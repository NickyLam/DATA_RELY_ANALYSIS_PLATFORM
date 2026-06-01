: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_odss_payment_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_odss_payment_${batch_date}_i.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="SELECT
PAYMENT_ID
,PAYMENT_TYPE_ID
,PAYMENT_METHOD_TYPE_ID
,PAYMENT_METHOD_ID
,PAYMENT_GATEWAY_RESPONSE_ID
,PAYMENT_PREFERENCE_ID
,PARTY_ID_FROM
,PARTY_ID_TO
,ROLE_TYPE_ID_TO
,STATUS_ID
,EFFECTIVE_DATE
,PAYMENT_REF_NUM
,AMOUNT
,CURRENCY_UOM_ID
,COMMENTS
,FIN_ACCOUNT_TRANS_ID
,OVERRIDE_GL_ACCOUNT_ID
,ACTUAL_CURRENCY_AMOUNT
,ACTUAL_CURRENCY_UOM_ID
,LAST_UPDATED_STAMP
,LAST_UPDATED_TX_STAMP
,CREATED_STAMP
,CREATED_TX_STAMP
,OPP_ACCOUNT_NUM
,OPP_ACCOUNT_NAME
,OPP_BANK_NUM
,OPP_BANK_NAME
,FIN_ACCOUNT_ID
,ACC_NAME
,TRADE_PARTY_ID
,ALL_RECEIVE_DATE
,PARENT_PAYMENT_ID
,SUMMARY_INFO
,POSTSCRIPT
,NUM
,RE_TYPE
,OPP_ACC_LEVEL
,CHECK_BILL_PRODUCT_ID
,CHECK_BILL_DATE

FROM IDL.hdws_odss_payment

WHERE ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_odss_payment_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes