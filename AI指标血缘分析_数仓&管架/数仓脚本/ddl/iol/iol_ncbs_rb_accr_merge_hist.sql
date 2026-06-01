/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_accr_merge_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_accr_merge_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_accr_merge_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_accr_merge_hist(
    amount number(17,2) -- 金额
    ,amt_type varchar2(10) -- 金额类型
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,business_unit varchar2(10) -- 账套
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,gl_code varchar2(20) -- 科目代码
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,event_type varchar2(20) -- 事件类型
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,in_status varchar2(1) -- 入账方式
    ,narrative varchar2(400) -- 摘要
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,reversal_seq_no varchar2(50) -- 冲正流水号
    ,seq_no varchar2(50) -- 序号
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,system_id varchar2(20) -- 系统id
    ,accounting_status varchar2(3) -- 核算状态
    ,channel_date date -- 渠道日期
    ,effect_date date -- 产品生效日期
    ,reversal_date date -- 冲正日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,int_amt number(17,2) -- 利息金额
    ,odi_amt number(17,2) -- 复利金额
    ,odp_amt number(17,2) -- 罚息金额
    ,pri_amt number(17,2) -- 本金金额
    ,settle_branch varchar2(12) -- 清算机构
    ,tax_amt number(17,2) -- 税金
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,tran_profit_center varchar2(20) -- 交易利润中心
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
grant select on ${iol_schema}.ncbs_rb_accr_merge_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_accr_merge_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_accr_merge_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_accr_merge_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_accr_merge_hist is '计提合并流水表';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.amount is '金额';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.business_unit is '账套';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.in_status is '入账方式';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.reversal_seq_no is '冲正流水号';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.system_id is '系统id';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.channel_date is '渠道日期';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.odi_amt is '复利金额';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.odp_amt is '罚息金额';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.pri_amt is '本金金额';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.settle_branch is '清算机构';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.tax_amt is '税金';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.tran_profit_center is '交易利润中心';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_accr_merge_hist.etl_timestamp is 'ETL处理时间戳';
