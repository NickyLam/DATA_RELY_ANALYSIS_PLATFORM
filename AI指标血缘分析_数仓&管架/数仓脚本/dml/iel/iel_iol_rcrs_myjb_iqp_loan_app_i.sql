: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_myjb_iqp_loan_app_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_myjb_iqp_loan_app.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.apply_no,chr(13),''),chr(10),'') as apply_no
,replace(replace(t.apply_date,chr(13),''),chr(10),'') as apply_date
,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t.cert_code,chr(13),''),chr(10),'') as cert_code
,replace(replace(t.cert_valid_end_date,chr(13),''),chr(10),'') as cert_valid_end_date
,replace(replace(t.cus_name,chr(13),''),chr(10),'') as cus_name
,replace(replace(t.mobile_no,chr(13),''),chr(10),'') as mobile_no
,replace(replace(t.zm_auth_flag,chr(13),''),chr(10),'') as zm_auth_flag
,replace(replace(t.hasjbadmit,chr(13),''),chr(10),'') as hasjbadmit
,replace(replace(t.approve_status,chr(13),''),chr(10),'') as approve_status
,replace(replace(t.fail_reason,chr(13),''),chr(10),'') as fail_reason
,t.apply_amount as apply_amount
,t.ruling_ir as ruling_ir
,replace(replace(t.risk_rating,chr(13),''),chr(10),'') as risk_rating
,replace(replace(t.solvency_ratings,chr(13),''),chr(10),'') as solvency_ratings
,replace(replace(t.change_result_reason,chr(13),''),chr(10),'') as change_result_reason
,replace(replace(t.start_date,chr(13),''),chr(10),'') as start_date
,replace(replace(t.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t.model_type,chr(13),''),chr(10),'') as model_type
,replace(replace(t.platform_access,chr(13),''),chr(10),'') as platform_access
,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
,replace(replace(t.is_check_inspect,chr(13),''),chr(10),'') as is_check_inspect
,replace(replace(t.is_get_cus_code,chr(13),''),chr(10),'') as is_get_cus_code
,replace(replace(t.inform_flag,chr(13),''),chr(10),'') as inform_flag
,replace(replace(t.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t.prd_name,chr(13),''),chr(10),'') as prd_name
,replace(replace(t.last_advice_date,chr(13),''),chr(10),'') as last_advice_date
,replace(replace(t.is_check_fqz,chr(13),''),chr(10),'') as is_check_fqz
,replace(replace(t.is_intercept,chr(13),''),chr(10),'') as is_intercept
,replace(replace(t.refuse_reason,chr(13),''),chr(10),'') as refuse_reason
,replace(replace(t.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t.promote_reason,chr(13),''),chr(10),'') as promote_reason
,replace(replace(t.promote_type,chr(13),''),chr(10),'') as promote_type
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.RCRS_MYJB_IQP_LOAN_APP t 
where to_char(to_date(apply_date,'yyyy-MM-dd'),'yyyymmdd')='${batch_date}'
and start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_myjb_iqp_loan_app.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes