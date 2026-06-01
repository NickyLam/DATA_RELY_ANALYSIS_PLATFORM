: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_nbzz_zgxtmx_i
CreateDate: 20251107
FileName:   ${iel_data_path}/pams_nbzz_zgxtmx.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,khdxdh
,jgkhdxdh
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,zhye
,zlbl
,hyye
,hyylj
,hyjlj
,hynlj
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh

from ${iol_schema}.pams_nbzz_zgxtmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_zgxtmx.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
