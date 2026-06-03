## MODIFIED Requirements

### Requirement: System selector loads data source list
The system selector SHALL display all enabled data sources from `AppConfig.datasource_configs` / `manifest.yml` on page load. Each option SHALL show display name and table count. The selector SHALL be the first level in the cascade; downstream selectors SHALL be disabled until a system is selected. The system selector SHALL be initialized when the display tab loads via `initCascadingWizard()` called from `initDisplayTab()`.

#### Scenario: Page load populates system selector
- **WHEN** display tab loads
- **THEN** `initCascadingWizard()` is called from `initDisplayTab()`, system selector is populated with all enabled data sources via `GET /api/systems`, each showing `{display_name} ({table_count} 表)`

#### Scenario: System selector empty state
- **WHEN** no system is selected
- **THEN** table selector and field selector are disabled with placeholder text "请先选择系统"

#### Scenario: Repeated tab switch does not re-fetch
- **WHEN** user switches away from and back to the display tab
- **THEN** `initCascadingWizard()` returns immediately due to `_systemsCache` check, no redundant API call

### Requirement: Table selector cascades from system selection
Selecting a system SHALL load all tables belonging to that system into the table selector. The table selector SHALL be a single `<select>` element without a separate search input box. Selecting a different system SHALL clear the table and field selectors.

#### Scenario: System selection loads tables
- **WHEN** user selects a system (e.g., "rrp")
- **THEN** table selector is populated via `GET /api/systems/{name}/tables` with all tables in that system, each showing `{short_name} [{layer}] ({field_count} 字段)`

#### Scenario: System re-selection clears downstream
- **WHEN** user changes the system selection
- **THEN** table selector is reset to empty, field selector is reset and disabled, query button is disabled

#### Scenario: No separate table search input
- **WHEN** the cascade query panel is displayed
- **THEN** there is no `tableFilter` input element; only a single `tableSelect` dropdown is shown for table selection

## ADDED Requirements

### Requirement: Cascade query controls fit in one row
All cascade query controls (system selector, table selector, field selector, direction buttons, query button) SHALL be displayed in a single horizontal row on desktop screens (width ≥ 1024px). The `.input-group` min-width SHALL be reduced to allow all controls to fit without wrapping.

#### Scenario: Desktop layout single row
- **WHEN** the browser viewport width is ≥ 1024px
- **THEN** all 5 cascade query controls are displayed in a single horizontal row within `.query-inputs-row` without wrapping

#### Scenario: Mobile layout vertical stack
- **WHEN** the browser viewport width is < 768px
- **THEN** cascade query controls stack vertically as per existing responsive CSS rules
