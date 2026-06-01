/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_fdl_idx_index_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_fdl_idx_index_data
whenever sqlerror continue none;
drop table ${msl_schema}.msl_fdl_idx_index_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_fdl_idx_index_data(
    index_no VARCHAR2(60)
    ,org_no VARCHAR2(60)
    ,biz_strip_line_cd VARCHAR2(30)
    ,dim_cd1 VARCHAR2(30)
    ,dim_cd2 VARCHAR2(30)
    ,dim_cd3 VARCHAR2(30)
    ,batch_freq VARCHAR2(30)
    ,index_measure VARCHAR2(30)
    ,curr_cd VARCHAR2(30)
    ,index_val NUMBER(30,8)
    ,etl_dt DATE
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
-- grant select on ${msl_schema}.msl_fdl_idx_index_data to itl;

-- comment
comment on table ${msl_schema}.msl_fdl_idx_index_data is 'FDL_指标_指标数据';
comment on column ${msl_schema}.msl_fdl_idx_index_data.index_no is '指标编号';
comment on column ${msl_schema}.msl_fdl_idx_index_data.org_no is '机构编号';
comment on column ${msl_schema}.msl_fdl_idx_index_data.biz_strip_line_cd is '业务条线代码';
comment on column ${msl_schema}.msl_fdl_idx_index_data.dim_cd1 is '维度代码1';
comment on column ${msl_schema}.msl_fdl_idx_index_data.dim_cd2 is '维度代码2';
comment on column ${msl_schema}.msl_fdl_idx_index_data.dim_cd3 is '维度代码3';
comment on column ${msl_schema}.msl_fdl_idx_index_data.batch_freq is '批次频度';
comment on column ${msl_schema}.msl_fdl_idx_index_data.index_measure is '指标度量';
comment on column ${msl_schema}.msl_fdl_idx_index_data.curr_cd is '币种代码';
comment on column ${msl_schema}.msl_fdl_idx_index_data.index_val is '指标值';
comment on column ${msl_schema}.msl_fdl_idx_index_data.etl_dt is '数据日期';
