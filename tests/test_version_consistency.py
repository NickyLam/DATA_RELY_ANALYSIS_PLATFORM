from __future__ import annotations

import tomllib
from pathlib import Path

import app
from app.config import config


def test_runtime_version_matches_pyproject() -> None:
    pyproject = tomllib.loads(Path("pyproject.toml").read_text(encoding="utf-8"))
    expected_version = pyproject["project"]["version"]

    assert app.__version__ == expected_version
    assert config.app_version == expected_version
