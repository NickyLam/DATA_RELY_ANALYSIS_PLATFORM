: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amss_xft_merchant_f
CreateDate: 20251106
FileName:   ${iel_data_path}/amss_xft_merchant.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.merchant_id,chr(13),''),chr(10),'') as merchant_id
,replace(replace(t1.merchant_name,chr(13),''),chr(10),'') as merchant_name
,replace(replace(t1.merchant_short_name,chr(13),''),chr(10),'') as merchant_short_name
,replace(replace(t1.account_code,chr(13),''),chr(10),'') as account_code
,replace(replace(t1.account_name,chr(13),''),chr(10),'') as account_name
,replace(replace(t1.account_bank,chr(13),''),chr(10),'') as account_bank
,replace(replace(t1.account_bank_name,chr(13),''),chr(10),'') as account_bank_name
,account_type
,replace(replace(t1.channel_id,chr(13),''),chr(10),'') as channel_id
,replace(replace(t1.channel_name,chr(13),''),chr(10),'') as channel_name
,examine_status
,check_flag
,merchant_status
,clear_mode
,replace(replace(t1.deposit_account,chr(13),''),chr(10),'') as deposit_account
,replace(replace(t1.deposit_account_name,chr(13),''),chr(10),'') as deposit_account_name
,rate_max
,rate_min
,amt_max
,amt_min
,replace(replace(t1.ftp_host,chr(13),''),chr(10),'') as ftp_host
,replace(replace(t1.ftp_port,chr(13),''),chr(10),'') as ftp_port
,replace(replace(t1.ftp_user,chr(13),''),chr(10),'') as ftp_user
,replace(replace(t1.ftp_password,chr(13),''),chr(10),'') as ftp_password
,replace(replace(t1.ftp_local,chr(13),''),chr(10),'') as ftp_local
,replace(replace(t1.ftp_remote,chr(13),''),chr(10),'') as ftp_remote
,replace(replace(t1.ftp_remote_ret,chr(13),''),chr(10),'') as ftp_remote_ret
,replace(replace(t1.create_emp,chr(13),''),chr(10),'') as create_emp
,create_time
,replace(replace(t1.update_emp,chr(13),''),chr(10),'') as update_emp
,update_time
,replace(replace(t1.fld_s1,chr(13),''),chr(10),'') as fld_s1
,replace(replace(t1.fld_s2,chr(13),''),chr(10),'') as fld_s2
,replace(replace(t1.fld_s3,chr(13),''),chr(10),'') as fld_s3
,fld_n1
,fld_n2
,fld_n3
,replace(replace(t1.audit_emp,chr(13),''),chr(10),'') as audit_emp

from ${iol_schema}.amss_xft_merchant t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_xft_merchant.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
