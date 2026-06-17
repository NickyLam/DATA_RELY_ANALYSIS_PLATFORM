/**
 * 展示层 - 详情面板模块
 * 负责查询结果详情展示、节点信息浮窗
 */
(function() {
    'use strict';

    // LAYER_CONFIG 已移至 layer-config.js，通过 getLayerConfig(layer, system) 获取

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
                        <span style="color:#059669;font-weight:500;">${_escape(srcShort)}.${_escape(srcCol)}</span>
                        <span style="color:#94a3b8;margin:0 6px;">→</span>
                        <span style="color:#dc2626;font-weight:500;">${_escape(tgtShort)}.${_escape(tgtCol)}</span>
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
                html += `<div class="detail-row upstream" data-table-name="${_escape(t)}">
                    <div class="d-name">${_escape(t.split('.').pop())}</div>
                </div>`;
            });
        }

        // 下游表列表
        if (downTables.length > 0) {
            html += `<h4 style="color:#ef4444;margin:12px 0 8px;font-size:13px;">↓ 下游去向表 (${downTables.length})</h4>`;
            downTables.slice(0, 25).forEach(t => {
                html += `<div class="detail-row downstream" data-table-name="${_escape(t)}">
                    <div class="d-name">${_escape(t.split('.').pop())}</div>
                </div>`;
            });
        }

        content.innerHTML = html;
    };

    function _escape(s) {
        if (s === null || s === undefined) return '';
        if (typeof escapeHtml === 'function') return escapeHtml(String(s));
        return String(s).replace(/[&<>"']/g, c => ({
            '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
        }[c]));
    }

    // 显示节点信息浮窗（点节点时触发，懒加载 /api/lineage/node-detail）
    // field 参数兼容：
    //   - string: 旧版字段名
    //   - object {name, data_type}: 新版字段元数据
    //   - null: 无字段
    window.showInfoPanel = function(node, field) {
        const panel = document.getElementById('infoPanel');
        const title = document.getElementById('panelTitle');
        const content = document.getElementById('panelContent');

        if (!panel || !title || !content) return;

        // Normalize field argument to {name, data_type} or null
        const fieldMeta = _normalizeFieldArg(field);
        const fieldName = fieldMeta ? fieldMeta.name : null;
        const fieldType = fieldMeta ? fieldMeta.data_type : '';

        const tableShort = node.id.split('.').pop();
        title.textContent = fieldName ? `${tableShort}.${fieldName}` : node.id;

        const config = getLayerConfig(node.layer);

        let fieldSummary = '';
        if (fieldName) {
            fieldSummary = `<span style="margin-left:8px;color:#64748b;font-size:11px;">` +
                `字段: <code style="color:#6366f1;">${_escape(fieldName)}</code>`;
            if (fieldType) {
                fieldSummary += ` <code style="color:#0d9488;">${_escape(fieldType)}</code>`;
            } else {
                fieldSummary += ` <code style="color:#94a3b8;font-style:italic;">(无类型)</code>`;
            }
            fieldSummary += `</span>`;
        }

        let html = `<div class="info-section">
            <div class="section-content">
                <span class="tag" style="background:${config.bg};color:${config.border};">${config.label}</span>
                ${fieldSummary}
            </div>
        </div>`;

        if (node.comment) {
            html += `<div class="info-section">
                <div class="section-title">说明</div>
                <div class="section-content">${_escape(node.comment)}</div>
            </div>`;
        }

        html += `<div id="nodeDetailLazy" class="info-section">
            <div class="section-title">${fieldName ? '加工口径' : '详情'}</div>
            <div class="section-content" style="color:#94a3b8;font-size:12px;">加载中...</div>
        </div>`;

        content.innerHTML = html;
        panel.style.display = 'block';
        panel.classList.add('show');

        if (fieldName) {
            _loadNodeCaliber(node.id, fieldName);
        } else {
            _loadNodeDetailFallback(node);
        }
    };

    /**
     * Normalize the field argument for backward compatibility.
     * Accepts: string (legacy field name), object {name, data_type}, or null.
     * @returns {{name: string, data_type: string}|null}
     */
    function _normalizeFieldArg(field) {
        if (!field) return null;
        if (typeof field === 'string') {
            return { name: field, data_type: '' };
        }
        if (typeof field === 'object' && field.name) {
            return { name: field.name, data_type: field.data_type || '' };
        }
        return null;
    }

    function _loadNodeCaliber(table, field) {
        const url = `/api/lineage/node-caliber?table=${encodeURIComponent(table)}&field=${encodeURIComponent(field)}`;

        fetch(url)
            .then(r => r.ok ? r.json() : null)
            .then(res => {
                const data = res && res.success ? res.data : null;
                if (!data) {
                    _renderNodeCaliberEmpty(table, field);
                    return;
                }
                _renderNodeCaliber(data);
            })
            .catch(() => _renderNodeCaliberEmpty(table, field));
    }

    function _renderNodeCaliber(data) {
        const slot = document.getElementById('nodeDetailLazy');
        if (!slot) return;

        const stats = data.stats || {};
        const flags = data.data_quality_flags || {};
        const indicator = data.indicator_short || data.indicator || '';
        const tech = data.technical_caliber_summary || '';
        const chainText = data.caliber_chain_text || [];
        const tables = stats.tables || [];
        const procs = stats.procedures || [];
        const customFns = stats.custom_functions || [];
        const parallelPaths = stats.parallel_paths ?? 0;
        const totalSteps = stats.total_steps ?? 0;
        const ms = data.query_time_ms ? Number(data.query_time_ms).toFixed(0) : '-';

        let html = '';

        // ── 概览：指标 + 技术口径摘要 ──
        html += `<div class="info-section">
            <div class="section-title">🎯 指标口径</div>
            <div style="font-size:12px;color:#0f172a;font-weight:600;margin-bottom:6px;">${_escape(indicator)}</div>`;
        if (tech) {
            html += `<div style="font-size:11px;line-height:1.5;color:#334155;background:#f8fafc;border:1px solid #e2e8f0;border-radius:4px;padding:6px 8px;font-family:monospace;word-break:break-all;">${_escape(tech)}</div>`;
        }
        html += `</div>`;

        // ── 数字卡：并行路径 / 步骤 / 表 / 过程 ──
        html += `<div class="info-section">
            <div class="section-title">📊 加工统计</div>
            <div class="ov-mini">
                <div class="ov-mini-card"><div class="ov-mini-val">${parallelPaths}</div><div class="ov-mini-lbl">并行路径</div></div>
                <div class="ov-mini-card"><div class="ov-mini-val">${totalSteps}</div><div class="ov-mini-lbl">加工步骤</div></div>
                <div class="ov-mini-card"><div class="ov-mini-val">${tables.length}</div><div class="ov-mini-lbl">涉及表</div></div>
                <div class="ov-mini-card"><div class="ov-mini-val">${procs.length}</div><div class="ov-mini-lbl">存储过程</div></div>
            </div>
            <div style="margin-top:6px;font-size:11px;color:#94a3b8;text-align:right;">查询耗时 ${ms}ms</div>
        </div>`;

        // ── 涉及表 ──
        if (tables.length > 0) {
            const tableTags = tables.map(t => `<span class="step-tag tag-join">${_escape(t)}</span>`).join(' ');
            html += `<div class="info-section">
                <div class="section-title">🗄️ 涉及表 (${tables.length})</div>
                <div style="line-height:2;">${tableTags}</div>
            </div>`;
        }

        // ── 存储过程 ──
        if (procs.length > 0) {
            const procTags = procs.map(p => `<span class="step-tag tag-where" title="${_escape(p)}">${_escape(p.split('.').pop())}</span>`).join(' ');
            html += `<div class="info-section">
                <div class="section-title">⚙️ 加工过程 (${procs.length})</div>
                <div style="line-height:2;">${procTags}</div>
            </div>`;
        }

        // ── 数据质量标记 ──
        const qFlags = [];
        if (flags.has_hardcoded_values) qFlags.push(['硬编码值', 'tag-having']);
        if (flags.has_cross_schema_join) qFlags.push(['跨库 JOIN', 'tag-join']);
        if (flags.has_null_branch) qFlags.push(['NULL 分支', 'tag-distinct']);
        if (flags.has_custom_function) qFlags.push(['自定义函数', 'tag-fn']);
        if (customFns.length > 0) {
            qFlags.push([`FN: ${customFns.slice(0, 3).map(_escape).join(', ')}${customFns.length > 3 ? '...' : ''}`, 'tag-fn']);
        }
        if (qFlags.length > 0) {
            const flagTags = qFlags.map(([t, c]) => `<span class="step-tag ${c}">${_escape(t)}</span>`).join(' ');
            html += `<div class="info-section">
                <div class="section-title">⚠️ 质量标记</div>
                <div style="line-height:2;">${flagTags}</div>
            </div>`;
        }

        // ── 完整口径规格（折叠：每一步独立细节） ──
        if (chainText.length > 0) {
            const chainHtml = chainText.map((step, i) => `<div class="caliber-step-block">
                <div class="caliber-step-head">步骤 ${i + 1}</div>
                <pre class="caliber-step-text">${_escape(step)}</pre>
            </div>`).join('');
            html += `<div class="info-section caliber-spec-section">
                <div class="section-title spec-toggle">
                    <span class="spec-arrow">▶</span> 📋 完整口径规格 (${chainText.length} 步)
                </div>
                <div class="section-content spec-body" style="display:none;">${chainHtml}</div>
            </div>`;
        }

        slot.outerHTML = html;
    }

    function _renderNodeCaliberEmpty(table, field) {
        const slot = document.getElementById('nodeDetailLazy');
        if (!slot) return;
        slot.outerHTML = `<div class="info-section">
            <div class="section-content" style="color:#94a3b8;font-size:12px;">
                未找到 ${_escape(table.split('.').pop())}.${_escape(field)} 的口径数据，<br>
                可能该字段未被解析或非加工字段
            </div>
        </div>`;
    }

    function _loadNodeDetailFallback(node) {
        fetch(`/api/lineage/node-detail?table=${encodeURIComponent(node.id)}`)
            .then(r => r.ok ? r.json() : Promise.reject(r.status))
            .then(res => {
                if (!res || !res.success || !res.data) {
                    _renderNodeDetailFallback(node);
                    return;
                }
                _renderNodeDetail(res.data);
            })
            .catch(() => _renderNodeDetailFallback(node));
    };

    function _renderNodeDetail(d) {
        const slot = document.getElementById('nodeDetailLazy');
        if (!slot) return;

        let html = '';

        if (d.comment) {
            html += `<div class="info-section">
                <div class="section-title">说明</div>
                <div class="section-content">${_escape(d.comment)}</div>
            </div>`;
        }

        const fields = d.fields || [];
        if (fields.length > 0) {
            const fieldsHtml = fields.slice(0, 50).map(f => {
                const fname = f.name || f;
                const ftype = f.type
                    ? ` <span style="color:#0d9488;">(${_escape(f.type)})</span>`
                    : ` <span style="color:#94a3b8;font-style:italic;">(无类型)</span>`;
                return `<span class="tag">${_escape(fname)}${ftype}</span>`;
            }).join('');
            html += `<div class="info-section">
                <div class="section-title">字段 (${fields.length})</div>
                <div class="section-content">${fieldsHtml}${fields.length > 50 ? `<span style="color:#94a3b8;font-size:11px;">...共${fields.length}个</span>` : ''}</div>
            </div>`;
        }

        const ups = d.upstream_tables || [];
        if (ups.length > 0) {
            const upsHtml = ups.slice(0, 20).map(t =>
                `<span class="tag" style="background:#dcfce7;color:#166534;cursor:pointer;" data-table-name="${_escape(t)}">${_escape(t.split('.').pop())}</span>`
            ).join(' ');
            html += `<div class="info-section">
                <div class="section-title">↑ 上游表 (${ups.length})</div>
                <div class="section-content">${upsHtml}</div>
            </div>`;
        }

        const downs = d.downstream_tables || [];
        if (downs.length > 0) {
            const downsHtml = downs.slice(0, 20).map(t =>
                `<span class="tag" style="background:#fee2e2;color:#991b1b;cursor:pointer;" data-table-name="${_escape(t)}">${_escape(t.split('.').pop())}</span>`
            ).join(' ');
            html += `<div class="info-section">
                <div class="section-title">↓ 下游表 (${downs.length})</div>
                <div class="section-content">${downsHtml}</div>
            </div>`;
        }

        const procs = d.procedures || [];
        if (procs.length > 0) {
            const procsHtml = procs.slice(0, 10).map(p =>
                `<span class="tag" style="background:#fef3c7;color:#92400e;">${_escape(p)}</span>`
            ).join(' ');
            html += `<div class="info-section">
                <div class="section-title">关联过程 (${procs.length})</div>
                <div class="section-content">${procsHtml}</div>
            </div>`;
        }

        slot.outerHTML = html || `<div class="info-section">
            <div class="section-content" style="color:#94a3b8;font-size:12px;">无更多详情</div>
        </div>`;
    }

    function _renderNodeDetailFallback(node) {
        const slot = document.getElementById('nodeDetailLazy');
        if (!slot) return;

        if (node.columns && node.columns.length > 0) {
            const colsHtml = node.columns.slice(0, 30).map(c => `<span class="tag">${_escape(c)}</span>`).join('');
            slot.outerHTML = `<div class="info-section">
                <div class="section-title">字段 (${node.columns.length})</div>
                <div class="section-content">${colsHtml}${node.columns.length > 30 ? `...共${node.columns.length}个` : ''}</div>
            </div>`;
        } else {
            slot.outerHTML = '';
        }
    }

    // 显示边的口径详情浮窗（点边时触发，懒加载 /api/lineage/edge-caliber）
    window.showEdgePanel = function(edge) {
        const panel = document.getElementById('infoPanel');
        const title = document.getElementById('panelTitle');
        const content = document.getElementById('panelContent');

        if (!panel || !title || !content) return;

        const srcTbl = edge.source_table || '';
        const tgtTbl = edge.target_table || '';
        const srcCol = edge.source_field || '';
        const tgtCol = edge.target_field || '';

        const srcShort = srcTbl.split('.').pop();
        const tgtShort = tgtTbl.split('.').pop();
        title.textContent = `${srcShort}.${srcCol} → ${tgtShort}.${tgtCol}`;

        content.innerHTML = `<div class="info-section">
            <div class="section-title">字段映射</div>
            <div class="section-content" style="font-family:monospace;font-size:12px;">
                <div><span style="color:#059669;">${_escape(srcTbl)}</span>.<span style="color:#059669;font-weight:600;">${_escape(srcCol)}</span></div>
                <div style="color:#94a3b8;margin:4px 0;">↓</div>
                <div><span style="color:#dc2626;">${_escape(tgtTbl)}</span>.<span style="color:#dc2626;font-weight:600;">${_escape(tgtCol)}</span></div>
            </div>
        </div>
        <div id="edgeCaliberLazy" class="info-section">
            <div class="section-title">加工口径</div>
            <div class="section-content" style="color:#94a3b8;font-size:12px;">加载中...</div>
        </div>`;

        panel.style.display = 'block';
        panel.classList.add('show');

        if (!srcCol || !tgtCol) {
            _renderEdgeCaliberEmpty('该边为表级血缘，无字段口径');
            return;
        }

        const params = new URLSearchParams({
            src: srcTbl, src_col: srcCol, tgt: tgtTbl, tgt_col: tgtCol,
        });
        if (edge.procedure) params.set('proc', edge.procedure);

        fetch(`/api/lineage/edge-caliber?${params.toString()}`)
            .then(r => r.ok ? r.json() : Promise.reject(r.status))
            .then(res => {
                if (!res || !res.success || !res.data) {
                    _renderEdgeCaliberEmpty('未找到该边的加工口径');
                    return;
                }
                _renderEdgeCaliber(res.data);
            })
            .catch(() => _renderEdgeCaliberEmpty('加载失败，请稍后重试'));
    };

    function _renderEdgeCaliber(c) {
        const slot = document.getElementById('edgeCaliberLazy');
        if (!slot) return;

        let html = '';

        if (c.transform_logic) {
            html += `<div class="info-section">
                <div class="section-title">转换逻辑</div>
                <div class="section-content"><pre style="background:#f8fafc;padding:8px;border-radius:4px;font-size:12px;overflow-x:auto;white-space:pre-wrap;margin:0;">${_escape(c.transform_logic)}</pre></div>
            </div>`;
        }

        if (c.procedure) {
            html += `<div class="info-section">
                <div class="section-title">加工过程</div>
                <div class="section-content"><span class="tag" style="background:#fef3c7;color:#92400e;">${_escape(c.procedure)}</span></div>
            </div>`;
        }

        const wheres = c.where_conditions || [];
        if (wheres.length > 0) {
            const wHtml = wheres.slice(0, 10).map(w => {
                const txt = (typeof w === 'string') ? w : (w.raw_text || JSON.stringify(w));
                return `<div style="background:#fef9c3;padding:6px 8px;border-radius:4px;font-family:monospace;font-size:11px;margin-bottom:4px;">${_escape(txt)}</div>`;
            }).join('');
            html += `<div class="info-section">
                <div class="section-title">WHERE 条件 (${wheres.length})</div>
                <div class="section-content">${wHtml}</div>
            </div>`;
        }

        const joins = c.join_conditions || [];
        if (joins.length > 0) {
            const jHtml = joins.slice(0, 10).map(j => {
                const txt = (typeof j === 'string') ? j : (j.raw_text || JSON.stringify(j));
                return `<div style="background:#dbeafe;padding:6px 8px;border-radius:4px;font-family:monospace;font-size:11px;margin-bottom:4px;">${_escape(txt)}</div>`;
            }).join('');
            html += `<div class="info-section">
                <div class="section-title">JOIN 条件 (${joins.length})</div>
                <div class="section-content">${jHtml}</div>
            </div>`;
        }

        slot.outerHTML = html || `<div class="info-section">
            <div class="section-content" style="color:#94a3b8;font-size:12px;">该字段为直传，无额外口径</div>
        </div>`;
    }

    function _renderEdgeCaliberEmpty(msg) {
        const slot = document.getElementById('edgeCaliberLazy');
        if (!slot) return;
        slot.outerHTML = `<div class="info-section">
            <div class="section-content" style="color:#94a3b8;font-size:12px;">${_escape(msg)}</div>
        </div>`;
    }

    // 关闭信息浮窗
    window.closeInfoPanel = function() {
        const panel = document.getElementById('infoPanel');
        if (panel) {
            panel.style.display = 'none';
            panel.classList.remove('show');
        }
    };

    // 事件委托：spec-toggle 折叠/展开
    document.getElementById('infoPanel').addEventListener('click', function(e) {
        const toggle = e.target.closest('.spec-toggle');
        if (!toggle) return;
        const section = toggle.closest('.caliber-spec-section');
        if (!section) return;
        const body = section.querySelector('.spec-body');
        const arrow = toggle.querySelector('.spec-arrow');
        if (!body) return;
        const isHidden = body.style.display === 'none';
        body.style.display = isHidden ? 'block' : 'none';
        if (arrow) arrow.textContent = isHidden ? '▼' : '▶';
    });

    // 事件委托：处理 data-table-name 点击，替代 inline onclick（防 XSS）
    document.addEventListener('click', function(e) {
        const el = e.target.closest('[data-table-name]');
        if (!el) return;
        const tableName = el.dataset.tableName;
        if (tableName && typeof window.quickQuery === 'function') {
            window.quickQuery(tableName);
        }
    });

})();
