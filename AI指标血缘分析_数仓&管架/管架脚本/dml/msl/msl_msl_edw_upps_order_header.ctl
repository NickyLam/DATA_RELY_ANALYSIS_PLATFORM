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
infile '${data_path}/upps_order_header.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_upps_order_header
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ORDER_ID char(4000) nullif ORDER_ID=blanks 
    ,ORDER_TYPE_ID char(4000) nullif ORDER_TYPE_ID=blanks 
    ,ORDER_NAME char(4000) nullif ORDER_NAME=blanks 
    ,EXTERNAL_ID char(4000) nullif EXTERNAL_ID=blanks 
    ,SALES_CHANNEL_ENUM_ID char(4000) nullif SALES_CHANNEL_ENUM_ID=blanks 
    ,ORDER_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif ORDER_DATE=blanks 
    ,PRIORITY char(4000) nullif PRIORITY=blanks 
    ,ENTRY_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif ENTRY_DATE=blanks 
    ,PICK_SHEET_PRINTED_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif PICK_SHEET_PRINTED_DATE=blanks 
    ,VISIT_ID char(4000) nullif VISIT_ID=blanks 
    ,STATUS_ID char(4000) nullif STATUS_ID=blanks 
    ,CREATED_BY char(4000) nullif CREATED_BY=blanks 
    ,FIRST_ATTEMPT_ORDER_ID char(4000) nullif FIRST_ATTEMPT_ORDER_ID=blanks 
    ,CURRENCY_UOM char(4000) nullif CURRENCY_UOM=blanks 
    ,SYNC_STATUS_ID char(4000) nullif SYNC_STATUS_ID=blanks 
    ,BILLING_ACCOUNT_ID char(4000) nullif BILLING_ACCOUNT_ID=blanks 
    ,ORIGIN_FACILITY_ID char(4000) nullif ORIGIN_FACILITY_ID=blanks 
    ,WEB_SITE_ID char(4000) nullif WEB_SITE_ID=blanks 
    ,PRODUCT_STORE_ID char(4000) nullif PRODUCT_STORE_ID=blanks 
    ,TERMINAL_ID char(4000) nullif TERMINAL_ID=blanks 
    ,TRANSACTION_ID char(4000) nullif TRANSACTION_ID=blanks 
    ,AUTO_ORDER_SHOPPING_LIST_ID char(4000) nullif AUTO_ORDER_SHOPPING_LIST_ID=blanks 
    ,NEEDS_INVENTORY_ISSUANCE char(4000) nullif NEEDS_INVENTORY_ISSUANCE=blanks 
    ,IS_RUSH_ORDER char(4000) nullif IS_RUSH_ORDER=blanks 
    ,INTERNAL_CODE char(4000) nullif INTERNAL_CODE=blanks 
    ,REMAINING_SUB_TOTAL char(4000) nullif REMAINING_SUB_TOTAL=blanks 
    ,GRAND_TOTAL char(4000) nullif GRAND_TOTAL=blanks 
    ,IS_VIEWED char(4000) nullif IS_VIEWED=blanks 
    ,LAST_UPDATED_STAMP timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif LAST_UPDATED_STAMP=blanks 
    ,LAST_UPDATED_TX_STAMP timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif LAST_UPDATED_TX_STAMP=blanks 
    ,CREATED_STAMP timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif CREATED_STAMP=blanks 
    ,CREATED_TX_STAMP timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif CREATED_TX_STAMP=blanks 
    ,PRODUCT_ID char(4000) nullif PRODUCT_ID=blanks 
    ,INTERNAL_NOTE char(4000) nullif INTERNAL_NOTE=blanks 
    ,PUBLIC_NOTE char(4000) nullif PUBLIC_NOTE=blanks 
    ,AMOUNT char(4000) nullif AMOUNT=blanks 
    ,ORIG_ORDER_ID char(4000) nullif ORIG_ORDER_ID=blanks 
    ,PRODUCT_CATEGORY_ID char(4000) nullif PRODUCT_CATEGORY_ID=blanks 
    ,GLOBAL_TRANS_ID char(4000) nullif GLOBAL_TRANS_ID=blanks 
    ,PROD_CATALOG_ID char(4000) nullif PROD_CATALOG_ID=blanks 
    ,STOP_ORDER_CREATED char(4000) nullif STOP_ORDER_CREATED=blanks 
    ,STOP_ORDER_RECEIVED char(4000) nullif STOP_ORDER_RECEIVED=blanks 
    ,DO_RECEIVED_FAIL char(4000) nullif DO_RECEIVED_FAIL=blanks 
    ,DO_DELIVERY_FAIL char(4000) nullif DO_DELIVERY_FAIL=blanks 
    ,PAYER_PAYMENT_METHOD_TYPE_ID char(4000) nullif PAYER_PAYMENT_METHOD_TYPE_ID=blanks 
    ,PAYER_PARTY_ID char(4000) nullif PAYER_PARTY_ID=blanks 
    ,PAYER_ACCOUNT_NUMBER char(4000) nullif PAYER_ACCOUNT_NUMBER=blanks 
    ,PAYER_ACCOUNT_NAME char(4000) nullif PAYER_ACCOUNT_NAME=blanks 
    ,PAYER_VOUCHER_TYPE_ID char(4000) nullif PAYER_VOUCHER_TYPE_ID=blanks 
    ,PAYER_VOUCHER_NUMBER char(4000) nullif PAYER_VOUCHER_NUMBER=blanks 
    ,PAYER_CASH_OR_REMIT_FLAG char(4000) nullif PAYER_CASH_OR_REMIT_FLAG=blanks 
    ,PAYER_CERT_NO char(4000) nullif PAYER_CERT_NO=blanks 
    ,PAYER_MOBILE_PHONE_NUMBER char(4000) nullif PAYER_MOBILE_PHONE_NUMBER=blanks 
    ,PAYEE_PAYMENT_METHOD_TYPE_ID char(4000) nullif PAYEE_PAYMENT_METHOD_TYPE_ID=blanks 
    ,PAYEE_PARTY_ID char(4000) nullif PAYEE_PARTY_ID=blanks 
    ,PAYEE_ACCOUNT_NUMBER char(4000) nullif PAYEE_ACCOUNT_NUMBER=blanks 
    ,PAYEE_ACCOUNT_NAME char(4000) nullif PAYEE_ACCOUNT_NAME=blanks 
    ,PAYEE_VOUCHER_TYPE_ID char(4000) nullif PAYEE_VOUCHER_TYPE_ID=blanks 
    ,PAYEE_VOUCHER_NUMBER char(4000) nullif PAYEE_VOUCHER_NUMBER=blanks 
    ,PAYEE_CASH_OR_REMIT_FLAG char(4000) nullif PAYEE_CASH_OR_REMIT_FLAG=blanks 
    ,PAYEE_CERT_NO char(4000) nullif PAYEE_CERT_NO=blanks 
    ,PAYEE_MOBILE_PHONE_NUMBER char(4000) nullif PAYEE_MOBILE_PHONE_NUMBER=blanks 
    ,PRE_AUTH_CANCEL_TRANS_ID char(4000) nullif PRE_AUTH_CANCEL_TRANS_ID=blanks 
    ,PAYER_CUST_NO char(4000) nullif PAYER_CUST_NO=blanks 
    ,AUTHR_TELLER_NO char(4000) nullif AUTHR_TELLER_NO=blanks 
    ,RET_CODE char(4000) nullif RET_CODE=blanks 
    ,RET_MESSAGE char(4000) nullif RET_MESSAGE=blanks 
    ,IS_NEXT_DAY char(4000) nullif IS_NEXT_DAY=blanks 
    ,TRANS_TIME timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif TRANS_TIME=blanks 
    ,TRANS_CODE char(4000) nullif TRANS_CODE=blanks 
    ,CHECKING_CODE char(4000) nullif CHECKING_CODE=blanks 
    ,PAYER_VOUCHER_DATE char(4000) nullif PAYER_VOUCHER_DATE=blanks 
    ,PAYEE_VOUCHER_DATE char(4000) nullif PAYEE_VOUCHER_DATE=blanks 
)