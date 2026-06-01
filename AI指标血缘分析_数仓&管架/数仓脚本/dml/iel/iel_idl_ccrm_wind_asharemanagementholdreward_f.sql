: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_asharemanagementholdreward_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_asharemanagementholdreward.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.ann_date,chr(13),''),chr(10),'') as ann_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.crny_code,chr(13),''),chr(10),'') as crny_code
,replace(replace(t1.s_info_manager_name,chr(13),''),chr(10),'') as s_info_manager_name
,replace(replace(t1.s_info_manager_post,chr(13),''),chr(10),'') as s_info_manager_post
,t1.s_manager_return as s_manager_return
,t1.s_manager_quantity as s_manager_quantity
,t1.opdate as opdate
,replace(replace(t1.opmode,chr(13),''),chr(10),'') as opmode
from ${iol_schema}.wind_asharemanagementholdreward t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_asharemanagementholdreward.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes