: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_rcrs_mybk_lhdk_rule_result_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_rcrs_mybk_lhdk_rule_result.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t1.rule_no,chr(13),''),chr(10),'') as rule_no
,replace(replace(t1.rule_desc,chr(13),''),chr(10),'') as rule_desc
,replace(replace(t1.result,chr(13),''),chr(10),'') as result
,replace(replace(t1.value,chr(13),''),chr(10),'') as value
,replace(replace(t1.model_type,chr(13),''),chr(10),'') as model_type
,replace(replace(t1.time,chr(13),''),chr(10),'') as time
,replace(replace(t1.cert_code,chr(13),''),chr(10),'') as cert_code
,replace(replace(t1.rule_type,chr(13),''),chr(10),'') as rule_type
 from iol.rcrs_mybk_lhdk_rule_result T1
where substr(replace(time,'-',''),1,8)='${batch_date}' and start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_rcrs_mybk_lhdk_rule_result.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes