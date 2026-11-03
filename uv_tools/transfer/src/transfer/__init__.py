import argparse
import shlex
import subprocess
import os


PORT = "8022"
USER = "hell"


def get_gateway():
    return subprocess.check_output(
        [
            "powershell",
            "-Command",
            "(Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway}).IPv4DefaultGateway.NextHop",
        ],
        text=True,
    ).strip()

EXCLUDE_DIRS = {
    ".venv",
    "__pycache__",
    ".ruff_cache",
}

EXCLUDE_SUFFIXES = (
    ".pyc",
)


def quote_remote(path):
    """Quote a path for the remote shell, expanding a leading ~ via $HOME."""
    if path == "~":
        return '"$HOME"'
    if path.startswith("~/"):
        return '"$HOME"' + shlex.quote(path[1:])
    return shlex.quote(path)

def remote_find():
    """Mirror the local filters as a find expression, so both sides stay in sync."""
    names = " -o ".join(f"-name {shlex.quote(d)}" for d in sorted(EXCLUDE_DIRS))
    suffixes = " -o ".join(f"-name {shlex.quote('*' + s)}" for s in EXCLUDE_SUFFIXES)

    expression = f"\\( {names} \\) -prune "
    if suffixes:
        expression += f"-o \\( {suffixes} \\) -prune "
    return expression + "-o -type f -print"


def get_files(path):
    """Collect paths recursively, excluding configured directories."""
    if not os.path.isdir(path):
        return [path]

    files = []

    for root, dirs, filenames in os.walk(path):
        dirs[:] = [d for d in dirs if d not in EXCLUDE_DIRS]

        for filename in filenames:
            if filename.endswith(EXCLUDE_SUFFIXES):
                continue
            files.append(os.path.join(root, filename))

    return files


def resolve_zoxide(path, gateway):
    """Resolve a remote path with zoxide, then confirm the match with the user.

    The last "/" separates the zoxide query from the trailing file name.
    No "/" means the whole argument is a directory query.
    Absolute and ~ paths are passed through untouched.
    """
    if path.startswith(("/", "~")):
        return path

    query, _, name = path.rpartition("/")
    if not query:
        query, name = name, ""

    script = (
        'Z=$(command -v zoxide || echo "$PREFIX/bin/zoxide"); '
        f'dir=$("$Z" query -- {shlex.quote(query)}) || exit 4; '
        '[ -d "$dir" ] || exit 5; '
    )
    if name:
        script += f"printf '%s/%s\\n' \"$dir\" {shlex.quote(name)}"
    else:
        script += "printf '%s\\n' \"$dir\""

    result = subprocess.run(
        ["ssh", "-p", PORT, f"{USER}@{gateway}", script],
        text=True,
        capture_output=True,
    )

    if result.returncode == 4:
        raise SystemExit(f"uscp: zoxide has no match for {query!r}")
    if result.returncode == 5:
        raise SystemExit(f"uscp: zoxide match is not a directory: {query!r}")
    if result.returncode != 0:
        raise SystemExit(f"uscp: {result.stderr.strip() or 'ssh failed'}")

    resolved = result.stdout.strip().splitlines()[-1]

    print(f"uscp: {path} -> {resolved}")
    if input("uscp: proceed? [Y/n] ").strip().lower() in {"n", "no"}:
        raise SystemExit(0)

    return resolved


def main():
    parser = argparse.ArgumentParser(prog="uscp")
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument(
        "-w",
        action="store_true",
        help="Hard-set the remote IP to 192.168.29.134",
    )
    common.add_argument(
        "-z",
        "--zoxide",
        action="store_true",
        help="Resolve the remote path with zoxide (last / starts the file name)",
    )
    common.add_argument(
        "-g",
        "--git",
        action="store_true",
        help="Include .git instead of pruning it",
    )
    subparsers = parser.add_subparsers(dest="action", required=True)

    give = subparsers.add_parser(
        "give",
        parents=[common],
        description="Copy files from the local machine to the remote machine, excluding configured directories.",
        help="Upload files to the remote machine",
    )
    give.add_argument("here", help="Local source path")
    give.add_argument("there", help="Remote destination path")
    give.add_argument("ip", nargs="?", help="Optional remote IP (defaults to gateway)")

    take = subparsers.add_parser(
        "take",
        parents=[common],
        description="Copy files from the remote machine to the local machine, excluding configured directories.",
        help="Download files from the remote machine",
    )
    take.add_argument("there", help="Remote source path")
    take.add_argument("here", help="Local destination path")
    take.add_argument("ip", nargs="?", help="Optional remote IP (defaults to gateway)")

    args = parser.parse_args()
    gateway = "192.168.29.134" if args.w else (args.ip or get_gateway())

    if args.zoxide:
        args.there = resolve_zoxide(args.there, gateway)

    if not args.git:
        EXCLUDE_DIRS.add(".git")

    if args.action == "give":
        for path in get_files(args.here):
            relative = os.path.relpath(path, args.here)
            destination = os.path.join(args.there, relative).replace("\\", "/")

            subprocess.run([
                "scp",
                "-P", PORT,
                path,
                f"{USER}@{gateway}:{destination}",
            ], check=True)

    else:
        # List files remotely: recurse for a directory, or echo the file as-is.
        raw_path = args.there.rstrip("/") or "/"
        remote_path = quote_remote(raw_path)
        command = [
            "ssh", "-p", PORT,
            f"{USER}@{gateway}",
            f"if [ -d {remote_path} ]; then cd {remote_path} && find . {remote_find()}; "
            f"elif [ -e {remote_path} ]; then printf '%s\\n' {remote_path}; "
            "else exit 6; fi",
        ]

        result = subprocess.run(command, text=True, capture_output=True)

        if result.returncode == 6:
            raise SystemExit(f"uscp: no such file or directory: {args.there}")
        if result.returncode != 0:
            raise SystemExit(f"uscp: {result.stderr.strip() or 'ssh failed'}")

        output = result.stdout

        for record in output.splitlines():
            if record.startswith("./"):
                relative = record.removeprefix("./")
                remote_file = f"{raw_path}/{relative}"
                local_file = os.path.join(args.here, relative)
            else:
                remote_file = record
                local_file = os.path.join(args.here, os.path.basename(record))
                if not (os.path.isdir(args.here) or args.here.endswith(("/", "\\"))):
                    local_file = args.here

            os.makedirs(os.path.dirname(local_file) or ".", exist_ok=True)

            subprocess.run([
                "scp",
                "-P", PORT,
                f"{USER}@{gateway}:{remote_file}",
                local_file,
            ], check=True)


if __name__ == "__main__":
    main()
