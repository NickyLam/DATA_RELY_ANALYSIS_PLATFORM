## 1. Backend Contract Tests

- [x] 1.1 Add service-level tests proving the query target node receives the requested field and complete `data_type`.
- [x] 1.2 Add tests for upstream/downstream endpoint field selection, full-name versus short-name table matching, and case-insensitive column lookup.
- [x] 1.3 Add API tests proving `include_fields=false` still returns `nodes[].field` without returning each node's full `columns` list.
- [x] 1.4 Add degradation tests for unknown field type, supplemental table-only nodes, and duplicate-schema short-name ambiguity.

## 2. Backend Node Metadata Assembly

- [x] 2.1 Add a helper in `LineageService` that deterministically maps each result node to its current lineage field, with the query target taking precedence.
- [x] 2.2 Resolve the selected field against `LineageQueryIndex.table_by_full` and table `columns`, preserving the original `data_type` string.
- [x] 2.3 Extend `_assemble_result()` / `_build_nodes()` to emit the optional `field: {name, data_type}` object independently of `include_fields`.
- [x] 2.4 Confirm query caching, node limits, edge deduplication, and node-detail lazy loading continue to behave as before.

## 3. Graph And Detail Rendering

- [x] 3.1 Add shared field-label formatting in `static/js/lineage-graph.js`, preferring `node.field` and falling back to the existing edge/mapping lookup for legacy responses.
- [x] 3.2 Render field name plus complete type declaration on each applicable node, with safe truncation and an SVG `title` containing the full value.
- [x] 3.3 Pass the node field object to `showInfoPanel()` and update `static/js/detail-panel.js` to display the same type while remaining compatible with the old string argument.
- [x] 3.4 Adjust node dimensions, spacing, or text styling only as needed to prevent overlap with the layer badge at supported viewport sizes.
- [x] 3.5 Update the query graph static resource version in `static/index.html` so browsers load the new renderer.

## 4. Frontend And Integration Verification

- [x] 4.1 Add focused frontend tests for `VARCHAR2(60)`, `NUMBER(18,2)`, `DATE`, empty type, long-label tooltip, and legacy response rendering.
- [x] 4.2 Update `tests/frontend_e2e_test.py` to assert a visible node field type and the matching node detail text for a representative lineage query.
- [x] 4.3 Run `python -m pytest` for the affected service/API/frontend tests, then run the full `python -m pytest tests/` suite.
- [ ] 4.4 Start the application and verify in the browser that target, upstream, downstream, missing-DDL, zoomed, and narrow-layout nodes remain readable and clickable.
