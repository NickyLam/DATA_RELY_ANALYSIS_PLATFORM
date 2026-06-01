: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsks_t_rsk_acct_log_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rsks_t_rsk_acct_log.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.seq_id,chr(13),''),chr(10),'') as seq_id
,replace(replace(t.endpoint,chr(13),''),chr(10),'') as endpoint
,replace(replace(t.channel_code,chr(13),''),chr(10),'') as channel_code
,replace(replace(t.trans_type,chr(13),''),chr(10),'') as trans_type
,t.regist_time as regist_time
,replace(replace(t.cred_type,chr(13),''),chr(10),'') as cred_type
,replace(replace(t.cred_no,chr(13),''),chr(10),'') as cred_no
,t.cred_period as cred_period
,replace(replace(t.cred_expire,chr(13),''),chr(10),'') as cred_expire
,replace(replace(t.birth_date,chr(13),''),chr(10),'') as birth_date
,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t.auth_address_code,chr(13),''),chr(10),'') as auth_address_code
,replace(replace(t.cellphone,chr(13),''),chr(10),'') as cellphone
,replace(replace(t.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t.profession,chr(13),''),chr(10),'') as profession
,replace(replace(t.contact_address,chr(13),''),chr(10),'') as contact_address
,replace(replace(t.tax_flag,chr(13),''),chr(10),'') as tax_flag
,replace(replace(t.tax_statement_flag,chr(13),''),chr(10),'') as tax_statement_flag
,replace(replace(t.eacct_no,chr(13),''),chr(10),'') as eacct_no
,replace(replace(t.quick_flag,chr(13),''),chr(10),'') as quick_flag
,replace(replace(t.cust_flag,chr(13),''),chr(10),'') as cust_flag
,replace(replace(t.ebank_flag,chr(13),''),chr(10),'') as ebank_flag
,replace(replace(t.eacct_flag,chr(13),''),chr(10),'') as eacct_flag
,replace(replace(t.acct_flag,chr(13),''),chr(10),'') as acct_flag
,replace(replace(t.acct_no,chr(13),''),chr(10),'') as acct_no
,replace(replace(t.acct_bank_flag,chr(13),''),chr(10),'') as acct_bank_flag
,replace(replace(t.acct_bank_no,chr(13),''),chr(10),'') as acct_bank_no
,replace(replace(t.open_branch,chr(13),''),chr(10),'') as open_branch
,replace(replace(t.merchant_id,chr(13),''),chr(10),'') as merchant_id
,replace(replace(t.net_verify_flag,chr(13),''),chr(10),'') as net_verify_flag
,replace(replace(t.four_verify_flag,chr(13),''),chr(10),'') as four_verify_flag
,replace(replace(t.five_verify_flag,chr(13),''),chr(10),'') as five_verify_flag
,replace(replace(t.tran_verify_flag,chr(13),''),chr(10),'') as tran_verify_flag
,replace(replace(t.ocr_verify_flag,chr(13),''),chr(10),'') as ocr_verify_flag
,replace(replace(t.face_verify_flag,chr(13),''),chr(10),'') as face_verify_flag
,replace(replace(t.batch_flag,chr(13),''),chr(10),'') as batch_flag
,replace(replace(t.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t.client_ip,chr(13),''),chr(10),'') as client_ip
,replace(replace(t.client_mac,chr(13),''),chr(10),'') as client_mac
,replace(replace(t.gps_info,chr(13),''),chr(10),'') as gps_info
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.response_code,chr(13),''),chr(10),'') as response_code
,replace(replace(t.response_desc,chr(13),''),chr(10),'') as response_desc
,t.score as score
,replace(replace(t.result,chr(13),''),chr(10),'') as result
,replace(replace(t.gps_info_la,chr(13),''),chr(10),'') as gps_info_la
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.outrule_flag,chr(13),''),chr(10),'') as outrule_flag
,replace(replace(t.full_device_no,chr(13),''),chr(10),'') as full_device_no
,replace(replace(t.app_name,chr(13),''),chr(10),'') as app_name
,replace(replace(t.device_type,chr(13),''),chr(10),'') as device_type
,replace(replace(t.ip_type,chr(13),''),chr(10),'') as ip_type
from ${iol_schema}.rsks_t_rsk_acct_log t 
where to_char(t.regist_time,'YYYYMMDD')='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsks_t_rsk_acct_log.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes