"""
解析相关 API 接口
文件上传、任务状态查询、SSE 进度推送

遵循 FastAPI 最佳实践:
  - 使用 Annotated 类型别名声明依赖
  - 同步服务调用使用 def（非 async def）
  - SSE 端点使用 async def（因其为异步生成器）
"""

from __future__ import annotations

import logging
from typing import Annotated, Optional

from fastapi import APIRouter, File, Form, HTTPException, Query, UploadFile
from fastapi.responses import StreamingResponse

from app.dependencies import (
    LineageServiceDep,
    ParserServiceDep,
    ProgressServiceDep,
)
from app.models import (
    BaseResponse,
    FileUploadData,
    FileUploadResponse,
    ParseMode,
    ParseStatus,
)
from app.services.progress_service import TaskStatus
from app.utils.file_handler import FileHandler

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/parse", tags=["解析管理"])


@router.post(
    "/upload",
    response_model=FileUploadResponse,
    summary="上传文件并启动解析任务",
    description="支持批量上传 .tab/.prc 文件，返回任务ID用于查询进度",
)
async def upload_files(
    files: list[UploadFile] = File(description="上传的文件列表"),
    parse_mode: ParseMode = Form(default=ParseMode.INCREMENTAL, description="解析模式"),
    schema_name: Annotated[Optional[str], Form(description="Schema名称")] = None,
    parser_service: ParserServiceDep = None,
    progress_service: ProgressServiceDep = None,
) -> FileUploadResponse:
    if not files:
        raise HTTPException(status_code=400, detail="请至少上传一个文件")

    task = progress_service.create_task(files_count=len(files))
    saved_paths = []
    errors = []

    for uploaded_file in files:
        is_valid, error_msg = FileHandler.validate_file(uploaded_file)
        if not is_valid:
            errors.append(f"{uploaded_file.filename}: {error_msg}")
            continue

        save_path, save_error = await FileHandler.save_upload(uploaded_file, task.task_id)
        if save_error:
            errors.append(f"{uploaded_file.filename}: {save_error}")
        else:
            saved_paths.append(save_path)

    if not saved_paths and errors:
        progress_service.fail_task(task.task_id, "; ".join(errors[:3]))
        raise HTTPException(status_code=400, detail=f"所有文件上传失败: {'; '.join(errors[:3])}")

    estimated_time = len(saved_paths) * 0.5
    progress_service.start_task(task.task_id)

    def run_parse_task():
        try:
            def on_progress(percent, current_file, message, **stats):
                progress_service.update_progress(
                    task.task_id,
                    percent=percent,
                    current_file=current_file or "",
                    message=message,
                    tables_parsed=stats.get("tables_parsed", 0),
                    procedures_parsed=stats.get("procedures_parsed", 0),
                    lineages_found=stats.get("lineages_found", 0),
                )

            result = parser_service.parse_uploaded_files(
                file_paths=saved_paths,
                mode=parse_mode.value,
                progress_callback=on_progress,
            )

            if result.errors:
                progress_service.update_progress(
                    task.task_id,
                    percent=98,
                    level="warning",
                    message=f"解析完成，{len(result.errors)} 个警告",
                    errors=result.errors[-5:],
                )

            final_result = result.to_dict()
            progress_service.complete_task(task.task_id, result=final_result)

            logger.info("任务 %s 完成: %s", task.task_id, final_result)

        except Exception as e:
            logger.error("任务 %s 执行失败: %s", task.task_id, e, exc_info=True)
            progress_service.fail_task(task.task_id, str(e))

    import threading
    parse_thread = threading.Thread(target=run_parse_task, daemon=True)
    parse_thread.start()

    return FileUploadResponse(
        success=True,
        message=f"已接收 {len(saved_paths)} 个文件，开始异步解析",
        data=FileUploadData(
            task_id=task.task_id,
            status=ParseStatus.PROCESSING,
            files_received=len(saved_paths),
            estimated_time_sec=round(estimated_time, 2),
        ),
    )


@router.get(
    "/progress/{task_id}",
    summary="SSE 实时进度推送",
    description="通过 Server-Sent Events 接收解析任务的实时进度更新",
    responses={
        200: {
            "description": "SSE 事件流",
            "content": {"text/event-stream": {}},
        },
    },
)
async def get_progress(
    task_id: str,
    progress_service: ProgressServiceDep,
):
    task = progress_service.get_task(task_id)

    if not task:
        raise HTTPException(status_code=404, detail=f"任务不存在: {task_id}")

    return StreamingResponse(
        progress_service.generate_sse_events(task_id),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no",
        },
    )


@router.get(
    "/tasks/{task_id}",
    summary="查询任务状态",
    description="获取指定任务的当前状态和结果（非实时）",
)
def get_task_status(
    task_id: str,
    progress_service: ProgressServiceDep,
) -> dict:
    task = progress_service.get_task(task_id)

    if not task:
        raise HTTPException(status_code=404, detail=f"任务不存在: {task_id}")

    return {
        "success": True,
        "data": {
            "task_id": task.task_id,
            "status": task.status.value,
            "progress": {
                "percent": round(task.progress.percent, 2),
                "current_file": task.progress.current_file,
                "message": task.progress.message,
                "tables_parsed": task.progress.tables_parsed,
                "procedures_parsed": task.progress.procedures_parsed,
                "lineages_found": task.progress.lineages_found,
                "errors": task.progress.errors[-10:] if task.progress.errors else [],
            },
            "result": task.result,
            "error": task.error,
            "created_at": task.created_at,
            "updated_at": task.updated_at,
        },
    }


@router.get(
    "/tasks",
    summary="列出所有任务",
    description="获取最近的任务列表（分页）",
)
def list_tasks(
    progress_service: ProgressServiceDep,
    limit: Annotated[int, Query(ge=1, le=100)] = 20,
    status: Annotated[Optional[str], Query(description="任务状态筛选")] = None,
) -> dict:
    all_tasks_info = progress_service.list_tasks(limit=None, status=status)
    paginated = all_tasks_info[:limit]

    return {
        "success": True,
        "data": {
            "tasks": paginated,
            "total": len(all_tasks_info),
            "limit": limit,
        },
    }


@router.post(
    "/parse-existing",
    summary="触发全量解析",
    description="重新解析 RRP_ORACLE 目录下的所有现有文件",
)
def trigger_full_parse(
    parser_service: ParserServiceDep,
    progress_service: ProgressServiceDep,
) -> dict:
    task = progress_service.create_task(files_count=0)
    progress_service.start_task(task.task_id)

    def run_full_parse():
        try:
            progress_service.update_progress(
                task.task_id,
                percent=10,
                message="开始扫描数据目录...",
            )

            result = parser_service.parse_existing_data()

            progress_service.complete_task(task.task_id, result=result.to_dict())
            logger.info("全量解析任务 %s 完成", task.task_id)

        except Exception as e:
            logger.error("全量解析失败: %s", e, exc_info=True)
            progress_service.fail_task(task.task_id, str(e))

    import threading
    thread = threading.Thread(target=run_full_parse, daemon=True)
    thread.start()

    return {
        "success": True,
        "message": "全量解析任务已启动",
        "data": {
            "task_id": task.task_id,
            "status": "processing",
        },
    }
