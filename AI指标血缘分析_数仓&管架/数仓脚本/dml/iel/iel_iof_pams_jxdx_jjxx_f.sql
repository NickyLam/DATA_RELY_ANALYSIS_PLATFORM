: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxdx_jjxx_f
CreateDate: 20251107
FileName:   ${iel_data_path}/pams_jxdx_jjxx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.cpdm,chr(13),''),chr(10),'') as cpdm
,replace(replace(t1.cpsx,chr(13),''),chr(10),'') as cpsx
,replace(replace(t1.tadm,chr(13),''),chr(10),'') as tadm
,replace(replace(t1.bzcpdm,chr(13),''),chr(10),'') as bzcpdm
,replace(replace(t1.jyzh,chr(13),''),chr(10),'') as jyzh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.fhfs,chr(13),''),chr(10),'') as fhfs
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,zhdhrq
,tjrq
,fe
,jz
,zhye
,replace(replace(t1.ztbz,chr(13),''),chr(10),'') as ztbz

from ${iol_schema}.pams_jxdx_jjxx t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_jjxx.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
