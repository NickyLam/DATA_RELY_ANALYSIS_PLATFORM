: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondcashflow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_cbondcashflow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t.statement_type,chr(13),''),chr(10),'') as statement_type
,replace(replace(t.crncy_code,chr(13),''),chr(10),'') as crncy_code
,t.cash_recp_sg_and_rs as cash_recp_sg_and_rs
,t.recp_tax_rends as recp_tax_rends
,t.net_incr_dep_cob as net_incr_dep_cob
,t.net_incr_loans_central_bank as net_incr_loans_central_bank
,t.net_incr_fund_borr_ofi as net_incr_fund_borr_ofi
,t.cash_recp_prem_orig_inco as cash_recp_prem_orig_inco
,t.net_incr_insured_dep as net_incr_insured_dep
,t.net_cash_received_reinsu_bus as net_cash_received_reinsu_bus
,t.net_incr_disp_tfa as net_incr_disp_tfa
,t.net_incr_int_handling_chrg as net_incr_int_handling_chrg
,t.net_incr_disp_faas as net_incr_disp_faas
,t.net_incr_loans_other_bank as net_incr_loans_other_bank
,t.net_incr_repurch_bus_fund as net_incr_repurch_bus_fund
,t.other_cash_recp_ral_oper_act as other_cash_recp_ral_oper_act
,t.stot_cash_inflows_oper_act as stot_cash_inflows_oper_act
,t.cash_pay_goods_purch_serv_rec as cash_pay_goods_purch_serv_rec
,t.cash_pay_beh_empl as cash_pay_beh_empl
,t.pay_all_typ_tax as pay_all_typ_tax
,t.net_incr_clients_loan_adv as net_incr_clients_loan_adv
,t.net_incr_dep_cbob as net_incr_dep_cbob
,t.cash_pay_claims_orig_inco as cash_pay_claims_orig_inco
,t.handling_chrg_paid as handling_chrg_paid
,t.comm_insur_plcy_paid as comm_insur_plcy_paid
,t.other_cash_pay_ral_oper_act as other_cash_pay_ral_oper_act
,t.stot_cash_outflows_oper_act as stot_cash_outflows_oper_act
,t.net_cash_flows_oper_act as net_cash_flows_oper_act
,t.cash_recp_disp_withdrwl_invest as cash_recp_disp_withdrwl_invest
,t.cash_recp_return_invest as cash_recp_return_invest
,t.net_cash_recp_disp_fiolta as net_cash_recp_disp_fiolta
,t.net_cash_recp_disp_sobu as net_cash_recp_disp_sobu
,t.other_cash_recp_ral_inv_act as other_cash_recp_ral_inv_act
,t.stot_cash_inflows_inv_act as stot_cash_inflows_inv_act
,t.cash_pay_acq_const_fiolta as cash_pay_acq_const_fiolta
,t.cash_paid_invest as cash_paid_invest
,t.net_cash_pay_aquis_sobu as net_cash_pay_aquis_sobu
,t.other_cash_pay_ral_inv_act as other_cash_pay_ral_inv_act
,t.net_incr_pledge_loan as net_incr_pledge_loan
,t.stot_cash_outflows_inv_act as stot_cash_outflows_inv_act
,t.net_cash_flows_inv_act as net_cash_flows_inv_act
,t.cash_recp_cap_contrib as cash_recp_cap_contrib
,t.incl_cash_rec_saims as incl_cash_rec_saims
,t.cash_recp_borrow as cash_recp_borrow
,t.proc_issue_bonds as proc_issue_bonds
,t.other_cash_recp_ral_fnc_act as other_cash_recp_ral_fnc_act
,t.stot_cash_inflows_fnc_act as stot_cash_inflows_fnc_act
,t.cash_prepay_amt_borr as cash_prepay_amt_borr
,t.cash_pay_dist_dpcp_int_exp as cash_pay_dist_dpcp_int_exp
,t.incl_dvd_profit_paid_sc_ms as incl_dvd_profit_paid_sc_ms
,t.other_cash_pay_ral_fnc_act as other_cash_pay_ral_fnc_act
,t.stot_cash_outflows_fnc_act as stot_cash_outflows_fnc_act
,t.net_cash_flows_fnc_act as net_cash_flows_fnc_act
,t.eff_fx_flu_cash as eff_fx_flu_cash
,t.net_incr_cash_cash_equ as net_incr_cash_cash_equ
,t.cash_cash_equ_beg_period as cash_cash_equ_beg_period
,t.cash_cash_equ_end_period as cash_cash_equ_end_period
,t.net_profit as net_profit
,t.unconfirmed_invest_loss as unconfirmed_invest_loss
,t.plus_prov_depr_assets as plus_prov_depr_assets
,t.depr_fa_coga_dpba as depr_fa_coga_dpba
,t.amort_intang_assets as amort_intang_assets
,t.amort_lt_deferred_exp as amort_lt_deferred_exp
,t.decr_deferred_exp as decr_deferred_exp
,t.incr_acc_exp as incr_acc_exp
,t.loss_disp_fiolta as loss_disp_fiolta
,t.loss_scr_fa as loss_scr_fa
,t.loss_fv_chg as loss_fv_chg
,t.fin_exp as fin_exp
,t.invest_loss as invest_loss
,t.decr_deferred_inc_tax_assets as decr_deferred_inc_tax_assets
,t.incr_deferred_inc_tax_liab as incr_deferred_inc_tax_liab
,t.decr_inventories as decr_inventories
,t.decr_oper_payable as decr_oper_payable
,t.incr_oper_payable as incr_oper_payable
,t.others as others
,t.im_net_cash_flows_oper_act as im_net_cash_flows_oper_act
,t.conv_debt_into_cap as conv_debt_into_cap
,t.conv_corp_bonds_due_within_1y as conv_corp_bonds_due_within_1y
,t.fa_fnc_leases as fa_fnc_leases
,t.end_bal_cash as end_bal_cash
,t.less_beg_bal_cash as less_beg_bal_cash
,t.plus_end_bal_cash_equ as plus_end_bal_cash_equ
,t.less_beg_bal_cash_equ as less_beg_bal_cash_equ
,t.im_net_incr_cash_cash_equ as im_net_incr_cash_cash_equ
,t.free_cash_flow as free_cash_flow
,replace(replace(t.comp_type_code,chr(13),''),chr(10),'') as comp_type_code
,replace(replace(t.actual_ann_dt,chr(13),''),chr(10),'') as actual_ann_dt
,t.spe_bal_cash_inflows_oper as spe_bal_cash_inflows_oper
,t.tot_bal_cash_inflows_oper as tot_bal_cash_inflows_oper
,t.spe_bal_cash_outflows_oper as spe_bal_cash_outflows_oper
,t.tot_bal_cash_outflows_oper as tot_bal_cash_outflows_oper
,t.tot_bal_netcash_outflows_oper as tot_bal_netcash_outflows_oper
,t.spe_bal_cash_inflows_inv as spe_bal_cash_inflows_inv
,t.tot_bal_cash_inflows_inv as tot_bal_cash_inflows_inv
,t.spe_bal_cash_outflows_inv as spe_bal_cash_outflows_inv
,t.tot_bal_cash_outflows_inv as tot_bal_cash_outflows_inv
,t.tot_bal_netcash_outflows_inv as tot_bal_netcash_outflows_inv
,t.spe_bal_cash_inflows_fnc as spe_bal_cash_inflows_fnc
,t.tot_bal_cash_inflows_fnc as tot_bal_cash_inflows_fnc
,t.spe_bal_cash_outflows_fnc as spe_bal_cash_outflows_fnc
,t.tot_bal_cash_outflows_fnc as tot_bal_cash_outflows_fnc
,t.tot_bal_netcash_outflows_fnc as tot_bal_netcash_outflows_fnc
,t.spe_bal_netcash_inc as spe_bal_netcash_inc
,t.tot_bal_netcash_inc as tot_bal_netcash_inc
,t.spe_bal_netcash_equ_undir as spe_bal_netcash_equ_undir
,t.tot_bal_netcash_equ_undir as tot_bal_netcash_equ_undir
,t.spe_bal_netcash_inc_undir as spe_bal_netcash_inc_undir
,t.tot_bal_netcash_inc_undir as tot_bal_netcash_inc_undir
,t.audit_am as audit_am
from iol.wind_cbondcashflow t
where etl_dt =to_date('${batch_date}','yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondcashflow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes