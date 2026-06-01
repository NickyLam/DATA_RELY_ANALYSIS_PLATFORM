/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_overdraft_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_overdraft_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_overdraft_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_overdraft_hist(
    channel_seq_no varchar2(33) -- 全局流水号
    ,sub_seq_no varchar2(100) -- 系统子流水号
    ,reference varchar2(50) -- 交易参考号
    ,agreement_id varchar2(50) -- 协议编号
    ,loan_no varchar2(50) -- 贷款号
    ,internal_key number(15,0) -- 账户内部键值
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,prod_type varchar2(12) -- 产品编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,client_no varchar2(16) -- 客户编号
    ,tran_date date -- 交易日期
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,tran_amt number(17,2) -- 交易金额
    ,act_tran_amt number(17,2) -- 实际交易金额
    ,deal_status varchar2(1) -- 处理状态
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
    ,dd_no number(5,0) -- 发放号
    ,cmisloan_no varchar2(60) -- 客户借据编号
    ,remark varchar2(600) -- 备注|备注
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
grant select on ${iol_schema}.ncbs_rb_overdraft_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_overdraft_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_overdraft_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_overdraft_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_overdraft_hist is '法人透支明细登记薄';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.sub_seq_no is '系统子流水号';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.act_tran_amt is '实际交易金额';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.deal_status is '处理状态';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.cmisloan_no is '客户借据编号';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.remark is '备注|备注';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_overdraft_hist.etl_timestamp is 'ETL处理时间戳';
