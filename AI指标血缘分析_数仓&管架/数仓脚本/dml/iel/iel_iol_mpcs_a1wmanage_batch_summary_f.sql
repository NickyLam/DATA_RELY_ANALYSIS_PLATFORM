: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a1wmanage_batch_summary_f
CreateDate: 20250709
FileName:   ${iel_data_path}/mpcs_a1wmanage_batch_summary.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.branch_no,chr(13),''),chr(10),'') as branch_no
,replace(replace(t1.branch_id,chr(13),''),chr(10),'') as branch_id
,company_count
,employee_count
,total_amount
,batch_count
,replace(replace(t1.create_timestamp,chr(13),''),chr(10),'') as create_timestamp
,replace(replace(t1.update_timestamp,chr(13),''),chr(10),'') as update_timestamp
,replace(replace(t1.redis_update_time,chr(13),''),chr(10),'') as redis_update_time

from ${iol_schema}.mpcs_a1wmanage_batch_summary t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1wmanage_batch_summary.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
