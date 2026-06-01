: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uuss_uus_userroleinfo_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/uuss_uus_userroleinfo_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(domainid,chr(10),''),chr(13),'') as domainid
,replace(replace(sysid,chr(10),''),chr(13),'') as sysid
,replace(replace(unitno,chr(10),''),chr(13),'') as unitno
,replace(replace(subunitno,chr(10),''),chr(13),'') as subunitno
,replace(replace(rolecode,chr(10),''),chr(13),'') as rolecode
,replace(replace(rolename,chr(10),''),chr(13),'') as rolename
,start_dt
,end_dt
,id_mark
,etl_timestamp
from  ${iol_schema}.uuss_uus_userroleinfo
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uuss_uus_userroleinfo_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes