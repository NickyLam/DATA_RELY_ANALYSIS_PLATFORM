: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxdx_dkypjemx_f
CreateDate: 20240806
FileName:   ${iel_data_path}/pams_jxdx_dkypjemx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,bzjje
,cdje

from ${iol_schema}.pams_jxdx_dkypjemx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_dkypjemx.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
