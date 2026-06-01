/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_abs_cashflow_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_abs_cashflow_plan
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_abs_cashflow_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_abs_cashflow_plan(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bond_item_id varchar2(60) -- 债项编号
    ,rpbl_dt date -- 应还日期
    ,rpbl_pric number(30,8) -- 应还本金
    ,rpbl_int number(30,8) -- 应还利息
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_abs_cashflow_plan to ${idl_schema};
grant select on ${icl_schema}.cmm_abs_cashflow_plan to ${iel_schema};
grant select on ${icl_schema}.cmm_abs_cashflow_plan to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_abs_cashflow_plan is 'ABS现金流计划';
comment on column ${icl_schema}.cmm_abs_cashflow_plan.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_abs_cashflow_plan.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_abs_cashflow_plan.bond_item_id is '债项编号';
comment on column ${icl_schema}.cmm_abs_cashflow_plan.rpbl_dt is '应还日期';
comment on column ${icl_schema}.cmm_abs_cashflow_plan.rpbl_pric is '应还本金';
comment on column ${icl_schema}.cmm_abs_cashflow_plan.rpbl_int is '应还利息';
comment on column ${icl_schema}.cmm_abs_cashflow_plan.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_abs_cashflow_plan.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_abs_cashflow_plan.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_abs_cashflow_plan.etl_timestamp is 'ETL处理时间戳';
