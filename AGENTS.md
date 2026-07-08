# AGENTS.md

This file provides guidance to Qoder (qoder.com) when working with code in this repository.

## Project Overview

Field-level data lineage analysis system for Oracle and warehouse SQL scripts. FastAPI backend parses `.tab`/`.prc`/`.sql`/`.ctl`/`.xlsx` files to build lineage graphs, caliber tracing chains, and indicator analysis. Frontend is vanilla JS + D3.js v7 served as static files.

## Commands

```bash
# Install dependencies
pip install -r requirements.txt

# Run dev server (port 8899, foreground)
python run_app.py
python run_app.py --reparse        # force re-parse all data sources, skip cache

# Scripted start/stop (background, auto-installs deps, checks port)
./start.sh                          # default port 8899
./start.sh --port 9000 --reparse
./stop.sh

# Run full test suite
python3.11 -m pytest tests/

# Run a single test file
python3.11 -m pytest tests/test_lineage_api.py -v

# Run a specific test by name
python3.11 -m pytest tests/test_sqlite_store.py::test_save_and_load -v

# Lint (ruff)
ruff check app/ core/ tests/

# Type check (mypy)
mypy app/ core/

# Git hook verification (delegates to scripts/agent-verify.sh)
scripts/agent-verify.sh quick       # pre-commit: Python 3.11 compat check + scope check + ruff on staged files
scripts/agent-verify.sh full        # pre-push: git diff --check + full pytest
scripts/agent-verify.sh all         # both

# Install local Git hooks
bash scripts/install-git-hooks.sh
```

## Architecture

Three-layer design: **API → Service → Core**. `core/` must stay framework-agnostic (no FastAPI imports).

### Data Flow

```
SOURCE_DATA/ (.tab, .prc, .sql, .ctl, .xlsx)
  → ParserRegistry routes by file extension → FileParser implementations
  → ParseOutput (unified dict lists) → ParserService.ParseResult
  → CacheStore (SQLite or legacy pickle/json) persists results
  → DataRepository (in-memory index) serves queries
  → LineageService / CaliberTracer / IndicatorEngine
  → API responses (Pydantic models)
```

### Key Layers

**`app/` — FastAPI application layer**
- `api/` — Route handlers (keep thin; business logic goes in services). Routers: `lineage.py`, `parse.py`, `indicator.py`, `system.py`.
- `services/` — Orchestration: `ParserService`, `LineageService`, `IndicatorService`, `TableQueryService`, `TracerFactory`, `ProgressService`. `lineage_service.py` is the largest (~1800 lines) and holds graph construction, node filtering, and export logic.
- `services/storage/` — `CacheStore` facade delegates to `SQLiteResultStore` (default) or `LegacyJsonPickleStore` via `ResultStoreProtocol`.
- `models/` — Pydantic request/response schemas.
- `dependencies.py` — `@lru_cache` singleton providers for FastAPI `Depends()` injection. Clears its own cache on init failure so retries work.
- `config.py` — `AppConfig` dataclass, reads env vars and `SOURCE_DATA/manifest.yml`.
- `repository.py` — `DataRepository`: in-memory search index with thread-safe locking and schema migration support.

**`core/` — Domain logic (no framework dependencies)**
- `models.py` — Core dataclasses: `TableInfo`, `ColumnInfo`, `CaliberInfo`, `CaliberChain`, `FieldMapping`, `ProcedureInfo`, `PipelineView`, `StepDetail`.
- `parser_protocol.py` — `FileParser` (typing.Protocol) + `ParseOutput`. All parsers implement this via duck typing (no inheritance required).
- `parser_registry.py` — `ParserRegistry` maps file extensions → parser instances; new file types just `register()`.
- `adapters/` — Oracle parsers: `oracle_tab_adapter.py` (.tab), `oracle_prc_adapter.py` (.prc), `indicator_adapter.py` (.xlsx).
- `warehouse/` — Warehouse SQL parser with two-phase DDL→DML logic: `warehouse_parser.py`, `ddl_parser.py`, `dml_parser.py`, `schema_resolver.py`. `temp_table_filter.py` distinguishes `_ex` exchange tables from TMP temp tables.
- `pam/` — Pipeline Analysis Module: `pam_parser.py`, `pam_ddl_parser.py`, `pam_dml_parser.py`.
- `caliber_*.py` — Caliber extraction/tracing modules (condition, expression, metadata, tracer, exporter).
- `lineage/` — `chain_builder.py`, `graph_converter.py`.
- `layer_detector.py` — Detects data layer from table naming patterns; supports 17 layer types (SRC/MSL/ITL/IOL/ICL/IML/IDL/IEL/DQC + ODS/DWD/DWS/ADS/EAST/base/east/other). Uses `LayerRule`/`SchemaRule`/`BareNameRule` priority cascade, configurable via per-source `manifest.yml`.
- `table_name_resolver.py` — Resolves short table names to fully qualified names.

### Startup Sequence

The `lifespan` context manager in `app/main.py` runs at startup:
1. `ParserService.parse_existing_data()` — loads from SQLite cache or does a full parse.
2. `LineageService` and `IndicatorService` init — builds BFS indexes, adjacency maps.
3. HTTP server ready.

### Storage Backends

`CacheStore` in `app/services/cache_store.py` is a facade that delegates to:
- **SQLite** (default): `SQLiteResultStore` at `output/lineage.db`, schema version tracked via `CACHE_SCHEMA_VERSION` in `protocol.py`.
- **Legacy**: `LegacyJsonPickleStore` using pickle + JSON files.

Config: `STORAGE_BACKEND` (sqlite | legacy), `SQLITE_DB_PATH`, `ENABLE_LEGACY_CACHE_WRITE`, `ENABLE_JSON_EXPORT`.

### Data Source Configuration

Data sources are auto-discovered from `SOURCE_DATA/manifest.yml` (YAML list of sources with name, path, file_extensions, parser type). Falls back to hardcoded defaults in `AppConfig.datasource_configs`. Env vars `TDH_DATA_DIR` / `GBASE_DATA_DIR` add extra sources at runtime.

## Coding Conventions

- Python 3.11+ baseline. `from __future__ import annotations` in all files.
- **Critical**: `isinstance()` second arg must use a **tuple** `(A, B, C)`, NOT PEP 604 union `A | B | C`. Python 3.11 raises `TypeError` with union syntax in `isinstance()`.
- Type hints required; `snake_case` for functions/variables, `PascalCase` for models.
- Route handlers in `app/api/` must be thin — delegate to services.
- `core/` must not import from `app/`.
- New parsers: implement `FileParser` protocol (duck typing, no inheritance required), then `registry.register(instance)`.
- Ruff: line-length 120, select E/F/W/I/N/UP/B/SIM; `core/` has relaxed rules (SIM, N, B007, UP045 ignored). `app/api/` ignores B008 (function calls in defaults — FastAPI `Depends()`).
- Mypy: `ignore_missing_imports = true`, `core/` allows untyped defs, `app/` requires `check_untyped_defs`.
- Conventional Commits with Chinese summaries: `feat: ...`, `fix: ...`, `refactor: ...`.
- Chinese comments are standard throughout the codebase.

## Testing

- pytest with `testpaths = tests`, pattern `test_*.py`.
- `conftest.py` provides basic fixtures (sample table/field names, test data dirs, sample `.tab`/`.prc` content). `tests/fixtures/mock_data.py` has richer mock objects.
- API tests use `httpx.AsyncClient` with mocked services.
- Prefer narrow unit tests for `core/` changes and API-level tests for `app/api/` changes.
- When touching user-facing graph behavior, update `tests/frontend_e2e_test.py`.
- Coverage configured in `pyproject.toml`: source = `app`, `core`; omit `tests/*`, `app/main.py`.

## Change Guardrails

**Python compatibility**: Generated code must stay compatible with Python >=3.11 (Ruff `target-version = "py311"`). Do not introduce 3.12+ syntax or stdlib APIs.

**Single-module commit scope**: Each commit should touch only one guarded business module. Guarded prefixes: `app/api`, `app/models`, `app/services`, `app/utils`, `core/adapters`, `core/lineage`, `core/pam`, `core/utils`, `core/warehouse`, `static/css`, `static/js`. Support files (`tests/`, `docs/`, `scripts/`, `.githooks/`, `.github/`) may accompany any module change. Cross-module commits require:
```bash
CHANGE_SCOPE=core/pam,core/warehouse git commit -m "fix: ..."
```

**Blocked artifacts**: `SOURCE_DATA/`, `output/`, `temp_uploads/`, `test_output/`, `.7z`, `.db`, `.log`, `.zip`, `.sqlite` files are blocked from commits by the pre-commit hook.

## Environment Variables

All optional, with defaults in `AppConfig`:
- `DEBUG` — enable debug mode
- `PORT` — server port (default 8899)
- `DATA_DIR` / `SOURCE_DATA_DIR` — data directories
- `STORAGE_BACKEND` — `sqlite` or `legacy`
- `SQLITE_DB_PATH` — SQLite database path
- `TDH_DATA_DIR` / `GBASE_DATA_DIR` — add extra warehouse data sources
- `FORCE_REPARSE` — skip cache and re-parse all data at startup
- `ADMIN_API_KEY` — required for admin endpoints (e.g., cache rebuild)
- `INDICATOR_FALLBACK_PATH` — fallback path for indicator XLSX files
