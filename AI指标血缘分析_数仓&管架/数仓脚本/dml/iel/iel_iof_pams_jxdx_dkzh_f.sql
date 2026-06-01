: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxdx_dkzh_f
CreateDate: 20240807
FileName:   ${iel_data_path}/pams_jxdx_dkzh.f.${batch_date}.dat
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
,replace(replace(t1.yqkm,chr(13),''),chr(10),'') as yqkm
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,khrq
,ffrq
,qxrq
,dqrq
,xhrq
,replace(replace(t1.zhzt,chr(13),''),chr(10),'') as zhzt
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,nll
,replace(replace(t1.llyhbz,chr(13),''),chr(10),'') as llyhbz
,llyhbl
,replace(replace(t1.pjh,chr(13),''),chr(10),'') as pjh
,replace(replace(t1.hth,chr(13),''),chr(10),'') as hth
,replace(replace(t1.dkfs,chr(13),''),chr(10),'') as dkfs
,dkje
,zhye
,zcye
,yqye
,daizhiye
,daizhangye
,bzjbl
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,tjrq
,replace(replace(t1.qygm,chr(13),''),chr(10),'') as qygm
,replace(replace(t1.psckzh,chr(13),''),chr(10),'') as psckzh
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx
,khdxdh
,replace(replace(t1.xwdkbs,chr(13),''),chr(10),'') as xwdkbs
,replace(replace(t1.ywpz,chr(13),''),chr(10),'') as ywpz
,replace(replace(t1.dkfflb,chr(13),''),chr(10),'') as dkfflb
,replace(replace(t1.hkfs,chr(13),''),chr(10),'') as hkfs
,bjyqts
,lxyqts
,replace(replace(t1.jxfs,chr(13),''),chr(10),'') as jxfs
,qynll
,sxed
,replace(replace(t1.lsdkbs,chr(13),''),chr(10),'') as lsdkbs
,replace(replace(t1.jjh,chr(13),''),chr(10),'') as jjh
,replace(replace(t1.jjzt,chr(13),''),chr(10),'') as jjzt
,zxll
,jzll
,replace(replace(t1.llfdfs,chr(13),''),chr(10),'') as llfdfs
,jtlxsr
,zyqrq
,replace(replace(t1.hxbz,chr(13),''),chr(10),'') as hxbz
,replace(replace(t1.sndkbz,chr(13),''),chr(10),'') as sndkbz
,replace(replace(t1.lhdkbz,chr(13),''),chr(10),'') as lhdkbz
,replace(replace(t1.wldkbz,chr(13),''),chr(10),'') as wldkbz
,se
,drlxsr
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.zqjh,chr(13),''),chr(10),'') as zqjh

from ${iol_schema}.pams_jxdx_dkzh t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_dkzh.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
