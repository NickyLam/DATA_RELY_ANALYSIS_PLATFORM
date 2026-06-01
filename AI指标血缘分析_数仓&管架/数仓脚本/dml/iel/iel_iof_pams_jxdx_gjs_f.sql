: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxdx_gjs_f
CreateDate: 20251107
FileName:   ${iel_data_path}/pams_jxdx_gjs.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,tjrq
,replace(replace(t1.ddh,chr(13),''),chr(10),'') as ddh
,replace(replace(t1.yhlsh,chr(13),''),chr(10),'') as yhlsh
,jyrq
,ddrq
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,replace(replace(t1.cpcs,chr(13),''),chr(10),'') as cpcs
,replace(replace(t1.hjl,chr(13),''),chr(10),'') as hjl
,replace(replace(t1.hyl,chr(13),''),chr(10),'') as hyl
,replace(replace(t1.gmsl,chr(13),''),chr(10),'') as gmsl
,replace(replace(t1.gysmc,chr(13),''),chr(10),'') as gysmc
,replace(replace(t1.xsqd,chr(13),''),chr(10),'') as xsqd
,jydj
,zhye
,sxf
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.sjly,chr(13),''),chr(10),'') as sjly
,khdxdh
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.cpfldm,chr(13),''),chr(10),'') as cpfldm
,tdrq
,replace(replace(t1.scddh,chr(13),''),chr(10),'') as scddh

from ${iol_schema}.pams_jxdx_gjs t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_gjs.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
