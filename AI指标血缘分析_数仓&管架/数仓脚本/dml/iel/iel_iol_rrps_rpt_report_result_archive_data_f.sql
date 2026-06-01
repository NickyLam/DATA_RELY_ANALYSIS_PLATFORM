: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rrps_rpt_report_result_archive_data_f
CreateDate: 20240909
FileName:   ${iel_data_path}/rrps_rpt_report_result_archive_data.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.archive_type,chr(13),''),chr(10),'') as archive_type
,replace(replace(t1.index_no,chr(13),''),chr(10),'') as index_no
,replace(replace(t1.data_date,chr(13),''),chr(10),'') as data_date
,replace(replace(t1.org_no,chr(13),''),chr(10),'') as org_no
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,index_val
,replace(replace(t1.template_id,chr(13),''),chr(10),'') as template_id
,replace(replace(t1.sys_time,chr(13),''),chr(10),'') as sys_time
,replace(replace(t1.sys_ind,chr(13),''),chr(10),'') as sys_ind

from ${iol_schema}.rrps_rpt_report_result_archive_data t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rrps_rpt_report_result_archive_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
