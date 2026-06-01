: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_lhdk_intercept_result_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_lhdk_intercept_result.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.rule_no,chr(13),''),chr(10),'') as rule_no
,replace(replace(t.rule_desc,chr(13),''),chr(10),'') as rule_desc
,replace(replace(t.result,chr(13),''),chr(10),'') as result
,replace(replace(t.value,chr(13),''),chr(10),'') as value
,replace(replace(t.model_type,chr(13),''),chr(10),'') as model_type
,replace(replace(t.time,chr(13),''),chr(10),'') as time
,replace(replace(t.cert_code,chr(13),''),chr(10),'') as cert_code
,replace(replace(t.rule_type,chr(13),''),chr(10),'') as rule_type
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.RCRS_LHDK_INTERCEPT_RESULT t 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
and substr(replace(time,'-',''),1,8)='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_lhdk_intercept_result.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes