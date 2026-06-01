: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_fi_income_statement_ns_f
CreateDate: 20251105
FileName:   ${iel_data_path}/uxds_fi_income_statement_ns.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,financing_expenses
,other_not_reclassi
,manage_fee
,sales_fee
,other_reclassi
,asset_disposal_income
,stop_operating_np
,continous_operating_np
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,sd
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
,total_revenue
,revenue
,interest_net_income
,interest_income
,interest_payout
,commi_net_income
,fee_and_commi_income
,charge_and_commi_expenses
,othr_income
,earned_premium
,insurance_income
,rein_premium_income
,ceded_out_premium
,draw_undueduty_deposit
,net_income_from_brokerage
,net_income_from_invest_banking
,asset_manage_service_charge_ni
,operating_total_revenue_si
,operating_costs
,operating_cost
,operating_taxes_and_surcharge
,asset_impairment_loss
,operating_payout
,business_and_manage_fee
,othr_business_costs
,refunded_premium
,compen_payout
,compen_expense
,draw_duty_deposit
,amortized_deposit_for_duty
,commi_on_insurance_policy
,rein_expenditure
,amortized_rein_expenditure
,operating_total_cost_si
,income_from_chg_in_fv
,invest_income
,invest_incomes_from_rr
,exchg_gain
,op
,non_operating_income
,non_operating_payout
,noncurrent_asset_disposal_loss
,profit_total_amt
,income_tax_expenses
,net_profit
,net_profit_atsopc
,minority_gal
,othr_compre_income
,total_compre_income
,total_compre_income_atsopc
,total_compre_income_atms
,is_statement_released_values
,operating_total_revenue_bi
,operating_total_cost_bi
,op_si
,op_bi
,total_profit_si
,total_profit_bi
,net_profit_si
,net_profit_bi
,basic_eps
,dlt_earnings_per_share
,replace(replace(t1.special_explain,chr(13),''),chr(10),'') as special_explain
,noncurrent_assets_dispose_gain
,othr_compre_income_atoopc
,othr_ci_nonreclassi_into_gal
,net_debt_or_na_chg_reclac
,can_not_be_reclassi_em
,othr_ci_to_reclassi_into_gal
,will_reclassi_equity_method
,salable_fnncl_asset_fvc_gal
,htm_salable_fnncl_asset_gal
,cash_flow_gal_valid_part
,frgn_currency_statement_diff
,othr_compre_income_atms
,other_income
,cash_flow_hedging_reserve
,other_eq_ins_invest_fv_chg
,credit_risk_fv_chg
,other_debt_invest_fv_chg
,fnncl_assets_rec_other_income
,other_debt_invest_credit_loss
,credit_impairment_loss
,finance_cost_interest_fee
,net_exposure_hedging_benefits
,finance_cost_interest_income
,rad_cost
,general_corp_operating_cost_pf
,amortized_cost_fnncl_asset_tce
,main_business_income
,main_business_cost
,main_business_profit
,operating_costs_publish
,asset_impairment_loss_publish
,credit_impairment_loss_publish
,unconfirmed_invest_loss
,convertible_contract_fin_chg
,convertible_owcontract_fin_chg
,unconvertible_contract_fin_chg
,insure_service_income
,insure_service_fee
,outward_reinsure_income
,amortize_insure_service_fee
,apportion_ceded_premium
,underwrite_financial_loss
,isvalid

from ${iol_schema}.uxds_fi_income_statement_ns t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_fi_income_statement_ns.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
