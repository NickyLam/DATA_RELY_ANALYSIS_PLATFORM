: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_acct_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_loan_acct_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.acct_id as acct_id
,t1.loan_num as loan_num
,t1.prod_id as prod_id
,t1.acct_name as acct_name
,t1.curr_cd as curr_cd
,t1.dubil_id as dubil_id
,t1.distr_flow_num as distr_flow_num
,t1.open_acct_org_id as open_acct_org_id
,t1.cust_id as cust_id
,t1.open_acct_dt as open_acct_dt
,t1.effect_dt as effect_dt
,t1.fir_tran_dt as fir_tran_dt
,t1.acct_status_cd as acct_status_cd
,t1.last_acct_status_cd as last_acct_status_cd
,t1.acct_status_modif_dt as acct_status_modif_dt
,t1.accti_status_cd as accti_status_cd
,t1.last_accti_status_cd as last_accti_status_cd
,t1.accti_status_modif_dt as accti_status_modif_dt
,t1.clos_acct_dt as clos_acct_dt
,t1.clos_acct_rs as clos_acct_rs
,t1.init_open_acct_dt as init_open_acct_dt
,t1.init_exp_dt as init_exp_dt
,t1.cust_mgr_id as cust_mgr_id
,t1.bal_type_cd as bal_type_cd
,t1.off_shore_flg as off_shore_flg
,t1.ftz_flg as ftz_flg
,t1.loan_tenor as loan_tenor
,t1.tenor_type_cd as tenor_type_cd
,t1.exp_dt as exp_dt
,t1.appl_org_id as appl_org_id
,t1.mgmt_org_id as mgmt_org_id
,t1.cust_name as cust_name
,t1.level5_cls_cd as level5_cls_cd
,t1.loan_rs_cd as loan_rs_cd
,t1.acct_aldy_check_flg as acct_aldy_check_flg
,t1.check_dt as check_dt
,t1.repay_way_cd as repay_way_cd
,t1.sub_plan_way_cd as sub_plan_way_cd
,t1.open_acct_chn_id as open_acct_chn_id
,t1.src_module_type_cd as src_module_type_cd
,t1.sob_cate_cd as sob_cate_cd
,t1.indv_bus_flg as indv_bus_flg
,t1.int_accr_flg as int_accr_flg
,t1.curr_pd as curr_pd
,t1.final_tran_dt as final_tran_dt
,t1.anew_create_repay_plan_flg as anew_create_repay_plan_flg
,t1.init_prod_id as init_prod_id
,t1.perds as perds
,t1.prog_intrv_perds as prog_intrv_perds
,t1.prog_amt as prog_amt
,t1.prog_ratio as prog_ratio
,t1.loan_auto_repay_type_cd as loan_auto_repay_type_cd
,t1.loan_pric_repay_seq_num as loan_pric_repay_seq_num
,t1.loan_int_repay_seq_num as loan_int_repay_seq_num
,t1.loan_pnlt_repay_seq_num as loan_pnlt_repay_seq_num
,t1.loan_comp_int_repay_seq_num as loan_comp_int_repay_seq_num
,t1.loan_fee_repay_seq_num as loan_fee_repay_seq_num
,t1.earliest_ovdue_dt as earliest_ovdue_dt
,t1.need_manual_input_repay_plan_flg as need_manual_input_repay_plan_flg
,t1.contri_ratio as contri_ratio
,t1.init_loan_num as init_loan_num
,t1.init_distr_flow_num as init_distr_flow_num
,t1.int_sub_closing_dt as int_sub_closing_dt
,t1.chg_term_not_chg_lmt_final_chg_dt as chg_term_not_chg_lmt_final_chg_dt
,t1.ftz_acct_flg as ftz_acct_flg
,t1.ftz_cd as ftz_cd
,t1.blon_loan_calc_pd as blon_loan_calc_pd
,t1.camp_prod_id as camp_prod_id
,t1.camp_prod_name as camp_prod_name
,t1.eh_issue_plan_repay_amt as eh_issue_plan_repay_amt
,t1.loan_usage_cd as loan_usage_cd
,t1.other_consm_descb as other_consm_descb
,t1.repay_plan_modif_way_cd as repay_plan_modif_way_cd
,t1.realtm_chase_capt_flg as realtm_chase_capt_flg
,t1.wrt_off_post_auto_turn_money_flg as wrt_off_post_auto_turn_money_flg
,t1.clos_acct_teller_id as clos_acct_teller_id
,t1.check_teller_id as check_teller_id
,t1.open_acct_teller_id as open_acct_teller_id
,t1.accrd_hours_int_rat as accrd_hours_int_rat
,t1.cust_econ_type_cd as cust_econ_type_cd
,t1.accrd_hours_file_flg_cd as accrd_hours_file_flg_cd
,t1.check_entry_code as check_entry_code
,t1.auto_comb_repay_flg as auto_comb_repay_flg
,t1.free_int_closing_dt as free_int_closing_dt
,t1.abs_flg as abs_flg
,t1.auto_revs_flg as auto_revs_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_loan_acct_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_acct_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
