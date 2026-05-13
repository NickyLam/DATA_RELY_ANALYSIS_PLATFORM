# DATA_RELY_ANALYSIS_SYS 项目记忆

## 项目概述
Oracle 数据库血缘分析系统，解析 .tab/.prc 文件，生成表级/字段级血缘关系，输出 JSON + HTML 可视化。

## 关键文件
- `core/layer_detector.py` — **层级检测权威模块**（LayerType/LAYER_CONFIG/detect_layer，支持 schema.table 全限定名）
- `core/table_parser.py` — OracleTableParser 表结构解析器（从 analyze_lineage.py 迁出）
- `core/models.py` — 数据模型（从 layer_detector re-export LayerType/detect_layer）
- `core/procedure_parser.py` — EnhancedProcedureParser 存储过程解析器
- `core/lineage_tracer.py` — LineageTracer 字段级血缘追踪（BFS上游+下游追溯）
- `app/services/lineage_service.py` — 血缘查询服务（委托 core.layer_detector 做层级检测）
- `app/services/parser_service.py` — 解析服务（使用 core.table_parser + core.procedure_parser）
- `api_server.py` — 遗留 HTTP 服务（使用 core.table_parser）
- `analyze_lineage.py` — **LEGACY**：向后兼容 wrapper，实际代码已迁入 core/
- `static/index.html` — 前端入口，双Tab（解析层+展示层）
- `static/js/app.js` — 全局状态管理、TAB切换、工具函数
- `static/js/search-panel.js` — 展示层搜索面板（表名搜索、字段选择、查询触发）
- `static/js/lineage-graph.js` — 展示层D3.js图谱渲染（BFS布局、节点/边绘制）
- `static/js/detail-panel.js` — 展示层详情面板（字段映射列表、节点信息浮窗）
- `static/js/display-tab.js` — **已拆分为以上3个模块，不再被 index.html 引入**
- `static/js/parse-tab.js` — 解析层文件上传/进度/SSE逻辑

## 2026-05-11 修复：展示层Tab无法点击使用

### 根因
前端 `display-tab.js` 期望 `/api/lineage/query` 返回 `nodes/edges/field_mappings` 格式，但后端 `api_server.py` 返回的是 `chains` 格式，格式不匹配导致展示层渲染空数据。

### 修复内容（方案2：后端适配前端）
1. **新增 `_result_to_graph()` 转换函数**：将 `FieldLineageResult`（chains格式）转换为前端期望的 `{nodes, edges, field_mappings, query_target, query_time_ms}` 格式
   - 节点按 `table_name` 去重，包含 `id/layer/comment/columns`
   - 边从 chain 连续节点对提取，包含 `source_table/target_table/source_field/target_field`
   - 字段映射同样从 chain 节点对提取
2. **修改 `_handle_lineage_query()`**：使用 `_result_to_graph()` 替代 `_serialize_result()`，兼容前端 `depth`→`max_depth` 参数映射，接受 `mode` 参数
3. **修改 `_handle_lineage_get()`**：同上
4. **新增 `/health` 端点**：返回 `{status, uptime_seconds, total_tables, total_procedures}`，修复前端 `checkSystemHealth()` 404 错误

### 架构说明
- 前端请求体：`{table, field, depth, mode, options}` → 后端解析为 `max_depth`
- 前端 display-tab.js 的 D3.js 渲染使用表级节点（BFS代际深度布局），不是字段级
- `display-tab.js` 中的 `renderGraphVertical()` 自带 BFS 深度算法，不依赖后端 layer 排序
- 下游追溯（downstream mode）已实现，支持 schema 变体合并和环路检测

### 遗留问题
- `parse-tab.js` 调用的 `/api/parse/upload`、`/api/parse/parse-existing`、SSE 进度端点后端未实现（解析层Tab不可用）
- 双重血缘引擎未统一：`LineageService._trace_field_lineage` (JSON dict) vs `core/lineage_tracer` (dataclass)，建议后续独立重构

## 2026-05-11 修复：字段名大小写不敏感

`trace_field` / `trace_field_downstream` 在调用 `_build_chains_from_bfs_tree` 前未 normalize 参数，导致小写字段名（如 `cust_name`）拼接的 root_key 与 BFS 树中的大写 key 不匹配，返回空结果。修复：在两处入口方法中先对 table/field 做 normalize 再传入。

## 数据规模
- 3041 张表，1754 个存储过程
- 服务初始化约需 8 分钟（解析全部 .prc 文件）
