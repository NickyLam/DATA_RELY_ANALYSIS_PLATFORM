: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_khdx_hy_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_khdx_hy.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.khdxdh as khdxdh
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.hymc,chr(13),''),chr(10),'') as hymc
,replace(replace(t1.xl,chr(13),''),chr(10),'') as xl
,replace(replace(t1.lxdh,chr(13),''),chr(10),'') as lxdh
,replace(replace(t1.sfz,chr(13),''),chr(10),'') as sfz
,replace(replace(t1.yxrybz,chr(13),''),chr(10),'') as yxrybz
,replace(replace(t1.xnhybz,chr(13),''),chr(10),'') as xnhybz
,replace(replace(t1.dlmc,chr(13),''),chr(10),'') as dlmc
,replace(replace(t1.dlmm,chr(13),''),chr(10),'') as dlmm
,replace(replace(t1.aqjb,chr(13),''),chr(10),'') as aqjb
,replace(replace(t1.zxzt,chr(13),''),chr(10),'') as zxzt
,replace(replace(t1.scdl,chr(13),''),chr(10),'') as scdl
,replace(replace(t1.zpxx,chr(13),''),chr(10),'') as zpxx
,replace(replace(t1.czybh,chr(13),''),chr(10),'') as czybh
,t1.zxrq as zxrq
,t1.csrq as csrq
,t1.gzrq as gzrq
,t1.rhrq as rhrq
,replace(replace(t1.fgbz,chr(13),''),chr(10),'') as fgbz
,t1.pxbz as pxbz
,replace(replace(t1.xgmmrq,chr(13),''),chr(10),'') as xgmmrq
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.pams_khdx_hy t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_khdx_hy.f.${batch_date}.dat" \
        charset=utf8
        safe=yes