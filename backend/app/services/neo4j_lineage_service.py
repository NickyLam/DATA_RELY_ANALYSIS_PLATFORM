"""
Neo4j 血缘查询服务
提供血缘图谱的查询、分析和可视化功能
"""

from typing import List, Optional, Dict, Any
from neo4j import AsyncGraphDatabase, AsyncSession

from app.core.config import settings
from app.schemas.lineage import LineageGraph, LineagePath, LineageNode, LineageEdge


class Neo4jLineageService:
    """
    Neo4j 血缘查询服务
    """
    
    def __init__(self):
        """
        初始化 Neo4j 连接
        """
        self.driver = AsyncGraphDatabase.driver(
            settings.NEO4J_URI,
            auth=(settings.NEO4J_USER, settings.NEO4J_PASSWORD),
        )
    
    async def close(self):
        """
        关闭 Neo4j 连接
        """
        await self.driver.close()
    
    async def get_table_lineage(
        self,
        table_id: str,
        depth: int = 5,
        direction: str = "upstream",
    ) -> LineageGraph:
        """
        获取表的完整血缘
        
        Args:
            table_id: 表 ID
            depth: 血缘深度（1-10）
            direction: 方向（upstream 或 downstream）
        
        Returns:
            LineageGraph: 血缘图
        """
        async with self.driver.session() as session:
            # 构建查询方向
            direction_operator = "<-" if direction == "upstream" else "->"
            
            # 执行查询
            query = f"""
            MATCH path = (t:Table {{id: $table_id}})-[:LINEAGE_TO*1..{depth}]{direction_operator}(related:Table)
            RETURN path, nodes(path) as nodes, relationships(path) as edges
            """
            
            result = await session.run(query, table_id=table_id)
            records = await result.list()
            
            # 解析结果
            nodes = []
            edges = []
            
            for record in records:
                # 解析节点
                for node in record["nodes"]:
                    nodes.append(LineageNode(
                        id=node.element_id,
                        name=node.get("name", ""),
                        type=node.labels[0] if node.labels else "Unknown",
                        properties=dict(node),
                    ))
                
                # 解析边
                for edge in record["edges"]:
                    edges.append(LineageEdge(
                        source_id=edge.start_node.element_id,
                        target_id=edge.end_node.element_id,
                        edge_type=edge.type,
                        properties=dict(edge),
                        transformation_type=edge.get("transformation_type"),
                        expression=edge.get("expression"),
                        confidence_score=edge.get("confidence_score"),
                    ))
            
            return LineageGraph(
                nodes=nodes,
                edges=edges,
                depth=depth,
                total_nodes=len(nodes),
                total_edges=len(edges),
            )
    
    async def get_field_lineage(
        self,
        field_id: str,
    ) -> LineagePath:
        """
        获取字段的最小血缘链路
        
        Args:
            field_id: 字段 ID
        
        Returns:
            LineagePath: 血缘路径
        """
        async with self.driver.session() as session:
            # 执行最短路径查询
            query = """
            MATCH path = shortestPath(
                (f:Field {id: $field_id})-[:LINEAGE_TO*]->(source:Field)
            )
            RETURN path, nodes(path) as nodes, relationships(path) as edges
            """
            
            result = await session.run(query, field_id=field_id)
            record = await result.single()
            
            if not record:
                return LineagePath(nodes=[], edges=[], path_length=0)
            
            # 解析节点
            nodes = []
            for node in record["nodes"]:
                nodes.append(LineageNode(
                    id=node.element_id,
                    name=node.get("name", ""),
                    type=node.labels[0] if node.labels else "Unknown",
                    properties=dict(node),
                ))
            
            # 解析边
            edges = []
            for edge in record["edges"]:
                edges.append(LineageEdge(
                    source_id=edge.start_node.element_id,
                    target_id=edge.end_node.element_id,
                    edge_type=edge.type,
                    properties=dict(edge),
                    transformation_type=edge.get("transformation_type"),
                    expression=edge.get("expression"),
                    confidence_score=edge.get("confidence_score"),
                ))
            
            return LineagePath(
                nodes=nodes,
                edges=edges,
                path_length=len(edges),
            )
    
    async def get_impact_analysis(
        self,
        table_id: str,
        depth: int = 5,
    ) -> LineageGraph:
        """
        影响分析（下游血缘）
        
        Args:
            table_id: 表 ID
            depth: 影响深度（1-10）
        
        Returns:
            LineageGraph: 影响图
        """
        return await self.get_table_lineage(table_id, depth, direction="downstream")
    
    async def get_job_lineage(
        self,
        job_id: str,
    ) -> LineageGraph:
        """
        获取作业的血缘关系
        
        Args:
            job_id: 作业 ID
        
        Returns:
            LineageGraph: 作业血缘图
        """
        async with self.driver.session() as session:
            # 执行查询
            query = """
            MATCH (j:Job {id: $job_id})
            OPTIONAL MATCH (j)-[:READS]->(source:Table)
            OPTIONAL MATCH (j)-[:WRITES]->(target:Table)
            RETURN j, source, target
            """
            
            result = await session.run(query, job_id=job_id)
            records = await result.list()
            
            # 解析结果
            nodes = []
            edges = []
            
            for record in records:
                # 解析作业节点
                job = record["j"]
                nodes.append(LineageNode(
                    id=job.element_id,
                    name=job.get("name", ""),
                    type="Job",
                    properties=dict(job),
                ))
                
                # 解析源表节点和边
                if record["source"]:
                    source = record["source"]
                    nodes.append(LineageNode(
                        id=source.element_id,
                        name=source.get("name", ""),
                        type="Table",
                        properties=dict(source),
                    ))
                    edges.append(LineageEdge(
                        source_id=job.element_id,
                        target_id=source.element_id,
                        edge_type="READS",
                    ))
                
                # 解析目标表节点和边
                if record["target"]:
                    target = record["target"]
                    nodes.append(LineageNode(
                        id=target.element_id,
                        name=target.get("name", ""),
                        type="Table",
                        properties=dict(target),
                    ))
                    edges.append(LineageEdge(
                        source_id=job.element_id,
                        target_id=target.element_id,
                        edge_type="WRITES",
                    ))
            
            return LineageGraph(
                nodes=nodes,
                edges=edges,
                total_nodes=len(nodes),
                total_edges=len(edges),
            )
    
    async def search_tables(
        self,
        name: Optional[str] = None,
        exact_name: Optional[str] = None,
        data_source_id: Optional[str] = None,
        limit: int = 20,
        offset: int = 0,
    ) -> List[LineageNode]:
        """
        搜索表
        
        Args:
            name: 表名（模糊查询）
            exact_name: 表名（精确查询）
            data_source_id: 数据源 ID
            limit: 返回数量限制
            offset: 偏移量
        
        Returns:
            List[LineageNode]: 表节点列表
        """
        async with self.driver.session() as session:
            # 构建查询条件
            conditions = []
            params = {}
            
            if exact_name:
                conditions.append("t.name = $exact_name")
                params["exact_name"] = exact_name
            elif name:
                conditions.append("t.name CONTAINS $name")
                params["name"] = name
            
            if data_source_id:
                conditions.append("t.data_source_id = $data_source_id")
                params["data_source_id"] = data_source_id
            
            # 构建查询语句
            where_clause = " AND " + " AND ".join(conditions) if conditions else ""
            
            query = f"""
            MATCH (t:Table)
            {where_clause}
            RETURN t
            ORDER BY t.name
            SKIP $offset
            LIMIT $limit
            """
            
            params["offset"] = offset
            params["limit"] = limit
            
            result = await session.run(query, **params)
            records = await result.list()
            
            # 解析结果
            nodes = []
            for record in records:
                table = record["t"]
                nodes.append(LineageNode(
                    id=table.element_id,
                    name=table.get("name", ""),
                    type="Table",
                    properties=dict(table),
                ))
            
            return nodes
    
    async def create_lineage_edge(
        self,
        source_id: str,
        target_id: str,
        edge_type: str,
        properties: Dict[str, Any],
    ) -> bool:
        """
        创建血缘边
        
        Args:
            source_id: 源节点 ID
            target_id: 目标节点 ID
            edge_type: 边类型
            properties: 边属性
        
        Returns:
            bool: 是否成功
        """
        async with self.driver.session() as session:
            # 构建属性字符串
            props_str = ", ".join([f"{k}: ${k}" for k in properties.keys()])
            
            # 执行创建
            query = f"""
            MATCH (source {{id: $source_id}})
            MATCH (target {{id: $target_id}})
            CREATE (source)-[r:{edge_type} {{{props_str}}}]->(target)
            RETURN r
            """
            
            params = {
                "source_id": source_id,
                "target_id": target_id,
                **properties,
            }
            
            result = await session.run(query, **params)
            record = await result.single()
            
            return record is not None
    
    async def update_lineage_edge(
        self,
        source_id: str,
        target_id: str,
        edge_type: str,
        properties: Dict[str, Any],
    ) -> bool:
        """
        更新血缘边
        
        Args:
            source_id: 源节点 ID
            target_id: 目标节点 ID
            edge_type: 边类型
            properties: 边属性
        
        Returns:
            bool: 是否成功
        """
        async with self.driver.session() as session:
            # 构建属性字符串
            props_str = ", ".join([f"r.{k} = ${k}" for k in properties.keys()])
            
            # 执行更新
            query = f"""
            MATCH (source {{id: $source_id}})-[r:{edge_type}]->(target {{id: $target_id}})
            SET {props_str}
            RETURN r
            """
            
            params = {
                "source_id": source_id,
                "target_id": target_id,
                **properties,
            }
            
            result = await session.run(query, **params)
            record = await result.single()
            
            return record is not None
    
    async def delete_lineage_edge(
        self,
        source_id: str,
        target_id: str,
        edge_type: str,
    ) -> bool:
        """
        删除血缘边
        
        Args:
            source_id: 源节点 ID
            target_id: 目标节点 ID
            edge_type: 边类型
        
        Returns:
            bool: 是否成功
        """
        async with self.driver.session() as session:
            # 执行删除
            query = f"""
            MATCH (source {{id: $source_id}})-[r:{edge_type}]->(target {{id: $target_id}})
            DELETE r
            """
            
            params = {
                "source_id": source_id,
                "target_id": target_id,
            }
            
            await session.run(query, **params)
            
            return True