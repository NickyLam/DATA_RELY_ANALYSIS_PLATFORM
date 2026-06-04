/**
 * 展示层 Tab 逻辑
 * D3.js 血缘图谱渲染、字段级查询、交互
 * v2.2 - 双输入框 + 垂直流向布局
 */

let svg, g, zoom;
let currentQuery = null;
let graphData = null;

const LAYER_CONFIG = {
    'ods':   { label: 'ODS源系统层',   color: '#10b981', bg: '#d1fae5', border: '#059669', order: 0 },
    'diis': { label: 'DIIS明细层',     color: '#0ea5e9', bg: '#e0f2fe', border: '#0284c7', order: 1 },
    'base': { label: 'B基础层',       color: '#6366f1', bg: '#e0e7ff', border: '#4f46e5', order: 2 },
    'mdl':  { label: 'M模型层',       color: '#a855f7', bg: '#f3e8ff', border: '#9333ea', order: 3 },
    'app':  { label: 'A/S应用汇总层', color: '#f97316', bg: '#ffedd5', border: '#ea580c', order: 4 },
    'east': { label: 'EAST报送层',     color: '#ef4444', bg: '#fee2e2', border: '#dc2626', order: 5 },
    'config': { label: '配置/临时表',  color: '#64748b', bg: '#f1f5f9', border: '#475569', order: 6 },
};

// ============================================
// 初始化展示层
// ============================================
function initDisplayTab() {
    if (!svg) {
        const container = document.querySelector('.graph-area');
        const width = container.clientWidth;
        const height = container.clientHeight;

        svg = d3.select('#graphSvg')
            .attr('width', width)
            .attr('height', height);

        svg.append('defs')
            .append('marker')
            .attr('id', 'arrow')
            .attr('viewBox', '0 -5 10 10')
            .attr('refX', 0)
            .attr('refY', 0)
            .attr('markerWidth', 8)
            .attr('markerHeight', 8)
            .attr('orient', 'auto')
            .append('path')
            .attr('d', 'M0,-4L10,0L0,4')
            .attr('fill', '#94a3b8');

        svg.append('defs')
            .append('marker')
            .attr('id', 'arrow-query')
            .attr('viewBox', '0 -5 10 10')
            .attr('refX', 0)
            .attr('refY', 0)
            .attr('markerWidth', 9)
            .attr('markerHeight', 9)
            .attr('orient', 'auto')
            .append('path')
            .attr('d', 'M0,-4L10,0L0,4')
            .attr('fill', '#6366f1');

        g = svg.append('g');

        zoom = d3.zoom()
            .scaleExtent([0.05, 4])
            .on('zoom', (event) => {
                g.attr('transform', event.transform);
            });

        svg.call(zoom);
    }

    setupSearchListeners();

    // 初始化级联查询向导
    if (typeof window.initCascadingWizard === 'function') {
        window.initCascadingWizard();
    }
}

function setupSearchListeners() {
    const tableInput = document.getElementById('tableInput');
    const fieldInput = document.getElementById('fieldInput');

    // 表名输入监听
    if (tableInput) {
        tableInput.addEventListener('input', () => onTableInput());
        tableInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                fieldInput.focus();
            }
        });
    }

    // 字段输入监听
    if (fieldInput) {
        fieldInput.addEventListener('input', () => updateQueryButton());
        fieldInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' && !document.getElementById('queryBtn').disabled) {
                executeFieldQuery();
            }
        });
    }

    // 点击外部关闭下拉
    document.addEventListener('click', (e) => {
        const searchBox = document.querySelector('.search-box');
        const results = document.getElementById('searchResults');

        if (searchBox && results && !searchBox.contains(e.target) && !results.contains(e.target)) {
            results.style.display = 'none';
        }
    });
}

// ============================================
// 表名搜索（带防抖）
// ============================================
window.onTableInput = debounce(async function () {
    const keyword = document.getElementById('tableInput').value.trim();
    const resultsContainer = document.getElementById('searchResults');

    if (!resultsContainer) return;

    if (keyword.length < 2) {
        resultsContainer.style.display = 'none';
        updateQueryButton();
        return;
    }

    try {
        const response = await apiRequest(`/api/tables?keyword=${encodeURIComponent(keyword)}&limit=15`);
        const tables = response.data || [];

        if (tables.length === 0) {
            resultsContainer.style.display = 'none';
            return;
        }

        let html = tables.map(table => `
            <div class="search-result-item" onclick="selectTable('${table.full_name}')">
                <div class="result-name">${table.short_name || table.full_name}</div>
                <div class="result-type">表 · ${table.layer || 'unknown'}</div>
            </div>
        `).join('');

        resultsContainer.innerHTML = html;
        resultsContainer.style.display = 'block';

    } catch (error) {
        console.error('搜索失败:', error);
    }
}, 250);

function selectTable(fullName) {
    // 始终显示完整表名（含 schema 前缀），让查询使用准确的全限定名
    document.getElementById('tableInput').value = fullName;

    document.getElementById('searchResults').style.display = 'none';

    // 加载该表的字段列表
    loadTableFields(fullName);
}

// 加载指定表的字段列表
async function loadTableFields(tableFullName) {
    const fieldContainer = document.getElementById('fieldListContainer');
    const fieldSelect = document.getElementById('fieldSelect');

    if (!fieldContainer || !fieldSelect) return;

    // 显示字段选择区域
    fieldContainer.style.display = 'block';
    fieldSelect.innerHTML = '<option value="">-- 加载中... --</option>';
    fieldSelect.disabled = true;

    try {
        // 调用API获取表详情（包含字段列表）
        const response = await apiRequest(`/api/tables?keyword=${encodeURIComponent(tableFullName)}&limit=1`);

        if (response.data && response.data.length > 0) {
            const tableInfo = response.data[0];

            // 如果有字段信息，显示字段列表
            if (tableInfo.columns && tableInfo.columns.length > 0) {
                let options = '<option value="">-- 请选择字段 --</option>';
                tableInfo.columns.forEach(col => {
                    options += `<option value="${col}">${col}</option>`;
                });
                fieldSelect.innerHTML = options;
                fieldSelect.disabled = false;

                console.log(`✅ 已加载 ${tableInfo.columns.length} 个字段`);
            } else {
                // 没有字段信息，提示用户手动输入
                fieldSelect.innerHTML = '<option value="">-- 无字段数据，请手动输入 --</option>';
                fieldSelect.disabled = true;

                // 自动聚焦到手动输入框
                document.getElementById('fieldInput').focus();
            }
        } else {
            fieldSelect.innerHTML = '<option value="">-- 表不存在 --</option>';
        }
    } catch (error) {
        console.error('加载字段失败:', error);
        fieldSelect.innerHTML = '<option value="">-- 加载失败，请手动输入 --</option>';
    }

    updateQueryButton();
}

// 从下拉框选择字段
function onFieldSelect() {
    const fieldSelect = document.getElementById('fieldSelect');
    const fieldValue = fieldSelect.value;

    if (fieldValue) {
        document.getElementById('fieldInput').value = fieldValue;
    }

    updateQueryButton();
}

function updateQueryButton() {
    const tableVal = document.getElementById('tableInput').value.trim();
    const fieldVal = document.getElementById('fieldInput').value.trim();
    const btn = document.getElementById('queryBtn');

    if (btn) {
        btn.disabled = !(tableVal.length >= 2 && fieldVal.length >= 1);
    }
}

// ============================================
// 执行字段级血缘查询
// ============================================
async function executeFieldQuery() {
    const tableName = document.getElementById('tableInput').value.trim();
    const fieldName = document.getElementById('fieldInput').value.trim();

    // 验证输入
    if (tableName.length < 2) {
        showNotification('请输入表名（至少2个字符）', 'warning');
        document.getElementById('tableInput').focus();
        return;
    }

    if (fieldName.length < 1) {
        showNotification('请输入字段名', 'warning');
        document.getElementById('fieldInput').focus();
        return;
    }

    // 关闭搜索结果
    document.getElementById('searchResults').style.display = 'none';

    // 显示加载状态
    document.getElementById('emptyHint').style.display = 'none';
    document.getElementById('loadingIndicator').style.display = 'block';

    try {
        // 构造完整表名（如果用户只输入了短名，尝试补全）
        let fullTableName = tableName;

        // 如果输入框中没有"."，尝试搜索完整表名
        if (!fullTableName.includes('.')) {
            console.log(`🔍 [DEBUG] 正在搜索完整表名: ${tableName}`);
            try {
                const searchResult = await apiRequest(`/api/tables?keyword=${encodeURIComponent(tableName)}&limit=5`);

                if (searchResult.data && searchResult.data.length > 0) {
                    // 优先选择：短名完全匹配的
                    let bestMatch = searchResult.data[0];

                    for (const table of searchResult.data) {
                        const short = table.full_name.split('.').pop();
                        if (short === tableName || short.toUpperCase() === tableName.toUpperCase()) {
                            bestMatch = table;
                            console.log(`✅ [DEBUG] 找到精确匹配: ${table.full_name}`);
                            break;
                        }
                    }

                    fullTableName = bestMatch.full_name;
                    console.log(`📌 [DEBUG] 使用完整表名: ${fullTableName}`);
                } else {
                    console.warn(`⚠️ [DEBUG] 未找到表名匹配: ${tableName}`);
                }
            } catch (e) {
                console.error('表名解析失败:', e);
            }
        }

        const requestBody = {
            table: fullTableName,
            field: fieldName,
            depth: AppState.queryDepth,
            mode: AppState.queryMode,
            options: {
                include_fields: false,
                limit: 100,
                use_cache: true,
            },
        };

        const response = await apiRequest('/api/lineage/query', {
            method: 'POST',
            body: JSON.stringify(requestBody),
        });

        graphData = response.data;

        // 关键修复：使用后端返回的完整表名作为当前查询目标，确保前后端一致
        const resolvedTable = graphData.query_target?.table || fullTableName;
        currentQuery = { table: resolvedTable, field: fieldName };

        // 调试日志：输出接收到的完整数据
        console.log('📊 [DEBUG] 接收到后端数据:');
        console.log(`   目标表: ${resolvedTable}`);
        console.log(`   目标字段: ${fieldName}`);
        console.log(`   节点总数: ${graphData.nodes_count}`);
        console.log(`   边总数: ${graphData.edges_count}`);
        console.log(`   字段映射数: ${graphData.field_mapping_count}`);
        console.log(`   实际节点数组长度: ${graphData.nodes?.length || 0}`);
        console.log(`   实际边数组长度: ${graphData.edges?.length || 0}`);

        if (graphData.nodes && graphData.nodes.length > 0) {
            console.log('📍 [DEBUG] 前5个节点:');
            graphData.nodes.slice(0, 5).forEach((node, i) => {
                console.log(`   ${i+1}. [${node.layer}] ${node.id || node.short_name}`);
            });
        }

        if (graphData.edges && graphData.edges.length > 0) {
            console.log('🔗 [DEBUG] 前5条边:');
            graphData.edges.slice(0, 5).forEach((edge, i) => {
                const src = edge.source_table?.split('.')?.pop() || edge.source_table;
                const tgt = edge.target_table?.split('.')?.pop() || edge.target_table;
                console.log(`   ${i+1}. ${src} → ${tgt}`);
            });
        }

        renderGraphVertical(graphData);  // 使用垂直布局
        renderDetailPanel(graphData, resolvedTable);

        document.getElementById('legend').classList.add('show');
        document.querySelector('.zoom-controls').style.display = 'flex';

        console.log(`✅ 字段级查询完成: ${fullTableName}.${fieldName}`);
        console.log(`   节点: ${graphData.nodes_count}, 边: ${graphData.edges_count}, 字段映射: ${graphData.field_mapping_count}`);

    } catch (error) {
        console.error('查询失败:', error);
        showNotification('查询失败: ' + error.message, 'error');
    }

    document.getElementById('loadingIndicator').style.display = 'none';
}

// ============================================
// 垂直流向布局渲染 (匹配附件图片效果)
// ============================================

/**
 * 获取节点相关的字段名（用于显示）
 * @param {Object} node - 当前节点
 * @param {Object} data - 完整的图数据
 * @returns {string|null} - 相关字段名，如果没有则返回null
 */
function _getNodeField(node, data) {
    // 1. 如果是查询目标节点，直接返回查询的字段
    const qt = currentQuery?.table || '';
    const isTarget = node.id === qt ||
                     (qt.includes('.') && node.id === qt) ||
                     (!qt.includes('.') && node.id.split('.').pop() === qt);
    if (currentQuery && isTarget) {
        return currentQuery.field || null;
    }

    // 2. 从边数据中查找该节点作为source或target时的字段
    const edges = data.edges || [];
    for (const edge of edges) {
        if (edge.source_table === node.id && edge.source_field) {
            return edge.source_field;
        }
        if (edge.target_table === node.id && edge.target_field) {
            return edge.target_field;
        }
    }

    // 3. 从字段映射中查找（优先显示目标字段）
    const mappings = data.field_mappings || [];
    for (const fm of mappings) {
        if (fm.target_table === node.id && fm.target_column) {
            return fm.target_column;
        }
        if (fm.source_table === node.id && fm.source_column) {
            return fm.source_column;
        }
    }

    return null;  // 没有找到相关字段
}

/**
 * 根据代际深度生成层级配置（颜色、标签等）
 * @param {number} depth - 代际深度（0=目标表，1=直接来源，...）
 * @returns {Object} - 层级配置对象
 */
function getDepthLayerConfig(depth) {
    const depthConfigs = [
        { color: '#ef4444', border: '#dc2626', bg: '#fef2f2', label: '目标层' },      // 第0层：目标表（红色）
        { color: '#f59e0b', border: '#d97706', bg: '#fffbeb', label: '第1层来源' },   // 第1层：直接来源（橙色）
        { color: '#3b82f6', border: '#2563eb', bg: '#eff6ff', label: '第2层来源' },   // 第2层（蓝色）
        { color: '#8b5cf6', border: '#7c3aed', bg: '#f5f3ff', label: '第3层来源' },   // 第3层（紫色）
        { color: '#10b981', border: '#059669', bg: '#ecfdf5', label: '第4层来源' },   // 第4层（绿色）
        { color: '#6b7280', border: '#4b5563', bg: '#f9fafb', label: '更深层来源' },  // 第5层及以上（灰色）
    ];

    const config = depthConfigs[Math.min(depth, depthConfigs.length - 1)];
    return {
        ...config,
        label: depth === 0 ? '目标表' : `第${depth}层来源`,
    };
}

function renderGraphVertical(data) {
    g.selectAll('*').remove();

    if (!data.nodes || data.nodes.length === 0) {
        g.append('text')
            .attr('x', 400)
            .attr('y', 300)
            .attr('fill', '#94a3b8')
            .attr('font-size', '16px')
            .attr('text-anchor', 'middle')
            .text('未找到相关数据');
        return;
    }

    const nodes = data.nodes;
    const edges = data.edges;

    // ========== 基于血缘关系深度的层级算法（代际关系）==========
    // 核心逻辑：
    // - 第0层：目标表
    // - 第1层：直接来源/去向表（与目标表有直接边连接）
    // - 第2层：第1层表的来源/去向表
    // - ...以此类推
    // 同一层的节点水平排列，不同层垂直排列

    const nodeDepths = {};  // 存储每个节点的深度（代数）
    // 使用后端返回的 query_target.table（完整名），确保目标表识别准确
    const targetTableId = data.query_target?.table || currentQuery?.table || '';
    console.log('DEBUG targetTableId:', targetTableId, 'currentQuery:', currentQuery, 'data.query_target:', data.query_target);

    // 构建邻接表（用于BFS）
    const adjacency = {};
    nodes.forEach(n => adjacency[n.id] = []);
    (data.edges || []).forEach(edge => {
        if (adjacency[edge.source_table]) {
            adjacency[edge.source_table].push(edge.target_table);
        }
        if (adjacency[edge.target_table]) {
            adjacency[edge.target_table].push(edge.source_table);  // 无向图，双向可达
        }
    });

    // BFS计算每个节点的深度（距离目标表的代数）
    function calculateNodeDepths() {
        const visited = new Set();
        const queue = [];

        // 找到目标节点并设置为第0层（支持完整名和短名匹配）
        let targetNode = null;
        for (const node of nodes) {
            const nodeId = node.id;
            const targetShort = targetTableId.split('.').pop() || targetTableId;

            // 优先完全匹配，其次短名匹配
            if (nodeId === targetTableId ||
                nodeId.toUpperCase() === targetTableId.toUpperCase() ||
                nodeId.split('.').pop() === targetShort ||
                nodeId.split('.').pop().toUpperCase() === targetShort.toUpperCase()) {
                targetNode = node;
                break;
            }
        }

        if (targetNode) {
            queue.push({ nodeId: targetNode.id, depth: 0 });
            visited.add(targetNode.id);
        } else {
            // 如果找不到目标表，将所有节点设为第0层
            console.warn('⚠️ 未找到目标表:', targetTableId, '可用节点:', nodes.map(n => n.id));
            nodes.forEach(node => {
                nodeDepths[node.id] = 0;
            });
            return;
        }

        while (queue.length > 0) {
            const { nodeId, depth } = queue.shift();
            nodeDepths[nodeId] = depth;

            // 遍历相邻节点（只沿血缘方向：上游→下游）
            for (const neighborId of (adjacency[nodeId] || [])) {
                if (!visited.has(neighborId) && neighborId in adjacency) {
                    visited.add(neighborId);
                    queue.push({ nodeId: neighborId, depth: depth + 1 });
                }
            }
        }

        // 处理未访问到的孤立节点（设为最大深度+1）
        const maxDepth = Math.max(...Object.values(nodeDepths), 0);
        nodes.forEach(node => {
            if (!(node.id in nodeDepths)) {
                nodeDepths[node.id] = maxDepth + 1;
                console.warn(`⚠️ 孤立节点未被访问: ${node.id}, 设为深度 ${maxDepth + 1}`);
            }
        });

        // 调试输出：打印每个节点的深度
        console.log('📊 节点深度分布:', Object.entries(nodeDepths)
            .sort((a, b) => a[1] - b[1])
            .map(([id, depth]) => `  L${depth}: ${id}`)
            .join('\n'));
    }

    // 执行BFS计算
    calculateNodeDepths();

    // 按深度分组（垂直排列）
    const layers = {};
    nodes.forEach(node => {
        const depth = nodeDepths[node.id] ?? 0;
        const layerKey = `depth_${depth}`;
        if (!layers[layerKey]) layers[layerKey] = [];
        layers[layerKey].push(node);
    });

    // 层级排序（从上到下：深度从小到大）
    const sortedLayers = Object.keys(layers).sort((a, b) => {
        const depthA = parseInt(a.split('_')[1]);
        const depthB = parseInt(b.split('_')[1]);
        return depthA - depthB;  // 目标表（深度0）在最上面
    });

    // 布局参数 - 匹配附件图片效果（优化版：支持更多信息展示）
    const nodeW = 240, nodeH = 72;          // 节点尺寸增大以容纳 schema+表名+字段名
    const layerGap = 80;                      // 层间垂直间距增加
    const nodeGapX = 30;                     // 同层节点水平间距
    const leftMargin = 120;                  // 左侧层级标签宽度
    const topMargin = 40;

    // 计算每层的布局（支持同层多行换行，避免节点过多挤在一起）
    let currentY = topMargin;
    const positions = {};
    const layerBounds = {};  // 记录每层的边界
    const containerWidth = document.querySelector('.graph-area')?.clientWidth || 1200;
    const maxRowWidth = Math.max(containerWidth - leftMargin - 40, 600);
    const nodesPerRow = Math.max(1, Math.floor(maxRowWidth / (nodeW + nodeGapX)));

    sortedLayers.forEach(layerName => {
        const layerNodes = layers[layerName];
        const depth = parseInt(layerName.split('_')[1]) || 0;

        // 根据深度生成层级配置
        const config = getDepthLayerConfig(depth);

        // 将节点分成多行（如果一行放不下）
        const rows = [];
        for (let i = 0; i < layerNodes.length; i += nodesPerRow) {
            rows.push(layerNodes.slice(i, i + nodesPerRow));
        }
        if (rows.length === 0) rows.push(layerNodes);

        const layerStartY = currentY;
        let maxRowWidthActual = 0;

        rows.forEach((row, rowIdx) => {
            const rowWidth = row.reduce((sum, _, i) => sum + nodeW + (i > 0 ? nodeGapX : 0), 0);
            maxRowWidthActual = Math.max(maxRowWidthActual, rowWidth);

            // 居中起始X位置
            let startX = leftMargin + (maxRowWidth - rowWidth) / 2;
            if (startX < leftMargin) startX = leftMargin;

            row.forEach((node, idx) => {
                const x = startX + idx * (nodeW + nodeGapX);
                const y = currentY;

                positions[node.id] = { x, y };
                node._x = x;
                node._y = y;
            });

            currentY += nodeH + 20; // 行间距
        });

        // 记录该层边界
        layerBounds[layerName] = {
            startY: layerStartY - 10,
            endY: currentY - 20 + 30,
            minX: leftMargin - 10,
            maxX: leftMargin + maxRowWidthActual + 20
        };

        currentY += layerGap;
    });

    const totalHeight = currentY + 50;

    // 绘制左侧层级标签背景（基于代际深度）
    sortedLayers.forEach(layerName => {
        const depth = parseInt(layerName.split('_')[1]) || 0;
        const config = getDepthLayerConfig(depth);
        const bounds = layerBounds[layerName];

        // 左侧标签背景条
        g.append('rect')
            .attr('x', 5)
            .attr('y', bounds.startY)
            .attr('width', leftMargin - 15)
            .attr('height', bounds.endY - bounds.startY)
            .attr('fill', config.bg)
            .attr('opacity', 0.3)
            .attr('rx', 6);

        // 层级名称（竖排显示，基于代际关系）
        const layerLabel = depth === 0 ? '目标' : `第${depth}层`;
        g.append('text')
            .attr('x', leftMargin / 2 + 5)
            .attr('y', (bounds.startY + bounds.endY) / 2)
            .attr('fill', config.border || config.color)
            .attr('font-size', '11px')
            .attr('font-weight', '700')
            .attr('text-anchor', 'middle')
            .attr('dominant-baseline', 'middle')
            .text(layerLabel);
    });

    // 绘制边（连线）- 使用最近边连接算法
    edges.forEach(edge => {
        const srcPos = positions[edge.source_table];
        const tgtPos = positions[edge.target_table];

        if (!srcPos || !tgtPos) return;

        const qt = currentQuery?.table || '';
        const isQueryNode = edge.source_table === qt || edge.target_table === qt ||
                            (!qt.includes('.') && (edge.source_table.split('.').pop() === qt || edge.target_table.split('.').pop() === qt));
        const strokeColor = isQueryNode ? '#6366f1' : '#94a3b8';
        const strokeWidth = isQueryNode ? 2 : 1.2;
        const opacity = isQueryNode ? 0.85 : 0.35;
        const marker = isQueryNode ? 'url(#arrow-query)' : 'url(#arrow)';

        // 最近边连接算法：
        // - 源节点出口点：底部边缘的X坐标限制在[srcPos.x, srcPos.x+nodeW]范围内，优先对齐目标节点中心
        // - 目标节点入口点：顶部边缘的X坐标限制在[tgtPos.x, tgtPos.x+nodeW]范围内，优先对齐源节点中心
        const srcCenterX = srcPos.x + nodeW / 2;
        const tgtCenterX = tgtPos.x + nodeW / 2;

        // 源节点出口：底部边缘，X坐标向目标中心靠拢但不超过边界
        const x1 = Math.max(srcPos.x, Math.min(srcPos.x + nodeW, tgtCenterX));
        const y1 = srcPos.y + nodeH;  // 底部

        // 目标节点入口：顶部边缘，X坐标向源中心靠拢但不超过边界
        const x2 = Math.max(tgtPos.x, Math.min(tgtPos.x + nodeW, srcCenterX));
        const y2 = tgtPos.y;  // 顶部

        // 贝塞尔曲线连接（控制点在中间Y位置）
        const midY = (y1 + y2) / 2;
        const path = `M${x1},${y1} C${x1},${midY} ${x2},${midY} ${x2},${y2}`;

        g.append('path')
            .attr('d', path)
            .attr('class', 'link-line')
            .attr('fill', 'none')
            .attr('stroke', strokeColor)
            .attr('stroke-width', strokeWidth)
            .attr('opacity', opacity)
            .attr('marker-end', marker);
    });

    // 绘制节点
    nodes.forEach(node => {
        const pos = positions[node.id];
        if (!pos) return;

        const queryTargetTable = currentQuery?.table || '';
        const isQueryTarget = node.id === queryTargetTable ||
                             (queryTargetTable.includes('.') && node.id === queryTargetTable) ||
                             (!queryTargetTable.includes('.') && node.id.split('.').pop() === queryTargetTable);
        const config = LAYER_CONFIG[node.layer] || LAYER_CONFIG['config'];

        const ng = g.append('g')
            .attr('transform', `translate(${pos.x},${pos.y})`)
            .style('cursor', 'pointer');

        // 查询目标高亮框（红色边框，类似附件图片）
        if (isQueryTarget) {
            ng.append('rect')
                .attr('x', -4).attr('y', -4)
                .attr('width', nodeW + 8).attr('height', nodeH + 8)
                .attr('fill', 'none')
                .attr('stroke', config.border || config.color)
                .attr('stroke-width', 3)
                .attr('rx', 8)
                .attr('opacity', 0.9);
        }

        // 节点背景
        ng.append('rect')
            .attr('width', nodeW).attr('height', nodeH)
            .attr('fill', isQueryTarget ? (config.color || '#ef4444') : '#ffffff')
            .attr('stroke', isQueryTarget ? '#ffffff' : (config.border || config.color))
            .attr('stroke-width', isQueryTarget ? 2 : 1.5)
            .attr('rx', 8)
            .on('click', () => showInfoPanel(node))
            .on('mouseover', function() { d3.select(this).attr('opacity', 0.85); })
            .on('mouseout', function() { d3.select(this).attr('opacity', 1); });

        // ========== 显示 Schema（用户表）+ 表名 + 字段名（无T标记，更简洁）==========

        // 第1行：Schema (如 RRP_MDL, RRP_EAST)
        const schemaName = node.id.split('.')[0] || '';
        if (schemaName) {
            ng.append('text')
                .attr('x', 12).attr('y', 18)
                .attr('fill', isQueryTarget ? '#ffd5d5' : '#64748b')
                .attr('font-size', '10px')
                .attr('font-weight', '500')
                .text(`[${schemaName}]`);
        }

        // 第2行：表名（短名，加粗显示）
        const shortName = node.id.split('.').pop();
        const displayName = shortName.length > 22 ? shortName.substring(0, 22) + '..' : shortName;
        const fontSize = shortName.length > 16 ? 11 : shortName.length > 12 ? 12 : 13;

        ng.append('text')
            .attr('x', 12).attr('y', 34)
            .attr('fill', isQueryTarget ? '#ffffff' : '#1e293b')
            .attr('font-size', `${fontSize}px`)
            .attr('font-weight', '700')  // 加粗表名
            .text(displayName);

        // 第3行：字段名（如果有相关字段信息）
        const relatedField = _getNodeField(node, data);
        if (relatedField) {
            ng.append('text')
                .attr('x', 12).attr('y', 52)
                .attr('fill', isQueryTarget ? '#ffcaca' : '#6366f1')
                .attr('font-size', '11px')
                .attr('font-weight', '600')
                .text(`→ ${relatedField}`);
        }

        // 层级标签（右下角小标签）
        const layerLabel = config.label.split(' ')[0];  // 取首字
        ng.append('rect')
            .attr('x', nodeW - 55).attr('y', nodeH - 20)
            .attr('width', 50).attr('height', 16)
            .attr('fill', config.bg || '#f1f5f9')
            .attr('rx', 3);

        ng.append('text')
            .attr('x', nodeW - 30).attr('y', nodeH - 9)
            .attr('fill', config.border || config.color)
            .attr('font-size', '9px')
            .attr('font-weight', '600')
            .attr('text-anchor', 'middle')
            .text(layerLabel.toUpperCase());
    });

    // 自动适应视图
    setTimeout(() => fitView(), 300);

    // 渲染图例
    renderLegend(layers);
}

function renderLegend(layers) {
    const legendEl = document.getElementById('legend');
    if (!legendEl) return;

    legendEl.style.display = 'block';
    let html = '';

    Object.keys(layers).sort((a, b) => {
        return (LAYER_CONFIG[a]?.order || 99) - (LAYER_CONFIG[b]?.order || 99);
    }).forEach(layer => {
        const config = LAYER_CONFIG[layer];
        if (config && layers[layer]) {
            html += `
                <div class="legend-item">
                    <div class="legend-dot" style="background:${config.color}"></div>
                    ${config.label} (${layers[layer].length})
                </div>
            `;
        }
    });

    legendEl.innerHTML = html;
}

// ============================================
// 详情面板
// ============================================
function renderDetailPanel(data, queryId) {
    const panel = document.getElementById('detailPanel');
    const content = document.getElementById('detailContent');

    if (!panel || !content) return;
    panel.style.display = 'block';

    const queryTarget = data.query_target || {};
    const targetTable = queryTarget.table || queryId;
    const targetField = queryTarget.field || currentQuery?.field;

    const upstreamEdges = data.edges.filter(e => e.target_table === targetTable);
    const downstreamEdges = data.edges.filter(e => e.source_table === targetTable);

    const upTables = [...new Set(upstreamEdges.map(e => e.source_table))];
    const downTables = [...new Set(downstreamEdges.map(e => e.target_table))];

    let html = '';

    // 查询目标高亮显示
    html += `<div style="margin-bottom:16px;padding:14px;background:linear-gradient(135deg,#fef2f2,#fff7ed);border-radius:8px;border-left:4px solid #ef4444;">
        <strong style="color:#dc2626;font-size:14px;">🎯 查询目标</strong><br>
        <span style="font-family:monospace;font-size:13px;color:#1e293b;">${targetTable.split('.').pop()}</span>
        <span style="color:#dc2626;margin:0 4px;">.</span>
        <span style="font-family:monospace;font-size:13px;color:#dc2626;font-weight:600;">${targetField || ''}</span>
        <br>
        <span style="font-size:12px;color:#64748b;margin-top:4px;display:inline-block;">
            深度: ${AppState.queryDepth}层 | 涉及: ${data.nodes_count}表, ${data.edges_count}关系 | 耗时: ${data.query_time_ms}ms
        </span>
    </div>`;

    // 字段映射列表
    if (data.field_mappings && data.field_mappings.length > 0) {
        html += `<h4 style="color:#6366f1;margin:16px 0 8px;font-size:13px;">🔗 字段血缘映射 (${data.field_mapping_count || data.field_mappings.length} 条)</h4>`;
        html += `<div style="max-height:280px;overflow-y:auto;background:#fafafa;border-radius:8px;padding:10px;border:1px solid #e2e8f0;">`;

        data.field_mappings.slice(0, 80).forEach(fm => {
            const srcShort = (fm.get ? fm.get('source_table') : fm.source_table || '').split('.').pop();
            const tgtShort = (fm.get ? fm.get('target_table') : fm.target_table || '').split('.').pop();
            const srcCol = fm.get ? fm.get('source_column') : fm.source_column;
            const tgtCol = fm.get ? fm.get('target_column') : fm.target_column;

            html += `
                <div style="padding:7px 10px;margin-bottom:4px;background:white;border-radius:5px;font-size:11px;border-left:3px solid #a855f7;display:flex;justify-content:space-between;align-items:center;">
                    <span>
                        <span style="color:#059669;font-weight:500;">${srcShort}.${srcCol}</span>
                        <span style="color:#94a3b8;margin:0 6px;">→</span>
                        <span style="color:#dc2626;font-weight:500;">${tgtShort}.${tgtCol}</span>
                    </span>
                </div>`;
        });

        if (data.field_mappings.length > 80) {
            html += `<p style="text-align:center;color:#94a3b8;font-size:11px;padding:8px;">... 还有 ${data.field_mappings.length - 80} 条映射</p>`;
        }
        html += `</div>`;
    }

    // 上游/下游表列表
    if (upTables.length > 0) {
        html += `<h4 style="color:#22c55e;margin:16px 0 8px;font-size:13px;">↑ 上游来源表 (${upTables.length})</h4>`;
        upTables.slice(0, 25).forEach(t => {
            html += `<div class="detail-row upstream" onclick="quickQuery('${t}')">
                <div class="d-name">${t.split('.').pop()}</div>
            </div>`;
        });
    }

    if (downTables.length > 0) {
        html += `<h4 style="color:#ef4444;margin:12px 0 8px;font-size:13px;">↓ 下游去向表 (${downTables.length})</h4>`;
        downTables.slice(0, 25).forEach(t => {
            html += `<div class="detail-row downstream" onclick="quickQuery('${t}')">
                <div class="d-name">${t.split('.').pop()}</div>
            </div>`;
        });
    }

    content.innerHTML = html;
}

function quickQuery(tableName) {
    // 快速切换到另一个表的查询（保留完整表名含 schema 前缀）
    document.getElementById('tableInput').value = tableName;
    document.getElementById('fieldInput').focus();
    updateQueryButton();
}

function showInfoPanel(node) {
    const panel = document.getElementById('infoPanel');
    const title = document.getElementById('panelTitle');
    const content = document.getElementById('panelContent');

    if (!panel || !title || !content) return;

    title.textContent = node.id;

    const config = LAYER_CONFIG[node.layer] || LAYER_CONFIG['config'];

    let html = `
        <div class="info-section">
            <div class="section-title">层级</div>
            <div class="section-content"><span class="tag" style="background:${config.bg};color:${config.border};">${config.label}</span></div>
        </div>
    `;

    if (node.comment) {
        html += `
            <div class="info-section">
                <div class="section-title">说明</div>
                <div class="section-content">${escapeHtml(node.comment)}</div>
            </div>
        `;
    }

    if (node.columns && node.columns.length > 0) {
        const colsHtml = node.columns.slice(0, 30)
            .map(c => `<span class="tag">${c}</span>`)
            .join('');

        html += `
            <div class="info-section">
                <div class="section-title">字段 (${node.columns.length})</div>
                <div class="section-content">${colsHtml}${node.columns.length > 30 ? `...共${node.columns.length}个` : ''}</div>
            </div>
        `;
    }

    content.innerHTML = html;
    panel.classList.add('show');
}

function closeInfoPanel() {
    const panel = document.getElementById('infoPanel');
    if (panel) panel.classList.remove('show');
}

// ============================================
// 视图控制
// ============================================
function setDepth(depth) {
    AppState.queryDepth = depth;

    // 深度选择器已移除，但仍保留此函数以备后用
    const depthBtns = document.querySelectorAll('.depth-btn');
    if (depthBtns.length > 0) {
        depthBtns.forEach(btn => {
            btn.classList.toggle('active', parseInt(btn.dataset.depth) === depth);
        });
    }

    if (currentQuery && (currentQuery.table || currentQuery.field)) {
        executeFieldQuery();
    }
}

function setMode(mode) {
    // 安全检查：不允许both模式
    if (mode === 'both') {
        console.warn('⚠️ both模式已禁用，默认使用upstream');
        mode = 'upstream';
    }

    AppState.queryMode = mode;

    document.querySelectorAll('.mode-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.mode === mode);
    });

    // 修复：不再自动触发查询，需要用户点击查询按钮后才查询
}

function resetView() {
    svg.transition().duration(500).call(zoom.transform, d3.zoomIdentity);
}

function zoomBy(factor) {
    svg.transition().duration(300).call(zoom.scaleBy, factor);
}

function fitView() {
    try {
        const bbox = g.node().getBBox();
        if (bbox.width === 0 || bbox.height === 0) return;

        const container = document.querySelector('.graph-area');
        const cw = container.clientWidth;
        const ch = container.clientHeight;

        const padding = 100;
        const scale = Math.min(
            cw / (bbox.width + padding * 2),
            ch / (bbox.height + padding * 2),
            1.0
        );

        const tx = (cw - bbox.width * scale) / 2 - bbox.x * scale + padding * scale / 2;
        const ty = (ch - bbox.height * scale) / 2 - bbox.y * scale + padding * scale / 2;

        svg.transition().duration(600).call(
            zoom.transform,
            d3.zoomIdentity.translate(tx, ty).scale(scale)
        );
    } catch (e) {}
}
