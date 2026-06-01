: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_hksharebankindicator_a
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_hksharebankindicator.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id 
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode 
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt 
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period 
,t1.statement_type as statement_type 
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code 
,t1.capi_ade_ratio as capi_ade_ratio 
,t1.core_capi_ade_ratio as core_capi_ade_ratio 
,t1.npl_ratio as npl_ratio 
,t1.loan_depo_ratio as loan_depo_ratio 
,t1.total_loan as total_loan 
,t1.total_deposit as total_deposit 
,t1.loan_loss_provision as loan_loss_provision 
,t1.bad_load_five_class as bad_load_five_class 
,t1.npl_provision_coverage as npl_provision_coverage 
,t1.cost_income_ratio as cost_income_ratio 
,t1.net_capital as net_capital 
,t1.core_capi_net_amount as core_capi_net_amount 
,t1.risk_weight_asset as risk_weight_asset 
,t1.interest_bearing_asset as interest_bearing_asset 
,t1.net_interest_margin as net_interest_margin 
,t1.net_interest_spread as net_interest_spread 
,t1.loanreservesratio as loanreservesratio 
,t1.coretier1_net_capi as coretier1_net_capi 
,t1.tier1_net_capi as tier1_net_capi 
,t1.net_capital_2013 as net_capital_2013 
,t1.coretier1capi_ade_ratio as coretier1capi_ade_ratio 
,t1.tier1capi_ade_ratio as tier1capi_ade_ratio 
,t1.capi_ade_ratio_2013 as capi_ade_ratio_2013 
,t1.risk_weight_net_asset_2013 as risk_weight_net_asset_2013 
from ${iol_schema}.wind_hksharebankindicator t1 
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_hksharebankindicator.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes