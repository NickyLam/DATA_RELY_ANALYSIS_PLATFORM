: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_ckzh_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_jxdx_ckzh.f.${batch_date}.dat
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
    ,replace(replace(t.pzh,chr(13),''),chr(10),'') as pzh
    ,replace(replace(t.jgdh,chr(13),''),chr(10),'') as jgdh
    ,replace(replace(t.khh,chr(13),''),chr(10),'') as khh
    ,t.khrq as khrq
    ,t.qxrq as qxrq
    ,t.dqrq as dqrq
    ,t.xhrq as xhrq
    ,replace(replace(t.zhzt,chr(13),''),chr(10),'') as zhzt
    ,replace(replace(t.zhsx,chr(13),''),chr(10),'') as zhsx
    ,replace(replace(t.qx,chr(13),''),chr(10),'') as qx
    ,t.nll as nll
    ,t.zhye as zhye
    ,replace(replace(t.zhbs,chr(13),''),chr(10),'') as zhbs
    ,replace(replace(t.hydh,chr(13),''),chr(10),'') as hydh
    ,t.tjrq as tjrq
    ,replace(replace(t.gxhslx,chr(13),''),chr(10),'') as gxhslx
    ,t.khdxdh as khdxdh
    ,replace(replace(t.czdm,chr(13),''),chr(10),'') as czdm
    ,replace(replace(t.dhbz,chr(13),''),chr(10),'') as dhbz
    ,t.jtlxzc as jtlxzc
    ,replace(replace(t.zzkzqr,chr(13),''),chr(10),'') as zzkzqr
    ,replace(replace(t.kh,chr(13),''),chr(10),'') as kh
    ,replace(replace(t.sfhx,chr(13),''),chr(10),'') as sfhx
    ,t.khje as khje
    ,replace(replace(t.zjhm,chr(13),''),chr(10),'') as zjhm
    ,replace(replace(t.ywtxdm,chr(13),''),chr(10),'') as ywtxdm
    ,replace(replace(t.khjg,chr(13),''),chr(10),'') as khjg
    ,replace(replace(t.khgybh,chr(13),''),chr(10),'') as khgybh
    ,replace(replace(t.chbz,chr(13),''),chr(10),'') as chbz
    ,replace(replace(t.tyckbz,chr(13),''),chr(10),'') as tyckbz
    ,replace(replace(t.shhbz,chr(13),''),chr(10),'') as shhbz
    ,replace(replace(t.djbz,chr(13),''),chr(10),'') as djbz
    ,t.djje as djje
    ,t.djdqrq as djdqrq
    ,replace(replace(t.zdzcbz,chr(13),''),chr(10),'') as zdzcbz
    ,t.yzccs as yzccs
    ,replace(replace(t.xdckbz,chr(13),''),chr(10),'') as xdckbz
    ,t.xdll as xdll
    ,t.xdcklcje as xdcklcje
    ,replace(replace(t.bzjbz,chr(13),''),chr(10),'') as bzjbz
    ,replace(replace(t.jgxckbz,chr(13),''),chr(10),'') as jgxckbz
    ,replace(replace(t.jzll,chr(13),''),chr(10),'') as jzll
    ,replace(replace(t.ktqzqbz,chr(13),''),chr(10),'') as ktqzqbz
    ,replace(replace(t.kzrbz,chr(13),''),chr(10),'') as kzrbz
    ,replace(replace(t.dfgzzhbz,chr(13),''),chr(10),'') as dfgzzhbz
    ,replace(replace(t.tzckbz,chr(13),''),chr(10),'') as tzckbz
    ,replace(replace(t.wlckbz,chr(13),''),chr(10),'') as wlckbz
    ,replace(replace(t.txyckbz,chr(13),''),chr(10),'') as txyckbz
    ,replace(replace(t.dzybz,chr(13),''),chr(10),'') as dzybz
    ,t.dzyje as dzyje
    ,replace(replace(t.glhxckzh,chr(13),''),chr(10),'') as glhxckzh
    ,replace(replace(t.p2pckbz,chr(13),''),chr(10),'') as p2pckbz
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.pams_jxdx_ckzh t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_ckzh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes