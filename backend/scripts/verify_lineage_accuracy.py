"""
血缘准确性验证脚本
对比采集血缘与人工标注，计算准确率
"""

import asyncio
import json
import logging
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple

# 添加项目根目录到 Python 路径
sys.path.insert(0, str(Path(__file__).parent.parent))

from app.config.pilot_tables import (
    ManualAnnotation,
    PilotTableConfig,
    get_default_pilot_tables,
    get_default_manual_annotations,
)
from app.services.neo4j_lineage_service import Neo4jLineageService

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


class LineageAccuracyVerifier:
    """血缘准确性验证器"""

    def __init__(self):
        self.config = PilotTableConfig(
            pilot_tables=get_default_pilot_tables(),
            manual_annotations=get_default_manual_annotations(),
        )
        self.neo4j_service = Neo4jLineageService()
        self.results: Dict = {
            "table_level_accuracy": 0.0,
            "field_level_accuracy": 0.0,
            "total_annotations": 0,
            "matched_lineages": 0,
            "missing_lineages": 0,
            "extra_lineages": 0,
            "false_positive_rate": 0.0,
            "false_negative_rate": 0.0,
            "details": [],
            "errors": [],
            "start_time": None,
            "end_time": None,
        }

    async def verify(self) -> dict:
        """
        执行血缘准确性验证

        Returns:
            dict: 验证结果
        """
        logger.info("开始血缘准确性验证...")
        self.results["start_time"] = datetime.now().isoformat()

        try:
            await self.neo4j_service.connect()

            # 1. 获取人工标注血缘
            annotations = get_default_manual_annotations()
            self.results["total_annotations"] = len(annotations)
            logger.info(f"人工标注数量: {len(annotations)}")

            # 2. 验证表级血缘
            await self._verify_table_level_lineages(annotations)

            # 3. 验证字段级血缘
            await self._verify_field_level_lineages(annotations)

            # 4. 计算准确率
            self._calculate_accuracy()

            # 5. 生成差异报告
            await self._generate_diff_report()

        except Exception as e:
            logger.error(f"验证失败: {e}")
            self.results["errors"].append(str(e))

        finally:
            await self.neo4j_service.close()
            self.results["end_time"] = datetime.now().isoformat()

        logger.info("血缘准确性验证完成!")
        self._print_summary()

        return self.results

    async def _verify_table_level_lineages(self, annotations: List[ManualAnnotation]):
        """
        验证表级血缘

        Args:
            annotations: 人工标注列表
        """
        logger.info("验证表级血缘...")

        matched = 0
        missing = 0

        for annotation in annotations:
            source_table = annotation.source_table_id
            target_table = annotation.target_table_id

            # 查询 Neo4j 中的血缘
            query = """
            MATCH (source:Table {table_id: $source_id})
            MATCH (target:Table {table_id: $target_id})
            OPTIONAL MATCH (source)-[r:LINEAGE_TO]->(target)
            RETURN r IS NOT NULL AS has_lineage
            """
            params = {
                "source_id": source_table,
                "target_id": target_table,
            }

            try:
                result = await self.neo4j_service.execute_query(query, params)
                has_lineage = result[0].get("has_lineage", False) if result else False

                if has_lineage:
                    matched += 1
                    self.results["details"].append({
                        "type": "table",
                        "annotation_id": annotation.annotation_id,
                        "source": source_table,
                        "target": target_table,
                        "status": "matched",
                        "confidence": annotation.confidence,
                    })
                else:
                    missing += 1
                    self.results["details"].append({
                        "type": "table",
                        "annotation_id": annotation.annotation_id,
                        "source": source_table,
                        "target": target_table,
                        "status": "missing",
                        "confidence": annotation.confidence,
                    })
            except Exception as e:
                logger.warning(f"验证 {source_table} -> {target_table} 失败: {e}")
                self.results["errors"].append(str(e))

        self.results["matched_lineages"] = matched
        self.results["missing_lineages"] = missing

    async def _verify_field_level_lineages(self, annotations: List[ManualAnnotation]):
        """
        验证字段级血缘

        Args:
            annotations: 人工标注列表
        """
        logger.info("验证字段级血缘...")

        field_annotations = [
            a
            for a in annotations
            if a.source_field_name and a.target_field_name
        ]

        field_matched = 0
        field_missing = 0

        for annotation in field_annotations:
            source_table = annotation.source_table_id
            target_table = annotation.target_table_id
            source_field = annotation.source_field_name
            target_field = annotation.target_field_name

            # 查询字段级血缘
            query = """
            MATCH (source:Table {table_id: $source_id})
            MATCH (target:Table {table_id: $target_id})
            OPTIONAL MATCH (source)-[r:LINEAGE_TO]->(target)
            WHERE r.source_fields CONTAINS $source_field
              AND r.target_fields CONTAINS $target_field
            RETURN r IS NOT NULL AS has_field_lineage
            """
            params = {
                "source_id": source_table,
                "target_id": target_table,
                "source_field": source_field,
                "target_field": target_field,
            }

            try:
                result = await self.neo4j_service.execute_query(query, params)
                has_field_lineage = result[0].get("has_field_lineage", False) if result else False

                if has_field_lineage:
                    field_matched += 1
                else:
                    field_missing += 1
                    self.results["details"].append({
                        "type": "field",
                        "annotation_id": annotation.annotation_id,
                        "source": f"{source_table}.{source_field}",
                        "target": f"{target_table}.{target_field}",
                        "status": "missing",
                        "expression": annotation.expression,
                    })
            except Exception as e:
                logger.warning(f"验证字段级血缘失败: {e}")

        self.results["field_matched"] = field_matched
        self.results["field_missing"] = field_missing

    async def _generate_diff_report(self):
        """
        生成差异报告
        """
        logger.info("生成差异报告...")

        # 查询所有采集的血缘关系
        query = """
        MATCH (source:Table)-[r:LINEAGE_TO]->(target:Table)
        RETURN source.table_id AS source_id, target.table_id AS target_id
        """
        try:
            collected_lineages = await self.neo4j_service.execute_query(query)

            # 检查是否有额外采集的血缘（不在标注中）
            annotations = get_default_manual_annotations()
            annotation_pairs = set()
            for a in annotations:
                annotation_pairs.add((a.source_table_id, a.target_table_id))

            extra_lineages = 0
            for lineage in collected_lineages:
                pair = (lineage.get("source_id"), lineage.get("target_id"))
                if pair not in annotation_pairs:
                    extra_lineages += 1
                    self.results["details"].append({
                        "type": "extra",
                        "source": lineage.get("source_id"),
                        "target": lineage.get("target_id"),
                        "status": "extra_lineage",
                    })

            self.results["extra_lineages"] = extra_lineages

        except Exception as e:
            logger.warning(f"生成差异报告失败: {e}")

    def _calculate_accuracy(self):
        """
        计算准确率
        """
        total_annotations = self.results["total_annotations"]
        matched = self.results["matched_lineages"]
        missing = self.results["missing_lineages"]
        extra = self.results["extra_lineages"]

        if total_annotations > 0:
            # 表级准确率 = 匹配数 / 总标注数
            self.results["table_level_accuracy"] = matched / total_annotations

            # 假阴性率 = 缺失数 / 总标注数
            self.results["false_negative_rate"] = missing / total_annotations

        # 假阳性率 = 额外血缘数 / (采集血缘总数)
        total_collected = matched + extra
        if total_collected > 0:
            self.results["false_positive_rate"] = extra / total_collected

        # 字段级准确率
        field_annotations = self.results.get("field_matched", 0) + self.results.get("field_missing", 0)
        if field_annotations > 0:
            self.results["field_level_accuracy"] = self.results.get("field_matched", 0) / field_annotations

    def _print_summary(self):
        """
        打印验证摘要
        """
        logger.info("=" * 60)
        logger.info("血缘准确性验证摘要")
        logger.info("=" * 60)
        logger.info(f"验证时间: {self.results['start_time']} - {self.results['end_time']}")
        logger.info("-" * 60)
        logger.info("表级血缘准确率:")
        logger.info(f"  总标注数: {self.results['total_annotations']}")
        logger.info(f"  匹配数: {self.results['matched_lineages']}")
        logger.info(f"  缺失数: {self.results['missing_lineages']}")
        logger.info(f"  准确率: {self.results['table_level_accuracy']:.2%}")
        logger.info(f"  假阴性率: {self.results['false_negative_rate']:.2%}")
        logger.info("-" * 60)
        logger.info("字段级血缘准确率:")
        logger.info(f"  匹配数: {self.results.get('field_matched', 0)}")
        logger.info(f"  缺失数: {self.results.get('field_missing', 0)}")
        logger.info(f"  准确率: {self.results['field_level_accuracy']:.2%}")
        logger.info("-" * 60)
        logger.info("假阳性分析:")
        logger.info(f"  额外血缘数: {self.results['extra_lineages']}")
        logger.info(f"  假阳性率: {self.results['false_positive_rate']:.2%}")
        logger.info("-" * 60)

        # 验收标准检查
        table_accuracy = self.results["table_level_accuracy"]
        field_accuracy = self.results["field_level_accuracy"]

        logger.info("验收标准检查:")
        if table_accuracy >= 0.95:
            logger.info("  ✅ 表级血缘准确率 ≥ 95%")
        else:
            logger.info(f"  ❌ 表级血缘准确率 {table_accuracy:.2%} < 95%")

        if field_accuracy >= 0.85:
            logger.info("  ✅ 字段级血缘准确率 ≥ 85%")
        else:
            logger.info(f"  ❌ 字段级血缘准确率 {field_accuracy:.2%} < 85%")

        if self.results["errors"]:
            logger.info("-" * 60)
            logger.info(f"错误数: {len(self.results['errors'])}")

        logger.info("=" * 60)


async def main():
    """主函数"""
    verifier = LineageAccuracyVerifier()
    results = await verifier.verify()

    # 输出结果到文件
    output_file = Path(__file__).parent / "lineage_accuracy_results.json"
    with open(output_file, "w") as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    logger.info(f"验证结果已保存到: {output_file}")

    return results


if __name__ == "__main__":
    asyncio.run(main())