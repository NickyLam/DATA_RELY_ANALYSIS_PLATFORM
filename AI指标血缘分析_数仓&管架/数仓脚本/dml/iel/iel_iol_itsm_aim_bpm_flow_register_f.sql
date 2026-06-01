: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_itsm_aim_bpm_flow_register_f
CreateDate: 20240904
FileName:   ${iel_data_path}/itsm_aim_bpm_flow_register.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.business_key,chr(13),''),chr(10),'') as business_key
,replace(replace(t1.topicname,chr(13),''),chr(10),'') as topicname
,replace(replace(t1.username,chr(13),''),chr(10),'') as username
,replace(replace(t1.nickname,chr(13),''),chr(10),'') as nickname
,replace(replace(t1.department,chr(13),''),chr(10),'') as department
,create_time
,update_time
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.category_id,chr(13),''),chr(10),'') as category_id
,replace(replace(t1.category_name,chr(13),''),chr(10),'') as category_name
,replace(replace(t1.model_id,chr(13),''),chr(10),'') as model_id
,replace(replace(t1.model_key,chr(13),''),chr(10),'') as model_key
,replace(replace(t1.model_name,chr(13),''),chr(10),'') as model_name
,replace(replace(t1.flowtype,chr(13),''),chr(10),'') as flowtype
,replace(replace(t1.procdef_id,chr(13),''),chr(10),'') as procdef_id
,replace(replace(t1.parent_key,chr(13),''),chr(10),'') as parent_key
,replace(replace(t1.unique_key,chr(13),''),chr(10),'') as unique_key
,source_system
,replace(replace(t1.priority,chr(13),''),chr(10),'') as priority
,replace(replace(t1.flowsafe,chr(13),''),chr(10),'') as flowsafe
,replace(replace(t1.serial_str,chr(13),''),chr(10),'') as serial_str
,replace(replace(t1.serial_number,chr(13),''),chr(10),'') as serial_number
,is_delete

from ${iol_schema}.itsm_aim_bpm_flow_register t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/itsm_aim_bpm_flow_register.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
