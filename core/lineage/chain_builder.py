"""
ChainBuilder: converts BFS tree dicts into FieldLineageChain lists.
Extracted from LineageTracer for SRP.
"""

from __future__ import annotations

from collections.abc import Callable

from core.layer_detector import detect_layer
from core.models import FieldLineageChain, FieldLineageNode


class _BFSNode:
    """Mirror of the BFS node used in LineageTracer."""

    __slots__ = ("table_name", "field_name", "layer", "procedure", "transform_logic", "parent_key")

    def __init__(self, *, table_name, field_name, layer, procedure, transform_logic, parent_key):
        self.table_name = table_name
        self.field_name = field_name
        self.layer = layer
        self.procedure = procedure
        self.transform_logic = transform_logic
        self.parent_key = parent_key


class ChainBuilder:
    """Converts a BFS tree dict into a list of FieldLineageChain objects."""

    @staticmethod
    def build_chains(
        bfs_tree: dict,
        target: tuple[str, str],
        reverse: bool = False,
        is_temp_fn: Callable[[str], bool] = lambda _: False,
    ) -> list[FieldLineageChain]:
        """Build lineage chains from a BFS tree.

        Args:
            bfs_tree: dict mapping "TABLE.FIELD" keys to BFS node objects.
            target: (table_name, field_name) tuple of the root node.
            reverse: If True, reverse the chain order (for downstream traces).
            is_temp_fn: Callable to detect temporary tables.

        Returns:
            List of FieldLineageChain sorted by depth (deepest first).
        """
        if not bfs_tree:
            return []

        root_key = f"{target[0]}.{target[1]}"
        if root_key not in bfs_tree:
            return []

        non_leaf_keys: set[str] = {n.parent_key for n in bfs_tree.values() if n.parent_key}
        leaf_keys = [k for k in bfs_tree if k != root_key and k not in non_leaf_keys]

        if not leaf_keys:
            leaf_keys = [root_key]

        chains: list[FieldLineageChain] = []
        seen_chains: set[str] = set()

        for leaf_key in leaf_keys:
            path: list[str] = []
            current_key = leaf_key

            while current_key:
                path.append(current_key)
                node = bfs_tree.get(current_key)
                if node is None:
                    break
                current_key = node.parent_key

            if reverse:
                path = path[::-1]

            chain_id = "\u2192".join(path)
            if chain_id in seen_chains:
                continue
            seen_chains.add(chain_id)

            chain_nodes: list[FieldLineageNode] = []
            for i, node_key in enumerate(path):
                node = bfs_tree[node_key]
                is_temp = is_temp_fn(node.table_name)
                layer_type_str = detect_layer(node.table_name).value

                source_fields_for_node: list[str] = []
                parent_keys = [k for k, n in bfs_tree.items() if n.parent_key == node_key]
                for pk in parent_keys:
                    parent_node = bfs_tree[pk]
                    source_fields_for_node.append(f"{parent_node.table_name}.{parent_node.field_name}")

                fl_node = FieldLineageNode(
                    layer=i,
                    table_name=node.table_name,
                    field_name=node.field_name,
                    procedure=node.procedure,
                    transform_logic=node.transform_logic,
                    source_fields=source_fields_for_node,
                    is_temp=is_temp,
                    layer_type=layer_type_str,
                )
                chain_nodes.append(fl_node)

            chain = FieldLineageChain(
                target_table=target[0],
                target_field=target[1],
                chain=chain_nodes,
                depth=len(chain_nodes) - 1,
            )
            chains.append(chain)

        chains.sort(key=lambda c: c.depth, reverse=True)
        return chains
