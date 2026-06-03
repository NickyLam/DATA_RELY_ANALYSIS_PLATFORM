## Tasks

### T1: Backend — Add systems API endpoint
- [x] 1.1 Add `GET /api/systems` route in `app/api/lineage.py`
- [x] 1.2 Add `TableQueryServiceDep` dependency injection in `app/dependencies.py`
- [x] 1.3 Wire route to `TableQueryService.get_systems()`
**Verification**: Route registered, returns `{success: true, data: [{name, display_name, table_count}]}`

### T2: Backend — Add system tables API endpoint
- [x] 2.1 Add `GET /api/systems/{system_name}/tables` route with `keyword` and `limit` params
- [x] 2.2 Add `get_tables_by_system()` method to `TableQueryService` (aggregates across all schemas)
- [x] 2.3 Wire route to `TableQueryService.get_tables_by_system()`
**Verification**: Route registered, returns tables for system, keyword filter works

### T3: Backend — Pydantic response models for new endpoints
- [x] 3.1 Create `SystemInfo`, `TableBrief`, `SystemListResponse`, `SystemTablesResponse` models in `app/models/__init__.py`
- [x] 3.2 Import and use models in API route signatures
**Verification**: Models import OK, routes use them for `response_model`

### T4: Frontend — Refactor cascading-wizard.js to three-level cascade
- [x] 4.1 Remove Schema level from cascade (system→table→field only)
- [x] 4.2 Change API paths from `/api/v1/systems` to `/api/systems` series
- [x] 4.3 Add `onTableFilterInput()` with debounce for keyword search
- [x] 4.4 Ensure query button disabled until all three selected
- [x] 4.5 Keep existing caching, retry, and mode-switch logic
**Verification**: No Schema selector, API paths correct, three-level cascade works

### T5: Frontend — Update HTML to integrate cascade wizard
- [x] 5.1 Add cascade panel with system/table/field selectors and table filter input
- [x] 5.2 Add mode toggle buttons ("级联查询"/"高级搜索")
- [x] 5.3 Keep existing search panel for advanced mode (hidden by default)
- [x] 5.4 Include `cascading-wizard.js` script tag
**Verification**: Page renders cascade panel by default, toggle works, no regressions

### T6: Frontend — Ensure table selector supports keyword filter input
- [x] 6.1 Implemented in T4 (tableFilter input + onTableFilterInput debounce)
- [x] 6.2 Implemented in T5 (HTML tableFilter input element)
**Verification**: Keyword in table filter → filtered dropdown results

### T7: Frontend — Wire cascade query execution
- [x] 7.1 Implemented in T4 (executeCascadingQuery function)
- [x] 7.2 Implemented in T5 (cascadingQueryBtn onclick)
**Verification**: All three selected → query → lineage graph renders

### T8: Testing — Backend unit tests for new API endpoints
- [x] 8.1 Create `tests/test_system_api.py` with mock data fixtures
- [x] 8.2 Test `GET /api/systems` returns system list with counts
- [x] 8.3 Test `GET /api/systems/{name}/tables` returns tables and keyword filter
- [x] 8.4 Test unknown system returns empty list
**Verification**: `python -m pytest tests/test_system_api.py -v` — 10/10 passed