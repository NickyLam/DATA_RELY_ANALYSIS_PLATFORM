## Why

Current lineage APIs are optimized for interactive table or field queries, but they do not provide a single, system-scoped export of all parsed lineage relationships. Analysts and downstream tools need a repeatable way to export the complete lineage graph for one data source system without issuing many per-table queries or reconstructing relationships client-side.

## What Changes

- Add a system-scoped full lineage export API that downloads the complete parsed lineage graph for one enabled system as an `.xlsx` file.
- Include export metadata, table nodes, table-level edges, field mappings, and aggregate counts as separate worksheets in the workbook.
- Keep export read-only and based on the current parsed dataset and rebuilt lineage indexes.
- Return clear 404/400-style errors for unknown systems or unavailable parsed data instead of empty success responses.
- Add service-level tests for filtering and API-level tests for response shape and error handling.

## Capabilities

### New Capabilities
- `system-full-lineage-export`: Export the complete lineage graph for a selected data source system, including table nodes, table lineage edges, field mappings, and metadata.

### Modified Capabilities
- None.

## Impact

- `app/api/lineage.py`: add a new GET endpoint under the existing lineage API router that returns an XLSX download response.
- `app/services/lineage_service.py`: add a read-only export method that filters current parser data by system/data source and assembles workbook-ready rows.
- `app/services/`: add or reuse a small XLSX writer built on the existing `openpyxl` dependency.
- `tests/`: add focused service and API coverage for one-system export, XLSX workbook contents, unknown system handling, and no-data behavior.
- No new external dependencies are expected because `openpyxl` is already present in `requirements.txt`.
