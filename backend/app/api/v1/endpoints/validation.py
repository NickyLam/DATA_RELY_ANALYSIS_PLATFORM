"""
验证 API 端点
提供血缘验证相关的 API 接口
"""

import logging
import uuid
from typing import Dict, List, Optional

from fastapi import APIRouter, BackgroundTasks, Depends, HTTPException, Query

from app.config.pilot_tables import get_cached_pilot_config
from app.schemas.lineage import LineageGraph
from app.schemas.validation_report import (
    ValidationHistory,
    ValidationProgress,
    ValidationReport,
    ValidationRequest,
    ValidationStatus,
    ValidationSummary,
)
from app.services.lineage_validator import LineageValidator, ValidatorConfig
from app.services.neo4j_lineage_service import Neo4jLineageService

logger = logging.getLogger(__name__)

router = APIRouter()

_validation_history: Dict[str, ValidationHistory] = {}
_active_validations: Dict[str, ValidationProgress] = {}


def get_validator() -> LineageValidator:
    """
    获取血缘验证器实例

    Returns:
        LineageValidator: 血缘验证器
    """
    return LineageValidator()


def get_lineage_service() -> Neo4jLineageService:
    """
    获取血缘服务实例

    Returns:
        Neo4jLineageService: 血缘服务
    """
    return Neo4jLineageService()


@router.post("/run", response_model=ValidationProgress)
async def run_validation(
    request: ValidationRequest,
    background_tasks: BackgroundTasks,
    validator: LineageValidator = Depends(get_validator),
    lineage_service: Neo4jLineageService = Depends(get_lineage_service),
):
    """
    执行血缘验证

    Args:
        request: 验证请求
        background_tasks: 后台任务
        validator: 血缘验证器
        lineage_service: 血缘服务

    Returns:
        ValidationProgress: 验证进度
    """
    validation_id = f"val_{uuid.uuid4().hex[:12]}"

    progress = ValidationProgress(
        validation_id=validation_id,
        status=ValidationStatus.PENDING,
        progress_percent=0.0,
        current_step="初始化验证",
        start_time=None,
    )

    _active_validations[validation_id] = progress

    background_tasks.add_task(
        _execute_validation_task,
        validation_id,
        request,
        validator,
        lineage_service,
    )

    return progress


async def _execute_validation_task(
    validation_id: str,
    request: ValidationRequest,
    validator: LineageValidator,
    lineage_service: Neo4jLineageService,
):
    """
    执行验证任务（后台）

    Args:
        validation_id: 验证 ID
        request: 验证请求
        validator: 血缘验证器
        lineage_service: 血缘服务
    """
    try:
        progress = _active_validations.get(validation_id)
        if not progress:
            return

        progress.status = ValidationStatus.RUNNING
        progress.start_time = None
        progress.current_step = "加载试点配置"

        pilot_config = get_cached_pilot_config()

        target_tables = validator._get_target_tables(request)
        progress.total_tables = len(target_tables)
        progress.processed_tables = 0

        lineage_graphs: Dict[str, LineageGraph] = {}

        for i, table in enumerate(target_tables):
            progress.current_step = f"采集血缘: {table.table_name}"
            progress.processed_tables = i + 1
            progress.progress_percent = (i + 1) / len(target_tables) * 80

            try:
                graph = await lineage_service.get_table_lineage(
                    table_id=table.table_id,
                    depth=5,
                    direction="upstream",
                )
                lineage_graphs[table.table_id] = graph
            except Exception as e:
                logger.warning(f"获取表 {table.table_id} 血缘失败: {e}")
                lineage_graphs[table.table_id] = LineageGraph(
                    nodes=[],
                    edges=[],
                    total_nodes=0,
                    total_edges=0,
                )

        progress.current_step = "生成验证报告"
        progress.progress_percent = 90

        report = validator.create_validation_report(
            request=request,
            lineage_graphs=lineage_graphs,
            validation_id=validation_id,
        )

        progress.current_step = "完成"
        progress.progress_percent = 100.0
        progress.status = ValidationStatus.COMPLETED

        history_id = "history_main"
        if history_id not in _validation_history:
            _validation_history[history_id] = ValidationHistory(
                history_id=history_id,
                reports=[],
            )

        history = _validation_history[history_id]
        history.reports.append(report)
        history.updated_at = None

        summary = _calculate_validation_summary(history.reports)
        history.summary = summary

    except Exception as e:
        logger.error(f"验证任务执行失败: {e}")

        progress = _active_validations.get(validation_id)
        if progress:
            progress.status = ValidationStatus.FAILED
            progress.error_message = str(e)
            progress.progress_percent = 0.0


def _calculate_validation_summary(reports: List[ValidationReport]) -> ValidationSummary:
    """
    计算验证摘要

    Args:
        reports: 报告列表

    Returns:
        ValidationSummary: 验证摘要
    """
    if not reports:
        return ValidationSummary()

    total_validations = len(reports)
    passed_validations = sum(1 for r in reports if r.passed)
    failed_validations = total_validations - passed_validations

    accuracies = [r.accuracy_metrics.accuracy_rate for r in reports]
    coverages = [r.coverage_metrics.table_coverage_rate for r in reports]

    average_accuracy = sum(accuracies) / total_validations
    average_coverage = sum(coverages) / total_validations
    best_accuracy = max(accuracies)
    worst_accuracy = min(accuracies)

    trend = "稳定"
    if len(reports) >= 3:
        recent_accuracies = accuracies[-3:]
        if recent_accuracies[2] > recent_accuracies[0]:
            trend = "上升"
        elif recent_accuracies[2] < recent_accuracies[0]:
            trend = "下降"

    last_validation_time = reports[-1].validation_time if reports else None

    return ValidationSummary(
        total_validations=total_validations,
        passed_validations=passed_validations,
        failed_validations=failed_validations,
        average_accuracy=average_accuracy,
        average_coverage=average_coverage,
        best_accuracy=best_accuracy,
        worst_accuracy=worst_accuracy,
        trend=trend,
        last_validation_time=last_validation_time,
    )


@router.get("/progress/{validation_id}", response_model=ValidationProgress)
async def get_validation_progress(
    validation_id: str,
):
    """
    获取验证进度

    Args:
        validation_id: 验证 ID

    Returns:
        ValidationProgress: 验证进度
    """
    progress = _active_validations.get(validation_id)

    if not progress:
        raise HTTPException(status_code=404, detail="验证任务不存在")

    return progress


@router.get("/report/{validation_id}", response_model=ValidationReport)
async def get_validation_report(
    validation_id: str,
    validator: LineageValidator = Depends(get_validator),
):
    """
    获取验证报告

    Args:
        validation_id: 验证 ID
        validator: 血缘验证器

    Returns:
        ValidationReport: 验证报告
    """
    report = validator.get_cached_report(validation_id)

    if not report:
        for history in _validation_history.values():
            for r in history.reports:
                if r.report_id == validation_id or validation_id in r.report_id:
                    report = r
                    break

    if not report:
        raise HTTPException(status_code=404, detail="验证报告不存在")

    return report


@router.get("/report/latest", response_model=Optional[ValidationReport])
async def get_latest_report():
    """
    获取最新验证报告

    Returns:
        Optional[ValidationReport]: 最新验证报告
    """
    history_id = "history_main"
    history = _validation_history.get(history_id)

    if not history or not history.reports:
        return None

    return history.reports[-1]


@router.get("/history", response_model=ValidationHistory)
async def get_validation_history(
    limit: int = Query(10, ge=1, le=100, description="返回报告数量限制"),
):
    """
    获取验证历史

    Args:
        limit: 返回报告数量限制

    Returns:
        ValidationHistory: 验证历史
    """
    history_id = "history_main"
    history = _validation_history.get(history_id)

    if not history:
        return ValidationHistory(
            history_id=history_id,
            reports=[],
        )

    limited_reports = history.reports[-limit:]
    summary = _calculate_validation_summary(history.reports)

    return ValidationHistory(
        history_id=history_id,
        reports=limited_reports,
        summary=summary,
    )


@router.get("/summary", response_model=ValidationSummary)
async def get_validation_summary():
    """
    获取验证摘要

    Returns:
        ValidationSummary: 验证摘要
    """
    history_id = "history_main"
    history = _validation_history.get(history_id)

    if not history or not history.reports:
        return ValidationSummary()

    return _calculate_validation_summary(history.reports)


@router.get("/statistics")
async def get_validation_statistics(
    validator: LineageValidator = Depends(get_validator),
):
    """
    获取验证统计

    Args:
        validator: 血缘验证器

    Returns:
        Dict: 统计信息
    """
    return validator.get_statistics()


@router.delete("/report/{validation_id}")
async def delete_validation_report(
    validation_id: str,
    validator: LineageValidator = Depends(get_validator),
):
    """
    删除验证报告

    Args:
        validation_id: 验证 ID
        validator: 血缘验证器

    Returns:
        Dict: 删除结果
    """
    report = validator.get_cached_report(validation_id)

    if report:
        validator._validation_cache.pop(validation_id, None)

    for history in _validation_history.values():
        history.reports = [r for r in history.reports if r.report_id != validation_id]
        history.summary = _calculate_validation_summary(history.reports)

    if validation_id in _active_validations:
        _active_validations.pop(validation_id)

    return {"message": "验证报告已删除", "validation_id": validation_id}


@router.post("/clear-cache")
async def clear_validation_cache(
    validator: LineageValidator = Depends(get_validator),
):
    """
    清空验证缓存

    Args:
        validator: 血缘验证器

    Returns:
        Dict: 清空结果
    """
    validator.clear_cache()
    _active_validations.clear()

    return {"message": "验证缓存已清空"}