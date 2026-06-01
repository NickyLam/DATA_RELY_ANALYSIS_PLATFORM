: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_lczh_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_jxdx_lczh.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.jxdxdh as jxdxdh
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.zhhm,chr(13),''),chr(10),'') as zhhm
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,t1.khrq as khrq
,t1.xhrq as xhrq
,replace(replace(t1.cpdm,chr(13),''),chr(10),'') as cpdm
,replace(replace(t1.cplb,chr(13),''),chr(10),'') as cplb
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,t1.mjksr as mjksr
,t1.mjjsr as mjjsr
,t1.nll as nll
,t1.zhye as zhye
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,replace(replace(t1.zhzt,chr(13),''),chr(10),'') as zhzt
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx
,t1.khdxdh as khdxdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,t1.tjrq as tjrq
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.qxrq as qxrq
,t1.zxrq as zxrq
,t1.yqnhsyl as yqnhsyl
,t1.cpyzsj as cpyzsj
,t1.mrjehz as mrjehz
,t1.cyfe as cyfe
,t1.mjje as mjje
,replace(replace(t1.zjjszh,chr(13),''),chr(10),'') as zjjszh
,replace(replace(t1.xssdm,chr(13),''),chr(10),'') as xssdm
,replace(replace(t1.yhbh,chr(13),''),chr(10),'') as yhbh
,replace(replace(t1.zhbh,chr(13),''),chr(10),'') as zhbh
from ${iol_schema}.pams_jxdx_lczh t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_lczh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes