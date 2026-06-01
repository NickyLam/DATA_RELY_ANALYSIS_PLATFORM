: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a50ubcardbin_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a50ubcardbin.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.pinblock,chr(13),''),chr(10),'') as pinblock
,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
,replace(replace(t.cardlen,chr(13),''),chr(10),'') as cardlen
,replace(replace(t.binlen,chr(13),''),chr(10),'') as binlen
,replace(replace(t.bintype,chr(13),''),chr(10),'') as bintype
,replace(replace(t.updtime,chr(13),''),chr(10),'') as updtime
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.mpcs_a50ubcardbin t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a50ubcardbin.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes