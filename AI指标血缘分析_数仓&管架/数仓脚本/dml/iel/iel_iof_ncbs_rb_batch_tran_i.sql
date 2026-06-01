: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_batch_tran_i
CreateDate: 20230602
FileName:   ${iel_data_path}/ncbs_rb_batch_tran.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.file_name,chr(13),''),chr(10),'') as file_name
,replace(replace(t1.file_path,chr(13),''),chr(10),'') as file_path
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.appr_flag,chr(13),''),chr(10),'') as appr_flag
,replace(replace(t1.auth_flag,chr(13),''),chr(10),'') as auth_flag
,replace(replace(t1.batch_class,chr(13),''),chr(10),'') as batch_class
,replace(replace(t1.batch_desc,chr(13),''),chr(10),'') as batch_desc
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.batch_status,chr(13),''),chr(10),'') as batch_status
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.error_desc,chr(13),''),chr(10),'') as error_desc
,failure_number
,replace(replace(t1.mac_value,chr(13),''),chr(10),'') as mac_value
,replace(replace(t1.narrative,chr(13),''),chr(10),'') as narrative
,replace(replace(t1.program_id,chr(13),''),chr(10),'') as program_id
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.source_branch_no,chr(13),''),chr(10),'') as source_branch_no
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,succ_num
,replace(replace(t1.system_id,chr(13),''),chr(10),'') as system_id
,replace(replace(t1.thread_no,chr(13),''),chr(10),'') as thread_no
,total_num
,replace(replace(t1.tran_mode,chr(13),''),chr(10),'') as tran_mode
,replace(replace(t1.user_lang,chr(13),''),chr(10),'') as user_lang
,replace(replace(t1.begin_time,chr(13),''),chr(10),'') as begin_time
,deal_date
,expire_date
,run_date
,tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.appr_user_id,chr(13),''),chr(10),'') as appr_user_id
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,replace(replace(t1.dest_branch_no,chr(13),''),chr(10),'') as dest_branch_no
,total_amt
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.approval_no,chr(13),''),chr(10),'') as approval_no

from ${iol_schema}.ncbs_rb_batch_tran t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_batch_tran.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
