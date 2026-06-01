: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icms_tk_management_message_a
CreateDate: 20241105
FileName:   ${iel_data_path}/icms_tk_management_message.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,t1.serialno as serialno
,t1.objectno as objectno
,t1.asstaskno as asstaskno
,t1.objecttype as objecttype
,t1.messagetype as messagetype
,t1.subject as subject
,t1.content as content
,t1.inputdate as inputdate

from ${idl_schema}.icms_tk_management_message t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_tk_management_message.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
