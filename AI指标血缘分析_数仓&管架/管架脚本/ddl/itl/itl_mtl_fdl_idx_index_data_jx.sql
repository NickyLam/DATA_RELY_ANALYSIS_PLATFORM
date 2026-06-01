/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl mtl_fdl_idx_index_data_jx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.mtl_fdl_idx_index_data_jx
whenever sqlerror continue none;
drop table ${itl_schema}.mtl_fdl_idx_index_data_jx purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.mtl_fdl_idx_index_data_jx(
    index_no varchar2(60) -- 指标编号
    ,org_no varchar2(60) -- 机构编号
    ,biz_strip_line_cd varchar2(30) -- 业务条线代码
    ,dim_cd1 varchar2(30) -- 维度代码1
    ,dim_cd2 varchar2(30) -- 维度代码2
    ,dim_cd3 varchar2(30) -- 维度代码3
    ,batch_freq varchar2(30) -- 批次频度
    ,index_measure varchar2(30) -- 指标度量
    ,curr_cd varchar2(30) -- 币种代码
    ,index_val number(30,8) -- 指标值
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.mtl_fdl_idx_index_data_jx to ${iol_schema};

-- comment
comment on table ${itl_schema}.mtl_fdl_idx_index_data_jx is 'FDL_指标_指标数据';
comment on column ${itl_schema}.mtl_fdl_idx_index_data_jx.index_no is '指标编号';
comment on column ${itl_schema}.mtl_fdl_idx_index_data_jx.org_no is '机构编号';
comment on column ${itl_schema}.mtl_fdl_idx_index_data_jx.biz_strip_line_cd is '业务条线代码';
comment on column ${itl_schema}.mtl_fdl_idx_index_data_jx.dim_cd1 is '维度代码1';
comment on column ${itl_schema}.mtl_fdl_idx_index_data_jx.dim_cd2 is '维度代码2';
comment on column ${itl_schema}.mtl_fdl_idx_index_data_jx.dim_cd3 is '维度代码3';
comment on column ${itl_schema}.mtl_fdl_idx_index_data_jx.batch_freq is '批次频度';
comment on column ${itl_schema}.mtl_fdl_idx_index_data_jx.index_measure is '指标度量';
comment on column ${itl_schema}.mtl_fdl_idx_index_data_jx.curr_cd is '币种代码';
comment on column ${itl_schema}.mtl_fdl_idx_index_data_jx.index_val is '指标值';
comment on column ${itl_schema}.mtl_fdl_idx_index_data_jx.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_fdl_idx_index_data_jx.etl_timestamp is 'ETL处理时间戳';
