: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_retl_loan_dubil_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_retl_loan_dubil_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id
,replace(replace(t.bus_breed_name,chr(13),''),chr(10),'') as bus_breed_name
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.repay_num,chr(13),''),chr(10),'') as repay_num
,replace(replace(t.enter_acct_num,chr(13),''),chr(10),'') as enter_acct_num
,replace(replace(t.mortg_flg,chr(13),''),chr(10),'') as mortg_flg
,replace(replace(t.npl_flg,chr(13),''),chr(10),'') as npl_flg
,replace(replace(t.deflt_flg,chr(13),''),chr(10),'') as deflt_flg
,replace(replace(t.crdt_lmt_use_flg,chr(13),''),chr(10),'') as crdt_lmt_use_flg
,replace(replace(t.gro_lend_flg,chr(13),''),chr(10),'') as gro_lend_flg
,replace(replace(t.blon_loan_flg,chr(13),''),chr(10),'') as blon_loan_flg
,replace(replace(t.level10_cls_manu_med_flg,chr(13),''),chr(10),'') as level10_cls_manu_med_flg
,replace(replace(t.insure_comp_flg,chr(13),''),chr(10),'') as insure_comp_flg
,replace(replace(t.pbc_inc_loan_flg,chr(13),''),chr(10),'') as pbc_inc_loan_flg
,replace(replace(t.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t.loan_happ_type_cd,chr(13),''),chr(10),'') as loan_happ_type_cd
,replace(replace(t.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd
,replace(replace(t.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t.sub_guar_way_cd,chr(13),''),chr(10),'') as sub_guar_way_cd
,replace(replace(t.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,replace(replace(t.dir_indus_cd,chr(13),''),chr(10),'') as dir_indus_cd
,replace(replace(t.dubil_status_cd,chr(13),''),chr(10),'') as dubil_status_cd
,replace(replace(t.refac_loan_status_cd,chr(13),''),chr(10),'') as refac_loan_status_cd
,replace(replace(t.comp_int_calc_way_cd,chr(13),''),chr(10),'') as comp_int_calc_way_cd
,replace(replace(t.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd
,t.int_rat_adj_ped_freq as int_rat_adj_ped_freq
,replace(replace(t.loan_level4_cls_cd,chr(13),''),chr(10),'') as loan_level4_cls_cd
,replace(replace(t.loan_level5_cls_cd,chr(13),''),chr(10),'') as loan_level5_cls_cd
,replace(replace(t.loan_level10_cls_cd,chr(13),''),chr(10),'') as loan_level10_cls_cd
,replace(replace(t.loan_level12_cls_cd,chr(13),''),chr(10),'') as loan_level12_cls_cd
,replace(replace(t.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t.ovdue_int_rat_adj_way,chr(13),''),chr(10),'') as ovdue_int_rat_adj_way
,replace(replace(t.int_rat_adj_effect_way,chr(13),''),chr(10),'') as int_rat_adj_effect_way
,replace(replace(t.int_rat_float_tenor_cd,chr(13),''),chr(10),'') as int_rat_float_tenor_cd
,replace(replace(t.enter_acct_pt_type_cd,chr(13),''),chr(10),'') as enter_acct_pt_type_cd
,replace(replace(t.repay_acct_pt_type_cd,chr(13),''),chr(10),'') as repay_acct_pt_type_cd
,replace(replace(t.deduct_way_cd,chr(13),''),chr(10),'') as deduct_way_cd
,replace(replace(t.mode_pay_cd,chr(13),''),chr(10),'') as mode_pay_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.loan_type_descb,chr(13),''),chr(10),'') as loan_type_descb
,replace(replace(t.enter_acct_name,chr(13),''),chr(10),'') as enter_acct_name
,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t.trust_cust_mgr,chr(13),''),chr(10),'') as trust_cust_mgr
,replace(replace(t.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,t.dubil_open_dt as dubil_open_dt
,t.dubil_exp_dt as dubil_exp_dt
,t.fir_distr_dt as fir_distr_dt
,t.recnt_repay_dt as recnt_repay_dt
,replace(replace(t.repay_day,chr(13),''),chr(10),'') as repay_day
,t.payoff_dt as payoff_dt
,t.pric_ovdue_dt as pric_ovdue_dt
,t.int_ovdue_dt as int_ovdue_dt
,t.loan_level5_cls_dt as loan_level5_cls_dt
,t.loan_level10_cls_dt as loan_level10_cls_dt
,t.base_rat as base_rat
,t.exec_int_rat as exec_int_rat
,t.ovdue_int_rat as ovdue_int_rat
,t.ovdue_int_rat_flo_val as ovdue_int_rat_flo_val
,t.int_rat_flo_val as int_rat_flo_val
,t.pric_ovdue_days as pric_ovdue_days
,t.int_ovdue_days as int_ovdue_days
,t.grace_days as grace_days
,t.grace_period_start_dt as grace_period_start_dt
,t.grace_period_exp_dt as grace_period_exp_dt
,t.final_ped_resv_amt as final_ped_resv_amt
,t.dubil_amt as dubil_amt
,replace(replace(t.refac_loan_batch_pkg_id,chr(13),''),chr(10),'') as refac_loan_batch_pkg_id
,t.refac_loan_batch_exp_dt as refac_loan_batch_exp_dt
,t.refac_loan_use_int_rat as refac_loan_use_int_rat
from ${icl_schema}.cmm_retl_loan_dubil_info t
where etl_dt = to_date('${batch_date}','yyyymmdd')    ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_loan_dubil_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes