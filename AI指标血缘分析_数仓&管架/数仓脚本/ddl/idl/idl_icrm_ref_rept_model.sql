/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ref_rept_model
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ref_rept_model
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ref_rept_model purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ref_rept_model(
    etl_dt date -- 数据日期
    ,model_id varchar2(60) -- 模型编号
    ,row_id varchar2(60) -- 行编号
    ,row_name varchar2(100) -- 行名称
    ,cors_subj_id varchar2(60) -- 对应科目编号
    ,dsply_seq_no varchar2(60) -- 显示次序
    ,row_dimen_type varchar2(60) -- 行量纲类型
    ,row_attr varchar2(250) -- 行属性
    ,col_1_def varchar2(2000) -- 列1定义
    ,col_2_def varchar2(2000) -- 列2定义
    ,col_3_def varchar2(2000) -- 列3定义
    ,col_4_def varchar2(2000) -- 列4定义
    ,std_val varchar2(60) -- 标准值
    ,del_flg varchar2(10) -- 删除标志
    ,formu_explain_1 varchar2(2000) -- 公式解释1
    ,formu_explain_2 varchar2(2000) -- 公式解释2
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
grant select on ${idl_schema}.icrm_ref_rept_model to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ref_rept_model is '报表模型';
comment on column ${idl_schema}.icrm_ref_rept_model.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ref_rept_model.model_id is '模型编号';
comment on column ${idl_schema}.icrm_ref_rept_model.row_id is '行编号';
comment on column ${idl_schema}.icrm_ref_rept_model.row_name is '行名称';
comment on column ${idl_schema}.icrm_ref_rept_model.cors_subj_id is '对应科目编号';
comment on column ${idl_schema}.icrm_ref_rept_model.dsply_seq_no is '显示次序';
comment on column ${idl_schema}.icrm_ref_rept_model.row_dimen_type is '行量纲类型';
comment on column ${idl_schema}.icrm_ref_rept_model.row_attr is '行属性';
comment on column ${idl_schema}.icrm_ref_rept_model.col_1_def is '列1定义';
comment on column ${idl_schema}.icrm_ref_rept_model.col_2_def is '列2定义';
comment on column ${idl_schema}.icrm_ref_rept_model.col_3_def is '列3定义';
comment on column ${idl_schema}.icrm_ref_rept_model.col_4_def is '列4定义';
comment on column ${idl_schema}.icrm_ref_rept_model.std_val is '标准值';
comment on column ${idl_schema}.icrm_ref_rept_model.del_flg is '删除标志';
comment on column ${idl_schema}.icrm_ref_rept_model.formu_explain_1 is '公式解释1';
comment on column ${idl_schema}.icrm_ref_rept_model.formu_explain_2 is '公式解释2';
comment on column ${idl_schema}.icrm_ref_rept_model.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_ref_rept_model.etl_timestamp is '数据处理时间';
