/**
 * 展示层 - 搜索面板模块
 * 负责表名搜索（带防抖）、字段联动（加载+过滤+验证）、查询参数构建和触发
 *
 * 核心约束：字段名必须是选中表的字段，选中后自动转大写
 */
(function() {
    'use strict';

    // 模块内部缓存
    let _currentTableFields = [];   // 当前选中表的字段列表（全大写）
    let _currentTableFullName = ''; // 当前选中表的完整名
    let _lastSearchResults = [];    // 最近一次表搜索结果
    let _tableSearchSeq = 0;         // 防止慢响应覆盖新输入
    const _tableSearchCache = new Map();
    const CACHE_MAX_SIZE = 100;
    const CACHE_TTL_MS = 5 * 60 * 1000;  // 5分钟过期

    function _cacheSet(key, value) {
        if (_tableSearchCache.size >= CACHE_MAX_SIZE) {
            const firstKey = _tableSearchCache.keys().next().value;
            _tableSearchCache.delete(firstKey);
        }
        _tableSearchCache.set(key, { value, timestamp: Date.now() });
    }

    function _cacheGet(key) {
        const entry = _tableSearchCache.get(key);
        if (!entry) return null;
        if (Date.now() - entry.timestamp > CACHE_TTL_MS) {
            _tableSearchCache.delete(key);
            return null;
        }
        // Move to end for LRU behavior
        _tableSearchCache.delete(key);
        _tableSearchCache.set(key, entry);
        return entry.value;
    }

    // ============================================
    // 表名搜索（带防抖）
    // ============================================
    window.onTableInput = debounce(async function () {
        const keyword = document.getElementById('tableInput').value.trim();
        const resultsContainer = document.getElementById('searchResults');

        if (!resultsContainer) return;

        if (keyword.length < 2) {
            resultsContainer.style.display = 'none';
            updateQueryButton();
            return;
        }

        try {
            const cacheKey = keyword.toUpperCase();
            const searchSeq = ++_tableSearchSeq;
            let tables = _cacheGet(cacheKey);

            if (!tables) {
                const response = await apiRequest(`/api/tables?keyword=${encodeURIComponent(keyword)}&limit=15`);
                if (searchSeq !== _tableSearchSeq) return;
                tables = response.data || [];
                _cacheSet(cacheKey, tables);
            }

            if (tables.length === 0) {
                resultsContainer.style.display = 'none';
                return;
            }

            let html = tables.map((table, idx) => {
                const schemaLabel = table.schema ? `<span style="color:#6366f1;font-weight:600;">${escapeHtml(table.schema)}</span>.` : '';
                return `
                <div class="search-result-item" data-table-name="${escapeHtml(table.full_name)}" data-index="${idx}">
                    <div class="result-name">${schemaLabel}${escapeHtml(table.short_name || table.full_name)}</div>
                    <div class="result-type">表 · ${escapeHtml(table.layer || 'unknown')} · ${table.field_count || 0} 字段</div>
                </div>
            `}).join('');

            // 缓存搜索结果，供 selectTable 使用
            _lastSearchResults = tables;

            resultsContainer.innerHTML = html;
            resultsContainer.style.display = 'block';

        } catch (error) {
            console.error('搜索失败:', error);
        }
    }, 250);

    // 显示所有字段（供 focus 和 selectTable 使用）
    function showAllFields() {
        const fieldDropdown = document.getElementById('fieldResults');
        if (!fieldDropdown || _currentTableFields.length === 0) return;

        // 最多显示50个字段
        const display = _currentTableFields.slice(0, 50);
        let html = display.map(f =>
            `<div class="field-item" data-field-name="${escapeHtml(f)}">
                <span class="field-name">${f}</span>
            </div>`
        ).join('');

        if (_currentTableFields.length > 50) {
            html += `<div class="field-empty">... 还有 ${_currentTableFields.length - 50} 个字段</div>`;
        }

        fieldDropdown.innerHTML = html;
        fieldDropdown.style.display = 'block';
    }

    window.selectTable = function(fullName, searchIdx) {
        document.getElementById('tableInput').value = fullName;
        document.getElementById('searchResults').style.display = 'none';

        _currentTableFullName = fullName;
        _currentTableFields = [];

        // 重置字段输入
        const fieldInput = document.getElementById('fieldInput');
        fieldInput.value = '';
        fieldInput.disabled = true;
        fieldInput.placeholder = '加载字段中...';
        fieldInput.classList.remove('valid', 'invalid');
        document.getElementById('fieldResults').style.display = 'none';

        // 优先从搜索结果中获取字段列表（避免额外API请求）
        if (searchIdx !== undefined && searchIdx !== null && _lastSearchResults[searchIdx]) {
            const columns = _lastSearchResults[searchIdx].columns;
            if (columns && columns.length > 0) {
                _currentTableFields = columns.map(f => String(f).toUpperCase());
                fieldInput.disabled = false;
                fieldInput.placeholder = `从 ${_currentTableFields.length} 个字段中选择`;
                fieldInput.focus();
                updateQueryButton();
                console.log(`已从搜索结果加载 ${_currentTableFields.length} 个字段`);
                return;
            }
        }

        // 搜索结果无字段数据，通过精确搜索获取
        loadTableFields(fullName);
    };

    // ============================================
    // 加载指定表的字段列表（通过精确表名搜索）
    // ============================================
    async function loadTableFields(tableFullName) {
        const fieldInput = document.getElementById('fieldInput');

        try {
            // 使用完整表名精确搜索，search_tables 接口返回中包含 columns 字段
            const shortName = tableFullName.split('.').pop();
            const response = await apiRequest(`/api/tables?keyword=${encodeURIComponent(shortName)}&limit=10`);
            const tables = response.data || [];

            // 从结果中找到完全匹配的表
            const matched = tables.find(t =>
                t.full_name === tableFullName ||
                t.full_name.toUpperCase() === tableFullName.toUpperCase() ||
                t.short_name.toUpperCase() === shortName.toUpperCase()
            );

            if (matched && matched.columns && matched.columns.length > 0) {
                _currentTableFields = matched.columns.map(f => String(f).toUpperCase());
                fieldInput.disabled = false;
                fieldInput.placeholder = `从 ${_currentTableFields.length} 个字段中选择`;
                console.log(`已加载 ${_currentTableFields.length} 个字段`);
            } else {
                fieldInput.disabled = false;
                fieldInput.placeholder = '该表无字段数据，可手动输入';
                _currentTableFields = [];
                console.warn(`表 ${tableFullName} 无字段数据`);
            }
        } catch (error) {
            console.error('加载字段失败:', error);
            fieldInput.disabled = false;
            fieldInput.placeholder = '字段加载失败，可手动输入';
            _currentTableFields = [];
        }

        fieldInput.focus();
        updateQueryButton();
    }

    // ============================================
    // 字段输入过滤（实时搜索匹配）
    // ============================================
    window.onFieldInput = debounce(function () {
        const fieldInput = document.getElementById('fieldInput');
        const fieldDropdown = document.getElementById('fieldResults');
        const keyword = fieldInput.value.trim();

        // 清除验证样式
        fieldInput.classList.remove('valid', 'invalid');

        if (!keyword || _currentTableFields.length === 0) {
            fieldDropdown.style.display = 'none';
            updateQueryButton();
            return;
        }

        const keywordUpper = keyword.toUpperCase();

        // 过滤匹配的字段（支持包含匹配）
        const matched = _currentTableFields.filter(f => f.includes(keywordUpper));

        if (matched.length === 0) {
            fieldDropdown.innerHTML = '<div class="field-empty">无匹配字段</div>';
            fieldDropdown.style.display = 'block';
        } else {
            // 最多显示 50 条，避免 DOM 过大
            const display = matched.slice(0, 50);
            let html = display.map(f => {
                // 高亮匹配部分
                const idx = f.indexOf(keywordUpper);
                const highlighted = idx >= 0
                    ? f.substring(0, idx) + '<strong>' + f.substring(idx, idx + keywordUpper.length) + '</strong>' + f.substring(idx + keywordUpper.length)
                    : f;
                return `<div class="field-item" data-field-name="${escapeHtml(f)}">
                    <span class="field-name">${highlighted}</span>
                </div>`;
            }).join('');

            if (matched.length > 50) {
                html += `<div class="field-empty">... 还有 ${matched.length - 50} 个匹配字段</div>`;
            }

            fieldDropdown.innerHTML = html;
            fieldDropdown.style.display = 'block';
        }

        updateQueryButton();
    }, 150);

    // ============================================
    // 选中字段：自动大写填入输入框
    // ============================================
    window.selectField = function(fieldName) {
        const fieldInput = document.getElementById('fieldInput');
        const fieldDropdown = document.getElementById('fieldResults');

        // fieldName 已经是大写（从缓存中取），直接填入
        fieldInput.value = fieldName;
        fieldInput.classList.add('valid');
        fieldInput.classList.remove('invalid');
        fieldDropdown.style.display = 'none';

        updateQueryButton();
    };

    // ============================================
    // 查询按钮状态控制
    // ============================================
    window.updateQueryButton = function() {
        const tableVal = document.getElementById('tableInput').value.trim();
        const fieldVal = document.getElementById('fieldInput').value.trim();
        const fieldInput = document.getElementById('fieldInput');
        const btn = document.getElementById('queryBtn');

        if (btn) {
            btn.disabled = !(tableVal.length >= 2 && fieldVal.length >= 1);
        }

        // 实时验证字段是否合法（有缓存且输入不为空时）
        if (fieldVal && _currentTableFields.length > 0) {
            if (_currentTableFields.includes(fieldVal.toUpperCase())) {
                fieldInput.classList.add('valid');
                fieldInput.classList.remove('invalid');
            } else {
                fieldInput.classList.add('invalid');
                fieldInput.classList.remove('valid');
            }
        } else {
            fieldInput.classList.remove('valid', 'invalid');
        }
    };

    // ============================================
    // 执行字段级血缘查询（含字段验证）
    // ============================================
    window.executeFieldQuery = async function() {
        const tableName = document.getElementById('tableInput').value.trim();
        let fieldName = document.getElementById('fieldInput').value.trim();

        if (tableName.length < 2) {
            showNotification('请输入表名（至少2个字符）', 'warning');
            document.getElementById('tableInput').focus();
            return;
        }

        if (!fieldName) {
            showNotification('请输入字段名', 'warning');
            document.getElementById('fieldInput').focus();
            return;
        }

        // 自动转大写
        fieldName = fieldName.toUpperCase();

        // 验证字段是否属于选中表（如果有缓存字段列表）
        if (_currentTableFields.length > 0) {
            if (!_currentTableFields.includes(fieldName)) {
                showNotification(`字段 "${fieldName}" 不属于表 "${tableName.split('.').pop()}"，请从下拉列表中选择`, 'warning');
                document.getElementById('fieldInput').focus();
                return;
            }
        }

        // 更新输入框为大写值
        document.getElementById('fieldInput').value = fieldName;
        document.getElementById('fieldResults').style.display = 'none';
        document.getElementById('emptyHint').style.display = 'none';
        document.getElementById('loadingIndicator').style.display = 'block';

        try {
            let fullTableName = tableName;

            if (!fullTableName.includes('.')) {
                try {
                    const searchResult = await apiRequest(`/api/tables?keyword=${encodeURIComponent(tableName)}&limit=10`);

                    if (searchResult.data && searchResult.data.length > 0) {
                        const shortName = tableName.toUpperCase();
                        const exactMatches = searchResult.data.filter(t => {
                            const short = t.full_name.split('.').pop().toUpperCase();
                            return short === shortName;
                        });
                        let bestMatch;
                        if (exactMatches.length === 1) {
                            bestMatch = exactMatches[0];
                        } else if (exactMatches.length > 1) {
                            // 多个 schema 同名表：优先选择 schema 与表名前缀重叠的
                            bestMatch = exactMatches.reduce((best, t) => {
                                const schema = (t.schema || '').toUpperCase();
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
                            bestMatch = searchResult.data[0];
                        }
                        fullTableName = bestMatch.full_name;
                    }
                } catch (e) {
                    console.error('表名解析失败:', e);
                }
            }

            const requestBody = {
                table: fullTableName,
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

            graphData = response.data;

            const resolvedTable = graphData.query_target?.table || fullTableName;
            currentQuery = { table: resolvedTable, field: fieldName };

            console.log('查询完成:', resolvedTable, fieldName,
                '节点:', graphData.nodes_count, '边:', graphData.edges_count);

            // 调用其他模块的渲染函数
            if (typeof renderGraphVertical === 'function') {
                renderGraphVertical(graphData);
            }
            if (typeof renderDetailPanel === 'function') {
                renderDetailPanel(graphData, resolvedTable);
            }

            document.getElementById('legend').classList.add('show');
            document.querySelector('.zoom-controls').style.display = 'flex';

        } catch (error) {
            console.error('查询失败:', error);
            showNotification('查询失败: ' + error.message, 'error');
        }

        document.getElementById('loadingIndicator').style.display = 'none';
    };

    // 快速切换到另一个表的查询
    const _prevQuickQuery = window.quickQuery;
    window.quickQuery = function(tableName) {
        document.getElementById('tableInput').value = tableName;
        _currentTableFullName = tableName;
        _currentTableFields = [];
        document.getElementById('fieldInput').value = '';
        document.getElementById('fieldInput').disabled = true;
        document.getElementById('fieldInput').placeholder = '加载字段中...';
        document.getElementById('fieldInput').classList.remove('valid', 'invalid');
        document.getElementById('fieldResults').style.display = 'none';
        loadTableFields(tableName);
        if (_prevQuickQuery) _prevQuickQuery(tableName);
    };

    // ============================================
    // 模块初始化：设置事件监听
    // ============================================
    window.setupSearchListeners = function() {
        const tableInput = document.getElementById('tableInput');
        const fieldInput = document.getElementById('fieldInput');

        if (tableInput) {
            tableInput.addEventListener('input', () => onTableInput());
            tableInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') {
                    // 如果已选中表且有字段，直接查询
                    const fieldVal = fieldInput.value.trim();
                    if (fieldVal && !fieldInput.disabled) {
                        executeFieldQuery();
                    } else if (!fieldInput.disabled) {
                        fieldInput.focus();
                    }
                }
            });
        }

        if (fieldInput) {
            // 使用自定义的 onFieldInput 替代直接 updateQueryButton
            fieldInput.addEventListener('input', () => onFieldInput());

            // 点击字段输入框时显示所有字段下拉列表
            fieldInput.addEventListener('focus', () => {
                if (!fieldInput.disabled && _currentTableFields.length > 0) {
                    const keyword = fieldInput.value.trim();
                    // 如果有输入则过滤显示，否则显示所有字段（最多50个）
                    if (!keyword) {
                        showAllFields();
                    } else {
                        onFieldInput();
                    }
                }
            });

            fieldInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' && !document.getElementById('queryBtn').disabled) {
                    executeFieldQuery();
                }
                // Tab 键自动补全：选择第一个匹配项
                if (e.key === 'Tab') {
                    const dropdown = document.getElementById('fieldResults');
                    if (dropdown.style.display !== 'none') {
                        const firstItem = dropdown.querySelector('.field-item');
                        if (firstItem) {
                            e.preventDefault();
                            firstItem.click();
                        }
                    }
                }
            });
        }

        // 点击外部关闭下拉
        document.addEventListener('click', (e) => {
            const results = document.getElementById('searchResults');
            const fieldDropdown = document.getElementById('fieldResults');

            // 关闭表名搜索下拉（点击不在表名输入组内时关闭）
            const tableGroup = document.getElementById('tableInput')?.closest('.input-group');
            if (results && tableGroup && !tableGroup.contains(e.target)) {
                results.style.display = 'none';
            }

            // 关闭字段下拉（点击不在字段输入组内时关闭）
            if (fieldDropdown) {
                const fieldGroup = document.getElementById('fieldInput')?.closest('.input-group');
                if (fieldGroup && !fieldGroup.contains(e.target)) {
                    fieldDropdown.style.display = 'none';
                }
            }
        });
    };

    // 暴露缓存访问接口（供其他模块使用）
    window.getSearchPanelState = function() {
        return {
            currentTableFields: _currentTableFields,
            currentTableFullName: _currentTableFullName,
        };
    };

    // 事件委托：处理 data-table-name / data-field-name 点击，替代 inline onclick（防 XSS）
    document.addEventListener('click', function(e) {
        const tableEl = e.target.closest('[data-table-name]');
        if (tableEl) {
            const tableName = tableEl.dataset.tableName;
            const idx = tableEl.dataset.index;
            if (tableName && typeof window.selectTable === 'function') {
                window.selectTable(tableName, idx !== undefined ? Number(idx) : undefined);
            }
            return;
        }
        const fieldEl = e.target.closest('[data-field-name]');
        if (fieldEl) {
            const fieldName = fieldEl.dataset.fieldName;
            if (fieldName && typeof window.selectField === 'function') {
                window.selectField(fieldName);
            }
        }
    });

})();
