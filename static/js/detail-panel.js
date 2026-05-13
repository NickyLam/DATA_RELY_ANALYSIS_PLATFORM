/**
 * 展示层 - 详情面板模块
 * 负责查询结果详情展示、节点信息浮窗
 */
(function() {
    'use strict';

    const LAYER_CONFIG = {
        'ods':   { label: 'ODS源系统层',   color: '#10b981', bg: '#d1fae5', border: '#059669' },
        'diis': { label: 'DIIS明细层',     color: '#0ea5e9', bg: '#e0f2fe', border: '#0284c7' },
        'base': { label: 'B基础层',       color: '#6366f1', bg: '#e0e7ff', border: '#4f46e5' },
        'mdl':  { label: 'M模型层',       color: '#a855f7', bg: '#f3e8ff', border: '#9333ea' },
        'app':  { label: 'A/S应用汇总层', color: '#f97316', bg: '#ffedd5', border: '#ea580c' },
        'east': { label: 'EAST报送层',     color: '#ef4444', bg: '#fee2e2', border: '#dc2626' },
        'config': { label: '配置/临时表',  color: '#64748b', bg: '#f1f5f9', border: '#475569' },
    };

    function deduplicateFieldMappings(mappings) {
        const seen = new Set();
        const unique = [];

        for (const fm of mappings || []) {
            const srcBare = (fm.source_table || '').split('.').pop();
            const tgtBare = (fm.target_table || '').split('.').pop();
            const key = [
                srcBare,
                fm.source_column || '',
                tgtBare,
                fm.target_column || '',
                fm.procedure || '',
            ].map(v => String(v).toUpperCase()).join('|');

            if (seen.has(key)) continue;
            seen.add(key);
            unique.push(fm);
        }

        return unique;
    }

    // 渲染查询详情面板
    window.renderDetailPanel = function(data, queryId) {
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
        const fieldMappings = deduplicateFieldMappings(data.field_mappings || []);

        let html = '';

        // 查询目标高亮
        html += `<div style="margin-bottom:16px;padding:14px;background:linear-gradient(135deg,#fef2f2,#fff7ed);border-radius:8px;border-left:4px solid #ef4444;">
            <strong style="color:#dc2626;font-size:14px;">查询目标</strong><br>
            <span style="font-family:monospace;font-size:13px;color:#1e293b;">${targetTable.split('.').pop()}</span>
            <span style="color:#dc2626;margin:0 4px;">.</span>
            <span style="font-family:monospace;font-size:13px;color:#dc2626;font-weight:600;">${targetField || ''}</span>
            <br>
            <span style="font-size:12px;color:#64748b;margin-top:4px;display:inline-block;">
                深度: ${AppState.queryDepth}层 | 涉及: ${data.nodes_count}表, ${data.edges_count}关系 | 耗时: ${data.query_time_ms}ms
            </span>
        </div>`;

        // 字段映射列表
        if (fieldMappings.length > 0) {
            html += `<h4 style="color:#6366f1;margin:16px 0 8px;font-size:13px;">字段血缘映射 (${fieldMappings.length} 条)</h4>`;
            html += `<div style="max-height:280px;overflow-y:auto;background:#fafafa;border-radius:8px;padding:10px;border:1px solid #e2e8f0;">`;

            fieldMappings.slice(0, 80).forEach(fm => {
                const srcShort = (fm.get ? fm.get('source_table') : fm.source_table || '').split('.').pop();
                const tgtShort = (fm.get ? fm.get('target_table') : fm.target_table || '').split('.').pop();
                const srcCol = fm.get ? fm.get('source_column') : fm.source_column;
                const tgtCol = fm.get ? fm.get('target_column') : fm.target_column;

                html += `<div style="padding:7px 10px;margin-bottom:4px;background:white;border-radius:5px;font-size:11px;border-left:3px solid #a855f7;display:flex;justify-content:space-between;align-items:center;">
                    <span>
                        <span style="color:#059669;font-weight:500;">${srcShort}.${srcCol}</span>
                        <span style="color:#94a3b8;margin:0 6px;">→</span>
                        <span style="color:#dc2626;font-weight:500;">${tgtShort}.${tgtCol}</span>
                    </span>
                </div>`;
            });

            if (fieldMappings.length > 80) {
                html += `<p style="text-align:center;color:#94a3b8;font-size:11px;padding:8px;">... 还有 ${fieldMappings.length - 80} 条映射</p>`;
            }
            html += `</div>`;
        }

        // 上游表列表
        if (upTables.length > 0) {
            html += `<h4 style="color:#22c55e;margin:16px 0 8px;font-size:13px;">↑ 上游来源表 (${upTables.length})</h4>`;
            upTables.slice(0, 25).forEach(t => {
                html += `<div class="detail-row upstream" onclick="quickQuery('${t}')">
                    <div class="d-name">${t.split('.').pop()}</div>
                </div>`;
            });
        }

        // 下游表列表
        if (downTables.length > 0) {
            html += `<h4 style="color:#ef4444;margin:12px 0 8px;font-size:13px;">↓ 下游去向表 (${downTables.length})</h4>`;
            downTables.slice(0, 25).forEach(t => {
                html += `<div class="detail-row downstream" onclick="quickQuery('${t}')">
                    <div class="d-name">${t.split('.').pop()}</div>
                </div>`;
            });
        }

        content.innerHTML = html;
    };

    // 显示节点信息浮窗
    window.showInfoPanel = function(node) {
        const panel = document.getElementById('infoPanel');
        const title = document.getElementById('panelTitle');
        const content = document.getElementById('panelContent');

        if (!panel || !title || !content) return;

        title.textContent = node.id;

        const config = LAYER_CONFIG[node.layer] || LAYER_CONFIG['config'];

        let html = `<div class="info-section">
            <div class="section-title">层级</div>
            <div class="section-content"><span class="tag" style="background:${config.bg};color:${config.border};">${config.label}</span></div>
        </div>`;

        if (node.comment) {
            html += `<div class="info-section">
                <div class="section-title">说明</div>
                <div class="section-content">${escapeHtml(node.comment)}</div>
            </div>`;
        }

        if (node.columns && node.columns.length > 0) {
            const colsHtml = node.columns.slice(0, 30)
                .map(c => `<span class="tag">${c}</span>`)
                .join('');

            html += `<div class="info-section">
                <div class="section-title">字段 (${node.columns.length})</div>
                <div class="section-content">${colsHtml}${node.columns.length > 30 ? `...共${node.columns.length}个` : ''}</div>
            </div>`;
        }

        content.innerHTML = html;
        panel.classList.add('show');
    };

    // 关闭信息浮窗
    window.closeInfoPanel = function() {
        const panel = document.getElementById('infoPanel');
        if (panel) panel.classList.remove('show');
    };

})();
