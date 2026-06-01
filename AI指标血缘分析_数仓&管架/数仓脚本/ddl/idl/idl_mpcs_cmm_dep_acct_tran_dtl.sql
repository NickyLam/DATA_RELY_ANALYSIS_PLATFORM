/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mpcs_cmm_dep_acct_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl(
    etl_dt date -- 数据日期
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,cust_acct_id varchar2(40) -- 客户账户编号
    ,tran_dt varchar2(49) -- 交易日期
    ,debit_crdt_dir_cd varchar2(1) -- 借贷方向代码
    ,type1 varchar2(1) -- 0：无法区分类型
    ,tran_amt number(20,4) -- 交易金额
    ,tran_bal number(22,4) -- 交易余额
    ,operate varchar2(1) -- 代表新增
    ,tran_org_id varchar2(20) -- 交易机构编号
    ,tran_teller_id varchar2(20) -- 交易柜员编号
    ,job_cd varchar2(10) -- 任务代码
    ,acct_bill_flow_num varchar2(60) --账单流水号
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
grant select on ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl to ${iel_schema};
grant select on ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl to ${icl_schema};

-- comment
comment on table ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl is '存款账户交易明细-惠州网点开户';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.etl_dt is '数据日期';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.tran_flow_num is '交易流水号';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.cust_acct_id is '客户账户编号';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.tran_dt is '交易日期';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.debit_crdt_dir_cd is '借贷方向代码';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.type1 is '0：无法区分类型';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.tran_amt is '交易金额';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.tran_bal is '交易余额';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.operate is '代表新增';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.tran_org_id is '交易机构编号';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.tran_teller_id is '交易柜员编号';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.job_cd is '任务代码';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.etl_timestamp is 'ETL处理时间戳';
comment on column ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl.acct_bill_flow_num is '账单流水号';