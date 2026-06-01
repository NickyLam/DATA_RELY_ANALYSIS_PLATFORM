: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_voucher_acct_relation_hist_f
CreateDate: 20230302
FileName:   ${iel_data_path}/ncbs_rb_voucher_acct_relation_hist.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.doc_type,chr(13),''),chr(10),'') as doc_type
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.voucher_no,chr(13),''),chr(10),'') as voucher_no
,replace(replace(t1.voucher_status,chr(13),''),chr(10),'') as voucher_status
,replace(replace(t1.collat_no,chr(13),''),chr(10),'') as collat_no
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.doc_class,chr(13),''),chr(10),'') as doc_class
,replace(replace(t1.narrative,chr(13),''),chr(10),'') as narrative
,replace(replace(t1.old_status,chr(13),''),chr(10),'') as old_status
,replace(replace(t1.prefix,chr(13),''),chr(10),'') as prefix
,tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.open_branch,chr(13),''),chr(10),'') as open_branch
,replace(replace(t1.can_reason_code,chr(13),''),chr(10),'') as can_reason_code

from ${iol_schema}.ncbs_rb_voucher_acct_relation_hist t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_voucher_acct_relation_hist.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
