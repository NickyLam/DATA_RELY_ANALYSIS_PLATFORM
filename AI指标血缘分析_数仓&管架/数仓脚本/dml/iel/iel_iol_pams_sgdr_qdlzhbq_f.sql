: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_sgdr_qdlzhbq_f
CreateDate: 20241018
FileName:   ${iel_data_path}/pams_sgdr_qdlzhbq.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.kh,chr(13),''),chr(10),'') as kh
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.qdzhflbs,chr(13),''),chr(10),'') as qdzhflbs
,replace(replace(t1.bqsccjsj,chr(13),''),chr(10),'') as bqsccjsj

from ${iol_schema}.pams_sgdr_qdlzhbq t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_sgdr_qdlzhbq.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
