: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_nbzhlx_f
CreateDate: 20260403
FileName:   ${iel_data_path}/pams_jxdx_nbzhlx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.bjkm,chr(13),''),chr(10),'') as bjkm
,replace(replace(t1.lxkm,chr(13),''),chr(10),'') as lxkm
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,sdlx
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph

from ${iol_schema}.pams_jxdx_nbzhlx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_nbzhlx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
