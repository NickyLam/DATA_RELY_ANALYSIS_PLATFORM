#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_NAME="$(basename "$SCRIPT_DIR")"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_FILE="${OUTPUT_DIR}/${PROJECT_NAME}_${TIMESTAMP}.tar.gz"

echo "╔══════════════════════════════════════╗"
echo "║     数据血缘分析系统 - 打包工具       ║"
echo "╚══════════════════════════════════════╝"
echo ""

cd "$SCRIPT_DIR"

chmod +x start.sh 2>/dev/null || true

EXCLUDE_ARGS=(
    --exclude="__pycache__"
    --exclude="*.pyc"
    --exclude=".workbuddy"
    --exclude=".DS_Store"
    --exclude="output/lineage_data.json"
    --exclude="output/lineage_graph*.html"
    --exclude="output/query_data.js"
)

echo "📦 正在打包..."
echo "   源目录: $(pwd)/"
echo "   输出文件: $(basename "$OUTPUT_FILE")"
echo "   排除: __pycache__, .pyc, .workbuddy, output/, .DS_Store"
echo ""

tar czf "$OUTPUT_FILE" "${EXCLUDE_ARGS[@]}" .

SIZE=$(du -h "$OUTPUT_FILE" | awk '{print $1}')
FILE_COUNT=$(tar tzf "$OUTPUT_FILE" | wc -l | tr -d ' ')

echo ""
echo "✅ 打包完成!"
echo "   文件: $(basename "$OUTPUT_FILE")"
echo "   大小: $SIZE"
echo "   包含: $FILE_COUNT 个文件"
echo ""
echo "📋 分发步骤:"
echo "   1. 将 $(basename "$OUTPUT_FILE") 发送给用户"
echo "   2. 用户执行:"
echo "      tar xzf $(basename "$OUTPUT_FILE")"
echo "      cd $PROJECT_NAME"
echo "      ./start.sh"
echo "   3. 浏览器打开 http://localhost:8899"
