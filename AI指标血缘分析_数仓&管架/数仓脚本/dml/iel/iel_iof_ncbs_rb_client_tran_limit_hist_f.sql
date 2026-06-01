: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_client_tran_limit_hist_f
CreateDate: 20231031
FileName:   ${iel_data_path}/ncbs_rb_client_tran_limit_hist.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.limit_level,chr(13),''),chr(10),'') as limit_level
,replace(replace(t1.limit_ref,chr(13),''),chr(10),'') as limit_ref
,replace(replace(t1.limit_type,chr(13),''),chr(10),'') as limit_type
,num
,replace(replace(t1.operate_flag,chr(13),''),chr(10),'') as operate_flag
,tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,limit_max_amt
,limit_min_amt
,max_amt
,min_amt
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.limit_main_type,chr(13),''),chr(10),'') as limit_main_type
,limit_max_num

from ${iol_schema}.ncbs_rb_client_tran_limit_hist t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_client_tran_limit_hist.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
