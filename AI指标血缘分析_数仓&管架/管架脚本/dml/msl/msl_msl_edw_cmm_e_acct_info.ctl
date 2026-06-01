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
infile '${data_path}/cmm_e_acct_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_cmm_e_acct_info
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,LP_ID char(4000) nullif LP_ID=blanks 
    ,ACCT_ID char(4000) nullif ACCT_ID=blanks 
    ,ACCT_NAME char(4000) nullif ACCT_NAME=blanks 
    ,CUST_ACCT_ID char(4000) nullif CUST_ACCT_ID=blanks 
    ,CUST_SUB_ACCT_NUM char(4000) nullif CUST_SUB_ACCT_NUM=blanks 
    ,CUST_ID char(4000) nullif CUST_ID=blanks 
    ,SUBJ_ID char(4000) nullif SUBJ_ID=blanks 
    ,PROD_ID char(4000) nullif PROD_ID=blanks 
    ,STD_PROD_ID char(4000) nullif STD_PROD_ID=blanks 
    ,DEP_TERM char(4000) nullif DEP_TERM=blanks 
    ,DEP_KIND_CD char(4000) nullif DEP_KIND_CD=blanks 
    ,ACCT_CLS_CD char(4000) nullif ACCT_CLS_CD=blanks 
    ,ACCT_TYPE_CD char(4000) nullif ACCT_TYPE_CD=blanks 
    ,E_ACCT_TYPE_CD char(4000) nullif E_ACCT_TYPE_CD=blanks 
    ,DEP_ACCT_STATUS_CD char(4000) nullif DEP_ACCT_STATUS_CD=blanks 
    ,CORP_ACCT_FLG char(4000) nullif CORP_ACCT_FLG=blanks 
    ,RC_FLG char(4000) nullif RC_FLG=blanks 
    ,WEB_DEP_FLG char(4000) nullif WEB_DEP_FLG=blanks 
    ,GENERAL_EXCH_FLG char(4000) nullif GENERAL_EXCH_FLG=blanks 
    ,MARGIN_FLG char(4000) nullif MARGIN_FLG=blanks 
    ,ADVISE_DEP_FLG char(4000) nullif ADVISE_DEP_FLG=blanks 
    ,EC_FLG char(4000) nullif EC_FLG=blanks 
    ,PRIVAVY_ACCT_FLG char(4000) nullif PRIVAVY_ACCT_FLG=blanks 
    ,LEGAL_ACCT_FLG char(4000) nullif LEGAL_ACCT_FLG=blanks 
    ,SLEEP_ACCT_FLG char(4000) nullif SLEEP_ACCT_FLG=blanks 
    ,FROZ_FLG char(4000) nullif FROZ_FLG=blanks 
    ,BIND_ACCT_FLG char(4000) nullif BIND_ACCT_FLG=blanks 
    ,INT_ACCR_FLG char(4000) nullif INT_ACCR_FLG=blanks 
    ,AUTO_REDT_FLG char(4000) nullif AUTO_REDT_FLG=blanks 
    ,REDT_WAY_CD char(4000) nullif REDT_WAY_CD=blanks 
    ,INT_ACCR_BASE_CD char(4000) nullif INT_ACCR_BASE_CD=blanks 
    ,INT_SET_WAY_CD char(4000) nullif INT_SET_WAY_CD=blanks 
    ,INT_ACCR_WAY_CD char(4000) nullif INT_ACCR_WAY_CD=blanks 
    ,CURR_CD char(4000) nullif CURR_CD=blanks 
    ,OPEN_ACCT_CHN_TYPE_CD char(4000) nullif OPEN_ACCT_CHN_TYPE_CD=blanks 
    ,TRAN_CHN_STATUS_CD char(4000) nullif TRAN_CHN_STATUS_CD=blanks 
    ,OPEN_ACCT_DT date "yyyy-mm-dd hh24:mi:ss" nullif OPEN_ACCT_DT=blanks 
    ,OPEN_ACCT_TM timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif OPEN_ACCT_TM=blanks 
    ,CLOS_ACCT_DT date "yyyy-mm-dd hh24:mi:ss" nullif CLOS_ACCT_DT=blanks 
    ,CLOS_ACCT_TM timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif CLOS_ACCT_TM=blanks 
    ,ACTV_DT date "yyyy-mm-dd hh24:mi:ss" nullif ACTV_DT=blanks 
    ,VALUE_DT date "yyyy-mm-dd hh24:mi:ss" nullif VALUE_DT=blanks 
    ,EXP_DT date "yyyy-mm-dd hh24:mi:ss" nullif EXP_DT=blanks 
    ,FINAL_ACTIV_ACCT_DT date "yyyy-mm-dd hh24:mi:ss" nullif FINAL_ACTIV_ACCT_DT=blanks 
    ,FROZ_DT date "yyyy-mm-dd hh24:mi:ss" nullif FROZ_DT=blanks 
    ,UNFRZ_DT date "yyyy-mm-dd hh24:mi:ss" nullif UNFRZ_DT=blanks 
    ,LAST_INT_SET_DT date "yyyy-mm-dd hh24:mi:ss" nullif LAST_INT_SET_DT=blanks 
    ,NEXT_INT_SET_DT date "yyyy-mm-dd hh24:mi:ss" nullif NEXT_INT_SET_DT=blanks 
    ,FIR_VALUE_DT date "yyyy-mm-dd hh24:mi:ss" nullif FIR_VALUE_DT=blanks 
    ,BASE_RAT_TYPE_CD char(4000) nullif BASE_RAT_TYPE_CD=blanks 
    ,BASE_RAT char(4000) nullif BASE_RAT=blanks 
    ,EXEC_INT_RAT char(4000) nullif EXEC_INT_RAT=blanks 
    ,TD_ACRU_INT char(4000) nullif TD_ACRU_INT=blanks 
    ,CURRT_ACRU_INT char(4000) nullif CURRT_ACRU_INT=blanks 
    ,OPEN_ACCT_TELLER_ID char(4000) nullif OPEN_ACCT_TELLER_ID=blanks 
    ,CLOS_ACCT_TELLER_ID char(4000) nullif CLOS_ACCT_TELLER_ID=blanks 
    ,OPEN_ACCT_ORG_ID char(4000) nullif OPEN_ACCT_ORG_ID=blanks 
    ,CLOSE_ACCT_ORG_ID char(4000) nullif CLOSE_ACCT_ORG_ID=blanks 
    ,BELONG_ORG_ID char(4000) nullif BELONG_ORG_ID=blanks 
    ,CAMP_ACTIV_ID char(4000) nullif CAMP_ACTIV_ID=blanks 
    ,REFERRER_TYPE_CD char(4000) nullif REFERRER_TYPE_CD=blanks 
    ,REFERRER_NUM char(4000) nullif REFERRER_NUM=blanks 
    ,VTUAL_ACCT_FLG char(4000) nullif VTUAL_ACCT_FLG=blanks 
    ,MERCHT_ID char(4000) nullif MERCHT_ID=blanks 
    ,CURRT_BAL char(4000) nullif CURRT_BAL=blanks 
    ,AVAL_BAL char(4000) nullif AVAL_BAL=blanks 
    ,FROZ_AMT char(4000) nullif FROZ_AMT=blanks 
    ,CL_CURR_CURRT_BAL char(4000) nullif CL_CURR_CURRT_BAL=blanks 
    ,EAR_D_BAL char(4000) nullif EAR_D_BAL=blanks 
    ,EAR_M_BAL char(4000) nullif EAR_M_BAL=blanks 
    ,EAR_S_BAL char(4000) nullif EAR_S_BAL=blanks 
    ,EAR_Y_BAL char(4000) nullif EAR_Y_BAL=blanks 
    ,Y_ACM_BAL char(4000) nullif Y_ACM_BAL=blanks 
    ,S_ACM_BAL char(4000) nullif S_ACM_BAL=blanks 
    ,M_ACM_BAL char(4000) nullif M_ACM_BAL=blanks 
    ,CL_CURR_EAR_D_BAL char(4000) nullif CL_CURR_EAR_D_BAL=blanks 
    ,CL_CURR_EAR_M_BAL char(4000) nullif CL_CURR_EAR_M_BAL=blanks 
    ,CL_CURR_EAR_S_BAL char(4000) nullif CL_CURR_EAR_S_BAL=blanks 
    ,CL_CURR_EAR_Y_BAL char(4000) nullif CL_CURR_EAR_Y_BAL=blanks 
    ,CL_CURR_Y_ACM_BAL char(4000) nullif CL_CURR_Y_ACM_BAL=blanks 
    ,CL_CURR_EAR_D_Y_ACM_BAL char(4000) nullif CL_CURR_EAR_D_Y_ACM_BAL=blanks 
    ,CL_CURR_EAR_M_Y_ACM_BAL char(4000) nullif CL_CURR_EAR_M_Y_ACM_BAL=blanks 
    ,CL_CURR_EAR_S_Y_ACM_BAL char(4000) nullif CL_CURR_EAR_S_Y_ACM_BAL=blanks 
    ,CL_CURR_EAR_Y_Y_ACM_BAL char(4000) nullif CL_CURR_EAR_Y_Y_ACM_BAL=blanks 
    ,CL_CURR_S_ACM_BAL char(4000) nullif CL_CURR_S_ACM_BAL=blanks 
    ,CL_CURR_EAR_D_S_ACM_BAL char(4000) nullif CL_CURR_EAR_D_S_ACM_BAL=blanks 
    ,CL_CURR_EAR_S_S_ACM_BAL char(4000) nullif CL_CURR_EAR_S_S_ACM_BAL=blanks 
    ,CL_CURR_EAR_Y_S_ACM_BAL char(4000) nullif CL_CURR_EAR_Y_S_ACM_BAL=blanks 
    ,CL_CURR_M_ACM_BAL char(4000) nullif CL_CURR_M_ACM_BAL=blanks 
    ,CL_CURR_EAR_D_M_ACM_BAL char(4000) nullif CL_CURR_EAR_D_M_ACM_BAL=blanks 
    ,CL_CURR_EAR_M_M_ACM_BAL char(4000) nullif CL_CURR_EAR_M_M_ACM_BAL=blanks 
    ,CL_CURR_EAR_Y_M_ACM_BAL char(4000) nullif CL_CURR_EAR_Y_M_ACM_BAL=blanks 
    ,ENTRY_FLG char(4000) nullif ENTRY_FLG=blanks 
    ,Y_AVG_BAL char(4000) nullif Y_AVG_BAL=blanks 
    ,Q_AVG_BAL char(4000) nullif Q_AVG_BAL=blanks 
    ,M_AVG_BAL char(4000) nullif M_AVG_BAL=blanks 
    ,CL_CURR_Y_AVG_BAL char(4000) nullif CL_CURR_Y_AVG_BAL=blanks 
    ,CL_CURR_Q_AVG_BAL char(4000) nullif CL_CURR_Q_AVG_BAL=blanks 
    ,CL_CURR_M_AVG_BAL char(4000) nullif CL_CURR_M_AVG_BAL=blanks 
    ,LIAB_ACCT_ID char(4000) nullif LIAB_ACCT_ID=blanks 
    ,OPEN_AMT char(4000) nullif OPEN_AMT=blanks 
    ,OLD_ACCT_ID char(4000) nullif OLD_ACCT_ID=blanks 
    ,INT_PAYBL_SUBJ_ID char(4000) nullif INT_PAYBL_SUBJ_ID=blanks 
    ,INT_PAYBL_ADJ_SUBJ_ID char(4000) nullif INT_PAYBL_ADJ_SUBJ_ID=blanks 
    ,INT_EXPNS_SUBJ_ID char(4000) nullif INT_EXPNS_SUBJ_ID=blanks 
    ,INT_EXPNS_ADJ_SUBJ_ID char(4000) nullif INT_EXPNS_ADJ_SUBJ_ID=blanks 
    ,CURRT_INT_PAYBL_ADJ char(4000) nullif CURRT_INT_PAYBL_ADJ=blanks 
    ,TD_INT_EXPNS char(4000) nullif TD_INT_EXPNS=blanks 
    ,TD_INT_EXPNS_ADJ char(4000) nullif TD_INT_EXPNS_ADJ=blanks 
)