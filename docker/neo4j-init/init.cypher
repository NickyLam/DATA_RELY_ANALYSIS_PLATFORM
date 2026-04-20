// Neo4j 血缘图谱模型初始化脚本
// 数据血缘分析平台 - 血缘图谱模型

// ============================================
// 1. 创建节点唯一性约束
// ============================================

// 数据源节点约束
CREATE CONSTRAINT data_source_unique IF NOT EXISTS
FOR (ds:DataSource) REQUIRE ds.id IS UNIQUE;

// 数据库节点约束
CREATE CONSTRAINT database_unique IF NOT EXISTS
FOR (db:Database) REQUIRE db.id IS UNIQUE;

// 表节点约束
CREATE CONSTRAINT table_unique IF NOT EXISTS
FOR (t:Table) REQUIRE t.id IS UNIQUE;

// 字段节点约束
CREATE CONSTRAINT field_unique IF NOT EXISTS
FOR (f:Field) REQUIRE f.id IS UNIQUE;

// 作业节点约束
CREATE CONSTRAINT job_unique IF NOT EXISTS
FOR (j:Job) REQUIRE j.id IS UNIQUE;

// SQL语句节点约束
CREATE CONSTRAINT sql_statement_unique IF NOT EXISTS
FOR (s:SQLStatement) REQUIRE s.id IS UNIQUE;

// 批次运行节点约束
CREATE CONSTRAINT batch_run_unique IF NOT EXISTS
FOR (b:BatchRun) REQUIRE b.id IS UNIQUE;

// ============================================
// 2. 创建节点属性索引
// ============================================

// 数据源名称索引
CREATE INDEX data_source_name_idx IF NOT EXISTS
FOR (ds:DataSource) ON (ds.name);

// 数据源类型索引
CREATE INDEX data_source_type_idx IF NOT EXISTS
FOR (ds:DataSource) ON (ds.type);

// 表名称索引
CREATE INDEX table_name_idx IF NOT EXISTS
FOR (t:Table) ON (t.name);

// 表类型索引
CREATE INDEX table_type_idx IF NOT EXISTS
FOR (t:Table) ON (t.type);

// 字段名称索引
CREATE INDEX field_name_idx IF NOT EXISTS
FOR (f:Field) ON (f.name);

// 字段数据类型索引
CREATE INDEX field_data_type_idx IF NOT EXISTS
FOR (f:Field) ON (f.data_type);

// 作业名称索引
CREATE INDEX job_name_idx IF NOT EXISTS
FOR (j:Job) ON (j.name);

// 作业类型索引
CREATE INDEX job_type_idx IF NOT EXISTS
FOR (j:Job) ON (j.type);

// 批次运行状态索引
CREATE INDEX batch_run_status_idx IF NOT EXISTS
FOR (b:BatchRun) ON (b.status);

// ============================================
// 3. 创建关系属性索引
// ============================================

// 血缘关系类型索引
CREATE INDEX lineage_type_idx IF NOT EXISTS
FOR ()-[r:LINEAGE_TO]-() ON (r.transformation_type);

// 血缘关系可信度索引
CREATE INDEX lineage_confidence_idx IF NOT EXISTS
FOR ()-[r:LINEAGE_TO]-() ON (r.confidence_score);

// 血缘关系来源方法索引
CREATE INDEX lineage_method_idx IF NOT EXISTS
FOR ()-[r:LINEAGE_TO]-() ON (r.derivation_method);

// ============================================
// 4. 创建示例节点（用于测试）
// ============================================

// 创建示例数据源
CREATE (ds_oracle:DataSource {
    id: 'ds-oracle-001',
    name: 'Oracle 19c - 生产环境',
    type: 'oracle',
    host: 'oracle-prod.example.com',
    port: 1521,
    database: 'ORCL',
    status: 'active',
    createdAt: datetime(),
    createdBy: 'system'
});

// 创建示例数据库
CREATE (db_dw:Database {
    id: 'db-dw-001',
    name: 'DW',
    schema: 'DATAWAREHOUSE',
    type: 'schema',
    description: '数据仓库核心库',
    createdAt: datetime()
});

// 创建示例表
CREATE (t_source:Table {
    id: 't-source-001',
    name: 'T_SOURCE_TABLE',
    type: 'table',
    description: '贴源层原始数据表',
    rowCount: 1000000,
    columnCount: 50,
    createdAt: datetime(),
    owner: 'ETL_TEAM'
});

CREATE (t_target:Table {
    id: 't-target-001',
    name: 'T_TARGET_TABLE',
    type: 'table',
    description: '目标层汇总表',
    rowCount: 500000,
    columnCount: 20,
    createdAt: datetime(),
    owner: 'REPORT_TEAM'
});

// 创建示例字段
CREATE (f_source_id:Field {
    id: 'f-source-id-001',
    name: 'CUSTOMER_ID',
    dataType: 'NUMBER(20)',
    isPrimaryKey: true,
    isNullable: false,
    description: '客户唯一标识',
    position: 1,
    createdAt: datetime()
});

CREATE (f_source_name:Field {
    id: 'f-source-name-001',
    name: 'CUSTOMER_NAME',
    dataType: 'VARCHAR2(100)',
    isPrimaryKey: false,
    isNullable: true,
    description: '客户姓名',
    position: 2,
    createdAt: datetime()
});

CREATE (f_target_id:Field {
    id: 'f-target-id-001',
    name: 'CUST_ID',
    dataType: 'NUMBER(20)',
    isPrimaryKey: true,
    isNullable: false,
    description: '客户ID',
    position: 1,
    createdAt: datetime()
});

CREATE (f_target_name:Field {
    id: 'f-target-name-001',
    name: 'CUST_NAME',
    dataType: 'VARCHAR2(100)',
    isPrimaryKey: false,
    isNullable: true,
    description: '客户名称',
    position: 2,
    createdAt: datetime()
});

// 创建示例作业
CREATE (job_etl:Job {
    id: 'job-etl-001',
    name: 'ETL_CUSTOMER_DATA',
    type: 'sql',
    scriptContent: 'INSERT INTO T_TARGET_TABLE SELECT CUSTOMER_ID AS CUST_ID, CUSTOMER_NAME AS CUST_NAME FROM T_SOURCE_TABLE',
    schedule: '0 2 * * *',
    status: 'active',
    createdAt: datetime(),
    owner: 'ETL_TEAM'
});

// ============================================
// 5. 创建示例关系
// ============================================

// 数据源包含数据库
CREATE (ds_oracle)-[:CONTAINS]->(db_dw);

// 数据库包含表
CREATE (db_dw)-[:CONTAINS]->(t_source);
CREATE (db_dw)-[:CONTAINS]->(t_target);

// 表包含字段
CREATE (t_source)-[:CONTAINS]->(f_source_id);
CREATE (t_source)-[:CONTAINS]->(f_source_name);
CREATE (t_target)-[:CONTAINS]->(f_target_id);
CREATE (t_target)-[:CONTAINS]->(f_target_name);

// 作业读取表
CREATE (job_etl)-[:READS]->(t_source);

// 作业写入表
CREATE (job_etl)-[:WRITES]->(t_target);

// 表级血缘关系
CREATE (t_source)-[:LINEAGE_TO {
    edgeType: 'table_lineage',
    derivationMethod: 'static_parse',
    parseEngine: 'JSqlParser',
    confidenceScore: 0.98,
    transformationType: 'direct_map',
    createdAt: datetime(),
    createdBy: 'system'
}]->(t_target);

// 字段级血缘关系
CREATE (f_source_id)-[:LINEAGE_TO {
    edgeType: 'field_lineage',
    derivationMethod: 'static_parse',
    parseEngine: 'JSqlParser',
    confidenceScore: 0.98,
    transformationType: 'direct_map',
    expression: 'CUSTOMER_ID AS CUST_ID',
    createdAt: datetime(),
    createdBy: 'system'
}]->(f_target_id);

CREATE (f_source_name)-[:LINEAGE_TO {
    edgeType: 'field_lineage',
    derivationMethod: 'static_parse',
    parseEngine: 'JSqlParser',
    confidenceScore: 0.98,
    transformationType: 'direct_map',
    expression: 'CUSTOMER_NAME AS CUST_NAME',
    createdAt: datetime(),
    createdBy: 'system'
}]->(f_target_name);

// ============================================
// 6. 创建血缘查询示例
// ============================================

// 查询表级完整血缘
// MATCH path = (t:Table {name: 'T_TARGET_TABLE'})-[:LINEAGE_TO*]->(source:Table)
// RETURN path;

// 查询字段级最小链路
// MATCH path = shortestPath(
//     (f:Field {name: 'CUST_ID'})-[:LINEAGE_TO*]->(source:Field)
// )
// RETURN path;

// 查询影响分析
// MATCH (t:Table {name: 'T_SOURCE_TABLE'})-[:LINEAGE_TO*]->(target:Table)
// RETURN target.name AS affectedTable, target.owner AS owner;

// ============================================
// 7. 完成初始化
// ============================================

RETURN 'Neo4j 血缘图谱模型初始化完成' AS message;