/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wld_dubil_info_mpcsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wld_dubil_info_mpcsf1_tm purge;
drop table ${iml_schema}.agt_wld_dubil_info_mpcsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_wld_dubil_info add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_wld_dubil_info modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wld_dubil_info_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_dubil_info partition for ('mpcsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_dubil_info_mpcsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 内部借据编号
    ,dubil_id -- 借据编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cust_id -- 客户编号
    ,cust_lmt_id -- 客户额度编号
    ,apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,tran_ref_no -- 交易参考号
    ,card_no -- 卡号
    ,renew_effect_dt -- 展期生效日期
    ,loan_rgst_dt -- 贷款注册日期
    ,loan_exp_dt -- 贷款到期日期
    ,appl_tm -- 申请时间
    ,payoff_dt -- 结清日期
    ,adv_termnt_dt -- 提前终止日期
    ,grace_dt_term -- 宽限日期
    ,init_tran_dt -- 原始交易日期
    ,fir_exp_repay_dt -- 首个到期还款日期
    ,last_behav_dt -- 上次行动日期
    ,actv_dt -- 激活日期
    ,curr_ovdue_days -- 当前逾期天数
    ,loan_type_cd -- 贷款类型代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_tot_perds -- 贷款总期数
    ,curr_perds -- 当前期数
    ,surp_perds -- 剩余期数
    ,loan_pric -- 贷款本金
    ,loan_eh_issue_rpbl_pric -- 贷款每期应还本金
    ,loan_fst_rpbl_pric -- 贷款首期应还本金
    ,loan_late_rpbl_pric -- 贷款末期应还本金
    ,loan_tot_comm_fee -- 贷款总手续费
    ,loan_eh_issue_comm_fee -- 贷款每期手续费
    ,loan_fst_comm_fee -- 贷款首期手续费
    ,loan_late_comm_fee -- 贷款末期手续费
    ,loan_acct_bill_pric -- 贷款账单的本金
    ,loan_acct_bill_comm_fee -- 贷款账单手续费
    ,repaid_pric -- 已偿还本金
    ,repaid_int -- 已偿还利息
    ,repaid_fee -- 已偿还费用
    ,loan_curr_tot_bal -- 贷款当前总余额
    ,loan_unexp_bal -- 贷款未到期余额
    ,loan_expd_bal -- 贷款已到期余额
    ,debt_pric -- 欠款本金
    ,debt_int -- 欠款利息
    ,debt_pnlt -- 欠款罚息
    ,loan_unexp_pric -- 贷款未到期本金
    ,loan_expd_pric -- 贷款已到期本金
    ,loan_unexp_comm_fee -- 贷款未到期手续费
    ,loan_expd_comm_fee -- 贷款已到期手续费
    ,currt_repay_amt -- 当期还款金额
    ,adv_repay_amt -- 提前还款金额
    ,init_tran_curr_amt -- 原始交易币种金额
    ,renew_pric_amt -- 展期本金金额
    ,b_renew_eh_issue_rpbl_pric -- 展期前每期应还本金
    ,b_renew_tot_perds -- 展期前总期数
    ,b_renew_loan_fst_rpbl_pric -- 展期前贷款首期应还本金
    ,b_renew_loan_late_rpbl_pric -- 展期前贷款末期应还本金
    ,b_renew_loan_tot_comm_fee -- 展期前贷款总手续费
    ,b_renew_loan_eh_issue_comm_fee -- 展期前贷款每期手续费
    ,b_renew_loan_fst_comm_fee -- 展期前贷款首期手续费
    ,b_renew_loan_late_comm_fee -- 展期前贷款末期手续费
    ,a_renew_fst_comm_fee -- 展期后首期手续费
    ,loan_tot_int -- 贷款总利息
    ,init_loan_tot_int -- 原贷款总利息
    ,exec_int_rat -- 执行利率
    ,pnlt_int_rat -- 罚息利率
    ,comp_int_int_rat -- 复利利率
    ,int_rat_fl_rt -- 利率浮动比例
    ,loan_ovdue_max_perds -- 贷款逾期最大期数
    ,renewd_cnt -- 已展期次数
    ,sotermed_cnt -- 已缩期次数
    ,loan_comm_fee_coll_way_cd -- 贷款手续费收取方式代码
    ,last_behav_type_cd -- 上次行动类型代码
    ,int_accr_base_cd -- 计息基准代码
    ,aging_cd -- 账龄代码
    ,loan_termnt_rs_cd -- 贷款终止原因代码
    ,syn_id -- 银团编号
    ,loan_appl_seq_num -- 贷款申请顺序号
    ,cont_edit_num -- 合同版本号
    ,loan_prod_id -- 贷款产品编号
    ,bank_contri_ratio -- 银行出资比例
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,init_tran_auth_cd -- 原始交易授权码
    ,optimit_lock_edit_num -- 乐观锁版本号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,revo_dt -- 撤销日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_dubil_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_wld_dubil_info_mpcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_wld_dubil_info partition for ('mpcsf1') where 0=1;

-- 2.1 insert data to tm table
-- mpcs_a0ntm_loan-
insert into ${iml_schema}.agt_wld_dubil_info_mpcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 内部借据编号
    ,dubil_id -- 借据编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cust_id -- 客户编号
    ,cust_lmt_id -- 客户额度编号
    ,apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,tran_ref_no -- 交易参考号
    ,card_no -- 卡号
    ,renew_effect_dt -- 展期生效日期
    ,loan_rgst_dt -- 贷款注册日期
    ,loan_exp_dt -- 贷款到期日期
    ,appl_tm -- 申请时间
    ,payoff_dt -- 结清日期
    ,adv_termnt_dt -- 提前终止日期
    ,grace_dt_term -- 宽限日期
    ,init_tran_dt -- 原始交易日期
    ,fir_exp_repay_dt -- 首个到期还款日期
    ,last_behav_dt -- 上次行动日期
    ,actv_dt -- 激活日期
    ,curr_ovdue_days -- 当前逾期天数
    ,loan_type_cd -- 贷款类型代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_tot_perds -- 贷款总期数
    ,curr_perds -- 当前期数
    ,surp_perds -- 剩余期数
    ,loan_pric -- 贷款本金
    ,loan_eh_issue_rpbl_pric -- 贷款每期应还本金
    ,loan_fst_rpbl_pric -- 贷款首期应还本金
    ,loan_late_rpbl_pric -- 贷款末期应还本金
    ,loan_tot_comm_fee -- 贷款总手续费
    ,loan_eh_issue_comm_fee -- 贷款每期手续费
    ,loan_fst_comm_fee -- 贷款首期手续费
    ,loan_late_comm_fee -- 贷款末期手续费
    ,loan_acct_bill_pric -- 贷款账单的本金
    ,loan_acct_bill_comm_fee -- 贷款账单手续费
    ,repaid_pric -- 已偿还本金
    ,repaid_int -- 已偿还利息
    ,repaid_fee -- 已偿还费用
    ,loan_curr_tot_bal -- 贷款当前总余额
    ,loan_unexp_bal -- 贷款未到期余额
    ,loan_expd_bal -- 贷款已到期余额
    ,debt_pric -- 欠款本金
    ,debt_int -- 欠款利息
    ,debt_pnlt -- 欠款罚息
    ,loan_unexp_pric -- 贷款未到期本金
    ,loan_expd_pric -- 贷款已到期本金
    ,loan_unexp_comm_fee -- 贷款未到期手续费
    ,loan_expd_comm_fee -- 贷款已到期手续费
    ,currt_repay_amt -- 当期还款金额
    ,adv_repay_amt -- 提前还款金额
    ,init_tran_curr_amt -- 原始交易币种金额
    ,renew_pric_amt -- 展期本金金额
    ,b_renew_eh_issue_rpbl_pric -- 展期前每期应还本金
    ,b_renew_tot_perds -- 展期前总期数
    ,b_renew_loan_fst_rpbl_pric -- 展期前贷款首期应还本金
    ,b_renew_loan_late_rpbl_pric -- 展期前贷款末期应还本金
    ,b_renew_loan_tot_comm_fee -- 展期前贷款总手续费
    ,b_renew_loan_eh_issue_comm_fee -- 展期前贷款每期手续费
    ,b_renew_loan_fst_comm_fee -- 展期前贷款首期手续费
    ,b_renew_loan_late_comm_fee -- 展期前贷款末期手续费
    ,a_renew_fst_comm_fee -- 展期后首期手续费
    ,loan_tot_int -- 贷款总利息
    ,init_loan_tot_int -- 原贷款总利息
    ,exec_int_rat -- 执行利率
    ,pnlt_int_rat -- 罚息利率
    ,comp_int_int_rat -- 复利利率
    ,int_rat_fl_rt -- 利率浮动比例
    ,loan_ovdue_max_perds -- 贷款逾期最大期数
    ,renewd_cnt -- 已展期次数
    ,sotermed_cnt -- 已缩期次数
    ,loan_comm_fee_coll_way_cd -- 贷款手续费收取方式代码
    ,last_behav_type_cd -- 上次行动类型代码
    ,int_accr_base_cd -- 计息基准代码
    ,aging_cd -- 账龄代码
    ,loan_termnt_rs_cd -- 贷款终止原因代码
    ,syn_id -- 银团编号
    ,loan_appl_seq_num -- 贷款申请顺序号
    ,cont_edit_num -- 合同版本号
    ,loan_prod_id -- 贷款产品编号
    ,bank_contri_ratio -- 银行出资比例
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,init_tran_auth_cd -- 原始交易授权码
    ,optimit_lock_edit_num -- 乐观锁版本号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,revo_dt -- 撤销日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222650'||TO_CHAR(P1.LOAN_ID) -- 协议编号
    ,'9999' -- 法人编号
    ,P1.LOAN_ID -- 内部借据编号
    ,P1.LOAN_RECEIPT_NBR -- 借据编号
    ,TO_CHAR(P1.ACCT_NO) -- 账户编号
    ,NVL(TRIM(P1.ACCT_TYPE),'-') -- 账户类型代码
    ,NVL(TRIM(P3.CBSCUSTNO),' ') -- 客户编号
    ,P2.CUST_LIMIT_ID -- 客户额度编号
    ,P2.DD_BANK_ACCT_NO -- 约定还款扣款账号
    ,P1.REF_NBR -- 交易参考号
    ,P1.CARD_NO -- 卡号
    ,P1.resch_date -- 展期生效日期
    ,P1.REGISTER_DATE -- 贷款注册日期
    ,P1.LOAN_EXPIRE_DATE -- 贷款到期日期
    ,to_timestamp(to_char(P1.REQUEST_TIME,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD HH24:MI:SS.ff6') -- 申请时间
    ,P1.PAID_OUT_DATE -- 结清日期
    ,P1.TERMINATE_DATE -- 提前终止日期
    ,P1.GRACE_DATE -- 宽限日期
    ,P1.ORIG_TRANS_DATE -- 原始交易日期
    ,P1.FIRST_BILL_DATE -- 首个到期还款日期
    ,P1.LAST_ACTION_DATE -- 上次行动日期
    ,P1.ACTIVATE_DATE -- 激活日期
    ,P1.DUE_DAYS -- 当前逾期天数
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.LOAN_TYPE END -- 贷款类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.LOAN_STATUS END -- 贷款状态代码
    ,P1.LOAN_INIT_TERM -- 贷款总期数
    ,P1.CURR_TERM -- 当前期数
    ,P1.REMAIN_TERM -- 剩余期数
    ,P1.LOAN_INIT_PRIN -- 贷款本金
    ,P1.LOAN_FIXED_PMT_PRIN -- 贷款每期应还本金
    ,P1.LOAN_FIRST_TERM_PRIN -- 贷款首期应还本金
    ,P1.LOAN_FINAL_TERM_PRIN -- 贷款末期应还本金
    ,P1.LOAN_INIT_FEE1 -- 贷款总手续费
    ,P1.LOAN_FIXED_FEE1 -- 贷款每期手续费
    ,P1.LOAN_FIRST_TERM_FEE1 -- 贷款首期手续费
    ,P1.LOAN_FINAL_TERM_FEE1 -- 贷款末期手续费
    ,P1.UNEARNED_PRIN -- 贷款账单的本金
    ,P1.UNEARNED_FEE1 -- 贷款账单手续费
    ,P1.PRIN_PAID -- 已偿还本金
    ,P1.INT_PAID -- 已偿还利息
    ,P1.FEE_PAID -- 已偿还费用
    ,P1.LOAN_CURR_BAL -- 贷款当前总余额
    ,P1.LOAN_BAL_XFROUT -- 贷款未到期余额
    ,P1.LOAN_BAL_XFRIN -- 贷款已到期余额
    ,P1.LOAN_BAL_PRINCIPAL -- 欠款本金
    ,P1.LOAN_BAL_INTEREST -- 欠款利息
    ,P1.LOAN_BAL_PENALTY -- 欠款罚息
    ,P1.LOAN_PRIN_XFROUT -- 贷款未到期本金
    ,P1.LOAN_PRIN_XFRIN -- 贷款已到期本金
    ,P1.LOAN_FEE1_XFROUT -- 贷款未到期手续费
    ,P1.LOAN_FEE1_XFRIN -- 贷款已到期手续费
    ,P1.CTD_PAYMENT_AMT -- 当期还款金额
    ,P1.ADV_PMT_AMT -- 提前还款金额
    ,P1.ORIG_TXN_AMT -- 原始交易币种金额
    ,P1.RESCH_INIT_PRIN -- 展期本金金额
    ,P1.BEF_RESCH_FIXED_PMT_PRIN -- 展期前每期应还本金
    ,P1.BEF_RESCH_INIT_TERM -- 展期前总期数
    ,P1.BEF_RESCH_FIRST_TERM_PRIN -- 展期前贷款首期应还本金
    ,P1.BEF_RESCH_FINAL_TERM_PRIN -- 展期前贷款末期应还本金
    ,P1.BEF_RESCH_INIT_FEE1 -- 展期前贷款总手续费
    ,P1.BEF_RESCH_FIXED_FEE1 -- 展期前贷款每期手续费
    ,P1.BEF_RESCH_FIRST_TERM_FEE1 -- 展期前贷款首期手续费
    ,P1.BEF_RESCH_FINAL_TERM_FEE1 -- 展期前贷款末期手续费
    ,P1.RESCH_FIRST_TERM_FEE1 -- 展期后首期手续费
    ,P1.LOAN_INIT_INTEREST -- 贷款总利息
    ,P1.BEF_INIT_INTEREST -- 原贷款总利息
    ,P1.INTEREST_RATE*100 -- 执行利率
    ,P1.PENALTY_RATE*100 -- 罚息利率
    ,P1.COMPOUND_RATE -- 复利利率
    ,P1.FLOAT_RATE -- 利率浮动比例
    ,TO_NUMBER(TRIM(P1.LOAN_CD)) -- 贷款逾期最大期数
    ,P1.PAST_RESCH_CNT -- 已展期次数
    ,P1.PAST_SHORTED_CNT -- 已缩期次数
    ,NVL(TRIM(P1.LOAN_FEE_METHOD),'-') -- 贷款手续费收取方式代码
    ,NVL(TRIM(P1.LAST_ACTION_TYPE),'-') -- 上次行动类型代码
    ,decode(trim(P1.INTEREST_CALC_BASE),'P','-','-') -- 计息基准代码
    ,P1.AGE_CD -- 账龄代码
    ,NVL(TRIM(P1.TERMINATE_REASON_CD),'-') -- 贷款终止原因代码
    ,P1.BANK_GROUP_ID -- 银团编号
    ,TO_CHAR(P1.REGISTER_ID) -- 贷款申请顺序号
    ,P1.CONTRACT_VER -- 合同版本号
    ,P1.LOAN_CODE -- 贷款产品编号
    ,P1.BANK_PROPORTION -- 银行出资比例
    ,P1.BATCHFILENAME -- 批量文件名称
    ,P1.SEQNO -- 序列号
    ,P1.ORIG_AUTH_CODE -- 原始交易授权码
    ,TO_CHAR(P1.JPA_VERSION) -- 乐观锁版本号
    ,NVL(TRIM(P1.THREE_TYPE_CD),'XXX') -- 资产三分类代码
    ,P1.CANCEL_DATE -- 撤销日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a0ntm_loan' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a0ntm_loan p1
    left join ${iol_schema}.mpcs_a0ntm_account p2 on P1.ACCT_NO = P2.ACCT_NO AND P1.ACCT_TYPE = P2.ACCT_TYPE AND P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iol_schema}.mpcs_a0ntm_customer p3 on P2.CUST_ID=P3.CUST_ID AND  P3.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P3.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.LOAN_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A0NTM_LOAN'
        AND R2.SRC_FIELD_EN_NAME= 'LOAN_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_WLD_DUBIL_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'LOAN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.LOAN_STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A0NTM_LOAN'
        AND R1.SRC_FIELD_EN_NAME= 'LOAN_STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_WLD_DUBIL_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'LOAN_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wld_dubil_info_mpcsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_wld_dubil_info_mpcsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 内部借据编号
    ,dubil_id -- 借据编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cust_id -- 客户编号
    ,cust_lmt_id -- 客户额度编号
    ,apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,tran_ref_no -- 交易参考号
    ,card_no -- 卡号
    ,renew_effect_dt -- 展期生效日期
    ,loan_rgst_dt -- 贷款注册日期
    ,loan_exp_dt -- 贷款到期日期
    ,appl_tm -- 申请时间
    ,payoff_dt -- 结清日期
    ,adv_termnt_dt -- 提前终止日期
    ,grace_dt_term -- 宽限日期
    ,init_tran_dt -- 原始交易日期
    ,fir_exp_repay_dt -- 首个到期还款日期
    ,last_behav_dt -- 上次行动日期
    ,actv_dt -- 激活日期
    ,curr_ovdue_days -- 当前逾期天数
    ,loan_type_cd -- 贷款类型代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_tot_perds -- 贷款总期数
    ,curr_perds -- 当前期数
    ,surp_perds -- 剩余期数
    ,loan_pric -- 贷款本金
    ,loan_eh_issue_rpbl_pric -- 贷款每期应还本金
    ,loan_fst_rpbl_pric -- 贷款首期应还本金
    ,loan_late_rpbl_pric -- 贷款末期应还本金
    ,loan_tot_comm_fee -- 贷款总手续费
    ,loan_eh_issue_comm_fee -- 贷款每期手续费
    ,loan_fst_comm_fee -- 贷款首期手续费
    ,loan_late_comm_fee -- 贷款末期手续费
    ,loan_acct_bill_pric -- 贷款账单的本金
    ,loan_acct_bill_comm_fee -- 贷款账单手续费
    ,repaid_pric -- 已偿还本金
    ,repaid_int -- 已偿还利息
    ,repaid_fee -- 已偿还费用
    ,loan_curr_tot_bal -- 贷款当前总余额
    ,loan_unexp_bal -- 贷款未到期余额
    ,loan_expd_bal -- 贷款已到期余额
    ,debt_pric -- 欠款本金
    ,debt_int -- 欠款利息
    ,debt_pnlt -- 欠款罚息
    ,loan_unexp_pric -- 贷款未到期本金
    ,loan_expd_pric -- 贷款已到期本金
    ,loan_unexp_comm_fee -- 贷款未到期手续费
    ,loan_expd_comm_fee -- 贷款已到期手续费
    ,currt_repay_amt -- 当期还款金额
    ,adv_repay_amt -- 提前还款金额
    ,init_tran_curr_amt -- 原始交易币种金额
    ,renew_pric_amt -- 展期本金金额
    ,b_renew_eh_issue_rpbl_pric -- 展期前每期应还本金
    ,b_renew_tot_perds -- 展期前总期数
    ,b_renew_loan_fst_rpbl_pric -- 展期前贷款首期应还本金
    ,b_renew_loan_late_rpbl_pric -- 展期前贷款末期应还本金
    ,b_renew_loan_tot_comm_fee -- 展期前贷款总手续费
    ,b_renew_loan_eh_issue_comm_fee -- 展期前贷款每期手续费
    ,b_renew_loan_fst_comm_fee -- 展期前贷款首期手续费
    ,b_renew_loan_late_comm_fee -- 展期前贷款末期手续费
    ,a_renew_fst_comm_fee -- 展期后首期手续费
    ,loan_tot_int -- 贷款总利息
    ,init_loan_tot_int -- 原贷款总利息
    ,exec_int_rat -- 执行利率
    ,pnlt_int_rat -- 罚息利率
    ,comp_int_int_rat -- 复利利率
    ,int_rat_fl_rt -- 利率浮动比例
    ,loan_ovdue_max_perds -- 贷款逾期最大期数
    ,renewd_cnt -- 已展期次数
    ,sotermed_cnt -- 已缩期次数
    ,loan_comm_fee_coll_way_cd -- 贷款手续费收取方式代码
    ,last_behav_type_cd -- 上次行动类型代码
    ,int_accr_base_cd -- 计息基准代码
    ,aging_cd -- 账龄代码
    ,loan_termnt_rs_cd -- 贷款终止原因代码
    ,syn_id -- 银团编号
    ,loan_appl_seq_num -- 贷款申请顺序号
    ,cont_edit_num -- 合同版本号
    ,loan_prod_id -- 贷款产品编号
    ,bank_contri_ratio -- 银行出资比例
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,init_tran_auth_cd -- 原始交易授权码
    ,optimit_lock_edit_num -- 乐观锁版本号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,revo_dt -- 撤销日期
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.intnal_dubil_id, o.intnal_dubil_id) as intnal_dubil_id -- 内部借据编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_lmt_id, o.cust_lmt_id) as cust_lmt_id -- 客户额度编号
    ,nvl(n.apot_repay_deduct_acct_num, o.apot_repay_deduct_acct_num) as apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.renew_effect_dt, o.renew_effect_dt) as renew_effect_dt -- 展期生效日期
    ,nvl(n.loan_rgst_dt, o.loan_rgst_dt) as loan_rgst_dt -- 贷款注册日期
    ,nvl(n.loan_exp_dt, o.loan_exp_dt) as loan_exp_dt -- 贷款到期日期
    ,nvl(n.appl_tm, o.appl_tm) as appl_tm -- 申请时间
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.adv_termnt_dt, o.adv_termnt_dt) as adv_termnt_dt -- 提前终止日期
    ,nvl(n.grace_dt_term, o.grace_dt_term) as grace_dt_term -- 宽限日期
    ,nvl(n.init_tran_dt, o.init_tran_dt) as init_tran_dt -- 原始交易日期
    ,nvl(n.fir_exp_repay_dt, o.fir_exp_repay_dt) as fir_exp_repay_dt -- 首个到期还款日期
    ,nvl(n.last_behav_dt, o.last_behav_dt) as last_behav_dt -- 上次行动日期
    ,nvl(n.actv_dt, o.actv_dt) as actv_dt -- 激活日期
    ,nvl(n.curr_ovdue_days, o.curr_ovdue_days) as curr_ovdue_days -- 当前逾期天数
    ,nvl(n.loan_type_cd, o.loan_type_cd) as loan_type_cd -- 贷款类型代码
    ,nvl(n.loan_status_cd, o.loan_status_cd) as loan_status_cd -- 贷款状态代码
    ,nvl(n.loan_tot_perds, o.loan_tot_perds) as loan_tot_perds -- 贷款总期数
    ,nvl(n.curr_perds, o.curr_perds) as curr_perds -- 当前期数
    ,nvl(n.surp_perds, o.surp_perds) as surp_perds -- 剩余期数
    ,nvl(n.loan_pric, o.loan_pric) as loan_pric -- 贷款本金
    ,nvl(n.loan_eh_issue_rpbl_pric, o.loan_eh_issue_rpbl_pric) as loan_eh_issue_rpbl_pric -- 贷款每期应还本金
    ,nvl(n.loan_fst_rpbl_pric, o.loan_fst_rpbl_pric) as loan_fst_rpbl_pric -- 贷款首期应还本金
    ,nvl(n.loan_late_rpbl_pric, o.loan_late_rpbl_pric) as loan_late_rpbl_pric -- 贷款末期应还本金
    ,nvl(n.loan_tot_comm_fee, o.loan_tot_comm_fee) as loan_tot_comm_fee -- 贷款总手续费
    ,nvl(n.loan_eh_issue_comm_fee, o.loan_eh_issue_comm_fee) as loan_eh_issue_comm_fee -- 贷款每期手续费
    ,nvl(n.loan_fst_comm_fee, o.loan_fst_comm_fee) as loan_fst_comm_fee -- 贷款首期手续费
    ,nvl(n.loan_late_comm_fee, o.loan_late_comm_fee) as loan_late_comm_fee -- 贷款末期手续费
    ,nvl(n.loan_acct_bill_pric, o.loan_acct_bill_pric) as loan_acct_bill_pric -- 贷款账单的本金
    ,nvl(n.loan_acct_bill_comm_fee, o.loan_acct_bill_comm_fee) as loan_acct_bill_comm_fee -- 贷款账单手续费
    ,nvl(n.repaid_pric, o.repaid_pric) as repaid_pric -- 已偿还本金
    ,nvl(n.repaid_int, o.repaid_int) as repaid_int -- 已偿还利息
    ,nvl(n.repaid_fee, o.repaid_fee) as repaid_fee -- 已偿还费用
    ,nvl(n.loan_curr_tot_bal, o.loan_curr_tot_bal) as loan_curr_tot_bal -- 贷款当前总余额
    ,nvl(n.loan_unexp_bal, o.loan_unexp_bal) as loan_unexp_bal -- 贷款未到期余额
    ,nvl(n.loan_expd_bal, o.loan_expd_bal) as loan_expd_bal -- 贷款已到期余额
    ,nvl(n.debt_pric, o.debt_pric) as debt_pric -- 欠款本金
    ,nvl(n.debt_int, o.debt_int) as debt_int -- 欠款利息
    ,nvl(n.debt_pnlt, o.debt_pnlt) as debt_pnlt -- 欠款罚息
    ,nvl(n.loan_unexp_pric, o.loan_unexp_pric) as loan_unexp_pric -- 贷款未到期本金
    ,nvl(n.loan_expd_pric, o.loan_expd_pric) as loan_expd_pric -- 贷款已到期本金
    ,nvl(n.loan_unexp_comm_fee, o.loan_unexp_comm_fee) as loan_unexp_comm_fee -- 贷款未到期手续费
    ,nvl(n.loan_expd_comm_fee, o.loan_expd_comm_fee) as loan_expd_comm_fee -- 贷款已到期手续费
    ,nvl(n.currt_repay_amt, o.currt_repay_amt) as currt_repay_amt -- 当期还款金额
    ,nvl(n.adv_repay_amt, o.adv_repay_amt) as adv_repay_amt -- 提前还款金额
    ,nvl(n.init_tran_curr_amt, o.init_tran_curr_amt) as init_tran_curr_amt -- 原始交易币种金额
    ,nvl(n.renew_pric_amt, o.renew_pric_amt) as renew_pric_amt -- 展期本金金额
    ,nvl(n.b_renew_eh_issue_rpbl_pric, o.b_renew_eh_issue_rpbl_pric) as b_renew_eh_issue_rpbl_pric -- 展期前每期应还本金
    ,nvl(n.b_renew_tot_perds, o.b_renew_tot_perds) as b_renew_tot_perds -- 展期前总期数
    ,nvl(n.b_renew_loan_fst_rpbl_pric, o.b_renew_loan_fst_rpbl_pric) as b_renew_loan_fst_rpbl_pric -- 展期前贷款首期应还本金
    ,nvl(n.b_renew_loan_late_rpbl_pric, o.b_renew_loan_late_rpbl_pric) as b_renew_loan_late_rpbl_pric -- 展期前贷款末期应还本金
    ,nvl(n.b_renew_loan_tot_comm_fee, o.b_renew_loan_tot_comm_fee) as b_renew_loan_tot_comm_fee -- 展期前贷款总手续费
    ,nvl(n.b_renew_loan_eh_issue_comm_fee, o.b_renew_loan_eh_issue_comm_fee) as b_renew_loan_eh_issue_comm_fee -- 展期前贷款每期手续费
    ,nvl(n.b_renew_loan_fst_comm_fee, o.b_renew_loan_fst_comm_fee) as b_renew_loan_fst_comm_fee -- 展期前贷款首期手续费
    ,nvl(n.b_renew_loan_late_comm_fee, o.b_renew_loan_late_comm_fee) as b_renew_loan_late_comm_fee -- 展期前贷款末期手续费
    ,nvl(n.a_renew_fst_comm_fee, o.a_renew_fst_comm_fee) as a_renew_fst_comm_fee -- 展期后首期手续费
    ,nvl(n.loan_tot_int, o.loan_tot_int) as loan_tot_int -- 贷款总利息
    ,nvl(n.init_loan_tot_int, o.init_loan_tot_int) as init_loan_tot_int -- 原贷款总利息
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.pnlt_int_rat, o.pnlt_int_rat) as pnlt_int_rat -- 罚息利率
    ,nvl(n.comp_int_int_rat, o.comp_int_int_rat) as comp_int_int_rat -- 复利利率
    ,nvl(n.int_rat_fl_rt, o.int_rat_fl_rt) as int_rat_fl_rt -- 利率浮动比例
    ,nvl(n.loan_ovdue_max_perds, o.loan_ovdue_max_perds) as loan_ovdue_max_perds -- 贷款逾期最大期数
    ,nvl(n.renewd_cnt, o.renewd_cnt) as renewd_cnt -- 已展期次数
    ,nvl(n.sotermed_cnt, o.sotermed_cnt) as sotermed_cnt -- 已缩期次数
    ,nvl(n.loan_comm_fee_coll_way_cd, o.loan_comm_fee_coll_way_cd) as loan_comm_fee_coll_way_cd -- 贷款手续费收取方式代码
    ,nvl(n.last_behav_type_cd, o.last_behav_type_cd) as last_behav_type_cd -- 上次行动类型代码
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.aging_cd, o.aging_cd) as aging_cd -- 账龄代码
    ,nvl(n.loan_termnt_rs_cd, o.loan_termnt_rs_cd) as loan_termnt_rs_cd -- 贷款终止原因代码
    ,nvl(n.syn_id, o.syn_id) as syn_id -- 银团编号
    ,nvl(n.loan_appl_seq_num, o.loan_appl_seq_num) as loan_appl_seq_num -- 贷款申请顺序号
    ,nvl(n.cont_edit_num, o.cont_edit_num) as cont_edit_num -- 合同版本号
    ,nvl(n.loan_prod_id, o.loan_prod_id) as loan_prod_id -- 贷款产品编号
    ,nvl(n.bank_contri_ratio, o.bank_contri_ratio) as bank_contri_ratio -- 银行出资比例
    ,nvl(n.batch_doc_name, o.batch_doc_name) as batch_doc_name -- 批量文件名称
    ,nvl(n.ser_num, o.ser_num) as ser_num -- 序列号
    ,nvl(n.init_tran_auth_cd, o.init_tran_auth_cd) as init_tran_auth_cd -- 原始交易授权码
    ,nvl(n.optimit_lock_edit_num, o.optimit_lock_edit_num) as optimit_lock_edit_num -- 乐观锁版本号
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.revo_dt, o.revo_dt) as revo_dt -- 撤销日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.intnal_dubil_id <> n.intnal_dubil_id
                or o.dubil_id <> n.dubil_id
                or o.acct_id <> n.acct_id
                or o.acct_type_cd <> n.acct_type_cd
                or o.cust_id <> n.cust_id
                or o.cust_lmt_id <> n.cust_lmt_id
                or o.apot_repay_deduct_acct_num <> n.apot_repay_deduct_acct_num
                or o.tran_ref_no <> n.tran_ref_no
                or o.card_no <> n.card_no
                or o.renew_effect_dt <> n.renew_effect_dt
                or o.loan_rgst_dt <> n.loan_rgst_dt
                or o.loan_exp_dt <> n.loan_exp_dt
                or o.appl_tm <> n.appl_tm
                or o.payoff_dt <> n.payoff_dt
                or o.adv_termnt_dt <> n.adv_termnt_dt
                or o.grace_dt_term <> n.grace_dt_term
                or o.init_tran_dt <> n.init_tran_dt
                or o.fir_exp_repay_dt <> n.fir_exp_repay_dt
                or o.last_behav_dt <> n.last_behav_dt
                or o.actv_dt <> n.actv_dt
                or o.curr_ovdue_days <> n.curr_ovdue_days
                or o.loan_type_cd <> n.loan_type_cd
                or o.loan_status_cd <> n.loan_status_cd
                or o.loan_tot_perds <> n.loan_tot_perds
                or o.curr_perds <> n.curr_perds
                or o.surp_perds <> n.surp_perds
                or o.loan_pric <> n.loan_pric
                or o.loan_eh_issue_rpbl_pric <> n.loan_eh_issue_rpbl_pric
                or o.loan_fst_rpbl_pric <> n.loan_fst_rpbl_pric
                or o.loan_late_rpbl_pric <> n.loan_late_rpbl_pric
                or o.loan_tot_comm_fee <> n.loan_tot_comm_fee
                or o.loan_eh_issue_comm_fee <> n.loan_eh_issue_comm_fee
                or o.loan_fst_comm_fee <> n.loan_fst_comm_fee
                or o.loan_late_comm_fee <> n.loan_late_comm_fee
                or o.loan_acct_bill_pric <> n.loan_acct_bill_pric
                or o.loan_acct_bill_comm_fee <> n.loan_acct_bill_comm_fee
                or o.repaid_pric <> n.repaid_pric
                or o.repaid_int <> n.repaid_int
                or o.repaid_fee <> n.repaid_fee
                or o.loan_curr_tot_bal <> n.loan_curr_tot_bal
                or o.loan_unexp_bal <> n.loan_unexp_bal
                or o.loan_expd_bal <> n.loan_expd_bal
                or o.debt_pric <> n.debt_pric
                or o.debt_int <> n.debt_int
                or o.debt_pnlt <> n.debt_pnlt
                or o.loan_unexp_pric <> n.loan_unexp_pric
                or o.loan_expd_pric <> n.loan_expd_pric
                or o.loan_unexp_comm_fee <> n.loan_unexp_comm_fee
                or o.loan_expd_comm_fee <> n.loan_expd_comm_fee
                or o.currt_repay_amt <> n.currt_repay_amt
                or o.adv_repay_amt <> n.adv_repay_amt
                or o.init_tran_curr_amt <> n.init_tran_curr_amt
                or o.renew_pric_amt <> n.renew_pric_amt
                or o.b_renew_eh_issue_rpbl_pric <> n.b_renew_eh_issue_rpbl_pric
                or o.b_renew_tot_perds <> n.b_renew_tot_perds
                or o.b_renew_loan_fst_rpbl_pric <> n.b_renew_loan_fst_rpbl_pric
                or o.b_renew_loan_late_rpbl_pric <> n.b_renew_loan_late_rpbl_pric
                or o.b_renew_loan_tot_comm_fee <> n.b_renew_loan_tot_comm_fee
                or o.b_renew_loan_eh_issue_comm_fee <> n.b_renew_loan_eh_issue_comm_fee
                or o.b_renew_loan_fst_comm_fee <> n.b_renew_loan_fst_comm_fee
                or o.b_renew_loan_late_comm_fee <> n.b_renew_loan_late_comm_fee
                or o.a_renew_fst_comm_fee <> n.a_renew_fst_comm_fee
                or o.loan_tot_int <> n.loan_tot_int
                or o.init_loan_tot_int <> n.init_loan_tot_int
                or o.exec_int_rat <> n.exec_int_rat
                or o.pnlt_int_rat <> n.pnlt_int_rat
                or o.comp_int_int_rat <> n.comp_int_int_rat
                or o.int_rat_fl_rt <> n.int_rat_fl_rt
                or o.loan_ovdue_max_perds <> n.loan_ovdue_max_perds
                or o.renewd_cnt <> n.renewd_cnt
                or o.sotermed_cnt <> n.sotermed_cnt
                or o.loan_comm_fee_coll_way_cd <> n.loan_comm_fee_coll_way_cd
                or o.last_behav_type_cd <> n.last_behav_type_cd
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.aging_cd <> n.aging_cd
                or o.loan_termnt_rs_cd <> n.loan_termnt_rs_cd
                or o.syn_id <> n.syn_id
                or o.loan_appl_seq_num <> n.loan_appl_seq_num
                or o.cont_edit_num <> n.cont_edit_num
                or o.loan_prod_id <> n.loan_prod_id
                or o.bank_contri_ratio <> n.bank_contri_ratio
                or o.batch_doc_name <> n.batch_doc_name
                or o.ser_num <> n.ser_num
                or o.init_tran_auth_cd <> n.init_tran_auth_cd
                or o.optimit_lock_edit_num <> n.optimit_lock_edit_num
                or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
                or o.revo_dt <> n.revo_dt
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_dubil_info_mpcsf1_tm n
    full join ${iml_schema}.agt_wld_dubil_info_mpcsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_wld_dubil_info truncate partition for ('mpcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_wld_dubil_info exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.agt_wld_dubil_info_mpcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_wld_dubil_info drop subpartition p_mpcsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wld_dubil_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_wld_dubil_info_mpcsf1_tm purge;
drop table ${iml_schema}.agt_wld_dubil_info_mpcsf1_ex purge;
drop table ${iml_schema}.agt_wld_dubil_info_mpcsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wld_dubil_info', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);