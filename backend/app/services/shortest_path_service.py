"""
字段级最小血缘链路服务
实现 Dijkstra 最短路径算法和字段血缘提取
"""
import heapq
from collections import defaultdict
from dataclasses import dataclass, field
from datetime import datetime
from typing import Any, Dict, List, Optional, Set, Tuple

from neo4j import GraphDatabase

from app.core.config import settings


@dataclass
class FieldNode:
    """字段节点"""
    id: str
    name: str
    table_name: str
    full_name: str
    data_type: Optional[str] = None
    expression: Optional[str] = None
    is_source: bool = False
    properties: Dict[str, Any] = field(default_factory=dict)


@dataclass
class FieldEdge:
    """字段血缘边"""
    source_id: str
    target_id: str
    transformation_type: str
    expression: Optional[str] = None
    confidence_score: float = 1.0
    sql_statement: Optional[str] = None
    job_id: Optional[str] = None
    properties: Dict[str, Any] = field(default_factory=dict)


@dataclass
class ShortestPathResult:
    """最短路径结果"""
    nodes: List[FieldNode]
    edges: List[FieldEdge]
    path_length: int
    total_weight: float
    source_nodes: List[FieldNode]
    multi_source_paths: Dict[str, List[FieldNode]] = field(default_factory=dict)


@dataclass
class ExpressionDetail:
    """表达式详情"""
    raw_expression: str
    parsed_expression: str
    transformation_type: str
    source_fields: List[str]
    aggregation_type: Optional[str] = None
    join_condition: Optional[str] = None
    filter_condition: Optional[str] = None
    description: Optional[str] = None


class ShortestPathService:
    """
    字段级最小血缘链路服务
    使用 Dijkstra 算法计算最短路径
    """

    def __init__(self):
        self.driver = GraphDatabase.driver(
            settings.NEO4J_URI,
            auth=(settings.NEO4J_USER, settings.NEO4J_PASSWORD),
        )

    def close(self):
        self.driver.close()

    def get_field_shortest_path(
        self,
        target_field_id: str,
        max_depth: int = 10,
        include_expression: bool = True,
    ) -> ShortestPathResult:
        """
        获取字段的最小血缘链路
        
        Args:
            target_field_id: 目标字段 ID
            max_depth: 最大搜索深度
            include_expression: 是否包含表达式解析
        
        Returns:
            ShortestPathResult: 最短路径结果
        """
        with self.driver.session() as session:
            graph_data = self._fetch_field_graph(session, target_field_id, max_depth)
            
            if not graph_data["nodes"]:
                return ShortestPathResult(
                    nodes=[], edges=[], path_length=0, total_weight=0.0, source_nodes=[]
                )

            nodes_map = self._build_nodes_map(graph_data["nodes"])
            edges_list = self._build_edges_list(graph_data["edges"])
            
            source_nodes = self._find_source_nodes(nodes_map, edges_list)
            
            if len(source_nodes) == 1:
                result = self._dijkstra_single_source(
                    target_field_id, source_nodes[0].id, nodes_map, edges_list
                )
            else:
                result = self._dijkstra_multi_source(
                    target_field_id, source_nodes, nodes_map, edges_list
                )

            if include_expression:
                self._enrich_expression_details(result, session)

            return result

    def _fetch_field_graph(
        self,
        session,
        target_field_id: str,
        max_depth: int,
    ) -> Dict[str, Any]:
        """
        从 Neo4j 获取字段血缘图数据
        """
        query = """
        MATCH (target:Field {id: $target_field_id})
        MATCH path = (target)-[:LINEAGE_TO*1..$max_depth]->(source:Field)
        WHERE NOT (source)-[:LINEAGE_TO]->()
        WITH nodes(path) as path_nodes, relationships(path) as path_edges
        UNWIND path_nodes as node
        WITH distinct node, path_edges
        UNWIND path_edges as edge
        WITH distinct node, edge
        RETURN 
            collect(distinct {
                id: node.id,
                name: node.name,
                table_name: node.table_name,
                full_name: node.full_name,
                data_type: node.data_type,
                expression: node.expression,
                is_source: node.is_source,
                properties: node
            }) as nodes,
            collect(distinct {
                source_id: startNode(edge).id,
                target_id: endNode(edge).id,
                transformation_type: edge.transformation_type,
                expression: edge.expression,
                confidence_score: edge.confidence_score,
                sql_statement: edge.sql_statement,
                job_id: edge.job_id,
                properties: edge
            }) as edges
        """
        result = session.run(query, target_field_id=target_field_id, max_depth=max_depth)
        record = result.single()
        
        if not record:
            return {"nodes": [], "edges": []}
        
        return {"nodes": record["nodes"], "edges": record["edges"]}

    def _build_nodes_map(self, nodes_data: List[Dict]) -> Dict[str, FieldNode]:
        """构建节点映射"""
        nodes_map = {}
        for node_data in nodes_data:
            node = FieldNode(
                id=node_data["id"],
                name=node_data.get("name", ""),
                table_name=node_data.get("table_name", ""),
                full_name=node_data.get("full_name", ""),
                data_type=node_data.get("data_type"),
                expression=node_data.get("expression"),
                is_source=node_data.get("is_source", False),
                properties=node_data.get("properties", {}),
            )
            nodes_map[node.id] = node
        return nodes_map

    def _build_edges_list(self, edges_data: List[Dict]) -> List[FieldEdge]:
        """构建边列表"""
        edges = []
        for edge_data in edges_data:
            edge = FieldEdge(
                source_id=edge_data["source_id"],
                target_id=edge_data["target_id"],
                transformation_type=edge_data.get("transformation_type", "direct_map"),
                expression=edge_data.get("expression"),
                confidence_score=edge_data.get("confidence_score", 1.0),
                sql_statement=edge_data.get("sql_statement"),
                job_id=edge_data.get("job_id"),
                properties=edge_data.get("properties", {}),
            )
            edges.append(edge)
        return edges

    def _find_source_nodes(
        self,
        nodes_map: Dict[str, FieldNode],
        edges: List[FieldEdge],
    ) -> List[FieldNode]:
        """
        找到所有源节点（没有上游的字段）
        """
        target_ids = {edge.target_id for edge in edges}
        source_ids = {edge.source_id for edge in edges}
        
        pure_source_ids = source_ids - target_ids
        
        source_nodes = []
        for node_id in pure_source_ids:
            if node_id in nodes_map:
                source_nodes.append(nodes_map[node_id])
        
        for node_id, node in nodes_map.items():
            if node.is_source and node_id not in pure_source_ids:
                source_nodes.append(node)
        
        return source_nodes

    def _dijkstra_single_source(
        self,
        target_id: str,
        source_id: str,
        nodes_map: Dict[str, FieldNode],
        edges: List[FieldEdge],
    ) -> ShortestPathResult:
        """
        单源 Dijkstra 最短路径算法
        """
        graph = defaultdict(list)
        edge_map = {}
        
        for edge in edges:
            weight = 1.0 - edge.confidence_score
            graph[edge.target_id].append((edge.source_id, weight, edge))
            edge_map[(edge.target_id, edge.source_id)] = edge
        
        distances = {target_id: 0.0}
        predecessors = {}
        visited = set()
        pq = [(0.0, target_id)]
        
        while pq:
            current_dist, current_node = heapq.heappop(pq)
            
            if current_node in visited:
                continue
            visited.add(current_node)
            
            if current_node == source_id:
                break
            
            for neighbor, weight, edge in graph[current_node]:
                new_dist = current_dist + weight
                
                if neighbor not in distances or new_dist < distances[neighbor]:
                    distances[neighbor] = new_dist
                    predecessors[neighbor] = (current_node, edge)
                    heapq.heappush(pq, (new_dist, neighbor))
        
        path_nodes = []
        path_edges = []
        current = source_id
        
        while current != target_id:
            if current in nodes_map:
                path_nodes.append(nodes_map[current])
            
            if current in predecessors:
                prev, edge = predecessors[current]
                path_edges.append(edge)
                current = prev
            else:
                break
        
        if target_id in nodes_map:
            path_nodes.append(nodes_map[target_id])
        
        path_nodes.reverse()
        path_edges.reverse()
        
        source_nodes = [nodes_map[source_id]] if source_id in nodes_map else []
        
        return ShortestPathResult(
            nodes=path_nodes,
            edges=path_edges,
            path_length=len(path_edges),
            total_weight=distances.get(source_id, 0.0),
            source_nodes=source_nodes,
        )

    def _dijkstra_multi_source(
        self,
        target_id: str,
        source_nodes: List[FieldNode],
        nodes_map: Dict[str, FieldNode],
        edges: List[FieldEdge],
    ) -> ShortestPathResult:
        """
        多源汇聚场景的 Dijkstra 算法
        """
        graph = defaultdict(list)
        edge_map = {}
        
        for edge in edges:
            weight = 1.0 - edge.confidence_score
            graph[edge.target_id].append((edge.source_id, weight, edge))
            edge_map[(edge.target_id, edge.source_id)] = edge
        
        distances = {target_id: 0.0}
        predecessors = {}
        visited = set()
        pq = [(0.0, target_id)]
        
        source_ids = {node.id for node in source_nodes}
        reached_sources = set()
        
        while pq:
            current_dist, current_node = heapq.heappop(pq)
            
            if current_node in visited:
                continue
            visited.add(current_node)
            
            if current_node in source_ids:
                reached_sources.add(current_node)
                if len(reached_sources) == len(source_ids):
                    break
            
            for neighbor, weight, edge in graph[current_node]:
                new_dist = current_dist + weight
                
                if neighbor not in distances or new_dist < distances[neighbor]:
                    distances[neighbor] = new_dist
                    predecessors[neighbor] = (current_node, edge)
                    heapq.heappush(pq, (new_dist, neighbor))
        
        multi_paths = {}
        all_path_nodes = []
        all_path_edges = []
        
        for source_node in source_nodes:
            if source_node.id not in reached_sources:
                continue
            
            path_nodes = []
            path_edges = []
            current = source_node.id
            
            while current != target_id:
                if current in nodes_map and nodes_map[current] not in path_nodes:
                    path_nodes.append(nodes_map[current])
                
                if current in predecessors:
                    prev, edge = predecessors[current]
                    if edge not in path_edges:
                        path_edges.append(edge)
                    current = prev
                else:
                    break
            
            if target_id in nodes_map:
                path_nodes.append(nodes_map[target_id])
            
            path_nodes.reverse()
            path_edges.reverse()
            
            multi_paths[source_node.id] = path_nodes
            
            for node in path_nodes:
                if node not in all_path_nodes:
                    all_path_nodes.append(node)
            
            for edge in path_edges:
                if edge not in all_path_edges:
                    all_path_edges.append(edge)
        
        return ShortestPathResult(
            nodes=all_path_nodes,
            edges=all_path_edges,
            path_length=len(all_path_edges),
            total_weight=sum(distances.get(s.id, 0.0) for s in source_nodes if s.id in distances),
            source_nodes=source_nodes,
            multi_source_paths=multi_paths,
        )

    def _enrich_expression_details(
        self,
        result: ShortestPathResult,
        session,
    ) -> None:
        """
        为边添加表达式详情
        """
        for edge in result.edges:
            if edge.expression:
                detail = self._parse_expression(edge.expression, edge.transformation_type)
                edge.properties["expression_detail"] = detail

    def _parse_expression(
        self,
        expression: str,
        transformation_type: str,
    ) -> ExpressionDetail:
        """
        解析表达式
        """
        source_fields = self._extract_source_fields(expression)
        
        aggregation_type = None
        if transformation_type in ("aggregation", "group_by"):
            aggregation_type = self._detect_aggregation_type(expression)
        
        join_condition = None
        if transformation_type == "join":
            join_condition = self._extract_join_condition(expression)
        
        filter_condition = None
        if transformation_type == "filter":
            filter_condition = self._extract_filter_condition(expression)
        
        description = self._generate_description(
            expression, transformation_type, aggregation_type, source_fields
        )
        
        return ExpressionDetail(
            raw_expression=expression,
            parsed_expression=self._format_expression(expression),
            transformation_type=transformation_type,
            source_fields=source_fields,
            aggregation_type=aggregation_type,
            join_condition=join_condition,
            filter_condition=filter_condition,
            description=description,
        )

    def _extract_source_fields(self, expression: str) -> List[str]:
        """从表达式中提取源字段"""
        import re
        
        patterns = [
            r'\b([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)\b',
        ]
        
        keywords = {
            'SELECT', 'FROM', 'WHERE', 'AND', 'OR', 'NOT', 'IN', 'IS', 'NULL',
            'AS', 'ON', 'JOIN', 'LEFT', 'RIGHT', 'INNER', 'OUTER', 'FULL',
            'GROUP', 'BY', 'ORDER', 'HAVING', 'LIMIT', 'OFFSET',
            'SUM', 'AVG', 'COUNT', 'MAX', 'MIN', 'COALESCE', 'CASE', 'WHEN', 'THEN', 'ELSE', 'END',
            'CAST', 'CONVERT', 'SUBSTR', 'SUBSTRING', 'TRIM', 'UPPER', 'LOWER',
            'DATE', 'TIME', 'TIMESTAMP', 'YEAR', 'MONTH', 'DAY',
        }
        
        fields = []
        for pattern in patterns:
            matches = re.findall(pattern, expression)
            for match in matches:
                upper_match = match.upper()
                if upper_match not in keywords and not match.isdigit():
                    fields.append(match)
        
        return list(set(fields))

    def _detect_aggregation_type(self, expression: str) -> Optional[str]:
        """检测聚合类型"""
        import re
        
        agg_funcs = ['SUM', 'AVG', 'COUNT', 'MAX', 'MIN']
        for func in agg_funcs:
            if re.search(rf'\b{func}\s*\(', expression, re.IGNORECASE):
                return func.lower()
        return None

    def _extract_join_condition(self, expression: str) -> Optional[str]:
        """提取 JOIN 条件"""
        import re
        
        match = re.search(r'\bON\s+(.+?)(?:\s+(?:WHERE|GROUP|ORDER|HAVING)|$)', expression, re.IGNORECASE)
        if match:
            return match.group(1).strip()
        return None

    def _extract_filter_condition(self, expression: str) -> Optional[str]:
        """提取过滤条件"""
        import re
        
        match = re.search(r'\bWHERE\s+(.+?)(?:\s+GROUP|\s+ORDER|\s+HAVING|\s+LIMIT|$)', expression, re.IGNORECASE)
        if match:
            return match.group(1).strip()
        return None

    def _format_expression(self, expression: str) -> str:
        """格式化表达式"""
        formatted = expression.strip()
        if len(formatted) > 100:
            formatted = formatted[:100] + "..."
        return formatted

    def _generate_description(
        self,
        expression: str,
        transformation_type: str,
        aggregation_type: Optional[str],
        source_fields: List[str],
    ) -> str:
        """生成表达式描述"""
        descriptions = {
            "direct_map": "直接映射",
            "expression": "表达式计算",
            "aggregation": f"{aggregation_type or '聚合'}计算",
            "join": "多表关联",
            "filter": "条件过滤",
            "case_when": "条件判断",
            "function": "函数转换",
        }
        
        base_desc = descriptions.get(transformation_type, "转换")
        
        if source_fields:
            if len(source_fields) <= 3:
                fields_str = ", ".join(source_fields)
                return f"{base_desc}: {fields_str}"
            else:
                return f"{base_desc}: {len(source_fields)} 个源字段"
        
        return base_desc

    def get_field_details(self, field_id: str) -> Optional[Dict[str, Any]]:
        """获取字段详细信息"""
        with self.driver.session() as session:
            query = """
            MATCH (f:Field {id: $field_id})
            OPTIONAL MATCH (t:Table)-[:CONTAINS]->(f)
            OPTIONAL MATCH (ds:DataSource)-[:HAS_TABLE]->(t)
            RETURN f, t, ds
            """
            result = session.run(query, field_id=field_id)
            record = result.single()
            
            if not record:
                return None
            
            field = record["f"]
            table = record["t"]
            data_source = record["ds"]
            
            return {
                "id": field.get("id"),
                "name": field.get("name"),
                "full_name": field.get("full_name"),
                "table_name": table.get("name") if table else None,
                "data_source": data_source.get("name") if data_source else None,
                "data_type": field.get("data_type"),
                "expression": field.get("expression"),
                "is_source": field.get("is_source"),
                "created_at": field.get("created_at"),
                "updated_at": field.get("updated_at"),
            }

    def search_fields(
        self,
        table_name: Optional[str] = None,
        field_name: Optional[str] = None,
        data_source_id: Optional[str] = None,
        limit: int = 50,
    ) -> List[Dict[str, Any]]:
        """搜索字段"""
        with self.driver.session() as session:
            conditions = []
            params = {}
            
            if table_name:
                conditions.append("t.name CONTAINS $table_name")
                params["table_name"] = table_name
            
            if field_name:
                conditions.append("f.name CONTAINS $field_name")
                params["field_name"] = field_name
            
            if data_source_id:
                conditions.append("t.data_source_id = $data_source_id")
                params["data_source_id"] = data_source_id
            
            where_clause = " AND " + " AND ".join(conditions) if conditions else ""
            
            query = f"""
            MATCH (t:Table)-[:CONTAINS]->(f:Field)
            {where_clause}
            RETURN f.id as id, f.name as name, f.full_name as full_name,
                   t.name as table_name, f.data_type as data_type
            ORDER BY t.name, f.name
            LIMIT $limit
            """
            
            params["limit"] = limit
            
            result = session.run(query, **params)
            records = result.list()
            
            return [dict(record) for record in records]

    def export_lineage(
        self,
        result: ShortestPathResult,
        format_type: str = "json",
    ) -> str:
        """导出血缘链路"""
        if format_type == "json":
            import json
            
            export_data = {
                "nodes": [
                    {
                        "id": node.id,
                        "name": node.name,
                        "table_name": node.table_name,
                        "full_name": node.full_name,
                        "data_type": node.data_type,
                        "is_source": node.is_source,
                    }
                    for node in result.nodes
                ],
                "edges": [
                    {
                        "source_id": edge.source_id,
                        "target_id": edge.target_id,
                        "transformation_type": edge.transformation_type,
                        "expression": edge.expression,
                        "confidence_score": edge.confidence_score,
                        "description": edge.properties.get("expression_detail", {}).get("description"),
                    }
                    for edge in result.edges
                ],
                "path_length": result.path_length,
                "total_weight": result.total_weight,
                "source_count": len(result.source_nodes),
                "exported_at": datetime.utcnow().isoformat(),
            }
            
            return json.dumps(export_data, indent=2, ensure_ascii=False)
        
        elif format_type == "csv":
            lines = ["节点ID,节点名称,表名,是否源字段"]
            for node in result.nodes:
                lines.append(f"{node.id},{node.name},{node.table_name},{node.is_source}")
            
            lines.append("")
            lines.append("源字段ID,目标字段ID,转换类型,表达式,置信度")
            for edge in result.edges:
                expr = edge.expression or ""
                lines.append(f"{edge.source_id},{edge.target_id},{edge.transformation_type},{expr},{edge.confidence_score}")
            
            return "\n".join(lines)
        
        elif format_type == "markdown":
            lines = ["# 字段血缘链路报告"]
            lines.append("")
            lines.append(f"**路径长度**: {result.path_length}")
            lines.append(f"**源字段数量**: {len(result.source_nodes)}")
            lines.append("")
            lines.append("## 节点列表")
            lines.append("")
            for node in result.nodes:
                lines.append(f"- **{node.name}** ({node.table_name})")
                if node.is_source:
                    lines.append("  - 源字段")
            
            lines.append("")
            lines.append("## 转换路径")
            lines.append("")
            for edge in result.edges:
                detail = edge.properties.get("expression_detail", {})
                lines.append(f"- {edge.transformation_type}: {detail.get('description', edge.expression or 'N/A')}")
            
            return "\n".join(lines)
        
        return ""