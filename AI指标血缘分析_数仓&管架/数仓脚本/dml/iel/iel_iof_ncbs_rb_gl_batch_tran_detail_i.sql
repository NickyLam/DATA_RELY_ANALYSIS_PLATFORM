: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_gl_batch_tran_detail_i
CreateDate: 20230602
FileName:   ${iel_data_path}/ncbs_rb_gl_batch_tran_detail.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.gl_code,chr(13),''),chr(10),'') as gl_code
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.bal_upd_type,chr(13),''),chr(10),'') as bal_upd_type
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.batch_status,chr(13),''),chr(10),'') as batch_status
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.error_code,chr(13),''),chr(10),'') as error_code
,replace(replace(t1.error_desc,chr(13),''),chr(10),'') as error_desc
,replace(replace(t1.hang_write_off_flag,chr(13),''),chr(10),'') as hang_write_off_flag
,replace(replace(t1.job_run_id,chr(13),''),chr(10),'') as job_run_id
,replace(replace(t1.od_facility,chr(13),''),chr(10),'') as od_facility
,replace(replace(t1.prod_desc,chr(13),''),chr(10),'') as prod_desc
,replace(replace(t1.ret_msg,chr(13),''),chr(10),'') as ret_msg
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.subject_desc,chr(13),''),chr(10),'') as subject_desc
,acct_open_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.acct_branch,chr(13),''),chr(10),'') as acct_branch
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.hang_term,chr(13),''),chr(10),'') as hang_term
,link_value
,replace(replace(t1.counter_dep_flag,chr(13),''),chr(10),'') as counter_dep_flag
,replace(replace(t1.counter_debt_flag,chr(13),''),chr(10),'') as counter_debt_flag

from ${iol_schema}.ncbs_rb_gl_batch_tran_detail t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_gl_batch_tran_detail.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
