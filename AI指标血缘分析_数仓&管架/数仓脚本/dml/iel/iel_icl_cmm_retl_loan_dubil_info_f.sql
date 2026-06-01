: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_retl_loan_dubil_info_f
CreateDate: 20250804
FileName:   ${iel_data_path}/cmm_retl_loan_dubil_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id
,replace(replace(t1.bus_breed_name,chr(13),''),chr(10),'') as bus_breed_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.repay_num,chr(13),''),chr(10),'') as repay_num
,replace(replace(t1.enter_acct_num,chr(13),''),chr(10),'') as enter_acct_num
,replace(replace(t1.mortg_flg,chr(13),''),chr(10),'') as mortg_flg
,replace(replace(t1.npl_flg,chr(13),''),chr(10),'') as npl_flg
,replace(replace(t1.deflt_flg,chr(13),''),chr(10),'') as deflt_flg
,replace(replace(t1.crdt_lmt_use_flg,chr(13),''),chr(10),'') as crdt_lmt_use_flg
,replace(replace(t1.gro_lend_flg,chr(13),''),chr(10),'') as gro_lend_flg
,replace(replace(t1.blon_loan_flg,chr(13),''),chr(10),'') as blon_loan_flg
,replace(replace(t1.level10_cls_manu_med_flg,chr(13),''),chr(10),'') as level10_cls_manu_med_flg
,replace(replace(t1.insure_comp_flg,chr(13),''),chr(10),'') as insure_comp_flg
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.loan_happ_type_cd,chr(13),''),chr(10),'') as loan_happ_type_cd
,replace(replace(t1.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.sub_guar_way_cd,chr(13),''),chr(10),'') as sub_guar_way_cd
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,replace(replace(t1.dir_indus_cd,chr(13),''),chr(10),'') as dir_indus_cd
,replace(replace(t1.dubil_status_cd,chr(13),''),chr(10),'') as dubil_status_cd
,replace(replace(t1.comp_int_calc_way_cd,chr(13),''),chr(10),'') as comp_int_calc_way_cd
,replace(replace(t1.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd
,int_rat_adj_ped_freq
,replace(replace(t1.loan_level4_cls_cd,chr(13),''),chr(10),'') as loan_level4_cls_cd
,replace(replace(t1.loan_level5_cls_cd,chr(13),''),chr(10),'') as loan_level5_cls_cd
,replace(replace(t1.loan_level10_cls_cd,chr(13),''),chr(10),'') as loan_level10_cls_cd
,replace(replace(t1.loan_level12_cls_cd,chr(13),''),chr(10),'') as loan_level12_cls_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.ovdue_int_rat_adj_way,chr(13),''),chr(10),'') as ovdue_int_rat_adj_way
,replace(replace(t1.int_rat_adj_effect_way,chr(13),''),chr(10),'') as int_rat_adj_effect_way
,replace(replace(t1.int_rat_float_tenor_cd,chr(13),''),chr(10),'') as int_rat_float_tenor_cd
,replace(replace(t1.enter_acct_pt_type_cd,chr(13),''),chr(10),'') as enter_acct_pt_type_cd
,replace(replace(t1.repay_acct_pt_type_cd,chr(13),''),chr(10),'') as repay_acct_pt_type_cd
,replace(replace(t1.deduct_way_cd,chr(13),''),chr(10),'') as deduct_way_cd
,replace(replace(t1.mode_pay_cd,chr(13),''),chr(10),'') as mode_pay_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.loan_type_descb,chr(13),''),chr(10),'') as loan_type_descb
,replace(replace(t1.enter_acct_name,chr(13),''),chr(10),'') as enter_acct_name
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.trust_cust_mgr,chr(13),''),chr(10),'') as trust_cust_mgr
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,dubil_open_dt
,dubil_exp_dt
,fir_distr_dt
,recnt_repay_dt
,replace(replace(t1.repay_day,chr(13),''),chr(10),'') as repay_day
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
,replace(replace(t1.pbc_inc_loan_flg,chr(13),''),chr(10),'') as pbc_inc_loan_flg
,replace(replace(t1.refac_loan_status_cd,chr(13),''),chr(10),'') as refac_loan_status_cd
,grace_days
,last_level5_cls_modif_dt
,grace_period_start_dt
,grace_period_exp_dt
,replace(replace(t1.refac_loan_batch_pkg_id,chr(13),''),chr(10),'') as refac_loan_batch_pkg_id
,refac_loan_batch_exp_dt
,refac_loan_use_int_rat
,replace(replace(t1.white_list_cust_flg,chr(13),''),chr(10),'') as white_list_cust_flg
,replace(replace(t1.last_risk_rgst_adj_rs,chr(13),''),chr(10),'') as last_risk_rgst_adj_rs
,replace(replace(t1.risk_rgst_apver_id,chr(13),''),chr(10),'') as risk_rgst_apver_id
,replace(replace(t1.crdtc_subm_bus_breed_cd,chr(13),''),chr(10),'') as crdtc_subm_bus_breed_cd
,replace(replace(t1.crdtc_subm_bus_breed_descb,chr(13),''),chr(10),'') as crdtc_subm_bus_breed_descb
,cust_crdt_tot
,replace(replace(t1.wrt_off_flg,chr(13),''),chr(10),'') as wrt_off_flg
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num
,exec_exp_dt
,replace(replace(t1.regroup_loan_flg,chr(13),''),chr(10),'') as regroup_loan_flg
,dubil_bal
,ovdue_bal
,replace(replace(t1.farm_flg,chr(13),''),chr(10),'') as farm_flg
,replace(replace(t1.regroup_loan_type_cd,chr(13),''),chr(10),'') as regroup_loan_type_cd
,replace(replace(t1.int_rat_float_type_cd,chr(13),''),chr(10),'') as int_rat_float_type_cd
,replace(replace(t1.cust_char_cd,chr(13),''),chr(10),'') as cust_char_cd
,comp_amt
,replace(replace(t1.prob_asset_flg,chr(13),''),chr(10),'') as prob_asset_flg
,replace(replace(t1.due_diligence_flg,chr(13),''),chr(10),'') as due_diligence_flg
,replace(replace(t1.outline_vrif_idti_flg,chr(13),''),chr(10),'') as outline_vrif_idti_flg
,prft_cut_amt
,replace(replace(t1.sub_prod_id,chr(13),''),chr(10),'') as sub_prod_id
,replace(replace(t1.provi_for_aged_property_flg,chr(13),''),chr(10),'') as provi_for_aged_property_flg
,suit_fee_bal

from ${icl_schema}.cmm_retl_loan_dubil_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_loan_dubil_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
