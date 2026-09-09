import subprocess
from pathlib import Path

import pytest


SCRIPT_DIR = Path(__file__).parents[1]
FIXTURES = Path(__file__).parent / "fixtures"
SCRIPTS = (
    SCRIPT_DIR / "check-filename-id-heading-match.py",
    SCRIPT_DIR / "check-filename-id-heading-match.sh",
)


def run_script(script: Path, target: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [str(script), str(target)],
        capture_output=True,
        text=True,
        check=False,
    )


@pytest.mark.parametrize("script", SCRIPTS)
def test_valid_module(script: Path) -> None:
    result = run_script(script, FIXTURES / "con_valid.adoc")

    assert result.returncode == 0
    assert "Checked 1 module(s)" in result.stdout
    assert "All IDs match their filenames" in result.stdout
    assert result.stderr == ""


@pytest.mark.parametrize("script", SCRIPTS)
def test_attribute_normalization(script: Path) -> None:
    result = run_script(script, FIXTURES / "proc_project-server.adoc")

    assert result.returncode == 0
    assert "All IDs match their filenames" in result.stdout


@pytest.mark.parametrize("script", SCRIPTS)
def test_heading_normalization(script: Path) -> None:
    result = run_script(script, FIXTURES / "ref_by-using-cli.adoc")

    assert result.returncode == 0
    assert "All IDs match their filenames" in result.stdout


@pytest.mark.parametrize(
    ("fixture", "messages"),
    (
        ("con_wrong-id.adoc", ("ID 'actual-id' does not match expected 'wrong-id'",)),
        ("ref_heading-match.adoc", ("Heading 'Wrong heading' does not match ID",)),
        ("con_no-id.adoc", ("No ID found (modules should have an ID)",)),
    ),
)
@pytest.mark.parametrize("script", SCRIPTS)
def test_invalid_module(script: Path, fixture: str, messages: tuple[str, ...]) -> None:
    result = run_script(script, FIXTURES / fixture)

    assert result.returncode == 1
    assert "Checked 1 module(s)" in result.stdout
    assert "Found 1 warning(s)" in result.stdout
    for message in messages:
        assert message in result.stdout


@pytest.mark.parametrize("script", SCRIPTS)
def test_directory_target_is_recursive_and_only_checks_adoc_files(script: Path) -> None:
    result = run_script(script, FIXTURES)

    assert result.returncode == 1
    assert "Checked 6 module(s)" in result.stdout
    assert "Found 3 warning(s)" in result.stdout


@pytest.mark.parametrize("script", SCRIPTS)
def test_missing_target_is_an_error(script: Path) -> None:
    result = run_script(script, FIXTURES / "does-not-exist")

    assert result.returncode == 1
    assert "is not a file or directory" in result.stdout
