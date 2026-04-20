"""
问题排查 Pydantic 模型
"""
from datetime import datetime
from typing import Any, Dict, List, Optional

from pydantic import BaseModel, Field


class TroubleshootQueryRequest(BaseModel):
    """问题排查查询请求"""
    object_name: str = Field(..., description="对象名称（表名或字段名）")
    object_type: str = Field("table", description="对象类型：table 或 field")
    data_source_id: Optional[str] = Field(None, description="数据源 ID")
    include_runtime: bool = Field(True, description="是否包含运行态数据")
    include_changes: bool = Field(True, description="是否包含变更历史")
    days_limit: int = Field(7, ge=1, le=30, description="查询天数限制")


class LineageRelation(BaseModel):
    """血缘关系"""
    source_id: str = Field(..., description="源节点 ID")
    source_name: str = Field(..., description="源节点名称")
    source_type: str = Field(..., description="源节点类型")
    target_id: str = Field(..., description="目标节点 ID")
    target_name: str = Field(..., description="目标节点名称")
    target_type: str = Field(..., description="目标节点类型")
    lineage_type: str = Field(..., description="血缘类型")
    sources: List[str] = Field(default_factory=list, description="血缘来源")
    confidence_score: float = Field(0.0, ge=0.0, le=1.0, description="置信度")
    transformation_type: Optional[str] = Field(None, description="转换类型")
    expression: Optional[str] = Field(None, description="转换表达式")
    execution_count: int = Field(0, description="执行次数")
    first_seen: Optional[datetime] = Field(None, description="首次发现时间")
    last_seen: Optional[datetime] = Field(None, description="最后发现时间")


class BatchExecution(BaseModel):
    """批次执行信息"""
    batch_id: str = Field(..., description="批次 ID")
    job_name: str = Field(..., description="作业名称")
    job_type: str = Field(..., description="作业类型")
    status: str = Field(..., description="执行状态")
    start_time: datetime = Field(..., description="开始时间")
    end_time: Optional[datetime] = Field(None, description="结束时间")
    duration_seconds: float = Field(0.0, description="执行时长（秒）")
    records_processed: int = Field(0, description="处理记录数")
    records_failed: int = Field(0, description="失败记录数")
    error_message: Optional[str] = Field(None, description="错误信息")
    source_tables: List[str] = Field(default_factory=list, description="源表列表")
    target_tables: List[str] = Field(default_factory=list, description="目标表列表")


class ChangeRecord(BaseModel):
    """变更记录"""
    change_id: str = Field(..., description="变更 ID")
    change_type: str = Field(..., description="变更类型")
    object_type: str = Field(..., description="对象类型")
    object_name: str = Field(..., description="对象名称")
    change_time: datetime = Field(..., description="变更时间")
    change_user: Optional[str] = Field(None, description="变更用户")
    change_description: Optional[str] = Field(None, description="变更描述")
    before_value: Optional[str] = Field(None, description="变更前值")
    after_value: Optional[str] = Field(None, description="变更后值")
    related_job: Optional[str] = Field(None, description="关联作业")
    impact_level: str = Field("low", description="影响级别")


class TroubleshootResult(BaseModel):
    """问题排查结果"""
    object_id: str = Field(..., description="对象 ID")
    object_name: str = Field(..., description="对象名称")
    object_type: str = Field(..., description="对象类型")
    data_source: Optional[str] = Field(None, description="数据源")
    upstream_lineages: List[LineageRelation] = Field(default_factory=list, description="上游血缘")
    downstream_lineages: List[LineageRelation] = Field(default_factory=list, description="下游血缘")
    recent_batches: List[BatchExecution] = Field(default_factory=list, description="最近批次")
    change_history: List[ChangeRecord] = Field(default_factory=list, description="变更历史")
    potential_issues: List[str] = Field(default_factory=list, description="潜在问题")
    recommendations: List[str] = Field(default_factory=list, description="排查建议")
    statistics: Dict[str, Any] = Field(default_factory=dict, description="统计信息")


class QuickSearchRequest(BaseModel):
    """快速搜索请求"""
    keyword: str = Field(..., description="搜索关键词")
    search_type: str = Field("all", description="搜索类型：all, table, field")
    limit: int = Field(10, ge=1, le=50, description="返回数量限制")


class QuickSearchResult(BaseModel):
    """快速搜索结果"""
    object_id: str = Field(..., description="对象 ID")
    object_name: str = Field(..., description="对象名称")
    object_type: str = Field(..., description="对象类型")
    database: Optional[str] = Field(None, description="数据库")
    schema: Optional[str] = Field(None, description="模式")
    description: Optional[str] = Field(None, description="描述")
    has_lineage: bool = Field(False, description="是否有血缘")
    lineage_count: int = Field(0, description="血缘数量")


class QuickSearchResponse(BaseModel):
    """快速搜索响应"""
    results: List[QuickSearchResult] = Field(default_factory=list, description="搜索结果")
    total_count: int = Field(0, description="总数")