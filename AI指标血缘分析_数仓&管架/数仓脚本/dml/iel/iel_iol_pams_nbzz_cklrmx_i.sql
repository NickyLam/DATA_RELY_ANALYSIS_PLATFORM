: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_nbzz_cklrmx_i
CreateDate: 20260403
FileName:   ${iel_data_path}/pams_nbzz_cklrmx.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,khdxdh
,jxdxdh
,jgkhdxdh
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,replace(replace(t1.sfhx,chr(13),''),chr(10),'') as sfhx
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh
,replace(replace(t1.zhhm,chr(13),''),chr(10),'') as zhhm
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,ftplc
,nll
,zyjg
,zlbl
,zhye
,hyye
,hyylj
,hyjlj
,hybnlj
,hynlj
,ftpsr
,ftpsrylj
,ftpsrjlj
,ftpsrbnlj
,ftpsrnlj
,ftplxzc
,ftplxzcylj
,ftplxzcjlj
,ftplxzcbnlj
,ftplxzcnlj
,ftpsy
,ftpsyylj
,ftpsyjlj
,ftpsybnlj
,ftpsynlj
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.dnxkhbs,chr(13),''),chr(10),'') as dnxkhbs

from ${iol_schema}.pams_nbzz_cklrmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_cklrmx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
