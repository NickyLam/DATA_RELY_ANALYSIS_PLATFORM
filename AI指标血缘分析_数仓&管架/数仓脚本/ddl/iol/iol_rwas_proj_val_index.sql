/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_proj_val_index
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_proj_val_index
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_proj_val_index purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_proj_val_index(
    etl_dt_ora date -- 数据日期yyyyMMdd
    ,proj_val_id varchar2(20) -- 指标表数据ID,系统简称+序列号
    ,proj_id varchar2(100) -- 项目编号
    ,proj_name varchar2(100) -- 项目名称
    ,proj_online_dt date -- 
    ,dep_name varchar2(100) -- 需求提出部门
    ,sys_short_name varchar2(10) -- 系统简称
    ,sys_name varchar2(100) -- 系统名称
    ,budg_amt number(18,2) -- 预算金额
    ,xq_id varchar2(20) -- 需求编号
    ,index_type varchar2(100) -- 指标类型
    ,weht_ratio number(22) -- 权重比例
    ,index_name varchar2(500) -- 指标名称
    ,index_unit varchar2(20) -- 指标单位,中文，如:亿元、万元、元、人、万人等
    ,tgt_val number(5,2) -- 目标值,[0,999.99]
    ,index_val number(5,2) -- 指标值,[0,999.99]
    ,stati_peri varchar2(10) -- 统计周期,日，或者周
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rwas_proj_val_index to ${iml_schema};
grant select on ${iol_schema}.rwas_proj_val_index to ${icl_schema};
grant select on ${iol_schema}.rwas_proj_val_index to ${idl_schema};
grant select on ${iol_schema}.rwas_proj_val_index to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_proj_val_index is '项目价值指标表';
comment on column ${iol_schema}.rwas_proj_val_index.etl_dt_ora is '数据日期yyyyMMdd';
comment on column ${iol_schema}.rwas_proj_val_index.proj_val_id is '指标表数据ID,系统简称+序列号';
comment on column ${iol_schema}.rwas_proj_val_index.proj_id is '项目编号';
comment on column ${iol_schema}.rwas_proj_val_index.proj_name is '项目名称';
comment on column ${iol_schema}.rwas_proj_val_index.proj_online_dt is '';
comment on column ${iol_schema}.rwas_proj_val_index.dep_name is '需求提出部门';
comment on column ${iol_schema}.rwas_proj_val_index.sys_short_name is '系统简称';
comment on column ${iol_schema}.rwas_proj_val_index.sys_name is '系统名称';
comment on column ${iol_schema}.rwas_proj_val_index.budg_amt is '预算金额';
comment on column ${iol_schema}.rwas_proj_val_index.xq_id is '需求编号';
comment on column ${iol_schema}.rwas_proj_val_index.index_type is '指标类型';
comment on column ${iol_schema}.rwas_proj_val_index.weht_ratio is '权重比例';
comment on column ${iol_schema}.rwas_proj_val_index.index_name is '指标名称';
comment on column ${iol_schema}.rwas_proj_val_index.index_unit is '指标单位,中文，如:亿元、万元、元、人、万人等';
comment on column ${iol_schema}.rwas_proj_val_index.tgt_val is '目标值,[0,999.99]';
comment on column ${iol_schema}.rwas_proj_val_index.index_val is '指标值,[0,999.99]';
comment on column ${iol_schema}.rwas_proj_val_index.stati_peri is '统计周期,日，或者周';
comment on column ${iol_schema}.rwas_proj_val_index.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rwas_proj_val_index.etl_timestamp is 'ETL处理时间戳';
