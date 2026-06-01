: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_storage_details_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_storage_details_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 ID
 ,CONTRACT_ID
 ,CANCEL_CONTRACT_ID
 ,DRAFT_ID
 ,REF_TXN_TYPE
 ,REF_ID
 ,STORG_DTL_STATUS
 ,SAVE_DATE
 ,REMOVE_DATE
 ,CREDIT_CUST_NO
 ,FEE1
 ,FEE2
 ,CHECK_STATUS
 ,QUERY_ORDER
 ,QUERY_CONTENT
 ,QUERY_TYPE
 ,CHECK_RESULT
 ,CHECK_CONTENT
 ,QUERY_CHECK_ID
 ,MISC
 ,LAST_UPD_OPER_ID
 ,LAST_UPD_TIME
 ,ACCOUNT_FLAG
 ,ACCOUNT_DATE
 ,CP_BANK_NO
 ,CP_ACCOUNT_NO
 ,IS_SAME_CITY
 ,TMP_STATUS
 ,STORAGE_STATUS
 
from ${idl_schema}.odss_storage_details
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_storage_details_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes