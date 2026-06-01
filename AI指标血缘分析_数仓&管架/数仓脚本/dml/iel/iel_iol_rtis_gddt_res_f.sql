: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rtis_gddt_res_f
CreateDate: 20240506
FileName:   ${iel_data_path}/rtis_gddt_res.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.ip,chr(13),''),chr(10),'') as ip
,replace(replace(t1.oper_county,chr(13),''),chr(10),'') as oper_county
,replace(replace(t1.oper_prov,chr(13),''),chr(10),'') as oper_prov
,replace(replace(t1.oper_city,chr(13),''),chr(10),'') as oper_city
,create_time

from ${iol_schema}.rtis_gddt_res t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rtis_gddt_res.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
