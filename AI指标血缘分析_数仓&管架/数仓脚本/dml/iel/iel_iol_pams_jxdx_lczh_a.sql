: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_lczh_a
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_jxdx_lczh.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.jxdxdh as jxdxdh
,replace(replace(t.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t.zhhm,chr(13),''),chr(10),'') as zhhm
,replace(replace(t.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t.kmh,chr(13),''),chr(10),'') as kmh
,t.khrq as khrq
,t.xhrq as xhrq
,replace(replace(t.cpdm,chr(13),''),chr(10),'') as cpdm
,replace(replace(t.cplb,chr(13),''),chr(10),'') as cplb
,replace(replace(t.cpmc,chr(13),''),chr(10),'') as cpmc
,t.mjksr as mjksr
,t.mjjsr as mjjsr
,t.nll as nll
,t.zhye as zhye
,replace(replace(t.zhbs,chr(13),''),chr(10),'') as zhbs
,replace(replace(t.zhzt,chr(13),''),chr(10),'') as zhzt
,replace(replace(t.gxhslx,chr(13),''),chr(10),'') as gxhslx
,t.khdxdh as khdxdh
,replace(replace(t.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t.hydh,chr(13),''),chr(10),'') as hydh
,t.tjrq as tjrq
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.pams_jxdx_lczh t
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_lczh.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes