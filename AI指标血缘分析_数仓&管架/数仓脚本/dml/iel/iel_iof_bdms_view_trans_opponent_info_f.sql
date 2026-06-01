: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_bdms_view_trans_opponent_info_f
CreateDate: 20240131
FileName:   ${iel_data_path}/bdms_view_trans_opponent_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.bsnssq,chr(13),''),chr(10),'') as bsnssq
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t1.serino,chr(13),''),chr(10),'') as serino
,replace(replace(t1.cust_acct,chr(13),''),chr(10),'') as cust_acct
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_bank_no,chr(13),''),chr(10),'') as cust_bank_no
,replace(replace(t1.cust_bank_name,chr(13),''),chr(10),'') as cust_bank_name
,replace(replace(t1.province_no,chr(13),''),chr(10),'') as province_no
,replace(replace(t1.province_name,chr(13),''),chr(10),'') as province_name
,replace(replace(t1.cert_id,chr(13),''),chr(10),'') as cert_id
,replace(replace(t1.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t1.social_credit_no,chr(13),''),chr(10),'') as social_credit_no
,replace(replace(t1.txn_bank_type,chr(13),''),chr(10),'') as txn_bank_type

from ${iol_schema}.bdms_view_trans_opponent_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_view_trans_opponent_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
