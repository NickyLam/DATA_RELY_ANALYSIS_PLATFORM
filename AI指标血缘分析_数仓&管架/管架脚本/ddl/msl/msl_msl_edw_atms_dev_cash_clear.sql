/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_atms_dev_cash_clear
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_atms_dev_cash_clear
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_atms_dev_cash_clear purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_atms_dev_cash_clear(
    etl_dt date
    ,dev_no varchar2(20)
    ,addcash_id varchar2(10)
    ,addcash_datetime varchar2(19)
    ,addcash_amount number(22)
    ,addcash_type varchar2(60)
    ,addcash_count varchar2(60)
    ,clear_datetime varchar2(19)
    ,addcash_left number(22)
    ,addcash_lastamount number(22)
    ,addcash_retractcount number(22)
    ,deposit_count number(22)
    ,deposit_amount number(22)
    ,withdraw_count number(22)
    ,withdraw_amount number(22)
    ,clear_id varchar2(30)
    ,cashutil_amount varchar2(100)
    ,cashby_handcount varchar2(100)
    ,add_id varchar2(30)
    ,start_dt date
    ,end_dt date
    ,id_mark varchar2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_atms_dev_cash_clear to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_atms_dev_cash_clear is '设备清加钞信息表';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.dev_no is '设备号';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.addcash_id is '加钞标识（当前日期+编号，编号为两位，从00~99）';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.addcash_datetime is '加钞日期';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.addcash_amount is '加钞金额';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.addcash_type is '加钞面值集合 如50,100多种面值以逗号分割';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.addcash_count is '加钞张数 如 1000,2000 多种面值与AddCashType的面值对应，同样以逗号分割';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.clear_datetime is '清机时间';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.addcash_left is '主机尾箱余额';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.addcash_lastamount is '钞箱剩余金额（不包括回收箱）';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.addcash_retractcount is '回收箱张数';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.deposit_count is '存款总笔数';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.deposit_amount is '存款总金额';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.withdraw_count is '取款总笔数';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.withdraw_amount is '取款总金额';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.clear_id is '';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.cashutil_amount is '';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.cashby_handcount is '';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.add_id is '';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.start_dt is '开始时间';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.end_dt is '结束时间';
comment on column ${msl_schema}.msl_edw_atms_dev_cash_clear.id_mark is '增删标志';
