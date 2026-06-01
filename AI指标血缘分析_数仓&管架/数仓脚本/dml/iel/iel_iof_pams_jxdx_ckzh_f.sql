: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxdx_ckzh_f
CreateDate: 20251111
FileName:   ${iel_data_path}/pams_jxdx_ckzh.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh
,replace(replace(t1.zhhm,chr(13),''),chr(10),'') as zhhm
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.pzh,chr(13),''),chr(10),'') as pzh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,khrq
,qxrq
,dqrq
,xhrq
,replace(replace(t1.zhzt,chr(13),''),chr(10),'') as zhzt
,replace(replace(t1.zhsx,chr(13),''),chr(10),'') as zhsx
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,nll
,zhye
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,tjrq
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx
,khdxdh
,replace(replace(t1.czdm,chr(13),''),chr(10),'') as czdm
,replace(replace(t1.dhbz,chr(13),''),chr(10),'') as dhbz
,jtlxzc
,replace(replace(t1.zzkzqr,chr(13),''),chr(10),'') as zzkzqr
,replace(replace(t1.kh,chr(13),''),chr(10),'') as kh
,replace(replace(t1.sfhx,chr(13),''),chr(10),'') as sfhx
,khje
,replace(replace(t1.zjhm,chr(13),''),chr(10),'') as zjhm
,replace(replace(t1.ywtxdm,chr(13),''),chr(10),'') as ywtxdm
,replace(replace(t1.khjg,chr(13),''),chr(10),'') as khjg
,replace(replace(t1.khgybh,chr(13),''),chr(10),'') as khgybh
,replace(replace(t1.chbz,chr(13),''),chr(10),'') as chbz
,replace(replace(t1.tyckbz,chr(13),''),chr(10),'') as tyckbz
,replace(replace(t1.shhbz,chr(13),''),chr(10),'') as shhbz
,replace(replace(t1.djbz,chr(13),''),chr(10),'') as djbz
,djje
,djdqrq
,replace(replace(t1.zdzcbz,chr(13),''),chr(10),'') as zdzcbz
,yzccs
,replace(replace(t1.xdckbz,chr(13),''),chr(10),'') as xdckbz
,xdll
,xdcklcje
,replace(replace(t1.bzjbz,chr(13),''),chr(10),'') as bzjbz
,replace(replace(t1.jgxckbz,chr(13),''),chr(10),'') as jgxckbz
,replace(replace(t1.jzll,chr(13),''),chr(10),'') as jzll
,replace(replace(t1.ktqzqbz,chr(13),''),chr(10),'') as ktqzqbz
,replace(replace(t1.kzrbz,chr(13),''),chr(10),'') as kzrbz
,replace(replace(t1.dfgzzhbz,chr(13),''),chr(10),'') as dfgzzhbz
,replace(replace(t1.tzckbz,chr(13),''),chr(10),'') as tzckbz
,replace(replace(t1.wlckbz,chr(13),''),chr(10),'') as wlckbz
,replace(replace(t1.txyckbz,chr(13),''),chr(10),'') as txyckbz
,replace(replace(t1.dzybz,chr(13),''),chr(10),'') as dzybz
,dzyje
,replace(replace(t1.glhxckzh,chr(13),''),chr(10),'') as glhxckzh
,replace(replace(t1.p2pckbz,chr(13),''),chr(10),'') as p2pckbz
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.pams_jxdx_ckzh t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_ckzh.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
