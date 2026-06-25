"""
打包入口文件
用于 PyInstaller 打包成 Windows exe

功能：
1. 检测运行环境（开发/打包模式）
2. 启动 FastAPI 应用
3. 提供友好的启动信息

使用方法：
  开发模式：python run_app.py
  重新解析：python run_app.py --reparse
  打包后：数据血缘分析系统.exe [--reparse]
"""

from __future__ import annotations

import argparse
import logging
import sys
from pathlib import Path

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger(__name__)


def ensure_python_version() -> None:
    if (sys.version_info.major, sys.version_info.minor) < (3, 11):
        raise SystemExit(
            "Python 3.11+ is required. "
            f"Current interpreter: {sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
        )


def is_frozen() -> bool:
    """检测是否在 PyInstaller 打包模式下运行"""
    return getattr(sys, "frozen", False) and getattr(sys, "_MEIPASS", None) is not None


def get_base_dir() -> Path:
    """获取应用基础目录"""
    if is_frozen():
        return Path(sys._MEIPASS)  # type: ignore[attr-defined]
    return Path(__file__).parent


def print_startup_info(force_reparse: bool = False) -> None:
    """打印启动信息"""
    from app.config import config

    base_dir = get_base_dir()
    static_dir = base_dir / "static"
    data_dir = config.source_data_path

    print("\n" + "=" * 60)
    print(f"  数据血缘分析系统 v{config.app_version}")
    print("=" * 60)
    print(f"  运行模式: {'打包模式' if is_frozen() else '开发模式'}")
    print(f"  数据加载: {'强制重新解析' if force_reparse else '缓存优先（默认）'}")
    print(f"  基础目录: {base_dir}")
    print(f"  静态文件: {static_dir}")
    print(f"  数据目录: {data_dir}")
    print("=" * 60 + "\n")


def main() -> None:
    """主入口函数"""
    ensure_python_version()

    parser = argparse.ArgumentParser(description="数据血缘分析系统")
    parser.add_argument(
        "--reparse",
        action="store_true",
        default=False,
        help="启动时强制重新解析所有数据源（跳过缓存）",
    )
    args = parser.parse_args()

    if args.reparse:
        import os
        os.environ["FORCE_REPARSE"] = "1"

    print_startup_info(force_reparse=args.reparse)

    try:
        import uvicorn

        from app.config import config
        from app.main import app

        if args.reparse:
            config.force_reparse = True
            logger.info("🔄 已启用 --reparse 参数，启动时将强制重新解析数据源")

        logger.info("正在启动 FastAPI 服务...")
        logger.info("访问地址: http://localhost:%s", config.port)
        logger.info("API 文档: http://localhost:%s/docs", config.port)
        logger.info("前端页面: http://localhost:%s/", config.port)

        uvicorn.run(
            app,
            host=config.host,
            port=config.port,
            log_level="info",
        )

    except ImportError as e:
        logger.error("导入模块失败: %s", e)
        logger.error("请确保已安装所有依赖: pip install -r requirements.txt")
        sys.exit(1)
    except Exception as e:
        logger.error("启动失败: %s", e, exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
