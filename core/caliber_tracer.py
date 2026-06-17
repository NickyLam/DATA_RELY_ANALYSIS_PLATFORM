"""
指标口径 BFS 递归追溯引擎

核心算法：
  1. 从目标字段出发，按 BFS 逐层向上追溯上游来源
  2. 每层不仅返回来源表/字段，还携带完整的 WHERE/JOIN/GROUP BY 条件
  3. 支持跨存储过程的口径链路拼接（条件逐层传递）
  4. 支持多链路（UNION ALL 等合并场景）
  5. 循环依赖检测，避免无限递归
  6. 口径摘要生成（可读文本 + 结构化数据）

与 LineageTracer 的区别：
  - LineageTracer 返回 FieldLineageChain（节点+边，关注数据流向）
  - CaliberTracer 返回 CaliberChain（每步含完整条件，关注加工口径）
"""

from __future__ import annotations

import logging
import time
from collections import deque
from dataclasses import dataclass
from dataclasses import field as dc_field
from typing import Any, TypedDict

from core.base_tracer import BaseTracer
from core.caliber_extractor import CaliberExtractor
from core.layer_detector import LayerType, detect_layer
from core.models import (
    CaliberChain,
    CaliberInfo,
    CaliberResult,
    FieldMapping,
    ProcedureInfo,
    SourceLocation,
    SQLCondition,
    TableInfo,
    TableLineage,
)

logger = logging.getLogger(__name__)


class CaliberInfoDict(TypedDict, total=False):
    source_table: str
    source_column: str
    target_table: str
    target_column: str
    transform_logic: str
    procedure: str
    where_conditions: list[str]
    join_conditions: list[str]


@dataclass
class _CaliberBFSNode:
    table_name: str
    field_name: str
    depth: int
    procedure: str = ""
    step_num: int = 0
    parent_key: str = ""
    accumulated_conditions: list[dict] = dc_field(default_factory=list)


@dataclass
class _CaliberSourceRecord:
    source_table: str
    source_column: str
    target_table: str
    target_column: str
    transform_logic: str
    where_conditions: list[dict]
    join_conditions: list[dict]
    group_by_clause: str
    having_clause: str
    procedure: str
    step_num: int
    step_desc: str
    data_source: str
    raw_sql_fragment: str
    confidence: float


class CaliberTracer(BaseTracer):
    def __init__(
        self,
        tables: dict[str, TableInfo],
        procedures: dict[str, ProcedureInfo],
        table_lineages: list[TableLineage],
        field_mappings: list[FieldMapping],
        caliber_infos: list[CaliberInfoDict],
        max_depth: int = 10,
        known_schemas: list[str] | None = None,
        default_data_source: str = "oracle",
    ) -> None:
        super().__init__(tables, procedures, table_lineages, field_mappings, max_depth)
        self.caliber_infos_raw: list[CaliberInfoDict] = caliber_infos
        self._known_schemas: list[str] = known_schemas or ["RRP_MDL", "RRP_EAST"]
        self._default_data_source: str = default_data_source

        self._target_idx: dict[tuple[str, str], list[dict]] = {}
        self._source_idx: dict[tuple[str, str], list[dict]] = {}

        self._build_caliber_indexes()
        logger.info(
            "CaliberTracer 初始化完成: %d 张表, %d 个过程, %d 条字段映射, %d 条口径信息",
            len(tables),
            len(procedures),
            len(field_mappings),
            len(caliber_infos),
        )

    def _build_schema_variants(self, short_table: str) -> list[str]:
        """根据已知 schema 列表动态构建 schema 变体，替代硬编码 RRP_MDL/RRP_EAST"""
        variants = [short_table]
        for schema in self._known_schemas:
            variants.append(f"{schema}.{short_table}")
        return variants

    def _build_caliber_indexes(self) -> None:
        for ci_dict in self.caliber_infos_raw:
            target_table = ci_dict.get("target_table", "").upper()
            target_column = ci_dict.get("target_column", "").upper()
            source_table = ci_dict.get("source_table", "").upper()
            source_column = ci_dict.get("source_column", "").upper()

            if not (target_table and target_column):
                continue

            tgt_key = self.make_key(target_table, target_column)
            self._target_idx.setdefault(tgt_key, []).append(ci_dict)

            if source_table and source_column:
                src_key = self.make_key(source_table, source_column)
                self._source_idx.setdefault(src_key, []).append(ci_dict)

    def trace_caliber(
        self,
        target_table: str,
        target_field: str,
        direction: str = "upstream",
        max_depth: int | None = None,
        data_source: str | None = None,
    ) -> CaliberResult:
        t0 = time.perf_counter()
        depth = max_depth or self.max_depth

        norm_table = self.normalize_name(target_table)
        norm_field = target_field.upper().strip()

        logger.info(
            "开始追溯口径: %s.%s, 方向=%s, 深度=%d",
            norm_table,
            norm_field,
            direction,
            depth,
        )

        chains: list[CaliberChain] = []

        if direction in ("upstream", "both"):
            up_chains = self._trace_upstream(norm_table, norm_field, depth, data_source)
            chains.extend(up_chains)

        if direction in ("downstream", "both"):
            down_chains = self._trace_downstream(norm_table, norm_field, depth, data_source)
            chains.extend(down_chains)

        elapsed_ms = (time.perf_counter() - t0) * 1000

        total_steps = sum(len(c.steps) for c in chains)
        total_conds = sum(len(s.where_conditions) + len(s.join_conditions) for c in chains for s in c.steps)

        result = CaliberResult(
            target_table=norm_table,
            target_column=norm_field,
            chains=chains,
            total_steps=total_steps,
            total_conditions=total_conds,
            query_time_ms=round(elapsed_ms, 2),
        )

        result.build_complete_spec()

        logger.info(
            "口径追溯完成: %s.%s → %d 条链路, %d 步, %d 条条件, 耗时 %.2fms",
            norm_table,
            norm_field,
            len(chains),
            total_steps,
            total_conds,
            elapsed_ms,
        )
        return result

    def trace_upstream(self, target_table: str, target_field: str, max_depth: int = 10) -> list[CaliberChain]:
        return self._trace_upstream(self.normalize_name(target_table), target_field.upper(), max_depth)

    def trace_downstream(self, target_table: str, target_field: str, max_depth: int = 10) -> list[CaliberChain]:
        return self._trace_downstream(self.normalize_name(target_table), target_field.upper(), max_depth)

    def get_direct_sources(self, table: str, field: str) -> list[_CaliberSourceRecord]:
        key = self.make_key(self.normalize_name(table), field.upper())
        records = self._target_idx.get(key, [])
        return [self._dict_to_record(r) for r in records]

    def get_direct_targets(self, table: str, field: str) -> list[_CaliberSourceRecord]:
        key = self.make_key(self.normalize_name(table), field.upper())
        records = self._source_idx.get(key, [])
        return [self._dict_to_record(r) for r in records]

    def lookup_caliber_by_target(self, short_table: str, column: str) -> list[dict]:
        """按目标表和列查找口径信息"""
        key = (short_table.upper(), column.upper())
        return self._target_idx.get(key, [])

    def generate_summary_text(self, result: CaliberResult) -> str:
        lines: list[str] = []
        lines.append("## 指标口径分析报告")
        lines.append("")
        lines.append(f"- **目标**: `{result.target_table}.{result.target_column}`")
        lines.append(f"- **链路数**: {len(result.chains)}")
        lines.append(f"- **总步骤**: {result.total_steps}")
        lines.append(f"- **总条件数**: {result.total_conditions}")
        lines.append(f"- **查询耗时**: {result.query_time_ms:.1f}ms")
        lines.append("")

        for i, chain in enumerate(result.chains):
            lines.append(f"### 链路 #{i + 1}（深度: {chain.depth}）")
            lines.append("")
            for j, step in enumerate(chain.steps):
                lines.append(
                    f"**Step {j + 1}**: `{step.source_table}.{step.source_column}` → `{step.target_table}.{step.target_column}`"
                )

                if step.transform_logic:
                    lines.append(f"  - 转换逻辑: `{step.transform_logic}`")

                if step.where_conditions:
                    lines.append(f"  - 筛选条件 ({len(step.where_conditions)} 条):")
                    for wc in step.where_conditions:
                        raw = wc.raw_text if hasattr(wc, "raw_text") else str(wc)
                        lines.append(f"    - WHERE `{raw}`")

                if step.join_conditions:
                    lines.append(f"  - 关联条件 ({len(step.join_conditions)} 条):")
                    for jc in step.join_conditions:
                        raw = jc.raw_text if hasattr(jc, "raw_text") else str(jc)
                        lines.append(f"    - JOIN `{raw}`")

                if step.group_by_clause:
                    lines.append(f"  - 分组: GROUP BY `{step.group_by_clause}`")

                if step.having_clause:
                    lines.append(f"  - 筛选分组: HAVING `{step.having_clause}`")

                if step.procedure:
                    lines.append(f"  - 加工过程: `{step.procedure}`")

                if step.step_desc:
                    lines.append(f"  - 步骤说明: {step.step_desc}")

                lines.append("")

            lines.append("---")
            lines.append("")

        return "\n".join(lines)

    def _trace_upstream(
        self,
        start_table: str,
        start_field: str,
        max_depth: int,
        data_source: str | None = None,
    ) -> list[CaliberChain]:
        start_key = self.make_key(start_table, start_field)

        visited: set[tuple[str, str]] = {start_key}
        queue: deque[_CaliberBFSNode] = deque()
        queue.append(
            _CaliberBFSNode(
                table_name=start_table,
                field_name=start_field,
                depth=0,
                parent_key="",
            )
        )

        bfs_tree: dict[str, _CaliberBFSNode] = {
            start_key: _CaliberBFSNode(
                table_name=start_table,
                field_name=start_field,
                depth=0,
            )
        }

        leaf_paths: list[list[_CaliberBFSNode]] = []

        while queue:
            current = queue.popleft()

            current_layer = detect_layer(current.table_name)
            if current_layer in (LayerType.ODS, LayerType.CONFIG):
                path = self._reconstruct_path(bfs_tree, current)
                leaf_paths.append(path)
                continue

            sources = self._find_upstream_sources(current.table_name, current.field_name, data_source)

            if not sources:
                path = self._reconstruct_path(bfs_tree, current)
                leaf_paths.append(path)
                continue

            if current.depth >= max_depth:
                path = self._reconstruct_path(bfs_tree, current)
                leaf_paths.append(path)
                continue

            added_in_this_level = 0
            for src in sources[:8]:
                src_key = self.make_key(src.source_table, src.source_column)

                bare_src_key = (
                    src.source_table.split(".")[-1].upper(),
                    src.source_column.upper(),
                )
                if src_key in visited or bare_src_key in visited:
                    continue

                if not self.is_upstream_layer_compatible(src.source_table, current.table_name):
                    src_layer_type = detect_layer(src.source_table)
                    tgt_layer_type = detect_layer(current.table_name)
                    logger.debug(
                        "口径BFS层级不兼容，跳过上游: %s (层级=%s, 目标层级=%s)",
                        src.source_table,
                        src_layer_type.value,
                        tgt_layer_type.value,
                    )
                    continue

                visited.add(src_key)
                visited.add(bare_src_key)

                src_node = _CaliberBFSNode(
                    table_name=src.source_table,
                    field_name=src.source_column,
                    depth=current.depth + 1,
                    procedure=src.procedure,
                    step_num=src.step_num,
                    parent_key=self.make_key(current.table_name, current.field_name),
                )
                bfs_tree[src_key] = src_node
                queue.append(src_node)
                added_in_this_level += 1

            if added_in_this_level == 0:
                path = self._reconstruct_path(bfs_tree, current)
                leaf_paths.append(path)

        chains = self._paths_to_chains(leaf_paths, start_table, start_field)
        return chains

    def _trace_downstream(
        self,
        start_table: str,
        start_field: str,
        max_depth: int,
        data_source: str | None = None,
    ) -> list[CaliberChain]:
        start_key = self.make_key(start_table, start_field)

        visited: set[tuple[str, str]] = {start_key}
        queue: deque[_CaliberBFSNode] = deque()
        queue.append(
            _CaliberBFSNode(
                table_name=start_table,
                field_name=start_field,
                depth=0,
                parent_key="",
            )
        )

        bfs_tree: dict[str, _CaliberBFSNode] = {
            start_key: _CaliberBFSNode(
                table_name=start_table,
                field_name=start_field,
                depth=0,
            )
        }

        leaf_paths: list[list[_CaliberBFSNode]] = []

        while queue:
            current = queue.popleft()

            current_layer = detect_layer(current.table_name)
            if current_layer == LayerType.EAST:
                path = self._reconstruct_path(bfs_tree, current)
                leaf_paths.append(path)
                continue

            targets = self._find_downstream_targets(current.table_name, current.field_name, data_source)

            if not targets:
                path = self._reconstruct_path(bfs_tree, current)
                leaf_paths.append(path)
                continue

            if current.depth >= max_depth:
                for tgt in targets[:3]:
                    if not self.is_downstream_layer_compatible(tgt.target_table, current.table_name):
                        continue
                    tgt_node = _CaliberBFSNode(
                        table_name=tgt.target_table,
                        field_name=tgt.target_column,
                        depth=current.depth + 1,
                        procedure=tgt.procedure,
                        step_num=tgt.step_num,
                        parent_key=self.make_key(current.table_name, current.field_name),
                    )
                    tgt_key = self.make_key(tgt_node.table_name, tgt_node.field_name)
                    if tgt_key not in visited:
                        visited.add(tgt_key)
                        bfs_tree[tgt_key] = tgt_node
                    path = self._reconstruct_path(bfs_tree, tgt_node)
                    leaf_paths.append(path)
                continue

            added_in_this_level = 0
            for tgt in targets[:8]:
                tgt_key = self.make_key(tgt.target_table, tgt.target_column)

                bare_tgt_key = (
                    tgt.target_table.split(".")[-1].upper(),
                    tgt.target_column.upper(),
                )
                if tgt_key in visited or bare_tgt_key in visited:
                    continue

                if not self.is_downstream_layer_compatible(tgt.target_table, current.table_name):
                    tgt_layer_type = detect_layer(tgt.target_table)
                    src_layer_type = detect_layer(current.table_name)
                    logger.debug(
                        "口径BFS层级不兼容，跳过下游: %s (层级=%s, 源层级=%s)",
                        tgt.target_table,
                        tgt_layer_type.value,
                        src_layer_type.value,
                    )
                    continue

                visited.add(tgt_key)
                visited.add(bare_tgt_key)

                tgt_node = _CaliberBFSNode(
                    table_name=tgt.target_table,
                    field_name=tgt.target_column,
                    depth=current.depth + 1,
                    procedure=tgt.procedure,
                    step_num=tgt.step_num,
                    parent_key=self.make_key(current.table_name, current.field_name),
                )
                bfs_tree[tgt_key] = tgt_node
                queue.append(tgt_node)
                added_in_this_level += 1

            if added_in_this_level == 0:
                path = self._reconstruct_path(bfs_tree, current)
                leaf_paths.append(path)

        chains = self._paths_to_chains(leaf_paths, start_table, start_field)
        return chains

    def _find_upstream_sources(self, table: str, field: str, data_source: str | None) -> list[_CaliberSourceRecord]:
        results: list[_CaliberSourceRecord] = []
        short_table = self.normalize_name(table).split(".")[-1]
        field_upper = field.upper()

        key = self.make_key(self.normalize_name(table), field_upper)

        direct_hits = self._target_idx.get(key, [])
        for ci_dict in direct_hits:
            if data_source and ci_dict.get("data_source", "") != data_source:
                continue
            results.append(self._dict_to_record(ci_dict))

        if results:
            return results

        schema_variants = self._build_schema_variants(short_table)

        for variant in schema_variants:
            vkey = (variant, field_upper)
            hits = self._target_idx.get(vkey, [])
            for h in hits:
                if data_source and h.get("data_source", "") != data_source:
                    continue
                results.append(self._dict_to_record(h))

        if results:
            return results

        fm_cols = self._fm_target_idx.get(short_table, {})
        fm_list = fm_cols.get(field_upper, [])
        for fm in fm_list:
            if not fm.source_table or not fm.source_column:
                continue
            ci = self._field_mapping_to_caliber(fm, fm.procedure or "")
            if ci:
                results.append(ci)

        if results:
            return results

        for variant in schema_variants:
            v_short = variant.split(".")[-1]
            fm_cols_v = self._fm_target_idx.get(v_short, {})
            fm_list_v = fm_cols_v.get(field_upper, [])
            for fm in fm_list_v:
                if not fm.source_table or not fm.source_column:
                    continue
                ci = self._field_mapping_to_caliber(fm, fm.procedure or "")
                if ci:
                    results.append(ci)

        if results:
            return results

        proc_list = self._proc_target_idx.get(short_table, [])
        for proc in proc_list:
            for fm in proc.field_mappings:
                fm_tgt = fm.target_table.upper().split(".")[-1]
                fm_col = fm.target_column.upper()
                if fm_tgt == short_table and fm_col == field_upper:
                    ci = self._field_mapping_to_caliber(fm, proc.full_name)
                    if ci:
                        results.append(ci)

        if results:
            return results

        tl_list = self._tl_target_idx.get(short_table, [])
        for tl in tl_list:
            src_short = tl.source_table.upper().split(".")[-1]
            src_fm_cols = self._fm_source_idx.get(src_short, {})

            matched = False
            for col_name, fm_entries in src_fm_cols.items():
                for fm in fm_entries:
                    fm_tgt_short = fm.target_table.upper().split(".")[-1]
                    if fm_tgt_short == short_table and fm.target_column.upper() == field_upper:
                        ci = self._field_mapping_to_caliber(fm, tl.procedure or fm.procedure or "")
                        if ci:
                            results.append(ci)
                            matched = True

            if not matched:
                src_cols = self._fm_target_idx.get(src_short, {})
                if field_upper in src_cols:
                    for fm in src_cols[field_upper]:
                        ci = self._field_mapping_to_caliber(fm, tl.procedure or fm.procedure or "")
                        if ci:
                            results.append(ci)
                            matched = True

            if not matched:
                src_fm_cols = self._fm_source_idx.get(src_short, {})
                for col_name, fm_entries in src_fm_cols.items():
                    for fm in fm_entries:
                        fm_tgt_short = fm.target_table.upper().split(".")[-1]
                        if fm_tgt_short == short_table and fm.target_column.upper() == field_upper:
                            ci = self._field_mapping_to_caliber(fm, tl.procedure or fm.procedure or "")
                            if ci:
                                results.append(ci)
                                matched = True

            if not matched:
                src_tgt_cols = self._fm_target_idx.get(src_short, {})
                for col_name, fm_entries in src_tgt_cols.items():
                    for fm in fm_entries:
                        fm_tgt_short = fm.target_table.upper().split(".")[-1]
                        if fm_tgt_short == short_table and fm.target_column.upper() == field_upper:
                            ci = self._field_mapping_to_caliber(fm, tl.procedure or fm.procedure or "")
                            if ci:
                                results.append(ci)
                                matched = True

            if not matched:
                results.append(
                    _CaliberSourceRecord(
                        source_table=tl.source_table,
                        source_column=field_upper,
                        target_table=tl.target_table,
                        target_column=field_upper,
                        transform_logic="TABLE_LINEAGE_FALLBACK",
                        where_conditions=[],
                        join_conditions=[],
                        group_by_clause="",
                        having_clause="",
                        procedure=tl.procedure or "",
                        step_num=0,
                        step_desc="表级血缘回退(同名字段匹配)",
                        data_source=self._default_data_source,
                        raw_sql_fragment="",
                        confidence=0.5,
                    )
                )

        return results

    def _find_downstream_targets(self, table: str, field: str, data_source: str | None) -> list[_CaliberSourceRecord]:
        results: list[_CaliberSourceRecord] = []
        short_table = self.normalize_name(table).split(".")[-1]
        field_upper = field.upper()

        key = self.make_key(self.normalize_name(table), field_upper)

        direct_hits = self._source_idx.get(key, [])
        for ci_dict in direct_hits:
            if data_source and ci_dict.get("data_source", "") != data_source:
                continue
            results.append(self._dict_to_record(ci_dict))

        if results:
            return results

        schema_variants = self._build_schema_variants(short_table)

        for variant in schema_variants:
            vkey = (variant, field_upper)
            hits = self._source_idx.get(vkey, [])
            for h in hits:
                if data_source and h.get("data_source", "") != data_source:
                    continue
                results.append(self._dict_to_record(h))

        if results:
            return results

        fm_cols = self._fm_source_idx.get(short_table, {})
        fm_list = fm_cols.get(field_upper, [])
        for fm in fm_list:
            if not fm.target_table or not fm.target_column:
                continue
            ci = self._field_mapping_to_caliber(fm, fm.procedure or "")
            if ci:
                results.append(ci)

        if results:
            return results

        for variant in schema_variants:
            v_short = variant.split(".")[-1]
            fm_cols_v = self._fm_source_idx.get(v_short, {})
            fm_list_v = fm_cols_v.get(field_upper, [])
            for fm in fm_list_v:
                if not fm.target_table or not fm.target_column:
                    continue
                ci = self._field_mapping_to_caliber(fm, fm.procedure or "")
                if ci:
                    results.append(ci)

        if results:
            return results

        tl_list = self._tl_source_idx.get(short_table, [])
        for tl in tl_list:
            tgt_short = tl.target_table.upper().split(".")[-1]
            tgt_fm_cols = self._fm_target_idx.get(tgt_short, {})

            matched = False
            for col_name, fm_entries in tgt_fm_cols.items():
                for fm in fm_entries:
                    fm_src_short = fm.source_table.upper().split(".")[-1]
                    if fm_src_short == short_table and fm.source_column.upper() == field_upper:
                        ci = self._field_mapping_to_caliber(fm, tl.procedure or fm.procedure or "")
                        if ci:
                            results.append(ci)
                            matched = True

            if not matched:
                tgt_cols = self._fm_source_idx.get(tgt_short, {})
                if field_upper in tgt_cols:
                    for fm in tgt_cols[field_upper]:
                        ci = self._field_mapping_to_caliber(fm, tl.procedure or fm.procedure or "")
                        if ci:
                            results.append(ci)
                            matched = True

            if not matched:
                tgt_fm_cols = self._fm_target_idx.get(tgt_short, {})
                for col_name, fm_entries in tgt_fm_cols.items():
                    for fm in fm_entries:
                        fm_src_short = fm.source_table.upper().split(".")[-1]
                        if fm_src_short == short_table and fm.source_column.upper() == field_upper:
                            ci = self._field_mapping_to_caliber(fm, tl.procedure or fm.procedure or "")
                            if ci:
                                results.append(ci)
                                matched = True

            if not matched:
                tgt_src_cols = self._fm_source_idx.get(tgt_short, {})
                for col_name, fm_entries in tgt_src_cols.items():
                    for fm in fm_entries:
                        fm_src_short = fm.source_table.upper().split(".")[-1]
                        if fm_src_short == short_table and fm.source_column.upper() == field_upper:
                            ci = self._field_mapping_to_caliber(fm, tl.procedure or fm.procedure or "")
                            if ci:
                                results.append(ci)
                                matched = True

            if not matched:
                results.append(
                    _CaliberSourceRecord(
                        source_table=tl.source_table,
                        source_column=field_upper,
                        target_table=tl.target_table,
                        target_column=field_upper,
                        transform_logic="TABLE_LINEAGE_FALLBACK",
                        where_conditions=[],
                        join_conditions=[],
                        group_by_clause="",
                        having_clause="",
                        procedure=tl.procedure or "",
                        step_num=0,
                        step_desc="表级血缘回退(同名字段匹配)",
                        data_source=self._default_data_source,
                        raw_sql_fragment="",
                        confidence=0.5,
                    )
                )

        return results

    def _reconstruct_path(self, tree: dict[str, _CaliberBFSNode], end_node: _CaliberBFSNode) -> list[_CaliberBFSNode]:
        path: list[_CaliberBFSNode] = []
        current = end_node
        while True:
            path.insert(0, current)
            if not current.parent_key:
                break
            parent = tree.get(current.parent_key)
            if not parent:
                break
            current = parent
        return path

    def _paths_to_chains(
        self, paths: list[list[_CaliberBFSNode]], start_table: str, start_field: str
    ) -> list[CaliberChain]:
        chains: list[CaliberChain] = []
        seen_chain_signatures: set[str] = set()

        for path in paths:
            steps: list[CaliberInfo] = []
            for i, node in enumerate(path[1:], start=1):
                prev_node = path[i - 1]

                src_table = node.table_name
                src_field = node.field_name
                tgt_table = prev_node.table_name
                tgt_field = prev_node.field_name

                tgt_key = self.make_key(tgt_table, tgt_field)
                records = self._target_idx.get(tgt_key, [])

                src_short = src_table.split(".")[-1].upper() if src_table else ""
                matching_records = [
                    r
                    for r in records
                    if r.get("source_table", "").upper().split(".")[-1] == src_short
                    and r.get("source_column", "").upper() == src_field.upper()
                ]

                if not matching_records:
                    src_variants = [src_table] + self._build_schema_variants(src_short)
                    for variant in src_variants:
                        v_short = variant.split(".")[-1].upper()
                        matching_records = [
                            r
                            for r in records
                            if r.get("source_table", "").upper().split(".")[-1] == v_short
                            and r.get("source_column", "").upper() == src_field.upper()
                        ]
                        if matching_records:
                            break

                if matching_records:
                    best = matching_records[0]
                    ci = CaliberExtractor.from_dict(best) if isinstance(best, dict) else best
                    if node.step_num > 0:
                        ci.step_num = node.step_num
                    if node.procedure:
                        ci.procedure = node.procedure

                    ci_src_short = (
                        ci.source_table.split(".")[-1]
                        if ci.source_table and "." in ci.source_table
                        else (ci.source_table or "")
                    )
                    ci_tgt_short = (
                        ci.target_table.split(".")[-1]
                        if ci.target_table and "." in ci.target_table
                        else (ci.target_table or "")
                    )
                    if not ci_src_short.strip() or not ci_tgt_short.strip():
                        continue

                    if not ci.source_table_layer and ci.source_table:
                        ci.source_table_layer = detect_layer(ci.source_table).value
                    if not ci.target_table_layer and ci.target_table:
                        ci.target_table_layer = detect_layer(ci.target_table).value

                    if not self.is_upstream_layer_compatible(ci.source_table, ci.target_table):
                        logger.debug(
                            "口径步骤层级不兼容，跳过: %s → %s",
                            ci.source_table,
                            ci.target_table,
                        )
                        continue

                    if steps:
                        prev_step = steps[-1]
                        prev_s = (
                            prev_step.source_table.split(".")[-1]
                            if prev_step.source_table and "." in prev_step.source_table
                            else (prev_step.source_table or "")
                        )
                        prev_t = (
                            prev_step.target_table.split(".")[-1]
                            if prev_step.target_table and "." in prev_step.target_table
                            else (prev_step.target_table or "")
                        )
                        if (
                            ci_src_short == prev_s
                            and ci_tgt_short == prev_t
                            and ci.source_column.upper() == prev_step.source_column.upper()
                            and ci.target_column.upper() == prev_step.target_column.upper()
                        ):
                            continue

                    steps.append(ci)
                else:
                    src_short_name = src_table.split(".")[-1] if src_table and "." in src_table else (src_table or "")
                    if not src_short_name.strip():
                        continue

                    src_layer = detect_layer(src_table).value if src_table else ""
                    tgt_short_name = tgt_table.split(".")[-1] if tgt_table and "." in tgt_table else (tgt_table or "")

                    if not tgt_short_name.strip():
                        continue

                    if not self.is_upstream_layer_compatible(src_table, tgt_table):
                        logger.debug(
                            "口径步骤层级不兼容(回退)，跳过: %s → %s",
                            src_table,
                            tgt_table,
                        )
                        continue

                    if steps:
                        prev_step = steps[-1]
                        prev_s = (
                            prev_step.source_table.split(".")[-1]
                            if prev_step.source_table and "." in prev_step.source_table
                            else (prev_step.source_table or "")
                        )
                        prev_t = (
                            prev_step.target_table.split(".")[-1]
                            if prev_step.target_table and "." in prev_step.target_table
                            else (prev_step.target_table or "")
                        )
                        if (
                            src_short_name == prev_s
                            and tgt_short_name == prev_t
                            and src_field.upper() == prev_step.source_column.upper()
                            and tgt_field.upper() == prev_step.target_column.upper()
                        ):
                            continue

                    steps.append(
                        CaliberInfo(
                            source_location=SourceLocation(
                                source_table=src_table,
                                source_column=src_field,
                            ),
                            target_table=tgt_table,
                            target_column=tgt_field,
                            procedure=node.procedure or "",
                            confidence=0.5,
                            source_table_layer=src_layer,
                            target_table_layer=detect_layer(tgt_table).value if tgt_table else "",
                            step_desc="表级血缘回退(同名字段匹配)"
                            if node.procedure == "TABLE_LINEAGE_FALLBACK"
                            else "",
                        )
                    )

            if not steps:
                continue

            self._inject_accumulated_conditions(steps)

            signature = "|".join(
                f"{s.source_table}.{s.source_column}->{s.target_table}.{s.target_column}" for s in steps
            )
            if signature in seen_chain_signatures:
                continue
            seen_chain_signatures.add(signature)

            chain = CaliberChain(
                target_table=start_table,
                target_column=start_field,
                steps=steps,
                depth=len(steps),
            )
            chains.append(chain)

        chains.sort(key=lambda c: c.depth)
        return chains

    @staticmethod
    def _inject_accumulated_conditions(steps: list[CaliberInfo]) -> None:
        acc_where: list[SQLCondition] = []
        acc_join: list[SQLCondition] = []

        for step in steps:
            acc_where.extend(step.where_conditions)
            acc_join.extend(step.join_conditions)

            seen_where = set()
            deduped_where: list[SQLCondition] = []
            for w in acc_where:
                if w.raw_text not in seen_where:
                    seen_where.add(w.raw_text)
                    deduped_where.append(w)

            seen_join = set()
            deduped_join: list[SQLCondition] = []
            for j in acc_join:
                if j.raw_text not in seen_join:
                    seen_join.add(j.raw_text)
                    deduped_join.append(j)

            step.accumulated_where = deduped_where
            step.accumulated_join = deduped_join

    def _get_records_for_node(self, key: tuple[str, str], node: _CaliberBFSNode) -> list[Any]:
        records = self._target_idx.get(key, [])
        if not records:
            short_key = (
                key[0].split(".")[-1],
                key[1],
            )
            records = self._target_idx.get(short_key, [])

        if node.procedure:
            filtered = [r for r in records if r.get("procedure", "") == node.procedure]
            if filtered:
                return filtered

        return records

    def _dict_to_record(self, d: dict) -> _CaliberSourceRecord:
        where_conds = d.get("where_conditions", [])
        join_conds = d.get("join_conditions", [])
        return _CaliberSourceRecord(
            source_table=d.get("source_table", ""),
            source_column=d.get("source_column", ""),
            target_table=d.get("target_table", ""),
            target_column=d.get("target_column", ""),
            transform_logic=d.get("transform_logic", ""),
            where_conditions=[dict(c) for c in where_conds],
            join_conditions=[dict(c) for c in join_conds],
            group_by_clause=d.get("group_by_clause", ""),
            having_clause=d.get("having_clause", ""),
            procedure=d.get("procedure", ""),
            step_num=d.get("step_num", 0),
            step_desc=d.get("step_desc", ""),
            data_source=d.get("data_source", self._default_data_source),
            raw_sql_fragment=d.get("raw_sql_fragment", ""),
            confidence=d.get("confidence", 1.0),
        )

    def _field_mapping_to_caliber(self, fm: FieldMapping, procedure: str) -> _CaliberSourceRecord | None:
        if not fm.source_table or not fm.source_column:
            return None
        return _CaliberSourceRecord(
            source_table=fm.source_table,
            source_column=fm.source_column,
            target_table=fm.target_table,
            target_column=fm.target_column,
            transform_logic=fm.transform_logic,
            where_conditions=[],
            join_conditions=[],
            group_by_clause="",
            having_clause="",
            procedure=procedure,
            step_num=0,
            step_desc="",
            data_source=self._default_data_source,
            raw_sql_fragment="",
            confidence=fm.confidence,
        )
