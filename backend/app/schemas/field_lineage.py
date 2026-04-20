"""
字段血缘 Pydantic 模型
"""
from datetime import datetime
from typing import Any, Dict, List, Optional

from pydantic import BaseModel, Field


class FieldNodeResponse(BaseModel):
    """字段节点响应"""
    id: str = Field(..., description="字段 ID")
    name: str = Field(..., description="字段名称")
    table_name: str = Field(..., description="所属表名")
    full_name: str = Field(..., description="完整名称")
    data_type: Optional[str] = Field(None, description="数据类型")
    expression: Optional[str] = Field(None, description="表达式")
    is_source: bool = Field(False, description="是否源字段")
    properties: Dict[str, Any] = Field(default_factory=dict, description="其他属性")


class ExpressionDetailResponse(BaseModel):
    """表达式详情响应"""
    raw_expression: str = Field(..., description="原始表达式")
    parsed_expression: str = Field(..., description="解析后的表达式")
    transformation_type: str = Field(..., description="转换类型")
    source_fields: List[str] = Field(default_factory=list, description="源字段列表")
    aggregation_type: Optional[str] = Field(None, description="聚合类型")
    join_condition: Optional[str] = Field(None, description="JOIN 条件")
    filter_condition: Optional[str] = Field(None, description="过滤条件")
    description: Optional[str] = Field(None, description="描述")


class FieldEdgeResponse(BaseModel):
    """字段血缘边响应"""
    source_id: str = Field(..., description="源字段 ID")
    target_id: str = Field(..., description="目标字段 ID")
    transformation_type: str = Field(..., description="转换类型")
    expression: Optional[str] = Field(None, description="表达式")
    confidence_score: float = Field(1.0, description="置信度评分")
    sql_statement: Optional[str] = Field(None, description="SQL 语句")
    job_id: Optional[str] = Field(None, description="作业 ID")
    expression_detail: Optional[ExpressionDetailResponse] = Field(None, description="表达式详情")
    properties: Dict[str, Any] = Field(default_factory=dict, description="其他属性")


class MultiSourcePath(BaseModel):
    """多源路径"""
    source_id: str = Field(..., description="源字段 ID")
    source_name: str = Field(..., description="源字段名称")
    path_nodes: List[FieldNodeResponse] = Field(default_factory=list, description="路径节点")


class ShortestPathResponse(BaseModel):
    """最短路径响应"""
    nodes: List[FieldNodeResponse] = Field(default_factory=list, description="节点列表")
    edges: List[FieldEdgeResponse] = Field(default_factory=list, description="边列表")
    path_length: int = Field(0, description="路径长度")
    total_weight: float = Field(0.0, description="总权重")
    source_nodes: List[FieldNodeResponse] = Field(default_factory=list, description="源节点列表")
    multi_source_paths: Dict[str, List[FieldNodeResponse]] = Field(
        default_factory=dict, description="多源路径映射"
    )
    is_multi_source: bool = Field(False, description="是否多源汇聚")


class FieldDetailResponse(BaseModel):
    """字段详情响应"""
    id: str = Field(..., description="字段 ID")
    name: str = Field(..., description="字段名称")
    full_name: str = Field(..., description="完整名称")
    table_name: Optional[str] = Field(None, description="所属表名")
    data_source: Optional[str] = Field(None, description="数据源")
    data_type: Optional[str] = Field(None, description="数据类型")
    expression: Optional[str] = Field(None, description="表达式")
    is_source: bool = Field(False, description="是否源字段")
    created_at: Optional[str] = Field(None, description="创建时间")
    updated_at: Optional[str] = Field(None, description="更新时间")


class FieldSearchResult(BaseModel):
    """字段搜索结果"""
    id: str = Field(..., description="字段 ID")
    name: str = Field(..., description="字段名称")
    full_name: str = Field(..., description="完整名称")
    table_name: Optional[str] = Field(None, description="所属表名")
    data_type: Optional[str] = Field(None, description="数据类型")


class FieldSearchRequest(BaseModel):
    """字段搜索请求"""
    table_name: Optional[str] = Field(None, description="表名")
    field_name: Optional[str] = Field(None, description="字段名")
    data_source_id: Optional[str] = Field(None, description="数据源 ID")
    limit: int = Field(50, ge=1, le=200, description="返回数量限制")


class FieldLineageQueryRequest(BaseModel):
    """字段血缘查询请求"""
    target_field_id: str = Field(..., description="目标字段 ID")
    max_depth: int = Field(10, ge=1, le=20, description="最大搜索深度")
    include_expression: bool = Field(True, description="是否包含表达式解析")


class ExportRequest(BaseModel):
    """导出请求"""
    format_type: str = Field("json", description="导出格式: json, csv, markdown")


class ExportResponse(BaseModel):
    """导出响应"""
    content: str = Field(..., description="导出内容")
    format_type: str = Field(..., description="导出格式")
    filename: str = Field(..., description="建议文件名")
    created_at: datetime = Field(default_factory=datetime.utcnow, description="创建时间")