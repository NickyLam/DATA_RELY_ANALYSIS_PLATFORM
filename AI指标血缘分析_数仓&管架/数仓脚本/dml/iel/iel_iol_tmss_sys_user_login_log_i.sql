: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tmss_sys_user_login_log_i
CreateDate: 20260410
FileName:   ${iel_data_path}/tmss_sys_user_login_log.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.login_name,chr(13),''),chr(10),'') as login_name
,type
,replace(replace(t1.host,chr(13),''),chr(10),'') as host
,replace(replace(t1.user_agent,chr(13),''),chr(10),'') as user_agent
,login_date
,logout_date
,replace(replace(t1.reason,chr(13),''),chr(10),'') as reason
,replace(replace(t1.session_id,chr(13),''),chr(10),'') as session_id
,replace(replace(t1.mac,chr(13),''),chr(10),'') as mac
,replace(replace(t1.login_system,chr(13),''),chr(10),'') as login_system

from ${iol_schema}.tmss_sys_user_login_log t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tmss_sys_user_login_log.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
