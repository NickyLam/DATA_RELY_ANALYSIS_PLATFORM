: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_rcrs_intercept_rule_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_rcrs_intercept_rule.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t1.cus_id,chr(13),''),chr(10),'') as cus_id
,replace(replace(t1.cus_name,chr(13),''),chr(10),'') as cus_name
,replace(replace(t1.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t1.cert_code,chr(13),''),chr(10),'') as cert_code
,replace(replace(t1.input_date,chr(13),''),chr(10),'') as input_date
,replace(replace(t1.update_date,chr(13),''),chr(10),'') as update_date
,replace(replace(t1.tdkj_result_flag,chr(13),''),chr(10),'') as tdkj_result_flag
,replace(replace(t1.yl_result_flag,chr(13),''),chr(10),'') as yl_result_flag
,replace(replace(t1.hfw_result_flag,chr(13),''),chr(10),'') as hfw_result_flag
,replace(replace(t1.rule_result,chr(13),''),chr(10),'') as rule_result
,replace(replace(t1.lwhc_result_flag,chr(13),''),chr(10),'') as lwhc_result_flag
 from iol.rcrs_intercept_rule T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') and to_char(to_date(substr(update_date,0,10),'yyyy-mm-dd'),'yyyymmdd')='${batch_date}' and substr (serno,0,4)='MYJB';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_rcrs_intercept_rule.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes