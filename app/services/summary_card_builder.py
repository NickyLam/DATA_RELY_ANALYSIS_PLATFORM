"""指标概览卡构建器

从 UnifiedTracer.trace_caliber 的 CaliberResult 构建给前端节点浮窗用的
summary card 数据（指标 + 技术口径摘要 + 统计 + 质量标记 + 完整规格）。

P5 迁移：原 CaliberService.build_summary_card 拆分到此独立模块，
LineageService 调用，作为节点浮窗 /api/lineage/node-caliber 的后端。
"""

from __future__ import annotations

import re
import time
from typing import Any

_HARDCODED_PATTERN = re.compile(r"=\s*['\"]?[01]['\"]?|=\s*\d+")
_NULL_PATTERN = re.compile(r"(NVL|COALESCE|IS\s+NULL)", re.IGNORECASE)


def _step_to_dict(step: Any) -> dict[str, Any]:
    """简化版 CaliberStep 序列化，只输出 summary card 需要的字段。"""
    return {
        "target_table": step.target_table,
        "target_column": step.target_column,
        "source_table": step.source_table,
        "source_column": step.source_column,
        "transform_logic": step.transform_logic,
        "procedure": step.procedure,
        "target_table_layer": getattr(step, "target_table_layer", ""),
        "full_expression": getattr(step, "full_expression", ""),
        "where_conditions": [
            {
                "raw_text": getattr(c, "raw_text", ""),
                "tables_involved": getattr(c, "tables_involved", []),
            }
            for c in step.where_conditions
        ],
        "join_conditions": [{"tables_involved": getattr(c, "tables_involved", [])} for c in step.join_conditions],
        "custom_functions": list(getattr(step, "custom_functions", []) or []),
        "caliber_spec": step.generate_caliber_spec() if hasattr(step, "generate_caliber_spec") else "",
    }


def _build_technical_summary(chain_steps: list[dict]) -> str:
    if not chain_steps:
        return ""
    parts: list[str] = []
    n = len(chain_steps)
    for i, step in enumerate(chain_steps):
        full_expr = step.get("full_expression") or step.get("transform_logic") or ""
        src_col = step.get("source_column", "")
        tgt_col = step.get("target_column", "")
        layer = step.get("target_table_layer", "")
        if i == 0:
            parts.append(full_expr if (full_expr and full_expr != src_col) else src_col)
        elif i == n - 1:
            parts.append(tgt_col)
        else:
            if full_expr and full_expr != src_col:
                parts.append(f"[{layer} {full_expr}]" if layer else f"[{full_expr}]")
            else:
                parts.append(src_col)
    return " → ".join(parts)


def _detect_quality_flags(chains: list[dict]) -> dict:
    flags = {
        "has_hardcoded_values": False,
        "has_cross_schema_join": False,
        "has_null_branch": False,
        "has_custom_function": False,
    }
    for chain in chains:
        for step in chain.get("steps", []):
            for wc in step.get("where_conditions", []):
                if _HARDCODED_PATTERN.search(wc.get("raw_text", "") or ""):
                    flags["has_hardcoded_values"] = True
            for jc in step.get("join_conditions", []):
                schemas = set()
                for t in jc.get("tables_involved", []):
                    if "." in t:
                        schemas.add(t.split(".")[0])
                if len(schemas) > 1:
                    flags["has_cross_schema_join"] = True
            full_expr = step.get("full_expression") or ""
            tl = step.get("transform_logic") or ""
            if _NULL_PATTERN.search(full_expr) or _NULL_PATTERN.search(tl):
                flags["has_null_branch"] = True
            if step.get("custom_functions"):
                flags["has_custom_function"] = True
    return flags


def _build_summary_stats(chains: list[dict]) -> dict:
    parallel_paths = len(chains)
    total_steps = sum(c.get("depth", 0) for c in chains)
    procedures: set[str] = set()
    tables: set[str] = set()
    custom_functions: set[str] = set()
    for chain in chains:
        for step in chain.get("steps", []):
            if step.get("procedure"):
                procedures.add(step["procedure"])
            for k in ("target_table", "source_table"):
                t = step.get(k) or ""
                if t:
                    tables.add(t.split(".")[-1])
            for cf in step.get("custom_functions", []):
                custom_functions.add(cf)
    return {
        "parallel_paths": parallel_paths,
        "total_steps": total_steps,
        "procedures": sorted(procedures),
        "tables": sorted(tables),
        "custom_functions": sorted(custom_functions),
    }


def build_summary_card(
    unified_tracer: Any,
    table: str,
    field: str,
    direction: str = "upstream",
    depth: int = 10,
    data_source: str | None = None,
) -> dict:
    """构建节点浮窗用的指标概览卡。

    Args:
        unified_tracer: UnifiedTracer 实例（必须）
        table: 目标表名
        field: 目标字段名
    """
    if unified_tracer is None:
        return {"success": False, "message": "tracer 未初始化", "data": None}

    start = time.time()
    result = unified_tracer.trace_caliber(
        table=table,
        field=field,
        direction=direction,
        max_depth=depth,
        data_source=data_source,
    )
    if result is None or not result.chains:
        return {"success": False, "message": "未找到该字段的口径数据", "data": None}

    chains_dict: list[dict] = []
    for chain in result.chains:
        chains_dict.append(
            {
                "depth": chain.depth,
                "steps": [_step_to_dict(s) for s in chain.steps],
            }
        )

    target_table = result.target_table
    short_table = target_table.split(".")[-1]
    target_column = result.target_column

    first_chain_steps = chains_dict[0]["steps"] if chains_dict else []
    caliber_chain_text = [s.get("caliber_spec", "") for s in first_chain_steps]
    query_time_ms = (time.time() - start) * 1000

    return {
        "success": True,
        "data": {
            "indicator": f"{target_table}.{target_column}",
            "indicator_short": f"{short_table}.{target_column}",
            "technical_caliber_summary": _build_technical_summary(first_chain_steps),
            "caliber_chain_text": caliber_chain_text,
            "stats": _build_summary_stats(chains_dict),
            "data_quality_flags": _detect_quality_flags(chains_dict),
            "query_time_ms": query_time_ms,
        },
    }
