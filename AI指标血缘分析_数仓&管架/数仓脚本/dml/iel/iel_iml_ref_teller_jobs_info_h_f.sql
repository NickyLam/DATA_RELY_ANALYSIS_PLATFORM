: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_teller_jobs_info_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/ref_teller_jobs_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(jobs_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(jobs_name,chr(13),''),chr(10),'')
,replace(replace(jobs_type_cd,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.ref_teller_jobs_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_teller_jobs_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
