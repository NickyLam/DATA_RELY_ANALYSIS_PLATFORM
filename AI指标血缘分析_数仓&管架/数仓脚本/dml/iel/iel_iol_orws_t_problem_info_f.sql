: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_t_problem_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_t_problem_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,t1.biztype as biztype 
,replace(replace(t1.node_name,chr(13),''),chr(10),'') as node_name 
,replace(replace(t1.inst_no,chr(13),''),chr(10),'') as inst_no 
,replace(replace(t1.chkdept,chr(13),''),chr(10),'') as chkdept 
,t1.organid as organid 
,t1.task_organ as task_organ 
,t1.bigtype_id as bigtype_id 
,t1.smalltype_id as smalltype_id 
,t1.biz_date as biz_date 
,t1.check_time as check_time 
,replace(replace(t1.chktitle,chr(13),''),chr(10),'') as chktitle 
,t1.chkperson as chkperson 
,t1.problemer as problemer 
,t1.problemstate as problemstate 
,replace(replace(t1.problem_detail_action,chr(13),''),chr(10),'') as problem_detail_action 
,replace(replace(t1.problem_biz_id,chr(13),''),chr(10),'') as problem_biz_id 
,replace(replace(t1.serinum,chr(13),''),chr(10),'') as serinum 
,replace(replace(t1.rectified_serinum,chr(13),''),chr(10),'') as rectified_serinum 
,replace(replace(t1.prbinfo,chr(13),''),chr(10),'') as prbinfo 
,replace(replace(t1.remarks,chr(13),''),chr(10),'') as remarks 
,t1.is_emp_resp as is_emp_resp 
,t1.is_debit_resp as is_debit_resp 
,t1.is_credit_resp as is_credit_resp 
,replace(replace(t1.approve_type,chr(13),''),chr(10),'') as approve_type 
,t1.rectify_deadline as rectify_deadline 
,replace(replace(t1.prb_org_first_desc,chr(13),''),chr(10),'') as prb_org_first_desc 
,replace(replace(t1.pro_idtf,chr(13),''),chr(10),'') as pro_idtf 
,t1.org_res_date as org_res_date 
,replace(replace(t1.confirm_desc,chr(13),''),chr(10),'') as confirm_desc 
,t1.approve_status as approve_status 
,t1.risk_level as risk_level 
,t1.approve_date as approve_date 
,t1.upgrade_date as upgrade_date 
,t1.is_overdue as is_overdue 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.orws_t_problem_info t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_t_problem_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes