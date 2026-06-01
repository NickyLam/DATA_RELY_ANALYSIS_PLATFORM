: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_nbzz_gskhsxfsdmx_f
CreateDate: 20250307
FileName:   ${iel_data_path}/pams_nbzz_gskhsxfsdmx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.hth,chr(13),''),chr(10),'') as hth
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,replace(replace(t1.xwdkbs,chr(13),''),chr(10),'') as xwdkbs
,replace(replace(t1.gyljrywbz,chr(13),''),chr(10),'') as gyljrywbz
,replace(replace(t1.bwbs,chr(13),''),chr(10),'') as bwbs
,sxckye
,khsxckye

from ${iol_schema}.pams_nbzz_gskhsxfsdmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_gskhsxfsdmx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
