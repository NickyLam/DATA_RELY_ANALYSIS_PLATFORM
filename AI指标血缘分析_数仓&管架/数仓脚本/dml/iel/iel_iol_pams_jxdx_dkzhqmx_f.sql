: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_dkzhqmx_f
CreateDate: 20260309
FileName:   ${iel_data_path}/pams_jxdx_dkzhqmx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,qsrq
,jsrq
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.ywpz,chr(13),''),chr(10),'') as ywpz
,replace(replace(t1.yqkm,chr(13),''),chr(10),'') as yqkm
,khrq
,ffrq
,qxrq
,dqrq
,xhrq
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,nll
,qynll
,bjyqts
,lxyqts
,replace(replace(t1.zhzt,chr(13),''),chr(10),'') as zhzt
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh
,replace(replace(t1.hxbz,chr(13),''),chr(10),'') as hxbz
,replace(replace(t1.sndkbz,chr(13),''),chr(10),'') as sndkbz
,replace(replace(t1.lhdkbz,chr(13),''),chr(10),'') as lhdkbz
,replace(replace(t1.wldkbz,chr(13),''),chr(10),'') as wldkbz
,se
,drlxsr
,jqrq
,replace(replace(t1.xwdkbs,chr(13),''),chr(10),'') as xwdkbs
,yqxyss
,replace(replace(t1.jjzt,chr(13),''),chr(10),'') as jjzt
,replace(replace(t1.gylrzcplx,chr(13),''),chr(10),'') as gylrzcplx
,replace(replace(t1.zycklx,chr(13),''),chr(10),'') as zycklx

from ${iol_schema}.pams_jxdx_dkzhqmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_dkzhqmx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
