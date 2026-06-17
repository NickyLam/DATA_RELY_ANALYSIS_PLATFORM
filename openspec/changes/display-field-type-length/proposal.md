## Why

当前血缘图节点只展示表名和链路字段名，用户无法直接判断字段的数据类型、字符长度或数值精度，必须点击节点再查看详情。解析结果实际上已保存完整的 `data_type`（如 `VARCHAR2(60)`、`NUMBER(18,2)`），需要将这部分元数据准确绑定到当前链路节点并在图上直接展示。

## What Changes

- 为血缘查询结果中的每个节点补充当前链路字段元数据，包括字段名和原始数据类型声明。
- 由后端根据“表 + 当前链路字段”匹配列定义，避免前端仅从第一条边猜测字段后无法获得类型。
- 在 D3 血缘图节点中展示 `字段名 类型(长度/精度)`；无长度的数据类型仅展示类型，无类型元数据时保持仅展示字段名。
- 节点详情面板复用同一份字段元数据，并保持对缺失 DDL、表级补充节点和旧缓存数据的兼容。
- 增加服务层、API 契约和前端渲染测试，覆盖长度、精度、无长度和元数据缺失场景。

## Capabilities

### New Capabilities

- `lineage-node-field-metadata`: 定义血缘图节点关联字段元数据的组装、API 返回、降级规则和展示格式。

### Modified Capabilities

无。

## Impact

- 后端：`app/services/lineage_service.py` 的节点组装逻辑，必要时扩展 `app/services/lineage_query_index.py` 的列元数据索引。
- API：`POST /api/lineage/query` 的 `nodes[]` 增加向后兼容的可选字段元数据，不移除或重命名现有字段。
- 前端：`static/js/lineage-graph.js` 和 `static/js/detail-panel.js` 使用节点元数据渲染字段类型；`static/js/display-tab.js` 仅作为未加载的旧实现核对，不作为主要改造入口。
- 测试：补充 `tests/test_lineage_api.py`、服务层单元测试及 `tests/frontend_e2e_test.py` 中的节点文本断言。
- 存储与解析：现有 `ColumnInfo.data_type`、`columns_json` 和缓存结构可继续使用，无需数据库迁移或重新设计 DDL 解析模型。
