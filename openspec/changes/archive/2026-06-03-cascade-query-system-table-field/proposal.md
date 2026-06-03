## Why

当前展示层的查询流程是"表名搜索 → 字段选择"两步，用户需要输入表名关键词搜索，从模糊匹配结果中选择表，再选字段。这种方式存在两个问题：

1. **缺少系统级筛选**：当多个系统（RRP/EDW/MCS/FDM）存在同名或相似表时，搜索结果混杂，用户难以快速定位到目标系统下的表。
2. **查询时机不受控**：用户可以在只选了表、未选字段时就点击查询，导致无效查询或错误结果。

改为系统→表→字段三级级联选择，强制用户逐层递进完成全部选择后才能查询，既缩小搜索范围提升效率，也保证查询参数的完整性。

## What Changes

- **新增系统级选择器**：查询面板顶部增加系统下拉选择（RRP监管报送平台、EDW企业级数据仓库、MCS管理驾驶舱、FDM财务数据集市等），数据源来自 `AppConfig.datasource_configs` 或 `SOURCE_DATA/manifest.yml`
- **改造表选择为级联**：表列表不再由关键词搜索触发，而是由系统选择触发，展示该系统下所有表（支持表名过滤缩小范围）
- **保留字段级联**：字段选择逻辑基本不变，仍由表选择触发加载
- **查询按钮激活条件变更**：必须系统+表+字段三者都选择完毕才激活查询按钮
- **保留快速搜索入口**：提供"高级搜索"模式切换，允许用户直接输入表名关键词搜索（兼容现有行为）
- **后端新增级联查询 API**：`GET /api/systems`（系统列表）、`GET /api/systems/{name}/tables`（系统下表列表），复用现有 `GET /api/tables/{table}/fields`

## Capabilities

### New Capabilities
- `cascade-query`: 三级级联选择器（系统→表→字段）替代原有的两步搜索，强制逐层递进，三者选完才可查询

### Modified Capabilities
<!-- No existing specs to modify -->

## Impact

- **前端**：`static/js/search-panel.js` 重构为级联模式；`static/js/cascading-wizard.js` 已有部分实现可复用/改造；`static/index.html` 需更新查询面板 HTML 结构
- **后端**：`app/api/lineage.py` 或 `app/api/system.py` 新增系统列表和系统下表列表两个 API 端点；`app/services/lineage_service.py` 或 `app/services/table_query_service.py` 新增对应服务方法
- **API**：新增 `GET /api/systems` 和 `GET /api/systems/{name}/tables`，不影响现有端点
- **配置**：系统列表数据源已有（`AppConfig.datasource_configs` / manifest.yml），无需新增配置
