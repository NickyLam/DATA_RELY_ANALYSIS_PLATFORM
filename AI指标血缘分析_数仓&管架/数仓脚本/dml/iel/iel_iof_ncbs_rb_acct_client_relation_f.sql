: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_acct_client_relation_f
CreateDate: 20230131
FileName:   ${iel_data_path}/ncbs_rb_acct_client_relation.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.acct_status,chr(13),''),chr(10),'') as acct_status
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.client_type,chr(13),''),chr(10),'') as client_type
,replace(replace(t1.document_id,chr(13),''),chr(10),'') as document_id
,replace(replace(t1.document_type,chr(13),''),chr(10),'') as document_type
,internal_key
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.reason_code,chr(13),''),chr(10),'') as reason_code
,replace(replace(t1.acct_class,chr(13),''),chr(10),'') as acct_class
,replace(replace(t1.acct_nature,chr(13),''),chr(10),'') as acct_nature
,replace(replace(t1.acct_real_flag,chr(13),''),chr(10),'') as acct_real_flag
,replace(replace(t1.app_flag,chr(13),''),chr(10),'') as app_flag
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.default_settle_acct,chr(13),''),chr(10),'') as default_settle_acct
,replace(replace(t1.individual_flag,chr(13),''),chr(10),'') as individual_flag
,replace(replace(t1.is_card,chr(13),''),chr(10),'') as is_card
,replace(replace(t1.is_corp_settle_card,chr(13),''),chr(10),'') as is_corp_settle_card
,replace(replace(t1.lead_acct_flag,chr(13),''),chr(10),'') as lead_acct_flag
,replace(replace(t1.reason_code_desc,chr(13),''),chr(10),'') as reason_code_desc
,replace(replace(t1.shard_id,chr(13),''),chr(10),'') as shard_id
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.acct_branch,chr(13),''),chr(10),'') as acct_branch
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.actual_acct_no,chr(13),''),chr(10),'') as actual_acct_no
,parent_internal_key
,start_dt
,end_dt

from ${iol_schema}.ncbs_rb_acct_client_relation t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_acct_client_relation.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
