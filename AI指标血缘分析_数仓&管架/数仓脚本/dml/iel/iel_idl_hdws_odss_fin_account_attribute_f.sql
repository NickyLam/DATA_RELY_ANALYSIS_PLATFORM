: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_odss_fin_account_attribute_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_odss_fin_account_attribute_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="SELECT
FIN_ACCOUNT_ID
,ATTR_NAME
,ATTR_VALUE
,LAST_UPDATED_STAMP
,LAST_UPDATED_TX_STAMP
,CREATED_STAMP
,CREATED_TX_STAMP
,DESCRIPTION

FROM IDL.HDWS_ODSS_FIN_ACCOUNT_ATTRIBUTE
WHERE ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_odss_fin_account_attribute_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes