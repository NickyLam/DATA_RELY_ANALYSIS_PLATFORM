# Spec Delta: Cascading Query Wizard

## ADDED Requirements

### Requirement: System List API
WHEN a client requests `GET /api/v1/systems`,
the system SHALL return a list of all enabled data sources with their display names and table counts.

#### Scenario: Normal Request
GIVEN the application has 4 enabled data sources (rrp, edw, mcs, fdm)
WHEN the client requests `GET /api/v1/systems`
THEN the response contains 4 items
AND each item includes `name`, `display_name`, and `table_count`

#### Scenario: No Data Sources
GIVEN no data sources are configured
WHEN the client requests `GET /api/v1/systems`
THEN the response contains an empty list with `code: 0`

---

### Requirement: Schema List API
WHEN a client requests `GET /api/v1/systems/{system}/schemas`,
the system SHALL return a list of distinct schemas (namespaces) within that data source with their table counts.

#### Scenario: Valid System with Multiple Schemas
GIVEN the "rrp" system has tables in schemas "RRP_MDL" and "RRP_EAST"
WHEN the client requests `GET /api/v1/systems/rrp/schemas`
THEN the response includes entries for "RRP_MDL" and "RRP_EAST"
AND each entry includes `schema_name` and `table_count`

#### Scenario: System with Unclassified Tables
GIVEN some tables in the "rrp" system have no schema prefix
WHEN the client requests `GET /api/v1/systems/rrp/schemas`
THEN the response includes an entry with `schema_name: "__unclassified__"`

#### Scenario: Invalid System Name
GIVEN the system "nonexistent" does not exist
WHEN the client requests `GET /api/v1/systems/nonexistent/schemas`
THEN the response returns `code: 0` with an empty data list

---

### Requirement: Tables by Schema API
WHEN a client requests `GET /api/v1/systems/{system}/schemas/{schema}/tables`,
the system SHALL return a list of tables belonging to that system and schema.

#### Scenario: Valid System and Schema
GIVEN the "rrp" system's "RRP_MDL" schema contains 50 tables
WHEN the client requests `GET /api/v1/systems/rrp/schemas/RRP_MDL/tables`
THEN the response includes up to 50 table items
AND each item includes `full_name`, `short_name`, `layer`, and `field_count`

#### Scenario: With Keyword Filter
GIVEN the "RRP_MDL" schema contains tables including "O_ICL_LOAN"
WHEN the client requests `GET /api/v1/systems/rrp/schemas/RRP_MDL/tables?keyword=ICL`
THEN the response includes only tables whose name contains "ICL"

---

### Requirement: Cascading Query Wizard UI
WHEN a user navigates to the display tab,
the system SHALL present a cascading selection wizard with four levels: System → Schema → Table → Field.

#### Scenario: Happy Path Query
GIVEN the user is on the display tab
WHEN the user selects system "监管报送平台", then schema "RRP_MDL", then table "O_ICL_LOAN", then field "LOAN_NO"
AND clicks the query button
THEN the system displays the field-level lineage graph for `RRP_MDL.O_ICL_LOAN.LOAN_NO`

#### Scenario: Cascading Reset
GIVEN the user has selected system "rrp" and schema "RRP_MDL"
WHEN the user changes the system selection to "edw"
THEN the schema, table, and field selections SHALL be cleared
AND the schema dropdown SHALL be populated with schemas from "edw"

#### Scenario: Empty State Guidance
GIVEN the user has not selected any system
WHEN the user views the cascading wizard
THEN all downstream dropdowns SHALL be disabled with placeholder text guiding the user to select the previous level first

---

### Requirement: Advanced Search Fallback
WHEN a user toggles to "Advanced Search" mode,
the system SHALL present the original free-text search interface (table input + field input).

#### Scenario: Switch to Advanced Search
GIVEN the user is in cascading wizard mode
WHEN the user clicks "Advanced Search"
THEN the free-text search inputs SHALL appear
AND the table and field values from the cascading selection (if any) SHALL be pre-populated into the search inputs

#### Scenario: Switch Back to Wizard
GIVEN the user is in advanced search mode
WHEN the user clicks "Cascading Wizard"
THEN the cascading selection area SHALL appear
AND any table/field values from the advanced search SHALL NOT be automatically mapped back (as reverse mapping is ambiguous)

---

### Requirement: Unclassified Table Handling
WHEN tables exist that cannot be mapped to a specific schema,
the system SHALL group them under a virtual schema labeled "未分类" (unclassified).

#### Scenario: Display Unclassified Tables
GIVEN 15 tables have no schema prefix
WHEN the user views the schema list for that system
THEN an entry "未分类" SHALL appear at the end of the schema list with `table_count: 15`
AND selecting it SHALL show those 15 tables
