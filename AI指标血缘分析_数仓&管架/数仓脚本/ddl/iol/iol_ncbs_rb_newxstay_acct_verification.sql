/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_newxstay_acct_verification
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_newxstay_acct_verification
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_newxstay_acct_verification purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_newxstay_acct_verification(
    acct_name varchar2(200) -- 账户名称
    ,acct_status varchar2(1) -- 账户状态
    ,acct_type varchar2(1) -- 账户类型
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,acct_verification varchar2(1) -- 账户核实情况
    ,company varchar2(20) -- 法人
    ,verification_flag varchar2(1) -- 核实标志
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,verification_date date -- 核实日期
    ,acct_ccy varchar2(3) -- 账户币种
    ,home_branch varchar2(12) -- 客户管理行
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,verification_user_id varchar2(8) -- 核实柜员
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_rb_newxstay_acct_verification to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_newxstay_acct_verification to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_newxstay_acct_verification to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_newxstay_acct_verification to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_newxstay_acct_verification is '待核实帐户表';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.acct_type is '账户类型';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.acct_verification is '账户核实情况';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.company is '法人';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.verification_flag is '核实标志';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.verification_date is '核实日期';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.home_branch is '客户管理行';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.verification_user_id is '核实柜员';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_newxstay_acct_verification.etl_timestamp is 'ETL处理时间戳';
