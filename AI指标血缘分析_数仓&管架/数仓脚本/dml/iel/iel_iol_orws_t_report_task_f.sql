: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_t_report_task_f
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_t_report_task.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,replace(replace(t1.task_title,chr(13),''),chr(10),'') as task_title 
,replace(replace(t1.task_status,chr(13),''),chr(10),'') as task_status 
,replace(replace(t1.explain_advise,chr(13),''),chr(10),'') as explain_advise 
,replace(replace(t1.verification_opinion,chr(13),''),chr(10),'') as verification_opinion 
,t1.executive_organ_id as executive_organ_id 
,replace(replace(t1.task_level,chr(13),''),chr(10),'') as task_level 
,t1.parent_organ_id as parent_organ_id 
,t1.parent_task_id as parent_task_id 
,t1.task_create_date as task_create_date 
,t1.task_report_date as task_report_date 
,t1.task_update_date as task_update_date 
,replace(replace(t1.is_delete,chr(13),''),chr(10),'') as is_delete 
,t1.curr_operator_id as curr_operator_id 
,t1.operator_entry_time as operator_entry_time 
,t1.business_date as business_date 
,t1.curr_node_id as curr_node_id 
,replace(replace(t1.temp_verification_opinion,chr(13),''),chr(10),'') as temp_verification_opinion 
,replace(replace(t1.is_selected,chr(13),''),chr(10),'') as is_selected 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.orws_t_report_task t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_t_report_task.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes