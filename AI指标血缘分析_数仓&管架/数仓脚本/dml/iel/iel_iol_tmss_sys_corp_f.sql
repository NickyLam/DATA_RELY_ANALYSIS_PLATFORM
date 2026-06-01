: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tmss_sys_corp_f
CreateDate: 20260410
FileName:   ${iel_data_path}/tmss_sys_corp.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.account_licence,chr(13),''),chr(10),'') as account_licence
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,collect_flag
,ctl_budget
,replace(replace(t1.head_person,chr(13),''),chr(10),'') as head_person
,listed_company
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.parent_id,chr(13),''),chr(10),'') as parent_id
,replace(replace(t1.parent_ids,chr(13),''),chr(10),'') as parent_ids
,replace(replace(t1.province,chr(13),''),chr(10),'') as province
,sort
,status
,type
,replace(replace(t1.use_account_code,chr(13),''),chr(10),'') as use_account_code
,replace(replace(t1.net_id,chr(13),''),chr(10),'') as net_id
,rat_group
,create_time
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,update_time
,replace(replace(t1.update_by,chr(13),''),chr(10),'') as update_by
,replace(replace(t1.is_limit_quota,chr(13),''),chr(10),'') as is_limit_quota
,day_limit_quota
,month_limit_quota
,replace(replace(t1.name_en,chr(13),''),chr(10),'') as name_en
,replace(replace(t1.address_en,chr(13),''),chr(10),'') as address_en
,replace(replace(t1.cur_id,chr(13),''),chr(10),'') as cur_id
,replace(replace(t1.unit_attribute,chr(13),''),chr(10),'') as unit_attribute
,replace(replace(t1.unit_cm,chr(13),''),chr(10),'') as unit_cm
,replace(replace(t1.country_id,chr(13),''),chr(10),'') as country_id
,replace(replace(t1.tenant_id,chr(13),''),chr(10),'') as tenant_id
,replace(replace(t1.soc_code,chr(13),''),chr(10),'') as soc_code
,replace(replace(t1.corp_tenant_code,chr(13),''),chr(10),'') as corp_tenant_code
,replace(replace(t1.bank_code,chr(13),''),chr(10),'') as bank_code

from ${iol_schema}.tmss_sys_corp t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tmss_sys_corp.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
