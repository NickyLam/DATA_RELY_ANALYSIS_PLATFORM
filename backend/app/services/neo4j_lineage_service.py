"""
Neo4j 血缘查询服务
提供血缘图谱的查询、分析和可视化功能
"""

import logging
from typing import Dict, List, Optional, Set

from neo4j import AsyncGraphDatabase

from app.core.config import settings
from app.schemas.lineage import LineageEdge, LineageGraph, LineageNode, LineagePath

logger = logging.getLogger(__name__)


class Neo4jLineageService:
    """
    Neo4j 血缘查询服务
    """

    def __init__(self):
        self.driver = AsyncGraphDatabase.driver(
            settings.NEO4J_URI,
            auth=(settings.NEO4J_USER, settings.NEO4J_PASSWORD),
        )

    async def close(self):
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
            nodes_dict: Dict[str, LineageNode] = {}
            edges_dict: Dict[str, LineageEdge] = {}

            if direction == "upstream":
                await self._traverse_upstream(
                    session, table_id, depth, nodes_dict, edges_dict, set()
                )
            elif direction == "downstream":
                await self._traverse_downstream(
                    session, table_id, depth, nodes_dict, edges_dict, set()
                )
            else:
                await self._traverse_upstream(
                    session, table_id, depth, nodes_dict, edges_dict, set()
                )
                await self._traverse_downstream(
                    session, table_id, depth, nodes_dict, edges_dict, set()
                )

            nodes = list(nodes_dict.values())
            edges = list(edges_dict.values())

            return LineageGraph(
                nodes=nodes,
                edges=edges,
                depth=depth,
                total_nodes=len(nodes),
                total_edges=len(edges),
            )

    async def _traverse_upstream(
        self,
        session,
        table_id: str,
        depth: int,
        nodes_dict: Dict[str, LineageNode],
        edges_dict: Dict[str, LineageEdge],
        visited: Set[str],
        current_depth: int = 0,
    ):
        if current_depth >= depth or table_id in visited:
            return

        visited.add(table_id)

        query = """
        MATCH (target:Table {id: $table_id})
        OPTIONAL MATCH (source:Table)-[r:LINEAGE_TO]->(target)
        RETURN target, collect(source) as sources, collect(r) as relationships
        """

        result = await session.run(query, table_id=table_id)
        record = await result.single()

        if not record:
            return

        target_node = record["target"]
        if target_node:
            target_id = target_node.get("id") or target_node.element_id
            if target_id not in nodes_dict:
                nodes_dict[target_id] = self._create_node(target_node)

        sources = record["sources"] or []
        relationships = record["relationships"] or []

        for source, rel in zip(sources, relationships):
            if source is None:
                continue

            source_id = source.get("id") or source.element_id

            if source_id not in nodes_dict:
                nodes_dict[source_id] = self._create_node(source)

            edge_key = f"{source_id}->{target_id}"
            if edge_key not in edges_dict:
                edges_dict[edge_key] = self._create_edge(source_id, target_id, rel)

            await self._traverse_upstream(
                session, source_id, depth, nodes_dict, edges_dict, visited, current_depth + 1
            )

    async def _traverse_downstream(
        self,
        session,
        table_id: str,
        depth: int,
        nodes_dict: Dict[str, LineageNode],
        edges_dict: Dict[str, LineageEdge],
        visited: Set[str],
        current_depth: int = 0,
    ):
        if current_depth >= depth or table_id in visited:
            return

        visited.add(table_id)

        query = """
        MATCH (source:Table {id: $table_id})
        OPTIONAL MATCH (source)-[r:LINEAGE_TO]->(target:Table)
        RETURN source, collect(target) as targets, collect(r) as relationships
        """

        result = await session.run(query, table_id=table_id)
        record = await result.single()

        if not record:
            return

        source_node = record["source"]
        if source_node:
            source_id = source_node.get("id") or source_node.element_id
            if source_id not in nodes_dict:
                nodes_dict[source_id] = self._create_node(source_node)

        targets = record["targets"] or []
        relationships = record["relationships"] or []

        for target, rel in zip(targets, relationships):
            if target is None:
                continue

            target_id = target.get("id") or target.element_id

            if target_id not in nodes_dict:
                nodes_dict[target_id] = self._create_node(target)

            edge_key = f"{source_id}->{target_id}"
            if edge_key not in edges_dict:
                edges_dict[edge_key] = self._create_edge(source_id, target_id, rel)

            await self._traverse_downstream(
                session, target_id, depth, nodes_dict, edges_dict, visited, current_depth + 1
            )

    def _create_node(self, node_data) -> LineageNode:
        props = dict(node_data) if node_data else {}
        node_id = props.get("id") or node_data.element_id
        node_type = "Table"
        labels = node_data.labels if hasattr(node_data, "labels") else []
        if "View" in labels:
            node_type = "View"
        elif "StoredProcedure" in labels:
            node_type = "StoredProcedure"
        elif "Job" in labels:
            node_type = "Job"

        return LineageNode(
            id=node_id,
            name=props.get("name", ""),
            type=node_type,
            properties=props,
        )

    def _create_edge(self, source_id: str, target_id: str, rel_data) -> LineageEdge:
        props = dict(rel_data) if rel_data else {}
        return LineageEdge(
            source_id=source_id,
            target_id=target_id,
            edge_type=rel_data.type if rel_data else "LINEAGE_TO",
            properties=props,
            transformation_type=props.get("transformation_type"),
            expression=props.get("expression"),
            confidence_score=props.get("confidence_score"),
        )

    async def get_table_lineage_with_expand(
        self,
        table_id: str,
        depth: int = 5,
        direction: str = "upstream",
        expand_levels: Optional[List[int]] = None,
    ) -> LineageGraph:
        """
        获取表的血缘图，支持层级展开

        Args:
            table_id: 表 ID
            depth: 血缘深度（1-10）
            direction: 方向（upstream, downstream, both）
            expand_levels: 要展开的层级列表，None 表示全部展开

        Returns:
            LineageGraph: 血缘图
        """
        async with self.driver.session() as session:
            nodes_dict: Dict[str, LineageNode] = {}
            edges_dict: Dict[str, LineageEdge] = {}
            level_nodes: Dict[int, Set[str]] = {}

            await self._traverse_with_levels(
                session,
                table_id,
                depth,
                direction,
                nodes_dict,
                edges_dict,
                level_nodes,
            )

            nodes = list(nodes_dict.values())
            edges = list(edges_dict.values())

            for node in nodes:
                node_level = self._find_node_level(node.id, level_nodes)
                if node.properties is None:
                    node.properties = {}
                node.properties["level"] = node_level

            return LineageGraph(
                nodes=nodes,
                edges=edges,
                depth=depth,
                total_nodes=len(nodes),
                total_edges=len(edges),
            )

    async def _traverse_with_levels(
        self,
        session,
        table_id: str,
        depth: int,
        direction: str,
        nodes_dict: Dict[str, LineageNode],
        edges_dict: Dict[str, LineageEdge],
        level_nodes: Dict[int, Set[str]],
        current_level: int = 0,
        visited: Optional[Set[str]] = None,
    ):
        if visited is None:
            visited = set()

        if current_level > depth or table_id in visited:
            return

        visited.add(table_id)

        if current_level not in level_nodes:
            level_nodes[current_level] = set()
        level_nodes[current_level].add(table_id)

        query = """
        MATCH (t:Table {id: $table_id})
        RETURN t
        """
        result = await session.run(query, table_id=table_id)
        record = await result.single()

        if record and record["t"]:
            node_data = record["t"]
            node_id = node_data.get("id") or node_data.element_id
            if node_id not in nodes_dict:
                nodes_dict[node_id] = self._create_node(node_data)

        if direction in ("upstream", "both"):
            upstream_query = """
            MATCH (source:Table)-[r:LINEAGE_TO]->(target:Table {id: $table_id})
            RETURN source, r
            """
            upstream_result = await session.run(upstream_query, table_id=table_id)
            upstream_records = await upstream_result.list()

            for rec in upstream_records:
                source = rec["source"]
                rel = rec["r"]
                source_id = source.get("id") or source.element_id

                if source_id not in nodes_dict:
                    nodes_dict[source_id] = self._create_node(source)

                edge_key = f"{source_id}->{table_id}"
                if edge_key not in edges_dict:
                    edges_dict[edge_key] = self._create_edge(source_id, table_id, rel)

                await self._traverse_with_levels(
                    session,
                    source_id,
                    depth,
                    direction,
                    nodes_dict,
                    edges_dict,
                    level_nodes,
                    current_level + 1,
                    visited.copy(),
                )

        if direction in ("downstream", "both"):
            downstream_query = """
            MATCH (source:Table {id: $table_id})-[r:LINEAGE_TO]->(target:Table)
            RETURN target, r
            """
            downstream_result = await session.run(downstream_query, table_id=table_id)
            downstream_records = await downstream_result.list()

            for rec in downstream_records:
                target = rec["target"]
                rel = rec["r"]
                target_id = target.get("id") or target.element_id

                if target_id not in nodes_dict:
                    nodes_dict[target_id] = self._create_node(target)

                edge_key = f"{table_id}->{target_id}"
                if edge_key not in edges_dict:
                    edges_dict[edge_key] = self._create_edge(table_id, target_id, rel)

                await self._traverse_with_levels(
                    session,
                    target_id,
                    depth,
                    direction,
                    nodes_dict,
                    edges_dict,
                    level_nodes,
                    current_level + 1,
                    visited.copy(),
                )

    def _find_node_level(self, node_id: str, level_nodes: Dict[int, Set[str]]) -> int:
        for level, nodes in level_nodes.items():
            if node_id in nodes:
                return level
        return 0

    async def get_field_lineage(self, field_id: str) -> LineagePath:
        """
        获取字段的最小血缘链路

        Args:
            field_id: 字段 ID

        Returns:
            LineagePath: 血缘路径
        """
        async with self.driver.session() as session:
            query = """
            MATCH path = shortestPath(
                (f:Field {id: $field_id})-[:LINEAGE_TO*]->(source:Field)
            )
            WHERE NOT (source)-[:LINEAGE_TO]->()
            RETURN path, nodes(path) as nodes, relationships(path) as edges
            """

            result = await session.run(query, field_id=field_id)
            record = await result.single()

            if not record:
                return LineagePath(nodes=[], edges=[], path_length=0)

            nodes = []
            for node in record["nodes"]:
                nodes.append(
                    LineageNode(
                        id=node.get("id") or node.element_id,
                        name=node.get("name", ""),
                        type=node.labels[0] if node.labels else "Unknown",
                        properties=dict(node),
                    )
                )

            edges = []
            for edge in record["edges"]:
                edges.append(
                    LineageEdge(
                        source_id=edge.start_node.element_id,
                        target_id=edge.end_node.element_id,
                        edge_type=edge.type,
                        properties=dict(edge),
                        transformation_type=edge.get("transformation_type"),
                        expression=edge.get("expression"),
                        confidence_score=edge.get("confidence_score"),
                    )
                )

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

    async def get_job_lineage(self, job_id: str) -> LineageGraph:
        """
        获取作业的血缘关系

        Args:
            job_id: 作业 ID

        Returns:
            LineageGraph: 作业血缘图
        """
        async with self.driver.session() as session:
            query = """
            MATCH (j:Job {id: $job_id})
            OPTIONAL MATCH (j)-[:READS]->(source:Table)
            OPTIONAL MATCH (j)-[:WRITES]->(target:Table)
            RETURN j, collect(DISTINCT source) as sources, collect(DISTINCT target) as targets
            """

            result = await session.run(query, job_id=job_id)
            record = await result.single()

            if not record:
                return LineageGraph(nodes=[], edges=[], total_nodes=0, total_edges=0)

            nodes = []
            edges = []

            job = record["j"]
            if job:
                job_id_actual = job.get("id") or job.element_id
                nodes.append(
                    LineageNode(
                        id=job_id_actual,
                        name=job.get("name", ""),
                        type="Job",
                        properties=dict(job),
                    )
                )

                sources = record["sources"] or []
                for source in sources:
                    if source:
                        source_id = source.get("id") or source.element_id
                        nodes.append(
                            LineageNode(
                                id=source_id,
                                name=source.get("name", ""),
                                type="Table",
                                properties=dict(source),
                            )
                        )
                        edges.append(
                            LineageEdge(
                                source_id=job_id_actual,
                                target_id=source_id,
                                edge_type="READS",
                            )
                        )

                targets = record["targets"] or []
                for target in targets:
                    if target:
                        target_id = target.get("id") or target.element_id
                        nodes.append(
                            LineageNode(
                                id=target_id,
                                name=target.get("name", ""),
                                type="Table",
                                properties=dict(target),
                            )
                        )
                        edges.append(
                            LineageEdge(
                                source_id=job_id_actual,
                                target_id=target_id,
                                edge_type="WRITES",
                            )
                        )

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

            where_clause = "WHERE " + " AND ".join(conditions) if conditions else ""

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

            nodes = []
            for record in records:
                table = record["t"]
                nodes.append(
                    LineageNode(
                        id=table.get("id") or table.element_id,
                        name=table.get("name", ""),
                        type="Table",
                        properties=dict(table),
                    )
                )

            return nodes

    async def get_table_details(self, table_id: str) -> Optional[LineageNode]:
        """
        获取表详情

        Args:
            table_id: 表 ID

        Returns:
            Optional[LineageNode]: 表节点详情
        """
        async with self.driver.session() as session:
            query = """
            MATCH (t:Table {id: $table_id})
            OPTIONAL MATCH (t)-[:HAS_FIELD]->(f:Field)
            RETURN t, collect(f) as fields
            """

            result = await session.run(query, table_id=table_id)
            record = await result.single()

            if not record or not record["t"]:
                return None

            table = record["t"]
            fields = record["fields"] or []

            props = dict(table)
            props["fields"] = [
                {
                    "id": f.get("id") or f.element_id,
                    "name": f.get("name", ""),
                    "type": f.get("type", ""),
                }
                for f in fields
                if f
            ]

            return LineageNode(
                id=table.get("id") or table.element_id,
                name=table.get("name", ""),
                type="Table",
                properties=props,
            )

    async def create_lineage_edge(
        self,
        source_id: str,
        target_id: str,
        edge_type: str,
        properties: Dict,
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
            props_str = ", ".join([f"{k}: ${k}" for k in properties.keys()])

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
        properties: Dict,
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
            props_str = ", ".join([f"r.{k} = ${k}" for k in properties.keys()])

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