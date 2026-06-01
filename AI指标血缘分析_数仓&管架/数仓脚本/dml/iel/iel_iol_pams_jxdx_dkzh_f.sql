: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_dkzh_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_jxdx_dkzh.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.jxdxdh as jxdxdh
    ,replace(replace(t.zhdh,chr(13),''),chr(10),'') as zhdh
    ,replace(replace(t.zzh,chr(13),''),chr(10),'') as zzh
    ,replace(replace(t.zhhm,chr(13),''),chr(10),'') as zhhm
    ,replace(replace(t.bz,chr(13),''),chr(10),'') as bz
    ,replace(replace(t.cph,chr(13),''),chr(10),'') as cph
    ,replace(replace(t.kmh,chr(13),''),chr(10),'') as kmh
    ,replace(replace(t.yqkm,chr(13),''),chr(10),'') as yqkm
    ,replace(replace(t.jgdh,chr(13),''),chr(10),'') as jgdh
    ,replace(replace(t.khh,chr(13),''),chr(10),'') as khh
    ,t.khrq as khrq
    ,t.ffrq as ffrq
    ,t.qxrq as qxrq
    ,t.dqrq as dqrq
    ,t.xhrq as xhrq
    ,replace(replace(t.zhzt,chr(13),''),chr(10),'') as zhzt
    ,replace(replace(t.qx,chr(13),''),chr(10),'') as qx
    ,t.nll as nll
    ,replace(replace(t.llyhbz,chr(13),''),chr(10),'') as llyhbz
    ,t.llyhbl as llyhbl
    ,replace(replace(t.pjh,chr(13),''),chr(10),'') as pjh
    ,replace(replace(t.hth,chr(13),''),chr(10),'') as hth
    ,replace(replace(t.dkfs,chr(13),''),chr(10),'') as dkfs
    ,t.dkje as dkje
    ,t.zhye as zhye
    ,t.zcye as zcye
    ,t.yqye as yqye
    ,t.daizhiye as daizhiye
    ,t.daizhangye as daizhangye
    ,t.bzjbl as bzjbl
    ,replace(replace(t.hydh,chr(13),''),chr(10),'') as hydh
    ,replace(replace(t.zhbs,chr(13),''),chr(10),'') as zhbs
    ,t.tjrq as tjrq
    ,replace(replace(t.qygm,chr(13),''),chr(10),'') as qygm
    ,replace(replace(t.psckzh,chr(13),''),chr(10),'') as psckzh
    ,replace(replace(t.gxhslx,chr(13),''),chr(10),'') as gxhslx
    ,t.khdxdh as khdxdh
    ,replace(replace(t.xwdkbs,chr(13),''),chr(10),'') as xwdkbs
    ,replace(replace(t.ywpz,chr(13),''),chr(10),'') as ywpz
    ,replace(replace(t.dkfflb,chr(13),''),chr(10),'') as dkfflb
    ,replace(replace(t.hkfs,chr(13),''),chr(10),'') as hkfs
    ,t.bjyqts as bjyqts
    ,t.lxyqts as lxyqts
    ,replace(replace(t.jxfs,chr(13),''),chr(10),'') as jxfs
    ,t.qynll as qynll
    ,t.sxed as sxed
    ,replace(replace(t.lsdkbs,chr(13),''),chr(10),'') as lsdkbs
    ,replace(replace(t.jjh,chr(13),''),chr(10),'') as jjh
    ,replace(replace(t.jjzt,chr(13),''),chr(10),'') as jjzt
    ,t.zxll as zxll
    ,t.jzll as jzll
    ,replace(replace(t.llfdfs,chr(13),''),chr(10),'') as llfdfs
    ,t.jtlxsr as jtlxsr
    ,t.zyqrq as zyqrq
    ,replace(replace(t.hxbz,chr(13),''),chr(10),'') as hxbz
    ,replace(replace(t.sndkbz,chr(13),''),chr(10),'') as sndkbz
    ,replace(replace(t.lhdkbz,chr(13),''),chr(10),'') as lhdkbz
    ,replace(replace(t.wldkbz,chr(13),''),chr(10),'') as wldkbz
    ,t.se as se
    ,t.drlxsr as drlxsr
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.pams_jxdx_dkzh t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_dkzh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes