: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_sgdr_qdlzhbq_recal_i
CreateDate: 20250529
FileName:   ${iel_data_path}/pams_sgdr_qdlzhbq_recal.i.${batch_date}.dat
IF_mark:    i
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
,recal_dt

from ${iol_schema}.pams_sgdr_qdlzhbq_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_sgdr_qdlzhbq_recal.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
