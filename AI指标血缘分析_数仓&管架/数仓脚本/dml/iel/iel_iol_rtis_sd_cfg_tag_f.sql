: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rtis_sd_cfg_tag_f
CreateDate: 20241012
FileName:   ${iel_data_path}/rtis_sd_cfg_tag.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id_,chr(13),''),chr(10),'') as id_
,replace(replace(t1.code_,chr(13),''),chr(10),'') as code_
,replace(replace(t1.name_,chr(13),''),chr(10),'') as name_
,replace(replace(t1.comment_,chr(13),''),chr(10),'') as comment_
,replace(replace(t1.group_id_,chr(13),''),chr(10),'') as group_id_
,replace(replace(t1.oper_scene_id,chr(13),''),chr(10),'') as oper_scene_id
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,replace(replace(t1.update_by,chr(13),''),chr(10),'') as update_by
,create_time
,update_time

from ${iol_schema}.rtis_sd_cfg_tag t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rtis_sd_cfg_tag.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
