/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_loan_repay_plan_dtl_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_loan_repay_plan_dtl_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_loan_repay_plan_dtl_h(
etl_dt date --数据日期
,repay_plan_id varchar2(100) --还款计划编号
,acct_id varchar2(100) --账户编号
,cust_id varchar2(100) --客户编号
,curr_pd number(10,0) --当前期次
,amt_type_cd varchar2(30) --金额类型代码
,value_dt date --起息日期
,int_set_dt date --结息日期
,plan_repay_amt number(30,2) --计划还款金额
,aldy_paid_amt number(30,2) --已还金额
,pric_amt number(30,2) --本金金额
,iss_flg varchar2(10) --出单标志
,advise_odd_no varchar2(60) --通知单号
,iss_int_rat number(18,8) --出单利率
,iss_amt number(30,2) --出单金额
,doc_bal number(30,2) --单据余额
,doc_exp_dt date --单据到期日期
,grace_dt date --宽限日期
,tran_dt date --交易日期
,stl_dt date --结算日期
,full_amt_callbk_flg varchar2(10) --全额回收标志
,doc_create_way_cd varchar2(30) --单据生成方式代码
,tran_ref_no varchar2(60) --交易参考号
,tax_category_cd varchar2(30) --税种代码
,tax_rat number(18,6) --税率
,tax_amt number(30,2) --税金
,doc_ld_unpaid_amt number(30,2) --单据上日未还金额
,ld_bal_update_dt date --上日余额更新日期
,delay_pay_int_flg varchar2(10) --延期付息标志
,wrt_off_pric number(30,2) --核销本金
,tran_teller_id varchar2(100) --交易柜员编号
,final_modif_dt date --最后修改日期
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(250) --协议编号
,lp_id varchar2(100) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_loan_repay_plan_dtl_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_loan_repay_plan_dtl_h is '贷款还款计划明细历史';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.repay_plan_id is '还款计划编号';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.acct_id is '账户编号';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.curr_pd is '当前期次';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.amt_type_cd is '金额类型代码';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.value_dt is '起息日期';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.int_set_dt is '结息日期';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.plan_repay_amt is '计划还款金额';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.aldy_paid_amt is '已还金额';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.pric_amt is '本金金额';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.iss_flg is '出单标志';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.advise_odd_no is '通知单号';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.iss_int_rat is '出单利率';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.iss_amt is '出单金额';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.doc_bal is '单据余额';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.doc_exp_dt is '单据到期日期';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.grace_dt is '宽限日期';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.tran_dt is '交易日期';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.stl_dt is '结算日期';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.full_amt_callbk_flg is '全额回收标志';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.doc_create_way_cd is '单据生成方式代码';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.tran_ref_no is '交易参考号';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.tax_category_cd is '税种代码';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.tax_rat is '税率';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.tax_amt is '税金';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.doc_ld_unpaid_amt is '单据上日未还金额';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.ld_bal_update_dt is '上日余额更新日期';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.delay_pay_int_flg is '延期付息标志';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.wrt_off_pric is '核销本金';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.tran_teller_id is '交易柜员编号';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.final_modif_dt is '最后修改日期';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_loan_repay_plan_dtl_h.lp_id is '法人编号';

