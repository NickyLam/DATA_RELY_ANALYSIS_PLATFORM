"""
指标口径条件提取器（兼容门面）
从 SQL 操作块中提取 WHERE / JOIN / GROUP BY / HAVING 条件，
以及操作类型、SELECT列映射、DISTINCT、ORDER BY、窗口函数、集合运算、子查询等，
构建增强版 CaliberInfo 对象。

本模块为兼容门面，实际实现已拆分到：
  - core/caliber_condition.py    (ConditionExtractor: WHERE/JOIN/GROUP BY/HAVING/步骤隔离)
  - core/caliber_metadata.py     (MetadataExtractor: CTE/窗口函数/子查询/自定义函数/元数据)
  - core/caliber_expression.py   (ExpressionBuilder: SELECT列/完整表达式/CaliberInfo构建)

保留 CaliberExtractor 类及其全部 public/private 静态方法签名，
确保既有调用方（analyze_lineage、procedure_parser、caliber_tracer 等）无需修改。
"""

from __future__ import annotations

from core.caliber_condition import ConditionExtractor
from core.caliber_expression import ExpressionBuilder
from core.caliber_metadata import MetadataExtractor
from core.models import (
    CaliberInfo,
    FieldMapping,
    SelectColumnMapping,
    SQLCondition,
)


class CaliberExtractor:
    """指标口径条件提取器（兼容门面，无状态工具类）

    所有方法委托到 ConditionExtractor / MetadataExtractor / ExpressionBuilder。
    保留此类仅为向后兼容，新代码应直接使用拆分后的模块。
    """

    # ------------------------------------------------------------------
    # 公共 API
    # ------------------------------------------------------------------

    @staticmethod
    def extract_conditions(
        sql_block: str,
        dialect: str = "oracle",
    ) -> tuple[list[SQLCondition], list[SQLCondition], str, str]:
        """提取 WHERE/JOIN/GROUP BY/HAVING 条件。委托到 ConditionExtractor。"""
        return ConditionExtractor.extract_conditions(sql_block, dialect=dialect)

    @staticmethod
    def extract_enhanced_metadata(sql_block: str) -> dict:
        """从SQL块提取增强版元数据。委托到 MetadataExtractor。

        Returns:
            dict 包含以下键:
              - operation_type: SQL操作类型
              - distinct_flag: 是否DISTINCT
              - order_by_clause: ORDER BY子句
              - set_operation: 集合运算类型
              - select_columns: SELECT列映射列表
              - window_functions: 窗口函数列表
              - subqueries: 子查询信息列表
        """
        return MetadataExtractor.extract_enhanced_metadata(sql_block)

    @staticmethod
    def build_caliber_info(
        field_mapping: FieldMapping,
        sql_block: str,
        procedure: str,
        step_num: int = 0,
        step_desc: str = "",
        data_source: str = "oracle",
        sql_operation_sequence: int = 0,
        file_path: str = "",
        start_line: int = 0,
        end_line: int = 0,
        accumulated_where: list[SQLCondition] | None = None,
        accumulated_join: list[SQLCondition] | None = None,
    ) -> CaliberInfo:
        """构建单个 CaliberInfo。委托到 ExpressionBuilder。"""
        return ExpressionBuilder.build_caliber_info(
            field_mapping=field_mapping,
            sql_block=sql_block,
            procedure=procedure,
            step_num=step_num,
            step_desc=step_desc,
            data_source=data_source,
            sql_operation_sequence=sql_operation_sequence,
            file_path=file_path,
            start_line=start_line,
            end_line=end_line,
            accumulated_where=accumulated_where,
            accumulated_join=accumulated_join,
        )

    @staticmethod
    def build_caliber_infos(
        mappings: list[FieldMapping],
        sql_block: str,
        procedure: str,
        step_num: int = 0,
        step_desc: str = "",
        data_source: str = "oracle",
        sql_operation_sequence: int = 0,
        file_path: str = "",
        start_line: int = 0,
        end_line: int = 0,
        accumulated_where: list[SQLCondition] | None = None,
        accumulated_join: list[SQLCondition] | None = None,
    ) -> list[CaliberInfo]:
        """批量构建 CaliberInfo。委托到 ExpressionBuilder。"""
        return ExpressionBuilder.build_caliber_infos(
            mappings=mappings,
            sql_block=sql_block,
            procedure=procedure,
            step_num=step_num,
            step_desc=step_desc,
            data_source=data_source,
            sql_operation_sequence=sql_operation_sequence,
            file_path=file_path,
            start_line=start_line,
            end_line=end_line,
            accumulated_where=accumulated_where,
            accumulated_join=accumulated_join,
        )

    # ------------------------------------------------------------------
    # 私有方法（委托到拆分模块，保留签名以兼容既有调用方）
    # ------------------------------------------------------------------

    # --- ConditionExtractor 委托 ---

    @staticmethod
    def _detect_operation_type(sql_block: str) -> str:
        return ConditionExtractor._detect_operation_type(sql_block)

    @staticmethod
    def _detect_distinct(sql_block: str) -> bool:
        return ConditionExtractor._detect_distinct(sql_block)

    @staticmethod
    def _detect_set_operation(sql_block: str) -> str:
        return ConditionExtractor._detect_set_operation(sql_block)

    @staticmethod
    def _extract_order_by(sql_block: str) -> str:
        return ConditionExtractor._extract_order_by(sql_block)

    @staticmethod
    def _extract_where(sql_block: str) -> list[SQLCondition]:
        return ConditionExtractor._extract_where(sql_block)

    @staticmethod
    def _extract_joins(sql_block: str) -> list[SQLCondition]:
        return ConditionExtractor._extract_joins(sql_block)

    @staticmethod
    def _extract_group_by(sql_block: str) -> str:
        return ConditionExtractor._extract_group_by(sql_block)

    @staticmethod
    def _extract_having(sql_block: str) -> str:
        return ConditionExtractor._extract_having(sql_block)

    @staticmethod
    def _extract_step_isolated_where(
        sql_block: str,
        accumulated_where: list[SQLCondition] | None = None,
    ) -> list[SQLCondition]:
        """提取步骤级隔离 WHERE 条件（非累积）。委托到 ConditionExtractor。"""
        return ConditionExtractor._extract_step_isolated_where(
            sql_block, accumulated_where=accumulated_where
        )

    @staticmethod
    def _extract_step_isolated_join(
        sql_block: str,
        accumulated_join: list[SQLCondition] | None = None,
    ) -> list[SQLCondition]:
        """提取步骤级隔离 JOIN 条件（非累积）。委托到 ConditionExtractor。"""
        return ConditionExtractor._extract_step_isolated_join(
            sql_block, accumulated_join=accumulated_join
        )

    # --- MetadataExtractor 委托 ---

    @staticmethod
    def _extract_window_functions(sql_block: str) -> list[str]:
        return MetadataExtractor._extract_window_functions(sql_block)

    @staticmethod
    def _extract_subqueries(sql_block: str):
        return MetadataExtractor._extract_subqueries(sql_block)

    @staticmethod
    def _extract_cte_definitions(sql_block: str) -> list[str]:
        """提取 WITH ... AS (...) CTE 定义。委托到 MetadataExtractor。"""
        return MetadataExtractor._extract_cte_definitions(sql_block)

    @staticmethod
    def _extract_custom_functions(sql_block: str) -> list[str]:
        """检测 Oracle 自定义函数调用。委托到 MetadataExtractor。"""
        return MetadataExtractor._extract_custom_functions(sql_block)

    # --- ExpressionBuilder 委托 ---

    @staticmethod
    def _extract_select_columns(sql_block: str) -> list[SelectColumnMapping]:
        return ExpressionBuilder._extract_select_columns(sql_block)

    @staticmethod
    def _filter_select_columns_for_field(
        all_columns: list[SelectColumnMapping],
        field_mapping: FieldMapping,
    ) -> list[SelectColumnMapping]:
        return ExpressionBuilder._filter_select_columns_for_field(all_columns, field_mapping)

    @staticmethod
    def _extract_full_expression(sql_block: str, target_column: str) -> str:
        """提取 SELECT 中目标字段对应的完整表达式。委托到 ExpressionBuilder。"""
        return ExpressionBuilder._extract_full_expression(sql_block, target_column)

    @staticmethod
    def to_dict(caliber_info: CaliberInfo) -> dict:
        return ExpressionBuilder.to_dict(caliber_info)

    @staticmethod
    def from_dict(data: dict) -> CaliberInfo:
        return ExpressionBuilder.from_dict(data)
