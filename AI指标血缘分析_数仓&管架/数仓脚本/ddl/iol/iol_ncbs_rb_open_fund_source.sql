/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_open_fund_source
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_open_fund_source
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_open_fund_source purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_open_fund_source(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,company varchar2(20) -- 法人
    ,oth_seq_no varchar2(50) -- 对方交易流水号
    ,seq_no varchar2(50) -- 序号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,oth_acct_ccy varchar2(3) -- 对方账户币种
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_bank_code varchar2(20) -- 对方银行代码
    ,oth_bank_name varchar2(400) -- 对方银行名称
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,tran_amt number(17,2) -- 交易金额
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
grant select on ${iol_schema}.ncbs_rb_open_fund_source to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_open_fund_source to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_open_fund_source to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_open_fund_source to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_open_fund_source is '开户存入资金来源登记簿';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.company is '法人';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.oth_seq_no is '对方交易流水号';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.oth_acct_ccy is '对方账户币种';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.oth_bank_code is '对方银行代码';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.oth_bank_name is '对方银行名称';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_open_fund_source.etl_timestamp is 'ETL处理时间戳';
