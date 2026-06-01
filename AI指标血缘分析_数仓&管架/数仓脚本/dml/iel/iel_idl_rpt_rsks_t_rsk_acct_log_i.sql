: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_rsks_t_rsk_acct_log_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_rsks_t_rsk_acct_log.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.seq_id,chr(13),''),chr(10),'') as seq_id
,replace(replace(t1.endpoint,chr(13),''),chr(10),'') as endpoint
,replace(replace(t1.channel_code,chr(13),''),chr(10),'') as channel_code
,replace(replace(t1.trans_type,chr(13),''),chr(10),'') as trans_type
,t1.regist_time as regist_time
,replace(replace(t1.cred_type,chr(13),''),chr(10),'') as cred_type
,replace(replace(t1.cred_no,chr(13),''),chr(10),'') as cred_no
,t1.cred_period as cred_period
,replace(replace(t1.cred_expire,chr(13),''),chr(10),'') as cred_expire
,replace(replace(t1.birth_date,chr(13),''),chr(10),'') as birth_date
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.auth_address_code,chr(13),''),chr(10),'') as auth_address_code
,replace(replace(t1.cellphone,chr(13),''),chr(10),'') as cellphone
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.profession,chr(13),''),chr(10),'') as profession
,replace(replace(t1.contact_address,chr(13),''),chr(10),'') as contact_address
,replace(replace(t1.tax_flag,chr(13),''),chr(10),'') as tax_flag
,replace(replace(t1.tax_statement_flag,chr(13),''),chr(10),'') as tax_statement_flag
,replace(replace(t1.eacct_no,chr(13),''),chr(10),'') as eacct_no
,replace(replace(t1.quick_flag,chr(13),''),chr(10),'') as quick_flag
,replace(replace(t1.cust_flag,chr(13),''),chr(10),'') as cust_flag
,replace(replace(t1.ebank_flag,chr(13),''),chr(10),'') as ebank_flag
,replace(replace(t1.eacct_flag,chr(13),''),chr(10),'') as eacct_flag
,replace(replace(t1.acct_flag,chr(13),''),chr(10),'') as acct_flag
,replace(replace(t1.acct_no,chr(13),''),chr(10),'') as acct_no
,replace(replace(t1.acct_bank_flag,chr(13),''),chr(10),'') as acct_bank_flag
,replace(replace(t1.acct_bank_no,chr(13),''),chr(10),'') as acct_bank_no
,replace(replace(t1.open_branch,chr(13),''),chr(10),'') as open_branch
,replace(replace(t1.merchant_id,chr(13),''),chr(10),'') as merchant_id
,replace(replace(t1.net_verify_flag,chr(13),''),chr(10),'') as net_verify_flag
,replace(replace(t1.four_verify_flag,chr(13),''),chr(10),'') as four_verify_flag
,replace(replace(t1.five_verify_flag,chr(13),''),chr(10),'') as five_verify_flag
,replace(replace(t1.tran_verify_flag,chr(13),''),chr(10),'') as tran_verify_flag
,replace(replace(t1.ocr_verify_flag,chr(13),''),chr(10),'') as ocr_verify_flag
,replace(replace(t1.face_verify_flag,chr(13),''),chr(10),'') as face_verify_flag
,replace(replace(t1.batch_flag,chr(13),''),chr(10),'') as batch_flag
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.client_ip,chr(13),''),chr(10),'') as client_ip
,replace(replace(t1.client_mac,chr(13),''),chr(10),'') as client_mac
,replace(replace(t1.gps_info,chr(13),''),chr(10),'') as gps_info
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.response_code,chr(13),''),chr(10),'') as response_code
,replace(replace(t1.response_desc,chr(13),''),chr(10),'') as response_desc
,t1.score as score
,replace(replace(t1.result,chr(13),''),chr(10),'') as result
,replace(replace(t1.gps_info_la,chr(13),''),chr(10),'') as gps_info_la
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.outrule_flag,chr(13),''),chr(10),'') as outrule_flag
 from iol.rsks_t_rsk_acct_log T1
where to_char(regist_time,'yyyymmdd')=${batch_date};" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_rsks_t_rsk_acct_log.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes