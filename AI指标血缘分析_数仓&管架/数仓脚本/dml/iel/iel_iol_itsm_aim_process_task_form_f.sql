: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_itsm_aim_process_task_form_f
CreateDate: 20240821
FileName:   ${iel_data_path}/itsm_aim_process_task_form.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.businesskey,chr(13),''),chr(10),'') as businesskey
,replace(replace(t1.task_id,chr(13),''),chr(10),'') as task_id
,replace(replace(t1.form_name,chr(13),''),chr(10),'') as form_name
,replace(replace(t1.fields,chr(13),''),chr(10),'') as fields
,lastupdatetime
,seq
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.task_name,chr(13),''),chr(10),'') as task_name
,replace(replace(t1.form_type,chr(13),''),chr(10),'') as form_type
,replace(replace(t1.link_id,chr(13),''),chr(10),'') as link_id
,replace(replace(t1.form_html,chr(13),''),chr(10),'') as form_html
,is_use

from ${iol_schema}.itsm_aim_process_task_form t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/itsm_aim_process_task_form.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
