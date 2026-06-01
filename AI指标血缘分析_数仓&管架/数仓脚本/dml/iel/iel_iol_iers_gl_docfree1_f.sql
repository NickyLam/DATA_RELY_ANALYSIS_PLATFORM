: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iers_gl_docfree1_f
CreateDate: 20240819
FileName:   ${iel_data_path}/iers_gl_docfree1.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.assid,chr(13),''),chr(10),'') as assid
,dr
,replace(replace(t1.f1,chr(13),''),chr(10),'') as f1
,replace(replace(t1.f10,chr(13),''),chr(10),'') as f10
,replace(replace(t1.f11,chr(13),''),chr(10),'') as f11
,replace(replace(t1.f12,chr(13),''),chr(10),'') as f12
,replace(replace(t1.f13,chr(13),''),chr(10),'') as f13
,replace(replace(t1.f14,chr(13),''),chr(10),'') as f14
,replace(replace(t1.f15,chr(13),''),chr(10),'') as f15
,replace(replace(t1.f16,chr(13),''),chr(10),'') as f16
,replace(replace(t1.f17,chr(13),''),chr(10),'') as f17
,replace(replace(t1.f18,chr(13),''),chr(10),'') as f18
,replace(replace(t1.f19,chr(13),''),chr(10),'') as f19
,replace(replace(t1.f2,chr(13),''),chr(10),'') as f2
,replace(replace(t1.f20,chr(13),''),chr(10),'') as f20
,replace(replace(t1.f21,chr(13),''),chr(10),'') as f21
,replace(replace(t1.f22,chr(13),''),chr(10),'') as f22
,replace(replace(t1.f23,chr(13),''),chr(10),'') as f23
,replace(replace(t1.f24,chr(13),''),chr(10),'') as f24
,replace(replace(t1.f25,chr(13),''),chr(10),'') as f25
,replace(replace(t1.f26,chr(13),''),chr(10),'') as f26
,replace(replace(t1.f27,chr(13),''),chr(10),'') as f27
,replace(replace(t1.f28,chr(13),''),chr(10),'') as f28
,replace(replace(t1.f29,chr(13),''),chr(10),'') as f29
,replace(replace(t1.f3,chr(13),''),chr(10),'') as f3
,replace(replace(t1.f30,chr(13),''),chr(10),'') as f30
,replace(replace(t1.f4,chr(13),''),chr(10),'') as f4
,replace(replace(t1.f5,chr(13),''),chr(10),'') as f5
,replace(replace(t1.f6,chr(13),''),chr(10),'') as f6
,replace(replace(t1.f7,chr(13),''),chr(10),'') as f7
,replace(replace(t1.f8,chr(13),''),chr(10),'') as f8
,replace(replace(t1.f9,chr(13),''),chr(10),'') as f9
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts

from ${iol_schema}.iers_gl_docfree1 t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_gl_docfree1.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
