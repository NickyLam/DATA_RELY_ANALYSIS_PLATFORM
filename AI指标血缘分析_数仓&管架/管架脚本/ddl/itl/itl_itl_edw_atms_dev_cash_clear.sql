/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_atms_dev_cash_clear
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_atms_dev_cash_clear
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_atms_dev_cash_clear purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_atms_dev_cash_clear(
    dev_no varchar2(20) -- 设备号
    ,addcash_id varchar2(10) -- 加钞标识（当前日期+编号，编号为两位，从00~99）
    ,addcash_datetime varchar2(19) -- 加钞日期
    ,addcash_amount number(22) -- 加钞金额
    ,addcash_type varchar2(60) -- 加钞面值集合 如50,100多种面值以逗号分割
    ,addcash_count varchar2(60) -- 加钞张数 如 1000,2000 多种面值与AddCashType的面值对应，同样以逗号分割
    ,clear_datetime varchar2(19) -- 清机时间
    ,addcash_left number(22) -- 主机尾箱余额
    ,addcash_lastamount number(22) -- 钞箱剩余金额（不包括回收箱）
    ,addcash_retractcount number(22) -- 回收箱张数
    ,deposit_count number(22) -- 存款总笔数
    ,deposit_amount number(22) -- 存款总金额
    ,withdraw_count number(22) -- 取款总笔数
    ,withdraw_amount number(22) -- 取款总金额
    ,clear_id varchar2(30) -- 
    ,cashutil_amount varchar2(100) -- 
    ,cashby_handcount varchar2(100) -- 
    ,add_id varchar2(30) -- 
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
grant select on ${itl_schema}.itl_edw_atms_dev_cash_clear to ${icl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_atms_dev_cash_clear is '设备清加钞信息表';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.dev_no is '设备号';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.addcash_id is '加钞标识（当前日期+编号，编号为两位，从00~99）';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.addcash_datetime is '加钞日期';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.addcash_amount is '加钞金额';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.addcash_type is '加钞面值集合 如50,100多种面值以逗号分割';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.addcash_count is '加钞张数 如 1000,2000 多种面值与AddCashType的面值对应，同样以逗号分割';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.clear_datetime is '清机时间';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.addcash_left is '主机尾箱余额';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.addcash_lastamount is '钞箱剩余金额（不包括回收箱）';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.addcash_retractcount is '回收箱张数';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.deposit_count is '存款总笔数';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.deposit_amount is '存款总金额';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.withdraw_count is '取款总笔数';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.withdraw_amount is '取款总金额';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.clear_id is '';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.cashutil_amount is '';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.cashby_handcount is '';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.add_id is '';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_atms_dev_cash_clear.etl_timestamp is 'ETL处理时间戳';
