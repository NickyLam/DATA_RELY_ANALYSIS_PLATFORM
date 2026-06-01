: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_rat_f
CreateDate: 20250208
FileName:   ${iel_data_path}/isbs_rat.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,replace(replace(t1.mon,chr(13),''),chr(10),'') as mon
,replace(replace(t1.cur,chr(13),''),chr(10),'') as cur
,rat
,dat
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver

from ${iol_schema}.isbs_rat t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_rat.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
