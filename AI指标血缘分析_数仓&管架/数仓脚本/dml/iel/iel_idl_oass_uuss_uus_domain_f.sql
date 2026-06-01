: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_uuss_uus_domain_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_uuss_uus_domain.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.name as name
,t1.sysstatus as sysstatus
,t1.companycountrycode as companycountrycode
,t1.companyareacode as companyareacode
,t1.companyphone as companyphone
,t1.companysubphone as companysubphone
,t1.mobile as mobile
,t1.post as post
,t1.address as address
,t1.email as email
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.domainid as domainid
,t1.employeeid as employeeid

from ${idl_schema}.oass_uuss_uus_domain t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_uuss_uus_domain.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
