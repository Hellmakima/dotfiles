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


def main():
    parser = argparse.ArgumentParser(prog="uscp")
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument(
        "-w",
        action="store_true",
        help="Hard-set the remote IP to 192.168.29.134",
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
            f"if [ -d '{remote_path}' ]; then cd '{remote_path}' && "
            "find . \\( -name .venv -o -name __pycache__ -o -name .ruff_cache \\) -prune "
            "-o -name '*.pyc' -prune -o -type f -print; "
            f"else printf '%s\\n' '{remote_path}'; fi",
        ]

        output = subprocess.check_output(command, text=True)

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
