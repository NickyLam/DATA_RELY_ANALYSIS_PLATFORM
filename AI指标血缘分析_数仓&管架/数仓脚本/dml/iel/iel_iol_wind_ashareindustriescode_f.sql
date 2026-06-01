: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_ashareindustriescode_f
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_ashareindustriescode.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id 
,replace(replace(t1.industriescode,chr(13),''),chr(10),'') as industriescode 
,replace(replace(t1.industriesname,chr(13),''),chr(10),'') as industriesname 
,t1.levelnum as levelnum 
,t1.used as used 
,replace(replace(t1.industriesalias,chr(13),''),chr(10),'') as industriesalias 
,t1.sequence as sequence 
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.wind_ashareindustriescode t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_ashareindustriescode.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes