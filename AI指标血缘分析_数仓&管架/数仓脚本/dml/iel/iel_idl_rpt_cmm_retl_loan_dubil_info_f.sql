: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cmm_retl_loan_dubil_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cmm_retl_loan_dubil_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,lp_id
,dubil_id
,cont_id
,std_prod_id
,bus_breed_id
,bus_breed_name
,cust_id
,repay_num
,enter_acct_num
,mortg_flg
,npl_flg
,deflt_flg
,crdt_lmt_use_flg
,gro_lend_flg
,blon_loan_flg
,level10_cls_manu_med_flg
,prod_type_cd
,loan_happ_type_cd
,loan_type_cd
,guar_way_cd
,sub_guar_way_cd
,repay_way_cd
,dir_indus_cd
,dubil_status_cd
,comp_int_calc_way_cd
,int_rat_adj_ped_corp_cd
,int_rat_adj_ped_freq
,loan_level4_cls_cd
,loan_level5_cls_cd
,loan_level10_cls_cd
,loan_level12_cls_cd
,int_rat_adj_way_cd
,ovdue_int_rat_adj_way
,int_rat_adj_effect_way
,int_rat_float_tenor_cd
,enter_acct_pt_type_cd
,repay_acct_pt_type_cd
,deduct_way_cd
,mode_pay_cd
,curr_cd
,loan_type_descb
,enter_acct_name
,cust_mgr_id
,trust_cust_mgr
,rgst_teller_id
,rgst_org_id
,acct_instit_id
,mgmt_org_id
,dubil_open_dt
,dubil_exp_dt
,fir_distr_dt
,recnt_repay_dt
,repay_day
,payoff_dt
,pric_ovdue_dt
,int_ovdue_dt
,loan_level5_cls_dt
,loan_level10_cls_dt
,base_rat
,exec_int_rat
,ovdue_int_rat
,ovdue_int_rat_flo_val
,int_rat_flo_val
,pric_ovdue_days
,int_ovdue_days
,final_ped_resv_amt
,dubil_amt
,job_cd 
,insure_comp_flg
,pbc_inc_loan_flg
,white_list_cust_flg
,asset_thd_cls_cd
,refac_loan_status_cd
,last_level5_cls_modif_dt
,last_risk_rgst_adj_rs
,risk_rgst_apver_id
,grace_days
,grace_period_start_dt
,grace_period_exp_dt
,refac_loan_batch_pkg_id
,refac_loan_batch_exp_dt
,refac_loan_use_int_rat
from idl.rpt_cmm_retl_loan_dubil_info where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cmm_retl_loan_dubil_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes