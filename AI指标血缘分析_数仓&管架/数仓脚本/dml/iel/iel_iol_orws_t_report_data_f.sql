: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_t_report_data_f
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_t_report_data.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,t1.bmc_id as bmc_id 
,replace(replace(t1.yesterday_condition,chr(13),''),chr(10),'') as yesterday_condition 
,replace(replace(t1.sb_confirmation_feedback,chr(13),''),chr(10),'') as sb_confirmation_feedback 
,replace(replace(t1.bb_confirmation_feedback,chr(13),''),chr(10),'') as bb_confirmation_feedback 
,replace(replace(t1.hb_confirmation_feedback,chr(13),''),chr(10),'') as hb_confirmation_feedback 
,replace(replace(t1.is_count,chr(13),''),chr(10),'') as is_count 
,t1.mmd_id as mmd_id 
,t1.executive_organ_id as executive_organ_id 
,replace(replace(t1.rdata_level,chr(13),''),chr(10),'') as rdata_level 
,t1.task_id as task_id 
,replace(replace(t1.rdata_status,chr(13),''),chr(10),'') as rdata_status 
,t1.problem_id as problem_id 
,t1.flow_up_status as flow_up_status 
,t1.risk_level as risk_level 
,t1.approve_status as approve_status 
,t1.reportto_node_id as reportto_node_id 
,replace(replace(t1.business_date,chr(13),''),chr(10),'') as business_date 
,replace(replace(t1.templatetype_id,chr(13),''),chr(10),'') as templatetype_id 
,replace(replace(t1.sb_status_feedback,chr(13),''),chr(10),'') as sb_status_feedback 
,replace(replace(t1.bb_status_feedback,chr(13),''),chr(10),'') as bb_status_feedback 
,replace(replace(t1.hb_status_feedback,chr(13),''),chr(10),'') as hb_status_feedback 
,t1.is_overdue as is_overdue 
,t1.upgrade_date as upgrade_date 
,t1.approve_days as approve_days 
,t1.flow_up_id as flow_up_id 
,t1.approve_date as approve_date 
,t1.is_manualup as is_manualup 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.orws_t_report_data t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_t_report_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes