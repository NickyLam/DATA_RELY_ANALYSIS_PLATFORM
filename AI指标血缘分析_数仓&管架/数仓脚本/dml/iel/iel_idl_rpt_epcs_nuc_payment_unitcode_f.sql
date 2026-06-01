: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_epcs_nuc_payment_unitcode_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_epcs_nuc_payment_unitcode.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.unit_code,chr(13),''),chr(10),'') as unit_code
,replace(replace(t1.unit_name,chr(13),''),chr(10),'') as unit_name
,t1.last_updated_stamp as last_updated_stamp
,t1.last_updated_tx_stamp as last_updated_tx_stamp
,t1.created_stamp as created_stamp
,t1.created_tx_stamp as created_tx_stamp
,replace(replace(t1.crypt_key_seq_no,chr(13),''),chr(10),'') as crypt_key_seq_no
,replace(replace(t1.sign_sn_seq_no,chr(13),''),chr(10),'') as sign_sn_seq_no
,replace(replace(t1.acct_code,chr(13),''),chr(10),'') as acct_code
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.unit_short_name,chr(13),''),chr(10),'') as unit_short_name
,replace(replace(t1.custom_sign_type,chr(13),''),chr(10),'') as custom_sign_type
 from iol.epcs_nuc_payment_unitcode T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_epcs_nuc_payment_unitcode.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes