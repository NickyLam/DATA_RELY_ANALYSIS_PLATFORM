# Code Quality Refactoring Plan (P0 + P1 + P2)

## Context

The project (`data-rely-analysis-sys` v2.1.0) received a comprehensive code quality assessment scoring **6.32/10 (C+)**. The core issues are:
- **Code duplication**: `procedure_parser.py` duplicates 6 methods/constants from `table_name_resolver.py` (~75 lines), creating a silent divergence risk
- **Broken encapsulation**: `LineageService` directly accesses `ParserService._tracer_factory` and `._cache_store`
- **God Methods**: `_bfs_trace` (160 lines, CC=18-22), duplicated upstream/downstream BFS (~100 lines)
- **Unused type safety**: Pydantic response models defined but not wired into routes
- **SRP violations**: `LineageTracer` (938L, 7 responsibilities), `CaliberExtractor` (854L, 16 responsibilities), `LineageService` (1088L)

This plan implements 16 refactoring items across 3 phases to raise the quality score toward 8/10.

## Execution Rules

1. Phases are **strictly sequential**: P0 complete -> P1 complete -> P2
2. Within each phase, tasks follow the recommended order below
3. After each task: `python -m pytest tests/ -x` (zero regression)
4. After each task: code review via `code-reviewer` agent
5. After each task: update task status in `spec/changes/refactor-code-quality/tasks.md`

---

## Phase P0 - Foundation Fixes (4 tasks)

### P0-4: Expose public methods on ParserService (do first - enables P0-1)

**Files:**
- `app/services/parser_service.py` - add 2 public methods
- `app/services/lineage_service.py` - replace 2 private accesses

**Changes:**
1. Add to `ParserService`:
   ```python
   def invalidate_tracer(self) -> None:
       self._tracer_factory.invalidate()
   
   def get_repository(self) -> Optional[DataRepository]:
       return self._cache_store.get_repository()
   ```
2. Replace in `lineage_service.py`:
   - Line 89: `self.parser._tracer_factory.invalidate()` -> `self.parser.invalidate_tracer()`
   - Line 562: `self.parser._cache_store.get_repository()` -> `self.parser.get_repository()`
3. Verify no other `self.parser._` accesses: `grep -rn "self\.parser\._" app/services/`

**Verify:** `python -m pytest tests/ -x`

---

### P0-1: Eliminate TableNameResolver duplication in procedure_parser.py

**Files:**
- `core/procedure_parser.py` - inject resolver, delete 6 methods/constants (~75 lines)
- `app/services/parser_service.py` - pass resolver when creating EnhancedProcedureParser

**Changes:**
1. Modify `EnhancedProcedureParser.__init__` to accept `resolver: Optional[TableNameResolver] = None`; default creates one from `set(tables.keys())`
2. Delete constants: `_INVALID_TABLE_PREFIXES` (lines 52-61), `_TEMP_TABLE_SUFFIXES` (line 64)
3. Delete methods: `_is_valid_table` (1043-1051), `_is_temp_table` (884-887), `_normalize_table_name` (1053-1072), `_find_best_table_match` (1074-1101)
4. Replace 32 call sites (see REFACTOR_DESIGN.md P0-1 Step 3 for full list):
   - `self._is_valid_table(x)` -> `TableNameResolver.is_valid_table(x)` (static)
   - `self._is_temp_table(x)` -> `TableNameResolver.is_temp_table(x)` (static)
   - `self._normalize_table_name(x)` -> `self._resolver.normalize(x)`
5. Update `parser_service.py` to pass resolver:
   ```python
   resolver = TableNameResolver(known_full_names=set(tables.keys()))
   self._proc_parser = EnhancedProcedureParser(tables=tables, resolver=resolver)
   ```

**Risk:** Medium. Verify `TableNameResolver._get_known_schemas("rrp")` returns same set as hardcoded `{"ICL", "IML", "IOL", "RRP_EAST", "RRP_MDL"}`.

**Verify:** `python -m pytest tests/ -x -k "procedure or parse or lineage or tracer"`

---

### P0-3: Move business logic from lineage.py route to service

**Files:**
- `app/api/lineage.py` - slim down `get_table_fields` (~50 lines -> ~5 lines)
- `app/services/lineage_service.py` - add `get_table_fields(table_name: str) -> list[str]`

**Changes:**
1. Move lines 136-170 from `lineage.py:get_table_fields()` into `LineageService.get_table_fields()`
2. Route becomes:
   ```python
   def get_table_fields(table: str, lineage_service: LineageServiceDep) -> dict:
       _validate_table_name(table)
       fields = lineage_service.get_table_fields(table)
       if not fields:
           raise HTTPException(status_code=404, detail=f"未找到表: {table}")
       return {"code": 0, "message": "", "data": fields}
   ```

**Verify:** `python -m pytest tests/test_lineage_api.py -v`

---

### P0-2: Wire Pydantic response models into route return types

**Files:**
- `app/models/responses.py` - NEW: define `ApiResponse[T]` + per-endpoint data models
- `app/api/lineage.py`, `app/api/parse.py`, `app/api/indicator.py`, `app/api/system.py` - change return types
- `app/models/__init__.py` - remove now-unused legacy response models

**Changes:**
1. Create `app/models/responses.py`:
   ```python
   class ApiResponse(BaseModel, Generic[T]):
       code: int = 0
       message: str = ""
       data: Optional[T] = None
   ```
2. Define data models: `LineageQueryResult`, `TableFieldsData`, `SystemStatsData`, `ParseTaskData`, etc.
3. Change routes from `-> dict` to `-> ApiResponse[XxxData]` (or `response_model=ApiResponse[XxxData]`)
4. Replace hand-crafted dicts with `ApiResponse(data=...)` construction
5. SSE endpoints (`/api/parse/progress/{task_id}`) keep `StreamingResponse` - NOT affected

**Verify:** `python -m pytest tests/ -x` + check `/docs` page shows correct response schemas

---

## Phase P1 - Short-term Improvements (6 tasks)

### P1-9: Add pytest-cov configuration

**Files:** `requirements.txt`, `pytest.ini`

**Changes:**
1. Add `pytest-cov>=4.0` to requirements.txt
2. Update pytest.ini: `addopts = --cov=core --cov=app --cov-report=term-missing --cov-fail-under=35`
3. Run and record baseline coverage

**Verify:** `python -m pytest tests/` shows coverage report

---

### P1-7: Merge three duplicate enums

**Files:** `app/models/__init__.py`, update imports across `app/api/`, `tests/`

**Changes:**
1. Keep `LineageDirection` as canonical (rename `QueryMode`):
   ```python
   class LineageDirection(str, Enum):
       UPSTREAM = "upstream"
       DOWNSTREAM = "downstream"
       BOTH = "both"
   
   QueryMode = LineageDirection  # backward-compat alias
   CaliberQueryMode = LineageDirection
   IndicatorQueryMode = LineageDirection
   ```
2. Update all explicit references to use `LineageDirection` (old names still work via alias)

**Verify:** `python -m pytest tests/ -x`

---

### P1-8: Unify error handling with response_utils

**Files:**
- `app/utils/response_utils.py` - NEW: `ok()`, `err()` helpers
- `app/api/indicator.py` - remove local `_ok()`/`_err()`, use shared utils
- `app/api/lineage.py`, `parse.py`, `system.py` - replace inline dict construction

**Changes:**
1. Create response_utils.py with `ok(data=None, message="")` and `err(code=1, message="")`
2. Replace all `return {"code": 0, "message": "", "data": ...}` with `return ok(data=...)`
3. Remove `indicator.py`'s local `_ok()`/`_err()` (lines ~20-25)

**Verify:** `python -m pytest tests/ -x`

---

### P1-5: Split God Method `_bfs_trace` (160 lines -> 4 helpers + 30-line orchestrator)

**Files:** `core/lineage_tracer.py`

**Changes:**
Extract from `_bfs_trace` (lines 190-350):
1. `_init_bfs_root(table, field)` -> (bfs_tree, visited, root_node)
2. `_fold_same_table_transforms(current, sources, bfs_tree)` -> (final_sources, note)
3. `_update_transform_annotation(bfs_tree, key, note)` -> None
4. `_expand_bfs_neighbors(bfs_tree, visited, queue, current, sources, current_key)` -> None

Parent `_bfs_trace` becomes ~30 lines calling these helpers.

**Risk:** Medium. Create golden output test BEFORE refactoring: serialize trace results for 3 known inputs, assert equality after.

**Verify:** `python -m pytest tests/test_unified_tracer.py tests/test_tracer_procedure.py -v`

---

### P1-6: Parameterize BFS direction (merge upstream + downstream)

**Files:** `core/lineage_tracer.py`

**Changes:**
1. Add `BFSDirection` enum: `UPSTREAM | DOWNSTREAM`
2. Create `_bfs_trace_unified(table, field, max_depth, direction)` that uses strategy pattern:
   - direction selects: `find_neighbors_fn`, `layer_compat_fn`, `root_label`
3. Keep `_bfs_trace()` and `_bfs_trace_downstream()` as thin wrappers (backward compat)
4. Delete ~100 lines of duplicated downstream logic

**Verify:** `python -m pytest tests/test_unified_tracer.py -v` + golden output comparison

---

### P1-10: Introduce /api/v1/ version prefix

**Files:**
- `app/api/lineage.py`, `parse.py`, `indicator.py`, `system.py` - change prefix
- `app/main.py` - add legacy redirect middleware
- `static/js/*.js` - update fetch URLs
- `tests/test_*.py` - update URL paths

**Changes:**
1. Change each router: `prefix="/api"` -> `prefix="/api/v1"`, `prefix="/api/parse"` -> `prefix="/api/v1/parse"`, etc.
2. Add middleware in main.py for backward compat: `/api/*` -> 307 redirect to `/api/v1/*`
3. Update frontend JS API base URL
4. Update all test client URLs

**Risk:** Medium-high (largest blast radius). Do last in P1.

**Verify:** `python -m pytest tests/ -x` + manual curl test for redirect behavior

---

## Phase P2 - SRP Refactoring (6 tasks)

### P2-16: Create mock data layer
- Create `tests/fixtures/mock_data.py` with factory functions
- Expand `tests/conftest.py` with reusable mock fixtures

### P2-15: Add warehouse module tests
- Create `tests/test_warehouse_parser.py` covering DDL/DML/CTL/schema parsing

### P2-13: Extract shared bracket matching utility
- Create `core/utils/bracket_matcher.py`
- Replace implementations in `sql_boundary_detector.py` and `caliber_extractor.py`

### P2-12: Split CaliberExtractor into 3 classes
- `core/caliber/condition_extractor.py`, `metadata_extractor.py`, `expression_builder.py`
- `CaliberExtractor` becomes orchestrator facade

### P2-11: Split LineageTracer into 4 classes
- `core/lineage/lineage_index.py`, `bfs_engine.py`, `chain_builder.py`, `graph_converter.py`
- `LineageTracer` becomes orchestrator facade

### P2-14: Split LineageService (1088 lines) into 4 services
- `app/services/lineage/table_query_service.py`, `field_lineage_service.py`, `index_service.py`
- `LineageService` becomes facade maintaining backward-compat API

---

## Verification Strategy

After EACH task:
1. `python -m pytest tests/ -x` - zero regression
2. `python -c "from app.main import app"` - import sanity
3. Code review via code-reviewer agent
4. Update task tracking file

After each PHASE:
1. Full test suite: `python -m pytest tests/ -v`
2. Start server and smoke test: `python run_app.py` + verify `/docs` accessible
3. Compare behavior with pre-refactoring baseline

## New Files Created

| File | Phase |
|------|-------|
| `app/models/responses.py` | P0-2 |
| `app/utils/response_utils.py` | P1-8 |
| `core/utils/__init__.py` | P2-13 |
| `core/utils/bracket_matcher.py` | P2-13 |
| `core/lineage/__init__.py` | P2-11 |
| `core/lineage/lineage_index.py` | P2-11 |
| `core/lineage/bfs_engine.py` | P2-11 |
| `core/lineage/chain_builder.py` | P2-11 |
| `core/lineage/graph_converter.py` | P2-11 |
| `core/caliber/__init__.py` | P2-12 |
| `core/caliber/condition_extractor.py` | P2-12 |
| `core/caliber/metadata_extractor.py` | P2-12 |
| `core/caliber/expression_builder.py` | P2-12 |
| `app/services/lineage/__init__.py` | P2-14 |
| `tests/fixtures/mock_data.py` | P2-16 |
| `tests/test_warehouse_parser.py` | P2-15 |
