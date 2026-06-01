: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_retl_loan_cont_info_f
CreateDate: 20260226
FileName:   ${iel_data_path}/cmm_retl_loan_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id
,replace(replace(t1.enter_acct_id,chr(13),''),chr(10),'') as enter_acct_id
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.apv_flow_num,chr(13),''),chr(10),'') as apv_flow_num
,replace(replace(t1.cont_type_cd,chr(13),''),chr(10),'') as cont_type_cd
,replace(replace(t1.cont_status_cd,chr(13),''),chr(10),'') as cont_status_cd
,replace(replace(t1.bus_kind_cd,chr(13),''),chr(10),'') as bus_kind_cd
,replace(replace(t1.loan_happ_type_cd,chr(13),''),chr(10),'') as loan_happ_type_cd
,replace(replace(t1.major_guar_way_cd,chr(13),''),chr(10),'') as major_guar_way_cd
,replace(replace(t1.sub_guar_way_cd,chr(13),''),chr(10),'') as sub_guar_way_cd
,replace(replace(t1.borw_usage_type_cd,chr(13),''),chr(10),'') as borw_usage_type_cd
,replace(replace(t1.dir_indus_cd,chr(13),''),chr(10),'') as dir_indus_cd
,replace(replace(t1.distr_way_cd,chr(13),''),chr(10),'') as distr_way_cd
,replace(replace(t1.mode_pay_cd,chr(13),''),chr(10),'') as mode_pay_cd
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.int_rat_float_dir_cd,chr(13),''),chr(10),'') as int_rat_float_dir_cd
,replace(replace(t1.repay_freq_cd,chr(13),''),chr(10),'') as repay_freq_cd
,replace(replace(t1.repay_day_cfm_cd,chr(13),''),chr(10),'') as repay_day_cfm_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.housing_cnt_cd,chr(13),''),chr(10),'') as housing_cnt_cd
,replace(replace(t1.crdt_lmt_use_flg,chr(13),''),chr(10),'') as crdt_lmt_use_flg
,replace(replace(t1.mortg_flg,chr(13),''),chr(10),'') as mortg_flg
,replace(replace(t1.gro_lend_flg,chr(13),''),chr(10),'') as gro_lend_flg
,replace(replace(t1.blon_loan_flg,chr(13),''),chr(10),'') as blon_loan_flg
,replace(replace(t1.green_pass_flg,chr(13),''),chr(10),'') as green_pass_flg
,replace(replace(t1.low_risk_bus_flg,chr(13),''),chr(10),'') as low_risk_bus_flg
,replace(replace(t1.bar_flg,chr(13),''),chr(10),'') as bar_flg
,replace(replace(t1.allow_stage_repay_flg,chr(13),''),chr(10),'') as allow_stage_repay_flg
,replace(replace(t1.hxb_open_supv_acct_flg,chr(13),''),chr(10),'') as hxb_open_supv_acct_flg
,appl_dt
,apv_dt
,sign_dt
,cont_create_dt
,start_dt
,termnt_dt
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.crdt_loan_flg,chr(13),''),chr(10),'') as crdt_loan_flg
,replace(replace(t1.crdt_loan_reply_flow_num,chr(13),''),chr(10),'') as crdt_loan_reply_flow_num
,replace(replace(t1.use_coprator_lmt_flg,chr(13),''),chr(10),'') as use_coprator_lmt_flg
,replace(replace(t1.coprator_agt_id,chr(13),''),chr(10),'') as coprator_agt_id
,replace(replace(t1.coprator_stand_b_id,chr(13),''),chr(10),'') as coprator_stand_b_id
,replace(replace(t1.coprator_proj_type_cd,chr(13),''),chr(10),'') as coprator_proj_type_cd
,replace(replace(t1.coprator_type_cd,chr(13),''),chr(10),'') as coprator_type_cd
,base_rat
,exec_int_rat
,replace(replace(t1.repay_day,chr(13),''),chr(10),'') as repay_day
,tenor
,pm_guar_tot
,avg_pm_rat
,cont_amt
,cont_aval_bal
,acm_distr_amt
,acm_callbk_amt
,replace(replace(t1.coprator_id,chr(13),''),chr(10),'') as coprator_id
,replace(replace(t1.coprator_name,chr(13),''),chr(10),'') as coprator_name
,replace(replace(t1.init_dubil_id,chr(13),''),chr(10),'') as init_dubil_id
,replace(replace(t1.cont_name,chr(13),''),chr(10),'') as cont_name
,replace(replace(t1.incre_crdt_mode_cd,chr(13),''),chr(10),'') as incre_crdt_mode_cd
,replace(replace(t1.entr_loan_flg,chr(13),''),chr(10),'') as entr_loan_flg
,replace(replace(t1.csner_cust_no,chr(13),''),chr(10),'') as csner_cust_no
,replace(replace(t1.csner_cust_name,chr(13),''),chr(10),'') as csner_cust_name
,exp_dt
,replace(replace(t1.high_tech_property_type_cd,chr(13),''),chr(10),'') as high_tech_property_type_cd
,replace(replace(t1.digit_econ_core_property_type_cd,chr(13),''),chr(10),'') as digit_econ_core_property_type_cd
,replace(replace(t1.intel_prop_inte_property_type_cd,chr(13),''),chr(10),'') as intel_prop_inte_property_type_cd
,replace(replace(t1.strtg_new_indus_type_cd,chr(13),''),chr(10),'') as strtg_new_indus_type_cd
,replace(replace(t1.cul_and_rela_property_type_cd,chr(13),''),chr(10),'') as cul_and_rela_property_type_cd
,replace(replace(t1.agclt_flg,chr(13),''),chr(10),'') as agclt_flg
,replace(replace(t1.green_crdt_flg,chr(13),''),chr(10),'') as green_crdt_flg
,replace(replace(t1.green_loan_usage_cd,chr(13),''),chr(10),'') as green_loan_usage_cd
,replace(replace(t1.green_loan_usage_level2_cls_cd,chr(13),''),chr(10),'') as green_loan_usage_level2_cls_cd
,replace(replace(t1.green_loan_usage_level3_cls_cd,chr(13),''),chr(10),'') as green_loan_usage_level3_cls_cd
,replace(replace(t1.vehic_type_cd,chr(13),''),chr(10),'') as vehic_type_cd
,replace(replace(t1.aplv_flow_num,chr(13),''),chr(10),'') as aplv_flow_num
,replace(replace(t1.provi_for_aged_property_flg,chr(13),''),chr(10),'') as provi_for_aged_property_flg

from ${icl_schema}.cmm_retl_loan_cont_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_loan_cont_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
