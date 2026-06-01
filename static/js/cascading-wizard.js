/**
 * 级联查询向导模块
 * 系统→Schema→表→字段 级联选择器 + 高级搜索切换
 *
 * 核心约束：每级选择后自动加载下一级，切换时清空下游
 */
(function() {
    'use strict';

    // HTML 转义工具函数（防止 XSS）
    function _esc(s) {
        if (s === null || s === undefined) return '';
        return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    }

    // 缓存
    let _systemsCache = null;     // 系统列表缓存
    let _schemasCache = {};       // system → schema 列表缓存
    let _tablesCache = {};        // "system:schema" → 表列表缓存
    let _currentFields = [];      // 当前选中表的字段列表
    let _queryMode = 'wizard';   // 'wizard' | 'advanced'

    // ============================================
    // 初始化：加载系统列表
    // ============================================
    window.initCascadingWizard = async function() {
        if (_systemsCache) return; // 已初始化
        await loadSystems();
    };

    async function loadSystems() {
        const select = document.getElementById('systemSelect');
        if (!select) return;

        try {
            const response = await apiRequest('/api/v1/systems');
            const systems = response.data || [];
            _systemsCache = systems;

            let html = '<option value="">-- 请选择系统 --</option>';
            systems.forEach(sys => {
                html += `<option value="${_esc(sys.name)}">${_esc(sys.display_name)} (${sys.table_count} 表)</option>`;
            });
            select.innerHTML = html;
        } catch (error) {
            console.error('加载系统列表失败:', error);
            select.innerHTML = '<option value="">-- 加载失败 --</option>';
        }
    }

    // ============================================
    // 系统→Schema 级联
    // ============================================
    window.onSystemChange = async function() {
        const system = document.getElementById('systemSelect').value;

        // 清空下游
        resetCascadeFrom('schema');

        if (!system) return;

        const schemaSelect = document.getElementById('schemaSelect');
        schemaSelect.disabled = true;
        schemaSelect.innerHTML = '<option value="">-- 加载中... --</option>';

        try {
            // 检查缓存
            if (!_schemasCache[system]) {
                const response = await apiRequest(`/api/v1/systems/${encodeURIComponent(system)}/schemas`);
                _schemasCache[system] = response.data || [];
            }

            const schemas = _schemasCache[system];
            let html = '<option value="">-- 请选择Schema --</option>';

            schemas.forEach(s => {
                const label = s.schema_name === '__unclassified__'
                    ? '📋 未分类'
                    : _esc(s.schema_name);
                html += `<option value="${_esc(s.schema_name)}">${label} (${s.table_count} 表)</option>`;
            });

            schemaSelect.innerHTML = html;
            schemaSelect.disabled = false;
        } catch (error) {
            console.error('加载Schema列表失败:', error);
            schemaSelect.innerHTML = '<option value="">-- 加载失败 --</option>';
        }
    };

    // ============================================
    // Schema→表 级联
    // ============================================
    window.onSchemaChange = async function() {
        const system = document.getElementById('systemSelect').value;
        const schema = document.getElementById('schemaSelect').value;

        // 清空下游
        resetCascadeFrom('table');

        if (!system || !schema) return;

        const tableSelect = document.getElementById('tableSelect');
        tableSelect.disabled = true;
        tableSelect.innerHTML = '<option value="">-- 加载中... --</option>';

        try {
            const cacheKey = `${system}:${schema}`;
            if (!_tablesCache[cacheKey]) {
                const response = await apiRequest(
                    `/api/v1/systems/${encodeURIComponent(system)}/schemas/${encodeURIComponent(schema)}/tables`
                );
                _tablesCache[cacheKey] = response.data || [];
            }

            const tables = _tablesCache[cacheKey];
            let html = '<option value="">-- 请选择表 --</option>';

            tables.forEach(t => {
                const layerTag = t.layer ? ` [${_esc(t.layer)}]` : '';
                html += `<option value="${_esc(t.full_name)}" data-short="${_esc(t.short_name)}">${_esc(t.short_name)}${layerTag} (${t.field_count} 字段)</option>`;
            });

            tableSelect.innerHTML = html;
            tableSelect.disabled = false;
        } catch (error) {
            console.error('加载表列表失败:', error);
            tableSelect.innerHTML = '<option value="">-- 加载失败 --</option>';
        }
    };

    // ============================================
    // 表→字段 级联
    // ============================================
    window.onTableChange = async function() {
        const tableFullName = document.getElementById('tableSelect').value;

        // 清空下游
        resetCascadeFrom('field');

        if (!tableFullName) return;

        const fieldSelect = document.getElementById('fieldSelect');
        fieldSelect.disabled = true;
        fieldSelect.innerHTML = '<option value="">-- 加载中... --</option>';

        try {
            // 使用现有字段获取 API
            const response = await apiRequest(`/api/v1/tables/${encodeURIComponent(tableFullName)}/fields`);
            const fields = response.data || [];
            _currentFields = fields;

            let html = '<option value="">-- 请选择字段 --</option>';

            if (fields.length === 0) {
                html = '<option value="">-- 无字段数据 --</option>';
            } else {
                fields.forEach(f => {
                    html += `<option value="${_esc(f)}">${_esc(f)}</option>`;
                });
            }

            fieldSelect.innerHTML = html;
            fieldSelect.disabled = false;
        } catch (error) {
            console.error('加载字段列表失败:', error);
            // 尝试通过搜索接口获取字段
            try {
                const shortName = tableFullName.split('.').pop();
                const searchResp = await apiRequest(`/api/v1/tables?keyword=${encodeURIComponent(shortName)}&limit=5`);
                const tables = searchResp.data || [];
                const matched = tables.find(t => t.full_name === tableFullName);
                const columns = matched?.columns || [];

                _currentFields = columns;
                let html = '<option value="">-- 请选择字段 --</option>';
                columns.forEach(f => {
                    html += `<option value="${_esc(f)}">${_esc(f)}</option>`;
                });
                fieldSelect.innerHTML = html;
                fieldSelect.disabled = false;
            } catch (e2) {
                fieldSelect.innerHTML = '<option value="">-- 加载失败 --</option>';
            }
        }
    };

    // ============================================
    // 字段选择 → 激活查询按钮
    // ============================================
    window.onFieldChange = function() {
        const btn = document.getElementById('cascadingQueryBtn');
        const fieldVal = document.getElementById('fieldSelect').value;
        if (btn) {
            btn.disabled = !fieldVal;
        }
    };

    // ============================================
    // 级联查询执行
    // ============================================
    window.executeCascadingQuery = async function() {
        const tableFullName = document.getElementById('tableSelect').value;
        const fieldName = document.getElementById('fieldSelect').value;

        if (!tableFullName || !fieldName) {
            showNotification('请完成级联选择后再查询', 'warning');
            return;
        }

        // 复用展示层的查询逻辑
        document.getElementById('emptyHint').style.display = 'none';
        document.getElementById('loadingIndicator').style.display = 'block';

        try {
            const requestBody = {
                table: tableFullName,
                field: fieldName,
                depth: AppState.queryDepth,
                mode: AppState.queryMode,
                options: {
                    include_fields: true,
                    limit: 100,
                    use_cache: true,
                },
            };

            const response = await apiRequest('/api/v1/lineage/query', {
                method: 'POST',
                body: JSON.stringify(requestBody),
            });

            const graphData = response.data;
            const resolvedTable = graphData.query_target?.table || tableFullName;

            // 更新全局状态
            if (typeof currentQuery !== 'undefined') {
                currentQuery = { table: resolvedTable, field: fieldName };
            }

            // 渲染图谱
            if (typeof renderGraphVertical === 'function') {
                renderGraphVertical(graphData);
            }
            if (typeof renderDetailPanel === 'function') {
                renderDetailPanel(graphData, resolvedTable);
            }

            document.getElementById('legend').classList.add('show');
            document.querySelector('.zoom-controls').style.display = 'flex';

        } catch (error) {
            console.error('级联查询失败:', error);
            showNotification('查询失败: ' + error.message, 'error');
        }

        document.getElementById('loadingIndicator').style.display = 'none';
    };

    // ============================================
    // 查询模式切换
    // ============================================
    window.setQueryMode = function(mode) {
        _queryMode = mode;

        const wizardPanel = document.getElementById('wizardPanel');
        const advancedPanel = document.getElementById('advancedPanel');
        const wizardBtn = document.getElementById('wizardModeBtn');
        const advancedBtn = document.getElementById('advancedModeBtn');

        if (mode === 'wizard') {
            wizardPanel.style.display = 'block';
            advancedPanel.style.display = 'none';
            wizardBtn.classList.add('active');
            advancedBtn.classList.remove('active');
        } else {
            wizardPanel.style.display = 'none';
            advancedPanel.style.display = 'block';
            wizardBtn.classList.remove('active');
            advancedBtn.classList.add('active');

            // 将级联选择的值预填到高级搜索
            prefillAdvancedFromWizard();
        }
    };

    function prefillAdvancedFromWizard() {
        const tableFullName = document.getElementById('tableSelect').value;
        const fieldName = document.getElementById('fieldSelect').value;

        const tableInput = document.getElementById('tableInput');
        const fieldInput = document.getElementById('fieldInput');

        if (tableFullName && tableInput) {
            tableInput.value = tableFullName;
        }
        if (fieldName && fieldInput) {
            fieldInput.value = fieldName;
            fieldInput.disabled = false;
        }

        // 更新查询按钮状态
        if (typeof updateQueryButton === 'function') {
            updateQueryButton();
        }
    }

    // ============================================
    // 级联重置
    // ============================================
    function resetCascadeFrom(level) {
        const levels = {
            schema: ['schemaSelect', 'tableSelect', 'fieldSelect'],
            table: ['tableSelect', 'fieldSelect'],
            field: ['fieldSelect'],
        };

        const placeholders = {
            schemaSelect: ['-- 请先选择系统 --', true],
            tableSelect: ['-- 请先选择Schema --', true],
            fieldSelect: ['-- 请先选择表 --', true],
        };

        const toReset = levels[level] || [];
        toReset.forEach(id => {
            const el = document.getElementById(id);
            if (el) {
                const [placeholder, disabled] = placeholders[id] || ['', true];
                el.innerHTML = `<option value="">${placeholder}</option>`;
                el.disabled = disabled;
            }
        });

        // 重置查询按钮
        const queryBtn = document.getElementById('cascadingQueryBtn');
        if (queryBtn) queryBtn.disabled = true;

        _currentFields = [];
    }

    // ============================================
    // 快速查询兼容：从图谱中的快速跳转
    // ============================================
    const _originalQuickQuery = window.quickQuery;
    window.quickQuery = function(tableName) {
        if (_queryMode === 'wizard') {
            // 在向导模式中尝试自动选择
            autoSelectInWizard(tableName);
        }
        // 同时调用原始逻辑
        if (_originalQuickQuery) {
            _originalQuickQuery(tableName);
        }
    };

    async function autoSelectInWizard(tableName) {
        // 尝试在当前 tableSelect 中找到匹配项
        const tableSelect = document.getElementById('tableSelect');
        if (!tableSelect) return;

        const options = tableSelect.options;
        for (let i = 0; i < options.length; i++) {
            if (options[i].value === tableName || options[i].getAttribute('data-short') === tableName.split('.').pop()) {
                tableSelect.selectedIndex = i;
                await onTableChange();
                break;
            }
        }
    }

    // ============================================
    // 页面加载时初始化
    // ============================================
    // 使用 DOMContentLoaded + 重试机制替代任意 setTimeout
    let _initRetries = 0;
    const MAX_INIT_RETRIES = 5;

    async function _initWithRetry() {
        try {
            await loadSystems();
            _initRetries = 0; // 成功则重置
        } catch (error) {
            _initRetries++;
            if (_initRetries < MAX_INIT_RETRIES) {
                console.warn(`级联向导初始化失败，${2 ** _initRetries}s 后重试 (${_initRetries}/${MAX_INIT_RETRIES})`);
                setTimeout(_initWithRetry, 1000 * (2 ** _initRetries));
            } else {
                console.error('级联向导初始化最终失败:', error);
            }
        }
    }

    document.addEventListener('DOMContentLoaded', () => _initWithRetry());

})();
