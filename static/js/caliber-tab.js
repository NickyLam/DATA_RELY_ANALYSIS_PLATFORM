/**
 * 指标口径查询 Tab 交互逻辑
 * 负责口径查询的搜索、结果展示和链路可视化
 * 
 * v3.0: 三层 Pipeline 可视化 — 概览卡 + 水平链路图 + 点击展开详情抽屉
 */

const CaliberTab = {
    initialized: false,
    _tableFields: [],
    _tableFullName: '',
    _lastSearchResults: [],
    _searchSeq: 0,
    _searchCache: new Map(),
    _caliberFields: [],
    _caliberFieldsLoaded: false,
    _activeDrawerStepIdx: null,  // 当前打开详情抽屉的步骤索引
    _lastCaliberData: null,      // 缓存最新口径数据
};

function initCaliberTab() {
    if (CaliberTab.initialized) return;
    CaliberTab.initialized = true;

    const tableInput = document.getElementById('caliberTableInput');
    const fieldInput = document.getElementById('caliberFieldInput');

    if (tableInput) {
        tableInput.addEventListener('input', debounce(caliberTableSearch, 250));
        tableInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                const dropdown = document.getElementById('caliberTableResults');
                if (dropdown && dropdown.style.display !== 'none') {
                    const firstItem = dropdown.querySelector('.search-result-item');
                    if (firstItem) firstItem.click();
                }
            }
        });
    }

    if (fieldInput) {
        fieldInput.addEventListener('input', debounce(caliberFieldFilter, 150));
        fieldInput.addEventListener('focus', () => {
            if (!fieldInput.disabled && CaliberTab._tableFields.length > 0) {
                if (!fieldInput.value.trim()) {
                    caliberShowAllFields();
                } else {
                    caliberFieldFilter();
                }
            }
        });
        fieldInput.addEventListener('keydown', (e) => {
            if (e.key === 'Tab') {
                const dropdown = document.getElementById('caliberFieldResults');
                if (dropdown && dropdown.style.display !== 'none') {
                    const firstItem = dropdown.querySelector('.field-item');
                    if (firstItem) { e.preventDefault(); firstItem.click(); }
                }
            }
            if (e.key === 'Enter') {
                executeCaliberQuery();
            }
        });
    }

    document.addEventListener('click', (e) => {
        const tableDropdown = document.getElementById('caliberTableResults');
        const fieldDropdown = document.getElementById('caliberFieldResults');
        const tableGroup = tableInput?.closest('.input-group');
        const fieldGroup = fieldInput?.closest('.input-group');

        if (tableDropdown && tableGroup && !tableGroup.contains(e.target)) {
            tableDropdown.style.display = 'none';
        }
        if (fieldDropdown && fieldGroup && !fieldGroup.contains(e.target)) {
            fieldDropdown.style.display = 'none';
        }
    });

    console.log('🎯 指标口径模块 v3.0 已初始化（Pipeline 可视化）');
}

async function caliberTableSearch() {
    const keyword = document.getElementById('caliberTableInput').value.trim();
    const resultsContainer = document.getElementById('caliberTableResults');

    if (!resultsContainer || keyword.length < 2) {
        if (resultsContainer) resultsContainer.style.display = 'none';
        return;
    }

    const cacheKey = keyword.toUpperCase();
    const seq = ++CaliberTab._searchSeq;
    let tables = CaliberTab._searchCache.get(cacheKey);

    if (!tables) {
        try {
            const response = await apiRequest(`/api/tables?keyword=${encodeURIComponent(keyword)}&limit=15`);
            if (seq !== CaliberTab._searchSeq) return;
            tables = response.data || [];
            CaliberTab._searchCache.set(cacheKey, tables);
        } catch (error) {
            console.error('口径表搜索失败:', error);
            return;
        }
    }

    if (tables.length === 0) {
        resultsContainer.style.display = 'none';
        return;
    }

    CaliberTab._lastSearchResults = tables;

    let html = tables.map((table, idx) => {
        const schemaLabel = table.schema ? `<span style="color:#6366f1;font-weight:600;">${table.schema}</span>.` : '';
        return `
        <div class="search-result-item" onclick="caliberSelectTable('${table.full_name}', ${idx})">
            <div class="result-name">${schemaLabel}${table.short_name || table.full_name}</div>
            <div class="result-type">表 · ${table.layer || 'unknown'} · ${table.field_count || 0} 字段</div>
        </div>
    `}).join('');

    resultsContainer.innerHTML = html;
    resultsContainer.style.display = 'block';
}

function caliberSelectTable(fullName, searchIdx) {
    document.getElementById('caliberTableInput').value = fullName;
    document.getElementById('caliberTableResults').style.display = 'none';

    CaliberTab._tableFullName = fullName;
    CaliberTab._tableFields = [];
    CaliberTab._caliberFields = [];
    CaliberTab._caliberFieldsLoaded = false;

    const fieldInput = document.getElementById('caliberFieldInput');
    fieldInput.value = '';
    fieldInput.disabled = true;
    fieldInput.placeholder = '加载字段中...';
    fieldInput.classList.remove('valid', 'invalid');
    document.getElementById('caliberFieldResults').style.display = 'none';

    if (searchIdx !== undefined && CaliberTab._lastSearchResults[searchIdx]) {
        const columns = CaliberTab._lastSearchResults[searchIdx].columns;
        if (columns && columns.length > 0) {
            CaliberTab._tableFields = columns.map(f => String(f).toUpperCase());
        }
    }

    caliberLoadFields(fullName);
}

async function caliberLoadFields(tableFullName) {
    const fieldInput = document.getElementById('caliberFieldInput');

    try {
        const shortName = tableFullName.split('.').pop();

        const [tableResp, caliberResp] = await Promise.allSettled([
            apiRequest(`/api/tables?keyword=${encodeURIComponent(shortName)}&limit=10`),
            apiRequest(`/api/caliber/fields?table=${encodeURIComponent(tableFullName)}`),
        ]);

        let tableFields = [];
        if (tableResp.status === 'fulfilled' && tableResp.value.data) {
            const tables = tableResp.value.data;
            const matched = tables.find(t =>
                t.full_name === tableFullName ||
                t.full_name.toUpperCase() === tableFullName.toUpperCase() ||
                t.short_name.toUpperCase() === shortName.toUpperCase()
            );
            if (matched && matched.columns && matched.columns.length > 0) {
                tableFields = matched.columns.map(f => String(f).toUpperCase());
            }
        }

        let caliberFieldSet = new Set();
        if (caliberResp.status === 'fulfilled' && caliberResp.value.success && caliberResp.value.data) {
            const caliberFields = caliberResp.value.data.fields || [];
            CaliberTab._caliberFields = caliberFields;
            CaliberTab._caliberFieldsLoaded = true;
            caliberFields.forEach(f => caliberFieldSet.add(f.field.toUpperCase()));
        }

        const caliberOnly = [];
        const nonCaliber = [];
        for (const f of tableFields) {
            if (caliberFieldSet.has(f)) {
                caliberOnly.push(f);
            } else {
                nonCaliber.push(f);
            }
        }
        for (const cf of CaliberTab._caliberFields) {
            const upper = cf.field.toUpperCase();
            if (!tableFields.includes(upper)) {
                caliberOnly.push(upper);
            }
        }

        CaliberTab._tableFields = caliberOnly.concat(nonCaliber);

        if (CaliberTab._tableFields.length > 0) {
            fieldInput.disabled = false;
            const caliberCount = caliberOnly.length;
            fieldInput.placeholder = CaliberTab._caliberFieldsLoaded
                ? `${CaliberTab._tableFields.length} 个字段（${caliberCount} 个有口径数据）`
                : `从 ${CaliberTab._tableFields.length} 个字段中选择`;
        } else {
            fieldInput.disabled = false;
            fieldInput.placeholder = '该表无字段数据，可手动输入';
        }
    } catch (error) {
        console.error('口径字段加载失败:', error);
        fieldInput.disabled = false;
        fieldInput.placeholder = '字段加载失败，可手动输入';
        CaliberTab._tableFields = [];
    }

    fieldInput.focus();
}

function caliberShowAllFields() {
    const fieldDropdown = document.getElementById('caliberFieldResults');
    if (!fieldDropdown || CaliberTab._tableFields.length === 0) return;

    const caliberFieldSet = new Set(
        CaliberTab._caliberFields.map(f => f.field.toUpperCase())
    );

    const display = CaliberTab._tableFields.slice(0, 50);
    let html = display.map(f => {
        const hasCaliber = CaliberTab._caliberFieldsLoaded && caliberFieldSet.has(f);
        const badge = hasCaliber
            ? '<span style="display:inline-block;padding:0 4px;background:#dcfce7;color:#166534;border-radius:3px;font-size:9px;font-weight:700;margin-left:6px;">口径</span>'
            : '';
        return `<div class="field-item" onclick="caliberSelectField('${f}')">
            <span class="field-name">${f}${badge}</span>
        </div>`;
    }).join('');

    if (CaliberTab._tableFields.length > 50) {
        html += `<div class="field-empty">... 还有 ${CaliberTab._tableFields.length - 50} 个字段</div>`;
    }

    fieldDropdown.innerHTML = html;
    fieldDropdown.style.display = 'block';
}

function caliberFieldFilter() {
    const fieldInput = document.getElementById('caliberFieldInput');
    const fieldDropdown = document.getElementById('caliberFieldResults');
    const keyword = fieldInput.value.trim();

    fieldInput.classList.remove('valid', 'invalid');

    if (!keyword || CaliberTab._tableFields.length === 0) {
        fieldDropdown.style.display = 'none';
        return;
    }

    const keywordUpper = keyword.toUpperCase();
    const matched = CaliberTab._tableFields.filter(f => f.includes(keywordUpper));

    const caliberFieldSet = new Set(
        CaliberTab._caliberFields.map(f => f.field.toUpperCase())
    );

    if (matched.length === 0) {
        fieldDropdown.innerHTML = '<div class="field-empty">无匹配字段</div>';
        fieldDropdown.style.display = 'block';
    } else {
        const display = matched.slice(0, 50);
        let html = display.map(f => {
            const idx = f.indexOf(keywordUpper);
            const highlighted = idx >= 0
                ? f.substring(0, idx) + '<strong>' + f.substring(idx, idx + keywordUpper.length) + '</strong>' + f.substring(idx + keywordUpper.length)
                : f;
            const hasCaliber = CaliberTab._caliberFieldsLoaded && caliberFieldSet.has(f);
            const badge = hasCaliber
                ? '<span style="display:inline-block;padding:0 4px;background:#dcfce7;color:#166534;border-radius:3px;font-size:9px;font-weight:700;margin-left:6px;">口径</span>'
                : '';
            return `<div class="field-item" onclick="caliberSelectField('${f}')">
                <span class="field-name">${highlighted}${badge}</span>
            </div>`;
        }).join('');
        fieldDropdown.innerHTML = html;
        fieldDropdown.style.display = 'block';
    }

    if (CaliberTab._tableFields.length > 0 && keyword) {
        if (CaliberTab._tableFields.includes(keywordUpper)) {
            fieldInput.classList.add('valid');
        } else {
            fieldInput.classList.add('invalid');
        }
    }
}

function caliberSelectField(fieldName) {
    const fieldInput = document.getElementById('caliberFieldInput');
    fieldInput.value = fieldName;
    fieldInput.classList.add('valid');
    fieldInput.classList.remove('invalid');
    document.getElementById('caliberFieldResults').style.display = 'none';
}

async function executeCaliberQuery() {
    let table = document.getElementById('caliberTableInput').value.trim();
    let field = document.getElementById('caliberFieldInput').value.trim();
    const direction = AppState.caliberMode;
    const dataSource = document.getElementById('caliberDataSource').value;

    if (!table || !field) {
        showNotification('请输入表名和字段名', 'error');
        return;
    }

    field = field.toUpperCase();
    document.getElementById('caliberFieldInput').value = field;

    if (CaliberTab._tableFields.length > 0 && !CaliberTab._tableFields.includes(field)) {
        showNotification(`字段 "${field}" 不属于表 "${table.split('.').pop()}"，请从下拉列表中选择`, 'warning');
        return;
    }

    if (!table.includes('.')) {
        try {
            const searchResult = await apiRequest(`/api/tables?keyword=${encodeURIComponent(table)}&limit=10`);
            if (searchResult.data && searchResult.data.length > 0) {
                const shortName = table.toUpperCase();
                // 筛选 short_name 完全匹配的结果
                const exactMatches = searchResult.data.filter(t =>
                    t.short_name.toUpperCase() === shortName
                );
                let bestMatch;
                if (exactMatches.length === 1) {
                    bestMatch = exactMatches[0];
                } else if (exactMatches.length > 1) {
                    // 多个 schema 同名表：优先选择 schema 与表名前缀重叠的
                    // 例：EAST5_201_GRJCXXB → RRP_EAST schema 优先（EAST 匹配）
                    bestMatch = exactMatches.reduce((best, t) => {
                        const schema = (t.schema || '').toUpperCase();
                        // 检查 schema 是否包含短名的关键前缀（去掉数字后）
                        const prefixMatch = (name, kw) => {
                            const namePrefix = name.replace(/[0-9]/g, '').replace(/_+$/, '');
                            const kwPrefix = kw.replace(/[0-9]/g, '').replace(/_+$/, '');
                            return namePrefix.includes(kwPrefix) || kwPrefix.includes(namePrefix);
                        };
                        const bestSchema = (best.schema || '').toUpperCase();
                        const curScore = prefixMatch(schema, shortName) ? 1 : 0;
                        const bestScore = prefixMatch(bestSchema, shortName) ? 1 : 0;
                        return curScore > bestScore ? t : best;
                    }, exactMatches[0]);
                } else {
                    // 无精确匹配，用搜索排序的第一个
                    bestMatch = searchResult.data[0];
                }
                table = bestMatch.full_name;
                document.getElementById('caliberTableInput').value = table;
            }
        } catch (e) {
            console.error('口径表名解析失败:', e);
        }
    }

    const loading = document.getElementById('caliberLoading');
    const emptyHint = document.getElementById('caliberEmptyHint');
    const results = document.getElementById('caliberResults');

    loading.style.display = 'flex';
    emptyHint.style.display = 'none';
    results.style.display = 'none';

    try {
        const params = new URLSearchParams({ table: table, field: field, depth: '10', direction: direction });
        if (dataSource) params.append('data_source', dataSource);

        const response = await apiRequest(
            `/api/caliber/trace?${params.toString()}`
        );

        if (response.success && response.data) {
            renderCaliberResults(response.data, table, field);
        } else {
            showNotification(response.message || '查询失败', 'error');
            emptyHint.style.display = 'flex';
        }
    } catch (error) {
        console.error('口径查询失败:', error);
        showNotification('查询失败: ' + error.message, 'error');
        emptyHint.style.display = 'flex';
    } finally {
        loading.style.display = 'none';
    }
}

function renderCaliberResults(data, table, field) {
    const results = document.getElementById('caliberResults');
    const emptyHint = document.getElementById('caliberEmptyHint');
    const overview = document.getElementById('caliberOverview');
    const pipeline = document.getElementById('caliberPipeline');

    results.style.display = 'flex';
    emptyHint.style.display = 'none';

    CaliberTab._lastCaliberData = data;

    // ─── 第一层：概览卡 ───
    const LAYER_COLORS = { east: '#7c3aed', mdl: '#2563eb', dws: '#059669', ads: '#ea580c', ods: '#0891b2', diis: '#64748b', other: '#6b7280' };

    const flowTags = (data.data_flow_layers_summary || []).map(l => {
        const c = LAYER_COLORS[l] || '#6b7280';
        return `<span class="ov-flow-tag" style="background:${c}20;color:${c};">${l.toUpperCase()}</span>`;
    });
    const flowArrows = flowTags.length > 1
        ? flowTags.join('<span class="ov-flow-arrow">→</span>')
        : flowTags.join('');

    overview.innerHTML = `
        <div class="ov-card">
            <div class="ov-value">${data.chains ? data.chains.length : 0}</div>
            <div class="ov-label">口径链路</div>
        </div>
        <div class="ov-card">
            <div class="ov-value">${data.total_steps || 0}</div>
            <div class="ov-label">加工步骤</div>
        </div>
        <div class="ov-card">
            <div class="ov-value">${data.total_conditions || 0}</div>
            <div class="ov-label">筛选条件</div>
        </div>
        <div class="ov-card">
            <div class="ov-value">${data.query_time_ms ? data.query_time_ms.toFixed(1) : 0}</div>
            <div class="ov-label">耗时(ms)</div>
        </div>
        ${flowArrows ? `<div class="ov-card ov-flow">
            <div>
                <div style="font-size:11px;color:#64748b;margin-bottom:4px;">数据流向</div>
                <div>${flowArrows}</div>
            </div>
        </div>` : ''}
    `;

    // ─── 第二层：Pipeline 链路图 ───
    pipeline.innerHTML = '';

    if (!data.chains || data.chains.length === 0) {
        pipeline.innerHTML = `
            <div class="pipeline-empty">
                <div class="empty-icon">🔍</div>
                <p>未找到 ${formatShortName(table)}.${field} 的口径信息</p>
                <p style="font-size:12px;margin-top:6px;color:#94a3b8;">可能该字段尚未被解析，或表名/字段名输入有误</p>
            </div>
        `;
        return;
    }

    data.chains.forEach((chain, chainIdx) => {
        if (chainIdx > 0) {
            const divider = document.createElement('div');
            divider.className = 'pipeline-chain-divider';
            pipeline.appendChild(divider);

            const label = document.createElement('div');
            label.className = 'pipeline-chain-divider-label';
            label.textContent = `链路 #${chainIdx + 1}`;
            pipeline.appendChild(label);
        }

        // 链路轨道
        const track = document.createElement('div');
        track.className = 'pipeline-track';

        // 轨道头
        const trackHeader = document.createElement('div');
        trackHeader.className = 'pipeline-track-header';
        const layerTags = (chain.data_flow_layers || []).map(l => {
            const c = LAYER_COLORS[l] || '#6b7280';
            return `<span style="display:inline-block;padding:1px 6px;background:${c}20;color:${c};border-radius:3px;font-size:10px;font-weight:600;">${l.toUpperCase()}</span>`;
        }).join(' → ');
        trackHeader.innerHTML = `
            <span>链路 #${chainIdx + 1}</span>
            <span class="track-depth">深度: ${chain.depth || 0}</span>
            ${layerTags ? '<span>　' + layerTags + '</span>' : ''}
            <span style="margin-left:auto;font-size:11px;color:#94a3b8;">${chain.tables_involved ? chain.tables_involved.join(' → ') : ''}</span>
        `;
        track.appendChild(trackHeader);

        // 节点行
        const nodesRow = document.createElement('div');
        nodesRow.className = 'pipeline-nodes';

        if (chain.steps && chain.steps.length > 0) {
            chain.steps.forEach((step, stepIdx) => {
                if (stepIdx > 0) {
                    const conn = createPipelineConnector(step, stepIdx);
                    nodesRow.appendChild(conn);
                }
                const node = createPipelineNode(step, stepIdx, chainIdx);
                nodesRow.appendChild(node);
            });
        }

        track.appendChild(nodesRow);

        // 全链路累积条件（如果有的话，放在轨道底部）
        if (chain.accumulated_conditions_text) {
            const accDiv = document.createElement('div');
            accDiv.style.cssText = 'padding:8px 14px;background:#fefce8;border:1px solid #fde68a;border-radius:6px;font-size:12px;margin-top:4px;';
            accDiv.innerHTML = `<span style="color:#92400e;font-weight:600;">🔗 全链路累积条件:</span> <span style="color:#78350f;">${escapeHtml(chain.accumulated_conditions_text)}</span>`;
            track.appendChild(accDiv);
        }

        // 完整口径规格（折叠）
        if (chain.complete_caliber_spec) {
            const specDiv = document.createElement('div');
            specDiv.style.cssText = 'margin-top:8px;';
            specDiv.innerHTML = `
                <details>
                    <summary style="cursor:pointer;font-size:12px;color:#0369a1;font-weight:600;">📋 查看完整口径规格</summary>
                    <pre style="margin-top:8px;padding:12px;background:#0f172a;color:#e2e8f0;border-radius:6px;font-size:12px;line-height:1.6;overflow-x:auto;white-space:pre-wrap;">${escapeHtml(chain.complete_caliber_spec)}</pre>
                </details>
            `;
            track.appendChild(specDiv);
        }

        pipeline.appendChild(track);
    });
}

/**
 * 创建 Pipeline 节点卡片（仅展示摘要信息：字段映射 + 条件标签）
 */
function createPipelineNode(step, stepIdx, chainIdx) {
    const node = document.createElement('div');
    node.className = 'pipeline-node';
    node.setAttribute('data-chain', chainIdx);
    node.setAttribute('data-step', stepIdx);

    const LAYER_COLORS = { east: '#7c3aed', mdl: '#2563eb', dws: '#059669', ads: '#ea580c', ods: '#0891b2', diis: '#64748b', other: '#6b7280' };

    // 层级色条
    const tgtLayer = step.target_table_layer || 'other';
    const layerBarClass = `layer-${tgtLayer}`;

    // 操作类型标签
    const opTag = step.operation_type
        ? `<span class="node-op-tag">${step.operation_type}</span>`
        : '';

    // FN 标签
    const fnTag = step.is_custom_function_call
        ? `<span class="node-fn-tag">FN</span>`
        : '';

    // 源→目标字段
    const srcShort = formatShortName(step.source_table);
    const tgtShort = formatShortName(step.target_table);
    const srcCol = step.source_column || '?';
    const tgtCol = step.target_column || '?';

    // 条件摘要标签
    let condTags = '';
    const whereCount = (step.step_isolated_where && step.step_isolated_where.length > 0)
        ? step.step_isolated_where.length
        : (step.where_conditions ? step.where_conditions.length : 0);
    if (whereCount > 0) {
        condTags += `<span class="cond-tag">WHERE ×${whereCount}</span>`;
    }
    const joinCount = (step.step_isolated_join && step.step_isolated_join.length > 0)
        ? step.step_isolated_join.length
        : (step.join_conditions ? step.join_conditions.length : 0);
    if (joinCount > 0) {
        condTags += `<span class="cond-tag cond-join">JOIN ×${joinCount}</span>`;
    }
    if (step.group_by_clause) {
        condTags += `<span class="cond-tag cond-group">GROUP BY</span>`;
    }
    if (step.having_clause) {
        condTags += `<span class="cond-tag cond-having">HAVING</span>`;
    }
    if (step.distinct_flag) {
        condTags += `<span class="cond-tag cond-distinct">DISTINCT</span>`;
    }
    if (step.set_operation) {
        condTags += `<span class="cond-tag cond-setop">${step.set_operation}</span>`;
    }
    if (step.cte_definitions && step.cte_definitions.length > 0) {
        condTags += `<span class="cond-tag cond-cte">CTE ×${step.cte_definitions.length}</span>`;
    }
    if (step.custom_functions && step.custom_functions.length > 0) {
        condTags += `<span class="cond-tag cond-func">FN ×${step.custom_functions.length}</span>`;
    }

    // 转换逻辑（如果不是直接映射）
    const transformHint = step.transform_logic && step.transform_logic.toUpperCase() !== (srcCol || '').toUpperCase()
        ? `<div style="padding:0 14px 6px;font-size:11px;color:#6366f1;font-family:'Cascadia Code','Fira Code',monospace;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${escapeHtml(step.transform_logic)}">⚡ ${escapeHtml(step.transform_logic.length > 40 ? step.transform_logic.substring(0, 40) + '...' : step.transform_logic)}</div>`
        : '';

    // 底部信息
    const procInfo = step.procedure
        ? `<span>📄 ${escapeHtml(step.procedure)}${step.sql_operation_sequence > 0 ? ' #' + step.sql_operation_sequence : ''}</span>`
        : '';
    const lineInfo = step.start_line > 0
        ? `<span>📍 L${step.start_line}${step.end_line > step.start_line ? '-' + step.end_line : ''}</span>`
        : '';

    node.innerHTML = `
        <div class="node-layer-bar ${layerBarClass}"></div>
        <div class="node-header">
            <div class="node-step-num">${stepIdx + 1}</div>
            ${opTag}${fnTag}
            ${step.confidence < 0.8 ? `<span style="font-size:10px;color:#f59e0b;margin-left:auto;">${(step.confidence * 100).toFixed(0)}%</span>` : ''}
        </div>
        <div class="node-fields">
            <span class="field-table">${escapeHtml(srcShort)}.</span><span class="field-name">${escapeHtml(srcCol)}</span>
            <span class="field-arrow">→</span>
            <span class="field-table">${escapeHtml(tgtShort)}.</span><span class="field-name">${escapeHtml(tgtCol)}</span>
        </div>
        ${transformHint}
        ${condTags ? `<div class="node-conditions">${condTags}</div>` : ''}
        ${procInfo || lineInfo ? `<div class="node-footer">${procInfo} ${lineInfo}</div>` : ''}
    `;

    // 点击展开详情抽屉
    node.addEventListener('click', () => {
        openCaliberDrawer(step, stepIdx, chainIdx);
    });

    return node;
}

