/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_receipt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_receipt
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_receipt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_receipt(
    ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,reason_code varchar2(10) -- 账户用途
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,appr_flag varchar2(1) -- 复核标志
    ,company varchar2(20) -- 法人
    ,event_type varchar2(20) -- 事件类型
    ,last_pre_repay_deal varchar2(1) -- 提前还款前的还款计划变更方式
    ,narrative varchar2(400) -- 摘要
    ,pre_repay_deal varchar2(1) -- 还款计划变更方式
    ,receipt_gen_code varchar2(1) -- 回收产生方式
    ,receipt_no varchar2(50) -- 回收号
    ,reversal varchar2(1) -- 是否冲正标志
    ,sell_not_flag varchar2(1) -- 是否卖断式
    ,settle varchar2(1) -- 结算标志
    ,xrate_id varchar2(1) -- 汇兑方式
    ,approval_date date -- 复核日期
    ,last_change_date date -- 最后修改日期
    ,last_contraction_date date -- 提前还款前的到期日期
    ,receipt_date date -- 贷款还款日期
    ,settle_date date -- 结算日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,last_formula_amt number(17,2) -- 提前还款前的期供
    ,loan_no varchar2(50) -- 贷款号
    ,local_xrate number(15,8) -- 对人民币汇率
    ,payer_client_no varchar2(16) -- 付款人客户号
    ,pre_fee_amt number(17,2) -- 提前还款费用金额
    ,pre_pri_amt number(17,2) -- 提前还款本金金额
    ,rec_amt number(17,2) -- 回收金额(指回收的本金)
    ,reversal_reason varchar2(200) -- 冲正原因
    ,settle_user_id varchar2(8) -- 结算柜员
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,receipt_type varchar2(2) -- 还款类型
    ,reaccount_cd varchar2(20) -- 对账代码
    ,repay_restraint varchar2(10) -- 还款约束
    ,rec_mode varchar2(1) -- 回收模式:T-转账,C-现金
    ,receipt_reason varchar2(200) -- 回收原因
    ,reversal_date date -- 
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
grant select on ${iol_schema}.ncbs_cl_receipt to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_receipt to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_receipt to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_receipt to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_receipt is '回收表';
comment on column ${iol_schema}.ncbs_cl_receipt.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_receipt.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_receipt.reason_code is '账户用途';
comment on column ${iol_schema}.ncbs_cl_receipt.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_receipt.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_cl_receipt.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_receipt.appr_flag is '复核标志';
comment on column ${iol_schema}.ncbs_cl_receipt.company is '法人';
comment on column ${iol_schema}.ncbs_cl_receipt.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_cl_receipt.last_pre_repay_deal is '提前还款前的还款计划变更方式';
comment on column ${iol_schema}.ncbs_cl_receipt.narrative is '摘要';
comment on column ${iol_schema}.ncbs_cl_receipt.pre_repay_deal is '还款计划变更方式';
comment on column ${iol_schema}.ncbs_cl_receipt.receipt_gen_code is '回收产生方式';
comment on column ${iol_schema}.ncbs_cl_receipt.receipt_no is '回收号';
comment on column ${iol_schema}.ncbs_cl_receipt.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_cl_receipt.sell_not_flag is '是否卖断式';
comment on column ${iol_schema}.ncbs_cl_receipt.settle is '结算标志';
comment on column ${iol_schema}.ncbs_cl_receipt.xrate_id is '汇兑方式';
comment on column ${iol_schema}.ncbs_cl_receipt.approval_date is '复核日期';
comment on column ${iol_schema}.ncbs_cl_receipt.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_receipt.last_contraction_date is '提前还款前的到期日期';
comment on column ${iol_schema}.ncbs_cl_receipt.receipt_date is '贷款还款日期';
comment on column ${iol_schema}.ncbs_cl_receipt.settle_date is '结算日期';
comment on column ${iol_schema}.ncbs_cl_receipt.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_receipt.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_receipt.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_cl_receipt.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_cl_receipt.last_formula_amt is '提前还款前的期供';
comment on column ${iol_schema}.ncbs_cl_receipt.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_receipt.local_xrate is '对人民币汇率';
comment on column ${iol_schema}.ncbs_cl_receipt.payer_client_no is '付款人客户号';
comment on column ${iol_schema}.ncbs_cl_receipt.pre_fee_amt is '提前还款费用金额';
comment on column ${iol_schema}.ncbs_cl_receipt.pre_pri_amt is '提前还款本金金额';
comment on column ${iol_schema}.ncbs_cl_receipt.rec_amt is '回收金额(指回收的本金)';
comment on column ${iol_schema}.ncbs_cl_receipt.reversal_reason is '冲正原因';
comment on column ${iol_schema}.ncbs_cl_receipt.settle_user_id is '结算柜员';
comment on column ${iol_schema}.ncbs_cl_receipt.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cl_receipt.receipt_type is '还款类型';
comment on column ${iol_schema}.ncbs_cl_receipt.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_cl_receipt.repay_restraint is '还款约束';
comment on column ${iol_schema}.ncbs_cl_receipt.rec_mode is '回收模式:T-转账,C-现金';
comment on column ${iol_schema}.ncbs_cl_receipt.receipt_reason is '回收原因';
comment on column ${iol_schema}.ncbs_cl_receipt.reversal_date is '';
comment on column ${iol_schema}.ncbs_cl_receipt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_receipt.etl_timestamp is 'ETL处理时间戳';
