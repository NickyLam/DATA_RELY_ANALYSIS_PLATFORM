: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_base_acct_f
CreateDate: 20231024
FileName:   ${iel_data_path}/ncbs_rb_base_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.acct_status,chr(13),''),chr(10),'') as acct_status
,replace(replace(t1.acct_type,chr(13),''),chr(10),'') as acct_type
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.client_type,chr(13),''),chr(10),'') as client_type
,replace(replace(t1.doc_type,chr(13),''),chr(10),'') as doc_type
,replace(replace(t1.document_id,chr(13),''),chr(10),'') as document_id
,replace(replace(t1.document_type,chr(13),''),chr(10),'') as document_type
,internal_key
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.voucher_status,chr(13),''),chr(10),'') as voucher_status
,replace(replace(t1.acct_desc,chr(13),''),chr(10),'') as acct_desc
,replace(replace(t1.acct_exec,chr(13),''),chr(10),'') as acct_exec
,replace(replace(t1.acct_res_status,chr(13),''),chr(10),'') as acct_res_status
,replace(replace(t1.acct_status_prev,chr(13),''),chr(10),'') as acct_status_prev
,replace(replace(t1.all_dep_ind,chr(13),''),chr(10),'') as all_dep_ind
,replace(replace(t1.all_dra_ind,chr(13),''),chr(10),'') as all_dra_ind
,replace(replace(t1.checked_flag,chr(13),''),chr(10),'') as checked_flag
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.prefix,chr(13),''),chr(10),'') as prefix
,replace(replace(t1.source_module,chr(13),''),chr(10),'') as source_module
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,replace(replace(t1.terminal_id,chr(13),''),chr(10),'') as terminal_id
,replace(replace(t1.fixed_call,chr(13),''),chr(10),'') as fixed_call
,acct_open_date
,acct_status_upd_date
,last_change_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.iss_country,chr(13),''),chr(10),'') as iss_country
,replace(replace(t1.acct_branch,chr(13),''),chr(10),'') as acct_branch
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.acct_close_reason,chr(13),''),chr(10),'') as acct_close_reason
,replace(replace(t1.acct_close_user_id,chr(13),''),chr(10),'') as acct_close_user_id
,replace(replace(t1.alt_acct_name,chr(13),''),chr(10),'') as alt_acct_name
,replace(replace(t1.last_change_user_id,chr(13),''),chr(10),'') as last_change_user_id
,replace(replace(t1.old_prod_type,chr(13),''),chr(10),'') as old_prod_type
,replace(replace(t1.voucher_start_no,chr(13),''),chr(10),'') as voucher_start_no

from ${iol_schema}.ncbs_rb_base_acct t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_base_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
