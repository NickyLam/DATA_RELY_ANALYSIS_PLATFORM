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
infile '${data_path}/uxds_bank_special_fnncl_indicator.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,seq char(4000) nullif seq=blanks 
    ,ctime date "yyyy-mm-dd hh24:mi:ss" nullif ctime=blanks 
    ,mtime date "yyyy-mm-dd hh24:mi:ss" nullif mtime=blanks 
    ,rtime date "yyyy-mm-dd hh24:mi:ss" nullif rtime=blanks 
    ,corp_code char(4000) nullif corp_code=blanks 
    ,ed date "yyyy-mm-dd hh24:mi:ss" nullif ed=blanks 
    ,total_deposit_amt char(4000) nullif total_deposit_amt=blanks 
    ,total_loan_amt char(4000) nullif total_loan_amt=blanks 
    ,loan_loss_reserve char(4000) nullif loan_loss_reserve=blanks 
    ,bad_loan_ratio char(4000) nullif bad_loan_ratio=blanks 
    ,capital_adequacy_ratio char(4000) nullif capital_adequacy_ratio=blanks 
    ,core_capital_adequacy_ratio char(4000) nullif core_capital_adequacy_ratio=blanks 
    ,bad_loan char(4000) nullif bad_loan=blanks 
    ,provision_coverage char(4000) nullif provision_coverage=blanks 
    ,deposit_loan_ratio char(4000) nullif deposit_loan_ratio=blanks 
    ,deposit_and_loan_ratio_rmb char(4000) nullif deposit_and_loan_ratio_rmb=blanks 
    ,deposit_and_loan_ratio_fc char(4000) nullif deposit_and_loan_ratio_fc=blanks 
    ,st_assets_liquid_ratio char(4000) nullif st_assets_liquid_ratio=blanks 
    ,st_asset_liquid_ratio_fc char(4000) nullif st_asset_liquid_ratio_fc=blanks 
    ,lending_funds_ratio char(4000) nullif lending_funds_ratio=blanks 
    ,borrowing_funds_ratio char(4000) nullif borrowing_funds_ratio=blanks 
    ,provision_ratio_rmb char(4000) nullif provision_ratio_rmb=blanks 
    ,provision_ratio_fc char(4000) nullif provision_ratio_fc=blanks 
    ,interest_recovery char(4000) nullif interest_recovery=blanks 
    ,net_interest_margin char(4000) nullif net_interest_margin=blanks 
    ,non_interest_income_ratio char(4000) nullif non_interest_income_ratio=blanks 
    ,living_asset_avg_interest char(4000) nullif living_asset_avg_interest=blanks 
    ,interest_liab_avg_interest char(4000) nullif interest_liab_avg_interest=blanks 
    ,loan_ratio_slc char(4000) nullif loan_ratio_slc=blanks 
    ,cost_to_income_ratio char(4000) nullif cost_to_income_ratio=blanks 
    ,non_interest_liab char(4000) nullif non_interest_liab=blanks 
    ,non_living_asset char(4000) nullif non_living_asset=blanks 
    ,net_core_capital char(4000) nullif net_core_capital=blanks 
    ,interest_bearing_liab char(4000) nullif interest_bearing_liab=blanks 
    ,interest_bearing_liab_cv char(4000) nullif interest_bearing_liab_cv=blanks 
    ,is_interest_bearing_liab_value char(4000) nullif is_interest_bearing_liab_value=blanks 
    ,wgt_risk_net_amt char(4000) nullif wgt_risk_net_amt=blanks 
    ,net_profit_margin char(4000) nullif net_profit_margin=blanks 
    ,net_interest_margin_cv char(4000) nullif net_interest_margin_cv=blanks 
    ,is_np_margin_value char(4000) nullif is_np_margin_value=blanks 
    ,np_margin_cv char(4000) nullif np_margin_cv=blanks 
    ,is_net_interest_margin_value char(4000) nullif is_net_interest_margin_value=blanks 
    ,interest_earning_assets char(4000) nullif interest_earning_assets=blanks 
    ,interest_earning_assets_cv char(4000) nullif interest_earning_assets_cv=blanks 
    ,interest_earning_assets_value char(4000) nullif interest_earning_assets_value=blanks 
    ,market_venture_cap char(4000) nullif market_venture_cap=blanks 
    ,net_capital char(4000) nullif net_capital=blanks 
    ,top10_customer_loan_ratio char(4000) nullif top10_customer_loan_ratio=blanks 
    ,bad_loan_ratio_third_classi char(4000) nullif bad_loan_ratio_third_classi=blanks 
    ,non_interest_income char(4000) nullif non_interest_income=blanks 
    ,cash_inv_cfd char(4000) nullif cash_inv_cfd=blanks 
    ,first_capital_adequacy_ratio char(4000) nullif first_capital_adequacy_ratio=blanks 
    ,core_fc_adequacy_ratio char(4000) nullif core_fc_adequacy_ratio=blanks 
    ,net_primary_capital_net_amt char(4000) nullif net_primary_capital_net_amt=blanks 
    ,net_core_first_capital char(4000) nullif net_core_first_capital=blanks 
    ,lcr char(4000) nullif lcr=blanks 
    ,leverage_ratio char(4000) nullif leverage_ratio=blanks 
    ,overdue_loan char(4000) nullif overdue_loan=blanks 
    ,overdue_loan_ratio char(4000) nullif overdue_loan_ratio=blanks 
    ,overdue_loan_of_more_than_90d char(4000) nullif overdue_loan_of_more_than_90d=blanks 
    ,recombine_loan char(4000) nullif recombine_loan=blanks 
    ,normal_loan_migration_rate char(4000) nullif normal_loan_migration_rate=blanks 
    ,focused_loan_migration_rate char(4000) nullif focused_loan_migration_rate=blanks 
    ,subprime_loan_migration_rate char(4000) nullif subprime_loan_migration_rate=blanks 
    ,suspicious_loan_migration_rate char(4000) nullif suspicious_loan_migration_rate=blanks 
    ,mal_loan_ratio_fc char(4000) nullif mal_loan_ratio_fc=blanks 
    ,mal_loan_ratio_rmb char(4000) nullif mal_loan_ratio_rmb=blanks 
    ,currency_code char(4000) nullif currency_code=blanks 
    ,st_asset_flow_ratio char(4000) nullif st_asset_flow_ratio=blanks 
    ,normal_asset char(4000) nullif normal_asset=blanks 
    ,normal_asset_ratio char(4000) nullif normal_asset_ratio=blanks 
    ,special_mention_asset char(4000) nullif special_mention_asset=blanks 
    ,special_mention_asset_ratio char(4000) nullif special_mention_asset_ratio=blanks 
    ,sub_asset char(4000) nullif sub_asset=blanks 
    ,sub_asset_ratio char(4000) nullif sub_asset_ratio=blanks 
    ,doubtful_asset char(4000) nullif doubtful_asset=blanks 
    ,doubtful_asset_ratio char(4000) nullif doubtful_asset_ratio=blanks 
    ,loss_asset char(4000) nullif loss_asset=blanks 
    ,loss_asset_ratio char(4000) nullif loss_asset_ratio=blanks 
    ,bank_wproduct_balance char(4000) nullif bank_wproduct_balance=blanks 
    ,credit_card_credit_limit char(4000) nullif credit_card_credit_limit=blanks 
    ,issue_guarantee_letter char(4000) nullif issue_guarantee_letter=blanks 
    ,issue_credit_letter char(4000) nullif issue_credit_letter=blanks 
    ,adj_asset_balance char(4000) nullif adj_asset_balance=blanks 
    ,loan_commitment char(4000) nullif loan_commitment=blanks 
    ,acceptance_bill char(4000) nullif acceptance_bill=blanks 
    ,credit_risk_wgt_asset char(4000) nullif credit_risk_wgt_asset=blanks 
    ,net_stable_funds_ratio char(4000) nullif net_stable_funds_ratio=blanks 
    ,available_stable_funds_ratio char(4000) nullif available_stable_funds_ratio=blanks 
    ,market_risk_wgt_asset char(4000) nullif market_risk_wgt_asset=blanks 
    ,needed_stable_funds_ratio char(4000) nullif needed_stable_funds_ratio=blanks 
    ,prov_to_loan_ratio char(4000) nullif prov_to_loan_ratio=blanks 
    ,operational_risk_wgt_asset char(4000) nullif operational_risk_wgt_asset=blanks 
    ,green_credit_balance char(4000) nullif green_credit_balance=blanks 
    ,isvalid char(4000) nullif isvalid=blanks 
)