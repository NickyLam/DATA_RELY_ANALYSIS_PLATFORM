/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_event_register_dtls
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_event_register_dtls
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_event_register_dtls purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_event_register_dtls(
    client_no varchar2(16) -- 客户编号
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,tran_type varchar2(10) -- 交易类型
    ,batch_seq_no varchar2(50) -- 批次明细序号
    ,company varchar2(20) -- 法人
    ,int_status varchar2(1) -- 利息状态
    ,movt_status varchar2(1) -- 转存类型
    ,seq_no varchar2(50) -- 序号
    ,tran_seq_no varchar2(50) -- 交易序号
    ,int_end_date date -- 下一取息日
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,int_rate number(15,8) -- 出单利率
    ,tax_amt number(17,2) -- 税金
    ,third_party_internal_key number(15) -- 第三方账户内部键值
    ,tran_amt number(17,2) -- 交易金额
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
grant select on ${iol_schema}.ncbs_rb_acct_event_register_dtls to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_event_register_dtls to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_event_register_dtls to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_event_register_dtls to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_event_register_dtls is '账户重要事件登记簿明细信息';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.batch_seq_no is '批次明细序号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.int_status is '利息状态';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.movt_status is '转存类型';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.tran_seq_no is '交易序号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.int_end_date is '下一取息日';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.int_rate is '出单利率';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.tax_amt is '税金';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.third_party_internal_key is '第三方账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_event_register_dtls.etl_timestamp is 'ETL处理时间戳';
