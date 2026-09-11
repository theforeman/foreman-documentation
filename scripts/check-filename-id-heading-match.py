#!/usr/bin/env python3
"""Check that AsciiDoc module IDs, headings, and filenames match."""

import re
import sys
from pathlib import Path
from typing import Iterable

RED = "\033[0;31m"
YELLOW = "\033[1;33m"
GREEN = "\033[0;32m"
NC = "\033[0m"

ID_SUBSTITUTIONS = (
    ("{project-context}", "project"),
    ("{smart-proxy-context}", "smart-proxy"),
    ("{smart-proxies-context}", "smart-proxies"),
    ("{smart-proxy-context-titlecase}", "smart-proxy"),
    ("{ProjectNameID}", "project"),
    ("{ProjectServerID}", "project-server"),
    ("{customreposid}", "repositories"),
    ("{customrepoid}", "repository"),
    ("{customproductid}", "product"),
    ("{FreeIPA-id}", "freeipa"),
    ("{insights-id}", "insights"),
    ("{insights-iop-id}", "insights"),
    ("{ISS-id}", "inter-server-synchronization"),
    ("{foreman-installer}", "foreman-installer"),
    ("{awx-context}", "awx"),
    ("{compute-resource-id}", "compute-resource"),
    ("{OpenStack-id}", "openstack"),
    ("{KubeVirt-id}", "kubevirt"),
    ("{a-KubeVirt-id}", "a-kubevirt"),
    ("{client-os-context}", "client-os"),
)

HEADING_SUBSTITUTIONS = (
    ("{projectname}", "project"),
    ("{project}", "project"),
    ("{projectserver}", "project-server"),
    ("{smartproxy}", "smart-proxy"),
    ("{smartproxyserver}", "smart-proxy-server"),
    ("{smartproxyservers}", "smart-proxy-servers"),
    ("{freeipa}", "freeipa"),
    ("{insights}", "insights"),
    ("{insights-iop}", "insights"),
    ("{iss}", "inter-server-synchronization"),
    ("{nbsp}", ""),
    ("{customfiletype}", "custom-file-type"),
    ("{openstack}", "openstack"),
    ("{keycloak}", "keycloak"),
    ("{rhel}", "rhel"),
    ("{the-cockpit}", "cockpit"),
    ("{rhcloud}", "rhcloud"),
    ("{loraxcompose}", "lorax-compose"),
    ("{foreman-installer}", "foreman-installer"),
    ("{compute-resource}", "compute-resource"),
    ("{openstack}", "openstack"),
    ("{kubevirt}", "kubevirt"),
    ("{a-kubevirt}", "a-kubevirt"),
    ("{client-os}", "client-os"),
    ("by-using-hammer-cli", "by-using-cli"),
    ("by-using-project-api", "by-using-api"),
    ("{projectwebui}", "web-ui"),
)


def replace_all(value: str, substitutions: Iterable[tuple[str, str]]) -> str:
    for source, replacement in substitutions:
        value = value.replace(source, replacement)
    return value


def read_id_and_heading(path: Path) -> tuple[str | None, str | None]:
    id_line = heading_line = None
    try:
        with path.open(encoding="utf-8", errors="surrogateescape") as source:
            for line in source:
                line = line.rstrip("\n")
                if id_line is None and line.startswith('[id="'):
                    id_line = line
                if heading_line is None and line.startswith("= "):
                    heading_line = line
                if id_line is not None and heading_line is not None:
                    break
    except OSError:
        pass
    return id_line, heading_line


def check_file(path: Path) -> int:
    expected = re.sub(r"^(?:con|proc|ref)_", "", path.stem)
    id_line, heading_line = read_id_and_heading(path)
    if id_line is None:
        print(f"{YELLOW}Warning:{NC} {path}")
        print("  No ID found (modules should have an ID)")
        return 1

    match = re.fullmatch(r'\[id="([^"]*)"\]', id_line)
    id_value = match.group(1) if match else ""
    normalized_id = replace_all(id_value, ID_SUBSTITUTIONS)
    heading_value = normalized_heading = ""
    if heading_line is not None:
        heading_value = re.sub(r"^= *", "", heading_line).rstrip(" ")
        normalized_heading = heading_value.lower().replace("_", "-").replace(" ", "-")
        normalized_heading = replace_all(normalized_heading, HEADING_SUBSTITUTIONS)

    id_mismatch = normalized_id != expected
    heading_mismatch = bool(normalized_heading) and normalized_heading != normalized_id
    if not (id_mismatch or heading_mismatch):
        return 0

    print(f"{YELLOW}Warning:{NC} {path}")
    if id_mismatch:
        print(f"  ID '{id_value}' does not match expected '{expected}'")
        print("  (based on filename without prefix)")
    if heading_mismatch:
        print(f"  Heading '{heading_value}' does not match ID")
        print(
            f"  (normalized heading: '{normalized_heading}', normalized ID: "
            f"'{normalized_id}')"
        )
    print()
    return 1


def files_to_check(target: Path) -> list[Path]:
    if target.is_file():
        return [target] if target.name.startswith(("con_", "proc_", "ref_")) else []
    if target.is_dir():
        return sorted(
            path
            for path in target.rglob("*.adoc")
            if path.is_file() and path.name.startswith(("con_", "proc_", "ref_"))
        )
    print(f"{RED}Error:{NC} '{target}' is not a file or directory")
    sys.exit(1)


def main() -> int:
    target = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("guides/common/modules")
    files = files_to_check(target)
    warning_count = sum(check_file(path) for path in files)
    print("─────────────────────────────────────────")
    print(f"Checked {len(files)} module(s)")
    if warning_count == 0:
        print(f"{GREEN}✓ All IDs match their filenames{NC}")
        return 0
    print(f"{YELLOW}⚠ Found {warning_count} warning(s){NC}")
    return 1


if __name__ == "__main__":
    sys.exit(main())
