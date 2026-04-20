"""
问题排查服务
提供血缘与运行态关联查询、批次查询、变更查询等功能
"""
import logging
from datetime import datetime, timedelta
from typing import Any, Dict, List, Optional, Set

from neo4j import AsyncGraphDatabase

from app.core.config import settings
from app.schemas.troubleshoot import (
    BatchExecution,
    ChangeRecord,
    LineageRelation,
    QuickSearchResult,
    TroubleshootResult,
)

logger = logging.getLogger(__name__)


class TroubleshootService:
    """
    问题排查服务
    
    整合静态血缘和运行态数据，提供问题定位辅助功能
    """
    
    def __init__(self):
        """
        初始化服务
        """
        self.neo4j_driver = AsyncGraphDatabase.driver(
            settings.NEO4J_URI,
            auth=(settings.NEO4J_USER, settings.NEO4J_PASSWORD),
        )
    
    async def close(self):
        """
        关闭连接
        """
        await self.neo4j_driver.close()
    
    async def quick_search(
        self,
        keyword: str,
        search_type: str = "all",
        limit: int = 10,
    ) -> List[QuickSearchResult]:
        """
        快速搜索表或字段
        
        Args:
            keyword: 搜索关键词
            search_type: 搜索类型（all, table, field）
            limit: 返回数量限制
        
        Returns:
            List[QuickSearchResult]: 搜索结果列表
        """
        async with self.neo4j_driver.session() as session:
            type_filter = ""
            if search_type == "table":
                type_filter = "AND n:Table"
            elif search_type == "field":
                type_filter = "AND n:Field"
            
            query = f"""
            MATCH (n)
            WHERE n.name CONTAINS $keyword
            {type_filter}
            OPTIONAL MATCH (n)-[r:LINEAGE_TO]-()
            WITH n, count(r) as lineage_count
            RETURN n.id as object_id, 
                   n.name as object_name,
                   labels(n)[0] as object_type,
                   n.database as database,
                   n.schema as schema,
                   n.description as description,
                   lineage_count > 0 as has_lineage,
                   lineage_count
            ORDER BY lineage_count DESC, n.name
            LIMIT $limit
            """
            
            result = await session.run(query, keyword=keyword, limit=limit)
            records = await result.list()
            
            results = []
            for record in records:
                results.append(QuickSearchResult(
                    object_id=record.get("object_id", ""),
                    object_name=record.get("object_name", ""),
                    object_type=record.get("object_type", "Unknown"),
                    database=record.get("database"),
                    schema=record.get("schema"),
                    description=record.get("description"),
                    has_lineage=record.get("has_lineage", False),
                    lineage_count=record.get("lineage_count", 0),
                ))
            
            return results
    
    async def get_object_by_name(
        self,
        object_name: str,
        object_type: str = "table",
    ) -> Optional[Dict[str, Any]]:
        """
        根据名称获取对象信息
        
        Args:
            object_name: 对象名称
            object_type: 对象类型
        
        Returns:
            Optional[Dict[str, Any]]: 对象信息
        """
        async with self.neo4j_driver.session() as session:
            label = "Table" if object_type == "table" else "Field"
            
            query = f"""
            MATCH (n:{label})
            WHERE n.name = $object_name OR n.name CONTAINS $object_name
            RETURN n.id as id, n.name as name, labels(n)[0] as type,
                   n.database as database, n.schema as schema,
                   n.description as description, n.data_source_id as data_source_id
            LIMIT 1
            """
            
            result = await session.run(query, object_name=object_name)
            record = await result.single()
            
            if record:
                return {
                    "id": record.get("id", ""),
                    "name": record.get("name", ""),
                    "type": record.get("type", ""),
                    "database": record.get("database"),
                    "schema": record.get("schema"),
                    "description": record.get("description"),
                    "data_source_id": record.get("data_source_id"),
                }
            
            return None
    
    async def get_lineage_relations(
        self,
        object_id: str,
        direction: str = "upstream",
        depth: int = 3,
    ) -> List[LineageRelation]:
        """
        获取血缘关系
        
        Args:
            object_id: 对象 ID
            direction: 方向（upstream 或 downstream）
            depth: 深度
        
        Returns:
            List[LineageRelation]: 血缘关系列表
        """
        async with self.neo4j_driver.session() as session:
            if direction == "upstream":
                query = f"""
                MATCH path = (target)-[:LINEAGE_TO*1..{depth}]<-[:LINEAGE_TO*0..1]-(source)
                WHERE target.id = $object_id
                WITH source, target, relationships(path) as rels
                UNWIND rels as rel
                RETURN DISTINCT
                    source.id as source_id,
                    source.name as source_name,
                    labels(source)[0] as source_type,
                    target.id as target_id,
                    target.name as target_name,
                    labels(target)[0] as target_type,
                    rel.transformation_type as lineage_type,
                    rel.sources as sources,
                    rel.confidence_score as confidence_score,
                    rel.transformation_type as transformation_type,
                    rel.expression as expression,
                    rel.execution_count as execution_count,
                    rel.first_seen as first_seen,
                    rel.last_seen as last_seen
                """
            else:
                query = f"""
                MATCH path = (source)-[:LINEAGE_TO*1..{depth}]<-[:LINEAGE_TO*0..1]-(target)
                WHERE source.id = $object_id
                WITH source, target, relationships(path) as rels
                UNWIND rels as rel
                RETURN DISTINCT
                    source.id as source_id,
                    source.name as source_name,
                    labels(source)[0] as source_type,
                    target.id as target_id,
                    target.name as target_name,
                    labels(target)[0] as target_type,
                    rel.transformation_type as lineage_type,
                    rel.sources as sources,
                    rel.confidence_score as confidence_score,
                    rel.transformation_type as transformation_type,
                    rel.expression as expression,
                    rel.execution_count as execution_count,
                    rel.first_seen as first_seen,
                    rel.last_seen as last_seen
                """
            
            result = await session.run(query, object_id=object_id)
            records = await result.list()
            
            relations = []
            for record in records:
                sources_list = record.get("sources", [])
                if isinstance(sources_list, str):
                    sources_list = [sources_list]
                
                first_seen_val = record.get("first_seen")
                last_seen_val = record.get("last_seen")
                
                relations.append(LineageRelation(
                    source_id=record.get("source_id", ""),
                    source_name=record.get("source_name", ""),
                    source_type=record.get("source_type", "Unknown"),
                    target_id=record.get("target_id", ""),
                    target_name=record.get("target_name", ""),
                    target_type=record.get("target_type", "Unknown"),
                    lineage_type=record.get("lineage_type", "LINEAGE_TO"),
                    sources=sources_list if sources_list else ["static"],
                    confidence_score=record.get("confidence_score", 0.5) or 0.5,
                    transformation_type=record.get("transformation_type"),
                    expression=record.get("expression"),
                    execution_count=record.get("execution_count", 0) or 0,
                    first_seen=first_seen_val if first_seen_val else None,
                    last_seen=last_seen_val if last_seen_val else None,
                ))
            
            return relations
    
    async def get_recent_batches(
        self,
        object_id: str,
        days_limit: int = 7,
        limit: int = 20,
    ) -> List[BatchExecution]:
        """
        获取最近批次执行信息
        
        Args:
            object_id: 对象 ID
            days_limit: 天数限制
            limit: 返回数量限制
        
        Returns:
            List[BatchExecution]: 批次执行列表
        """
        async with self.neo4j_driver.session() as session:
            start_time = datetime.now() - timedelta(days=days_limit)
            
            query = """
            MATCH (obj {id: $object_id})
            OPTIONAL MATCH (job:Job)-[r:READS|WRITES]->(obj)
            WHERE job.start_time >= $start_time
            OPTIONAL MATCH (batch:BatchExecution)-[:EXECUTES]->(job)
            WHERE batch.start_time >= $start_time
            WITH job, batch, obj,
                 [(job)-[:READS]->(s:Table) | s.name] as source_tables,
                 [(job)-[:WRITES]->(t:Table) | t.name] as target_tables
            RETURN DISTINCT
                COALESCE(batch.id, job.id) as batch_id,
                job.name as job_name,
                job.type as job_type,
                COALESCE(batch.status, job.status, 'unknown') as status,
                COALESCE(batch.start_time, job.start_time) as start_time,
                COALESCE(batch.end_time, job.end_time) as end_time,
                COALESCE(batch.duration_seconds, job.duration_seconds, 0) as duration_seconds,
                COALESCE(batch.records_processed, job.records_processed, 0) as records_processed,
                COALESCE(batch.records_failed, job.records_failed, 0) as records_failed,
                COALESCE(batch.error_message, job.error_message) as error_message,
                source_tables,
                target_tables
            ORDER BY start_time DESC
            LIMIT $limit
            """
            
            result = await session.run(
                query,
                object_id=object_id,
                start_time=start_time.isoformat(),
                limit=limit,
            )
            records = await result.list()
            
            batches = []
            for record in records:
                start_time_val = record.get("start_time")
                end_time_val = record.get("end_time")
                
                batches.append(BatchExecution(
                    batch_id=record.get("batch_id", ""),
                    job_name=record.get("job_name", ""),
                    job_type=record.get("job_type", "ETL"),
                    status=record.get("status", "unknown"),
                    start_time=start_time_val if start_time_val else datetime.now(),
                    end_time=end_time_val if end_time_val else None,
                    duration_seconds=record.get("duration_seconds", 0) or 0,
                    records_processed=record.get("records_processed", 0) or 0,
                    records_failed=record.get("records_failed", 0) or 0,
                    error_message=record.get("error_message"),
                    source_tables=record.get("source_tables", []) or [],
                    target_tables=record.get("target_tables", []) or [],
                ))
            
            return batches
    
    async def get_change_history(
        self,
        object_id: str,
        days_limit: int = 7,
        limit: int = 50,
    ) -> List[ChangeRecord]:
        """
        获取变更历史
        
        Args:
            object_id: 对象 ID
            days_limit: 天数限制
            limit: 返回数量限制
        
        Returns:
            List[ChangeRecord]: 变更记录列表
        """
        async with self.neo4j_driver.session() as session:
            start_time = datetime.now() - timedelta(days=days_limit)
            
            query = """
            MATCH (obj {id: $object_id})
            OPTIONAL MATCH (change:ChangeRecord)-[:CHANGES]->(obj)
            WHERE change.change_time >= $start_time
            RETURN DISTINCT
                change.id as change_id,
                change.change_type as change_type,
                obj.labels[0] as object_type,
                obj.name as object_name,
                change.change_time as change_time,
                change.change_user as change_user,
                change.change_description as change_description,
                change.before_value as before_value,
                change.after_value as after_value,
                change.related_job as related_job,
                change.impact_level as impact_level
            ORDER BY change_time DESC
            LIMIT $limit
            """
            
            result = await session.run(
                query,
                object_id=object_id,
                start_time=start_time.isoformat(),
                limit=limit,
            )
            records = await result.list()
            
            changes = []
            for record in records:
                change_time_val = record.get("change_time")
                
                changes.append(ChangeRecord(
                    change_id=record.get("change_id", ""),
                    change_type=record.get("change_type", "unknown"),
                    object_type=record.get("object_type", "Table"),
                    object_name=record.get("object_name", ""),
                    change_time=change_time_val if change_time_val else datetime.now(),
                    change_user=record.get("change_user"),
                    change_description=record.get("change_description"),
                    before_value=record.get("before_value"),
                    after_value=record.get("after_value"),
                    related_job=record.get("related_job"),
                    impact_level=record.get("impact_level", "low") or "low",
                ))
            
            return changes
    
    async def analyze_potential_issues(
        self,
        object_id: str,
        upstream_lineages: List[LineageRelation],
        downstream_lineages: List[LineageRelation],
        recent_batches: List[BatchExecution],
        change_history: List[ChangeRecord],
    ) -> List[str]:
        """
        分析潜在问题
        
        Args:
            object_id: 对象 ID
            upstream_lineages: 上游血缘
            downstream_lineages: 下游血缘
            recent_batches: 最近批次
            change_history: 变更历史
        
        Returns:
            List[str]: 潜在问题列表
        """
        issues = []
        
        failed_batches = [b for b in recent_batches if b.status in ["failed", "error"]]
        if failed_batches:
            issues.append(f"发现 {len(failed_batches)} 个执行失败的批次")
        
        high_impact_changes = [c for c in change_history if c.impact_level in ["high", "critical"]]
        if high_impact_changes:
            issues.append(f"发现 {len(high_impact_changes)} 个高影响级别的变更")
        
        low_confidence_lineages = [l for l in upstream_lineages if l.confidence_score < 0.5]
        if low_confidence_lineages:
            issues.append(f"发现 {len(low_confidence_lineages)} 个低置信度上游血缘关系")
        
        recent_changes = [c for c in change_history if 
                         c.change_time and 
                         (datetime.now() - c.change_time).total_seconds() < 3600 * 24]
        if recent_changes:
            issues.append(f"最近 24 小时内有 {len(recent_changes)} 次变更")
        
        long_running_batches = [b for b in recent_batches if b.duration_seconds > 3600]
        if long_running_batches:
            issues.append(f"发现 {len(long_running_batches)} 个执行时间超过 1 小时的批次")
        
        if not upstream_lineages:
            issues.append("未找到上游血缘关系，可能影响数据溯源分析")
        
        if not downstream_lineages:
            issues.append("未找到下游血缘关系，可能影响影响范围分析")
        
        return issues
    
    async def generate_recommendations(
        self,
        object_id: str,
        issues: List[str],
        upstream_lineages: List[LineageRelation],
        downstream_lineages: List[LineageRelation],
        recent_batches: List[BatchExecution],
        change_history: List[ChangeRecord],
    ) -> List[str]:
        """
        生成排查建议
        
        Args:
            object_id: 对象 ID
            issues: 潜在问题
            upstream_lineages: 上游血缘
            downstream_lineages: 下游血缘
            recent_batches: 最近批次
            change_history: 变更历史
        
        Returns:
            List[str]: 排查建议列表
        """
        recommendations = []
        
        failed_batches = [b for b in recent_batches if b.status in ["failed", "error"]]
        if failed_batches:
            recommendations.append("建议检查失败批次的错误日志，定位具体失败原因")
            recommendations.append("建议检查源表数据质量和数据完整性")
        
        high_impact_changes = [c for c in change_history if c.impact_level in ["high", "critical"]]
        if high_impact_changes:
            recommendations.append("建议审查高影响变更的变更内容和影响范围")
            recommendations.append("建议验证变更后的数据一致性")
        
        low_confidence_lineages = [l for l in upstream_lineages if l.confidence_score < 0.5]
        if low_confidence_lineages:
            recommendations.append("建议验证低置信度血缘关系的准确性")
            recommendations.append("建议补充运行态血缘数据以提高置信度")
        
        if upstream_lineages:
            recommendations.append("建议检查上游数据源的数据质量和数据时效性")
        
        if downstream_lineages:
            recommendations.append("建议评估对下游系统的影响范围")
        
        if not upstream_lineages or not downstream_lineages:
            recommendations.append("建议完善血缘关系图谱，补充缺失的血缘信息")
        
        recommendations.append("建议查看血缘详情页面，深入了解数据流转路径")
        
        return recommendations
    
    async def troubleshoot(
        self,
        object_name: str,
        object_type: str = "table",
        include_runtime: bool = True,
        include_changes: bool = True,
        days_limit: int = 7,
    ) -> TroubleshootResult:
        """
        问题排查主方法
        
        Args:
            object_name: 对象名称
            object_type: 对象类型
            include_runtime: 是否包含运行态数据
            include_changes: 是否包含变更历史
            days_limit: 天数限制
        
        Returns:
            TroubleshootResult: 排查结果
        """
        object_info = await self.get_object_by_name(object_name, object_type)
        
        if not object_info:
            return TroubleshootResult(
                object_id="",
                object_name=object_name,
                object_type=object_type,
                potential_issues=["未找到指定对象"],
                recommendations=["请确认对象名称是否正确"],
            )
        
        object_id = object_info.get("id", "")
        
        upstream_lineages = await self.get_lineage_relations(object_id, "upstream", 3)
        downstream_lineages = await self.get_lineage_relations(object_id, "downstream", 3)
        
        recent_batches = []
        if include_runtime:
            recent_batches = await self.get_recent_batches(object_id, days_limit)
        
        change_history = []
        if include_changes:
            change_history = await self.get_change_history(object_id, days_limit)
        
        potential_issues = await self.analyze_potential_issues(
            object_id,
            upstream_lineages,
            downstream_lineages,
            recent_batches,
            change_history,
        )
        
        recommendations = await self.generate_recommendations(
            object_id,
            potential_issues,
            upstream_lineages,
            downstream_lineages,
            recent_batches,
            change_history,
        )
        
        statistics = {
            "upstream_count": len(upstream_lineages),
            "downstream_count": len(downstream_lineages),
            "batch_count": len(recent_batches),
            "failed_batch_count": len([b for b in recent_batches if b.status in ["failed", "error"]]),
            "change_count": len(change_history),
            "high_impact_change_count": len([c for c in change_history if c.impact_level in ["high", "critical"]]),
            "avg_confidence": sum(l.confidence_score for l in upstream_lineages) / len(upstream_lineages) if upstream_lineages else 0,
        }
        
        return TroubleshootResult(
            object_id=object_id,
            object_name=object_info.get("name", object_name),
            object_type=object_info.get("type", object_type),
            data_source=object_info.get("data_source_id"),
            upstream_lineages=upstream_lineages,
            downstream_lineages=downstream_lineages,
            recent_batches=recent_batches,
            change_history=change_history,
            potential_issues=potential_issues,
            recommendations=recommendations,
            statistics=statistics,
        )
    
    async def get_statistics_summary(self) -> Dict[str, Any]:
        """
        获取统计摘要
        
        Returns:
            Dict[str, Any]: 统计摘要
        """
        async with self.neo4j_driver.session() as session:
            query = """
            MATCH (n)
            RETURN labels(n)[0] as type, count(n) as count
            """
            
            result = await session.run(query)
            records = await result.list()
            
            node_stats = {}
            for record in records:
                node_stats[record.get("type", "Unknown")] = record.get("count", 0)
            
            edge_query = """
            MATCH ()-[r]->()
            RETURN type(r) as type, count(r) as count
            """
            
            edge_result = await session.run(edge_query)
            edge_records = await edge_result.list()
            
            edge_stats = {}
            for record in edge_records:
                edge_stats[record.get("type", "Unknown")] = record.get("count", 0)
            
            return {
                "nodes": node_stats,
                "edges": edge_stats,
                "total_nodes": sum(node_stats.values()),
                "total_edges": sum(edge_stats.values()),
            }