"""
核心数据模型
定义字段级血缘链路的所有数据结构
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Optional

# 从专用模块导入层级检测，保持向后兼容的 re-export
from core.layer_detector import LayerType, LAYER_CONFIG, LAYER_ORDER, detect_layer  # noqa: F401
from core.table_name_resolver import TableNameResolver  # noqa: F401


@dataclass
class ColumnInfo:
    name: str
    data_type: str = ""
    nullable: bool = True
    comment: str = ""


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


@dataclass
class TableLineage:
    source_schema: str = ""
    source_table: str = ""
    target_schema: str = ""
    target_table: str = ""
    procedure: str = ""
    field_mappings: list[FieldMapping] = field(default_factory=list)


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


@dataclass
class SelectColumnMapping:
    """SELECT 列映射 — 描述源列到目标列的映射关系"""
    source_expression: str = ""
    target_column: str = ""
    alias: str = ""


@dataclass
class SubqueryInfo:
    """子查询信息"""
    alias: str = ""
    raw_text: str = ""
    source_tables: list[str] = field(default_factory=list)
    where_conditions: list[SQLCondition] = field(default_factory=list)


class SQLOperationType:
    INSERT_SELECT = "INSERT_SELECT"
    INSERT_VALUES = "INSERT_VALUES"
    MERGE = "MERGE"
    UPDATE = "UPDATE"
    DELETE = "DELETE"
    CREATE_TABLE_AS_SELECT = "CREATE_TABLE_AS_SELECT"


class SetOperationType:
    NONE = ""
    UNION = "UNION"
    UNION_ALL = "UNION ALL"
    INTERSECT = "INTERSECT"
    MINUS = "MINUS"


@dataclass
class CaliberInfo:
    """指标口径信息 — 描述一个目标字段是如何加工而成的

    增强字段说明:
      - operation_type: SQL操作类型 (INSERT_SELECT/MERGE/UPDATE等)
      - select_columns: SELECT列映射列表 (源表达式→目标列)
      - distinct_flag: 是否使用了DISTINCT去重
      - order_by_clause: ORDER BY排序子句
      - set_operation: 集合运算类型 (UNION/UNION ALL/INTERSECT/MINUS)
      - subqueries: 子查询分解信息
      - source_table_layer: 来源表数据分层 (ODS/DWD/DWS/ADS)
      - target_table_layer: 目标表数据分层 (ODS/DWD/DWS/ADS)
      - window_functions: 窗口函数表达式列表
      - sql_operation_sequence: 该步骤在存储过程中的执行顺序
      - accumulated_where: 截至当前步骤累积的所有WHERE条件
      - accumulated_join: 截至当前步骤累积的所有JOIN条件
      - caliber_spec: 该步骤的完整口径规格描述（供技术人员直接阅读）
    """
    target_table: str = ""
    target_column: str = ""
    source_table: str = ""
    source_column: str = ""
    transform_logic: str = ""
    where_conditions: list[SQLCondition] = field(default_factory=list)
    join_conditions: list[SQLCondition] = field(default_factory=list)
    group_by_clause: str = ""
    having_clause: str = ""
    procedure: str = ""
    step_num: int = 0
    step_desc: str = ""
    data_source: str = "oracle"
    raw_sql_fragment: str = ""
    confidence: float = 1.0
    operation_type: str = ""
    select_columns: list[SelectColumnMapping] = field(default_factory=list)
    distinct_flag: bool = False
    order_by_clause: str = ""
    set_operation: str = ""
    subqueries: list[SubqueryInfo] = field(default_factory=list)
    source_table_layer: str = ""
    target_table_layer: str = ""
    window_functions: list[str] = field(default_factory=list)
    sql_operation_sequence: int = 0
    accumulated_where: list[SQLCondition] = field(default_factory=list)
    accumulated_join: list[SQLCondition] = field(default_factory=list)
    caliber_spec: str = ""

    @property
    def target_key(self) -> str:
        return f"{self.target_table}.{self.target_column}".upper()

    @property
    def source_key(self) -> str:
        return f"{self.source_table}.{self.source_column}".upper()

    @property
    def short_source_table(self) -> str:
        return self.source_table.split(".")[-1] if "." in self.source_table else self.source_table

    @property
    def short_target_table(self) -> str:
        return self.target_table.split(".")[-1] if "." in self.target_table else self.target_table

    def generate_caliber_spec(self) -> str:
        """生成当前步骤的完整口径规格描述"""
        if self.caliber_spec:
            return self.caliber_spec

        parts: list[str] = []

        layer_prefix = ""
        if self.target_table_layer:
            layer_prefix = f"[{self.target_table_layer}] "
        parts.append(f"{layer_prefix}{self.short_target_table}.{self.target_column}")

        if self.operation_type:
            parts.append(f"  加工方式: {self.operation_type}")

        if self.source_table:
            src_layer = f"[{self.source_table_layer}] " if self.source_table_layer else ""
            parts.append(f"  数据来源: {src_layer}{self.short_source_table}.{self.source_column}")

        if self.transform_logic and self.transform_logic.upper() not in ("DIRECT", self.source_column.upper()):
            parts.append(f"  转换逻辑: {self.transform_logic}")

        if self.select_columns:
            col_descs = []
            for sc in self.select_columns[:10]:
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

        if self.join_conditions:
            join_descs = [f"JOIN {j.raw_text}" for j in self.join_conditions]
            parts.append(f"  关联条件: {'; '.join(join_descs)}")

        all_where = self.accumulated_where if self.accumulated_where else self.where_conditions
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

        if self.subqueries:
            sq_descs = [f"({sq.alias}: {sq.raw_text[:80]})" for sq in self.subqueries]
            parts.append(f"  子查询: {'; '.join(sq_descs)}")

        return "\n".join(parts)


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
