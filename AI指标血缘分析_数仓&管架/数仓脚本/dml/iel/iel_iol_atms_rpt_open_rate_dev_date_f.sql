: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_atms_rpt_open_rate_dev_date_f
CreateDate: 20240703
FileName:   ${iel_data_path}/atms_rpt_open_rate_dev_date.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.dev_no,chr(13),''),chr(10),'') as dev_no
,replace(replace(t1.date_time,chr(13),''),chr(10),'') as date_time
,replace(replace(t1.open_rate_year,chr(13),''),chr(10),'') as open_rate_year
,replace(replace(t1.open_rate_month,chr(13),''),chr(10),'') as open_rate_month
,replace(replace(t1.open_rate_day,chr(13),''),chr(10),'') as open_rate_day
,full_fun_time
,full_rate
,half_fun_time
,half_rate
,hard_fault_time
,soft_fault_time
,maintenance_time
,comm_failure_time
,close_time
,other_reason_time
,work_time
,perfect_rate
,service_rate
,comm_rate
,stop_time
,vcomm_failure_time
,suspected_crash_time
,replace(replace(t1.is_from_dev,chr(13),''),chr(10),'') as is_from_dev
,short_paper_time
,cash_gate_time
,movement_fail_time

from ${iol_schema}.atms_rpt_open_rate_dev_date t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/atms_rpt_open_rate_dev_date.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
