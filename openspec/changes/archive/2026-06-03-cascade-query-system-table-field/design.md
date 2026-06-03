## Context

当前展示层查询流程是"表名关键词搜索 → 字段选择"两步模式（`search-panel.js`）。前端已有 `cascading-wizard.js` 实现了系统→Schema→表→字段的四级级联逻辑，但它引用的 API 端点（`/api/v1/systems` 等）不存在，且该 JS 文件未接入 HTML。后端 `TableQueryService` 已有 `get_systems()`、`get_schemas()`、`get_tables_by_schema()` 方法，但缺少对应的 API 路由。

用户要求改为三级级联（系统→表→字段），去掉 Schema 层级，三个字段全部选好后才可查询。

## Goals / Non-Goals

**Goals:**
- 实现系统→表→字段三级级联选择器，替代现有的表名搜索模式
- 强制三级全部选完才可查询（查询按钮仅三级全选后激活）
- 后端新增级联查询 API 端点，暴露已有的 `TableQueryService` 方法
- 保留"高级搜索"切换入口，兼容原有关键词搜索行为

**Non-Goals:**
- 不做 Schema 级（四级级联），用户要求去掉这一层
- 不改造指标 Tab（indicator tab）的查询流程
- 不改变血缘查询 API 的核心逻辑（`/api/lineage/query` POST 接口不变）
- 不做级联选择的 URL/bookmark 支持（不持久化选择状态）

## Decisions

### D1: 级联层级 = 系统→表→字段（三级），不保留 Schema 层

**选择**: 三级而非四级。用户明确要求去掉 Schema 层级。

**理由**: Schema 层在 Oracle 系统中才有意义（如 RRP_MDL/RRP_EAST），对数仓系统（EDW/MCS）的表大多无 schema 或只有一个默认 schema。增加 Schema 层会让大部分用户多选一层无意义选项。改为系统选择后，直接展示该系统下所有表（内含 schema 前缀区分）。

**备选**: 四级级联（系统→Schema→表→字段），已在 `cascading-wizard.js` 实现。不采用，因为用户明确要求三级。

### D2: 复用并改造 `cascading-wizard.js`，而非重写全新模块

**选择**: 改造现有 `cascading-wizard.js`，去掉 Schema 级联逻辑，调整 API 端点路径，适配三级模式。

**理由**: `cascading-wizard.js` 已有 14KB 完整的级联选择器实现（缓存、级联清空、XSS 防护、重试机制、模式切换），复用可大幅减少工作量。只需去掉 Schema 层并调整 API URL。

**备选**: 从零重写级联模块。工作量更大，且核心逻辑（缓存、级联重置、查询执行）与现有文件高度重复。

### D3: 后端 API 路径不含 `/v1/` 前缀，对齐现有 API 风格

**选择**: 新增端点使用 `/api/systems` 和 `/api/systems/{name}/tables`，不含 `/v1/`。

**理由**: 项目现有所有端点都在 `/api/` 下（如 `/api/tables`、`/api/lineage/query`），没有 `/v1/` 前缀。保持一致。

**备选**: 使用 `/api/v1/systems`。cascading-wizard.js 当前引用此路径。不采用，与项目风格不一致。

### D4: 系统下表列表接口支持 keyword 过滤参数

**选择**: `GET /api/systems/{name}/tables` 支持 `?keyword=` 参数，用于前端表名搜索框过滤。

**理由**: 系统可能有数百张表，提供关键词过滤让用户快速定位目标表。`get_tables_by_schema()` 已有 keyword 参数，只需在 API 层透传。

### D5: 系统列表数据从后端动态加载，不做硬编码

**选择**: 页面加载时调 `GET /api/systems` 获取系统列表，与 manifest.yml 配置同步。

**理由**: 系统列表依赖运行时配置（manifest.yml 可动态增减数据源），硬编码会导致前后端不一致。后端 `get_systems()` 已实现。

### D6: 级联模式与高级搜索模式作为 Tab 式切换

**选择**: 在查询面板顶部用两个按钮（"级联查询"/"高级搜索"）切换，不额外增加 Tab。

**理由**: 这是同一个查询功能的不同入口方式，用按钮切换比增加 Tab 更轻量。`cascading-wizard.js` 已有 `setQueryMode()` 实现模式切换逻辑。

## Risks / Trade-offs

- **[大系统性能]** 单个系统可能有数百张表（如 EDW），级联加载一次性返回全部表可能导致下拉列表过长 → Mitigation: 表选择下拉框内增加搜索过滤输入框（已在前端实现 keyword 参数），默认只显示前 100 条，支持搜索缩小范围
- **[跨系统同名表]** 不同系统可能有同名表（如 RRP 和 EDW 都有某表），级联选择时已通过系统筛选避免混淆 → 无额外风险，这正是级联查询的优势
- **[cascading-wizard.js API 路径不匹配]** 现有 JS 引用 `/api/v1/systems` 等不存在路径 → Mitigation: 改造 JS 文件时统一调整所有 API 路径为 `/api/systems` 系列
- **[Schema 级联数据丢失]** 去掉 Schema 层后，Oracle 系统中同一系统多个 schema 的表将混合展示 → Mitigation: 表名本身包含 schema 前缀（如 `RRP_MDL.ICL_CMM_XXX`），下拉列表中用 schema 前缀颜色区分即可，且字段名展示时仍标注 schema