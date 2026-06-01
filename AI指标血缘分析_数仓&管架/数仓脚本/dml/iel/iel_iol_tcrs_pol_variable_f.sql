: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tcrs_pol_variable_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tcrs_pol_variable.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.variable_code,chr(13),''),chr(10),'') as variable_code
,replace(replace(t.name,chr(13),''),chr(10),'') as name
,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t.genre_code,chr(13),''),chr(10),'') as genre_code
,replace(replace(t.return_type,chr(13),''),chr(10),'') as return_type
,replace(replace(t.exception_value,chr(13),''),chr(10),'') as exception_value
,replace(replace(t.event_code,chr(13),''),chr(10),'') as event_code
,replace(replace(t.entity_type,chr(13),''),chr(10),'') as entity_type
,replace(replace(t.type,chr(13),''),chr(10),'') as type
,replace(replace(t.is_share,chr(13),''),chr(10),'') as is_share
,replace(replace(t.args,chr(13),''),chr(10),'') as args
,replace(replace(t.tenant_code,chr(13),''),chr(10),'') as tenant_code
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,t.ctime as ctime
,replace(replace(t.cuid,chr(13),''),chr(10),'') as cuid
,t.mtime as mtime
,replace(replace(t.muid,chr(13),''),chr(10),'') as muid
,t.seq as seq
,t.version as version
,replace(replace(t.src,chr(13),''),chr(10),'') as src
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.tcrs_pol_variable t
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tcrs_pol_variable.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes