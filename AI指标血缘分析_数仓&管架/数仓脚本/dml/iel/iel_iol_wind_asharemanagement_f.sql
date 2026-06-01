: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_asharemanagement_f
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_asharemanagement.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t.ann_date,chr(13),''),chr(10),'') as ann_date
,replace(replace(t.s_info_manager_name,chr(13),''),chr(10),'') as s_info_manager_name
,replace(replace(t.s_info_manager_gender,chr(13),''),chr(10),'') as s_info_manager_gender
,replace(replace(t.s_info_manager_education,chr(13),''),chr(10),'') as s_info_manager_education
,replace(replace(t.s_info_manager_nationality,chr(13),''),chr(10),'') as s_info_manager_nationality
,replace(replace(t.s_info_manager_birthyear,chr(13),''),chr(10),'') as s_info_manager_birthyear
,replace(replace(t.s_info_manager_startdate,chr(13),''),chr(10),'') as s_info_manager_startdate
,replace(replace(t.s_info_manager_leavedate,chr(13),''),chr(10),'') as s_info_manager_leavedate
,t.s_info_manager_type as s_info_manager_type
,replace(replace(t.s_info_manager_post,chr(13),''),chr(10),'') as s_info_manager_post
,replace(replace(t.s_info_manager_introduction,chr(13),''),chr(10),'') as s_info_manager_introduction
,t.opdate as opdate
,replace(replace(t.opmode,chr(13),''),chr(10),'') as opmode
from iol.wind_asharemanagement t
where etl_dt =to_date('${batch_date}','yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_asharemanagement.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes