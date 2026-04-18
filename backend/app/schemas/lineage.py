"""
血缘关系 Pydantic 模型
"""
from datetime import datetime
from typing import List, Optional

from pydantic import BaseModel, Field


class LineageNode(BaseModel):
    """
    血缘节点
    """
    id: str
    name: str
    type: str = Field(..., description="节点类型：table, field, job")
    properties: Optional[dict] = None


class LineageEdge(BaseModel):
    """
    血缘边
    """
    source_id: str
    target_id: str
    edge_type: str = Field(..., description="边类型：LINEAGE_TO, READS, WRITES")
    properties: Optional[dict] = None
    transformation_type: Optional[str] = None
    expression: Optional[str] = None
    confidence_score: Optional[float] = None


class LineageGraph(BaseModel):
    """
    血缘图
    """
    nodes: List[LineageNode]
    edges: List[LineageEdge]
    depth: Optional[int] = None
    total_nodes: int = Field(0, description="节点总数")
    total_edges: int = Field(0, description="边总数")


class LineagePath(BaseModel):
    """
    血缘路径（最小链路）
    """
    nodes: List[LineageNode]
    edges: List[LineageEdge]
    path_length: int = Field(0, description="路径长度")


class ImpactAnalysisResult(BaseModel):
    """
    影响分析结果
    """
    source_table_id: str
    source_table_name: str
    affected_tables: List[LineageNode]
    affected_fields: List[LineageNode]
    affected_jobs: List[LineageNode]
    total_impact_count: int = Field(0, description="受影响对象总数")


class LineageQueryRequest(BaseModel):
    """
    血缘查询请求
    """
    object_id: str
    object_type: str = Field(..., description="对象类型：table, field, job")
    direction: str = Field("upstream", description="方向：upstream 或 downstream")
    depth: int = Field(5, ge=1, le=10, description="血缘深度")
    include_fields: bool = Field(False, description="是否包含字段级血缘")
    include_jobs: bool = Field(False, description="是否包含作业依赖")