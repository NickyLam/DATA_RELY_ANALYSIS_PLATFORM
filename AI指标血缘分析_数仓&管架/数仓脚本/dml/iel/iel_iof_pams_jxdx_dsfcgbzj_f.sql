: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxdx_dsfcgbzj_f
CreateDate: 20251107
FileName:   ${iel_data_path}/pams_jxdx_dsfcgbzj.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,replace(replace(t1.xybh,chr(13),''),chr(10),'') as xybh
,replace(replace(t1.frbh,chr(13),''),chr(10),'') as frbh
,replace(replace(t1.zjlx,chr(13),''),chr(10),'') as zjlx
,replace(replace(t1.zjhm,chr(13),''),chr(10),'') as zjhm
,replace(replace(t1.kh,chr(13),''),chr(10),'') as kh
,khrq
,replace(replace(t1.qsdm,chr(13),''),chr(10),'') as qsdm
,replace(replace(t1.zqzjzhbh,chr(13),''),chr(10),'') as zqzjzhbh
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,zhye
,replace(replace(t1.bzjzt,chr(13),''),chr(10),'') as bzjzt
,djrq
,replace(replace(t1.cpbh,chr(13),''),chr(10),'') as cpbh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,ksrq
,tjrq

from ${iol_schema}.pams_jxdx_dsfcgbzj t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_dsfcgbzj.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
