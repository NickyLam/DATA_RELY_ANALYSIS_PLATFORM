: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_ic_solvency_indicator_f
CreateDate: 20251105
FileName:   ${iel_data_path}/uxds_ic_solvency_indicator.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,announcement_date
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,ed
,replace(replace(t1.statement_type_code,chr(13),''),chr(10),'') as statement_type_code
,replace(replace(t1.report_type_code,chr(13),''),chr(10),'') as report_type_code
,statement_year
,chg_seq
,is_latest
,core_smpa
,core_smr
,total_smpa
,total_smr
,insurance_business_income
,net_profit
,net_asset
,approved_asset
,approved_debt
,actual_capital
,actual_first_core_capital
,actual_second_core_capital
,actual_first_sub_capital
,actual_sub_core_capital
,min_capital
,min_quantify_risk_capital
,min_contral_risk_capital
,min_sub_capital
,min_lifeinsur_risk_capital
,min_non_lifeinsur_risk_capital
,min_market_risk_capital
,min_credit_risk_capital
,quantify_risk_disperse_effect
,spe_contract_loss_absorption
,replace(replace(t1.latest_risk_rating,chr(13),''),chr(10),'') as latest_risk_rating
,replace(replace(t1.latest_risk_rating_time,chr(13),''),chr(10),'') as latest_risk_rating_time
,net_cash_flow
,net_cash_flow_1y
,net_cash_flow_2y
,net_cash_flow_3y
,total_current_ratio_within_3m
,total_current_ratio_within_1y
,total_current_ratio_over_1y
,total_current_ratio_1y_to_3y
,total_current_ratio_3y_to_5y
,total_current_ratio_over_5y
,lcr_corp_stress_scenario1
,lcr_corp_stress_scenario2
,lcr_account_stress_scenario1
,lcr_account_stress_scenario2
,replace(replace(t1.currency_code,chr(13),''),chr(10),'') as currency_code
,isvalid

from ${iol_schema}.uxds_ic_solvency_indicator t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_ic_solvency_indicator.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
