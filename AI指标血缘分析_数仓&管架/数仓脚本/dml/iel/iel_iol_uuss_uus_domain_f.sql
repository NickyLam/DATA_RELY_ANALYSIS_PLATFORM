: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uuss_uus_domain_f
CreateDate: 20221021
FileName:   ${iel_data_path}/uuss_uus_domain.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(domainid,chr(13),''),chr(10),'')
,replace(replace(employeeid,chr(13),''),chr(10),'')
,replace(replace(name,chr(13),''),chr(10),'')
,replace(replace(sysstatus,chr(13),''),chr(10),'')
,replace(replace(companycountrycode,chr(13),''),chr(10),'')
,replace(replace(companyareacode,chr(13),''),chr(10),'')
,replace(replace(companyphone,chr(13),''),chr(10),'')
,replace(replace(companysubphone,chr(13),''),chr(10),'')
,replace(replace(mobile,chr(13),''),chr(10),'')
,replace(replace(post,chr(13),''),chr(10),'')
,replace(replace(address,chr(13),''),chr(10),'')
,replace(replace(email,chr(13),''),chr(10),'')

from ${iol_schema}.uuss_uus_domain t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uuss_uus_domain.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
