#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

MODE="${1:-quick}"
PYTHON_BIN="${PYTHON_BIN:-python3.11}"

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "error: $PYTHON_BIN is required. Set PYTHON_BIN to a Python 3.11+ interpreter." >&2
  exit 1
fi

"$PYTHON_BIN" - <<'PY'
import sys

if sys.version_info < (3, 11):
    raise SystemExit("error: Python 3.11+ is required by pyproject.toml")
PY

run_quick() {
  "$PYTHON_BIN" scripts/check_python_compat.py --staged
  "$PYTHON_BIN" scripts/check_change_scope.py --staged

  py_files=()
  while IFS= read -r -d '' file_name; do
    if [ -f "$file_name" ]; then
      py_files+=("$file_name")
    fi
  done < <(git diff --cached --name-only -z --diff-filter=ACMR -- '*.py')

  if [ "${#py_files[@]}" -gt 0 ]; then
    "$PYTHON_BIN" -m ruff check --target-version py311 "${py_files[@]}"
  fi
}

run_full() {
  git diff --check
  "$PYTHON_BIN" -m pytest tests/ -q
}

case "$MODE" in
  quick)
    run_quick
    ;;
  full)
    run_full
    ;;
  all)
    run_quick
    run_full
    ;;
  *)
    echo "usage: scripts/agent-verify.sh [quick|full|all]" >&2
    exit 2
    ;;
esac
