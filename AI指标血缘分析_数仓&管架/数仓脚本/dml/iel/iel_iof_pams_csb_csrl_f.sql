: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_csb_csrl_f
CreateDate: 20250721
FileName:   ${iel_data_path}/pams_csb_csrl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.xqj,chr(13),''),chr(10),'') as xqj
,replace(replace(t1.sfcs,chr(13),''),chr(10),'') as sfcs
,csts
,csqsrq
,csjsrq
,replace(replace(t1.rqlx,chr(13),''),chr(10),'') as rqlx
,dqcsrq
,replace(replace(t1.cszt,chr(13),''),chr(10),'') as cszt

from ${iol_schema}.pams_csb_csrl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_csb_csrl.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
