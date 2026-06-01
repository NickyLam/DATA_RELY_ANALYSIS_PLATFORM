: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_odss_posting_date_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_odss_posting_date_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="SELECT
 POSTING_DATE_ID
 ,POSTING_DATE_TYPE_ID
 ,FROM_DATE
 ,THRU_DATE
 ,POSTING_DATE_TIME
 ,LAST_UPDATED_STAMP
 ,LAST_UPDATED_TX_STAMP
 ,CREATED_STAMP
 ,CREATED_TX_STAMP
FROM IDL.HDWS_ODSS_POSTING_DATE
WHERE ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_odss_posting_date_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes