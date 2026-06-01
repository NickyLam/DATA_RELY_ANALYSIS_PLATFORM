: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_nbzz_dfgzkhmx_i
CreateDate: 20250620
FileName:   ${iel_data_path}/pams_nbzz_dfgzkhmx.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.sjbh,chr(13),''),chr(10),'') as sjbh
,replace(replace(t1.zckhh,chr(13),''),chr(10),'') as zckhh
,replace(replace(t1.khdbbz,chr(13),''),chr(10),'') as khdbbz
,replace(replace(t1.zczhdh,chr(13),''),chr(10),'') as zczhdh
,replace(replace(t1.zczhmc,chr(13),''),chr(10),'') as zczhmc
,replace(replace(t1.dfly,chr(13),''),chr(10),'') as dfly
,replace(replace(t1.zrkhh,chr(13),''),chr(10),'') as zrkhh
,zrjyje
,fpje
,jyrq
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,zlbl
,khdxdh
,jgkhdxdh
,replace(replace(t1.jddbbz,chr(13),''),chr(10),'') as jddbbz

from ${iol_schema}.pams_nbzz_dfgzkhmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_dfgzkhmx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
