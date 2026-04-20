"""
运行态血缘 Pydantic 模型
"""
from datetime import datetime
from enum import Enum
from typing import Any, Dict, List, Optional

from pydantic import BaseModel, Field


class RuntimeLineageSource(str, Enum):
    """运行态血缘来源"""
    AUDIT_LOG = "audit_log"
    VSQL = "vsql"
    BOTH = "both"


class AuditActionType(str, Enum):
    """审计操作类型"""
    SELECT = "SELECT"
    INSERT = "INSERT"
    UPDATE = "UPDATE"
    DELETE = "DELETE"
    MERGE = "MERGE"
    CREATE = "CREATE"
    ALTER = "ALTER"
    DROP = "DROP"
    TRUNCATE = "TRUNCATE"
    EXECUTE = "EXECUTE"


class RuntimeLineageBase(BaseModel):
    """运行态血缘基础模型"""
    source_table: str = Field(..., description="源表名")
    target_table: str = Field(..., description="目标表名")
    source_schema: Optional[str] = Field(None, description="源表模式")
    target_schema: Optional[str] = Field(None, description="目标表模式")
    operation_type: AuditActionType = Field(..., description="操作类型")
    sql_text: Optional[str] = Field(None, description="SQL 文本")
    confidence: float = Field(0.5, ge=0.0, le=1.0, description="置信度")


class RuntimeLineageCreate(RuntimeLineageBase):
    """创建运行态血缘请求模型"""
    source_fields: Optional[List[str]] = Field(None, description="源字段列表")
    target_fields: Optional[List[str]] = Field(None, description="目标字段列表")
    execution_count: int = Field(1, ge=1, description="执行次数")
    first_seen: Optional[datetime] = Field(None, description="首次发现时间")
    last_seen: Optional[datetime] = Field(None, description="最后发现时间")
    data_source_id: str = Field(..., description="数据源 ID")
    lineage_source: RuntimeLineageSource = Field(RuntimeLineageSource.AUDIT_LOG, description="血缘来源")


class RuntimeLineageResponse(RuntimeLineageBase):
    """运行态血缘响应模型"""
    id: str = Field(..., description="血缘 ID")
    source_fields: List[str] = Field(default_factory=list, description="源字段列表")
    target_fields: List[str] = Field(default_factory=list, description="目标字段列表")
    execution_count: int = Field(0, description="执行次数")
    avg_elapsed_time: float = Field(0.0, description="平均耗时（微秒）")
    first_seen: datetime = Field(..., description="首次发现时间")
    last_seen: datetime = Field(..., description="最后发现时间")
    data_source_id: str = Field(..., description="数据源 ID")
    lineage_source: RuntimeLineageSource = Field(..., description="血缘来源")
    parsing_schema: Optional[str] = Field(None, description="解析模式")
    credibility_score: float = Field(0.0, ge=0.0, le=1.0, description="可信度评分")
    credibility_level: str = Field("unverified", description="可信度等级")
    is_verified: bool = Field(False, description="是否已验证")
    created_at: datetime = Field(..., description="创建时间")
    updated_at: datetime = Field(..., description="更新时间")
    
    class Config:
        from_attributes = True


class AuditLogEntryResponse(BaseModel):
    """审计日志条目响应模型"""
    session_id: int = Field(..., description="会话 ID")
    user_name: str = Field(..., description="用户名")
    action: AuditActionType = Field(..., description="操作类型")
    object_name: Optional[str] = Field(None, description="对象名")
    object_schema: Optional[str] = Field(None, description="对象模式")
    sql_text: Optional[str] = Field(None, description="SQL 文本")
    timestamp: datetime = Field(..., description="时间戳")
    return_code: int = Field(0, description="返回码")


class VSQLStatementResponse(BaseModel):
    """V$SQL 语句响应模型"""
    sql_id: str = Field(..., description="SQL ID")
    sql_text: str = Field(..., description="SQL 文本")
    plan_hash_value: int = Field(0, description="执行计划哈希值")
    executions: int = Field(0, description="执行次数")
    elapsed_time: float = Field(0.0, description="总耗时（微秒）")
    cpu_time: float = Field(0.0, description="CPU 时间（微秒）")
    parsing_schema: str = Field("", description="解析模式")
    last_active_time: Optional[datetime] = Field(None, description="最后活跃时间")


class ExecutionPlanResponse(BaseModel):
    """执行计划响应模型"""
    sql_id: str = Field(..., description="SQL ID")
    plan_hash_value: int = Field(0, description="计划哈希值")
    operation: str = Field(..., description="操作类型")
    object_name: Optional[str] = Field(None, description="对象名")
    object_owner: Optional[str] = Field(None, description="对象所有者")
    id: int = Field(0, description="计划 ID")
    parent_id: Optional[int] = Field(None, description="父 ID")
    cost: Optional[float] = Field(None, description="成本")


class BindVariableResponse(BaseModel):
    """绑定变量响应模型"""
    sql_id: str = Field(..., description="SQL ID")
    name: str = Field(..., description="变量名")
    position: int = Field(0, description="位置")
    datatype: str = Field("", description="数据类型")
    value_string: Optional[str] = Field(None, description="字符串值")


class RuntimeLineageQueryRequest(BaseModel):
    """运行态血缘查询请求"""
    data_source_id: Optional[str] = Field(None, description="数据源 ID")
    source_table: Optional[str] = Field(None, description="源表名")
    target_table: Optional[str] = Field(None, description="目标表名")
    operation_type: Optional[AuditActionType] = Field(None, description="操作类型")
    lineage_source: Optional[RuntimeLineageSource] = Field(None, description="血缘来源")
    min_confidence: float = Field(0.0, ge=0.0, le=1.0, description="最小置信度")
    min_execution_count: int = Field(1, ge=1, description="最小执行次数")
    start_time: Optional[datetime] = Field(None, description="开始时间")
    end_time: Optional[datetime] = Field(None, description="结束时间")
    limit: int = Field(100, ge=1, le=1000, description="返回数量限制")
    offset: int = Field(0, ge=0, description="偏移量")


class RuntimeLineageCollectionRequest(BaseModel):
    """运行态血缘采集请求"""
    data_source_id: str = Field(..., description="数据源 ID")
    collection_type: RuntimeLineageSource = Field(RuntimeLineageSource.BOTH, description="采集类型")
    start_time: Optional[datetime] = Field(None, description="开始时间")
    end_time: Optional[datetime] = Field(None, description="结束时间")
    time_range_hours: int = Field(24, ge=1, le=168, description="时间范围（小时）")
    exclude_users: Optional[List[str]] = Field(None, description="排除用户列表")
    exclude_schemas: Optional[List[str]] = Field(None, description="排除模式列表")
    min_executions: int = Field(1, ge=1, description="最小执行次数")
    batch_size: int = Field(1000, ge=100, le=5000, description="批次大小")


class RuntimeLineageCollectionResult(BaseModel):
    """运行态血缘采集结果"""
    data_source_id: str = Field(..., description="数据源 ID")
    collection_type: RuntimeLineageSource = Field(..., description="采集类型")
    total_audit_entries: int = Field(0, description="审计日志总数")
    total_sql_statements: int = Field(0, description="SQL 语句总数")
    total_lineages_extracted: int = Field(0, description="提取血缘总数")
    total_lineages_saved: int = Field(0, description="保存血缘总数")
    collection_start_time: datetime = Field(..., description="采集开始时间")
    collection_end_time: datetime = Field(..., description="采集结束时间")
    duration_seconds: float = Field(0.0, description="耗时（秒）")
    errors: List[str] = Field(default_factory=list, description="错误列表")
    statistics: Dict[str, Any] = Field(default_factory=dict, description="统计信息")


class CredibilityScoreResponse(BaseModel):
    """可信度评分响应模型"""
    lineage_id: str = Field(..., description="血缘 ID")
    overall_score: float = Field(0.0, ge=0.0, le=1.0, description="总体评分")
    level: str = Field("unverified", description="可信度等级")
    factors: Dict[str, float] = Field(default_factory=dict, description="评分因子")
    confidence_interval: List[float] = Field(default_factory=lambda: [0.0, 1.0], description="置信区间")
    recommendation: Optional[str] = Field(None, description="建议")
    last_updated: datetime = Field(..., description="最后更新时间")


class FusedLineageResponse(BaseModel):
    """融合血缘响应模型"""
    source_id: str = Field(..., description="源节点 ID")
    target_id: str = Field(..., description="目标节点 ID")
    source_name: str = Field(..., description="源节点名称")
    target_name: str = Field(..., description="目标节点名称")
    lineage_type: str = Field(..., description="血缘类型")
    sources: List[str] = Field(default_factory=list, description="血缘来源列表")
    confidence_score: float = Field(0.0, ge=0.0, le=1.0, description="置信度评分")
    execution_count: int = Field(0, description="执行次数")
    first_seen: datetime = Field(..., description="首次发现时间")
    last_seen: datetime = Field(..., description="最后发现时间")
    transformation_type: Optional[str] = Field(None, description="转换类型")
    expression: Optional[str] = Field(None, description="转换表达式")
    sql_samples: List[str] = Field(default_factory=list, description="SQL 样本")
    credibility: Optional[CredibilityScoreResponse] = Field(None, description="可信度评分详情")


class LineageFusionRequest(BaseModel):
    """血缘融合请求"""
    static_lineages: Optional[List[Dict[str, Any]]] = Field(None, description="静态血缘列表")
    runtime_lineages: Optional[List[Dict[str, Any]]] = Field(None, description="运行态血缘列表")
    merge_strategy: str = Field("weighted_average", description="合并策略")
    min_confidence_threshold: float = Field(0.3, ge=0.0, le=1.0, description="最小置信度阈值")


class LineageFusionResult(BaseModel):
    """血缘融合结果"""
    total_static_lineages: int = Field(0, description="静态血缘总数")
    total_runtime_lineages: int = Field(0, description="运行态血缘总数")
    total_fused_lineages: int = Field(0, description="融合血缘总数")
    high_confidence_count: int = Field(0, description="高置信度数量")
    medium_confidence_count: int = Field(0, description="中等置信度数量")
    low_confidence_count: int = Field(0, description="低置信度数量")
    statistics: Dict[str, Any] = Field(default_factory=dict, description="统计信息")
    fused_lineages: List[FusedLineageResponse] = Field(default_factory=list, description="融合血缘列表")