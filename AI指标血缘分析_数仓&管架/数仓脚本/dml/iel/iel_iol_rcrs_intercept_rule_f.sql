: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_intercept_rule_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_intercept_rule.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
,replace(replace(t.cus_name,chr(13),''),chr(10),'') as cus_name
,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t.cert_code,chr(13),''),chr(10),'') as cert_code
,replace(replace(t.input_date,chr(13),''),chr(10),'') as input_date
,replace(replace(t.update_date,chr(13),''),chr(10),'') as update_date
,replace(replace(t.tdkj_result_flag,chr(13),''),chr(10),'') as tdkj_result_flag
,replace(replace(t.yl_result_flag,chr(13),''),chr(10),'') as yl_result_flag
,replace(replace(t.hfw_result_flag,chr(13),''),chr(10),'') as hfw_result_flag
,replace(replace(t.rule_result,chr(13),''),chr(10),'') as rule_result
,replace(replace(t.lwhc_result_flag,chr(13),''),chr(10),'') as lwhc_result_flag
,replace(replace(t.sjbl_result_flag,chr(13),''),chr(10),'') as sjbl_result_flag
,replace(replace(t.idbl_result_flag,chr(13),''),chr(10),'') as idbl_result_flag
,replace(replace(t.glr_result_flag,chr(13),''),chr(10),'') as glr_result_flag
,replace(replace(t.zzc_result_flag,chr(13),''),chr(10),'') as zzc_result_flag
,replace(replace(t.bj_result_flag,chr(13),''),chr(10),'') as bj_result_flag
,replace(replace(t.ja_result_flag,chr(13),''),chr(10),'') as ja_result_flag
,replace(replace(t.bh_result_flag,chr(13),''),chr(10),'') as bh_result_flag
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_intercept_rule t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_intercept_rule.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes