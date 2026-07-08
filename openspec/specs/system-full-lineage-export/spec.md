## Purpose

Define the system-scoped full lineage export capability that produces an XLSX workbook for a selected data source system.

## Requirements

### Requirement: System-scoped full lineage export API
The system SHALL expose a read-only API endpoint `GET /api/systems/{system_name}/lineage/export` that exports the complete currently parsed lineage graph for the requested data source system as an `.xlsx` file.

#### Scenario: Successful system export
- **WHEN** a client requests `GET /api/systems/edw/lineage/export` and parsed data is available for system `edw`
- **THEN** the response SHALL return an XLSX workbook containing export metadata, table nodes, table-level lineage edges, field mappings, and summary counts for the `edw` export

#### Scenario: Export does not trigger parsing
- **WHEN** a client requests a system lineage export
- **THEN** the system SHALL use the current parser data and SHALL NOT trigger full parsing, incremental parsing, or cache rebuild as part of the export request

#### Scenario: Download response headers
- **WHEN** a system export succeeds
- **THEN** the response SHALL use media type `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet` and a `Content-Disposition` attachment filename ending in `.xlsx`

### Requirement: System filtering must match cascade table classification
The export SHALL classify tables by the same system membership rules used by system table browsing: explicit `data_source` takes precedence, and schema-to-system mapping is used when `data_source` is absent.

#### Scenario: Explicit data_source wins over schema
- **WHEN** a table has `data_source` equal to the requested system but its schema name could map to another system
- **THEN** the table SHALL be included in the requested system export

#### Scenario: Schema fallback when data_source is absent
- **WHEN** a table has no `data_source` and its schema maps to the requested system
- **THEN** the table SHALL be included in the requested system export

### Requirement: Complete touched lineage relationships
The export SHALL include every table-level lineage edge and field mapping where either endpoint belongs to the requested system. Referenced tables outside the requested system SHALL appear as external nodes with minimal metadata.

#### Scenario: Inbound cross-system lineage
- **WHEN** a lineage edge has an external source table and a target table in the requested system
- **THEN** the edge SHALL be included and the external source table SHALL appear as a node marked `is_external=true`

#### Scenario: Outbound cross-system lineage
- **WHEN** a lineage edge has a source table in the requested system and an external target table
- **THEN** the edge SHALL be included and the external target table SHALL appear as a node marked `is_external=true`

#### Scenario: Field mapping export
- **WHEN** a field mapping has a source or target table in the requested system
- **THEN** the mapping SHALL be included with source table, source column, target table, target column, procedure, and transformation metadata when present

### Requirement: Export response metadata and counts
The export workbook SHALL include deterministic metadata and counts so clients can identify and validate the exported dataset.

#### Scenario: Metadata included
- **WHEN** a system export succeeds
- **THEN** the `Summary` worksheet SHALL include `system_name`, `generated_at`, `data_mtime`, and `parser_generation` when those values are available

#### Scenario: Counts included
- **WHEN** a system export succeeds
- **THEN** the `Summary` worksheet SHALL include counts for total nodes, system nodes, external nodes, table lineage edges, and field mappings

### Requirement: Workbook sheet structure
The export workbook SHALL contain stable worksheets and columns for downstream review and automated validation.

#### Scenario: Required worksheets
- **WHEN** a system export succeeds
- **THEN** the workbook SHALL contain `Summary`, `Tables`, `TableLineages`, and `FieldMappings` worksheets

#### Scenario: Tables worksheet columns
- **WHEN** the `Tables` worksheet is generated
- **THEN** it SHALL include columns for full table name, short table name, layer, field count, system name, and external flag

#### Scenario: TableLineages worksheet columns
- **WHEN** the `TableLineages` worksheet is generated
- **THEN** it SHALL include columns for source table, target table, procedure, data source, and available operation metadata

#### Scenario: FieldMappings worksheet columns
- **WHEN** the `FieldMappings` worksheet is generated
- **THEN** it SHALL include columns for source table, source column, target table, target column, procedure, transform logic, and condition metadata when present

### Requirement: Export error handling
The export endpoint SHALL return HTTP errors for unknown systems and unavailable parsed data instead of returning a successful empty export.

#### Scenario: Unknown system
- **WHEN** a client requests an export for a system name that is not an enabled data source system
- **THEN** the response SHALL have HTTP 404 status with a user-safe error message

#### Scenario: No parsed data available
- **WHEN** a client requests a system export before any parsed data is available
- **THEN** the response SHALL have HTTP 404 status with a user-safe error message

### Requirement: Documented XLSX file response
The export endpoint SHALL document the XLSX response media type and binary body in OpenAPI route metadata.

#### Scenario: OpenAPI schema includes XLSX response
- **WHEN** the FastAPI OpenAPI schema is generated
- **THEN** `GET /api/systems/{system_name}/lineage/export` SHALL document a 200 response with `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet` content
