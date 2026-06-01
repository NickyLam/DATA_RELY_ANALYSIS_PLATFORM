/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_lm_client_limit_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_lm_client_limit_record
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_lm_client_limit_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_lm_client_limit_record(
    internal_key number(15) -- 账户内部键值
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,prod_type varchar2(12) -- 产品编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,client_no varchar2(16) -- 客户编号
    ,limit_main_type varchar2(10) -- 限额大类
    ,day_limit_max_amt number(17,2) -- 日限额最大值
    ,old_day_limit_amt number(17,2) -- 原日累计最大限制金额
    ,day_limit_max_num number(5) -- 日累计最大笔数
    ,old_day_limit_num number(5) -- 原日累计最大限制笔数
    ,single_limit_max_amt number(17,2) -- 单笔最大限制金额
    ,old_single_limit_amt number(17,2) -- 原单笔最大限制金额
    ,year_limit_max_amt number(17,2) -- 年限额最大值
    ,old_year_limit_amt number(17,2) -- 原年累计最大限制金额
    ,source_type varchar2(6) -- 渠道编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,limit_reason varchar2(2) -- 限额设置原因
    ,reference varchar2(50) -- 交易参考号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_limit_due_date date -- 交易限额有效期
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
grant select on ${iol_schema}.ncbs_rb_lm_client_limit_record to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_lm_client_limit_record to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_lm_client_limit_record to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_lm_client_limit_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_lm_client_limit_record is '自定义限额变更记录表|自定义限额变更记录表';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.limit_main_type is '限额大类';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.day_limit_max_amt is '日限额最大值';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.old_day_limit_amt is '原日累计最大限制金额';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.day_limit_max_num is '日累计最大笔数';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.old_day_limit_num is '原日累计最大限制笔数';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.single_limit_max_amt is '单笔最大限制金额';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.old_single_limit_amt is '原单笔最大限制金额';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.year_limit_max_amt is '年限额最大值';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.old_year_limit_amt is '原年累计最大限制金额';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.limit_reason is '限额设置原因';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.tran_limit_due_date is '交易限额有效期';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_lm_client_limit_record.etl_timestamp is 'ETL处理时间戳';
