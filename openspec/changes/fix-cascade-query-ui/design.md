## Context

展示层级联查询系统（系统→表→字段三级选择器）存在三个 UI 问题：

1. **初始化缺失**：`cascading-wizard.js` 定义了 `initCascadingWizard()` 函数，但 `display-tab.js` 的 `initDisplayTab()` 从未调用它，导致系统下拉框停留在"加载中..."状态
2. **布局换行**：`.input-group` 的 `min-width: 340px` 过大，5 个控件（系统、表名、字段、方向、查询按钮）无法在同一行显示
3. **表名双控件**：表名区域同时有 `tableFilter`（搜索输入框）和 `tableSelect`（下拉选择框），占用空间且交互冗余

当前布局结构（`static/index.html` 第 224-268 行）：
```
.query-inputs-row (flex, gap: 16px)
  ├── .input-group (系统选择, min-width: 340px)
  ├── .input-group (表名, flex:2, min-width: 340px)
  │     ├── #tableFilter (搜索输入框)
  │     └── #tableSelect (下拉选择框)
  ├── .input-group (字段名, min-width: 340px)
  ├── .input-group.mode-group (方向, min-width: 200px)
  └── .input-group.btn-group (查询按钮, min-width: auto)
```

## Goals / Non-Goals

**Goals:**
- 修复级联查询初始化，确保展示层 Tab 加载时系统下拉框正确填充
- 调整布局使所有控件在同一行显示（桌面端）
- 合并表名双控件为单控件，简化交互

**Non-Goals:**
- 不修改后端 API（`/api/systems`、`/api/systems/{name}/tables` 接口保持不变）
- 不引入新的第三方库（如 Select2、Choices.js）
- 不修改高级搜索面板的布局

## Decisions

### D1: 初始化调用位置

**选择**：在 `display-tab.js` 的 `initDisplayTab()` 末尾添加 `initCascadingWizard()` 调用

**理由**：
- `initDisplayTab()` 是展示层 Tab 的标准入口点，由 `switchTab('display')` 触发
- `initCascadingWizard()` 内部有缓存检查（`if (_systemsCache) return;`），多次调用无副作用
- 替代方案（在 HTML onload 或 app.js 中调用）会增加耦合

### D2: 布局调整策略

**选择**：减小 `.input-group` 的 `min-width` 从 340px 到 140px，并调整表名控件宽度

**理由**：
- 5 个控件 + 4 个 gap(16px) = 5*140 + 4*16 = 764px 最小宽度，适合大多数桌面屏幕
- 表名控件使用 `flex: 2` 自动扩展，其他控件保持固定宽度
- 替代方案（移除 min-width）会导致控件过窄，影响用户体验

### D3: 表名控件合并方案

**选择**：移除 `tableFilter` 输入框，将搜索功能集成到 `tableSelect` 下拉框

**理由**：
- 原设计：`tableFilter` 输入 → 触发 API 过滤 → 更新 `tableSelect` 选项
- 新设计：直接在 `tableSelect` 上方添加一个搜索输入框（datalist 风格），或使用原生 `<input>` + `<select>` 组合但只显示一行
- 简化后：保留 `tableSelect`，移除 `tableFilter`，用户直接在下拉框中选择（表数量通常不超过 500，可直接滚动选择）
- 替代方案（使用 datalist）兼容性较差，iOS Safari 支持不完善

**最终方案**：移除 `tableFilter`，保留 `tableSelect`。如果表数量过多（>200），用户可通过高级搜索模式使用关键词搜索。

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 移除 tableFilter 后，用户无法快速过滤表列表 | 保留高级搜索模式作为备选；表数量 <200 时直接滚动选择足够 |
| 布局调整后小屏幕设备可能仍换行 | 响应式 CSS 已有 `@media (max-width: 768px)` 处理，换行后垂直排列 |
| initDisplayTab 多次调用可能重复初始化 | initCascadingWizard 内部有 `_systemsCache` 检查，幂等安全 |

## Migration Plan

1. **部署**：直接替换前端静态文件，无需后端重启
2. **回滚**：恢复 `static/js/display-tab.js`、`static/js/cascading-wizard.js`、`static/index.html`、`static/css/style.css` 四个文件
3. **验证**：打开展示层 Tab，检查系统下拉框是否正确加载；检查控件是否在同一行

## Open Questions

（无）
