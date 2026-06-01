: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_fi_balance_sheet_ns_f
CreateDate: 20251105
FileName:   ${iel_data_path}/uxds_fi_balance_sheet_ns.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,ed
,replace(replace(t1.statement_type_code,chr(13),''),chr(10),'') as statement_type_code
,replace(replace(t1.statement_type,chr(13),''),chr(10),'') as statement_type
,chg_seq
,replace(replace(t1.statement_format_code,chr(13),''),chr(10),'') as statement_format_code
,replace(replace(t1.statement_format,chr(13),''),chr(10),'') as statement_format
,replace(replace(t1.sas_code,chr(13),''),chr(10),'') as sas_code
,replace(replace(t1.sas,chr(13),''),chr(10),'') as sas
,announ_seq
,replace(replace(t1.data_source_code,chr(13),''),chr(10),'') as data_source_code
,replace(replace(t1.data_source,chr(13),''),chr(10),'') as data_source
,replace(replace(t1.statement_source_explain,chr(13),''),chr(10),'') as statement_source_explain
,is_statement_complete
,replace(replace(t1.currency_code,chr(13),''),chr(10),'') as currency_code
,is_audited
,announcement_date
,currency_funds
,tradable_fnncl_assets
,bills_receivable
,account_receivable
,pre_payment
,interest_receivable
,dividend_receivable
,othr_receivables
,inventory
,nca_due_within_one_year
,othr_current_assets
,current_assets_si
,current_assets_bi
,total_current_assets
,salable_financial_assets
,held_to_maturity_invest
,lt_receivable
,lt_equity_invest
,invest_property
,fixed_asset
,construction_in_process
,project_goods_and_material
,fixed_assets_disposal
,productive_biological_assets
,oil_and_gas_asset
,intangible_assets
,dev_expenditure
,goodwill
,lt_deferred_expense
,dt_assets
,othr_noncurrent_assets
,noncurrent_assets_si
,noncurrent_assets_bi
,total_noncurrent_assets
,central_bank_cash_and_deposit
,interbank_storage
,precious_metal
,lending_fund
,derivative_fnncl_assets
,buy_resale_fnncl_assets
,disbursement_loan_and_advance
,othr_assets
,receivable_invest
,premium_receivable
,subrogation_receivable
,rein_account_receivable
,rein_undue_liability_reserve
,receivable_rein_olr
,receivable_rein_duty_reserve
,receivable_deposit_of_lt_hi
,assured_pledge_loan
,fixed_deposit
,paid_capital_deposit
,separate_account
,customer_fund_deposit
,settle_reserves
,customer_provision
,paid_deposit
,td_seat_fee
,asset_si
,asset_bi
,total_assets
,st_loan
,tradable_fnncl_liab
,bill_payable
,accounts_payable
,pre_receivable
,payroll_payable
,tax_payable
,interest_payable
,dividend_payable
,othr_payables
,noncurrent_liab_due_in1y
,othr_current_liab
,current_liab_si
,current_liab_bi
,total_current_liab
,lt_loan
,bond_payable
,lt_payable
,special_payable
,estimated_liab
,dt_liab
,othr_non_current_liab
,noncurrent_liab_si
,noncurrent_liab_bi
,total_noncurrent_liab
,loan_from_central_bank
,interbank_deposit_etc
,borrowing_funds
,derivative_fnncl_liab
,fnncl_assets_sold_for_repur
,savings_absorption
,othr_liab
,advance_premium
,charge_and_commi_payable
,rein_payable
,claim_payable
,dvdnd_payable_for_the_insured
,assured_saving_and_invest
,unearned_premium_reserve
,reserve_for_outstanding_losses
,life_insurance_reserve
,lt_health_insurance_reserve
,independent_account_liab
,pledged_loan
,acting_td_sec
,act_underwriting_sec
,liab_si
,liab_bi
,total_liab
,shares
,capital_reserve
,treasury_stock
,special_reserve
,earned_surplus
,general_risk_provision
,td_risk_preparation
,undstrbtd_profit
,frgn_currency_convert_diff
,holders_equity_si
,holders_equity_bi
,total_quity_atsopc
,minority_equity
,total_holders_equity
,total_liab_and_holders_equity
,is_statement_released_values
,replace(replace(t1.special_explain,chr(13),''),chr(10),'') as special_explain
,shares_num
,rein_contract_reserve
,saving_and_interbank_deposit
,insurance_contract_reserve
,current_liab_di
,st_bond_payable
,noncurrent_liab_di
,received_deposit
,financing_funds
,receivable
,st_financing_payable
,accrued_payable
,othr_compre_income
,lt_staff_salary_payable
,othr_equity_instruments
,preferred_share
,perpetual_bond
,to_sale_debt
,to_sale_asset
,preferred_shares
,perpetual_capital_sec
,fv_chg_income_fnncl_assets
,amortized_cost_fnncl_assets
,debt_invest
,other_debt_invest
,other_eq_ins_invest
,other_illiquid_fnncl_assets
,contract_liabilities
,contractual_assets
,bp_and_ap
,ar_and_br
,lt_payable_sum
,construction_in_process_sum
,fixed_asset_sum
,other_receivables_sum
,other_payables_sum
,use_right_asset
,receivable_financing
,lease_debt
,total_quity_atsopc_bi
,total_quity_atsopc_si
,agency_business_debt
,agency_business_asset
,unconfirmed_invest_loss
,inventory_dscorce
,develop_exp_dscorce
,inta_asset_dscorce
,insurance_contract_debt
,insurance_contract_asset
,outward_reinsurance_debt
,outward_reinsurance_asset
,isvalid

from ${iol_schema}.uxds_fi_balance_sheet_ns t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_fi_balance_sheet_ns.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
