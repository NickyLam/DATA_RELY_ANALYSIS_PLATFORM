# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Data lineage analysis system (数据血缘分析系统) — a FastAPI backend that parses Oracle .tab/.prc files, warehouse SQL files, and indicator xlsx files to build field-level lineage graphs, caliber tracing chains, and reliability indicators. Frontend is vanilla JS + D3.js v7 served as static files.

## Commands

```bash
# Install dependencies
pip install -r requirements.txt

# Run dev server (port 8899, auto-reload)
python run_app.py

# Start/stop via shell scripts
./start.sh   # sources .env, then runs python run_app.py
./stop.sh    # kills the uvicorn process

# Run full test suite
python -m pytest tests/

# Run a single test file
python -m pytest tests/test_lineage_api.py -v

# Run specific test by name
python -m pytest tests/test_sqlite_store.py::test_save_and_load -v

# Lint (ruff)
ruff check app/ core/ tests/

# Type check (mypy)
mypy app/ core/

# Coverage is configured in pyproject.toml (--cov-fail-under=35)
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
- `api/` — Route handlers (keep thin; business logic goes in services)
- `services/` — Orchestration: `ParserService`, `LineageService`, `IndicatorService`, `TracerFactory`
- `services/storage/` — `CacheStore` facade delegates to `SQLiteResultStore` (default) or `LegacyJsonPickleStore` via `ResultStoreProtocol`
- `models/` — Pydantic request/response schemas
- `dependencies.py` — `@lru_cache` singleton providers for FastAPI `Depends()` injection
- `config.py` — `AppConfig` dataclass, reads env vars and `SOURCE_DATA/manifest.yml`
- `repository.py` — `DataRepository`: in-memory search index (倒排索引) for tables/procedures

**`core/` — Domain logic (no framework dependencies)**
- `models.py` — Core dataclasses: `TableInfo`, `ColumnInfo`, `CaliberInfo`, `CaliberChain`, `FieldMapping`, `ProcedureInfo`, `PipelineView`, `StepDetail`, etc.
- `parser_protocol.py` — `FileParser` (typing.Protocol) + `ParseOutput` — the contract all parsers implement
- `parser_registry.py` — `ParserRegistry` maps file extensions → parser instances; new file types just `register()`
- `adapters/` — Oracle parsers: `oracle_tab_adapter.py` (.tab), `oracle_prc_adapter.py` (.prc), `indicator_adapter.py` (.xlsx)
- `warehouse/` — Warehouse SQL parser with two-phase DDL→DML logic: `warehouse_parser.py`, `ddl_parser.py`, `dml_parser.py`, `schema_resolver.py`
- `pam/` — Pipeline Analysis Module: `pam_parser.py`, `pam_ddl_parser.py`, `pam_dml_parser.py`
- `caliber_*.py` — Caliber extraction/tracing modules (condition, expression, metadata, tracer, exporter)
- `lineage/` — `chain_builder.py`, `graph_converter.py`
- `layer_detector.py` — Detects data layer (ODS/DWD/DWS/ADS/EAST) from table naming patterns
- `table_name_resolver.py` — Resolves short table names to full qualified names

### Storage Backends

`CacheStore` in `app/services/cache_store.py` is a facade that delegates to:
- **SQLite** (default): `SQLiteResultStore` at `output/lineage.db`, schema version tracked via `CACHE_SCHEMA_VERSION = "v4"` in `protocol.py`
- **Legacy**: `LegacyJsonPickleStore` using pickle + JSON files

Config: `storage_backend`, `sqlite_db_path`, `enable_legacy_cache_write`, `enable_json_export` (env vars or `AppConfig`)

### Data Source Configuration

Data sources are auto-discovered from `SOURCE_DATA/manifest.yml` (YAML list of sources with name, path, file_extensions, parser type). Falls back to hardcoded defaults in `AppConfig.datasource_configs`. Env vars `TDH_DATA_DIR` / `GBASE_DATA_DIR` add extra sources at runtime.

## Coding Conventions

- Python 3.11+, `from __future__ import annotations` in all files
- Type hints required; `snake_case` for functions/variables, `PascalCase` for models
- Route handlers in `app/api/` must be thin — delegate to services
- `core/` must not import from `app/`
- New parsers: implement `FileParser` protocol (duck typing, no inheritance required), then `registry.register(instance)`
- Ruff: line-length 120, select E/F/W/I/N/UP/B/SIM; `core/` has relaxed rules (SIM, N, B007, UP045 ignored)
- Mypy: `ignore_missing_imports = true`, `core/` allows untyped defs
- Conventional Commits with Chinese summaries: `feat: ...`, `fix: ...`, `refactor: ...`
- Chinese comments are standard throughout the codebase

## Testing

- pytest with `testpaths = tests`, pattern `test_*.py`
- `conftest.py` provides basic fixtures (sample table/field names, test data dirs, sample .tab/.prc content)
- API tests use `httpx.AsyncClient` with mocked services (~60s for full API suite)
- Unit tests for `core/` changes; API-level tests for `app/api/` changes
- Coverage configured in pyproject.toml: `--cov=app --cov=core --cov-fail-under=35`
- Key test files: `test_sqlite_store.py`, `test_repository_search.py`, `test_lineage_api.py`, `test_caliber_api.py`, `test_parse_api.py`, `test_indicator_api.py`

## Environment Variables

Key env vars (all optional, with defaults in `AppConfig`):
- `DEBUG` — enable debug mode
- `PORT` — server port (default 8899)
- `DATA_DIR` / `SOURCE_DATA_DIR` — data directories
- `STORAGE_BACKEND` — `sqlite` or `legacy`
- `SQLITE_DB_PATH` — SQLite database path
- `TDH_DATA_DIR` / `GBASE_DATA_DIR` — add extra warehouse data sources
