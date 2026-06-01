: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_neeqsbalancesheet_a
CreateDate: 20240509
FileName:   ${iel_data_path}/wind_neeqsbalancesheet.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t1.statement_type,chr(13),''),chr(10),'') as statement_type
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,monetary_cap
,tradable_fin_assets
,notes_rcv
,acct_rcv
,oth_rcv
,prepay
,dvd_rcv
,int_rcv
,inventories
,consumptive_bio_assets
,deferred_exp
,non_cur_assets_due_within_1y
,settle_rsrv
,loans_to_oth_banks
,prem_rcv
,rcv_from_reinsurer
,rcv_from_ceded_insur_cont_rsrv
,red_monetary_cap_for_sale
,oth_cur_assets
,tot_cur_assets
,fin_assets_avail_for_sale
,held_to_mty_invest
,long_term_eqy_invest
,invest_real_estate
,time_deposits
,oth_assets
,long_term_rec
,fix_assets
,const_in_prog
,proj_matl
,fix_assets_disp
,productive_bio_assets
,oil_and_natural_gas_assets
,intang_assets
,r_and_d_costs
,goodwill
,long_term_deferred_exp
,deferred_tax_assets
,loans_and_adv_granted
,oth_non_cur_assets
,tot_non_cur_assets
,cash_deposits_central_bank
,asset_dep_oth_banks_fin_inst
,precious_metals
,derivative_fin_assets
,agency_bus_assets
,subr_rec
,rcv_ceded_unearned_prem_rsrv
,rcv_ceded_claim_rsrv
,rcv_ceded_life_insur_rsrv
,rcv_ceded_lt_health_insur_rsrv
,mrgn_paid
,insured_pledge_loan
,cap_mrgn_paid
,independent_acct_assets
,clients_cap_deposit
,clients_rsrv_settle
,incl_seat_fees_exchange
,rcv_invest
,tot_assets
,st_borrow
,borrow_central_bank
,deposit_received_ib_deposits
,loans_oth_banks
,tradable_fin_liab
,notes_payable
,acct_payable
,adv_from_cust
,fund_sales_fin_assets_rp
,handling_charges_comm_payable
,empl_ben_payable
,taxes_surcharges_payable
,int_payable
,dvd_payable
,oth_payable
,acc_exp
,deferred_inc
,st_bonds_payable
,payable_to_reinsurer
,rsrv_insur_cont
,acting_trading_sec
,acting_uw_sec
,non_cur_liab_due_within_1y
,oth_cur_liab
,tot_cur_liab
,lt_borrow
,bonds_payable
,lt_payable
,specific_item_payable
,provisions
,deferred_tax_liab
,deferred_inc_non_cur_liab
,oth_non_cur_liab
,tot_non_cur_liab
,liab_dep_oth_banks_fin_inst
,derivative_fin_liab
,cust_bank_dep
,agency_bus_liab
,oth_liab
,prem_received_adv
,deposit_received
,insured_deposit_invest
,unearned_prem_rsrv
,out_loss_rsrv
,life_insur_rsrv
,lt_health_insur_v
,independent_acct_liab
,incl_pledge_loan
,claims_payable
,dvd_payable_insured
,tot_liab
,cap_stk
,cap_rsrv
,special_rsrv
,surplus_rsrv
,undistributed_profit
,less_tsy_stk
,prov_nom_risks
,cnvd_diff_foreign_curr_stat
,unconfirmed_invest_loss
,minority_int
,tot_shrhldr_eqy_excl_min_int
,tot_shrhldr_eqy_incl_min_int
,tot_liab_shrhldr_eqy
,replace(replace(t1.comp_type_code,chr(13),''),chr(10),'') as comp_type_code
,replace(replace(t1.actual_ann_dt,chr(13),''),chr(10),'') as actual_ann_dt
,spe_cur_assets_diff
,tot_cur_assets_diff
,spe_non_cur_assets_diff
,tot_non_cur_assets_diff
,spe_bal_assets_diff
,tot_bal_assets_diff
,spe_cur_liab_diff
,tot_cur_liab_diff
,spe_non_cur_liab_diff
,tot_non_cur_liab_diff
,spe_bal_liab_diff
,tot_bal_liab_diff
,spe_bal_shrhldr_eqy_diff
,tot_bal_shrhldr_eqy_diff
,spe_bal_liab_eqy_diff
,tot_bal_liab_eqy_diff
,hfs_assets
,hfs_sales
,lt_payroll_payable
,other_comp_income
,other_equity_tools
,other_equity_tools_p_shr
,lending_funds
,accounts_receivable
,st_financing_payable
,payables

from ${iol_schema}.wind_neeqsbalancesheet t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_neeqsbalancesheet.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
