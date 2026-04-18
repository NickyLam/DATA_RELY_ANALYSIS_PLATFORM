"""
资产搜索 API
"""
from typing import List, Optional

from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.schemas.table import TableResponse

router = APIRouter()


@router.get("/tables", response_model=List[TableResponse])
async def search_tables(
    name: Optional[str] = Query(None, description="表名（模糊查询）"),
    exact_name: Optional[str] = Query(None, description="表名（精确查询）"),
    data_source_id: Optional[str] = Query(None, description="数据源ID"),
    limit: int = Query(20, ge=1, le=100),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
):
    """
    搜索表
    """
    # TODO: 实现搜索逻辑
    return []


@router.get("/fields", response_model=List[dict])
async def search_fields(
    name: Optional[str] = Query(None, description="字段名（模糊查询）"),
    table_name: Optional[str] = Query(None, description="所属表名"),
    limit: int = Query(20, ge=1, le=100),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
):
    """
    搜索字段
    """
    # TODO: 实现搜索逻辑
    return []