: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_epcs_nuc_payment_unitcode_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_epcs_nuc_payment_unitcode.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.unit_code
,t1.unit_name
,t1.last_updated_stamp
,t1.last_updated_tx_stamp
,t1.created_stamp
,t1.created_tx_stamp
,t1.crypt_key_seq_no
,t1.sign_sn_seq_no
,t1.acct_code
,t1.acct_name
,t1.unit_short_name
,t1.custom_sign_type
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_epcs_nuc_payment_unitcode t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_epcs_nuc_payment_unitcode.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes