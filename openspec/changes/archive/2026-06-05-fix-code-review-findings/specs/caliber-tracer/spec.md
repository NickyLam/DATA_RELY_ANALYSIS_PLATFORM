## MODIFIED Requirements

### Requirement: CaliberTracer internal storage type safety
`CaliberTracer` SHALL define a `TypedDict` (`CaliberInfoDict`) to constrain the structure of `caliber_infos_raw` items and index entries. All `ci_dict.get("source_table", "")` patterns SHALL use the TypedDict for type checking.

#### Scenario: Type checker catches missing key
- **WHEN** a developer accesses `ci_dict["nonexistent_key"]`
- **THEN** the type checker SHALL report an error

### Requirement: _find_upstream_sources and _find_downstream_targets decomposition
The `_find_upstream_sources` (135 lines) and `_find_downstream_targets` (122 lines) methods SHALL be decomposed into shared fallback methods: `_find_from_caliber_idx()`, `_find_from_field_mapping()`, `_find_from_procedure()`, `_find_from_table_lineage()`. The upstream and downstream variants SHALL be unified via a direction parameter.

#### Scenario: Upstream caliber tracing
- **WHEN** `_find_upstream_sources` is called
- **THEN** the result SHALL be identical to the pre-decomposition output

#### Scenario: Downstream caliber tracing
- **WHEN** `_find_downstream_targets` is called
- **THEN** the result SHALL be identical to the pre-decomposition output
