: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_osbs_ope_request_flow_i
CreateDate: 20230630
FileName:   ${iel_data_path}/osbs_ope_request_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.orf_flowno,chr(13),''),chr(10),'') as orf_flowno
,replace(replace(t1.orf_date,chr(13),''),chr(10),'') as orf_date
,replace(replace(t1.orf_time,chr(13),''),chr(10),'') as orf_time
,replace(replace(t1.orf_ecifno,chr(13),''),chr(10),'') as orf_ecifno
,replace(replace(t1.orf_activeid,chr(13),''),chr(10),'') as orf_activeid
,replace(replace(t1.orf_extend1,chr(13),''),chr(10),'') as orf_extend1
,replace(replace(t1.orf_extend2,chr(13),''),chr(10),'') as orf_extend2
,replace(replace(t1.orf_extend3,chr(13),''),chr(10),'') as orf_extend3

from ${iol_schema}.osbs_ope_request_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_ope_request_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
