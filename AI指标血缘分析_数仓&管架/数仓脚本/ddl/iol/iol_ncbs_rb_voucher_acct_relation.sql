/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_voucher_acct_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_voucher_acct_relation
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_voucher_acct_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_voucher_acct_relation(
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
    ,collat_ind varchar2(1) -- 抵质押标志
    ,collat_no varchar2(32) -- 押品编号
    ,company varchar2(20) -- 法人
    ,doc_class varchar2(3) -- 存款凭证种类
    ,narrative varchar2(400) -- 摘要
    ,old_status varchar2(3) -- 凭证原状态
    ,prefix varchar2(10) -- 前缀
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,can_reason_code varchar2(2) -- 作废原因
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
grant select on ${iol_schema}.ncbs_rb_voucher_acct_relation to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_acct_relation to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_acct_relation to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_acct_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_voucher_acct_relation is '凭证账户关系表';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.voucher_status is '凭证状态';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.collat_ind is '抵质押标志';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.collat_no is '押品编号';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.company is '法人';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.doc_class is '存款凭证种类';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.old_status is '凭证原状态';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.can_reason_code is '作废原因';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_voucher_acct_relation.etl_timestamp is 'ETL处理时间戳';
