/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_upps_order_header
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_upps_order_header
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_upps_order_header purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_upps_order_header(
    ETL_DT DATE
    ,ORDER_ID VARCHAR2(20)
    ,ORDER_TYPE_ID VARCHAR2(20)
    ,ORDER_NAME VARCHAR2(100)
    ,EXTERNAL_ID VARCHAR2(20)
    ,SALES_CHANNEL_ENUM_ID VARCHAR2(20)
    ,ORDER_DATE TIMESTAMP(6)
    ,PRIORITY VARCHAR2(1)
    ,ENTRY_DATE TIMESTAMP(6)
    ,PICK_SHEET_PRINTED_DATE TIMESTAMP(6)
    ,VISIT_ID VARCHAR2(20)
    ,STATUS_ID VARCHAR2(20)
    ,CREATED_BY VARCHAR2(255)
    ,FIRST_ATTEMPT_ORDER_ID VARCHAR2(20)
    ,CURRENCY_UOM VARCHAR2(20)
    ,SYNC_STATUS_ID VARCHAR2(20)
    ,BILLING_ACCOUNT_ID VARCHAR2(20)
    ,ORIGIN_FACILITY_ID VARCHAR2(20)
    ,WEB_SITE_ID VARCHAR2(20)
    ,PRODUCT_STORE_ID VARCHAR2(20)
    ,TERMINAL_ID VARCHAR2(60)
    ,TRANSACTION_ID VARCHAR2(60)
    ,AUTO_ORDER_SHOPPING_LIST_ID VARCHAR2(20)
    ,NEEDS_INVENTORY_ISSUANCE VARCHAR2(1)
    ,IS_RUSH_ORDER VARCHAR2(1)
    ,INTERNAL_CODE VARCHAR2(60)
    ,REMAINING_SUB_TOTAL NUMBER(18,2)
    ,GRAND_TOTAL NUMBER(18,2)
    ,IS_VIEWED VARCHAR2(1)
    ,LAST_UPDATED_STAMP TIMESTAMP(6)
    ,LAST_UPDATED_TX_STAMP TIMESTAMP(6)
    ,CREATED_STAMP TIMESTAMP(6)
    ,CREATED_TX_STAMP TIMESTAMP(6)
    ,PRODUCT_ID VARCHAR2(20)
    ,INTERNAL_NOTE VARCHAR2(255)
    ,PUBLIC_NOTE VARCHAR2(255)
    ,AMOUNT NUMBER(18,2)
    ,ORIG_ORDER_ID VARCHAR2(255)
    ,PRODUCT_CATEGORY_ID VARCHAR2(20)
    ,GLOBAL_TRANS_ID VARCHAR2(60)
    ,PROD_CATALOG_ID VARCHAR2(20)
    ,STOP_ORDER_CREATED VARCHAR2(60)
    ,STOP_ORDER_RECEIVED VARCHAR2(60)
    ,DO_RECEIVED_FAIL VARCHAR2(60)
    ,DO_DELIVERY_FAIL VARCHAR2(60)
    ,PAYER_PAYMENT_METHOD_TYPE_ID VARCHAR2(20)
    ,PAYER_PARTY_ID VARCHAR2(20)
    ,PAYER_ACCOUNT_NUMBER VARCHAR2(60)
    ,PAYER_ACCOUNT_NAME VARCHAR2(255)
    ,PAYER_VOUCHER_TYPE_ID VARCHAR2(20)
    ,PAYER_VOUCHER_NUMBER VARCHAR2(60)
    ,PAYER_CASH_OR_REMIT_FLAG VARCHAR2(1)
    ,PAYER_CERT_NO VARCHAR2(60)
    ,PAYER_MOBILE_PHONE_NUMBER VARCHAR2(20)
    ,PAYEE_PAYMENT_METHOD_TYPE_ID VARCHAR2(20)
    ,PAYEE_PARTY_ID VARCHAR2(20)
    ,PAYEE_ACCOUNT_NUMBER VARCHAR2(60)
    ,PAYEE_ACCOUNT_NAME VARCHAR2(255)
    ,PAYEE_VOUCHER_TYPE_ID VARCHAR2(20)
    ,PAYEE_VOUCHER_NUMBER VARCHAR2(60)
    ,PAYEE_CASH_OR_REMIT_FLAG VARCHAR2(1)
    ,PAYEE_CERT_NO VARCHAR2(60)
    ,PAYEE_MOBILE_PHONE_NUMBER VARCHAR2(20)
    ,PRE_AUTH_CANCEL_TRANS_ID VARCHAR2(60)
    ,PAYER_CUST_NO VARCHAR2(20)
    ,AUTHR_TELLER_NO VARCHAR2(20)
    ,RET_CODE VARCHAR2(20)
    ,RET_MESSAGE VARCHAR2(255)
    ,IS_NEXT_DAY VARCHAR2(1)
    ,TRANS_TIME TIMESTAMP(6)
    ,TRANS_CODE VARCHAR2(10)
    ,CHECKING_CODE VARCHAR2(60)
    ,PAYER_VOUCHER_DATE VARCHAR2(20)
    ,PAYEE_VOUCHER_DATE VARCHAR2(20)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_upps_order_header to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_upps_order_header is '订单信息表';
comment on column ${msl_schema}.msl_edw_upps_order_header.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_upps_order_header.ORDER_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.ORDER_TYPE_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.ORDER_NAME is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.EXTERNAL_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.SALES_CHANNEL_ENUM_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.ORDER_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PRIORITY is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.ENTRY_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PICK_SHEET_PRINTED_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.VISIT_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.STATUS_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.CREATED_BY is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.FIRST_ATTEMPT_ORDER_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.CURRENCY_UOM is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.SYNC_STATUS_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.BILLING_ACCOUNT_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.ORIGIN_FACILITY_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.WEB_SITE_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PRODUCT_STORE_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.TERMINAL_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.TRANSACTION_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.AUTO_ORDER_SHOPPING_LIST_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.NEEDS_INVENTORY_ISSUANCE is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.IS_RUSH_ORDER is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.INTERNAL_CODE is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.REMAINING_SUB_TOTAL is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.GRAND_TOTAL is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.IS_VIEWED is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.LAST_UPDATED_STAMP is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.LAST_UPDATED_TX_STAMP is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.CREATED_STAMP is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.CREATED_TX_STAMP is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PRODUCT_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.INTERNAL_NOTE is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PUBLIC_NOTE is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.AMOUNT is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.ORIG_ORDER_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PRODUCT_CATEGORY_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.GLOBAL_TRANS_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PROD_CATALOG_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.STOP_ORDER_CREATED is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.STOP_ORDER_RECEIVED is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.DO_RECEIVED_FAIL is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.DO_DELIVERY_FAIL is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYER_PAYMENT_METHOD_TYPE_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYER_PARTY_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYER_ACCOUNT_NUMBER is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYER_ACCOUNT_NAME is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYER_VOUCHER_TYPE_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYER_VOUCHER_NUMBER is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYER_CASH_OR_REMIT_FLAG is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYER_CERT_NO is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYER_MOBILE_PHONE_NUMBER is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYEE_PAYMENT_METHOD_TYPE_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYEE_PARTY_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYEE_ACCOUNT_NUMBER is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYEE_ACCOUNT_NAME is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYEE_VOUCHER_TYPE_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYEE_VOUCHER_NUMBER is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYEE_CASH_OR_REMIT_FLAG is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYEE_CERT_NO is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYEE_MOBILE_PHONE_NUMBER is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PRE_AUTH_CANCEL_TRANS_ID is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYER_CUST_NO is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.AUTHR_TELLER_NO is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.RET_CODE is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.RET_MESSAGE is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.IS_NEXT_DAY is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.TRANS_TIME is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.TRANS_CODE is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.CHECKING_CODE is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYER_VOUCHER_DATE is '';
comment on column ${msl_schema}.msl_edw_upps_order_header.PAYEE_VOUCHER_DATE is '';
