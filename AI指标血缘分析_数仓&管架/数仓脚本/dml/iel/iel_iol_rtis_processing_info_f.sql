: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rtis_processing_info_f
CreateDate: 20241012
FileName:   ${iel_data_path}/rtis_processing_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,warn_id
,replace(replace(t1.pro_order,chr(13),''),chr(10),'') as pro_order
,replace(replace(t1.pro_time,chr(13),''),chr(10),'') as pro_time
,replace(replace(t1.pro_people,chr(13),''),chr(10),'') as pro_people
,replace(replace(t1.resp_day,chr(13),''),chr(10),'') as resp_day
,replace(replace(t1.result,chr(13),''),chr(10),'') as result
,replace(replace(t1.explains,chr(13),''),chr(10),'') as explains
,replace(replace(t1.net_feedback,chr(13),''),chr(10),'') as net_feedback
,replace(replace(t1.super_vet,chr(13),''),chr(10),'') as super_vet

from ${iol_schema}.rtis_processing_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rtis_processing_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
