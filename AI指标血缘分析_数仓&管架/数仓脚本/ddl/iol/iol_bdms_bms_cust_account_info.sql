/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_cust_account_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_cust_account_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_cust_account_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_cust_account_info(
    id varchar2(60) -- ID
    ,cust_no varchar2(24) -- 客户编号
    ,cust_name varchar2(300) -- 客户名称
    ,branch_no varchar2(30) -- 所属机构
    ,top_branch_no varchar2(30) -- 所属总行机构
    ,account_no varchar2(150) -- 帐号编号
    ,acc_bank_name varchar2(300) -- 开户行名称
    ,acc_bank_no varchar2(18) -- 开户行行号
    ,acc_type varchar2(3) -- 帐号类型： 01 结算账号 02 保证金账号
    ,currency varchar2(5) -- 账户币种
    ,status varchar2(2) -- 状态
    ,dualcontrol_lockstatus varchar2(2) -- 双岗复核锁标记
    ,last_operator_no varchar2(45) -- 最后操作员编号
    ,last_txn_date date -- 最后操作日期
    ,acct_busi_type varchar2(8) -- 账户类型： 1 同业账户 2 对公账户 3 托收账户 4 票据池账户
    ,acct_class varchar2(8) -- 账号种类： 01 活期 02 定期
    ,dist_type varchar2(9) -- 识别类型： DT01-票据账户, DT02-银行账户
    ,account_name varchar2(225) -- 账号名称
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
grant select on ${iol_schema}.bdms_bms_cust_account_info to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_cust_account_info to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_cust_account_info to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_cust_account_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_cust_account_info is '客户账号信息表';
comment on column ${iol_schema}.bdms_bms_cust_account_info.id is 'ID';
comment on column ${iol_schema}.bdms_bms_cust_account_info.cust_no is '客户编号';
comment on column ${iol_schema}.bdms_bms_cust_account_info.cust_name is '客户名称';
comment on column ${iol_schema}.bdms_bms_cust_account_info.branch_no is '所属机构';
comment on column ${iol_schema}.bdms_bms_cust_account_info.top_branch_no is '所属总行机构';
comment on column ${iol_schema}.bdms_bms_cust_account_info.account_no is '帐号编号';
comment on column ${iol_schema}.bdms_bms_cust_account_info.acc_bank_name is '开户行名称';
comment on column ${iol_schema}.bdms_bms_cust_account_info.acc_bank_no is '开户行行号';
comment on column ${iol_schema}.bdms_bms_cust_account_info.acc_type is '帐号类型： 01 结算账号 02 保证金账号';
comment on column ${iol_schema}.bdms_bms_cust_account_info.currency is '账户币种';
comment on column ${iol_schema}.bdms_bms_cust_account_info.status is '状态';
comment on column ${iol_schema}.bdms_bms_cust_account_info.dualcontrol_lockstatus is '双岗复核锁标记';
comment on column ${iol_schema}.bdms_bms_cust_account_info.last_operator_no is '最后操作员编号';
comment on column ${iol_schema}.bdms_bms_cust_account_info.last_txn_date is '最后操作日期';
comment on column ${iol_schema}.bdms_bms_cust_account_info.acct_busi_type is '账户类型： 1 同业账户 2 对公账户 3 托收账户 4 票据池账户';
comment on column ${iol_schema}.bdms_bms_cust_account_info.acct_class is '账号种类： 01 活期 02 定期';
comment on column ${iol_schema}.bdms_bms_cust_account_info.dist_type is '识别类型： DT01-票据账户, DT02-银行账户';
comment on column ${iol_schema}.bdms_bms_cust_account_info.account_name is '账号名称';
comment on column ${iol_schema}.bdms_bms_cust_account_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_cust_account_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_cust_account_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_cust_account_info.etl_timestamp is 'ETL处理时间戳';
