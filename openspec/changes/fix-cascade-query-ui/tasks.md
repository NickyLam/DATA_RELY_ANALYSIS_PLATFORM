## 1. 修复级联查询初始化

- [x] 1.1 在 `static/js/display-tab.js` 的 `initDisplayTab()` 函数末尾添加 `if (typeof window.initCascadingWizard === 'function') window.initCascadingWizard();` 调用
- [x] 1.2 验证打开展示层 Tab 后系统下拉框正确填充数据，不再停留在"加载中..."状态

## 2. 合并表名双控件为单控件

- [x] 2.1 在 `static/index.html` 中移除 `#tableFilter` 输入框 HTML 元素（级联查询面板内），仅保留 `#tableSelect` 下拉选择框
- [x] 2.2 在 `static/js/cascading-wizard.js` 中移除所有对 `tableFilter` 元素的引用：`onSystemChange()` 中移除 `tableFilter` 相关代码、移除 `onTableFilterInput` 函数及其 `window` 暴露、`resetCascadeFrom()` 中移除 `tableFilter` 引用
- [x] 2.3 验证系统选择后表下拉框正常加载，表选择后字段下拉框正常级联

## 3. 调整布局使控件同行显示

- [x] 3.1 在 `static/css/style.css` 中将 `.input-group` 的 `min-width` 从 `340px` 改为 `140px`
- [x] 3.2 调整 `static/index.html` 中级联查询面板的 `.input-group` 内联样式，移除 `style="flex:2;"` 等不必要的内联宽度覆盖
- [x] 3.3 验证桌面端（≥1024px）所有控件在同一行显示，移动端（<768px）垂直堆叠正常

## 4. 集成验证

- [x] 4.1 运行 `python -m pytest tests/ -v` 确认全量测试通过（后端无变动，确保无回归）
- [x] 4.2 启动开发服务器，手动验证级联查询完整流程：选择系统→选择表→选择字段→执行查询
