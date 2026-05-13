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
class CaliberInfo:
    """指标口径信息 — 描述一个目标字段是如何加工而成的"""
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

    @property
    def target_key(self) -> str:
        return f"{self.target_table}.{self.target_column}".upper()

    @property
    def source_key(self) -> str:
        return f"{self.source_table}.{self.source_column}".upper()


@dataclass
class CaliberChain:
    """指标口径链路 — 从目标字段逐层追溯到源头，每层都包含完整的口径条件"""
    target_table: str = ""
    target_column: str = ""
    steps: list[CaliberInfo] = field(default_factory=list)
    depth: int = 0

    @property
    def summary(self) -> str:
        parts = []
        for step in self.steps:
            cond_text = ""
            if step.where_conditions:
                cond_text = " WHERE " + " AND ".join(c.raw_text for c in step.where_conditions)
            parts.append(
                f"{step.source_table}.{step.source_column} -> "
                f"{step.target_table}.{step.target_column} "
                f"[{step.transform_logic}]{cond_text}"
            )
        return ";\n".join(parts)


@dataclass
class CaliberResult:
    """指标口径查询结果"""
    target_table: str = ""
    target_column: str = ""
    chains: list[CaliberChain] = field(default_factory=list)
    total_steps: int = 0
    total_conditions: int = 0
    query_time_ms: float = 0.0


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
