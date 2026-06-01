: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ccdb_ochat_message_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccdb_ochat_message_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.room_no,chr(13),''),chr(10),'') as room_no
,replace(replace(t1.msg_content_code,chr(13),''),chr(10),'') as msg_content_code
,replace(replace(t1.from_member_no,chr(13),''),chr(10),'') as from_member_no
,replace(replace(t1.to_member_no,chr(13),''),chr(10),'') as to_member_no
,t1.time as time
,replace(replace(t1.sender_name,chr(13),''),chr(10),'') as sender_name
,replace(replace(t1.sender_code,chr(13),''),chr(10),'') as sender_code
,replace(replace(t1.sender_type,chr(13),''),chr(10),'') as sender_type
,t1.reply_interval as reply_interval
,replace(replace(t1.buss_code,chr(13),''),chr(10),'') as buss_code
,replace(replace(t1.skill_group_code,chr(13),''),chr(10),'') as skill_group_code
,replace(replace(t1.chat_sign,chr(13),''),chr(10),'') as chat_sign
,t1.chat_seq as chat_seq
,replace(replace(t1.msg_type,chr(13),''),chr(10),'') as msg_type
,replace(replace(t1.reply_sign,chr(13),''),chr(10),'') as reply_sign
from ${iol_schema}.ccdb_ochat_message_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccdb_ochat_message_info.i.${batch_date}.dat" \
        charset=utf8
        safe=yes