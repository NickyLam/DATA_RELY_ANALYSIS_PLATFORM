#!/bin/bash
# ============================================
# 数据血缘分析系统 - 一键启动
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PORT=8899
DIR="RRP_ORACLE"
LOG_FILE="$SCRIPT_DIR/server.log"
PID_FILE="$SCRIPT_DIR/.server.pid"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --port|-p) PORT="$2"; shift 2 ;;
        --dir|-d)  DIR="$2";  shift 2 ;;
        --help|-h)
            echo "用法: $0 [--port PORT] [--dir DIR]"
            echo ""
            echo "选项:"
            echo "  -p, --port PORT   监听端口 (默认: 8899)"
            echo "  -d, --dir  DIR    .prc 文件目录 (默认: RRP_ORACLE)"
            echo "  -h, --help        显示帮助"
            exit 0
            ;;
        *) echo -e "${RED}未知参数: $1${NC}"; exit 1 ;;
    esac
done

# 检查 Python（自动检测 3.11+ 版本）
PYTHON_CMD=""

# 尝试按版本号查找
for ver in 3.13 3.12 3.11; do
    if command -v python${ver} &>/dev/null; then
        PYTHON_CMD="python${ver}"
        break
    fi
done

# 如果没找到特定版本，尝试 python3
if [ -z "$PYTHON_CMD" ]; then
    if command -v python3 &>/dev/null; then
        PYTHON_CMD="python3"
    else
        echo -e "${RED}错误: 未找到 Python，请先安装 Python 3.11+${NC}"
        exit 1
    fi
fi

