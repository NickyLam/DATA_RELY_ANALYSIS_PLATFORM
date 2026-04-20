"""
血缘构建器
将解析结果构建为血缘图谱并写入 Neo4j
"""
import hashlib
from dataclasses import dataclass, field
from datetime import datetime
from typing import Optional, List, Dict, Any, Set, Tuple

from neo4j import GraphDatabase

from app.core.config import settings
from app.parsers.sql_parser import (
    ParsedSQL,
    SQLStatementType,
    TableReference,
    ColumnReference,
)
from app.parsers.oracle_dialect import OracleParsedSQL
from app.parsers.lineage_rules import (
    LineageRuleEngine,
    LineageExtractionResult,
    TableLineage,
    ColumnLineage,
    TransformationType,
)
from app.schemas.lineage import LineageNode, LineageEdge, LineageGraph


@dataclass
class LineageBuildContext:
    job_id: Optional[str] = None
    data_source_id: Optional[str] = None
    schema_name: Optional[str] = None
    database_name: Optional[str] = None
    parse_timestamp: Optional[datetime] = None
    sql_file_path: Optional[str] = None
    confidence_threshold: float = 0.5
    include_field_lineage: bool = True
    overwrite_existing: bool = False


@dataclass
class BuiltLineageGraph:
    nodes: List[Dict[str, Any]] = field(default_factory=list)
    edges: List[Dict[str, Any]] = field(default_factory=list)
    table_nodes: Dict[str, Dict[str, Any]] = field(default_factory=dict)
    field_nodes: Dict[str, Dict[str, Any]] = field(default_factory=dict)
    job_node: Optional[Dict[str, Any]] = None
    metadata: Dict[str, Any] = field(default_factory=dict)


class LineageBuilder:
    """
    血缘构建器
    负责将 SQL 解析结果转换为血缘图谱并写入 Neo4j
    """

    NODE_LABELS = {
        "table": "Table",
        "field": "Field",
        "job": "Job",
        "data_source": "DataSource",
    }

    EDGE_TYPES = {
        "table_lineage": "LINEAGE_TO",
        "field_lineage": "FIELD_LINEAGE_TO",
        "job_reads": "READS",
        "job_writes": "WRITES",
        "contains": "CONTAINS",
        "belongs_to": "BELONGS_TO",
    }

    def __init__(self, context: Optional[LineageBuildContext] = None):
        self.context = context or LineageBuildContext()
        self.rule_engine = LineageRuleEngine()
        self._node_cache: Dict[str, Dict[str, Any]] = {}
        self._edge_cache: Set[Tuple[str, str, str]] = set()

    def build_from_parsed_sql(
        self,
        parsed_sql: ParsedSQL,
        context: Optional[LineageBuildContext] = None,
    ) -> BuiltLineageGraph:
        if context:
            self.context = context

        extraction_result = self.rule_engine.extract_lineage(parsed_sql)

        graph = BuiltLineageGraph()

        self._build_table_nodes(parsed_sql, extraction_result, graph)
        if self.context.include_field_lineage:
            self._build_field_nodes(parsed_sql, extraction_result, graph)
        self._build_job_node(graph)
        self._build_table_lineage_edges(extraction_result, graph)
        if self.context.include_field_lineage:
            self._build_field_lineage_edges(extraction_result, graph)
        self._build_job_edges(graph)

        graph.metadata = {
            "statement_type": parsed_sql.statement_type.value,
            "source_tables_count": len(parsed_sql.source_tables),
            "target_tables_count": len(parsed_sql.target_tables),
            "table_lineages_count": len(extraction_result.table_lineages),
            "field_lineages_count": len(extraction_result.column_lineages),
            "errors": extraction_result.errors,
            "warnings": extraction_result.warnings,
            "parse_timestamp": self.context.parse_timestamp or datetime.utcnow(),
        }

        return graph

    def _generate_id(self, prefix: str, name: str, *args: str) -> str:
        components = [prefix, name] + list(args)
        key = ":".join(components)
        return hashlib.sha256(key.encode()).hexdigest()[:16]

    def _build_table_nodes(
        self,
        parsed_sql: ParsedSQL,
        extraction_result: LineageExtractionResult,
        graph: BuiltLineageGraph,
    ) -> None:
        all_tables: Dict[str, TableReference] = {}

        for table in parsed_sql.source_tables:
            key = table.full_name
            all_tables[key] = table

        for table in parsed_sql.target_tables:
            key = table.full_name
            all_tables[key] = table

        for lineage in extraction_result.table_lineages:
            key = lineage.source_table.full_name
            all_tables[key] = lineage.source_table
            key = lineage.target_table.full_name
            all_tables[key] = lineage.target_table

        for full_name, table in all_tables.items():
            node_id = self._generate_id(
                "table",
                full_name,
                self.context.data_source_id or "",
            )

            node = {
                "id": node_id,
                "labels": [self.NODE_LABELS["table"]],
                "properties": {
                    "name": table.name,
                    "full_name": full_name,
                    "schema": table.schema or self.context.schema_name,
                    "database": table.database or self.context.database_name,
                    "alias": table.alias,
                    "is_target": table.is_target,
                    "data_source_id": self.context.data_source_id,
                    "created_at": datetime.utcnow().isoformat(),
                    "updated_at": datetime.utcnow().isoformat(),
                },
            }

            graph.table_nodes[full_name] = node
            graph.nodes.append(node)

    def _build_field_nodes(
        self,
        parsed_sql: ParsedSQL,
        extraction_result: LineageExtractionResult,
        graph: BuiltLineageGraph,
    ) -> None:
        all_columns: Dict[str, Tuple[ColumnReference, Optional[TableReference]]] = {}

        for col in parsed_sql.source_columns:
            key = col.full_name
            table = self._resolve_column_table(col, parsed_sql)
            all_columns[key] = (col, table)

        for col in parsed_sql.target_columns:
            key = col.full_name
            table = parsed_sql.target_tables[0] if parsed_sql.target_tables else None
            all_columns[key] = (col, table)

        for lineage in extraction_result.column_lineages:
            key = lineage.source_column.full_name
            all_columns[key] = (lineage.source_column, lineage.source_table)
            key = lineage.target_column.full_name
            all_columns[key] = (lineage.target_column, lineage.target_table)

        for full_name, (column, table) in all_columns.items():
            table_full_name = table.full_name if table else "unknown"
            table_node = graph.table_nodes.get(table_full_name)

            node_id = self._generate_id(
                "field",
                full_name,
                table_full_name,
                self.context.data_source_id or "",
            )

            node = {
                "id": node_id,
                "labels": [self.NODE_LABELS["field"]],
                "properties": {
                    "name": column.name,
                    "full_name": full_name,
                    "table_alias": column.table_alias,
                    "expression": column.expression,
                    "is_source": column.is_source,
                    "is_target": column.is_target,
                    "table_id": table_node["id"] if table_node else None,
                    "table_name": table_full_name,
                    "data_source_id": self.context.data_source_id,
                    "created_at": datetime.utcnow().isoformat(),
                    "updated_at": datetime.utcnow().isoformat(),
                },
            }

            graph.field_nodes[full_name] = node
            graph.nodes.append(node)

            if table_node:
                contains_edge = {
                    "id": self._generate_id("edge", table_node["id"], node_id, "CONTAINS"),
                    "type": self.EDGE_TYPES["contains"],
                    "source_id": table_node["id"],
                    "target_id": node_id,
                    "properties": {},
                }
                graph.edges.append(contains_edge)

    def _resolve_column_table(
        self,
        column: ColumnReference,
        parsed_sql: ParsedSQL,
    ) -> Optional[TableReference]:
        if column.table_alias:
            for table in parsed_sql.source_tables:
                if table.alias == column.table_alias:
                    return table
            for table in parsed_sql.target_tables:
                if table.alias == column.table_alias:
                    return table

        if parsed_sql.source_tables:
            return parsed_sql.source_tables[0]

        return None

    def _build_job_node(self, graph: BuiltLineageGraph) -> None:
        if not self.context.job_id:
            return

        job_node = {
            "id": self.context.job_id,
            "labels": [self.NODE_LABELS["job"]],
            "properties": {
                "name": self.context.job_id,
                "sql_file_path": self.context.sql_file_path,
                "data_source_id": self.context.data_source_id,
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            },
        }

        graph.job_node = job_node
        graph.nodes.append(job_node)

    def _build_table_lineage_edges(
        self,
        extraction_result: LineageExtractionResult,
        graph: BuiltLineageGraph,
    ) -> None:
        for lineage in extraction_result.table_lineages:
            if lineage.confidence_score < self.context.confidence_threshold:
                continue

            source_table = graph.table_nodes.get(lineage.source_table.full_name)
            target_table = graph.table_nodes.get(lineage.target_table.full_name)

            if not source_table or not target_table:
                continue

            edge_id = self._generate_id(
                "edge",
                source_table["id"],
                target_table["id"],
                lineage.transformation_type.value,
            )

            edge = {
                "id": edge_id,
                "type": self.EDGE_TYPES["table_lineage"],
                "source_id": source_table["id"],
                "target_id": target_table["id"],
                "properties": {
                    "transformation_type": lineage.transformation_type.value,
                    "expression": lineage.expression,
                    "confidence_score": lineage.confidence_score,
                    "job_id": self.context.job_id,
                    "created_at": datetime.utcnow().isoformat(),
                    "updated_at": datetime.utcnow().isoformat(),
                },
            }

            graph.edges.append(edge)

    def _build_field_lineage_edges(
        self,
        extraction_result: LineageExtractionResult,
        graph: BuiltLineageGraph,
    ) -> None:
        for lineage in extraction_result.column_lineages:
            if lineage.confidence_score < self.context.confidence_threshold:
                continue

            source_field = graph.field_nodes.get(lineage.source_column.full_name)
            target_field = graph.field_nodes.get(lineage.target_column.full_name)

            if not source_field or not target_field:
                continue

            edge_id = self._generate_id(
                "edge",
                source_field["id"],
                target_field["id"],
                lineage.transformation_type.value,
            )

            edge = {
                "id": edge_id,
                "type": self.EDGE_TYPES["field_lineage"],
                "source_id": source_field["id"],
                "target_id": target_field["id"],
                "properties": {
                    "transformation_type": lineage.transformation_type.value,
                    "expression": lineage.expression,
                    "confidence_score": lineage.confidence_score,
                    "source_table_id": source_field["properties"].get("table_id"),
                    "target_table_id": target_field["properties"].get("table_id"),
                    "job_id": self.context.job_id,
                    "created_at": datetime.utcnow().isoformat(),
                    "updated_at": datetime.utcnow().isoformat(),
                },
            }

            graph.edges.append(edge)

    def _build_job_edges(self, graph: BuiltLineageGraph) -> None:
        if not graph.job_node:
            return

        job_id = graph.job_node["id"]

        for table_name, table_node in graph.table_nodes.items():
            if table_node["properties"].get("is_target"):
                edge = {
                    "id": self._generate_id("edge", job_id, table_node["id"], "WRITES"),
                    "type": self.EDGE_TYPES["job_writes"],
                    "source_id": job_id,
                    "target_id": table_node["id"],
                    "properties": {
                        "created_at": datetime.utcnow().isoformat(),
                    },
                }
                graph.edges.append(edge)
            else:
                edge = {
                    "id": self._generate_id("edge", job_id, table_node["id"], "READS"),
                    "type": self.EDGE_TYPES["job_reads"],
                    "source_id": job_id,
                    "target_id": table_node["id"],
                    "properties": {
                        "created_at": datetime.utcnow().isoformat(),
                    },
                }
                graph.edges.append(edge)

    def write_to_neo4j(self, graph: BuiltLineageGraph) -> Dict[str, Any]:
        driver = GraphDatabase.driver(
            settings.NEO4J_URI,
            auth=(settings.NEO4J_USER, settings.NEO4J_PASSWORD),
        )

        try:
            with driver.session() as session:
                return self._execute_write(session, graph)
        finally:
            driver.close()

    def _execute_write(self, session, graph: BuiltLineageGraph) -> Dict[str, Any]:
        stats = {
            "nodes_created": 0,
            "nodes_updated": 0,
            "edges_created": 0,
            "edges_updated": 0,
            "errors": [],
        }

        for node in graph.nodes:
            try:
                result = self._create_or_update_node(session, node)
                if result.get("created"):
                    stats["nodes_created"] += 1
                elif result.get("updated"):
                    stats["nodes_updated"] += 1
            except Exception as e:
                stats["errors"].append(f"节点写入失败: {node['id']} - {str(e)}")

        for edge in graph.edges:
            try:
                result = self._create_or_update_edge(session, edge)
                if result.get("created"):
                    stats["edges_created"] += 1
                elif result.get("updated"):
                    stats["edges_updated"] += 1
            except Exception as e:
                stats["errors"].append(f"边写入失败: {edge['id']} - {str(e)}")

        return stats

    def _create_or_update_node(self, session, node: Dict[str, Any]) -> Dict[str, Any]:
        labels = node["labels"]
        label_str = ":".join(labels)
        props = node["properties"]

        props_list = [f"n.{k} = ${k}" for k in props.keys()]
        props_str = ", ".join(props_list)

        if self.context.overwrite_existing:
            query = f"""
            MERGE (n:{label_str} {{id: $id}})
            SET {props_str}
            RETURN n
            """
        else:
            create_props_list = [f"n.{k} = ${k}" for k in props.keys()]
            create_props_str = ", ".join(create_props_list)
            query = f"""
            MERGE (n:{label_str} {{id: $id}})
            ON CREATE SET {create_props_str}
            ON MATCH SET n.updated_at = $updated_at
            RETURN n
            """

        params = {"id": node["id"], **props}

        result = session.run(query, **params)
        record = result.single()

        return {"created": record is not None, "updated": False}

    def _create_or_update_edge(self, session, edge: Dict[str, Any]) -> Dict[str, Any]:
        edge_type = edge["type"]
        props = edge["properties"]

        props_list = [f"r.{k} = ${k}" for k in props.keys()]
        props_str = ", ".join(props_list)

        if self.context.overwrite_existing:
            query = f"""
            MATCH (source {{id: $source_id}})
            MATCH (target {{id: $target_id}})
            MERGE (source)-[r:{edge_type}]->(target)
            SET {props_str}
            RETURN r
            """
        else:
            create_props_list = [f"r.{k} = ${k}" for k in props.keys()]
            create_props_str = ", ".join(create_props_list)
            query = f"""
            MATCH (source {{id: $source_id}})
            MATCH (target {{id: $target_id}})
            MERGE (source)-[r:{edge_type}]->(target)
            ON CREATE SET {create_props_str}
            ON MATCH SET r.updated_at = $updated_at
            RETURN r
            """

        params = {
            "source_id": edge["source_id"],
            "target_id": edge["target_id"],
            **props,
        }

        result = session.run(query, **params)
        record = result.single()

        return {"created": record is not None, "updated": False}

    def to_lineage_graph(self, graph: BuiltLineageGraph) -> LineageGraph:
        nodes = []
        for node in graph.nodes:
            nodes.append(LineageNode(
                id=node["id"],
                name=node["properties"].get("name", ""),
                type=node["labels"][0],
                properties=node["properties"],
            ))

        edges = []
        for edge in graph.edges:
            edges.append(LineageEdge(
                source_id=edge["source_id"],
                target_id=edge["target_id"],
                edge_type=edge["type"],
                properties=edge["properties"],
                transformation_type=edge["properties"].get("transformation_type"),
                expression=edge["properties"].get("expression"),
                confidence_score=edge["properties"].get("confidence_score"),
            ))

        return LineageGraph(
            nodes=nodes,
            edges=edges,
            total_nodes=len(nodes),
            total_edges=len(edges),
        )

    def parse_and_build(
        self,
        sql: str,
        context: Optional[LineageBuildContext] = None,
        use_oracle_dialect: bool = False,
    ) -> Tuple[BuiltLineageGraph, Dict[str, Any]]:
        if use_oracle_dialect:
            from app.parsers.oracle_dialect import OracleDialect
            parser = OracleDialect()
            parsed_sql = parser.parse(sql)
        else:
            from app.parsers.sql_parser import SQLParser
            parser = SQLParser()
            parsed_sql = parser.parse(sql)

        graph = self.build_from_parsed_sql(parsed_sql, context)

        stats = self.write_to_neo4j(graph)

        return graph, stats

    def batch_parse_and_build(
        self,
        sql_list: List[str],
        context: Optional[LineageBuildContext] = None,
        use_oracle_dialect: bool = False,
    ) -> List[Tuple[BuiltLineageGraph, Dict[str, Any]]]:
        results = []

        driver = GraphDatabase.driver(
            settings.NEO4J_URI,
            auth=(settings.NEO4J_USER, settings.NEO4J_PASSWORD),
        )

        try:
            with driver.session() as session:
                for sql in sql_list:
                    try:
                        graph, stats = self._parse_single_and_write(
                            sql, session, context, use_oracle_dialect
                        )
                        results.append((graph, stats))
                    except Exception as e:
                        empty_graph = BuiltLineageGraph()
                        empty_graph.metadata["error"] = str(e)
                        results.append((empty_graph, {"errors": [str(e)]}))
        finally:
            driver.close()

        return results

    def _parse_single_and_write(
        self,
        sql: str,
        session,
        context: Optional[LineageBuildContext],
        use_oracle_dialect: bool,
    ) -> Tuple[BuiltLineageGraph, Dict[str, Any]]:
        if use_oracle_dialect:
            from app.parsers.oracle_dialect import OracleDialect
            parser = OracleDialect()
            parsed_sql = parser.parse(sql)
        else:
            from app.parsers.sql_parser import SQLParser
            parser = SQLParser()
            parsed_sql = parser.parse(sql)

        graph = self.build_from_parsed_sql(parsed_sql, context)
        stats = self._execute_write(session, graph)

        return graph, stats

    def delete_lineage_by_job(self, job_id: str) -> Dict[str, Any]:
        driver = GraphDatabase.driver(
            settings.NEO4J_URI,
            auth=(settings.NEO4J_USER, settings.NEO4J_PASSWORD),
        )

        try:
            with driver.session() as session:
                return self._execute_delete_by_job(session, job_id)
        finally:
            driver.close()

    def _execute_delete_by_job(self, session, job_id: str) -> Dict[str, Any]:
        query = """
        MATCH (j:Job {id: $job_id})
        OPTIONAL MATCH (j)-[r1:READS]->(t1:Table)
        OPTIONAL MATCH (j)-[r2:WRITES]->(t2:Table)
        OPTIONAL MATCH (j)-[r3]->(f:Field)
        DELETE r1, r2, r3, j
        RETURN count(r1) + count(r2) + count(r3) as edges_deleted, count(j) as nodes_deleted
        """

        result = session.run(query, job_id=job_id)
        record = result.single()

        if record:
            return {
                "edges_deleted": record.get("edges_deleted", 0),
                "nodes_deleted": record.get("nodes_deleted", 0),
            }
        return {"edges_deleted": 0, "nodes_deleted": 0}

    def get_lineage_stats(self) -> Dict[str, Any]:
        driver = GraphDatabase.driver(
            settings.NEO4J_URI,
            auth=(settings.NEO4J_USER, settings.NEO4J_PASSWORD),
        )

        try:
            with driver.session() as session:
                return self._execute_get_stats(session)
        finally:
            driver.close()

    def _execute_get_stats(self, session) -> Dict[str, Any]:
        queries = {
            "tables": "MATCH (t:Table) RETURN count(t) as count",
            "fields": "MATCH (f:Field) RETURN count(f) as count",
            "jobs": "MATCH (j:Job) RETURN count(j) as count",
            "table_lineages": "MATCH ()-[r:LINEAGE_TO]->() RETURN count(r) as count",
            "field_lineages": "MATCH ()-[r:FIELD_LINEAGE_TO]->() RETURN count(r) as count",
            "job_reads": "MATCH ()-[r:READS]->() RETURN count(r) as count",
            "job_writes": "MATCH ()-[r:WRITES]->() RETURN count(r) as count",
        }

        stats = {}
        for key, query in queries.items():
            result = session.run(query)
            record = result.single()
            stats[key] = record.get("count", 0) if record else 0

        return stats