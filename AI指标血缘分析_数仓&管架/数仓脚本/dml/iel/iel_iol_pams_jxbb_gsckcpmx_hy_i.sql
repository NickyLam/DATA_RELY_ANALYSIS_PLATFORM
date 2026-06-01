: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_gsckcpmx_hy_i
CreateDate: 20240308
FileName:   ${iel_data_path}/pams_jxbb_gsckcpmx_hy.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,khdxdh
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,replace(replace(t1.cpbh,chr(13),''),chr(10),'') as cpbh
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.bzbs,chr(13),''),chr(10),'') as bzbs
,zhye
,zhyrjye
,zhjrjye
,zhnrjye
,ftpsy
,ftpsyylj
,ftpsyjlj
,ftpsynlj
,ftplxzc
,ftplxzcylj
,ftplxzcjlj
,ftplxzcnlj
,ftpsr
,ftpsrylj
,ftpsrjlj
,ftpsrnlj

from ${iol_schema}.pams_jxbb_gsckcpmx_hy t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_gsckcpmx_hy.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
