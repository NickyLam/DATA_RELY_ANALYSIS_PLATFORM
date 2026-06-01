: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_ded_rate_def_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_ded_rate_def.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.id as id
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.type,chr(13),''),chr(10),'') as type
,t1.i_id as i_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.ibms_ttrd_ded_rate_def t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_ded_rate_def.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes