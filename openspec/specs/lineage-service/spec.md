## MODIFIED Requirements

### Requirement: LineageService encapsulation — no private attribute access
`LineageService` SHALL NOT access `ParserService._cache_store` or any other private attribute. `ParserService` SHALL expose a public `get_data_mtime() -> float | None` method that encapsulates the cache store access.

#### Scenario: Getting data modification time
- **WHEN** `LineageService._get_data_mtime()` is called
- **THEN** it SHALL call `self.parser.get_data_mtime()` instead of `self.parser._cache_store.get_repository()`

### Requirement: UnifiedTracer encapsulation — no getattr on private attributes
`UnifiedTracer` SHALL NOT use `getattr(self._lineage, "_table_proc_idx", {})` or `getattr(self._caliber, "_target_idx", {})`. `LineageTracer` SHALL expose `get_procedures_for_table(table: str) -> list[str]`, and `CaliberTracer` SHALL expose `lookup_caliber_by_target(short_table: str, column: str) -> dict | None`.

#### Scenario: UnifiedTracer queries procedure index
- **WHEN** `UnifiedTracer` needs procedure information for a table
- **THEN** it SHALL call `self._lineage.get_procedures_for_table(table)` instead of accessing `_table_proc_idx`

### Requirement: get_downstream_tables must use existing index
`LineageTracer.get_downstream_tables` SHALL use `self._tl_source_idx` for O(1) lookup instead of linear scanning `self.table_lineages`.

#### Scenario: Downstream table lookup performance
- **WHEN** `get_downstream_tables("MY_TABLE")` is called
- **THEN** the lookup SHALL use `self._tl_source_idx.get(norm_table, [])` instead of iterating all lineages

### Requirement: _trace_field_lineage method decomposition
The `_trace_field_lineage` method (335 lines) SHALL be decomposed into smaller methods: `_build_field_mapping_index()`, `_trace_field_bfs()`, and `_supplement_table_lineage_from_field()`. Each sub-method SHALL be independently testable.

#### Scenario: Field lineage tracing correctness
- **WHEN** `_trace_field_lineage` is called with the same inputs as before decomposition
- **THEN** the output SHALL be identical to the pre-decomposition output

### Requirement: Remove dead code _infer_source_table_from_lineage
The `_infer_source_table_from_lineage` method SHALL be removed from `LineageTracer` as it has no callers.

#### Scenario: No reference to removed method
- **WHEN** the codebase is searched for `_infer_source_table_from_lineage`
- **THEN** no references SHALL be found
