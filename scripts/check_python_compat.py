#!/usr/bin/env python3

from __future__ import annotations

import argparse
import ast
import subprocess
import sys
from pathlib import Path

TARGET_VERSION = (3, 11)
UNSUPPORTED_IMPORTS = {
    ("typing", "override"): "typing.override requires Python 3.12+",
    ("typing", "TypeAliasType"): "typing.TypeAliasType requires Python 3.12+",
    ("typing", "ReadOnly"): "typing.ReadOnly requires Python 3.13+",
    ("itertools", "batched"): "itertools.batched requires Python 3.12+",
    ("pathlib", "walk"): "pathlib.Path.walk requires Python 3.12+",
}


class CompatVisitor(ast.NodeVisitor):
    def __init__(self, path: Path) -> None:
        self.path = path
        self.errors: list[str] = []

    def visit_ImportFrom(self, node: ast.ImportFrom) -> None:
        module = node.module or ""
        for alias in node.names:
            reason = UNSUPPORTED_IMPORTS.get((module, alias.name))
            if reason:
                self.errors.append(f"{self.path}:{node.lineno}: {reason}")
        self.generic_visit(node)

    def visit_Call(self, node: ast.Call) -> None:
        if (
            isinstance(node.func, ast.Attribute)
            and node.func.attr == "walk"
            and isinstance(node.func.value, ast.Name)
            and node.func.value.id == "Path"
        ):
            self.errors.append(f"{self.path}:{node.lineno}: pathlib.Path.walk requires Python 3.12+")
        self.generic_visit(node)


def staged_files() -> list[Path]:
    result = subprocess.run(
        ["git", "diff", "--cached", "--name-only", "--diff-filter=ACMR", "--", "*.py"],
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or "failed to read staged Python files")
    return [Path(line) for line in result.stdout.splitlines() if line.strip()]


def check_file(path: Path) -> list[str]:
    if path.suffix != ".py" or not path.exists():
        return []

    try:
        source = path.read_text(encoding="utf-8")
    except UnicodeDecodeError as exc:
        return [f"{path}: cannot decode as UTF-8: {exc}"]

    try:
        tree = ast.parse(source, filename=str(path), feature_version=TARGET_VERSION)
    except SyntaxError as exc:
        line = exc.lineno or 1
        message = exc.msg or "invalid syntax"
        return [f"{path}:{line}: not compatible with Python 3.11 syntax: {message}"]

    visitor = CompatVisitor(path)
    visitor.visit(tree)
    return visitor.errors


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Check changed Python files against the Python 3.11 baseline.")
    parser.add_argument("files", nargs="*", help="Python files to check.")
    parser.add_argument("--staged", action="store_true", help="Check staged Python files.")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv or sys.argv[1:])

    if sys.version_info < TARGET_VERSION:
        print("Python 3.11+ is required to run project checks.", file=sys.stderr)
        return 1

    try:
        files = staged_files() if args.staged else [Path(file_name) for file_name in args.files]
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    errors: list[str] = []
    for path in files:
        errors.extend(check_file(path))

    if errors:
        print("Python compatibility check failed:", file=sys.stderr)
        for error in errors:
            print(f"  - {error}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
