: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_dkzh_a
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_jxdx_dkzh.a.${batch_date}.dat
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
,replace(replace(t1.yqkm,chr(13),''),chr(10),'') as yqkm 
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh 
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh 
,t1.khrq as khrq 
,t1.ffrq as ffrq 
,t1.qxrq as qxrq 
,t1.dqrq as dqrq 
,t1.xhrq as xhrq 
,replace(replace(t1.zhzt,chr(13),''),chr(10),'') as zhzt 
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx 
,t1.nll as nll 
,replace(replace(t1.llyhbz,chr(13),''),chr(10),'') as llyhbz 
,t1.llyhbl as llyhbl 
,replace(replace(t1.pjh,chr(13),''),chr(10),'') as pjh 
,replace(replace(t1.hth,chr(13),''),chr(10),'') as hth 
,replace(replace(t1.dkfs,chr(13),''),chr(10),'') as dkfs 
,t1.dkje as dkje 
,t1.zhye as zhye 
,t1.zcye as zcye 
,t1.yqye as yqye 
,t1.daizhiye as daizhiye 
,t1.daizhangye as daizhangye 
,t1.bzjbl as bzjbl 
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh 
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs 
,t1.tjrq as tjrq 
,replace(replace(t1.qygm,chr(13),''),chr(10),'') as qygm 
,replace(replace(t1.psckzh,chr(13),''),chr(10),'') as psckzh 
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx 
,t1.khdxdh as khdxdh 
,replace(replace(t1.xwdkbs,chr(13),''),chr(10),'') as xwdkbs 
,replace(replace(t1.ywpz,chr(13),''),chr(10),'') as ywpz 
,replace(replace(t1.dkfflb,chr(13),''),chr(10),'') as dkfflb 
,replace(replace(t1.hkfs,chr(13),''),chr(10),'') as hkfs 
,t1.bjyqts as bjyqts 
,t1.lxyqts as lxyqts 
,replace(replace(t1.jxfs,chr(13),''),chr(10),'') as jxfs 
,t1.qynll as qynll 
,t1.sxed as sxed 
,replace(replace(t1.lsdkbs,chr(13),''),chr(10),'') as lsdkbs 
,replace(replace(t1.jjh,chr(13),''),chr(10),'') as jjh 
,replace(replace(t1.jjzt,chr(13),''),chr(10),'') as jjzt 
,t1.zxll as zxll 
,t1.jzll as jzll 
,replace(replace(t1.llfdfs,chr(13),''),chr(10),'') as llfdfs 
,t1.jtlxsr as jtlxsr 
,t1.zyqrq as zyqrq 
,replace(replace(t1.hxbz,chr(13),''),chr(10),'') as hxbz 
,replace(replace(t1.sndkbz,chr(13),''),chr(10),'') as sndkbz 
,replace(replace(t1.lhdkbz,chr(13),''),chr(10),'') as lhdkbz 
,replace(replace(t1.wldkbz,chr(13),''),chr(10),'') as wldkbz 
,t1.se as se 
,t1.drlxsr as drlxsr 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from iol.pams_jxdx_dkzh t1 
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_dkzh.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes