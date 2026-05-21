"""
核心数据模型
定义字段级血缘链路的所有数据结构
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

# 从专用模块导入层级检测，保持向后兼容的 re-export
from core.layer_detector import LayerType, LAYER_CONFIG, LAYER_ORDER, detect_layer  # noqa: F401
from core.table_name_resolver import TableNameResolver  # noqa: F401


@dataclass
class ColumnInfo:
    name: str
    data_type: str = ""
    nullable: bool = True
    comment: str = ""

    def to_dict(self) -> dict[str, Any]:
        return {
            "name": self.name,
            "data_type": self.data_type,
            "nullable": self.nullable,
            "comment": self.comment,
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> ColumnInfo:
        return cls(
            name=data.get("name", ""),
            data_type=data.get("data_type", ""),
            nullable=data.get("nullable", True),
            comment=data.get("comment", ""),
        )


@dataclass
class TableInfo:
    schema: str = ""
    table_name: str = ""
    full_name: str = ""
    comment: str = ""
    columns: list[ColumnInfo] = field(default_factory=list)
    primary_keys: list[str] = field(default_factory=list)
    is_temp: bool = False
    file_path: str = ""
    partitions: list[str] = field(default_factory=list)

    @property
    def layer(self) -> LayerType:
        return detect_layer(self.full_name)

    @property
    def column_names(self) -> list[str]:
        return [c.name for c in self.columns]

    def to_dict(self) -> dict[str, Any]:
        return {
            "schema": self.schema,
            "table_name": self.table_name,
            "full_name": self.full_name,
            "comment": self.comment,
            "columns": [c.to_dict() for c in self.columns],
            "primary_keys": self.primary_keys,
            "is_temp": self.is_temp,
            "file_path": self.file_path,
            "partitions": self.partitions,
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> TableInfo:
        return cls(
            schema=data.get("schema", ""),
            table_name=data.get("table_name", ""),
            full_name=data.get("full_name", ""),
            comment=data.get("comment", ""),
            columns=[ColumnInfo.from_dict(c) for c in data.get("columns", [])],
            primary_keys=data.get("primary_keys", []),
            is_temp=data.get("is_temp", False),
            file_path=data.get("file_path", ""),
            partitions=data.get("partitions", []),
        )


@dataclass
class FieldMapping:
    source_schema: str = ""
    source_table: str = ""
    source_column: str = ""
    target_schema: str = ""
    target_table: str = ""
    target_column: str = ""
    transform_logic: str = ""
    procedure: str = ""
    confidence: float = 1.0

    @property
    def source_key(self) -> str:
        return f"{self.source_table}.{self.source_column}".upper()

    @property
    def target_key(self) -> str:
        return f"{self.target_table}.{self.target_column}".upper()

    def to_dict(self) -> dict[str, Any]:
        return {
            "source_schema": self.source_schema,
            "source_table": self.source_table,
            "source_column": self.source_column,
            "target_schema": self.target_schema,
            "target_table": self.target_table,
            "target_column": self.target_column,
            "transform_logic": self.transform_logic,
            "procedure": self.procedure,
            "confidence": self.confidence,
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> FieldMapping:
        return cls(
            source_schema=data.get("source_schema", ""),
            source_table=data.get("source_table", ""),
            source_column=data.get("source_column", ""),
            target_schema=data.get("target_schema", ""),
            target_table=data.get("target_table", ""),
            target_column=data.get("target_column", ""),
            transform_logic=data.get("transform_logic", ""),
            procedure=data.get("procedure", ""),
            confidence=data.get("confidence", 1.0),
        )

    def to_dict(self) -> dict[str, Any]:
        return {
            "source_schema": self.source_schema,
            "source_table": self.source_table,
            "source_column": self.source_column,
            "target_schema": self.target_schema,
            "target_table": self.target_table,
            "target_column": self.target_column,
            "transform_logic": self.transform_logic,
            "procedure": self.procedure,
            "confidence": self.confidence,
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> FieldMapping:
        return cls(
            source_schema=data.get("source_schema", ""),
            source_table=data.get("source_table", ""),
            source_column=data.get("source_column", ""),
            target_schema=data.get("target_schema", ""),
            target_table=data.get("target_table", ""),
            target_column=data.get("target_column", ""),
            transform_logic=data.get("transform_logic", ""),
            procedure=data.get("procedure", ""),
            confidence=data.get("confidence", 1.0),
        )


@dataclass
class TableLineage:
    source_schema: str = ""
    source_table: str = ""
    target_schema: str = ""
    target_table: str = ""
    procedure: str = ""
    field_mappings: list[FieldMapping] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "source_schema": self.source_schema,
            "source_table": self.source_table,
            "target_schema": self.target_schema,
            "target_table": self.target_table,
            "procedure": self.procedure,
            "field_mappings": [fm.to_dict() for fm in self.field_mappings],
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> TableLineage:
        return cls(
            source_schema=data.get("source_schema", ""),
            source_table=data.get("source_table", ""),
            target_schema=data.get("target_schema", ""),
            target_table=data.get("target_table", ""),
            procedure=data.get("procedure", ""),
            field_mappings=[FieldMapping.from_dict(fm) for fm in data.get("field_mappings", [])],
        )


@dataclass
class ProcedureInfo:
    schema: str = ""
    proc_name: str = ""
    full_name: str = ""
    description: str = ""
    source_tables: list[str] = field(default_factory=list)
    target_tables: list[str] = field(default_factory=list)
    config_tables: list[str] = field(default_factory=list)
    temp_tables: list[str] = field(default_factory=list)
    table_lineages: list[TableLineage] = field(default_factory=list)
    field_mappings: list[FieldMapping] = field(default_factory=list)
    file_path: str = ""

    def to_dict(self) -> dict[str, Any]:
        return {
            "schema": self.schema,
            "proc_name": self.proc_name,
            "full_name": self.full_name,
            "description": self.description,
            "source_tables": self.source_tables,
            "target_tables": self.target_tables,
            "config_tables": self.config_tables,
            "temp_tables": self.temp_tables,
            "table_lineages": [tl.to_dict() for tl in self.table_lineages],
            "field_mappings": [fm.to_dict() for fm in self.field_mappings],
            "file_path": self.file_path,
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> ProcedureInfo:
        return cls(
            schema=data.get("schema", ""),
            proc_name=data.get("proc_name", ""),
            full_name=data.get("full_name", ""),
            description=data.get("description", ""),
            source_tables=data.get("source_tables", []),
            target_tables=data.get("target_tables", []),
            config_tables=data.get("config_tables", []),
            temp_tables=data.get("temp_tables", []),
            table_lineages=[TableLineage.from_dict(tl) for tl in data.get("table_lineages", [])],
            field_mappings=[FieldMapping.from_dict(fm) for fm in data.get("field_mappings", [])],
            file_path=data.get("file_path", ""),
        )


@dataclass
class FieldLineageNode:
    """字段血缘链路上的一个节点"""
    layer: int = 0
    table_name: str = ""
    field_name: str = ""
    procedure: str = ""
    transform_logic: str = ""
    source_fields: list[str] = field(default_factory=list)
    is_temp: bool = False
    layer_type: str = ""

    @property
    def display_id(self) -> str:
        short_tbl = self.table_name.split(".")[-1] if "." in self.table_name else self.table_name
        return f"{short_tbl}.{self.field_name}"


@dataclass
class FieldLineageChain:
    """一条完整的字段加工链路，从源头到目标"""
    target_table: str = ""
    target_field: str = ""
    chain: list[FieldLineageNode] = field(default_factory=list)
    depth: int = 0

    @property
    def node_count(self) -> int:
        return len(self.chain)

    @property
    def tables_involved(self) -> set[str]:
        return {n.table_name for n in self.chain}

    @property
    def procedures_involved(self) -> set[str]:
        return {n.procedure for n in self.chain if n.procedure}


@dataclass
class SQLCondition:
    """SQL 条件子句"""
    condition_type: str = ""
    raw_text: str = ""
    tables_involved: list[str] = field(default_factory=list)
    fields_involved: list[str] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "condition_type": self.condition_type,
            "raw_text": self.raw_text,
            "tables_involved": self.tables_involved,
            "fields_involved": self.fields_involved,
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> SQLCondition:
        return cls(
            condition_type=data.get("condition_type", ""),
            raw_text=data.get("raw_text", ""),
            tables_involved=data.get("tables_involved", []),
            fields_involved=data.get("fields_involved", []),
        )


@dataclass
class SelectColumnMapping:
    """SELECT 列映射 — 描述源列到目标列的映射关系"""
    source_expression: str = ""
    target_column: str = ""
    alias: str = ""

    def to_dict(self) -> dict[str, Any]:
        return {
            "source_expression": self.source_expression,
            "target_column": self.target_column,
            "alias": self.alias,
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> SelectColumnMapping:
        return cls(
            source_expression=data.get("source_expression", ""),
            target_column=data.get("target_column", ""),
            alias=data.get("alias", ""),
        )


@dataclass
class SubqueryInfo:
    """子查询信息"""
    alias: str = ""
    raw_text: str = ""
    source_tables: list[str] = field(default_factory=list)
    where_conditions: list[SQLCondition] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "alias": self.alias,
            "raw_text": self.raw_text,
            "source_tables": self.source_tables,
            "where_conditions": [wc.to_dict() for wc in self.where_conditions],
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> SubqueryInfo:
        return cls(
            alias=data.get("alias", ""),
            raw_text=data.get("raw_text", ""),
            source_tables=data.get("source_tables", []),
            where_conditions=[SQLCondition.from_dict(wc) for wc in data.get("where_conditions", [])],
        )


@dataclass
class SourceLocation:
    source_schema: str = ""
    source_table: str = ""
    source_column: str = ""

    def to_dict(self) -> dict[str, Any]:
        return {
            "source_schema": self.source_schema,
            "source_table": self.source_table,
            "source_column": self.source_column,
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> SourceLocation:
        return cls(
            source_schema=data.get("source_schema", ""),
            source_table=data.get("source_table", ""),
            source_column=data.get("source_column", ""),
        )

    def __bool__(self) -> bool:
        return bool(self.source_table or self.source_column)


@dataclass
class StepIsolation:
    step_name: str = ""
    step_number: int = 0
    is_isolated: bool = False
    isolation_reason: str = ""
    isolated_expression: str = ""
    isolated_source_columns: list[str] = field(default_factory=list)
    isolated_target_columns: list[str] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "step_name": self.step_name,
            "step_number": self.step_number,
            "is_isolated": self.is_isolated,
            "isolation_reason": self.isolation_reason,
            "isolated_expression": self.isolated_expression,
            "isolated_source_columns": list(self.isolated_source_columns),
            "isolated_target_columns": list(self.isolated_target_columns),
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> StepIsolation:
        return cls(
            step_name=data.get("step_name", ""),
            step_number=data.get("step_number", 0),
            is_isolated=data.get("is_isolated", False),
            isolation_reason=data.get("isolation_reason", ""),
            isolated_expression=data.get("isolated_expression", ""),
            isolated_source_columns=list(data.get("isolated_source_columns", [])),
            isolated_target_columns=list(data.get("isolated_target_columns", [])),
        )


@dataclass
class ExpressionDetail:
    expression: str = ""
    expression_type: str = ""
    select_columns: list[SelectColumnMapping] = field(default_factory=list)
    where_conditions: list[SQLCondition] = field(default_factory=list)
    group_by_columns: list[str] = field(default_factory=list)
    having_conditions: list[SQLCondition] = field(default_factory=list)
    order_by_columns: list[str] = field(default_factory=list)
    subqueries: list[SubqueryInfo] = field(default_factory=list)
    join_clauses: list[str] = field(default_factory=list)
    union_queries: list[str] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "expression": self.expression,
            "expression_type": self.expression_type,
            "select_columns": [c.to_dict() for c in self.select_columns],
            "where_conditions": [c.to_dict() for c in self.where_conditions],
            "group_by_columns": list(self.group_by_columns),
            "having_conditions": [c.to_dict() for c in self.having_conditions],
            "order_by_columns": list(self.order_by_columns),
            "subqueries": [sq.to_dict() for sq in self.subqueries],
            "join_clauses": list(self.join_clauses),
            "union_queries": list(self.union_queries),
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> ExpressionDetail:
        return cls(
            expression=data.get("expression", ""),
            expression_type=data.get("expression_type", ""),
            select_columns=[SelectColumnMapping.from_dict(c) for c in data.get("select_columns", [])],
            where_conditions=[SQLCondition.from_dict(c) for c in data.get("where_conditions", [])],
            group_by_columns=list(data.get("group_by_columns", [])),
            having_conditions=[SQLCondition.from_dict(c) for c in data.get("having_conditions", [])],
            order_by_columns=list(data.get("order_by_columns", [])),
            subqueries=[SubqueryInfo.from_dict(sq) for sq in data.get("subqueries", [])],
            join_clauses=list(data.get("join_clauses", [])),
            union_queries=list(data.get("union_queries", [])),
        )


@dataclass
class SQLEnhancement:
    enhanced_sql: str = ""
    original_sql: str = ""
    enhancement_notes: list[str] = field(default_factory=list)
    sql_quality_score: float = 0.0
    performance_hints: list[str] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "enhanced_sql": self.enhanced_sql,
            "original_sql": self.original_sql,
            "enhancement_notes": list(self.enhancement_notes),
            "sql_quality_score": self.sql_quality_score,
            "performance_hints": list(self.performance_hints),
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> SQLEnhancement:
        return cls(
            enhanced_sql=data.get("enhanced_sql", ""),
            original_sql=data.get("original_sql", ""),
            enhancement_notes=list(data.get("enhancement_notes", [])),
            sql_quality_score=float(data.get("sql_quality_score", 0.0)),
            performance_hints=list(data.get("performance_hints", [])),
        )


class SQLOperationType:
    INSERT_SELECT = "INSERT_SELECT"
    INSERT_VALUES = "INSERT_VALUES"
    MERGE = "MERGE"
    UPDATE = "UPDATE"
    DELETE = "DELETE"
    CREATE_TABLE_AS_SELECT = "CREATE_TABLE_AS_SELECT"


class ConditionType:
    WHERE = "WHERE"
    HAVING = "HAVING"
    JOIN = "JOIN"
    ON = "ON"
    FILTER = "FILTER"


class ExpressionType:
    SELECT = "SELECT"
    INSERT = "INSERT"
    UPDATE = "UPDATE"
    MERGE = "MERGE"
    CREATE_TABLE = "CREATE_TABLE"
    UNKNOWN = "UNKNOWN"


class DataSource:
    ORACLE = "oracle"
    HIVE = "hive"
    FILE = "file"
    UNKNOWN = "unknown"


class SetOperationType:
    NONE = ""
    UNION = "UNION"
    UNION_ALL = "UNION ALL"
    INTERSECT = "INTERSECT"
    MINUS = "MINUS"


@dataclass
class CaliberInfo:
    target_schema: str = ""
    target_table: str = ""
    target_column: str = ""
    data_source: str = "oracle"
    confidence: float = 1.0
    last_updated: str = ""
    source_location: SourceLocation = field(default_factory=SourceLocation)
    step_isolation: StepIsolation = field(default_factory=StepIsolation)
    expression_detail: ExpressionDetail = field(default_factory=ExpressionDetail)
    sql_enhancement: SQLEnhancement = field(default_factory=SQLEnhancement)
    transform_logic: str = ""
    join_conditions: list[SQLCondition] = field(default_factory=list)
    group_by_clause: str = ""
    having_clause: str = ""
    procedure: str = ""
    step_num: int = 0
    step_desc: str = ""
    raw_sql_fragment: str = ""
    operation_type: str = ""
    distinct_flag: bool = False
    order_by_clause: str = ""
    set_operation: str = ""
    source_table_layer: str = ""
    target_table_layer: str = ""
    window_functions: list[str] = field(default_factory=list)
    sql_operation_sequence: int = 0
    accumulated_where: list[SQLCondition] = field(default_factory=list)
    accumulated_join: list[SQLCondition] = field(default_factory=list)
    caliber_spec: str = ""
    file_path: str = ""
    start_line: int = 0
    end_line: int = 0
    step_isolated_where: list[SQLCondition] = field(default_factory=list)
    step_isolated_join: list[SQLCondition] = field(default_factory=list)
    cte_definitions: list[str] = field(default_factory=list)
    custom_functions: list[str] = field(default_factory=list)
    full_expression: str = ""
    is_custom_function_call: bool = False

    @property
    def source_table(self) -> str:
        return self.source_location.source_table

    @source_table.setter
    def source_table(self, value: str) -> None:
        self.source_location.source_table = value

    @property
    def source_column(self) -> str:
        return self.source_location.source_column

    @source_column.setter
    def source_column(self, value: str) -> None:
        self.source_location.source_column = value

    @property
    def source_schema(self) -> str:
        return self.source_location.source_schema

    @source_schema.setter
    def source_schema(self, value: str) -> None:
        self.source_location.source_schema = value

    @property
    def select_columns(self) -> list[SelectColumnMapping]:
        return self.expression_detail.select_columns

    @select_columns.setter
    def select_columns(self, value: list[SelectColumnMapping]) -> None:
        self.expression_detail.select_columns = value

    @property
    def where_conditions(self) -> list[SQLCondition]:
        return self.expression_detail.where_conditions

    @where_conditions.setter
    def where_conditions(self, value: list[SQLCondition]) -> None:
        self.expression_detail.where_conditions = value

    @property
    def subqueries(self) -> list[SubqueryInfo]:
        return self.expression_detail.subqueries

    @subqueries.setter
    def subqueries(self, value: list[SubqueryInfo]) -> None:
        self.expression_detail.subqueries = value

    @property
    def target_key(self) -> str:
        return f"{self.target_table}.{self.target_column}".upper()

    @property
    def source_key(self) -> str:
        return f"{self.source_location.source_table}.{self.source_location.source_column}".upper()

    @property
    def short_source_table(self) -> str:
        src = self.source_location.source_table
        return src.split(".")[-1] if "." in src else src

    @property
    def short_target_table(self) -> str:
        return self.target_table.split(".")[-1] if "." in self.target_table else self.target_table

    def generate_caliber_spec(self) -> str:
        if self.caliber_spec:
            return self.caliber_spec

        parts: list[str] = []

        layer_prefix = ""
        if self.target_table_layer:
            layer_prefix = f"[{self.target_table_layer}] "
        parts.append(f"{layer_prefix}{self.short_target_table}.{self.target_column}")

        if self.operation_type:
            parts.append(f"  加工方式: {self.operation_type}")

        if self.source_location.source_table:
            src_layer = f"[{self.source_table_layer}] " if self.source_table_layer else ""
            parts.append(f"  数据来源: {src_layer}{self.short_source_table}.{self.source_location.source_column}")

        if self.transform_logic and self.transform_logic.upper() not in ("DIRECT", self.source_location.source_column.upper()):
            parts.append(f"  转换逻辑: {self.transform_logic}")

        if self.expression_detail.select_columns:
            col_descs = []
            for sc in self.expression_detail.select_columns[:10]:
                expr = sc.source_expression
                alias = sc.alias or sc.target_column
                if expr.upper() != alias.upper():
                    col_descs.append(f"{expr} AS {alias}")
                else:
                    col_descs.append(expr)
            if col_descs:
                parts.append(f"  字段映射: {', '.join(col_descs)}")

        if self.distinct_flag:
            parts.append("  去重方式: DISTINCT")

        all_join = self.step_isolated_join or self.accumulated_join or self.join_conditions
        if all_join:
            join_descs = [f"JOIN {j.raw_text}" for j in all_join]
            parts.append(f"  关联条件: {'; '.join(join_descs)}")

        all_where = self.step_isolated_where or self.accumulated_where or self.expression_detail.where_conditions
        if all_where:
            where_descs = [w.raw_text for w in all_where]
            parts.append(f"  筛选条件: {' AND '.join(where_descs)}")

        if self.group_by_clause:
            parts.append(f"  分组规则: GROUP BY {self.group_by_clause}")

        if self.having_clause:
            parts.append(f"  分组筛选: HAVING {self.having_clause}")

        if self.window_functions:
            parts.append(f"  窗口函数: {'; '.join(self.window_functions)}")

        if self.set_operation:
            parts.append(f"  集合运算: {self.set_operation}")

        if self.order_by_clause:
            parts.append(f"  排序规则: ORDER BY {self.order_by_clause}")

        if self.procedure:
            seq = f" (步骤{self.sql_operation_sequence})" if self.sql_operation_sequence > 0 else ""
            parts.append(f"  加工过程: {self.procedure}{seq}")

        if self.expression_detail.subqueries:
            sq_descs = [f"({sq.alias}: {sq.raw_text[:80]})" for sq in self.expression_detail.subqueries]
            parts.append(f"  子查询: {'; '.join(sq_descs)}")

        if self.cte_definitions:
            cte_descs = [cte[:100] for cte in self.cte_definitions]
            parts.append(f"  CTE定义: {'; '.join(cte_descs)}")

        if self.custom_functions:
            parts.append(f"  自定义函数: {', '.join(self.custom_functions)}")

        if self.full_expression and self.full_expression.upper() != self.source_location.source_column.upper():
            parts.append(f"  完整表达式: {self.full_expression}")

        if self.is_custom_function_call:
            parts.append(f"  函数调用标记: 是")

        return "\n".join(parts)

    def to_dict(self) -> dict[str, Any]:
        return {
            "target_schema": self.target_schema,
            "target_table": self.target_table,
            "target_column": self.target_column,
            "data_source": self.data_source,
            "confidence": self.confidence,
            "last_updated": self.last_updated,
            "source_location": self.source_location.to_dict(),
            "step_isolation": self.step_isolation.to_dict(),
            "expression_detail": self.expression_detail.to_dict(),
            "sql_enhancement": self.sql_enhancement.to_dict(),
            "transform_logic": self.transform_logic,
            "join_conditions": [c.to_dict() for c in self.join_conditions],
            "group_by_clause": self.group_by_clause,
            "having_clause": self.having_clause,
            "procedure": self.procedure,
            "step_num": self.step_num,
            "step_desc": self.step_desc,
            "raw_sql_fragment": self.raw_sql_fragment,
            "operation_type": self.operation_type,
            "distinct_flag": self.distinct_flag,
            "order_by_clause": self.order_by_clause,
            "set_operation": self.set_operation,
            "source_table_layer": self.source_table_layer,
            "target_table_layer": self.target_table_layer,
            "window_functions": list(self.window_functions),
            "sql_operation_sequence": self.sql_operation_sequence,
            "accumulated_where": [c.to_dict() for c in self.accumulated_where],
            "accumulated_join": [c.to_dict() for c in self.accumulated_join],
            "caliber_spec": self.caliber_spec,
            "file_path": self.file_path,
            "start_line": self.start_line,
            "end_line": self.end_line,
            "step_isolated_where": [c.to_dict() for c in self.step_isolated_where],
            "step_isolated_join": [c.to_dict() for c in self.step_isolated_join],
            "cte_definitions": list(self.cte_definitions),
            "custom_functions": list(self.custom_functions),
            "full_expression": self.full_expression,
            "is_custom_function_call": self.is_custom_function_call,
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> CaliberInfo:
        source_location_data = data.get("source_location")
        expression_detail_data = data.get("expression_detail")
        step_isolation_data = data.get("step_isolation")
        sql_enhancement_data = data.get("sql_enhancement")

        is_legacy = source_location_data is None and (
            data.get("source_table") is not None or data.get("source_column") is not None
        )

        if is_legacy:
            source_location = SourceLocation(
                source_schema=data.get("source_schema", ""),
                source_table=data.get("source_table", ""),
                source_column=data.get("source_column", ""),
            )
        elif source_location_data and isinstance(source_location_data, dict):
            source_location = SourceLocation.from_dict(source_location_data)
        else:
            source_location = SourceLocation()

        if is_legacy:
            select_cols = [SelectColumnMapping.from_dict(c) for c in data.get("select_columns", [])]
            where_conds = [SQLCondition.from_dict(c) for c in data.get("where_conditions", [])]
            subqs = [SubqueryInfo.from_dict(sq) for sq in data.get("subqueries", [])]
            expression_detail = ExpressionDetail(
                expression=data.get("full_expression", ""),
                expression_type=data.get("operation_type", ""),
                select_columns=select_cols,
                where_conditions=where_conds,
                group_by_columns=[data.get("group_by_clause", "")] if data.get("group_by_clause") else [],
                having_conditions=[],
                order_by_columns=[data.get("order_by_clause", "")] if data.get("order_by_clause") else [],
                subqueries=subqs,
                join_clauses=[],
                union_queries=[data.get("set_operation", "")] if data.get("set_operation") else [],
            )
        elif expression_detail_data and isinstance(expression_detail_data, dict):
            expression_detail = ExpressionDetail.from_dict(expression_detail_data)
        else:
            expression_detail = ExpressionDetail()

        if step_isolation_data and isinstance(step_isolation_data, dict):
            step_isolation = StepIsolation.from_dict(step_isolation_data)
        else:
            step_isolation = StepIsolation(
                step_name=data.get("step_desc", ""),
                step_number=data.get("step_num", 0),
            )

        if sql_enhancement_data and isinstance(sql_enhancement_data, dict):
            sql_enhancement = SQLEnhancement.from_dict(sql_enhancement_data)
        else:
            sql_enhancement = SQLEnhancement(
                original_sql=data.get("raw_sql_fragment", ""),
            )

        return cls(
            target_schema=data.get("target_schema", ""),
            target_table=data.get("target_table", ""),
            target_column=data.get("target_column", ""),
            data_source=data.get("data_source", "oracle"),
            confidence=data.get("confidence", 1.0),
            last_updated=data.get("last_updated", ""),
            source_location=source_location,
            step_isolation=step_isolation,
            expression_detail=expression_detail,
            sql_enhancement=sql_enhancement,
            transform_logic=data.get("transform_logic", ""),
            join_conditions=[SQLCondition.from_dict(c) for c in data.get("join_conditions", [])],
            group_by_clause=data.get("group_by_clause", ""),
            having_clause=data.get("having_clause", ""),
            procedure=data.get("procedure", ""),
            step_num=data.get("step_num", 0),
            step_desc=data.get("step_desc", ""),
            raw_sql_fragment=data.get("raw_sql_fragment", ""),
            operation_type=data.get("operation_type", ""),
            distinct_flag=data.get("distinct_flag", False),
            order_by_clause=data.get("order_by_clause", ""),
            set_operation=data.get("set_operation", ""),
            source_table_layer=data.get("source_table_layer", ""),
            target_table_layer=data.get("target_table_layer", ""),
            window_functions=data.get("window_functions", []),
            sql_operation_sequence=data.get("sql_operation_sequence", 0),
            accumulated_where=[SQLCondition.from_dict(c) for c in data.get("accumulated_where", [])],
            accumulated_join=[SQLCondition.from_dict(c) for c in data.get("accumulated_join", [])],
            caliber_spec=data.get("caliber_spec", ""),
            file_path=data.get("file_path", ""),
            start_line=data.get("start_line", 0),
            end_line=data.get("end_line", 0),
            step_isolated_where=[SQLCondition.from_dict(c) for c in data.get("step_isolated_where", [])],
            step_isolated_join=[SQLCondition.from_dict(c) for c in data.get("step_isolated_join", [])],
            cte_definitions=data.get("cte_definitions", []),
            custom_functions=data.get("custom_functions", []),
            full_expression=data.get("full_expression", ""),
            is_custom_function_call=data.get("is_custom_function_call", False),
        )


@dataclass
class CaliberChain:
    """指标口径链路 — 从目标字段逐层追溯到源头，每层都包含完整的口径条件

    增强字段说明:
      - data_flow_layers: 数据流经的分层路径 (如 ['ADS', 'DWS', 'DWD', 'ODS'])
      - procedures_involved: 涉及的所有存储过程
      - tables_involved: 涉及的所有表
      - total_conditions: 该链路上的总条件数
      - complete_caliber_spec: 完整口径规格 (所有步骤的口径描述拼接)
      - accumulated_conditions_text: 全链路累积条件的可读描述
    """
    target_table: str = ""
    target_column: str = ""
    steps: list[CaliberInfo] = field(default_factory=list)
    depth: int = 0
    data_flow_layers: list[str] = field(default_factory=list)
    procedures_involved: list[str] = field(default_factory=list)
    tables_involved: list[str] = field(default_factory=list)
    total_conditions: int = 0
    complete_caliber_spec: str = ""
    accumulated_conditions_text: str = ""

    @property
    def summary(self) -> str:
        parts = []
        for step in self.steps:
            layer_tag = f"[{step.target_table_layer}]" if step.target_table_layer else ""
            cond_text = ""
            if step.where_conditions:
                cond_text = " WHERE " + " AND ".join(c.raw_text for c in step.where_conditions)
            parts.append(
                f"{layer_tag}{step.source_table}.{step.source_column} -> "
                f"{step.target_table}.{step.target_column} "
                f"[{step.transform_logic}]{cond_text}"
            )
        return ";\n".join(parts)

    def build_complete_caliber_spec(self) -> str:
        """构建完整口径规格 — 供技术人员直接阅读的加工口径说明"""
        if self.complete_caliber_spec:
            return self.complete_caliber_spec

        lines: list[str] = []
        lines.append(f"{'=' * 60}")
        lines.append(f"指标口径规格: {self.target_table}.{self.target_column}")
        if self.data_flow_layers:
            lines.append(f"数据流向: {' → '.join(self.data_flow_layers)}")
        lines.append(f"链路深度: {self.depth} 步")
        lines.append(f"{'=' * 60}")

        for i, step in enumerate(self.steps, 1):
            lines.append(f"")
            lines.append(f"── Step {i}/{self.depth} ──")
            spec = step.generate_caliber_spec()
            lines.append(spec)

        lines.append(f"")
        lines.append(f"{'=' * 60}")
        lines.append(f"全链路累积条件:")
        lines.append(self.accumulated_conditions_text or "无")
        lines.append(f"{'=' * 60}")

        return "\n".join(lines)

    def compute_metadata(self) -> None:
        """计算链路的元数据（分层路径、涉及表/过程、总条件数、累积条件文本）"""
        layers: list[str] = []
        procs: list[str] = []
        tables: list[str] = []
        cond_count = 0
        all_where: list[str] = []
        all_join: list[str] = []

        for step in self.steps:
            if step.target_table_layer and step.target_table_layer not in layers:
                layers.append(step.target_table_layer)
            if step.source_table_layer and step.source_table_layer not in layers:
                layers.append(step.source_table_layer)
            if step.procedure and step.procedure not in procs:
                procs.append(step.procedure)
            short_tgt = step.short_target_table
            short_src = step.short_source_table
            if short_tgt and short_tgt not in tables:
                tables.append(short_tgt)
            if short_src and short_src not in tables:
                tables.append(short_src)

            cond_count += len(step.where_conditions) + len(step.join_conditions)
            for w in step.where_conditions:
                if w.raw_text and w.raw_text not in all_where:
                    all_where.append(w.raw_text)
            for j in step.join_conditions:
                if j.raw_text and j.raw_text not in all_join:
                    all_join.append(j.raw_text)

        self.data_flow_layers = layers
        self.procedures_involved = procs
        self.tables_involved = tables
        self.total_conditions = cond_count

        acc_parts: list[str] = []
        if all_join:
            acc_parts.append("关联条件: " + " AND ".join(all_join))
        if all_where:
            acc_parts.append("筛选条件: " + " AND ".join(all_where))
        self.accumulated_conditions_text = "\n".join(acc_parts)


@dataclass
class CaliberResult:
    """指标口径查询结果

    增强字段说明:
      - data_flow_layers_summary: 所有链路经过的数据分层汇总
      - complete_caliber_spec: 完整口径规格 (首选链路的完整规格)
    """
    target_table: str = ""
    target_column: str = ""
    chains: list[CaliberChain] = field(default_factory=list)
    total_steps: int = 0
    total_conditions: int = 0
    query_time_ms: float = 0.0
    data_flow_layers_summary: list[str] = field(default_factory=list)
    complete_caliber_spec: str = ""

    def build_complete_spec(self) -> None:
        """构建完整口径规格并汇总元数据"""
        all_layers: list[str] = []
        for chain in self.chains:
            chain.compute_metadata()
            for layer in chain.data_flow_layers:
                if layer not in all_layers:
                    all_layers.append(layer)

        self.data_flow_layers_summary = all_layers

        if self.chains:
            self.chains[0].build_complete_caliber_spec()
            self.complete_caliber_spec = self.chains[0].complete_caliber_spec


@dataclass
class FieldLineageResult:
    """字段血缘查询结果（可能包含多条链路）"""
    target_table: str = ""
    target_field: str = ""
    chains: list[FieldLineageChain] = field(default_factory=list)
    total_nodes: int = 0
    total_tables: int = 0
    total_procedures: int = 0
    max_depth: int = 0
    query_time_ms: float = 0.0

    def summarize(self) -> dict:
        return {
            "target": f"{self.target_table.split('.')[-1]}.{self.target_field}",
            "chain_count": len(self.chains),
            "total_nodes": self.total_nodes,
            "total_tables": self.total_tables,
            "total_procedures": self.total_procedures,
            "max_depth": self.max_depth,
        }


# ===================================================================
# Phase 1: Summary Card 数据模型
# ===================================================================


@dataclass
class CaliberSummaryCard:
    """指标概览卡数据模型 — 提供宏观视角的口径摘要

    用于前端 Summary Card 组件，展示:
      - 指标标识与短标识
      - 业务口径描述
      - 技术口径摘要 (一行文字链路)
      - 每步转换描述列表
      - 统计信息 (路径数/步骤数/涉及表和过程)
      - 数据质量标记
    """
    indicator: str = ""                    # 完整标识 (SCHEMA.TABLE.FIELD)
    indicator_short: str = ""              # 短标识 (TABLE.FIELD)
    business_caliber: str = ""             # 业务口径描述
    technical_caliber_summary: str = ""    # 技术口径摘要 (一行文字链路)
    caliber_chain_text: list[str] = field(default_factory=list)  # 每步转换描述
    stats: dict = field(default_factory=dict)  # 统计信息
    data_quality_flags: dict = field(default_factory=dict)  # 数据质量标记
    query_time_ms: float = 0.0


# ===================================================================
# Phase 2: Pipeline 数据模型
# ===================================================================


@dataclass
class PipelineNode:
    """Pipeline 视图节点 — 代表链路中的一个表或表.字段"""
    id: str = ""                           # 唯一标识 (SHORT_TABLE.FIELD)
    layer: str = ""                        # 数据分层 (ODS/DWD/DWS/ADS/EAST)
    layer_label: str = ""                  # 分层显示标签
    label: str = ""                        # 显示标签 (短表名)
    field: str = ""                        # 关联字段名
    is_source: bool = False                # 是否为源头节点
    is_target: bool = False                # 是否为目标节点
    is_internal_transform: bool = False    # 是否为同表内字段转换
    transform_note: str = ""               # 转换说明 (如 "同表内脱敏处理")


@dataclass
class PipelineEdge:
    """Pipeline 视图边 — 代表一个加工步骤"""
    id: str = ""                           # 步骤 ID (如 "step_1")
    source: str = ""                       # 源节点 ID
    target: str = ""                       # 目标节点 ID
    source_field: str = ""                 # 源字段名
    target_field: str = ""                 # 目标字段名
    expression: str = ""                   # 完整加工表达式
    procedure: str = ""                    # 所属存储过程
    step_num: int = 0                      # 步骤编号
    operation_type: str = ""               # 操作类型 (INSERT_SELECT/MERGE/UPDATE)
    has_detail: bool = True                # 是否有详情可展开
    file_path: str = ""                    # 源文件路径
    start_line: int = 0                    # 起始行号


@dataclass
class PipelineBranch:
    """Pipeline 视图中的分支 (并行路径)"""
    merge_point: str = ""                  # 汇聚节点 ID
    source_node: str = ""                  # 分支来源节点 ID
    label: str = ""                        # 分支标签


@dataclass
class PipelineView:
    """Pipeline 完整视图 — 横向 DAG 结构"""
    target_table: str = ""
    target_field: str = ""
    nodes: list[PipelineNode] = field(default_factory=list)
    edges: list[PipelineEdge] = field(default_factory=list)
    branches: list[PipelineBranch] = field(default_factory=list)
    layer_order: list[str] = field(default_factory=list)  # 从左到右的分层顺序


# ===================================================================
# Phase 3: Step Detail 数据模型
# ===================================================================


@dataclass
class TargetFieldExpression:
    """单个目标字段的完整表达式"""
    target_column: str = ""
    expression: str = ""                   # 完整表达式
    source_columns: list[str] = field(default_factory=list)
    source_tables: list[str] = field(default_factory=list)
    is_custom_function: bool = False
    custom_function_name: str = ""


@dataclass
class CTEDetail:
    """CTE 详情 (展示用)"""
    name: str = ""
    definition: str = ""                   # CTE 完整定义体
    source_tables: list[str] = field(default_factory=list)
    consumed_in_step: int = 0


@dataclass
class CustomFunctionDetail:
    """自定义函数详情"""
    name: str = ""                         # 函数全名 (如 PKG_DESEN.ENCRYPT_NAME)
    is_custom: bool = True
    migration_risk: str = "LOW"            # LOW / MEDIUM / HIGH
    risk_note: str = ""                    # 风险说明


@dataclass
class StepDetail:
    """单步详情面板完整数据"""
    step_num: int = 0
    step_desc: str = ""
    procedure: str = ""
    source_table: str = ""
    target_table: str = ""
    operation_type: str = ""               # INSERT_SELECT / MERGE / UPDATE

    # 源码锚定
    source_code_location: dict = field(default_factory=dict)  # {file_path, start_line, end_line}

    # 目标字段表达式 (核心)
    target_field_expressions: list[TargetFieldExpression] = field(default_factory=list)

    # 步骤级隔离条件 (非累积)
    step_isolated_where: list[dict] = field(default_factory=list)
    step_isolated_join: list[dict] = field(default_factory=list)

    # 聚合/窗口
    window_functions: list[str] = field(default_factory=list)
    group_by_clause: str = ""
    having_clause: str = ""
    distinct_flag: bool = False
    set_operation: str = ""
    order_by_clause: str = ""

    # CTE
    cte_definitions: list[CTEDetail] = field(default_factory=list)

    # 自定义函数
    custom_functions: list[CustomFunctionDetail] = field(default_factory=list)

    # 原始 SQL
    raw_sql: str = ""

    # 元数据
    confidence: float = 1.0
