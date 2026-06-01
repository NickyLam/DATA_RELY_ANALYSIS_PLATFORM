/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_law_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_law_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_law_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_law_detail(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,doc_type varchar2(10) -- 凭证类型
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,bal_type varchar2(2) -- 余额类型
    ,batch_no varchar2(50) -- 批次号
    ,cash_tran_flag varchar2(1) -- 现金交易
    ,company varchar2(20) -- 法人
    ,narrative varchar2(400) -- 摘要
    ,seq_no varchar2(50) -- 序号
    ,tran_date date -- 交易日期
    ,tran_hist_time varchar2(26) -- 交易历史时间
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,actual_bal number(17,2) -- 实际余额
    ,auth_user_id varchar2(8) -- 授权柜员
    ,cret_amt number(17,2) -- 存入金额
    ,debt_amt number(17,2) -- 支取金额
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
grant select on ${iol_schema}.ncbs_rb_batch_law_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_law_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_law_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_law_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_law_detail is '批量司法查询结果明细表';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.bal_type is '余额类型';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.cash_tran_flag is '现金交易';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.tran_hist_time is '交易历史时间';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.actual_bal is '实际余额';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.cret_amt is '存入金额';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.debt_amt is '支取金额';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_law_detail.etl_timestamp is 'ETL处理时间戳';
