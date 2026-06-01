"""
GraphConverter: transforms FieldLineageChain lists into graph representations.
Extracted from LineageTracer for SRP.
"""

from __future__ import annotations

from core.models import FieldLineageChain


class GraphConverter:
    """Converts lineage chains into node sets, edge lists, and mapping lists."""

    @staticmethod
    def to_graph(
        chains: list[FieldLineageChain],
        direction: str = "upstream",
    ) -> tuple[set[str], list[dict], list[dict]]:
        """Convert chains to graph elements.

        Returns:
            (node_names, edges, mappings) tuple.
        """
        node_names: set[str] = set()
        edges: list[dict] = []
        mappings: list[dict] = []
        seen_edges: set[tuple] = set()
        seen_mappings: set[tuple] = set()

        for chain in chains:
            for i, node in enumerate(chain.chain):
                node_names.add(node.table_name)

                if i > 0:
                    prev_node = chain.chain[i - 1]

                    if direction == "upstream":
                        src_table = prev_node.table_name
                        tgt_table = node.table_name
                        src_field = prev_node.field_name
                        tgt_field = node.field_name
                    else:
                        src_table = prev_node.table_name
                        tgt_table = node.table_name
                        src_field = prev_node.field_name
                        tgt_field = node.field_name

                    edge_key = (src_table, tgt_table, src_field, tgt_field)
                    if edge_key not in seen_edges:
                        seen_edges.add(edge_key)
                        edges.append(
                            {
                                "source_table": src_table,
                                "target_table": tgt_table,
                                "source_field": src_field,
                                "target_field": tgt_field,
                                "type": "field_mapping",
                            }
                        )

                    edge_procedure = prev_node.procedure if direction == "upstream" else node.procedure
                    edge_transform = prev_node.transform_logic if direction == "upstream" else node.transform_logic

                    mapping_key = (src_table, src_field, tgt_table, tgt_field)
                    if mapping_key not in seen_mappings:
                        seen_mappings.add(mapping_key)
                        mappings.append(
                            {
                                "source_table": src_table,
                                "source_column": src_field,
                                "target_table": tgt_table,
                                "target_column": tgt_field,
                                "transform_logic": edge_transform,
                                "procedure": edge_procedure,
                            }
                        )

        return node_names, edges, mappings
