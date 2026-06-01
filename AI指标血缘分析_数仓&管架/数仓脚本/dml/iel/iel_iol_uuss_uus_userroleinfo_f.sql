: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uuss_uus_userroleinfo_f
CreateDate: 20221021
FileName:   ${iel_data_path}/uuss_uus_userroleinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(domainid,chr(13),''),chr(10),'')
,replace(replace(sysid,chr(13),''),chr(10),'')
,replace(replace(unitno,chr(13),''),chr(10),'')
,replace(replace(subunitno,chr(13),''),chr(10),'')
,replace(replace(rolecode,chr(13),''),chr(10),'')
,replace(replace(rolename,chr(13),''),chr(10),'')

from ${iol_schema}.uuss_uus_userroleinfo t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uuss_uus_userroleinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