PY_VER=$($PYTHON_CMD -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
PY_MAJOR=$(echo "$PY_VER" | cut -d. -f1)
PY_MINOR=$(echo "$PY_VER" | cut -d. -f2)
echo -e "  ${GREEN}使用 $PYTHON_CMD (版本 $PY_VER)${NC}"

if [ "$PY_MAJOR" -lt 3 ] || { [ "$PY_MAJOR" -eq 3 ] && [ "$PY_MINOR" -lt 11 ]; }; then
    echo -e "${RED}错误: Python 版本过低 ($PY_VER)，需要 3.11+${NC}"
    exit 1
fi
echo -e "  ${GREEN}python 版本符合要求${NC}"

# 检查并安装依赖
REQ_FILE="$SCRIPT_DIR/requirements.txt"
if [ -f "$REQ_FILE" ]; then
    MISSING=0
    # 逐行检查非注释非空行的包
    while IFS= read -r line; do
        # 跳过空行、注释、可选依赖说明
        line=$(echo "$line" | sed 's/#.*//' | xargs)
        [ -z "$line" ] && continue
        # 提取包名（去掉版本约束 >=、~=、== 等）
        PKG=$(echo "$line" | sed 's/[<>=!~\[].*//' | xargs)
        [ -z "$PKG" ] && continue
        # 检查是否已安装
        if ! $PYTHON_CMD -c "import importlib.metadata; importlib.metadata.distribution('$PKG')" 2>/dev/null; then
            # 对带中括号的包名（如 uvicorn[standard]）去掉括号再试
            PKG_BASE=$(echo "$PKG" | sed 's/\[.*//' | xargs)
            if ! $PYTHON_CMD -c "import importlib.metadata; importlib.metadata.distribution('$PKG_BASE')" 2>/dev/null; then
                MISSING=$((MISSING + 1))
            fi
        fi
    done < "$REQ_FILE"

    if [ "$MISSING" -gt 0 ]; then
        echo -e "  ${YELLOW}检测到 $MISSING 个依赖缺失，正在安装...${NC}"
        $PYTHON_CMD -m pip install -q -r "$REQ_FILE" 2>&1 | tail -1
        if [ $? -ne 0 ]; then
            echo -e "  ${RED}依赖安装失败，请手动执行: pip3 install -r requirements.txt${NC}"
            exit 1
        fi
        echo -e "  ${GREEN}依赖安装完成${NC}"
    else
        echo -e "  ${GREEN}依赖检查通过${NC}"
    fi
fi

# 检查核心模块能否导入
$PYTHON_CMD -c "from core.lineage_tracer import LineageTracer; from core.models import FieldMapping" 2>/dev/null || {
    echo -e "${RED}核心模块导入失败，请确认项目文件完整${NC}"
    exit 1
}

# 检查端口是否已占用
if lsof -i :$PORT -sTCP:LISTEN &>/dev/null; then
    OLD_PID=$(lsof -t -i :$PORT -sTCP:LISTEN 2>/dev/null)
    echo -e "${YELLOW}端口 $PORT 已被占用 (PID: $OLD_PID)，正在停止旧进程...${NC}"
    kill $OLD_PID 2>/dev/null
    sleep 1
    # 强制杀
    if kill -0 $OLD_PID 2>/dev/null; then
        kill -9 $OLD_PID 2>/dev/null
        sleep 1
    fi
fi

# 检查目录
if [ ! -d "$DIR" ]; then
    echo -e "${RED}目录不存在: $DIR${NC}"
    exit 1
fi

# 启动
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  数据血缘分析系统 启动中...${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "  端口: ${GREEN}$PORT${NC}"
echo -e "  目录: ${GREEN}$DIR${NC}"
echo -e "  日志: ${GREEN}$LOG_FILE${NC}"
echo ""

# 清空日志文件
> "$LOG_FILE"

# 启动服务 (FastAPI 应用)
nohup $PYTHON_CMD -m uvicorn app.main:app --host 0.0.0.0 --port $PORT --log-level info >> "$LOG_FILE" 2>&1 &
SERVER_PID=$!
echo $SERVER_PID > "$PID_FILE"

# 显示解析进度条
echo -e "${YELLOW}[1/3] 正在初始化服务...${NC}"
for i in $(seq 1 10); do
    sleep 1
    if ! kill -0 $SERVER_PID 2>/dev/null; then
        echo ""
        echo -e "${RED}服务启动失败！查看日志:${NC}"
        echo -e "  ${RED}tail -50 $LOG_FILE${NC}"
        rm -f "$PID_FILE"
        exit 1
    fi
done

echo -e "${YELLOW}[2/3] 正在加载数据（缓存优先）...${NC}"
while ! grep -q "系统就绪" "$LOG_FILE" 2>/dev/null; do
    sleep 2

    # 显示进度提示
    if grep -q "缓存加载完成" "$LOG_FILE" 2>/dev/null; then
        if [ "$LAST_PROGRESS" != "cache" ]; then
            echo -e "${GREEN}  ✅ 缓存加载完成${NC}"
            LAST_PROGRESS="cache"
        fi
    elif grep -q "全量解析完成" "$LOG_FILE" 2>/dev/null; then
        if [ "$LAST_PROGRESS" != "parse" ]; then
            echo -e "${GREEN}  ✅ 全量解析完成${NC}"
            LAST_PROGRESS="parse"
        fi
    elif grep -q "索引构建完成" "$LOG_FILE" 2>/dev/null; then
        if [ "$LAST_PROGRESS" != "index" ]; then
            echo -e "${GREEN}  ✅ 索引构建完成${NC}"
            LAST_PROGRESS="index"
        fi
    fi

    # 检查进程是否退出
    if ! kill -0 $SERVER_PID 2>/dev/null; then
        echo ""
        echo -e "${RED}服务启动失败！查看日志:${NC}"
        echo -e "  ${RED}tail -50 $LOG_FILE${NC}"
        rm -f "$PID_FILE"
        exit 1
    fi
done
echo -e "${GREEN}  ✅ 系统就绪${NC}"
echo ""

# 等待端口就绪
echo -e "${GREEN}✅ 数据加载完成！等待服务启动...${NC}"
for i in $(seq 1 30); do
    sleep 2
    if lsof -i :$PORT -sTCP:LISTEN &>/dev/null; then
        echo ""
        echo ""
        echo -e "${GREEN}服务已就绪!${NC}"
        echo ""
        echo -e "  访问地址: ${GREEN}http://localhost:$PORT${NC}"
        echo -e "  健康检查: ${GREEN}http://localhost:$PORT/health${NC}"
        echo ""
        echo -e "  PID: $SERVER_PID"
        echo -e "  停止命令: ${YELLOW}./stop.sh${NC}  或  ${YELLOW}kill $SERVER_PID${NC}"
        echo ""
        echo -e "${BLUE}----------------------------------------${NC}"
        exit 0
    fi
    echo -ne "."
done

echo ""
echo -e "${YELLOW}服务仍在初始化中，请稍后访问...${NC}"
echo -e "查看日志: ${YELLOW}tail -f $LOG_FILE${NC}"
