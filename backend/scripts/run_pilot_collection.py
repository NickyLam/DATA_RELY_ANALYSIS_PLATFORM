"""
试点采集任务执行脚本
执行试点表的元数据采集、SQL 解析和血缘提取
"""

import asyncio
import json
import logging
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional

# 添加项目根目录到 Python 路径
sys.path.insert(0, str(Path(__file__).parent.parent))

from app.config.pilot_tables import (
    CollectionType,
    DataSourceConfig,
    DataSourceType,
    PilotTable,
    PilotTableConfig,
    TablePriority,
    get_default_data_sources,
    get_default_pilot_tables,
)
from app.collectors.base_collector import BaseCollector
from app.collectors.jdbc_collector import JDBCCollector
from app.collectors.oracle_views_collector import OracleViewsCollector
from app.collectors.plsql_collector import PLSQLCollector
from app.parsers.sql_parser import SQLParser
from app.parsers.lineage_builder import LineageBuilder
from app.services.neo4j_lineage_service import Neo4jLineageService

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


class PilotCollectionRunner:
    """试点采集任务执行器"""

    def __init__(self):
        self.config = PilotTableConfig(
            pilot_tables=get_default_pilot_tables(),
            data_sources=get_default_data_sources(),
        )
        self.neo4j_service = Neo4jLineageService()
        self.parser = SQLParser()
        self.lineage_builder = LineageBuilder()
        self.results: Dict = {
            "metadata_collected": 0,
            "plsql_collected": 0,
            "sql_parsed": 0,
            "lineages_created": 0,
            "errors": [],
            "start_time": None,
            "end_time": None,
        }

    async def run(self, data_source_ids: Optional[List[str]] = None) -> dict:
        """
        执行试点采集任务

        Args:
            data_source_ids: 可选，指定要采集的数据源 ID 列表
                            如果不指定，则采集所有 Oracle 数据源

        Returns:
            dict: 采集结果统计
        """
        logger.info("开始试点采集任务...")
        self.results["start_time"] = datetime.now().isoformat()

        try:
            await self.neo4j_service.connect()

            # 确定要采集的数据源
            target_ds_ids = data_source_ids or [
                ds.data_source_id
                for ds in self.config.data_sources
                if ds.type == DataSourceType.ORACLE
            ]

            logger.info(f"计划采集 {len(target_ds_ids)} 个数据源")

            for ds_id in target_ds_ids:
                ds = self.config.get_data_source_by_id(ds_id)
                if not ds:
                    logger.warning(f"数据源 {ds_id} 不存在，跳过")
                    continue

                # 获取该数据源的试点表
                pilot_tables = self.config.get_tables_by_data_source(ds_id)
                if not pilot_tables:
                    logger.warning(f"数据源 {ds_id} 没有试点表，跳过")
                    continue

                logger.info(f"开始采集数据源 {ds.name} ({ds_id})")

                # 执行采集
                await self._collect_data_source(ds, pilot_tables)

        except Exception as e:
            logger.error(f"采集任务失败: {e}")
            self.results["errors"].append(str(e))

        finally:
            await self.neo4j_service.close()
            self.results["end_time"] = datetime.now().isoformat()

        logger.info("试点采集任务完成!")
        self._print_summary()

        return self.results

    async def _collect_data_source(
        self, ds: DataSourceConfig, tables: List[PilotTable]
    ):
        """
        采集单个数据源

        Args:
            ds: 数据源配置
            tables: 试点表列表
        """
        # 1. 元数据采集（模拟）
        logger.info(f"  采集元数据...")
        for table in tables:
            try:
                # 模拟采集表元数据
                await self._collect_table_metadata(ds, table)
                self.results["metadata_collected"] += 1
            except Exception as e:
                logger.warning(f"  采集表 {table.table_name} 元数据失败: {e}")
                self.results["errors"].append(f"metadata:{table.table_id}:{str(e)}")

        # 2. PL/SQL 源码采集（模拟）
        logger.info(f"  采集 PL/SQL 源码...")
        plsql_objects = self._get_simulated_plsql_objects(ds, tables)
        for obj in plsql_objects:
            try:
                await self._collect_plsql_source(ds, obj)
                self.results["plsql_collected"] += 1
            except Exception as e:
                logger.warning(f"  采集 PL/SQL {obj['name']} 失败: {e}")
                self.results["errors"].append(f"plsql:{obj['name']}:{str(e)}")

        # 3. SQL 解析和血缘提取
        logger.info(f"  解析 SQL 并提取血缘...")
        sql_sources = self._get_simulated_sql_sources(ds, tables)
        for sql_info in sql_sources:
            try:
                await self._parse_and_extract_lineage(ds, sql_info, tables)
                self.results["sql_parsed"] += 1
            except Exception as e:
                logger.warning(f"  解析 SQL {sql_info['source']} 失败: {e}")
                self.results["errors"].append(f"parse:{sql_info['source']}:{str(e)}")

    async def _collect_table_metadata(self, ds: DataSourceConfig, table: PilotTable):
        """
        采集表元数据（模拟）

        Args:
            ds: 数据源配置
            table: 表配置
        """
        # 模拟写入 Neo4j（实际环境中会通过 JDBC 查询）
        query = """
        MERGE (t:Table {table_id: $table_id})
        SET t.table_name = $table_name,
            t.schema_name = $schema_name,
            t.data_source = $data_source,
            t.business_domain = $business_domain,
            t.description = $description,
            t.collected_at = datetime(),
            t.collection_status = 'completed'
        
        // 创建列节点（模拟）
        WITH t
        UNWIND range(1, 5) AS col_idx
        MERGE (c:Column {
            table_id: $table_id,
            column_name: 'col_' + col_idx
        })
        SET c.data_type = CASE col_idx
            WHEN 1 THEN 'VARCHAR2(100)'
            WHEN 2 THEN 'NUMBER(18,2)'
            WHEN 3 THEN 'DATE'
            WHEN 4 THEN 'VARCHAR2(50)'
            WHEN 5 THEN 'NUMBER(10)'
            END,
            c.is_primary_key = (col_idx = 1),
            c.is_nullable = (col_idx > 2)
        MERGE (t)-[:HAS_COLUMN]->(c)
        """
        params = {
            "table_id": table.table_id,
            "table_name": table.table_name,
            "schema_name": table.schema_name,
            "data_source": ds.name,
            "business_domain": table.business_domain or "",
            "description": table.description or "",
        }
        await self.neo4j_service.execute_query(query, params)

    async def _collect_plsql_source(self, ds: DataSourceConfig, obj: dict):
        """
        采集 PL/SQL 源码（模拟）

        Args:
            ds: 数据源配置
            obj: PL/SQL 对象信息
        """
        # 模拟存储 PL/SQL 源码
        query = """
        MERGE (p:PLSQLObject {
            data_source_id: $data_source_id,
            object_name: $object_name,
            object_type: $object_type
        })
        SET p.source_code = $source_code,
            p.schema_name = $schema_name,
            p.collected_at = datetime()
        """
        params = {
            "data_source_id": ds.data_source_id,
            "object_name": obj["name"],
            "object_type": obj["type"],
            "source_code": obj["source"],
            "schema_name": obj["schema"],
        }
        await self.neo4j_service.execute_query(query, params)

    async def _parse_and_extract_lineage(
        self, ds: DataSourceConfig, sql_info: dict, tables: List[PilotTable]
    ):
        """
        解析 SQL 并提取血缘

        Args:
            ds: 数据源配置
            sql_info: SQL 信息
            tables: 试点表列表
        """
        sql = sql_info["sql"]
        target_table_id = sql_info["target_table"]

        # 使用解析器解析 SQL（模拟）
        parsed_result = await self._parse_sql(sql)

        # 提取血缘关系
        lineage_relations = parsed_result.get("lineages", [])
        for relation in lineage_relations:
            source_table_id = relation.get("source_table")
            if source_table_id and target_table_id:
                # 验证表在试点列表中
                source_table = self.config.get_table_by_id(source_table_id)
                target_table = self.config.get_table_by_id(target_table_id)

                if source_table and target_table:
                    await self._create_lineage_relation(
                        source_table_id, target_table_id, relation
                    )
                    self.results["lineages_created"] += 1

    async def _parse_sql(self, sql: str) -> dict:
        """
        解析 SQL（模拟）

        Args:
            sql: SQL 语句

        Returns:
            dict: 解析结果
        """
        # 实际环境中会使用 SQLParser
        # 这里模拟解析结果
        return {
            "sql": sql,
            "type": "insert_select",
            "lineages": [],
        }

    async def _create_lineage_relation(
        self, source_id: str, target_id: str, relation: dict
    ):
        """
        创建血缘关系

        Args:
            source_id: 源表 ID
            target_id: 目标表 ID
            relation: 关系详情
        """
        query = """
        MATCH (source:Table {table_id: $source_id})
        MATCH (target:Table {table_id: $target_id})
        MERGE (source)-[r:LINEAGE_TO]->(target)
        SET r.lineage_type = 'table',
            r.transformation_type = $transformation_type,
            r.expression = $expression,
            r.confidence = $confidence,
            r.source = 'sql_parsing',
            r.created_at = datetime()
        """
        params = {
            "source_id": source_id,
            "target_id": target_id,
            "transformation_type": relation.get("transformation_type", "direct"),
            "expression": relation.get("expression", ""),
            "confidence": relation.get("confidence", 0.85),
        }
        await self.neo4j_service.execute_query(query, params)

    def _get_simulated_plsql_objects(
        self, ds: DataSourceConfig, tables: List[PilotTable]
    ) -> List[dict]:
        """
        获取模拟的 PL/SQL 对象列表

        Args:
            ds: 数据源配置
            tables: 试点表列表

        Returns:
            List[dict]: PL/SQL 对象列表
        """
        # 模拟数据
        return [
            {
                "name": f"pkg_{ds.database_name}_etl",
                "type": "PACKAGE",
                "schema": tables[0].schema_name if tables else "public",
                "source": f"""
CREATE OR REPLACE PACKAGE pkg_{ds.database_name}_etl AS
    PROCEDURE load_daily_data;
    PROCEDURE aggregate_monthly;
END;
""",
            },
            {
                "name": f"proc_load_{tables[0].table_name if tables else 'data'}",
                "type": "PROCEDURE",
                "schema": tables[0].schema_name if tables else "public",
                "source": f"""
CREATE OR REPLACE PROCEDURE proc_load_{tables[0].table_name if tables else 'data'} AS
BEGIN
    INSERT INTO {tables[0].table_name if tables else 'target_table'}
    SELECT * FROM source_table;
END;
""",
            },
        ]

    def _get_simulated_sql_sources(
        self, ds: DataSourceConfig, tables: List[PilotTable]
    ) -> List[dict]:
        """
        获取模拟的 SQL 源列表

        Args:
            ds: 数据源配置
            tables: 试点表列表

        Returns:
            List[dict]: SQL 源列表
        """
        # 模拟 ETL SQL
        sqls = []
        for i, table in enumerate(tables[:3]):  # 只模拟前3个表
            sqls.append({
                "source": f"etl_job_{table.table_name}",
                "target_table": table.table_id,
                "sql": f"""
INSERT INTO {table.table_name}
SELECT col1, col2, col3
FROM source_table_{i}
WHERE create_date = SYSDATE;
""",
            })
        return sqls

    def _print_summary(self):
        """打印采集摘要"""
        logger.info("=" * 60)
        logger.info("试点采集任务摘要")
        logger.info("=" * 60)
        logger.info(f"开始时间: {self.results['start_time']}")
        logger.info(f"结束时间: {self.results['end_time']}")
        logger.info(f"元数据采集: {self.results['metadata_collected']} 表")
        logger.info(f"PL/SQL 采集: {self.results['plsql_collected']} 对象")
        logger.info(f"SQL 解析: {self.results['sql_parsed']} 条")
        logger.info(f"血缘创建: {self.results['lineages_created']} 条")
        if self.results["errors"]:
            logger.info(f"错误数: {len(self.results['errors'])}")
            for error in self.results["errors"][:5]:  # 只显示前5个错误
                logger.info(f"  - {error}")
        logger.info("=" * 60)


async def main():
    """主函数"""
    runner = PilotCollectionRunner()
    results = await runner.run()

    # 输出结果到文件
    output_file = Path(__file__).parent / "collection_results.json"
    with open(output_file, "w") as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    logger.info(f"采集结果已保存到: {output_file}")


if __name__ == "__main__":
    asyncio.run(main())