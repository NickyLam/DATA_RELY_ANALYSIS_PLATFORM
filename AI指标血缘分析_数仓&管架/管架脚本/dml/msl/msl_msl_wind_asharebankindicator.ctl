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
infile '${data_path}/wind_asharebankindicator.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_wind_asharebankindicator
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,OBJECT_ID char(4000) nullif OBJECT_ID=blanks 
    ,S_INFO_WINDCODE char(4000) nullif S_INFO_WINDCODE=blanks 
    ,ANN_DT char(4000) nullif ANN_DT=blanks 
    ,REPORT_PERIOD char(4000) nullif REPORT_PERIOD=blanks 
    ,STATEMENT_TYPE char(4000) nullif STATEMENT_TYPE=blanks 
    ,CRNCY_CODE char(4000) nullif CRNCY_CODE=blanks 
    ,CAPI_ADE_RATIO char(4000) nullif CAPI_ADE_RATIO=blanks 
    ,CORE_CAPI_ADE_RATIO char(4000) nullif CORE_CAPI_ADE_RATIO=blanks 
    ,NPL_RATIO char(4000) nullif NPL_RATIO=blanks 
    ,LOAN_DEPO_RATIO char(4000) nullif LOAN_DEPO_RATIO=blanks 
    ,LOAN_DEPO_RATIO_RMB char(4000) nullif LOAN_DEPO_RATIO_RMB=blanks 
    ,LOAN_DEPO_RATIO_NORMB char(4000) nullif LOAN_DEPO_RATIO_NORMB=blanks 
    ,ST_ASSET_LIQ_RATIO_RMB char(4000) nullif ST_ASSET_LIQ_RATIO_RMB=blanks 
    ,ST_ASSET_LIQ_RATIO_NORMB char(4000) nullif ST_ASSET_LIQ_RATIO_NORMB=blanks 
    ,LOAN_FROM_BANKS_RATIO char(4000) nullif LOAN_FROM_BANKS_RATIO=blanks 
    ,LEND_TO_BANKS_RATIO char(4000) nullif LEND_TO_BANKS_RATIO=blanks 
    ,LARGEST_CUSTOMER_LOAN char(4000) nullif LARGEST_CUSTOMER_LOAN=blanks 
    ,TOP_TEN_CUSTOMER_LOAN char(4000) nullif TOP_TEN_CUSTOMER_LOAN=blanks 
    ,TOTAL_LOAN char(4000) nullif TOTAL_LOAN=blanks 
    ,TOTAL_DEPOSIT char(4000) nullif TOTAL_DEPOSIT=blanks 
    ,LOAN_LOSS_PROVISION char(4000) nullif LOAN_LOSS_PROVISION=blanks 
    ,BAD_LOAD_FIVE_CLASS char(4000) nullif BAD_LOAD_FIVE_CLASS=blanks 
    ,NPL_PROVISION_COVERAGE char(4000) nullif NPL_PROVISION_COVERAGE=blanks 
    ,COST_INCOME_RATIO char(4000) nullif COST_INCOME_RATIO=blanks 
    ,NON_INTEREST_MARGIN char(4000) nullif NON_INTEREST_MARGIN=blanks 
    ,NET_CAPITAL char(4000) nullif NET_CAPITAL=blanks 
    ,CORE_CAPI_NET_AMOUNT char(4000) nullif CORE_CAPI_NET_AMOUNT=blanks 
    ,RISK_WEIGHT_ASSET char(4000) nullif RISK_WEIGHT_ASSET=blanks 
    ,INTEREST_BEARING_ASSET char(4000) nullif INTEREST_BEARING_ASSET=blanks 
    ,INTEREST_BEARING_ASSET_COMP char(4000) nullif INTEREST_BEARING_ASSET_COMP=blanks 
    ,INTEREST_BEARING_LIA char(4000) nullif INTEREST_BEARING_LIA=blanks 
    ,INTEREST_BEARING_LIA_COMP char(4000) nullif INTEREST_BEARING_LIA_COMP=blanks 
    ,NON_INTEREST_INCOME char(4000) nullif NON_INTEREST_INCOME=blanks 
    ,NONEANING_ASSET char(4000) nullif NONEANING_ASSET=blanks 
    ,NONEANING_LIA char(4000) nullif NONEANING_LIA=blanks 
    ,NET_INTEREST_MARGIN char(4000) nullif NET_INTEREST_MARGIN=blanks 
    ,NET_INTEREST_MARGIN_IS_ANN char(4000) nullif NET_INTEREST_MARGIN_IS_ANN=blanks 
    ,NET_INTEREST_SPREAD char(4000) nullif NET_INTEREST_SPREAD=blanks 
    ,NET_INTEREST_SPREAD_IS_ANN char(4000) nullif NET_INTEREST_SPREAD_IS_ANN=blanks 
    ,OVERDUE_LOAN char(4000) nullif OVERDUE_LOAN=blanks 
    ,TOTAL_INTEREST_INCOME char(4000) nullif TOTAL_INTEREST_INCOME=blanks 
    ,TOTAL_INTEREST_EXP char(4000) nullif TOTAL_INTEREST_EXP=blanks 
    ,CASH_ON_HAND char(4000) nullif CASH_ON_HAND=blanks 
    ,LONGTERM_LOANS_RATIO_CNY char(4000) nullif LONGTERM_LOANS_RATIO_CNY=blanks 
    ,LONGTERM_LOANS_RATIO_FC char(4000) nullif LONGTERM_LOANS_RATIO_FC=blanks 
    ,IBUSINESS_LOAN_RATIO char(4000) nullif IBUSINESS_LOAN_RATIO=blanks 
    ,INTERECT_COLLECTION_RATIO char(4000) nullif INTERECT_COLLECTION_RATIO=blanks 
    ,CASH_RESERVE_RATIO_CNY char(4000) nullif CASH_RESERVE_RATIO_CNY=blanks 
    ,CASH_RESERVE_RATIO_FC char(4000) nullif CASH_RESERVE_RATIO_FC=blanks 
    ,OVERSEAS_FUNDS_APP_RATIO char(4000) nullif OVERSEAS_FUNDS_APP_RATIO=blanks 
    ,MARKET_RISK_CAPITAL char(4000) nullif MARKET_RISK_CAPITAL=blanks 
    ,INTEREST_BEARING_ASSET_IFPUB char(4000) nullif INTEREST_BEARING_ASSET_IFPUB=blanks 
    ,INTEREST_BEARING_LIA_IFPUB char(4000) nullif INTEREST_BEARING_LIA_IFPUB=blanks 
    ,NET_INTEREST_MARGIN_IFPUB char(4000) nullif NET_INTEREST_MARGIN_IFPUB=blanks 
    ,LOANRESERVESRATIO char(4000) nullif LOANRESERVESRATIO=blanks 
    ,SUBORDINATED_NET_CAPI char(4000) nullif SUBORDINATED_NET_CAPI=blanks 
    ,INT_BEAR_ASSET_AVG_BALANCE char(4000) nullif INT_BEAR_ASSET_AVG_BALANCE=blanks 
    ,INT_BEAR_ASSET_AVG_RETURN char(4000) nullif INT_BEAR_ASSET_AVG_RETURN=blanks 
    ,INT_CCRUED_LIAB_AVG_BALANCE char(4000) nullif INT_CCRUED_LIAB_AVG_BALANCE=blanks 
    ,INT_CCRUED_LIAB_AVG_COSTRATIO char(4000) nullif INT_CCRUED_LIAB_AVG_COSTRATIO=blanks 
    ,RESCHEDULEDLOANS char(4000) nullif RESCHEDULEDLOANS=blanks 
    ,CORETIER1_NET_CAPI char(4000) nullif CORETIER1_NET_CAPI=blanks 
    ,TIER1_NET_CAPI char(4000) nullif TIER1_NET_CAPI=blanks 
    ,NET_CAPITAL_2013 char(4000) nullif NET_CAPITAL_2013=blanks 
    ,CORETIER1CAPI_ADE_RATIO char(4000) nullif CORETIER1CAPI_ADE_RATIO=blanks 
    ,TIER1CAPI_ADE_RATIO char(4000) nullif TIER1CAPI_ADE_RATIO=blanks 
    ,CAPI_ADE_RATIO_2013 char(4000) nullif CAPI_ADE_RATIO_2013=blanks 
    ,RISK_WEIGHT_NET_ASSET_2013 char(4000) nullif RISK_WEIGHT_NET_ASSET_2013=blanks 
)