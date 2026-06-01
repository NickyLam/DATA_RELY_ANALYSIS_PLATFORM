: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_acct_up_down_info_f
CreateDate: 20241031
FileName:   ${iel_data_path}/ncbs_rb_acct_up_down_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,internal_key
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.acct_class,chr(13),''),chr(10),'') as acct_class
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.old_acct_class,chr(13),''),chr(10),'') as old_acct_class
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.up_down_type,chr(13),''),chr(10),'') as up_down_type
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,tran_date
,replace(replace(t1.channel_seq_no,chr(13),''),chr(10),'') as channel_seq_no

from ${iol_schema}.ncbs_rb_acct_up_down_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_acct_up_down_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
