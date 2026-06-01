: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ppps_t_merchant_info_f
CreateDate: 20240903
FileName:   ${iel_data_path}/ppps_t_merchant_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sign_no,chr(13),''),chr(10),'') as sign_no
,replace(replace(t1.payee_acct_no,chr(13),''),chr(10),'') as payee_acct_no
,replace(replace(t1.payee_acct_name,chr(13),''),chr(10),'') as payee_acct_name
,replace(replace(t1.intra_acct_no,chr(13),''),chr(10),'') as intra_acct_no
,replace(replace(t1.intra_acct_name,chr(13),''),chr(10),'') as intra_acct_name
,replace(replace(t1.branch_no,chr(13),''),chr(10),'') as branch_no
,replace(replace(t1.business_scope,chr(13),''),chr(10),'') as business_scope
,replace(replace(t1.legitimacy,chr(13),''),chr(10),'') as legitimacy
,replace(replace(t1.business_license,chr(13),''),chr(10),'') as business_license
,replace(replace(t1.active,chr(13),''),chr(10),'') as active
,create_time
,update_time
,replace(replace(t1.mer_type,chr(13),''),chr(10),'') as mer_type
,replace(replace(t1.pty_num,chr(13),''),chr(10),'') as pty_num

from ${iol_schema}.ppps_t_merchant_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ppps_t_merchant_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
