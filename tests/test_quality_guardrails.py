from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def run_script(script: str, *args: str, env: dict[str, str] | None = None) -> subprocess.CompletedProcess[str]:
    command_env = os.environ.copy()
    if env:
        command_env.update(env)
    return subprocess.run(
        [sys.executable, str(ROOT / script), *args],
        cwd=ROOT,
        env=command_env,
        text=True,
        capture_output=True,
        check=False,
    )


def write_file(path: Path, content: str) -> Path:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    return path


def test_python_compat_accepts_python311_syntax(tmp_path: Path) -> None:
    source = write_file(
        tmp_path / "ok.py",
        "from enum import StrEnum\n\nclass Status(StrEnum):\n    READY = 'ready'\n",
    )

    result = run_script("scripts/check_python_compat.py", str(source))

    assert result.returncode == 0, result.stderr


def test_python_compat_rejects_python312_type_parameter_syntax(tmp_path: Path) -> None:
    source = write_file(tmp_path / "py312.py", "class Box[T]:\n    pass\n")

    result = run_script("scripts/check_python_compat.py", str(source))

    assert result.returncode == 1
    assert "not compatible with Python 3.11 syntax" in result.stderr


def test_python_compat_rejects_python312_typing_override(tmp_path: Path) -> None:
    source = write_file(tmp_path / "py312_api.py", "from typing import override\n")

    result = run_script("scripts/check_python_compat.py", str(source))

    assert result.returncode == 1
    assert "typing.override requires Python 3.12+" in result.stderr


def test_change_scope_allows_single_module_with_tests_and_docs(tmp_path: Path) -> None:
    file_list = write_file(
        tmp_path / "files.txt",
        "\n".join(
            [
                "core/pam/pam_parser.py",
                "tests/test_pam_parser.py",
                "docs/pam-parser-notes.md",
            ]
        ),
    )

    result = run_script("scripts/check_change_scope.py", "--file-list", str(file_list))

    assert result.returncode == 0, result.stderr


def test_change_scope_allows_hook_tooling_paths(tmp_path: Path) -> None:
    file_list = write_file(
        tmp_path / "files.txt",
        "\n".join(
            [
                ".githooks/pre-commit",
                "scripts/agent-verify.sh",
                "README.md",
            ]
        ),
    )

    result = run_script("scripts/check_change_scope.py", "--file-list", str(file_list))

    assert result.returncode == 0, result.stderr


def test_change_scope_rejects_unrelated_core_modules(tmp_path: Path) -> None:
    file_list = write_file(
        tmp_path / "files.txt",
        "\n".join(
            [
                "core/pam/pam_parser.py",
                "core/warehouse/dml_parser.py",
            ]
        ),
    )

    result = run_script("scripts/check_change_scope.py", "--file-list", str(file_list))

    assert result.returncode == 1
    assert "touches multiple guarded modules" in result.stderr


def test_change_scope_accepts_explicit_scope_override(tmp_path: Path) -> None:
    file_list = write_file(
        tmp_path / "files.txt",
        "\n".join(
            [
                "core/pam/pam_parser.py",
                "core/warehouse/dml_parser.py",
            ]
        ),
    )

    result = run_script(
        "scripts/check_change_scope.py",
        "--file-list",
        str(file_list),
        env={"CHANGE_SCOPE": "core/pam,core/warehouse"},
    )

    assert result.returncode == 0, result.stderr


def test_change_scope_rejects_operational_artifacts(tmp_path: Path) -> None:
    file_list = write_file(
        tmp_path / "files.txt",
        "\n".join(
            [
                "SOURCE_DATA/PAM/sample.sql",
                "output/cache.json",
                "server.log",
            ]
        ),
    )

    result = run_script("scripts/check_change_scope.py", "--file-list", str(file_list))

    assert result.returncode == 1
    assert "operational artifact" in result.stderr
