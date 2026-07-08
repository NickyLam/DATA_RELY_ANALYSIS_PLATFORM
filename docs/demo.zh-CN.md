# 演示：30 秒看懂字段级血缘

语言版本：中文 | [English](demo.md)

这是面向审核人员和新用户的演示入口。无需访问真实企业 SQL，即可理解项目能做什么。

## 它能做什么

系统解析 Oracle 与企业数仓 SQL，构建字段级血缘，并将结果渲染为可交互图谱，用于数据治理、影响分析和审计复核。

![Lineage walkthrough](assets/demo-lineage-flow.gif)

## 核心场景

给定目标字段，例如 `ICL.CUSTOMER_DAILY_SNAPSHOT.CUSTOMER_TIER`，分析器可以追踪字段来源、上游表贡献关系和字段转换表达式。

![Lineage graph](assets/demo-lineage-graph.png)

## 架构概览

![Architecture overview](assets/architecture-overview.png)

处理流程：

1. 从配置的数据源发现 SQL、存储过程、控制文件和表格文件。
2. ParserRegistry 按文件类型路由到对应解析器。
3. 解析结果写入缓存并构建索引。
4. 血缘、口径和指标服务响应 API 查询。
5. 前端使用 D3.js 渲染血缘图谱。

## 本地运行

```bash
python3.11 -m venv .venv
source .venv/bin/activate
python3.11 -m pip install -r requirements.txt
python3.11 run_app.py
```

打开 `http://localhost:8899/static/index.html`。

## 安全公开样例

- SQL：[`examples/oracle_warehouse_lineage.sql`](examples/oracle_warehouse_lineage.sql)
- 输出：[`examples/lineage_query_output.json`](examples/lineage_query_output.json)
