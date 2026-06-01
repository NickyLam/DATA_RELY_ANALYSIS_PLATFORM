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
infile '${data_path}/wind_unlistedbankincome.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_wind_unlistedbankincome
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
    ,EBIT char(4000) nullif EBIT=blanks 
    ,EBITDA char(4000) nullif EBITDA=blanks 
    ,NET_PROFIT_AFTER_DED_NR_LP char(4000) nullif NET_PROFIT_AFTER_DED_NR_LP=blanks 
    ,NET_PROFIT_UNDER_INTL_ACC_STA char(4000) nullif NET_PROFIT_UNDER_INTL_ACC_STA=blanks 
    ,S_FA_EPS_BASIC char(4000) nullif S_FA_EPS_BASIC=blanks 
    ,S_FA_EPS_DILUTED char(4000) nullif S_FA_EPS_DILUTED=blanks 
    ,ACTUAL_ANN_DT char(4000) nullif ACTUAL_ANN_DT=blanks 
    ,OPER_REV char(4000) nullif OPER_REV=blanks 
    ,NET_INT_INC char(4000) nullif NET_INT_INC=blanks 
    ,INT_INC char(4000) nullif INT_INC=blanks 
    ,LESS_INT_EXP char(4000) nullif LESS_INT_EXP=blanks 
    ,NET_HANDLING_CHRG_COMM_INC char(4000) nullif NET_HANDLING_CHRG_COMM_INC=blanks 
    ,HANDLING_CHRG_COMM_INC char(4000) nullif HANDLING_CHRG_COMM_INC=blanks 
    ,LESS_HANDLING_CHRG_COMM_EXP char(4000) nullif LESS_HANDLING_CHRG_COMM_EXP=blanks 
    ,PLUS_NET_INVEST_INC char(4000) nullif PLUS_NET_INVEST_INC=blanks 
    ,INCL_INC_INVEST_ASSOC_JV_ENTP char(4000) nullif INCL_INC_INVEST_ASSOC_JV_ENTP=blanks 
    ,PLUS_NET_GAIN_CHG_FV char(4000) nullif PLUS_NET_GAIN_CHG_FV=blanks 
    ,NET_INC_OTHER_OPS char(4000) nullif NET_INC_OTHER_OPS=blanks 
    ,PLUS_NET_GAIN_FX_TRANS char(4000) nullif PLUS_NET_GAIN_FX_TRANS=blanks 
    ,PLUS_NET_INC_OTHER_BUS char(4000) nullif PLUS_NET_INC_OTHER_BUS=blanks 
    ,OTHER_BUS_INC char(4000) nullif OTHER_BUS_INC=blanks 
    ,OTHER_BUS_COST char(4000) nullif OTHER_BUS_COST=blanks 
    ,OPER_EXP char(4000) nullif OPER_EXP=blanks 
    ,LESS_TAXES_SURCHARGES_OPS char(4000) nullif LESS_TAXES_SURCHARGES_OPS=blanks 
    ,LESS_GERL_ADMIN_EXP char(4000) nullif LESS_GERL_ADMIN_EXP=blanks 
    ,LESS_IMPAIR_LOSS_ASSETS char(4000) nullif LESS_IMPAIR_LOSS_ASSETS=blanks 
    ,SPE_BAL_OPER_PROFIT char(4000) nullif SPE_BAL_OPER_PROFIT=blanks 
    ,TOT_BAL_OPER_PROFIT char(4000) nullif TOT_BAL_OPER_PROFIT=blanks 
    ,OPER_PROFIT char(4000) nullif OPER_PROFIT=blanks 
    ,PLUS_NON_OPER_REV char(4000) nullif PLUS_NON_OPER_REV=blanks 
    ,LESS_NON_OPER_EXP char(4000) nullif LESS_NON_OPER_EXP=blanks 
    ,IL_NET_LOSS_DISP_NONCUR_ASSET char(4000) nullif IL_NET_LOSS_DISP_NONCUR_ASSET=blanks 
    ,SPE_BAL_TOT_PROFIT char(4000) nullif SPE_BAL_TOT_PROFIT=blanks 
    ,TOT_BAL_TOT_PROFIT char(4000) nullif TOT_BAL_TOT_PROFIT=blanks 
    ,TOT_PROFIT char(4000) nullif TOT_PROFIT=blanks 
    ,INC_TAX char(4000) nullif INC_TAX=blanks 
    ,UNCONFIRMED_INVEST_LOSS char(4000) nullif UNCONFIRMED_INVEST_LOSS=blanks 
    ,SPE_BAL_NET_PROFIT char(4000) nullif SPE_BAL_NET_PROFIT=blanks 
    ,TOT_BAL_NET_PROFIT char(4000) nullif TOT_BAL_NET_PROFIT=blanks 
    ,NET_PROFIT_INCL_MIN_INT_INC char(4000) nullif NET_PROFIT_INCL_MIN_INT_INC=blanks 
    ,NET_PROFIT_EXCL_MIN_INT_INC char(4000) nullif NET_PROFIT_EXCL_MIN_INT_INC=blanks 
    ,OTHER_COMPREH_INC char(4000) nullif OTHER_COMPREH_INC=blanks 
    ,TOT_COMPREH_INC char(4000) nullif TOT_COMPREH_INC=blanks 
    ,TOT_COMPREH_INC_MIN_SHRHLDR char(4000) nullif TOT_COMPREH_INC_MIN_SHRHLDR=blanks 
    ,TOT_COMPREH_INC_PARENT_COMP char(4000) nullif TOT_COMPREH_INC_PARENT_COMP=blanks 
)