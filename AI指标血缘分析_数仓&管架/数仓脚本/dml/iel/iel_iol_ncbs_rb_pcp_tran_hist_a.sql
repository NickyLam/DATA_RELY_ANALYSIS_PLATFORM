: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_pcp_tran_hist_a
CreateDate: 20251111
FileName:   ${iel_data_path}/ncbs_rb_pcp_tran_hist.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt as etl_dt
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,internal_key
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.tran_type,chr(13),''),chr(10),'') as tran_type
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.channel_seq_no,chr(13),''),chr(10),'') as channel_seq_no
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.cr_dr_ind,chr(13),''),chr(10),'') as cr_dr_ind
,replace(replace(t1.event_type,chr(13),''),chr(10),'') as event_type
,replace(replace(t1.oth_seq_no,chr(13),''),chr(10),'') as oth_seq_no
,replace(replace(t1.pcp_group_id,chr(13),''),chr(10),'') as pcp_group_id
,replace(replace(t1.reversal_flag,chr(13),''),chr(10),'') as reversal_flag
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.source_module,chr(13),''),chr(10),'') as source_module
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,replace(replace(t1.tran_desc,chr(13),''),chr(10),'') as tran_desc
,replace(replace(t1.tran_status,chr(13),''),chr(10),'') as tran_status
,tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,replace(replace(t1.failure_reason,chr(13),''),chr(10),'') as failure_reason
,replace(replace(t1.oth_acct_ccy,chr(13),''),chr(10),'') as oth_acct_ccy
,replace(replace(t1.oth_acct_seq_no,chr(13),''),chr(10),'') as oth_acct_seq_no
,replace(replace(t1.oth_base_acct_no,chr(13),''),chr(10),'') as oth_base_acct_no
,oth_internal_key
,replace(replace(t1.oth_prod_type,chr(13),''),chr(10),'') as oth_prod_type
,replace(replace(t1.pcp_prod_type,chr(13),''),chr(10),'') as pcp_prod_type
,tran_amt
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.narrative,chr(13),''),chr(10),'') as narrative
,replace(replace(t1.narrative_code,chr(13),''),chr(10),'') as narrative_code

from ${iol_schema}.ncbs_rb_pcp_tran_hist t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_pcp_tran_hist.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
