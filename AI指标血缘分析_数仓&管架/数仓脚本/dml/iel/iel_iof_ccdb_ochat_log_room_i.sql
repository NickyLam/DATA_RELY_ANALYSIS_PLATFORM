: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ccdb_ochat_log_room_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccdb_ochat_log_room.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.room_no,chr(13),''),chr(10),'') as room_no
,replace(replace(t1.sum_no,chr(13),''),chr(10),'') as sum_no
,replace(replace(t1.title,chr(13),''),chr(10),'') as title
,t1.begin_time as begin_time
,t1.end_time as end_time
,replace(replace(t1.video_url,chr(13),''),chr(10),'') as video_url
,replace(replace(t1.channel_id,chr(13),''),chr(10),'') as channel_id
from ${iol_schema}.ccdb_ochat_log_room t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccdb_ochat_log_room.i.${batch_date}.dat" \
        charset=utf8
        safe=yes