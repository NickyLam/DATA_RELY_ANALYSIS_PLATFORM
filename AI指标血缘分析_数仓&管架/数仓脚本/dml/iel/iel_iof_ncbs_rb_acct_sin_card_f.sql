: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_acct_sin_card_f
CreateDate: 20260306
FileName:   ${iel_data_path}/ncbs_rb_acct_sin_card.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,internal_key
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.make_card_type,chr(13),''),chr(10),'') as make_card_type
,last_tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.med_ins_card_no,chr(13),''),chr(10),'') as med_ins_card_no
,replace(replace(t1.related_acct_type,chr(13),''),chr(10),'') as related_acct_type
,replace(replace(t1.sin_card_no,chr(13),''),chr(10),'') as sin_card_no

from ${iol_schema}.ncbs_rb_acct_sin_card t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_acct_sin_card.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
