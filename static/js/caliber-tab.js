/**
 * 指标口径查询 Tab 交互逻辑
 * 负责口径查询的搜索、结果展示和链路可视化
 * 
 * v2.1: 增加表搜索+字段联动、数据分层展示、完整口径规格渲染
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

    console.log('🎯 指标口径模块 v2.1 已初始化（含表搜索+字段联动）');
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

    let html = tables.map((table, idx) => `
        <div class="search-result-item" onclick="caliberSelectTable('${table.full_name}', ${idx})">
            <div class="result-name">${table.short_name || table.full_name}</div>
            <div class="result-type">表 · ${table.layer || 'unknown'} · ${table.field_count || 0} 字段</div>
        </div>
    `).join('');

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
            const searchResult = await apiRequest(`/api/tables?keyword=${encodeURIComponent(table)}&limit=5`);
            if (searchResult.data && searchResult.data.length > 0) {
                const shortName = table;
                let bestMatch = searchResult.data[0];
                for (const t of searchResult.data) {
                    if (t.short_name.toUpperCase() === shortName.toUpperCase()) {
                        bestMatch = t;
                        break;
                    }
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
    const statsDiv = document.getElementById('caliberStats');
    const chainList = document.getElementById('caliberChainList');

    results.style.display = 'block';
    emptyHint.style.display = 'none';

    const layersSummary = (data.data_flow_layers_summary || []).map(l => {
        const colors = { east: '#7c3aed', mdl: '#2563eb', dws: '#059669', ads: '#ea580c', ods: '#0891b2', diis: '#64748b', other: '#6b7280' };
        return `<span style="display:inline-block;padding:2px 8px;background:${colors[l] || '#6b7280'}20;color:${colors[l] || '#6b7280'};border-radius:4px;font-size:11px;font-weight:600;">${l.toUpperCase()}</span>`;
    }).join(' → ');

    statsDiv.innerHTML = `
        <div class="stat-card">
            <div class="stat-value">${data.chains ? data.chains.length : 0}</div>
            <div class="stat-label">口径链路</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">${data.total_steps || 0}</div>
            <div class="stat-label">加工步骤</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">${data.total_conditions || 0}</div>
            <div class="stat-label">筛选条件</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">${data.query_time_ms ? data.query_time_ms.toFixed(1) : 0}</div>
            <div class="stat-label">查询耗时(ms)</div>
        </div>
        ${layersSummary ? `<div class="stat-card" style="grid-column:span 2;">
            <div style="font-size:12px;color:#64748b;margin-bottom:4px;">数据流向</div>
            <div>${layersSummary}</div>
        </div>` : ''}
    `;

    chainList.innerHTML = '';

    if (!data.chains || data.chains.length === 0) {
        chainList.innerHTML = `
            <div class="empty-state" style="text-align:center;padding:40px;color:#64748b;">
                <p style="font-size:16px;">未找到 ${table}.${field} 的口径信息</p>
                <p style="font-size:13px;margin-top:8px;">可能该字段尚未被解析，或表名/字段名输入有误</p>
            </div>
        `;
        return;
    }

    data.chains.forEach((chain, chainIdx) => {
        const chainDiv = document.createElement('div');
        chainDiv.className = 'caliber-chain';
        chainDiv.style.cssText = `
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            margin-bottom: 16px;
            overflow: hidden;
        `;

        const layerTags = (chain.data_flow_layers || []).map(l => {
            const colors = { east: '#7c3aed', mdl: '#2563eb', dws: '#059669', ads: '#ea580c', ods: '#0891b2', diis: '#64748b', other: '#6b7280' };
            return `<span style="display:inline-block;padding:1px 6px;background:${colors[l] || '#6b7280'}20;color:${colors[l] || '#6b7280'};border-radius:3px;font-size:10px;font-weight:600;">${l.toUpperCase()}</span>`;
        }).join(' → ');

        const chainHeader = document.createElement('div');
        chainHeader.style.cssText = `
            padding: 12px 16px;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            font-size: 14px;
            font-weight: 600;
            color: #1e293b;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 8px;
        `;
        chainHeader.innerHTML = `
            <span>链路 #${chainIdx + 1}（深度: ${chain.depth || 0}）${layerTags ? '　' + layerTags : ''}</span>
            <span style="font-size:12px;color:#64748b;font-weight:400;">${chain.tables_involved ? chain.tables_involved.join(' → ') : ''}</span>
        `;
        chainDiv.appendChild(chainHeader);

        if (chain.complete_caliber_spec) {
            const specToggle = document.createElement('div');
            specToggle.style.cssText = 'padding:8px 16px;background:#f0f9ff;border-bottom:1px solid #bae6fd;';
            specToggle.innerHTML = `
                <details>
                    <summary style="cursor:pointer;font-size:12px;color:#0369a1;font-weight:600;">📋 查看完整口径规格</summary>
                    <pre style="margin-top:8px;padding:12px;background:#0f172a;color:#e2e8f0;border-radius:6px;font-size:12px;line-height:1.6;overflow-x:auto;white-space:pre-wrap;">${escapeHtml(chain.complete_caliber_spec)}</pre>
                </details>
            `;
            chainDiv.appendChild(specToggle);
        }

        if (chain.steps && chain.steps.length > 0) {
            chain.steps.forEach((step, stepIdx) => {
                const stepDiv = renderCaliberStep(step, stepIdx);
                chainDiv.appendChild(stepDiv);
            });
        } else {
            const noSteps = document.createElement('div');
            noSteps.style.cssText = 'padding:20px;text-align:center;color:#94a3b8;';
            noSteps.textContent = '无口径步骤信息';
            chainDiv.appendChild(noSteps);
        }

        if (chain.accumulated_conditions_text) {
            const accDiv = document.createElement('div');
            accDiv.style.cssText = 'padding:12px 16px;background:#fefce8;border-top:1px solid #fde68a;font-size:12px;';
            accDiv.innerHTML = `
                <span style="color:#92400e;font-weight:600;">🔗 全链路累积条件:</span>
                <div style="margin-top:4px;color:#78350f;">${escapeHtml(chain.accumulated_conditions_text)}</div>
            `;
            chainDiv.appendChild(accDiv);
        }

        chainList.appendChild(chainDiv);
    });
}

function renderCaliberStep(step, stepIdx) {
    const stepDiv = document.createElement('div');
    stepDiv.className = 'caliber-step';
    stepDiv.style.cssText = `
        padding: 16px;
        border-bottom: 1px solid #f1f5f9;
        position: relative;
    `;

    const sourceLabel = step.source_table
        ? `${formatShortName(step.source_table)}.${step.source_column}`
        : '(未知来源)';
    const targetLabel = step.target_table
        ? `${formatShortName(step.target_table)}.${step.target_column}`
        : '(未知目标)';

    const layerColors = { east: '#7c3aed', mdl: '#2563eb', dws: '#059669', ads: '#ea580c', ods: '#0891b2', diis: '#64748b', other: '#6b7280' };
    const srcLayer = step.source_table_layer
        ? `<span style="display:inline-block;padding:1px 5px;background:${layerColors[step.source_table_layer] || '#6b7280'}20;color:${layerColors[step.source_table_layer] || '#6b7280'};border-radius:3px;font-size:10px;font-weight:600;">${step.source_table_layer.toUpperCase()}</span>`
        : '';
    const tgtLayer = step.target_table_layer
        ? `<span style="display:inline-block;padding:1px 5px;background:${layerColors[step.target_table_layer] || '#6b7280'}20;color:${layerColors[step.target_table_layer] || '#6b7280'};border-radius:3px;font-size:10px;font-weight:600;">${step.target_table_layer.toUpperCase()}</span>`
        : '';

    const dsTag = step.data_source
        ? `<span style="display:inline-block;padding:2px 8px;background:#ede9fe;color:#7c3aed;border-radius:4px;font-size:11px;margin-left:8px;">${step.data_source.toUpperCase()}</span>`
        : '';

    const opTag = step.operation_type
        ? `<span style="display:inline-block;padding:1px 6px;background:#dbeafe;color:#1d4ed8;border-radius:3px;font-size:10px;font-weight:600;margin-left:6px;">${step.operation_type}</span>`
        : '';

    const distinctTag = step.distinct_flag
        ? `<span style="display:inline-block;padding:1px 6px;background:#fef3c7;color:#92400e;border-radius:3px;font-size:10px;font-weight:600;margin-left:4px;">DISTINCT</span>`
        : '';

    const setOpTag = step.set_operation
        ? `<span style="display:inline-block;padding:1px 6px;background:#fce7f3;color:#be185d;border-radius:3px;font-size:10px;font-weight:600;margin-left:4px;">${step.set_operation}</span>`
        : '';

    const stepLabel = step.step_num > 0
        ? `<span style="color:#6366f1;font-weight:600;">第${step.step_num}步</span>${step.step_desc ? ' - ' + step.step_desc : ''}`
        : '';

    let conditionsHtml = '';

    if (step.accumulated_where && step.accumulated_where.length > 0) {
        step.accumulated_where.forEach(cond => {
            conditionsHtml += `
                <div class="condition-item" style="padding:8px 12px;background:#fff1f2;border:1px solid #fecdd3;border-radius:6px;margin-bottom:6px;font-size:13px;">
                    <span style="color:#be123c;font-weight:600;">累积WHERE</span>
                    <code style="color:#1e293b;margin-left:8px;">${escapeHtml(cond.raw_text)}</code>
                </div>
            `;
        });
    } else if (step.where_conditions && step.where_conditions.length > 0) {
        step.where_conditions.forEach(cond => {
            conditionsHtml += `
                <div class="condition-item" style="padding:8px 12px;background:#fff7ed;border:1px solid #fed7aa;border-radius:6px;margin-bottom:6px;font-size:13px;">
                    <span style="color:#c2410c;font-weight:600;">WHERE</span>
                    <code style="color:#1e293b;margin-left:8px;">${escapeHtml(cond.raw_text)}</code>
                    ${cond.fields_involved && cond.fields_involved.length > 0
                        ? `<div style="margin-top:4px;font-size:11px;color:#9a3412;">涉及字段: ${cond.fields_involved.join(', ')}</div>`
                        : ''}
                </div>
            `;
        });
    }

    if (step.accumulated_join && step.accumulated_join.length > 0) {
        step.accumulated_join.forEach(cond => {
            conditionsHtml += `
                <div class="condition-item" style="padding:8px 12px;background:#eff6ff;border:1px solid #93c5fd;border-radius:6px;margin-bottom:6px;font-size:13px;">
                    <span style="color:#1d4ed8;font-weight:600;">累积JOIN</span>
                    <code style="color:#1e293b;margin-left:8px;">${escapeHtml(cond.raw_text)}</code>
                </div>
            `;
        });
    } else if (step.join_conditions && step.join_conditions.length > 0) {
        step.join_conditions.forEach(cond => {
            conditionsHtml += `
                <div class="condition-item" style="padding:8px 12px;background:#eff6ff;border:1px solid #bfdbfe;border-radius:6px;margin-bottom:6px;font-size:13px;">
                    <span style="color:#1d4ed8;font-weight:600;">JOIN</span>
                    <code style="color:#1e293b;margin-left:8px;">${escapeHtml(cond.raw_text)}</code>
                </div>
            `;
        });
    }

    if (step.group_by_clause) {
        conditionsHtml += `
            <div class="condition-item" style="padding:8px 12px;background:#f0fdf4;border:1px solid #bbf7d0;border-radius:6px;margin-bottom:6px;font-size:13px;">
                <span style="color:#166534;font-weight:600;">GROUP BY</span>
                <code style="color:#1e293b;margin-left:8px;">${escapeHtml(step.group_by_clause)}</code>
            </div>
        `;
    }

    if (step.having_clause) {
        conditionsHtml += `
            <div class="condition-item" style="padding:8px 12px;background:#fef2f2;border:1px solid #fecaca;border-radius:6px;margin-bottom:6px;font-size:13px;">
                <span style="color:#991b1b;font-weight:600;">HAVING</span>
                <code style="color:#1e293b;margin-left:8px;">${escapeHtml(step.having_clause)}</code>
            </div>
        `;
    }

    if (step.order_by_clause) {
        conditionsHtml += `
            <div class="condition-item" style="padding:6px 10px;background:#faf5ff;border:1px solid #e9d5ff;border-radius:6px;margin-bottom:6px;font-size:12px;">
                <span style="color:#7e22ce;font-weight:600;">ORDER BY</span>
                <code style="color:#1e293b;margin-left:8px;">${escapeHtml(step.order_by_clause)}</code>
            </div>
        `;
    }

    if (step.window_functions && step.window_functions.length > 0) {
        step.window_functions.forEach(wf => {
            conditionsHtml += `
                <div class="condition-item" style="padding:6px 10px;background:#ecfdf5;border:1px solid #a7f3d0;border-radius:6px;margin-bottom:6px;font-size:12px;">
                    <span style="color:#047857;font-weight:600;">WINDOW</span>
                    <code style="color:#1e293b;margin-left:8px;">${escapeHtml(wf)}</code>
                </div>
            `;
        });
    }

    const transformHtml = step.transform_logic && step.transform_logic.toUpperCase() !== step.source_column?.toUpperCase()
        ? `<div style="margin-top:8px;padding:8px 12px;background:#f8fafc;border-radius:6px;font-size:13px;">
               <span style="color:#6366f1;font-weight:600;">转换逻辑:</span>
               <code style="color:#1e293b;margin-left:4px;">${escapeHtml(step.transform_logic)}</code>
           </div>`
        : '';

    const selectColsHtml = step.select_columns && step.select_columns.length > 0
        ? `<div style="margin-top:6px;font-size:12px;color:#475569;">
               <span style="font-weight:600;color:#6366f1;">字段映射:</span>
               ${step.select_columns.slice(0, 8).map(sc => {
                   const alias = sc.alias || sc.target_column;
                   if (sc.source_expression.toUpperCase() !== (alias || '').toUpperCase()) {
                       return `<code style="margin-left:4px;">${escapeHtml(sc.source_expression)}→${escapeHtml(alias)}</code>`;
                   }
                   return '';
               }).filter(Boolean).join('　') || '<span style="color:#94a3b8;">直接映射</span>'}
           </div>`
        : '';

    const subqueryHtml = step.subqueries && step.subqueries.length > 0
        ? `<details style="margin-top:6px;">
               <summary style="cursor:pointer;font-size:12px;color:#7c3aed;">📦 子查询 (${step.subqueries.length})</summary>
               ${step.subqueries.map(sq => `
                   <div style="margin-top:4px;padding:6px 10px;background:#f5f3ff;border:1px solid #ddd6fe;border-radius:4px;font-size:11px;">
                       ${sq.alias ? `<span style="color:#7c3aed;font-weight:600;">${escapeHtml(sq.alias)}</span>: ` : ''}
                       <code style="color:#1e293b;">${escapeHtml(sq.raw_text)}</code>
                       ${sq.source_tables && sq.source_tables.length > 0 ? `<div style="margin-top:2px;color:#6d28d9;">来源: ${sq.source_tables.join(', ')}</div>` : ''}
                   </div>
               `).join('')}
           </details>`
        : '';

    const procedureHtml = step.procedure
        ? `<div style="margin-top:6px;font-size:12px;color:#64748b;">
               📄 存储过程: <span style="color:#6366f1;">${escapeHtml(step.procedure)}</span>
               ${step.sql_operation_sequence > 0 ? `<span style="margin-left:8px;color:#94a3b8;">步骤${step.sql_operation_sequence}</span>` : ''}
           </div>`
        : '';

    const rawSqlHtml = step.raw_sql_fragment
        ? `<details style="margin-top:8px;">
               <summary style="cursor:pointer;font-size:12px;color:#6366f1;">查看原始 SQL</summary>
               <pre style="margin-top:8px;padding:12px;background:#1e293b;color:#e2e8f0;border-radius:6px;font-size:12px;line-height:1.6;overflow-x:auto;white-space:pre-wrap;">${escapeHtml(step.raw_sql_fragment)}</pre>
           </details>`
        : '';

    stepDiv.innerHTML = `
        <div style="display:flex;align-items:center;margin-bottom:8px;">
            <div style="
                width:28px;height:28px;
                background:linear-gradient(135deg,#6366f1,#8b5cf6);
                border-radius:50%;
                display:flex;align-items:center;justify-content:center;
                color:white;font-size:12px;font-weight:700;
                margin-right:10px;flex-shrink:0;
            ">${stepIdx + 1}</div>
            <div style="flex:1;">
                <div style="font-size:14px;font-weight:600;color:#1e293b;">
                    ${srcLayer} ${sourceLabel} → ${tgtLayer} ${targetLabel}
                    ${dsTag}${opTag}${distinctTag}${setOpTag}
                </div>
                ${stepLabel ? `<div style="font-size:12px;color:#64748b;margin-top:2px;">${stepLabel}</div>` : ''}
            </div>
            ${step.confidence < 0.8 ? `<span style="font-size:11px;color:#f59e0b;">置信度: ${(step.confidence * 100).toFixed(0)}%</span>` : ''}
        </div>

        ${conditionsHtml ? `<div style="margin-top:8px;">${conditionsHtml}</div>` : ''}
        ${transformHtml}
        ${selectColsHtml}
        ${subqueryHtml}
        ${procedureHtml}
        ${rawSqlHtml}
    `;

    return stepDiv;
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
