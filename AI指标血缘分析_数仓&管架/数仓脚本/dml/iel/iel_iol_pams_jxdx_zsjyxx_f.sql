: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_zsjyxx_f
CreateDate: 20240319
FileName:   ${iel_data_path}/pams_jxdx_zsjyxx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,jyrq
,replace(replace(t1.jylsh,chr(13),''),chr(10),'') as jylsh
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.ywxzbz,chr(13),''),chr(10),'') as ywxzbz
,replace(replace(t1.ywbh,chr(13),''),chr(10),'') as ywbh
,replace(replace(t1.jzjgdh,chr(13),''),chr(10),'') as jzjgdh
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.sfdm,chr(13),''),chr(10),'') as sfdm
,replace(replace(t1.sfmc,chr(13),''),chr(10),'') as sfmc
,jyje
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.ywtxbh,chr(13),''),chr(10),'') as ywtxbh
,replace(replace(t1.bzcpbh,chr(13),''),chr(10),'') as bzcpbh
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx
,khdxdh
,tjrq
,replace(replace(t1.khlx,chr(13),''),chr(10),'') as khlx
,replace(replace(t1.sfdjh,chr(13),''),chr(10),'') as sfdjh
,replace(replace(t1.txlsh,chr(13),''),chr(10),'') as txlsh
,replace(replace(t1.qjlsh,chr(13),''),chr(10),'') as qjlsh

from ${iol_schema}.pams_jxdx_zsjyxx t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_zsjyxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
