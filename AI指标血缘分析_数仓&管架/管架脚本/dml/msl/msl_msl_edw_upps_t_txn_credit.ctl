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
infile '${data_path}/upps_t_txn_credit.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_upps_t_txn_credit
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ID char(4000) nullif ID=blanks 
    ,GLOBAL_NO char(4000) nullif GLOBAL_NO=blanks 
    ,TXN_NO char(4000) nullif TXN_NO=blanks 
    ,TXN_DATE char(4000) nullif TXN_DATE=blanks 
    ,TXN_TIME char(4000) nullif TXN_TIME=blanks 
    ,TXN_TYPE char(4000) nullif TXN_TYPE=blanks 
    ,CORPORATE char(4000) nullif CORPORATE=blanks 
    ,MCHT_NO char(4000) nullif MCHT_NO=blanks 
    ,PRODUCT_NO char(4000) nullif PRODUCT_NO=blanks 
    ,TRAN_NO char(4000) nullif TRAN_NO=blanks 
    ,TRAN_DATE char(4000) nullif TRAN_DATE=blanks 
    ,TRAN_TIME char(4000) nullif TRAN_TIME=blanks 
    ,STATUS char(4000) nullif STATUS=blanks 
    ,BIZ_STATUS char(4000) nullif BIZ_STATUS=blanks 
    ,TRADE_TYPE char(4000) nullif TRADE_TYPE=blanks 
    ,ROUTE_TYPE char(4000) nullif ROUTE_TYPE=blanks 
    ,PRIORITY char(4000) nullif PRIORITY=blanks 
    ,WORK_DATE char(4000) nullif WORK_DATE=blanks 
    ,AMOUNT char(4000) nullif AMOUNT=blanks 
    ,CURRENCY char(4000) nullif CURRENCY=blanks 
    ,PAYEE_ACCT_NO char(4000) nullif PAYEE_ACCT_NO=blanks 
    ,PAYEE_ACCT_NAME char(4000) nullif PAYEE_ACCT_NAME=blanks 
    ,PAYEE_ACCT_TYPE char(4000) nullif PAYEE_ACCT_TYPE=blanks 
    ,PAYEE_HOST_TYPE char(4000) nullif PAYEE_HOST_TYPE=blanks 
    ,PAYEE_BANK_CODE char(4000) nullif PAYEE_BANK_CODE=blanks 
    ,PAYER_ACCT_NO char(4000) nullif PAYER_ACCT_NO=blanks 
    ,PAYER_ACCT_NAME char(4000) nullif PAYER_ACCT_NAME=blanks 
    ,PAYER_ACCT_TYPE char(4000) nullif PAYER_ACCT_TYPE=blanks 
    ,PAYER_HOST_TYPE char(4000) nullif PAYER_HOST_TYPE=blanks 
    ,PAYER_PHONE char(4000) nullif PAYER_PHONE=blanks 
    ,PAYER_VALID_DATE char(4000) nullif PAYER_VALID_DATE=blanks 
    ,PAYER_CVN2 char(4000) nullif PAYER_CVN2=blanks 
    ,PAYER_BANK_CODE char(4000) nullif PAYER_BANK_CODE=blanks 
    ,REAL_PAYER_ACCT_NO char(4000) nullif REAL_PAYER_ACCT_NO=blanks 
    ,REAL_PAYER_ACCT_NAME char(4000) nullif REAL_PAYER_ACCT_NAME=blanks 
    ,REAL_PAYER_ACCT_TYPE char(4000) nullif REAL_PAYER_ACCT_TYPE=blanks 
    ,REAL_PAYER_HOST_TYPE char(4000) nullif REAL_PAYER_HOST_TYPE=blanks 
    ,RET_CODE char(4000) nullif RET_CODE=blanks 
    ,RET_MSG char(4000) nullif RET_MSG=blanks 
    ,IS_LIMITED char(4000) nullif IS_LIMITED=blanks 
    ,ACTION_TYPE char(4000) nullif ACTION_TYPE=blanks 
    ,HOST_STATUS char(4000) nullif HOST_STATUS=blanks 
    ,ACCOUNT_CNT char(4000) nullif ACCOUNT_CNT=blanks 
    ,HOST_CODE_LIST char(4000) nullif HOST_CODE_LIST=blanks 
    ,HOST_NO char(4000) nullif HOST_NO=blanks 
    ,REVERSE_NO char(4000) nullif REVERSE_NO=blanks 
    ,REFUNDED char(4000) nullif REFUNDED=blanks 
    ,PMC_CODE char(4000) nullif PMC_CODE=blanks 
    ,PMC_NO char(4000) nullif PMC_NO=blanks 
    ,PMC_STATUS char(4000) nullif PMC_STATUS=blanks 
    ,PMC_RET_CODE char(4000) nullif PMC_RET_CODE=blanks 
    ,PMC_RET_MSG char(4000) nullif PMC_RET_MSG=blanks 
    ,PMC_DATE char(4000) nullif PMC_DATE=blanks 
    ,PMC_TIME char(4000) nullif PMC_TIME=blanks 
    ,PMC_COST char(4000) nullif PMC_COST=blanks 
    ,MCHT_FEE char(4000) nullif MCHT_FEE=blanks 
    ,FEE_NO char(4000) nullif FEE_NO=blanks 
    ,FEE_STATUS char(4000) nullif FEE_STATUS=blanks 
    ,CHARGE_TYPE char(4000) nullif CHARGE_TYPE=blanks 
    ,CHECK_DATE char(4000) nullif CHECK_DATE=blanks 
    ,CHECKED char(4000) nullif CHECKED=blanks 
    ,CHECK_STATE char(4000) nullif CHECK_STATE=blanks 
    ,IS_CHARGE char(4000) nullif IS_CHARGE=blanks 
    ,IS_DELAY char(4000) nullif IS_DELAY=blanks 
    ,DELAY_TIME char(4000) nullif DELAY_TIME=blanks 
    ,FEE_AMOUNT char(4000) nullif FEE_AMOUNT=blanks 
    ,CHL_CHECKING_CODE char(4000) nullif CHL_CHECKING_CODE=blanks 
    ,CHL_CHECK_DATE char(4000) nullif CHL_CHECK_DATE=blanks 
    ,AUTH_TELLER_NO char(4000) nullif AUTH_TELLER_NO=blanks 
    ,CHECK_TELLER_NO char(4000) nullif CHECK_TELLER_NO=blanks 
    ,TRANS_ORG_NO char(4000) nullif TRANS_ORG_NO=blanks 
    ,SUMMERY_CODE char(4000) nullif SUMMERY_CODE=blanks 
    ,CONSUMER_ID char(4000) nullif CONSUMER_ID=blanks 
    ,IS_NOTIFY char(4000) nullif IS_NOTIFY=blanks 
    ,NOTIFY_ADDR char(4000) nullif NOTIFY_ADDR=blanks 
    ,NOTIFY_SERVICE_NAME char(4000) nullif NOTIFY_SERVICE_NAME=blanks 
    ,PAYER_EXT_MAP_ID char(4000) nullif PAYER_EXT_MAP_ID=blanks 
    ,PAYEE_EXT_MAP_ID char(4000) nullif PAYEE_EXT_MAP_ID=blanks 
    ,ROUTE_MAP_ID char(4000) nullif ROUTE_MAP_ID=blanks 
    ,HOST_DESC char(4000) nullif HOST_DESC=blanks 
    ,CHANNEL_DESC char(4000) nullif CHANNEL_DESC=blanks 
    ,BALANCE_DESC char(4000) nullif BALANCE_DESC=blanks 
    ,CHECK_TIME date "yyyy-mm-dd hh24:mi:ss" nullif CHECK_TIME=blanks 
    ,BUINESS_MODULE char(4000) nullif BUINESS_MODULE=blanks 
    ,INIT_MCHT_NO char(4000) nullif INIT_MCHT_NO=blanks 
    ,SYS_COMM_NO char(4000) nullif SYS_COMM_NO=blanks 
    ,PMC_RET_NO char(4000) nullif PMC_RET_NO=blanks 
    ,PMC_RET_DATE char(4000) nullif PMC_RET_DATE=blanks 
    ,PMC_RET_TIME char(4000) nullif PMC_RET_TIME=blanks 
    ,PMC_RET_STATUS char(4000) nullif PMC_RET_STATUS=blanks 
    ,MCHT_CHECK_MODE char(4000) nullif MCHT_CHECK_MODE=blanks 
    ,PAYER_BANK_NAME char(4000) nullif PAYER_BANK_NAME=blanks 
    ,PAYEE_BANK_NAME char(4000) nullif PAYEE_BANK_NAME=blanks 
    ,CHECK_FLAG char(4000) nullif CHECK_FLAG=blanks 
    ,HOST_DATE char(4000) nullif HOST_DATE=blanks 
    ,HOST_TIME char(4000) nullif HOST_TIME=blanks 
    ,ACC_BEAN_JSON char(4000) nullif ACC_BEAN_JSON=blanks 
    ,CLEAR_DATE char(4000) nullif CLEAR_DATE=blanks 
    ,CLEARED char(4000) nullif CLEARED=blanks 
    ,CLEAR_NO char(4000) nullif CLEAR_NO=blanks 
    ,CLEAR_TYPE char(4000) nullif CLEAR_TYPE=blanks 
    ,CLEAR_CYCLE char(4000) nullif CLEAR_CYCLE=blanks 
    ,TELLER_NO char(4000) nullif TELLER_NO=blanks 
    ,PAYEE_PHONE char(4000) nullif PAYEE_PHONE=blanks 
    ,PAYEE_VALID_DATE char(4000) nullif PAYEE_VALID_DATE=blanks 
    ,PAYEE_CVN2 char(4000) nullif PAYEE_CVN2=blanks 
    ,BIZ_TYPE char(4000) nullif BIZ_TYPE=blanks 
    ,SIGN_NO char(4000) nullif SIGN_NO=blanks 
    ,BATCH_NO char(4000) nullif BATCH_NO=blanks 
    ,PURPOSE char(4000) nullif PURPOSE=blanks 
    ,LOG_ID char(4000) nullif LOG_ID=blanks 
    ,SERVER_ID char(4000) nullif SERVER_ID=blanks 
    ,SHARDING char(4000) nullif SHARDING=blanks 
    ,REMARK char(4000) nullif REMARK=blanks 
    ,CREATE_TIME date "yyyy-mm-dd hh24:mi:ss" nullif CREATE_TIME=blanks 
    ,UPDATE_TIME date "yyyy-mm-dd hh24:mi:ss" nullif UPDATE_TIME=blanks 
    ,TRACE_MSG char(4000) nullif TRACE_MSG=blanks 
    ,CHECKING_CODE char(4000) nullif CHECKING_CODE=blanks 
    ,ADVANCE_FLAG char(4000) nullif ADVANCE_FLAG=blanks 
    ,BIZ_SYS_CODE char(4000) nullif BIZ_SYS_CODE=blanks 
)