/**
 * 创建 Pipeline 节点间的连接箭头
 */
function createPipelineConnector(step, stepIdx) {
    const conn = document.createElement('div');
    conn.className = 'pipeline-connector';
    conn.innerHTML = `
        <div class="connector-line">
            <div class="connector-arrow"></div>
        </div>
    `;
    return conn;
}

/**
 * 打开详情抽屉
 */
function openCaliberDrawer(step, stepIdx, chainIdx) {
    const drawer = document.getElementById('caliberDetailDrawer');
    const title = document.getElementById('drawerTitle');
    const body = document.getElementById('drawerBody');

    // 标记激活节点
    document.querySelectorAll('.pipeline-node.node-active').forEach(n => n.classList.remove('node-active'));
    const activeNode = document.querySelector(`.pipeline-node[data-chain="${chainIdx}"][data-step="${stepIdx}"]`);
    if (activeNode) activeNode.classList.add('node-active');

    CaliberTab._activeDrawerStepIdx = { stepIdx, chainIdx };

    const srcShort = formatShortName(step.source_table);
    const tgtShort = formatShortName(step.target_table);
    const srcCol = step.source_column || '?';
    const tgtCol = step.target_column || '?';

    title.textContent = `第${stepIdx + 1}步: ${srcShort}.${srcCol} → ${tgtShort}.${tgtCol}`;

    let html = '';

    // 字段映射
    html += `<div class="detail-section">
        <div class="ds-title">字段映射</div>
        <div class="ds-content">
            <div><code>${escapeHtml(step.source_table || '?')}.${escapeHtml(srcCol)}</code> → <code>${escapeHtml(step.target_table || '?')}.${escapeHtml(tgtCol)}</code></div>
            ${step.operation_type ? `<div style="margin-top:4px;"><span style="font-weight:600;">操作:</span> ${step.operation_type}</div>` : ''}
            ${step.data_source ? `<div style="margin-top:2px;"><span style="font-weight:600;">数据源:</span> ${step.data_source.toUpperCase()}</div>` : ''}
            ${step.step_num > 0 ? `<div style="margin-top:2px;"><span style="font-weight:600;">步骤:</span> 第${step.step_num}步${step.step_desc ? ' — ' + step.step_desc : ''}</div>` : ''}
        </div>
    </div>`;

    // 转换逻辑
    if (step.transform_logic && step.transform_logic.toUpperCase() !== srcCol.toUpperCase()) {
        html += `<div class="detail-section">
            <div class="ds-title">转换逻辑</div>
            <div class="ds-content"><code>${escapeHtml(step.transform_logic)}</code></div>
        </div>`;
    }

    // 完整表达式
    if (step.full_expression && step.full_expression.toUpperCase() !== srcCol.toUpperCase()) {
        html += `<div class="detail-section">
            <div class="ds-title">完整表达式</div>
            <div class="ds-content"><code>${escapeHtml(step.full_expression)}</code></div>
        </div>`;
    }

    // 步骤级隔离 WHERE
    if (step.step_isolated_where && step.step_isolated_where.length > 0) {
        html += `<div class="detail-section">
            <div class="ds-title">步骤独有 WHERE（本步骤新增条件）</div>
            <div class="ds-content">
                ${step.step_isolated_where.map(c => `
                    <div class="cond-block cond-where-isolated">
                        <span class="cond-label" style="color:#be123c;">步骤WHERE</span>
                        <code>${escapeHtml(c.raw_text)}</code>
                        ${c.fields_involved && c.fields_involved.length > 0 ? `<div style="margin-top:4px;font-size:11px;color:#9a3412;">涉及字段: ${c.fields_involved.join(', ')}</div>` : ''}
                    </div>
                `).join('')}
            </div>
        </div>`;
    }

    // 步骤级隔离 JOIN
    if (step.step_isolated_join && step.step_isolated_join.length > 0) {
        html += `<div class="detail-section">
            <div class="ds-title">步骤独有 JOIN（本步骤新增关联）</div>
            <div class="ds-content">
                ${step.step_isolated_join.map(c => `
                    <div class="cond-block cond-join-isolated">
                        <span class="cond-label" style="color:#1d4ed8;">步骤JOIN</span>
                        <code>${escapeHtml(c.raw_text)}</code>
                    </div>
                `).join('')}
            </div>
        </div>`;
    }

    // 累积 WHERE
    if (step.accumulated_where && step.accumulated_where.length > 0) {
        html += `<div class="detail-section">
            <div class="ds-title">累积 WHERE（含历史步骤）</div>
            <div class="ds-content">
                ${step.accumulated_where.map(c => `
                    <div class="cond-block cond-where-isolated">
                        <span class="cond-label" style="color:#be123c;">累积WHERE</span>
                        <code>${escapeHtml(c.raw_text)}</code>
                    </div>
                `).join('')}
            </div>
        </div>`;
    }

    // 累积 JOIN
    if (step.accumulated_join && step.accumulated_join.length > 0) {
        html += `<div class="detail-section">
            <div class="ds-title">累积 JOIN（含历史步骤）</div>
            <div class="ds-content">
                ${step.accumulated_join.map(c => `
                    <div class="cond-block cond-join-isolated">
                        <span class="cond-label" style="color:#1d4ed8;">累积JOIN</span>
                        <code>${escapeHtml(c.raw_text)}</code>
                    </div>
                `).join('')}
            </div>
        </div>`;
    }

    // WHERE（无累积且无步骤独有时）
    const hasIsolatedWhere = step.step_isolated_where && step.step_isolated_where.length > 0;
    const hasAccumulatedWhere = step.accumulated_where && step.accumulated_where.length > 0;
    if (!hasIsolatedWhere && !hasAccumulatedWhere && step.where_conditions && step.where_conditions.length > 0) {
        html += `<div class="detail-section">
            <div class="ds-title">WHERE 条件</div>
            <div class="ds-content">
                ${step.where_conditions.map(c => `
                    <div class="cond-block cond-where">
                        <span class="cond-label" style="color:#c2410c;">WHERE</span>
                        <code>${escapeHtml(c.raw_text)}</code>
                        ${c.fields_involved && c.fields_involved.length > 0 ? `<div style="margin-top:4px;font-size:11px;color:#9a3412;">涉及字段: ${c.fields_involved.join(', ')}</div>` : ''}
                    </div>
                `).join('')}
            </div>
        </div>`;
    }

    // JOIN（无累积且无步骤独有时）
    const hasIsolatedJoin = step.step_isolated_join && step.step_isolated_join.length > 0;
    const hasAccumulatedJoin = step.accumulated_join && step.accumulated_join.length > 0;
    if (!hasIsolatedJoin && !hasAccumulatedJoin && step.join_conditions && step.join_conditions.length > 0) {
        html += `<div class="detail-section">
            <div class="ds-title">JOIN 条件</div>
            <div class="ds-content">
                ${step.join_conditions.map(c => `
                    <div class="cond-block cond-join">
                        <span class="cond-label" style="color:#1d4ed8;">JOIN</span>
                        <code>${escapeHtml(c.raw_text)}</code>
                    </div>
                `).join('')}
            </div>
        </div>`;
    }

    // GROUP BY
    if (step.group_by_clause) {
        html += `<div class="detail-section">
            <div class="ds-title">GROUP BY</div>
            <div class="ds-content"><div class="cond-block cond-group"><code>${escapeHtml(step.group_by_clause)}</code></div></div>
        </div>`;
    }

    // HAVING
    if (step.having_clause) {
        html += `<div class="detail-section">
            <div class="ds-title">HAVING</div>
            <div class="ds-content"><div class="cond-block cond-having"><code>${escapeHtml(step.having_clause)}</code></div></div>
        </div>`;
    }

    // ORDER BY
    if (step.order_by_clause) {
        html += `<div class="detail-section">
            <div class="ds-title">ORDER BY</div>
            <div class="ds-content"><code>${escapeHtml(step.order_by_clause)}</code></div>
        </div>`;
    }

    // WINDOW FUNCTIONS
    if (step.window_functions && step.window_functions.length > 0) {
        html += `<div class="detail-section">
            <div class="ds-title">窗口函数</div>
            <div class="ds-content">${step.window_functions.map(wf => `<div style="margin-bottom:4px;"><code>${escapeHtml(wf)}</code></div>`).join('')}</div>
        </div>`;
    }

    // DISTINCT / SET OPERATION
    if (step.distinct_flag || step.set_operation) {
        html += `<div class="detail-section">
            <div class="ds-title">其他操作</div>
            <div class="ds-content">
                ${step.distinct_flag ? '<span style="margin-right:8px;"><code>DISTINCT</code></span>' : ''}
                ${step.set_operation ? `<span><code>${escapeHtml(step.set_operation)}</code></span>` : ''}
            </div>
        </div>`;
    }

    // CTE 定义（Common Table Expression - 临时结果集）
    if (step.cte_definitions && step.cte_definitions.length > 0) {
        html += `<div class="detail-section">
            <div class="ds-title">CTE 定义 <span style="font-size:11px;color:#64748b;">(Common Table Expression - 临时结果集)</span></div>
            <div class="ds-content">
                ${step.cte_definitions.map(cte => `
                    <div style="margin-bottom:6px;padding:6px 10px;background:#ecfeff;border:1px solid #a5f3fc;border-radius:4px;font-size:12px;">
                        <code>${escapeHtml(cte)}</code>
                    </div>
                `).join('')}
            </div>
        </div>`;
    }

    // 自定义函数
    if (step.custom_functions && step.custom_functions.length > 0) {
        html += `<div class="detail-section">
            <div class="ds-title">自定义函数</div>
            <div class="ds-content">
                ${step.custom_functions.map(fn => `<code style="margin-right:6px;padding:2px 6px;background:#fef2f2;border:1px solid #fecaca;border-radius:3px;">${escapeHtml(fn)}</code>`).join('')}
            </div>
        </div>`;
    }

    // SELECT 列映射
    if (step.select_columns && step.select_columns.length > 0) {
        const mapped = step.select_columns.filter(sc => {
            const alias = sc.alias || sc.target_column;
            return sc.source_expression.toUpperCase() !== (alias || '').toUpperCase();
        });
        if (mapped.length > 0) {
            html += `<div class="detail-section">
                <div class="ds-title">字段映射 (${mapped.length}/${step.select_columns.length} 非直接映射)</div>
                <div class="ds-content" style="font-size:12px;">
                    ${mapped.slice(0, 20).map(sc => {
                        const alias = sc.alias || sc.target_column;
                        return `<div style="margin-bottom:3px;"><code>${escapeHtml(sc.source_expression)}</code> → <code>${escapeHtml(alias)}</code></div>`;
                    }).join('')}
                    ${mapped.length > 20 ? `<div style="color:#94a3b8;">... 还有 ${mapped.length - 20} 个</div>` : ''}
                </div>
            </div>`;
        }
    }

    // 子查询
    if (step.subqueries && step.subqueries.length > 0) {
        html += `<div class="detail-section">
            <div class="ds-title">子查询 (${step.subqueries.length})</div>
            <div class="ds-content">
                ${step.subqueries.map(sq => `
                    <div style="margin-bottom:6px;padding:6px 10px;background:#f5f3ff;border:1px solid #ddd6fe;border-radius:4px;font-size:12px;">
                        ${sq.alias ? `<span style="color:#7c3aed;font-weight:600;">${escapeHtml(sq.alias)}</span>: ` : ''}
                        <code>${escapeHtml(sq.raw_text)}</code>
                        ${sq.source_tables && sq.source_tables.length > 0 ? `<div style="margin-top:2px;color:#6d28d9;font-size:11px;">来源: ${sq.source_tables.join(', ')}</div>` : ''}
                    </div>
                `).join('')}
            </div>
        </div>`;
    }

    // 存储过程 + 行号
    if (step.procedure || step.start_line > 0) {
        html += `<div class="detail-section">
            <div class="ds-title">来源定位</div>
            <div class="ds-content" style="font-size:12px;">
                ${step.procedure ? `<div>📄 存储过程: <code>${escapeHtml(step.procedure)}</code>${step.sql_operation_sequence > 0 ? ` 步骤#${step.sql_operation_sequence}` : ''}</div>` : ''}
                ${step.start_line > 0 ? `<div>📍 第 ${step.start_line}${step.end_line > step.start_line ? '-' + step.end_line : ''} 行${step.file_path ? ` (${escapeHtml(step.file_path.split('/').pop() || step.file_path)})` : ''}</div>` : ''}
            </div>
        </div>`;
    }

    // 原始 SQL
    if (step.raw_sql_fragment) {
        html += `<div class="detail-section">
            <div class="ds-title">原始 SQL</div>
            <div class="ds-content"><pre class="sql-pre">${escapeHtml(step.raw_sql_fragment)}</pre></div>
        </div>`;
    }

    // 置信度
    if (step.confidence < 0.8) {
        html += `<div class="detail-section">
            <div class="ds-title">置信度</div>
            <div class="ds-content">
                <div style="display:flex;align-items:center;gap:8px;">
                    <div style="flex:1;height:6px;background:#f1f5f9;border-radius:3px;overflow:hidden;">
                        <div style="width:${step.confidence * 100}%;height:100%;background:${step.confidence >= 0.6 ? '#f59e0b' : '#ef4444'};border-radius:3px;"></div>
                    </div>
                    <span style="font-size:12px;color:${step.confidence >= 0.6 ? '#f59e0b' : '#ef4444'};font-weight:600;">${(step.confidence * 100).toFixed(0)}%</span>
                </div>
            </div>
        </div>`;
    }

    body.innerHTML = html;
    drawer.classList.add('drawer-open');
}

/**
 * 关闭详情抽屉
 */
function closeCaliberDrawer() {
    const drawer = document.getElementById('caliberDetailDrawer');
    drawer.classList.remove('drawer-open');
    document.querySelectorAll('.pipeline-node.node-active').forEach(n => n.classList.remove('node-active'));
    CaliberTab._activeDrawerStepIdx = null;
}

function formatShortName(fullName) {
    if (!fullName) return '';
    if (fullName.includes('.')) {
        return fullName.split('.').pop();
    }
    return fullName;
}

function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
