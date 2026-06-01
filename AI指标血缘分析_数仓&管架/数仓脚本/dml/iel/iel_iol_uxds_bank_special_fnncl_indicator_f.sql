: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_bank_special_fnncl_indicator_f
CreateDate: 20250605
FileName:   ${iel_data_path}/uxds_bank_special_fnncl_indicator.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,replace(replace(t1.corp_code,chr(13),''),chr(10),'') as corp_code
,ed
,total_deposit_amt
,total_loan_amt
,loan_loss_reserve
,bad_loan_ratio
,capital_adequacy_ratio
,core_capital_adequacy_ratio
,bad_loan
,provision_coverage
,deposit_loan_ratio
,deposit_and_loan_ratio_rmb
,deposit_and_loan_ratio_fc
,st_assets_liquid_ratio
,st_asset_liquid_ratio_fc
,lending_funds_ratio
,borrowing_funds_ratio
,provision_ratio_rmb
,provision_ratio_fc
,interest_recovery
,net_interest_margin
,non_interest_income_ratio
,living_asset_avg_interest
,interest_liab_avg_interest
,loan_ratio_slc
,cost_to_income_ratio
,non_interest_liab
,non_living_asset
,net_core_capital
,interest_bearing_liab
,interest_bearing_liab_cv
,is_interest_bearing_liab_value
,wgt_risk_net_amt
,net_profit_margin
,net_interest_margin_cv
,is_np_margin_value
,np_margin_cv
,is_net_interest_margin_value
,interest_earning_assets
,interest_earning_assets_cv
,interest_earning_assets_value
,market_venture_cap
,net_capital
,top10_customer_loan_ratio
,bad_loan_ratio_third_classi
,non_interest_income
,cash_inv_cfd
,first_capital_adequacy_ratio
,core_fc_adequacy_ratio
,net_primary_capital_net_amt
,net_core_first_capital
,lcr
,leverage_ratio
,overdue_loan
,overdue_loan_ratio
,overdue_loan_of_more_than_90d
,recombine_loan
,normal_loan_migration_rate
,focused_loan_migration_rate
,subprime_loan_migration_rate
,suspicious_loan_migration_rate
,mal_loan_ratio_fc
,mal_loan_ratio_rmb
,replace(replace(t1.currency_code,chr(13),''),chr(10),'') as currency_code
,st_asset_flow_ratio
,normal_asset
,normal_asset_ratio
,special_mention_asset
,special_mention_asset_ratio
,sub_asset
,sub_asset_ratio
,doubtful_asset
,doubtful_asset_ratio
,loss_asset
,loss_asset_ratio
,bank_wproduct_balance
,credit_card_credit_limit
,issue_guarantee_letter
,issue_credit_letter
,adj_asset_balance
,loan_commitment
,acceptance_bill
,credit_risk_wgt_asset
,net_stable_funds_ratio
,available_stable_funds_ratio
,market_risk_wgt_asset
,needed_stable_funds_ratio
,prov_to_loan_ratio
,operational_risk_wgt_asset
,green_credit_balance
,isvalid

from ${iol_schema}.uxds_bank_special_fnncl_indicator t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_bank_special_fnncl_indicator.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
