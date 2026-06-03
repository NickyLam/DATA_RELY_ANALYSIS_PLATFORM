## ADDED Requirements

### Requirement: SQLCondition import in caliber_metadata
`core/caliber_metadata.py` SHALL import `SQLCondition` from `core.models` so that `MetadataExtractor._extract_subqueries()` can construct WHERE condition objects without raising `NameError`.

#### Scenario: Subquery extraction with WHERE clause
- **WHEN** a `.prc` file containing a SQL subquery with a WHERE clause is parsed
- **THEN** `MetadataExtractor._extract_subqueries()` SHALL successfully create `SQLCondition` objects for the subquery's WHERE conditions without raising `NameError`

#### Scenario: PRC file parsing no longer fails on SQLCondition
- **WHEN** the system parses a `.prc` file that triggers `_extract_subqueries()`
- **THEN** the file SHALL be parsed successfully and the caliber extraction SHALL complete without `name 'SQLCondition' is not defined` error
