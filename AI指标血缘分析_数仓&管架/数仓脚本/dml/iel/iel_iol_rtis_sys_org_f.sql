: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rtis_sys_org_f
CreateDate: 20240506
FileName:   ${iel_data_path}/rtis_sys_org.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id_,chr(13),''),chr(10),'') as id_
,replace(replace(t1.parent_id,chr(13),''),chr(10),'') as parent_id
,replace(replace(t1.full_path,chr(13),''),chr(10),'') as full_path
,replace(replace(t1.name_,chr(13),''),chr(10),'') as name_
,replace(replace(t1.type_,chr(13),''),chr(10),'') as type_
,replace(replace(t1.contact,chr(13),''),chr(10),'') as contact
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.comments,chr(13),''),chr(10),'') as comments
,create_time
,update_time
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,replace(replace(t1.update_by,chr(13),''),chr(10),'') as update_by
,replace(replace(t1.org_area,chr(13),''),chr(10),'') as org_area
,replace(replace(t1.handle_org,chr(13),''),chr(10),'') as handle_org
,replace(replace(t1.org_level,chr(13),''),chr(10),'') as org_level

from ${iol_schema}.rtis_sys_org t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rtis_sys_org.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
