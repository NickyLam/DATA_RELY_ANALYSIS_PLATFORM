: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tmss_sys_tenant_bank_acc_f
CreateDate: 20251230
FileName:   ${iel_data_path}/tmss_sys_tenant_bank_acc.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.tenant_id,chr(13),''),chr(10),'') as tenant_id
,replace(replace(t1.tenant_code,chr(13),''),chr(10),'') as tenant_code
,replace(replace(t1.bank_acc_no,chr(13),''),chr(10),'') as bank_acc_no
,replace(replace(t1.bank_acc_name,chr(13),''),chr(10),'') as bank_acc_name
,replace(replace(t1.bank_code,chr(13),''),chr(10),'') as bank_code
,replace(replace(t1.bank_name,chr(13),''),chr(10),'') as bank_name
,replace(replace(t1.cur_code,chr(13),''),chr(10),'') as cur_code
,replace(replace(t1.acc_type,chr(13),''),chr(10),'') as acc_type
,replace(replace(t1.acc_nature,chr(13),''),chr(10),'') as acc_nature
,replace(replace(t1.acc_attribute,chr(13),''),chr(10),'') as acc_attribute
,status
,sign_date
,un_sign_date
,create_date
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,update_date
,replace(replace(t1.update_by,chr(13),''),chr(10),'') as update_by
,replace(replace(t1.corp_code,chr(13),''),chr(10),'') as corp_code
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name

from ${iol_schema}.tmss_sys_tenant_bank_acc t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tmss_sys_tenant_bank_acc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
