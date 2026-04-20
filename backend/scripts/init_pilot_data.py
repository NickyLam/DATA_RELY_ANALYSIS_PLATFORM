"""
试点表初始化脚本
将试点表配置数据写入 Neo4j 图数据库
"""

import asyncio
import logging
import sys
from pathlib import Path
from typing import List, Optional

# 添加项目根目录到 Python 路径
sys.path.insert(0, str(Path(__file__).parent.parent))

from app.config.pilot_tables import (
    DataSourceConfig,
    PilotTable,
    PilotTableConfig,
    TablePriority,
    get_default_data_sources,
    get_default_pilot_tables,
    get_default_collection_tasks,
    get_default_manual_annotations,
)
from app.services.neo4j_lineage_service import Neo4jLineageService

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


class PilotDataInitializer:
    """试点数据初始化器"""

    def __init__(self, neo4j_service: Neo4jLineageService):
        self.neo4j_service = neo4j_service
        self.config = PilotTableConfig(
            pilot_tables=get_default_pilot_tables(),
            data_sources=get_default_data_sources(),
            collection_tasks=get_default_collection_tasks(),
            manual_annotations=get_default_manual_annotations(),
        )

    async def initialize(self) -> dict:
        """
        执行完整的初始化流程

        Returns:
            dict: 初始化结果统计
        """
        logger.info("开始试点数据初始化...")

        results = {
            "data_sources": 0,
            "tables": 0,
            "lineages": 0,
            "annotations": 0,
            "errors": [],
        }

        try:
            # 1. 创建数据源节点
            results["data_sources"] = await self._create_data_sources()

            # 2. 创建表节点
            results["tables"] = await self._create_tables()

            # 3. 创建表级血缘关系
            results["lineages"] = await self._create_lineages()

            # 4. 创建人工标注数据
            results["annotations"] = await self._create_annotations()

            logger.info("试点数据初始化完成!")
            self._print_summary(results)

        except Exception as e:
            logger.error(f"初始化失败: {e}")
            results["errors"].append(str(e))

        return results

    async def _create_data_sources(self) -> int:
        """创建数据源节点"""
        logger.info(f"创建 {len(self.config.data_sources)} 个数据源节点...")

        count = 0
        for ds in self.config.data_sources:
            try:
                query = """
                MERGE (ds:DataSource {data_source_id: $data_source_id})
                SET ds.name = $name,
                    ds.type = $type,
                    ds.host = $host,
                    ds.port = $port,
                    ds.database_name = $database_name,
                    ds.enabled = $enabled,
                    ds.priority = $priority
                """
                params = {
                    "data_source_id": ds.data_source_id,
                    "name": ds.name,
                    "type": ds.type.value,
                    "host": ds.host,
                    "port": ds.port,
                    "database_name": ds.database_name,
                    "enabled": ds.enabled,
                    "priority": ds.priority.value,
                }
                await self.neo4j_service.execute_query(query, params)
                count += 1
            except Exception as e:
                logger.warning(f"创建数据源 {ds.data_source_id} 失败: {e}")

        return count

    async def _create_tables(self) -> int:
        """创建表节点"""
        logger.info(f"创建 {len(self.config.pilot_tables)} 个表节点...")

        count = 0
        for table in self.config.pilot_tables:
            try:
                query = """
                MERGE (t:Table {table_id: $table_id})
                SET t.table_name = $table_name,
                    t.schema_name = $schema_name,
                    t.business_domain = $business_domain,
                    t.description = $description,
                    t.priority = $priority,
                    t.expected_lineage_count = $expected_lineage_count,
                    t.has_manual_annotation = $has_manual_annotation,
                    t.tags = $tags
                WITH t
                MATCH (ds:DataSource {data_source_id: $data_source_id})
                MERGE (t)-[:BELONGS_TO]->(ds)
                """
                params = {
                    "table_id": table.table_id,
                    "table_name": table.table_name,
                    "schema_name": table.schema_name,
                    "business_domain": table.business_domain or "",
                    "description": table.description or "",
                    "priority": table.priority.value,
                    "expected_lineage_count": table.expected_lineage_count,
                    "has_manual_annotation": table.has_manual_annotation,
                    "tags": table.tags,
                    "data_source_id": table.data_source_id,
                }
                await self.neo4j_service.execute_query(query, params)
                count += 1
            except Exception as e:
                logger.warning(f"创建表 {table.table_id} 失败: {e}")

        return count

    async def _create_lineages(self) -> int:
        """创建表级血缘关系（基于人工标注）"""
        logger.info("创建表级血缘关系...")

        # 定义核心血缘关系（监管报送系统的典型血缘链路）
        lineage_pairs = [
            # 财务模块血缘
            ("oracle:finance:transaction_log", "oracle:finance:account_balance"),
            ("oracle:finance:transaction_log", "oracle:finance:daily_report"),
            ("oracle:finance:account_balance", "oracle:finance:monthly_summary"),
            ("oracle:finance:daily_report", "oracle:finance:monthly_summary"),
            ("oracle:finance:budget_plan", "oracle:finance:expense_record"),
            ("oracle:finance:invoice_detail", "oracle:finance:expense_record"),
            ("oracle:finance:expense_record", "oracle:finance:monthly_summary"),
            
            # CRM 模块血缘
            ("oracle:crm:customer_info", "oracle:crm:order_detail"),
            ("oracle:crm:customer_contact", "oracle:crm:order_detail"),
            ("oracle:crm:product_catalog", "oracle:crm:order_detail"),
            ("oracle:crm:price_list", "oracle:crm:order_detail"),
            ("oracle:crm:order_detail", "oracle:crm:order_summary"),
            ("oracle:crm:promotion_record", "oracle:crm:order_detail"),
            
            # HR 模块血缘
            ("oracle:hr:employee_info", "oracle:hr:salary_record"),
            ("oracle:hr:position_info", "oracle:hr:salary_record"),
            ("oracle:hr:department_info", "oracle:hr:employee_info"),
            ("oracle:hr:attendance_log", "oracle:hr:salary_record"),
            
            # 库存模块血缘
            ("oracle:inventory:product_info", "oracle:inventory:stock_record"),
            ("oracle:inventory:warehouse_info", "oracle:inventory:stock_record"),
            ("oracle:inventory:supplier_info", "oracle:inventory:purchase_order"),
            ("oracle:inventory:purchase_order", "oracle:inventory:stock_movement"),
            ("oracle:inventory:stock_record", "oracle:inventory:stock_movement"),
            
            # 数据湖血缘（Oracle -> TDH）
            ("oracle:finance:transaction_log", "tdh:datalake:raw_transaction"),
            ("oracle:crm:order_detail", "tdh:datalake:raw_transaction"),
            ("tdh:datalake:raw_transaction", "tdh:datalake:cleaned_transaction"),
            ("tdh:datalake:cleaned_transaction", "tdh:datalake:aggregated_report"),
            ("oracle:crm:customer_info", "tdh:datalake:customer_profile"),
            ("tdh:datalake:cleaned_transaction", "tdh:datalake:customer_profile"),
            ("oracle:inventory:product_info", "tdh:datalake:product_analysis"),
            ("tdh:datalake:cleaned_transaction", "tdh:datalake:product_analysis"),
            
            # 报表模块血缘（TDH -> OceanBase）
            ("tdh:datalake:aggregated_report", "oceanbase:report:daily_metrics"),
            ("tdh:datalake:aggregated_report", "oceanbase:report:weekly_metrics"),
            ("tdh:datalake:aggregated_report", "oceanbase:report:monthly_metrics"),
            ("oceanbase:report:daily_metrics", "oceanbase:report:kpi_dashboard"),
            ("oceanbase:report:weekly_metrics", "oceanbase:report:kpi_dashboard"),
            ("oceanbase:report:monthly_metrics", "oceanbase:report:kpi_dashboard"),
            
            # 分析模块血缘（OceanBase -> GBase）
            ("tdh:datalake:customer_profile", "gbase:analytics:user_behavior"),
            ("tdh:datalake:cleaned_transaction", "gbase:analytics:product_sales"),
            ("gbase:analytics:user_behavior", "gbase:analytics:customer_segment"),
            ("gbase:analytics:product_sales", "gbase:analytics:market_trend"),
            
            # 归档模块血缘
            ("oracle:finance:transaction_log", "yashan:archive:transaction_archive"),
            ("oracle:crm:customer_info", "yashan:archive:customer_archive"),
        ]

        count = 0
        for source_id, target_id in lineage_pairs:
            try:
                query = """
                MATCH (source:Table {table_id: $source_id})
                MATCH (target:Table {table_id: $target_id})
                MERGE (source)-[r:LINEAGE_TO]->(target)
                SET r.lineage_type = 'table',
                    r.confidence = 0.9,
                    r.source = 'manual_annotation',
                    r.created_at = datetime()
                """
                params = {
                    "source_id": source_id,
                    "target_id": target_id,
                }
                await self.neo4j_service.execute_query(query, params)
                count += 1
            except Exception as e:
                logger.warning(f"创建血缘关系 {source_id} -> {target_id} 失败: {e}")

        return count

    async def _create_annotations(self) -> int:
        """创建人工标注数据"""
        annotations = get_default_manual_annotations()
        logger.info(f"创建 {len(annotations)} 个人工标注...")

        count = 0
        for annotation in annotations:
            try:
                query = """
                MATCH (source:Table {table_id: $source_table_id})
                MATCH (target:Table {table_id: $target_table_id})
                MERGE (source)-[r:ANNOTATED_LINEAGE]->(target)
                SET r.annotation_id = $annotation_id,
                    r.transformation_type = $transformation_type,
                    r.expression = $expression,
                    r.confidence = $confidence,
                    r.annotator = $annotator,
                    r.annotation_date = $annotation_date
                """
                params = {
                    "annotation_id": annotation.annotation_id,
                    "source_table_id": annotation.source_table_id,
                    "target_table_id": annotation.target_table_id,
                    "transformation_type": annotation.transformation_type or "direct",
                    "expression": annotation.expression or "",
                    "confidence": annotation.confidence,
                    "annotator": annotation.annotator or "system",
                    "annotation_date": annotation.annotation_date or "2026-04-20",
                }
                await self.neo4j_service.execute_query(query, params)
                count += 1
            except Exception as e:
                logger.warning(f"创建标注 {annotation.annotation_id} 失败: {e}")

        return count

    def _print_summary(self, results: dict):
        """打印初始化摘要"""
        logger.info("=" * 50)
        logger.info("试点数据初始化摘要")
        logger.info("=" * 50)
        logger.info(f"数据源节点: {results['data_sources']}")
        logger.info(f"表节点: {results['tables']}")
        logger.info(f"血缘关系: {results['lineages']}")
        logger.info(f"人工标注: {results['annotations']}")
        if results["errors"]:
            logger.info(f"错误数: {len(results['errors'])}")
            for error in results["errors"]:
                logger.info(f"  - {error}")
        logger.info("=" * 50)


async def main():
    """主函数"""
    neo4j_service = Neo4jLineageService()
    
    try:
        await neo4j_service.connect()
        initializer = PilotDataInitializer(neo4j_service)
        results = await initializer.initialize()
        
        # 输出结果到文件
        output_file = Path(__file__).parent / "init_results.json"
        import json
        with open(output_file, "w") as f:
            json.dump(results, f, indent=2, ensure_ascii=False)
        logger.info(f"结果已保存到: {output_file}")
        
    finally:
        await neo4j_service.close()


if __name__ == "__main__":
    asyncio.run(main())