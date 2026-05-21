/**
 * 指标血缘 Tab 模块
 * 负责指标搜索、流水线展示、血缘图谱渲染
 */
(function() {
    'use strict';

    const API_BASE = '/api/indicator';
    let currentIndicator = null;
    let currentView = 'dag';
    let indicatorSvg = null;
    let indicatorG = null;
    let indicatorZoom = null;
    let d3Available = typeof d3 !== 'undefined';

    /** 检查 D3 是否可用，不可用时在图谱区域显示提示 */
    function checkD3() {
        if (!d3Available) {
            const container = document.getElementById('indicatorGraphContainer');
            if (container) {
                container.innerHTML = '<div style="display:flex;align-items:center;justify-content:center;height:100%;color:#ef4444;font-size:15px;flex-direction:column;gap:8px;"><span style="font-size:32px;">⚠️</span><span>D3.js 未加载，血缘图谱无法渲染</span><span style="font-size:12px;color:#94a3b8;">请检查网络连接或刷新页面（已切换为本地部署）</span></div>';
            }
            return false;
        }
        return true;
    }

    function initIndicatorGraph() {
        if (!checkD3()) return;
        const container = document.getElementById('indicatorGraphContainer');
        if (!container) return;

        // Tab 可能刚切换为可见，需要读取实际尺寸
        const width = container.clientWidth || 800;
        const height = container.clientHeight || 500;
        console.log('[indicator] initIndicatorGraph container size:', width, 'x', height);

        // 确保SVG元素存在
        let svgEl = document.getElementById('indicatorSvg');
        if (!svgEl) {
            svgEl = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
            svgEl.setAttribute('id', 'indicatorSvg');
            container.appendChild(svgEl);
        }

        indicatorSvg = d3.select('#indicatorSvg')
            .attr('width', width)
            .attr('height', height);

        // 移除旧的g元素和defs，避免重复叠加
        indicatorSvg.selectAll('g').remove();
        indicatorSvg.selectAll('defs').remove();

        // 添加箭头marker定义
        const defs = indicatorSvg.append('defs');
        defs.append('marker')
            .attr('id', 'indicator-arrow')
            .attr('viewBox', '0 -5 10 10')
            .attr('refX', 14).attr('refY', 0)
            .attr('markerWidth', 8).attr('markerHeight', 8)
            .attr('orient', 'auto')
            .append('path').attr('d', 'M0,-4L10,0L0,4').attr('fill', '#94a3b8');

        defs.append('marker')
            .attr('id', 'indicator-arrow-query')
            .attr('viewBox', '0 -5 10 10')
            .attr('refX', 14).attr('refY', 0)
            .attr('markerWidth', 9).attr('markerHeight', 9)
            .attr('orient', 'auto')
            .append('path').attr('d', 'M0,-4L10,0L0,4').attr('fill', '#6366f1');

        indicatorG = indicatorSvg.append('g');

        indicatorZoom = d3.zoom()
            .scaleExtent([0.1, 4])
            .on('zoom', (event) => {
                indicatorG.attr('transform', event.transform);
            });

        indicatorSvg.call(indicatorZoom);
    }

    window.searchIndicator = async function() {
        console.log('[indicator] searchIndicator START');
        const keyword = document.getElementById('indicatorSearchInput').value.trim();
        console.log('[indicator] keyword:', keyword);
        if (!keyword) {
            showIndicatorMessage('请输入指标编号');
            return;
        }

        showIndicatorLoading(true);

        try {
            console.log('[indicator] fetching...');
            const response = await fetch(`${API_BASE}/search?keyword=${encodeURIComponent(keyword)}&limit=20`);
            console.log('[indicator] response status:', response.status);
            const result = await response.json();
            console.log('[indicator] result:', result.success, 'data.length:', result.data?.length);

            if (result.success && result.data.length > 0) {
                console.log('[indicator] calling renderIndicatorSearchResults with', result.data.length, 'items');
                renderIndicatorSearchResults(result.data);
                console.log('[indicator] renderIndicatorSearchResults DONE');
            } else {
                console.log('[indicator] no results, calling showIndicatorMessage');
                showIndicatorMessage('未找到匹配的指标');
            }
        } catch (error) {
            console.error('[indicator] search ERROR:', error);
            showIndicatorMessage('搜索失败: ' + error.message);
        } finally {
            showIndicatorLoading(false);
            console.log('[indicator] searchIndicator END');
        }
    };

    function renderIndicatorSearchResults(results) {
        console.log('[indicator] renderIndicatorSearchResults START, results:', results?.length);
        const container = document.getElementById('indicatorSearchResults');
        console.log('[indicator] container:', !!container);
        if (!container) {
            console.error('[indicator] container NOT FOUND');
            return;
        }
        container.innerHTML = '';
        console.log('[indicator] cleared container');

        results.forEach((item, idx) => {
            console.log('[indicator] rendering item', idx, ':', item.index_no);
            const div = document.createElement('div');
            div.className = 'indicator-result-item';
            div.dataset.indexNo = item.index_no;

            div.innerHTML = `
                <div class="indicator-no">${item.index_no}</div>
                <div class="indicator-meta">
                    <span class="indicator-type">${item.source_type === 'gl' ? '总账' : '基础'}</span>
                    ${item.is_derived ? '<span class="indicator-tag">衍生</span>' : ''}
                </div>
            `;

            // 四重保障：直接 addEventListener（最可靠）
            div.addEventListener('click', function(e) {
                console.log('[indicator] result item clicked (direct listener):', item.index_no);
                // 视觉反馈：高亮选中项
                container.querySelectorAll('.indicator-result-item').forEach(el => {
                    el.style.background = '';
                    el.style.borderLeft = '';
                });
                div.style.background = '#e0e7ff';
                div.style.borderLeft = '3px solid #3b82f6';
                selectIndicator(item.index_no);
            });

            container.appendChild(div);
            console.log('[indicator] appended item', idx);
        });
        console.log('[indicator] renderIndicatorSearchResults END, total children:', container.children.length);
    }

    // 使用事件委托处理搜索结果点击，比单个 onclick 更可靠
    function setupResultClickDelegation() {
        const container = document.getElementById('indicatorSearchResults');
        if (!container) return;
        container.addEventListener('click', function(event) {
            const item = event.target.closest('.indicator-result-item');
            if (!item) return;
            const indexNo = item.dataset.indexNo;
            console.log('[indicator] result item clicked (delegation):', indexNo);
            // 视觉反馈：高亮选中项
            container.querySelectorAll('.indicator-result-item').forEach(el => {
                el.style.background = '';
                el.style.borderLeft = '';
            });
            item.style.background = '#e0e7ff';
            item.style.borderLeft = '3px solid #3b82f6';
            selectIndicator(indexNo);
        });
    }

    async function selectIndicator(indexNo) {
        console.log('[indicator] selectIndicator called:', indexNo);
        currentIndicator = indexNo;
        showIndicatorLoading(true);

        try {
            const [detailRes, pipelineRes, lineageRes] = await Promise.all([
                fetch(`${API_BASE}/detail?index_no=${indexNo}`).then(r => r.json()),
                fetch(`${API_BASE}/pipeline?index_no=${indexNo}`).then(r => r.json()),
                fetch(`${API_BASE}/lineage?index_no=${indexNo}&direction=both&depth=5`).then(r => r.json()),
            ]);
            console.log('[indicator] API responses - detail:', detailRes.success, 'pipeline:', pipelineRes.success, 'lineage:', lineageRes.success);

            if (detailRes.success) {
                renderIndicatorDetail(detailRes.data);
            }

            if (pipelineRes.success) {
                renderIndicatorPipeline(pipelineRes.data.steps);
            }

            if (lineageRes.success) {
                renderIndicatorGraph(lineageRes.data.graph);
            }
        } catch (error) {
            showIndicatorMessage('加载指标详情失败: ' + error.message);
        } finally {
            showIndicatorLoading(false);
        }
    }

    function renderIndicatorDetail(detail) {
        const panel = document.getElementById('indicatorDetailPanel');
        panel.style.display = 'block';
        panel.innerHTML = `
            <div class="detail-header">
                <h3>${detail.index_no}</h3>
                <button class="btn-close" onclick="closeIndicatorDetail()">×</button>
            </div>
            <div class="detail-content">
                <div class="detail-section">
                    <h4>度量配置</h4>
                    <div class="measure-list">
                        ${detail.measures.map(m => `
                            <div class="measure-item">
                                <span class="measure-code">${m.code}</span>
                                <span class="measure-label">${m.label}</span>
                                <span class="algo-type">${m.algo_label}</span>
                            </div>
                        `).join('')}
                    </div>
                </div>
                ${detail.gl_mappings.length > 0 ? `
                <div class="detail-section">
                    <h4>科目映射</h4>
                    <div class="gl-mapping-list">
                        ${detail.gl_mappings.map(m => `
                            <div class="gl-mapping-item">
                                <span>科目${m.subj_no}(${m.length_val}位)</span>
                                <span>${m.sign_label} × ${m.amt_val_label}</span>
                            </div>
                        `).join('')}
                    </div>
                </div>
                ` : ''}
                <div class="detail-section">
                    <h4>上下游关系</h4>
                    <div class="relation-list">
                        ${detail.upstream_indices.length > 0 ? `<div>上游: ${detail.upstream_indices.join(', ')}</div>` : ''}
                        ${detail.downstream_indices.length > 0 ? `<div>下游: ${detail.downstream_indices.join(', ')}</div>` : ''}
                    </div>
                </div>
            </div>
        `;
    }

    function renderIndicatorPipeline(steps) {
        console.log('[indicator] renderIndicatorPipeline steps:', steps ? steps.length : 0);
        const container = document.getElementById('indicatorPipeline');
        if (!container) {
            console.error('[indicator] indicatorPipeline container NOT FOUND');
            return;
        }
        container.innerHTML = '';

        steps.forEach(step => {
            const div = document.createElement('div');
            div.className = `pipeline-step ${step.involved ? 'involved' : 'not-involved'}`;
            div.innerHTML = `
                <div class="step-header">
                    <span class="step-order">STEP ${step.step_order}</span>
                    <span class="step-name">${step.proc_name.replace('PRO_F_INDEX_CALC_', '')}</span>
                </div>
                <div class="step-detail">${step.detail || '-'}</div>
                <div class="step-target">${step.target_table || ''}</div>
            `;
            container.appendChild(div);
        });
    }

    function renderIndicatorGraph(graphData) {
        console.log('[indicator] renderIndicatorGraph called, nodes:', graphData?.nodes?.length, 'edges:', graphData?.edges?.length);
        if (!checkD3()) return;

        const container = document.getElementById('indicatorGraphContainer');
        const overlay = container ? container.querySelector('.loading-overlay') : null;
        if (overlay) overlay.remove();

        let svgEl = document.getElementById('indicatorSvg');
        if (!svgEl && container) {
            svgEl = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
            svgEl.setAttribute('id', 'indicatorSvg');
            container.appendChild(svgEl);
        }

        initIndicatorGraph();
        indicatorG.selectAll('*').remove();

        if (!graphData || !graphData.nodes || graphData.nodes.length === 0) {
            indicatorG.append('text')
                .attr('x', 400).attr('y', 250)
                .attr('fill', '#94a3b8').attr('font-size', '16px').attr('text-anchor', 'middle')
                .text('未找到血缘数据');
            return;
        }

        // ====== 1. 数据规范化 ======
        const nodes = graphData.nodes.map(n => ({ ...n }));
        const edges = (graphData.edges || []).map(e => ({
            source: typeof e.source === 'object' ? e.source.id : e.source,
            target: typeof e.target === 'object' ? e.target.id : e.target,
            type: e.type
        }));

        const nodeMap = {};
        nodes.forEach(n => nodeMap[n.id] = n);

        // ====== 2. BFS计算节点深度（区分上游/下游方向） ======
        let targetNode = null;
        for (const node of nodes) {
            if (node.type === 'indicator' && node.index_no === currentIndicator) {
                targetNode = node;
                break;
            }
        }
        if (!targetNode) {
            for (const node of nodes) {
                if (node.type === 'indicator' || node.id === currentIndicator) {
                    targetNode = node;
                    break;
                }
            }
        }

        const nodeDepths = {};
        const upstreamAdj = {};   // 谁指向我 = 我的上游
        const downstreamAdj = {}; // 我指向谁 = 我的下游
        nodes.forEach(n => { upstreamAdj[n.id] = []; downstreamAdj[n.id] = []; });
        edges.forEach(edge => {
            if (upstreamAdj[edge.target]) upstreamAdj[edge.target].push(edge.source);
            if (downstreamAdj[edge.source]) downstreamAdj[edge.source].push(edge.target);
        });

        if (targetNode) {
            // 上游BFS：沿边反方向走（找数据来源）
            const upVisited = new Set();
            const upQueue = [{ nodeId: targetNode.id, depth: 0 }];
            upVisited.add(targetNode.id);
            const upstreamDepths = {};
            while (upQueue.length > 0) {
                const { nodeId, depth } = upQueue.shift();
                upstreamDepths[nodeId] = depth;
                for (const neighborId of (upstreamAdj[nodeId] || [])) {
                    if (!upVisited.has(neighborId) && nodeMap[neighborId]) {
                        upVisited.add(neighborId);
                        upQueue.push({ nodeId: neighborId, depth: depth + 1 });
                    }
                }
            }

            // 下游BFS：沿边正方向走（找数据去向）
            const downVisited = new Set();
            const downQueue = [{ nodeId: targetNode.id, depth: 0 }];
            downVisited.add(targetNode.id);
            const downstreamDepths = {};
            while (downQueue.length > 0) {
                const { nodeId, depth } = downQueue.shift();
                downstreamDepths[nodeId] = depth;
                for (const neighborId of (downstreamAdj[nodeId] || [])) {
                    if (!downVisited.has(neighborId) && nodeMap[neighborId]) {
                        downVisited.add(neighborId);
                        downQueue.push({ nodeId: neighborId, depth: depth + 1 });
                    }
                }
            }

            // 合并深度：上游为负（排上方），下游为正（排下方）
            nodes.forEach(node => {
                if (node.id === targetNode.id) {
                    nodeDepths[node.id] = 0;
                } else if (upstreamDepths[node.id] !== undefined && downstreamDepths[node.id] !== undefined) {
                    // 同时在上游和下游路径中（环形），优先取上游
                    nodeDepths[node.id] = -upstreamDepths[node.id];
                } else if (upstreamDepths[node.id] !== undefined) {
                    nodeDepths[node.id] = -upstreamDepths[node.id];
                } else if (downstreamDepths[node.id] !== undefined) {
                    nodeDepths[node.id] = downstreamDepths[node.id];
                } else {
                    nodeDepths[node.id] = 0; // 孤立节点放目标层
                }
            });
        } else {
            nodes.forEach(node => { nodeDepths[node.id] = 0; });
        }

        // ====== 3. 按深度分组并计算固定位置 ======
        const layers = {};
        nodes.forEach(node => {
            const depth = nodeDepths[node.id] ?? 0;
            const layerKey = `depth_${depth}`;
            if (!layers[layerKey]) layers[layerKey] = [];
            layers[layerKey].push(node);
        });

        const sortedLayers = Object.keys(layers).sort((a, b) =>
            parseInt(a.split('_')[1]) - parseInt(b.split('_')[1])
        );

        // 布局参数（矩形卡片节点）
        const nodeW = 180;
        const nodeH = 68;
        const layerGap = 100;
        const nodeGapX = 40;
        const leftMargin = 80;
        const graphStartX = leftMargin + 16;
        const topMargin = 36;

        let currentY = topMargin;
        const positions = {};
        const layerBounds = {};
        const containerWidth = container?.clientWidth || 800;
        const maxRowWidth = Math.max(containerWidth - graphStartX - 40, 400);
        const nodesPerRow = Math.max(1, Math.floor(maxRowWidth / (nodeW + nodeGapX)));

        sortedLayers.forEach(layerName => {
            const layerNodes = layers[layerName];
            const depth = parseInt(layerName.split('_')[1]) || 0;

            const rows = [];
            for (let i = 0; i < layerNodes.length; i += nodesPerRow) {
                rows.push(layerNodes.slice(i, i + nodesPerRow));
            }
            if (rows.length === 0) rows.push(layerNodes);

            const layerStartY = currentY;
            let maxRowWidthActual = 0;

            rows.forEach((row) => {
                const rowWidth = row.reduce((sum, _, i) => sum + nodeW + (i > 0 ? nodeGapX : 0), 0);
                maxRowWidthActual = Math.max(maxRowWidthActual, rowWidth);
                const startX = graphStartX + Math.max(0, (maxRowWidth - rowWidth) / 2);

                row.forEach((node, idx) => {
                    positions[node.id] = {
                        x: startX + idx * (nodeW + nodeGapX),
                        y: currentY
                    };
                    node._x = positions[node.id].x;
                    node._y = positions[node.id].y;
                });
                currentY += nodeH + 16;
            });

            layerBounds[layerName] = {
                startY: layerStartY - 8,
                endY: currentY - 16 + 20,
                minX: leftMargin - 8,
                maxX: graphStartX + maxRowWidthActual + 16
            };
            currentY += layerGap;
        });

        // ====== 4. 绘制左侧层级标签 ======
        const depthConfigs = (typeof getDepthLayerConfigShared === 'function')
            ? null
            : [
                { color: '#ef4444', border: '#dc2626', bg: '#fef2f2', label: '目标' },
                { color: '#f59e0b', border: '#d97706', bg: '#fffbeb', label: '第1层' },
                { color: '#3b82f6', border: '#2563eb', bg: '#eff6ff', label: '第2层' },
                { color: '#8b5cf6', border: '#7c3aed', bg: '#f5f3ff', label: '第3层' },
                { color: '#10b981', border: '#059669', bg: '#ecfdf5', label: '第4层' },
                { color: '#6b7280', border: '#4b5563', bg: '#f9fafb', label: '更深层' },
              ];

        sortedLayers.forEach(layerName => {
            const depth = parseInt(layerName.split('_')[1]) || 0;
            const absDepth = Math.abs(depth);
            const config = (typeof getDepthLayerConfigShared === 'function')
                ? getDepthLayerConfigShared(absDepth)
                : depthConfigs[Math.min(absDepth, depthConfigs.length - 1)];
            const bounds = layerBounds[layerName];

            indicatorG.append('rect')
                .attr('x', 2).attr('y', bounds.startY)
                .attr('width', leftMargin - 12).attr('height', bounds.endY - bounds.startY)
                .attr('fill', config.bg).attr('opacity', 0.35).attr('rx', 6);

            let layerLabel;
            if (depth < 0) {
                layerLabel = absDepth === 1 ? '上游' : `上游${absDepth}层`;
            } else if (depth === 0) {
                layerLabel = '目标';
            } else {
                layerLabel = absDepth === 1 ? '下游' : `下游${absDepth}层`;
            }
            indicatorG.append('text')
                .attr('x', leftMargin / 2 - 4).attr('y', (bounds.startY + bounds.endY) / 2)
                .attr('fill', config.border)
                .attr('font-size', '11px').attr('font-weight', '700')
                .attr('text-anchor', 'middle').attr('dominant-baseline', 'middle')
                .text(layerLabel);
        });

        // ====== 5. 绘制边（贝塞尔曲线） ======
        edges.forEach(edge => {
            const srcPos = positions[edge.source];
            const tgtPos = positions[edge.target];
            if (!srcPos || !tgtPos) return;

            const edgeConfig = getEdgeTypeConfig(edge.type);
            const strokeColor = edgeConfig.color || '#94a3b8';
            const isDashed = edgeConfig.style === 'dashed';
            const isQueryEdge = targetNode && (edge.source === targetNode.id || edge.target === targetNode.id);

            const srcCX = srcPos.x + nodeW / 2;
            const tgtCX = tgtPos.x + nodeW / 2;
            let x1, y1, x2, y2;
            if (srcPos.y + nodeH < tgtPos.y) {
                x1 = Math.max(srcPos.x, Math.min(srcPos.x + nodeW, tgtCX));
                y1 = srcPos.y + nodeH;
                x2 = Math.max(tgtPos.x, Math.min(tgtPos.x + nodeW, srcCX));
                y2 = tgtPos.y;
            } else if (srcPos.y > tgtPos.y + nodeH) {
                x1 = Math.max(srcPos.x, Math.min(srcPos.x + nodeW, tgtCX));
                y1 = srcPos.y;
                x2 = Math.max(tgtPos.x, Math.min(tgtPos.x + nodeW, srcCX));
                y2 = tgtPos.y + nodeH;
            } else {
                x1 = srcPos.x + (srcPos.x < tgtPos.x ? nodeW : 0);
                y1 = srcPos.y + nodeH / 2;
                x2 = tgtPos.x + (srcPos.x < tgtPos.x ? 0 : nodeW);
                y2 = tgtPos.y + nodeH / 2;
            }

            const midY = (y1 + y2) / 2;
            indicatorG.append('path')
                .attr('d', `M${x1},${y1} C${x1},${midY} ${x2},${midY} ${x2},${y2}`)
                .attr('fill', 'none')
                .attr('stroke', strokeColor)
                .attr('stroke-width', isQueryEdge ? 2.5 : 1.5)
                .attr('opacity', isQueryEdge ? 0.9 : 0.65)
                .attr('stroke-dasharray', isDashed ? '5,5' : 'none')
                .attr('marker-end', isQueryEdge ? 'url(#indicator-arrow-query)' : 'url(#indicator-arrow)');
        });

        // ====== 6. 绘制节点（矩形卡片，保留指标类型配色） ======
        nodes.forEach(node => {
            const pos = positions[node.id];
            if (!pos) return;

            const isTarget = targetNode && node.id === targetNode.id;
            const nodeConfig = getNodeTypeConfig(node.type);

            const ng = indicatorG.append('g')
                .attr('transform', `translate(${pos.x},${pos.y})`)
                .style('cursor', 'pointer');

            // 目标节点外框高亮
            if (isTarget) {
                ng.append('rect')
                    .attr('x', -3).attr('y', -3)
                    .attr('width', nodeW + 6).attr('height', nodeH + 6)
                    .attr('fill', 'none')
                    .attr('stroke', nodeConfig.border)
                    .attr('stroke-width', 3).attr('rx', 8).attr('opacity', 0.9);
            }

            // 主卡片
            const cardRect = ng.append('rect')
                .attr('width', nodeW).attr('height', nodeH)
                .attr('fill', isTarget ? nodeConfig.color : '#ffffff')
                .attr('stroke', isTarget ? '#ffffff' : nodeConfig.border)
                .attr('stroke-width', isTarget ? 2 : 1.5).attr('rx', 8)
                .on('click', () => {
                    if (node.type === 'indicator' || node.type === 'measure') {
                        selectIndicator(node.index_no);
                    } else if (node.type === 'table') {
                        bridgeToFieldLineage(node.label || node.id);
                    }
                })
                .on('mouseover', function() { d3.select(this).attr('opacity', 0.85); })
                .on('mouseout', function() { d3.select(this).attr('opacity', 1); });

            // 第1行：类型角标（左上角）
            ng.append('text')
                .attr('x', 10).attr('y', 16)
                .attr('fill', isTarget ? 'rgba(255,255,255,0.85)' : '#64748b')
                .attr('font-size', '10px').attr('font-weight', '500')
                .text(nodeConfig.label);

            // 第2行：主名称
            const mainText = node.type === 'indicator' || node.type === 'measure'
                ? (node.index_no || node.id)
                : (node.label || node.id);
            const displayName = mainText.length > 18 ? mainText.substring(0, 18) + '..' : mainText;
            const fontSize = mainText.length > 14 ? 11 : mainText.length > 10 ? 12 : 13;

            ng.append('text')
                .attr('x', 10).attr('y', 36)
                .attr('fill', isTarget ? '#ffffff' : '#1e293b')
                .attr('font-size', `${fontSize}px`).attr('font-weight', '700')
                .text(displayName);

            // 第3行：ID / 附加信息
            const subText = node.type === 'table' ? (node.id || '')
                : node.type === 'indicator' ? (node.label || '')
                : '';
            if (subText) {
                const shortSub = subText.length > 22 ? subText.substring(0, 22) + '..' : subText;
                ng.append('text')
                    .attr('x', 10).attr('y', 54)
                    .attr('fill', isTarget ? 'rgba(255,255,255,0.75)' : '#6366f1')
                    .attr('font-size', '10px').attr('font-weight', '500')
                    .text(shortSub);
            }

            // 右下角类型色块标签
            const badgeW = 44, badgeH = 16;
            ng.append('rect')
                .attr('x', nodeW - badgeW - 6).attr('y', nodeH - badgeH - 6)
                .attr('width', badgeW).attr('height', badgeH)
                .attr('fill', nodeConfig.bg).attr('rx', 3);
            ng.append('text')
                .attr('x', nodeW - badgeW / 2 - 6).attr('y', nodeH - badgeH / 2 - 1)
                .attr('fill', nodeConfig.border)
                .attr('font-size', '9px').attr('font-weight', '600')
                .attr('text-anchor', 'middle')
                .text(nodeConfig.label.substring(0, 2));
        });

        // ====== 7. 自动缩放适应 ======
        setTimeout(() => fitIndicatorView(), 300);
    }

    function fitIndicatorView() {
        try {
            const bbox = indicatorG.node().getBBox();
            if (bbox.width === 0 || bbox.height === 0) return;
            const container = document.getElementById('indicatorGraphContainer');
            const cw = container.clientWidth || 800;
            const ch = container.clientHeight || 500;
            const padding = 80;
            const scale = Math.min(cw / (bbox.width + padding * 2), ch / (bbox.height + padding * 2), 1.0);
            const tx = (cw - bbox.width * scale) / 2 - bbox.x * scale + padding * scale / 2;
            const ty = (ch - bbox.height * scale) / 2 - bbox.y * scale + padding * scale / 2;

            if (indicatorZoom) {
                indicatorSvg.transition().duration(600)
                    .call(indicatorZoom.transform, d3.zoomIdentity.translate(tx, ty).scale(scale));
            }
        } catch (e) {
            console.error('[indicator] fitIndicatorView error:', e);
        }
    }

    window.resetIndicatorView = function() {
        if (indicatorZoom) {
            indicatorSvg.transition().duration(500)
                .call(indicatorZoom.transform, d3.zoomIdentity);
        }
    };

    window.zoomIndicatorBy = function(factor) {
        if (indicatorZoom) {
            indicatorSvg.transition().duration(300).call(indicatorZoom.scaleBy, factor);
        }
    };

    // 暴露给 switchTab 调用，确保 Tab 切换后重新计算 SVG 尺寸
    window.initIndicatorGraphTab = function() {
        console.log('[indicator] initIndicatorGraphTab called');
        initIndicatorGraph();
    };

    // 内联 onclick 兜底处理器（绕过所有 JS 事件绑定问题）
    window._indicatorSelect = function(indexNo) {
        console.log('[indicator] _indicatorSelect called (inline fallback):', indexNo);
        selectIndicator(indexNo);
    };

    window.switchIndicatorView = function(view) {
        currentView = view;
        document.querySelectorAll('.view-btn').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.view === view);
        });
    };

    window.closeIndicatorDetail = function() {
        document.getElementById('indicatorDetailPanel').style.display = 'none';
    };

    function showIndicatorLoading(show) {
        const container = document.getElementById('indicatorGraphContainer');
        if (show) {
            // 保留已有的SVG，在上方覆盖loading层
            let overlay = container.querySelector('.loading-overlay');
            if (!overlay) {
                overlay = document.createElement('div');
                overlay.className = 'loading-overlay';
                overlay.innerHTML = '<div class="spinner"></div><p>加载中...</p>';
                container.appendChild(overlay);
            }
            overlay.style.display = '';
        } else {
            // 移除loading覆盖层
            const overlay = container.querySelector('.loading-overlay');
            if (overlay) {
                overlay.remove();
            }
        }
    }

    function showIndicatorMessage(msg) {
        const container = document.getElementById('indicatorSearchResults');
        container.innerHTML = `<div class="message-hint">${msg}</div>`;
    }

    async function bridgeToFieldLineage(tableName) {
        const cleanTableName = tableName.replace(/^TBL_/, '');
        showIndicatorLoading(true);

        try {
            const response = await fetch(`${API_BASE}/bridge-lineage?table_name=${encodeURIComponent(cleanTableName)}`);
            const result = await response.json();

            if (result.success && result.data) {
                switchTab('display');
                if (window.renderLineageGraph) {
                    window.renderLineageGraph(result.data);
                }
                if (window.setSearchInput) {
                    window.setSearchInput(cleanTableName);
                }
            } else {
                showIndicatorMessage(result.message || '未找到字段血缘数据');
            }
        } catch (error) {
            showIndicatorMessage('桥接失败: ' + error.message);
        } finally {
            showIndicatorLoading(false);
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        initIndicatorGraph();
        setupResultClickDelegation();

        // 搜索输入框 Enter 键触发搜索
        const searchInput = document.getElementById('indicatorSearchInput');
        if (searchInput) {
            searchInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    window.searchIndicator();
                }
            });
        }

        // 直接给搜索按钮绑定点击事件（不依赖 HTML onclick 属性）
        const searchBtn = document.querySelector('#indicator-tab button.btn-primary');
        if (searchBtn) {
            console.log('[indicator] binding search button click');
            searchBtn.addEventListener('click', (e) => {
                console.log('[indicator] search button clicked (direct)');
                e.preventDefault();
                e.stopPropagation();
                window.searchIndicator();
            });
        }
    });

})();