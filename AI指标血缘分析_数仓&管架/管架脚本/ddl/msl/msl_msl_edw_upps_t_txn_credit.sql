/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_upps_t_txn_credit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_upps_t_txn_credit
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_upps_t_txn_credit purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_upps_t_txn_credit(
    ETL_DT DATE
    ,ID NUMBER(20,0)
    ,GLOBAL_NO VARCHAR2(64)
    ,TXN_NO VARCHAR2(64)
    ,TXN_DATE VARCHAR2(8)
    ,TXN_TIME VARCHAR2(6)
    ,TXN_TYPE VARCHAR2(2)
    ,CORPORATE VARCHAR2(64)
    ,MCHT_NO VARCHAR2(32)
    ,PRODUCT_NO VARCHAR2(32)
    ,TRAN_NO VARCHAR2(64)
    ,TRAN_DATE VARCHAR2(8)
    ,TRAN_TIME VARCHAR2(20)
    ,STATUS VARCHAR2(30)
    ,BIZ_STATUS VARCHAR2(30)
    ,TRADE_TYPE VARCHAR2(24)
    ,ROUTE_TYPE VARCHAR2(6)
    ,PRIORITY VARCHAR2(2)
    ,WORK_DATE VARCHAR2(8)
    ,AMOUNT NUMBER(20,2)
    ,CURRENCY VARCHAR2(6)
    ,PAYEE_ACCT_NO VARCHAR2(32)
    ,PAYEE_ACCT_NAME VARCHAR2(192)
    ,PAYEE_ACCT_TYPE VARCHAR2(30)
    ,PAYEE_HOST_TYPE VARCHAR2(30)
    ,PAYEE_BANK_CODE VARCHAR2(24)
    ,PAYER_ACCT_NO VARCHAR2(32)
    ,PAYER_ACCT_NAME VARCHAR2(192)
    ,PAYER_ACCT_TYPE VARCHAR2(30)
    ,PAYER_HOST_TYPE VARCHAR2(30)
    ,PAYER_PHONE VARCHAR2(24)
    ,PAYER_VALID_DATE VARCHAR2(8)
    ,PAYER_CVN2 VARCHAR2(4)
    ,PAYER_BANK_CODE VARCHAR2(24)
    ,REAL_PAYER_ACCT_NO VARCHAR2(32)
    ,REAL_PAYER_ACCT_NAME VARCHAR2(192)
    ,REAL_PAYER_ACCT_TYPE VARCHAR2(30)
    ,REAL_PAYER_HOST_TYPE VARCHAR2(30)
    ,RET_CODE VARCHAR2(60)
    ,RET_MSG VARCHAR2(1536)
    ,IS_LIMITED VARCHAR2(2)
    ,ACTION_TYPE VARCHAR2(24)
    ,HOST_STATUS VARCHAR2(30)
    ,ACCOUNT_CNT NUMBER(10,0)
    ,HOST_CODE_LIST VARCHAR2(120)
    ,HOST_NO VARCHAR2(64)
    ,REVERSE_NO VARCHAR2(64)
    ,REFUNDED VARCHAR2(2)
    ,PMC_CODE VARCHAR2(12)
    ,PMC_NO VARCHAR2(64)
    ,PMC_STATUS VARCHAR2(30)
    ,PMC_RET_CODE VARCHAR2(24)
    ,PMC_RET_MSG VARCHAR2(1536)
    ,PMC_DATE VARCHAR2(8)
    ,PMC_TIME VARCHAR2(6)
    ,PMC_COST NUMBER(20,2)
    ,MCHT_FEE NUMBER(20,2)
    ,FEE_NO VARCHAR2(64)
    ,FEE_STATUS VARCHAR2(12)
    ,CHARGE_TYPE VARCHAR2(2)
    ,CHECK_DATE VARCHAR2(8)
    ,CHECKED VARCHAR2(2)
    ,CHECK_STATE VARCHAR2(12)
    ,IS_CHARGE VARCHAR2(1)
    ,IS_DELAY VARCHAR2(1)
    ,DELAY_TIME VARCHAR2(12)
    ,FEE_AMOUNT NUMBER(20,2)
    ,CHL_CHECKING_CODE VARCHAR2(30)
    ,CHL_CHECK_DATE VARCHAR2(8)
    ,AUTH_TELLER_NO VARCHAR2(30)
    ,CHECK_TELLER_NO VARCHAR2(30)
    ,TRANS_ORG_NO VARCHAR2(30)
    ,SUMMERY_CODE VARCHAR2(30)
    ,CONSUMER_ID VARCHAR2(30)
    ,IS_NOTIFY VARCHAR2(2)
    ,NOTIFY_ADDR VARCHAR2(100)
    ,NOTIFY_SERVICE_NAME VARCHAR2(60)
    ,PAYER_EXT_MAP_ID VARCHAR2(60)
    ,PAYEE_EXT_MAP_ID VARCHAR2(60)
    ,ROUTE_MAP_ID VARCHAR2(60)
    ,HOST_DESC VARCHAR2(256)
    ,CHANNEL_DESC VARCHAR2(256)
    ,BALANCE_DESC VARCHAR2(256)
    ,CHECK_TIME DATE
    ,BUINESS_MODULE VARCHAR2(32)
    ,INIT_MCHT_NO VARCHAR2(64)
    ,SYS_COMM_NO VARCHAR2(64)
    ,PMC_RET_NO VARCHAR2(64)
    ,PMC_RET_DATE VARCHAR2(8)
    ,PMC_RET_TIME VARCHAR2(20)
    ,PMC_RET_STATUS VARCHAR2(20)
    ,MCHT_CHECK_MODE VARCHAR2(32)
    ,PAYER_BANK_NAME VARCHAR2(256)
    ,PAYEE_BANK_NAME VARCHAR2(256)
    ,CHECK_FLAG VARCHAR2(30)
    ,HOST_DATE VARCHAR2(8)
    ,HOST_TIME VARCHAR2(6)
    ,ACC_BEAN_JSON VARCHAR2(3000)
    ,CLEAR_DATE VARCHAR2(8)
    ,CLEARED VARCHAR2(2)
    ,CLEAR_NO VARCHAR2(64)
    ,CLEAR_TYPE VARCHAR2(2)
    ,CLEAR_CYCLE NUMBER(11,0)
    ,TELLER_NO VARCHAR2(64)
    ,PAYEE_PHONE VARCHAR2(24)
    ,PAYEE_VALID_DATE VARCHAR2(8)
    ,PAYEE_CVN2 VARCHAR2(4)
    ,BIZ_TYPE VARCHAR2(24)
    ,SIGN_NO VARCHAR2(64)
    ,BATCH_NO VARCHAR2(64)
    ,PURPOSE VARCHAR2(128)
    ,LOG_ID VARCHAR2(64)
    ,SERVER_ID VARCHAR2(64)
    ,SHARDING VARCHAR2(64)
    ,REMARK VARCHAR2(128)
    ,CREATE_TIME DATE
    ,UPDATE_TIME DATE
    ,TRACE_MSG VARCHAR2(256)
    ,CHECKING_CODE VARCHAR2(24)
    ,ADVANCE_FLAG VARCHAR2(4)
    ,BIZ_SYS_CODE VARCHAR2(24)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_upps_t_txn_credit to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_upps_t_txn_credit is '平台贷记类交易交互流水表';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.ID is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.GLOBAL_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.TXN_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.TXN_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.TXN_TIME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.TXN_TYPE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CORPORATE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.MCHT_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PRODUCT_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.TRAN_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.TRAN_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.TRAN_TIME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.STATUS is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.BIZ_STATUS is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.TRADE_TYPE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.ROUTE_TYPE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PRIORITY is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.WORK_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.AMOUNT is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CURRENCY is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYEE_ACCT_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYEE_ACCT_NAME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYEE_ACCT_TYPE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYEE_HOST_TYPE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYEE_BANK_CODE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYER_ACCT_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYER_ACCT_NAME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYER_ACCT_TYPE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYER_HOST_TYPE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYER_PHONE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYER_VALID_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYER_CVN2 is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYER_BANK_CODE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.REAL_PAYER_ACCT_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.REAL_PAYER_ACCT_NAME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.REAL_PAYER_ACCT_TYPE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.REAL_PAYER_HOST_TYPE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.RET_CODE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.RET_MSG is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.IS_LIMITED is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.ACTION_TYPE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.HOST_STATUS is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.ACCOUNT_CNT is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.HOST_CODE_LIST is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.HOST_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.REVERSE_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.REFUNDED is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PMC_CODE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PMC_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PMC_STATUS is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PMC_RET_CODE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PMC_RET_MSG is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PMC_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PMC_TIME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PMC_COST is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.MCHT_FEE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.FEE_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.FEE_STATUS is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CHARGE_TYPE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CHECK_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CHECKED is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CHECK_STATE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.IS_CHARGE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.IS_DELAY is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.DELAY_TIME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.FEE_AMOUNT is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CHL_CHECKING_CODE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CHL_CHECK_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.AUTH_TELLER_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CHECK_TELLER_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.TRANS_ORG_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.SUMMERY_CODE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CONSUMER_ID is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.IS_NOTIFY is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.NOTIFY_ADDR is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.NOTIFY_SERVICE_NAME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYER_EXT_MAP_ID is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYEE_EXT_MAP_ID is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.ROUTE_MAP_ID is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.HOST_DESC is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CHANNEL_DESC is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.BALANCE_DESC is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CHECK_TIME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.BUINESS_MODULE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.INIT_MCHT_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.SYS_COMM_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PMC_RET_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PMC_RET_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PMC_RET_TIME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PMC_RET_STATUS is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.MCHT_CHECK_MODE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYER_BANK_NAME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYEE_BANK_NAME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CHECK_FLAG is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.HOST_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.HOST_TIME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.ACC_BEAN_JSON is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CLEAR_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CLEARED is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CLEAR_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CLEAR_TYPE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CLEAR_CYCLE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.TELLER_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYEE_PHONE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYEE_VALID_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PAYEE_CVN2 is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.BIZ_TYPE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.SIGN_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.BATCH_NO is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.PURPOSE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.LOG_ID is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.SERVER_ID is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.SHARDING is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.REMARK is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CREATE_TIME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.UPDATE_TIME is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.TRACE_MSG is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.CHECKING_CODE is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.ADVANCE_FLAG is '';
comment on column ${msl_schema}.msl_edw_upps_t_txn_credit.BIZ_SYS_CODE is '';
