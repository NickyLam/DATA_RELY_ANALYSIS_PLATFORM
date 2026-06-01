# Repository Guidelines

## Project Structure & Module Organization
`app/` contains the FastAPI application: `api/` for routes, `services/` for orchestration, `models/` for Pydantic schemas, and `utils/` for shared helpers. `core/` holds the parsing and lineage engines and should stay framework-agnostic. `static/` contains the D3.js frontend (`css/`, `js/`). `tests/` contains pytest suites for API, tracer, storage, and frontend flows. Runtime data lives in `SOURCE_DATA/` and generated artifacts in `output/`; both are operational directories, not places for new source code.

## Build, Test, and Development Commands
Install dependencies with `pip install -r requirements.txt`.
Run the app locally with `python run_app.py` for a foreground dev server, or `./start.sh` for the scripted startup flow on port `8899`.
Stop the scripted server with `./stop.sh`.
Run the full test suite with `python -m pytest tests/`.
Run a focused test file with `python -m pytest tests/test_lineage_api.py -v`.
If you need packaging behavior, inspect `package.sh` and `build_exe.py` before changing release flow.

## Coding Style & Naming Conventions
Follow existing style: Python uses 4-space indentation, type hints, `from __future__ import annotations`, and short docstrings on public modules/functions. Keep route handlers thin in `app/api/*`; put business logic in `app/services/` or `core/`. Use `snake_case` for Python files, functions, and variables; use `PascalCase` for Pydantic/dataclass models. Frontend JavaScript in `static/js/` follows plain ES6 with `camelCase` function names and uppercase constants.

## Testing Guidelines
Pytest is the project standard. New tests belong in `tests/` and should be named `test_*.py`; `pytest.ini` only discovers that pattern. Prefer narrow unit tests for `core/` changes and API tests for `app/api/` changes. When touching user-facing graph behavior, add or update `tests/frontend_e2e_test.py` coverage where practical.

## Commit & Pull Request Guidelines
Recent history uses Conventional Commit prefixes with concise Chinese summaries, for example `feat: ...` and `refactor: ...`. Keep commits scoped to one change. Pull requests should include: purpose, affected modules, test evidence (`python -m pytest ...`), and screenshots or GIFs when `static/` behavior changes. Link the relevant spec, issue, or task when one exists.

## Security & Configuration Tips
Do not commit real source datasets, logs, or generated cache files. Prefer configuring paths and storage through `start.sh` flags or environment variables such as `SOURCE_DATA_DIR`, `STORAGE_BACKEND`, and `SQLITE_DB_PATH`.
