# Open-source data lineage analyzer for Oracle and enterprise data warehouse SQL

> Field-level Data Lineage Analysis System

> Version: v2.2.0
> Last updated: 2026-07-08

Language: [中文](README.md) | English

## 30-second overview

![Demo lineage graph](docs/assets/demo-lineage-graph.png)

This project is an open-source field-level data lineage analyzer for Oracle scripts and enterprise data warehouse SQL. It parses DDL, DML, stored procedures, SQL files, control files, and indicator spreadsheets, then builds table-level lineage, field-level lineage, caliber tracing chains, and visual lineage diagrams for governance, impact analysis, audit review, and system migration work.

Reviewers can verify quickly that it can:

- Parse Oracle and warehouse SQL into table-level and field-level lineage.
- Trace upstream/downstream dependencies through layered warehouse schemas such as SRC, MSL, ITL, IOL, ICL, IML, IDL, IEL, and DQC.
- Visualize lineage with D3.js, layer colors, highlighted paths, search, and node details.
- Export lineage/caliber evidence for audits and data governance reviews.

Useful documents:

- [Demo walkthrough](docs/demo.md) / [中文演示](docs/demo.zh-CN.md)
- [v2.2.0 release notes](docs/releases/v2.2.0.md) / [中文发布说明](docs/releases/v2.2.0.zh-CN.md)
- [Changelog](CHANGELOG.md) / [中文变更日志](CHANGELOG.zh-CN.md)
- [Contributing guide](CONTRIBUTING.md) / [中文贡献指南](CONTRIBUTING.zh-CN.md)
- [Security policy](SECURITY.md) / [中文安全策略](SECURITY.zh-CN.md)
- [Roadmap](ROADMAP.md) / [中文路线图](ROADMAP.zh-CN.md)

## Core capabilities

- **SQL parsing**: Oracle DDL/DML/stored procedures and layered warehouse scripts.
- **Field-level lineage**: BFS-based table/field graph construction with upstream, downstream, and bidirectional tracing.
- **Warehouse layering**: Supports enterprise warehouse layers including SRC, MSL, ITL, IOL, ICL, IML, IDL, IEL, and DQC.
- **Exchange table handling**: Maps `_ex` exchange tables back to physical target tables to preserve Type5 ICL lineage.
- **Caliber tracing**: Extracts field transformation logic and exports evidence workbooks.
- **Indicator analysis**: Builds lineage views for indicator tables and metric definitions.
- **Visualization**: D3.js graph with layer coloring, path highlighting, search, and node details.
- **System-level export**: Exports full lineage workbooks for a configured data source/system.

## Tech stack

| Layer | Technology |
|---|---|
| Backend | FastAPI + Python 3.11+ |
| Models | Pydantic v2 + dataclasses |
| SQL parsing | sqlglot + project-specific Oracle/warehouse parsers |
| Visualization | D3.js v7 + vanilla JavaScript |
| Storage | SQLite result cache + in-memory indexes + optional legacy pickle/json compatibility |

## Quick start

### Requirements

- Python 3.11+
- pip or uv

### Install and run

```bash
python3.11 -m venv .venv
source .venv/bin/activate
python3.11 -m pip install -r requirements.txt

# Default port: 8899
python3.11 run_app.py

# Force a clean parse
python3.11 run_app.py --reparse
```

Open:

- Frontend: `http://localhost:8899/static/index.html`
- API docs: `http://localhost:8899/docs`

## Example SQL

Full example: [`docs/examples/oracle_warehouse_lineage.sql`](docs/examples/oracle_warehouse_lineage.sql)

```sql
CREATE TABLE ICL.CUSTOMER_DAILY_SNAPSHOT AS
SELECT
    c.CUST_ID,
    c.CUST_NAME,
    a.ACCT_BALANCE,
    CASE WHEN a.ACCT_BALANCE > 100000 THEN 'VIP' ELSE 'STANDARD' END AS CUSTOMER_TIER
FROM IML.CUSTOMER_PROFILE c
LEFT JOIN IOL.ACCOUNT_BALANCE a
    ON c.CUST_ID = a.CUST_ID;
```

Query field lineage:

```bash
curl -X POST http://localhost:8899/api/lineage/query \
  -H 'Content-Type: application/json' \
  -d '{
    "target_table": "ICL.CUSTOMER_DAILY_SNAPSHOT",
    "target_field": "CUSTOMER_TIER",
    "direction": "upstream"
  }'
```

Example response: [`docs/examples/lineage_query_output.json`](docs/examples/lineage_query_output.json)

## Data source layout

Put local SQL assets under `SOURCE_DATA/`. This directory is intentionally ignored by Git because enterprise SQL and metadata may be sensitive.

```text
SOURCE_DATA/
├── EDW/
│   ├── ddl/
│   └── dml/
├── BRT/
├── CCR/
└── manifest.yml
```

## Architecture

```text
SOURCE_DATA/ (.tab, .prc, .sql, .ctl, .xlsx)
  → ParserRegistry routes by extension
  → FileParser implementations
  → ParseOutput
  → CacheStore / SQLiteResultStore
  → DataRepository in-memory indexes
  → LineageService / CaliberTracer / IndicatorEngine
  → FastAPI + D3.js UI
```

The project follows a three-layer structure:

```text
app/api/ ──→ app/services/ ──→ core/
  routes       orchestration      parser and lineage engine
```

`core/` must remain framework-agnostic and must not import FastAPI.

## Key API endpoints

| API | Method | Path | Description |
|---|---:|---|---|
| Upload parse | POST | `/api/parse/upload` | Upload and parse a SQL file |
| Directory parse | POST | `/api/parse/directory` | Parse all files in a directory |
| Lineage query | POST | `/api/lineage/query` | Query field-level lineage |
| Quick lineage | GET | `/api/lineage/{table}/{field}` | Quick field lineage lookup |
| System tables | GET | `/api/systems/{system_name}/tables` | List tables in a configured system |
| System lineage export | GET | `/api/systems/{system_name}/lineage/export` | Export full-system lineage workbook |
| Caliber query | POST | `/api/caliber/query` | Query transformation caliber |
| Indicator lineage | POST | `/api/indicator/build` | Build indicator lineage graph |
| Stats | GET | `/api/stats` | System stats |

## Development checks

```bash
python3.11 -m pytest tests/
ruff check app/ core/ tests/
mypy app/ core/
scripts/agent-verify.sh quick
scripts/agent-verify.sh full
```

## Security note

Do not commit real enterprise SQL, local caches, logs, databases, screenshots containing sensitive data, or archives. Keep `SOURCE_DATA/`, `output/`, and `temp_uploads/` local.

## License

This project is released under the [MIT License](LICENSE).
