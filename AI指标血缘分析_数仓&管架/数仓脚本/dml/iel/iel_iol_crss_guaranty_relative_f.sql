: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_guaranty_relative_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_guaranty_relative.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.objecttype,chr(13),''),chr(10),'') as objecttype
,replace(replace(t.objectno,chr(13),''),chr(10),'') as objectno
,replace(replace(t.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t.guarantyid,chr(13),''),chr(10),'') as guarantyid
,replace(replace(t.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.othersrightid,chr(13),''),chr(10),'') as othersrightid
,replace(replace(t.guarantysum,chr(13),''),chr(10),'') as guarantysum
,replace(replace(t.describe,chr(13),''),chr(10),'') as describe
,replace(replace(t.payorder,chr(13),''),chr(10),'') as payorder
,replace(replace(t.type,chr(13),''),chr(10),'') as type
,replace(replace(t.relationstatus,chr(13),''),chr(10),'') as relationstatus
,replace(replace(t.isinuse,chr(13),''),chr(10),'') as isinuse
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_guaranty_relative t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_guaranty_relative.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes