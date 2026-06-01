: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_nbzz_khzshz_f
CreateDate: 20240806
FileName:   ${iel_data_path}/pams_nbzz_khzshz.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jgkhdxdh
,khdxdh
,jxdxdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,shje
,yshje
,jshje
,nshje

from ${iol_schema}.pams_nbzz_khzshz t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_khzshz.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
