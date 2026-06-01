: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_acct_settle_hist_f
CreateDate: 20241230
FileName:   ${iel_data_path}/ncbs_rb_acct_settle_hist.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,internal_key
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.acct_settle_operate_type,chr(13),''),chr(10),'') as acct_settle_operate_type
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.settle_acct_class,chr(13),''),chr(10),'') as settle_acct_class
,replace(replace(t1.settle_bank_flag,chr(13),''),chr(10),'') as settle_bank_flag
,replace(replace(t1.settle_mobile_phone,chr(13),''),chr(10),'') as settle_mobile_phone
,replace(replace(t1.settle_no,chr(13),''),chr(10),'') as settle_no
,last_charge_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.last_change_user_id,chr(13),''),chr(10),'') as last_change_user_id
,replace(replace(t1.old_settle_base_acct_no,chr(13),''),chr(10),'') as old_settle_base_acct_no
,replace(replace(t1.settle_acct_ccy,chr(13),''),chr(10),'') as settle_acct_ccy
,settle_acct_internal_key
,replace(replace(t1.settle_acct_name,chr(13),''),chr(10),'') as settle_acct_name
,replace(replace(t1.settle_acct_seq_no,chr(13),''),chr(10),'') as settle_acct_seq_no
,replace(replace(t1.settle_base_acct_no,chr(13),''),chr(10),'') as settle_base_acct_no
,replace(replace(t1.settle_branch,chr(13),''),chr(10),'') as settle_branch
,replace(replace(t1.settle_client,chr(13),''),chr(10),'') as settle_client
,replace(replace(t1.settle_prod_type,chr(13),''),chr(10),'') as settle_prod_type
,replace(replace(t1.bind_acct_branch,chr(13),''),chr(10),'') as bind_acct_branch

from ${iol_schema}.ncbs_rb_acct_settle_hist t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_acct_settle_hist.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
