: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_heps_s_loan_process_f
CreateDate: 20180529
FileName:   ${iel_data_path}/heps_s_loan_process.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.operate_result,chr(13),''),chr(10),'') as operate_result
,replace(replace(t.operator,chr(13),''),chr(10),'') as operator
,t.operate_time as operate_time
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.node_name,chr(13),''),chr(10),'') as node_name
,replace(replace(t.pre_status,chr(13),''),chr(10),'') as pre_status
,replace(replace(t.failure_reason,chr(13),''),chr(10),'') as failure_reason
,replace(replace(t.task_id,chr(13),''),chr(10),'') as task_id
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.operate_trace,chr(13),''),chr(10),'') as operate_trace
from iol.heps_s_loan_process t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/heps_s_loan_process.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes