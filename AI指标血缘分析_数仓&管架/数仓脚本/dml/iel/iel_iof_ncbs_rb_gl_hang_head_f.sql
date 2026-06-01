: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_gl_hang_head_f
CreateDate: 20231115
FileName:   ${iel_data_path}/ncbs_rb_gl_hang_head.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
t1.start_dt as etl_dt
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.hang_seq_no,chr(13),''),chr(10),'') as hang_seq_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,tran_date
,hang_total_amt
,hang_bal
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.hang_status,chr(13),''),chr(10),'') as hang_status
,hang_end_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.company,chr(13),''),chr(10),'') as company

from ${iol_schema}.ncbs_rb_gl_hang_head t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_gl_hang_head.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
