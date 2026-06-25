from __future__ import annotations

import tomllib
from importlib import metadata
from pathlib import Path

PACKAGE_NAME = "data-rely-analysis-sys"


def get_project_version() -> str:
    try:
        return metadata.version(PACKAGE_NAME)
    except metadata.PackageNotFoundError:
        pyproject_path = Path(__file__).resolve().parents[1] / "pyproject.toml"
        data = tomllib.loads(pyproject_path.read_text(encoding="utf-8"))
        return str(data["project"]["version"])
