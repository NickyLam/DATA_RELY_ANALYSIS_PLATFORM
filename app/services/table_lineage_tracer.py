"""
表级血缘追溯器
负责图预处理（邻接表构建）和表级 BFS 追溯。
从 LineageService 中提取，实现单一职责。
"""

from __future__ import annotations

import logging
from typing import TYPE_CHECKING

from core.table_name_resolver import TableNameResolver

if TYPE_CHECKING:
    from app.services.lineage_query_index import LineageQueryIndex

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
        query_index: LineageQueryIndex | None = None,
    ) -> tuple[set[str], list[dict]]:
        """追踪表级血缘关系（BFS）。

        Args:
            start_table: 起始表名（支持短名）
            data: 数据字典（用于短名解析，当 query_index 为 None 时使用）
            max_depth: 最大追溯深度
            direction: "up" 上游 / "down" 下游
            query_index: 可选的预构建查询索引，存在时替代每次扫描 data["tables"]

        Returns:
            (节点集合, 边列表)
        """
        from core.layer_detector import detect_layer_str

        # 使用索引解析表名，避免每次重建 actual_tables_by_full/short
        if query_index is not None and query_index.is_built:
            adjacency_keys = set(self._adjacency_up.keys()) | set(self._adjacency_down.keys())
            resolved_start = query_index.resolve_table_name(start_table, adjacency_keys)
        else:
            resolved_start = self.resolve_table_name(start_table, data)

        start_layer = detect_layer_str(resolved_start)
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
                    # 层级兼容性过滤：过滤掉 ICL 分支
                    neighbor_layer = detect_layer_str(neighbor)
                    if start_layer == "east" and neighbor_layer in ("other",):
                        # 对于 OTHER 层，检查是否是 ICL 相关表
                        neighbor_upper = neighbor.upper()
                        bare = self._resolver.bare_table(neighbor_upper)
                        if bare.startswith("ICL_") or neighbor_upper.startswith("ICL."):
                            continue
                    if start_layer == "east" and neighbor_layer in ("ods", "diis"):
                        continue

                    visited.add(neighbor)
                    queue.append((neighbor, depth + 1))

                    if neighbor == current:
                        continue

                    if direction == "up":
                        edges.append(
                            {
                                "source_table": neighbor,
                                "target_table": current,
                            }
                        )
                    else:
                        edges.append(
                            {
                                "source_table": current,
                                "target_table": neighbor,
                            }
                        )

        return visited, edges

    def resolve_table_name(self, table_name: str, data: dict) -> str:
        """将短名或部分表名解析为完整表名。

        解析策略（按优先级）：
          0. 实际表定义精确匹配（权威来源优先）
          1. 显式 schema 严格校验：用户输入带 schema 前缀时，必须匹配实际表定义
          2. 短名邻接表匹配：无 schema 时，在邻接表中查找实际存在的表
          3. 短名智能解析：按业务规则排序候选表
        """
        table_upper = table_name.upper().strip()
        if not table_upper:
            return table_name

        # ---- 步骤0: 优先从实际表定义中查找（权威来源）----
        # 构建实际表定义的索引，用于严格校验
        actual_tables_by_full: dict[str, dict] = {}
        actual_tables_by_short: dict[str, dict] = {}
        for t in data.get("tables", []):
            full = t.get("full_name", "").upper()
            short = t.get("table_name", "").upper()
            if full:
                actual_tables_by_full[full] = t
            if short:
                actual_tables_by_short[short] = t

        # 精确匹配实际表定义（全名或短名）
        if table_upper in actual_tables_by_full:
            return actual_tables_by_full[table_upper].get("full_name", table_name)
        if table_upper in actual_tables_by_short:
            return actual_tables_by_short[table_upper].get("full_name", table_name)

        # ---- 步骤1: 显式 schema 前缀的严格校验 ----
        if "." in table_upper:
            return table_name

        # ---- 步骤3: 短名模糊匹配（无 schema 前缀）----
        candidates: list[str] = []
        all_keys = set(list(self._adjacency_up.keys()) + list(self._adjacency_down.keys()))

        for full_name in all_keys:
            if full_name.upper().endswith("." + table_upper):
                candidates.append(full_name)

        if not candidates:
            return table_name

        # 3a) 优先选择在实际表定义中真实存在的候选
        real_candidates = [c for c in candidates if c.upper() in actual_tables_by_full]

        if real_candidates:
            # 3b) 业务规则：EAST5_ 表优先匹配 RRP_EAST schema
            if table_upper.startswith("EAST5_"):
                east_candidates = [c for c in real_candidates if c.upper().startswith("RRP_EAST.")]
                if east_candidates:
                    return east_candidates[0]

            # 3c) 多个真实候选时，按 schema 优先级排序（而非简单取最短）
            schema_priority = {"RRP_EAST.": 0, "RRP_MDL.": 1, "ICL.": 2}

            def _schema_sort_key(c: str) -> tuple:
                c_upper = c.upper()
                for prefix, priority in schema_priority.items():
                    if c_upper.startswith(prefix):
                        return (priority, len(c))
                return (99, len(c))

            real_candidates.sort(key=_schema_sort_key)
            return real_candidates[0]

        # 3d) 无真实表候选时，回退到邻接表候选（最短匹配）
        return min(candidates, key=len)
