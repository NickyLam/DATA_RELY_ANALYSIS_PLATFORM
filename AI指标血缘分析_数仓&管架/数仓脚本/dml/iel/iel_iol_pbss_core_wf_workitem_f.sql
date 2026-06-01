: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pbss_core_wf_workitem_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pbss_core_wf_workitem.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.id,chr(13),''),chr(10),'') as id 
,t1.engine_address as engine_address 
,replace(replace(t1.root_act_id,chr(13),''),chr(10),'') as root_act_id 
,replace(replace(t1.parent_act_id,chr(13),''),chr(10),'') as parent_act_id 
,replace(replace(t1.activitypath,chr(13),''),chr(10),'') as activitypath 
,replace(replace(t1.description,chr(13),''),chr(10),'') as description 
,replace(replace(t1.stylesheet,chr(13),''),chr(10),'') as stylesheet 
,replace(replace(t1.exclude_participant,chr(13),''),chr(10),'') as exclude_participant 
,replace(replace(t1.workqueue,chr(13),''),chr(10),'') as workqueue 
,t1.created_time as created_time 
,t1.reclaim_deadline_time as reclaim_deadline_time 
,t1.obtain_deadline_time as obtain_deadline_time 
,t1.obtained_time as obtained_time 
,t1.submited_time as submited_time 
,t1.pauseed_time as pauseed_time 
,t1.exception_pauseed_time as exception_pauseed_time 
,t1.resumed_time as resumed_time 
,t1.finished_time as finished_time 
,replace(replace(t1.participant,chr(13),''),chr(10),'') as participant 
,t1.isrolemanager as isrolemanager 
,replace(replace(t1.org_business,chr(13),''),chr(10),'') as org_business 
,replace(replace(t1.organizationalunit,chr(13),''),chr(10),'') as organizationalunit 
,replace(replace(t1.organizationalunittype,chr(13),''),chr(10),'') as organizationalunittype 
,replace(replace(t1.organizationclassname,chr(13),''),chr(10),'') as organizationclassname 
,replace(replace(t1.operator,chr(13),''),chr(10),'') as operator 
,t1.state as state 
,t1.priority as priority 
,replace(replace(t1.processtype,chr(13),''),chr(10),'') as processtype 
,replace(replace(t1.obtainid,chr(13),''),chr(10),'') as obtainid 
,replace(replace(t1.instancepath,chr(13),''),chr(10),'') as instancepath 
,replace(replace(t1.act_id,chr(13),''),chr(10),'') as act_id 
,replace(replace(t1.act_def_v_id,chr(13),''),chr(10),'') as act_def_v_id 
,replace(replace(t1.ref_entity_id,chr(13),''),chr(10),'') as ref_entity_id 
,t1.condition_data1 as condition_data1 
,t1.condition_data2 as condition_data2 
,t1.condition_data3 as condition_data3 
,t1.condition_data4 as condition_data4 
,replace(replace(t1.share_data1,chr(13),''),chr(10),'') as share_data1 
,replace(replace(t1.share_data2,chr(13),''),chr(10),'') as share_data2 
,t1.share_data3 as share_data3 
,t1.share_data4 as share_data4 
,replace(replace(t1.update_ass,chr(13),''),chr(10),'') as update_ass 
,t1.root_start_datetime as root_start_datetime 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.pbss_core_wf_workitem t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbss_core_wf_workitem.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes