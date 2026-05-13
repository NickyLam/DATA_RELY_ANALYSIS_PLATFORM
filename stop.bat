@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: ============================================
:: 数据血缘分析系统 - 一键停止 (Windows)
:: ============================================

title 数据血缘分析系统 - 停止服务

cd /d "%~dp0"

set PORT=8899
set PID_FILE=%~dp0.server.pid
set KILLED=0

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
if /i "%~1"=="--help" goto show_help
if /i "%~1"=="-h" goto show_help
echo [错误] 未知参数: %~1
exit /b 1

:args_done

echo.
echo ========================================
echo   数据血缘分析系统 - 停止服务
echo ========================================
echo.

:: ========== 方式1: 通过 PID 文件停止 ==========
if exist "%PID_FILE%" (
    set /p PID=<"%PID_FILE%"
    if not "!PID!"=="" (
        :: 检查进程是否存在
        tasklist /FI "PID eq !PID!" /NH 2>nul | findstr /r "[0-9]" >nul 2>&1
        if !errorlevel! equ 0 (
            echo [方式1] 通过 PID 文件停止服务 (PID: !PID!)...
            taskkill /PID !PID! /F >nul 2>&1
            if !errorlevel! equ 0 (
                echo       [OK] 进程已终止
                set KILLED=1
            ) else (
                echo       [警告] 无法终止进程，可能已退出
                set KILLED=1
            )
        ) else (
            echo [提示] PID 文件中的进程 (!PID!) 已不存在
        )
    )
    del "%PID_FILE%" >nul 2>&1
)

:: ========== 方式2: 通过端口查找并停止 ==========
if %KILLED% EQU 0 (
    echo [方式2] 通过端口 %PORT% 查找进程...
    
    :: 使用 netstat 查找占用端口的 PID
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%PORT% " ^| findstr "LISTENING"') do (
        set FOUND_PID=%%a
        goto :found_by_port
    )
    goto :not_found_by_port
    
    :found_by_port
        echo       找到占用端口的进程 (PID: !FOUND_PID!)
        echo       正在停止...
        taskkill /PID !FOUND_PID! /F >nul 2>&1
        if !errorlevel! equ 0 (
            echo       [OK] 进程已终止
            set KILLED=1
        ) else (
            echo       [错误] 无法终止进程
        )
        goto :port_check_done
        
    :not_found_by_port
        echo       未找到监听端口 %PORT% 的进程
        
    :port_check_done
)

:: ========== 确认停止结果 ==========
echo.
timeout /t 1 /nobreak >nul

:: 再次检查端口是否释放
netstat -ano | findstr ":%PORT% " | findstr "LISTENING" >nul 2>&1
if %errorlevel% EQU 0 (
    echo [错误] 停止失败，端口 %PORT% 仍被占用！
    echo.
    echo   请手动执行以下命令:
    echo     1. 查看占用进程: netstat -ano ^| findstr ":%PORT%"
    echo     2. 强制结束进程:   taskkill /PID ^<PID^> /F
    exit /b 1
)

if %KILLED% EQU 1 (
    echo ========================================
    echo   [成功] 服务已停止
    echo ========================================
    echo.
    echo   端口 %PORT% 已释放
    echo   如需重新启动，请运行: start.bat
) else (
    echo ========================================
    echo   [提示] 未找到运行中的服务
    echo ========================================
    echo.
    echo   端口 %PORT% 未被占用
    echo   如需启动服务，请运行: start.bat
)

echo.
exit /b 0

:show_help
echo.
echo 数据血缘分析系统 - 一键停止脚本
echo.
echo 用法: %~nx0 [--port PORT]
echo.
echo 选项:
echo   -p, --port PORT   服务端口 (默认: 8899)
echo   -h, --help        显示帮助信息
echo.
echo 示例:
echo   %~nx0             # 停止默认端口 (8899) 的服务
echo   %~nx0 -p 8080     # 停止端口 8080 的服务
echo.
exit /b 0
