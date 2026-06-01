: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_unite_wl_dubil_info_clear_f
CreateDate: 20241029
FileName:   ${iel_data_path}/cmm_unite_wl_dubil_info_clear.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.acctnt_cate_cd,chr(13),''),chr(10),'') as acctnt_cate_cd
,replace(replace(t1.enter_acct_acct_num,chr(13),''),chr(10),'') as enter_acct_acct_num
,replace(replace(t1.repay_num,chr(13),''),chr(10),'') as repay_num
,replace(replace(t1.rela_agt_id,chr(13),''),chr(10),'') as rela_agt_id
,replace(replace(t1.rela_appl_flow_num,chr(13),''),chr(10),'') as rela_appl_flow_num
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id
,replace(replace(t1.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.dubil_status_cd,chr(13),''),chr(10),'') as dubil_status_cd
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd
,replace(replace(t1.dir_indus_cd,chr(13),''),chr(10),'') as dir_indus_cd
,replace(replace(t1.cont_status_cd,chr(13),''),chr(10),'') as cont_status_cd
,replace(replace(t1.loan_level4_cls_cd,chr(13),''),chr(10),'') as loan_level4_cls_cd
,replace(replace(t1.loan_level5_cls_cd,chr(13),''),chr(10),'') as loan_level5_cls_cd
,replace(replace(t1.loan_level10_cls_cd,chr(13),''),chr(10),'') as loan_level10_cls_cd
,replace(replace(t1.loan_level12_cls_cd,chr(13),''),chr(10),'') as loan_level12_cls_cd
,replace(replace(t1.acru_non_acru_cd,chr(13),''),chr(10),'') as acru_non_acru_cd
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,replace(replace(t1.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd
,int_rat_adj_ped_freq
,replace(replace(t1.int_rat_base_type_cd,chr(13),''),chr(10),'') as int_rat_base_type_cd
,replace(replace(t1.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd
,replace(replace(t1.int_rat_float_dir_cd,chr(13),''),chr(10),'') as int_rat_float_dir_cd
,int_rat_flo_val
,replace(replace(t1.pric_repay_freq_cd,chr(13),''),chr(10),'') as pric_repay_freq_cd
,replace(replace(t1.int_repay_freq_cd,chr(13),''),chr(10),'') as int_repay_freq_cd
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.enter_acct_acct_num_type,chr(13),''),chr(10),'') as enter_acct_acct_num_type
,replace(replace(t1.repay_num_type,chr(13),''),chr(10),'') as repay_num_type
,replace(replace(t1.intnal_carr_flg,chr(13),''),chr(10),'') as intnal_carr_flg
,replace(replace(t1.dom_overs_flg,chr(13),''),chr(10),'') as dom_overs_flg
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,replace(replace(t1.comp_int_flg,chr(13),''),chr(10),'') as comp_int_flg
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,replace(replace(t1.wrt_off_flg,chr(13),''),chr(10),'') as wrt_off_flg
,open_acct_dt
,distr_dt
,value_dt
,exp_dt
,payoff_dt
,last_repay_dt
,next_repay_dt
,curr_int_rat_effect_dt
,next_int_rat_adj_dt
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,tot_perds
,curr_issue_perds
,surp_perds
,ovdue_perds
,replace(replace(t1.pric_ovdue_flg,chr(13),''),chr(10),'') as pric_ovdue_flg
,replace(replace(t1.int_ovdue_flg,chr(13),''),chr(10),'') as int_ovdue_flg
,pric_ovdue_days
,int_ovdue_days
,grace_period_days
,inst_comm_fee_rat
,base_rat
,exec_int_rat
,ovdue_int_rat
,daily_exec_int_rat
,cont_amt
,dubil_amt
,distr_amt
,bank_contri_ratio
,td_acru_int
,currt_acru_int
,nomal_pric
,ovdue_pric
,idle_pric
,bad_debt_pric
,wrt_off_pric
,nomal_int
,ovdue_int
,wrt_off_int
,ovdue_pric_pnlt
,ovdue_int_pnlt
,recvbl_over_int
,recvbl_acru_pnlt
,recvbl_pnlt
,recvbl_fee
,in_bs_over_int_bal
,off_bs_over_int_bal
,in_bs_int
,off_bs_int
,acm_recvbl_uncol_int_amt
,repaid_nomal_pric
,repaid_ovdue_pric
,repaid_nomal_int
,repaid_ovdue_int
,repaid_ovdue_pric_pnlt
,repaid_ovdue_int_pnlt
,repaid_fee
,pric_bal
,currt_bal
,cl_curr_currt_bal
,ear_d_bal
,ear_m_bal
,ear_s_bal
,ear_y_bal
,y_acm_bal
,s_acm_bal
,m_acm_bal
,cl_curr_ear_d_bal
,cl_curr_ear_m_bal
,cl_curr_ear_s_bal
,cl_curr_ear_y_bal
,cl_curr_y_acm_bal
,cl_curr_ear_d_y_acm_bal
,cl_curr_ear_m_y_acm_bal
,cl_curr_ear_s_y_acm_bal
,cl_curr_ear_y_y_acm_bal
,cl_curr_s_acm_bal
,cl_curr_ear_d_s_acm_bal
,cl_curr_ear_s_s_acm_bal
,cl_curr_ear_y_s_acm_bal
,cl_curr_m_acm_bal
,cl_curr_ear_d_m_acm_bal
,cl_curr_ear_m_m_acm_bal
,cl_curr_ear_y_m_acm_bal
,y_avg_bal
,q_avg_bal
,m_avg_bal
,cl_curr_y_avg_bal
,cl_curr_q_avg_bal
,cl_curr_m_avg_bal
,init_tot_perds
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id

from ${icl_schema}.cmm_unite_wl_dubil_info_clear t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_unite_wl_dubil_info_clear.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
