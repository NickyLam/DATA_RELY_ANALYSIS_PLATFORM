"""
Pydantic 数据模型定义
请求体、响应体的类型校验与序列化
"""

from __future__ import annotations

from datetime import datetime
from enum import StrEnum
from typing import Any

from pydantic import BaseModel, Field


class ParseMode(StrEnum):
    INCREMENTAL = "incremental"
    FULL = "full"


class ParseStatus(StrEnum):
    PENDING = "pending"
    PROCESSING = "processing"
    COMPLETED = "completed"
    FAILED = "failed"


class QueryMode(StrEnum):
    UPSTREAM = "upstream"
    DOWNSTREAM = "downstream"
    BOTH = "both"


class ProgressEventType(StrEnum):
    PROGRESS = "progress"
    LOG = "log"
    COMPLETE = "complete"
    ERROR = "error"


class CaliberQueryMode(StrEnum):
    UPSTREAM = "upstream"
    DOWNSTREAM = "downstream"
    BOTH = "both"


class LineageQueryRequest(BaseModel):
    table: str = Field(min_length=2, description="表名")
    field: str | None = Field(default=None, description="字段名(可选)")
    depth: int = Field(default=3, ge=1, le=20, description="查询深度(1-20)")
    mode: QueryMode = Field(default=QueryMode.BOTH, description="查询方向")
    options: LineageQueryOptions | None = Field(default=None, description="查询选项")


class LineageQueryOptions(BaseModel):
    include_fields: bool = Field(default=False, description="是否包含字段信息（首屏默认不返回，点击节点时通过 node-detail 懒加载）")
    limit: int = Field(default=1000, ge=1, le=10000, description="结果数量限制")
    use_cache: bool = Field(default=True, description="是否使用缓存")


class TableSearchRequest(BaseModel):
    keyword: str = Field(min_length=1, description="搜索关键词")
    limit: int = Field(default=50, ge=1, le=500, description="返回数量限制")


class BaseResponse(BaseModel):
    success: bool = True
    message: str = "操作成功"
    timestamp: datetime = Field(default_factory=datetime.now)


class FileUploadResponse(BaseResponse):
    data: FileUploadData


class FileUploadData(BaseModel):
    task_id: str = Field(description="任务ID(SSE查询用)")
    status: ParseStatus = Field(description="当前状态")
    files_received: int = Field(description="接收到的文件数")
    estimated_time_sec: float = Field(description="预估耗时(秒)")


class ProgressEvent(BaseModel):
    event_type: ProgressEventType = Field(alias="type")
    data: ProgressEventData


class ProgressEventData(BaseModel):
    percent: float = Field(default=0, ge=0, le=100)
    current_file: str | None = None
    message: str = ""
    level: str = "info"
    tables_parsed: int | None = None
    procedures_parsed: int | None = None
    lineages_found: int | None = None
    errors: list[str] | None = None

    class Config:
        populate_by_name = True


class LineageQueryResponse(BaseModel):
    data: LineageResultData


class LineageResultData(BaseModel):
    query_time_ms: float = Field(description="查询耗时(毫秒)")
    nodes_count: int = Field(default=0, description="节点数")
    edges_count: int = Field(default=0, description="边数")
    nodes: list[dict[str, Any]] = Field(default_factory=list)
    edges: list[dict[str, Any]] = Field(default_factory=list)
    has_more: bool = Field(default=False, description="是否有更多数据")
    cache_hit: bool = Field(default=False, description="是否命中缓存")
    tables_involved: int | None = None
    procedures_involved: int | None = None
    max_depth_reached: int | None = None
    query_target: dict[str, str | None] | None = Field(default=None, description="查询目标(表+字段)")
    field_mappings: list[dict[str, Any]] = Field(default_factory=list, description="字段级血缘映射")
    field_mapping_count: int = Field(default=0, description="字段映射数量")


class TableInfoResponse(BaseModel):
    data: list[TableListItem]


class SingleTableInfoResponse(BaseModel):
    data: dict[str, Any]


class TableListItem(BaseModel):
    full_name: str
    short_name: str
    field_count: int = 0
    layer: str = "other"
    comment: str = ""
    columns: list[str] | None = None


class SystemStatsResponse(BaseModel):
    data: SystemStatsData


class SystemStatsData(BaseModel):
    total_tables: int = 0
    total_procedures: int = 0
    total_table_lineages: int = 0
    total_field_mappings: int = 0
    total_caliber_infos: int = 0
    cache_size: int = 0
    active_tasks: int = 0
    uptime_seconds: float = 0.0


class CaliberQueryRequest(BaseModel):
    table: str = Field(min_length=2, description="表名")
    field: str = Field(min_length=1, description="字段名")
    depth: int = Field(default=10, ge=1, le=20, description="追溯深度(1-20)")
    direction: CaliberQueryMode = Field(
        default=CaliberQueryMode.UPSTREAM,
        description="查询方向: upstream(上游) | downstream(下游) | both(双向)",
    )
    data_source: str | None = Field(default=None, description="数据源筛选: oracle | tdh | gbase")


class CaliberSearchRequest(BaseModel):
    keyword: str = Field(min_length=1, description="搜索关键词(表名或字段名)")
    limit: int = Field(default=50, ge=1, le=500, description="返回数量限制")
    data_source: str | None = Field(default=None, description="数据源筛选")


class SQLConditionData(BaseModel):
    condition_type: str = ""
    raw_text: str = ""
    tables_involved: list[str] = Field(default_factory=list)
    fields_involved: list[str] = Field(default_factory=list)


class SelectColumnData(BaseModel):
    source_expression: str = ""
    target_column: str = ""
    alias: str = ""


class SubqueryData(BaseModel):
    alias: str = ""
    raw_text: str = ""
    source_tables: list[str] = Field(default_factory=list)


class CaliberStepData(BaseModel):
    target_table: str = ""
    target_column: str = ""
    source_table: str = ""
    source_column: str = ""
    transform_logic: str = ""
    where_conditions: list[SQLConditionData] = Field(default_factory=list)
    join_conditions: list[SQLConditionData] = Field(default_factory=list)
    group_by_clause: str = ""
    having_clause: str = ""
    procedure: str = ""
    step_num: int = 0
    step_desc: str = ""
    data_source: str = "oracle"
    raw_sql_fragment: str = ""
    confidence: float = 1.0
    operation_type: str = ""
    select_columns: list[SelectColumnData] = Field(default_factory=list)
    distinct_flag: bool = False
    order_by_clause: str = ""
    set_operation: str = ""
    subqueries: list[SubqueryData] = Field(default_factory=list)
    source_table_layer: str = ""
    target_table_layer: str = ""
    window_functions: list[str] = Field(default_factory=list)
    sql_operation_sequence: int = 0
    accumulated_where: list[SQLConditionData] = Field(default_factory=list)
    accumulated_join: list[SQLConditionData] = Field(default_factory=list)
    caliber_spec: str = ""


class CaliberChainData(BaseModel):
    target_table: str = ""
    target_column: str = ""
    steps: list[CaliberStepData] = Field(default_factory=list)
    depth: int = 0
    summary: str = ""
    data_flow_layers: list[str] = Field(default_factory=list)
    procedures_involved: list[str] = Field(default_factory=list)
    tables_involved: list[str] = Field(default_factory=list)
    total_conditions: int = 0
    complete_caliber_spec: str = ""
    accumulated_conditions_text: str = ""


class CaliberQueryResponse(BaseResponse):
    data: CaliberResultData


class CaliberResultData(BaseModel):
    target_table: str = ""
    target_column: str = ""
    chains: list[CaliberChainData] = Field(default_factory=list, description="口径链路列表")
    total_steps: int = Field(default=0, description="总步骤数")
    total_conditions: int = Field(default=0, description="总条件数")
    query_time_ms: float = Field(default=0.0, description="查询耗时(毫秒)")
    data_flow_layers_summary: list[str] = Field(default_factory=list, description="数据分层汇总")
    complete_caliber_spec: str = Field(default="", description="完整口径规格")


class IndicatorQueryMode(StrEnum):
    UPSTREAM = "upstream"
    DOWNSTREAM = "downstream"
    BOTH = "both"


class IndicatorLineageRequest(BaseModel):
    index_no: str = Field(min_length=2, description="指标编号")
    measure: str | None = Field(default=None, description="度量(可选)")
    depth: int = Field(default=10, ge=1, le=20, description="查询深度(1-20)")
    direction: IndicatorQueryMode = Field(default=IndicatorQueryMode.UPSTREAM, description="查询方向")


class IndicatorSearchRequest(BaseModel):
    keyword: str = Field(min_length=1, description="搜索关键词")
    limit: int = Field(default=50, ge=1, le=500, description="返回数量限制")


class IndicatorNodeData(BaseModel):
    id: str = Field(description="节点ID")
    type: str = Field(description="节点类型")
    label: str = Field(description="节点标签")
    index_no: str = Field(default="", description="指标编号")
    index_measure: str = Field(default="", description="指标度量")
    index_type: str = Field(default="", description="指标类型")
    algo_type: str = Field(default="", description="算法类型")
    layer: str = Field(default="", description="数据层")
    brch_type: str = Field(default="", description="分支类型")
    detail: dict[str, Any] = Field(default_factory=dict, description="详细信息")


class IndicatorEdgeData(BaseModel):
    id: str = Field(description="边ID")
    source: str = Field(description="源节点ID")
    target: str = Field(description="目标节点ID")
    type: str = Field(description="边类型")
    procedure: str = Field(default="", description="存储过程名")
    transform_logic: str = Field(default="", description="转换逻辑")
    algo_type: str = Field(default="", description="算法类型")
    condition_sql: str = Field(default="", description="条件SQL")
    measure_sql: str = Field(default="", description="度量SQL")


class IndicatorGraphData(BaseModel):
    nodes: list[IndicatorNodeData] = Field(default_factory=list, description="节点列表")
    edges: list[IndicatorEdgeData] = Field(default_factory=list, description="边列表")
    stats: dict[str, Any] = Field(default_factory=dict, description="统计信息")


class IndicatorChainStepData(BaseModel):
    step_num: int = Field(description="步骤序号")
    index_no: str = Field(description="指标编号")
    index_measure: str = Field(description="指标度量")
    index_type: str = Field(description="指标类型")
    algo_type: str = Field(description="算法类型")
    procedure: str = Field(description="存储过程名")
    source_tables: list[str] = Field(default_factory=list, description="源表列表")
    target_table: str = Field(default="", description="目标表")
    transform_logic: str = Field(default="", description="转换逻辑")
    condition_sql: str = Field(default="", description="条件SQL")
    measure_sql: str = Field(default="", description="度量SQL")
    brch_type: str = Field(default="", description="分支类型")
    gl_subj_no: str = Field(default="", description="总账科目号")
    gl_amt_val: str = Field(default="", description="总账金额值")
    gl_sign_no: int = Field(default=0, description="总账符号号")
    algo_label: str = Field(default="", description="算法标签")
    measure_label: str = Field(default="", description="度量标签")
    index_type_label: str = Field(default="", description="指标类型标签")


class IndicatorChainData(BaseModel):
    target_index_no: str = Field(description="目标指标编号")
    target_measure: str = Field(description="目标度量")
    steps: list[IndicatorChainStepData] = Field(default_factory=list, description="步骤列表")
    depth: int = Field(description="深度")
    step_count: int = Field(default=0, description="步骤数")
    procedures_involved: list[str] = Field(default_factory=list, description="涉及的存储过程")
    tables_involved: list[str] = Field(default_factory=list, description="涉及的表")


class IndicatorLineageResultData(BaseModel):
    target_index_no: str = Field(description="目标指标编号")
    target_measure: str = Field(description="目标度量")
    graph: IndicatorGraphData = Field(description="图数据")
    chains: list[IndicatorChainData] = Field(default_factory=list, description="链路列表")
    query_time_ms: float = Field(description="查询耗时(毫秒)")
    chain_count: int = Field(default=0, description="链路数")
    max_depth: int = Field(default=0, description="最大深度")
    measure_label: str = Field(default="", description="度量标签")


class IndicatorDetailData(BaseModel):
    index_no: str = Field(description="指标编号")
    measures: list[dict[str, Any]] = Field(default_factory=list, description="度量列表")
    gl_mappings: list[dict[str, Any]] = Field(default_factory=list, description="总账映射")
    upstream_indices: list[str] = Field(default_factory=list, description="上游指标")
    downstream_indices: list[str] = Field(default_factory=list, description="下游指标")
    is_base: bool = Field(description="是否基础指标")
    is_derived: bool = Field(description="是否衍生指标")
    is_gl: bool = Field(description="是否总账指标")


class IndicatorPipelineStepData(BaseModel):
    step_order: int = Field(description="步骤顺序")
    proc_name: str = Field(description="存储过程名")
    description: str = Field(description="描述")
    involved: bool = Field(description="是否涉及")
    detail: str = Field(description="详情")
    target_table: str = Field(default="", description="目标表")


class IndicatorLineageResponse(BaseResponse):
    data: IndicatorLineageResultData


class IndicatorDetailResponse(BaseResponse):
    data: IndicatorDetailData


class IndicatorSearchResponse(BaseResponse):
    data: list[dict[str, Any]] = Field(default_factory=list)


class IndicatorPipelineResponse(BaseResponse):
    data: dict[str, Any] = Field(default_factory=dict)


class IndicatorStatsResponse(BaseResponse):
    data: dict[str, Any] = Field(default_factory=dict)


class CaliberSearchResponse(BaseResponse):
    data: list[dict[str, Any]] = Field(default_factory=list)


# ── 系统级联查询模型 ──────────────────────────────────────────


class SystemInfo(BaseModel):
    """数据源系统信息"""

    name: str
    display_name: str
    table_count: int = 0


class TableBrief(BaseModel):
    """表简要信息（级联选择用）"""

    full_name: str
    short_name: str = ""
    layer: str = ""
    field_count: int = 0


class SystemListResponse(BaseModel):
    """系统列表响应"""

    success: bool = True
    data: list[SystemInfo] = []


class SystemTablesResponse(BaseModel):
    """系统下表列表响应"""

    success: bool = True
    data: list[TableBrief] = []
    total: int = 0
