/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_bail_account
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_bail_account
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_bail_account purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_bail_account(
    id number(22) -- 
    ,bail_account varchar2(60) -- 
    ,cust_id number(22) -- 
    ,bail_sub_no varchar2(60) -- 
    ,bail_amount number(18,2) -- 
    ,manager_id number(22) -- 
    ,depart_id number(22) -- 
    ,brch_id varchar2(45) -- 
    ,cust_account_start_dt varchar2(12) -- 
    ,cust_account_mature_dt varchar2(12) -- 
    ,cust_account_rate number(8,5) -- 
    ,deposit_type number(22) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
    ,valid_flag varchar2(2) -- 
    ,lock_flag varchar2(2) -- 
    ,lock_type varchar2(3) -- 
    ,lock_id number(22) -- 
    ,if_default varchar2(2) -- 
    ,avaibl number(18,2) -- 
    ,pool_type varchar2(2) -- 1-额度池；2-资产池
    ,bank_no varchar2(30) -- 开户行号
    ,bank_name varchar2(270) -- 开户行名称
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
grant select on ${iol_schema}.bdps_bail_account to ${iml_schema};
grant select on ${iol_schema}.bdps_bail_account to ${icl_schema};
grant select on ${iol_schema}.bdps_bail_account to ${idl_schema};
grant select on ${iol_schema}.bdps_bail_account to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_bail_account is '保证金账号表';
comment on column ${iol_schema}.bdps_bail_account.id is '';
comment on column ${iol_schema}.bdps_bail_account.bail_account is '';
comment on column ${iol_schema}.bdps_bail_account.cust_id is '';
comment on column ${iol_schema}.bdps_bail_account.bail_sub_no is '';
comment on column ${iol_schema}.bdps_bail_account.bail_amount is '';
comment on column ${iol_schema}.bdps_bail_account.manager_id is '';
comment on column ${iol_schema}.bdps_bail_account.depart_id is '';
comment on column ${iol_schema}.bdps_bail_account.brch_id is '';
comment on column ${iol_schema}.bdps_bail_account.cust_account_start_dt is '';
comment on column ${iol_schema}.bdps_bail_account.cust_account_mature_dt is '';
comment on column ${iol_schema}.bdps_bail_account.cust_account_rate is '';
comment on column ${iol_schema}.bdps_bail_account.deposit_type is '';
comment on column ${iol_schema}.bdps_bail_account.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_bail_account.last_upd_time is '';
comment on column ${iol_schema}.bdps_bail_account.valid_flag is '';
comment on column ${iol_schema}.bdps_bail_account.lock_flag is '';
comment on column ${iol_schema}.bdps_bail_account.lock_type is '';
comment on column ${iol_schema}.bdps_bail_account.lock_id is '';
comment on column ${iol_schema}.bdps_bail_account.if_default is '';
comment on column ${iol_schema}.bdps_bail_account.avaibl is '';
comment on column ${iol_schema}.bdps_bail_account.pool_type is '1-额度池；2-资产池';
comment on column ${iol_schema}.bdps_bail_account.bank_no is '开户行号';
comment on column ${iol_schema}.bdps_bail_account.bank_name is '开户行名称';
comment on column ${iol_schema}.bdps_bail_account.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_bail_account.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_bail_account.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_bail_account.etl_timestamp is 'ETL处理时间戳';
