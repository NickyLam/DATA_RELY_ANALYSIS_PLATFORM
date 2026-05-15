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

    const NODE_TYPE_CONFIG = {
        'indicator': { label: '指标', color: '#3b82f6', bg: '#dbeafe', border: '#2563eb', shape: 'circle' },
        'measure': { label: '度量', color: '#8b5cf6', bg: '#ede9fe', border: '#7c3aed', shape: 'circle' },
        'table': { label: '源表', color: '#10b981', bg: '#d1fae5', border: '#059669', shape: 'rect' },
        'field': { label: '科目', color: '#f59e0b', bg: '#fef3c7', border: '#d97706', shape: 'diamond' },
        'procedure': { label: '过程', color: '#64748b', bg: '#f1f5f9', border: '#475569', shape: 'hexagon' },
    };

    const EDGE_TYPE_CONFIG = {
        'data_flow': { label: '数据流', style: 'solid', color: '#3b82f6' },
        'calc_dependency': { label: '计算依赖', style: 'solid', color: '#8b5cf6' },
        'gl_mapping': { label: '科目映射', style: 'dashed', color: '#f59e0b' },
    };

    function initIndicatorGraph() {
        const container = document.getElementById('indicatorGraphContainer');
        if (!container) return;

        const width = container.clientWidth || 800;
        const height = container.clientHeight || 500;

        indicatorSvg = d3.select('#indicatorSvg')
            .attr('width', width)
            .attr('height', height);

        indicatorG = indicatorSvg.append('g');

        const zoom = d3.zoom()
            .scaleExtent([0.1, 4])
            .on('zoom', (event) => {
                indicatorG.attr('transform', event.transform);
            });

        indicatorSvg.call(zoom);
    }

    window.searchIndicator = async function() {
        const keyword = document.getElementById('indicatorSearchInput').value.trim();
        if (!keyword) {
            showIndicatorMessage('请输入指标编号');
            return;
        }

        showIndicatorLoading(true);

        try {
            const response = await fetch(`${API_BASE}/search?keyword=${encodeURIComponent(keyword)}&limit=20`);
            const result = await response.json();

            if (result.success && result.data.length > 0) {
                renderIndicatorSearchResults(result.data);
            } else {
                showIndicatorMessage('未找到匹配的指标');
            }
        } catch (error) {
            showIndicatorMessage('搜索失败: ' + error.message);
        } finally {
            showIndicatorLoading(false);
        }
    };

    function renderIndicatorSearchResults(results) {
        const container = document.getElementById('indicatorSearchResults');
        container.innerHTML = '';

        results.forEach(item => {
            const div = document.createElement('div');
            div.className = 'indicator-result-item';
            div.innerHTML = `
                <div class="indicator-no">${item.index_no}</div>
                <div class="indicator-meta">
                    <span class="indicator-type">${item.source_type === 'gl' ? '总账' : '基础'}</span>
                    ${item.is_derived ? '<span class="indicator-tag">衍生</span>' : ''}
                </div>
            `;
            div.onclick = () => selectIndicator(item.index_no);
            container.appendChild(div);
        });
    }

    async function selectIndicator(indexNo) {
        currentIndicator = indexNo;
        showIndicatorLoading(true);

        try {
            const [detailRes, pipelineRes, lineageRes] = await Promise.all([
                fetch(`${API_BASE}/detail?index_no=${indexNo}`).then(r => r.json()),
                fetch(`${API_BASE}/pipeline?index_no=${indexNo}`).then(r => r.json()),
                fetch(`${API_BASE}/lineage?index_no=${indexNo}&direction=upstream&depth=5`).then(r => r.json()),
            ]);

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
        const container = document.getElementById('indicatorPipeline');
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
        if (!indicatorG) initIndicatorGraph();
        indicatorG.selectAll('*').remove();

        if (!graphData || !graphData.nodes || graphData.nodes.length === 0) {
            indicatorG.append('text')
                .attr('x', 400)
                .attr('y', 250)
                .attr('fill', '#94a3b8')
                .attr('font-size', '16px')
                .attr('text-anchor', 'middle')
                .text('未找到血缘数据');
            return;
        }

        const nodes = graphData.nodes;
        const edges = graphData.edges;

        const nodeMap = {};
        nodes.forEach(n => nodeMap[n.id] = n);

        const simulation = d3.forceSimulation(nodes)
            .force('link', d3.forceLink(edges).id(d => d.id).distance(100))
            .force('charge', d3.forceManyBody().strength(-300))
            .force('center', d3.forceCenter(400, 250))
            .force('collision', d3.forceCollide().radius(40));

        const link = indicatorG.append('g')
            .selectAll('line')
            .data(edges)
            .enter()
            .append('line')
            .attr('stroke', d => EDGE_TYPE_CONFIG[d.type]?.color || '#94a3b8')
            .attr('stroke-width', 2)
            .attr('stroke-dasharray', d => EDGE_TYPE_CONFIG[d.type]?.style === 'dashed' ? '5,5' : 'none');

        const node = indicatorG.append('g')
            .selectAll('g')
            .data(nodes)
            .enter()
            .append('g')
            .call(d3.drag()
                .on('start', dragstarted)
                .on('drag', dragged)
                .on('end', dragended));

        node.append('circle')
            .attr('r', 20)
            .attr('fill', d => NODE_TYPE_CONFIG[d.type]?.bg || '#f1f5f9')
            .attr('stroke', d => NODE_TYPE_CONFIG[d.type]?.border || '#475569')
            .attr('stroke-width', 2);

        node.append('text')
            .attr('dy', 4)
            .attr('text-anchor', 'middle')
            .attr('font-size', '10px')
            .attr('fill', '#1e293b')
            .text(d => {
                if (d.type === 'indicator' || d.type === 'measure') {
                    return d.index_no ? d.index_no.substring(0, 8) : d.id.substring(0, 8);
                }
                return d.label ? d.label.substring(0, 10) : d.id.substring(0, 10);
            });

        node.on('click', (event, d) => {
            event.stopPropagation();
            if (d.type === 'indicator' || d.type === 'measure') {
                selectIndicator(d.index_no);
            } else if (d.type === 'table') {
                bridgeToFieldLineage(d.label || d.id);
            }
        });

        node.on('mouseover', (event, d) => {
            if (d.type === 'table') {
                d3.select(event.currentTarget).select('circle')
                    .attr('stroke-width', 4)
                    .attr('stroke', '#0ea5e9');
            }
        });

        node.on('mouseout', (event, d) => {
            d3.select(event.currentTarget).select('circle')
                .attr('stroke-width', 2)
                .attr('stroke', NODE_TYPE_CONFIG[d.type]?.border || '#475569');
        });

        simulation.on('tick', () => {
            link
                .attr('x1', d => d.source.x)
                .attr('y1', d => d.source.y)
                .attr('x2', d => d.target.x)
                .attr('y2', d => d.target.y);

            node.attr('transform', d => `translate(${d.x},${d.y})`);
        });

        function dragstarted(event, d) {
            if (!event.active) simulation.alphaTarget(0.3).restart();
            d.fx = d.x;
            d.fy = d.y;
        }

        function dragged(event, d) {
            d.fx = event.x;
            d.fy = event.y;
        }

        function dragended(event, d) {
            if (!event.active) simulation.alphaTarget(0);
            d.fx = null;
            d.fy = null;
        }
    }

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
            container.innerHTML = '<div class="loading-overlay"><div class="spinner"></div><p>加载中...</p></div><svg id="indicatorSvg"></svg>';
            initIndicatorGraph();
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
    });

})();