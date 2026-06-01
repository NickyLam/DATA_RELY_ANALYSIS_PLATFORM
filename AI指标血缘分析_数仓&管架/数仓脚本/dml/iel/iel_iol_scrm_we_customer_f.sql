: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_scrm_we_customer_f
CreateDate: 20230804
FileName:   ${iel_data_path}/scrm_we_customer.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.external_userid,chr(13),''),chr(10),'') as external_userid
,replace(replace(t1.customer_name,chr(13),''),chr(10),'') as customer_name
,replace(replace(t1.avatar,chr(13),''),chr(10),'') as avatar
,customer_type
,gender
,replace(replace(t1.unionid,chr(13),''),chr(10),'') as unionid
,replace(replace(t1.position_ora,chr(13),''),chr(10),'') as position_ora
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.corp_full_name,chr(13),''),chr(10),'') as corp_full_name
,replace(replace(t1.external_profile,chr(13),''),chr(10),'') as external_profile
,replace(replace(t1.is_bank_customer,chr(13),''),chr(10),'') as is_bank_customer
,replace(replace(t1.ident_no,chr(13),''),chr(10),'') as ident_no
,replace(replace(t1.birth,chr(13),''),chr(10),'') as birth
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.ident_flg,chr(13),''),chr(10),'') as ident_flg
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.last_modi_by,chr(13),''),chr(10),'') as last_modi_by
,replace(replace(t1.last_modi_time,chr(13),''),chr(10),'') as last_modi_time
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.customer_initial,chr(13),''),chr(10),'') as customer_initial
,replace(replace(t1.line_id,chr(13),''),chr(10),'') as line_id
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.auth_dt,chr(13),''),chr(10),'') as auth_dt
,replace(replace(t1.auth_mode,chr(13),''),chr(10),'') as auth_mode
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id

from ${iol_schema}.scrm_we_customer t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/scrm_we_customer.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
