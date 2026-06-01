: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_nbzz_ckgjywmx_a
CreateDate: 20251127
FileName:   ${iel_data_path}/pams_nbzz_ckgjywmx.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,tjrq
,jxdxdh
,khdxdh
,jgkhdxdh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,ckgjtfl
,replace(replace(t1.jjh,chr(13),''),chr(10),'') as jjh
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,ybje
,zrmbhl

from ${iol_schema}.pams_nbzz_ckgjywmx t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_ckgjywmx.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
