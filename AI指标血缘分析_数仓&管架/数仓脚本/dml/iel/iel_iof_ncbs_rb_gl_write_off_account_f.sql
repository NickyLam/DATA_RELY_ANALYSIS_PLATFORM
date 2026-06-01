: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_gl_write_off_account_f
CreateDate: 20230509
FileName:   ${iel_data_path}/ncbs_rb_gl_write_off_account.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.tran_type,chr(13),''),chr(10),'') as tran_type
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.narrative,chr(13),''),chr(10),'') as narrative
,replace(replace(t1.write_off_seq_no,chr(13),''),chr(10),'') as write_off_seq_no
,replace(replace(t1.write_off_status,chr(13),''),chr(10),'') as write_off_status
,tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,hang_bal
,replace(replace(t1.oth_acct_name,chr(13),''),chr(10),'') as oth_acct_name
,replace(replace(t1.oth_base_acct_no,chr(13),''),chr(10),'') as oth_base_acct_no
,replace(replace(t1.oth_branch,chr(13),''),chr(10),'') as oth_branch
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,write_off_amt
,replace(replace(t1.hang_seq_no,chr(13),''),chr(10),'') as hang_seq_no
,replace(replace(t1.hang_deal_type,chr(13),''),chr(10),'') as hang_deal_type
,replace(replace(t1.sub_hang_seq_no,chr(13),''),chr(10),'') as sub_hang_seq_no
,replace(replace(t1.hang_write_off_time,chr(13),''),chr(10),'') as hang_write_off_time

from ${iol_schema}.ncbs_rb_gl_write_off_account t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_gl_write_off_account.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
