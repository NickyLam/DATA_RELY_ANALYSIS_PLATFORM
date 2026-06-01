/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl MC_INDEX_DEFINE
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.MC_INDEX_DEFINE
whenever sqlerror continue none;
drop table ${idl_schema}.MC_INDEX_DEFINE purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.MC_INDEX_DEFINE(
  index_no          VARCHAR2(150),
  index_clsaa_f     VARCHAR2(500),
  index_clsaa_s     VARCHAR2(500),
  index_no_mcs      VARCHAR2(150),
  index_clsaa_f_mcs VARCHAR2(500),
  index_clsaa_s_mcs VARCHAR2(500),
  index_clsaa_t_mcs VARCHAR2(500),
  index_name_mcs    VARCHAR2(500),
  index_name        VARCHAR2(500),
  source_system     VARCHAR2(500),
  dept_mg           VARCHAR2(500),
  dept_use          VARCHAR2(500),
  regulatory_flag   VARCHAR2(25),
  index_type        VARCHAR2(150),
  frequency         VARCHAR2(25),
  dimension         VARCHAR2(500),
  unit              VARCHAR2(150),
  manual_adj_flag   VARCHAR2(25),
  index_state       VARCHAR2(25),
  etl_dt            DATE,
  etl_timestamp     TIMESTAMP(6),
  manual_adj_source_system        VARCHAR2(60),
  manual_adj_index_no VARCHAR2(60)
  
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.MC_INDEX_DEFINE to ${idl_schema};

-- comment
comment on table MC_INDEX_DEFINE
  is '指标映射表';
-- Add comments to the columns 
comment on column MC_INDEX_DEFINE.index_no
  is '标准指标编号';
comment on column MC_INDEX_DEFINE.index_clsaa_f
  is '标准指标一级分类';
comment on column MC_INDEX_DEFINE.index_clsaa_s
  is '标准指标二级分类';
comment on column MC_INDEX_DEFINE.index_no_mcs
  is '管驾指标编号';
comment on column MC_INDEX_DEFINE.index_clsaa_f_mcs
  is '管驾一级分类';
comment on column MC_INDEX_DEFINE.index_clsaa_s_mcs
  is '管驾二级分类';
comment on column MC_INDEX_DEFINE.index_clsaa_t_mcs
  is '管驾三级分类';
comment on column MC_INDEX_DEFINE.index_name_mcs
  is '指标名称';
comment on column MC_INDEX_DEFINE.index_name
  is '指标常用名';
comment on column MC_INDEX_DEFINE.source_system
  is '来源系统';
comment on column MC_INDEX_DEFINE.dept_mg
  is '管理部门';
comment on column MC_INDEX_DEFINE.dept_use
  is '使用部门';
comment on column MC_INDEX_DEFINE.regulatory_flag
  is '监管报送标志';
comment on column MC_INDEX_DEFINE.index_type
  is '指标类型';
comment on column MC_INDEX_DEFINE.frequency
  is '频度';
comment on column MC_INDEX_DEFINE.dimension
  is '维度';
comment on column MC_INDEX_DEFINE.unit
  is '计量单位';
comment on column MC_INDEX_DEFINE.manual_adj_flag
  is '是否涉及手工调整';
comment on column MC_INDEX_DEFINE.index_state
  is '指标状态';
comment on column MC_INDEX_DEFINE.etl_dt
  is 'ETL处理日期';
comment on column MC_INDEX_DEFINE.etl_timestamp
  is 'ETL处理时间戳';
comment on column MC_INDEX_DEFINE.manual_adj_source_system
  is '手工调整来源系统';
comment on column MC_INDEX_DEFINE.manual_adj_index_no
  is '手工调整指标编号';