: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_wl_merchant_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_wl_merchant.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.merchant_no,chr(13),''),chr(10),'') as merchant_no
,replace(replace(t.merchant_name,chr(13),''),chr(10),'') as merchant_name
,replace(replace(t.merchant_describe,chr(13),''),chr(10),'') as merchant_describe
,replace(replace(t.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t.corp_idcard_no,chr(13),''),chr(10),'') as corp_idcard_no
,replace(replace(t.org_no,chr(13),''),chr(10),'') as org_no
,replace(replace(t.tax_no,chr(13),''),chr(10),'') as tax_no
,replace(replace(t.uscc,chr(13),''),chr(10),'') as uscc
,t.registed_capital as registed_capital
,t.establish_date as establish_date
,replace(replace(t.registed_org,chr(13),''),chr(10),'') as registed_org
,replace(replace(t.registed_addr,chr(13),''),chr(10),'') as registed_addr
,replace(replace(t.prov_code,chr(13),''),chr(10),'') as prov_code
,replace(replace(t.city_code,chr(13),''),chr(10),'') as city_code
,replace(replace(t.dis_code,chr(13),''),chr(10),'') as dis_code
,replace(replace(t.office_addr,chr(13),''),chr(10),'') as office_addr
,replace(replace(t.office_tel,chr(13),''),chr(10),'') as office_tel
,replace(replace(t.contact_name,chr(13),''),chr(10),'') as contact_name
,replace(replace(t.contact_phone,chr(13),''),chr(10),'') as contact_phone
,replace(replace(t.parent_no,chr(13),''),chr(10),'') as parent_no
,replace(replace(t.account_no,chr(13),''),chr(10),'') as account_no
,replace(replace(t.data_uuid,chr(13),''),chr(10),'') as data_uuid
,replace(replace(t.create_user,chr(13),''),chr(10),'') as create_user
,t.create_time as create_time
,replace(replace(t.update_user,chr(13),''),chr(10),'') as update_user
,t.update_time as update_time
,replace(replace(t.agency_no,chr(13),''),chr(10),'') as agency_no
,t.use_yn as use_yn
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ilss_wl_merchant t
where start_dt <= to_date('${batch_date}','yyyymmdd')
  and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_wl_merchant.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes