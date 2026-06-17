## MODIFIED Requirements

### Requirement: All API endpoints must declare response_model
All API endpoints in `lineage.py`, `indicator.py`, `parse.py`, and `system.py` SHALL declare a `response_model` parameter. Endpoints currently returning bare `dict` SHALL use appropriate Pydantic response models.

#### Scenario: OpenAPI documentation completeness
- **WHEN** the OpenAPI schema is generated
- **THEN** all endpoints SHALL have documented response schemas

### Requirement: Error responses must use appropriate HTTP status codes
Endpoints SHALL NOT return `{"success": False}` with HTTP 200 for error conditions. The `force_reparse` endpoint SHALL use `HTTPException(status_code=500)` for internal errors instead of returning `{"success": False, "error": str(e)}` with HTTP 200.

#### Scenario: Reparse failure
- **WHEN** `POST /api/system/reparse` encounters an error
- **THEN** the response SHALL have HTTP status code 500, not 200

#### Scenario: No internal error details exposed
- **WHEN** an internal error occurs
- **THEN** the response SHALL NOT include `str(e)` which may contain file paths or stack traces

### Requirement: DML parser regex constants must not be duplicated
The `_FROM_TABLE_PATTERN` and `_COMMA_TABLE_PATTERN` constants in `dml_parser.py` SHALL be defined exactly once. The duplicate definitions at lines 102-115 SHALL be removed.

#### Scenario: Regex pattern consistency
- **WHEN** `_FROM_TABLE_PATTERN` is modified
- **THEN** there SHALL be exactly one definition to update, not two
