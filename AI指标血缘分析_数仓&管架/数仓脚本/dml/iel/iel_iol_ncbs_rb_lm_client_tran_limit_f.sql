: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_lm_client_tran_limit_f
CreateDate: 20240328
FileName:   ${iel_data_path}/ncbs_rb_lm_client_tran_limit.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.limit_ref,chr(13),''),chr(10),'') as limit_ref
,limit_max_amt
,limit_min_amt
,limit_max_num
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.limit_main_type,chr(13),''),chr(10),'') as limit_main_type

from ${iol_schema}.ncbs_rb_lm_client_tran_limit t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_lm_client_tran_limit.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
