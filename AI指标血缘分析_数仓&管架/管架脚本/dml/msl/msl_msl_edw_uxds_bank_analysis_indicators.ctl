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
infile '${data_path}/uxds_bank_analysis_indicators.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_uxds_bank_analysis_indicators
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,seq char(4000) nullif seq=blanks 
    ,ctime date "yyyy-mm-dd hh24:mi:ss" nullif ctime=blanks 
    ,mtime date "yyyy-mm-dd hh24:mi:ss" nullif mtime=blanks 
    ,rtime date "yyyy-mm-dd hh24:mi:ss" nullif rtime=blanks 
    ,interest_recovery char(4000) nullif interest_recovery=blanks 
    ,rwa_to_general_loan_ratio char(4000) nullif rwa_to_general_loan_ratio=blanks 
    ,corp_code char(4000) nullif corp_code=blanks 
    ,corp_name char(4000) nullif corp_name=blanks 
    ,ed date "yyyy-mm-dd hh24:mi:ss" nullif ed=blanks 
    ,currency_code char(4000) nullif currency_code=blanks 
    ,total_assets char(4000) nullif total_assets=blanks 
    ,net_assets char(4000) nullif net_assets=blanks 
    ,interbank_storage char(4000) nullif interbank_storage=blanks 
    ,interest_earning_assets char(4000) nullif interest_earning_assets=blanks 
    ,market_venture_cap char(4000) nullif market_venture_cap=blanks 
    ,interest_earning_assets_cv char(4000) nullif interest_earning_assets_cv=blanks 
    ,interest_earning_assets_value char(4000) nullif interest_earning_assets_value=blanks 
    ,non_living_asset char(4000) nullif non_living_asset=blanks 
    ,interest_bearing_liab char(4000) nullif interest_bearing_liab=blanks 
    ,interest_bearing_liab_cv char(4000) nullif interest_bearing_liab_cv=blanks 
    ,is_interest_bearing_liab_value char(4000) nullif is_interest_bearing_liab_value=blanks 
    ,non_interest_liab char(4000) nullif non_interest_liab=blanks 
    ,total_deposit_amt char(4000) nullif total_deposit_amt=blanks 
    ,total_loan_amt char(4000) nullif total_loan_amt=blanks 
    ,cash_inv_cfd char(4000) nullif cash_inv_cfd=blanks 
    ,leverage_ratio char(4000) nullif leverage_ratio=blanks 
    ,prov_to_loan_ratio char(4000) nullif prov_to_loan_ratio=blanks 
    ,general_loan char(4000) nullif general_loan=blanks 
    ,recombine_loan char(4000) nullif recombine_loan=blanks 
    ,overdue_loan char(4000) nullif overdue_loan=blanks 
    ,overdue_loan_ratio char(4000) nullif overdue_loan_ratio=blanks 
    ,bad_loan char(4000) nullif bad_loan=blanks 
    ,bad_loan_ratio char(4000) nullif bad_loan_ratio=blanks 
    ,overdue_loan_mrth_90d char(4000) nullif overdue_loan_mrth_90d=blanks 
    ,loans_to_eassets_ratio char(4000) nullif loans_to_eassets_ratio=blanks 
    ,interbank_assets_ratio char(4000) nullif interbank_assets_ratio=blanks 
    ,total_liab char(4000) nullif total_liab=blanks 
    ,interbank_deposit_etc char(4000) nullif interbank_deposit_etc=blanks 
    ,deposit_to_ibl_ratio char(4000) nullif deposit_to_ibl_ratio=blanks 
    ,interbank_liab_ratio char(4000) nullif interbank_liab_ratio=blanks 
    ,bank_wproduct_balance char(4000) nullif bank_wproduct_balance=blanks 
    ,loan_ratio_slc char(4000) nullif loan_ratio_slc=blanks 
    ,top10_customer_loan_ratio char(4000) nullif top10_customer_loan_ratio=blanks 
    ,normal_asset char(4000) nullif normal_asset=blanks 
    ,normal_proportion char(4000) nullif normal_proportion=blanks 
    ,special_mention_asset char(4000) nullif special_mention_asset=blanks 
    ,special_proportion char(4000) nullif special_proportion=blanks 
    ,substandard_asset char(4000) nullif substandard_asset=blanks 
    ,substandard_proportion char(4000) nullif substandard_proportion=blanks 
    ,suspicious_asset char(4000) nullif suspicious_asset=blanks 
    ,suspicious_proportion char(4000) nullif suspicious_proportion=blanks 
    ,loss_asset char(4000) nullif loss_asset=blanks 
    ,loss_proportion char(4000) nullif loss_proportion=blanks 
    ,provision_coverage char(4000) nullif provision_coverage=blanks 
    ,loan_loss_reserve char(4000) nullif loan_loss_reserve=blanks 
    ,loan_loss_resr_cover_ratio char(4000) nullif loan_loss_resr_cover_ratio=blanks 
    ,normal_loan_migration_rate char(4000) nullif normal_loan_migration_rate=blanks 
    ,focused_loan_migration_rate char(4000) nullif focused_loan_migration_rate=blanks 
    ,subprime_loan_migration_rate char(4000) nullif subprime_loan_migration_rate=blanks 
    ,suspicious_loan_migration_rate char(4000) nullif suspicious_loan_migration_rate=blanks 
    ,deposit_loan_ratio char(4000) nullif deposit_loan_ratio=blanks 
    ,deposit_and_loan_ratio_rmb char(4000) nullif deposit_and_loan_ratio_rmb=blanks 
    ,deposit_and_loan_ratio_fc char(4000) nullif deposit_and_loan_ratio_fc=blanks 
    ,lending_funds_ratio char(4000) nullif lending_funds_ratio=blanks 
    ,borrowing_funds_ratio char(4000) nullif borrowing_funds_ratio=blanks 
    ,provision_ratio_rmb char(4000) nullif provision_ratio_rmb=blanks 
    ,provision_ratio_fc char(4000) nullif provision_ratio_fc=blanks 
    ,mal_loan_ratio_rmb char(4000) nullif mal_loan_ratio_rmb=blanks 
    ,mal_loan_ratio_fc char(4000) nullif mal_loan_ratio_fc=blanks 
    ,st_asset_flow_ratio char(4000) nullif st_asset_flow_ratio=blanks 
    ,st_assets_liquid_ratio char(4000) nullif st_assets_liquid_ratio=blanks 
    ,st_asset_liquid_ratio_fc char(4000) nullif st_asset_liquid_ratio_fc=blanks 
    ,lcr char(4000) nullif lcr=blanks 
    ,net_interest_margin char(4000) nullif net_interest_margin=blanks 
    ,net_interest_margin_cv char(4000) nullif net_interest_margin_cv=blanks 
    ,is_net_interest_margin_value char(4000) nullif is_net_interest_margin_value=blanks 
    ,net_profit_margin char(4000) nullif net_profit_margin=blanks 
    ,np_margin_cv char(4000) nullif np_margin_cv=blanks 
    ,is_np_margin_value char(4000) nullif is_np_margin_value=blanks 
    ,living_asset_avg_interest char(4000) nullif living_asset_avg_interest=blanks 
    ,interest_liab_avg_interest char(4000) nullif interest_liab_avg_interest=blanks 
    ,non_interest_income char(4000) nullif non_interest_income=blanks 
    ,non_interest_income_ratio char(4000) nullif non_interest_income_ratio=blanks 
    ,cost_to_income_ratio char(4000) nullif cost_to_income_ratio=blanks 
    ,net_capital char(4000) nullif net_capital=blanks 
    ,net_core_capital char(4000) nullif net_core_capital=blanks 
    ,net_primary_capital_net_amt char(4000) nullif net_primary_capital_net_amt=blanks 
    ,net_core_first_capital char(4000) nullif net_core_first_capital=blanks 
    ,capital_adequacy_ratio char(4000) nullif capital_adequacy_ratio=blanks 
    ,core_capital_adequacy_ratio char(4000) nullif core_capital_adequacy_ratio=blanks 
    ,first_capital_adequacy_ratio char(4000) nullif first_capital_adequacy_ratio=blanks 
    ,core_fc_adequacy_ratio char(4000) nullif core_fc_adequacy_ratio=blanks 
    ,wgt_risk_net_amt char(4000) nullif wgt_risk_net_amt=blanks 
    ,rwa_to_total_asset_ratio char(4000) nullif rwa_to_total_asset_ratio=blanks 
    ,rwa_to_ear_asset_ratio char(4000) nullif rwa_to_ear_asset_ratio=blanks 
    ,rwa_to_total_loan_ratio char(4000) nullif rwa_to_total_loan_ratio=blanks 
    ,isvalid char(4000) nullif isvalid=blanks 
)