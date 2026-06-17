## ADDED Requirements

### Requirement: Lineage query nodes include their displayed field metadata
The lineage query service SHALL attach an optional `field` object to each graph node that has a field participating in the current lineage result. The object SHALL contain `name` and `data_type`; `data_type` SHALL preserve the complete parsed declaration, including length, precision, or scale when present. This metadata SHALL be returned even when `options.include_fields` is `false`, because it describes only the current lineage field rather than the table's full column list.

#### Scenario: Character field includes length
- **WHEN** a graph node represents field `CUSTOMER_NAME` whose parsed column type is `VARCHAR2(60)`
- **THEN** the node contains `field: {name: "CUSTOMER_NAME", data_type: "VARCHAR2(60)"}`

#### Scenario: Numeric field includes precision and scale
- **WHEN** a graph node represents field `BALANCE` whose parsed column type is `NUMBER(18,2)`
- **THEN** the node's `field.data_type` is exactly `NUMBER(18,2)`

#### Scenario: Type without length is preserved
- **WHEN** a graph node represents field `CREATED_AT` whose parsed column type is `DATE`
- **THEN** the node's `field.data_type` is exactly `DATE`

#### Scenario: Minimal graph response still includes current field metadata
- **WHEN** `POST /api/lineage/query` is called with `options.include_fields` set to `false`
- **THEN** each node with a known lineage field still includes its `field` object and does not include the table's full `columns` collection

### Requirement: Node field selection is deterministic and resolved by the backend
The backend SHALL determine the field associated with each node from the query target and the field-level edges or mappings in the result. The query target field SHALL take precedence for the target node. Matching of table and column metadata SHALL be case-insensitive and SHALL support full and short table names. The frontend SHALL NOT need to scan graph edges to choose the displayed field when `node.field` is present.

#### Scenario: Query target field takes precedence
- **WHEN** the target node is connected by multiple field mappings and the query was for field `ACCOUNT_ID`
- **THEN** the target node's `field.name` is `ACCOUNT_ID`

#### Scenario: Upstream node field is derived from its edge endpoint
- **WHEN** an upstream edge has `source_table` equal to a node and `source_field` equal to `SOURCE_ID`
- **THEN** that node's selected field is `SOURCE_ID`

#### Scenario: Full and short names resolve to the same column metadata
- **WHEN** an edge references `SOURCE_TABLE.SOURCE_ID` and table metadata is stored under `SCHEMA.SOURCE_TABLE`
- **THEN** the backend resolves `SOURCE_ID` and returns its parsed `data_type`

### Requirement: Missing field metadata degrades without breaking the graph
The lineage query and graph rendering SHALL remain functional when a field has no parsed type, when a supplemental table-level node has no field endpoint, or when data comes from an older cache shape.

#### Scenario: Field name exists but type is unavailable
- **WHEN** a node's lineage field is known but no matching column definition exists
- **THEN** the node contains the field name with an empty `data_type` and the graph renders the field name without a type suffix

#### Scenario: Supplemental table node has no field
- **WHEN** a node was added only by table-level lineage fallback and no field endpoint can be associated with it
- **THEN** the node may omit `field` and the graph still renders the table node normally

#### Scenario: Legacy response has no node field object
- **WHEN** the frontend receives a node without `field`
- **THEN** it falls back to the existing edge or mapping lookup for the field name and renders without throwing an error

### Requirement: Graph nodes display field type and declared length
For every graph node with field metadata, the D3 graph SHALL display the field name and its complete `data_type`. Types containing parentheses SHALL display the parenthesized length, precision, or scale. The full field/type value SHALL remain available through an SVG tooltip when visible text is truncated to fit the node.

#### Scenario: Node displays type and length
- **WHEN** a node has `field.name` equal to `CUSTOMER_NAME` and `field.data_type` equal to `VARCHAR2(60)`
- **THEN** the node visibly displays both `CUSTOMER_NAME` and `VARCHAR2(60)`

#### Scenario: Node displays type without length
- **WHEN** a node has `field.name` equal to `CREATED_AT` and `field.data_type` equal to `DATE`
- **THEN** the node visibly displays both `CREATED_AT` and `DATE` without adding empty parentheses

#### Scenario: Long field metadata remains inspectable
- **WHEN** the combined field name and data type exceed the node's available width
- **THEN** the visible label is safely truncated and an SVG `title` exposes the complete untruncated value

### Requirement: Node detail uses the same field metadata contract
Opening a graph node SHALL pass the backend-selected node field metadata to the detail panel. The panel heading or field summary SHALL show the same field name and complete data type used by the graph node, while the existing lazy-loaded table and caliber details continue to work.

#### Scenario: Detail panel shows selected field type
- **WHEN** a user opens a node whose `field` is `{name: "AMOUNT", data_type: "NUMBER(18,2)"}`
- **THEN** the detail panel identifies `AMOUNT` and displays `NUMBER(18,2)` before or alongside the lazy-loaded details

#### Scenario: Detail panel handles missing type
- **WHEN** a user opens a node whose field has an empty `data_type`
- **THEN** the panel displays the field name and omits the type text without showing an empty placeholder
