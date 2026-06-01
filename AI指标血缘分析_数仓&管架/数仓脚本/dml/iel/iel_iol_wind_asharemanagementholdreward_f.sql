: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_asharemanagementholdreward_f
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_asharemanagementholdreward.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t.ann_date,chr(13),''),chr(10),'') as ann_date
,replace(replace(t.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t.crny_code,chr(13),''),chr(10),'') as crny_code
,replace(replace(t.s_info_manager_name,chr(13),''),chr(10),'') as s_info_manager_name
,replace(replace(t.s_info_manager_post,chr(13),''),chr(10),'') as s_info_manager_post
,t.s_manager_return as s_manager_return
,t.s_manager_quantity as s_manager_quantity
,t.opdate as opdate
,replace(replace(t.opmode,chr(13),''),chr(10),'') as opmode
from iol.wind_asharemanagementholdreward t
where etl_dt =to_date('${batch_date}','yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_asharemanagementholdreward.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes