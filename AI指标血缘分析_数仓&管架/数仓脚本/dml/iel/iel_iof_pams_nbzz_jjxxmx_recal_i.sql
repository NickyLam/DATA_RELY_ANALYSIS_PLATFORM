: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_nbzz_jjxxmx_recal_i
CreateDate: 20251107
FileName:   ${iel_data_path}/pams_nbzz_jjxxmx_recal.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,recal_dt
,tjrq
,jxdxdh
,khdxdh
,jgkhdxdh
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.cpdm,chr(13),''),chr(10),'') as cpdm
,replace(replace(t1.cpsx,chr(13),''),chr(10),'') as cpsx
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,zlbl
,zhye
,hyye
,hyylj
,hyjlj
,hynlj
,fe
,hyfe
,hyfeylj
,hyfejlj
,hyfenlj
,replace(replace(t1.ymjjbz,chr(13),''),chr(10),'') as ymjjbz
,replace(replace(t1.ztbz,chr(13),''),chr(10),'') as ztbz

from ${iol_schema}.pams_nbzz_jjxxmx_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_jjxxmx_recal.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
