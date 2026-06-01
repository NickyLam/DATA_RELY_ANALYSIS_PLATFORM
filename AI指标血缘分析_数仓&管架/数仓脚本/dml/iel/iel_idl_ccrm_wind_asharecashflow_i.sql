: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_asharecashflow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_asharecashflow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.wind_code,chr(13),''),chr(10),'') as wind_code
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t1.statement_type,chr(13),''),chr(10),'') as statement_type
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,t1.cash_recp_sg_and_rs as cash_recp_sg_and_rs
,t1.recp_tax_rends as recp_tax_rends
,t1.net_incr_dep_cob as net_incr_dep_cob
,t1.net_incr_loans_central_bank as net_incr_loans_central_bank
,t1.net_incr_fund_borr_ofi as net_incr_fund_borr_ofi
,t1.cash_recp_prem_orig_inco as cash_recp_prem_orig_inco
,t1.net_incr_insured_dep as net_incr_insured_dep
,t1.net_cash_received_reinsu_bus as net_cash_received_reinsu_bus
,t1.net_incr_disp_tfa as net_incr_disp_tfa
,t1.net_incr_int_handling_chrg as net_incr_int_handling_chrg
,t1.net_incr_disp_faas as net_incr_disp_faas
,t1.net_incr_loans_other_bank as net_incr_loans_other_bank
,t1.net_incr_repurch_bus_fund as net_incr_repurch_bus_fund
,t1.other_cash_recp_ral_oper_act as other_cash_recp_ral_oper_act
,t1.stot_cash_inflows_oper_act as stot_cash_inflows_oper_act
,t1.cash_pay_goods_purch_serv_rec as cash_pay_goods_purch_serv_rec
,t1.cash_pay_beh_empl as cash_pay_beh_empl
,t1.pay_all_typ_tax as pay_all_typ_tax
,t1.net_incr_clients_loan_adv as net_incr_clients_loan_adv
,t1.net_incr_dep_cbob as net_incr_dep_cbob
,t1.cash_pay_claims_orig_inco as cash_pay_claims_orig_inco
,t1.handling_chrg_paid as handling_chrg_paid
,t1.comm_insur_plcy_paid as comm_insur_plcy_paid
,t1.other_cash_pay_ral_oper_act as other_cash_pay_ral_oper_act
,t1.stot_cash_outflows_oper_act as stot_cash_outflows_oper_act
,t1.net_cash_flows_oper_act as net_cash_flows_oper_act
,t1.cash_recp_disp_withdrwl_invest as cash_recp_disp_withdrwl_invest
,t1.cash_recp_return_invest as cash_recp_return_invest
,t1.net_cash_recp_disp_fiolta as net_cash_recp_disp_fiolta
,t1.net_cash_recp_disp_sobu as net_cash_recp_disp_sobu
,t1.other_cash_recp_ral_inv_act as other_cash_recp_ral_inv_act
,t1.stot_cash_inflows_inv_act as stot_cash_inflows_inv_act
,t1.cash_pay_acq_const_fiolta as cash_pay_acq_const_fiolta
,t1.cash_paid_invest as cash_paid_invest
,t1.net_cash_pay_aquis_sobu as net_cash_pay_aquis_sobu
,t1.other_cash_pay_ral_inv_act as other_cash_pay_ral_inv_act
,t1.net_incr_pledge_loan as net_incr_pledge_loan
,t1.stot_cash_outflows_inv_act as stot_cash_outflows_inv_act
,t1.net_cash_flows_inv_act as net_cash_flows_inv_act
,t1.cash_recp_cap_contrib as cash_recp_cap_contrib
,t1.incl_cash_rec_saims as incl_cash_rec_saims
,t1.cash_recp_borrow as cash_recp_borrow
,t1.proc_issue_bonds as proc_issue_bonds
,t1.other_cash_recp_ral_fnc_act as other_cash_recp_ral_fnc_act
,t1.stot_cash_inflows_fnc_act as stot_cash_inflows_fnc_act
,t1.cash_prepay_amt_borr as cash_prepay_amt_borr
,t1.cash_pay_dist_dpcp_int_exp as cash_pay_dist_dpcp_int_exp
,t1.incl_dvd_profit_paid_sc_ms as incl_dvd_profit_paid_sc_ms
,t1.other_cash_pay_ral_fnc_act as other_cash_pay_ral_fnc_act
,t1.stot_cash_outflows_fnc_act as stot_cash_outflows_fnc_act
,t1.net_cash_flows_fnc_act as net_cash_flows_fnc_act
,t1.eff_fx_flu_cash as eff_fx_flu_cash
,t1.net_incr_cash_cash_equ as net_incr_cash_cash_equ
,t1.cash_cash_equ_beg_period as cash_cash_equ_beg_period
,t1.cash_cash_equ_end_period as cash_cash_equ_end_period
,t1.net_profit as net_profit
,t1.unconfirmed_invest_loss as unconfirmed_invest_loss
,t1.plus_prov_depr_assets as plus_prov_depr_assets
,t1.depr_fa_coga_dpba as depr_fa_coga_dpba
,t1.amort_intang_assets as amort_intang_assets
,t1.amort_lt_deferred_exp as amort_lt_deferred_exp
,t1.decr_deferred_exp as decr_deferred_exp
,t1.incr_acc_exp as incr_acc_exp
,t1.loss_disp_fiolta as loss_disp_fiolta
,t1.loss_scr_fa as loss_scr_fa
,t1.loss_fv_chg as loss_fv_chg
,t1.fin_exp as fin_exp
,t1.invest_loss as invest_loss
,t1.decr_deferred_inc_tax_assets as decr_deferred_inc_tax_assets
,t1.incr_deferred_inc_tax_liab as incr_deferred_inc_tax_liab
,t1.decr_inventories as decr_inventories
,t1.decr_oper_payable as decr_oper_payable
,t1.incr_oper_payable as incr_oper_payable
,t1.others as others
,t1.im_net_cash_flows_oper_act as im_net_cash_flows_oper_act
,t1.conv_debt_into_cap as conv_debt_into_cap
,t1.conv_corp_bonds_due_within_1y as conv_corp_bonds_due_within_1y
,t1.fa_fnc_leases as fa_fnc_leases
,t1.end_bal_cash as end_bal_cash
,t1.less_beg_bal_cash as less_beg_bal_cash
,t1.plus_end_bal_cash_equ as plus_end_bal_cash_equ
,t1.less_beg_bal_cash_equ as less_beg_bal_cash_equ
,t1.im_net_incr_cash_cash_equ as im_net_incr_cash_cash_equ
,t1.free_cash_flow as free_cash_flow
,replace(replace(t1.comp_type_code,chr(13),''),chr(10),'') as comp_type_code
,replace(replace(t1.actual_ann_dt,chr(13),''),chr(10),'') as actual_ann_dt
,t1.spe_bal_cash_inflows_oper as spe_bal_cash_inflows_oper
,t1.tot_bal_cash_inflows_oper as tot_bal_cash_inflows_oper
,t1.spe_bal_cash_outflows_oper as spe_bal_cash_outflows_oper
,t1.tot_bal_cash_outflows_oper as tot_bal_cash_outflows_oper
,t1.tot_bal_netcash_outflows_oper as tot_bal_netcash_outflows_oper
,t1.spe_bal_cash_inflows_inv as spe_bal_cash_inflows_inv
,t1.tot_bal_cash_inflows_inv as tot_bal_cash_inflows_inv
,t1.spe_bal_cash_outflows_inv as spe_bal_cash_outflows_inv
,t1.tot_bal_cash_outflows_inv as tot_bal_cash_outflows_inv
,t1.tot_bal_netcash_outflows_inv as tot_bal_netcash_outflows_inv
,t1.spe_bal_cash_inflows_fnc as spe_bal_cash_inflows_fnc
,t1.tot_bal_cash_inflows_fnc as tot_bal_cash_inflows_fnc
,t1.spe_bal_cash_outflows_fnc as spe_bal_cash_outflows_fnc
,t1.tot_bal_cash_outflows_fnc as tot_bal_cash_outflows_fnc
,t1.tot_bal_netcash_outflows_fnc as tot_bal_netcash_outflows_fnc
,t1.spe_bal_netcash_inc as spe_bal_netcash_inc
,t1.tot_bal_netcash_inc as tot_bal_netcash_inc
,t1.spe_bal_netcash_equ_undir as spe_bal_netcash_equ_undir
,t1.tot_bal_netcash_equ_undir as tot_bal_netcash_equ_undir
,t1.spe_bal_netcash_inc_undir as spe_bal_netcash_inc_undir
,t1.tot_bal_netcash_inc_undir as tot_bal_netcash_inc_undir
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,to_date('${batch_date}','yyyymmdd') as opdate
,'' as opmode
from ${iol_schema}.wind_asharecashflow t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_asharecashflow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes