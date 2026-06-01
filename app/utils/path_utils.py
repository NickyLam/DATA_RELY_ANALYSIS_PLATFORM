"""
路径处理工具模块
兼容开发模式和 PyInstaller 打包模式

PyInstaller 打包后：
- 代码运行在临时目录 sys._MEIPASS
- 静态文件和数据文件通过 --add-data 打包
- Windows 上路径分隔符为分号(;)，macOS/Linux 为冒号(:)
"""

from __future__ import annotations

import sys
from pathlib import Path


def is_frozen() -> bool:
    """检测是否在 PyInstaller 打包模式下运行"""
    return getattr(sys, "frozen", False) and hasattr(sys, "_MEIPASS")


def get_base_dir() -> Path:
    """获取应用基础目录"""
    if is_frozen():
        return Path(sys._MEIPASS)
    return Path(__file__).parent.parent.parent


def get_static_dir() -> Path:
    """获取静态文件目录"""
    return get_base_dir() / "static"


def get_data_dir() -> Path:
    """获取数据目录 (RRP_ORACLE)"""
    return get_base_dir() / "RRP_ORACLE"


def get_output_dir() -> Path:
    """获取输出目录"""
    path = get_base_dir() / "output"
    path.mkdir(parents=True, exist_ok=True)
    return path


def get_upload_temp_dir() -> Path:
    """获取上传临时目录"""
    path = get_base_dir() / "temp_uploads"
    path.mkdir(parents=True, exist_ok=True)
    return path


def get_executable_dir() -> Path:
    """获取可执行文件所在目录（用于保存用户数据）"""
    if is_frozen():
        return Path(sys.executable).parent
    return get_base_dir()


def get_user_data_dir() -> Path:
    """获取用户数据目录（exe 外部，可持久化）"""
    exe_dir = get_executable_dir()
    user_data = exe_dir / "user_data"
    user_data.mkdir(parents=True, exist_ok=True)
    return user_data


def get_config_file_path() -> Path:
    """获取配置文件路径（exe 外部，可持久化）"""
    return get_executable_dir() / "config.json"


def resolve_path(relative_path: str) -> Path:
    """解析相对路径，兼容开发/打包模式"""
    return get_base_dir() / relative_path


def ensure_dir(path: Path) -> Path:
    """确保目录存在"""
    path.mkdir(parents=True, exist_ok=True)
    return path


def get_runtime_info() -> dict[str, str | bool]:
    """获取运行环境信息（调试用）"""
    return {
        "is_frozen": is_frozen(),
        "base_dir": str(get_base_dir()),
        "static_dir": str(get_static_dir()),
        "data_dir": str(get_data_dir()),
        "executable_dir": str(get_executable_dir()),
        "sys_executable": sys.executable,
        "sys_meipass": getattr(sys, "_MEIPASS", "N/A"),
    }
