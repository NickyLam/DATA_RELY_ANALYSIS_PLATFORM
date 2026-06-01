: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tmss_sys_tenant_f
CreateDate: 20251230
FileName:   ${iel_data_path}/tmss_sys_tenant.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.tenant_code,chr(13),''),chr(10),'') as tenant_code
,replace(replace(t1.tenant_name,chr(13),''),chr(10),'') as tenant_name
,replace(replace(t1.tenant_cert_type,chr(13),''),chr(10),'') as tenant_cert_type
,replace(replace(t1.tenant_cert_code,chr(13),''),chr(10),'') as tenant_cert_code
,replace(replace(t1.sign_code,chr(13),''),chr(10),'') as sign_code
,sign_time
,replace(replace(t1.post_code,chr(13),''),chr(10),'') as post_code
,replace(replace(t1.tenant_phone,chr(13),''),chr(10),'') as tenant_phone
,replace(replace(t1.tenant_sina_name,chr(13),''),chr(10),'') as tenant_sina_name
,replace(replace(t1.tenant_eng_name,chr(13),''),chr(10),'') as tenant_eng_name
,tenant_time
,replace(replace(t1.tenant_addr,chr(13),''),chr(10),'') as tenant_addr
,replace(replace(t1.fr_name,chr(13),''),chr(10),'') as fr_name
,replace(replace(t1.fr_mobile,chr(13),''),chr(10),'') as fr_mobile
,replace(replace(t1.fr_cert_type,chr(13),''),chr(10),'') as fr_cert_type
,replace(replace(t1.fr_cert_code,chr(13),''),chr(10),'') as fr_cert_code
,replace(replace(t1.fr_cert_time,chr(13),''),chr(10),'') as fr_cert_time
,replace(replace(t1.bank_seal_id,chr(13),''),chr(10),'') as bank_seal_id
,replace(replace(t1.charge_mode,chr(13),''),chr(10),'') as charge_mode
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,create_date
,replace(replace(t1.update_by,chr(13),''),chr(10),'') as update_by
,update_date
,status
,replace(replace(t1.sign_name,chr(13),''),chr(10),'') as sign_name
,un_sign_time
,replace(replace(t1.sign_model,chr(13),''),chr(10),'') as sign_model
,replace(replace(t1.sign_user_id,chr(13),''),chr(10),'') as sign_user_id
,replace(replace(t1.sign_agreement_id,chr(13),''),chr(10),'') as sign_agreement_id

from ${iol_schema}.tmss_sys_tenant t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tmss_sys_tenant.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
