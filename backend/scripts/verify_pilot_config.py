"""
试点配置验证脚本
验证试点表配置的完整性和数据源连接
"""

import asyncio
import json
import logging
import sys
from pathlib import Path
from typing import Dict, List, Optional

# 添加项目根目录到 Python 路径
sys.path.insert(0, str(Path(__file__).parent.parent))

from app.config.pilot_tables import (
    DataSourceConfig,
    DataSourceType,
    PilotTable,
    PilotTableConfig,
    TablePriority,
    get_default_data_sources,
    get_default_pilot_tables,
    get_default_collection_tasks,
    get_default_manual_annotations,
)

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


class PilotConfigVerifier:
    """试点配置验证器"""

    def __init__(self):
        self.config = PilotTableConfig(
            pilot_tables=get_default_pilot_tables(),
            data_sources=get_default_data_sources(),
            collection_tasks=get_default_collection_tasks(),
            manual_annotations=get_default_manual_annotations(),
        )
        self.errors: List[str] = []
        self.warnings: List[str] = []

    def verify(self) -> dict:
        """
        执行完整的配置验证

        Returns:
            dict: 验证结果
        """
        logger.info("开始试点配置验证...")

        results = {
            "valid": True,
            "tables_count": len(self.config.pilot_tables),
            "data_sources_count": len(self.config.data_sources),
            "tasks_count": len(self.config.collection_tasks),
            "annotations_count": len(self.config.manual_annotations),
            "high_priority_tables": len(self.config.get_high_priority_tables()),
            "tables_with_annotations": len(self.config.get_tables_with_annotations()),
            "errors": [],
            "warnings": [],
            "coverage_stats": {},
            "priority_distribution": {},
            "domain_distribution": {},
        }

        # 1. 验证表配置完整性
        self._verify_tables(results)

        # 2. 验证数据源配置
        self._verify_data_sources(results)

        # 3. 验证采集任务配置
        self._verify_collection_tasks(results)

        # 4. 验证人工标注配置
        self._verify_annotations(results)

        # 5. 验证配置一致性
        self._verify_consistency(results)

        # 6. 统计分布
        self._calculate_statistics(results)

        # 收集错误和警告
        results["errors"] = self.errors
        results["warnings"] = self.warnings
        results["valid"] = len(self.errors) == 0

        logger.info("试点配置验证完成!")
        self._print_summary(results)

        return results

    def _verify_tables(self, results: dict):
        """验证表配置完整性"""
        logger.info(f"验证 {len(self.config.pilot_tables)} 个表配置...")

        required_fields = ["table_id", "table_name", "schema_name", "data_source_id"]

        for table in self.config.pilot_tables:
            for field in required_fields:
                if not getattr(table, field, None):
                    self.errors.append(f"表 {table.table_id} 缺少必填字段: {field}")

            # 验证数据源存在
            ds = self.config.get_data_source_by_id(table.data_source_id)
            if not ds:
                self.errors.append(
                    f"表 {table.table_id} 引用的数据源 {table.data_source_id} 不存在"
                )

            # 验证表 ID 格式
            if ":" not in table.table_id:
                self.warnings.append(
                    f"表 {table.table_id} 的 ID 格式不规范，应为 '数据源:schema:table'"
                )

            # 验证预期血缘数量
            if table.expected_lineage_count < 0:
                self.errors.append(
                    f"表 {table.table_id} 的预期血缘数量不能为负数"
                )

    def _verify_data_sources(self, results: dict):
        """验证数据源配置"""
        logger.info(f"验证 {len(self.config.data_sources)} 个数据源配置...")

        required_fields = ["data_source_id", "name", "type", "host", "port", "database_name"]

        for ds in self.config.data_sources:
            for field in required_fields:
                if not getattr(ds, field, None):
                    self.errors.append(f"数据源 {ds.data_source_id} 缺少必填字段: {field}")

            # 验证端口范围
            if ds.port <= 0 or ds.port > 65535:
                self.errors.append(f"数据源 {ds.data_source_id} 的端口 {ds.port} 不在有效范围内")

            # 验证数据源类型
            valid_types = [t.value for t in DataSourceType]
            if ds.type.value not in valid_types:
                self.errors.append(
                    f"数据源 {ds.data_source_id} 的类型 {ds.type.value} 无效"
                )

    def _verify_collection_tasks(self, results: dict):
        """验证采集任务配置"""
        logger.info(f"验证 {len(self.config.collection_tasks)} 个采集任务配置...")

        required_fields = ["task_id", "task_name", "data_source_id", "collection_type"]

        for task in self.config.collection_tasks:
            for field in required_fields:
                if not getattr(task, field, None):
                    self.errors.append(f"任务 {task.task_id} 缺少必填字段: {field}")

            # 验证数据源存在
            ds = self.config.get_data_source_by_id(task.data_source_id)
            if not ds:
                self.errors.append(
                    f"任务 {task.task_id} 引用的数据源 {task.data_source_id} 不存在"
                )

            # 验证目标表存在
            for table_id in task.target_tables:
                table = self.config.get_table_by_id(table_id)
                if not table:
                    self.warnings.append(
                        f"任务 {task.task_id} 的目标表 {table_id} 不在试点表列表中"
                    )

            # 验证超时设置
            if task.timeout_seconds <= 0:
                self.errors.append(f"任务 {task.task_id} 的超时时间必须大于 0")

    def _verify_annotations(self, results: dict):
        """验证人工标注配置"""
        annotations = get_default_manual_annotations()
        logger.info(f"验证 {len(annotations)} 个人工标注配置...")

        for annotation in annotations:
            # 验证源表存在
            source_table = self.config.get_table_by_id(annotation.source_table_id)
            if not source_table:
                self.errors.append(
                    f"标注 {annotation.annotation_id} 的源表 {annotation.source_table_id} 不存在"
                )

            # 验证目标表存在
            target_table = self.config.get_table_by_id(annotation.target_table_id)
            if not target_table:
                self.errors.append(
                    f"标注 {annotation.annotation_id} 的目标表 {annotation.target_table_id} 不存在"
                )

            # 验证置信度范围
            if annotation.confidence < 0 or annotation.confidence > 1:
                self.errors.append(
                    f"标注 {annotation.annotation_id} 的置信度 {annotation.confidence} 不在 [0, 1] 范围内"
                )

    def _verify_consistency(self, results: dict):
        """验证配置一致性"""
        logger.info("验证配置一致性...")

        # 验证阈值设置
        if self.config.validation_threshold < 0.5 or self.config.validation_threshold > 1:
            self.warnings.append(
                f"验证阈值 {self.config.validation_threshold} 可能设置不当"
            )

        if self.config.coverage_threshold < 0.5 or self.config.coverage_threshold > 1:
            self.warnings.append(
                f"覆盖率阈值 {self.config.coverage_threshold} 可能设置不当"
            )

        # 验证每个数据源至少有一个采集任务
        ds_with_tasks = set()
        for task in self.config.collection_tasks:
            ds_with_tasks.add(task.data_source_id)

        for ds in self.config.data_sources:
            if ds.data_source_id not in ds_with_tasks:
                self.warnings.append(
                    f"数据源 {ds.data_source_id} 没有配置采集任务"
                )

        # 验证高优先级表都有人工标注
        high_priority_tables = self.config.get_high_priority_tables()
        for table in high_priority_tables:
            if not table.has_manual_annotation:
                self.warnings.append(
                    f"高优先级表 {table.table_id} 没有人工标注"
                )

    def _calculate_statistics(self, results: dict):
        """计算统计信息"""
        # 优先级分布
        priority_dist = {}
        for priority in TablePriority:
            count = len(self.config.get_tables_by_priority(priority))
            priority_dist[priority.value] = count
        results["priority_distribution"] = priority_dist

        # 业务域分布
        domain_dist = {}
        for table in self.config.pilot_tables:
            domain = table.business_domain or "未分类"
            domain_dist[domain] = domain_dist.get(domain, 0) + 1
        results["domain_distribution"] = domain_dist

        # 数据源类型分布
        type_dist = {}
        for ds in self.config.data_sources:
            type_dist[ds.type.value] = type_dist.get(ds.type.value, 0) + 1
        results["data_source_type_distribution"] = type_dist

        # 覆盖统计
        results["coverage_stats"] = {
            "total_expected_lineage": self.config.get_total_expected_lineage_count(),
            "annotation_coverage": len(self.config.get_tables_with_annotations()) / len(self.config.pilot_tables) if self.config.pilot_tables else 0,
            "high_priority_coverage": len(self.config.get_high_priority_tables()) / len(self.config.pilot_tables) if self.config.pilot_tables else 0,
        }

    def _print_summary(self, results: dict):
        """打印验证摘要"""
        logger.info("=" * 60)
        logger.info("试点配置验证摘要")
        logger.info("=" * 60)
        logger.info(f"验证状态: {'✅ 通过' if results['valid'] else '❌ 失败'}")
        logger.info(f"试点表总数: {results['tables_count']}")
        logger.info(f"数据源总数: {results['data_sources_count']}")
        logger.info(f"采集任务总数: {results['tasks_count']}")
        logger.info(f"人工标注总数: {results['annotations_count']}")
        logger.info("-" * 60)
        logger.info("优先级分布:")
        for priority, count in results["priority_distribution"].items():
            logger.info(f"  {priority}: {count} 表")
        logger.info("-" * 60)
        logger.info("业务域分布:")
        for domain, count in results["domain_distribution"].items():
            logger.info(f"  {domain}: {count} 表")
        logger.info("-" * 60)
        logger.info("覆盖统计:")
        logger.info(f"  总预期血缘数: {results['coverage_stats']['total_expected_lineage']}")
        logger.info(f"  标注覆盖率: {results['coverage_stats']['annotation_coverage']:.2%}")
        logger.info(f"  高优先级覆盖率: {results['coverage_stats']['high_priority_coverage']:.2%}")
        if results["errors"]:
            logger.info("-" * 60)
            logger.info(f"错误 ({len(results['errors'])}):")
            for error in results["errors"]:
                logger.info(f"  ❌ {error}")
        if results["warnings"]:
            logger.info("-" * 60)
            logger.info(f"警告 ({len(results['warnings'])}):")
            for warning in results["warnings"]:
                logger.info(f"  ⚠️ {warning}")
        logger.info("=" * 60)


def main():
    """主函数"""
    verifier = PilotConfigVerifier()
    results = verifier.verify()
    
    # 输出结果到文件
    output_file = Path(__file__).parent / "verify_results.json"
    with open(output_file, "w") as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    logger.info(f"验证结果已保存到: {output_file}")
    
    # 返回验证状态
    return 0 if results["valid"] else 1


if __name__ == "__main__":
    sys.exit(main())