: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_kmzz_f
CreateDate: 20260403
FileName:   ${iel_data_path}/pams_jxdx_kmzz.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,zzrq
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,jffse
,dffse
,sqjfye
,sqdfye
,jfye
,dfye
,kmye
,drkmye
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph

from ${iol_schema}.pams_jxdx_kmzz t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_kmzz.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
