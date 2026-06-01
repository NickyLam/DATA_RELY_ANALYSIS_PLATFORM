: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orms_t21_disclosure_f
CreateDate: 20231107
FileName:   ${iel_data_path}/orms_t21_disclosure.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag
,replace(replace(t1.pid,chr(13),''),chr(10),'') as pid
,replace(replace(t1.seq,chr(13),''),chr(10),'') as seq
,replace(replace(t1.type,chr(13),''),chr(10),'') as type
,replace(replace(t1.model,chr(13),''),chr(10),'') as model

from ${iol_schema}.orms_t21_disclosure t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orms_t21_disclosure.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
