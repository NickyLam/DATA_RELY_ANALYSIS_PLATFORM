/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_deposit_prove
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_deposit_prove
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_deposit_prove purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_deposit_prove(
    balance number(17,2) -- 余额
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,bond_brief_name varchar2(200) -- 国债名称
    ,bond_code varchar2(50) -- 国债批次号
    ,bond_type varchar2(10) -- 发起国债渠道
    ,bond1_no varchar2(50) -- 国债序号
    ,company varchar2(20) -- 法人
    ,prefix varchar2(10) -- 前缀
    ,res_seq_no varchar2(50) -- 限制编号
    ,channel varchar2(10) -- 渠道
    ,bonf_end_date date -- 国债截止日期
    ,cert_end_date date -- 证明截止日期
    ,rise_date date -- 认购日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,cert_bal number(17,2) -- 证明余额
    ,rise_amt number(17,2) -- 资信证明认购金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_deposit_prove to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_deposit_prove to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_deposit_prove to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_deposit_prove to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_deposit_prove is '资信证明登记簿';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.balance is '余额';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.term is '存期';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.bond_brief_name is '国债名称';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.bond_code is '国债批次号';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.bond_type is '发起国债渠道';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.bond1_no is '国债序号';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.company is '法人';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.bonf_end_date is '国债截止日期';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.cert_end_date is '证明截止日期';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.rise_date is '认购日期';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.cert_bal is '证明余额';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.rise_amt is '资信证明认购金额';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_deposit_prove.etl_timestamp is 'ETL处理时间戳';
