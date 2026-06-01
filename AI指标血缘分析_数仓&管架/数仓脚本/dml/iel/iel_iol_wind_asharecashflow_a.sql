: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_asharecashflow_a
CreateDate: 20240509
FileName:   ${iel_data_path}/wind_asharecashflow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.wind_code,chr(13),''),chr(10),'') as wind_code
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t1.statement_type,chr(13),''),chr(10),'') as statement_type
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,cash_recp_sg_and_rs
,recp_tax_rends
,net_incr_dep_cob
,net_incr_loans_central_bank
,net_incr_fund_borr_ofi
,cash_recp_prem_orig_inco
,net_incr_insured_dep
,net_cash_received_reinsu_bus
,net_incr_disp_tfa
,net_incr_int_handling_chrg
,net_incr_disp_faas
,net_incr_loans_other_bank
,net_incr_repurch_bus_fund
,other_cash_recp_ral_oper_act
,stot_cash_inflows_oper_act
,cash_pay_goods_purch_serv_rec
,cash_pay_beh_empl
,pay_all_typ_tax
,net_incr_clients_loan_adv
,net_incr_dep_cbob
,cash_pay_claims_orig_inco
,handling_chrg_paid
,comm_insur_plcy_paid
,other_cash_pay_ral_oper_act
,stot_cash_outflows_oper_act
,net_cash_flows_oper_act
,cash_recp_disp_withdrwl_invest
,cash_recp_return_invest
,net_cash_recp_disp_fiolta
,net_cash_recp_disp_sobu
,other_cash_recp_ral_inv_act
,stot_cash_inflows_inv_act
,cash_pay_acq_const_fiolta
,cash_paid_invest
,net_cash_pay_aquis_sobu
,other_cash_pay_ral_inv_act
,net_incr_pledge_loan
,stot_cash_outflows_inv_act
,net_cash_flows_inv_act
,cash_recp_cap_contrib
,incl_cash_rec_saims
,cash_recp_borrow
,proc_issue_bonds
,other_cash_recp_ral_fnc_act
,stot_cash_inflows_fnc_act
,cash_prepay_amt_borr
,cash_pay_dist_dpcp_int_exp
,incl_dvd_profit_paid_sc_ms
,other_cash_pay_ral_fnc_act
,stot_cash_outflows_fnc_act
,net_cash_flows_fnc_act
,eff_fx_flu_cash
,net_incr_cash_cash_equ
,cash_cash_equ_beg_period
,cash_cash_equ_end_period
,net_profit
,unconfirmed_invest_loss
,plus_prov_depr_assets
,depr_fa_coga_dpba
,amort_intang_assets
,amort_lt_deferred_exp
,decr_deferred_exp
,incr_acc_exp
,loss_disp_fiolta
,loss_scr_fa
,loss_fv_chg
,fin_exp
,invest_loss
,decr_deferred_inc_tax_assets
,incr_deferred_inc_tax_liab
,decr_inventories
,decr_oper_payable
,incr_oper_payable
,others
,im_net_cash_flows_oper_act
,conv_debt_into_cap
,conv_corp_bonds_due_within_1y
,fa_fnc_leases
,end_bal_cash
,less_beg_bal_cash
,plus_end_bal_cash_equ
,less_beg_bal_cash_equ
,im_net_incr_cash_cash_equ
,free_cash_flow
,replace(replace(t1.comp_type_code,chr(13),''),chr(10),'') as comp_type_code
,replace(replace(t1.actual_ann_dt,chr(13),''),chr(10),'') as actual_ann_dt
,spe_bal_cash_inflows_oper
,tot_bal_cash_inflows_oper
,spe_bal_cash_outflows_oper
,tot_bal_cash_outflows_oper
,tot_bal_netcash_outflows_oper
,spe_bal_cash_inflows_inv
,tot_bal_cash_inflows_inv
,spe_bal_cash_outflows_inv
,tot_bal_cash_outflows_inv
,tot_bal_netcash_outflows_inv
,spe_bal_cash_inflows_fnc
,tot_bal_cash_inflows_fnc
,spe_bal_cash_outflows_fnc
,tot_bal_cash_outflows_fnc
,tot_bal_netcash_outflows_fnc
,spe_bal_netcash_inc
,tot_bal_netcash_inc
,spe_bal_netcash_equ_undir
,tot_bal_netcash_equ_undir
,spe_bal_netcash_inc_undir
,tot_bal_netcash_inc_undir
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode

from ${iol_schema}.wind_asharecashflow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_asharecashflow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
