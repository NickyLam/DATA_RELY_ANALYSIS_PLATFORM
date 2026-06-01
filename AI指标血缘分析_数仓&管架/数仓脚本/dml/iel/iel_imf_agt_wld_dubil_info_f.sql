: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_wld_dubil_info_f
CreateDate: 20230608
FileName:   ${iel_data_path}/agt_wld_dubil_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.intnal_dubil_id,chr(13),''),chr(10),'') as intnal_dubil_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_lmt_id,chr(13),''),chr(10),'') as cust_lmt_id
,replace(replace(t1.apot_repay_deduct_acct_num,chr(13),''),chr(10),'') as apot_repay_deduct_acct_num
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,renew_effect_dt
,loan_rgst_dt
,loan_exp_dt
,appl_tm
,payoff_dt
,adv_termnt_dt
,grace_dt_term
,init_tran_dt
,fir_exp_repay_dt
,last_behav_dt
,actv_dt
,curr_ovdue_days
,replace(replace(t1.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd
,replace(replace(t1.loan_status_cd,chr(13),''),chr(10),'') as loan_status_cd
,loan_tot_perds
,curr_perds
,surp_perds
,loan_pric
,loan_eh_issue_rpbl_pric
,loan_fst_rpbl_pric
,loan_late_rpbl_pric
,loan_tot_comm_fee
,loan_eh_issue_comm_fee
,loan_fst_comm_fee
,loan_late_comm_fee
,loan_acct_bill_pric
,loan_acct_bill_comm_fee
,repaid_pric
,repaid_int
,repaid_fee
,loan_curr_tot_bal
,loan_unexp_bal
,loan_expd_bal
,debt_pric
,debt_int
,debt_pnlt
,loan_unexp_pric
,loan_expd_pric
,loan_unexp_comm_fee
,loan_expd_comm_fee
,currt_repay_amt
,adv_repay_amt
,init_tran_curr_amt
,renew_pric_amt
,b_renew_eh_issue_rpbl_pric
,b_renew_tot_perds
,b_renew_loan_fst_rpbl_pric
,b_renew_loan_late_rpbl_pric
,b_renew_loan_tot_comm_fee
,b_renew_loan_eh_issue_comm_fee
,b_renew_loan_fst_comm_fee
,b_renew_loan_late_comm_fee
,a_renew_fst_comm_fee
,loan_tot_int
,init_loan_tot_int
,exec_int_rat
,pnlt_int_rat
,comp_int_int_rat
,int_rat_fl_rt
,loan_ovdue_max_perds
,renewd_cnt
,sotermed_cnt
,replace(replace(t1.loan_comm_fee_coll_way_cd,chr(13),''),chr(10),'') as loan_comm_fee_coll_way_cd
,replace(replace(t1.last_behav_type_cd,chr(13),''),chr(10),'') as last_behav_type_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.aging_cd,chr(13),''),chr(10),'') as aging_cd
,replace(replace(t1.loan_termnt_rs_cd,chr(13),''),chr(10),'') as loan_termnt_rs_cd
,replace(replace(t1.syn_id,chr(13),''),chr(10),'') as syn_id
,replace(replace(t1.loan_appl_seq_num,chr(13),''),chr(10),'') as loan_appl_seq_num
,replace(replace(t1.cont_edit_num,chr(13),''),chr(10),'') as cont_edit_num
,replace(replace(t1.loan_prod_id,chr(13),''),chr(10),'') as loan_prod_id
,bank_contri_ratio
,replace(replace(t1.batch_doc_name,chr(13),''),chr(10),'') as batch_doc_name
,replace(replace(t1.ser_num,chr(13),''),chr(10),'') as ser_num
,replace(replace(t1.init_tran_auth_cd,chr(13),''),chr(10),'') as init_tran_auth_cd
,replace(replace(t1.optimit_lock_edit_num,chr(13),''),chr(10),'') as optimit_lock_edit_num
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,revo_dt
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.agt_wld_dubil_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') -1 and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wld_dubil_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
