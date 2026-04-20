"""
采集任务管理 API
"""
from typing import List, Optional
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks, Query
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.schemas.data_source import DataSourceResponse

router = APIRouter()


class CollectTaskCreate(BaseModel):
    """创建采集任务请求"""
    data_source_id: str
    task_type: str
    target_schemas: Optional[List[str]] = None
    target_tables: Optional[List[str]] = None
    include_plsql: bool = True
    include_runtime: bool = False


class CollectTaskResponse(BaseModel):
    """采集任务响应"""
    task_id: str
    data_source_id: str
    task_type: str
    status: str
    created_at: datetime
    started_at: Optional[datetime] = None
    completed_at: Optional[datetime] = None
    total_count: int = 0
    success_count: int = 0
    error_count: int = 0
    error_message: Optional[str] = None


class CollectLogEntry(BaseModel):
    """采集日志条目"""
    timestamp: datetime
    level: str
    message: str
    details: Optional[dict] = None


@router.post("/tasks", response_model=CollectTaskResponse)
async def create_collect_task(
    task: CollectTaskCreate,
    background_tasks: BackgroundTasks,
    db: AsyncSession = Depends(get_db),
):
    """
    创建采集任务
    
    task_type 可选值:
    - metadata: 元数据采集（表、列、约束）
    - plsql: PL/SQL 源码采集
    - runtime: 运行时血缘采集
    - full: 全量采集
    """
    task_id = f"task-{datetime.now().strftime('%Y%m%d%H%M%S')}"
    
    return CollectTaskResponse(
        task_id=task_id,
        data_source_id=task.data_source_id,
        task_type=task.task_type,
        status="pending",
        created_at=datetime.now(),
    )


@router.get("/tasks", response_model=List[CollectTaskResponse])
async def list_collect_tasks(
    data_source_id: Optional[str] = Query(None, description="数据源ID过滤"),
    status: Optional[str] = Query(None, description="状态过滤"),
    limit: int = Query(20, ge=1, le=100),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
):
    """
    获取采集任务列表
    
    status 可选值: pending, running, completed, failed
    """
    return []


@router.get("/tasks/{task_id}", response_model=CollectTaskResponse)
async def get_collect_task(
    task_id: str,
    db: AsyncSession = Depends(get_db),
):
    """
    获取采集任务详情
    """
    raise HTTPException(status_code=404, detail="Task not found")


@router.post("/tasks/{task_id}/run", response_model=CollectTaskResponse)
async def run_collect_task(
    task_id: str,
    background_tasks: BackgroundTasks,
    db: AsyncSession = Depends(get_db),
):
    """
    执行采集任务
    """
    raise HTTPException(status_code=404, detail="Task not found")


@router.get("/tasks/{task_id}/log", response_model=List[CollectLogEntry])
async def get_collect_task_log(
    task_id: str,
    level: Optional[str] = Query(None, description="日志级别过滤"),
    limit: int = Query(100, ge=1, le=500),
    db: AsyncSession = Depends(get_db),
):
    """
    获取采集任务日志
    
    level 可选值: info, warning, error
    """
    raise HTTPException(status_code=404, detail="Task not found")


@router.delete("/tasks/{task_id}")
async def cancel_collect_task(
    task_id: str,
    db: AsyncSession = Depends(get_db),
):
    """
    取消采集任务
    """
    raise HTTPException(status_code=404, detail="Task not found")


@router.get("/stats")
async def get_collect_stats(
    data_source_id: Optional[str] = Query(None, description="数据源ID"),
    db: AsyncSession = Depends(get_db),
):
    """
    获取采集统计信息
    """
    return {
        "total_tasks": 0,
        "running_tasks": 0,
        "completed_tasks": 0,
        "failed_tasks": 0,
        "tables_collected": 0,
        "columns_collected": 0,
        "lineages_extracted": 0,
    }