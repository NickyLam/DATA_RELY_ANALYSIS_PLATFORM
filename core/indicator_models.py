"""
指标血缘数据模型
定义指标血缘链路的所有数据结构，包括指标定义、算法配置、依赖关系、血缘图和查询结果
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Literal

MEASURE_LABELS: dict[str, str] = {
    "001": "原始统计值(期末余额)",
    "002": "月日均",
    "003": "季日均",
    "004": "年日均",
    "005": "月初余额",
    "006": "季初余额",
    "007": "年初余额",
    "008": "上月末余额",
    "009": "上季末余额",
    "010": "上年末余额",
    "011": "月累计发生额",
    "012": "季累计发生额",
    "013": "月日均年化",
    "014": "季日均年化",
    "015": "年日均年化",
    "016": "月发生额",
    "017": "季发生额",
    "018": "年发生额",
    "019": "月环比增减",
    "020": "季环比增减",
    "021": "年环比增减",
    "022": "月同比增减",
    "023": "季同比增减",
    "024": "年同比增减",
    "025": "比月初增减",
    "026": "比季初增减",
    "027": "比年初增减",
    "028": "月日均年化增量",
    "029": "季累计",
}

INDEX_TYPE_LABELS: dict[str, str] = {
    "1": "基础指标",
    "2": "衍生指标",
    "3": "特殊指标",
    "6": "绩效指标",
}

ALGO_TYPE_LABELS: dict[str, str] = {
    "1": "通用算法",
    "2": "自定义算法",
    "3": "年化通用算法",
    "4": "临时指标转标准指标",
}


@dataclass
class IndicatorDef:
    """指标定义"""
    index_no: str = ""
    index_name: str = ""
    index_bclass: str = ""
    index_level1_class: str = ""
    index_level2_class: str = ""
    index_level3_class: str = ""
    biz_cali: str = ""
    tech_cali: str = ""
    stat_period: str = ""


@dataclass
class IndicatorMeasureDef:
    """指标度量定义"""
    index_measure: str = ""
    measure_type: str = ""
    subindex_measure: str = ""
    index_no: str = ""


@dataclass
class IndicatorCalcBase:
    """基础指标算法配置，来源于 Excel 配置表 fdl_idx_para_index_calc"""
    index_no: str = ""
    index_measure: str = ""
    algo_type: str = ""
    call_level: str = ""
    trg_table_name: str = ""
    src_table_name: str = ""
    measure_sql: str = ""
    condition_sql: str = ""
    sqlcc: str = ""
    index_flag: str = ""
    start_dt: str = ""
    end_dt: str = ""


@dataclass
class IndicatorCalcGL:
    """总账指标算法配置，来源于 fdl_idx_para_index_calc_gl"""
    index_no: str = ""
    index_measure: str = ""
    sign_no: int = 0
    subj_no: str = ""
    length_val: int = 0
    amt_val: str = ""
    start_dt: str = ""
    end_dt: str = ""


@dataclass
class IndicatorRel:
    """指标依赖关系"""
    index_no: str = ""
    depend_index_nos: list[str] = field(default_factory=list)


@dataclass
class ProcedureIndicatorInfo:
    """存储过程指标加工元数据"""
    proc_name: str = ""
    step_order: int = 0
    description: str = ""
    index_type: str = ""
    config_table: str = ""
    target_table: str = ""
    source_tables: list[str] = field(default_factory=list)


@dataclass
class IndicatorLineageNode:
    """指标血缘图节点

    node_type 取值: "indicator" | "measure" | "table" | "field" | "procedure"
    """
    node_id: str = ""
    node_type: Literal["indicator", "measure", "table", "field", "procedure"] = "indicator"
    index_no: str = ""
    index_measure: str = ""
    index_type: str = ""
    algo_type: str = ""
    label: str = ""
    layer: str = ""
    brch_type: str = ""
    detail: dict = field(default_factory=dict)

    @property
    def display_label(self) -> str:
        if self.label:
            return self.label
        if self.index_no and self.index_measure:
            return f"{self.index_no}[{self.index_measure}]"
        return self.node_id


@dataclass
class IndicatorLineageEdge:
    """指标血缘图边

    edge_type 取值: "data_flow" | "calc_dependency" | "procedure_step" | "gl_mapping"
    """
    edge_id: str = ""
    source_id: str = ""
    target_id: str = ""
    edge_type: Literal["data_flow", "calc_dependency", "procedure_step", "gl_mapping"] = "data_flow"
    procedure: str = ""
    transform_logic: str = ""
    algo_type: str = ""
    condition_sql: str = ""
    measure_sql: str = ""


@dataclass
class IndicatorLineageGraph:
    """指标血缘图容器"""
    nodes: list[IndicatorLineageNode] = field(default_factory=list)
    edges: list[IndicatorLineageEdge] = field(default_factory=list)
    stats: dict = field(default_factory=dict)

    @property
    def node_count(self) -> int:
        return len(self.nodes)

    @property
    def edge_count(self) -> int:
        return len(self.edges)

    def get_node(self, node_id: str) -> IndicatorLineageNode | None:
        for node in self.nodes:
            if node.node_id == node_id:
                return node
        return None

    def get_upstream_nodes(self, node_id: str) -> list[IndicatorLineageNode]:
        upstream_ids = {
            e.source_id for e in self.edges if e.target_id == node_id
        }
        return [n for n in self.nodes if n.node_id in upstream_ids]

    def get_downstream_nodes(self, node_id: str) -> list[IndicatorLineageNode]:
        downstream_ids = {
            e.target_id for e in self.edges if e.source_id == node_id
        }
        return [n for n in self.nodes if n.node_id in downstream_ids]


@dataclass
class IndicatorChainStep:
    """指标加工链路中的单个步骤"""
    step_num: int = 0
    index_no: str = ""
    index_measure: str = ""
    index_type: str = ""
    algo_type: str = ""
    procedure: str = ""
    source_tables: list[str] = field(default_factory=list)
    target_table: str = ""
    transform_logic: str = ""
    condition_sql: str = ""
    measure_sql: str = ""
    brch_type: str = ""
    gl_subj_no: str = ""
    gl_amt_val: str = ""
    gl_sign_no: int = 0

    @property
    def is_gl_step(self) -> bool:
        return self.algo_type == "2"

    @property
    def algo_label(self) -> str:
        return ALGO_TYPE_LABELS.get(self.algo_type, self.algo_type)

    @property
    def measure_label(self) -> str:
        return MEASURE_LABELS.get(self.index_measure, self.index_measure)

    @property
    def index_type_label(self) -> str:
        return INDEX_TYPE_LABELS.get(self.index_type, self.index_type)


@dataclass
class IndicatorChain:
    """指标完整加工链路，从源头到目标"""
    target_index_no: str = ""
    target_measure: str = ""
    steps: list[IndicatorChainStep] = field(default_factory=list)
    depth: int = 0

    @property
    def step_count(self) -> int:
        return len(self.steps)

    @property
    def procedures_involved(self) -> list[str]:
        seen: list[str] = []
        for s in self.steps:
            if s.procedure and s.procedure not in seen:
                seen.append(s.procedure)
        return seen

    @property
    def tables_involved(self) -> list[str]:
        seen: list[str] = []
        for s in self.steps:
            for t in s.source_tables:
                if t and t not in seen:
                    seen.append(t)
            if s.target_table and s.target_table not in seen:
                seen.append(s.target_table)
        return seen

    @property
    def has_gl_step(self) -> bool:
        return any(s.is_gl_step for s in self.steps)


@dataclass
class IndicatorLineageResult:
    """指标血缘查询结果"""
    target_index_no: str = ""
    target_measure: str = ""
    graph: IndicatorLineageGraph = field(default_factory=IndicatorLineageGraph)
    chains: list[IndicatorChain] = field(default_factory=list)
    query_time_ms: float = 0.0

    @property
    def chain_count(self) -> int:
        return len(self.chains)

    @property
    def max_depth(self) -> int:
        if not self.chains:
            return 0
        return max(c.depth for c in self.chains)

    @property
    def measure_label(self) -> str:
        return MEASURE_LABELS.get(self.target_measure, self.target_measure)


@dataclass
class IndicatorConfigResult:
    """解析后的指标配置容器"""
    base_calcs: list[IndicatorCalcBase] = field(default_factory=list)
    gl_calcs: list[IndicatorCalcGL] = field(default_factory=list)
    relations: list[IndicatorRel] = field(default_factory=list)
    procedures: dict[str, ProcedureIndicatorInfo] = field(default_factory=dict)
    parse_time_sec: float = 0.0

    @property
    def base_calc_count(self) -> int:
        return len(self.base_calcs)

    @property
    def gl_calc_count(self) -> int:
        return len(self.gl_calcs)

    @property
    def relation_count(self) -> int:
        return len(self.relations)

    @property
    def procedure_count(self) -> int:
        return len(self.procedures)

    def get_base_calcs_by_index(self, index_no: str) -> list[IndicatorCalcBase]:
        return [c for c in self.base_calcs if c.index_no == index_no]

    def get_gl_calcs_by_index(self, index_no: str) -> list[IndicatorCalcGL]:
        return [c for c in self.gl_calcs if c.index_no == index_no]

    def get_dependents(self, index_no: str) -> list[str]:
        return [
            r.index_no
            for r in self.relations
            if index_no in r.depend_index_nos
        ]
