import argparse
import subprocess


PORT = "8022"
USER = "user"


def get_gateway():
    return subprocess.check_output(
        ["ip", "route", "show", "default"],
        text=True,
    ).split()[2]


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
        command = [
            "scp",
            "-P", PORT,
            "-r",
            args.here,
            f"{USER}@{gateway}:{args.there}",
        ]

    else:  # take
        command = [
            "scp",
            "-P", PORT,
            "-r",
            f"{USER}@{gateway}:{args.there}",
            args.here,
        ]

    print(" ".join(command))
    subprocess.run(command)


if __name__ == "__main__":
    main()

