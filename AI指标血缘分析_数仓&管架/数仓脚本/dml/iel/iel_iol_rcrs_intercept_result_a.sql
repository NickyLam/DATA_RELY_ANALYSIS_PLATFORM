: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_intercept_result_a
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_intercept_result.i.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.result_id,chr(13),''),chr(10),'') as result_id
,replace(replace(t.prj_id,chr(13),''),chr(10),'') as prj_id
,replace(replace(t.item_id,chr(13),''),chr(10),'') as item_id
,replace(replace(t.intercept_result,chr(13),''),chr(10),'') as intercept_result
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.result_type,chr(13),''),chr(10),'') as result_type
,replace(replace(t.input_date,chr(13),''),chr(10),'') as input_date
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_intercept_result t " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_intercept_result.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes