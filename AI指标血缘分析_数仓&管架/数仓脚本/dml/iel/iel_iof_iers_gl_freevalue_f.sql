: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_iers_gl_freevalue_f
CreateDate: 20250514
FileName:   ${iel_data_path}/iers_gl_freevalue.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,dr
,replace(replace(t1.freevalueid,chr(13),''),chr(10),'') as freevalueid
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,replace(replace(t1.typevalue1,chr(13),''),chr(10),'') as typevalue1
,replace(replace(t1.typevalue2,chr(13),''),chr(10),'') as typevalue2
,replace(replace(t1.typevalue3,chr(13),''),chr(10),'') as typevalue3
,replace(replace(t1.typevalue4,chr(13),''),chr(10),'') as typevalue4
,replace(replace(t1.typevalue5,chr(13),''),chr(10),'') as typevalue5
,replace(replace(t1.typevalue6,chr(13),''),chr(10),'') as typevalue6
,replace(replace(t1.typevalue7,chr(13),''),chr(10),'') as typevalue7
,replace(replace(t1.typevalue8,chr(13),''),chr(10),'') as typevalue8
,replace(replace(t1.typevalue9,chr(13),''),chr(10),'') as typevalue9
,replace(replace(t1.typevaluemd5,chr(13),''),chr(10),'') as typevaluemd5

from ${iol_schema}.iers_gl_freevalue t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_gl_freevalue.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
