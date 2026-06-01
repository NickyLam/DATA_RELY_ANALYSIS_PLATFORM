: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_scrm_chat_msg_record_i
CreateDate: 20230804
FileName:   ${iel_data_path}/scrm_chat_msg_record.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pk_id,chr(13),''),chr(10),'') as pk_id
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.from_id,chr(13),''),chr(10),'') as from_id
,from_type
,replace(replace(t1.to_id,chr(13),''),chr(10),'') as to_id
,to_type
,replace(replace(t1.msg_date,chr(13),''),chr(10),'') as msg_date
,replace(replace(t1.msg_day,chr(13),''),chr(10),'') as msg_day
,replace(replace(t1.msg_time,chr(13),''),chr(10),'') as msg_time
,msg_unix_time
,replace(replace(t1.msg_type,chr(13),''),chr(10),'') as msg_type
,msg_cnt

from ${iol_schema}.scrm_chat_msg_record t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/scrm_chat_msg_record.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
