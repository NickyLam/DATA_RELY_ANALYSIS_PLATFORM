# DATA_RELY_ANALYSIS_SYS 项目记忆（精简版）

## 项目概述
Oracle 数据库血缘分析系统，解析 .tab/.prc 文件，生成表级/字段级血缘关系。

## 关键文件
- `core/layer_detector.py` — 层级检测权威模块
- `core/table_parser.py` — OracleTableParser 表结构解析器
- `core/procedure_parser.py` — EnhancedProcedureParser 存储过程解析器
- `core/lineage_tracer.py` — LineageTracer 字段级血缘追踪（BFS）
- `core/caliber_extractor.py` — 口径提取器
- `core/caliber_exporter.py` — 口径文档导出引擎（Markdown/HTML）
- `core/sql_boundary_detector.py` — SQL边界检测器
- `core/table_name_resolver.py` — 表名解析器（含统一 bare_table() 方法）
- `app/main.py` — FastAPI 应用入口
- `app/services/caliber_service.py` — 口径查询服务（含 Summary Card/Pipeline/Step Detail）
- `app/api/caliber.py` — 口径 API 路由（含 4 个新端点）
- `deprecated/api_server.py` — 旧版单体 HTTP API（已废弃，移入 deprecated/）
- `deprecated/static_app.js` — 旧版单体前端（34KB，已废弃）
- `static/js/caliber-tab.js` — 口径Tab前端（Pipeline可视化v3.0）
- `static/css/style.css` — 全局样式（含Pipeline专用样式）

## Schema 变体合并规则（`_bare()` 函数）
- `RRP_MDL.O_ICL_*` → `ICL_*`（去掉O_前缀）
- `ICL.V_*` → `ICL_*`（去掉V_前缀，加ICL_前缀）
- `ICL.XXX` → `ICL_XXX`（加ICL_前缀）

统一实现位置：`core/table_name_resolver.py` → `TableNameResolver.bare_table()`
`core/lineage_tracer.py` 委托调用此统一实现

## 数据规模
3041 张表，1754 个存储过程，缓存启动约 10 秒（pickle），全量解析约 6-10 分钟。

## 缓存策略（2026-05-19 优化）
- 启动优先级：pickle (~8s) → JSON (~117s) → 全量解析 (~6-10min)
- 缓存文件：`output/lineage_data.pkl`（快速）+ `output/lineage_data.json`（人可读备份）
- `DataRepository.load()` 会重复读 JSON，缓存加载时应跳过，直接用 `update()` 传入内存数据
- `get_lineage_tracer()` 支持从缓存 dict 重建 dataclass 对象（策略2），无需重新解析 .prc
- 手动重解析：前端"重新解析"按钮 → `POST /api/system/reparse`

## 关键修复记录

### 2026-05-14：ICL 多余节点 + 字段映射重复
- `_bare()` 增加 ICL.V_* 处理
- 自环边过滤改为精确条件：`src_bare == tgt_bare AND src_table != tgt_table`
- 三元组去重：`(src_bare | tgt_bare.target_field)`

### 2026-05-15：Batch B/C/D 口径提取增强
- 行号定位、SQL边界检测、隔离条件、CTE/函数提取
- `procedure_parser.py` 增加 `_extend_with_cte()` 方法
- `_chains_to_caliber_result` 增强过程查找策略

### 2026-05-15：口径链路重复（BFS去重）
- BFS visited-set 改用 `_bare_table()` 归一化
- 口径链语义去重：`bare_target_table.target_column` 签名

### 2026-05-15：Pipeline 布局修复
- `.caliber-results` 增加 CSS class
- `.pipeline-container` 增加 `min-height: 0`
- `.pipeline-scroll` 改为 `flex-direction: column`

## 已解决问题（2026-05-15）

### 问题1：口径链路重复（公共前缀去重）
- **根因**：口径链去重仅比较单步签名，未比较完整路径签名
- **修复**：改为公共前缀检测，按深度降序排列，优先保留最长链（丢弃前缀子链）
- **代码位置**：`api_server.py` `_chains_to_caliber_result()` 第461-482行

### 问题2：口径详情为空（sql_block提取失败）
- **根因**：`tgt_node.procedure`为空、short-name精确匹配无法处理schema变体、索引key带schema前缀
- **修复**：3策略匹配（精确→bare归一化→INSERT/MERGE兜底）+ 多策略过程查找（tgt_node.procedure→src_node.procedure→_proc_target_idx）
- **验证**：Step 1-4 全部有 op_type=INSERT_VALUES、where>0、sql_len>0 ✅

### 问题3：Pipeline布局展示不完全
- **根因**：`.caliber-results` 缺少 CSS class、`.pipeline-container` 缺少 min-height:0
- **修复**：新增 `.caliber-results` CSS、调整 flex 属性、`.caliber-overview` 增加 flex-shrink:0
- **验证**：浏览器端到端测试通过，4节点全部渲染完整 ✅

## 2026-05-18：设计规范优化迭代

### 新增 4 个 API 端点
- `GET /api/caliber/card-summary` — 指标概览卡（技术口径摘要+统计+质量标记）
- `GET /api/caliber/pipeline` — Pipeline 视图（节点+边+分支 DAG）
- `GET /api/caliber/step-detail` — 单步详情（表达式+隔离条件+CTE+自定义函数+raw_sql）
- `POST /api/caliber/export` — 口径文档导出（Markdown/HTML）

### 新增数据模型
- `CaliberSummaryCard`, `PipelineNode/Edge/Branch/View`, `StepDetail`, `TargetFieldExpression`, `CTEDetail`, `CustomFunctionDetail`

### Gap G4 修复
- `_bare_table()` 统一到 `TableNameResolver.bare_table()`

### 修复：openpyxl 缺失导致项目无法启动
- 安装 openpyxl>=3.1.0，更新 requirements.txt

## 2026-05-18：全项目综合测试

### comprehensive_test.py — 6大功能板块、66项检查点
- 服务初始化（FastAPI lifespan + lru_cache依赖注入）
- Table Parser准确性（递归查找RRP_ORACLE子目录.tab文件）
- bare_table归一化（8个schema变体测试用例）
- LineageService功能（表级/字段级血缘查询、节点/边/映射去重）
- CaliberService核心查询（query_caliber、search_indicators、get_fields_with_caliber）
- Summary Card/Pipeline/Step Detail（构建+验证）
- 口径文档导出（Markdown/HTML）
- API路由注册验证（34个API路由）
- BFS一致性（3次调用结果一致）

### 关键测试陷阱记录
- `export_markdown()` 期望接收 `build_summary_card()` 返回的 summary_card dict，非 `query_caliber()` 的 caliber_result
- Pipeline边的字段名是 `source`/`target`，不是 `source_id`/`target_id`
- BFS口径追溯中多条链路共享公共前缀步骤是正常的DAG特性，不是bug
- `.tab` 文件在 `RRP_ORACLE/rrp_east/` 和 `RRP_ORACLE/rrp_mdl/` 子目录中，需递归查找

## 2026-05-19：血缘三Bug修复（第二轮）

### Bug 1&2 根因：空source_table幽灵链路 + 同表变换未折叠 + ICL.V_*未全局过滤
**修复位置**: `core/lineage_tracer.py`
- Fix A: 跳过空 source_table 的 field_mapping（`_collect_source_from_idx` + `_find_source_fields_in_procedure`）
- Fix B: `_bfs_trace()` 同表字段变换折叠（查找跨表上游+变换注解附加到当前BFS节点）
- Fix C: `_is_layer_compatible()` 全局过滤 ICL.V_* 视图（上游/下游/推断三处修复）

### Bug 3 根因：旧 api_server.py 缺少 /api/indicator/* 路由 + Path类型错误
**修复位置**: `api_server.py`
- 新增 6 个指标路由 + `_init_indicator_service()` 初始化
- 修复 `IndicatorConfigParser(data_path)` 必须传 Path 对象
- 添加弃用通知（推荐 FastAPI: `uvicorn app.main:app`）

### BFS 同表折叠逻辑注意点
- 变换注解必须附加到 **当前BFS节点**（`bfs_tree[current_key]`），而非源节点
- 否则注解会出现在错误的边上（因 `_result_to_graph` 从 tgt_node 读取 transform_logic）

### 服务架构
- 旧版 `api_server.py` 已移入 `deprecated/`，不再维护
- FastAPI `app/main.py` 是唯一入口，功能完整（42个路由）
- 新增 `GET /api/tables/{table}/fields` 端点补齐旧版兼容

### 前端功能验证（2026-05-19）
- **API 批量测试**：20/20 全部通过（健康检查、表搜索、字段列表、过程搜索、字段血缘、口径搜索/字段/追溯/Pipeline、基础指标搜索/详情/血缘/Pipeline、派生指标详情/血缘/Pipeline、指标统计/桥接、系统统计、数据源列表）
- **浏览器测试**：基础指标 FM0100011（DAG 5上游表+1下游，Pipeline 4步）、派生指标 FM0100015（DAG 上游3指标+视图，Pipeline 3步），指标血缘 Tab 搜索/DAG/流水线/详情面板全部正常