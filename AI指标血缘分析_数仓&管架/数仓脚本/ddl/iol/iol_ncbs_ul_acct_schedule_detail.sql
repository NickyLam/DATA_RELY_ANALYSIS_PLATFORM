/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_ul_acct_schedule_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_ul_acct_schedule_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_ul_acct_schedule_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_ul_acct_schedule_detail(
    sched_seq_no varchar2(50) -- 还款计划序号|还款计划序号
    ,batch_no varchar2(50) -- 批次号|批次号
    ,cmisloan_no varchar2(60) -- 客户借据编号|客户借据编号
    ,client_no varchar2(16) -- 客户编号|客户编号
    ,stage_no number(5,0) -- 期次|期次
    ,amt_type varchar2(10) -- 金额类型|金额类型|bal-余额,dda-发放金额,intp-逾期利息,lim-额度金额,od-透支金额,odip-逾期复利,odpp-逾期罚息,osl-未到期本金,prd-逾期本金,pri-本金,pf-净本金,int-利息,odi-复利,odp-罚息,fee-费用,uni-非本金,all-本加息,ds-前收息金额,prf-提前结清手续费
    ,start_date date -- 开始日期|开始日期
    ,receipt_date date -- 贷款还款日期|贷款还款日期
    ,end_date date -- 结束日期|结束日期
    ,sched_amt number(17,2) -- 还款计划金额|还款计划金额
    ,paid_amt number(17,2) -- 已还金额|已还金额
    ,pri_outstanding number(17,2) -- 贷款还款本金金额|贷款还款本金金额
    ,tran_timestamp varchar2(26) -- 交易时间戳|交易时间戳
    ,due_date date -- 单据到期日|单据到期日
    ,tran_date date -- 交易日期|交易日期
    ,final_settle_date date -- 最后结算日期|最后结算日期
    ,fully_settled_flag varchar2(1) -- 单据全额回收标志|单据全额回收标志
    ,last_change_date date -- 最后修改日期|最后修改日期
    ,company varchar2(20) -- 法人|法人
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
grant select on ${iol_schema}.ncbs_ul_acct_schedule_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_ul_acct_schedule_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_ul_acct_schedule_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_ul_acct_schedule_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_ul_acct_schedule_detail is '联合贷还款计划明细表';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.sched_seq_no is '还款计划序号|还款计划序号';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.batch_no is '批次号|批次号';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.cmisloan_no is '客户借据编号|客户借据编号';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.client_no is '客户编号|客户编号';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.stage_no is '期次|期次';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.amt_type is '金额类型|金额类型|bal-余额,dda-发放金额,intp-逾期利息,lim-额度金额,od-透支金额,odip-逾期复利,odpp-逾期罚息,osl-未到期本金,prd-逾期本金,pri-本金,pf-净本金,int-利息,odi-复利,odp-罚息,fee-费用,uni-非本金,all-本加息,ds-前收息金额,prf-提前结清手续费';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.start_date is '开始日期|开始日期';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.receipt_date is '贷款还款日期|贷款还款日期';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.end_date is '结束日期|结束日期';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.sched_amt is '还款计划金额|还款计划金额';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.paid_amt is '已还金额|已还金额';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.pri_outstanding is '贷款还款本金金额|贷款还款本金金额';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.tran_timestamp is '交易时间戳|交易时间戳';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.due_date is '单据到期日|单据到期日';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.tran_date is '交易日期|交易日期';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.final_settle_date is '最后结算日期|最后结算日期';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.fully_settled_flag is '单据全额回收标志|单据全额回收标志';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.last_change_date is '最后修改日期|最后修改日期';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.company is '法人|法人';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_ul_acct_schedule_detail.etl_timestamp is 'ETL处理时间戳';
