# 阶段 2: 采集适配器开发 - 执行计划

## 计划概览

**阶段**：Phase 2 - 采集适配器开发  
**预计工时**：9 人周  
**执行方式**：自主执行  
**开始日期**：2026-04-19

---

## 执行顺序

基于依赖关系，执行顺序如下：

```
WBS-2.1 (Oracle 采集器) → WBS-2.2 (SQL 解析引擎) → WBS-2.3 (运行时采集)
```

---

## Wave 1: Oracle 19c 采集适配器 (WBS-2.1)

### Task 2.1.1: JDBC 元数据采集器增强

**目标**：增强 JDBC 连接和批量采集能力

**执行步骤**：
1. 创建 `backend/app/collectors/jdbc_collector.py`
2. 实现连接池管理
3. 实现批量查询优化
4. 实现错误处理和重试机制

**文件清单**：
- `backend/app/collectors/__init__.py`
- `backend/app/collectors/jdbc_collector.py`
- `backend/app/collectors/base_collector.py`

### Task 2.1.2: 系统视图采集器优化

**目标**：优化 Oracle 系统视图采集

**执行步骤**：
1. 创建 `backend/app/collectors/oracle_views_collector.py`
2. 实现 ALL_TABLES, ALL_TAB_COLUMNS 采集
3. 实现 ALL_CONSTRAINTS, ALL_INDEXES 采集
4. 实现 ALL_DEPENDENCIES 采集

**文件清单**：
- `backend/app/collectors/oracle_views_collector.py`
- `backend/app/schemas/oracle_metadata.py`

### Task 2.1.3: 存储过程源码采集

**目标**：采集存储过程、函数、包体源码

**执行步骤**：
1. 创建 `backend/app/collectors/plsql_collector.py`
2. 实现 ALL_SOURCE 视图采集
3. 实现源码分类存储
4. 实现源码解析预处理

**文件清单**：
- `backend/app/collectors/plsql_collector.py`
- `backend/app/models/plsql_source.py`

### Task 2.1.4: PL/SQL 深度解析

**目标**：解析 PL/SQL 提取血缘关系

**执行步骤**：
1. 创建 `backend/app/parsers/plsql_parser.py`
2. 实现常见场景解析规则
3. 实现动态 SQL 检测
4. 实现血缘提取逻辑

**文件清单**：
- `backend/app/parsers/__init__.py`
- `backend/app/parsers/plsql_parser.py`
- `backend/app/parsers/lineage_extractor.py`

---

## Wave 2: SQL 解析引擎集成 (WBS-2.2)

### Task 2.2.1: JSqlParser 集成

**目标**：通过 JPype 集成 JSqlParser

**执行步骤**：
1. 创建 Java 依赖配置
2. 实现 JPype 桥接服务
3. 实现 SQL 解析接口
4. 实现解析结果转换

**文件清单**：
- `backend/lib/jsqlparser-4.6.jar`
- `backend/app/parsers/jsqlparser_bridge.py`
- `backend/app/parsers/sql_parser.py`

### Task 2.2.2: Oracle 方言适配

**目标**：支持 Oracle 特有语法

**执行步骤**：
1. 创建 Oracle 方言规则
2. 实现 MERGE 语句解析
3. 实现 WITH 子句解析
4. 实现自定义函数识别

**文件清单**：
- `backend/app/parsers/oracle_dialect.py`
- `backend/app/parsers/dialect_rules.py`

### Task 2.2.3: 血缘提取规则

**目标**：从 SQL 提取血缘关系

**执行步骤**：
1. 创建血缘提取规则引擎
2. 实现 INSERT/UPDATE 解析
3. 实现 SELECT 子查询解析
4. 实现 JOIN 关系提取

**文件清单**：
- `backend/app/parsers/lineage_rules.py`
- `backend/app/services/lineage_builder.py`

---

## Wave 3: 运行时血缘采集 (WBS-2.3)

### Task 2.3.1: Oracle 审计日志采集

**目标**：采集 Oracle 审计日志

**执行步骤**：
1. 创建审计日志采集器
2. 实现 DBA_AUDIT_TRAIL 解析
3. 实现执行语句提取
4. 实现日志存储

**文件清单**：
- `backend/app/collectors/audit_collector.py`
- `backend/app/schemas/audit_log.py`

### Task 2.3.2: V$SQL 视图采集

**目标**：采集实时 SQL 执行信息

**执行步骤**：
1. 创建 V$SQL 采集器
2. 实现执行计划提取
3. 实现绑定变量解析
4. 实现高频 SQL 识别

**文件清单**：
- `backend/app/collectors/vsql_collector.py`
- `backend/app/schemas/vsql_record.py`

### Task 2.3.3: 血缘融合服务

**目标**：融合静态和运行态血缘

**执行步骤**：
1. 创建血缘融合服务
2. 实现可信度评分算法
3. 实现冲突检测和处理
4. 实现融合结果存储

**文件清单**：
- `backend/app/services/lineage_fusion.py`
- `backend/app/models/fused_lineage.py`

---

## API 端点设计

### 采集任务管理 API

```
POST   /api/v1/collect/tasks          - 创建采集任务
GET    /api/v1/collect/tasks          - 获取采集任务列表
GET    /api/v1/collect/tasks/{id}     - 获取采集任务详情
POST   /api/v1/collect/tasks/{id}/run - 执行采集任务
GET    /api/v1/collect/tasks/{id}/log - 获取采集日志
```

### SQL 解析 API

```
POST   /api/v1/parse/sql              - 解析 SQL 语句
POST   /api/v1/parse/batch            - 批量解析 SQL
GET    /api/v1/parse/result/{id}      - 获取解析结果
```

---

## 验证清单

### Wave 1 验证
- [ ] JDBC 连接池正常工作
- [ ] 系统视图采集返回数据
- [ ] 存储过程源码正确存储
- [ ] PL/SQL 解析提取血缘

### Wave 2 验证
- [ ] JSqlParser 正常解析 SQL
- [ ] Oracle 方言正确处理
- [ ] 血缘提取规则生效

### Wave 3 验证
- [ ] 审计日志采集正常
- [ ] V$SQL 采集返回数据
- [ ] 血缘融合结果正确

---

## 风险缓解

| 风险 | 缓解措施 | 执行时机 |
|------|---------|---------|
| JPype 安装失败 | 提供 Docker 环境替代 | Wave 2 开始前 |
| Oracle 连接问题 | 提供模拟数据测试 | Wave 1 开始前 |
| 解析准确率不足 | 建立人工补录机制 | Wave 2 结束后 |

---

**创建日期**：2026-04-19  
**执行状态**：待开始