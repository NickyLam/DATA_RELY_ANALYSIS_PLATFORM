"""
血缘验证服务
实现血缘准确性验证、对比人工标注血缘、计算准确率指标、生成验证报告
"""

import logging
import uuid
from dataclasses import dataclass, field
from datetime import datetime
from typing import Any, Dict, List, Optional, Set, Tuple

from app.config.pilot_tables import (
    ManualAnnotation,
    PilotTable,
    PilotTableConfig,
    TablePriority,
    get_cached_pilot_config,
)
from app.schemas.lineage import LineageEdge, LineageGraph, LineageNode
from app.schemas.validation_report import (
    AccuracyMetrics,
    CoverageMetrics,
    DataSourceValidationResult,
    ErrorDetail,
    ErrorSummary,
    ErrorType,
    LineageComparisonResult,
    SeverityLevel,
    TableValidationResult,
    ValidationProgress,
    ValidationReport,
    ValidationRequest,
    ValidationStatus,
)

logger = logging.getLogger(__name__)


@dataclass
class LineageMatch:
    """血缘匹配结果"""

    auto_lineage: Optional[LineageEdge] = None
    manual_annotation: Optional[ManualAnnotation] = None
    is_matched: bool = False
    match_type: str = "none"
    error_type: Optional[ErrorType] = None
    details: str = ""


@dataclass
class ValidatorConfig:
    """验证器配置"""

    accuracy_threshold: float = 0.85
    coverage_threshold: float = 0.80
    min_confidence: float = 0.5
    compare_transformation: bool = True
    compare_expression: bool = True
    transformation_match_threshold: float = 0.9
    expression_match_threshold: float = 0.8
    ignore_case: bool = True
    ignore_whitespace: bool = True
    max_errors_per_table: int = 100
    generate_recommendations: bool = True


class LineageValidator:
    """
    血缘验证服务

    实现血缘准确性验证，对比人工标注血缘，计算准确率指标，生成验证报告
    """

    def __init__(
        self,
        config: Optional[ValidatorConfig] = None,
        pilot_config: Optional[PilotTableConfig] = None,
    ):
        """
        初始化血缘验证器

        Args:
            config: 验证器配置
            pilot_config: 试点配置
        """
        self.config = config or ValidatorConfig()
        self.pilot_config = pilot_config or get_cached_pilot_config()
        self._validation_cache: Dict[str, ValidationReport] = {}
        self._progress_cache: Dict[str, ValidationProgress] = {}

    def validate_lineage(
        self,
        auto_lineages: List[LineageEdge],
        manual_annotations: List[ManualAnnotation],
        table_id: Optional[str] = None,
    ) -> Tuple[List[LineageMatch], AccuracyMetrics]:
        """
        验证血缘准确性

        Args:
            auto_lineages: 自动识别的血缘列表
            manual_annotations: 人工标注的血缘列表
            table_id: 表 ID（可选）

        Returns:
            Tuple[List[LineageMatch], AccuracyMetrics]: 匹配结果和准确率指标
        """
        matches: List[LineageMatch] = []
        matched_auto_indices: Set[int] = set()
        matched_manual_indices: Set[int] = set()

        for i, auto_lineage in enumerate(auto_lineages):
            best_match: Optional[LineageMatch] = None
            best_match_score = 0.0

            for j, manual_annotation in enumerate(manual_annotations):
                if j in matched_manual_indices:
                    continue

                match_result = self._compare_lineage(auto_lineage, manual_annotation)

                if match_result.is_matched:
                    match_score = self._calculate_match_score(match_result)

                    if match_score > best_match_score:
                        best_match = match_result
                        best_match_score = match_score
                        matched_manual_indices.add(j)

            if best_match:
                matched_auto_indices.add(i)
                matches.append(best_match)
            else:
                matches.append(
                    LineageMatch(
                        auto_lineage=auto_lineage,
                        is_matched=False,
                        match_type="extra",
                        error_type=ErrorType.EXTRA_LINEAGE,
                        details="自动识别的血缘未在人工标注中找到对应项",
                    )
                )

        for j, manual_annotation in enumerate(manual_annotations):
            if j not in matched_manual_indices:
                matches.append(
                    LineageMatch(
                        manual_annotation=manual_annotation,
                        is_matched=False,
                        match_type="missing",
                        error_type=ErrorType.MISSING_LINEAGE,
                        details="人工标注的血缘未在自动识别结果中找到",
                    )
                )

        metrics = self._calculate_accuracy_metrics(
            matches,
            len(auto_lineages),
            len(manual_annotations),
        )

        return matches, metrics

    def _compare_lineage(
        self,
        auto_lineage: LineageEdge,
        manual_annotation: ManualAnnotation,
    ) -> LineageMatch:
        """
        对比单个血缘

        Args:
            auto_lineage: 自动识别的血缘
            manual_annotation: 人工标注的血缘

        Returns:
            LineageMatch: 匹配结果
        """
        source_matched = self._compare_source(auto_lineage, manual_annotation)
        target_matched = self._compare_target(auto_lineage, manual_annotation)

        if not source_matched:
            return LineageMatch(
                auto_lineage=auto_lineage,
                manual_annotation=manual_annotation,
                is_matched=False,
                match_type="source_mismatch",
                error_type=ErrorType.WRONG_SOURCE,
                details=f"源表不匹配: 自动={auto_lineage.source_id}, 人工={manual_annotation.source_table_id}",
            )

        if not target_matched:
            return LineageMatch(
                auto_lineage=auto_lineage,
                manual_annotation=manual_annotation,
                is_matched=False,
                match_type="target_mismatch",
                error_type=ErrorType.WRONG_TARGET,
                details=f"目标表不匹配: 自动={auto_lineage.target_id}, 人工={manual_annotation.target_table_id}",
            )

        transformation_matched = True
        expression_matched = True
        error_type = None
        details = ""

        if self.config.compare_transformation:
            transformation_matched = self._compare_transformation(
                auto_lineage.transformation_type,
                manual_annotation.transformation_type,
            )
            if not transformation_matched:
                error_type = ErrorType.WRONG_TRANSFORMATION
                details = f"转换类型不匹配: 自动={auto_lineage.transformation_type}, 人工={manual_annotation.transformation_type}"

        if self.config.compare_expression and transformation_matched:
            expression_matched = self._compare_expression(
                auto_lineage.expression,
                manual_annotation.expression,
            )
            if not expression_matched:
                error_type = ErrorType.WRONG_EXPRESSION
                details = f"表达式不匹配: 自动={auto_lineage.expression}, 人工={manual_annotation.expression}"

        is_matched = source_matched and target_matched
        match_type = "full" if is_matched and transformation_matched and expression_matched else "partial"

        return LineageMatch(
            auto_lineage=auto_lineage,
            manual_annotation=manual_annotation,
            is_matched=is_matched,
            match_type=match_type,
            error_type=error_type,
            details=details,
        )

    def _compare_source(
        self,
        auto_lineage: LineageEdge,
        manual_annotation: ManualAnnotation,
    ) -> bool:
        """
        对比源表/字段

        Args:
            auto_lineage: 自动识别的血缘
            manual_annotation: 人工标注的血缘

        Returns:
            bool: 是否匹配
        """
        auto_source = auto_lineage.source_id
        manual_source = manual_annotation.source_table_id

        if self.config.ignore_case:
            auto_source = auto_source.lower()
            manual_source = manual_source.lower()

        if auto_source != manual_source:
            return False

        if manual_annotation.source_field_name and auto_lineage.properties:
            auto_field = auto_lineage.properties.get("source_field_name", "")
            manual_field = manual_annotation.source_field_name

            if self.config.ignore_case:
                auto_field = auto_field.lower()
                manual_field = manual_field.lower()

            if auto_field != manual_field:
                return False

        return True

    def _compare_target(
        self,
        auto_lineage: LineageEdge,
        manual_annotation: ManualAnnotation,
    ) -> bool:
        """
        对比目标表/字段

        Args:
            auto_lineage: 自动识别的血缘
            manual_annotation: 人工标注的血缘

        Returns:
            bool: 是否匹配
        """
        auto_target = auto_lineage.target_id
        manual_target = manual_annotation.target_table_id

        if self.config.ignore_case:
            auto_target = auto_target.lower()
            manual_target = manual_target.lower()

        if auto_target != manual_target:
            return False

        if manual_annotation.target_field_name and auto_lineage.properties:
            auto_field = auto_lineage.properties.get("target_field_name", "")
            manual_field = manual_annotation.target_field_name

            if self.config.ignore_case:
                auto_field = auto_field.lower()
                manual_field = manual_field.lower()

            if auto_field != manual_field:
                return False

        return True

    def _compare_transformation(
        self,
        auto_transformation: Optional[str],
        manual_transformation: Optional[str],
    ) -> bool:
        """
        对比转换类型

        Args:
            auto_transformation: 自动识别的转换类型
            manual_transformation: 人工标注的转换类型

        Returns:
            bool: 是否匹配
        """
        if auto_transformation is None and manual_transformation is None:
            return True

        if auto_transformation is None or manual_transformation is None:
            return False

        if self.config.ignore_case:
            auto_transformation = auto_transformation.lower()
            manual_transformation = manual_transformation.lower()

        return auto_transformation == manual_transformation

    def _compare_expression(
        self,
        auto_expression: Optional[str],
        manual_expression: Optional[str],
    ) -> bool:
        """
        对比表达式

        Args:
            auto_expression: 自动识别的表达式
            manual_expression: 人工标注的表达式

        Returns:
            bool: 是否匹配
        """
        if auto_expression is None and manual_expression is None:
            return True

        if auto_expression is None or manual_expression is None:
            return False

        if self.config.ignore_whitespace:
            auto_expression = self._normalize_expression(auto_expression)
            manual_expression = self._normalize_expression(manual_expression)

        if self.config.ignore_case:
            auto_expression = auto_expression.lower()
            manual_expression = manual_expression.lower()

        similarity = self._calculate_expression_similarity(auto_expression, manual_expression)

        return similarity >= self.config.expression_match_threshold

    def _normalize_expression(self, expression: str) -> str:
        """
        规范化表达式

        Args:
            expression: 表达式

        Returns:
            str: 规范化后的表达式
        """
        normalized = expression.strip()
        normalized = " ".join(normalized.split())
        return normalized

    def _calculate_expression_similarity(self, expr1: str, expr2: str) -> float:
        """
        计算表达式相似度

        Args:
            expr1: 表达式1
            expr2: 表达式2

        Returns:
            float: 相似度（0-1）
        """
        if expr1 == expr2:
            return 1.0

        words1 = set(expr1.split())
        words2 = set(expr2.split())

        if not words1 or not words2:
            return 0.0

        intersection = words1 & words2
        union = words1 | words2

        return len(intersection) / len(union)

    def _calculate_match_score(self, match: LineageMatch) -> float:
        """
        计算匹配得分

        Args:
            match: 匹配结果

        Returns:
            float: 匹配得分
        """
        if match.match_type == "full":
            return 1.0
        elif match.match_type == "partial":
            return 0.5
        return 0.0

    def _calculate_accuracy_metrics(
        self,
        matches: List[LineageMatch],
        auto_count: int,
        manual_count: int,
    ) -> AccuracyMetrics:
        """
        计算准确率指标

        Args:
            matches: 匹配结果列表
            auto_count: 自动识别血缘数量
            manual_count: 人工标注血缘数量

        Returns:
            AccuracyMetrics: 准确率指标
        """
        matched_count = sum(1 for m in matches if m.is_matched)
        extra_count = sum(1 for m in matches if m.match_type == "extra")
        missing_count = sum(1 for m in matches if m.match_type == "missing")

        accuracy_rate = matched_count / manual_count if manual_count > 0 else 0.0
        precision_rate = matched_count / auto_count if auto_count > 0 else 0.0
        recall_rate = matched_count / manual_count if manual_count > 0 else 0.0

        f1_score = 0.0
        if precision_rate + recall_rate > 0:
            f1_score = 2 * precision_rate * recall_rate / (precision_rate + recall_rate)

        transformation_matches = sum(
            1
            for m in matches
            if m.is_matched
            and m.auto_lineage
            and m.manual_annotation
            and self._compare_transformation(
                m.auto_lineage.transformation_type,
                m.manual_annotation.transformation_type,
            )
        )

        expression_matches = sum(
            1
            for m in matches
            if m.is_matched
            and m.auto_lineage
            and m.manual_annotation
            and self._compare_expression(
                m.auto_lineage.expression,
                m.manual_annotation.expression,
            )
        )

        transformation_accuracy = (
            transformation_matches / matched_count if matched_count > 0 else 0.0
        )
        expression_accuracy = expression_matches / matched_count if matched_count > 0 else 0.0

        return AccuracyMetrics(
            total_lineages=manual_count,
            matched_lineages=matched_count,
            unmatched_lineages=manual_count - matched_count,
            missing_lineages=missing_count,
            extra_lineages=extra_count,
            accuracy_rate=accuracy_rate,
            precision_rate=precision_rate,
            recall_rate=recall_rate,
            f1_score=f1_score,
            transformation_accuracy=transformation_accuracy,
            expression_accuracy=expression_accuracy,
        )

    def calculate_coverage_metrics(
        self,
        tables: List[PilotTable],
        lineage_graphs: Dict[str, LineageGraph],
    ) -> CoverageMetrics:
        """
        计算覆盖率指标

        Args:
            tables: 试点表列表
            lineage_graphs: 血缘图字典（按表 ID）

        Returns:
            CoverageMetrics: 覆盖率指标
        """
        total_tables = len(tables)
        covered_tables = 0
        high_priority_tables = 0
        high_priority_covered = 0
        total_expected_lineages = 0
        total_actual_lineages = 0

        for table in tables:
            expected_count = table.expected_lineage_count
            total_expected_lineages += expected_count

            graph = lineage_graphs.get(table.table_id)
            if graph:
                actual_count = len(graph.edges)
                total_actual_lineages += actual_count

                if actual_count > 0:
                    covered_tables += 1

            if table.priority == TablePriority.HIGH:
                high_priority_tables += 1
                if graph and len(graph.edges) > 0:
                    high_priority_covered += 1

        uncovered_tables = total_tables - covered_tables
        table_coverage_rate = covered_tables / total_tables if total_tables > 0 else 0.0
        high_priority_coverage = (
            high_priority_covered / high_priority_tables if high_priority_tables > 0 else 0.0
        )

        annotation_count = len(self.pilot_config.manual_annotations)
        annotation_coverage = annotation_count / total_expected_lineages if total_expected_lineages > 0 else 0.0

        return CoverageMetrics(
            total_tables=total_tables,
            covered_tables=covered_tables,
            uncovered_tables=uncovered_tables,
            total_fields=0,
            covered_fields=0,
            uncovered_fields=0,
            table_coverage_rate=table_coverage_rate,
            field_coverage_rate=0.0,
            high_priority_coverage=high_priority_coverage,
            annotation_coverage=annotation_coverage,
        )

    def generate_error_details(
        self,
        matches: List[LineageMatch],
        table_id: Optional[str] = None,
    ) -> List[ErrorDetail]:
        """
        生成错误详情列表

        Args:
            matches: 匹配结果列表
            table_id: 表 ID（可选）

        Returns:
            List[ErrorDetail]: 错误详情列表
        """
        errors: List[ErrorDetail] = []

        for i, match in enumerate(matches):
            if match.is_matched and match.match_type == "full":
                continue

            error_id = f"error_{uuid.uuid4().hex[:8]}_{i}"

            severity = self._determine_error_severity(match)

            description = match.details
            if not description:
                if match.match_type == "extra":
                    description = "自动识别的血缘未在人工标注中找到对应项"
                elif match.match_type == "missing":
                    description = "人工标注的血缘未在自动识别结果中找到"
                elif match.match_type == "partial":
                    description = "血缘部分匹配，存在差异"

            expected_value = None
            actual_value = None

            if match.error_type == ErrorType.WRONG_TRANSFORMATION:
                expected_value = (
                    match.manual_annotation.transformation_type if match.manual_annotation else None
                )
                actual_value = (
                    match.auto_lineage.transformation_type if match.auto_lineage else None
                )
            elif match.error_type == ErrorType.WRONG_EXPRESSION:
                expected_value = match.manual_annotation.expression if match.manual_annotation else None
                actual_value = match.auto_lineage.expression if match.auto_lineage else None

            suggestion = self._generate_error_suggestion(match)

            error = ErrorDetail(
                error_id=error_id,
                error_type=match.error_type or ErrorType.DATA_QUALITY,
                severity=severity,
                lineage_id=(
                    match.auto_lineage.source_id + "->" + match.auto_lineage.target_id
                    if match.auto_lineage
                    else None
                ),
                source_table_id=(
                    match.auto_lineage.source_id
                    if match.auto_lineage
                    else (match.manual_annotation.source_table_id if match.manual_annotation else None)
                ),
                target_table_id=(
                    match.auto_lineage.target_id
                    if match.auto_lineage
                    else (match.manual_annotation.target_table_id if match.manual_annotation else None)
                ),
                description=description,
                expected_value=expected_value,
                actual_value=actual_value,
                suggestion=suggestion,
            )

            errors.append(error)

        return errors[:self.config.max_errors_per_table]

    def _determine_error_severity(self, match: LineageMatch) -> SeverityLevel:
        """
        确定错误严重程度

        Args:
            match: 匹配结果

        Returns:
            SeverityLevel: 严重程度
        """
        if match.match_type == "missing":
            return SeverityLevel.HIGH
        elif match.match_type == "extra":
            return SeverityLevel.MEDIUM
        elif match.error_type == ErrorType.WRONG_SOURCE or match.error_type == ErrorType.WRONG_TARGET:
            return SeverityLevel.CRITICAL
        elif match.error_type == ErrorType.WRONG_TRANSFORMATION:
            return SeverityLevel.MEDIUM
        elif match.error_type == ErrorType.WRONG_EXPRESSION:
            return SeverityLevel.LOW
        return SeverityLevel.INFO

    def _generate_error_suggestion(self, match: LineageMatch) -> str:
        """
        生成错误修复建议

        Args:
            match: 匹配结果

        Returns:
            str: 修复建议
        """
        if match.match_type == "missing":
            return "建议检查采集配置，确保该血缘关系被正确采集"
        elif match.match_type == "extra":
            return "建议人工审核该血缘关系，确认是否为误识别"
        elif match.error_type == ErrorType.WRONG_SOURCE:
            return "建议检查源表识别逻辑，确保源表映射正确"
        elif match.error_type == ErrorType.WRONG_TARGET:
            return "建议检查目标表识别逻辑，确保目标表映射正确"
        elif match.error_type == ErrorType.WRONG_TRANSFORMATION:
            return "建议优化转换类型识别算法，提高转换类型识别准确率"
        elif match.error_type == ErrorType.WRONG_EXPRESSION:
            return "建议优化表达式解析逻辑，提高表达式识别准确率"
        return "建议人工审核并修正"

    def generate_error_summary(
        self,
        errors: List[ErrorDetail],
    ) -> ErrorSummary:
        """
        生成错误汇总

        Args:
            errors: 错误详情列表

        Returns:
            ErrorSummary: 错误汇总
        """
        total_errors = len(errors)
        critical_errors = sum(1 for e in errors if e.severity == SeverityLevel.CRITICAL)
        high_errors = sum(1 for e in errors if e.severity == SeverityLevel.HIGH)
        medium_errors = sum(1 for e in errors if e.severity == SeverityLevel.MEDIUM)
        low_errors = sum(1 for e in errors if e.severity == SeverityLevel.LOW)

        by_type: Dict[str, int] = {}
        for error in errors:
            error_type = error.error_type.value
            by_type[error_type] = by_type.get(error_type, 0) + 1

        by_table: Dict[str, int] = {}
        for error in errors:
            if error.source_table_id:
                by_table[error.source_table_id] = by_table.get(error.source_table_id, 0) + 1
            if error.target_table_id:
                by_table[error.target_table_id] = by_table.get(error.target_table_id, 0) + 1

        by_data_source: Dict[str, int] = {}
        for error in errors:
            if error.source_table_id:
                ds_id = error.source_table_id.split(":")[0] if ":" in error.source_table_id else "unknown"
                by_data_source[ds_id] = by_data_source.get(ds_id, 0) + 1

        return ErrorSummary(
            total_errors=total_errors,
            critical_errors=critical_errors,
            high_errors=high_errors,
            medium_errors=medium_errors,
            low_errors=low_errors,
            by_type=by_type,
            by_table=by_table,
            by_data_source=by_data_source,
        )

    def generate_recommendations(
        self,
        accuracy_metrics: AccuracyMetrics,
        coverage_metrics: CoverageMetrics,
        error_summary: ErrorSummary,
    ) -> List[str]:
        """
        生成改进建议

        Args:
            accuracy_metrics: 准确率指标
            coverage_metrics: 覆盖率指标
            error_summary: 错误汇总

        Returns:
            List[str]: 改进建议列表
        """
        recommendations: List[str] = []

        if accuracy_metrics.accuracy_rate < self.config.accuracy_threshold:
            gap = self.config.accuracy_threshold - accuracy_metrics.accuracy_rate
            recommendations.append(
                f"准确率低于阈值（当前 {accuracy_metrics.accuracy_rate:.2%}，目标 {self.config.accuracy_threshold:.2%}），"
                f"差距 {gap:.2%}，建议优化血缘识别算法"
            )

        if coverage_metrics.table_coverage_rate < self.config.coverage_threshold:
            gap = self.config.coverage_threshold - coverage_metrics.table_coverage_rate
            recommendations.append(
                f"表覆盖率低于阈值（当前 {coverage_metrics.table_coverage_rate:.2%}，目标 {self.config.coverage_threshold:.2%}），"
                f"差距 {gap:.2%}，建议扩展采集范围"
            )

        if error_summary.critical_errors > 0:
            recommendations.append(
                f"存在 {error_summary.critical_errors} 个严重错误，建议优先处理关键血缘识别问题"
            )

        if error_summary.missing_lineages > 0:
            recommendations.append(
                f"缺失 {accuracy_metrics.missing_lineages} 条血缘，建议检查采集配置和数据源连接"
            )

        if error_summary.extra_lineages > 0:
            recommendations.append(
                f"多余 {accuracy_metrics.extra_lineages} 条血缘，建议优化血缘过滤规则，减少误识别"
            )

        if accuracy_metrics.transformation_accuracy < 0.8:
            recommendations.append(
                f"转换类型准确率 {accuracy_metrics.transformation_accuracy:.2%}，建议增强转换类型识别能力"
            )

        if accuracy_metrics.expression_accuracy < 0.7:
            recommendations.append(
                f"表达式准确率 {accuracy_metrics.expression_accuracy:.2%}，建议优化 SQL 解析和表达式提取逻辑"
            )

        if coverage_metrics.high_priority_coverage < 0.9:
            recommendations.append(
                f"高优先级表覆盖率 {coverage_metrics.high_priority_coverage:.2%}，建议优先完成核心表的血缘采集"
            )

        if not recommendations:
            recommendations.append("验证结果良好，建议持续监控血缘质量并定期验证")

        return recommendations

    def create_validation_report(
        self,
        request: ValidationRequest,
        lineage_graphs: Dict[str, LineageGraph],
        validation_id: Optional[str] = None,
    ) -> ValidationReport:
        """
        创建验证报告

        Args:
            request: 验证请求
            lineage_graphs: 血缘图字典
            validation_id: 验证 ID（可选）

        Returns:
            ValidationReport: 验证报告
        """
        validation_id = validation_id or f"val_{uuid.uuid4().hex[:12]}"
        report_id = f"report_{uuid.uuid4().hex[:12]}"

        start_time = datetime.now()

        target_tables = self._get_target_tables(request)
        all_matches: List[LineageMatch] = []
        all_errors: List[ErrorDetail] = []
        table_results: List[TableValidationResult] = []
        data_source_results: List[DataSourceValidationResult] = []

        for table in target_tables:
            annotations = self.pilot_config.get_annotations_by_table(table.table_id)

            graph = lineage_graphs.get(table.table_id)
            auto_lineages = graph.edges if graph else []

            matches, metrics = self.validate_lineage(auto_lineages, annotations, table.table_id)
            all_matches.extend(matches)

            errors = self.generate_error_details(matches, table.table_id)
            all_errors.extend(errors)

            coverage_rate = len(auto_lineages) / table.expected_lineage_count if table.expected_lineage_count > 0 else 0.0

            table_result = TableValidationResult(
                table_id=table.table_id,
                table_name=table.table_name,
                schema_name=table.schema_name,
                data_source_id=table.data_source_id,
                expected_lineage_count=table.expected_lineage_count,
                actual_lineage_count=len(auto_lineages),
                matched_lineage_count=metrics.matched_lineages,
                accuracy_rate=metrics.accuracy_rate,
                coverage_rate=coverage_rate,
                error_count=len(errors),
                has_manual_annotation=table.has_manual_annotation,
                status=ValidationStatus.COMPLETED,
                errors=errors[:10],
            )
            table_results.append(table_result)

        data_source_ids = set(table.data_source_id for table in target_tables)
        for ds_id in data_source_ids:
            ds_tables = [t for t in target_tables if t.data_source_id == ds_id]
            ds_config = self.pilot_config.get_data_source_by_id(ds_id)

            ds_accuracy = sum(t.accuracy_rate for t in table_results if t.data_source_id == ds_id) / len(ds_tables) if ds_tables else 0.0
            ds_coverage = sum(t.coverage_rate for t in table_results if t.data_source_id == ds_id) / len(ds_tables) if ds_tables else 0.0
            ds_errors = sum(t.error_count for t in table_results if t.data_source_id == ds_id)

            ds_result = DataSourceValidationResult(
                data_source_id=ds_id,
                data_source_name=ds_config.name if ds_config else ds_id,
                total_tables=len(ds_tables),
                validated_tables=len(ds_tables),
                accuracy_rate=ds_accuracy,
                coverage_rate=ds_coverage,
                error_count=ds_errors,
                status=ValidationStatus.COMPLETED,
            )
            data_source_results.append(ds_result)

        total_auto = sum(len(graph.edges) if graph else 0 for graph in lineage_graphs.values())
        total_manual = len(self.pilot_config.manual_annotations)

        overall_accuracy = self._calculate_accuracy_metrics(all_matches, total_auto, total_manual)
        coverage_metrics = self.calculate_coverage_metrics(target_tables, lineage_graphs)
        error_summary = self.generate_error_summary(all_errors)

        lineage_comparisons = self._create_lineage_comparisons(all_matches)

        passed = (
            overall_accuracy.accuracy_rate >= request.threshold_accuracy
            and coverage_metrics.table_coverage_rate >= request.threshold_coverage
        )

        recommendations = []
        if request.generate_recommendations:
            recommendations = self.generate_recommendations(
                overall_accuracy,
                coverage_metrics,
                error_summary,
            )

        summary = self._generate_summary(
            overall_accuracy,
            coverage_metrics,
            error_summary,
            passed,
        )

        end_time = datetime.now()
        duration_seconds = (end_time - start_time).total_seconds()

        report = ValidationReport(
            report_id=report_id,
            report_name=request.validation_name or f"验证报告_{start_time.strftime('%Y%m%d_%H%M%S')}",
            validation_time=start_time,
            status=ValidationStatus.COMPLETED,
            duration_seconds=duration_seconds,
            accuracy_metrics=overall_accuracy,
            coverage_metrics=coverage_metrics,
            error_summary=error_summary,
            data_source_results=data_source_results,
            table_results=table_results,
            lineage_comparisons=lineage_comparisons,
            errors=all_errors[:100],
            passed=passed,
            threshold_accuracy=request.threshold_accuracy,
            threshold_coverage=request.threshold_coverage,
            summary=summary,
            recommendations=recommendations,
        )

        self._validation_cache[validation_id] = report

        return report

    def _get_target_tables(self, request: ValidationRequest) -> List[PilotTable]:
        """
        获取目标表列表

        Args:
            request: 验证请求

        Returns:
            List[PilotTable]: 目标表列表
        """
        if request.target_tables:
            tables = []
            for table_id in request.target_tables:
                table = self.pilot_config.get_table_by_id(table_id)
                if table:
                    tables.append(table)
            return tables

        if request.target_data_sources:
            tables = []
            for ds_id in request.target_data_sources:
                ds_tables = self.pilot_config.get_tables_by_data_source(ds_id)
                tables.extend(ds_tables)
            return tables

        return self.pilot_config.pilot_tables

    def _create_lineage_comparisons(
        self,
        matches: List[LineageMatch],
    ) -> List[LineageComparisonResult]:
        """
        创建血缘对比结果列表

        Args:
            matches: 匹配结果列表

        Returns:
            List[LineageComparisonResult]: 血缘对比结果列表
        """
        comparisons: List[LineageComparisonResult] = []

        for match in matches:
            lineage_id = ""
            source_table_id = ""
            source_field_name = None
            target_table_id = ""
            target_field_name = None

            if match.auto_lineage:
                lineage_id = f"{match.auto_lineage.source_id}->{match.auto_lineage.target_id}"
                source_table_id = match.auto_lineage.source_id
                target_table_id = match.auto_lineage.target_id
                if match.auto_lineage.properties:
                    source_field_name = match.auto_lineage.properties.get("source_field_name")
                    target_field_name = match.auto_lineage.properties.get("target_field_name")

            if match.manual_annotation:
                if not lineage_id:
                    lineage_id = f"{match.manual_annotation.source_table_id}->{match.manual_annotation.target_table_id}"
                if not source_table_id:
                    source_table_id = match.manual_annotation.source_table_id
                if not target_table_id:
                    target_table_id = match.manual_annotation.target_table_id
                source_field_name = match.manual_annotation.source_field_name
                target_field_name = match.manual_annotation.target_field_name

            comparison = LineageComparisonResult(
                lineage_id=lineage_id,
                source_table_id=source_table_id,
                source_field_name=source_field_name,
                target_table_id=target_table_id,
                target_field_name=target_field_name,
                is_matched=match.is_matched,
                auto_transformation_type=(
                    match.auto_lineage.transformation_type if match.auto_lineage else None
                ),
                manual_transformation_type=(
                    match.manual_annotation.transformation_type if match.manual_annotation else None
                ),
                auto_expression=match.auto_lineage.expression if match.auto_lineage else None,
                manual_expression=match.manual_annotation.expression if match.manual_annotation else None,
                auto_confidence=match.auto_lineage.confidence_score if match.auto_lineage else None,
                manual_confidence=match.manual_annotation.confidence if match.manual_annotation else None,
                error_type=match.error_type,
                severity=self._determine_error_severity(match),
                details=match.details,
            )

            comparisons.append(comparison)

        return comparisons

    def _generate_summary(
        self,
        accuracy_metrics: AccuracyMetrics,
        coverage_metrics: CoverageMetrics,
        error_summary: ErrorSummary,
        passed: bool,
    ) -> str:
        """
        生成验证摘要

        Args:
            accuracy_metrics: 准确率指标
            coverage_metrics: 覆盖率指标
            error_summary: 错误汇总
            passed: 是否通过

        Returns:
            str: 验证摘要
        """
        status = "通过" if passed else "未通过"

        summary = (
            f"验证结果：{status}\n"
            f"准确率：{accuracy_metrics.accuracy_rate:.2%}（匹配 {accuracy_metrics.matched_lineages}/{accuracy_metrics.total_lineages}）\n"
            f"精确率：{accuracy_metrics.precision_rate:.2%}\n"
            f"召回率：{accuracy_metrics.recall_rate:.2%}\n"
            f"F1分数：{accuracy_metrics.f1_score:.2%}\n"
            f"表覆盖率：{coverage_metrics.table_coverage_rate:.2%}（{coverage_metrics.covered_tables}/{coverage_metrics.total_tables}）\n"
            f"高优先级表覆盖率：{coverage_metrics.high_priority_coverage:.2%}\n"
            f"错误总数：{error_summary.total_errors}（严重 {error_summary.critical_errors}，高 {error_summary.high_errors}）\n"
            f"缺失血缘：{accuracy_metrics.missing_lineages}，多余血缘：{accuracy_metrics.extra_lineages}"
        )

        return summary

    def get_validation_progress(
        self,
        validation_id: str,
    ) -> Optional[ValidationProgress]:
        """
        获取验证进度

        Args:
            validation_id: 验证 ID

        Returns:
            Optional[ValidationProgress]: 验证进度
        """
        return self._progress_cache.get(validation_id)

    def get_cached_report(
        self,
        validation_id: str,
    ) -> Optional[ValidationReport]:
        """
        获取缓存的验证报告

        Args:
            validation_id: 验证 ID

        Returns:
            Optional[ValidationReport]: 验证报告
        """
        return self._validation_cache.get(validation_id)

    def clear_cache(self) -> None:
        """清空缓存"""
        self._validation_cache.clear()
        self._progress_cache.clear()
        logger.info("验证缓存已清空")

    def export_report(
        self,
        report: ValidationReport,
    ) -> Dict[str, Any]:
        """
        导出验证报告

        Args:
            report: 验证报告

        Returns:
            Dict[str, Any]: 报告数据
        """
        return report.model_dump()

    def batch_validate_tables(
        self,
        tables: List[PilotTable],
        lineage_graphs: Dict[str, LineageGraph],
    ) -> Dict[str, Tuple[AccuracyMetrics, List[ErrorDetail]]]:
        """
        批量验证表

        Args:
            tables: 表列表
            lineage_graphs: 血缘图字典

        Returns:
            Dict[str, Tuple[AccuracyMetrics, List[ErrorDetail]]]: 验证结果字典
        """
        results: Dict[str, Tuple[AccuracyMetrics, List[ErrorDetail]]] = {}

        for table in tables:
            annotations = self.pilot_config.get_annotations_by_table(table.table_id)
            graph = lineage_graphs.get(table.table_id)
            auto_lineages = graph.edges if graph else []

            matches, metrics = self.validate_lineage(auto_lineages, annotations, table.table_id)
            errors = self.generate_error_details(matches, table.table_id)

            results[table.table_id] = (metrics, errors)

        return results

    def get_statistics(self) -> Dict[str, Any]:
        """
        获取验证统计

        Returns:
            Dict[str, Any]: 统计信息
        """
        total_reports = len(self._validation_cache)
        passed_reports = sum(1 for r in self._validation_cache.values() if r.passed)

        avg_accuracy = 0.0
        avg_coverage = 0.0

        if total_reports > 0:
            avg_accuracy = sum(r.accuracy_metrics.accuracy_rate for r in self._validation_cache.values()) / total_reports
            avg_coverage = sum(r.coverage_metrics.table_coverage_rate for r in self._validation_cache.values()) / total_reports

        return {
            "total_reports": total_reports,
            "passed_reports": passed_reports,
            "failed_reports": total_reports - passed_reports,
            "average_accuracy": avg_accuracy,
            "average_coverage": avg_coverage,
            "pilot_tables_count": len(self.pilot_config.pilot_tables),
            "annotations_count": len(self.pilot_config.manual_annotations),
            "data_sources_count": len(self.pilot_config.data_sources),
        }