: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tcrs_pol_attribute_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tcrs_pol_attribute.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.attribute_code,chr(13),''),chr(10),'') as attribute_code
,replace(replace(t.type,chr(13),''),chr(10),'') as type
,replace(replace(t.name,chr(13),''),chr(10),'') as name
,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,t.ctime as ctime
,replace(replace(t.cuid,chr(13),''),chr(10),'') as cuid
,t.mtime as mtime
,replace(replace(t.muid,chr(13),''),chr(10),'') as muid
,replace(replace(t.required,chr(13),''),chr(10),'') as required
,replace(replace(t.value_type,chr(13),''),chr(10),'') as value_type
,replace(replace(t.enumeration,chr(13),''),chr(10),'') as enumeration
,replace(replace(t.is_inner,chr(13),''),chr(10),'') as is_inner
,replace(replace(t.visible,chr(13),''),chr(10),'') as visible
,t.version as version
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.tcrs_pol_attribute t
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tcrs_pol_attribute.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes