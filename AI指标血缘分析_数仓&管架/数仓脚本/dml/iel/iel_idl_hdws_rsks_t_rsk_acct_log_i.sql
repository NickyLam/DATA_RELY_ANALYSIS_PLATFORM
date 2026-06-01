: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_rsks_t_rsk_acct_log_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_rsks_t_rsk_acct_log.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.seq_id
,t1.endpoint
,t1.channel_code
,t1.trans_type
,t1.regist_time
,t1.cred_type
,t1.cred_no
,t1.cred_period
,t1.cred_expire
,t1.birth_date
,t1.cust_no
,t1.auth_address_code
,t1.cellphone
,t1.sex
,t1.profession
,t1.contact_address
,t1.tax_flag
,t1.tax_statement_flag
,t1.eacct_no
,t1.quick_flag
,t1.cust_flag
,t1.ebank_flag
,t1.eacct_flag
,t1.acct_flag
,t1.acct_no
,t1.acct_bank_flag
,t1.acct_bank_no
,t1.open_branch
,t1.merchant_id
,t1.net_verify_flag
,t1.four_verify_flag
,t1.five_verify_flag
,t1.tran_verify_flag
,t1.ocr_verify_flag
,t1.face_verify_flag
,t1.batch_flag
,t1.client_no
,t1.client_ip
,t1.client_mac
,t1.gps_info
,t1.status
,t1.response_code
,t1.response_desc
,t1.score
,t1.result
,t1.gps_info_la
,t1.cust_name
,t1.outrule_flag
,t1.full_device_no
,t1.app_name
,t1.device_type
,t1.ip_type
from ${idl_schema}.hdws_rsks_t_rsk_acct_log t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_rsks_t_rsk_acct_log.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes