/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl d_proj_val_index
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.d_proj_val_index
whenever sqlerror continue none;
drop table ${idl_schema}.d_proj_val_index purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.d_proj_val_index(
    etl_dt date -- 数据日期   
    ,proj_val_id varchar(20) -- 指标表数据ID   
    ,proj_id varchar(100) -- 项目编号   
    ,proj_name varchar(100) -- 项目名称   
    ,proj_online_dt date -- 项目上线日期   
    ,dep_name varchar(100) -- 需求提出部门   
    ,sys_short_name varchar(10) -- 系统简称   
    ,sys_name varchar(100) -- 系统名称   
    ,budg_amt number(18,2) -- 预算金额   
    ,xq_id varchar(20) -- 需求编号   
    ,index_type varchar(100) -- 指标类型   
    ,weht_ratio integer -- 权重比例   
    ,index_name varchar(500) -- 指标名称   
    ,index_unit varchar(20) -- 指标单位   
    ,tgt_val number(5,2) -- 目标值   
    ,index_val number(5,2) -- 指标值   
    ,stati_peri varchar(10) -- 统计周期   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.d_proj_val_index to ${iel_schema};

-- comment
comment on table ${idl_schema}.d_proj_val_index is '项目价值指标表';
comment on column ${idl_schema}.d_proj_val_index.etl_dt is '数据日期';
comment on column ${idl_schema}.d_proj_val_index.proj_val_id is '指标表数据ID';
comment on column ${idl_schema}.d_proj_val_index.proj_id is '项目编号';
comment on column ${idl_schema}.d_proj_val_index.proj_name is '项目名称';
comment on column ${idl_schema}.d_proj_val_index.proj_online_dt is '项目上线日期';
comment on column ${idl_schema}.d_proj_val_index.dep_name is '需求提出部门';
comment on column ${idl_schema}.d_proj_val_index.sys_short_name is '系统简称';
comment on column ${idl_schema}.d_proj_val_index.sys_name is '系统名称';
comment on column ${idl_schema}.d_proj_val_index.budg_amt is '预算金额';
comment on column ${idl_schema}.d_proj_val_index.xq_id is '需求编号';
comment on column ${idl_schema}.d_proj_val_index.index_type is '指标类型';
comment on column ${idl_schema}.d_proj_val_index.weht_ratio is '权重比例';
comment on column ${idl_schema}.d_proj_val_index.index_name is '指标名称';
comment on column ${idl_schema}.d_proj_val_index.index_unit is '指标单位';
comment on column ${idl_schema}.d_proj_val_index.tgt_val is '目标值';
comment on column ${idl_schema}.d_proj_val_index.index_val is '指标值';
comment on column ${idl_schema}.d_proj_val_index.stati_peri is '统计周期';
comment on column ${idl_schema}.d_proj_val_index.etl_timestamp is '数据处理时间';