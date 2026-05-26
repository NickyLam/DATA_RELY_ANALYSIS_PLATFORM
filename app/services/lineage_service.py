"""
血缘查询服务
封装血缘追踪逻辑，集成性能优化（索引缓存、图预处理）
"""

from __future__ import annotations

import logging
import time
from typing import Any, Optional

from app.services.parser_service import ParserService
from app.services.table_lineage_tracer import TableLineageTracer
from app.services.event_bus import EventType, get_event_bus
from app.utils.cache_manager import CacheManager
from app.repository import search_table_dicts
from core.table_name_resolver import TableNameResolver

logger = logging.getLogger(__name__)


class LineageService:
    """数据血缘查询服务（性能优化版）"""

    def __init__(
        self,
        parser_service: ParserService,
        cache_manager: CacheManager,
    ):
        self.parser = parser_service
        self.cache = cache_manager

        self._resolver = TableNameResolver()
        self._table_tracer = TableLineageTracer(self._resolver)
        self._transitive_cache: dict[tuple, set] = {}
        self._last_data_mtime: float = 0

        self._event_bus = get_event_bus()
        self._event_bus.subscribe(EventType.DATA_CHANGED, self._on_data_changed)
        self._event_bus.subscribe(EventType.CACHE_INVALIDATED, self._on_cache_invalidated)

        self._build_indexes()

    def _build_indexes(self) -> None:
        """启动时构建内存索引和图预处理数据"""
        data = self.parser.get_current_data()
        if not data:
            logger.warning("无可用数据，跳过索引构建")
            return

        tables = data.get("tables", [])
        procedures = data.get("procedures", [])

        self.cache.build_index(tables, procedures)
        self._table_tracer.build_graph(data.get("table_lineages", []))
        logger.info("血缘服务索引构建完成")

    def _on_data_changed(self, **kwargs) -> None:
        self._build_indexes()
        self._transitive_cache.clear()

    def _on_cache_invalidated(self, **kwargs) -> None:
        self._build_indexes()
        self._transitive_cache.clear()
        self.cache.clear()

    def query_lineage(
        self,
        table: str,
        field: Optional[str] = None,
        depth: int = 3,
        mode: str = "both",
        include_fields: bool = True,
        limit: int = 1000,
        use_cache: bool = True,
    ) -> dict[str, Any]:
        start_time = time.perf_counter()
        self._check_and_refresh_cache()

        cache_key = None
        if use_cache:
            cache_key = self._generate_cache_key(table, field, depth, mode)
            cached = self.cache.get(cache_key)
            if cached:
                cached["query_time_ms"] = round((time.perf_counter() - start_time) * 1000, 2)
                cached["cache_hit"] = True
                return cached

        data = self.parser.get_current_data()
        if not data:
            return self._empty_result(start_time)

        table_upper = table.upper().strip()
        field_upper = field.upper().strip() if field else None
        resolved_table = self._table_tracer.resolve_table_name(table_upper, data)

        if not self._validate_schema(table_upper, resolved_table, data):
            return self._empty_result(start_time)

        if field_upper:
            result = self._query_field_lineage(resolved_table, field_upper, depth, mode, data, include_fields, limit)
        else:
            result = self._query_table_lineage(resolved_table, depth, mode, data, include_fields, field_upper, limit)

        if result.get("nodes_count", 0) == 0 and "." in resolved_table:
            alt_table = self._find_alternate_schema_table(resolved_table, data)
            if alt_table:
                logger.info("同名表重定向: %s → %s", resolved_table, alt_table)
                if field_upper:
                    result = self._query_field_lineage(alt_table, field_upper, depth, mode, data, include_fields, limit)
                else:
                    result = self._query_table_lineage(alt_table, depth, mode, data, include_fields, field_upper, limit)
                if result.get("nodes_count", 0) > 0:
                    result["redirected_from"] = resolved_table
                    result["resolved_table"] = alt_table

        result["query_time_ms"] = round((time.perf_counter() - start_time) * 1000, 2)
        if cache_key:
            self.cache.set(cache_key, result)
        return result

    def _find_alternate_schema_table(self, resolved_table: str, data: dict) -> Optional[str]:
        if "." not in resolved_table:
            return None
        schema, short_name = resolved_table.rsplit(".", 1)

        _SCHEMA_REDIRECT = {
            "RRP_MDL": "RRP_EAST",
            "RRP_EAST": "RRP_MDL",
        }
        alt_schema = _SCHEMA_REDIRECT.get(schema.upper())
        if not alt_schema:
            return None

        alt_full = f"{alt_schema}.{short_name}"
        actual_tables = {t.get("full_name", "").upper() for t in data.get("tables", [])}
        if alt_full.upper() in actual_tables:
            return alt_full
        return None

    def _validate_schema(self, table_upper: str, resolved_table: str, data: dict) -> bool:
        if "." in table_upper:
            parts = table_upper.split(".")
            if len(parts) == 2:
                schema, table_short = parts
                if table_short.startswith("EAST5_") and schema != "RRP_EAST":
                    logger.info("EAST5_ 表自动重定向: %s → RRP_EAST.%s", table_upper, table_short)
                    return True
            actual_tables = {t.get("full_name", "").upper() for t in data.get("tables", [])}
            if resolved_table.upper() not in actual_tables:
                logger.warning("显式 schema 表不存在: 输入=%s, 解析=%s", table_upper, resolved_table)
                return False
        return True

    def _query_field_lineage(
        self, table: str, field: str, depth: int,
        mode: str, data: dict, include_fields: bool, limit: int,
    ) -> dict[str, Any]:
        all_nodes, all_edges, all_mappings = set(), [], []
        tracer = self.parser.get_lineage_tracer()
        if tracer:
            self._trace_field_with_tracer(tracer, table, field, depth, mode, all_nodes, all_edges, all_mappings)
        else:
            self._trace_field_legacy(table, field, depth, mode, data, all_nodes, all_edges, all_mappings)
        if len(all_nodes) < 3:
            self._supplement_table_lineage(table, mode, data, all_nodes, all_edges)
        if include_fields:
            self._supplement_field_mappings(data, all_nodes, all_mappings, table, field)
        return self._assemble_result(all_nodes, all_edges, all_mappings, data, include_fields, table, field, limit)

    def _trace_field_with_tracer(
        self, tracer, table: str, field: str, depth: int,
        mode: str, all_nodes: set, all_edges: list, all_mappings: list,
    ) -> None:
        if mode in ("upstream", "both"):
            up_chains = tracer.trace_field_upstream(table, field, depth)
            up_nodes, up_edges, up_mappings = tracer.to_graph_result(up_chains, direction="upstream")
            all_nodes.update(up_nodes)
            all_edges.extend(up_edges)
            all_mappings.extend(up_mappings)
        if mode in ("downstream", "both"):
            down_chains = tracer.trace_field_downstream(table, field, depth)
            down_nodes, down_edges, down_mappings = tracer.to_graph_result(down_chains, direction="downstream")
            all_nodes.update(down_nodes)
            all_edges.extend(down_edges)
            all_mappings.extend(down_mappings)

    def _trace_field_legacy(
        self, table: str, field: str, depth: int,
        mode: str, data: dict, all_nodes: set, all_edges: list, all_mappings: list,
    ) -> None:
        logger.warning("LineageTracer 不可用，回退到旧版字段级追溯")
        if mode in ("upstream", "both"):
            up_nodes, up_edges, up_mappings = self._trace_field_lineage(
                target_table=table, target_field=field,
                all_field_mappings=data.get("field_mappings", []),
                max_depth=depth, direction="upstream",
            )
            all_nodes.update(up_nodes)
            all_edges.extend(up_edges)
            all_mappings.extend(up_mappings)
        if mode in ("downstream", "both"):
            down_nodes, down_edges, down_mappings = self._trace_field_lineage(
                target_table=table, target_field=field,
                all_field_mappings=data.get("field_mappings", []),
                max_depth=depth, direction="downstream",
            )
            all_nodes.update(down_nodes)
            all_edges.extend(down_edges)
            all_mappings.extend(down_mappings)

    def _supplement_table_lineage(
        self, table: str, mode: str, data: dict,
        all_nodes: set, all_edges: list,
    ) -> None:
        logger.info("字段级血缘节点过少(%d个)，补充1层直接表级血缘", len(all_nodes))
        if mode in ("upstream", "both"):
            up_nodes_tbl, up_edges_tbl = self._table_tracer.trace(table, data, max_depth=1, direction="up")
            for node in up_nodes_tbl:
                if node not in all_nodes:
                    all_nodes.add(node)
            for edge in up_edges_tbl:
                if edge not in all_edges:
                    if edge["source_table"] in all_nodes and edge["target_table"] in all_nodes:
                        all_edges.append(edge)
        if mode in ("downstream", "both"):
            down_nodes_tbl, down_edges_tbl = self._table_tracer.trace(table, data, max_depth=1, direction="down")
            for node in down_nodes_tbl:
                if node not in all_nodes:
                    all_nodes.add(node)
            for edge in down_edges_tbl:
                if edge not in all_edges:
                    if edge["source_table"] in all_nodes and edge["target_table"] in all_nodes:
                        all_edges.append(edge)

    def _supplement_field_mappings(
        self, data: dict, all_nodes: set, all_mappings: list,
        table: str, field: str,
    ) -> None:
        """补充 tracer 产出的映射中缺少 procedure 信息的版本。

        只补充与已有映射具有相同 (src_bare, src_col, tgt_bare, tgt_col) 的映射，
        不引入图节点范围外的新映射。
        """
        existing_keys_4: set[tuple] = set()
        for m in all_mappings:
            src_bare = TableNameResolver.bare_table(m.get("source_table", "")).upper()
            tgt_bare = TableNameResolver.bare_table(m.get("target_table", "")).upper()
            existing_keys_4.add((
                src_bare,
                m.get("source_column", "").upper(),
                tgt_bare,
                m.get("target_column", "").upper(),
            ))

        node_full_by_bare: dict[str, str] = {}
        for n in all_nodes:
            bare = n.split(".")[-1].upper() if "." in n else n.upper()
            node_full_by_bare.setdefault(bare, n)

        candidates = self._filter_field_mappings(
            data.get("field_mappings", []),
            all_nodes,
            target_table=table,
            target_field=field,
        )

        seen_dedup = {self._field_mapping_dedup_key(m) for m in all_mappings}
        for fm in candidates:
            key4 = (
                TableNameResolver.bare_table(fm.get("source_table", "")).upper(),
                fm.get("source_column", "").upper(),
                TableNameResolver.bare_table(fm.get("target_table", "")).upper(),
                fm.get("target_column", "").upper(),
            )
            if key4 not in existing_keys_4:
                continue

            # Normalize short names to full names
            nf = dict(fm)
            for k in ("source_table", "target_table"):
                val = fm.get(k, "").upper()
                bare = val.split(".")[-1] if "." in val else val
                if bare in node_full_by_bare and val != node_full_by_bare[bare]:
                    nf[k] = node_full_by_bare[bare]

            dedup_key = self._field_mapping_dedup_key(nf)
            if dedup_key not in seen_dedup:
                seen_dedup.add(dedup_key)
                all_mappings.append(nf)

    def _query_table_lineage(
        self, table: str, depth: int,
        mode: str, data: dict, include_fields: bool,
        field: Optional[str], limit: int,
    ) -> dict[str, Any]:
        all_nodes, all_edges = set(), []
        if mode in ("upstream", "both"):
            up_nodes, up_edges = self._table_tracer.trace(table, data, depth, direction="up")
            all_nodes.update(up_nodes)
            all_edges.extend(up_edges)
        if mode in ("downstream", "both"):
            down_nodes, down_edges = self._table_tracer.trace(table, data, depth, direction="down")
            all_nodes.update(down_nodes)
            all_edges.extend(down_edges)
        all_mappings = []
        if field and include_fields:
            all_mappings = self._filter_field_mappings(
                data.get("field_mappings", []),
                all_nodes, target_table=table, target_field=field,
            )
        return self._assemble_result(all_nodes, all_edges, all_mappings, data, include_fields, table, field, limit)

    def _assemble_result(
        self, all_nodes: set, all_edges: list, all_mappings: list,
        data: dict, include_fields: bool, table: str,
        field: Optional[str], limit: int,
    ) -> dict[str, Any]:
        nodes_list = self._build_nodes(all_nodes, data, include_fields)
        edges_list = self._deduplicate_edges(all_edges)
        if field and len(nodes_list) > limit:
            nodes_list = self._prioritize_field_lineage_nodes(nodes_list, edges_list, table, field, limit)
        all_mappings = self._deduplicate_field_mappings(all_mappings)
        return {
            "nodes_count": len(nodes_list),
            "edges_count": len(edges_list),
            "nodes": nodes_list[:limit],
            "edges": edges_list[:limit * 3],
            "has_more": len(nodes_list) > limit or len(edges_list) > limit * 3,
            "cache_hit": False,
            "tables_involved": len(all_nodes),
            "max_depth_reached": 0,
            "query_target": {"table": table, "field": field},
            "field_mappings": all_mappings[:500] if all_mappings else [],
            "field_mapping_count": len(all_mappings),
        }

    def search_tables(
        self,
        keyword: str,
        limit: int = 50,
    ) -> list[dict]:
        """
        搜索表名（智能排序 - 精确匹配优先）

        排序优先级（从高到低）：
        1. 短名完全匹配（如 EAST5_201_GRJCXXB == EAST5_201_GRJCXXB）
        2. 全名以关键词结尾（如 RRP_MDL.EAST5_201_GRJCXXB）
        3. 包含匹配（如 T_COM_RRP_EAST_EAST5_201_GRJCXXB）

        Args:
            keyword: 搜索关键词
            limit: 返回数量限制

        Returns:
            list[dict]: 匹配的表信息列表（按相关度排序）
        """
        parser_search = getattr(self.parser, "search_tables", None)
        if callable(parser_search):
            return self._format_table_search_results(
                parser_search(keyword, limit=limit),
                limit,
            )

        data = self.parser.get_current_data()
        table_results = search_table_dicts(data.get("tables", []), keyword, limit) if data else []
        return self._format_table_search_results(table_results, limit)

    def _format_table_search_results(self, table_results: list[dict], limit: int) -> list[dict]:
        tables = []
        seen = set()

        for table_info in table_results[:limit]:
            name = table_info.get("full_name", "")
            if not name or name in seen:
                continue

            seen.add(name)
            short = table_info.get("table_name") or (name.split(".")[-1] if "." in name else name)
            columns = [
                column.get("name", "")
                for column in table_info.get("columns", [])
                if column.get("name")
            ]

            tables.append({
                "full_name": name,
                "short_name": short,
                "layer": self._detect_layer(name),
                "field_count": len(columns),
                "columns": columns if columns else None,
            })

        return tables

    def search_procedures(
        self,
        keyword: str,
        limit: int = 50,
    ) -> list[dict]:
        """搜索存储过程名称"""
        results = self.cache.search_by_keyword(keyword, index_type="procedure_name", limit=limit)

        procedures = []
        seen = set()
        for name in results[:limit]:
            if name not in seen:
                seen.add(name)
                short = name.split(".")[-1] if "." in name else name
                procedures.append({"full_name": name, "short_name": short})

        return procedures

    def get_edge_caliber(
        self,
        src_table: str,
        src_column: str,
        tgt_table: str,
        tgt_column: str,
        procedure: str = "",
    ) -> Optional[dict]:
        """懒加载单条边的口径详情，委托给 UnifiedTracer。"""
        tracer = self.parser.get_unified_tracer()
        if tracer is None:
            return None
        return tracer.get_edge_caliber(
            src_table, src_column, tgt_table, tgt_column, procedure
        )

    def get_node_detail(self, table: str) -> Optional[dict]:
        """懒加载节点详情（表字段 + 上下游 + 关联过程）。"""
        tracer = self.parser.get_unified_tracer()
        if tracer is None:
            return None
        return tracer.get_node_detail(table)

    def build_summary_card(
        self,
        table: str,
        field: str,
        direction: str = "upstream",
        depth: int = 10,
        data_source: Optional[str] = None,
    ) -> dict:
        """节点浮窗用的指标概览卡（P5 由 caliber_service 迁移而来）。"""
        from app.services.summary_card_builder import build_summary_card
        tracer = self.parser.get_unified_tracer()
        return build_summary_card(
            tracer, table, field,
            direction=direction, depth=depth, data_source=data_source,
        )

    def get_system_stats(self) -> dict[str, Any]:
        """获取系统统计信息"""
        data = self.parser.get_current_data()

        base_stats = {
            "total_tables": 0,
            "total_procedures": 0,
            "total_table_lineages": 0,
            "total_field_mappings": 0,
            "total_caliber_infos": 0,
            "cache_size": 0,
            "active_tasks": 0,
            "uptime_seconds": 0.0,
        }

        if data:
            metadata = data.get("metadata", {})
            base_stats.update({
                "total_tables": metadata.get("total_tables", 0),
                "total_procedures": metadata.get("total_procedures", 0),
                "total_table_lineages": metadata.get("total_table_lineages", 0),
                "total_field_mappings": metadata.get("total_field_mappings", 0),
                "total_caliber_infos": metadata.get("total_caliber_infos", 0),
            })

        base_stats["cache_size"] = self.cache.size

        return base_stats

    def rebuild_indexes(self) -> None:
        """强制重建所有索引"""
        logger.info("开始重建索引...")
        self.cache.clear()
        self._table_tracer.adjacency_up.clear()
        self._table_tracer.adjacency_down.clear()
        self._transitive_cache.clear()
        self._build_indexes()
        # 更新数据文件修改时间
        self._update_data_mtime()
        logger.info("索引重建完成")

    def _check_and_refresh_cache(self) -> None:
        """检查数据是否已更新，如果更新则自动清除缓存。

        兼容 SQLite 和 legacy 两种后端：
        - SQLite 模式: 从 DataRepository metadata 中读取 last_updated 时间戳
        - Legacy 模式: 从 lineage_data.json 文件 mtime 检测
        """
        current_mtime = self._get_data_mtime()
        if current_mtime is None:
            return

        if self._last_data_mtime == 0:
            # 首次加载，记录时间
            self._last_data_mtime = current_mtime
            return

        if current_mtime > self._last_data_mtime:
            logger.info(
                "检测到数据已更新 (%.2f > %.2f)，自动清除缓存",
                current_mtime,
                self._last_data_mtime,
            )
            self.cache.clear()
            self._table_tracer.adjacency_up.clear()
            self._table_tracer.adjacency_down.clear()
            self._transitive_cache.clear()
            self._build_indexes()
            self._last_data_mtime = current_mtime

    def _get_data_mtime(self) -> Optional[float]:
        """获取数据的最后更新时间戳。

        优先从 DataRepository metadata 读取，fallback 到 JSON 文件 mtime。
        """
        # 优先从 repository metadata 获取
        try:
            repo = self.parser._cache_store.get_repository()
            metadata = repo.get_metadata()
            last_updated_str = metadata.get("last_updated", "")
            if last_updated_str:
                from datetime import datetime
                dt = datetime.strptime(str(last_updated_str), "%Y-%m-%d %H:%M:%S")
                return dt.timestamp()
        except Exception:
            pass

        # Fallback: 检测 JSON 文件 mtime（legacy 模式）
        import os
        cache_file = self.parser.output_dir / "lineage_data.json"
        if cache_file.exists():
            return cache_file.stat().st_mtime

        return None

    def _update_data_mtime(self) -> None:
        """更新数据的最后修改时间。"""
        current = self._get_data_mtime()
        if current is not None:
            self._last_data_mtime = current

    def _trace_field_lineage(
        self,
        target_table: str,
        target_field: str,
        all_field_mappings: list[dict],
        max_depth: int = 5,
        direction: str = "both",
    ) -> tuple[set, list, list]:
        """
        基于字段映射递归追溯血缘关系（核心算法 - 增强版）

        策略升级：
        1. 先用字段映射做精确BFS（第1-2层）
        2. 对找到的所有节点，再用表级血缘扩展（第3-N层）
        3. 混合策略确保不会因为字段映射缺失而丢失血缘链路

        Args:
            target_table: 目标表名（如 RRP_MDL.EAST5_201_GRJCXXB）
            target_field: 目标字段名（如 KHXM）
            all_field_mappings: 全部字段映射列表
            max_depth: 最大追溯深度（默认5层）
            direction: 追溯方向 (upstream/downstream/both)

        Returns:
            tuple[set, list, list]: (节点集合, 边列表, 字段映射列表)
        """
        # 将短名解析为完整表名，确保节点和边中的表名统一
        resolved_target = TableNameResolver.resolve_from_mappings(target_table, all_field_mappings)
        visited_nodes = {resolved_target}
        edges = []
        collected_mappings = []

        # BFS 队列：(当前表, 当前字段, 当前深度)
        queue = [(resolved_target, target_field, 0)]
        
        # 硬限制：字段级查询最多返回50个节点，避免结果爆炸
        MAX_FIELD_NODES = 50

        # 构建映射索引：加速查询
        # target_map: {(target_table, target_column): [mappings]}
        # source_map: {(source_table, source_column): [mappings]}
        target_map = {}
        source_map = {}

        for fm in all_field_mappings:
            tgt_key = (
                fm.get("target_table", "").upper(),
                fm.get("target_column", "").upper(),
            )
            src_key = (
                fm.get("source_table", "").upper(),
                fm.get("source_column", "").upper(),
            )

            target_map.setdefault(tgt_key, []).append(fm)
            source_map.setdefault(src_key, []).append(fm)

        # 方案C：基于数据流向过滤
        # 核心思想：只保留与查询目标表在同一数据流中的映射
        # 实现方式：
        # 1. 从目标表出发，向上游追溯时，只保留"映射的目标表是目标表的祖先"的映射
        # 2. 这意味着我们只关心那些"最终到达目标表"的数据流
        # 3. 即：数据从映射的源表 -> 映射的目标表 -> ... -> 查询目标表

        # 预计算：构建表级血缘图，用于判断数据流方向
        # table_to_upstream: {table: set(upstream_tables)}
        # 即：对于每个表，记录哪些表是它的上游（数据从这些表流向它）
        table_to_upstream = {}
        for fm in all_field_mappings:
            src_tbl = fm.get("source_table", "").upper()
            tgt_tbl = fm.get("target_table", "").upper()
            if src_tbl and tgt_tbl:
                table_to_upstream.setdefault(tgt_tbl, set()).add(src_tbl)

        # 判断一个表是否在目标表的上游（即数据从该表流向目标表）
        def is_upstream_of_target(table: str) -> bool:
            """判断表是否在目标表的上游（数据从该表流向目标表）"""
            table_upper = table.upper()
            target_upper = resolved_target.upper()
            if table_upper == target_upper:
                return True
            # BFS检查该表是否能到达目标表（即该表是否在目标表的上游）
            visited = {table_upper}
            queue_bfs = [table_upper]
            while queue_bfs:
                current = queue_bfs.pop(0)
                for upstream in table_to_upstream.get(current, set()):
                    if upstream == target_upper:
                        return True
                    if upstream not in visited:
                        visited.add(upstream)
                        queue_bfs.append(upstream)
            return False

        # 判断一个映射是否与目标表在同一数据流中
        # 条件：映射的目标表必须在目标表的上游（包括目标表本身）
        # 即：映射的目标表是目标表的祖先，数据从映射的源表 -> 映射的目标表 -> ... -> 查询目标表
        def is_mapping_in_target_flow(fm: dict) -> bool:
            """判断映射是否与目标表在同一数据流中"""
            tgt_tbl = fm.get("target_table", "").upper()
            src_tbl = fm.get("source_table", "").upper()
            # 如果映射的目标表在目标表的上游，则认为在同一数据流
            # 这意味着数据从映射的源表 -> 映射的目标表 -> ... -> 查询目标表
            return is_upstream_of_target(tgt_tbl)

        while queue:
            current_table, current_field, depth = queue.pop(0)

            if depth >= max_depth:
                continue

            # ========== 向上游追溯（找来源）==========
            if direction in ("upstream", "both"):
                tgt_key = (current_table.upper(), current_field.upper())

                # 精确匹配
                matching_mappings = target_map.get(tgt_key, [])

                # 模糊匹配（处理表名短名、schema差异等）
                if not matching_mappings:
                    for key, mappings in target_map.items():
                        if self._resolver.match(key[0], current_table) and \
                           self._resolver.match_field(key[1], current_field):
                            matching_mappings.extend(mappings)

                for fm in matching_mappings:
                    # 硬限制：最多50个节点
                    if len(visited_nodes) >= MAX_FIELD_NODES:
                        logger.warning(
                            "字段级查询节点数达到上限(%d)，停止追溯",
                            MAX_FIELD_NODES,
                        )
                        break

                    # 方案C过滤：只保留与目标表在同一数据流中的映射
                    if not is_mapping_in_target_flow(fm):
                        continue  # 跳过不在目标数据流中的映射

                    src_tbl = fm.get("source_table", "").upper()
                    src_col = fm.get("source_column", "").upper()

                    if not src_tbl or not src_col:
                        continue

                    # 添加节点和边
                    if src_tbl not in visited_nodes:
                        visited_nodes.add(src_tbl)

                    edge = {
                        "source_table": src_tbl,
                        "target_table": current_table.upper(),
                        "source_field": src_col,
                        "target_field": current_field.upper(),
                        "type": "field_mapping",
                    }

                    if edge not in edges:
                        edges.append(edge)

                    if fm not in collected_mappings:
                        collected_mappings.append(fm)

                    # 继续向上追溯（从源表的源字段出发）
                    if depth + 1 < max_depth:
                        queue.append((src_tbl, src_col, depth + 1))

            # ========== 向下游追溯（找去向）==========
            if direction in ("downstream", "both"):
                src_key = (current_table.upper(), current_field.upper())

                # 精确匹配
                matching_mappings = source_map.get(src_key, [])

                # 模糊匹配
                if not matching_mappings:
                    for key, mappings in source_map.items():
                        if self._resolver.match(key[0], current_table) and \
                           self._resolver.match_field(key[1], current_field):
                            matching_mappings.extend(mappings)

                for fm in matching_mappings:
                    # 硬限制：最多50个节点
                    if len(visited_nodes) >= MAX_FIELD_NODES:
                        logger.warning(
                            "字段级查询节点数达到上限(%d)，停止追溯",
                            MAX_FIELD_NODES,
                        )
                        break

                    # 方案C过滤：只保留与目标表在同一数据流中的映射
                    if not is_mapping_in_target_flow(fm):
                        continue  # 跳过不在目标数据流中的映射

                    tgt_tbl = fm.get("target_table", "").upper()
                    tgt_col = fm.get("target_column", "").upper()

                    if not tgt_tbl or not tgt_col:
                        continue

                    if tgt_tbl not in visited_nodes:
                        visited_nodes.add(tgt_tbl)

                    edge = {
                        "source_table": current_table.upper(),
                        "target_table": tgt_tbl,
                        "source_field": current_field.upper(),
                        "target_field": tgt_col,
                        "type": "field_mapping",
                    }

                    if edge not in edges:
                        edges.append(edge)

                    if fm not in collected_mappings:
                        collected_mappings.append(fm)

                    # 继续向下追溯
                    if depth + 1 < max_depth:
                        queue.append((tgt_tbl, tgt_col, depth + 1))

        # ========== 表级血缘扩展（严格限制版）==========
        # 修复：字段级查询应只返回与字段相关的表，避免全量表级扩展导致结果爆炸
        # 策略：仅当字段映射找到的节点过少时，才进行有限的表级扩展
        
        if len(visited_nodes) < 3:
            # 字段映射节点过少，补充1层直接表级血缘
            logger.info(
                "字段映射节点过少(%d个)，补充1层直接表级血缘",
                len(visited_nodes),
            )
            
            if direction in ("downstream", "both"):
                table_queue = list(visited_nodes)
                table_visited = set(visited_nodes)
                
                while table_queue:
                    current = table_queue.pop(0)
                    downstream_tables = self._table_tracer.adjacency_down.get(current.upper(), set())
                    
                    for downstream_tbl in downstream_tables:
                        downstream_tbl_upper = downstream_tbl.upper()
                        if downstream_tbl_upper not in table_visited:
                            table_visited.add(downstream_tbl_upper)
                            edges.append({
                                "source_table": current.upper(),
                                "target_table": downstream_tbl_upper,
                                "source_field": "",
                                "target_field": "",
                                "type": "table_lineage",
                            })
                
                visited_nodes = table_visited
            
            if direction in ("upstream", "both"):
                table_queue = list(visited_nodes)
                table_visited = set(visited_nodes)
                
                while table_queue:
                    current = table_queue.pop(0)
                    upstream_tables = self._table_tracer.adjacency_up.get(current.upper(), set())
                    
                    for upstream_tbl in upstream_tables:
                        upstream_tbl_upper = upstream_tbl.upper()
                        if upstream_tbl_upper not in table_visited:
                            table_visited.add(upstream_tbl_upper)
                            edges.append({
                                "source_table": upstream_tbl_upper,
                                "target_table": current.upper(),
                                "source_field": "",
                                "target_field": "",
                                "type": "table_lineage",
                            })
                
                visited_nodes = table_visited
        else:
            logger.info(
                "字段映射已找到%d个节点，跳过表级扩展以避免结果膨胀",
                len(visited_nodes),
            )

        logger.info(
            "🔗 字段映射追溯结果: %s.%s → %d 节点, %d 边, %d 映射",
            target_table, target_field,
            len(visited_nodes), len(edges), len(collected_mappings),
        )

        return visited_nodes, edges, collected_mappings

    @staticmethod
    @staticmethod
    @staticmethod
    def _is_node_in_set(table_name: str, involved_nodes: set) -> bool:
        """检查表名是否在节点集合中（支持全名和短名匹配）。"""
        upper = table_name.upper()
        if upper in involved_nodes:
            return True
        bare = upper.split(".")[-1] if "." in upper else upper
        for node in involved_nodes:
            node_bare = node.split(".")[-1] if "." in node else node
            if node_bare == bare:
                return True
        return False

    @staticmethod
    def _filter_field_mappings(
        all_mappings: list[dict],
        involved_nodes: set,
        target_table: str = None,
        target_field: str = None,
    ) -> list[dict]:
        """过滤字段映射，只返回源和目标表都在图节点中的映射。

        核心约束：field_mappings 是图详情的补充，必须与图节点一致。
        只有一端在节点中的映射属于其他血缘路径，不应出现在当前图中。
        """
        filtered = []
        field_upper = (target_field or "").upper()

        for fm in all_mappings:
            src_tbl = fm.get("source_table", "").upper()
            tgt_tbl = fm.get("target_table", "").upper()
            src_col = fm.get("source_column", "").upper()
            tgt_col = fm.get("target_column", "").upper()

            src_in = LineageService._is_node_in_set(src_tbl, involved_nodes)
            tgt_in = LineageService._is_node_in_set(tgt_tbl, involved_nodes)

            # 源和目标都必须在图节点中
            if not (src_in and tgt_in):
                continue

            # 如果指定了字段，必须匹配
            if field_upper:
                if tgt_col == field_upper or field_upper in tgt_col or field_upper in src_col:
                    filtered.append(fm)
            else:
                filtered.append(fm)

        return filtered

    def _build_nodes(
        self,
        node_names: set,
        data: dict,
        include_fields: bool,
    ) -> list[dict]:
        """构建节点数据列表"""
        table_map = {t["full_name"]: t for t in data.get("tables", [])}

        nodes = []
        for name in sorted(node_names):
            table_info = table_map.get(name, {})
            node = {
                "id": name,
                "full_name": name,
                "short_name": name.split(".")[-1] if "." in name else name,
                "layer": self._detect_layer(name),
                "comment": table_info.get("comment", ""),
            }

            if include_fields and "columns" in table_info:
                node["columns"] = [c["name"] for c in table_info["columns"]]

            nodes.append(node)

        return nodes

    @staticmethod
    def _deduplicate_edges(edges: list[dict]) -> list[dict]:
        """去重边列表"""
        seen = set()
        unique_edges = []

        for edge in edges:
            key = (edge["source_table"], edge["target_table"])
            if key not in seen:
                seen.add(key)
                unique_edges.append(edge)

        return unique_edges

    @staticmethod
    def _field_mapping_dedup_key(mapping: dict) -> tuple:
        """生成字段映射归一化去重 key（消除 full name vs short name 差异）。

        Why: LineageTracer.to_graph_result() 产出 full name（如 "RRP_MDL.X"），
        而 data["field_mappings"] 可能是短名（"X"）。直接用原始 table name 比较
        会把同一逻辑映射当成两条不同记录。
        """
        src_bare = TableNameResolver.bare_table(mapping.get("source_table", "")).upper()
        tgt_bare = TableNameResolver.bare_table(mapping.get("target_table", "")).upper()
        proc_raw = mapping.get("procedure", "").upper()
        proc_bare = proc_raw.split(".")[-1] if "." in proc_raw else proc_raw
        return (
            src_bare,
            mapping.get("source_column", "").upper(),
            tgt_bare,
            mapping.get("target_column", "").upper(),
            proc_bare,
        )

    @classmethod
    def _deduplicate_field_mappings(cls, mappings: list[dict]) -> list[dict]:
        """按展示所需字段去重字段映射，保留首次出现顺序。"""
        seen = set()
        unique_mappings = []

        for mapping in mappings:
            key = cls._field_mapping_dedup_key(mapping)
            if key in seen:
                continue
            seen.add(key)
            unique_mappings.append(mapping)

        return unique_mappings

    @staticmethod
    def _detect_layer(table_name: str) -> str:
        """检测表所属层级 - 委托给统一的层级检测模块"""
        from core.layer_detector import detect_layer_str
        return detect_layer_str(table_name)

    @staticmethod
    def _prioritize_field_lineage_nodes(
        nodes: list[dict],
        edges: list[dict],
        target_table: str,
        target_field: str,
        limit: int,
    ) -> list[dict]:
        """字段级查询时优先排序节点，确保关键血缘节点不被截断。

        排序优先级：
        1. 目标表（查询起点）
        2. 字段级血缘路径上的节点（通过BFS计算距离）
        3. 其他节点（按字母顺序）
        """
        from collections import deque

        # 支持短名和完整名匹配
        target_upper = target_table.upper()

        def _is_target_table(table_name: str) -> bool:
            """检查表名是否匹配目标表（支持短名和完整名）"""
            name_upper = table_name.upper()
            return name_upper == target_upper or name_upper.endswith("." + target_upper)

        # 构建邻接表（无向图，用于BFS计算距离）
        adjacency: dict[str, set[str]] = {}
        for edge in edges:
            src = edge.get("source_table", "")
            tgt = edge.get("target_table", "")
            if src and tgt:
                adjacency.setdefault(src, set()).add(tgt)
                adjacency.setdefault(tgt, set()).add(src)

        # BFS计算每个节点到目标表的距离
        distances: dict[str, int] = {}
        queue = deque()

        # 找到目标表的实际名称（可能是短名或完整名）
        target_actual = None
        for node_name in adjacency:
            if _is_target_table(node_name):
                target_actual = node_name
                break

        if target_actual:
            distances[target_actual] = 0
            queue.append(target_actual)

            while queue:
                current = queue.popleft()
                current_dist = distances[current]
                for neighbor in adjacency.get(current, set()):
                    if neighbor not in distances:
                        distances[neighbor] = current_dist + 1
                        queue.append(neighbor)

        def sort_key(node: dict) -> tuple:
            node_id = node.get("id", "")
            if _is_target_table(node_id):
                return (0, 0, node_id)  # 目标表最优先
            dist = distances.get(node_id, 9999)
            return (1, dist, node_id)  # 按距离排序，距离越近越优先

        return sorted(nodes, key=sort_key)

    @staticmethod
    def _generate_cache_key(
        table: str,
        field: Optional[str],
        depth: int,
        mode: str,
    ) -> str:
        """生成缓存键"""
        parts = [table.upper(), str(depth), mode]
        if field:
            parts.append(field.upper())
        return ":".join(parts)

    @staticmethod
    def _empty_result(start_time: float) -> dict:
        """返回空结果"""
        return {
            "query_time_ms": round((time.perf_counter() - start_time) * 1000, 2),
            "nodes_count": 0,
            "edges_count": 0,
            "nodes": [],
            "edges": [],
            "has_more": False,
            "cache_hit": False,
        }
