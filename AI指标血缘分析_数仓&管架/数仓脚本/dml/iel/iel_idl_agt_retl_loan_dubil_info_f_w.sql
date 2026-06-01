: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_retl_loan_dubil_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_loan_dubil_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.agt_id as agt_id
,t.lp_id as lp_id
,t.dubil_id as dubil_id
,t.cont_id as cont_id
,t.prod_id as prod_id
,t.prod_name as prod_name
,t.prod_type_cd as prod_type_cd
,t.dubil_amt as dubil_amt
,t.loan_start_dt as loan_start_dt
,t.loan_termnt_dt as loan_termnt_dt
,t.base_rat as base_rat
,t.int_rat_float_point as int_rat_float_point
,t.ovdue_int_rat_fl_rt as ovdue_int_rat_fl_rt
,t.ovdue_mon_int_rat as ovdue_mon_int_rat
,t.deflt_int_rat as deflt_int_rat
,t.comp_int_pty_int_rat as comp_int_pty_int_rat
,t.comp_int_int_rat as comp_int_int_rat
,t.pric_ovdue_days as pric_ovdue_days
,t.pric_ovdue_start_dt as pric_ovdue_start_dt
,t.int_ovdue_start_dt as int_ovdue_start_dt
,t.repay_dt as repay_dt
,t.payoff_dt as payoff_dt
,t.curr_cd as curr_cd
,t.dubil_status_cd as dubil_status_cd
,t.repay_way_cd as repay_way_cd
,t.mode_pay_cd as mode_pay_cd
,t.sub_guar_way_cd as sub_guar_way_cd
,t.int_rat_float_tenor_cd as int_rat_float_tenor_cd
,t.l_ped_level5_cls_cd as l_ped_level5_cls_cd
,t.l_ped_level5_cls_cmplt_dt as l_ped_level5_cls_cmplt_dt
,t.l_ped_level10_cls_cd as l_ped_level10_cls_cd
,t.l_ped_level10_cls_cmplt_dt as l_ped_level10_cls_cmplt_dt
,t.loan_level4_cls_cd as loan_level4_cls_cd
,t.loan_level5_cls_cd as loan_level5_cls_cd
,t.level5_cls_cmplt_dt as level5_cls_cmplt_dt
,t.loan_level10_cls_cd as loan_level10_cls_cd
,t.level10_cls_cmplt_dt as level10_cls_cmplt_dt
,t.level10_cls_manu_med_flg as level10_cls_manu_med_flg
,t.risk_cls_final_jud_ps_id as risk_cls_final_jud_ps_id
,t.turn_non_flg as turn_non_flg
,t.deflt_flg as deflt_flg
,t.cust_id as cust_id
,t.cust_mgr_id as cust_mgr_id
,t.trust_cust_mgr_id as trust_cust_mgr_id
,t.open_acct_org_id as open_acct_org_id
,t.acct_instit_id as acct_instit_id
,t.mgmt_org_id as mgmt_org_id
,t.rgst_emply_id as rgst_emply_id
,t.repay_acct_id as repay_acct_id
,t.enter_acct_id as enter_acct_id
,t.enter_acct_name as enter_acct_name
,t.main_guar_way_cd_3 as main_guar_way_cd_3
,t.exec_int_rat as exec_int_rat
,t.int_rat_adj_way_cd as int_rat_adj_way_cd
,t.ovdue_int_rat_float_type_cd as ovdue_int_rat_float_type_cd
,t.int_rat_modif_effect_way_cd as int_rat_modif_effect_way_cd
,t.deduct_flg as deduct_flg
,t.int_rat_adj_type_cd as int_rat_adj_type_cd
,t.blon_loan_flg as blon_loan_flg
,t.final_ped_resv_amt as final_ped_resv_amt
,t.loan_form_cd as loan_form_cd
,t.main_guar_way_cd as main_guar_way_cd
,t.mortg_idf as mortg_idf
,t.loan_dir_cd as loan_dir_cd
,t.crdt_lmt_use_flg as crdt_lmt_use_flg
,t.int_rat_incremt_option_cd as int_rat_incremt_option_cd
,t.int_rat_incremt as int_rat_incremt
,t.prod_user_def_name as prod_user_def_name
,t.prod_user_def_cate_cd as prod_user_def_cate_cd
,t.repay_day as repay_day
,t.gro_lend_flg as gro_lend_flg
,t.int_ovdue_days as int_ovdue_days
,t.enter_acct_pt_type_cd as enter_acct_pt_type_cd
,t.repay_acct_pt_type_cd as repay_acct_pt_type_cd
,t.fir_distr_dt as fir_distr_dt
,t.asset_thd_cls_cd as asset_thd_cls_cd
,t.base_rat_type_cd as base_rat_type_cd
,t.refac_loan_status_cd as refac_loan_status_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_retl_loan_dubil_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_loan_dubil_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes