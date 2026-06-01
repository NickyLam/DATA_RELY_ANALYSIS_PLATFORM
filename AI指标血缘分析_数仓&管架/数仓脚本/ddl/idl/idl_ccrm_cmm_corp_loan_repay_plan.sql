/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ccrm_cmm_corp_loan_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.ccrm_cmm_corp_loan_repay_plan
whenever sqlerror continue none;
drop table ${idl_schema}.ccrm_cmm_corp_loan_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.ccrm_cmm_corp_loan_repay_plan(
    etl_dt date -- 数据日期   
    ,lp_id varchar2(60) -- 法人编号   
    ,dubil_id varchar2(60) -- 借据编号   
    ,acct_id varchar2(60) -- 账户编号   
    ,cust_id varchar2(60) -- 客户编号   
    ,tot_perds number(10, 0) -- 总期数   
    ,repay_perds number(10, 0) -- 还款期数   
    ,repay_sub_perds number(10, 0) -- 还款子期数   
    ,value_dt date -- 起息日期   
    ,repaybl_dt date -- 应还款日期   
    ,exec_status_flg varchar2(10) -- 执行状态标志   
    ,ovdue_flg varchar2(10) -- 逾期标志   
    ,irr_repay_plan_flg varchar2(10) -- 不规则还款计划标志   
    ,repay_flg varchar2(10) -- 偿还标志   
    ,is_int_set_flg varchar2(10) -- 是否结息标志   
    ,repay_cate_cd varchar2(10) -- 还款类别代码   
    ,repay_way_cd varchar2(10) -- 还款方式代码   
    ,curr_cd varchar2(10) -- 币种代码   
    ,exec_int_rat number(18, 8) -- 执行利率   
    ,acru_nomal_pric number(30, 2) -- 应计正常本金   
    ,curr_issue_recvbl_pric number(30, 2) -- 本期应收本金   
    ,curr_issue_int_recvbl number(30, 2) -- 本期应收利息   
    ,curr_issue_recvbl_fee number(30, 2) -- 本期应收费用   
    ,curr_issue_int_sub_amt number(30, 2) -- 本期贴息金额   
    ,job_cd varchar2(10) -- 任务代码   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.ccrm_cmm_corp_loan_repay_plan to ${iel_schema};

-- comment
comment on table ${idl_schema}.ccrm_cmm_corp_loan_repay_plan is '对公贷款还款计划';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.etl_dt is '数据日期';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.lp_id is '法人编号';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.dubil_id is '借据编号';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.acct_id is '账户编号';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.cust_id is '客户编号';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.tot_perds is '总期数';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.repay_perds is '还款期数';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.repay_sub_perds is '还款子期数';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.value_dt is '起息日期';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.repaybl_dt is '应还款日期';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.exec_status_flg is '执行状态标志';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.ovdue_flg is '逾期标志';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.irr_repay_plan_flg is '不规则还款计划标志';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.repay_flg is '偿还标志';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.is_int_set_flg is '是否结息标志';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.repay_cate_cd is '还款类别代码';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.repay_way_cd is '还款方式代码';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.curr_cd is '币种代码';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.exec_int_rat is '执行利率';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.acru_nomal_pric is '应计正常本金';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.curr_issue_recvbl_pric is '本期应收本金';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.curr_issue_int_recvbl is '本期应收利息';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.curr_issue_recvbl_fee is '本期应收费用';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.curr_issue_int_sub_amt is '本期贴息金额';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.job_cd is '任务代码';
comment on column ${idl_schema}.ccrm_cmm_corp_loan_repay_plan.etl_timestamp is '数据处理时间';