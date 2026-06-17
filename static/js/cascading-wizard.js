/**
 * 级联查询模块（三级：系统→表→字段）
 * 表名和字段名使用 combobox 控件：支持输入模糊匹配 + 下拉选择
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

    /** 高亮匹配关键词 */
    function _highlight(text, keyword) {
        if (!keyword) return _esc(text);
        const escaped = _esc(text);
        const kw = _esc(keyword);
        const idx = escaped.toUpperCase().indexOf(kw.toUpperCase());
        if (idx < 0) return escaped;
        return escaped.substring(0, idx) + '<mark>' + escaped.substring(idx, idx + kw.length) + '</mark>' + escaped.substring(idx + kw.length);
    }

    // 缓存
    let _systemsCache = null;
    let _tablesCache = {};
    const CACHE_MAX_SIZE = 100;
    const CACHE_TTL_MS = 5 * 60 * 1000;
    let _currentFields = [];       // 当前选中表的字段列表 [{name, data_type}] 或 [string]
    let _currentSystem = '';
    let _currentTableFullName = '';
    let _currentFieldName = '';
    let _queryMode = 'wizard';
    let _tablesList = [];          // 当前系统下的所有表数据（用于模糊过滤）
    let _tableComboTimer = null;   // 防抖计时器

    function _tablesCacheGet(key) {
        const entry = _tablesCache[key];
        if (!entry) return null;
        if (Date.now() - entry.timestamp > CACHE_TTL_MS) {
            delete _tablesCache[key];
            return null;
        }
        return entry.data;
    }

    function _tablesCacheSet(key, data) {
        const keys = Object.keys(_tablesCache);
        if (keys.length >= CACHE_MAX_SIZE) {
            let oldestKey = keys[0];
            let oldestTime = _tablesCache[keys[0]].timestamp;
            for (let i = 1; i < keys.length; i++) {
                if (_tablesCache[keys[i]].timestamp < oldestTime) {
                    oldestKey = keys[i];
                    oldestTime = _tablesCache[keys[i]].timestamp;
                }
            }
            delete _tablesCache[oldestKey];
        }
        _tablesCache[key] = { data, timestamp: Date.now() };
    }

    // ============================================
    // 初始化：加载系统列表
    // ============================================
    window.initCascadingWizard = async function() {
        if (_systemsCache) return;
        await loadSystems();
    };

    async function loadSystems() {
        const select = document.getElementById('systemSelect');
        if (!select) return;

        try {
            const response = await apiRequest('/api/systems');
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
    // 系统→表 级联（combobox）
    // ============================================
    window.onSystemChange = async function() {
        const system = document.getElementById('systemSelect').value;

        resetCascadeFrom('table');
        if (!system) return;

        _currentSystem = system;

        const tableInput = document.getElementById('tableComboInput');
        tableInput.disabled = true;
        tableInput.value = '';
        tableInput.placeholder = '加载中...';

        try {
            let tables = _tablesCacheGet(system);
            if (!tables) {
                const response = await apiRequest(`/api/systems/${encodeURIComponent(system)}/tables`);
                tables = response.data || [];
                _tablesCacheSet(system, tables);
            }
            _tablesList = tables;
            tableInput.disabled = false;
            tableInput.placeholder = '输入搜索或点击选择';
            // 不自动弹出下拉，等用户主动 focus 或输入时才显示
        } catch (error) {
            console.error('加载表列表失败:', error);
            tableInput.placeholder = '加载失败';
        }
    };

    /** 渲染表名 combobox 下拉 */
    function renderTableComboDropdown(keyword, tables) {
        const dropdown = document.getElementById('tableComboDropdown');
        if (!dropdown) return;

        const kw = (keyword || '').trim().toUpperCase();
        let filtered = tables;

        if (kw) {
            filtered = tables.filter(t => {
                const short = (t.short_name || '').toUpperCase();
                const full = (t.full_name || '').toUpperCase();
                return short.includes(kw) || full.includes(kw);
            });
        }

        if (filtered.length === 0) {
            dropdown.innerHTML = '<div class="combo-empty">无匹配表</div>';
            dropdown.style.display = 'block';
            return;
        }

        const MAX_DISPLAY = 100;
        const display = filtered.slice(0, MAX_DISPLAY);

        let html = display.map((t, idx) => {
            const schemaPrefix = t.full_name.includes('.') ? `${_esc(t.full_name.split('.')[0])}.` : '';
            const layerTag = t.layer ? ` [${_esc(t.layer)}]` : '';
            const shortHighlighted = _highlight(t.short_name || t.full_name, keyword);
            return `<div class="combo-item" data-table-full="${_esc(t.full_name)}" data-index="${idx}">
                <span class="combo-main">${schemaPrefix}${shortHighlighted}</span>
                <span class="combo-sub">${layerTag} (${t.field_count || 0} 字段)</span>
            </div>`;
        }).join('');

        if (filtered.length > MAX_DISPLAY) {
            html += `<div class="combo-more">... 共 ${filtered.length} 个匹配项，请继续输入缩小范围</div>`;
        }

        dropdown.innerHTML = html;
        dropdown.style.display = 'block';
    }

    /** 选中表名 combobox 项 */
    function selectTableCombo(fullName) {
        const tableInput = document.getElementById('tableComboInput');
        tableInput.value = fullName;
        document.getElementById('tableComboDropdown').style.display = 'none';
        _currentTableFullName = fullName;
        // 触发字段加载
        loadFieldsForTable(fullName);
    }

    // ============================================
    // 表→字段 级联（combobox）
    // ============================================
    async function loadFieldsForTable(tableFullName) {
        const fieldInput = document.getElementById('fieldComboInput');
        fieldInput.disabled = true;
        fieldInput.value = '';
        fieldInput.placeholder = '加载中...';
        _currentFields = [];
        _currentFieldName = '';
        updateCascadingQueryBtn();

        try {
            const response = await apiRequest(`/api/tables/${encodeURIComponent(tableFullName)}/fields`);
            const fields = response.data || [];
            _currentFields = fields;
            fieldInput.disabled = false;
            fieldInput.placeholder = fields.length > 0 ? `输入搜索或选择（${fields.length} 字段）` : '无字段数据，可手动输入';
            // 不自动弹出，等用户主动 focus 或输入
        } catch (error) {
            console.error('加载字段列表失败:', error);
            // 回退：通过搜索接口获取
            try {
                const shortName = tableFullName.split('.').pop();
                const searchResp = await apiRequest(`/api/tables?keyword=${encodeURIComponent(shortName)}&limit=5`);
                const tables = searchResp.data || [];
                const matched = tables.find(t => t.full_name === tableFullName);
                const columns = matched?.columns || [];
                _currentFields = columns;
                fieldInput.disabled = false;
                fieldInput.placeholder = columns.length > 0 ? `输入搜索或选择（${columns.length} 字段）` : '可手动输入';
                // 不自动弹出
            } catch (e2) {
                fieldInput.placeholder = '加载失败，可手动输入';
                fieldInput.disabled = false;
            }
        }
    }

    /** 渲染字段 combobox 下拉 */
    function renderFieldComboDropdown(keyword, fields) {
        const dropdown = document.getElementById('fieldComboDropdown');
        if (!dropdown) return;

        const kw = (keyword || '').trim().toUpperCase();
        let filtered = fields;

        if (kw) {
            filtered = fields.filter(f => {
                const name = (typeof f === 'string' ? f : f.name || '').toUpperCase();
                return name.includes(kw);
            });
        }

        if (filtered.length === 0) {
            dropdown.innerHTML = '<div class="combo-empty">无匹配字段</div>';
            dropdown.style.display = 'block';
            return;
        }

        const MAX_DISPLAY = 80;
        const display = filtered.slice(0, MAX_DISPLAY);

        let html = display.map(f => {
            const name = typeof f === 'string' ? f : (f.name || '');
            const dtype = (typeof f === 'object' && f.data_type) ? f.data_type : '';
            const nameHighlighted = _highlight(name, keyword);
            const typeLabel = dtype ? `<span class="combo-sub">${_esc(dtype)}</span>` : '';
            return `<div class="combo-item" data-field-name="${_esc(name)}">
                <span class="combo-main">${nameHighlighted}</span>${typeLabel}
            </div>`;
        }).join('');

        if (filtered.length > MAX_DISPLAY) {
            html += `<div class="combo-more">... 共 ${filtered.length} 个匹配项</div>`;
        }

        dropdown.innerHTML = html;
        dropdown.style.display = 'block';
    }

    /** 选中字段 combobox 项 */
    function selectFieldCombo(fieldName) {
        const fieldInput = document.getElementById('fieldComboInput');
        fieldInput.value = fieldName;
        document.getElementById('fieldComboDropdown').style.display = 'none';
        _currentFieldName = fieldName;
        updateCascadingQueryBtn();
    }

    // ============================================
    // 查询按钮状态控制
    // ============================================
    function updateCascadingQueryBtn() {
        const btn = document.getElementById('cascadingQueryBtn');
        if (!btn) return;
        const tableVal = document.getElementById('tableComboInput')?.value.trim() || '';
        const fieldVal = document.getElementById('fieldComboInput')?.value.trim() || '';
        btn.disabled = !(tableVal.length >= 2 && fieldVal.length >= 1);
    }
    window.onFieldChange = function() { updateCascadingQueryBtn(); };

    // ============================================
    // 级联查询执行
    // ============================================
    window.executeCascadingQuery = async function() {
        const tableFullName = document.getElementById('tableComboInput').value.trim();
        let fieldName = document.getElementById('fieldComboInput').value.trim();

        if (!tableFullName || !fieldName) {
            showNotification('请完成级联选择后再查询', 'warning');
            return;
        }

        fieldName = fieldName.toUpperCase();
        document.getElementById('fieldComboInput').value = fieldName;
        document.getElementById('emptyHint').style.display = 'none';
        document.getElementById('loadingIndicator').style.display = 'block';

        try {
            const requestBody = {
                table: tableFullName,
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

            const graphData = response.data;
            const resolvedTable = graphData.query_target?.table || tableFullName;

            if (typeof currentQuery !== 'undefined') {
                currentQuery = { table: resolvedTable, field: fieldName };
            }

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
            prefillAdvancedFromWizard();
        }
    };

    function prefillAdvancedFromWizard() {
        const tableFullName = document.getElementById('tableComboInput')?.value || '';
        const fieldName = document.getElementById('fieldComboInput')?.value || '';
        const tableInput = document.getElementById('tableInput');
        const fieldInput = document.getElementById('fieldInput');

        if (tableFullName && tableInput) tableInput.value = tableFullName;
        if (fieldName && fieldInput) {
            fieldInput.value = fieldName;
            fieldInput.disabled = false;
        }
        if (typeof updateQueryButton === 'function') updateQueryButton();
    }

    // ============================================
    // 级联重置
    // ============================================
    function resetCascadeFrom(level) {
        _currentFields = [];
        _currentFieldName = '';

        if (level === 'table') {
            _currentTableFullName = '';
            _tablesList = [];
            const tableInput = document.getElementById('tableComboInput');
            if (tableInput) {
                tableInput.value = '';
                tableInput.disabled = true;
                tableInput.placeholder = '-- 请先选择系统 --';
            }
            const tableDropdown = document.getElementById('tableComboDropdown');
            if (tableDropdown) {
                tableDropdown.style.display = 'none';
                tableDropdown.innerHTML = '';
            }
        }

        const fieldInput = document.getElementById('fieldComboInput');
        if (fieldInput) {
            fieldInput.value = '';
            fieldInput.disabled = true;
            fieldInput.placeholder = level === 'table' ? '-- 请先选择表 --' : '-- 请先选择表 --';
        }
        const fieldDropdown = document.getElementById('fieldComboDropdown');
        if (fieldDropdown) {
            fieldDropdown.style.display = 'none';
            fieldDropdown.innerHTML = '';
        }

        updateCascadingQueryBtn();
    }

    // ============================================
    // 快速查询兼容：从图谱中的快速跳转
    // ============================================
    const _originalQuickQuery = window.quickQuery;
    window.quickQuery = function(tableName) {
        if (_queryMode === 'wizard') {
            autoSelectInWizard(tableName);
        }
        if (_originalQuickQuery) {
            _originalQuickQuery(tableName);
        }
    };

    async function autoSelectInWizard(tableName) {
        // 在当前已加载的表列表中查找匹配
        const shortTarget = tableName.split('.').pop().toUpperCase();
        const matched = _tablesList.find(t =>
            t.full_name === tableName ||
            t.full_name.toUpperCase() === tableName.toUpperCase() ||
            (t.short_name || '').toUpperCase() === shortTarget
        );
        if (matched) {
            selectTableCombo(matched.full_name);
        }
    }

    // ============================================
    // 暴露状态访问接口
    // ============================================
    window.getCascadingWizardState = function() {
        return {
            currentSystem: _currentSystem,
            currentTableFullName: _currentTableFullName,
            currentFields: _currentFields,
            queryMode: _queryMode,
        };
    };

    // ============================================
    // 事件绑定（combobox 输入/焦点/键盘/外部点击）
    // ============================================
    function setupComboListeners() {
        // --- 表名 combobox ---
        const tableInput = document.getElementById('tableComboInput');
        const tableDropdown = document.getElementById('tableComboDropdown');

        if (tableInput) {
            tableInput.addEventListener('input', () => {
                const kw = tableInput.value.trim();
                clearTimeout(_tableComboTimer);
                _tableComboTimer = setTimeout(() => {
                    renderTableComboDropdown(kw, _tablesList);
                }, 150);
                updateCascadingQueryBtn();
            });

            tableInput.addEventListener('focus', () => {
                if (!tableInput.disabled && _tablesList.length > 0) {
                    renderTableComboDropdown(tableInput.value.trim(), _tablesList);
                }
            });

            tableInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    // 选择下拉第一项或直接提交
                    const firstItem = tableDropdown?.querySelector('.combo-item');
                    if (firstItem && tableDropdown.style.display !== 'none') {
                        firstItem.click();
                    }
                }
                if (e.key === 'Escape') {
                    tableDropdown.style.display = 'none';
                }
                if (e.key === 'Tab' && tableDropdown.style.display !== 'none') {
                    const firstItem = tableDropdown.querySelector('.combo-item');
                    if (firstItem) {
                        e.preventDefault();
                        firstItem.click();
                    }
                }
            });
        }

        // --- 字段 combobox ---
        const fieldInput = document.getElementById('fieldComboInput');
        const fieldDropdown = document.getElementById('fieldComboDropdown');

        if (fieldInput) {
            fieldInput.addEventListener('input', () => {
                const kw = fieldInput.value.trim();
                renderFieldComboDropdown(kw, _currentFields);
                _currentFieldName = kw;
                updateCascadingQueryBtn();
            });

            fieldInput.addEventListener('focus', () => {
                if (!fieldInput.disabled && _currentFields.length > 0) {
                    renderFieldComboDropdown(fieldInput.value.trim(), _currentFields);
                }
            });

            fieldInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    const firstItem = fieldDropdown?.querySelector('.combo-item');
                    if (firstItem && fieldDropdown.style.display !== 'none') {
                        firstItem.click();
                    } else if (!document.getElementById('cascadingQueryBtn').disabled) {
                        executeCascadingQuery();
                    }
                }
                if (e.key === 'Escape') {
                    fieldDropdown.style.display = 'none';
                }
                if (e.key === 'Tab' && fieldDropdown.style.display !== 'none') {
                    const firstItem = fieldDropdown.querySelector('.combo-item');
                    if (firstItem) {
                        e.preventDefault();
                        firstItem.click();
                    }
                }
            });
        }

        // --- 事件委托：点击下拉项 ---
        document.addEventListener('click', (e) => {
            // 表名下拉项
            const tableItem = e.target.closest('[data-table-full]');
            if (tableItem) {
                selectTableCombo(tableItem.dataset.tableFull);
                return;
            }

            // 字段下拉项
            const fieldItem = e.target.closest('[data-field-name]');
            if (fieldItem && fieldItem.closest('#fieldComboDropdown')) {
                selectFieldCombo(fieldItem.dataset.fieldName);
                return;
            }

            // 点击外部关闭下拉
            const tableGroup = tableInput?.closest('.input-group');
            if (tableDropdown && tableGroup && !tableGroup.contains(e.target)) {
                tableDropdown.style.display = 'none';
            }

            const fieldGroup = fieldInput?.closest('.input-group');
            if (fieldDropdown && fieldGroup && !fieldGroup.contains(e.target)) {
                fieldDropdown.style.display = 'none';
            }
        });
    }

    // ============================================
    // 页面加载时初始化
    // ============================================
    let _initRetries = 0;
    const MAX_INIT_RETRIES = 5;

    async function _initWithRetry() {
        try {
            await loadSystems();
            setupComboListeners();
            _initRetries = 0;
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
