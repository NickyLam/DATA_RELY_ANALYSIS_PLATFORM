: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_nbzz_dklrmx_f
CreateDate: 20251103
FileName:   ${iel_data_path}/pams_nbzz_dklrmx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,khdxdh
,jxdxdh
,jgkhdxdh
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.ywpz,chr(13),''),chr(10),'') as ywpz
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh
,replace(replace(t1.zhhm,chr(13),''),chr(10),'') as zhhm
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,nll
,zyjg
,ftplc
,zlbl
,zhye
,hyye
,hyylj
,hyjlj
,hybnlj
,hynlj
,replace(replace(t1.wjfl,chr(13),''),chr(10),'') as wjfl
,khdkje
,ftpzycb
,ftpzycbylj
,ftpzycbjlj
,ftpzycbbnlj
,ftpzycbnlj
,ftplxsr
,ftplxsrylj
,ftplxsrjlj
,ftplxsrbnlj
,ftplxsrnlj
,ftpsy
,ftpsyylj
,ftpsyjlj
,ftpsybnlj
,ftpsynlj
,replace(replace(t1.hxbz,chr(13),''),chr(10),'') as hxbz
,replace(replace(t1.xwdkbs,chr(13),''),chr(10),'') as xwdkbs
,replace(replace(t1.zxzdkztdm,chr(13),''),chr(10),'') as zxzdkztdm

from ${iol_schema}.pams_nbzz_dklrmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_dklrmx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
