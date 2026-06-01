: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_cont_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_loan_cont_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.apv_flow_num as apv_flow_num
,t1.rela_cont_id as rela_cont_id
,t1.text_cont_id as text_cont_id
,t1.cust_id as cust_id
,t1.cust_name as cust_name
,t1.lmt_cont_flg as lmt_cont_flg
,t1.rela_old_cont_id as rela_old_cont_id
,t1.appl_way_cd as appl_way_cd
,t1.loan_distr_type_cd as loan_distr_type_cd
,t1.distr_mode_pay_cd as distr_mode_pay_cd
,t1.happ_dt as happ_dt
,t1.curr_cd as curr_cd
,t1.cont_amt as cont_amt
,t1.actl_out_acct_amt as actl_out_acct_amt
,t1.out_acct_dt as out_acct_dt
,t1.base_prod_id as base_prod_id
,t1.prod_id as prod_id
,t1.mon_tenor as mon_tenor
,t1.day_tenor as day_tenor
,t1.cont_effect_dt as cont_effect_dt
,t1.cont_exp_dt as cont_exp_dt
,t1.lmt_circl_flg as lmt_circl_flg
,t1.risk_type_cd as risk_type_cd
,t1.low_risk_bus_flg as low_risk_bus_flg
,t1.remote_bus_flg as remote_bus_flg
,t1.int_rat_mode_cd as int_rat_mode_cd
,t1.fix_int_rat as fix_int_rat
,t1.base_rat_type_cd as base_rat_type_cd
,t1.base_rat as base_rat
,t1.int_rat_float_type_cd as int_rat_float_type_cd
,t1.int_rat_adj_way_cd as int_rat_adj_way_cd
,t1.int_rat_flo_val as int_rat_flo_val
,t1.exec_int_rat as exec_int_rat
,t1.main_guar_way_cd as main_guar_way_cd
,t1.supp_guar_way_flg as supp_guar_way_flg
,t1.other_cond_descb as other_cond_descb
,t1.guar_way_cd_two as guar_way_cd_two
,t1.guar_way_cd_three as guar_way_cd_three
,t1.repay_way_cd as repay_way_cd
,t1.sub_guar_way_cd as sub_guar_way_cd
,t1.repay_ped as repay_ped
,t1.repay_ped_cd as repay_ped_cd
,t1.deflt_repay_day as deflt_repay_day
,t1.stl_acct_id as stl_acct_id
,t1.crdt_dir_cd as crdt_dir_cd
,t1.nat_std_indus_dir_cd as nat_std_indus_dir_cd
,t1.bank_int_indus_dir_cd as bank_int_indus_dir_cd
,t1.usage_descb as usage_descb
,t1.data_input_integy_flg as data_input_integy_flg
,t1.rsrv_amt as rsrv_amt
,t1.curr_bal as curr_bal
,t1.nomal_bal as nomal_bal
,t1.loan_ovdue_amt as loan_ovdue_amt
,t1.idle_bal as idle_bal
,t1.bad_debt_bal as bad_debt_bal
,t1.in_bs_over_int_bal as in_bs_over_int_bal
,t1.off_bs_over_int_bal as off_bs_over_int_bal
,t1.ovdue_pnlt_bal as ovdue_pnlt_bal
,t1.comp_int_bal as comp_int_bal
,t1.loan_ovdue_days as loan_ovdue_days
,t1.over_int_days as over_int_days
,t1.wrt_off_pric as wrt_off_pric
,t1.wrt_off_int as wrt_off_int
,t1.pre_loss_amt as pre_loss_amt
,t1.fir_idtfy_non_dt as fir_idtfy_non_dt
,t1.cont_status_cd as cont_status_cd
,t1.effect_dt as effect_dt
,t1.termnt_dt as termnt_dt
,t1.payoff_flg as payoff_flg
,t1.off_bs_flg as off_bs_flg
,t1.onl_bus_flg as onl_bus_flg
,t1.belong_strip_line_cd as belong_strip_line_cd
,t1.apv_status_cd as apv_status_cd
,t1.lmt_id as lmt_id
,t1.oper_teller_id as oper_teller_id
,t1.oper_org_id as oper_org_id
,t1.oper_dt as oper_dt
,t1.rgst_teller_id as rgst_teller_id
,t1.rgst_org_id as rgst_org_id
,t1.rgst_dt as rgst_dt
,t1.update_teller_id as update_teller_id
,t1.update_org_id as update_org_id
,t1.modif_dt as modif_dt
,t1.lp_id as lp_id
,t1.spec_ped_corp_cd as spec_ped_corp_cd
,t1.spec_ped_cd as spec_ped_cd
,t1.b_renew_exp_dt as b_renew_exp_dt
,t1.b_renew_amt as b_renew_amt
,t1.b_renew_exec_year_int_rat as b_renew_exec_year_int_rat
,t1.hxb_rela_party_flg as hxb_rela_party_flg
,t1.loan_usage_cd as loan_usage_cd
,t1.int_rat_adj_ped_cd as int_rat_adj_ped_cd
,t1.lmt_open_amt as lmt_open_amt
,t1.occu_lmt as occu_lmt
,t1.margin_curr_cd as margin_curr_cd
,t1.margin_ratio as margin_ratio
,t1.margin_amt as margin_amt
,t1.open_amt as open_amt
,t1.lmt_cont_id as lmt_cont_id
,t1.exec_mon_int_rat as exec_mon_int_rat
,t1.asset_thd_cls_cd as asset_thd_cls_cd
,t1.level5_cls_cd as level5_cls_cd
,t1.level5_cls_dt as level5_cls_dt
,t1.level11_cls_cd as level11_cls_cd
,t1.lon_post_mgmt_teller_id as lon_post_mgmt_teller_id
,t1.lon_post_mgmt_org_id as lon_post_mgmt_org_id
,t1.file_dt as file_dt
,t1.froz_flg as froz_flg
,t1.ovdue_exec_int_rat as ovdue_exec_int_rat
,t1.ovdue_int_rat_float_way_cd as ovdue_int_rat_float_way_cd
,t1.ovdue_int_rat_flo_val as ovdue_int_rat_flo_val
,t1.core_out_acct_org_id as core_out_acct_org_id
,t1.stl_acct_name as stl_acct_name
,t1.enter_id as enter_id
,t1.enter_name as enter_name
,t1.enter_open_acct_org_id as enter_open_acct_org_id
,t1.backup_status_cd as backup_status_cd
,t1.backup_lmt_cont_id as backup_lmt_cont_id
,t1.comm_fee_rat as comm_fee_rat
,t1.move_remark as move_remark
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.cont_id as cont_id

from ${idl_schema}.oass_agt_loan_cont_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_cont_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
