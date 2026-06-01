: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_wfi_app_advice_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_wfi_app_advice.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.wfi_app_advice_id,chr(13),''),chr(10),'') as wfi_app_advice_id
    ,replace(replace(t.app_conclusion,chr(13),''),chr(10),'') as app_conclusion
    ,replace(replace(t.app_advice,chr(13),''),chr(10),'') as app_advice
    ,replace(replace(t.wfi_instance_id,chr(13),''),chr(10),'') as wfi_instance_id
    ,replace(replace(t.wfi_node_id,chr(13),''),chr(10),'') as wfi_node_id
    ,replace(replace(t.wfi_node_name,chr(13),''),chr(10),'') as wfi_node_name
    ,replace(replace(t.wfi_scene_id,chr(13),''),chr(10),'') as wfi_scene_id
    ,replace(replace(t.wfsign,chr(13),''),chr(10),'') as wfsign
    ,replace(replace(t.app_user,chr(13),''),chr(10),'') as app_user
    ,replace(replace(t.app_org,chr(13),''),chr(10),'') as app_org
    ,replace(replace(t.operate_time,chr(13),''),chr(10),'') as operate_time
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
    ,replace(replace(t.wfi_status,chr(13),''),chr(10),'') as wfi_status
    ,replace(replace(t.disagree_reason,chr(13),''),chr(10),'') as disagree_reason
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_wfi_app_advice t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_wfi_app_advice.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes