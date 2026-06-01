: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_iers_gl_dtlfreevalue_f
CreateDate: 20250514
FileName:   ${iel_data_path}/iers_gl_dtlfreevalue.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pk_dtlfreevalue,chr(13),''),chr(10),'') as pk_dtlfreevalue
,dr
,replace(replace(t1.freevalue1,chr(13),''),chr(10),'') as freevalue1
,replace(replace(t1.freevalue10,chr(13),''),chr(10),'') as freevalue10
,replace(replace(t1.freevalue11,chr(13),''),chr(10),'') as freevalue11
,replace(replace(t1.freevalue12,chr(13),''),chr(10),'') as freevalue12
,replace(replace(t1.freevalue13,chr(13),''),chr(10),'') as freevalue13
,replace(replace(t1.freevalue14,chr(13),''),chr(10),'') as freevalue14
,replace(replace(t1.freevalue15,chr(13),''),chr(10),'') as freevalue15
,replace(replace(t1.freevalue16,chr(13),''),chr(10),'') as freevalue16
,replace(replace(t1.freevalue17,chr(13),''),chr(10),'') as freevalue17
,replace(replace(t1.freevalue18,chr(13),''),chr(10),'') as freevalue18
,replace(replace(t1.freevalue19,chr(13),''),chr(10),'') as freevalue19
,replace(replace(t1.freevalue2,chr(13),''),chr(10),'') as freevalue2
,replace(replace(t1.freevalue20,chr(13),''),chr(10),'') as freevalue20
,replace(replace(t1.freevalue21,chr(13),''),chr(10),'') as freevalue21
,replace(replace(t1.freevalue22,chr(13),''),chr(10),'') as freevalue22
,replace(replace(t1.freevalue23,chr(13),''),chr(10),'') as freevalue23
,replace(replace(t1.freevalue24,chr(13),''),chr(10),'') as freevalue24
,replace(replace(t1.freevalue25,chr(13),''),chr(10),'') as freevalue25
,replace(replace(t1.freevalue26,chr(13),''),chr(10),'') as freevalue26
,replace(replace(t1.freevalue27,chr(13),''),chr(10),'') as freevalue27
,replace(replace(t1.freevalue28,chr(13),''),chr(10),'') as freevalue28
,replace(replace(t1.freevalue29,chr(13),''),chr(10),'') as freevalue29
,replace(replace(t1.freevalue3,chr(13),''),chr(10),'') as freevalue3
,replace(replace(t1.freevalue30,chr(13),''),chr(10),'') as freevalue30
,replace(replace(t1.freevalue4,chr(13),''),chr(10),'') as freevalue4
,replace(replace(t1.freevalue5,chr(13),''),chr(10),'') as freevalue5
,replace(replace(t1.freevalue6,chr(13),''),chr(10),'') as freevalue6
,replace(replace(t1.freevalue7,chr(13),''),chr(10),'') as freevalue7
,replace(replace(t1.freevalue8,chr(13),''),chr(10),'') as freevalue8
,replace(replace(t1.freevalue9,chr(13),''),chr(10),'') as freevalue9
,replace(replace(t1.pk_detail,chr(13),''),chr(10),'') as pk_detail
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts

from ${iol_schema}.iers_gl_dtlfreevalue t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_gl_dtlfreevalue.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
