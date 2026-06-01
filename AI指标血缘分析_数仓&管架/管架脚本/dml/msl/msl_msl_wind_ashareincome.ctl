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
infile '${data_path}/wind_ashareincome.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_wind_ashareincome
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,OBJECT_ID char(4000) nullif OBJECT_ID=blanks 
    ,S_INFO_WINDCODE char(4000) nullif S_INFO_WINDCODE=blanks 
    ,WIND_CODE char(4000) nullif WIND_CODE=blanks 
    ,ANN_DT char(4000) nullif ANN_DT=blanks 
    ,REPORT_PERIOD char(4000) nullif REPORT_PERIOD=blanks 
    ,STATEMENT_TYPE char(4000) nullif STATEMENT_TYPE=blanks 
    ,CRNCY_CODE char(4000) nullif CRNCY_CODE=blanks 
    ,TOT_OPER_REV char(4000) nullif TOT_OPER_REV=blanks 
    ,OPER_REV char(4000) nullif OPER_REV=blanks 
    ,INT_INC char(4000) nullif INT_INC=blanks 
    ,NET_INT_INC char(4000) nullif NET_INT_INC=blanks 
    ,INSUR_PREM_UNEARNED char(4000) nullif INSUR_PREM_UNEARNED=blanks 
    ,HANDLING_CHRG_COMM_INC char(4000) nullif HANDLING_CHRG_COMM_INC=blanks 
    ,NET_HANDLING_CHRG_COMM_INC char(4000) nullif NET_HANDLING_CHRG_COMM_INC=blanks 
    ,NET_INC_OTHER_OPS char(4000) nullif NET_INC_OTHER_OPS=blanks 
    ,PLUS_NET_INC_OTHER_BUS char(4000) nullif PLUS_NET_INC_OTHER_BUS=blanks 
    ,PREM_INC char(4000) nullif PREM_INC=blanks 
    ,LESS_CEDED_OUT_PREM char(4000) nullif LESS_CEDED_OUT_PREM=blanks 
    ,CHG_UNEARNED_PREM_RES char(4000) nullif CHG_UNEARNED_PREM_RES=blanks 
    ,INCL_REINSURANCE_PREM_INC char(4000) nullif INCL_REINSURANCE_PREM_INC=blanks 
    ,NET_INC_SEC_TRADING_BROK_BUS char(4000) nullif NET_INC_SEC_TRADING_BROK_BUS=blanks 
    ,NET_INC_SEC_UW_BUS char(4000) nullif NET_INC_SEC_UW_BUS=blanks 
    ,NET_INC_EC_ASSET_MGMT_BUS char(4000) nullif NET_INC_EC_ASSET_MGMT_BUS=blanks 
    ,OTHER_BUS_INC char(4000) nullif OTHER_BUS_INC=blanks 
    ,PLUS_NET_GAIN_CHG_FV char(4000) nullif PLUS_NET_GAIN_CHG_FV=blanks 
    ,PLUS_NET_INVEST_INC char(4000) nullif PLUS_NET_INVEST_INC=blanks 
    ,INCL_INC_INVEST_ASSOC_JV_ENTP char(4000) nullif INCL_INC_INVEST_ASSOC_JV_ENTP=blanks 
    ,PLUS_NET_GAIN_FX_TRANS char(4000) nullif PLUS_NET_GAIN_FX_TRANS=blanks 
    ,TOT_OPER_COST char(4000) nullif TOT_OPER_COST=blanks 
    ,LESS_OPER_COST char(4000) nullif LESS_OPER_COST=blanks 
    ,LESS_INT_EXP char(4000) nullif LESS_INT_EXP=blanks 
    ,LESS_HANDLING_CHRG_COMM_EXP char(4000) nullif LESS_HANDLING_CHRG_COMM_EXP=blanks 
    ,LESS_TAXES_SURCHARGES_OPS char(4000) nullif LESS_TAXES_SURCHARGES_OPS=blanks 
    ,LESS_SELLING_DIST_EXP char(4000) nullif LESS_SELLING_DIST_EXP=blanks 
    ,LESS_GERL_ADMIN_EXP char(4000) nullif LESS_GERL_ADMIN_EXP=blanks 
    ,LESS_FIN_EXP char(4000) nullif LESS_FIN_EXP=blanks 
    ,LESS_IMPAIR_LOSS_ASSETS char(4000) nullif LESS_IMPAIR_LOSS_ASSETS=blanks 
    ,PREPAY_SURR char(4000) nullif PREPAY_SURR=blanks 
    ,TOT_CLAIM_EXP char(4000) nullif TOT_CLAIM_EXP=blanks 
    ,CHG_INSUR_CONT_RSRV char(4000) nullif CHG_INSUR_CONT_RSRV=blanks 
    ,DVD_EXP_INSURED char(4000) nullif DVD_EXP_INSURED=blanks 
    ,REINSURANCE_EXP char(4000) nullif REINSURANCE_EXP=blanks 
    ,OPER_EXP char(4000) nullif OPER_EXP=blanks 
    ,LESS_CLAIM_RECB_REINSURER char(4000) nullif LESS_CLAIM_RECB_REINSURER=blanks 
    ,LESS_INS_RSRV_RECB_REINSURER char(4000) nullif LESS_INS_RSRV_RECB_REINSURER=blanks 
    ,LESS_EXP_RECB_REINSURER char(4000) nullif LESS_EXP_RECB_REINSURER=blanks 
    ,OTHER_BUS_COST char(4000) nullif OTHER_BUS_COST=blanks 
    ,OPER_PROFIT char(4000) nullif OPER_PROFIT=blanks 
    ,PLUS_NON_OPER_REV char(4000) nullif PLUS_NON_OPER_REV=blanks 
    ,LESS_NON_OPER_EXP char(4000) nullif LESS_NON_OPER_EXP=blanks 
    ,IL_NET_LOSS_DISP_NONCUR_ASSET char(4000) nullif IL_NET_LOSS_DISP_NONCUR_ASSET=blanks 
    ,TOT_PROFIT char(4000) nullif TOT_PROFIT=blanks 
    ,INC_TAX char(4000) nullif INC_TAX=blanks 
    ,UNCONFIRMED_INVEST_LOSS char(4000) nullif UNCONFIRMED_INVEST_LOSS=blanks 
    ,NET_PROFIT_INCL_MIN_INT_INC char(4000) nullif NET_PROFIT_INCL_MIN_INT_INC=blanks 
    ,NET_PROFIT_EXCL_MIN_INT_INC char(4000) nullif NET_PROFIT_EXCL_MIN_INT_INC=blanks 
    ,MINORITY_INT_INC char(4000) nullif MINORITY_INT_INC=blanks 
    ,OTHER_COMPREH_INC char(4000) nullif OTHER_COMPREH_INC=blanks 
    ,TOT_COMPREH_INC char(4000) nullif TOT_COMPREH_INC=blanks 
    ,TOT_COMPREH_INC_PARENT_COMP char(4000) nullif TOT_COMPREH_INC_PARENT_COMP=blanks 
    ,TOT_COMPREH_INC_MIN_SHRHLDR char(4000) nullif TOT_COMPREH_INC_MIN_SHRHLDR=blanks 
    ,EBIT char(4000) nullif EBIT=blanks 
    ,EBITDA char(4000) nullif EBITDA=blanks 
    ,NET_PROFIT_AFTER_DED_NR_LP char(4000) nullif NET_PROFIT_AFTER_DED_NR_LP=blanks 
    ,NET_PROFIT_UNDER_INTL_ACC_STA char(4000) nullif NET_PROFIT_UNDER_INTL_ACC_STA=blanks 
    ,COMP_TYPE_CODE char(4000) nullif COMP_TYPE_CODE=blanks 
    ,S_FA_EPS_BASIC char(4000) nullif S_FA_EPS_BASIC=blanks 
    ,S_FA_EPS_DILUTED char(4000) nullif S_FA_EPS_DILUTED=blanks 
    ,ACTUAL_ANN_DT char(4000) nullif ACTUAL_ANN_DT=blanks 
    ,INSURANCE_EXPENSE char(4000) nullif INSURANCE_EXPENSE=blanks 
    ,SPE_BAL_OPER_PROFIT char(4000) nullif SPE_BAL_OPER_PROFIT=blanks 
    ,TOT_BAL_OPER_PROFIT char(4000) nullif TOT_BAL_OPER_PROFIT=blanks 
    ,SPE_BAL_TOT_PROFIT char(4000) nullif SPE_BAL_TOT_PROFIT=blanks 
    ,TOT_BAL_TOT_PROFIT char(4000) nullif TOT_BAL_TOT_PROFIT=blanks 
    ,SPE_BAL_NET_PROFIT char(4000) nullif SPE_BAL_NET_PROFIT=blanks 
    ,TOT_BAL_NET_PROFIT char(4000) nullif TOT_BAL_NET_PROFIT=blanks 
    ,UNDISTRIBUTED_PROFIT char(4000) nullif UNDISTRIBUTED_PROFIT=blanks 
    ,ADJLOSSGAIN_PREVYEAR char(4000) nullif ADJLOSSGAIN_PREVYEAR=blanks 
    ,TRANSFER_FROM_SURPLUSRESERVE char(4000) nullif TRANSFER_FROM_SURPLUSRESERVE=blanks 
    ,TRANSFER_FROM_HOUSINGIMPREST char(4000) nullif TRANSFER_FROM_HOUSINGIMPREST=blanks 
    ,TRANSFER_FROM_OTHERS char(4000) nullif TRANSFER_FROM_OTHERS=blanks 
    ,DISTRIBUTABLE_PROFIT char(4000) nullif DISTRIBUTABLE_PROFIT=blanks 
    ,WITHDR_LEGALSURPLUS char(4000) nullif WITHDR_LEGALSURPLUS=blanks 
    ,WITHDR_LEGALPUBWELFUNDS char(4000) nullif WITHDR_LEGALPUBWELFUNDS=blanks 
    ,WORKERS_WELFARE char(4000) nullif WORKERS_WELFARE=blanks 
    ,WITHDR_BUZEXPWELFARE char(4000) nullif WITHDR_BUZEXPWELFARE=blanks 
    ,WITHDR_RESERVEFUND char(4000) nullif WITHDR_RESERVEFUND=blanks 
    ,DISTRIBUTABLE_PROFIT_SHRHDER char(4000) nullif DISTRIBUTABLE_PROFIT_SHRHDER=blanks 
    ,PRFSHARE_DVD_PAYABLE char(4000) nullif PRFSHARE_DVD_PAYABLE=blanks 
    ,WITHDR_OTHERSURPRESERVE char(4000) nullif WITHDR_OTHERSURPRESERVE=blanks 
    ,COMSHARE_DVD_PAYABLE char(4000) nullif COMSHARE_DVD_PAYABLE=blanks 
    ,CAPITALIZED_COMSTOCK_DIV char(4000) nullif CAPITALIZED_COMSTOCK_DIV=blanks 
    ,S_INFO_COMPCODE char(4000) nullif S_INFO_COMPCODE=blanks 
)