: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_lsb_dkzh_f
CreateDate: 20231122
FileName:   ${iel_data_path}/pams_lsb_dkzh.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,tjrq
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh
,replace(replace(t1.zhhm,chr(13),''),chr(10),'') as zhhm
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.yqkm,chr(13),''),chr(10),'') as yqkm
,replace(replace(t1.daizhikm,chr(13),''),chr(10),'') as daizhikm
,replace(replace(t1.daizhangkm,chr(13),''),chr(10),'') as daizhangkm
,replace(replace(t1.fhdh,chr(13),''),chr(10),'') as fhdh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,khrq
,ffrq
,qxrq
,dqrq
,xhrq
,replace(replace(t1.zhzt,chr(13),''),chr(10),'') as zhzt
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,replace(replace(t1.lldh,chr(13),''),chr(10),'') as lldh
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
,yswslx
,bzjbl
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,replace(replace(t1.txbz,chr(13),''),chr(10),'') as txbz
,replace(replace(t1.czyh,chr(13),''),chr(10),'') as czyh
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx
,khdxdh
,zhnrjye
,khdkje
,khdkye
,replace(replace(t1.qygm,chr(13),''),chr(10),'') as qygm
,replace(replace(t1.gdzl,chr(13),''),chr(10),'') as gdzl
,replace(replace(t1.sjfl,chr(13),''),chr(10),'') as sjfl
,replace(replace(t1.wjfl,chr(13),''),chr(10),'') as wjfl
,replace(replace(t1.ffbs,chr(13),''),chr(10),'') as ffbs
,replace(replace(t1.dqbs,chr(13),''),chr(10),'') as dqbs
,replace(replace(t1.zhyeqj,chr(13),''),chr(10),'') as zhyeqj
,replace(replace(t1.khyeqj,chr(13),''),chr(10),'') as khyeqj
,replace(replace(t1.dkjeqj,chr(13),''),chr(10),'') as dkjeqj
,replace(replace(t1.khjeqj,chr(13),''),chr(10),'') as khjeqj
,replace(replace(t1.yqtsqj,chr(13),''),chr(10),'') as yqtsqj
,replace(replace(t1.zrdkjeqj,chr(13),''),chr(10),'') as zrdkjeqj
,replace(replace(t1.xcbldkbs,chr(13),''),chr(10),'') as xcbldkbs
,replace(replace(t1.xwdkbs,chr(13),''),chr(10),'') as xwdkbs
,replace(replace(t1.sndkbs,chr(13),''),chr(10),'') as sndkbs
,replace(replace(t1.xcdkbs,chr(13),''),chr(10),'') as xcdkbs
,replace(replace(t1.yxblbs,chr(13),''),chr(10),'') as yxblbs
,replace(replace(t1.ncwjfl,chr(13),''),chr(10),'') as ncwjfl
,replace(replace(t1.qxtsqj,chr(13),''),chr(10),'') as qxtsqj
,replace(replace(t1.ncqxtsqj,chr(13),''),chr(10),'') as ncqxtsqj
,replace(replace(t1.llqj,chr(13),''),chr(10),'') as llqj
,replace(replace(t1.zgdkbs,chr(13),''),chr(10),'') as zgdkbs
,replace(replace(t1.stdkbs,chr(13),''),chr(10),'') as stdkbs
,replace(replace(t1.fpdkbs,chr(13),''),chr(10),'') as fpdkbs
,replace(replace(t1.mzdkbs,chr(13),''),chr(10),'') as mzdkbs
,replace(replace(t1.qxbs,chr(13),''),chr(10),'') as qxbs
,replace(replace(t1.yswslxqj,chr(13),''),chr(10),'') as yswslxqj
,replace(replace(t1.ywpz,chr(13),''),chr(10),'') as ywpz
,replace(replace(t1.dkxz,chr(13),''),chr(10),'') as dkxz
,zyqrq
,zfyjrq
,replace(replace(t1.dkfflb,chr(13),''),chr(10),'') as dkfflb
,replace(replace(t1.hkfs,chr(13),''),chr(10),'') as hkfs
,bjyqts
,lxyqts
,replace(replace(t1.jxfs,chr(13),''),chr(10),'') as jxfs
,sxed
,qynll
,replace(replace(t1.khkhbs,chr(13),''),chr(10),'') as khkhbs
,replace(replace(t1.xcfyjdkbs,chr(13),''),chr(10),'') as xcfyjdkbs
,replace(replace(t1.xcyqdkbs,chr(13),''),chr(10),'') as xcyqdkbs
,replace(replace(t1.bmkkh,chr(13),''),chr(10),'') as bmkkh
,zhjrjye
,zhyrjye
,replace(replace(t1.lxdbs,chr(13),''),chr(10),'') as lxdbs
,replace(replace(t1.hxbz,chr(13),''),chr(10),'') as hxbz
,replace(replace(t1.lsdkbs,chr(13),''),chr(10),'') as lsdkbs
,replace(replace(t1.xsbz,chr(13),''),chr(10),'') as xsbz
,jqrq
,replace(replace(t1.sfzydk,chr(13),''),chr(10),'') as sfzydk
,replace(replace(t1.fdbptdk,chr(13),''),chr(10),'') as fdbptdk
,replace(replace(t1.ypbzjblqj,chr(13),''),chr(10),'') as ypbzjblqj

from ${iol_schema}.pams_lsb_dkzh t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_lsb_dkzh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
