"""
表级血缘追溯器
负责图预处理（邻接表构建）和表级 BFS 追溯。
从 LineageService 中提取，实现单一职责。
"""

from __future__ import annotations

import logging
from typing import Any

from core.table_name_resolver import TableNameResolver

logger = logging.getLogger(__name__)


class TableLineageTracer:
    """表级血缘追溯器。

    职责：
      - 构建上游/下游邻接表
      - 执行表级 BFS 追溯
      - 短名解析（委托给 TableNameResolver）
    """

    def __init__(self, resolver: TableNameResolver):
        self._resolver = resolver
        self._adjacency_up: dict[str, set[str]] = {}
        self._adjacency_down: dict[str, set[str]] = {}

    @property
    def adjacency_up(self) -> dict[str, set[str]]:
        return self._adjacency_up

    @property
    def adjacency_down(self) -> dict[str, set[str]]:
        return self._adjacency_down

    def build_graph(self, lineages: list[dict]) -> None:
        """从表级血缘数据构建邻接表。"""
        self._adjacency_up.clear()
        self._adjacency_down.clear()

        for lineage in lineages:
            src = lineage.get("source_table", "").upper()
            tgt = lineage.get("target_table", "").upper()

            if not src or not tgt:
                continue

            self._adjacency_up.setdefault(tgt, set()).add(src)
            self._adjacency_down.setdefault(src, set()).add(tgt)

        node_count = len(set(list(self._adjacency_up.keys()) + list(self._adjacency_down.keys())))
        edge_count = sum(len(v) for v in self._adjacency_up.values())
        logger.info("图预处理完成: %d 个节点, %d 条边", node_count, edge_count)

    def clear(self) -> None:
        self._adjacency_up.clear()
        self._adjacency_down.clear()

    def trace(
        self,
        start_table: str,
        data: dict,
        max_depth: int,
        direction: str = "up",
    ) -> tuple[set[str], list[dict]]:
        """追踪表级血缘关系（BFS）。

        Args:
            start_table: 起始表名（支持短名）
            data: 数据字典（用于短名解析）
            max_depth: 最大追溯深度
            direction: "up" 上游 / "down" 下游

        Returns:
            (节点集合, 边列表)
        """
        resolved_start = self.resolve_table_name(start_table, data)
        visited: set[str] = {resolved_start}
        edges: list[dict] = []
        queue: list[tuple[str, int]] = [(resolved_start, 0)]

        adjacency = self._adjacency_up if direction == "up" else self._adjacency_down

        while queue:
            current, depth = queue.pop(0)

            if depth >= max_depth:
                continue

            for neighbor in adjacency.get(current, set()):
                if neighbor not in visited:
                    visited.add(neighbor)
                    queue.append((neighbor, depth + 1))

                    if neighbor == current:
                        continue

                    if direction == "up":
                        edges.append({
                            "source_table": neighbor,
                            "target_table": current,
                        })
                    else:
                        edges.append({
                            "source_table": current,
                            "target_table": neighbor,
                        })

        return visited, edges

    def resolve_table_name(self, table_name: str, data: dict) -> str:
        """将短名或部分表名解析为完整表名。"""
        table_upper = table_name.upper()

        if table_upper in self._adjacency_up or table_upper in self._adjacency_down:
            return table_upper

        candidates: list[str] = []
        all_keys = set(list(self._adjacency_up.keys()) + list(self._adjacency_down.keys()))

        for full_name in all_keys:
            if full_name.upper() == table_upper:
                return full_name
            if full_name.upper().endswith("." + table_upper):
                candidates.append(full_name)

        if candidates:
            return min(candidates, key=len)

        for t in data.get("tables", []):
            full = t.get("full_name", "")
            short = t.get("table_name", "")
            if full.upper() == table_upper or short.upper() == table_upper:
                return full

        return table_name
