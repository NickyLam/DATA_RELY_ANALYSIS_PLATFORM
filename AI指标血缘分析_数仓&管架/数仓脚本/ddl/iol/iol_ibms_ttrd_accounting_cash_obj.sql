/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_accounting_cash_obj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_accounting_cash_obj
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_accounting_cash_obj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_accounting_cash_obj(
    obj_id varchar2(45) -- 对象id
    ,tsk_id varchar2(45) -- 任务id
    ,beg_date varchar2(15) -- 开始日期
    ,end_date varchar2(15) -- 结束日期
    ,ext_cash_acct_id varchar2(30) -- 外部资金账户
    ,cash_acct_id varchar2(45) -- 内部资金账户
    ,currency varchar2(5) -- 币种
    ,real_amount number(31,8) -- 余额
    ,real_margin number(31,8) -- 期货保证金
    ,open_time varchar2(29) -- 开仓时间
    ,update_time varchar2(29) -- 更新时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_ttrd_accounting_cash_obj to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_cash_obj to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_cash_obj to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_cash_obj to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_accounting_cash_obj is '同业活期账户信息';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.obj_id is '对象id';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.tsk_id is '任务id';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.beg_date is '开始日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.end_date is '结束日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.ext_cash_acct_id is '外部资金账户';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.cash_acct_id is '内部资金账户';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.real_amount is '余额';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.real_margin is '期货保证金';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.open_time is '开仓时间';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_obj.etl_timestamp is 'ETL处理时间戳';
