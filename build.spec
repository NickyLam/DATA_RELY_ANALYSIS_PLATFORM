# -*- mode: python ; coding: utf-8 -*-
"""
PyInstaller 打包配置文件
用于将数据血缘分析系统打包成 Windows exe

环境要求：
  - Python 3.11+ (推荐 3.11 或 3.12)
  - Python 3.9 已于 2025年10月停止维护

使用方法（在 Windows 上运行）：
  pyinstaller build.spec

生成文件位置：
  dist/数据血缘分析系统.exe
"""

import os
import sys
from pathlib import Path

block_cipher = None

a = Analysis(
    ['run_app.py'],
    pathex=[],
    binaries=[],
    datas=[
        ('static', 'static'),
        ('RRP_ORACLE', 'RRP_ORACLE'),
    ],
    hiddenimports=[
        'uvicorn.logging',
        'uvicorn.loops',
        'uvicorn.loops.auto',
        'uvicorn.protocols',
        'uvicorn.protocols.http',
        'uvicorn.protocols.http.auto',
        'uvicorn.protocols.websockets',
        'uvicorn.protocols.websockets.auto',
        'uvicorn.lifespan',
        'uvicorn.lifespan.on',
        'starlette',
        'starlette.responses',
        'starlette.routing',
        'starlette.middleware',
        'starlette.middleware.cors',
        'starlette.staticfiles',
        'pydantic',
        'pydantic_core',
        'annotated_types',
        'fastapi',
        'fastapi.routing',
        'fastapi.middleware',
        'fastapi.middleware.cors',
        'fastapi.staticfiles',
        'fastapi.responses',
        'fastapi.encoders',
        'httpcore',
        'httpcore._backends',
        'httpcore._backends.auto',
        'httptools',
        'anyio',
        'anyio._backends',
        'anyio._backends._asyncio',
        'sniffio',
        'core.lineage_tracer',
        'core.procedure_parser',
        'core.models',
        'analyze_lineage',
        'app.main',
        'app.config',
        'app.dependencies',
        'app.api.parse',
        'app.api.lineage',
        'app.api.system',
        'app.services.parser_service',
        'app.services.lineage_service',
        'app.services.progress_service',
        'app.utils.path_utils',
        'app.utils.file_handler',
        'app.utils.cache_manager',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        'tkinter',
        'matplotlib',
        'numpy',
        'pandas',
        'scipy',
        'pytest',
        'IPython',
        'jupyter',
        'notebook',
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='数据血缘分析系统',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=None,
    version=None,
    uac_admin=False,
    uac_uiaccess=False,
)
