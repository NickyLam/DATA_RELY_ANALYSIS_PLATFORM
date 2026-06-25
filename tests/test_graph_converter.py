"""Tests for GraphConverter.to_graph direction semantics.

The `direction` parameter only affects which node's procedure/transform_logic
is attached to each edge. Source/target table/field assignment is always
determined by chain order (prev_node → node), regardless of direction.
"""

from __future__ import annotations

from core.lineage.graph_converter import GraphConverter
from core.models import FieldLineageChain, FieldLineageNode


def _make_node(table: str, field: str, procedure: str = "", transform_logic: str = "") -> FieldLineageNode:
    return FieldLineageNode(
        layer=0,
        table_name=table,
        field_name=field,
        procedure=procedure,
        transform_logic=transform_logic,
        source_fields=[],
        is_temp=False,
        layer_type="base",
    )


def test_upstream_procedure_from_prev_node():
    """Upstream: procedure and transform_logic should come from prev_node (source)."""
    chain = FieldLineageChain(
        target_table="TGT.TABLE_C",
        target_field="COL_C",
        chain=[
            _make_node("SRC.TABLE_A", "COL_A", "PROC_A", "logic_a"),
            _make_node("MID.TABLE_B", "COL_B", "PROC_B", "logic_b"),
            _make_node("TGT.TABLE_C", "COL_C", "", "(target)"),
        ],
        depth=2,
    )
    nodes, edges, mappings = GraphConverter.to_graph([chain], direction="upstream")

    assert len(edges) == 2
    assert len(mappings) == 2

    # Edge 1: TABLE_A → TABLE_B — procedure from prev_node (PROC_A)
    assert mappings[0]["procedure"] == "PROC_A"
    assert mappings[0]["transform_logic"] == "logic_a"
    assert mappings[0]["source_table"] == "SRC.TABLE_A"
    assert mappings[0]["target_table"] == "MID.TABLE_B"

    # Edge 2: TABLE_B → TABLE_C — procedure from prev_node (PROC_B)
    assert mappings[1]["procedure"] == "PROC_B"
    assert mappings[1]["transform_logic"] == "logic_b"


def test_downstream_procedure_from_node():
    """Downstream: procedure and transform_logic should come from node (target)."""
    chain = FieldLineageChain(
        target_table="SRC.TABLE_A",
        target_field="COL_A",
        chain=[
            _make_node("TGT.TABLE_C", "COL_C", "", "(source)"),
            _make_node("MID.TABLE_B", "COL_B", "PROC_B", "logic_b"),
            _make_node("SRC.TABLE_A", "COL_A", "PROC_A", "logic_a"),
        ],
        depth=2,
    )
    nodes, edges, mappings = GraphConverter.to_graph([chain], direction="downstream")

    assert len(edges) == 2
    assert len(mappings) == 2

    # Edge 1: TABLE_C → TABLE_B — procedure from node (PROC_B)
    assert mappings[0]["procedure"] == "PROC_B"
    assert mappings[0]["transform_logic"] == "logic_b"

    # Edge 2: TABLE_B → TABLE_A — procedure from node (PROC_A)
    assert mappings[1]["procedure"] == "PROC_A"
    assert mappings[1]["transform_logic"] == "logic_a"


def test_source_target_same_regardless_of_direction():
    """Source/target assignment is determined by chain order, not direction."""
    chain = FieldLineageChain(
        target_table="TGT.TABLE_B",
        target_field="COL_B",
        chain=[
            _make_node("SRC.TABLE_A", "COL_A", "PROC_UP", "up_logic"),
            _make_node("TGT.TABLE_B", "COL_B", "PROC_DOWN", "down_logic"),
        ],
        depth=1,
    )

    _, edges_up, mappings_up = GraphConverter.to_graph([chain], direction="upstream")
    _, edges_down, mappings_down = GraphConverter.to_graph([chain], direction="downstream")

    # Source/target must be identical
    assert edges_up[0]["source_table"] == edges_down[0]["source_table"] == "SRC.TABLE_A"
    assert edges_up[0]["target_table"] == edges_down[0]["target_table"] == "TGT.TABLE_B"
    assert edges_up[0]["source_field"] == edges_down[0]["source_field"] == "COL_A"
    assert edges_up[0]["target_field"] == edges_down[0]["target_field"] == "COL_B"

    # But procedure/transform differ
    assert mappings_up[0]["procedure"] == "PROC_UP"
    assert mappings_down[0]["procedure"] == "PROC_DOWN"


def test_empty_chains():
    """Empty chains produce empty results."""
    nodes, edges, mappings = GraphConverter.to_graph([], direction="upstream")
    assert nodes == set()
    assert edges == []
    assert mappings == []
