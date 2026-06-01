/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_bab_acct_restraint
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_bab_acct_restraint
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_bab_acct_restraint purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_bab_acct_restraint(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,bab_settle_class varchar2(5) -- 绑备款账户类型
    ,company varchar2(20) -- 法人
    ,res_seq_no varchar2(50) -- 限制编号
    ,res_status varchar2(1) -- 保证金冻结状态
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,accept_contract_no varchar2(30) -- 银承合同编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,bill_doc_type varchar2(10) -- 票据凭证类型
    ,bill_voucher_no varchar2(50) -- 票据凭证号码
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
grant select on ${iol_schema}.ncbs_rb_bab_acct_restraint to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_bab_acct_restraint to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_bab_acct_restraint to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_bab_acct_restraint to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_bab_acct_restraint is '银行承兑汇票账户限制表';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.bab_settle_class is '绑备款账户类型';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.company is '法人';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.res_status is '保证金冻结状态';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.accept_contract_no is '银承合同编号';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.bill_doc_type is '票据凭证类型';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.bill_voucher_no is '票据凭证号码';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_bab_acct_restraint.etl_timestamp is 'ETL处理时间戳';
