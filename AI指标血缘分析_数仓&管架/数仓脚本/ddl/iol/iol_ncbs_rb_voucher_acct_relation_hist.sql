/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_voucher_acct_relation_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_voucher_acct_relation_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_voucher_acct_relation_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_voucher_acct_relation_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,voucher_no varchar2(50) -- 凭证号码
    ,voucher_status varchar2(3) -- 凭证状态
    ,collat_no varchar2(32) -- 押品编号
    ,company varchar2(20) -- 法人
    ,doc_class varchar2(3) -- 存款凭证种类
    ,narrative varchar2(400) -- 摘要
    ,old_status varchar2(3) -- 凭证原状态
    ,prefix varchar2(10) -- 前缀
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,open_branch varchar2(12) -- 开立机构
    ,can_reason_code varchar2(2) -- 作废原因
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
grant select on ${iol_schema}.ncbs_rb_voucher_acct_relation_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_acct_relation_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_acct_relation_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_acct_relation_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_voucher_acct_relation_hist is '凭证账户关系历史表';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.voucher_status is '凭证状态';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.collat_no is '押品编号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.doc_class is '存款凭证种类';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.old_status is '凭证原状态';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.open_branch is '开立机构';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.can_reason_code is '作废原因';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation_hist.etl_timestamp is 'ETL处理时间戳';
