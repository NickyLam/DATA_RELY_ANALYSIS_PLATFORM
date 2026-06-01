-- SQL* Unloader: Fast Oracle TetUnloader (Gzip),Release 3.0.1
-- (@) Copyright Lou Fangxin (AnySQL.net) 2004 -2010, all rigths reserved.
-- Purpose:    Sqlldr Control File
-- Author:     Sunline
-- CreateDate: 20190705
-- FileType:   Control-File
-- Logs:
--     luzd 2019-07-05 create template

options(bindsize=2097152,readsize=2097152,errors=0,rows=5000)
load data
infile '${data_path}/uxds_income_statement_ns.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_uxds_income_statement_ns
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,seq char(4000) nullif seq=blanks 
    ,ctime date "yyyy-mm-dd hh24:mi:ss" nullif ctime=blanks 
    ,mtime date "yyyy-mm-dd hh24:mi:ss" nullif mtime=blanks 
    ,rtime date "yyyy-mm-dd hh24:mi:ss" nullif rtime=blanks 
    ,org_id char(4000) nullif org_id=blanks 
    ,org_name char(4000) nullif org_name=blanks 
    ,sd date "yyyy-mm-dd hh24:mi:ss" nullif sd=blanks 
    ,ed date "yyyy-mm-dd hh24:mi:ss" nullif ed=blanks 
    ,statement_type_code char(4000) nullif statement_type_code=blanks 
    ,statement_type char(4000) nullif statement_type=blanks 
    ,chg_seq char(4000) nullif chg_seq=blanks 
    ,statement_format_code char(4000) nullif statement_format_code=blanks 
    ,statement_format char(4000) nullif statement_format=blanks 
    ,sas_code char(4000) nullif sas_code=blanks 
    ,sas char(4000) nullif sas=blanks 
    ,announ_seq char(4000) nullif announ_seq=blanks 
    ,data_source_code char(4000) nullif data_source_code=blanks 
    ,data_source char(4000) nullif data_source=blanks 
    ,statement_source_explain char(4000) nullif statement_source_explain=blanks 
    ,is_statement_complete char(4000) nullif is_statement_complete=blanks 
    ,currency_code char(4000) nullif currency_code=blanks 
    ,is_audited char(4000) nullif is_audited=blanks 
    ,announcement_date date "yyyy-mm-dd hh24:mi:ss" nullif announcement_date=blanks 
    ,total_revenue char(4000) nullif total_revenue=blanks 
    ,revenue char(4000) nullif revenue=blanks 
    ,interest_net_income char(4000) nullif interest_net_income=blanks 
    ,interest_income char(4000) nullif interest_income=blanks 
    ,interest_payout char(4000) nullif interest_payout=blanks 
    ,commi_net_income char(4000) nullif commi_net_income=blanks 
    ,fee_and_commi_income char(4000) nullif fee_and_commi_income=blanks 
    ,charge_and_commi_expenses char(4000) nullif charge_and_commi_expenses=blanks 
    ,othr_income char(4000) nullif othr_income=blanks 
    ,earned_premium char(4000) nullif earned_premium=blanks 
    ,insurance_income char(4000) nullif insurance_income=blanks 
    ,rein_premium_income char(4000) nullif rein_premium_income=blanks 
    ,ceded_out_premium char(4000) nullif ceded_out_premium=blanks 
    ,draw_undueduty_deposit char(4000) nullif draw_undueduty_deposit=blanks 
    ,net_income_from_brokerage char(4000) nullif net_income_from_brokerage=blanks 
    ,net_income_from_invest_banking char(4000) nullif net_income_from_invest_banking=blanks 
    ,asset_manage_service_charge_ni char(4000) nullif asset_manage_service_charge_ni=blanks 
    ,operating_total_revenue_si char(4000) nullif operating_total_revenue_si=blanks 
    ,operating_costs char(4000) nullif operating_costs=blanks 
    ,operating_cost char(4000) nullif operating_cost=blanks 
    ,operating_taxes_and_surcharge char(4000) nullif operating_taxes_and_surcharge=blanks 
    ,sales_fee char(4000) nullif sales_fee=blanks 
    ,manage_fee char(4000) nullif manage_fee=blanks 
    ,financing_expenses char(4000) nullif financing_expenses=blanks 
    ,asset_impairment_loss char(4000) nullif asset_impairment_loss=blanks 
    ,operating_payout char(4000) nullif operating_payout=blanks 
    ,business_and_manage_fee char(4000) nullif business_and_manage_fee=blanks 
    ,othr_business_costs char(4000) nullif othr_business_costs=blanks 
    ,refunded_premium char(4000) nullif refunded_premium=blanks 
    ,compen_payout char(4000) nullif compen_payout=blanks 
    ,compen_expense char(4000) nullif compen_expense=blanks 
    ,draw_duty_deposit char(4000) nullif draw_duty_deposit=blanks 
    ,amortized_deposit_for_duty char(4000) nullif amortized_deposit_for_duty=blanks 
    ,commi_on_insurance_policy char(4000) nullif commi_on_insurance_policy=blanks 
    ,rein_expenditure char(4000) nullif rein_expenditure=blanks 
    ,amortized_rein_expenditure char(4000) nullif amortized_rein_expenditure=blanks 
    ,operating_total_cost_si char(4000) nullif operating_total_cost_si=blanks 
    ,income_from_chg_in_fv char(4000) nullif income_from_chg_in_fv=blanks 
    ,invest_income char(4000) nullif invest_income=blanks 
    ,invest_incomes_from_rr char(4000) nullif invest_incomes_from_rr=blanks 
    ,exchg_gain char(4000) nullif exchg_gain=blanks 
    ,op char(4000) nullif op=blanks 
    ,non_operating_income char(4000) nullif non_operating_income=blanks 
    ,non_operating_payout char(4000) nullif non_operating_payout=blanks 
    ,noncurrent_asset_disposal_loss char(4000) nullif noncurrent_asset_disposal_loss=blanks 
    ,profit_total_amt char(4000) nullif profit_total_amt=blanks 
    ,income_tax_expenses char(4000) nullif income_tax_expenses=blanks 
    ,net_profit char(4000) nullif net_profit=blanks 
    ,net_profit_atsopc char(4000) nullif net_profit_atsopc=blanks 
    ,minority_gal char(4000) nullif minority_gal=blanks 
    ,othr_compre_income char(4000) nullif othr_compre_income=blanks 
    ,total_compre_income char(4000) nullif total_compre_income=blanks 
    ,total_compre_income_atsopc char(4000) nullif total_compre_income_atsopc=blanks 
    ,total_compre_income_atms char(4000) nullif total_compre_income_atms=blanks 
    ,is_statement_released_values char(4000) nullif is_statement_released_values=blanks 
    ,operating_total_revenue_bi char(4000) nullif operating_total_revenue_bi=blanks 
    ,operating_total_cost_bi char(4000) nullif operating_total_cost_bi=blanks 
    ,op_si char(4000) nullif op_si=blanks 
    ,op_bi char(4000) nullif op_bi=blanks 
    ,total_profit_si char(4000) nullif total_profit_si=blanks 
    ,total_profit_bi char(4000) nullif total_profit_bi=blanks 
    ,net_profit_si char(4000) nullif net_profit_si=blanks 
    ,net_profit_bi char(4000) nullif net_profit_bi=blanks 
    ,basic_eps char(4000) nullif basic_eps=blanks 
    ,dlt_earnings_per_share char(4000) nullif dlt_earnings_per_share=blanks 
    ,special_explain char(4000) nullif special_explain=blanks 
    ,noncurrent_assets_dispose_gain char(4000) nullif noncurrent_assets_dispose_gain=blanks 
    ,othr_compre_income_atoopc char(4000) nullif othr_compre_income_atoopc=blanks 
    ,othr_ci_nonreclassi_into_gal char(4000) nullif othr_ci_nonreclassi_into_gal=blanks 
    ,net_debt_or_na_chg_reclac char(4000) nullif net_debt_or_na_chg_reclac=blanks 
    ,can_not_be_reclassi_em char(4000) nullif can_not_be_reclassi_em=blanks 
    ,othr_ci_to_reclassi_into_gal char(4000) nullif othr_ci_to_reclassi_into_gal=blanks 
    ,will_reclassi_equity_method char(4000) nullif will_reclassi_equity_method=blanks 
    ,salable_fnncl_asset_fvc_gal char(4000) nullif salable_fnncl_asset_fvc_gal=blanks 
    ,htm_salable_fnncl_asset_gal char(4000) nullif htm_salable_fnncl_asset_gal=blanks 
    ,cash_flow_gal_valid_part char(4000) nullif cash_flow_gal_valid_part=blanks 
    ,frgn_currency_statement_diff char(4000) nullif frgn_currency_statement_diff=blanks 
    ,other_reclassi char(4000) nullif other_reclassi=blanks 
    ,othr_compre_income_atms char(4000) nullif othr_compre_income_atms=blanks 
    ,other_not_reclassi char(4000) nullif other_not_reclassi=blanks 
    ,other_income char(4000) nullif other_income=blanks 
    ,asset_disposal_income char(4000) nullif asset_disposal_income=blanks 
    ,stop_operating_np char(4000) nullif stop_operating_np=blanks 
    ,continous_operating_np char(4000) nullif continous_operating_np=blanks 
    ,cash_flow_hedging_reserve char(4000) nullif cash_flow_hedging_reserve=blanks 
    ,other_eq_ins_invest_fv_chg char(4000) nullif other_eq_ins_invest_fv_chg=blanks 
    ,credit_risk_fv_chg char(4000) nullif credit_risk_fv_chg=blanks 
    ,other_debt_invest_fv_chg char(4000) nullif other_debt_invest_fv_chg=blanks 
    ,fnncl_assets_rec_other_income char(4000) nullif fnncl_assets_rec_other_income=blanks 
    ,other_debt_invest_credit_loss char(4000) nullif other_debt_invest_credit_loss=blanks 
    ,credit_impairment_loss char(4000) nullif credit_impairment_loss=blanks 
    ,finance_cost_interest_fee char(4000) nullif finance_cost_interest_fee=blanks 
    ,net_exposure_hedging_benefits char(4000) nullif net_exposure_hedging_benefits=blanks 
    ,finance_cost_interest_income char(4000) nullif finance_cost_interest_income=blanks 
    ,rad_cost char(4000) nullif rad_cost=blanks 
    ,general_corp_operating_cost_pf char(4000) nullif general_corp_operating_cost_pf=blanks 
    ,amortized_cost_fnncl_asset_tce char(4000) nullif amortized_cost_fnncl_asset_tce=blanks 
    ,isvalid char(4000) nullif isvalid=blanks 
)