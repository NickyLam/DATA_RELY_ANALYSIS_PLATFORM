: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_rtis_sd_package_f
CreateDate: 20240307
FileName:   ${iel_data_path}/rtis_sd_package.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id_
,replace(replace(t1.pkg_id,chr(13),''),chr(10),'') as pkg_id
,version_
,replace(replace(t1.simulation_id,chr(13),''),chr(10),'') as simulation_id
,is_latest
,replace(replace(t1.name_,chr(13),''),chr(10),'') as name_
,replace(replace(t1.type_,chr(13),''),chr(10),'') as type_
,replace(replace(t1.oper_scene_id,chr(13),''),chr(10),'') as oper_scene_id
,order_index
,status_
,replace(replace(t1.cate_id,chr(13),''),chr(10),'') as cate_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.apply_org,chr(13),''),chr(10),'') as apply_org
,replace(replace(t1.note,chr(13),''),chr(10),'') as note
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,replace(replace(t1.update_by,chr(13),''),chr(10),'') as update_by
,create_time
,update_time

from ${iol_schema}.rtis_sd_package t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rtis_sd_package.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
