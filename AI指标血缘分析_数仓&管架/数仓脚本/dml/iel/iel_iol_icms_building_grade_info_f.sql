: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_building_grade_info_f
CreateDate: 20240814
FileName:   ${iel_data_path}/icms_building_grade_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.bldgencd,chr(13),''),chr(10),'') as bldgencd
,replace(replace(t1.rowcount,chr(13),''),chr(10),'') as rowcount
,replace(replace(t1.message,chr(13),''),chr(10),'') as message
,replace(replace(t1.data,chr(13),''),chr(10),'') as data
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.attribute1,chr(13),''),chr(10),'') as attribute1
,replace(replace(t1.attribute2,chr(13),''),chr(10),'') as attribute2
,replace(replace(t1.attribute3,chr(13),''),chr(10),'') as attribute3
,replace(replace(t1.regioncd,chr(13),''),chr(10),'') as regioncd
,replace(replace(t1.prptycomplloc,chr(13),''),chr(10),'') as prptycomplloc

from ${iol_schema}.icms_building_grade_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_building_grade_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
