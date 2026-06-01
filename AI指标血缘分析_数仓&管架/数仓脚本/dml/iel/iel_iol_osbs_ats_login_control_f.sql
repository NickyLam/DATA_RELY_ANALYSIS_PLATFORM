: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_osbs_ats_login_control_f
CreateDate: 20241230
FileName:   ${iel_data_path}/osbs_ats_login_control.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.alc_cstno,chr(13),''),chr(10),'') as alc_cstno
,replace(replace(t1.alc_userno,chr(13),''),chr(10),'') as alc_userno
,replace(replace(t1.alc_sessionid,chr(13),''),chr(10),'') as alc_sessionid
,replace(replace(t1.alc_create_time,chr(13),''),chr(10),'') as alc_create_time
,replace(replace(t1.alc_serveraddress,chr(13),''),chr(10),'') as alc_serveraddress
,replace(replace(t1.alc_clientip,chr(13),''),chr(10),'') as alc_clientip
,replace(replace(t1.alc_channel,chr(13),''),chr(10),'') as alc_channel

from ${iol_schema}.osbs_ats_login_control t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_ats_login_control.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
