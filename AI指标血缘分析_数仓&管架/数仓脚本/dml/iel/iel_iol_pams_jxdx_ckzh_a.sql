: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_ckzh_a
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_jxdx_ckzh.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.jxdxdh as jxdxdh 
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh 
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh 
,replace(replace(t1.zhhm,chr(13),''),chr(10),'') as zhhm 
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz 
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph 
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh 
,replace(replace(t1.pzh,chr(13),''),chr(10),'') as pzh 
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh 
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh 
,t1.khrq as khrq 
,t1.qxrq as qxrq 
,t1.dqrq as dqrq 
,t1.xhrq as xhrq 
,replace(replace(t1.zhzt,chr(13),''),chr(10),'') as zhzt 
,replace(replace(t1.zhsx,chr(13),''),chr(10),'') as zhsx 
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx 
,t1.nll as nll 
,t1.zhye as zhye 
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs 
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh 
,t1.tjrq as tjrq 
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx 
,t1.khdxdh as khdxdh 
,replace(replace(t1.czdm,chr(13),''),chr(10),'') as czdm 
,replace(replace(t1.dhbz,chr(13),''),chr(10),'') as dhbz 
,t1.jtlxzc as jtlxzc 
,replace(replace(t1.zzkzqr,chr(13),''),chr(10),'') as zzkzqr 
,replace(replace(t1.kh,chr(13),''),chr(10),'') as kh 
,replace(replace(t1.sfhx,chr(13),''),chr(10),'') as sfhx 
,t1.khje as khje 
,replace(replace(t1.zjhm,chr(13),''),chr(10),'') as zjhm 
,replace(replace(t1.ywtxdm,chr(13),''),chr(10),'') as ywtxdm 
,replace(replace(t1.khjg,chr(13),''),chr(10),'') as khjg 
,replace(replace(t1.khgybh,chr(13),''),chr(10),'') as khgybh 
,replace(replace(t1.chbz,chr(13),''),chr(10),'') as chbz 
,replace(replace(t1.tyckbz,chr(13),''),chr(10),'') as tyckbz 
,replace(replace(t1.shhbz,chr(13),''),chr(10),'') as shhbz 
,replace(replace(t1.djbz,chr(13),''),chr(10),'') as djbz 
,t1.djje as djje 
,t1.djdqrq as djdqrq 
,replace(replace(t1.zdzcbz,chr(13),''),chr(10),'') as zdzcbz 
,t1.yzccs as yzccs 
,replace(replace(t1.xdckbz,chr(13),''),chr(10),'') as xdckbz 
,t1.xdll as xdll 
,t1.xdcklcje as xdcklcje 
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
,t1.dzyje as dzyje 
,replace(replace(t1.glhxckzh,chr(13),''),chr(10),'') as glhxckzh 
,replace(replace(t1.p2pckbz,chr(13),''),chr(10),'') as p2pckbz 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from iol.pams_jxdx_ckzh t1 
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_ckzh.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes