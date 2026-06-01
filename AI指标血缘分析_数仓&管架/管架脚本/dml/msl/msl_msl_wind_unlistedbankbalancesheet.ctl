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
infile '${data_path}/wind_unlistedbankbalancesheet.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_wind_unlistedbankbalancesheet
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,OBJECT_ID char(4000) nullif OBJECT_ID=blanks 
    ,S_INFO_COMPCODE char(4000) nullif S_INFO_COMPCODE=blanks 
    ,ANN_DT char(4000) nullif ANN_DT=blanks 
    ,REPORT_PERIOD char(4000) nullif REPORT_PERIOD=blanks 
    ,STATEMENT_TYPE char(4000) nullif STATEMENT_TYPE=blanks 
    ,CRNCY_CODE char(4000) nullif CRNCY_CODE=blanks 
    ,ACTUAL_ANN_DT char(4000) nullif ACTUAL_ANN_DT=blanks 
    ,CASH_DEPOSITS_CENTRAL_BANK char(4000) nullif CASH_DEPOSITS_CENTRAL_BANK=blanks 
    ,ASSET_DEP_OTH_BANKS_FIN_INST char(4000) nullif ASSET_DEP_OTH_BANKS_FIN_INST=blanks 
    ,PRECIOUS_METALS char(4000) nullif PRECIOUS_METALS=blanks 
    ,LOANS_TO_OTH_BANKS char(4000) nullif LOANS_TO_OTH_BANKS=blanks 
    ,TRADABLE_FIN_ASSETS char(4000) nullif TRADABLE_FIN_ASSETS=blanks 
    ,DERIVATIVE_FIN_ASSETS char(4000) nullif DERIVATIVE_FIN_ASSETS=blanks 
    ,RED_MONETARY_CAP_FOR_SALE char(4000) nullif RED_MONETARY_CAP_FOR_SALE=blanks 
    ,INT_RCV char(4000) nullif INT_RCV=blanks 
    ,LOANS_AND_ADV_GRANTED char(4000) nullif LOANS_AND_ADV_GRANTED=blanks 
    ,AGENCY_BUS_ASSETS char(4000) nullif AGENCY_BUS_ASSETS=blanks 
    ,FIN_ASSETS_AVAIL_FOR_SALE char(4000) nullif FIN_ASSETS_AVAIL_FOR_SALE=blanks 
    ,HELD_TO_MTY_INVEST char(4000) nullif HELD_TO_MTY_INVEST=blanks 
    ,LONG_TERM_EQY_INVEST char(4000) nullif LONG_TERM_EQY_INVEST=blanks 
    ,RCV_INVEST char(4000) nullif RCV_INVEST=blanks 
    ,FIX_ASSETS char(4000) nullif FIX_ASSETS=blanks 
    ,INTANG_ASSETS char(4000) nullif INTANG_ASSETS=blanks 
    ,GOODWILL char(4000) nullif GOODWILL=blanks 
    ,DEFERRED_TAX_ASSETS char(4000) nullif DEFERRED_TAX_ASSETS=blanks 
    ,INVEST_REAL_ESTATE char(4000) nullif INVEST_REAL_ESTATE=blanks 
    ,OTH_ASSETS char(4000) nullif OTH_ASSETS=blanks 
    ,SPE_BAL_ASSETS char(4000) nullif SPE_BAL_ASSETS=blanks 
    ,TOT_BAL_ASSETS char(4000) nullif TOT_BAL_ASSETS=blanks 
    ,TOT_ASSETS char(4000) nullif TOT_ASSETS=blanks 
    ,LIAB_DEP_OTH_BANKS_FIN_INST char(4000) nullif LIAB_DEP_OTH_BANKS_FIN_INST=blanks 
    ,BORROW_CENTRAL_BANK char(4000) nullif BORROW_CENTRAL_BANK=blanks 
    ,LOANS_OTH_BANKS char(4000) nullif LOANS_OTH_BANKS=blanks 
    ,TRADABLE_FIN_LIAB char(4000) nullif TRADABLE_FIN_LIAB=blanks 
    ,DERIVATIVE_FIN_LIAB char(4000) nullif DERIVATIVE_FIN_LIAB=blanks 
    ,FUND_SALES_FIN_ASSETS_RP char(4000) nullif FUND_SALES_FIN_ASSETS_RP=blanks 
    ,CUST_BANK_DEP char(4000) nullif CUST_BANK_DEP=blanks 
    ,EMPL_BEN_PAYABLE char(4000) nullif EMPL_BEN_PAYABLE=blanks 
    ,TAXES_SURCHARGES_PAYABLE char(4000) nullif TAXES_SURCHARGES_PAYABLE=blanks 
    ,INT_PAYABLE char(4000) nullif INT_PAYABLE=blanks 
    ,AGENCY_BUS_LIAB char(4000) nullif AGENCY_BUS_LIAB=blanks 
    ,BONDS_PAYABLE char(4000) nullif BONDS_PAYABLE=blanks 
    ,DEFERRED_TAX_LIAB char(4000) nullif DEFERRED_TAX_LIAB=blanks 
    ,PROVISIONS char(4000) nullif PROVISIONS=blanks 
    ,OTH_LIAB char(4000) nullif OTH_LIAB=blanks 
    ,SPE_BAL_LIAB char(4000) nullif SPE_BAL_LIAB=blanks 
    ,TOT_BAL_LIAB char(4000) nullif TOT_BAL_LIAB=blanks 
    ,TOT_LIAB char(4000) nullif TOT_LIAB=blanks 
    ,CAP_STK char(4000) nullif CAP_STK=blanks 
    ,CAP_RSRV char(4000) nullif CAP_RSRV=blanks 
    ,LESS_TSY_STK char(4000) nullif LESS_TSY_STK=blanks 
    ,SURPLUS_RSRV char(4000) nullif SURPLUS_RSRV=blanks 
    ,UNDISTRIBUTED_PROFIT char(4000) nullif UNDISTRIBUTED_PROFIT=blanks 
    ,PROV_NOM_RISKS char(4000) nullif PROV_NOM_RISKS=blanks 
    ,CNVD_DIFF_FOREIGN_CURR_STAT char(4000) nullif CNVD_DIFF_FOREIGN_CURR_STAT=blanks 
    ,UNCONFIRMED_INVEST_LOSS char(4000) nullif UNCONFIRMED_INVEST_LOSS=blanks 
    ,SPE_BAL_SHRHLDR_EQY char(4000) nullif SPE_BAL_SHRHLDR_EQY=blanks 
    ,TOT_BAL_SHRHLDR_EQY char(4000) nullif TOT_BAL_SHRHLDR_EQY=blanks 
    ,MINORITY_INT char(4000) nullif MINORITY_INT=blanks 
    ,TOT_SHRHLDR_EQY_EXCL_MIN_INT char(4000) nullif TOT_SHRHLDR_EQY_EXCL_MIN_INT=blanks 
    ,TOT_SHRHLDR_EQY_INCL_MIN_INT char(4000) nullif TOT_SHRHLDR_EQY_INCL_MIN_INT=blanks 
    ,SPE_BAL_LIAB_EQY char(4000) nullif SPE_BAL_LIAB_EQY=blanks 
    ,TOT_BAL_LIAB_EQY char(4000) nullif TOT_BAL_LIAB_EQY=blanks 
    ,TOT_LIAB_SHRHLDR_EQY char(4000) nullif TOT_LIAB_SHRHLDR_EQY=blanks 
)