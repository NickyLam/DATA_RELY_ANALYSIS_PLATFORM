"""
Pydantic 数据模型定义
请求体、响应体的类型校验与序列化
"""

from __future__ import annotations

from datetime import datetime
from enum import Enum
from typing import Any, Optional

from pydantic import BaseModel, Field


class ParseMode(str, Enum):
    INCREMENTAL = "incremental"
    FULL = "full"


class ParseStatus(str, Enum):
    PENDING = "pending"
    PROCESSING = "processing"
    COMPLETED = "completed"
    FAILED = "failed"


class QueryMode(str, Enum):
    UPSTREAM = "upstream"
    DOWNSTREAM = "downstream"
    BOTH = "both"


class ProgressEventType(str, Enum):
    PROGRESS = "progress"
    LOG = "log"
    COMPLETE = "complete"
    ERROR = "error"


class CaliberQueryMode(str, Enum):
    UPSTREAM = "upstream"
    DOWNSTREAM = "downstream"
    BOTH = "both"


class FileUploadRequest(BaseModel):
    parse_mode: ParseMode = Field(
        default=ParseMode.INCREMENTAL,
        description="解析模式: incremental(增量) | full(全量)",
    )
    schema_name: Optional[str] = Field(
        default=None,
        description="目标 Schema: rrp_mdl | rrp_east",
    )


class LineageQueryRequest(BaseModel):
    table: str = Field(min_length=2, description="表名")
    field: Optional[str] = Field(default=None, description="字段名(可选)")
    depth: int = Field(default=3, ge=1, le=20, description="查询深度(1-20)")
    mode: QueryMode = Field(default=QueryMode.BOTH, description="查询方向")
    options: Optional[LineageQueryOptions] = Field(default=None, description="查询选项")


class LineageQueryOptions(BaseModel):
    include_fields: bool = Field(default=True, description="是否包含字段信息")
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
    current_file: Optional[str] = None
    message: str = ""
    level: str = "info"
    tables_parsed: Optional[int] = None
    procedures_parsed: Optional[int] = None
    lineages_found: Optional[int] = None
    errors: Optional[list[str]] = None

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
    tables_involved: Optional[int] = None
    procedures_involved: Optional[int] = None
    max_depth_reached: Optional[int] = None
    query_target: Optional[dict[str, Optional[str]]] = Field(default=None, description="查询目标(表+字段)")
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
    columns: Optional[list[str]] = None


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
    data_source: Optional[str] = Field(default=None, description="数据源筛选: oracle | tdh | gbase")


class CaliberSearchRequest(BaseModel):
    keyword: str = Field(min_length=1, description="搜索关键词(表名或字段名)")
    limit: int = Field(default=50, ge=1, le=500, description="返回数量限制")
    data_source: Optional[str] = Field(default=None, description="数据源筛选")


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


class CaliberSearchResponse(BaseResponse):
    data: list[dict[str, Any]] = Field(default_factory=list)
