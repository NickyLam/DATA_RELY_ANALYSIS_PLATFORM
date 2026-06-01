: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_open_close_reg_f
CreateDate: 20250506
FileName:   ${iel_data_path}/ncbs_rb_open_close_reg.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.acct_status,chr(13),''),chr(10),'') as acct_status
,replace(replace(t1.acct_type,chr(13),''),chr(10),'') as acct_type
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.document_id,chr(13),''),chr(10),'') as document_id
,internal_key
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.reason_code,chr(13),''),chr(10),'') as reason_code
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.acct_nature,chr(13),''),chr(10),'') as acct_nature
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.inform_bank_flag,chr(13),''),chr(10),'') as inform_bank_flag
,replace(replace(t1.is_self,chr(13),''),chr(10),'') as is_self
,replace(replace(t1.narrative,chr(13),''),chr(10),'') as narrative
,replace(replace(t1.op_method,chr(13),''),chr(10),'') as op_method
,replace(replace(t1.reason_code_desc,chr(13),''),chr(10),'') as reason_code_desc
,replace(replace(t1.reg_type,chr(13),''),chr(10),'') as reg_type
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.suc_flag,chr(13),''),chr(10),'') as suc_flag
,active_date
,tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.acct_branch,chr(13),''),chr(10),'') as acct_branch
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.open_branch,chr(13),''),chr(10),'') as open_branch
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.approval_no,chr(13),''),chr(10),'') as approval_no
,replace(replace(t1.narrative_code,chr(13),''),chr(10),'') as narrative_code

from ${iol_schema}.ncbs_rb_open_close_reg t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_open_close_reg.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
