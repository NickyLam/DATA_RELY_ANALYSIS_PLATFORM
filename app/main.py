"""
FastAPI 应用主入口
数据血缘分析系统 v2.0 - 双TAB架构（解析层 + 展示层）

启动方式:
  uvicorn app.main:app --reload --port 8899
  或
  python -m app.main
"""

from __future__ import annotations

import logging
import os
import time
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, JSONResponse
from fastapi.staticfiles import StaticFiles

from app.api.parse import router as parse_router
from app.api.lineage import router as lineage_router
from app.api.caliber import router as caliber_router
from app.api.indicator import router as indicator_router
from app.api.system import router as system_router
from app.config import config
from app.dependencies import (
    get_caliber_service,
    get_indicator_service,
    get_lineage_service,
    get_parser_service,
    get_progress_service,
)
from app.utils.path_utils import get_static_dir

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """应用生命周期管理：启动时初始化，关闭时清理"""
    logger.info("=" * 60)
    logger.info("正在启动 %s v%s...", config.app_title, config.app_version)
    logger.info("=" * 60)

    start_time = time.time()

    try:
        parser_service = get_parser_service()
        progress_service = get_progress_service()

        logger.info("步骤 1/3: 加载数据（缓存优先）...")
        if config.data_path.exists():
            result = parser_service.parse_existing_data()
            if result and result.parse_time_sec == 0.0:
                logger.info("✅ 缓存加载完成: %d 张表, %d 个过程", len(result.tables), len(result.procedures))
            else:
                logger.info(
                    "✅ 全量解析完成: %d 张表, %d 个过程, 耗时 %.2fs",
                    len(result.tables),
                    len(result.procedures),
                    result.parse_time_sec,
                )
        else:
            logger.warning("⚠️ 数据目录不存在: %s", config.data_path)

        logger.info("步骤 2/3: 构建性能优化索引...")
        lineage_service = get_lineage_service()
        caliber_service = get_caliber_service()
        indicator_service = get_indicator_service()
        logger.info("✅ 索引构建完成")

        logger.info("步骤 3/3: 启动 HTTP 服务...")
        elapsed = time.time() - start_time
        logger.info("🚀 系统就绪! 启动耗时 %.2fs", elapsed)
        logger.info("=" * 60)
        logger.info("访问地址: http://localhost:%s", config.port)
        logger.info("API 文档: http://localhost:%s/docs", config.port)
        logger.info("前端页面: http://localhost:%s/static/index.html", config.port)
        logger.info("=" * 60)

    except Exception as e:
        logger.error("❌ 启动初始化失败: %s", e, exc_info=True)

    yield

    logger.info("正在关闭服务...")
    progress_service.cleanup_old_tasks(max_age_sec=0)
    logger.info("服务已安全关闭")


app = FastAPI(
    title=config.app_title,
    version=config.app_version,
    description="""
## 数据血缘分析系统 v2.0

### 核心功能

1. **解析层 (Parse Tab)**
   - 上传 .tab / .prc 文件进行实时解析
   - SSE 实时进度推送 + 详细日志
   - 支持增量/全量两种解析模式

2. **展示层 (Display Tab)**
   - D3.js 交互式血缘图谱可视化
   - 智能搜索（倒排索引加速，<50ms响应）
   - 虚拟滚动支持万级节点流畅渲染
   - Web Worker 分块渲染避免UI卡顿

### 性能优化

- ✅ 内存倒排索引（毫秒级搜索）
- ✅ 图数据预处理（邻接表预计算）
- ✅ 结果缓存（TTL过期自动淘汰）
- ✅ 虚拟滚动（长列表性能优化）
- ✅ Web Worker 分块渲染

### 技术栈

- **后端**: FastAPI + Python 3.11+
- **前端**: 原生 JavaScript ES6+ + D3.js v7
- **实时通信**: Server-Sent Events (SSE)
- **数据验证**: Pydantic v2
    """,
    lifespan=lifespan,
    docs_url="/docs",
    redoc_url="/redoc",
)

# CORS 中间件配置
ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://localhost:8080",
    "http://localhost:8899",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS if os.getenv("PRODUCTION") else ["*"],
    allow_credentials=True,
    allow_methods=["GET", "POST"],
    allow_headers=["Content-Type"],
)


# P4: /api/caliber/* 弃用标记
# 旧路由仍保留功能，但响应头提示客户端迁移到 /api/lineage/*
# RFC 8594: Sunset HTTP header / draft-ietf-httpapi-deprecation-header
CALIBER_SUNSET_DATE = "Sun, 30 Aug 2026 00:00:00 GMT"
CALIBER_DEPRECATION_LINK = (
    '</docs>; rel="successor-version", '
    '</api/lineage/edge-caliber>; rel="alternate"'
)


@app.middleware("http")
async def add_caliber_deprecation_headers(request: Request, call_next):
    response = await call_next(request)
    if request.url.path.startswith("/api/caliber/"):
        response.headers["Deprecation"] = "true"
        response.headers["Sunset"] = CALIBER_SUNSET_DATE
        response.headers["Link"] = CALIBER_DEPRECATION_LINK
        response.headers["Warning"] = (
            '299 - "This endpoint is deprecated; migrate to /api/lineage/* '
            'before 2026-08-30. See /docs."'
        )
    return response


# 注册路由
app.include_router(parse_router)
app.include_router(lineage_router)
app.include_router(caliber_router)
app.include_router(indicator_router)
app.include_router(system_router)


@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    logger.error("未处理异常: %s %s - %s", request.method, request.url.path, exc, exc_info=True)
    return JSONResponse(
        status_code=500,
        content={
            "success": False,
            "error": {"code": "INTERNAL_ERROR", "message": "服务内部错误"},
        },
    )

# 静态文件服务
static_dir = get_static_dir()
if static_dir.exists():
    app.mount("/static", StaticFiles(directory=str(static_dir)), name="static")


@app.get("/index.html")
@app.get("/")
async def serve_index():
    """提供前端主页（强制禁用缓存，确保版本更新即时生效）"""
    index_file = static_dir / "index.html"

    if index_file.exists():
        return FileResponse(
            str(index_file),
            media_type="text/html",
            headers={
                "Cache-Control": "no-cache, no-store, must-revalidate",
                "Pragma": "no-cache",
                "Expires": "0",
            },
        )

    return {
        "message": "前端页面尚未构建，请访问 /docs 查看 API 文档",
        "hint": "运行 python generate_frontend.py 生成前端文件",
    }


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "app.main:app",
        host=config.host,
        port=config.port,
        reload=config.debug,
        log_level="info",
    )
