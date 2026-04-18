-- PostgreSQL 初始化脚本
-- 数据血缘分析平台数据库初始化

-- 创建扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 创建数据源表
CREATE TABLE IF NOT EXISTS data_sources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL UNIQUE,
    type VARCHAR(50) NOT NULL,  -- oracle, tdh, oceanbase, gbase, yashan
    host VARCHAR(255) NOT NULL,
    port INTEGER NOT NULL,
    database_name VARCHAR(255),
    username VARCHAR(255),
    password_encrypted TEXT,
    connection_params JSONB,
    status VARCHAR(20) DEFAULT 'active',  -- active, inactive, error
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_collected_at TIMESTAMP,
    created_by VARCHAR(255),
    updated_by VARCHAR(255)
);

-- 创建数据库/模式表
CREATE TABLE IF NOT EXISTS databases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    data_source_id UUID NOT NULL REFERENCES data_sources(id),
    name VARCHAR(255) NOT NULL,
    schema_name VARCHAR(255),
    type VARCHAR(50),  -- database, schema
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建表元数据表
CREATE TABLE IF NOT EXISTS tables (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    database_id UUID NOT NULL REFERENCES databases(id),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) DEFAULT 'table',  -- table, view, materialized_view
    description TEXT,
    row_count BIGINT,
    column_count INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified_at TIMESTAMP,
    owner VARCHAR(255),
    is_active BOOLEAN DEFAULT true
);

-- 创建字段元数据表
CREATE TABLE IF NOT EXISTS fields (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    table_id UUID NOT NULL REFERENCES tables(id),
    name VARCHAR(255) NOT NULL,
    data_type VARCHAR(100),
    is_primary_key BOOLEAN DEFAULT false,
    is_foreign_key BOOLEAN DEFAULT false,
    is_nullable BOOLEAN DEFAULT true,
    default_value TEXT,
    description TEXT,
    position INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建作业元数据表
CREATE TABLE IF NOT EXISTS jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    data_source_id UUID NOT NULL REFERENCES data_sources(id),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50),  -- sql, stored_procedure, etl, spark_job
    script_content TEXT,
    schedule VARCHAR(255),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_run_at TIMESTAMP,
    owner VARCHAR(255)
);

-- 创建批次运行记录表
CREATE TABLE IF NOT EXISTS batch_runs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    job_id UUID NOT NULL REFERENCES jobs(id),
    run_id VARCHAR(255) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    status VARCHAR(20),  -- running, success, failed, cancelled
    error_message TEXT,
    records_processed BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建血缘关系表（用于备份和审计）
CREATE TABLE IF NOT EXISTS lineage_edges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    edge_type VARCHAR(50) NOT NULL,  -- table_lineage, field_lineage, job_dependency
    source_node_id UUID NOT NULL,
    source_node_type VARCHAR(50) NOT NULL,  -- table, field, job
    target_node_id UUID NOT NULL,
    target_node_type VARCHAR(50) NOT NULL,
    derivation_method VARCHAR(50),  -- static_parse, runtime_capture, manual_entry
    parse_engine VARCHAR(50),
    confidence_score DECIMAL(3,2),  -- 0.00 to 1.00
    evidence TEXT,  -- SQL片段或日志片段
    transformation_type VARCHAR(50),  -- direct_map, calculation, aggregation, filter, join
    expression TEXT,
    business_term VARCHAR(255),
    regulatory_tag VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_from TIMESTAMP,
    valid_to TIMESTAMP,
    created_by VARCHAR(255),
    reviewed_by VARCHAR(255),
    review_comment TEXT,
    version INTEGER DEFAULT 1
);

-- 创建人工修正记录表
CREATE TABLE IF NOT EXISTS manual_corrections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lineage_edge_id UUID REFERENCES lineage_edges(id),
    correction_type VARCHAR(50),  -- add, modify, delete
    old_value JSONB,
    new_value JSONB,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'pending',  -- pending, approved, rejected
    submitted_by VARCHAR(255) NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_by VARCHAR(255),
    reviewed_at TIMESTAMP,
    review_comment TEXT
);

-- 创建采集任务表
CREATE TABLE IF NOT EXISTS collection_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    data_source_id UUID NOT NULL REFERENCES data_sources(id),
    task_name VARCHAR(255) NOT NULL,
    task_type VARCHAR(50),  -- metadata, sql_parse, runtime_capture
    schedule VARCHAR(255),  -- cron表达式
    status VARCHAR(20) DEFAULT 'active',
    last_run_at TIMESTAMP,
    next_run_at TIMESTAMP,
    config JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建采集日志表
CREATE TABLE IF NOT EXISTS collection_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID NOT NULL REFERENCES collection_tasks(id),
    run_id VARCHAR(255) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    status VARCHAR(20),  -- running, success, failed
    error_message TEXT,
    objects_collected INTEGER,
    objects_failed INTEGER,
    details JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建索引
CREATE INDEX idx_data_sources_type ON data_sources(type);
CREATE INDEX idx_data_sources_status ON data_sources(status);
CREATE INDEX idx_databases_data_source ON databases(data_source_id);
CREATE INDEX idx_tables_database ON tables(database_id);
CREATE INDEX idx_tables_name ON tables(name);
CREATE INDEX idx_fields_table ON fields(table_id);
CREATE INDEX idx_fields_name ON fields(name);
CREATE INDEX idx_jobs_data_source ON jobs(data_source_id);
CREATE INDEX idx_batch_runs_job ON batch_runs(job_id);
CREATE INDEX idx_batch_runs_status ON batch_runs(status);
CREATE INDEX idx_lineage_edges_source ON lineage_edges(source_node_id, source_node_type);
CREATE INDEX idx_lineage_edges_target ON lineage_edges(target_node_id, target_node_type);
CREATE INDEX idx_lineage_edges_type ON lineage_edges(edge_type);
CREATE INDEX idx_manual_corrections_status ON manual_corrections(status);
CREATE INDEX idx_collection_tasks_data_source ON collection_tasks(data_source_id);
CREATE INDEX idx_collection_logs_task ON collection_logs(task_id);

-- 创建更新时间触发器
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为所有表添加更新时间触发器
CREATE TRIGGER update_data_sources_updated_at BEFORE UPDATE ON data_sources
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_databases_updated_at BEFORE UPDATE ON databases
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tables_updated_at BEFORE UPDATE ON tables
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_fields_updated_at BEFORE UPDATE ON fields
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_jobs_updated_at BEFORE UPDATE ON jobs
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_lineage_edges_updated_at BEFORE UPDATE ON lineage_edges
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_collection_tasks_updated_at BEFORE UPDATE ON collection_tasks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 插入默认数据源（Oracle 19c）
INSERT INTO data_sources (name, type, host, port, database_name, status, created_by)
VALUES ('Oracle 19c - 生产环境', 'oracle', 'oracle-prod.example.com', 1521, 'ORCL', 'active', 'system');

-- 插入默认采集任务
INSERT INTO collection_tasks (data_source_id, task_name, task_type, schedule, status, created_by)
SELECT id, 'Oracle 元数据采集', 'metadata', '0 2 * * *', 'active', 'system'
FROM data_sources WHERE name = 'Oracle 19c - 生产环境';

-- 完成初始化
INSERT INTO collection_logs (task_id, run_id, start_time, end_time, status, objects_collected, details)
SELECT id, 'init-001', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'success', 0, '{"message": "Database initialized"}'::jsonb
FROM collection_tasks WHERE task_name = 'Oracle 元数据采集';