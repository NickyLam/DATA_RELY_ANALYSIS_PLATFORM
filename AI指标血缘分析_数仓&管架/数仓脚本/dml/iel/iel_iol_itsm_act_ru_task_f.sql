: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_itsm_act_ru_task_f
CreateDate: 20240904
FileName:   ${iel_data_path}/itsm_act_ru_task.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id_,chr(13),''),chr(10),'') as id_
,rev_
,replace(replace(t1.execution_id_,chr(13),''),chr(10),'') as execution_id_
,replace(replace(t1.proc_inst_id_,chr(13),''),chr(10),'') as proc_inst_id_
,replace(replace(t1.proc_def_id_,chr(13),''),chr(10),'') as proc_def_id_
,replace(replace(t1.scope_id_,chr(13),''),chr(10),'') as scope_id_
,replace(replace(t1.sub_scope_id_,chr(13),''),chr(10),'') as sub_scope_id_
,replace(replace(t1.scope_type_,chr(13),''),chr(10),'') as scope_type_
,replace(replace(t1.scope_definition_id_,chr(13),''),chr(10),'') as scope_definition_id_
,replace(replace(t1.name_,chr(13),''),chr(10),'') as name_
,replace(replace(t1.parent_task_id_,chr(13),''),chr(10),'') as parent_task_id_
,replace(replace(t1.description_,chr(13),''),chr(10),'') as description_
,replace(replace(t1.task_def_key_,chr(13),''),chr(10),'') as task_def_key_
,replace(replace(t1.owner_,chr(13),''),chr(10),'') as owner_
,replace(replace(t1.assignee_,chr(13),''),chr(10),'') as assignee_
,replace(replace(t1.delegation_,chr(13),''),chr(10),'') as delegation_
,priority_
,create_time_
,due_date_
,replace(replace(t1.category_,chr(13),''),chr(10),'') as category_
,suspension_state_
,replace(replace(t1.tenant_id_,chr(13),''),chr(10),'') as tenant_id_
,replace(replace(t1.form_key_,chr(13),''),chr(10),'') as form_key_
,claim_time_
,is_count_enabled_
,var_count_
,id_link_count_

from ${iol_schema}.itsm_act_ru_task t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/itsm_act_ru_task.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
