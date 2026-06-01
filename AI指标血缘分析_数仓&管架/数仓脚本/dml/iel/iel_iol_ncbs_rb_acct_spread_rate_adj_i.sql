: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_acct_spread_rate_adj_i
CreateDate: 20251028
FileName:   ${iel_data_path}/ncbs_rb_acct_spread_rate_adj.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,internal_key
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,before_acct_spread_rate
,after_acct_spread_rate
,before_real_rate
,after_real_rate
,replace(replace(t1.int_class,chr(13),''),chr(10),'') as int_class
,tran_date
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.company,chr(13),''),chr(10),'') as company

from ${iol_schema}.ncbs_rb_acct_spread_rate_adj t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_acct_spread_rate_adj.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
