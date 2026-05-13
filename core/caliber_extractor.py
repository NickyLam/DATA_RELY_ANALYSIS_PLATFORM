"""
指标口径条件提取器
从 SQL 操作块中提取 WHERE / JOIN / GROUP BY / HAVING 条件，
构建 CaliberInfo 对象。设计为无状态工具类，被各数据源解析器复用。
"""

from __future__ import annotations

import re
import logging
from typing import Optional

from core.models import CaliberInfo, FieldMapping, SQLCondition

logger = logging.getLogger(__name__)

_WHERE_PATTERN = re.compile(
    r"\bWHERE\s+(.*?)(?:\bGROUP\s+BY\b|\bHAVING\b|\bORDER\s+BY\b|\bUNION\b|;|$)",
    re.IGNORECASE | re.DOTALL,
)

_JOIN_PATTERN = re.compile(
    r"\b(?:INNER\s+|LEFT\s+(?:OUTER\s+)?|RIGHT\s+(?:OUTER\s+)?|FULL\s+(?:OUTER\s+)?|CROSS\s+)?"
    r"JOIN\s+([\w.]+)\s+(?:AS\s+)?(\w+)?\s*ON\s+(.*?)(?="
    r"\b(?:INNER|LEFT|RIGHT|FULL|CROSS|WHERE|GROUP|HAVING|ORDER|UNION|SET|;)\b|$)",
    re.IGNORECASE | re.DOTALL,
)

_GROUP_BY_PATTERN = re.compile(
    r"\bGROUP\s+BY\s+(.*?)(?:\bHAVING\b|\bORDER\s+BY\b|\bUNION\b|;|$)",
    re.IGNORECASE | re.DOTALL,
)

_HAVING_PATTERN = re.compile(
    r"\bHAVING\s+(.*?)(?:\bORDER\s+BY\b|\bUNION\b|;|$)",
    re.IGNORECASE | re.DOTALL,
)

_TABLE_REF_PATTERN = re.compile(
    r"\b(?:FROM|JOIN)\s+([\w.]+)(?:\s+(?:AS\s+)?(\w+))?",
    re.IGNORECASE,
)

_FIELD_REF_PATTERN = re.compile(
    r"(?:^|[\s,(])((?:[\w.]+\.)?[\w]+)\s*(?:=|!=|<>|>|<|>=|<=|LIKE|IN|BETWEEN|IS)",
    re.IGNORECASE,
)


class CaliberExtractor:
    """指标口径条件提取器（无状态工具类）"""

    @staticmethod
    def extract_conditions(
        sql_block: str,
        dialect: str = "oracle",
    ) -> tuple[list[SQLCondition], list[SQLCondition], str, str]:
        """从一条 SQL 操作块中提取所有条件信息

        Returns:
            (where_conditions, join_conditions, group_by_clause, having_clause)
        """
        where_conditions = CaliberExtractor._extract_where(sql_block)
        join_conditions = CaliberExtractor._extract_joins(sql_block)
        group_by_clause = CaliberExtractor._extract_group_by(sql_block)
        having_clause = CaliberExtractor._extract_having(sql_block)
        return where_conditions, join_conditions, group_by_clause, having_clause

    @staticmethod
    def build_caliber_info(
        field_mapping: FieldMapping,
        sql_block: str,
        procedure: str,
        step_num: int = 0,
        step_desc: str = "",
        data_source: str = "oracle",
    ) -> CaliberInfo:
        """从 FieldMapping + SQL 块构建完整的 CaliberInfo"""
        where_conds, join_conds, group_by, having = CaliberExtractor.extract_conditions(
            sql_block, dialect=data_source
        )

        return CaliberInfo(
            target_table=field_mapping.target_table,
            target_column=field_mapping.target_column,
            source_table=field_mapping.source_table,
            source_column=field_mapping.source_column,
            transform_logic=field_mapping.transform_logic,
            where_conditions=where_conds,
            join_conditions=join_conds,
            group_by_clause=group_by,
            having_clause=having,
            procedure=procedure,
            step_num=step_num,
            step_desc=step_desc,
            data_source=data_source,
            raw_sql_fragment=_truncate_sql(sql_block, max_len=2000),
            confidence=field_mapping.confidence,
        )

    @staticmethod
    def build_caliber_infos(
        mappings: list[FieldMapping],
        sql_block: str,
        procedure: str,
        step_num: int = 0,
        step_desc: str = "",
        data_source: str = "oracle",
    ) -> list[CaliberInfo]:
        """批量构建 CaliberInfo（同一 SQL 块产出多个字段映射时复用条件提取）"""
        if not mappings:
            return []

        where_conds, join_conds, group_by, having = CaliberExtractor.extract_conditions(
            sql_block, dialect=data_source
        )

        results: list[CaliberInfo] = []
        for fm in mappings:
            results.append(CaliberInfo(
                target_table=fm.target_table,
                target_column=fm.target_column,
                source_table=fm.source_table,
                source_column=fm.source_column,
                transform_logic=fm.transform_logic,
                where_conditions=where_conds,
                join_conditions=join_conds,
                group_by_clause=group_by,
                having_clause=having,
                procedure=procedure,
                step_num=step_num,
                step_desc=step_desc,
                data_source=data_source,
                raw_sql_fragment=_truncate_sql(sql_block, max_len=2000),
                confidence=fm.confidence,
            ))
        return results

    @staticmethod
    def _extract_where(sql_block: str) -> list[SQLCondition]:
        match = _WHERE_PATTERN.search(sql_block)
        if not match:
            return []

        raw_text = match.group(1).strip()
        if not raw_text:
            return []

        fields_involved = _extract_field_refs(raw_text)
        tables_involved = _extract_table_refs(raw_text)

        return [SQLCondition(
            condition_type="WHERE",
            raw_text=raw_text,
            tables_involved=tables_involved,
            fields_involved=fields_involved,
        )]

    @staticmethod
    def _extract_joins(sql_block: str) -> list[SQLCondition]:
        results: list[SQLCondition] = []
        for match in _JOIN_PATTERN.finditer(sql_block):
            join_table = match.group(1).strip()
            join_cond = match.group(3).strip() if match.group(3) else ""
            if not join_cond:
                continue

            results.append(SQLCondition(
                condition_type="JOIN",
                raw_text=f"JOIN {join_table} ON {join_cond}",
                tables_involved=[join_table.upper()] + _extract_table_refs(join_cond),
                fields_involved=_extract_field_refs(join_cond),
            ))
        return results

    @staticmethod
    def _extract_group_by(sql_block: str) -> str:
        match = _GROUP_BY_PATTERN.search(sql_block)
        if match:
            return match.group(1).strip()
        return ""

    @staticmethod
    def _extract_having(sql_block: str) -> str:
        match = _HAVING_PATTERN.search(sql_block)
        if match:
            return match.group(1).strip()
        return ""

    @staticmethod
    def to_dict(caliber_info: CaliberInfo) -> dict:
        """将 CaliberInfo 序列化为字典"""
        return {
            "target_table": caliber_info.target_table,
            "target_column": caliber_info.target_column,
            "source_table": caliber_info.source_table,
            "source_column": caliber_info.source_column,
            "transform_logic": caliber_info.transform_logic,
            "where_conditions": [
                {
                    "condition_type": c.condition_type,
                    "raw_text": c.raw_text,
                    "tables_involved": c.tables_involved,
                    "fields_involved": c.fields_involved,
                }
                for c in caliber_info.where_conditions
            ],
            "join_conditions": [
                {
                    "condition_type": c.condition_type,
                    "raw_text": c.raw_text,
                    "tables_involved": c.tables_involved,
                    "fields_involved": c.fields_involved,
                }
                for c in caliber_info.join_conditions
            ],
            "group_by_clause": caliber_info.group_by_clause,
            "having_clause": caliber_info.having_clause,
            "procedure": caliber_info.procedure,
            "step_num": caliber_info.step_num,
            "step_desc": caliber_info.step_desc,
            "data_source": caliber_info.data_source,
            "raw_sql_fragment": caliber_info.raw_sql_fragment,
            "confidence": caliber_info.confidence,
        }

    @staticmethod
    def from_dict(data: dict) -> CaliberInfo:
        """从字典反序列化为 CaliberInfo"""
        where_conditions = [
            SQLCondition(
                condition_type=c.get("condition_type", ""),
                raw_text=c.get("raw_text", ""),
                tables_involved=c.get("tables_involved", []),
                fields_involved=c.get("fields_involved", []),
            )
            for c in data.get("where_conditions", [])
        ]
        join_conditions = [
            SQLCondition(
                condition_type=c.get("condition_type", ""),
                raw_text=c.get("raw_text", ""),
                tables_involved=c.get("tables_involved", []),
                fields_involved=c.get("fields_involved", []),
            )
            for c in data.get("join_conditions", [])
        ]
        return CaliberInfo(
            target_table=data.get("target_table", ""),
            target_column=data.get("target_column", ""),
            source_table=data.get("source_table", ""),
            source_column=data.get("source_column", ""),
            transform_logic=data.get("transform_logic", ""),
            where_conditions=where_conditions,
            join_conditions=join_conditions,
            group_by_clause=data.get("group_by_clause", ""),
            having_clause=data.get("having_clause", ""),
            procedure=data.get("procedure", ""),
            step_num=data.get("step_num", 0),
            step_desc=data.get("step_desc", ""),
            data_source=data.get("data_source", "oracle"),
            raw_sql_fragment=data.get("raw_sql_fragment", ""),
            confidence=data.get("confidence", 1.0),
        )


def _truncate_sql(sql: str, max_len: int = 2000) -> str:
    if len(sql) <= max_len:
        return sql.strip()
    return sql[:max_len].strip() + "..."


def _extract_table_refs(text: str) -> list[str]:
    tables: list[str] = []
    for match in _TABLE_REF_PATTERN.finditer(text):
        table_name = match.group(1).strip().upper()
        if table_name and table_name not in ("DUAL", "SELECT"):
            tables.append(table_name)
    return list(dict.fromkeys(tables))


def _extract_field_refs(text: str) -> list[str]:
    fields: list[str] = []
    for match in _FIELD_REF_PATTERN.finditer(text):
        field_name = match.group(1).strip().upper()
        if field_name and not field_name.startswith(("SELECT", "FROM", "WHERE", "AND", "OR")):
            fields.append(field_name)
    return list(dict.fromkeys(fields))
