import argparse
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

def get_files(path):
    if not os.path.isdir(path):
        return [path]

    files = []

    for root, dirs, filenames in os.walk(path):
        dirs[:] = [d for d in dirs if d not in EXCLUDE_DIRS]

        for filename in filenames:
            files.append(os.path.join(root, filename))

    return files


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="action", required=True)

    give = subparsers.add_parser("give")
    give.add_argument("here")
    give.add_argument("there")

    take = subparsers.add_parser("take")
    take.add_argument("there")
    take.add_argument("here")

    args = parser.parse_args()
    gateway = get_gateway()

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
        # Download everything except .venv using remote find.
        remote_path = args.there.replace("'", "'\\''")
        command = [
            "ssh", "-p", PORT,
            f"{USER}@{gateway}",
            f"cd '{remote_path}' && find . -path './.venv' -prune -o -type f -print",
        ]

        output = subprocess.check_output(command, text=True)

        for file in output.splitlines():
            remote_file = f"{args.there.rstrip('/')}/{file.removeprefix('./')}"
            local_file = os.path.join(args.here, file.removeprefix("./"))

            os.makedirs(os.path.dirname(local_file) or ".", exist_ok=True)

            subprocess.run([
                "scp",
                "-P", PORT,
                f"{USER}@{gateway}:{remote_file}",
                local_file,
            ], check=True)


if __name__ == "__main__":
    main()
