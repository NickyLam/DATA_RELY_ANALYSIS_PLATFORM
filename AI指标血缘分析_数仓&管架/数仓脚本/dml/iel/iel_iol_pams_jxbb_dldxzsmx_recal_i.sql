: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_dldxzsmx_recal_i
CreateDate: 20250529
FileName:   ${iel_data_path}/pams_jxbb_dldxzsmx_recal.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,recal_dt
,replace(replace(t1.sjly,chr(13),''),chr(10),'') as sjly
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,khdxdh
,jgkhdxdh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.tadm,chr(13),''),chr(10),'') as tadm
,zlbl
,zs
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,replace(replace(t1.ssjgdh,chr(13),''),chr(10),'') as ssjgdh
,replace(replace(t1.sshydh,chr(13),''),chr(10),'') as sshydh

from ${iol_schema}.pams_jxbb_dldxzsmx_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_dldxzsmx_recal.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
