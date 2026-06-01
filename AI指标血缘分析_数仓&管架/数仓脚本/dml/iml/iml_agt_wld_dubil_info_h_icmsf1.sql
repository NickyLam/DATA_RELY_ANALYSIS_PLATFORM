/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wld_dubil_info_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_wld_dubil_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wld_dubil_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_dubil_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_wld_dubil_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_wld_dubil_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_wld_dubil_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_dubil_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
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
    ,init_tran_auth_cd -- 原始交易授权码
    ,optimit_lock_edit_num -- 乐观锁版本号
    ,revo_dt -- 撤销日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_dubil_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_wld_dubil_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_dubil_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_wld_dubil_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_dubil_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_wld_tm_loan-1
insert into ${iml_schema}.agt_wld_dubil_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
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
    ,init_tran_auth_cd -- 原始交易授权码
    ,optimit_lock_edit_num -- 乐观锁版本号
    ,revo_dt -- 撤销日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222650'||TO_CHAR(P1.LOANID) -- 协议编号
    ,'9999' -- 法人编号
    ,P1.PRODUCTID -- 产品编号
    ,TO_CHAR(P1.LOANID) -- 内部借据编号
    ,P1.LOANRECEIPTNBR -- 借据编号
    ,TO_CHAR(P1.ACCTNO) -- 账户编号
    ,NVL(TRIM(P1.ACCTTYPE),'-') -- 账户类型代码
    ,P1.CUSTOMERID -- 客户编号
    ,TO_CHAR(P2.CUSTLIMITID) -- 客户额度编号
    ,P2.DDBANKACCTNO -- 约定还款扣款账号
    ,P1.REFNBR -- 交易参考号
    ,P1.CARDNO -- 卡号
    ,P1.RESCHDATE -- 展期生效日期
    ,P1.REGISTERDATE -- 贷款注册日期
    ,P1.LOANEXPIREDATE -- 贷款到期日期
    ,${iml_schema}.TIMEFORMAT_MIN(P1.REQUESTTIME) -- 申请时间
    ,P1.PAIDOUTDATE -- 结清日期
    ,P1.TERMINATEDATE -- 提前终止日期
    ,P1.GRACEDATE -- 宽限日期
    ,P1.ORIGTRANSDATE -- 原始交易日期
    ,P1.FIRSTBILLDATE -- 首个到期还款日期
    ,P1.LASTACTIONDATE -- 上次行动日期
    ,P1.ACTIVATEDATE -- 激活日期
    ,P1.DUEDAYS -- 当前逾期天数
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.LOANTYPE END -- 贷款类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.LOANSTATUS END -- 贷款状态代码
    ,P1.LOANINITTERM -- 贷款总期数
    ,P1.CURRTERM -- 当前期数
    ,P1.REMAINTERM -- 剩余期数
    ,P1.LOANINITPRIN -- 贷款本金
    ,P1.LOANFIXEDPMTPRIN -- 贷款每期应还本金
    ,P1.LOANFIRSTTERMPRIN -- 贷款首期应还本金
    ,P1.LOANFINALTERMPRIN -- 贷款末期应还本金
    ,P1.LOANINITFEE1 -- 贷款总手续费
    ,P1.LOANFIXEDFEE1 -- 贷款每期手续费
    ,P1.LOANFIRSTTERMFEE1 -- 贷款首期手续费
    ,P1.LOANFINALTERMFEE1 -- 贷款末期手续费
    ,P1.UNEARNEDPRIN -- 贷款账单的本金
    ,P1.UNEARNEDFEE1 -- 贷款账单手续费
    ,P1.PRINPAID -- 已偿还本金
    ,P1.INTEGERPAID -- 已偿还利息
    ,P1.FEEPAID -- 已偿还费用
    ,P1.LOANCURRBAL -- 贷款当前总余额
    ,P1.LOANBALXFROUT -- 贷款未到期余额
    ,P1.LOANBALXFRIN -- 贷款已到期余额
    ,P1.LOANBALPRINCIPAL -- 欠款本金
    ,P1.LOANBALINTEGEREREST -- 欠款利息
    ,P1.LOANBALPENALTY -- 欠款罚息
    ,P1.LOANPRINXFROUT -- 贷款未到期本金
    ,P1.LOANPRINXFRIN -- 贷款已到期本金
    ,P1.LOANFEE1XFROUT -- 贷款未到期手续费
    ,P1.LOANFEE1XFRIN -- 贷款已到期手续费
    ,P1.CTDPAYMENTAMT -- 当期还款金额
    ,P1.ADVPMTAMT -- 提前还款金额
    ,P1.ORIGTXNAMT -- 原始交易币种金额
    ,P1.RESCHINITPRIN -- 展期本金金额
    ,P1.BEFRESCHFIXEDPMTPRIN -- 展期前每期应还本金
    ,P1.BEFRESCHINITTERM -- 展期前总期数
    ,P1.BEFRESCHFIRSTTERMPRIN -- 展期前贷款首期应还本金
    ,P1.BEFRESCHFINALTERMPRIN -- 展期前贷款末期应还本金
    ,P1.BEFRESCHINITFEE1 -- 展期前贷款总手续费
    ,P1.BEFRESCHFIXEDFEE1 -- 展期前贷款每期手续费
    ,P1.BEFRESCHFIRSTTERMFEE1 -- 展期前贷款首期手续费
    ,P1.BEFRESCHFINALTERMFEE1 -- 展期前贷款末期手续费
    ,P1.RESCHFIRSTTERMFEE1 -- 展期后首期手续费
    ,P1.LOANINITINTEGEREREST -- 贷款总利息
    ,P1.BEFINITINTEGEREREST -- 原贷款总利息
    ,P1.INTEGERERESTRATE -- 执行利率
    ,P1.PENALTYRATE -- 罚息利率
    ,P1.COMPOUNDRATE -- 复利利率
    ,P1.FLOATRATE -- 利率浮动比例
    ,NVL(TRIM(P1.LOANCD),0) -- 贷款逾期最大期数
    ,P1.PASTRESCHCNT -- 已展期次数
    ,P1.PASTSHORTEDCNT -- 已缩期次数
    ,NVL(TRIM(P1.LOANFEEMETHOD),'-') -- 贷款手续费收取方式代码
    ,NVL(TRIM(P1.LASTACTIONTYPE),'-') -- 上次行动类型代码
    ,NVL(TRIM(P1.INTEGERERESTCALCBASE),'-') -- 计息基准代码
    ,NVL(TRIM(P1.AGECD),'-') -- 账龄代码
    ,NVL(TRIM(P1.TERMINATEREASONCD),'-') -- 贷款终止原因代码
    ,P1.BANKGROUPID -- 银团编号
    ,TO_CHAR(P1.REGISTERID) -- 贷款申请顺序号
    ,P1.CONTRACTVER -- 合同版本号
    ,P1.LOANCODE -- 贷款产品编号
    ,P1.BANKPROPORTION -- 银行出资比例
    ,P1.ORIGAUTHCODE -- 原始交易授权码
    ,TO_CHAR(P1.JPAVERSION) -- 乐观锁版本号
    ,P1.CANCELDATE -- 撤销日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wld_tm_loan' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wld_tm_loan p1
    left join ${iol_schema}.icms_wld_tm_account p2 on P1.ACCTNO = P2.ACCTNO AND P1.ACCTTYPE = P2.ACCTTYPE 
