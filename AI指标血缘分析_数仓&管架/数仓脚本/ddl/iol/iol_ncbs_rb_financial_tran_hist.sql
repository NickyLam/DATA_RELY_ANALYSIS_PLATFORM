/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_financial_tran_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_financial_tran_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_financial_tran_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_financial_tran_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,business_unit varchar2(10) -- 账套
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,event_type varchar2(20) -- 事件类型
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,primary_tran_seq_no varchar2(50) -- 主交易序号
    ,seq_no varchar2(50) -- 序号
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,channel varchar2(10) -- 渠道
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,actual_bal number(17,2) -- 实际余额
    ,previous_bal_amt number(17,2) -- 交易前余额
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,reaccount_cd varchar2(20) -- 对账代码
    ,bus_seq_no varchar2(33) -- 业务流水号
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
grant select on ${iol_schema}.ncbs_rb_financial_tran_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_financial_tran_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_financial_tran_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_financial_tran_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_financial_tran_hist is '金融交易流水表';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.business_unit is '账套';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.primary_tran_seq_no is '主交易序号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.actual_bal is '实际余额';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.previous_bal_amt is '交易前余额';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_financial_tran_hist.etl_timestamp is 'ETL处理时间戳';
