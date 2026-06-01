: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_tbms_t_corp_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tbms_t_corp_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.companyid as companyid
,replace(replace(t1.orgcode,chr(13),''),chr(10),'') as orgcode
,replace(replace(t1.cname,chr(13),''),chr(10),'') as cname
,t1.legalid as legalid
,t1.adminid as adminid
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,t1.status as status
,t1.sys_ctime as sys_ctime
,t1.sys_utime as sys_utime
,t1.sys_valid as sys_valid
,replace(replace(t1.logourl,chr(13),''),chr(10),'') as logourl
,t1.cpytype as cpytype
,replace(replace(t1.summary,chr(13),''),chr(10),'') as summary
,replace(replace(t1.website,chr(13),''),chr(10),'') as website
,replace(replace(t1.legal,chr(13),''),chr(10),'') as legal
,replace(replace(t1.legalphone,chr(13),''),chr(10),'') as legalphone
,replace(replace(t1.contactinfo,chr(13),''),chr(10),'') as contactinfo
,t1.provinces as provinces
,t1.city as city
,t1.industryid as industryid
,t1.isfunc as isfunc
,t1.etype as etype
,replace(replace(t1.estdate,chr(13),''),chr(10),'') as estdate
,t1.regcaptial as regcaptial
,replace(replace(t1.uscc,chr(13),''),chr(10),'') as uscc
,replace(replace(t1.companyno,chr(13),''),chr(10),'') as companyno
,t1.authorgid as authorgid
,t1.authtime as authtime
,replace(replace(t1.authorgcode,chr(13),''),chr(10),'') as authorgcode
,replace(replace(t1.operusercode,chr(13),''),chr(10),'') as operusercode
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.tbms_t_corp_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbms_t_corp_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes