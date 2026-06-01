: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_atms_rpt_date_open_rate_f
CreateDate: 20180529
FileName:   ${iel_data_path}/atms_rpt_date_open_rate.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.logic_id,chr(13),''),chr(10),'') as logic_id
,replace(replace(t1.dev_no,chr(13),''),chr(10),'') as dev_no
,replace(replace(t1.date_time,chr(13),''),chr(10),'') as date_time
,t1.full_fun_time as full_fun_time
,t1.full_rate as full_rate
,t1.half_fun_time as half_fun_time
,t1.half_rate as half_rate
,t1.hard_fault_time as hard_fault_time
,t1.soft_fault_time as soft_fault_time
,t1.maintenance_time as maintenance_time
,t1.comm_failure_time as comm_failure_time
,t1.close_time as close_time
,t1.other_reason_time as other_reason_time
,t1.work_time as work_time
,t1.perfect_rate as perfect_rate
,t1.service_rate as service_rate
,t1.comm_rate as comm_rate
,t1.stop_time as stop_time
,t1.vcomm_failure_time as vcomm_failure_time
,t1.short_paper_time as short_paper_time
,t1.cash_gate_time as cash_gate_time
,t1.movement_fail_time as movement_fail_time
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.atms_rpt_date_open_rate t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/atms_rpt_date_open_rate.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes