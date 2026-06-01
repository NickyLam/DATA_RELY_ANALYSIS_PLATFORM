: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uuss_uus_domain_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/uuss_uus_domain_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(domainid,chr(10),''),chr(13),'') as domainid
,replace(replace(employeeid,chr(10),''),chr(13),'') as employeeid
,replace(replace(name,chr(10),''),chr(13),'') as name
,replace(replace(sysstatus,chr(10),''),chr(13),'') as sysstatus
,replace(replace(companycountrycode,chr(10),''),chr(13),'') as companycountrycode
,replace(replace(companyareacode,chr(10),''),chr(13),'') as companyareacode
,replace(replace(companyphone,chr(10),''),chr(13),'') as companyphone
,replace(replace(companysubphone,chr(10),''),chr(13),'') as companysubphone
,replace(replace(mobile,chr(10),''),chr(13),'') as mobile
,replace(replace(post,chr(10),''),chr(13),'') as post
,replace(replace(address,chr(10),''),chr(13),'') as address
,replace(replace(email,chr(10),''),chr(13),'') as email
,start_dt
,end_dt
,id_mark
,etl_timestamp
from  ${iol_schema}.uuss_uus_domain
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uuss_uus_domain_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes