: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_dubil_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_loan_dubil_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.rela_out_acct_flow_num as rela_out_acct_flow_num
,t1.rela_cont_id as rela_cont_id
,t1.happ_dt as happ_dt
,t1.loan_distr_type_cd as loan_distr_type_cd
,t1.main_guar_way_cd as main_guar_way_cd
,t1.cust_id as cust_id
,t1.cust_name as cust_name
,t1.prod_id as prod_id
,t1.curr_cd as curr_cd
,t1.dubil_amt as dubil_amt
,t1.mon_tenor as mon_tenor
,t1.day_tenor as day_tenor
,t1.distr_dt as distr_dt
,t1.apot_exp_dt as apot_exp_dt
,t1.actl_exp_dt as actl_exp_dt
,t1.int_rat_mode_cd as int_rat_mode_cd
,t1.base_rat_type_cd as base_rat_type_cd
,t1.base_rat as base_rat
,t1.int_rat_float_type_cd as int_rat_float_type_cd
,t1.exec_year_int_rat as exec_year_int_rat
,t1.margin_ratio as margin_ratio
,t1.margin_amt as margin_amt
,t1.margin_acct_id as margin_acct_id
,t1.distr_mode_pay_cd as distr_mode_pay_cd
,t1.distr_acct_id as distr_acct_id
,t1.distr_acct_name as distr_acct_name
,t1.repay_way_cd as repay_way_cd
,t1.repay_ped as repay_ped
,t1.repay_ped_cd as repay_ped_cd
,t1.repay_acct_id as repay_acct_id
,t1.repay_acct_name as repay_acct_name
,t1.repay_num_bal as repay_num_bal
,t1.repay_num_aval_bal as repay_num_aval_bal
,t1.curr_bal as curr_bal
,t1.nomal_bal as nomal_bal
,t1.ovdue_bal as ovdue_bal
,t1.idle_bal as idle_bal
,t1.bad_debt_bal as bad_debt_bal
,t1.renew_cnt as renew_cnt
,t1.in_bs_over_int_bal as in_bs_over_int_bal
,t1.off_bs_over_int_bal as off_bs_over_int_bal
,t1.ovdue_pnlt_bal as ovdue_pnlt_bal
,t1.comp_int_bal as comp_int_bal
,t1.loan_ovdue_days as loan_ovdue_days
,t1.over_int_days as over_int_days
,t1.loan_grace_period as loan_grace_period
,t1.provi_resv_lmt as provi_resv_lmt
,t1.pre_loss_amt as pre_loss_amt
,t1.termnt_dt as termnt_dt
,t1.belong_strip_line_cd as belong_strip_line_cd
,t1.off_bs_flg as off_bs_flg
,t1.low_risk_flg as low_risk_flg
,t1.fir_idtfy_non_dt as fir_idtfy_non_dt
,t1.level5_cls_cd as level5_cls_cd
,t1.level5_cls_dt as level5_cls_dt
,t1.level11_cls_cd as level11_cls_cd
,t1.level11_cls_dt as level11_cls_dt
,t1.advc_flg as advc_flg
,t1.dubil_status_cd as dubil_status_cd
,t1.init_dubil_id as init_dubil_id
,t1.enter_id as enter_id
,t1.oper_dt as oper_dt
,t1.bus_oper_teller_id as bus_oper_teller_id
,t1.oper_org_id as oper_org_id
,t1.rgst_teller_id as rgst_teller_id
,t1.rgst_org_id as rgst_org_id
,t1.rgst_dt as rgst_dt
,t1.update_teller_id as update_teller_id
,t1.update_org_id as update_org_id
,t1.modif_dt as modif_dt
,t1.lp_id as lp_id
,t1.deflt_repay_day as deflt_repay_day
,t1.ovdue_dt as ovdue_dt
,t1.over_int_dt as over_int_dt
,t1.ovdue_int_rat as ovdue_int_rat
,t1.accti_org_id as accti_org_id
,t1.asset_thd_cls_cd as asset_thd_cls_cd
,t1.guar_way_cd_two as guar_way_cd_two
,t1.guar_way_cd_three as guar_way_cd_three
,t1.int_rat_adj_way_cd as int_rat_adj_way_cd
,t1.int_rat_adj_ped_cd as int_rat_adj_ped_cd
,t1.int_rat_float_range as int_rat_float_range
,t1.enter_open_acct_org_id as enter_open_acct_org_id
,t1.bad_debt_wrt_off_status_cd as bad_debt_wrt_off_status_cd
,t1.out_acct_org_id as out_acct_org_id
,t1.ovdue_int_rat_float_way_cd as ovdue_int_rat_float_way_cd
,t1.ovdue_int_rat_flo_val as ovdue_int_rat_flo_val
,t1.move_remark as move_remark
,t1.refac_loan_idf_cd as refac_loan_idf_cd
,t1.old_cust_id as old_cust_id
,t1.old_prod_id as old_prod_id
,t1.loan_tot_perds as loan_tot_perds
,t1.surp_repay_perds as surp_repay_perds
,t1.level10_cls_manu_med_flg as level10_cls_manu_med_flg
,t1.last_level10_cls_cd as last_level10_cls_cd
,t1.last_level10_cls_dt as last_level10_cls_dt
,t1.last_level5_cls_cd as last_level5_cls_cd
,t1.last_level5_cls_cmplt_dt as last_level5_cls_cmplt_dt
,t1.last_term_level5_cls_modif_dt as last_term_level5_cls_modif_dt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.dubil_id as dubil_id

from ${idl_schema}.oass_agt_loan_dubil_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_dubil_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
