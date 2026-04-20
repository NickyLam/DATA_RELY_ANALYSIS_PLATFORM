"""
血缘提取规则引擎
定义和执行血缘关系提取规则
"""
import re
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from enum import Enum
from typing import Optional, List, Dict, Any, Set, Tuple, Callable

from app.parsers.sql_parser import (
    ParsedSQL,
    SQLStatementType,
    TableReference,
    ColumnReference,
    JoinClause,
)
from app.parsers.oracle_dialect import OracleParsedSQL


class LineageType(Enum):
    TABLE_TO_TABLE = "TABLE_TO_TABLE"
    COLUMN_TO_COLUMN = "COLUMN_TO_COLUMN"
    TABLE_TO_COLUMN = "TABLE_TO_COLUMN"
    COLUMN_TO_TABLE = "COLUMN_TO_TABLE"


class TransformationType(Enum):
    DIRECT = "DIRECT"
    DERIVED = "DERIVED"
    AGGREGATED = "AGGREGATED"
    JOINED = "JOINED"
    UNIONED = "UNIONED"
    FILTERED = "FILTERED"
    TRANSFORMED = "TRANSFORMED"
    CONDITIONAL = "CONDITIONAL"
    MERGED = "MERGED"


@dataclass
class LineageRule:
    name: str
    description: str
    statement_types: List[SQLStatementType]
    priority: int = 100
    enabled: bool = True


@dataclass
class TableLineage:
    source_table: TableReference
    target_table: TableReference
    transformation_type: TransformationType
    expression: Optional[str] = None
    confidence_score: float = 1.0
    metadata: Dict[str, Any] = field(default_factory=dict)


@dataclass
class ColumnLineage:
    source_column: ColumnReference
    target_column: ColumnReference
    source_table: Optional[TableReference] = None
    target_table: Optional[TableReference] = None
    transformation_type: TransformationType = TransformationType.DIRECT
    expression: Optional[str] = None
    confidence_score: float = 1.0
    metadata: Dict[str, Any] = field(default_factory=dict)


@dataclass
class LineageExtractionResult:
    table_lineages: List[TableLineage] = field(default_factory=list)
    column_lineages: List[ColumnLineage] = field(default_factory=list)
    errors: List[str] = field(default_factory=list)
    warnings: List[str] = field(default_factory=list)
    metadata: Dict[str, Any] = field(default_factory=dict)


class BaseLineageRule(ABC):
    """
    血缘提取规则基类
    """

    def __init__(self, rule: LineageRule):
        self.rule = rule

    @abstractmethod
    def apply(self, parsed_sql: ParsedSQL) -> LineageExtractionResult:
        pass

    def can_apply(self, parsed_sql: ParsedSQL) -> bool:
        return (
            self.rule.enabled
            and parsed_sql.statement_type in self.rule.statement_types
        )


class SelectLineageRule(BaseLineageRule):
    """
    SELECT 语句血缘提取规则
    """

    def __init__(self):
        super().__init__(LineageRule(
            name="select_lineage",
            description="提取 SELECT 语句的表级血缘",
            statement_types=[SQLStatementType.SELECT, SQLStatementType.WITH],
            priority=100,
        ))

    def apply(self, parsed_sql: ParsedSQL) -> LineageExtractionResult:
        result = LineageExtractionResult()

        if not parsed_sql.source_tables:
            result.warnings.append("SELECT 语句没有源表")
            return result

        for cte_name, cte_parsed in parsed_sql.ctes.items():
            cte_result = self.apply(cte_parsed)
            result.table_lineages.extend(cte_result.table_lineages)
            result.column_lineages.extend(cte_result.column_lineages)

        for subquery in parsed_sql.subqueries:
            subquery_result = self.apply(subquery)
            result.table_lineages.extend(subquery_result.table_lineages)
            result.column_lineages.extend(subquery_result.column_lineages)

        result.metadata["source_tables"] = [t.full_name for t in parsed_sql.source_tables]
        result.metadata["columns"] = [c.full_name for c in parsed_sql.source_columns]

        return result


class InsertLineageRule(BaseLineageRule):
    """
    INSERT 语句血缘提取规则
    """

    def __init__(self):
        super().__init__(LineageRule(
            name="insert_lineage",
            description="提取 INSERT 语句的表级和字段级血缘",
            statement_types=[SQLStatementType.INSERT],
            priority=100,
        ))

    def apply(self, parsed_sql: ParsedSQL) -> LineageExtractionResult:
        result = LineageExtractionResult()

        if not parsed_sql.target_tables:
            result.errors.append("INSERT 语句没有目标表")
            return result

        target_table = parsed_sql.target_tables[0]

        for source_table in parsed_sql.source_tables:
            lineage = TableLineage(
                source_table=source_table,
                target_table=target_table,
                transformation_type=TransformationType.DIRECT,
                confidence_score=1.0,
            )
            result.table_lineages.append(lineage)

        for source_col in parsed_sql.source_columns:
            for target_col in parsed_sql.target_columns:
                col_lineage = ColumnLineage(
                    source_column=source_col,
                    target_column=target_col,
                    source_table=parsed_sql.source_tables[0] if parsed_sql.source_tables else None,
                    target_table=target_table,
                    transformation_type=TransformationType.DIRECT,
                    confidence_score=0.9,
                )
                result.column_lineages.append(col_lineage)

        return result


class UpdateLineageRule(BaseLineageRule):
    """
    UPDATE 语句血缘提取规则
    """

    def __init__(self):
        super().__init__(LineageRule(
            name="update_lineage",
            description="提取 UPDATE 语句的表级和字段级血缘",
            statement_types=[SQLStatementType.UPDATE],
            priority=100,
        ))

    def apply(self, parsed_sql: ParsedSQL) -> LineageExtractionResult:
        result = LineageExtractionResult()

        if not parsed_sql.target_tables:
            result.errors.append("UPDATE 语句没有目标表")
            return result

        target_table = parsed_sql.target_tables[0]

        for target_col in parsed_sql.target_columns:
            col_lineage = ColumnLineage(
                source_column=target_col,
                target_column=target_col,
                source_table=target_table,
                target_table=target_table,
                transformation_type=TransformationType.TRANSFORMED,
                expression=parsed_sql.where_clause,
                confidence_score=0.8,
            )
            result.column_lineages.append(col_lineage)

        result.metadata["is_self_referential"] = True

        return result


class DeleteLineageRule(BaseLineageRule):
    """
    DELETE 语句血缘提取规则
    """

    def __init__(self):
        super().__init__(LineageRule(
            name="delete_lineage",
            description="提取 DELETE 语句的表级血缘",
            statement_types=[SQLStatementType.DELETE],
            priority=100,
        ))

    def apply(self, parsed_sql: ParsedSQL) -> LineageExtractionResult:
        result = LineageExtractionResult()

        if not parsed_sql.target_tables:
            result.errors.append("DELETE 语句没有目标表")
            return result

        result.metadata["operation"] = "DELETE"
        result.metadata["target_table"] = parsed_sql.target_tables[0].full_name

        return result


class CreateTableAsSelectRule(BaseLineageRule):
    """
    CREATE TABLE AS SELECT 语句血缘提取规则
    """

    def __init__(self):
        super().__init__(LineageRule(
            name="create_table_as_select",
            description="提取 CTAS 语句的表级和字段级血缘",
            statement_types=[SQLStatementType.CREATE],
            priority=100,
        ))

    def apply(self, parsed_sql: ParsedSQL) -> LineageExtractionResult:
        result = LineageExtractionResult()

        if not parsed_sql.target_tables:
            result.warnings.append("CREATE TABLE 语句没有目标表")
            return result

        if not parsed_sql.source_tables:
            result.warnings.append("CREATE TABLE AS SELECT 没有 SELECT 子句")
            return result

        target_table = parsed_sql.target_tables[0]

        for source_table in parsed_sql.source_tables:
            lineage = TableLineage(
                source_table=source_table,
                target_table=target_table,
                transformation_type=TransformationType.DERIVED,
                confidence_score=1.0,
            )
            result.table_lineages.append(lineage)

        for i, source_col in enumerate(parsed_sql.source_columns):
            target_col_name = source_col.name
            col_lineage = ColumnLineage(
                source_column=source_col,
                target_column=ColumnReference(name=target_col_name, is_target=True),
                source_table=parsed_sql.source_tables[0] if parsed_sql.source_tables else None,
                target_table=target_table,
                transformation_type=TransformationType.DIRECT,
                confidence_score=1.0,
            )
            result.column_lineages.append(col_lineage)

        return result


class MergeLineageRule(BaseLineageRule):
    """
    MERGE 语句血缘提取规则
    """

    def __init__(self):
        super().__init__(LineageRule(
            name="merge_lineage",
            description="提取 MERGE 语句的表级和字段级血缘",
            statement_types=[SQLStatementType.MERGE],
            priority=100,
        ))

    def apply(self, parsed_sql: ParsedSQL) -> LineageExtractionResult:
        result = LineageExtractionResult()

        if not parsed_sql.merge_source or not parsed_sql.merge_target:
            result.errors.append("MERGE 语句缺少源表或目标表")
            return result

        lineage = TableLineage(
            source_table=parsed_sql.merge_source,
            target_table=parsed_sql.merge_target,
            transformation_type=TransformationType.MERGED,
            expression=parsed_sql.merge_condition,
            confidence_score=1.0,
        )
        result.table_lineages.append(lineage)

        if isinstance(parsed_sql, OracleParsedSQL):
            for merge_clause in parsed_sql.merge_clauses:
                if merge_clause.match_type == "MATCHED":
                    for col, val in merge_clause.update_columns:
                        col_lineage = ColumnLineage(
                            source_column=ColumnReference(name=val, expression=val),
                            target_column=ColumnReference(name=col, is_target=True),
                            source_table=parsed_sql.merge_source,
                            target_table=parsed_sql.merge_target,
                            transformation_type=TransformationType.CONDITIONAL,
                            expression=merge_clause.condition,
                            confidence_score=0.9,
                        )
                        result.column_lineages.append(col_lineage)

                elif merge_clause.match_type == "NOT_MATCHED":
                    for i, col in enumerate(merge_clause.insert_columns):
                        if i < len(merge_clause.insert_values):
                            val = merge_clause.insert_values[i]
                            col_lineage = ColumnLineage(
                                source_column=ColumnReference(name=val, expression=val),
                                target_column=ColumnReference(name=col, is_target=True),
                                source_table=parsed_sql.merge_source,
                                target_table=parsed_sql.merge_target,
                                transformation_type=TransformationType.DIRECT,
                                confidence_score=0.9,
                            )
                            result.column_lineages.append(col_lineage)

        result.metadata["merge_condition"] = parsed_sql.merge_condition

        return result


class JoinLineageRule(BaseLineageRule):
    """
    JOIN 关系血缘提取规则
    """

    def __init__(self):
        super().__init__(LineageRule(
            name="join_lineage",
            description="提取 JOIN 关系的血缘",
            statement_types=[
                SQLStatementType.SELECT,
                SQLStatementType.WITH,
                SQLStatementType.INSERT,
                SQLStatementType.UPDATE,
                SQLStatementType.DELETE,
            ],
            priority=50,
        ))

    def apply(self, parsed_sql: ParsedSQL) -> LineageExtractionResult:
        result = LineageExtractionResult()

        for join in parsed_sql.joins:
            if join.left_table and join.right_table:
                lineage = TableLineage(
                    source_table=join.right_table,
                    target_table=join.left_table,
                    transformation_type=TransformationType.JOINED,
                    expression=join.condition,
                    confidence_score=0.9,
                    metadata={"join_type": join.join_type},
                )
                result.table_lineages.append(lineage)

        return result


class SubqueryLineageRule(BaseLineageRule):
    """
    子查询血缘提取规则
    """

    def __init__(self):
        super().__init__(LineageRule(
            name="subquery_lineage",
            description="提取子查询的血缘关系",
            statement_types=[
                SQLStatementType.SELECT,
                SQLStatementType.WITH,
                SQLStatementType.INSERT,
                SQLStatementType.UPDATE,
                SQLStatementType.DELETE,
            ],
            priority=30,
        ))

    def apply(self, parsed_sql: ParsedSQL) -> LineageExtractionResult:
        result = LineageExtractionResult()

        for subquery in parsed_sql.subqueries:
            subquery_result = self._extract_subquery_lineage(subquery, parsed_sql)
            result.table_lineages.extend(subquery_result.table_lineages)
            result.column_lineages.extend(subquery_result.column_lineages)

        return result

    def _extract_subquery_lineage(
        self, subquery: ParsedSQL, parent: ParsedSQL
    ) -> LineageExtractionResult:
        result = LineageExtractionResult()

        for source_table in subquery.source_tables:
            for parent_table in parent.source_tables:
                if source_table.name == parent_table.name:
                    lineage = TableLineage(
                        source_table=source_table,
                        target_table=parent_table,
                        transformation_type=TransformationType.DERIVED,
                        confidence_score=0.8,
                        metadata={"is_subquery": True},
                    )
                    result.table_lineages.append(lineage)

        return result


class LineageRuleEngine:
    """
    血缘提取规则引擎
    管理和执行所有血缘提取规则
    """

    def __init__(self):
        self._rules: List[BaseLineageRule] = []
        self._register_default_rules()

    def _register_default_rules(self) -> None:
        self._rules = [
            SelectLineageRule(),
            InsertLineageRule(),
            UpdateLineageRule(),
            DeleteLineageRule(),
            CreateTableAsSelectRule(),
            MergeLineageRule(),
            JoinLineageRule(),
            SubqueryLineageRule(),
        ]
        self._rules.sort(key=lambda r: r.rule.priority, reverse=True)

    def register_rule(self, rule: BaseLineageRule) -> None:
        self._rules.append(rule)
        self._rules.sort(key=lambda r: r.rule.priority, reverse=True)

    def extract_lineage(self, parsed_sql: ParsedSQL) -> LineageExtractionResult:
        final_result = LineageExtractionResult()

        for rule in self._rules:
            if rule.can_apply(parsed_sql):
                try:
                    result = rule.apply(parsed_sql)
                    final_result.table_lineages.extend(result.table_lineages)
                    final_result.column_lineages.extend(result.column_lineages)
                    final_result.errors.extend(result.errors)
                    final_result.warnings.extend(result.warnings)
                except Exception as e:
                    final_result.errors.append(f"规则 {rule.rule.name} 执行失败: {str(e)}")

        final_result = self._deduplicate_lineages(final_result)
        final_result = self._calculate_confidence_scores(final_result)

        return final_result

    def _deduplicate_lineages(self, result: LineageExtractionResult) -> LineageExtractionResult:
        seen_table_lineages: Set[Tuple[str, str, str]] = set()
        unique_table_lineages: List[TableLineage] = []

        for lineage in result.table_lineages:
            key = (
                lineage.source_table.full_name,
                lineage.target_table.full_name,
                lineage.transformation_type.value,
            )
            if key not in seen_table_lineages:
                seen_table_lineages.add(key)
                unique_table_lineages.append(lineage)

        seen_column_lineages: Set[Tuple[str, str, str]] = set()
        unique_column_lineages: List[ColumnLineage] = []

        for lineage in result.column_lineages:
            key = (
                lineage.source_column.full_name,
                lineage.target_column.full_name,
                lineage.transformation_type.value,
            )
            if key not in seen_column_lineages:
                seen_column_lineages.add(key)
                unique_column_lineages.append(lineage)

        result.table_lineages = unique_table_lineages
        result.column_lineages = unique_column_lineages

        return result

    def _calculate_confidence_scores(self, result: LineageExtractionResult) -> LineageExtractionResult:
        for lineage in result.table_lineages:
            if lineage.transformation_type == TransformationType.DIRECT:
                lineage.confidence_score = 1.0
            elif lineage.transformation_type == TransformationType.JOINED:
                lineage.confidence_score = 0.9
            elif lineage.transformation_type == TransformationType.MERGED:
                lineage.confidence_score = 0.85
            elif lineage.transformation_type == TransformationType.DERIVED:
                lineage.confidence_score = 0.8
            else:
                lineage.confidence_score = 0.7

        for lineage in result.column_lineages:
            if lineage.expression:
                if "CASE" in lineage.expression.upper():
                    lineage.confidence_score *= 0.9
                if "DECODE" in lineage.expression.upper():
                    lineage.confidence_score *= 0.9
                if any(agg in lineage.expression.upper() for agg in ["SUM", "AVG", "COUNT", "MAX", "MIN"]):
                    lineage.transformation_type = TransformationType.AGGREGATED
                    lineage.confidence_score *= 0.85

        return result

    def get_supported_statement_types(self) -> List[SQLStatementType]:
        types: Set[SQLStatementType] = set()
        for rule in self._rules:
            types.update(rule.rule.statement_types)
        return list(types)