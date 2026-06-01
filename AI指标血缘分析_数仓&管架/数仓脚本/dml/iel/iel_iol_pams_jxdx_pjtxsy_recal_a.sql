: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_pjtxsy_recal_a
CreateDate: 20250609
FileName:   ${iel_data_path}/pams_jxdx_pjtxsy_recal.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,recal_dt
,tjrq
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.pch,chr(13),''),chr(10),'') as pch
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.pjh,chr(13),''),chr(10),'') as pjh
,replace(replace(t1.zqjh,chr(13),''),chr(10),'') as zqjh
,pmje
,replace(replace(t1.txsqr,chr(13),''),chr(10),'') as txsqr
,txll
,txrq
,dqrq
,txlxsr
,replace(replace(t1.ldjg,chr(13),''),chr(10),'') as ldjg
,ldll
,zhfpsy
,fhfpsy
,tzjjx
,zhtzhsy
,fhtzhsy
,shtxlxsr
,replace(replace(t1.cprmc,chr(13),''),chr(10),'') as cprmc

from ${iol_schema}.pams_jxdx_pjtxsy_recal t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_pjtxsy_recal.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
