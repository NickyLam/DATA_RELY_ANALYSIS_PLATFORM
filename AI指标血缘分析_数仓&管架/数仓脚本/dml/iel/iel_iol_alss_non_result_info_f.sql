: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_alss_non_result_info_f
CreateDate: 20250822
FileName:   ${iel_data_path}/alss_non_result_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.deal_date,chr(13),''),chr(10),'') as deal_date
,replace(replace(t1.tran_organ,chr(13),''),chr(10),'') as tran_organ
,replace(replace(t1.jobs_name,chr(13),''),chr(10),'') as jobs_name
,replace(replace(t1.deal_user_no,chr(13),''),chr(10),'') as deal_user_no
,replace(replace(t1.teller_name,chr(13),''),chr(10),'') as teller_name
,replace(replace(t1.deal_user_no1,chr(13),''),chr(10),'') as deal_user_no1
,replace(replace(t1.teller_name1,chr(13),''),chr(10),'') as teller_name1
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_name,chr(13),''),chr(10),'') as tran_name
,t1.tran_start_time as tran_start_time
,t1.tran_end_time as tran_end_time
,replace(replace(t1.glob_seq_num,chr(13),''),chr(10),'') as glob_seq_num
,replace(replace(t1.system_name,chr(13),''),chr(10),'') as system_name

from ${iol_schema}.alss_non_result_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_non_result_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
