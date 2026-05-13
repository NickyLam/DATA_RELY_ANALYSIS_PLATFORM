@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: ============================================
:: 数据血缘分析系统 - 打包部署脚本 (Windows)
:: ============================================
::
:: 功能：
::   1. 将项目必要的运行文件打包成 ZIP
::   2. 自动排除开发/临时文件
::   3. 生成带版本号的压缩包
::
:: 使用方法：
::   package.bat                    # 默认打包
::   package.bat -v 2.0.1           # 指定版本号
::   package.bat --output dist      # 指定输出目录
::

title 数据血缘分析系统 - 打包工具

cd /d "%~dp0"

set VERSION=2.0.0
set OUTPUT_DIR=%~dp0dist
set PROJECT_NAME=数据血缘分析系统

:: 解析参数
:parse_args
if "%~1"=="" goto args_done
if /i "%~1"=="--version" (
    set VERSION=%~2
    shift
    shift
    goto parse_args
)
if /i "%~1"=="-v" (
    set VERSION=%~2
    shift
    shift
    goto parse_args
)
if /i "%~1"=="--output" (
    set OUTPUT_DIR=%~2
    shift
    shift
    goto parse_args
)
if /i "%~1"=="-o" (
    set OUTPUT_DIR=%~2
    shift
    shift
    goto parse_args
)
if /i "%~1"=="--help" goto show_help
if /i "%~1"=="-h" goto show_help
echo [错误] 未知参数: %~1
exit /b 1

:args_done

echo.
echo ╔══════════════════════════════════════════╗
echo ║     数据血缘分析系统 - 部署打包工具       ║
echo ╚══════════════════════════════════════════╝
echo.
echo   版本: %VERSION%
echo   输出: %OUTPUT_DIR%
echo.

:: ========== 检查 PowerShell ==========
echo [1/5] 检查打包环境...
where powershell >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 PowerShell，无法执行打包操作
    echo   本脚本需要 Windows PowerShell (Windows 10+ 自带)
    exit /b 1
)
echo       [OK] PowerShell 可用

:: ========== 创建输出目录 ==========
if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
    echo [提示] 已创建输出目录: %OUTPUT_DIR%
)

:: ========== 定义打包清单 ==========
echo.
echo [2/5] 准备文件清单...
echo.

:: 设置 ZIP 文件名
set ZIP_FILE=%OUTPUT_DIR%\%PROJECT_NAME%_v%VERSION%.zip

:: 创建临时清单文件
set MANIFEST_FILE=%TEMP%\package_manifest_%RANDOM%.txt
type nul > "%MANIFEST_FILE%"

:: ========== 收集必要文件 ==========
echo 正在收集文件...

:: 1) Python 核心代码 - app/ 目录
echo   + app\ (应用主程序)
dir /s /b "app\*.py" >> "%MANIFEST_FILE%" 2>nul

:: 2) Python 核心代码 - core/ 目录
echo   + core\ (核心业务逻辑)
dir /s /b "core\*.py" >> "%MANIFEST_FILE%" 2>nul

:: 3) 根目录 Python 文件
echo   + *.py (入口文件)
for %%f in (*.py) do (
    if /i not "%%f"=="_basic_test.py" (
        if /i not "%%f"=="_full_test.py" (
            echo %%f >> "%MANIFEST_FILE%"
        )
    )
)

:: 4) 前端静态资源 - static/ 目录
echo   + static\ (前端界面)
dir /s /b "static\*" >> "%MANIFEST_FILE%" 2>nul

:: 5) 配置文件
echo   + requirements.txt (依赖配置)
if exist "requirements.txt" echo requirements.txt >> "%MANIFEST_FILE%"

:: 6) 启动脚本
echo   + start.bat / stop.bat (启动脚本)
if exist "start.bat" echo start.bat >> "%MANIFEST_FILE%"
if exist "stop.bat" echo stop.bat >> "%MANIFEST_FILE%"
if exist "start.sh" echo start.sh >> "%MANIFEST_FILE%"
if exist "stop.sh" echo stop.sh >> "%MANIFEST_FILE%"

:: 7) 数据目录 - RRP_ORACLE/
echo   + RRP_ORACLE\ (数据文件)
if exist "RRP_ORACLE" (
    dir /s /b "RRP_ORACLE\*" >> "%MANIFEST_FILE%" 2>nul
)

:: 统计文件数量
set FILE_COUNT=0
for /f %%a in ('type "%MANIFEST_FILE%" ^| find /c /v ""') do set FILE_COUNT=%%a

echo.
echo       共收集 %FILE_COUNT% 个文件

:: ========== 执行打包 ==========
echo.
echo [3/5] 正在打包...
echo.
echo   目标文件: %ZIP_FILE%

:: 删除已存在的 ZIP
if exist "%ZIP_FILE%" del "%ZIP_FILE%"

:: 使用 PowerShell 压缩
powershell -Command "& {
    $files = Get-Content '%MANIFEST_FILE%' | Where-Object { Test-Path $_ }
    Compress-Archive -Path $files -DestinationPath '%ZIP_FILE%' -Force
}" >nul 2>&1

if %errorlevel% neq 0 (
    echo [错误] 打包失败！
    del "%MANIFEST_FILE%" >nul 2>&1
    exit /b 1
)

:: ========== 获取打包结果 ==========
echo.
echo [4/5] 验证打包结果...

:: 检查 ZIP 是否存在
if not exist "%ZIP_FILE%" (
    echo [错误] ZIP 文件未生成！
    del "%MANIFEST_FILE%" >nul 2>&1
    exit /b 1
)

:: 获取文件大小
for %%A in ("%ZIP_FILE%") do (
    set SIZE_BYTES=%%~zA
    set SIZE_MB=0
    set /a SIZE_MB=!SIZE_BYTES! / 1048576
)

echo       [OK] ZIP 文件已生成
echo       大小: 约 %SIZE_MB% MB (%SIZE_BYTES% bytes)

:: ========== 清理临时文件 ==========
del "%MANIFEST_FILE%" >nul 2>&1

:: ========== 显示打包报告 ==========
echo.
echo [5/5] 生成打包报告...
echo.

:: 获取完整路径
for %%I in ("%ZIP_FILE%") do set FULL_PATH=%%~fI

echo ╔═══════════════════════════════════════════════╗
echo ║              ✅ 打包完成！                      ║
echo ╠═══════════════════════════════════════════════╣
echo ║                                               ║
echo ║   项目名称: %PROJECT_NAME%                     ║
echo ║   版本号:   v%VERSION%                         ║
echo ║   文件数:   %FILE_COUNT% 个                    ║
echo ║   包大小:   约 %SIZE_MB% MB                   ║
echo ║                                               ║
echo ║   输出路径:                                    ║
echo ║   %FULL_PATH%                                  ║
echo ║                                               ║
echo ╠═══════════════════════════════════════════════╣
echo ║   包含内容:                                    ║
echo ║   ├─ app\          应用主程序                  ║
echo ║   ├─ core\         核心业务逻辑                ║
echo ║   ├─ static\       前端界面资源               ║
echo ║   ├─ RRP_ORACLE\   数据文件 (.prc/.tab)        ║
echo ║   ├─ *.py          入口和配置文件             ║
echo ║   ├─ start.bat     Windows 启动脚本            ║
echo ║   ├─ stop.bat      Windows 停止脚本            ║
echo ║   ├─ start.sh      Linux/Mac 启动脚本         ║
echo ║   ├─ stop.sh       Linux/Mac 停止脚本         ║
echo ║   └─ requirements.txt 依赖清单                 ║
echo ║                                               ║
echo ╠═══════════════════════════════════════════════╣
echo ║   排除内容:                                    ║
echo ║   ├─ __pycache__\  Python 缓存               ║
echo ║   ├─ temp_uploads\ 临时上传文件              ║
echo ║   ├─ output\       运行时输出                 ║
echo ║   ├─ test_output\ 测试输出                   ║
echo ║   ├─ *.log         日志文件                   ║
echo ║   ├─ .server.pid   进程 PID 文件             ║
echo ║   ├─ _*_test.py    测试脚本                   ║
echo ║   ├─ build.*       打包配置文件              ║
echo ║   └─ .workbuddy\   开发工具缓存             ║
echo ╚═══════════════════════════════════════════════╝
echo.

:: 询问是否打开输出文件夹
set /p OPEN_FOLDER="是否打开输出文件夹? (Y/n): "
if /i "%OPEN_FOLDER%"=="" set OPEN_FOLDER=Y
if /i "%OPEN_FOLDER%"=="Y" explorer "%OUTPUT_DIR%"
if /i "%OPEN_FOLDER%"=="y" explorer "%OUTPUT_DIR%"

echo.
echo [提示] 部署步骤:
echo   1. 将 ZIP 文件复制到目标服务器
echo   2. 解压到目标目录
echo   3. 安装 Python 3.11+ 并确保 pip 可用
echo   4. 双击 start.bat 启动服务
echo   5. 访问 http://localhost:8899
echo.

exit /b 0

:show_help
echo.
echo 数据血缘分析系统 - 部署打包工具
echo.
echo 用法: %~nx0 [选项]
echo.
echo 选项:
echo   -v, --version VER   指定版本号 (默认: 2.0.0)
echo   -o, --output DIR    指定输出目录 (默认: .\dist)
echo   -h, --help          显示帮助信息
echo.
echo 示例:
echo   %~nx0                          # 默认打包，输出到 .\dist
echo   %~nx0 -v 2.1.0                # 打包版本 2.1.0
echo   %~nx0 -v 1.0.0-beta -o release # 打包测试版到 release 目录
echo.
echo 输出:
echo   生成格式: 数据血缘分析系统_v{VERSION}.zip
echo.
exit /b 0
