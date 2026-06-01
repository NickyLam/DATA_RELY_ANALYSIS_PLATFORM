: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_unlistedbankindicator_i
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_unlistedbankindicator.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id 
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt 
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period 
,replace(replace(t1.statement_type,chr(13),''),chr(10),'') as statement_type 
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code 
,t1.capi_ade_ratio as capi_ade_ratio 
,t1.core_capi_ade_ratio as core_capi_ade_ratio 
,t1.npl_ratio as npl_ratio 
,t1.loan_depo_ratio as loan_depo_ratio 
,t1.loan_depo_ratio_rmb as loan_depo_ratio_rmb 
,t1.loan_depo_ratio_normb as loan_depo_ratio_normb 
,t1.st_asset_liq_ratio_rmb as st_asset_liq_ratio_rmb 
,t1.st_asset_liq_ratio_normb as st_asset_liq_ratio_normb 
,t1.loan_from_banks_ratio as loan_from_banks_ratio 
,t1.lend_to_banks_ratio as lend_to_banks_ratio 
,t1.largest_customer_loan as largest_customer_loan 
,t1.top_ten_customer_loan as top_ten_customer_loan 
,t1.total_loan as total_loan 
,t1.total_deposit as total_deposit 
,t1.loan_loss_provision as loan_loss_provision 
,t1.bad_load_five_class as bad_load_five_class 
,t1.npl_provision_coverage as npl_provision_coverage 
,t1.cost_income_ratio as cost_income_ratio 
,t1.non_interest_margin as non_interest_margin 
,t1.net_capital as net_capital 
,t1.core_capi_net_amount as core_capi_net_amount 
,t1.risk_weight_asset as risk_weight_asset 
,t1.interest_bearing_asset as interest_bearing_asset 
,t1.interest_bearing_asset_comp as interest_bearing_asset_comp 
,t1.interest_bearing_lia as interest_bearing_lia 
,t1.interest_bearing_lia_comp as interest_bearing_lia_comp 
,t1.non_interest_income as non_interest_income 
,t1.noneaning_asset as noneaning_asset 
,t1.noneaning_lia as noneaning_lia 
,t1.net_interest_margin as net_interest_margin 
,t1.net_interest_margin_is_ann as net_interest_margin_is_ann 
,t1.net_interest_spread as net_interest_spread 
,t1.net_interest_spread_is_ann as net_interest_spread_is_ann 
,t1.overdue_loan as overdue_loan 
,t1.total_interest_income as total_interest_income 
,t1.total_interest_exp as total_interest_exp 
,t1.cash_on_hand as cash_on_hand 
,t1.longterm_loans_ratio_cny as longterm_loans_ratio_cny 
,t1.longterm_loans_ratio_fc as longterm_loans_ratio_fc 
,t1.ibusiness_loan_ratio as ibusiness_loan_ratio 
,t1.interect_collection_ratio as interect_collection_ratio 
,t1.cash_reserve_ratio_cny as cash_reserve_ratio_cny 
,t1.cash_reserve_ratio_fc as cash_reserve_ratio_fc 
,t1.overseas_funds_app_ratio as overseas_funds_app_ratio 
,t1.market_risk_capital as market_risk_capital 
,t1.interest_bearing_asset_ifpub as interest_bearing_asset_ifpub 
,t1.interest_bearing_lia_ifpub as interest_bearing_lia_ifpub 
,t1.net_interest_margin_ifpub as net_interest_margin_ifpub 
,t1.coretier1capi_ade_ratio as coretier1capi_ade_ratio 
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode 
,t1.tier1capi_ade_ratio as tier1capi_ade_ratio 
,t1.capi_ade_ratio_2013 as capi_ade_ratio_2013 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.wind_unlistedbankindicator t1 
where start_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_unlistedbankindicator.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes