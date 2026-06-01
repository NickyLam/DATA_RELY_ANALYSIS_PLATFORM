: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_bank_analysis_indicators_f
CreateDate: 20250605
FileName:   ${iel_data_path}/uxds_bank_analysis_indicators.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,interest_recovery
,rwa_to_general_loan_ratio
,replace(replace(t1.corp_code,chr(13),''),chr(10),'') as corp_code
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,ed
,replace(replace(t1.currency_code,chr(13),''),chr(10),'') as currency_code
,total_assets
,net_assets
,interbank_storage
,interest_earning_assets
,market_venture_cap
,interest_earning_assets_cv
,interest_earning_assets_value
,non_living_asset
,interest_bearing_liab
,interest_bearing_liab_cv
,is_interest_bearing_liab_value
,non_interest_liab
,total_deposit_amt
,total_loan_amt
,cash_inv_cfd
,leverage_ratio
,prov_to_loan_ratio
,general_loan
,recombine_loan
,overdue_loan
,overdue_loan_ratio
,bad_loan
,bad_loan_ratio
,overdue_loan_mrth_90d
,loans_to_eassets_ratio
,interbank_assets_ratio
,total_liab
,interbank_deposit_etc
,deposit_to_ibl_ratio
,interbank_liab_ratio
,bank_wproduct_balance
,loan_ratio_slc
,top10_customer_loan_ratio
,normal_asset
,normal_proportion
,special_mention_asset
,special_proportion
,substandard_asset
,substandard_proportion
,suspicious_asset
,suspicious_proportion
,loss_asset
,loss_proportion
,provision_coverage
,loan_loss_reserve
,loan_loss_resr_cover_ratio
,normal_loan_migration_rate
,focused_loan_migration_rate
,subprime_loan_migration_rate
,suspicious_loan_migration_rate
,deposit_loan_ratio
,deposit_and_loan_ratio_rmb
,deposit_and_loan_ratio_fc
,lending_funds_ratio
,borrowing_funds_ratio
,provision_ratio_rmb
,provision_ratio_fc
,mal_loan_ratio_rmb
,mal_loan_ratio_fc
,st_asset_flow_ratio
,st_assets_liquid_ratio
,st_asset_liquid_ratio_fc
,lcr
,net_interest_margin
,net_interest_margin_cv
,is_net_interest_margin_value
,net_profit_margin
,np_margin_cv
,is_np_margin_value
,living_asset_avg_interest
,interest_liab_avg_interest
,non_interest_income
,non_interest_income_ratio
,cost_to_income_ratio
,net_capital
,net_core_capital
,net_primary_capital_net_amt
,net_core_first_capital
,capital_adequacy_ratio
,core_capital_adequacy_ratio
,first_capital_adequacy_ratio
,core_fc_adequacy_ratio
,wgt_risk_net_amt
,rwa_to_total_asset_ratio
,rwa_to_ear_asset_ratio
,rwa_to_total_loan_ratio
,isvalid

from ${iol_schema}.uxds_bank_analysis_indicators t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_bank_analysis_indicators.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
