: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_agt_wld_dubil_info_f
CreateDate: 20230608
FileName:   ${iel_data_path}/crps_agt_wld_dubil_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.agt_id as agt_id
,t1.lp_id as lp_id
,t1.intnal_dubil_id as intnal_dubil_id
,t1.dubil_id as dubil_id
,t1.acct_id as acct_id
,t1.acct_type_cd as acct_type_cd
,t1.cust_id as cust_id
,t1.cust_lmt_id as cust_lmt_id
,t1.apot_repay_deduct_acct_num as apot_repay_deduct_acct_num
,t1.tran_ref_no as tran_ref_no
,t1.card_no as card_no
,t1.renew_effect_dt as renew_effect_dt
,t1.loan_rgst_dt as loan_rgst_dt
,t1.loan_exp_dt as loan_exp_dt
,t1.appl_tm as appl_tm
,t1.payoff_dt as payoff_dt
,t1.adv_termnt_dt as adv_termnt_dt
,t1.grace_dt_term as grace_dt_term
,t1.init_tran_dt as init_tran_dt
,t1.fir_exp_repay_dt as fir_exp_repay_dt
,t1.last_behav_dt as last_behav_dt
,t1.actv_dt as actv_dt
,t1.curr_ovdue_days as curr_ovdue_days
,t1.loan_type_cd as loan_type_cd
,t1.loan_status_cd as loan_status_cd
,t1.loan_tot_perds as loan_tot_perds
,t1.curr_perds as curr_perds
,t1.surp_perds as surp_perds
,t1.loan_pric as loan_pric
,t1.loan_eh_issue_rpbl_pric as loan_eh_issue_rpbl_pric
,t1.loan_fst_rpbl_pric as loan_fst_rpbl_pric
,t1.loan_late_rpbl_pric as loan_late_rpbl_pric
,t1.loan_tot_comm_fee as loan_tot_comm_fee
,t1.loan_eh_issue_comm_fee as loan_eh_issue_comm_fee
,t1.loan_fst_comm_fee as loan_fst_comm_fee
,t1.loan_late_comm_fee as loan_late_comm_fee
,t1.loan_acct_bill_pric as loan_acct_bill_pric
,t1.loan_acct_bill_comm_fee as loan_acct_bill_comm_fee
,t1.repaid_pric as repaid_pric
,t1.repaid_int as repaid_int
,t1.repaid_fee as repaid_fee
,t1.loan_curr_tot_bal as loan_curr_tot_bal
,t1.loan_unexp_bal as loan_unexp_bal
,t1.loan_expd_bal as loan_expd_bal
,t1.debt_pric as debt_pric
,t1.debt_int as debt_int
,t1.debt_pnlt as debt_pnlt
,t1.loan_unexp_pric as loan_unexp_pric
,t1.loan_expd_pric as loan_expd_pric
,t1.loan_unexp_comm_fee as loan_unexp_comm_fee
,t1.loan_expd_comm_fee as loan_expd_comm_fee
,t1.currt_repay_amt as currt_repay_amt
,t1.adv_repay_amt as adv_repay_amt
,t1.init_tran_curr_amt as init_tran_curr_amt
,t1.renew_pric_amt as renew_pric_amt
,t1.b_renew_eh_issue_rpbl_pric as b_renew_eh_issue_rpbl_pric
,t1.b_renew_tot_perds as b_renew_tot_perds
,t1.b_renew_loan_fst_rpbl_pric as b_renew_loan_fst_rpbl_pric
,t1.b_renew_loan_late_rpbl_pric as b_renew_loan_late_rpbl_pric
,t1.b_renew_loan_tot_comm_fee as b_renew_loan_tot_comm_fee
,t1.b_renew_loan_eh_issue_comm_fee as b_renew_loan_eh_issue_comm_fee
,t1.b_renew_loan_fst_comm_fee as b_renew_loan_fst_comm_fee
,t1.b_renew_loan_late_comm_fee as b_renew_loan_late_comm_fee
,t1.a_renew_fst_comm_fee as a_renew_fst_comm_fee
,t1.loan_tot_int as loan_tot_int
,t1.init_loan_tot_int as init_loan_tot_int
,t1.exec_int_rat as exec_int_rat
,t1.pnlt_int_rat as pnlt_int_rat
,t1.comp_int_int_rat as comp_int_int_rat
,t1.int_rat_fl_rt as int_rat_fl_rt
,t1.loan_ovdue_max_perds as loan_ovdue_max_perds
,t1.renewd_cnt as renewd_cnt
,t1.sotermed_cnt as sotermed_cnt
,t1.loan_comm_fee_coll_way_cd as loan_comm_fee_coll_way_cd
,t1.last_behav_type_cd as last_behav_type_cd
,t1.int_accr_base_cd as int_accr_base_cd
,t1.aging_cd as aging_cd
,t1.loan_termnt_rs_cd as loan_termnt_rs_cd
,t1.syn_id as syn_id
,t1.loan_appl_seq_num as loan_appl_seq_num
,t1.cont_edit_num as cont_edit_num
,t1.loan_prod_id as loan_prod_id
,t1.bank_contri_ratio as bank_contri_ratio
,t1.batch_doc_name as batch_doc_name
,t1.ser_num as ser_num
,t1.init_tran_auth_cd as init_tran_auth_cd
,t1.optimit_lock_edit_num as optimit_lock_edit_num
,t1.asset_thd_cls_cd as asset_thd_cls_cd
,t1.revo_dt as revo_dt
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark

from ${idl_schema}.crps_agt_wld_dubil_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_agt_wld_dubil_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
