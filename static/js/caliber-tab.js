/**
 * 指标口径查询 Tab 交互逻辑
 * 负责口径查询的搜索、结果展示和链路可视化
 */

const CaliberTab = {
    initialized: false,
};

function initCaliberTab() {
    if (CaliberTab.initialized) return;
    CaliberTab.initialized = true;
    console.log('🎯 指标口径模块已初始化');
}

async function executeCaliberQuery() {
    const table = document.getElementById('caliberTableInput').value.trim();
    const field = document.getElementById('caliberFieldInput').value.trim();
    const direction = AppState.caliberMode;
    const dataSource = document.getElementById('caliberDataSource').value;

    if (!table || !field) {
        showNotification('请输入表名和字段名', 'error');
        return;
    }

    const loading = document.getElementById('caliberLoading');
    const emptyHint = document.getElementById('caliberEmptyHint');
    const results = document.getElementById('caliberResults');

    loading.style.display = 'flex';
    emptyHint.style.display = 'none';
    results.style.display = 'none';

    try {
        const params = new URLSearchParams({
            depth: '10',
            direction: direction,
        });
        if (dataSource) {
            params.append('data_source', dataSource);
        }

        const response = await apiRequest(
            `/api/caliber/${encodeURIComponent(table)}/${encodeURIComponent(field)}?${params.toString()}`
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
        `;
        chainHeader.innerHTML = `
            <span>链路 #${chainIdx + 1}（深度: ${chain.depth || 0}）</span>
            <span style="font-size:12px;color:#64748b;font-weight:400;">${chain.summary || ''}</span>
        `;
        chainDiv.appendChild(chainHeader);

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
    const targetLabel = `${formatShortName(step.target_table)}.${step.target_column}`;

    const dsTag = step.data_source
        ? `<span style="display:inline-block;padding:2px 8px;background:#ede9fe;color:#7c3aed;border-radius:4px;font-size:11px;margin-left:8px;">${step.data_source.toUpperCase()}</span>`
        : '';

    const stepLabel = step.step_num > 0
        ? `<span style="color:#6366f1;font-weight:600;">第${step.step_num}步</span>${step.step_desc ? ' - ' + step.step_desc : ''}`
        : '';

    let conditionsHtml = '';

    if (step.where_conditions && step.where_conditions.length > 0) {
        step.where_conditions.forEach(cond => {
            conditionsHtml += `
                <div class="condition-item" style="
                    padding: 8px 12px;
                    background: #fff7ed;
                    border: 1px solid #fed7aa;
                    border-radius: 6px;
                    margin-bottom: 6px;
                    font-size: 13px;
                ">
                    <span style="color:#c2410c;font-weight:600;">WHERE</span>
                    <code style="color:#1e293b;margin-left:8px;">${escapeHtml(cond.raw_text)}</code>
                    ${cond.fields_involved && cond.fields_involved.length > 0
                        ? `<div style="margin-top:4px;font-size:11px;color:#9a3412;">涉及字段: ${cond.fields_involved.join(', ')}</div>`
                        : ''}
                </div>
            `;
        });
    }

    if (step.join_conditions && step.join_conditions.length > 0) {
        step.join_conditions.forEach(cond => {
            conditionsHtml += `
                <div class="condition-item" style="
                    padding: 8px 12px;
                    background: #eff6ff;
                    border: 1px solid #bfdbfe;
                    border-radius: 6px;
                    margin-bottom: 6px;
                    font-size: 13px;
                ">
                    <span style="color:#1d4ed8;font-weight:600;">JOIN</span>
                    <code style="color:#1e293b;margin-left:8px;">${escapeHtml(cond.raw_text)}</code>
                </div>
            `;
        });
    }

    if (step.group_by_clause) {
        conditionsHtml += `
            <div class="condition-item" style="
                padding: 8px 12px;
                background: #f0fdf4;
                border: 1px solid #bbf7d0;
                border-radius: 6px;
                margin-bottom: 6px;
                font-size: 13px;
            ">
                <span style="color:#166534;font-weight:600;">GROUP BY</span>
                <code style="color:#1e293b;margin-left:8px;">${escapeHtml(step.group_by_clause)}</code>
            </div>
        `;
    }

    if (step.having_clause) {
        conditionsHtml += `
            <div class="condition-item" style="
                padding: 8px 12px;
                background: #fef2f2;
                border: 1px solid #fecaca;
                border-radius: 6px;
                margin-bottom: 6px;
                font-size: 13px;
            ">
                <span style="color:#991b1b;font-weight:600;">HAVING</span>
                <code style="color:#1e293b;margin-left:8px;">${escapeHtml(step.having_clause)}</code>
            </div>
        `;
    }

    const transformHtml = step.transform_logic
        ? `<div style="margin-top:8px;padding:8px 12px;background:#f8fafc;border-radius:6px;font-size:13px;">
               <span style="color:#6366f1;font-weight:600;">转换逻辑:</span>
               <code style="color:#1e293b;margin-left:4px;">${escapeHtml(step.transform_logic)}</code>
           </div>`
        : '';

    const procedureHtml = step.procedure
        ? `<div style="margin-top:6px;font-size:12px;color:#64748b;">
               📄 存储过程: <span style="color:#6366f1;">${escapeHtml(step.procedure)}</span>
           </div>`
        : '';

    const rawSqlHtml = step.raw_sql_fragment
        ? `<details style="margin-top:8px;">
               <summary style="cursor:pointer;font-size:12px;color:#6366f1;">查看原始 SQL</summary>
               <pre style="
                   margin-top:8px;
                   padding:12px;
                   background:#1e293b;
                   color:#e2e8f0;
                   border-radius:6px;
                   font-size:12px;
                   line-height:1.6;
                   overflow-x:auto;
                   white-space:pre-wrap;
               ">${escapeHtml(step.raw_sql_fragment)}</pre>
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
                    ${sourceLabel} → ${targetLabel}
                    ${dsTag}
                </div>
                ${stepLabel ? `<div style="font-size:12px;color:#64748b;margin-top:2px;">${stepLabel}</div>` : ''}
            </div>
            ${step.confidence < 0.8 ? `<span style="font-size:11px;color:#f59e0b;">置信度: ${(step.confidence * 100).toFixed(0)}%</span>` : ''}
        </div>

        ${conditionsHtml ? `<div style="margin-top:8px;">${conditionsHtml}</div>` : ''}
        ${transformHtml}
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
