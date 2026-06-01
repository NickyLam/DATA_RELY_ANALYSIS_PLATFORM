/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_voucher_journal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_voucher_journal
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_voucher_journal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_voucher_journal(
    amount number(17,2) -- 金额
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,voucher_status varchar2(3) -- 凭证状态
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,module_id varchar2(2) -- 模块
    ,old_status varchar2(3) -- 凭证原状态
    ,prefix varchar2(10) -- 前缀
    ,program_id varchar2(20) -- 交易代码
    ,source_type varchar2(6) -- 渠道编号
    ,tran_desc varchar2(200) -- 交易描述
    ,voucher_journal_id varchar2(30) -- 凭证流水id
    ,bill_date date -- 本票兑付出票日
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,check_user_id varchar2(8) -- 检查柜员
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_voucher_journal to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_journal to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_journal to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_journal to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_voucher_journal is '凭证账户流水表';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.amount is '金额';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.voucher_status is '凭证状态';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.company is '法人';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.module_id is '模块';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.old_status is '凭证原状态';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.program_id is '交易代码';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.voucher_journal_id is '凭证流水id';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.bill_date is '本票兑付出票日';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.check_user_id is '检查柜员';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.can_reason_code is '作废原因';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_voucher_journal.etl_timestamp is 'ETL处理时间戳';
