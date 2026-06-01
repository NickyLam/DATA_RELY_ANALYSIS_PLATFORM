: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_new_old_seq_no_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_new_old_seq_no.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.internal_key as internal_key
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_seq_no_o,chr(13),''),chr(10),'') as acct_seq_no_o
from ${iol_schema}.ncbs_new_old_seq_no t1
where 1=1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_new_old_seq_no.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes