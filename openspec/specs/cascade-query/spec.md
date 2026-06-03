## ADDED Requirements

### Requirement: System selector loads data source list
The system selector SHALL display all enabled data sources from `AppConfig.datasource_configs` / `manifest.yml` on page load. Each option SHALL show display name and table count. The selector SHALL be the first level in the cascade; downstream selectors SHALL be disabled until a system is selected.

#### Scenario: Page load populates system selector
- **WHEN** display tab loads
- **THEN** system selector is populated with all enabled data sources via `GET /api/systems`, each showing `{display_name} ({table_count} 表)`

#### Scenario: System selector empty state
- **WHEN** no system is selected
- **THEN** table selector and field selector are disabled with placeholder text "请先选择系统"

### Requirement: Table selector cascades from system selection
Selecting a system SHALL load all tables belonging to that system into the table selector. The table selector SHALL support keyword filtering to narrow results. Selecting a different system SHALL clear the table and field selectors.

#### Scenario: System selection loads tables
- **WHEN** user selects a system (e.g., "rrp")
- **THEN** table selector is populated via `GET /api/systems/{name}/tables` with all tables in that system, each showing `{short_name} [{layer}] ({field_count} 字段)`

#### Scenario: Table keyword filtering
- **WHEN** user types a keyword in the table search box after selecting a system
- **THEN** table list is filtered via `GET /api/systems/{name}/tables?keyword={keyword}` showing only matching tables

#### Scenario: System re-selection clears downstream
- **WHEN** user changes the system selection
- **THEN** table selector is reset to empty, field selector is reset and disabled, query button is disabled

### Requirement: Field selector cascades from table selection
Selecting a table SHALL load its field list into the field selector. Selecting a different table SHALL clear the field selector. Field names SHALL be displayed in uppercase.

#### Scenario: Table selection loads fields
- **WHEN** user selects a table from the table selector
- **THEN** field selector is populated with the table's columns via `GET /api/tables/{table}/fields`, all field names in uppercase

#### Scenario: Table re-selection clears field
- **WHEN** user changes the table selection
- **THEN** field selector is reset to empty, query button is disabled

#### Scenario: Table with no field data
- **WHEN** user selects a table that has no column data
- **THEN** field selector shows placeholder "无字段数据，可手动输入" and is enabled for manual entry

### Requirement: Query button requires all three selections
The query button SHALL be disabled unless system, table, and field are all selected. Only when all three are selected SHALL the query button become active and allow executing the lineage query.

#### Scenario: Partial selection keeps query disabled
- **WHEN** only system is selected, or system+table but no field
- **THEN** query button is disabled

#### Scenario: Full selection enables query
- **WHEN** system, table, and field are all selected
- **THEN** query button is enabled

#### Scenario: Query execution uses selected values
- **WHEN** user clicks query button with all three selections complete
- **THEN** system sends `POST /api/lineage/query` with the selected table full name and field name, using current depth and mode settings

### Requirement: Advanced search mode toggle
The query panel SHALL provide a toggle between "级联查询" (cascade) mode and "高级搜索" (advanced search) mode. Advanced search mode SHALL preserve the existing keyword-based table search behavior. Switching modes SHALL prefill values from the current mode into the other.

#### Scenario: Switch to advanced search
- **WHEN** user clicks "高级搜索" toggle button
- **THEN** cascade panel is hidden, keyword search panel is shown, and if a table+field were selected in cascade mode, they are prefilled into the search inputs

#### Scenario: Switch to cascade query
- **WHEN** user clicks "级联查询" toggle button
- **THEN** keyword search panel is hidden, cascade panel is shown

### Requirement: Backend API for system list
The backend SHALL expose `GET /api/systems` returning a list of enabled data sources with name, display_name, and table_count.

#### Scenario: Systems API response
- **WHEN** `GET /api/systems` is called
- **THEN** response is `{success: true, data: [{name, display_name, table_count}, ...]}` derived from `TableQueryService.get_systems()`

### Requirement: Backend API for system tables
The backend SHALL expose `GET /api/systems/{name}/tables` returning tables belonging to the specified system, with optional `keyword` query parameter for filtering and `limit` parameter.

#### Scenario: System tables API response
- **WHEN** `GET /api/systems/rrp/tables` is called
- **THEN** response is `{success: true, data: [{full_name, short_name, layer, field_count}, ...]}` derived from `TableQueryService.get_tables_by_schema()`

#### Scenario: System tables with keyword filter
- **WHEN** `GET /api/systems/rrp/tables?keyword=EAST5` is called
- **THEN** response contains only tables whose name includes "EAST5"

### Requirement: Cascade state caching
The cascade selector SHALL cache system list, and table lists per system in memory to avoid redundant API calls during the session.

#### Scenario: Cached system list reuse
- **WHEN** user switches away from and back to the cascade panel
- **THEN** system list is loaded from cache without an API call

#### Scenario: Cached table list reuse
- **WHEN** user re-selects a previously selected system
- **THEN** table list is loaded from cache without an API call
