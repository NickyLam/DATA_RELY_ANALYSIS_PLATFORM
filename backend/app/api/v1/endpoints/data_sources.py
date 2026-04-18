"""
数据源管理 API
"""
from typing import List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.schemas.data_source import DataSourceCreate, DataSourceResponse, DataSourceUpdate

router = APIRouter()


@router.get("/", response_model=List[DataSourceResponse])
async def list_data_sources(
    db: AsyncSession = Depends(get_db),
):
    """
    获取所有数据源
    """
    # TODO: 实现查询逻辑
    return []


@router.post("/", response_model=DataSourceResponse)
async def create_data_source(
    data_source: DataSourceCreate,
    db: AsyncSession = Depends(get_db),
):
    """
    创建数据源
    """
    # TODO: 实现创建逻辑
    return data_source


@router.get("/{data_source_id}", response_model=DataSourceResponse)
async def get_data_source(
    data_source_id: str,
    db: AsyncSession = Depends(get_db),
):
    """
    获取数据源详情
    """
    # TODO: 实现查询逻辑
    raise HTTPException(status_code=404, detail="Data source not found")


@router.put("/{data_source_id}", response_model=DataSourceResponse)
async def update_data_source(
    data_source_id: str,
    data_source: DataSourceUpdate,
    db: AsyncSession = Depends(get_db),
):
    """
    更新数据源
    """
    # TODO: 实现更新逻辑
    return data_source


@router.delete("/{data_source_id}")
async def delete_data_source(
    data_source_id: str,
    db: AsyncSession = Depends(get_db),
):
    """
    删除数据源
    """
    # TODO: 实现删除逻辑
    return {"message": "Data source deleted"}