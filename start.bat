@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: ============================================
:: 数据血缘分析系统 - 一键启动 (Windows)
:: ============================================

title 数据血缘分析系统

cd /d "%~dp0"

set PORT=8899
set DIR=RRP_ORACLE
set LOG_FILE=%~dp0server.log
set PID_FILE=%~dp0.server.pid

:: 解析参数
:parse_args
if "%~1"=="" goto args_done
if /i "%~1"=="--port" (
    set PORT=%~2
    shift
    shift
    goto parse_args
)
if /i "%~1"=="-p" (
    set PORT=%~2
    shift
    shift
    goto parse_args
)
if /i "%~1"=="--dir" (
    set DIR=%~2
    shift
    shift
    goto parse_args
)
if /i "%~1"=="-d" (
    set DIR=%~2
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
echo ========================================
echo   数据血缘分析系统 v2.0
echo ========================================
echo.

:: ========== 1. 检查 Python ==========
echo [1/5] 检查 Python 环境...

set PYTHON_CMD=

:: 尝试按版本号查找 Python 3.11+
for %%v in (3.13 3.12 3.11) do (
    python%%v --version >nul 2>&1
    if !errorlevel! equ 0 (
        set PYTHON_CMD=python%%v
        goto :python_found
    )
)

:: 如果没找到特定版本，尝试 python
python --version >nul 2>&1
if !errorlevel! equ 0 set PYTHON_CMD=python

:python_found
if "%PYTHON_CMD%"=="" (
    echo [错误] 未找到 Python，请先安装 Python 3.11 或更高版本
    echo.
    echo   下载地址: https://www.python.org/downloads/
    echo   安装时请勾选 "Add Python to PATH"
    exit /b 1
)

:: 获取 Python 版本
for /f "tokens=2 delims= " %%v in ('%PYTHON_CMD% --version 2^>^&1') do set PY_VER=%%v
for /f "tokens=1,2 delims=." %%a in ("%PY_VER%") do (
    set PY_MAJOR=%%a
    set PY_MINOR=%%b
)

echo   使用: %PYTHON_CMD% (版本 %PY_VER%)

:: 检查版本是否符合要求 (>= 3.11)
if %PY_MAJOR% LSS 3 goto :python_version_error
if %PY_MAJOR% EQU 3 if %PY_MINOR% LSS 11 goto :python_version_error
goto :python_ok

:python_version_error
echo [错误] Python 版本过低 (%PY_VER%)，需要 3.11 或更高版本
echo.
echo   当前支持的 Python 版本:
echo     - Python 3.11 (推荐 LTS，支持至 2027-10)
echo     - Python 3.12 (支持至 2028-10)
echo     - Python 3.13 (最新版)
echo.
echo   解决方案:
echo     1. 从 https://www.python.org/downloads/ 下载安装 Python 3.11+
echo     2. 安装时务必勾选 "Add Python to PATH"
exit /b 1

:python_ok
echo       [OK] Python 版本符合要求

:: ========== 2. 检查并安装依赖 ==========
echo.
echo [2/5] 检查项目依赖...

set REQ_FILE=%~dp0requirements.txt
if not exist "%REQ_FILE%" (
    echo [警告] 未找到 requirements.txt，跳过依赖检查
    goto :deps_done
)

:: 检查 pip 是否可用
%PYTHON_CMD% -m pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] pip 不可用，请检查 Python 安装是否完整
    exit /b 1
)

:: 统计缺失的依赖数量
set MISSING_COUNT=0
set MISSING_PKGS=

:: 解析 requirements.txt 并检查每个包
for /f "usebackq tokens=*" %%l in ("%REQ_FILE%") do (
    set "line=%%l"
    :: 跳过空行和注释
    if not "!line!"=="" (
        :: 去掉注释部分
        for /f "tokens=1 delims=#" %%c in ("!line!") do set "line=%%c"
        if not "!line!"=="" (
            :: 提取包名（去掉版本约束）
            for /f "tokens=1 delims=<>=!~[ " %%p in ("!line!") do (
                set "PKG=%%p"
                :: 跳过空包名
                if not "!PKG!"=="" (
                    :: 检查包是否已安装
                    %PYTHON_CMD% -c "import importlib.metadata; importlib.metadata.distribution('!PKG!')" >nul 2>&1
                    if !errorlevel! neq 0 (
                        :: 对带中括号的包名去掉括号再试
                        for /f "tokens=1 delims=[" %%b in ("!PKG!") do set "PKG_BASE=%%b"
                        %PYTHON_CMD% -c "import importlib.metadata; importlib.metadata.distribution('!PKG_BASE!')" >nul 2>&1
                        if !errorlevel! neq 0 (
                            set /a MISSING_COUNT+=1
                            if "!MISSING_PKGS!"=="" (
                                set "MISSING_PKGS=!PKG!"
                            ) else (
                                set "MISSING_PKGS=!MISSING_PKGS!, !PKG!"
                            )
                        )
                    )
                )
            )
        )
    )
)

if %MISSING_COUNT% GTR 0 (
    echo   [警告] 检测到 %MISSING_COUNT% 个依赖缺失: %MISSING_PKGS%
    echo   正在自动安装...
    echo.
    %PYTHON_CMD% -m pip install -r "%REQ_FILE%"
    if %errorlevel% neq 0 (
        echo [错误] 依赖安装失败！
        echo   请手动执行: %PYTHON_CMD% -m pip install -r requirements.txt
        exit /b 1
    )
    echo.
    echo       [OK] 依赖安装完成
) else (
    echo       [OK] 所有依赖已就绪
)

:deps_done

:: ========== 3. 检查核心模块 ==========
echo.
echo [3/5] 检查核心模块...
%PYTHON_CMD% -c "from core.lineage_tracer import LineageTracer; from core.models import FieldMapping" >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 核心模块导入失败，请确认项目文件完整
    exit /b 1
)
echo       [OK] 核心模块正常

:: ========== 4. 检查端口和数据目录 ==========
echo.
echo [4/5] 检查端口和目录...

:: 检查数据目录
if not exist "%DIR%" (
    echo [错误] 数据目录不存在: %DIR%
    exit /b 1
)

:: 检查端口是否被占用
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%PORT% " ^| findstr "LISTENING"') do (
    set OLD_PID=%%a
    goto :port_in_use
)
goto :port_free

:port_in_use
echo   [警告] 端口 %PORT% 已被占用 (PID: %OLD_PID%)
echo   正在停止旧进程...
taskkill /PID %OLD_PID% /F >nul 2>&1
timeout /t 2 /nobreak >nul
:: 再次检查
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%PORT% " ^| findstr "LISTENING"') do (
    echo [错误] 无法释放端口 %PORT%，请手动结束占用进程
    exit /b 1
)
echo       [OK] 端口已释放

:port_free
echo       [OK] 端口 %PORT% 可用
echo       [OK] 数据目录: %DIR%

:: ========== 5. 启动服务 ==========
echo.
echo [5/5] 启动服务...
echo.
echo ----------------------------------------
echo   配置信息:
echo     端口: %PORT%
echo     目录: %DIR%
echo     日志: %LOG_FILE%
echo ----------------------------------------
echo.

:: 清空日志文件
type nul > "%LOG_FILE%"

:: 启动服务（后台运行）
start "" /B %PYTHON_CMD% -m uvicorn app.main:app --host 0.0.0.0 --port %PORT% --log-level info >> "%LOG_FILE%" 2>&1
set SERVER_PID=%ERRORLEVEL%
:: Windows 下无法直接获取子进程 PID，使用端口检测代替
echo 服务启动中...

:: 显示初始化进度
echo [1/3] 正在初始化服务...
timeout /t 10 /nobreak >nul

:: 检查进程是否还在运行
netstat -ano | findstr ":%PORT% " | findstr "LISTENING" >nul 2>&1
if %errorlevel% neq 0 (
    :: 检查日志是否有错误
    findstr /i "Error\|Exception\|Traceback" "%LOG_FILE%" >nul 2>&1
    if %errorlevel% equ 0 (
        echo.
        echo [错误] 服务启动失败！日志显示有错误：
        type "%LOG_FILE%"
    ) else (
        echo.
        echo [错误] 服务启动失败！请查看日志:
        echo   type "%LOG_FILE%"
    )
    exit /b 1
)

echo [2/3] 正在解析数据 (可能需要 5-8 分钟)...

:: 等待系统就绪
set MAX_WAIT=180
set WAITED=0
set LAST_PROGRESS=none

:wait_loop
if %WAITED% GEQ %MAX_WAIT% goto :wait_timeout

timeout /t 3 /nobreak >nul
set /a WAITED+=3

:: 检查进程是否还在运行
netstat -ano | findstr ":%PORT% " | findstr "LISTENING" >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [错误] 服务异常退出！请查看日志:
    echo   type "%LOG_FILE%"
    exit /b 1
)

:: 检查进度
findstr "数据加载完成" "%LOG_FILE%" >nul 2>&1
if %errorlevel% equ 0 if not "%LAST_PROGRESS%"=="data" (
    echo       [OK] 数据加载完成
    set LAST_PROGRESS=data
)

findstr "索引构建完成" "%LOG_FILE%" >nul 2>&1
if %errorlevel% equ 0 if not "%LAST_PROGRESS%"=="index" (
    echo       [OK] 索引构建完成
    set LAST_PROGRESS=index
)

:: 检查是否就绪
findstr "系统就绪" "%LOG_FILE%" >nul 2>&1
if %errorlevel% equ 0 goto :system_ready

goto :wait_loop

:system_ready
echo [3/3] 系统就绪
echo.

:: 获取 PID 写入文件
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%PORT% " ^| findstr "LISTENING"') do (
    echo %%a > "%PID_FILE%"
    set SERVER_PID=%%a
    goto :pid_saved
)
:pid_saved

echo.
echo ========================================
echo   [成功] 服务已启动!
echo ========================================
echo.
echo   访问地址: http://localhost:%PORT%
echo   健康检查: http://localhost:%PORT%/health
echo   API 文档: http://localhost:%PORT%/docs
echo.
echo   进程 PID: %SERVER_PID%
echo   停止命令: stop.bat
echo.
echo   按 Ctrl+C 可在当前窗口查看实时日志
echo.

:: 保持窗口打开并显示日志
echo ----------------------------------------
echo   实时日志 (按 Ctrl+C 停止):
echo ----------------------------------------
type "%LOG_FILE%"
echo.
echo [提示] 服务已在后台运行，可关闭此窗口
echo [提示] 如需停止服务，请运行: stop.bat

:: 等待用户输入（可选：查看日志）
echo.
set /p CHOICE="按回车键退出 (服务继续在后台运行)..."

exit /b 0

:wait_timeout
echo.
echo [警告] 服务仍在初始化中（解析存储过程耗时较长）
echo   请稍后访问: http://localhost:%PORT%
echo   查看日志: type "%LOG_FILE%"
exit /b 0

:show_help
echo.
echo 数据血缘分析系统 - 一键启动脚本
echo.
echo 用法: %~nx0 [--port PORT] [--dir DIR]
echo.
echo 选项:
echo   -p, --port PORT   监听端口 (默认: 8899)
echo   -d, --dir  DIR    .prc 文件目录 (默认: RRP_ORACLE)
echo   -h, --help        显示帮助信息
echo.
echo 示例:
echo   %~nx0                     # 使用默认配置启动
echo   %~nx0 -p 8080             # 使用端口 8080 启动
echo   %~nx0 -p 8080 -d data     # 使用端口 8080 和 data 目录
echo.
exit /b 0
