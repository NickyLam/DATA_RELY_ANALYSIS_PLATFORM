## ADDED Requirements

### Requirement: Shared parenthesis matching function
The system SHALL provide a shared `find_matching_paren(text: str, start: int) -> int` function in `core/utils.py`. Both `SQLBoundaryDetector._find_matching_paren` and `caliber_extractor._find_matching_paren_in_text` SHALL delegate to this shared function.

#### Scenario: Matching parenthesis found
- **WHEN** `find_matching_paren("(a, b, c)", 0)` is called
- **THEN** the function SHALL return the index of the closing parenthesis

#### Scenario: No matching parenthesis
- **WHEN** `find_matching_paren("(a, b", 0)` is called
- **THEN** the function SHALL return -1

### Requirement: Shared temp table detection function
The system SHALL provide a shared `is_temp_table(table_name: str) -> bool` function in `core/utils.py`. Both `BaseTracer.is_temp_table` and `EnhancedProcedureParser._is_temp_table` SHALL delegate to this shared function.

#### Scenario: Temp table detected by suffix
- **WHEN** `is_temp_table("MY_TABLE_TMP")` is called
- **THEN** the function SHALL return True

#### Scenario: Normal table not flagged
- **WHEN** `is_temp_table("MY_TABLE")` is called
- **THEN** the function SHALL return False

### Requirement: Shared field name normalization
`LineageTracer._normalize_field_name` SHALL delegate to `BaseTracer.normalize_name` instead of reimplementing the same logic. The `_normalize_field_name` static method SHALL be removed.

#### Scenario: Field name normalization
- **WHEN** `normalize_name(" my_field ")` is called
- **THEN** the function SHALL return "MY_FIELD"
