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
        """
        执行血缘查询（优化版）- 支持表+字段级查询

        Args:
            table: 目标表名
            field: 目标字段名(可选，用于字段级血缘查询)
            depth: 查询深度
            mode: 查询方向 (upstream/downstream/both)
            include_fields: 是否包含字段详情
            limit: 结果数量限制
            use_cache: 是否使用缓存

        Returns:
            dict: 包含 nodes, edges, field_mappings, 统计信息的字典
        """
        start_time = time.perf_counter()

        # 检测数据文件是否已更新，如果更新则清除缓存
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

        # 将短名解析为完整表名，确保 query_target 和边中的表名统一
        resolved_table = self._table_tracer.resolve_table_name(table_upper, data)

        all_nodes = set()
        all_edges = []
        all_field_mappings = []

        if field_upper:
            logger.info("执行字段级血缘查询: %s.%s (深度=%d, 方向=%s)", resolved_table, field_upper, depth, mode)

            tracer = self.parser.get_lineage_tracer()

            if tracer:
                if mode in ("upstream", "both"):
                    up_chains = tracer.trace_field_upstream(resolved_table, field_upper, depth)
                    up_nodes, up_edges, up_mappings = tracer.to_graph_result(up_chains, direction="upstream")
                    all_nodes.update(up_nodes)
                    all_edges.extend(up_edges)
                    all_field_mappings.extend(up_mappings)
                    logger.info("字段级上游追溯完成: %d 节点, %d 边, %d 映射", len(up_nodes), len(up_edges), len(up_mappings))

                if mode in ("downstream", "both"):
                    down_chains = tracer.trace_field_downstream(resolved_table, field_upper, depth)
                    down_nodes, down_edges, down_mappings = tracer.to_graph_result(down_chains, direction="downstream")
                    all_nodes.update(down_nodes)
                    all_edges.extend(down_edges)
                    all_field_mappings.extend(down_mappings)
                    logger.info("字段级下游追溯完成: %d 节点, %d 边, %d 映射", len(down_nodes), len(down_edges), len(down_mappings))
            else:
                logger.warning("LineageTracer 不可用，回退到旧版字段级追溯")
                if mode in ("upstream", "both"):
                    up_nodes, up_edges, up_mappings = self._trace_field_lineage(
                        target_table=resolved_table,
                        target_field=field_upper,
                        all_field_mappings=data.get("field_mappings", []),
                        max_depth=depth,
                        direction="upstream",
                    )
                    all_nodes.update(up_nodes)
                    all_edges.extend(up_edges)
                    all_field_mappings.extend(up_mappings)

                if mode in ("downstream", "both"):
                    down_nodes, down_edges, down_mappings = self._trace_field_lineage(
                        target_table=resolved_table,
                        target_field=field_upper,
                        all_field_mappings=data.get("field_mappings", []),
                        max_depth=depth,
                        direction="downstream",
                    )
                    all_nodes.update(down_nodes)
                    all_edges.extend(down_edges)
                    all_field_mappings.extend(down_mappings)

            # ========== 字段级查询：严格限制只返回字段血缘相关的表 ==========
            # 修复：不再无条件补充表级血缘，避免返回大量无关表
            # 只有当字段级血缘找到的节点过少（< 3个）时，才补充1层直接表级血缘
            if len(all_nodes) < 3:
                logger.info(
                    "字段级血缘节点过少(%d个)，补充1层直接表级血缘",
                    len(all_nodes),
                )
                if mode in ("upstream", "both"):
                    up_nodes_tbl, up_edges_tbl = self._table_tracer.trace(
                        resolved_table, data, max_depth=1, direction="up"
                    )
                    for node in up_nodes_tbl:
                        if node not in all_nodes:
                            all_nodes.add(node)
                    for edge in up_edges_tbl:
                        if edge not in all_edges:
                            if edge["source_table"] in all_nodes and edge["target_table"] in all_nodes:
                                all_edges.append(edge)

                if mode in ("downstream", "both"):
                    down_nodes_tbl, down_edges_tbl = self._table_tracer.trace(
                        resolved_table, data, max_depth=1, direction="down"
                    )
                    for node in down_nodes_tbl:
                        if node not in all_nodes:
                            all_nodes.add(node)
                    for edge in down_edges_tbl:
                        if edge not in all_edges:
                            if edge["source_table"] in all_nodes and edge["target_table"] in all_nodes:
                                all_edges.append(edge)

            # 补充与当前涉及节点相关的所有字段映射
            if include_fields:
                extra_mappings = self._filter_field_mappings(
                    data.get("field_mappings", []),
                    all_nodes,
                    target_table=resolved_table,
                    target_field=field_upper,
                )
                seen_mappings = {
                    (m.get("source_table"), m.get("source_column"), m.get("target_table"), m.get("target_column"))
                    for m in all_field_mappings
                }
                for fm in extra_mappings:
                    key = (fm.get("source_table"), fm.get("source_column"), fm.get("target_table"), fm.get("target_column"))
                    if key not in seen_mappings:
                        all_field_mappings.append(fm)
        else:
            # 纯表级查询（保留原有逻辑）
            if mode in ("upstream", "both"):
                up_nodes, up_edges = self._table_tracer.trace(
                    resolved_table, data, depth, direction="up"
                )
                all_nodes.update(up_nodes)
                all_edges.extend(up_edges)

            if mode in ("downstream", "both"):
                down_nodes, down_edges = self._table_tracer.trace(
                    resolved_table, data, depth, direction="down"
                )
                all_nodes.update(down_nodes)
                all_edges.extend(down_edges)

            if field_upper and include_fields:
                all_field_mappings = self._filter_field_mappings(
                    data.get("field_mappings", []),
                    all_nodes,
                    target_table=resolved_table,
                    target_field=field_upper,
                )

        nodes_list = self._build_nodes(all_nodes, data, include_fields)
        edges_list = self._deduplicate_edges(all_edges)

        # 字段级查询时，优先保留与字段血缘相关的节点
        if field_upper and len(nodes_list) > limit:
            nodes_list = self._prioritize_field_lineage_nodes(
                nodes_list, edges_list, resolved_table, field_upper, limit
            )

        all_field_mappings = self._deduplicate_field_mappings(all_field_mappings)
        query_time_ms = round((time.perf_counter() - start_time) * 1000, 2)

        result = {
            "query_time_ms": query_time_ms,
            "nodes_count": len(nodes_list),
            "edges_count": len(edges_list),
            "nodes": nodes_list[:limit],
            "edges": edges_list[:limit * 3],
            "has_more": len(nodes_list) > limit or len(edges_list) > limit * 3,
            "cache_hit": False,
            "tables_involved": len(all_nodes),
            "max_depth_reached": depth,
            "query_target": {
                "table": resolved_table,
                "field": field_upper,
            },
            "field_mappings": all_field_mappings[:500] if all_field_mappings else [],
            "field_mapping_count": len(all_field_mappings),
        }

        if cache_key:
            self.cache.set(cache_key, result)

        return result

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
        """检查数据文件是否已更新，如果更新则自动清除缓存"""
        import os
        cache_file = self.parser.output_dir / "lineage_data.json"
        
        if not cache_file.exists():
            return
            
        current_mtime = cache_file.stat().st_mtime
        
        if self._last_data_mtime == 0:
            # 首次加载，记录时间
            self._last_data_mtime = current_mtime
            return
            
        if current_mtime > self._last_data_mtime:
            logger.info(
                "检测到数据文件已更新 (%.2f > %.2f)，自动清除缓存",
                current_mtime,
                self._last_data_mtime,
            )
            self.cache.clear()
            self._table_tracer.adjacency_up.clear()
            self._table_tracer.adjacency_down.clear()
            self._transitive_cache.clear()
            self._build_indexes()
            self._last_data_mtime = current_mtime

    def _update_data_mtime(self) -> None:
        """更新数据文件的最后修改时间"""
        import os
        cache_file = self.parser.output_dir / "lineage_data.json"
        
        if cache_file.exists():
            self._last_data_mtime = cache_file.stat().st_mtime

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
    def _filter_field_mappings(
        all_mappings: list[dict],
        involved_nodes: set,
        target_table: str = None,
        target_field: str = None,
    ) -> list[dict]:
        """
        过滤字段映射，只返回与查询相关的映射

        Args:
            all_mappings: 全部字段映射
            involved_nodes: 涉及的表节点集合
            target_table: 目标表名
            target_field: 目标字段名

        Returns:
            list[dict]: 过滤后的字段映射列表
        """
        filtered = []
        target_upper = (target_table or "").upper()
        target_table_short = target_upper.split(".")[-1] if "." in target_upper else target_upper
        field_upper = (target_field or "").upper()

        for fm in all_mappings:
            src_tbl = fm.get("source_table", "").upper()
            tgt_tbl = fm.get("target_table", "").upper()
            src_col = fm.get("source_column", "").upper()
            tgt_col = fm.get("target_column", "").upper()

            src_in = src_tbl in involved_nodes
            tgt_in = tgt_tbl in involved_nodes
            
            # 检查是否匹配目标表（支持全名或短名匹配）
            matches_target = False
            if target_upper:
                # 全名匹配
                if tgt_tbl == target_upper or src_tbl == target_upper:
                    matches_target = True
                # 短名匹配（表名的最后一部分）
                elif tgt_tbl.endswith("." + target_table_short) or src_tbl.endswith("." + target_table_short):
                    matches_target = True
                # 包含匹配
                elif target_table_short in tgt_tbl or target_table_short in src_tbl:
                    matches_target = True

            # 检查是否匹配目标字段
            matches_field = False
            if field_upper:
                if tgt_col == field_upper:
                    matches_field = True
                elif field_upper in tgt_col or field_upper in src_col:
                    matches_field = True

            # 过滤条件（满足任一即可）:
            # 1. 源或目标表在涉及节点中（原有逻辑）
            # 2. 匹配目标表（新增）
            # 3. 如果指定了字段，必须匹配字段
            if (src_in or tgt_in or matches_target):
                if field_upper:
                    if matches_field:
                        filtered.append(fm)
                else:
                    # 未指定字段，只要表匹配就保留
                    if src_in or tgt_in or matches_target:
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
    def _deduplicate_field_mappings(mappings: list[dict]) -> list[dict]:
        """按展示所需字段去重字段映射，保留首次出现顺序。"""
        seen = set()
        unique_mappings = []

        for mapping in mappings:
            key = (
                mapping.get("source_table", "").upper(),
                mapping.get("source_column", "").upper(),
                mapping.get("target_table", "").upper(),
                mapping.get("target_column", "").upper(),
                mapping.get("procedure", "").upper(),
            )
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
