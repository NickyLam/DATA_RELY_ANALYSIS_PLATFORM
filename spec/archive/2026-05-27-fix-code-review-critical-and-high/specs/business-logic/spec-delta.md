# Spec Delta: 业务逻辑修复

---

## MODIFIED Requirements

### Requirement: Tracer Cache Invalidation
WHEN the parser service completes a data update (full parse, incremental merge, or uploaded file parse),
the system SHALL invalidate the TracerFactory cache
so that subsequent lineage and caliber queries use the latest data.

#### Scenario: Full parse completes
GIVEN a full reparse has completed
WHEN the parse result is assigned to `_current_result`
THEN `TracerFactory.invalidate()` is called
AND subsequent `get_lineage_tracer()` / `get_caliber_tracer()` calls create fresh tracer instances

#### Scenario: DATA_CHANGED event fires
GIVEN the `DATA_CHANGED` event is published
WHEN `LineageService._on_data_changed` handles the event
THEN `TracerFactory.invalidate()` is called before index rebuild

---

### Requirement: Caliber Info Dedup Key Consistency
WHEN caliber info records are merged or deduplicated,
the system SHALL extract `source_table` and `source_column` using the same accessor
that handles both flat and nested (`source_location`) dict formats.

#### Scenario: Nested format from CaliberExtractor.to_dict()
GIVEN a caliber info dict where `source_table` is inside `source_location`
WHEN the merge function computes the dedup key
THEN `_get_source_table(ci)` and `_get_source_column(ci)` are used
AND the key contains the correct source table and column values

#### Scenario: Flat format from legacy source
GIVEN a caliber info dict where `source_table` is at the top level
WHEN the merge function computes the dedup key
THEN the top-level value is used correctly

---

### Requirement: Field Name Exact Matching
WHEN the lineage service searches for field mappings by field name,
the system SHALL use exact string matching, not substring matching.

#### Scenario: Search for field "ID"
GIVEN field mappings with target columns "ID", "VALID", "PROVID"
WHEN the service searches for field "ID"
THEN only the mapping for "ID" is returned
AND mappings for "VALID" and "PROVID" are excluded

---

### Requirement: Downstream Trace Depth Limit
WHEN a downstream caliber trace reaches the configured `max_depth`,
the system SHALL NOT create nodes beyond `max_depth`.

#### Scenario: Trace reaches max_depth
GIVEN `max_depth=5` and the BFS frontier reaches depth 5
WHEN the tracer processes nodes at depth 5
THEN no child nodes are created at depth 6
AND the current node is recorded as a leaf path
AND the behavior is symmetric with the upstream trace

---

### Requirement: Join Conditions Fallback Key
WHEN `_dict_to_record` falls back to `expression_detail` for join data,
the system SHALL use the correct key `"join_clauses"`
and convert the string items to the dict format expected by `_CaliberSourceRecord`.

#### Scenario: Top-level join_conditions absent
GIVEN a dict with no top-level `join_conditions`
WHEN `_dict_to_record` reads join data from `expression_detail`
THEN the key `"join_clauses"` is used to access the data
AND string items are wrapped as `{"raw_text": item}` for type compatibility

---

### Requirement: Procedure Parser Caliber Dedup
WHEN a target table appears in multiple procedure steps,
the system SHALL generate exactly one CaliberInfo per (target_table, target_column, step_num) combination.

#### Scenario: Target table in two steps
GIVEN table T appears in step 1 and step 3
AND there are 5 field mappings targeting T
WHEN caliber info is generated
THEN exactly 5 entries are produced for step 1 and 5 for step 3
AND no duplicate entries exist

---

### Requirement: EventBus Thread Safety
WHEN the EventBus publishes events from one thread while another thread subscribes or unsubscribes,
the system SHALL not crash or silently skip handlers.

#### Scenario: Concurrent publish and subscribe
GIVEN a handler list with 3 handlers
WHEN one thread iterates the list in `publish` while another appends in `subscribe`
THEN no `RuntimeError: list changed size during iteration` is raised
AND all handlers (including the newly added one) are called on subsequent publishes

#### Scenario: Handler without __name__
GIVEN a lambda function as an event handler
WHEN the handler throws an exception
THEN the error is logged with a fallback identifier (not AttributeError)
AND subsequent handlers continue to execute

---

## ADDED Requirements

### Requirement: File Upload Path Traversal Prevention
WHEN a file is uploaded via the API,
the system SHALL sanitize the filename to prevent path traversal attacks.

#### Scenario: Filename with directory traversal
GIVEN an uploaded file with filename `../../../etc/cron.d/malicious.tab`
WHEN the file handler constructs the save path
THEN only `malicious.tab` is used as the filename component
AND the resolved path is verified to be within the task directory

#### Scenario: Normal filename
GIVEN an uploaded file with filename `schema.tab`
WHEN the file handler constructs the save path
THEN the file is saved normally within the task directory
