"""
血缘查询服务
封装血缘追踪逻辑，集成性能优化（索引缓存、图预处理）
"""

from __future__ import annotations

import copy
import logging
import time
from collections import deque
from collections.abc import Callable
from typing import Any

from app.repository import search_table_dicts
from app.services.event_bus import DataChangedEvent, EventType, get_event_bus
from app.services.lineage_query_index import LineageQueryIndex
from app.services.parser_service import ParserService
from app.services.table_lineage_tracer import TableLineageTracer
from app.utils.cache_manager import CacheManager
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
        self._index = LineageQueryIndex()  # 预构建查询索引，避免每次查询重建全量 map/set
        self._transitive_cache: dict[tuple, set] = {}
        self._last_data_mtime: float = 0
        self._index_generation: int | None = None

        self._event_bus = get_event_bus()
        self._event_bus.subscribe(EventType.DATA_CHANGED, self._on_data_changed)
        self._event_bus.subscribe(EventType.CACHE_INVALIDATED, self._on_cache_invalidated)

        self._build_indexes(generation=getattr(self.parser, "data_generation", None))

    def _build_indexes(self, generation: int | None = None) -> None:
        """启动时构建内存索引和图预处理数据"""
        data = self.parser.get_current_data()
        if not data:
            logger.warning("无可用数据，跳过索引构建")
            return

        tables = data.get("tables", [])
        procedures = data.get("procedures", [])

        self.cache.build_index(tables, procedures)
        self._table_tracer.build_graph(data.get("table_lineages", []))
        self._index.build(data)  # 构建查询索引
        self._index_generation = generation
        logger.info("血缘服务索引构建完成")

    def _on_data_changed(
        self,
        event: DataChangedEvent | None = None,
        generation: int | None = None,
        **kwargs,
    ) -> None:
        next_generation = event.generation if event is not None else generation
        if next_generation is not None and next_generation == self._index_generation:
            return
        self.cache.clear()
        self._table_tracer.adjacency_up.clear()
        self._table_tracer.adjacency_down.clear()
        self._transitive_cache.clear()
        self._build_indexes(generation=next_generation)

    def _on_cache_invalidated(self, **kwargs) -> None:
        self.cache.clear()
        self._table_tracer.adjacency_up.clear()
        self._table_tracer.adjacency_down.clear()
        self._transitive_cache.clear()
        self._build_indexes(generation=getattr(self.parser, "data_generation", None))

    def query_lineage(
        self,
        table: str,
        field: str | None = None,
        depth: int = 3,
        mode: str = "both",
        include_fields: bool = True,
        limit: int = 1000,
        use_cache: bool = True,
    ) -> dict[str, Any]:
        start_time = time.perf_counter()
        t_refresh = start_time

        self._check_and_refresh_cache()
        t_after_refresh = time.perf_counter()

        cache_key = None
        if use_cache:
            cache_key = self._generate_cache_key(table, field, depth, mode, include_fields, limit)
            cached = self.cache.get(cache_key)
            if cached:
                # 返回深拷贝，避免修改缓存对象本身
                result_copy = copy.deepcopy(cached)
                result_copy["query_time_ms"] = round((time.perf_counter() - start_time) * 1000, 2)
                result_copy["cache_hit"] = True
                return result_copy

        t_cache_check = time.perf_counter()
        data = self.parser.get_current_data()
        if not data:
            return self._empty_result(start_time)

        t_get_data = time.perf_counter()
        table_upper = table.upper().strip()
        field_upper = field.upper().strip() if field else None

        # 使用预构建索引解析表名，替代每次扫描全量 tables
        adjacency_keys = set(self._table_tracer.adjacency_up.keys()) | set(self._table_tracer.adjacency_down.keys())
        resolved_table = self._index.resolve_table_name(table_upper, adjacency_keys) if self._index.is_built else self._table_tracer.resolve_table_name(table_upper, data)

        if not self._validate_schema(table_upper, resolved_table):
            return self._empty_result(start_time)

        t_resolve = time.perf_counter()
        if field_upper:
            result = self._query_field_lineage(resolved_table, field_upper, depth, mode, data, include_fields, limit)
        else:
            result = self._query_table_lineage(resolved_table, depth, mode, data, include_fields, field_upper, limit)

        if result.get("nodes_count", 0) == 0 and "." in resolved_table:
            alt_table = self._find_alternate_schema_table(resolved_table)
            if alt_table:
                logger.info("同名表重定向: %s → %s", resolved_table, alt_table)
                if field_upper:
                    result = self._query_field_lineage(alt_table, field_upper, depth, mode, data, include_fields, limit)
                else:
                    result = self._query_table_lineage(alt_table, depth, mode, data, include_fields, field_upper, limit)
                if result.get("nodes_count", 0) > 0:
                    result["redirected_from"] = resolved_table
                    result["resolved_table"] = alt_table

        t_assemble = time.perf_counter()
        total_ms = round((t_assemble - start_time) * 1000, 2)
        result["query_time_ms"] = total_ms
        if cache_key:
            self.cache.set(cache_key, result)

        # 分段耗时日志：慢查询（>2s）使用 info，否则 debug
        log_fn = logger.info if total_ms > 2000 else logger.debug
        log_fn(
            "query_lineage 分段耗时: table=%s field=%s total=%.1fms "
            "[refresh=%.1f cache_check=%.1f get_data=%.1f resolve=%.1f trace+assemble=%.1f]",
            table, field or "", total_ms,
            (t_after_refresh - t_refresh) * 1000,
            (t_cache_check - t_after_refresh) * 1000,
            (t_get_data - t_cache_check) * 1000,
            (t_resolve - t_get_data) * 1000,
            (t_assemble - t_resolve) * 1000,
        )
        return result

    def _find_alternate_schema_table(self, resolved_table: str) -> str | None:
        if "." not in resolved_table:
            return None
        schema, short_name = resolved_table.rsplit(".", 1)

        _schema_redirect = {
            "RRP_MDL": "RRP_EAST",
            "RRP_EAST": "RRP_MDL",
        }
        alt_schema = _schema_redirect.get(schema.upper())
        if not alt_schema:
            return None

        alt_full = f"{alt_schema}.{short_name}"
        # 使用预构建索引，替代每次扫描全量 tables
        if self._index.is_built and self._index.has_table(alt_full):
            return alt_full
        return None

    def _validate_schema(self, table_upper: str, resolved_table: str) -> bool:
        if "." in table_upper:
            parts = table_upper.split(".")
            if len(parts) == 2:
                schema, table_short = parts
                if table_short.startswith("EAST5_") and schema != "RRP_EAST":
                    logger.info(
                        "EAST5_ 表自动重定向: %s → RRP_EAST.%s",
                        table_upper,
                        table_short,
                    )
                    return True
            actual_tables = self._index.table_full_names if self._index.is_built else set()
            if resolved_table.upper() not in actual_tables:
                logger.warning(
                    "显式 schema 表不存在: 输入=%s, 解析=%s",
                    table_upper,
                    resolved_table,
                )
                return False
        return True

    def _query_field_lineage(
        self,
        table: str,
        field: str,
        depth: int,
        mode: str,
        data: dict,
        include_fields: bool,
        limit: int,
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
        return self._assemble_result(
            all_nodes,
            all_edges,
            all_mappings,
            data,
            include_fields,
            table,
            field,
            limit,
        )

    def _trace_field_with_tracer(
        self,
        tracer,
        table: str,
        field: str,
        depth: int,
        mode: str,
        all_nodes: set,
        all_edges: list,
        all_mappings: list,
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
        self,
        table: str,
        field: str,
        depth: int,
        mode: str,
        data: dict,
        all_nodes: set,
        all_edges: list,
        all_mappings: list,
    ) -> None:
        logger.warning("LineageTracer 不可用，回退到旧版字段级追溯")
        if mode in ("upstream", "both"):
            up_nodes, up_edges, up_mappings = self._trace_field_lineage(
                target_table=table,
                target_field=field,
                all_field_mappings=data.get("field_mappings", []),
                max_depth=depth,
                direction="upstream",
                query_index=self._index,
            )
            all_nodes.update(up_nodes)
            all_edges.extend(up_edges)
            all_mappings.extend(up_mappings)
        if mode in ("downstream", "both"):
            down_nodes, down_edges, down_mappings = self._trace_field_lineage(
                target_table=table,
                target_field=field,
                all_field_mappings=data.get("field_mappings", []),
                max_depth=depth,
                direction="downstream",
                query_index=self._index,
            )
            all_nodes.update(down_nodes)
            all_edges.extend(down_edges)
            all_mappings.extend(down_mappings)

    def _supplement_table_lineage(
        self,
        table: str,
        mode: str,
        data: dict,
        all_nodes: set,
        all_edges: list,
    ) -> None:
        logger.info("字段级血缘节点过少(%d个)，补充1层直接表级血缘", len(all_nodes))
        if mode in ("upstream", "both"):
            up_nodes_tbl, up_edges_tbl = self._table_tracer.trace(table, data, max_depth=1, direction="up", query_index=self._index)
            for node in up_nodes_tbl:
                if node not in all_nodes:
                    all_nodes.add(node)
            for edge in up_edges_tbl:
                if edge not in all_edges and edge["source_table"] in all_nodes and edge["target_table"] in all_nodes:
                    all_edges.append(edge)
        if mode in ("downstream", "both"):
            down_nodes_tbl, down_edges_tbl = self._table_tracer.trace(table, data, max_depth=1, direction="down", query_index=self._index)
            for node in down_nodes_tbl:
                if node not in all_nodes:
                    all_nodes.add(node)
            for edge in down_edges_tbl:
                if edge not in all_edges and edge["source_table"] in all_nodes and edge["target_table"] in all_nodes:
                    all_edges.append(edge)

    def _supplement_field_mappings(
        self,
        data: dict,
        all_nodes: set,
        all_mappings: list,
        table: str,
        field: str,
    ) -> None:
        """补充 tracer 产出的映射中缺少 procedure 信息的版本。

        只补充与已有映射具有相同 (src_bare, src_col, tgt_bare, tgt_col) 的映射，
        不引入图节点范围外的新映射。

        使用预构建索引（field_mappings_by_bare_pair）替代全量扫描。
        """
        existing_keys_4: set[tuple] = set()
        for m in all_mappings:
            src_bare = TableNameResolver.bare_table(m.get("source_table", "")).upper()
            tgt_bare = TableNameResolver.bare_table(m.get("target_table", "")).upper()
            existing_keys_4.add(
                (
                    src_bare,
                    m.get("source_column", "").upper(),
                    tgt_bare,
                    m.get("target_column", "").upper(),
                )
            )

        node_full_by_bare: dict[str, str] = {}
        for n in all_nodes:
            bare = n.split(".")[-1].upper() if "." in n else n.upper()
            node_full_by_bare.setdefault(bare, n)

        # 使用索引按 bare_pair 精确查找候选映射，替代扫描全量 field_mappings
        candidates: list[dict] = []
        if self._index.is_built:
            for (src_bare, src_col, tgt_bare, tgt_col) in existing_keys_4:
                index_hits = self._index.get_field_mappings_by_bare_pair(src_bare, src_col, tgt_bare, tgt_col)
                for fm in index_hits:
                    # 只保留双端都在节点集合中的映射
                    src_tbl = fm.get("source_table", "").upper()
                    tgt_tbl = fm.get("target_table", "").upper()
                    if self._index.node_in_set(src_tbl, all_nodes) and self._index.node_in_set(tgt_tbl, all_nodes):
                        candidates.append(fm)
        else:
            # Fallback: 全量扫描（仅在索引未构建时使用）
            logger.debug("LineageQueryIndex 未构建，回退到全量扫描 _supplement_field_mappings")
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
        self,
        table: str,
        depth: int,
        mode: str,
        data: dict,
        include_fields: bool,
        field: str | None,
        limit: int,
    ) -> dict[str, Any]:
        all_nodes, all_edges = set(), []
        if mode in ("upstream", "both"):
            up_nodes, up_edges = self._table_tracer.trace(table, data, depth, direction="up", query_index=self._index)
            all_nodes.update(up_nodes)
            all_edges.extend(up_edges)
        if mode in ("downstream", "both"):
            down_nodes, down_edges = self._table_tracer.trace(table, data, depth, direction="down", query_index=self._index)
            all_nodes.update(down_nodes)
            all_edges.extend(down_edges)
        all_mappings = []
        if field and include_fields:
            all_mappings = self._filter_field_mappings(
                data.get("field_mappings", []),
                all_nodes,
                target_table=table,
                target_field=field,
            )
        return self._assemble_result(
            all_nodes,
            all_edges,
            all_mappings,
            data,
            include_fields,
            table,
            field,
            limit,
        )

    def _build_node_field_map(
        self,
        all_nodes: set,
        all_edges: list,
        all_mappings: list,
        query_table: str,
        query_field: str | None,
    ) -> dict[str, str]:
        """Determine which field each node should display.

        Strategy:
        - Query target node always gets the query field.
        - Other nodes get their field from edge endpoints or mapping endpoints.
        - Bare-name matching used to handle full-name vs short-name differences.

        Returns:
            dict mapping node_id (as in all_nodes) -> field name (upper)
        """
        if not query_field:
            return {}

        field_map: dict[str, str] = {}

        query_table_upper = query_table.upper()
        query_field_upper = query_field.upper()

        # Helper: match node against a table name (bare or full)
        def _node_matches_table(node: str, tbl: str) -> bool:
            n_upper = node.upper()
            t_upper = tbl.upper()
            if n_upper == t_upper:
                return True
            n_bare = n_upper.split(".")[-1] if "." in n_upper else n_upper
            t_bare = t_upper.split(".")[-1] if "." in t_upper else t_upper
            return n_bare == t_bare

        # Step 1: Assign query target field to matching node
        for node in all_nodes:
            if _node_matches_table(node, query_table_upper):
                field_map[node] = query_field_upper

        # Step 2: For remaining nodes, derive field from edges
        for edge in all_edges:
            src_tbl = edge.get("source_table", "")
            tgt_tbl = edge.get("target_table", "")
            src_field = edge.get("source_field", "")
            tgt_field = edge.get("target_field", "")

            for node in all_nodes:
                if node in field_map:
                    continue
                if src_tbl and src_field and _node_matches_table(node, src_tbl):
                    field_map[node] = src_field.upper()
                elif tgt_tbl and tgt_field and _node_matches_table(node, tgt_tbl):
                    field_map[node] = tgt_field.upper()

        # Step 3: Fill gaps from field_mappings
        for fm in all_mappings:
            src_tbl = fm.get("source_table", "")
            tgt_tbl = fm.get("target_table", "")
            src_col = fm.get("source_column", "")
            tgt_col = fm.get("target_column", "")

            for node in all_nodes:
                if node in field_map:
                    continue
                if src_tbl and src_col and _node_matches_table(node, src_tbl):
                    field_map[node] = src_col.upper()
                elif tgt_tbl and tgt_col and _node_matches_table(node, tgt_tbl):
                    field_map[node] = tgt_col.upper()

        return field_map

    @staticmethod
    def _resolve_column_type(
        table_info: dict,
        field_name: str,
    ) -> tuple[str, str]:
        """Resolve a column's canonical name and data_type from table metadata.

        Matching is case-insensitive.  Returns (canonical_name, data_type).
        If no matching column found, returns (field_name, "").
        """
        columns = table_info.get("columns", [])
        field_upper = field_name.upper()
        for col in columns:
            col_name = col.get("name", "")
            if col_name.upper() == field_upper:
                return col_name, col.get("data_type", "")
        # No match found: return original name with empty type
        return field_name, ""

    def _assemble_result(
        self,
        all_nodes: set,
        all_edges: list,
        all_mappings: list,
        data: dict,
        include_fields: bool,
        table: str,
        field: str | None,
        limit: int,
    ) -> dict[str, Any]:
        field_map = self._build_node_field_map(all_nodes, all_edges, all_mappings, table, field)
        nodes_list = self._build_nodes(all_nodes, data, include_fields, field_map=field_map)
        edges_list = self._deduplicate_edges(all_edges)
        if field and len(nodes_list) > limit:
            nodes_list = self._prioritize_field_lineage_nodes(nodes_list, edges_list, table, field, limit)
        all_mappings = self._deduplicate_field_mappings(all_mappings)
        return {
            "nodes_count": len(nodes_list),
            "edges_count": len(edges_list),
            "nodes": nodes_list[:limit],
            "edges": edges_list[: limit * 3],
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
            columns = [column.get("name", "") for column in table_info.get("columns", []) if column.get("name")]

            tables.append(
                {
                    "full_name": name,
                    "short_name": short,
                    "layer": self._detect_layer(name),
                    "field_count": len(columns),
                    "columns": columns if columns else None,
                }
            )

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
    ) -> dict | None:
        """懒加载单条边的口径详情，委托给 UnifiedTracer。"""
        tracer = self.parser.get_unified_tracer()
        if tracer is None:
            return None
        return tracer.get_edge_caliber(src_table, src_column, tgt_table, tgt_column, procedure)

    def get_node_detail(self, table: str) -> dict | None:
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
        data_source: str | None = None,
    ) -> dict:
        """节点浮窗用的指标概览卡（P5 由 caliber_service 迁移而来）。"""
        from app.services.summary_card_builder import build_summary_card

        tracer = self.parser.get_unified_tracer()
        return build_summary_card(
            tracer,
            table,
            field,
            direction=direction,
            depth=depth,
            data_source=data_source,
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
            base_stats.update(
                {
                    "total_tables": metadata.get("total_tables", 0),
                    "total_procedures": metadata.get("total_procedures", 0),
                    "total_table_lineages": metadata.get("total_table_lineages", 0),
                    "total_field_mappings": metadata.get("total_field_mappings", 0),
                    "total_caliber_infos": metadata.get("total_caliber_infos", 0),
                }
            )

        base_stats["cache_size"] = self.cache.size

        return base_stats

    def rebuild_indexes(self) -> None:
        """强制重建所有索引"""
        logger.info("开始重建索引...")
        self.cache.clear()
        self._table_tracer.adjacency_up.clear()
        self._table_tracer.adjacency_down.clear()
        self._transitive_cache.clear()
        self._build_indexes(generation=getattr(self.parser, "data_generation", None))
        # 更新数据文件修改时间
        self._update_data_mtime()
        logger.info("索引重建完成")

    def is_index_ready(self) -> bool:
        """检查血缘索引是否已构建且可用。"""
        return bool(self._table_tracer.adjacency_up or self._table_tracer.adjacency_down)

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
            self._build_indexes(generation=getattr(self.parser, "data_generation", None))
            self._last_data_mtime = current_mtime

    def _get_data_mtime(self) -> float | None:
        """获取数据的最后更新时间戳。

        优先通过 ParserService 公共接口获取，fallback 到 JSON 文件 mtime。
        """
        # 优先通过公共接口获取
        mtime = self.parser.get_data_mtime()
        if mtime is not None:
            return mtime

        # Fallback: 检测 JSON 文件 mtime（legacy 模式）
        cache_file = self.parser.output_dir / "lineage_data.json"
        if cache_file.exists():
            return cache_file.stat().st_mtime

        return None

    def _update_data_mtime(self) -> None:
        """更新数据的最后修改时间。"""
        current = self._get_data_mtime()
        if current is not None:
            self._last_data_mtime = current

    def _build_field_mapping_indexes(
        self,
        all_field_mappings: list[dict],
        query_index: LineageQueryIndex | None,
    ) -> tuple[dict[tuple[str, str], list[dict]], dict[tuple[str, str], list[dict]]]:
        """构建字段映射索引，加速 BFS 查询。

        Returns:
            (target_map, source_map) — 目标/源索引映射
        """
        if query_index is not None and query_index.is_built:
            return query_index.field_mappings_by_target, query_index.field_mappings_by_source

        target_map: dict[tuple[str, str], list[dict]] = {}
        source_map: dict[tuple[str, str], list[dict]] = {}

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

        return target_map, source_map

    def _build_upstream_graph_cache(
        self,
        all_field_mappings: list[dict],
        query_index: LineageQueryIndex | None,
    ) -> tuple[dict[str, set[str]], Callable[[str], set[str]]]:
        """构建上游图缓存，用于判断数据流方向。

        Returns:
            (table_to_upstream, get_upstream_fn) — 上游映射和查询函数
        """
        if query_index is not None and query_index.is_built:
            _upstream_cache: dict[str, set[str]] = {}

            def _get_upstream_tables(tbl: str) -> set[str]:
                tbl_upper = tbl.upper()
                if tbl_upper not in _upstream_cache:
                    tls = query_index.table_lineages_by_target.get(tbl_upper, [])
                    _upstream_cache[tbl_upper] = {
                        tl.get("source_table", "").upper() for tl in tls if tl.get("source_table")
                    }
                return _upstream_cache[tbl_upper]

            return {}, _get_upstream_tables

        table_to_upstream: dict[str, set[str]] = {}
        for fm in all_field_mappings:
            src_tbl = fm.get("source_table", "").upper()
            tgt_tbl = fm.get("target_table", "").upper()
            if src_tbl and tgt_tbl:
                table_to_upstream.setdefault(tgt_tbl, set()).add(src_tbl)

        return table_to_upstream, lambda tbl: table_to_upstream.get(tbl.upper(), set())

    def _trace_upstream_field_lineage(
        self,
        current_table: str,
        current_field: str,
        depth: int,
        max_depth: int,
        target_map: dict[tuple[str, str], list[dict]],
        query_index: LineageQueryIndex | None,
        visited_nodes: set[str],
        edges: list[dict],
        collected_mappings: list[dict],
        max_field_nodes: int,
        is_mapping_in_target_flow: Callable[[dict], bool],
    ) -> deque[tuple[str, str, int]]:
        """向上游追溯字段血缘（BFS 单步）。

        Returns:
            新增的 BFS 队列条目
        """
        new_queue_items: deque[tuple[str, str, int]] = deque()
        tgt_key = (current_table.upper(), current_field.upper())

        # 精确匹配
        matching_mappings = target_map.get(tgt_key, [])

        # 模糊匹配（处理表名短名、schema差异等）
        if not matching_mappings:
            if query_index is not None and query_index.is_built:
                resolved_tbl = query_index.resolve_table_name(current_table)
                if resolved_tbl.upper() != current_table.upper():
                    tgt_key2 = (resolved_tbl.upper(), current_field.upper())
                    matching_mappings = target_map.get(tgt_key2, [])
            else:
                for key, mappings in target_map.items():
                    if self._resolver.match(key[0], current_table) and self._resolver.match_field(
                        key[1], current_field
                    ):
                        matching_mappings.extend(mappings)

        for fm in matching_mappings:
            if len(visited_nodes) >= max_field_nodes:
                logger.warning("字段级查询节点数达到上限(%d)，停止追溯", max_field_nodes)
                break

            if not is_mapping_in_target_flow(fm):
                continue

            src_tbl = fm.get("source_table", "").upper()
            src_col = fm.get("source_column", "").upper()

            if not src_tbl or not src_col:
                continue

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

            if depth + 1 < max_depth:
                new_queue_items.append((src_tbl, src_col, depth + 1))

        return new_queue_items

    def _trace_downstream_field_lineage(
        self,
        current_table: str,
        current_field: str,
        depth: int,
        max_depth: int,
        source_map: dict[tuple[str, str], list[dict]],
        query_index: LineageQueryIndex | None,
        visited_nodes: set[str],
        edges: list[dict],
        collected_mappings: list[dict],
        max_field_nodes: int,
        is_mapping_in_target_flow: Callable[[dict], bool],
    ) -> deque[tuple[str, str, int]]:
        """向下游追溯字段血缘（BFS 单步）。

        Returns:
            新增的 BFS 队列条目
        """
        new_queue_items: deque[tuple[str, str, int]] = deque()
        src_key = (current_table.upper(), current_field.upper())

        # 精确匹配
        matching_mappings = source_map.get(src_key, [])

        # 模糊匹配
        if not matching_mappings:
            if query_index is not None and query_index.is_built:
                resolved_tbl = query_index.resolve_table_name(current_table)
                if resolved_tbl.upper() != current_table.upper():
                    src_key2 = (resolved_tbl.upper(), current_field.upper())
                    matching_mappings = source_map.get(src_key2, [])
            else:
                for key, mappings in source_map.items():
                    if self._resolver.match(key[0], current_table) and self._resolver.match_field(
                        key[1], current_field
                    ):
                        matching_mappings.extend(mappings)

        for fm in matching_mappings:
            if len(visited_nodes) >= max_field_nodes:
                logger.warning("字段级查询节点数达到上限(%d)，停止追溯", max_field_nodes)
                break

            if not is_mapping_in_target_flow(fm):
                continue

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

            if depth + 1 < max_depth:
                new_queue_items.append((tgt_tbl, tgt_col, depth + 1))

        return new_queue_items

    def _expand_table_lineage_fallback(
        self,
        visited_nodes: set[str],
        edges: list[dict],
        direction: str,
    ) -> set[str]:
        """字段映射节点过少时，补充1层直接表级血缘。

        Returns:
            扩展后的节点集合
        """
        if len(visited_nodes) >= 3:
            logger.info(
                "字段映射已找到%d个节点，跳过表级扩展以避免结果膨胀",
                len(visited_nodes),
            )
            return visited_nodes

        logger.info(
            "字段映射节点过少(%d个)，补充1层直接表级血缘",
            len(visited_nodes),
        )

        if direction in ("downstream", "both"):
            table_queue = deque(visited_nodes)
            table_visited = set(visited_nodes)

            while table_queue:
                current = table_queue.popleft()
                downstream_tables = self._table_tracer.adjacency_down.get(current.upper(), set())

                for downstream_tbl in downstream_tables:
                    downstream_tbl_upper = downstream_tbl.upper()
                    if downstream_tbl_upper not in table_visited:
                        table_visited.add(downstream_tbl_upper)
                        edges.append(
                            {
                                "source_table": current.upper(),
                                "target_table": downstream_tbl_upper,
                                "source_field": "",
                                "target_field": "",
                                "type": "table_lineage",
                            }
                        )

            visited_nodes = table_visited

        if direction in ("upstream", "both"):
            table_queue = deque(visited_nodes)
            table_visited = set(visited_nodes)

            while table_queue:
                current = table_queue.popleft()
                upstream_tables = self._table_tracer.adjacency_up.get(current.upper(), set())

                for upstream_tbl in upstream_tables:
                    upstream_tbl_upper = upstream_tbl.upper()
                    if upstream_tbl_upper not in table_visited:
                        table_visited.add(upstream_tbl_upper)
                        edges.append(
                            {
                                "source_table": upstream_tbl_upper,
                                "target_table": current.upper(),
                                "source_field": "",
                                "target_field": "",
                                "type": "table_lineage",
                            }
                        )

            visited_nodes = table_visited

        return visited_nodes

    def _trace_field_lineage(
        self,
        target_table: str,
        target_field: str,
        all_field_mappings: list[dict],
        max_depth: int = 5,
        direction: str = "both",
        query_index: LineageQueryIndex | None = None,
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
            query_index: 预构建的查询索引（可选）

        Returns:
            tuple[set, list, list]: (节点集合, 边列表, 字段映射列表)
        """
        _use_index = query_index is not None and query_index.is_built

        # 解析目标表名
        resolved_target = (
            query_index.resolve_table_name(target_table)
            if _use_index
            else TableNameResolver.resolve_from_mappings(target_table, all_field_mappings)
        )
        if "." not in resolved_target.upper():
            resolved_target = resolved_target.upper()

        # 构建索引
        target_map, source_map = self._build_field_mapping_indexes(all_field_mappings, query_index)
        table_to_upstream, get_upstream_fn = self._build_upstream_graph_cache(all_field_mappings, query_index)

        # 构建数据流过滤函数
        def is_upstream_of_target(table: str) -> bool:
            table_upper = table.upper()
            target_upper = resolved_target.upper()
            if table_upper == target_upper:
                return True
            visited = {table_upper}
            bfs_queue = deque([table_upper])
            while bfs_queue:
                current = bfs_queue.popleft()
                upstreams = get_upstream_fn(current)
                for upstream in upstreams:
                    if upstream == target_upper:
                        return True
                    if upstream not in visited:
                        visited.add(upstream)
                        bfs_queue.append(upstream)
            return False

        def is_mapping_in_target_flow(fm: dict) -> bool:
            tgt_tbl = fm.get("target_table", "").upper()
            return is_upstream_of_target(tgt_tbl)

        # BFS 遍历
        visited_nodes = {resolved_target}
        edges: list[dict] = []
        collected_mappings: list[dict] = []
        queue: deque[tuple[str, str, int]] = deque([(resolved_target, target_field, 0)])
        max_field_nodes = 50

        while queue:
            current_table, current_field, depth = queue.popleft()

            if depth >= max_depth:
                continue

            if direction in ("upstream", "both"):
                new_items = self._trace_upstream_field_lineage(
                    current_table, current_field, depth, max_depth,
                    target_map, query_index, visited_nodes, edges,
                    collected_mappings, max_field_nodes, is_mapping_in_target_flow,
                )
                queue.extend(new_items)

            if direction in ("downstream", "both"):
                new_items = self._trace_downstream_field_lineage(
                    current_table, current_field, depth, max_depth,
                    source_map, query_index, visited_nodes, edges,
                    collected_mappings, max_field_nodes, is_mapping_in_target_flow,
                )
                queue.extend(new_items)

        # 表级血缘扩展
        visited_nodes = self._expand_table_lineage_fallback(visited_nodes, edges, direction)

        logger.info(
            "🔗 字段映射追溯结果: %s.%s → %d 节点, %d 边, %d 映射",
            target_table, target_field,
            len(visited_nodes), len(edges), len(collected_mappings),
        )

        return visited_nodes, edges, collected_mappings

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
        field_map: dict[str, str] | None = None,
    ) -> list[dict]:
        """构建节点数据列表，可选地为每个节点附加当前链路字段元数据。"""
        # 使用预构建索引替代每次扫描全量 tables
        table_map = (
            self._index.table_by_full
            if self._index.is_built
            else {t["full_name"]: t for t in data.get("tables", [])}
        )
        # Build short-name -> table_info fallback for field resolution
        table_by_short: dict[str, dict] = {}
        if self._index.is_built:
            table_by_short = {
                short: tbls[0]
                for short, tbls in self._index.table_by_short.items()
                if tbls
            }
        else:
            for t in data.get("tables", []):
                sn = t.get("table_name", "").upper()
                if sn:
                    table_by_short.setdefault(sn, t)

        nodes = []
        for name in sorted(node_names):
            table_info = table_map.get(name, {})
            # Fallback: try short-name lookup when full-name misses
            if not table_info and "." in name:
                short_upper = name.split(".")[-1].upper()
                table_info = table_by_short.get(short_upper, {})

            node = {
                "id": name,
                "full_name": name,
                "short_name": name.split(".")[-1] if "." in name else name,
                "layer": self._detect_layer(name),
                "comment": table_info.get("comment", ""),
            }

            if include_fields and "columns" in table_info:
                node["columns"] = [c["name"] for c in table_info["columns"]]

            # Attach current-lineage field metadata (independent of include_fields)
            if field_map is not None:
                raw_field = field_map.get(name, "")
                if raw_field:
                    col_name, col_type = self._resolve_column_type(table_info, raw_field)
                    node["field"] = {"name": col_name, "data_type": col_type}
                else:
                    # No field for this node (e.g. table-only supplemental node)
                    # Omit the key entirely for backward compatibility
                    pass

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
        field: str | None,
        depth: int,
        mode: str,
        include_fields: bool = True,
        limit: int = 1000,
    ) -> str:
        """生成缓存键（含 include_fields 和 limit，避免不同参数命中同一缓存）"""
        parts = [table.upper(), str(depth), mode]
        if field:
            parts.append(field.upper())
        parts.append(f"f={int(include_fields)}")
        parts.append(f"l={limit}")
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
