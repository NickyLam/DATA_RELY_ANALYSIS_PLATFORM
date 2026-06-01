# Implementation Tasks

1. **新增后端 API：获取系统列表**
   - `GET /api/v1/systems` 返回所有启用的数据源（name + display_name + table_count）
   - 从 `AppConfig.datasource_configs` 获取，聚合表计数

2. **新增后端 API：获取系统下的 schema 列表**
   - `GET /api/v1/systems/{system}/schemas` 返回 schema 名称 + 表计数
   - 从 `LineageService` 的 `search_tables` 结果中提取 distinct schema

3. **新增后端 API：获取 schema 下的表列表**
   - `GET /api/v1/systems/{system}/schemas/{schema}/tables` 返回表列表（含 short_name, full_name, layer, field_count）
   - 支持 `?keyword=` 过滤参数

4. **新增服务层方法**
   - `LineageService.get_systems()` — 聚合系统列表
   - `LineageService.get_schemas(system)` — 聚合 schema 列表
   - `LineageService.get_tables_by_schema(system, schema)` — 按系统+schema 过滤表

5. **前端：级联选择器 HTML 结构**
   - 4 个级联下拉框（系统→Schema→表→字段）+ 查询按钮
   - "高级搜索"折叠区域（保留原有输入框）

6. **前端：级联选择器 JS 逻辑**
   - 系统选择 → 加载 schema 列表 → 清空下游
   - Schema 选择 → 加载表列表 → 清空下游
   - 表选择 → 加载字段列表
   - 字段选择 → 激活查询按钮
   - 每级选择时自动显示 loading 状态

7. **前端：高级搜索模式切换**
   - 级联向导（默认）↔ 自由搜索（高级）切换按钮
   - 切换时保留已选参数（如从级联切到高级搜索，表名和字段名保留在输入框）

8. **前端：级联组件样式**
   - 级联下拉框使用统一的 select 样式
   - 选中项显示层级标签（系统名/schema名）
   - 响应式布局：窄屏时级联改为纵向堆叠

9. **数据兜底：未分类表处理**
   - 无 schema 的表归入"未分类"组
   - "未分类"组在 schema 列表末尾显示，带灰色标记

10. **缓存优化**
    - 系统/schema 列表启动时预加载到前端（少量数据）
    - 表列表按 schema 缓存，避免重复请求
    - 字段列表复用现有 `_currentTableFields` 缓存

11. **测试：后端 API 测试**
    - 测试 3 个新端点（正常/边界/错误场景）
    - 验证系统/schema 列表正确性

12. **测试：前端级联交互测试**
    - 级联选择 → 查询 → 血缘图渲染端到端
    - 高级搜索 ↔ 级联向导切换
    - 空数据/错误处理
