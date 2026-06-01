: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_unite_wl_dubil_info_clear_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_unite_wl_dubil_info_clear.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
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
,t1.int_rat_adj_ped_freq as int_rat_adj_ped_freq
,replace(replace(t1.int_rat_base_type_cd,chr(13),''),chr(10),'') as int_rat_base_type_cd
,replace(replace(t1.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd
,replace(replace(t1.int_rat_float_dir_cd,chr(13),''),chr(10),'') as int_rat_float_dir_cd
,t1.int_rat_flo_val as int_rat_flo_val
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
,t1.open_acct_dt as open_acct_dt
,t1.distr_dt as distr_dt
,t1.value_dt as value_dt
,t1.exp_dt as exp_dt
,t1.payoff_dt as payoff_dt
,t1.last_repay_dt as last_repay_dt
,t1.next_repay_dt as next_repay_dt
,t1.curr_int_rat_effect_dt as curr_int_rat_effect_dt
,t1.next_int_rat_adj_dt as next_int_rat_adj_dt
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,t1.tot_perds as tot_perds
,t1.curr_issue_perds as curr_issue_perds
,t1.surp_perds as surp_perds
,t1.ovdue_perds as ovdue_perds
,replace(replace(t1.pric_ovdue_flg,chr(13),''),chr(10),'') as pric_ovdue_flg
,replace(replace(t1.int_ovdue_flg,chr(13),''),chr(10),'') as int_ovdue_flg
,t1.pric_ovdue_days as pric_ovdue_days
,t1.int_ovdue_days as int_ovdue_days
,t1.grace_period_days as grace_period_days
,t1.inst_comm_fee_rat as inst_comm_fee_rat
,t1.base_rat as base_rat
,t1.exec_int_rat as exec_int_rat
,t1.ovdue_int_rat as ovdue_int_rat
,t1.daily_exec_int_rat as daily_exec_int_rat
,t1.cont_amt as cont_amt
,t1.dubil_amt as dubil_amt
,t1.distr_amt as distr_amt
,t1.bank_contri_ratio as bank_contri_ratio
,t1.td_acru_int as td_acru_int
,t1.currt_acru_int as currt_acru_int
,t1.nomal_pric as nomal_pric
,t1.ovdue_pric as ovdue_pric
,t1.idle_pric as idle_pric
,t1.bad_debt_pric as bad_debt_pric
,t1.wrt_off_pric as wrt_off_pric
,t1.nomal_int as nomal_int
,t1.ovdue_int as ovdue_int
,t1.wrt_off_int as wrt_off_int
,t1.ovdue_pric_pnlt as ovdue_pric_pnlt
,t1.ovdue_int_pnlt as ovdue_int_pnlt
,t1.recvbl_over_int as recvbl_over_int
,t1.recvbl_acru_pnlt as recvbl_acru_pnlt
,t1.recvbl_pnlt as recvbl_pnlt
,t1.recvbl_fee as recvbl_fee
,t1.in_bs_over_int_bal as in_bs_over_int_bal
,t1.off_bs_over_int_bal as off_bs_over_int_bal
,t1.in_bs_int as in_bs_int
,t1.off_bs_int as off_bs_int
,t1.acm_recvbl_uncol_int_amt as acm_recvbl_uncol_int_amt
,t1.repaid_nomal_pric as repaid_nomal_pric
,t1.repaid_ovdue_pric as repaid_ovdue_pric
,t1.repaid_nomal_int as repaid_nomal_int
,t1.repaid_ovdue_int as repaid_ovdue_int
,t1.repaid_ovdue_pric_pnlt as repaid_ovdue_pric_pnlt
,t1.repaid_ovdue_int_pnlt as repaid_ovdue_int_pnlt
,t1.repaid_fee as repaid_fee
,t1.pric_bal as pric_bal
,t1.currt_bal as currt_bal
,t1.cl_curr_currt_bal as cl_curr_currt_bal
,t1.ear_d_bal as ear_d_bal
,t1.ear_m_bal as ear_m_bal
,t1.ear_s_bal as ear_s_bal
,t1.ear_y_bal as ear_y_bal
,t1.y_acm_bal as y_acm_bal
,t1.s_acm_bal as s_acm_bal
,t1.m_acm_bal as m_acm_bal
,t1.cl_curr_ear_d_bal as cl_curr_ear_d_bal
,t1.cl_curr_ear_m_bal as cl_curr_ear_m_bal
,t1.cl_curr_ear_s_bal as cl_curr_ear_s_bal
,t1.cl_curr_ear_y_bal as cl_curr_ear_y_bal
,t1.cl_curr_y_acm_bal as cl_curr_y_acm_bal
,t1.cl_curr_ear_d_y_acm_bal as cl_curr_ear_d_y_acm_bal
,t1.cl_curr_ear_m_y_acm_bal as cl_curr_ear_m_y_acm_bal
,t1.cl_curr_ear_s_y_acm_bal as cl_curr_ear_s_y_acm_bal
,t1.cl_curr_ear_y_y_acm_bal as cl_curr_ear_y_y_acm_bal
,t1.cl_curr_s_acm_bal as cl_curr_s_acm_bal
,t1.cl_curr_ear_d_s_acm_bal as cl_curr_ear_d_s_acm_bal
,t1.cl_curr_ear_s_s_acm_bal as cl_curr_ear_s_s_acm_bal
,t1.cl_curr_ear_y_s_acm_bal as cl_curr_ear_y_s_acm_bal
,t1.cl_curr_m_acm_bal as cl_curr_m_acm_bal
,t1.cl_curr_ear_d_m_acm_bal as cl_curr_ear_d_m_acm_bal
,t1.cl_curr_ear_m_m_acm_bal as cl_curr_ear_m_m_acm_bal
,t1.cl_curr_ear_y_m_acm_bal as cl_curr_ear_y_m_acm_bal
,t1.y_avg_bal as y_avg_bal
,t1.q_avg_bal as q_avg_bal
,t1.m_avg_bal as m_avg_bal
,t1.cl_curr_y_avg_bal as cl_curr_y_avg_bal
,t1.cl_curr_q_avg_bal as cl_curr_q_avg_bal
,t1.cl_curr_m_avg_bal as cl_curr_m_avg_bal
,t1.init_tot_perds as init_tot_perds
from ${icl_schema}.cmm_unite_wl_dubil_info_clear t1
where t1.etl_dt>=to_date('20220101','yyyymmdd') AND t1.etl_dt<=to_date('20221231','yyyymmdd'); " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_unite_wl_dubil_info_clear.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes