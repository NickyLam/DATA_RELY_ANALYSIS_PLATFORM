"""
打包脚本
用于在 Windows 环境下将项目打包成 exe

环境要求：
  - Python 3.11+ (推荐 3.11 或 3.12)
  - Python 3.9 已于 2025年10月停止维护

使用方法（在 Windows 上运行）：
  python build_exe.py

注意：
  - macOS 无法直接打包 Windows exe
  - 需要在 Windows 环境下运行此脚本
  - 或使用 GitHub Actions 自动打包
"""

from __future__ import annotations

import platform
import subprocess
import sys
from pathlib import Path


def check_python_version() -> bool:
    """检查 Python 版本"""
    print("\n检查 Python 版本...")

    py_version = sys.version_info
    py_ver_str = f"{py_version.major}.{py_version.minor}.{py_version.micro}"

    print(f"  当前版本: Python {py_ver_str}")

    if py_version.major < 3 or (py_version.major == 3 and py_version.minor < 11):
        print("  ❌ Python 版本过低，需要 3.11+")
        print("  提示: Python 3.9 已于 2025年10月停止维护")
        print("  推荐: Python 3.11 或 3.12")
        return False

    if py_version.minor == 9:
        print("  ️ Python 3.9 已停止维护 (EOL: 2025-10-31)")
        print("  推荐: 升级到 Python 3.11 或 3.12")

    if py_version.minor == 10:
        print("  ️ Python 3.10 将于 2026年10月停止维护")
        print("  推荐: 升级到 Python 3.11 或 3.12")

    if py_version.minor >= 14:
        print("  ⚠️ Python 3.14 是最新版本，可能存在兼容性问题")
        print("  推荐: 使用 Python 3.11 或 3.12 进行打包")

    if 11 <= py_version.minor <= 13:
        print("  ✅ Python 版本符合要求")

    return True


def check_environment() -> bool:
    """检查运行环境"""
    print("\n" + "=" * 60)
    print("  数据血缘分析系统 - 打包脚本")
    print("=" * 60)

    current_system = platform.system()
    print(f"  当前系统: {current_system}")

    if current_system != "Windows":
        print("\n  ⚠️ 警告: PyInstaller 不支持跨平台打包")
        print(f"  当前系统 ({current_system}) 无法打包 Windows exe")
        print("\n  解决方案:")
        print("  1. 在 Windows 机器上运行此脚本")
        print("  2. 使用 GitHub Actions 自动打包")
        print("  3. 使用 Docker + Wine (复杂)")
        print("=" * 60 + "\n")
        return False

    print("  ✅ 系统检查通过")
    return True


def check_dependencies() -> bool:
    """检查依赖是否安装"""
    print("\n检查依赖...")

    try:
        result = subprocess.run(
            [sys.executable, "-m", "PyInstaller", "--version"],
            capture_output=True,
            text=True,
        )
        if result.returncode == 0:
            print(f"  ✅ PyInstaller 已安装 ({result.stdout.strip()})")
            return True
    except (FileNotFoundError, subprocess.SubprocessError):
        pass

    try:
        import pyinstaller  # noqa: F401  检测可导入性，不直接使用

        print("  ✅ PyInstaller 已安装")
        return True
    except ImportError:
        print("  ❌ PyInstaller 未安装")
        print("\n  请手动安装 PyInstaller:")
        print(f"    {sys.executable} -m pip install pyinstaller")
        print("\n  如果 pip 不可用，请先修复 pip:")
        print(f"    {sys.executable} -m ensurepip")
        print(f"    {sys.executable} -m pip install --upgrade pip")
        print("\n  或者在 Windows PowerShell 中运行:")
        print("    pip install pyinstaller")
        return False


def check_required_files() -> bool:
    """检查必要文件是否存在"""
    print("\n检查必要文件...")

    required_files = [
        "run_app.py",
        "build.spec",
        "requirements.txt",
        "app/main.py",
        "static/index.html",
    ]

    missing_files = []
    for file in required_files:
        if not Path(file).exists():
            missing_files.append(file)

    if missing_files:
        print(f"  ❌ 缺少文件: {missing_files}")
        return False

    print("  ✅ 所有必要文件存在")
    return True


def check_data_directory() -> bool:
    """检查数据目录是否存在"""
    print("\n检查数据目录...")

    data_dir = Path("RRP_ORACLE")
    if not data_dir.exists():
        print(f"  ❌ 数据目录不存在: {data_dir}")
        print("  请确保 RRP_ORACLE 目录存在")
        return False

    subdirs = ["rrp_mdl", "rrp_east"]
    for subdir in subdirs:
        if not (data_dir / subdir).exists():
            print(f"  ⚠️ 子目录不存在: {data_dir / subdir}")

    print("  ✅ 数据目录检查通过")
    return True


def run_build() -> bool:
    """执行打包"""
    print("\n" + "=" * 60)
    print("  开始打包...")
    print("=" * 60 + "\n")

    try:
        subprocess.run(
            [sys.executable, "-m", "PyInstaller", "build.spec", "--clean"],
            check=True,
        )

        print("\n" + "=" * 60)
        print("  ✅ 打包成功!")
        print("=" * 60)
        print("  输出文件: dist/数据血缘分析系统.exe")
        print("\n  使用方法:")
        print("  1. 双击运行 数据血缘分析系统.exe")
        print("  2. 访问 http://localhost:8899")
        print("=" * 60 + "\n")
        return True

    except subprocess.CalledProcessError as e:
        print("\n" + "=" * 60)
        print("  ❌ 打包失败!")
        print("=" * 60)
        print(f"  错误信息: {e}")
        print("\n  请检查:")
        print("  1. 所有依赖是否正确安装")
        print("  2. build.spec 配置是否正确")
        print("  3. 数据目录是否完整")
        print("=" * 60 + "\n")
        return False


def main() -> None:
    """主函数"""
    checks = [
        ("Python 版本检查", check_python_version),
        ("环境检查", check_environment),
        ("依赖检查", check_dependencies),
        ("文件检查", check_required_files),
        ("数据目录检查", check_data_directory),
    ]

    for name, check_func in checks:
        if not check_func():
            print(f"\n❌ {name}失败，无法继续打包")
            sys.exit(1)

    if not run_build():
        sys.exit(1)


if __name__ == "__main__":
    main()
