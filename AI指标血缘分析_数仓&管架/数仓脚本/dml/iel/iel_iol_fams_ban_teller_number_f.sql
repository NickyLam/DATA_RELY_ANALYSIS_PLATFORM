: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_ban_teller_number_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_ban_teller_number.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.username,chr(13),''),chr(10),'') as username
,replace(replace(t1.tellerno1,chr(13),''),chr(10),'') as tellerno1
,replace(replace(t1.tellerno2,chr(13),''),chr(10),'') as tellerno2
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,t1.create_time as create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,t1.update_time as update_time
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.fams_ban_teller_number t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_ban_teller_number.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes