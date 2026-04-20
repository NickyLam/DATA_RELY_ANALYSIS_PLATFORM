"""
SQL 解析 API
"""
from typing import List, Optional, Dict, Any
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.parsers.sql_parser import SQLParser
from app.parsers.lineage_builder import LineageBuilder

router = APIRouter()


class ParseRequest(BaseModel):
    """解析请求"""
    sql: str
    dialect: str = "oracle"
    extract_field_lineage: bool = True


class ParseResult(BaseModel):
    """解析结果"""
    parse_id: str
    sql: str
    dialect: str
    success: bool
    error_message: Optional[str] = None
    tables_referenced: List[str] = []
    tables_modified: List[str] = []
    field_lineages: List[Dict[str, Any]] = []
    parsed_at: datetime


class BatchParseRequest(BaseModel):
    """批量解析请求"""
    sqls: List[str]
    dialect: str = "oracle"
    extract_field_lineage: bool = True


class BatchParseResult(BaseModel):
    """批量解析结果"""
    batch_id: str
    total_count: int
    success_count: int
    error_count: int
    results: List[ParseResult]
    parsed_at: datetime


@router.post("/sql", response_model=ParseResult)
async def parse_single_sql(
    request: ParseRequest,
    db: AsyncSession = Depends(get_db),
):
    """
    解析单个 SQL 语句
    
    dialect 可选值: oracle, mysql, postgresql
    """
    parse_id = f"parse-{datetime.now().strftime('%Y%m%d%H%M%S')}"
    
    try:
        parser = SQLParser(dialect=request.dialect)
        result = parser.parse(request.sql)
        
        builder = LineageBuilder()
        lineages = builder.build_from_parse_result(result)
        
        return ParseResult(
            parse_id=parse_id,
            sql=request.sql,
            dialect=request.dialect,
            success=True,
            tables_referenced=result.get("tables_referenced", []),
            tables_modified=result.get("tables_modified", []),
            field_lineages=lineages,
            parsed_at=datetime.now(),
        )
    except Exception as e:
        return ParseResult(
            parse_id=parse_id,
            sql=request.sql,
            dialect=request.dialect,
            success=False,
            error_message=str(e),
            parsed_at=datetime.now(),
        )


@router.post("/batch", response_model=BatchParseResult)
async def parse_batch_sql(
    request: BatchParseRequest,
    db: AsyncSession = Depends(get_db),
):
    """
    批量解析 SQL 语句
    """
    batch_id = f"batch-{datetime.now().strftime('%Y%m%d%H%M%S')}"
    
    parser = SQLParser(dialect=request.dialect)
    builder = LineageBuilder()
    
    results = []
    success_count = 0
    error_count = 0
    
    for sql in request.sqls:
        try:
            result = parser.parse(sql)
            lineages = builder.build_from_parse_result(result)
            
            results.append(ParseResult(
                parse_id=f"{batch_id}-{len(results)}",
                sql=sql,
                dialect=request.dialect,
                success=True,
                tables_referenced=result.get("tables_referenced", []),
                tables_modified=result.get("tables_modified", []),
                field_lineages=lineages,
                parsed_at=datetime.now(),
            ))
            success_count += 1
        except Exception as e:
            results.append(ParseResult(
                parse_id=f"{batch_id}-{len(results)}",
                sql=sql,
                dialect=request.dialect,
                success=False,
                error_message=str(e),
                parsed_at=datetime.now(),
            ))
            error_count += 1
    
    return BatchParseResult(
        batch_id=batch_id,
        total_count=len(request.sqls),
        success_count=success_count,
        error_count=error_count,
        results=results,
        parsed_at=datetime.now(),
    )


@router.get("/result/{parse_id}", response_model=ParseResult)
async def get_parse_result(
    parse_id: str,
    db: AsyncSession = Depends(get_db),
):
    """
    获取解析结果详情
    """
    raise HTTPException(status_code=404, detail="Parse result not found")


@router.get("/stats")
async def get_parse_stats(
    db: AsyncSession = Depends(get_db),
):
    """
    获取解析统计信息
    """
    return {
        "total_parsed": 0,
        "success_rate": 0.0,
        "avg_parse_time_ms": 0,
        "tables_extracted": 0,
        "lineages_extracted": 0,
    }