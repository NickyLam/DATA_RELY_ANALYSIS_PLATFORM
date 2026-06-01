: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_uuss_afa_comminfo_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_uuss_afa_comminfo.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.itemname as itemname
,t1.serverip as serverip
,t1.serverport as serverport
,t1.conntimeout as conntimeout
,t1.transtimeout as transtimeout
,t1.encoding as encoding
,t1.remark as remark
,t1.status as status
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.sendersysid as sendersysid
,t1.recversysid as recversysid

from ${idl_schema}.oass_uuss_afa_comminfo t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_uuss_afa_comminfo.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
