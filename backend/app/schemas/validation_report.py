"""
验证报告 Schema
定义验证报告数据模型，包含准确率、覆盖率、错误详情
"""

from datetime import datetime
from enum import Enum
from typing import Any, Dict, List, Optional

from pydantic import BaseModel, Field


class ValidationStatus(str, Enum):
    """验证状态枚举"""

    PENDING = "pending"
    RUNNING = "running"
    COMPLETED = "completed"
    FAILED = "failed"
    PARTIAL = "partial"


class ErrorType(str, Enum):
    """错误类型枚举"""

    MISSING_LINEAGE = "missing_lineage"
    EXTRA_LINEAGE = "extra_lineage"
    WRONG_SOURCE = "wrong_source"
    WRONG_TARGET = "wrong_target"
    WRONG_TRANSFORMATION = "wrong_transformation"
    WRONG_EXPRESSION = "wrong_expression"
    LOW_CONFIDENCE = "low_confidence"
    DATA_QUALITY = "data_quality"


class SeverityLevel(str, Enum):
    """严重程度枚举"""

    CRITICAL = "critical"
    HIGH = "high"
    MEDIUM = "medium"
    LOW = "low"
    INFO = "info"


class LineageComparisonResult(BaseModel):
    """血缘对比结果"""

    lineage_id: str = Field(..., description="血缘 ID")
    source_table_id: str = Field(..., description="源表 ID")
    source_field_name: Optional[str] = Field(None, description="源字段名")
    target_table_id: str = Field(..., description="目标表 ID")
    target_field_name: Optional[str] = Field(None, description="目标字段名")
    is_matched: bool = Field(..., description="是否匹配")
    auto_transformation_type: Optional[str] = Field(None, description="自动识别的转换类型")
    manual_transformation_type: Optional[str] = Field(None, description="人工标注的转换类型")
    auto_expression: Optional[str] = Field(None, description="自动识别的表达式")
    manual_expression: Optional[str] = Field(None, description="人工标注的表达式")
    auto_confidence: Optional[float] = Field(None, description="自动识别的置信度")
    manual_confidence: Optional[float] = Field(None, description="人工标注的置信度")
    error_type: Optional[ErrorType] = Field(None, description="错误类型")
    severity: SeverityLevel = Field(SeverityLevel.INFO, description="严重程度")
    details: Optional[str] = Field(None, description="详细说明")


class AccuracyMetrics(BaseModel):
    """准确率指标"""

    total_lineages: int = Field(0, description="总血缘数量")
    matched_lineages: int = Field(0, description="匹配的血缘数量")
    unmatched_lineages: int = Field(0, description="不匹配的血缘数量")
    missing_lineages: int = Field(0, description="缺失的血缘数量")
    extra_lineages: int = Field(0, description="多余的血缘数量")
    accuracy_rate: float = Field(0.0, ge=0.0, le=1.0, description="准确率")
    precision_rate: float = Field(0.0, ge=0.0, le=1.0, description="精确率")
    recall_rate: float = Field(0.0, ge=0.0, le=1.0, description="召回率")
    f1_score: float = Field(0.0, ge=0.0, le=1.0, description="F1 分数")
    transformation_accuracy: float = Field(0.0, ge=0.0, le=1.0, description="转换类型准确率")
    expression_accuracy: float = Field(0.0, ge=0.0, le=1.0, description="表达式准确率")


class CoverageMetrics(BaseModel):
    """覆盖率指标"""

    total_tables: int = Field(0, description="总表数量")
    covered_tables: int = Field(0, description="有血缘的表数量")
    uncovered_tables: int = Field(0, description="无血缘的表数量")
    total_fields: int = Field(0, description="总字段数量")
    covered_fields: int = Field(0, description="有血缘的字段数量")
    uncovered_fields: int = Field(0, description="无血缘的字段数量")
    table_coverage_rate: float = Field(0.0, ge=0.0, le=1.0, description="表覆盖率")
    field_coverage_rate: float = Field(0.0, ge=0.0, le=1.0, description="字段覆盖率")
    high_priority_coverage: float = Field(0.0, ge=0.0, le=1.0, description="高优先级表覆盖率")
    annotation_coverage: float = Field(0.0, ge=0.0, le=1.0, description="标注覆盖率")


class ErrorDetail(BaseModel):
    """错误详情"""

    error_id: str = Field(..., description="错误 ID")
    error_type: ErrorType = Field(..., description="错误类型")
    severity: SeverityLevel = Field(..., description="严重程度")
    lineage_id: Optional[str] = Field(None, description="血缘 ID")
    source_table_id: Optional[str] = Field(None, description="源表 ID")
    target_table_id: Optional[str] = Field(None, description="目标表 ID")
    description: str = Field(..., description="错误描述")
    expected_value: Optional[str] = Field(None, description="期望值")
    actual_value: Optional[str] = Field(None, description="实际值")
    suggestion: Optional[str] = Field(None, description="修复建议")
    timestamp: datetime = Field(default_factory=datetime.now, description="时间戳")


class ErrorSummary(BaseModel):
    """错误汇总"""

    total_errors: int = Field(0, description="总错误数")
    critical_errors: int = Field(0, description="严重错误数")
    high_errors: int = Field(0, description="高严重度错误数")
    medium_errors: int = Field(0, description="中等严重度错误数")
    low_errors: int = Field(0, description="低严重度错误数")
    by_type: Dict[str, int] = Field(default_factory=dict, description="按类型统计")
    by_table: Dict[str, int] = Field(default_factory=dict, description="按表统计")
    by_data_source: Dict[str, int] = Field(default_factory=dict, description="按数据源统计")


class DataSourceValidationResult(BaseModel):
    """数据源验证结果"""

    data_source_id: str = Field(..., description="数据源 ID")
    data_source_name: str = Field(..., description="数据源名称")
    total_tables: int = Field(0, description="总表数量")
    validated_tables: int = Field(0, description="已验证表数量")
    accuracy_rate: float = Field(0.0, ge=0.0, le=1.0, description="准确率")
    coverage_rate: float = Field(0.0, ge=0.0, le=1.0, description="覆盖率")
    error_count: int = Field(0, description="错误数量")
    status: ValidationStatus = Field(ValidationStatus.PENDING, description="验证状态")


class TableValidationResult(BaseModel):
    """表验证结果"""

    table_id: str = Field(..., description="表 ID")
    table_name: str = Field(..., description="表名称")
    schema_name: str = Field(..., description="Schema 名称")
    data_source_id: str = Field(..., description="数据源 ID")
    expected_lineage_count: int = Field(0, description="预期血缘数量")
    actual_lineage_count: int = Field(0, description="实际血缘数量")
    matched_lineage_count: int = Field(0, description="匹配血缘数量")
    accuracy_rate: float = Field(0.0, ge=0.0, le=1.0, description="准确率")
    coverage_rate: float = Field(0.0, ge=0.0, le=1.0, description="覆盖率")
    error_count: int = Field(0, description="错误数量")
    has_manual_annotation: bool = Field(False, description="是否有人工标注")
    status: ValidationStatus = Field(ValidationStatus.PENDING, description="验证状态")
    errors: List[ErrorDetail] = Field(default_factory=list, description="错误列表")


class ValidationReport(BaseModel):
    """验证报告"""

    report_id: str = Field(..., description="报告 ID")
    report_name: str = Field(..., description="报告名称")
    validation_time: datetime = Field(default_factory=datetime.now, description="验证时间")
    status: ValidationStatus = Field(ValidationStatus.PENDING, description="验证状态")
    duration_seconds: float = Field(0.0, description="验证耗时（秒）")
    accuracy_metrics: AccuracyMetrics = Field(
        default_factory=AccuracyMetrics, description="准确率指标"
    )
    coverage_metrics: CoverageMetrics = Field(
        default_factory=CoverageMetrics, description="覆盖率指标"
    )
    error_summary: ErrorSummary = Field(default_factory=ErrorSummary, description="错误汇总")
    data_source_results: List[DataSourceValidationResult] = Field(
        default_factory=list, description="数据源验证结果"
    )
    table_results: List[TableValidationResult] = Field(
        default_factory=list, description="表验证结果"
    )
    lineage_comparisons: List[LineageComparisonResult] = Field(
        default_factory=list, description="血缘对比结果"
    )
    errors: List[ErrorDetail] = Field(default_factory=list, description="错误详情列表")
    passed: bool = Field(False, description="是否通过验证")
    threshold_accuracy: float = Field(0.85, description="准确率阈值")
    threshold_coverage: float = Field(0.80, description="覆盖率阈值")
    summary: Optional[str] = Field(None, description="验证摘要")
    recommendations: List[str] = Field(default_factory=list, description="改进建议")
    metadata: Dict[str, Any] = Field(default_factory=dict, description="元数据")


class ValidationRequest(BaseModel):
    """验证请求"""

    validation_name: Optional[str] = Field(None, description="验证名称")
    target_tables: Optional[List[str]] = Field(None, description="目标表列表（可选）")
    target_data_sources: Optional[List[str]] = Field(None, description="目标数据源列表（可选）")
    include_field_lineage: bool = Field(False, description="是否包含字段级血缘")
    threshold_accuracy: float = Field(0.85, ge=0.0, le=1.0, description="准确率阈值")
    threshold_coverage: float = Field(0.80, ge=0.0, le=1.0, description="覆盖率阈值")
    min_confidence: float = Field(0.5, ge=0.0, le=1.0, description="最小置信度")
    compare_transformation: bool = Field(True, description="是否对比转换类型")
    compare_expression: bool = Field(True, description="是否对比表达式")
    generate_recommendations: bool = Field(True, description="是否生成改进建议")


class ValidationProgress(BaseModel):
    """验证进度"""

    validation_id: str = Field(..., description="验证 ID")
    status: ValidationStatus = Field(ValidationStatus.PENDING, description="验证状态")
    progress_percent: float = Field(0.0, ge=0.0, le=100.0, description="进度百分比")
    current_step: Optional[str] = Field(None, description="当前步骤")
    total_tables: int = Field(0, description="总表数量")
    processed_tables: int = Field(0, description="已处理表数量")
    total_lineages: int = Field(0, description="总血缘数量")
    processed_lineages: int = Field(0, description="已处理血缘数量")
    start_time: Optional[datetime] = Field(None, description="开始时间")
    estimated_end_time: Optional[datetime] = Field(None, description="预计结束时间")
    error_message: Optional[str] = Field(None, description="错误信息")


class ValidationSummary(BaseModel):
    """验证摘要"""

    total_validations: int = Field(0, description="总验证次数")
    passed_validations: int = Field(0, description="通过验证次数")
    failed_validations: int = Field(0, description="失败验证次数")
    average_accuracy: float = Field(0.0, description="平均准确率")
    average_coverage: float = Field(0.0, description="平均覆盖率")
    best_accuracy: float = Field(0.0, description="最佳准确率")
    worst_accuracy: float = Field(0.0, description="最差准确率")
    trend: Optional[str] = Field(None, description="趋势分析")
    last_validation_time: Optional[datetime] = Field(None, description="最后验证时间")


class ValidationHistory(BaseModel):
    """验证历史"""

    history_id: str = Field(..., description="历史 ID")
    reports: List[ValidationReport] = Field(default_factory=list, description="报告列表")
    summary: ValidationSummary = Field(default_factory=ValidationSummary, description="验证摘要")
    created_at: datetime = Field(default_factory=datetime.now, description="创建时间")
    updated_at: datetime = Field(default_factory=datetime.now, description="更新时间")