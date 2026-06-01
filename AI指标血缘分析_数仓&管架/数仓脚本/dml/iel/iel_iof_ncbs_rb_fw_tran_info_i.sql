: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_fw_tran_info_i
CreateDate: 20241230
FileName:   ${iel_data_path}/ncbs_rb_fw_tran_info.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.service_id,chr(13),''),chr(10),'') as service_id
,replace(replace(t1.service_no,chr(13),''),chr(10),'') as service_no
,replace(replace(t1.tran_date,chr(13),''),chr(10),'') as tran_date
,replace(replace(t1.tran_time,chr(13),''),chr(10),'') as tran_time
,replace(replace(t1.response_type,chr(13),''),chr(10),'') as response_type
,replace(replace(t1.end_time,chr(13),''),chr(10),'') as end_time
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.program_id,chr(13),''),chr(10),'') as program_id
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.platform_id,chr(13),''),chr(10),'') as platform_id
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.ip_address,chr(13),''),chr(10),'') as ip_address
,replace(replace(t1.branch_id,chr(13),''),chr(10),'') as branch_id
,replace(replace(t1.compensate_service_no,chr(13),''),chr(10),'') as compensate_service_no
,week_day
,create_date
,replace(replace(t1.bus_seq_no,chr(13),''),chr(10),'') as bus_seq_no
,run_date
,replace(replace(t1.inner_service_flag,chr(13),''),chr(10),'') as inner_service_flag
,replace(replace(t1.gl_posted_flag,chr(13),''),chr(10),'') as gl_posted_flag
,replace(replace(t1.acct_no,chr(13),''),chr(10),'') as acct_no
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,tran_amt
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,replace(replace(t1.oth_acct_no,chr(13),''),chr(10),'') as oth_acct_no
,replace(replace(t1.oth_acct_seq_no,chr(13),''),chr(10),'') as oth_acct_seq_no
,replace(replace(t1.voucher_no,chr(13),''),chr(10),'') as voucher_no
,replace(replace(t1.doc_type,chr(13),''),chr(10),'') as doc_type
,replace(replace(t1.prefix,chr(13),''),chr(10),'') as prefix
,replace(replace(t1.cheque_voucher_no,chr(13),''),chr(10),'') as cheque_voucher_no
,replace(replace(t1.cheque_doc_type,chr(13),''),chr(10),'') as cheque_doc_type
,replace(replace(t1.cheque_prefix,chr(13),''),chr(10),'') as cheque_prefix
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.tran_name,chr(13),''),chr(10),'') as tran_name
,replace(replace(t1.inner_flag,chr(13),''),chr(10),'') as inner_flag
,replace(replace(t1.source_model,chr(13),''),chr(10),'') as source_model
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.sub_seq_no,chr(13),''),chr(10),'') as sub_seq_no
,replace(replace(t1.financial_flag,chr(13),''),chr(10),'') as financial_flag

from ${iol_schema}.ncbs_rb_fw_tran_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_fw_tran_info.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
