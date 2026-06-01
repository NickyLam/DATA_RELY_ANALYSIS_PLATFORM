: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_rcrs_intercept_rule_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_rcrs_intercept_rule.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.serno
,t1.cus_id
,t1.cus_name
,t1.cert_type
,t1.cert_code
,t1.input_date
,t1.update_date
,t1.tdkj_result_flag
,t1.yl_result_flag
,t1.hfw_result_flag
,t1.rule_result
,t1.lwhc_result_flag
,t1.sjbl_result_flag
,t1.idbl_result_flag
,t1.glr_result_flag
,t1.zzc_result_flag
,t1.bj_result_flag
,t1.ja_result_flag
,t1.bh_result_flag
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_rcrs_intercept_rule t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_rcrs_intercept_rule.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes