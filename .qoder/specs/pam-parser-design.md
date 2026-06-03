# PAM Parser Design

## Context

PAM (绩效考核系统) data files use an Oracle PL/SQL*Plus export format fundamentally different from the existing warehouse DDL/DML format:
- **DDL**: Single file with ~10,584 `CREATE TABLE` statements (1.2M lines), bare table names, `COMMENT ON` annotations
- **DML**: Single file with ~990 `CREATE EDITIONABLE procedure` blocks (327K lines), separated by `/`, containing dynamic SQL with `execute immediate`

The current `WarehouseSQLParser` expects per-file tables with `${schema}` variables and INSERT INTO...SELECT DML patterns, making it unsuitable for PAM. A dedicated PAM parser is needed.

## Implementation Plan

### 1. Create `core/pam/` package

**File: `core/pam/__init__.py`**
- Export `PamParser`

**File: `core/pam/pam_ddl_parser.py`** - Multi-table DDL splitter & parser

Functions:
- `parse_file(file_path) -> list[TableInfo]` — Entry point: read file, split, parse all tables
- `_split_tables(content) -> list[str]` — Split by `create table` boundaries (use regex to find each CREATE TABLE block including its trailing comments/indexes)
- `_parse_single_table(block, default_schema) -> TableInfo | None` — Extract table name, columns, comments from one block
- `_extract_columns(body_text) -> list[ColumnInfo]` — Parse column definitions from CREATE TABLE body
- `_extract_comments(block, table_name) -> tuple[str, dict[str, str]]` — Extract table comment + column comments from COMMENT ON statements

Key differences from warehouse DDLParser:
- No `${schema}` variable resolution needed
- Uses `default_schema` from manifest (`pam`)
- Handles `compress;` after column definitions
- Handles bare table names (no dot-qualified schema)

**File: `core/pam/pam_dml_parser.py`** - Multi-procedure DML splitter & parser

Functions:
- `parse_file(file_path) -> ParseOutput` — Entry point: read file, split procedures, parse each
- `_split_procedures(content) -> list[str]` — Split by `/` delimiter lines, filter out ALTER PROCEDURE blocks
- `_parse_single_procedure(block, default_schema) -> tuple | None` — Parse one procedure block, return (proc_dict, lineages, mappings)
- `_extract_proc_name(block) -> str | None` — Extract procedure name from `CREATE EDITIONABLE procedure` header
- `_resolve_variables(block) -> dict[str, str]` — Scan `v_xxx := 'TABLE_NAME'` assignments, build variable→value map
- `_extract_dynamic_sql(block, var_map) -> list[str]` — Extract SQL strings, replace `'||v_xxx||'` with resolved values
- `_parse_dml_from_sql(sql_text, proc_name, default_schema) -> tuple[list, list]` — Parse INSERT/DELETE/SELECT/MERGE from resolved SQL to build lineage + field mappings

Variable resolution strategy:
1. Scan the procedure body for `v_xxx varchar2(...) := 'VALUE'` declarations and `v_xxx := 'VALUE'` assignments
2. When encountering `'||v_xxx||'` in SQL strings, substitute with the resolved value
3. For unresolvable variables (e.g., runtime parameters like `i_tjrq`), leave as-is — these are values, not table names
4. This covers common patterns like `v_NBZZ_ZQLZMX := 'NBZZ_ZQLZMX'` used as table name references

Key points:
- Procedures use dynamic SQL concatenation (`v_sql:='insert into '||v_xxx||' ...'`)
- Target/source tables referenced as `pas.TABLE` or bare `TABLE`
- Skip ALTER PROCEDURE compilation blocks at file end
- Strip `pas.` schema prefix and normalize to `pam.TABLE` format

**File: `core/pam/pam_parser.py`** - FileParser Protocol entry point

Functions:
- `__init__(default_schema)` — Initialize with schema from manifest
- `supported_extensions() -> list[str]` — Returns `[".sql"]`
- `parse_file(file_path) -> ParseOutput` — Route to DDL or DML based on path
- `parse_directory(dir_path) -> ParseOutput` — Two-phase: DDL first, then DML (same pattern as WarehouseSQLParser)

### 2. Modify manifest and initialization

**File: `SOURCE_DATA/PAM/manifest.yml`**
- Change `parser: warehouse` to `parser: pam`

**File: `app/services/parser_service.py`** (`initialize_parsers` method)
- Add import for `PamParser`
- In the datasource config loop, detect `parser == "pam"` and register `PamParser` instance
- Pass `default_schema` from manifest's `layer_rules.default_schema` field

### 3. Files to create/modify

| File | Action |
|------|--------|
| `core/pam/__init__.py` | Create |
| `core/pam/pam_ddl_parser.py` | Create |
| `core/pam/pam_dml_parser.py` | Create |
| `core/pam/pam_parser.py` | Create |
| `SOURCE_DATA/PAM/manifest.yml` | Modify `parser` field |
| `app/services/parser_service.py` | Add PAM parser registration |

### 4. Verification

1. Run: `python -m pytest tests/ -v` (ensure no regressions)
2. Run: `python -c "from core.pam import PamParser; print('OK')"` (import check)
3. Run a targeted parse test:
   ```python
   from core.pam import PamParser
   from pathlib import Path
   parser = PamParser(default_schema="pam")
   output = parser.parse_directory(Path("SOURCE_DATA/PAM"))
   print(output.summary())
   ```
4. Verify DDL produces ~10,000+ table records with columns
5. Verify DML produces procedure records with table lineages
