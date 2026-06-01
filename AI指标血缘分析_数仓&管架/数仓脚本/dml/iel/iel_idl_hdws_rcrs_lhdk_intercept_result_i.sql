: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_rcrs_lhdk_intercept_result_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_rcrs_lhdk_intercept_result.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.serno
,t1.rule_no
,t1.rule_desc
,t1.result
,t1.value
,t1.model_type
,t1.time
,t1.cert_code
,t1.rule_type
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_rcrs_lhdk_intercept_result t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_rcrs_lhdk_intercept_result.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes