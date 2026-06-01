: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a60datadict_f
CreateDate: 20240507
FileName:   ${iel_data_path}/mpcs_a60datadict.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.key,chr(13),''),chr(10),'') as key
,replace(replace(t1.value,chr(13),''),chr(10),'') as value
,replace(replace(t1.stat,chr(13),''),chr(10),'') as stat
,replace(replace(t1.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t1.reserve2,chr(13),''),chr(10),'') as reserve2
,replace(replace(t1.reserve3,chr(13),''),chr(10),'') as reserve3
,replace(replace(t1.reserve4,chr(13),''),chr(10),'') as reserve4

from ${iol_schema}.mpcs_a60datadict t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a60datadict.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
