"""
字段级数据血缘 BFS 递归上溯引擎

核心算法：
  1. 从目标字段出发，按 BFS 逐层向上追溯上游来源
  2. 每层查找"加工了当前表"的存储过程，再从过程的 field_mappings 中定位来源字段
  3. 支持 TMP 表内部链路（同一过程内 INSERT→SELECT 多步链路）
  4. 支持多链路（UNION ALL 等合并场景返回多条 FieldLineageChain）
  5. 循环依赖检测，避免无限递归
"""

from __future__ import annotations

import logging
import time
from collections import deque
from dataclasses import dataclass
from typing import Optional

from core.base_tracer import BaseTracer
from core.models import (
    FieldLineageChain,
    FieldLineageNode,
    FieldLineageResult,
    FieldMapping,
    LayerType,
    ProcedureInfo,
    TableInfo,
    TableLineage,
    detect_layer,
)

logger = logging.getLogger(__name__)


@dataclass
class _BFSNode:
    table_name: str
    field_name: str
    layer: int
    procedure: str = ""
    transform_logic: str = ""
    parent_key: str = ""


@dataclass
class _SourceRecord:
    source_table: str
    source_field: str
    transform_logic: str
    procedure: str
    confidence: float


@dataclass
class _TargetRecord:
    target_table: str
    target_field: str
    transform_logic: str
    procedure: str
    confidence: float


class LineageTracer(BaseTracer):

    def __init__(
        self,
        tables: dict[str, TableInfo],
        procedures: dict[str, ProcedureInfo],
        table_lineages: list[TableLineage],
        field_mappings: list[FieldMapping],
        max_depth: int = 10,
    ) -> None:
        super().__init__(tables, procedures, table_lineages, field_mappings, max_depth)

        self._table_lineage_idx: dict[str, list[TableLineage]] = {}
        self._field_mapping_idx: dict[str, dict[str, list[FieldMapping]]] = {}
        self._source_field_mapping_idx: dict[str, dict[str, list[FieldMapping]]] = {}

        self._build_lineage_indexes()
        logger.info(
            "LineageTracer 初始化完成: %d 张表, %d 个过程, %d 条表级血缘, %d 条字段映射",
            len(tables),
            len(procedures),
            len(table_lineages),
            len(field_mappings),
        )

    def trace_field(self, target_table: str, target_field: str) -> FieldLineageResult:
        t0 = time.perf_counter()

        norm_table = self.normalize_name(target_table)
        norm_field = self._normalize_field_name(target_field)

        logger.info("开始追溯字段: %s.%s", norm_table, norm_field)

        chains = self.trace_field_upstream(norm_table, norm_field, self.max_depth)

        elapsed_ms = (time.perf_counter() - t0) * 1000

        all_tables: set[str] = set()
        all_procs: set[str] = set()
        total_nodes = 0
        max_depth_found = 0

        for chain in chains:
            total_nodes += chain.node_count
            all_tables.update(chain.tables_involved)
            all_procs.update(chain.procedures_involved)
            if chain.depth > max_depth_found:
                max_depth_found = chain.depth

        result = FieldLineageResult(
            target_table=norm_table,
            target_field=norm_field,
            chains=chains,
            total_nodes=total_nodes,
            total_tables=len(all_tables),
            total_procedures=len(all_procs),
            max_depth=max_depth_found,
            query_time_ms=round(elapsed_ms, 2),
        )

        logger.info(
            "追溯完成: %s.%s → %d 条链路, %d 个节点, 耗时 %.2fms",
            norm_table,
            norm_field,
            len(chains),
            total_nodes,
            elapsed_ms,
        )
        return result

    def trace_field_upstream(
        self, target_table: str, target_field: str, max_depth: int = 10
    ) -> list[FieldLineageChain]:
        norm_table = self.normalize_name(target_table)
        norm_field = self._normalize_field_name(target_field)
        bfs_tree = self._bfs_trace(norm_table, norm_field, max_depth)
        chains = self._build_chains_from_bfs_tree(bfs_tree, (norm_table, norm_field))
        return chains

    def get_upstream_tables(self, table_name: str) -> list[str]:
        norm_table = self.normalize_name(table_name)
        lineages = self._table_lineage_idx.get(norm_table, [])
        upstream: set[str] = set()
        for tl in lineages:
            src = self.normalize_name(tl.source_table)
            if src and src != norm_table:
                upstream.add(src)
        return sorted(upstream)

    def get_downstream_tables(self, table_name: str) -> list[str]:
        norm_table = self.normalize_name(table_name)
        downstream: set[str] = set()
        for tl in self.table_lineages:
            src = self.normalize_name(tl.source_table)
            tgt = self.normalize_name(tl.target_table)
            if src == norm_table and tgt != norm_table:
                downstream.add(tgt)
        return sorted(downstream)

    def _build_lineage_indexes(self) -> None:
        for tl in self.table_lineages:
            tgt = self.normalize_name(tl.target_table)
            self._table_lineage_idx.setdefault(tgt, []).append(tl)

        for fm in self.field_mappings:
            tgt_tbl = self.normalize_name(fm.target_table)
            tgt_col = self._normalize_field_name(fm.target_column)
            inner = self._field_mapping_idx.setdefault(tgt_tbl, {})
            inner.setdefault(tgt_col, []).append(fm)

        for fm in self.field_mappings:
            src_tbl = self.normalize_name(fm.source_table)
            src_col = self._normalize_field_name(fm.source_column)
            if not src_tbl or not src_col:
                continue
            inner = self._source_field_mapping_idx.setdefault(src_tbl, {})
            inner.setdefault(src_col, []).append(fm)

        logger.debug(
            "LineageTracer 索引构建完成: table_lineage_idx=%d, field_mapping_idx=%d, "
            "source_field_mapping_idx=%d",
            len(self._table_lineage_idx),
            len(self._field_mapping_idx),
            len(self._source_field_mapping_idx),
        )

    def _bfs_trace(
        self, target_table: str, target_field: str, max_depth: int = 10
    ) -> dict[str, _BFSNode]:
        norm_table = self.normalize_name(target_table)
        norm_field = self._normalize_field_name(target_field)

        root_key = f"{norm_table}.{norm_field}"
        visited: set[str] = set()

        bfs_tree: dict[str, _BFSNode] = {}

        root_node = _BFSNode(
            table_name=norm_table,
            field_name=norm_field,
            layer=0,
            procedure="",
            transform_logic="(目标字段)",
            parent_key="",
        )
        bfs_tree[root_key] = root_node
        visited.add(root_key)
        root_bare_tbl = self.bare_table(norm_table)
        if root_bare_tbl != norm_table:
            visited.add(f"{root_bare_tbl}.{norm_field}")

        queue: deque[_BFSNode] = deque([root_node])

        while queue:
            current = queue.popleft()

            if current.layer >= max_depth:
                logger.debug(
                    "达到最大深度 %d，停止扩展: %s.%s",
                    max_depth,
                    current.table_name,
                    current.field_name,
                )
                continue

            sources = self._find_source_fields(
                current.table_name, current.field_name
            )

            if not sources:
                logger.debug(
                    "L%d %s.%s → 无上游来源（叶子节点）",
                    current.layer,
                    current.table_name,
                    current.field_name,
                )
                continue

            cur_bare = self.bare_table(current.table_name)
            final_sources: list[_SourceRecord] = []
            same_table_transform_note = ""
            for src in sources:
                src_norm_t = self.normalize_name(src.source_table)
                src_bare = self.bare_table(src_norm_t)
                if src_bare == cur_bare:
                    transform_note = src.transform_logic or "同表字段转换"
                    same_table_transform_note = transform_note
                    inner_sources = self._find_source_fields(
                        src.source_table, src.source_field
                    )
                    if inner_sources:
                        found_cross_table = False
                        for inner in inner_sources:
                            inner_bare = self.bare_table(
                                self.normalize_name(inner.source_table)
                            )
                            if inner_bare != cur_bare:
                                final_sources.append(inner)
                                found_cross_table = True
                        if not found_cross_table:
                            src.transform_logic = transform_note
                            final_sources.append(src)
                    else:
                        src.transform_logic = transform_note
                        final_sources.append(src)
                else:
                    final_sources.append(src)
            sources = final_sources

            current_key = f"{current.table_name}.{current.field_name}"

            if same_table_transform_note and current_key in bfs_tree:
                existing_logic = bfs_tree[current_key].transform_logic
                if existing_logic and existing_logic != "(目标字段)":
                    bfs_tree[current_key].transform_logic = (
                        f"{existing_logic}; {same_table_transform_note}"
                    )
                else:
                    bfs_tree[current_key].transform_logic = same_table_transform_note

            for src in sources:
                src_norm_table = self.normalize_name(src.source_table)
                src_norm_field = self._normalize_field_name(src.source_field)
                src_key = f"{src_norm_table}.{src_norm_field}"

                if not src_norm_table or not src_norm_field:
                    continue

                bare_key = ""
                bare_tbl = self.bare_table(src_norm_table)
                if bare_tbl != src_norm_table:
                    bare_key = f"{bare_tbl}.{src_norm_field}"

                if src_key in visited or (bare_key and bare_key in visited):
                    logger.debug(
                        "检测到循环依赖，跳过: %s → %s (bare=%s)",
                        current_key,
                        src_key,
                        bare_key,
                    )
                    continue

                if not self.is_layer_compatible(src_norm_table, current.table_name):
                    src_layer_type = detect_layer(src_norm_table)
                    target_layer = detect_layer(current.table_name)
                    logger.debug(
                        "层级不兼容，跳过: %s (层级=%s, 目标层级=%s)",
                        src_norm_table,
                        src_layer_type.value,
                        target_layer.value,
                    )
                    continue

                visited.add(src_key)
                if bare_key:
                    visited.add(bare_key)

                src_layer = current.layer + 1
                src_node = _BFSNode(
                    table_name=src_norm_table,
                    field_name=src_norm_field,
                    layer=src_layer,
                    procedure=src.procedure,
                    transform_logic=src.transform_logic,
                    parent_key=current_key,
                )
                bfs_tree[src_key] = src_node
                queue.append(src_node)

                logger.debug(
                    "L%d %s.%s ← L%d %s.%s [%s] %s",
                    src_layer,
                    src_norm_table,
                    src_norm_field,
                    current.layer,
                    current.table_name,
                    current.field_name,
                    src.procedure,
                    src.transform_logic or "(直传)",
                )

        logger.info(
            "BFS 遍历结束: 根节点=%s, 共访问 %d 个节点",
            root_key,
            len(bfs_tree),
        )
        return bfs_tree

    def trace_field_downstream(
        self, source_table: str, source_field: str, max_depth: int = 10
    ) -> list[FieldLineageChain]:
        norm_table = self.normalize_name(source_table)
        norm_field = self._normalize_field_name(source_field)
        bfs_tree = self._bfs_trace_downstream(norm_table, norm_field, max_depth)
        chains = self._build_chains_from_bfs_tree(bfs_tree, (norm_table, norm_field), reverse=True)
        return chains

    def _bfs_trace_downstream(
        self, source_table: str, source_field: str, max_depth: int = 10
    ) -> dict[str, _BFSNode]:
        norm_table = self.normalize_name(source_table)
        norm_field = self._normalize_field_name(source_field)

        root_key = f"{norm_table}.{norm_field}"
        visited: set[str] = set()

        bfs_tree: dict[str, _BFSNode] = {}

        root_node = _BFSNode(
            table_name=norm_table,
            field_name=norm_field,
            layer=0,
            procedure="",
            transform_logic="(起始字段)",
            parent_key="",
        )
        bfs_tree[root_key] = root_node
        visited.add(root_key)
        root_bare_tbl = self.bare_table(norm_table)
        if root_bare_tbl != norm_table:
            visited.add(f"{root_bare_tbl}.{norm_field}")

        queue: deque[_BFSNode] = deque([root_node])

        while queue:
            current = queue.popleft()

            if current.layer >= max_depth:
                logger.debug(
                    "达到最大深度 %d，停止扩展: %s.%s",
                    max_depth,
                    current.table_name,
                    current.field_name,
                )
                continue

            targets = self._find_target_fields(
                current.table_name, current.field_name
            )

            if not targets:
                logger.debug(
                    "L%d %s.%s → 无下游去向（叶子节点）",
                    current.layer,
                    current.table_name,
                    current.field_name,
                )
                continue

            current_key = f"{current.table_name}.{current.field_name}"

            for tgt in targets:
                tgt_norm_table = self.normalize_name(tgt.target_table)
                tgt_norm_field = self._normalize_field_name(tgt.target_field)
                tgt_key = f"{tgt_norm_table}.{tgt_norm_field}"

                if not tgt_norm_table or not tgt_norm_field:
                    continue

                bare_key = ""
                bare_tbl = self.bare_table(tgt_norm_table)
                if bare_tbl != tgt_norm_table:
                    bare_key = f"{bare_tbl}.{tgt_norm_field}"

                if tgt_key in visited or (bare_key and bare_key in visited):
                    logger.debug(
                        "检测到循环依赖，跳过: %s → %s (bare=%s)",
                        current_key,
                        tgt_key,
                        bare_key,
                    )
                    continue

                if not self.is_downstream_layer_compatible(tgt_norm_table, current.table_name):
                    tgt_layer_type = detect_layer(tgt_norm_table)
                    source_layer = detect_layer(current.table_name)
                    logger.debug(
                        "层级不兼容（下游），跳过: %s (层级=%s, 源层级=%s)",
                        tgt_norm_table,
                        tgt_layer_type.value,
                        source_layer.value,
                    )
                    continue

                visited.add(tgt_key)
                if bare_key:
                    visited.add(bare_key)

                tgt_layer = current.layer + 1
                tgt_node = _BFSNode(
                    table_name=tgt_norm_table,
                    field_name=tgt_norm_field,
                    layer=tgt_layer,
                    procedure=tgt.procedure,
                    transform_logic=tgt.transform_logic,
                    parent_key=current_key,
                )
                bfs_tree[tgt_key] = tgt_node
                queue.append(tgt_node)

                logger.debug(
                    "L%d %s.%s → L%d %s.%s [%s] %s",
                    current.layer,
                    current.table_name,
                    current.field_name,
                    tgt_layer,
                    tgt_norm_table,
                    tgt_norm_field,
                    tgt.procedure,
                    tgt.transform_logic or "(直传)",
                )

        logger.info(
            "下游 BFS 遍历结束: 根节点=%s, 共访问 %d 个节点",
            root_key,
            len(bfs_tree),
        )
        return bfs_tree

    def _find_target_fields(
        self, source_table: str, source_field: str
    ) -> list[_TargetRecord]:
        norm_table = self.normalize_name(source_table)
        norm_field = self._normalize_field_name(source_field)
        results: list[_TargetRecord] = []
        seen_keys: set[str] = set()

        def _collect_from_idx(tbl_key: str) -> None:
            tbl_idx = self._source_field_mapping_idx.get(tbl_key)
            if not tbl_idx:
                return
            mappings = tbl_idx.get(norm_field, [])
            for fm in mappings:
                tgt_tbl = self.normalize_name(fm.target_table)
                tgt_col = self.normalize_name(fm.target_column)
                if not tgt_tbl or not tgt_col:
                    continue
                dedup_key = f"{self.bare_table(tgt_tbl)}.{tgt_col}"
                if dedup_key in seen_keys:
                    continue
                seen_keys.add(dedup_key)
                results.append(
                    _TargetRecord(
                        target_table=tgt_tbl,
                        target_field=tgt_col,
                        transform_logic=fm.transform_logic,
                        procedure=fm.procedure,
                        confidence=fm.confidence,
                    )
                )

        _collect_from_idx(norm_table)

        if not results:
            fuzzy_table = self._fuzzy_match_source_table_key(norm_table)
            if fuzzy_table:
                _collect_from_idx(fuzzy_table)

        bare_name = norm_table.split(".")[-1] if "." in norm_table else norm_table
        if bare_name != norm_table:
            _collect_from_idx(bare_name)
        else:
            for key in self._source_field_mapping_idx:
                if "." in key:
                    key_bare = key.split(".")[-1]
                    if key_bare.upper() == bare_name.upper():
                        _collect_from_idx(key)

        if not results:
            logger.debug(
                "未找到 %s.%s 的任何下游目标字段",
                norm_table,
                norm_field,
            )

        return results

    def _fuzzy_match_source_table_key(self, table_name: str) -> Optional[str]:
        upper_name = table_name.upper()
        bare_name = upper_name.split(".")[-1] if "." in upper_name else upper_name

        for key in self._source_field_mapping_idx:
            key_upper = key.upper()
            if key_upper.endswith(upper_name):
                return key
            if bare_name and "." in key_upper:
                key_bare = key_upper.split(".")[-1]
                if key_bare == bare_name:
                    return key
        return None

    def _find_source_fields(
        self, target_table: str, target_field: str
    ) -> list[_SourceRecord]:
        norm_table = self.normalize_name(target_table)
        norm_field = self._normalize_field_name(target_field)
        results: list[_SourceRecord] = []

        seen_keys: set[str] = set()

        def _collect_source_from_idx(tbl_key: str) -> None:
            tbl_idx = self._field_mapping_idx.get(tbl_key)
            if not tbl_idx:
                return
            mappings = tbl_idx.get(norm_field, [])
            for fm in mappings:
                src_table = self.normalize_name(fm.source_table)
                src_col = self._normalize_field_name(fm.source_column)
                if not src_col:
                    continue
                if not src_table:
                    continue
                dedup_key = f"{self.bare_table(src_table)}.{src_col}"
                if dedup_key in seen_keys:
                    continue
                seen_keys.add(dedup_key)
                results.append(
                    _SourceRecord(
                        source_table=src_table,
                        source_field=src_col,
                        transform_logic=fm.transform_logic,
                        procedure=fm.procedure,
                        confidence=fm.confidence,
                    )
                )

        _collect_source_from_idx(norm_table)

        if not results:
            fuzzy_table = self._fuzzy_match_table_key(norm_table)
            if fuzzy_table:
                _collect_source_from_idx(fuzzy_table)

        bare_name = norm_table.split(".")[-1] if "." in norm_table else norm_table
        if bare_name != norm_table:
            _collect_source_from_idx(bare_name)
        else:
            for key in self._field_mapping_idx:
                if "." in key:
                    key_bare = key.split(".")[-1]
                    if key_bare.upper() == bare_name.upper():
                        _collect_source_from_idx(key)

        if results:
            return results

        tmp_bridge = self._try_tmp_bridge(norm_table, norm_field)
        if tmp_bridge:
            logger.info(
                "TMP 桥接命中: %s.%s → %s.%s",
                norm_table, norm_field,
                tmp_bridge.source_table, tmp_bridge.source_field,
            )
            return [tmp_bridge]

        procs = self._find_procedures_for_table(norm_table)
        for proc in procs:
            proc_results = self._find_source_fields_in_procedure(
                norm_table, norm_field, proc
            )
            results.extend(proc_results)

        if not results:
            logger.debug(
                "未找到 %s.%s 的任何来源字段（%d 个候选过程）",
                norm_table,
                norm_field,
                len(procs),
            )

        if len(results) > 1:
            dedup: list[_SourceRecord] = []
            seen_bare: set[str] = set()
            for r in results:
                bare = self.bare_table(r.source_table)
                key = f"{bare}.{r.source_field}"
                if key not in seen_bare:
                    seen_bare.add(key)
                    dedup.append(r)
            if len(dedup) < len(results):
                logger.debug(
                    "来源字段按 bare table 去重: %d → %d",
                    len(results),
                    len(dedup),
                )
            results = dedup

        return results

    def _try_tmp_bridge(self, target_table: str, target_field: str) -> Optional[_SourceRecord]:
        base_name = target_table.split(".")[-1] if "." in target_table else target_table
        candidates = [
            f"{base_name}_TMP",
            f"{base_name}_TEMP",
            f"{base_name}TMP",
            f"{target_table}_TMP",
            f"{target_table}_TEMP",
        ]

        for tmp_name in candidates:
            tmp_idx = self._field_mapping_idx.get(tmp_name)
            if tmp_idx and target_field in tmp_idx:
                fms = tmp_idx[target_field]
                proc_hint = fms[0].procedure if fms else ""
                return _SourceRecord(
                    source_table=tmp_name,
                    source_field=target_field,
                    transform_logic="(TMP 表桥接)",
                    procedure=proc_hint,
                    confidence=0.7,
                )

        for tmp_name in candidates:
            matched_key = self._fuzzy_match_table_key(tmp_name)
            if matched_key:
                tbl_idx = self._field_mapping_idx.get(matched_key)
                if tbl_idx and target_field in tbl_idx:
                    fms = tbl_idx[target_field]
                    proc_hint = fms[0].procedure if fms else ""
                    return _SourceRecord(
                        source_table=matched_key,
                        source_field=target_field,
                        transform_logic="(TMP 表桥接)",
                        procedure=proc_hint,
                        confidence=0.7,
                    )

        return None

    def _fuzzy_match_table_key(self, table_name: str) -> Optional[str]:
        upper_name = table_name.upper()
        bare_name = upper_name.split(".")[-1] if "." in upper_name else upper_name

        for key in self._field_mapping_idx:
            key_upper = key.upper()
            if key_upper.endswith(upper_name):
                return key
            if bare_name and "." in key_upper:
                key_bare = key_upper.split(".")[-1]
                if key_bare == bare_name:
                    return key
        return None

    def _infer_source_table_from_lineage(
        self, target_table: str, procedure_name: str
    ) -> str:
        norm_target = self.normalize_name(target_table)
        candidates: list[str] = []
        same_proc_candidates: list[str] = []

        for tl in self.table_lineages:
            tl_tgt = self.normalize_name(tl.target_table)
            tl_src = self.normalize_name(tl.source_table)
            if tl_tgt == norm_target and tl_src and tl_src != norm_target:
                tl_proc = self.normalize_name(tl.procedure or "")
                if procedure_name and tl_proc == self.normalize_name(procedure_name):
                    same_proc_candidates.append(tl_src)
                candidates.append(tl_src)

        same_proc_candidates = [c for c in same_proc_candidates if self.is_layer_compatible(c, norm_target)]
        candidates = [c for c in candidates if self.is_layer_compatible(c, norm_target)]

        if same_proc_candidates:
            if len(same_proc_candidates) == 1:
                return same_proc_candidates[0]
            for src in same_proc_candidates:
                if src in self._field_mapping_idx:
                    return src
            return same_proc_candidates[0]

        if not candidates:
            return ""

        if len(candidates) == 1:
            return candidates[0]

        for src in candidates:
            if src in self._field_mapping_idx:
                return src

        return candidates[0]

    def _find_source_fields_in_procedure(
        self, target_table: str, target_field: str, procedure: ProcedureInfo
    ) -> list[_SourceRecord]:
        results: list[_SourceRecord] = []
        norm_table = self.normalize_name(target_table)
        norm_field = self._normalize_field_name(target_field)

        for fm in procedure.field_mappings:
            fm_tgt_tbl = self.normalize_name(fm.target_table)
            fm_tgt_col = self._normalize_field_name(fm.target_column)

            if fm_tgt_tbl == norm_table and fm_tgt_col == norm_field:
                src_table = self.normalize_name(fm.source_table)
                src_col = self._normalize_field_name(fm.source_column)
                if not src_col:
                    continue
                if not src_table:
                    continue
                results.append(
                    _SourceRecord(
                        source_table=src_table,
                        source_field=src_col,
                        transform_logic=fm.transform_logic,
                        procedure=procedure.full_name,
                        confidence=fm.confidence,
                    )
                )

        return results

    def _find_procedures_for_table(self, table_name: str) -> list[ProcedureInfo]:
        norm_table = self.normalize_name(table_name)

        primary = self._proc_target_idx.get(norm_table, [])
        if primary:
            return primary

        secondary = self._table_proc_idx.get(norm_table, [])
        filtered = [
            p
            for p in secondary
            if norm_table in [self.normalize_name(t) for t in p.target_tables]
        ]
        return filtered

    def _build_chains_from_bfs_tree(
        self, bfs_tree: dict[str, _BFSNode], target: tuple[str, str], reverse: bool = False
    ) -> list[FieldLineageChain]:
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
            max_layer = len(path) - 1

            chain_id = "→".join(path)
            if chain_id in seen_chains:
                continue
            seen_chains.add(chain_id)

            chain_nodes: list[FieldLineageNode] = []
            for i, node_key in enumerate(path):
                node = bfs_tree[node_key]
                is_temp = self.is_temp_table(node.table_name)
                layer_type_str = detect_layer(node.table_name).value

                display_layer = i
                source_fields_for_node: list[str] = []
                parent_keys = [
                    k for k, n in bfs_tree.items() if n.parent_key == node_key
                ]
                for pk in parent_keys:
                    parent_node = bfs_tree[pk]
                    source_fields_for_node.append(
                        f"{parent_node.table_name}.{parent_node.field_name}"
                    )

                fl_node = FieldLineageNode(
                    layer=display_layer,
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

    @staticmethod
    def _normalize_field_name(name: str) -> str:
        if not name:
            return ""
        return name.strip().upper()

    @staticmethod
    def to_graph_result(
        chains: list[FieldLineageChain],
        direction: str = "upstream",
    ) -> tuple[set[str], list[dict], list[dict]]:
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
                        edges.append({
                            "source_table": src_table,
                            "target_table": tgt_table,
                            "source_field": src_field,
                            "target_field": tgt_field,
                            "type": "field_mapping",
                        })

                    # 边 src → tgt 的 procedure 取自承载该字段映射的 BFS 节点：
                    # - upstream BFS：src.procedure 存的是"src 流向其 BFS 父节点（即下游 tgt）的过程"
                    # - downstream BFS：tgt.procedure 存的是"流入此 tgt 的过程"
                    edge_procedure = (
                        prev_node.procedure if direction == "upstream" else node.procedure
                    )
                    edge_transform = (
                        prev_node.transform_logic if direction == "upstream" else node.transform_logic
                    )

                    mapping_key = (src_table, src_field, tgt_table, tgt_field)
                    if mapping_key not in seen_mappings:
                        seen_mappings.add(mapping_key)
                        mappings.append({
                            "source_table": src_table,
                            "source_column": src_field,
                            "target_table": tgt_table,
                            "target_column": tgt_field,
                            "transform_logic": edge_transform,
                            "procedure": edge_procedure,
                        })

        return node_names, edges, mappings
