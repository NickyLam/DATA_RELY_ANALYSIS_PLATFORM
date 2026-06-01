/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_crps_agt_wld_dubil_info
CreateDate: 20230608
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.crps_agt_wld_dubil_info drop partition p_${last_date};
alter table ${idl_schema}.crps_agt_wld_dubil_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_agt_wld_dubil_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_agt_wld_dubil_info (
etl_dt --数据日期
,agt_id --协议编号
,lp_id --法人编号
,intnal_dubil_id --内部借据编号
,dubil_id --借据编号
,acct_id --账户编号
,acct_type_cd --账户类型代码
,cust_id --客户编号
,cust_lmt_id --客户额度编号
,apot_repay_deduct_acct_num --约定还款扣款账号
,tran_ref_no --交易参考号
,card_no --卡号
,renew_effect_dt --展期生效日期
,loan_rgst_dt --贷款注册日期
,loan_exp_dt --贷款到期日期
,appl_tm --申请时间
,payoff_dt --结清日期
,adv_termnt_dt --提前终止日期
,grace_dt_term --宽限日期
,init_tran_dt --原始交易日期
,fir_exp_repay_dt --首个到期还款日期
,last_behav_dt --上次行动日期
,actv_dt --激活日期
,curr_ovdue_days --当前逾期天数
,loan_type_cd --贷款类型代码
,loan_status_cd --贷款状态代码
,loan_tot_perds --贷款总期数
,curr_perds --当前期数
,surp_perds --剩余期数
,loan_pric --贷款本金
,loan_eh_issue_rpbl_pric --贷款每期应还本金
,loan_fst_rpbl_pric --贷款首期应还本金
,loan_late_rpbl_pric --贷款末期应还本金
,loan_tot_comm_fee --贷款总手续费
,loan_eh_issue_comm_fee --贷款每期手续费
,loan_fst_comm_fee --贷款首期手续费
,loan_late_comm_fee --贷款末期手续费
,loan_acct_bill_pric --贷款账单的本金
,loan_acct_bill_comm_fee --贷款账单手续费
,repaid_pric --已偿还本金
,repaid_int --已偿还利息
,repaid_fee --已偿还费用
,loan_curr_tot_bal --贷款当前总余额
,loan_unexp_bal --贷款未到期余额
,loan_expd_bal --贷款已到期余额
,debt_pric --欠款本金
,debt_int --欠款利息
,debt_pnlt --欠款罚息
,loan_unexp_pric --贷款未到期本金
,loan_expd_pric --贷款已到期本金
,loan_unexp_comm_fee --贷款未到期手续费
,loan_expd_comm_fee --贷款已到期手续费
,currt_repay_amt --当期还款金额
,adv_repay_amt --提前还款金额
,init_tran_curr_amt --原始交易币种金额
,renew_pric_amt --展期本金金额
,b_renew_eh_issue_rpbl_pric --展期前每期应还本金
,b_renew_tot_perds --展期前总期数
,b_renew_loan_fst_rpbl_pric --展期前贷款首期应还本金
,b_renew_loan_late_rpbl_pric --展期前贷款末期应还本金
,b_renew_loan_tot_comm_fee --展期前贷款总手续费
,b_renew_loan_eh_issue_comm_fee --展期前贷款每期手续费
,b_renew_loan_fst_comm_fee --展期前贷款首期手续费
,b_renew_loan_late_comm_fee --展期前贷款末期手续费
,a_renew_fst_comm_fee --展期后首期手续费
,loan_tot_int --贷款总利息
,init_loan_tot_int --原贷款总利息
,exec_int_rat --执行利率
,pnlt_int_rat --罚息利率
,comp_int_int_rat --复利利率
,int_rat_fl_rt --利率浮动比例
,loan_ovdue_max_perds --贷款逾期最大期数
,renewd_cnt --已展期次数
,sotermed_cnt --已缩期次数
,loan_comm_fee_coll_way_cd --贷款手续费收取方式代码
,last_behav_type_cd --上次行动类型代码
,int_accr_base_cd --计息基准代码
,aging_cd --账龄代码
,loan_termnt_rs_cd --贷款终止原因代码
,syn_id --银团编号
,loan_appl_seq_num --贷款申请顺序号
,cont_edit_num --合同版本号
,loan_prod_id --贷款产品编号
,bank_contri_ratio --银行出资比例
,batch_doc_name --批量文件名称
,ser_num --序列号
,init_tran_auth_cd --原始交易授权码
,optimit_lock_edit_num --乐观锁版本号
,asset_thd_cls_cd --资产三分类代码
,revo_dt --撤销日期
,create_dt --创建日期
,update_dt --更新日期
,id_mark --删除标识

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.intnal_dubil_id,chr(13),''),chr(10),'') as intnal_dubil_id --内部借据编号
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id --借据编号
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id --账户编号
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd --账户类型代码
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cust_lmt_id,chr(13),''),chr(10),'') as cust_lmt_id --客户额度编号
,replace(replace(t1.apot_repay_deduct_acct_num,chr(13),''),chr(10),'') as apot_repay_deduct_acct_num --约定还款扣款账号
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no --交易参考号
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no --卡号
,t1.renew_effect_dt as renew_effect_dt --展期生效日期
,t1.loan_rgst_dt as loan_rgst_dt --贷款注册日期
,t1.loan_exp_dt as loan_exp_dt --贷款到期日期
,t1.appl_tm as appl_tm --申请时间
,t1.payoff_dt as payoff_dt --结清日期
,t1.adv_termnt_dt as adv_termnt_dt --提前终止日期
,t1.grace_dt_term as grace_dt_term --宽限日期
,t1.init_tran_dt as init_tran_dt --原始交易日期
,t1.fir_exp_repay_dt as fir_exp_repay_dt --首个到期还款日期
,t1.last_behav_dt as last_behav_dt --上次行动日期
,t1.actv_dt as actv_dt --激活日期
,t1.curr_ovdue_days as curr_ovdue_days --当前逾期天数
,replace(replace(t1.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd --贷款类型代码
,replace(replace(t1.loan_status_cd,chr(13),''),chr(10),'') as loan_status_cd --贷款状态代码
,t1.loan_tot_perds as loan_tot_perds --贷款总期数
,t1.curr_perds as curr_perds --当前期数
,t1.surp_perds as surp_perds --剩余期数
,t1.loan_pric as loan_pric --贷款本金
,t1.loan_eh_issue_rpbl_pric as loan_eh_issue_rpbl_pric --贷款每期应还本金
,t1.loan_fst_rpbl_pric as loan_fst_rpbl_pric --贷款首期应还本金
,t1.loan_late_rpbl_pric as loan_late_rpbl_pric --贷款末期应还本金
,t1.loan_tot_comm_fee as loan_tot_comm_fee --贷款总手续费
,t1.loan_eh_issue_comm_fee as loan_eh_issue_comm_fee --贷款每期手续费
,t1.loan_fst_comm_fee as loan_fst_comm_fee --贷款首期手续费
,t1.loan_late_comm_fee as loan_late_comm_fee --贷款末期手续费
,t1.loan_acct_bill_pric as loan_acct_bill_pric --贷款账单的本金
,t1.loan_acct_bill_comm_fee as loan_acct_bill_comm_fee --贷款账单手续费
,t1.repaid_pric as repaid_pric --已偿还本金
,t1.repaid_int as repaid_int --已偿还利息
,t1.repaid_fee as repaid_fee --已偿还费用
,t1.loan_curr_tot_bal as loan_curr_tot_bal --贷款当前总余额
,t1.loan_unexp_bal as loan_unexp_bal --贷款未到期余额
,t1.loan_expd_bal as loan_expd_bal --贷款已到期余额
,t1.debt_pric as debt_pric --欠款本金
,t1.debt_int as debt_int --欠款利息
,t1.debt_pnlt as debt_pnlt --欠款罚息
,t1.loan_unexp_pric as loan_unexp_pric --贷款未到期本金
,t1.loan_expd_pric as loan_expd_pric --贷款已到期本金
,t1.loan_unexp_comm_fee as loan_unexp_comm_fee --贷款未到期手续费
,t1.loan_expd_comm_fee as loan_expd_comm_fee --贷款已到期手续费
,t1.currt_repay_amt as currt_repay_amt --当期还款金额
,t1.adv_repay_amt as adv_repay_amt --提前还款金额
,t1.init_tran_curr_amt as init_tran_curr_amt --原始交易币种金额
,t1.renew_pric_amt as renew_pric_amt --展期本金金额
,t1.b_renew_eh_issue_rpbl_pric as b_renew_eh_issue_rpbl_pric --展期前每期应还本金
,t1.b_renew_tot_perds as b_renew_tot_perds --展期前总期数
,t1.b_renew_loan_fst_rpbl_pric as b_renew_loan_fst_rpbl_pric --展期前贷款首期应还本金
,t1.b_renew_loan_late_rpbl_pric as b_renew_loan_late_rpbl_pric --展期前贷款末期应还本金
,t1.b_renew_loan_tot_comm_fee as b_renew_loan_tot_comm_fee --展期前贷款总手续费
,t1.b_renew_loan_eh_issue_comm_fee as b_renew_loan_eh_issue_comm_fee --展期前贷款每期手续费
,t1.b_renew_loan_fst_comm_fee as b_renew_loan_fst_comm_fee --展期前贷款首期手续费
,t1.b_renew_loan_late_comm_fee as b_renew_loan_late_comm_fee --展期前贷款末期手续费
,t1.a_renew_fst_comm_fee as a_renew_fst_comm_fee --展期后首期手续费
,t1.loan_tot_int as loan_tot_int --贷款总利息
,t1.init_loan_tot_int as init_loan_tot_int --原贷款总利息
,t1.exec_int_rat as exec_int_rat --执行利率
,t1.pnlt_int_rat as pnlt_int_rat --罚息利率
,t1.comp_int_int_rat as comp_int_int_rat --复利利率
,t1.int_rat_fl_rt as int_rat_fl_rt --利率浮动比例
,t1.loan_ovdue_max_perds as loan_ovdue_max_perds --贷款逾期最大期数
,t1.renewd_cnt as renewd_cnt --已展期次数
,t1.sotermed_cnt as sotermed_cnt --已缩期次数
,replace(replace(t1.loan_comm_fee_coll_way_cd,chr(13),''),chr(10),'') as loan_comm_fee_coll_way_cd --贷款手续费收取方式代码
,replace(replace(t1.last_behav_type_cd,chr(13),''),chr(10),'') as last_behav_type_cd --上次行动类型代码
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd --计息基准代码
,replace(replace(t1.aging_cd,chr(13),''),chr(10),'') as aging_cd --账龄代码
,replace(replace(t1.loan_termnt_rs_cd,chr(13),''),chr(10),'') as loan_termnt_rs_cd --贷款终止原因代码
,replace(replace(t1.syn_id,chr(13),''),chr(10),'') as syn_id --银团编号
,replace(replace(t1.loan_appl_seq_num,chr(13),''),chr(10),'') as loan_appl_seq_num --贷款申请顺序号
,replace(replace(t1.cont_edit_num,chr(13),''),chr(10),'') as cont_edit_num --合同版本号
,replace(replace(t1.loan_prod_id,chr(13),''),chr(10),'') as loan_prod_id --贷款产品编号
,t1.bank_contri_ratio as bank_contri_ratio --银行出资比例
,replace(replace(t1.batch_doc_name,chr(13),''),chr(10),'') as batch_doc_name --批量文件名称
,replace(replace(t1.ser_num,chr(13),''),chr(10),'') as ser_num --序列号
,replace(replace(t1.init_tran_auth_cd,chr(13),''),chr(10),'') as init_tran_auth_cd --原始交易授权码
,replace(replace(t1.optimit_lock_edit_num,chr(13),''),chr(10),'') as optimit_lock_edit_num --乐观锁版本号
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd --资产三分类代码
,t1.revo_dt as revo_dt --撤销日期
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --删除标识
from ${iml_schema}.agt_wld_dubil_info t1    --网商贷初审扩展信息
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D';
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_agt_wld_dubil_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
