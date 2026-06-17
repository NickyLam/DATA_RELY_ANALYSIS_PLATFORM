## ADDED Requirements

### Requirement: All dynamically inserted HTML content must be escaped
前端 JavaScript 中所有通过 `innerHTML`、`outerHTML` 插入 DOM 的动态内容 MUST 经过 HTML 实体转义处理。转义范围包括：`&`, `<`, `>`, `"`, `'`, `` ` ``。

#### Scenario: 搜索结果渲染时 schema 和 short_name 被转义
- **WHEN** 后端返回的表数据中 `schema` 或 `short_name` 包含 HTML 特殊字符（如 `<img onerror=...>`）
- **AND** `search-panel.js` 将搜索结果插入 `resultsContainer.innerHTML`
- **THEN** 特殊字符 SHALL 被转义为对应的 HTML 实体
- **AND** 浏览器 SHALL 不会将其解析为 HTML 标签或属性

#### Scenario: 详情面板字段映射显示时值被转义
- **WHEN** `detail-panel.js` 渲染字段映射列表（source_table, source_column, target_table, target_column）
- **AND** 这些值包含 HTML 特殊字符
- **THEN** 所有值 MUST 通过 `_escape()` 函数处理后才能拼入 HTML 模板

#### Scenario: 详情面板上游/下游表名被转义
- **WHEN** `renderDetailPanel` 渲染 upTables/downTables 列表
- **AND** 表名包含特殊字符
- **THEN** `data-table-name` 属性和显示文本均 MUST 经过 `_escape()` 处理

#### Scenario: escapeHtml 函数覆盖完整的特殊字符集
- **WHEN** `app.js` 中定义的全局 `escapeHtml()` 函数被调用
- **THEN** 它 SHALL 转义以下 5 种字符：`&` → `&amp;`, `<` → `&lt;`, `>` → `&gt;`, `"` → `&quot;`, `'` → `&#39;`

### Requirement: Event delegation pattern must be used over inline handlers
前端 JavaScript 中所有用户交互事件 MUST 使用事件委托模式（`addEventListener` + `data-*` 属性 + `closest()` 匹配），禁止使用 `onclick` 等 inline handler。

#### Scenario: 点击搜索结果项触发选择
- **WHEN** 用户点击 `.search-result-item` 元素
- **THEN** 事件 MUST 通过 document 级别的事件委托捕获
- **AND** 通过 `e.target.closest('[data-table-name]')` 获取目标数据
