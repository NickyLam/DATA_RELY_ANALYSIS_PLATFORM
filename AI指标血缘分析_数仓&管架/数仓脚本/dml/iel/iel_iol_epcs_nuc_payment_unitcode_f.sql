: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_epcs_nuc_payment_unitcode_f
CreateDate: 20180529
FileName:   ${iel_data_path}/epcs_nuc_payment_unitcode.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.unit_code,chr(13),''),chr(10),'') as unit_code
,replace(replace(t.unit_name,chr(13),''),chr(10),'') as unit_name
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,replace(replace(t.crypt_key_seq_no,chr(13),''),chr(10),'') as crypt_key_seq_no
,replace(replace(t.sign_sn_seq_no,chr(13),''),chr(10),'') as sign_sn_seq_no
,replace(replace(t.acct_code,chr(13),''),chr(10),'') as acct_code
,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t.unit_short_name,chr(13),''),chr(10),'') as unit_short_name
,replace(replace(t.custom_sign_type,chr(13),''),chr(10),'') as custom_sign_type
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.epcs_nuc_payment_unitcode t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/epcs_nuc_payment_unitcode.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes