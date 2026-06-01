: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxdx_zgxt_f
CreateDate: 20251107
FileName:   ${iel_data_path}/pams_jxdx_zgxt.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,replace(replace(t1.frbh,chr(13),''),chr(10),'') as frbh
,replace(replace(t1.tadm,chr(13),''),chr(10),'') as tadm
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.kh,chr(13),''),chr(10),'') as kh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,shje
,mrcb
,zfe
,jz
,zhye
,tjrq
,replace(replace(t1.bzcpbh,chr(13),''),chr(10),'') as bzcpbh
,replace(replace(t1.khlx,chr(13),''),chr(10),'') as khlx
,mrjz

from ${iol_schema}.pams_jxdx_zgxt t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_zgxt.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
