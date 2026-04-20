"""
血缘融合服务
融合静态血缘和运行态血缘，生成统一的血缘图谱
"""
import logging
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Any, Dict, List, Optional, Set, Tuple

from pydantic import BaseModel, Field

from app.schemas.lineage import LineageEdge, LineageGraph, LineageNode

logger = logging.getLogger(__name__)


class LineageSource(Enum):
    """血缘来源"""
    STATIC = "static"
    RUNTIME_AUDIT = "runtime_audit"
    RUNTIME_VSQL = "runtime_vsql"
    MANUAL = "manual"
    UNKNOWN = "unknown"


class LineageType(Enum):
    """血缘类型"""
    TABLE_TO_TABLE = "table_to_table"
    FIELD_TO_FIELD = "field_to_field"
    TABLE_TO_FIELD = "table_to_field"
    FIELD_TO_TABLE = "field_to_table"
    JOB_TO_TABLE = "job_to_table"
    UNKNOWN = "unknown"


class FusedLineage(BaseModel):
    """融合后的血缘"""
    source_id: str = Field(..., description="源节点 ID")
    target_id: str = Field(..., description="目标节点 ID")
    source_name: str = Field(..., description="源节点名称")
    target_name: str = Field(..., description="目标节点名称")
    lineage_type: LineageType = Field(..., description="血缘类型")
    sources: List[LineageSource] = Field(default_factory=list, description="血缘来源列表")
    confidence_score: float = Field(0.0, ge=0.0, le=1.0, description="置信度评分")
    execution_count: int = Field(0, description="执行次数")
    first_seen: datetime = Field(default_factory=datetime.now, description="首次发现时间")
    last_seen: datetime = Field(default_factory=datetime.now, description="最后发现时间")
    transformation_type: Optional[str] = Field(None, description="转换类型")
    expression: Optional[str] = Field(None, description="转换表达式")
    sql_samples: List[str] = Field(default_factory=list, description="SQL 样本")
    properties: Dict[str, Any] = Field(default_factory=dict, description="扩展属性")


class StaticLineage(BaseModel):
    """静态血缘"""
    source_id: str
    target_id: str
    source_name: str
    target_name: str
    lineage_type: LineageType
    transformation_type: Optional[str] = None
    expression: Optional[str] = None
    confidence_score: float = 0.7
    source_job: Optional[str] = None
    source_file: Optional[str] = None


class RuntimeLineage(BaseModel):
    """运行态血缘"""
    source_id: str
    target_id: str
    source_name: str
    target_name: str
    lineage_type: LineageType
    source_type: LineageSource
    execution_count: int = 1
    confidence_score: float = 0.5
    sql_text: Optional[str] = None
    first_seen: Optional[datetime] = None
    last_seen: Optional[datetime] = None
    parsing_schema: Optional[str] = None


@dataclass
class FusionConfig:
    """融合配置"""
    min_confidence_threshold: float = 0.3
    min_execution_count: int = 1
    max_sql_samples: int = 5
    static_weight: float = 0.4
    runtime_weight: float = 0.6
    audit_weight: float = 0.5
    vsql_weight: float = 0.5
    dedup_window_hours: int = 24
    merge_strategy: str = "weighted_average"


class LineageFusionService:
    """
    血缘融合服务
    
    融合静态血缘（来自 SQL 解析、ETL 作业分析）
    和运行态血缘（来自审计日志、V$SQL 视图）
    """
    
    def __init__(
        self,
        config: Optional[FusionConfig] = None,
    ):
        """
        初始化血缘融合服务
        
        Args:
            config: 融合配置
        """
        self.config = config or FusionConfig()
        self._lineage_cache: Dict[str, FusedLineage] = {}
        self._source_index: Dict[str, Set[str]] = {}
        self._target_index: Dict[str, Set[str]] = {}
    
    def add_static_lineage(
        self,
        static_lineages: List[StaticLineage],
    ) -> int:
        """
        添加静态血缘
        
        Args:
            static_lineages: 静态血缘列表
        
        Returns:
            int: 添加的数量
        """
        added_count = 0
        
        for lineage in static_lineages:
            key = self._generate_lineage_key(lineage.source_id, lineage.target_id)
            
            if key not in self._lineage_cache:
                fused = FusedLineage(
                    source_id=lineage.source_id,
                    target_id=lineage.target_id,
                    source_name=lineage.source_name,
                    target_name=lineage.target_name,
                    lineage_type=lineage.lineage_type,
                    sources=[LineageSource.STATIC],
                    confidence_score=lineage.confidence_score,
                    transformation_type=lineage.transformation_type,
                    expression=lineage.expression,
                    properties={
                        "source_job": lineage.source_job,
                        "source_file": lineage.source_file,
                    },
                )
                self._lineage_cache[key] = fused
                self._update_indexes(key, lineage.source_id, lineage.target_id)
                added_count += 1
            else:
                existing = self._lineage_cache[key]
                if LineageSource.STATIC not in existing.sources:
                    existing.sources.append(LineageSource.STATIC)
                    existing.confidence_score = self._recalculate_confidence(existing)
                    if lineage.transformation_type:
                        existing.transformation_type = lineage.transformation_type
                    if lineage.expression:
                        existing.expression = lineage.expression
                    added_count += 1
        
        logger.info(f"添加 {added_count} 条静态血缘")
        return added_count
    
    def add_runtime_lineage(
        self,
        runtime_lineages: List[RuntimeLineage],
    ) -> int:
        """
        添加运行态血缘
        
        Args:
            runtime_lineages: 运行态血缘列表
        
        Returns:
            int: 添加的数量
        """
        added_count = 0
        
        for lineage in runtime_lineages:
            key = self._generate_lineage_key(lineage.source_id, lineage.target_id)
            
            if key not in self._lineage_cache:
                fused = FusedLineage(
                    source_id=lineage.source_id,
                    target_id=lineage.target_id,
                    source_name=lineage.source_name,
                    target_name=lineage.target_name,
                    lineage_type=lineage.lineage_type,
                    sources=[lineage.source_type],
                    confidence_score=lineage.confidence_score,
                    execution_count=lineage.execution_count,
                    first_seen=lineage.first_seen or datetime.now(),
                    last_seen=lineage.last_seen or datetime.now(),
                    sql_samples=[lineage.sql_text] if lineage.sql_text else [],
                    properties={
                        "parsing_schema": lineage.parsing_schema,
                    },
                )
                self._lineage_cache[key] = fused
                self._update_indexes(key, lineage.source_id, lineage.target_id)
                added_count += 1
            else:
                existing = self._lineage_cache[key]
                if lineage.source_type not in existing.sources:
                    existing.sources.append(lineage.source_type)
                
                existing.execution_count += lineage.execution_count
                
                if lineage.last_seen:
                    if existing.last_seen < lineage.last_seen:
                        existing.last_seen = lineage.last_seen
                
                if lineage.first_seen:
                    if existing.first_seen > lineage.first_seen:
                        existing.first_seen = lineage.first_seen
                
                if lineage.sql_text and lineage.sql_text not in existing.sql_samples:
                    if len(existing.sql_samples) < self.config.max_sql_samples:
                        existing.sql_samples.append(lineage.sql_text)
                
                existing.confidence_score = self._recalculate_confidence(existing)
                added_count += 1
        
        logger.info(f"添加 {added_count} 条运行态血缘")
        return added_count
    
    def _generate_lineage_key(self, source_id: str, target_id: str) -> str:
        """
        生成血缘唯一键
        
        Args:
            source_id: 源节点 ID
            target_id: 目标节点 ID
        
        Returns:
            str: 唯一键
        """
        return f"{source_id}::{target_id}"
    
    def _update_indexes(self, key: str, source_id: str, target_id: str) -> None:
        """
        更新索引
        
        Args:
            key: 血缘键
            source_id: 源节点 ID
            target_id: 目标节点 ID
        """
        if source_id not in self._source_index:
            self._source_index[source_id] = set()
        self._source_index[source_id].add(key)
        
        if target_id not in self._target_index:
            self._target_index[target_id] = set()
        self._target_index[target_id].add(key)
    
    def _recalculate_confidence(self, lineage: FusedLineage) -> float:
        """
        重新计算置信度
        
        Args:
            lineage: 融合血缘
        
        Returns:
            float: 新的置信度
        """
        if self.config.merge_strategy == "weighted_average":
            return self._weighted_average_confidence(lineage)
        elif self.config.merge_strategy == "max":
            return self._max_confidence(lineage)
        elif self.config.merge_strategy == "boost":
            return self._boost_confidence(lineage)
        else:
            return self._weighted_average_confidence(lineage)
    
    def _weighted_average_confidence(self, lineage: FusedLineage) -> float:
        """
        加权平均置信度
        
        Args:
            lineage: 融合血缘
        
        Returns:
            float: 置信度
        """
        weights: Dict[LineageSource, float] = {
            LineageSource.STATIC: self.config.static_weight,
            LineageSource.RUNTIME_AUDIT: self.config.runtime_weight * self.config.audit_weight,
            LineageSource.RUNTIME_VSQL: self.config.runtime_weight * self.config.vsql_weight,
            LineageSource.MANUAL: 1.0,
        }
        
        total_weight = 0.0
        weighted_sum = 0.0
        
        base_confidence = 0.5
        
        for source in lineage.sources:
            weight = weights.get(source, 0.3)
            total_weight += weight
            weighted_sum += weight * base_confidence
        
        if lineage.execution_count > 0:
            execution_boost = min(0.2, lineage.execution_count * 0.01)
            weighted_sum += execution_boost * self.config.runtime_weight
            total_weight += self.config.runtime_weight
        
        if total_weight > 0:
            return min(1.0, weighted_sum / total_weight)
        return 0.5
    
    def _max_confidence(self, lineage: FusedLineage) -> float:
        """
        最大置信度
        
        Args:
            lineage: 融合血缘
        
        Returns:
            float: 置信度
        """
        base_confidences: Dict[LineageSource, float] = {
            LineageSource.STATIC: 0.7,
            LineageSource.RUNTIME_AUDIT: 0.6,
            LineageSource.RUNTIME_VSQL: 0.5,
            LineageSource.MANUAL: 1.0,
        }
        
        max_conf = 0.0
        for source in lineage.sources:
            conf = base_confidences.get(source, 0.5)
            max_conf = max(max_conf, conf)
        
        if lineage.execution_count > 10:
            max_conf = min(1.0, max_conf + 0.1)
        
        return max_conf
    
    def _boost_confidence(self, lineage: FusedLineage) -> float:
        """
        增强置信度（多源验证增强）
        
        Args:
            lineage: 融合血缘
        
        Returns:
            float: 置信度
        """
        base_confidence = 0.5
        
        source_count = len(lineage.sources)
        source_boost = min(0.3, source_count * 0.1)
        
        has_static = LineageSource.STATIC in lineage.sources
        has_runtime = LineageSource.RUNTIME_AUDIT in lineage.sources or LineageSource.RUNTIME_VSQL in lineage.sources
        
        if has_static and has_runtime:
            source_boost += 0.2
        
        execution_boost = min(0.2, lineage.execution_count * 0.01)
        
        total_confidence = base_confidence + source_boost + execution_boost
        
        return min(1.0, total_confidence)
    
    def get_fused_lineages(
        self,
        source_id: Optional[str] = None,
        target_id: Optional[str] = None,
        min_confidence: Optional[float] = None,
        sources: Optional[List[LineageSource]] = None,
    ) -> List[FusedLineage]:
        """
        获取融合血缘
        
        Args:
            source_id: 源节点 ID（可选）
            target_id: 目标节点 ID（可选）
            min_confidence: 最小置信度（可选）
            sources: 血缘来源过滤（可选）
        
        Returns:
            List[FusedLineage]: 融合血缘列表
        """
        result: List[FusedLineage] = []
        
        threshold = min_confidence or self.config.min_confidence_threshold
        
        if source_id:
            keys = self._source_index.get(source_id, set())
            for key in keys:
                lineage = self._lineage_cache.get(key)
                if lineage and lineage.confidence_score >= threshold:
                    if sources and not any(s in lineage.sources for s in sources):
                        continue
                    result.append(lineage)
        elif target_id:
            keys = self._target_index.get(target_id, set())
            for key in keys:
                lineage = self._lineage_cache.get(key)
                if lineage and lineage.confidence_score >= threshold:
                    if sources and not any(s in lineage.sources for s in sources):
                        continue
                    result.append(lineage)
        else:
            for lineage in self._lineage_cache.values():
                if lineage.confidence_score >= threshold:
                    if sources and not any(s in lineage.sources for s in sources):
                        continue
                    result.append(lineage)
        
        return result
    
    def get_lineage_graph(
        self,
        node_id: str,
        depth: int = 5,
        direction: str = "upstream",
        min_confidence: Optional[float] = None,
    ) -> LineageGraph:
        """
        获取血缘图
        
        Args:
            node_id: 节点 ID
            depth: 血缘深度
            direction: 方向（upstream 或 downstream）
            min_confidence: 最小置信度
        
        Returns:
            LineageGraph: 血缘图
        """
        nodes: List[LineageNode] = []
        edges: List[LineageEdge] = []
        
        visited_nodes: Set[str] = set()
        visited_edges: Set[str] = set()
        
        threshold = min_confidence or self.config.min_confidence_threshold
        
        self._traverse_lineage(
            node_id=node_id,
            depth=depth,
            direction=direction,
            min_confidence=threshold,
            visited_nodes=visited_nodes,
            visited_edges=visited_edges,
            nodes=nodes,
            edges=edges,
            current_depth=0,
        )
        
        return LineageGraph(
            nodes=nodes,
            edges=edges,
            depth=depth,
            total_nodes=len(nodes),
            total_edges=len(edges),
        )
    
    def _traverse_lineage(
        self,
        node_id: str,
        depth: int,
        direction: str,
        min_confidence: float,
        visited_nodes: Set[str],
        visited_edges: Set[str],
        nodes: List[LineageNode],
        edges: List[LineageEdge],
        current_depth: int,
    ) -> None:
        """
        递归遍历血缘
        
        Args:
            node_id: 当前节点 ID
            depth: 最大深度
            direction: 方向
            min_confidence: 最小置信度
            visited_nodes: 已访问节点
            visited_edges: 已访问边
            nodes: 节点列表
            edges: 边列表
            current_depth: 当前深度
        """
        if current_depth >= depth:
            return
        
        if node_id in visited_nodes:
            return
        
        visited_nodes.add(node_id)
        
        nodes.append(LineageNode(
            id=node_id,
            name=node_id.split(".")[-1] if "." in node_id else node_id,
            type="Table",
            properties={},
        ))
        
        if direction == "upstream":
            keys = self._target_index.get(node_id, set())
            for key in keys:
                lineage = self._lineage_cache.get(key)
                if lineage and lineage.confidence_score >= min_confidence:
                    edge_key = f"{lineage.source_id}->{lineage.target_id}"
                    if edge_key not in visited_edges:
                        visited_edges.add(edge_key)
                        edges.append(LineageEdge(
                            source_id=lineage.source_id,
                            target_id=lineage.target_id,
                            edge_type="LINEAGE_TO",
                            properties={
                                "confidence_score": lineage.confidence_score,
                                "sources": [s.value for s in lineage.sources],
                                "execution_count": lineage.execution_count,
                            },
                            confidence_score=lineage.confidence_score,
                            transformation_type=lineage.transformation_type,
                            expression=lineage.expression,
                        ))
                        
                        self._traverse_lineage(
                            node_id=lineage.source_id,
                            depth=depth,
                            direction=direction,
                            min_confidence=min_confidence,
                            visited_nodes=visited_nodes,
                            visited_edges=visited_edges,
                            nodes=nodes,
                            edges=edges,
                            current_depth=current_depth + 1,
                        )
        else:
            keys = self._source_index.get(node_id, set())
            for key in keys:
                lineage = self._lineage_cache.get(key)
                if lineage and lineage.confidence_score >= min_confidence:
                    edge_key = f"{lineage.source_id}->{lineage.target_id}"
                    if edge_key not in visited_edges:
                        visited_edges.add(edge_key)
                        edges.append(LineageEdge(
                            source_id=lineage.source_id,
                            target_id=lineage.target_id,
                            edge_type="LINEAGE_TO",
                            properties={
                                "confidence_score": lineage.confidence_score,
                                "sources": [s.value for s in lineage.sources],
                                "execution_count": lineage.execution_count,
                            },
                            confidence_score=lineage.confidence_score,
                            transformation_type=lineage.transformation_type,
                            expression=lineage.expression,
                        ))
                        
                        self._traverse_lineage(
                            node_id=lineage.target_id,
                            depth=depth,
                            direction=direction,
                            min_confidence=min_confidence,
                            visited_nodes=visited_nodes,
                            visited_edges=visited_edges,
                            nodes=nodes,
                            edges=edges,
                            current_depth=current_depth + 1,
                        )
    
    def merge_lineages(
        self,
        static_lineages: List[StaticLineage],
        runtime_lineages: List[RuntimeLineage],
    ) -> List[FusedLineage]:
        """
        合并静态和运行态血缘
        
        Args:
            static_lineages: 静态血缘列表
            runtime_lineages: 运行态血缘列表
        
        Returns:
            List[FusedLineage]: 合并后的血缘列表
        """
        self.add_static_lineage(static_lineages)
        self.add_runtime_lineage(runtime_lineages)
        
        return list(self._lineage_cache.values())
    
    def deduplicate_lineages(
        self,
        lineages: List[FusedLineage],
    ) -> List[FusedLineage]:
        """
        去重血缘
        
        Args:
            lineages: 血缘列表
        
        Returns:
            List[FusedLineage]: 去重后的血缘列表
        """
        unique_lineages: Dict[str, FusedLineage] = {}
        
        for lineage in lineages:
            key = self._generate_lineage_key(lineage.source_id, lineage.target_id)
            
            if key not in unique_lineages:
                unique_lineages[key] = lineage
            else:
                existing = unique_lineages[key]
                existing.sources = list(set(existing.sources + lineage.sources))
                existing.execution_count += lineage.execution_count
                
                if lineage.last_seen and existing.last_seen < lineage.last_seen:
                    existing.last_seen = lineage.last_seen
                
                if lineage.first_seen and existing.first_seen > lineage.first_seen:
                    existing.first_seen = lineage.first_seen
                
                for sql in lineage.sql_samples:
                    if sql not in existing.sql_samples and len(existing.sql_samples) < self.config.max_sql_samples:
                        existing.sql_samples.append(sql)
                
                existing.confidence_score = self._recalculate_confidence(existing)
        
        return list(unique_lineages.values())
    
    def validate_lineage(
        self,
        lineage: FusedLineage,
    ) -> Tuple[bool, List[str]]:
        """
        验证血缘有效性
        
        Args:
            lineage: 融合血缘
        
        Returns:
            Tuple[bool, List[str]]: 是否有效，错误列表
        """
        errors: List[str] = []
        
        if not lineage.source_id:
            errors.append("源节点 ID 不能为空")
        
        if not lineage.target_id:
            errors.append("目标节点 ID 不能为空")
        
        if lineage.source_id == lineage.target_id:
            errors.append("源节点和目标节点不能相同")
        
        if lineage.confidence_score < 0 or lineage.confidence_score > 1:
            errors.append("置信度必须在 0-1 之间")
        
        if not lineage.sources:
            errors.append("血缘来源不能为空")
        
        is_valid = len(errors) == 0
        
        return is_valid, errors
    
    def get_statistics(self) -> Dict[str, Any]:
        """
        获取融合统计信息
        
        Returns:
            Dict[str, Any]: 统计信息
        """
        total_lineages = len(self._lineage_cache)
        
        by_source: Dict[str, int] = {}
        by_confidence: Dict[str, int] = {
            "high": 0,
            "medium": 0,
            "low": 0,
        }
        
        total_executions = 0
        
        for lineage in self._lineage_cache.values():
            for source in lineage.sources:
                source_name = source.value
                by_source[source_name] = by_source.get(source_name, 0) + 1
            
            if lineage.confidence_score >= 0.7:
                by_confidence["high"] += 1
            elif lineage.confidence_score >= 0.5:
                by_confidence["medium"] += 1
            else:
                by_confidence["low"] += 1
            
            total_executions += lineage.execution_count
        
        return {
            "total_lineages": total_lineages,
            "by_source": by_source,
            "by_confidence": by_confidence,
            "total_executions": total_executions,
            "unique_sources": len(self._source_index),
            "unique_targets": len(self._target_index),
        }
    
    def clear_cache(self) -> None:
        """清空缓存"""
        self._lineage_cache.clear()
        self._source_index.clear()
        self._target_index.clear()
        logger.info("血缘融合缓存已清空")
    
    def export_lineages(self) -> List[Dict[str, Any]]:
        """
        导出血缘数据
        
        Returns:
            List[Dict[str, Any]]: 血缘数据列表
        """
        return [lineage.model_dump() for lineage in self._lineage_cache.values()]
    
    def import_lineages(
        self,
        lineages_data: List[Dict[str, Any]],
    ) -> int:
        """
        导入血缘数据
        
        Args:
            lineages_data: 血缘数据列表
        
        Returns:
            int: 导入数量
        """
        imported_count = 0
        
        for data in lineages_data:
            try:
                sources = [LineageSource(s) for s in data.get("sources", [])]
                lineage_type = LineageType(data.get("lineage_type", "table_to_table"))
                
                fused = FusedLineage(
                    source_id=data["source_id"],
                    target_id=data["target_id"],
                    source_name=data["source_name"],
                    target_name=data["target_name"],
                    lineage_type=lineage_type,
                    sources=sources,
                    confidence_score=data.get("confidence_score", 0.5),
                    execution_count=data.get("execution_count", 0),
                    first_seen=datetime.fromisoformat(data.get("first_seen", datetime.now().isoformat())),
                    last_seen=datetime.fromisoformat(data.get("last_seen", datetime.now().isoformat())),
                    transformation_type=data.get("transformation_type"),
                    expression=data.get("expression"),
                    sql_samples=data.get("sql_samples", []),
                    properties=data.get("properties", {}),
                )
                
                key = self._generate_lineage_key(fused.source_id, fused.target_id)
                self._lineage_cache[key] = fused
                self._update_indexes(key, fused.source_id, fused.target_id)
                imported_count += 1
                
            except Exception as e:
                logger.warning(f"导入血缘数据失败: {e}")
        
        logger.info(f"导入 {imported_count} 条血缘数据")
        return imported_count