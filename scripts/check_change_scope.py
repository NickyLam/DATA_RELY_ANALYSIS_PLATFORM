#!/usr/bin/env python3

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path

SUPPORT_PREFIXES = (
    ".githooks/",
    ".github/",
    "docs/",
    "scripts/",
    "tests/",
)

GUARDED_PREFIXES = (
    "app/api",
    "app/models",
    "app/services",
    "app/utils",
    "core/adapters",
    "core/lineage",
    "core/pam",
    "core/utils",
    "core/warehouse",
    "static/css",
    "static/js",
)

OPERATIONAL_PREFIXES = (
    "SOURCE_DATA/",
    "output/",
    "temp_uploads/",
    "test_output/",
)

OPERATIONAL_SUFFIXES = (
    ".7z",
    ".db",
    ".log",
    ".sqlite",
    ".sqlite3",
    ".zip",
)


def normalize(path: str) -> str:
    normalized = path.strip().replace("\\", "/")
    while normalized.startswith("./"):
        normalized = normalized[2:]
    return normalized


def staged_files() -> list[str]:
    result = subprocess.run(
        ["git", "diff", "--cached", "--name-only", "--diff-filter=ACMR"],
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or "failed to read staged files")
    return [normalize(line) for line in result.stdout.splitlines() if line.strip()]


def files_from_base(base_ref: str) -> list[str]:
    result = subprocess.run(
        ["git", "diff", "--name-only", "--diff-filter=ACMR", f"{base_ref}...HEAD"],
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or f"failed to diff against {base_ref}")
    return [normalize(line) for line in result.stdout.splitlines() if line.strip()]


def files_from_list(path: Path) -> list[str]:
    return [normalize(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def operational_artifact(path: str) -> bool:
    name = Path(path).name
    return (
        path.startswith(OPERATIONAL_PREFIXES)
        or path.endswith(OPERATIONAL_SUFFIXES)
        or name == ".DS_Store"
    )


def module_for(path: str) -> str | None:
    for prefix in GUARDED_PREFIXES:
        if path == prefix or path.startswith(f"{prefix}/"):
            return prefix
    if path.startswith("app/"):
        parts = path.split("/")
        return "/".join(parts[:2]) if len(parts) > 1 else "app"
    if path.startswith("core/"):
        parts = path.split("/")
        return "/".join(parts[:2]) if len(parts) > 2 else "core"
    if path.startswith("static/"):
        parts = path.split("/")
        return "/".join(parts[:2]) if len(parts) > 1 else "static"
    return None


def parse_allowed_scope() -> set[str]:
    raw = os.environ.get("CHANGE_SCOPE", "")
    return {normalize(part) for part in raw.split(",") if part.strip()}


def allow_cross_scope() -> bool:
    return os.environ.get("CHANGE_SCOPE_ALLOW_CROSS", "").lower() in {"1", "true", "yes"}


def validate(files: list[str]) -> list[str]:
    errors: list[str] = []
    normalized = [normalize(path) for path in files if normalize(path)]

    blocked = [path for path in normalized if operational_artifact(path)]
    if blocked:
        errors.append("operational artifact changes are blocked: " + ", ".join(blocked))

    modules = sorted({module for path in normalized if (module := module_for(path))})
    if len(modules) > 1 and not allow_cross_scope():
        allowed = parse_allowed_scope()
        if not allowed or not set(modules).issubset(allowed):
            errors.append(
                "change touches multiple guarded modules: "
                + ", ".join(modules)
                + ". Set CHANGE_SCOPE="
                + ",".join(modules)
                + " when the task intentionally spans them."
            )

    unsupported = [
        path
        for path in normalized
        if not operational_artifact(path)
        and module_for(path) is None
        and not path.startswith(SUPPORT_PREFIXES)
        and "/" in path
        and not path.startswith(".")
    ]
    if unsupported:
        errors.append("unmapped changed paths need scope review: " + ", ".join(unsupported))

    return errors


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Check that a change stays inside one guarded project module.")
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--staged", action="store_true", help="Check staged files.")
    group.add_argument("--base", help="Check committed files changed since this base ref.")
    group.add_argument("--file-list", type=Path, help="Read newline-delimited file paths from this file.")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv or sys.argv[1:])

    try:
        if args.file_list:
            files = files_from_list(args.file_list)
        elif args.base:
            files = files_from_base(args.base)
        else:
            files = staged_files()
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    errors = validate(files)
    if errors:
        print("Change scope check failed:", file=sys.stderr)
        for error in errors:
            print(f"  - {error}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
