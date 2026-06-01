: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tbms_t_user_status_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tbms_t_user_status.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.uaid as uaid 
,replace(replace(t1.userphone,chr(13),''),chr(10),'') as userphone 
,replace(replace(t1.mstpid,chr(13),''),chr(10),'') as mstpid 
,t1.userstatus as userstatus 
,replace(replace(t1.yqtid,chr(13),''),chr(10),'') as yqtid 
,t1.sys_ctime as sys_ctime 
,t1.sys_utime as sys_utime 
,t1.sys_valid as sys_valid 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.tbms_t_user_status t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbms_t_user_status.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes