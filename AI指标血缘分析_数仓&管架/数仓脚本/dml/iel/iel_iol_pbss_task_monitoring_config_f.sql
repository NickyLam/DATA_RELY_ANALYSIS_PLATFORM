: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pbss_task_monitoring_config_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pbss_task_monitoring_config.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.id,chr(13),''),chr(10),'') as id 
,replace(replace(t1.task_monitoring_code,chr(13),''),chr(10),'') as task_monitoring_code 
,replace(replace(t1.task_monitoring_name,chr(13),''),chr(10),'') as task_monitoring_name 
,replace(replace(t1.star,chr(13),''),chr(10),'') as star 
,replace(replace(t1.task_monitoring_type,chr(13),''),chr(10),'') as task_monitoring_type 
,replace(replace(t1.parent_id,chr(13),''),chr(10),'') as parent_id 
,replace(replace(t1.ave_mission,chr(13),''),chr(10),'') as ave_mission 
,replace(replace(t1.tache_type,chr(13),''),chr(10),'') as tache_type 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.pbss_task_monitoring_config t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbss_task_monitoring_config.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes