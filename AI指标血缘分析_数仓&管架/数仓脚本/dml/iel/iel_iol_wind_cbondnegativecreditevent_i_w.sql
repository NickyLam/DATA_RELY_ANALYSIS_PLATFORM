: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondnegativecreditevent_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_cbondnegativecreditevent_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(object_id,chr(10),''),chr(13),'') as object_id
,replace(replace(s_info_windcode,chr(10),''),chr(13),'') as s_info_windcode
,replace(replace(acu_date,chr(10),''),chr(13),'') as acu_date
,replace(replace(event_type,chr(10),''),chr(13),'') as event_type
,replace(replace(s_info_compcode,chr(10),''),chr(13),'') as s_info_compcode
,replace(replace(subject_type,chr(10),''),chr(13),'') as subject_type
,replace(replace(event_title,chr(10),''),chr(13),'') as event_title
,replace(replace(event_memo,chr(10),''),chr(13),'') as event_memo
,etl_dt
,etl_timestamp
from ${iol_schema}.wind_cbondnegativecreditevent where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondnegativecreditevent_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes