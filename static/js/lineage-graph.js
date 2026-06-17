/**
 * 展示层 - 血缘图谱渲染模块
 * 负责 D3.js SVG 图谱渲染、BFS布局算法、节点/边绘制、缩放交互
 */
(function() {
    'use strict';

    window.svg = window.svg || null;
    window.g = window.g || null;
    window.zoom = window.zoom || null;
    window.currentQuery = window.currentQuery || null;
    window.graphData = window.graphData || null;

    /** 检查 D3 是否可用，不可用时在图谱区域显示提示 */
    function checkD3() {
        if (typeof d3 === 'undefined') {
            const container = document.querySelector('.graph-area');
            if (container) {
                container.innerHTML = '<div style="display:flex;align-items:center;justify-content:center;height:100%;color:#ef4444;font-size:15px;flex-direction:column;gap:8px;"><span style="font-size:32px;">⚠️</span><span>D3.js 未加载，血缘图谱无法渲染</span><span style="font-size:12px;color:#94a3b8;">请检查网络连接或刷新页面（已切换为本地部署）</span></div>';
            }
            return false;
        }
        return true;
    }

    // 获取节点相关的字段名（legacy fallback — 仅当 node.field 不存在时使用）
    function _getNodeField(node, data) {
        // Prefer backend-provided field metadata
        if (node.field && node.field.name) return node.field.name;

        const qt = currentQuery?.table || '';
        const isTarget = node.id === qt ||
                         (qt.includes('.') && node.id === qt) ||
                         (!qt.includes('.') && node.id.split('.').pop() === qt);
        if (currentQuery && isTarget) {
            return currentQuery.field || null;
        }

        const edges = data.edges || [];
        for (const edge of edges) {
            if (edge.source_table === node.id && edge.source_field) return edge.source_field;
            if (edge.target_table === node.id && edge.target_field) return edge.target_field;
        }

        const mappings = data.field_mappings || [];
        for (const fm of mappings) {
            if (fm.target_table === node.id && fm.target_column) return fm.target_column;
            if (fm.source_table === node.id && fm.source_column) return fm.source_column;
        }

        return null;
    }

    /**
     * 获取节点字段元数据（name + data_type）。
     * 优先使用后端返回的 node.field，否则回退到边/映射查找。
     * @returns {{name: string, data_type: string}|null}
     */
    function _getNodeFieldMeta(node, data) {
        if (node.field && node.field.name) {
            return { name: node.field.name, data_type: node.field.data_type || '' };
        }
        const fallback = _getNodeField(node, data);
        return fallback ? { name: fallback, data_type: '' } : null;
    }

    /** 格式化字段标签：字段名 + 完整类型声明 */
    function _formatFieldLabel(meta) {
        if (!meta || !meta.name) return '';
        if (meta.data_type) return `${meta.name} ${meta.data_type}`;
        return meta.name;
    }

    function getDepthLayerConfig(depth) {
        if (typeof getDepthLayerConfigShared === 'function') {
            return getDepthLayerConfigShared(depth);
        }
        const depthConfigs = [
            { color: '#ef4444', border: '#dc2626', bg: '#fef2f2', label: '目标层' },
            { color: '#f59e0b', border: '#d97706', bg: '#fffbeb', label: '第1层来源' },
            { color: '#3b82f6', border: '#2563eb', bg: '#eff6ff', label: '第2层来源' },
            { color: '#8b5cf6', border: '#7c3aed', bg: '#f5f3ff', label: '第3层来源' },
            { color: '#10b981', border: '#059669', bg: '#ecfdf5', label: '第4层来源' },
            { color: '#6b7280', border: '#4b5563', bg: '#f9fafb', label: '更深层来源' },
        ];
        const config = depthConfigs[Math.min(depth, depthConfigs.length - 1)];
        return { ...config, label: depth === 0 ? '目标表' : `第${depth}层来源` };
    }

    // 垂直流向布局渲染
    window.renderGraphVertical = function(data) {
        if (!checkD3()) return;
        g.selectAll('*').remove();

        if (!data.nodes || data.nodes.length === 0) {
            g.append('text')
                .attr('x', 400).attr('y', 300)
                .attr('fill', '#94a3b8').attr('font-size', '16px').attr('text-anchor', 'middle')
                .text('未找到相关数据');
            return;
        }

        const nodes = data.nodes;
        const edges = data.edges;

        const nodeDepths = {};
        const targetTableId = data.query_target?.table || currentQuery?.table || '';

        // 构建邻接表（用于BFS）
        const adjacency = {};
        nodes.forEach(n => adjacency[n.id] = []);
        (data.edges || []).forEach(edge => {
            if (adjacency[edge.source_table]) adjacency[edge.source_table].push(edge.target_table);
            if (adjacency[edge.target_table]) adjacency[edge.target_table].push(edge.source_table);
        });

        // BFS计算每个节点的深度
        function calculateNodeDepths() {
            const visited = new Set();
            const queue = [];
            let targetNode = null;

            for (const node of nodes) {
                const nodeId = node.id;
                const targetShort = targetTableId.split('.').pop() || targetTableId;
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
                nodes.forEach(node => { nodeDepths[node.id] = 0; });
                return;
            }

            while (queue.length > 0) {
                const { nodeId, depth } = queue.shift();
                nodeDepths[nodeId] = depth;
                for (const neighborId of (adjacency[nodeId] || [])) {
                    if (!visited.has(neighborId) && neighborId in adjacency) {
                        visited.add(neighborId);
                        queue.push({ nodeId: neighborId, depth: depth + 1 });
                    }
                }
            }

            const maxDepth = Math.max(...Object.values(nodeDepths), 0);
            nodes.forEach(node => {
                if (!(node.id in nodeDepths)) nodeDepths[node.id] = maxDepth + 1;
            });
        }

        calculateNodeDepths();

        // 按深度分组
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

        // 布局参数
        const nodeW = 240, nodeH = 80;
        const layerGap = 80, nodeGapX = 30;
        const leftMargin = 96, graphStartX = leftMargin + 24, topMargin = 40;

        let currentY = topMargin;
        const positions = {};
        const layerBounds = {};
        const containerWidth = document.querySelector('.graph-area')?.clientWidth || 1200;
        const maxRowWidth = Math.max(containerWidth - graphStartX - 40, 600);
        const nodesPerRow = Math.max(1, Math.floor(maxRowWidth / (nodeW + nodeGapX)));

        sortedLayers.forEach(layerName => {
            const layerNodes = layers[layerName];
            const depth = parseInt(layerName.split('_')[1]) || 0;
            const config = getDepthLayerConfig(depth);

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
                let startX = graphStartX;
                if (row.length === nodesPerRow && rowWidth > maxRowWidth) startX = graphStartX;

                row.forEach((node, idx) => {
                    positions[node.id] = { x: startX + idx * (nodeW + nodeGapX), y: currentY };
                    node._x = positions[node.id].x;
                    node._y = positions[node.id].y;
                });
                currentY += nodeH + 20;
            });

            layerBounds[layerName] = {
                startY: layerStartY - 10,
                endY: currentY - 20 + 30,
                minX: leftMargin - 10,
                maxX: graphStartX + maxRowWidthActual + 20
            };
            currentY += layerGap;
        });

        // 绘制左侧层级标签
        sortedLayers.forEach(layerName => {
            const depth = parseInt(layerName.split('_')[1]) || 0;
            const config = getDepthLayerConfig(depth);
            const bounds = layerBounds[layerName];

            g.append('rect')
                .attr('x', 2).attr('y', bounds.startY)
                .attr('width', leftMargin - 12).attr('height', bounds.endY - bounds.startY)
                .attr('fill', config.bg).attr('opacity', 0.3).attr('rx', 6);

            const layerLabel = depth === 0 ? '目标' : `第${depth}层`;
            g.append('text')
                .attr('x', leftMargin / 2 - 4).attr('y', (bounds.startY + bounds.endY) / 2)
                .attr('fill', config.border || config.color)
                .attr('font-size', '11px').attr('font-weight', '700')
                .attr('text-anchor', 'middle').attr('dominant-baseline', 'middle')
                .text(layerLabel);
        });

        // 绘制边
        edges.forEach(edge => {
            const srcPos = positions[edge.source_table];
            const tgtPos = positions[edge.target_table];
            if (!srcPos || !tgtPos) return;

            const qt = currentQuery?.table || '';
            const qtBare = qt.includes('.') ? qt.split('.').pop() : qt;
            const srcBare = edge.source_table.includes('.') ? edge.source_table.split('.').pop() : edge.source_table;
            const tgtBare = edge.target_table.includes('.') ? edge.target_table.split('.').pop() : edge.target_table;
            const isQueryNode = edge.source_table === qt || edge.target_table === qt ||
                                srcBare === qtBare || tgtBare === qtBare;
            const strokeColor = isQueryNode ? '#6366f1' : '#94a3b8';
            const strokeWidth = isQueryNode ? 2 : 1.2;
            const opacity = isQueryNode ? 0.85 : 0.65;
            const marker = isQueryNode ? 'url(#arrow-query)' : 'url(#arrow)';

            const srcCenterX = srcPos.x + nodeW / 2;
            const tgtCenterX = tgtPos.x + nodeW / 2;

            // 根据节点相对位置确定连接点，使边始终从源节点朝向目标节点的一侧出发
            let x1, y1, x2, y2;
            if (srcPos.y < tgtPos.y) {
                // 源节点在目标节点上方：从源底边 → 目标顶边
                x1 = Math.max(srcPos.x, Math.min(srcPos.x + nodeW, tgtCenterX));
                y1 = srcPos.y + nodeH;
                x2 = Math.max(tgtPos.x, Math.min(tgtPos.x + nodeW, srcCenterX));
                y2 = tgtPos.y;
            } else {
                // 源节点在目标节点下方：从源顶边 → 目标底边
                x1 = Math.max(srcPos.x, Math.min(srcPos.x + nodeW, tgtCenterX));
                y1 = srcPos.y;
                x2 = Math.max(tgtPos.x, Math.min(tgtPos.x + nodeW, srcCenterX));
                y2 = tgtPos.y + nodeH;
            }
            const midY = (y1 + y2) / 2;

            const edgePath = g.append('path')
                .attr('d', `M${x1},${y1} C${x1},${midY} ${x2},${midY} ${x2},${y2}`)
                .attr('class', 'link-line')
                .attr('fill', 'none').attr('stroke', strokeColor)
                .attr('stroke-width', strokeWidth).attr('opacity', opacity)
                .attr('marker-end', marker);

            // 字段级边可点击查询口径详情（P3 懒加载）
            if (edge.source_field && edge.target_field) {
                edgePath.style('cursor', 'pointer')
                    .on('click', () => {
                        if (typeof showEdgePanel === 'function') showEdgePanel(edge);
                    })
                    .on('mouseover', function() {
                        d3.select(this).attr('stroke-width', strokeWidth + 1).attr('opacity', 1);
                    })
                    .on('mouseout', function() {
                        d3.select(this).attr('stroke-width', strokeWidth).attr('opacity', opacity);
                    });

                // 加宽透明热区，提升边的点击命中率
                g.append('path')
                    .attr('d', `M${x1},${y1} C${x1},${midY} ${x2},${midY} ${x2},${y2}`)
                    .attr('fill', 'none').attr('stroke', 'transparent')
                    .attr('stroke-width', 12).style('cursor', 'pointer')
                    .on('click', () => {
                        if (typeof showEdgePanel === 'function') showEdgePanel(edge);
                    });
            }
        });

        // 绘制节点
        nodes.forEach(node => {
            const pos = positions[node.id];
            if (!pos) return;

            const queryTargetTable = currentQuery?.table || '';
            const isQueryTarget = node.id === queryTargetTable ||
                                 (queryTargetTable.includes('.') && node.id === queryTargetTable) ||
                                 (!queryTargetTable.includes('.') && node.id.split('.').pop() === queryTargetTable);
            const config = getLayerConfig(node.layer, typeof getCurrentSystem === 'function' ? getCurrentSystem() : undefined);

            const ng = g.append('g')
                .attr('transform', `translate(${pos.x},${pos.y})`)
                .style('cursor', 'pointer');

            if (isQueryTarget) {
                ng.append('rect')
                    .attr('x', -4).attr('y', -4)
                    .attr('width', nodeW + 8).attr('height', nodeH + 8)
                    .attr('fill', 'none')
                    .attr('stroke', config.border || config.color)
                    .attr('stroke-width', 3).attr('rx', 8).attr('opacity', 0.9);
            }

            ng.append('rect')
                .attr('width', nodeW).attr('height', nodeH)
                .attr('fill', isQueryTarget ? (config.color || '#ef4444') : '#ffffff')
                .attr('stroke', isQueryTarget ? '#ffffff' : (config.border || config.color))
                .attr('stroke-width', isQueryTarget ? 2 : 1.5).attr('rx', 8)
                .on('click', () => {
                    if (typeof showInfoPanel === 'function') {
                        const meta = _getNodeFieldMeta(node, data);
                        showInfoPanel(node, meta);
                    }
                })
                .on('mouseover', function() { d3.select(this).attr('opacity', 0.85); })
                .on('mouseout', function() { d3.select(this).attr('opacity', 1); });

            const schemaName = node.id.split('.')[0] || '';
            if (schemaName) {
                ng.append('text')
                    .attr('x', 12).attr('y', 18)
                    .attr('fill', isQueryTarget ? '#ffd5d5' : '#64748b')
                    .attr('font-size', '10px').attr('font-weight', '500')
                    .text(`[${schemaName}]`);
            }

            const shortName = node.id.split('.').pop();
            const displayName = shortName.length > 22 ? shortName.substring(0, 22) + '..' : shortName;
            const fontSize = shortName.length > 16 ? 11 : shortName.length > 12 ? 12 : 13;

            ng.append('text')
                .attr('x', 12).attr('y', 34)
                .attr('fill', isQueryTarget ? '#ffffff' : '#1e293b')
                .attr('font-size', `${fontSize}px`).attr('font-weight', '700')
                .text(displayName);

            const fieldMeta = _getNodeFieldMeta(node, data);
            if (fieldMeta && fieldMeta.name) {
                const maxFieldChars = 28;
                const nameStr = fieldMeta.name;
                const typeStr = fieldMeta.data_type || '';
                const fullLabel = typeStr ? `${nameStr} ${typeStr}` : nameStr;

                // 截断：先截类型，再截名称
                let displayName = nameStr;
                let displayType = typeStr;
                if (fullLabel.length > maxFieldChars) {
                    if (typeStr) {
                        const nameBudget = Math.min(nameStr.length, 16);
                        displayName = nameStr.substring(0, nameBudget);
                        const typeBudget = maxFieldChars - nameBudget - 4;
                        displayType = typeBudget > 2 ? typeStr.substring(0, typeBudget) + '..' : '';
                    } else {
                        displayName = nameStr.length > maxFieldChars - 2
                            ? nameStr.substring(0, maxFieldChars - 2) + '..' : nameStr;
                    }
                }

                // 颜色方案：字段名 vs 类型 使用不同颜色
                const nameColor = isQueryTarget ? '#ffcaca' : '#6366f1';
                const typeColor = isQueryTarget ? '#fda4af' : '#0d9488';
                const noTypeColor = isQueryTarget ? '#f9a8a8' : '#94a3b8';

                const fieldText = ng.append('text')
                    .attr('x', 12).attr('y', 52)
                    .attr('font-size', '10px');

                // 字段名 tspan
                fieldText.append('tspan')
                    .attr('fill', nameColor)
                    .attr('font-weight', '600')
                    .text(`→ ${displayName}`);

                if (displayType) {
                    // 有类型：空格 + 类型名（青绿色）
                    fieldText.append('tspan')
                        .attr('fill', typeColor)
                        .attr('font-weight', '400')
                        .text(` ${displayType}`);
                } else {
                    // 无类型：淡色斜体提示
                    fieldText.append('tspan')
                        .attr('fill', noTypeColor)
                        .attr('font-weight', '400')
                        .attr('font-style', 'italic')
                        .text(' (无类型)');
                }

                // SVG tooltip: show full untruncated value
                if (fullLabel.length > maxFieldChars) {
                    fieldText.append('title').text(`→ ${fullLabel}`);
                }
            }

            const layerLabel = typeof getLayerShortLabel === 'function'
                ? getLayerShortLabel(node.layer)
                : (config.label.split(' ')[0] || config.label).toUpperCase();
            ng.append('rect')
                .attr('x', nodeW - 55).attr('y', nodeH - 20)
                .attr('width', 50).attr('height', 16)
                .attr('fill', config.bg || '#f1f5f9').attr('rx', 3);
            ng.append('text')
                .attr('x', nodeW - 30).attr('y', nodeH - 9)
                .attr('fill', config.border || config.color)
                .attr('font-size', '9px').attr('font-weight', '600')
                .attr('text-anchor', 'middle')
                .text(layerLabel.toUpperCase());
        });

        setTimeout(() => fitView(), 300);
        renderLegend(layers);
    };

    function renderLegend(layers) {
        const legendEl = document.getElementById('legend');
        if (!legendEl) return;
        legendEl.style.display = 'block';
        let html = '';
        Object.keys(layers).sort((a, b) => {
            const depthA = parseInt(a.split('_')[1]) || 0;
            const depthB = parseInt(b.split('_')[1]) || 0;
            return depthA - depthB;
        }).forEach(layerKey => {
            const depth = parseInt(layerKey.split('_')[1]) || 0;
            const config = getDepthLayerConfig(depth);
            if (config && layers[layerKey]) {
                const label = depth === 0 ? '目标表' : `第${depth}层来源`;
                html += `<div class="legend-item"><div class="legend-dot" style="background:${config.color}"></div>${label} (${layers[layerKey].length})</div>`;
            }
        });
        legendEl.innerHTML = html;
    }

    // ============================================
    // 视图控制
    // ============================================
    window.setDepth = function(depth) {
        AppState.queryDepth = depth;
        if (currentQuery && (currentQuery.table || currentQuery.field)) executeFieldQuery();
    };

    window.setMode = function(mode) {
        if (mode === 'both') mode = 'upstream';
        AppState.queryMode = mode;
        document.querySelectorAll('.mode-btn').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.mode === mode);
        });
    };

    window.resetView = function() {
        svg.transition().duration(500).call(zoom.transform, d3.zoomIdentity);
    };

    window.zoomBy = function(factor) {
        svg.transition().duration(300).call(zoom.scaleBy, factor);
    };

    window.fitView = function() {
        try {
            const bbox = g.node().getBBox();
            if (bbox.width === 0 || bbox.height === 0) return;
            const container = document.querySelector('.graph-area');
            const cw = container.clientWidth;
            const ch = container.clientHeight;
            const padding = 100;
            const scale = Math.min(cw / (bbox.width + padding * 2), ch / (bbox.height + padding * 2), 1.0);
            const tx = (cw - bbox.width * scale) / 2 - bbox.x * scale + padding * scale / 2;
            const ty = (ch - bbox.height * scale) / 2 - bbox.y * scale + padding * scale / 2;
            svg.transition().duration(600).call(zoom.transform, d3.zoomIdentity.translate(tx, ty).scale(scale));
        } catch (e) { console.warn('fitView failed:', e); }
    };

    // 初始化 D3 SVG 画布
    window.initDisplayTab = function() {
        if (!checkD3()) return;
        if (!svg) {
            const container = document.querySelector('.graph-area');
            const width = container.clientWidth;
            const height = container.clientHeight;

            svg = d3.select('#graphSvg')
                .attr('width', width).attr('height', height);

            svg.append('defs').append('marker')
                .attr('id', 'arrow').attr('viewBox', '0 -5 10 10')
                .attr('refX', 14).attr('refY', 0)
                .attr('markerWidth', 8).attr('markerHeight', 8).attr('orient', 'auto')
                .append('path').attr('d', 'M0,-4L10,0L0,4').attr('fill', '#94a3b8');

            svg.append('defs').append('marker')
                .attr('id', 'arrow-query').attr('viewBox', '0 -5 10 10')
                .attr('refX', 14).attr('refY', 0)
                .attr('markerWidth', 9).attr('markerHeight', 9).attr('orient', 'auto')
                .append('path').attr('d', 'M0,-4L10,0L0,4').attr('fill', '#6366f1');

            g = svg.append('g');

            zoom = d3.zoom()
                .scaleExtent([0.05, 4])
                .on('zoom', (event) => { g.attr('transform', event.transform); });

            svg.call(zoom);
        }

        if (typeof setupSearchListeners === 'function') {
            // 只绑定一次事件监听，防止重复
            if (!window._searchListenersInitialized) {
                setupSearchListeners();
                window._searchListenersInitialized = true;
            }
        }
    };

})();
