/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ibms_ttrd_accounting_cash_obj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj(
    etl_dt date -- 数据日期   
    ,obj_id varchar2(30) -- 对象Id   
    ,tsk_id varchar2(30) -- 任务Id   
    ,beg_date varchar2(10) -- 开始日期   
    ,end_date varchar2(10) -- 结束日期   
    ,ext_cash_acct_id varchar2(20) -- 外部资金账户   
    ,cash_acct_id varchar2(30) -- 内部资金账户   
    ,currency varchar2(10) -- 币种   
    ,real_amount number(31,8) -- 余额   
    ,real_margin number(31,8) -- 期货保证金   
    ,open_time varchar2(19) -- 开仓时间   
    ,update_time varchar2(19) -- 更新时间   
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
grant select on ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj is '同业活期账户信息';
comment on column ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj.obj_id is '对象Id';
comment on column ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj.tsk_id is '任务Id';
comment on column ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj.beg_date is '开始日期';
comment on column ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj.end_date is '结束日期';
comment on column ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj.ext_cash_acct_id is '外部资金账户';
comment on column ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj.cash_acct_id is '内部资金账户';
comment on column ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj.currency is '币种';
comment on column ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj.real_amount is '余额';
comment on column ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj.real_margin is '期货保证金';
comment on column ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj.open_time is '开仓时间';
comment on column ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj.update_time is '更新时间';
comment on column ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj.etl_timestamp is '数据处理时间';