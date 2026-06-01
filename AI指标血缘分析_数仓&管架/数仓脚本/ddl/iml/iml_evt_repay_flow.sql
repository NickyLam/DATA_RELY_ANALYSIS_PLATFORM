/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_repay_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_repay_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_repay_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_repay_flow(
    evt_id varchar2(250) -- 事件编号
    ,callbk_id varchar2(100) -- 回收编号
    ,lp_id varchar2(100) -- 法人编号
    ,loan_num varchar2(60) -- 贷款号
    ,cust_id varchar2(100) -- 客户编号
    ,loan_repay_dt date -- 贷款还款日期
    ,loan_repay_type_cd varchar2(30) -- 贷款还款类型代码
    ,pay_cust_id varchar2(100) -- 付款客户编号
    ,curr_cd varchar2(30) -- 币种代码
    ,cny_exch_rat number(18,8) -- 对人民币汇率
    ,exch_way_cd varchar2(30) -- 汇兑方式代码
    ,callbk_pric number(30,2) -- 回收金额
    ,bus_tran_dt date -- 业务交易日期
    ,callbk_prod_way_cd varchar2(30) -- 回收产生方式代码
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,repay_plan_modif_way_cd varchar2(30) -- 还款计划变更方式代码
    ,adv_repay_fee_amt number(30,2) -- 提前还款费用金额
    ,adv_repay_pric_amt number(30,2) -- 提前还款本金金额
    ,loan_rs_cd varchar2(30) -- 贷款原因代码
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,tran_stl_flg varchar2(10) -- 交易结算标志
    ,tran_stl_dt date -- 交易结算日期
    ,acct_aldy_check_flg varchar2(10) -- 账户已复核标志
    ,acct_check_dt date -- 账户复核日期
    ,revs_flg varchar2(10) -- 冲正标志
    ,tran_revs_rs_descb varchar2(500) -- 交易冲正原因描述
    ,sellout_flg varchar2(10) -- 卖断式标志
    ,evt_cate_id varchar2(100) -- 事件类别编号
    ,tran_cd varchar2(30) -- 交易码
    ,adv_bf_repay_repay_plan_modif_way_cd varchar2(30) -- 提前还款前还款计划变更方式代码
    ,adv_bf_repay_exp_dt date -- 提前还款前到期日期
    ,nomal_repay_eh_issue_repay_amt number(30,2) -- 正常还款每期还款金额
    ,stl_teller_id varchar2(100) -- 结算柜员编号
    ,acct_apv_teller_id varchar2(100) -- 账户审批柜员编号
    ,ba_auth_teller_id varchar2(100) -- 银承授权柜员编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,final_modif_dt date -- 最后修改日期
    ,tran_tm timestamp -- 交易时间
    ,repay_rstrct_cd varchar2(30) -- 还款约束代码
    ,callbk_rs varchar2(500) -- 回收原因
    ,check_entry_code varchar2(60) -- 对账编码
    ,callbk_mode_cd varchar2(30) -- 回收模式代码
    ,revs_dt date -- 冲正日期
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_repay_flow to ${icl_schema};
grant select on ${iml_schema}.evt_repay_flow to ${idl_schema};
grant select on ${iml_schema}.evt_repay_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_repay_flow is '还款流水';
comment on column ${iml_schema}.evt_repay_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_repay_flow.callbk_id is '回收编号';
comment on column ${iml_schema}.evt_repay_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_repay_flow.loan_num is '贷款号';
comment on column ${iml_schema}.evt_repay_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_repay_flow.loan_repay_dt is '贷款还款日期';
comment on column ${iml_schema}.evt_repay_flow.loan_repay_type_cd is '贷款还款类型代码';
comment on column ${iml_schema}.evt_repay_flow.pay_cust_id is '付款客户编号';
comment on column ${iml_schema}.evt_repay_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_repay_flow.cny_exch_rat is '对人民币汇率';
comment on column ${iml_schema}.evt_repay_flow.exch_way_cd is '汇兑方式代码';
comment on column ${iml_schema}.evt_repay_flow.callbk_pric is '回收金额';
comment on column ${iml_schema}.evt_repay_flow.bus_tran_dt is '业务交易日期';
comment on column ${iml_schema}.evt_repay_flow.callbk_prod_way_cd is '回收产生方式代码';
comment on column ${iml_schema}.evt_repay_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_repay_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_repay_flow.repay_plan_modif_way_cd is '还款计划变更方式代码';
comment on column ${iml_schema}.evt_repay_flow.adv_repay_fee_amt is '提前还款费用金额';
comment on column ${iml_schema}.evt_repay_flow.adv_repay_pric_amt is '提前还款本金金额';
comment on column ${iml_schema}.evt_repay_flow.loan_rs_cd is '贷款原因代码';
comment on column ${iml_schema}.evt_repay_flow.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.evt_repay_flow.tran_stl_flg is '交易结算标志';
comment on column ${iml_schema}.evt_repay_flow.tran_stl_dt is '交易结算日期';
comment on column ${iml_schema}.evt_repay_flow.acct_aldy_check_flg is '账户已复核标志';
comment on column ${iml_schema}.evt_repay_flow.acct_check_dt is '账户复核日期';
comment on column ${iml_schema}.evt_repay_flow.revs_flg is '冲正标志';
comment on column ${iml_schema}.evt_repay_flow.tran_revs_rs_descb is '交易冲正原因描述';
comment on column ${iml_schema}.evt_repay_flow.sellout_flg is '卖断式标志';
comment on column ${iml_schema}.evt_repay_flow.evt_cate_id is '事件类别编号';
comment on column ${iml_schema}.evt_repay_flow.tran_cd is '交易码';
comment on column ${iml_schema}.evt_repay_flow.adv_bf_repay_repay_plan_modif_way_cd is '提前还款前还款计划变更方式代码';
comment on column ${iml_schema}.evt_repay_flow.adv_bf_repay_exp_dt is '提前还款前到期日期';
comment on column ${iml_schema}.evt_repay_flow.nomal_repay_eh_issue_repay_amt is '正常还款每期还款金额';
comment on column ${iml_schema}.evt_repay_flow.stl_teller_id is '结算柜员编号';
comment on column ${iml_schema}.evt_repay_flow.acct_apv_teller_id is '账户审批柜员编号';
comment on column ${iml_schema}.evt_repay_flow.ba_auth_teller_id is '银承授权柜员编号';
comment on column ${iml_schema}.evt_repay_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_repay_flow.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.evt_repay_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_repay_flow.repay_rstrct_cd is '还款约束代码';
comment on column ${iml_schema}.evt_repay_flow.callbk_rs is '回收原因';
comment on column ${iml_schema}.evt_repay_flow.check_entry_code is '对账编码';
comment on column ${iml_schema}.evt_repay_flow.callbk_mode_cd is '回收模式代码';
comment on column ${iml_schema}.evt_repay_flow.revs_dt is '冲正日期';
comment on column ${iml_schema}.evt_repay_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_repay_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_repay_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_repay_flow.etl_timestamp is 'ETL处理时间戳';
