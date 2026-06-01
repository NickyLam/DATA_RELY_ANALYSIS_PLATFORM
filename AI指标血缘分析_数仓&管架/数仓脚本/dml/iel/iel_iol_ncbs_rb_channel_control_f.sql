: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_channel_control_f
CreateDate: 20240328
FileName:   ${iel_data_path}/ncbs_rb_channel_control.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,internal_key
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.channel_seq_no,chr(13),''),chr(10),'') as channel_seq_no
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.control_type,chr(13),''),chr(10),'') as control_type
,replace(replace(t1.limit_level,chr(13),''),chr(10),'') as limit_level
,replace(replace(t1.narrative,chr(13),''),chr(10),'') as narrative
,replace(replace(t1.program_id,chr(13),''),chr(10),'') as program_id
,replace(replace(t1.res_acct_range,chr(13),''),chr(10),'') as res_acct_range
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,end_date
,last_change_date
,start_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,replace(replace(t1.last_change_user_id,chr(13),''),chr(10),'') as last_change_user_id
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.control_seq_no,chr(13),''),chr(10),'') as control_seq_no
,replace(replace(t1.control_status,chr(13),''),chr(10),'') as control_status
,replace(replace(t1.out_sign_user_id,chr(13),''),chr(10),'') as out_sign_user_id
,replace(replace(t1.unlost_time,chr(13),''),chr(10),'') as unlost_time

from ${iol_schema}.ncbs_rb_channel_control t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_channel_control.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
