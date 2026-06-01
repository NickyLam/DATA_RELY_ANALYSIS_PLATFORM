/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_retl_loan_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_retl_loan_repay_plan
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_retl_loan_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_repay_plan(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(60) -- 借据编号
    ,acct_id varchar2(60) -- 账户编号
    ,loan_num varchar2(60) -- 贷款号
    ,cust_id varchar2(60) -- 客户编号
    ,tot_perds number(10,0) -- 贷款期数
    ,repay_perds number(10,0) -- 还款期数
    ,repay_sub_perds varchar2(100) -- 还款子期数
    ,value_dt date -- 起息日期
    ,repaybl_dt date -- 应还款日期
    ,grace_repay_dt date -- 宽限还款日期
    ,last_repay_dt date -- 上次还款日期
    ,next_repay_dt date -- 下次还款日期
    ,modif_dt date -- 修改日期
    ,repay_amt_type_cd varchar2(10) -- 还款金额类型代码
    ,repay_type_cd varchar2(10) -- 还款类型代码
    ,repay_status_cd varchar2(10) -- 还款状态代码
    ,ovdue_flg varchar2(10) -- 逾期标志
    ,repay_flg varchar2(10) -- 偿还标志
    ,pd_h_ovdue_flg varchar2(10) -- 期次历史逾期标志
    ,curr_cd varchar2(10) -- 币种代码
    ,exec_int_rat number(18,8) -- 执行利率
    ,pric_bal number(30,2) -- 本金余额
    ,acru_nomal_pric number(30,2) -- 应计正常本金
    ,curr_issue_recvbl_amt number(30,2) -- 本期应收金额
    ,curr_doc_bal number(30,2) -- 本期单据余额
    ,curr_issue_recvbl_pric number(30,2) -- 本期应收本金
    ,curr_issue_int_recvbl number(30,2) -- 本期应收利息
    ,curr_issue_recvbl_acru_int number(30,2) -- 本期应收应计利息
    ,curr_issue_coll_acru_int number(30,2) -- 本期催收应计利息
    ,curr_issue_ovdue_pric number(30,2) -- 本期逾期本金
    ,curr_issue_recvbl_over_int number(30,2) -- 本期应收欠息
    ,curr_issue_coll_over_int number(30,2) -- 本期催收欠息
    ,curr_issue_recvbl_acru_pnlt number(30,2) -- 本期应收应计罚息
    ,curr_issue_coll_acru_pnlt number(30,2) -- 本期催收应计罚息
    ,curr_issue_recvbl_pnlt number(30,2) -- 本期应收罚息
    ,curr_issue_coll_pnlt number(30,2) -- 本期催收罚息
    ,curr_issue_acru_comp_int number(30,2) -- 本期应计复息
    ,curr_issue_comp_int number(30,2) -- 本期复息
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_retl_loan_repay_plan to ${idl_schema};
grant select on ${icl_schema}.cmm_retl_loan_repay_plan to ${iel_schema};
grant select on ${icl_schema}.cmm_retl_loan_repay_plan to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_retl_loan_repay_plan is '零售贷款还款计划';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.loan_num is '贷款号';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.tot_perds is '贷款期数';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.repay_perds is '还款期数';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.repay_sub_perds is '还款子期数';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.repaybl_dt is '应还款日期';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.grace_repay_dt is '宽限还款日期';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.last_repay_dt is '上次还款日期';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.next_repay_dt is '下次还款日期';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.modif_dt is '修改日期';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.repay_amt_type_cd is '还款金额类型代码';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.repay_type_cd is '还款类型代码';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.repay_status_cd is '还款状态代码';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.ovdue_flg is '逾期标志';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.repay_flg is '偿还标志';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.pd_h_ovdue_flg is '期次历史逾期标志';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.pric_bal is '本金余额';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.acru_nomal_pric is '应计正常本金';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_recvbl_amt is '本期应收金额';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_doc_bal is '本期单据余额';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_recvbl_pric is '本期应收本金';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_int_recvbl is '本期应收利息';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_recvbl_acru_int is '本期应收应计利息';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_coll_acru_int is '本期催收应计利息';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_ovdue_pric is '本期逾期本金';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_recvbl_over_int is '本期应收欠息';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_coll_over_int is '本期催收欠息';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_recvbl_acru_pnlt is '本期应收应计罚息';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_coll_acru_pnlt is '本期催收应计罚息';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_recvbl_pnlt is '本期应收罚息';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_coll_pnlt is '本期催收罚息';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_acru_comp_int is '本期应计复息';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.curr_issue_comp_int is '本期复息';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_retl_loan_repay_plan.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_retl_loan_repay_plan.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_retl_loan_repay_plan.etl_timestamp is 'ETL处理时间戳';
