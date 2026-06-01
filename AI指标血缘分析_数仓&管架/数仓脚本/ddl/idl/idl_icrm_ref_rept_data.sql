/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ref_rept_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ref_rept_data
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ref_rept_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ref_rept_data(
    etl_dt date -- 数据日期
    ,rept_id varchar2(60) -- 报表编号
    ,row_id varchar2(60) -- 行编号
    ,row_name varchar2(100) -- 行名称
    ,cors_subj_id varchar2(60) -- 对应科目编号
    ,dsply_seq_no varchar2(60) -- 显示次序
    ,row_dimen_type varchar2(60) -- 行量纲类型
    ,row_attr varchar2(250) -- 行属性
    ,col_1_val number(30,6) -- 列1值
    ,col_2_val number(30,6) -- 列2值
    ,col_3_val number(30,6) -- 列3值
    ,col_4_val number(30,6) -- 列4值
    ,std_val number(30,6) -- 标准值
    ,job_cd varchar2(10) -- 任务代码
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
grant select on ${idl_schema}.icrm_ref_rept_data to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ref_rept_data is '报表数据';
comment on column ${idl_schema}.icrm_ref_rept_data.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ref_rept_data.rept_id is '报表编号';
comment on column ${idl_schema}.icrm_ref_rept_data.row_id is '行编号';
comment on column ${idl_schema}.icrm_ref_rept_data.row_name is '行名称';
comment on column ${idl_schema}.icrm_ref_rept_data.cors_subj_id is '对应科目编号';
comment on column ${idl_schema}.icrm_ref_rept_data.dsply_seq_no is '显示次序';
comment on column ${idl_schema}.icrm_ref_rept_data.row_dimen_type is '行量纲类型';
comment on column ${idl_schema}.icrm_ref_rept_data.row_attr is '行属性';
comment on column ${idl_schema}.icrm_ref_rept_data.col_1_val is '列1值';
comment on column ${idl_schema}.icrm_ref_rept_data.col_2_val is '列2值';
comment on column ${idl_schema}.icrm_ref_rept_data.col_3_val is '列3值';
comment on column ${idl_schema}.icrm_ref_rept_data.col_4_val is '列4值';
comment on column ${idl_schema}.icrm_ref_rept_data.std_val is '标准值';
comment on column ${idl_schema}.icrm_ref_rept_data.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_ref_rept_data.etl_timestamp is '数据处理时间';
