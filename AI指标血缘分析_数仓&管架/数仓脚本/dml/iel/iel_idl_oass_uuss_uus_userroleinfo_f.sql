: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_uuss_uus_userroleinfo_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_uuss_uus_userroleinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.unitno as unitno
,t1.subunitno as subunitno
,t1.rolecode as rolecode
,t1.rolename as rolename
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.domainid as domainid
,t1.sysid as sysid

from ${idl_schema}.oass_uuss_uus_userroleinfo t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_uuss_uus_userroleinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
