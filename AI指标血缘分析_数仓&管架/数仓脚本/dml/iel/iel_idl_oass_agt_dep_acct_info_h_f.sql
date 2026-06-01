: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_dep_acct_info_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_dep_acct_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.acct_id as acct_id
,t1.acct_name as acct_name
,t1.src_agt_id as src_agt_id
,t1.realtm_chase_capt_flg as realtm_chase_capt_flg
,t1.bal_type_cd as bal_type_cd
,t1.acct_type_cd as acct_type_cd
,t1.int_accr_flg as int_accr_flg
,t1.open_acct_dt as open_acct_dt
,t1.clos_acct_dt as clos_acct_dt
,t1.acct_status_cd as acct_status_cd
,t1.curr_cd as curr_cd
,t1.final_tran_dt as final_tran_dt
,t1.open_acct_org_id as open_acct_org_id
,t1.open_acct_chn_id as open_acct_chn_id
,t1.belong_org_id as belong_org_id
,t1.vouch_type_cd as vouch_type_cd
,t1.vouch_no as vouch_no
,t1.vouch_status_cd as vouch_status_cd
,t1.cust_id as cust_id
,t1.priv_flg as priv_flg
,t1.prod_id as prod_id
,t1.card_no as card_no
,t1.cust_acct_num as cust_acct_num
,t1.sub_acct_num as sub_acct_num
,t1.effect_dt as effect_dt
,t1.fir_tran_dt as fir_tran_dt
,t1.last_acct_status_cd as last_acct_status_cd
,t1.status_modif_dt as status_modif_dt
,t1.clos_acct_teller_id as clos_acct_teller_id
,t1.clos_acct_rs as clos_acct_rs
,t1.core_acct_type_cd as core_acct_type_cd
,t1.dep_term as dep_term
,t1.tenor_type_cd as tenor_type_cd
,t1.exp_dt as exp_dt
,t1.acct_init_exp_dt as acct_init_exp_dt
,t1.acct_init_open_acct_dt as acct_init_open_acct_dt
,t1.acct_attr_cd as acct_attr_cd
,t1.temp_acct_valid_dt as temp_acct_valid_dt
,t1.vtual_acct_flg as vtual_acct_flg
,t1.lmt_flg as lmt_flg
,t1.stop_pay_flg as stop_pay_flg
,t1.general_storage_flg as general_storage_flg
,t1.general_exch_flg as general_exch_flg
,t1.reg_acct_type_cd as reg_acct_type_cd
,t1.main_acct_flg as main_acct_flg
,t1.acct_lics_issue_dt as acct_lics_issue_dt
,t1.acct_lics_num as acct_lics_num
,t1.card_prod_id as card_prod_id
,t1.main_acct_bal_flg as main_acct_bal_flg
,t1.main_acct_int_flg as main_acct_int_flg
,t1.redt_way_type_cd as redt_way_type_cd
,t1.part_pric_redt_flg as part_pric_redt_flg
,t1.aldy_pric_redt_cnt as aldy_pric_redt_cnt
,t1.aldy_pric_int_redt_cnt as aldy_pric_int_redt_cnt
,t1.max_pric_redt_cnt as max_pric_redt_cnt
,t1.max_pric_int_redt_cnt as max_pric_int_redt_cnt
,t1.reg_acct_last_status_cd as reg_acct_last_status_cd
,t1.allow_add_pric_flg as allow_add_pric_flg
,t1.turn_dormt_acct_dt as turn_dormt_acct_dt
,t1.tran_stl_dt as tran_stl_dt
,t1.acct_appl_org_id as acct_appl_org_id
,t1.approval_id as approval_id
,t1.acct_aldy_check_flg as acct_aldy_check_flg
,t1.auto_payoff_flg as auto_payoff_flg
,t1.gl_type_cd as gl_type_cd
,t1.multi_bal_flg as multi_bal_flg
,t1.l_six_m_no_tran_flg as l_six_m_no_tran_flg
,t1.off_shore_flg as off_shore_flg
,t1.ftz_flg as ftz_flg
,t1.cust_mgr_id as cust_mgr_id
,t1.free_annual_fee_flg as free_annual_fee_flg
,t1.exch_way_cd as exch_way_cd
,t1.init_prod_id as init_prod_id
,t1.curr_pd as curr_pd
,t1.stl_flg as stl_flg
,t1.stl_teller_id as stl_teller_id
,t1.src_module_type_cd as src_module_type_cd
,t1.super_acct_id as super_acct_id
,t1.acct_usage_cd as acct_usage_cd
,t1.check_dt as check_dt
,t1.advise_dep_tenor as advise_dep_tenor
,t1.check_teller_id as check_teller_id
,t1.acct_char_type_cd as acct_char_type_cd
,t1.open_acct_teller_id as open_acct_teller_id
,t1.prod_modif_dt as prod_modif_dt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_dep_acct_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_dep_acct_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
