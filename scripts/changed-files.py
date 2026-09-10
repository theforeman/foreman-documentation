#!/usr/bin/env python3
"""Print the changed AsciiDoc files linted by the Vale CI job."""

import argparse
import json
import os
import subprocess
import sys
from pathlib import PurePosixPath


INCLUDED_PATTERNS = (
    "guides/common/*.adoc",
    "guides/common/modules/*.adoc",
)
DITA_PATTERNS = (
    "guides/common/modules/*.adoc",
    "guides/doc-Satellite_Documentation_Maps/*.adoc",
    "guides/doc-Satellite_Documentation_Maps/maps/*.adoc",
)
EXCLUDED_FILES = {
    "guides/common/header.adoc",
    "guides/common/ribbons.adoc",
}


def matches_ci_filter(path: str, dita: bool) -> bool:
    """Apply the files/files_ignore filter from .github/workflows/vale.yml."""
    posix_path = PurePosixPath(path)
    patterns = DITA_PATTERNS if dita else INCLUDED_PATTERNS
    if dita:
        return any(posix_path.match(pattern) for pattern in patterns)
    return (
        any(posix_path.match(pattern) for pattern in patterns)
        and path not in EXCLUDED_FILES
        and not posix_path.match("guides/common/attributes*.adoc")
    )


def diff_range() -> tuple[str, ...]:
    event_path = os.environ.get("GITHUB_EVENT_PATH")
    if event_path:
        with open(event_path, encoding="utf-8") as event_file:
            event = json.load(event_file)
        pull_request = event.get("pull_request")
        if pull_request:
            return (
                pull_request["base"]["sha"],
                pull_request["head"]["sha"],
            )

    return ("HEAD",)


def changed_files(dita: bool) -> list[str]:
    result = subprocess.run(
        [
            "git",
            "diff",
            "--name-only",
            "--diff-filter=ACMRT",
            *diff_range(),
            "--",
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    return [
        path
        for path in result.stdout.splitlines()
        if matches_ci_filter(path, dita)
    ]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--dita",
        action="store_true",
        help="use the DITA Vale job's file filter",
    )
    args = parser.parse_args()
    try:
        print("\n".join(changed_files(args.dita)))
    except (OSError, subprocess.CalledProcessError) as error:
        print(f"Error while determining changed files: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
