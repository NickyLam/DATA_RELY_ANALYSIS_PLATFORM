: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_scrm_user_behavior_data_a
CreateDate: 20241115
FileName:   ${iel_data_path}/scrm_user_behavior_data.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.qw_user_id,chr(13),''),chr(10),'') as qw_user_id
,replace(replace(t1.user_no,chr(13),''),chr(10),'') as user_no
,replace(replace(t1.user_name,chr(13),''),chr(10),'') as user_name
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.behavior_date,chr(13),''),chr(10),'') as behavior_date
,new_apply_cnt
,new_contact_cnt
,chat_cnt
,message_cnt
,reply_percentage
,avg_reply_time
,negative_feedback_cnt

from ${iol_schema}.scrm_user_behavior_data t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/scrm_user_behavior_data.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
