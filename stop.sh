#!/bin/bash
# ============================================
# 数据血缘分析系统 - 一键停止
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$SCRIPT_DIR/.server.pid"
PORT=8899

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --port|-p) PORT="$2"; shift 2 ;;
        --help|-h)
            echo "用法: $0 [--port PORT]"
            echo ""
            echo "选项:"
            echo "  -p, --port PORT   服务端口 (默认: 8899)"
            echo "  -h, --help        显示帮助"
            exit 0
            ;;
        *) echo -e "${RED}未知参数: $1${NC}"; exit 1 ;;
    esac
done

KILLED=0

# 方式1: 通过 PID 文件
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        echo -e "${YELLOW}正在停止服务 (PID: $PID)...${NC}"
        kill "$PID" 2>/dev/null
        sleep 2
        if kill -0 "$PID" 2>/dev/null; then
            kill -9 "$PID" 2>/dev/null
            sleep 1
        fi
        KILLED=1
    fi
    rm -f "$PID_FILE"
fi

# 方式2: 通过端口查找
if [ $KILLED -eq 0 ]; then
    PIDS=$(lsof -t -i :$PORT -sTCP:LISTEN 2>/dev/null || true)
    if [ -n "$PIDS" ]; then
        for PID in $PIDS; do
            echo -e "${YELLOW}正在停止服务 (PID: $PID)...${NC}"
            kill "$PID" 2>/dev/null
            sleep 2
            if kill -0 "$PID" 2>/dev/null; then
                kill -9 "$PID" 2>/dev/null
                sleep 1
            fi
        done
        KILLED=1
    fi
fi

if [ $KILLED -eq 1 ]; then
    # 确认已停止
    sleep 1
    if lsof -i :$PORT -sTCP:LISTEN &>/dev/null; then
        echo -e "${RED}停止失败，端口仍被占用${NC}"
        echo -e "请手动执行: ${YELLOW}lsof -i :$PORT | kill -9 \$(lsof -t -i :$PORT)${NC}"
        exit 1
    else
        echo -e "${GREEN}服务已停止 (端口 $PORT 已释放)${NC}"
    fi
else
    echo -e "${YELLOW}未找到运行中的服务 (端口 $PORT)${NC}"
fi
