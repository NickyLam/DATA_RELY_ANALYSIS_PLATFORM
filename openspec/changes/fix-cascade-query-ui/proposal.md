## Why

展示层级联查询系统存在三个 UI 问题：1) 级联查询面板无法加载——`initCascadingWizard()` 函数已定义但从未被 `initDisplayTab()` 调用，导致系统下拉框始终停留在"加载中..."状态；2) 查询输入控件因 `min-width: 340px` 过大导致按钮换行，无法保持在同一行；3) 表名区域同时包含搜索输入框（`tableFilter`）和下拉选择框（`tableSelect`）两个控件，占用过多空间且交互冗余。

## What Changes

- **修复级联查询初始化**：在 `initDisplayTab()` 中调用 `initCascadingWizard()`，确保展示层 Tab 加载时级联选择器正确初始化
- **调整输入框布局**：减小 `.input-group` 的 `min-width`，使系统、表名、字段、方向、查询按钮在同一行显示
- **合并表名双控件为单控件**：移除 `tableFilter` 搜索输入框，将搜索过滤功能集成到 `tableSelect` 下拉框中（使用 select2 风格的可搜索下拉框，或原生 datalist 方案），保留一个控件即可

## Capabilities

### New Capabilities

（无新增能力）

### Modified Capabilities

- `cascade-query`: 修复初始化调用缺失、调整布局使控件同行显示、合并表名双控件为单控件

## Impact

- **前端文件**：`static/js/cascading-wizard.js`（初始化调用、移除 tableFilter 逻辑）、`static/js/display-tab.js`（添加 initCascadingWizard 调用）、`static/index.html`（移除 tableFilter HTML、调整布局）、`static/css/style.css`（调整 min-width 和布局样式）
- **后端**：无影响，API 接口不变
- **用户体验**：级联查询可正常加载，所有控件在同一行，表名选择更简洁