AND P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.LOANTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_WLD_TM_LOAN'
        AND R1.SRC_FIELD_EN_NAME= 'LOANTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_WLD_DUBIL_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'LOAN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.LOANSTATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_WLD_TM_LOAN'
        AND R2.SRC_FIELD_EN_NAME= 'LOANSTATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_WLD_DUBIL_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'LOAN_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wld_dubil_info_h_icmsf1_tm 
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wld_dubil_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
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
    ,init_tran_auth_cd -- 原始交易授权码
    ,optimit_lock_edit_num -- 乐观锁版本号
    ,revo_dt -- 撤销日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wld_dubil_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
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
    ,init_tran_auth_cd -- 原始交易授权码
    ,optimit_lock_edit_num -- 乐观锁版本号
    ,revo_dt -- 撤销日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
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
    ,nvl(n.init_tran_auth_cd, o.init_tran_auth_cd) as init_tran_auth_cd -- 原始交易授权码
    ,nvl(n.optimit_lock_edit_num, o.optimit_lock_edit_num) as optimit_lock_edit_num -- 乐观锁版本号
    ,nvl(n.revo_dt, o.revo_dt) as revo_dt -- 撤销日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_dubil_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_wld_dubil_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.prod_id <> n.prod_id
        or o.intnal_dubil_id <> n.intnal_dubil_id
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
        or o.init_tran_auth_cd <> n.init_tran_auth_cd
        or o.optimit_lock_edit_num <> n.optimit_lock_edit_num
        or o.revo_dt <> n.revo_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wld_dubil_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
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
    ,init_tran_auth_cd -- 原始交易授权码
    ,optimit_lock_edit_num -- 乐观锁版本号
    ,revo_dt -- 撤销日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wld_dubil_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
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
    ,init_tran_auth_cd -- 原始交易授权码
    ,optimit_lock_edit_num -- 乐观锁版本号
    ,revo_dt -- 撤销日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.prod_id -- 产品编号
    ,o.intnal_dubil_id -- 内部借据编号
    ,o.dubil_id -- 借据编号
    ,o.acct_id -- 账户编号
    ,o.acct_type_cd -- 账户类型代码
    ,o.cust_id -- 客户编号
    ,o.cust_lmt_id -- 客户额度编号
    ,o.apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,o.tran_ref_no -- 交易参考号
    ,o.card_no -- 卡号
    ,o.renew_effect_dt -- 展期生效日期
    ,o.loan_rgst_dt -- 贷款注册日期
    ,o.loan_exp_dt -- 贷款到期日期
    ,o.appl_tm -- 申请时间
    ,o.payoff_dt -- 结清日期
    ,o.adv_termnt_dt -- 提前终止日期
    ,o.grace_dt_term -- 宽限日期
    ,o.init_tran_dt -- 原始交易日期
    ,o.fir_exp_repay_dt -- 首个到期还款日期
    ,o.last_behav_dt -- 上次行动日期
    ,o.actv_dt -- 激活日期
    ,o.curr_ovdue_days -- 当前逾期天数
    ,o.loan_type_cd -- 贷款类型代码
    ,o.loan_status_cd -- 贷款状态代码
    ,o.loan_tot_perds -- 贷款总期数
    ,o.curr_perds -- 当前期数
    ,o.surp_perds -- 剩余期数
    ,o.loan_pric -- 贷款本金
    ,o.loan_eh_issue_rpbl_pric -- 贷款每期应还本金
    ,o.loan_fst_rpbl_pric -- 贷款首期应还本金
    ,o.loan_late_rpbl_pric -- 贷款末期应还本金
    ,o.loan_tot_comm_fee -- 贷款总手续费
    ,o.loan_eh_issue_comm_fee -- 贷款每期手续费
    ,o.loan_fst_comm_fee -- 贷款首期手续费
    ,o.loan_late_comm_fee -- 贷款末期手续费
    ,o.loan_acct_bill_pric -- 贷款账单的本金
    ,o.loan_acct_bill_comm_fee -- 贷款账单手续费
    ,o.repaid_pric -- 已偿还本金
    ,o.repaid_int -- 已偿还利息
    ,o.repaid_fee -- 已偿还费用
    ,o.loan_curr_tot_bal -- 贷款当前总余额
    ,o.loan_unexp_bal -- 贷款未到期余额
    ,o.loan_expd_bal -- 贷款已到期余额
    ,o.debt_pric -- 欠款本金
    ,o.debt_int -- 欠款利息
    ,o.debt_pnlt -- 欠款罚息
    ,o.loan_unexp_pric -- 贷款未到期本金
    ,o.loan_expd_pric -- 贷款已到期本金
    ,o.loan_unexp_comm_fee -- 贷款未到期手续费
    ,o.loan_expd_comm_fee -- 贷款已到期手续费
    ,o.currt_repay_amt -- 当期还款金额
    ,o.adv_repay_amt -- 提前还款金额
    ,o.init_tran_curr_amt -- 原始交易币种金额
    ,o.renew_pric_amt -- 展期本金金额
    ,o.b_renew_eh_issue_rpbl_pric -- 展期前每期应还本金
    ,o.b_renew_tot_perds -- 展期前总期数
    ,o.b_renew_loan_fst_rpbl_pric -- 展期前贷款首期应还本金
    ,o.b_renew_loan_late_rpbl_pric -- 展期前贷款末期应还本金
    ,o.b_renew_loan_tot_comm_fee -- 展期前贷款总手续费
    ,o.b_renew_loan_eh_issue_comm_fee -- 展期前贷款每期手续费
    ,o.b_renew_loan_fst_comm_fee -- 展期前贷款首期手续费
    ,o.b_renew_loan_late_comm_fee -- 展期前贷款末期手续费
    ,o.a_renew_fst_comm_fee -- 展期后首期手续费
    ,o.loan_tot_int -- 贷款总利息
    ,o.init_loan_tot_int -- 原贷款总利息
    ,o.exec_int_rat -- 执行利率
    ,o.pnlt_int_rat -- 罚息利率
    ,o.comp_int_int_rat -- 复利利率
    ,o.int_rat_fl_rt -- 利率浮动比例
    ,o.loan_ovdue_max_perds -- 贷款逾期最大期数
    ,o.renewd_cnt -- 已展期次数
    ,o.sotermed_cnt -- 已缩期次数
    ,o.loan_comm_fee_coll_way_cd -- 贷款手续费收取方式代码
    ,o.last_behav_type_cd -- 上次行动类型代码
    ,o.int_accr_base_cd -- 计息基准代码
    ,o.aging_cd -- 账龄代码
    ,o.loan_termnt_rs_cd -- 贷款终止原因代码
    ,o.syn_id -- 银团编号
    ,o.loan_appl_seq_num -- 贷款申请顺序号
    ,o.cont_edit_num -- 合同版本号
    ,o.loan_prod_id -- 贷款产品编号
    ,o.bank_contri_ratio -- 银行出资比例
    ,o.init_tran_auth_cd -- 原始交易授权码
    ,o.optimit_lock_edit_num -- 乐观锁版本号
    ,o.revo_dt -- 撤销日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_dubil_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_wld_dubil_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_wld_dubil_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_wld_dubil_info_h;
--alter table ${iml_schema}.agt_wld_dubil_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_wld_dubil_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_wld_dubil_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_wld_dubil_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_wld_dubil_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wld_dubil_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_wld_dubil_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_wld_dubil_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wld_dubil_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wld_dubil_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_wld_dubil_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_wld_dubil_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_wld_dubil_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wld_dubil_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
