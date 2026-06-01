: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_khdx_jg_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_khdx_jg.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.khdxdh as khdxdh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.jgmc,chr(13),''),chr(10),'') as jgmc
,replace(replace(t1.jyjgbz,chr(13),''),chr(10),'') as jyjgbz
,t1.pxbz as pxbz
,replace(replace(t1.zxzt,chr(13),''),chr(10),'') as zxzt
,t1.zxrq as zxrq
,replace(replace(t1.fhdh,chr(13),''),chr(10),'') as fhdh
,replace(replace(t1.fhbz,chr(13),''),chr(10),'') as fhbz
,replace(replace(t1.jgdj,chr(13),''),chr(10),'') as jgdj
,replace(replace(t1.jgqc,chr(13),''),chr(10),'') as jgqc
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.pams_khdx_jg t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_khdx_jg.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes