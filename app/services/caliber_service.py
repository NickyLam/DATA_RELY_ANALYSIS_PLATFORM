"""
指标口径查询服务
封装口径追溯逻辑，支持按表名+字段名查询指标口径链路
"""

from __future__ import annotations

import logging
from typing import Any, Optional

from core.caliber_extractor import CaliberExtractor
from core.caliber_tracer import CaliberTracer
from core.models import (
    CaliberChain,
    CaliberInfo,
    CaliberResult,
    FieldMapping,
    ProcedureInfo,
    TableInfo,
    TableLineage,
)
from core.table_name_resolver import TableNameResolver
from app.services.parser_service import ParserService
from app.utils.cache_manager import CacheManager

logger = logging.getLogger(__name__)


class CaliberService:
    """指标口径查询服务

    使用 CaliberTracer 进行多层 BFS 追溯，
    同时保留轻量级索引用于快速搜索和单步查询。
    """

    def __init__(
        self,
        parser_service: ParserService,
        cache_manager: CacheManager,
    ):
        self.parser = parser_service
        self.cache = cache_manager
        self._resolver = TableNameResolver()

        self._target_caliber_idx: dict[tuple[str, str], list[dict]] = {}
        self._source_caliber_idx: dict[tuple[str, str], list[dict]] = {}
        self._tracer: Optional[CaliberTracer] = None

        self._build_indexes()
        self._build_tracer()

    def _build_indexes(self) -> None:
        """构建轻量级索引（用于快速搜索和单步查询）。"""
        data = self.parser.get_current_data()
        if not data:
            return

        caliber_infos = data.get("caliber_infos", [])
        if not caliber_infos:
            return

        self._target_caliber_idx.clear()
        self._source_caliber_idx.clear()

        for ci in caliber_infos:
            target_table = ci.get("target_table", "").upper()
            target_column = ci.get("target_column", "").upper()
            source_table = ci.get("source_table", "").upper()
            source_column = ci.get("source_column", "").upper()

            target_key = self._make_key(target_table, target_column)
            source_key = self._make_key(source_table, source_column)

            self._target_caliber_idx.setdefault(target_key, []).append(ci)
            self._source_caliber_idx.setdefault(source_key, []).append(ci)

        logger.info(
            "口径索引构建完成: %d 条口径信息, %d 个目标索引, %d 个来源索引",
            len(caliber_infos),
            len(self._target_caliber_idx),
            len(self._source_caliber_idx),
        )

    def _build_tracer(self) -> None:
        """构建 CaliberTracer 实例（用于多层追溯）。"""
        data = self.parser.get_current_data()
        if not data:
            return

        tables_raw = data.get("tables", [])
        procedures_raw = data.get("procedures", [])
        table_lineages_raw = data.get("table_lineages", [])
        field_mappings_raw = data.get("field_mappings", [])
        caliber_infos_raw = data.get("caliber_infos", [])

        tables: dict[str, TableInfo] = {}
        for t in tables_raw:
            try:
                ti = TableInfo(
                    schema=t.get("schema", ""),
                    table_name=t.get("table_name", ""),
                    full_name=t.get("full_name", t.get("table_name", "")),
                )
                tables[ti.full_name.upper()] = ti
                tables[ti.table_name.upper()] = ti
            except Exception:
                continue

        procedures: dict[str, ProcedureInfo] = {}
        for p in procedures_raw:
            proc_info = ProcedureInfo(
                full_name=p.get("full_name", ""),
                schema=p.get("schema", ""),
                proc_name=p.get("proc_name", ""),
                description=p.get("description", ""),
                source_tables=p.get("source_tables", []),
                target_tables=p.get("target_tables", []),
            )
            procedures[proc_info.full_name] = proc_info

        table_lineages: list[TableLineage] = []
        for tl in table_lineages_raw:
            table_lineages.append(TableLineage(
                source_table=tl.get("source_table", ""),
                target_table=tl.get("target_table", ""),
                procedure=tl.get("procedure", ""),
            ))

        field_mappings: list[FieldMapping] = []
        for fm in field_mappings_raw:
            field_mappings.append(FieldMapping(
                source_table=fm.get("source_table", ""),
                source_column=fm.get("source_column", ""),
                target_table=fm.get("target_table", ""),
                target_column=fm.get("target_column", ""),
                transform_logic=fm.get("transform_logic", ""),
                procedure=fm.get("procedure", ""),
                confidence=fm.get("confidence", 1.0),
            ))

        self._tracer = CaliberTracer(
            tables=tables,
            procedures=procedures,
            table_lineages=table_lineages,
            field_mappings=field_mappings,
            caliber_infos=caliber_infos_raw,
        )
        logger.info("CaliberTracer 构建完成")

    def rebuild_indexes(self) -> None:
        """重建所有索引和 Tracer（数据更新后调用）。"""
        self._build_indexes()
        self._build_tracer()

    @staticmethod
    def _make_key(table: str, column: str) -> tuple[str, str]:
        short_table = table.split(".")[-1] if "." in table else table
        return (short_table.upper(), column.upper())

    # ===================================================================
    # 核心查询 API（使用 CaliberTracer）
    # ===================================================================

    def query_caliber(
        self,
        table: str,
        field: str,
        depth: int = 10,
        direction: str = "upstream",
        data_source: Optional[str] = None,
    ) -> dict[str, Any]:
        """查询指标口径（使用 CaliberTracer 多层追溯引擎）。

        Args:
            table: 目标表名
            field: 目标字段名
            depth: 追溯深度
            direction: 追溯方向 (upstream/downstream/both)
            data_source: 数据源筛选
        """
        if not self._tracer:
            return {
                "success": False,
                "message": "数据尚未加载，请先执行解析操作",
                "data": None,
            }

        result = self._tracer.trace_caliber(
            target_table=table,
            target_field=field,
            direction=direction,
            max_depth=depth,
            data_source=data_source,
        )

        return self._result_to_dict(result)

    def query_caliber_summary(self, table: str, field: str, **kwargs) -> str:
        """查询指标口径并返回可读的 Markdown 摘要文本。"""
        if not self._tracer:
            return "# 错误：数据尚未加载"

        result = self._tracer.trace_caliber(
            target_table=table,
            target_field=field,
            direction=kwargs.get("direction", "upstream"),
            max_depth=kwargs.get("depth", 10),
            data_source=kwargs.get("data_source"),
        )
        return self._tracer.generate_summary_text(result)

    def get_direct_sources(self, table: str, field: str) -> list[dict]:
        """获取目标字段的直接上游口径记录（一层，不递归）。"""
        if not self._tracer:
            return []

        records = self._tracer.get_direct_sources(table, field)
        return [self._record_to_dict(r) for r in records]

    def get_direct_targets(self, table: str, field: str) -> list[dict]:
        """获取源字段的直接下游口径记录（一层，不递归）。"""
        if not self._tracer:
            return []

        records = self._tracer.get_direct_targets(table, field)
        return [self._record_to_dict(r) for r in records]

    # ===================================================================
    # 快速搜索（使用轻量级索引）
    # ===================================================================

    def search_indicators(
        self,
        keyword: str,
        limit: int = 50,
        data_source: Optional[str] = None,
    ) -> list[dict]:
        """搜索指标口径（按关键词）—— 使用轻量级索引，响应 <10ms。"""
        data = self.parser.get_current_data()
        if not data:
            return []

        caliber_infos = data.get("caliber_infos", [])
        keyword_upper = keyword.upper()

        seen: set[tuple[str, str]] = set()
        results: list[dict] = []

        for ci in caliber_infos:
            if data_source and ci.get("data_source", "") != data_source:
                continue

            target_table = ci.get("target_table", "").upper()
            target_column = ci.get("target_column", "").upper()
            source_table = ci.get("source_table", "").upper()
            source_column = ci.get("source_column", "").upper()

            short_target = target_table.split(".")[-1] if "." in target_table else target_table
            short_source = source_table.split(".")[-1] if "." in source_table else source_table

            hit = (
                keyword_upper in short_target
                or keyword_upper in target_column
                or keyword_upper in short_source
                or keyword_upper in source_column
            )
            if not hit:
                continue

            target_key = (short_target, target_column)
            if target_key in seen:
                continue
            seen.add(target_key)

            results.append({
                "table": ci.get("target_table", ""),
                "field": ci.get("target_column", ""),
                "short_table": short_target,
                "data_source": ci.get("data_source", "oracle"),
                "transform_logic": ci.get("transform_logic", ""),
                "procedure": ci.get("procedure", ""),
                "has_conditions": bool(ci.get("where_conditions") or ci.get("join_conditions")),
            })

            if len(results) >= limit:
                break

        return results

    def get_datasources(self) -> list[dict]:
        """获取可用的数据源列表。"""
        from app.config import config

        return [
            {
                "name": ds.name,
                "display_name": ds.display_name,
                "file_extensions": ds.file_extensions,
            }
            for ds in config.datasource_configs
        ]

    # ===================================================================
    # 序列化工具方法
    # ===================================================================

    @staticmethod
    def _result_to_dict(result: CaliberResult) -> dict[str, Any]:
        """将 CaliberResult 转换为 API 响应字典。"""
        chains_data = []
        for chain in result.chains:
            steps_data = []
            for step in chain.steps:
                steps_data.append({
                    "target_table": step.target_table,
                    "target_column": step.target_column,
                    "source_table": step.source_table,
                    "source_column": step.source_column,
                    "transform_logic": step.transform_logic,
                    "where_conditions": [
                        {
                            "condition_type": c.condition_type,
                            "raw_text": c.raw_text,
                            "tables_involved": c.tables_involved,
                            "fields_involved": c.fields_involved,
                        }
                        for c in step.where_conditions
                    ],
                    "join_conditions": [
                        {
                            "condition_type": c.condition_type,
                            "raw_text": c.raw_text,
                            "tables_involved": c.tables_involved,
                            "fields_involved": c.fields_involved,
                        }
                        for c in step.join_conditions
                    ],
                    "group_by_clause": step.group_by_clause,
                    "having_clause": step.having_clause,
                    "procedure": step.procedure,
                    "step_num": step.step_num,
                    "step_desc": step.step_desc,
                    "data_source": step.data_source,
                    "raw_sql_fragment": step.raw_sql_fragment,
                    "confidence": step.confidence,
                })

            chains_data.append({
                "target_table": chain.target_table,
                "target_column": chain.target_column,
                "steps": steps_data,
                "depth": chain.depth,
                "summary": chain.summary,
            })

        return {
            "target_table": result.target_table,
            "target_column": result.target_column,
            "chains": chains_data,
            "total_steps": result.total_steps,
            "total_conditions": result.total_conditions,
            "query_time_ms": result.query_time_ms,
        }

    @staticmethod
    def _record_to_dict(record) -> dict:
        """将内部记录对象转换为字典。"""
        return {
            "source_table": record.source_table,
            "source_column": record.source_column,
            "target_table": record.target_table,
            "target_column": record.target_column,
            "transform_logic": record.transform_logic,
            "where_conditions": record.where_conditions,
            "join_conditions": record.join_conditions,
            "group_by_clause": record.group_by_clause,
            "having_clause": record.having_clause,
            "procedure": record.procedure,
            "step_num": record.step_num,
            "step_desc": record.step_desc,
            "data_source": record.data_source,
            "raw_sql_fragment": record.raw_sql_fragment,
            "confidence": record.confidence,
        }
