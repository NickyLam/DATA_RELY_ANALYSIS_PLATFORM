: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_odss_interest_rate_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_odss_interest_rate_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="SELECT
INTEREST_RATE_ID
,RATE_PROPERTY
,FROM_DATE
,RATE_TYPE
,INTEREST_RATE
,DESCRIPTION
,LAST_UPDATED_STAMP
,LAST_UPDATED_TX_STAMP
,CREATED_STAMP
,CREATED_TX_STAMP

FROM IDL.HDWS_ODSS_INTEREST_RATE

WHERE ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_odss_interest_rate_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes