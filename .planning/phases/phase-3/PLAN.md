# 阶段 3: 核心功能开发 - 执行计划

## 计划概览

**阶段**：Phase 3 - 核心功能开发  
**预计工时**：11 人周  
**执行方式**：自主执行  
**开始日期**：2026-04-19

---

## Wave 1: 资产搜索模块 (WBS-3.1)

### Task 3.1.1: 搜索服务实现

**目标**：实现资产搜索后端服务

**执行步骤**：
1. 创建 `backend/app/services/search_service.py`
2. 实现模糊查询和精确查询
3. 实现高级筛选逻辑
4. 实现搜索结果排序

### Task 3.1.2: 搜索页面增强

**目标**：增强前端搜索页面

**执行步骤**：
1. 更新 `frontend/src/pages/SearchPage.tsx`
2. 实现搜索表单和筛选器
3. 实现搜索结果列表
4. 实现分页和排序

---

## Wave 2: 表级血缘查询模块 (WBS-3.2)

### Task 3.2.1: 血缘查询服务增强

**目标**：增强血缘查询服务

**执行步骤**：
1. 更新 `backend/app/services/neo4j_lineage_service.py`
2. 实现完整血缘图查询
3. 实现层级展开逻辑
4. 实现血缘图导出

### Task 3.2.2: 血缘图谱可视化

**目标**：实现血缘图谱前端可视化

**执行步骤**：
1. 更新 `frontend/src/pages/LineagePage.tsx`
2. 使用 React Flow 实现图谱
3. 实现节点拖拽和缩放
4. 实现层级展开收缩

---

## Wave 3: 字段级最小链路模块 (WBS-3.3)

### Task 3.3.1: 最短路径算法

**目标**：实现字段级最小链路算法

**执行步骤**：
1. 创建 `backend/app/services/shortest_path_service.py`
2. 实现 Dijkstra 算法
3. 实现字段血缘提取
4. 实现表达式解析

### Task 3.3.2: 字段链路可视化

**目标**：实现字段链路前端可视化

**执行步骤**：
1. 更新 `frontend/src/pages/FieldLineagePage.tsx`
2. 实现字段链路图
3. 实现表达式展示
4. 实现多源汇聚展示

---

## Wave 4: 问题排查页 (WBS-3.4)

### Task 3.4.1: 问题排查服务

**目标**：实现问题排查后端服务

**执行步骤**：
1. 创建 `backend/app/services/troubleshoot_service.py`
2. 实现血缘与运行态关联
3. 实现最近批次查询
4. 实现变更信息查询

### Task 3.4.2: 问题排查页面

**目标**：实现问题排查前端页面

**执行步骤**：
1. 创建 `frontend/src/pages/TroubleshootPage.tsx`
2. 实现血缘展示
3. 实现批次信息展示
4. 实现快速跳转功能

---

**创建日期**：2026-04-19