: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dep_acct_info_h_f
CreateDate: 20240529
FileName:   ${iel_data_path}/agt_dep_acct_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.realtm_chase_capt_flg,chr(13),''),chr(10),'') as realtm_chase_capt_flg
,replace(replace(t1.bal_type_cd,chr(13),''),chr(10),'') as bal_type_cd
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,open_acct_dt
,clos_acct_dt
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,final_tran_dt
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.open_acct_chn_id,chr(13),''),chr(10),'') as open_acct_chn_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no
,replace(replace(t1.vouch_status_cd,chr(13),''),chr(10),'') as vouch_status_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.priv_flg,chr(13),''),chr(10),'') as priv_flg
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,effect_dt
,fir_tran_dt
,replace(replace(t1.last_acct_status_cd,chr(13),''),chr(10),'') as last_acct_status_cd
,status_modif_dt
,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id
,replace(replace(t1.clos_acct_rs,chr(13),''),chr(10),'') as clos_acct_rs
,replace(replace(t1.core_acct_type_cd,chr(13),''),chr(10),'') as core_acct_type_cd
,dep_term
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,exp_dt
,acct_init_exp_dt
,acct_init_open_acct_dt
,replace(replace(t1.acct_attr_cd,chr(13),''),chr(10),'') as acct_attr_cd
,temp_acct_valid_dt
,replace(replace(t1.vtual_acct_flg,chr(13),''),chr(10),'') as vtual_acct_flg
,replace(replace(t1.lmt_flg,chr(13),''),chr(10),'') as lmt_flg
,replace(replace(t1.stop_pay_flg,chr(13),''),chr(10),'') as stop_pay_flg
,replace(replace(t1.general_storage_flg,chr(13),''),chr(10),'') as general_storage_flg
,replace(replace(t1.general_exch_flg,chr(13),''),chr(10),'') as general_exch_flg
,replace(replace(t1.reg_acct_type_cd,chr(13),''),chr(10),'') as reg_acct_type_cd
,replace(replace(t1.main_acct_flg,chr(13),''),chr(10),'') as main_acct_flg
,acct_lics_issue_dt
,replace(replace(t1.acct_lics_num,chr(13),''),chr(10),'') as acct_lics_num
,replace(replace(t1.card_prod_id,chr(13),''),chr(10),'') as card_prod_id
,replace(replace(t1.main_acct_bal_flg,chr(13),''),chr(10),'') as main_acct_bal_flg
,replace(replace(t1.main_acct_int_flg,chr(13),''),chr(10),'') as main_acct_int_flg
,replace(replace(t1.redt_way_type_cd,chr(13),''),chr(10),'') as redt_way_type_cd
,replace(replace(t1.part_pric_redt_flg,chr(13),''),chr(10),'') as part_pric_redt_flg
,aldy_pric_redt_cnt
,aldy_pric_int_redt_cnt
,max_pric_redt_cnt
,max_pric_int_redt_cnt
,replace(replace(t1.reg_acct_last_status_cd,chr(13),''),chr(10),'') as reg_acct_last_status_cd
,replace(replace(t1.allow_add_pric_flg,chr(13),''),chr(10),'') as allow_add_pric_flg
,turn_dormt_acct_dt
,tran_stl_dt
,replace(replace(t1.acct_appl_org_id,chr(13),''),chr(10),'') as acct_appl_org_id
,replace(replace(t1.approval_id,chr(13),''),chr(10),'') as approval_id
,replace(replace(t1.acct_aldy_check_flg,chr(13),''),chr(10),'') as acct_aldy_check_flg
,replace(replace(t1.auto_payoff_flg,chr(13),''),chr(10),'') as auto_payoff_flg
,replace(replace(t1.gl_type_cd,chr(13),''),chr(10),'') as gl_type_cd
,replace(replace(t1.multi_bal_flg,chr(13),''),chr(10),'') as multi_bal_flg
,replace(replace(t1.l_six_m_no_tran_flg,chr(13),''),chr(10),'') as l_six_m_no_tran_flg
,replace(replace(t1.off_shore_flg,chr(13),''),chr(10),'') as off_shore_flg
,replace(replace(t1.ftz_flg,chr(13),''),chr(10),'') as ftz_flg
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.free_annual_fee_flg,chr(13),''),chr(10),'') as free_annual_fee_flg
,replace(replace(t1.exch_way_cd,chr(13),''),chr(10),'') as exch_way_cd
,replace(replace(t1.init_prod_id,chr(13),''),chr(10),'') as init_prod_id
,curr_pd
,replace(replace(t1.stl_flg,chr(13),''),chr(10),'') as stl_flg
,replace(replace(t1.stl_teller_id,chr(13),''),chr(10),'') as stl_teller_id
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,replace(replace(t1.super_acct_id,chr(13),''),chr(10),'') as super_acct_id
,replace(replace(t1.acct_usage_cd,chr(13),''),chr(10),'') as acct_usage_cd
,check_dt
,advise_dep_tenor
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.acct_char_type_cd,chr(13),''),chr(10),'') as acct_char_type_cd
,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id
,prod_modif_dt
,final_modif_dt
,replace(replace(t1.final_modif_teller_id,chr(13),''),chr(10),'') as final_modif_teller_id

from ${iml_schema}.agt_dep_acct_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_acct_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
