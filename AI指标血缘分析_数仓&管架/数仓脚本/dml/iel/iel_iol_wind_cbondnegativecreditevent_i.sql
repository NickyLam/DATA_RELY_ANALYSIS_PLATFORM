: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondnegativecreditevent_i
CreateDate: 20230423
FileName:   ${iel_data_path}/wind_cbondnegativecreditevent.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.acu_date,chr(13),''),chr(10),'') as acu_date
,event_type
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,subject_type
,replace(replace(t1.event_title,chr(13),''),chr(10),'') as event_title
,replace(replace(t1.event_memo,chr(13),''),chr(10),'') as event_memo
,replace(replace(t1.event_id,chr(13),''),chr(10),'') as event_id

from ${iol_schema}.wind_cbondnegativecreditevent t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondnegativecreditevent.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
