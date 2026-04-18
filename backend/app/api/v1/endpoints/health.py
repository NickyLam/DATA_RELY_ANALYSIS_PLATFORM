"""
健康检查 API
"""
from fastapi import APIRouter

router = APIRouter()


@router.get("/")
async def health():
    """
    健康检查
    """
    return {"status": "healthy"}