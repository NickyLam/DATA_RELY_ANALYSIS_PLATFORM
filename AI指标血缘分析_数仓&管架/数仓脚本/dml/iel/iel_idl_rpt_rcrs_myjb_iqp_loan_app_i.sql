: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_rcrs_myjb_iqp_loan_app_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_rcrs_myjb_iqp_loan_app.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t1.apply_no,chr(13),''),chr(10),'') as apply_no
,replace(replace(t1.apply_date,chr(13),''),chr(10),'') as apply_date
,replace(replace(t1.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t1.cert_code,chr(13),''),chr(10),'') as cert_code
,replace(replace(t1.cert_valid_end_date,chr(13),''),chr(10),'') as cert_valid_end_date
,replace(replace(t1.cus_name,chr(13),''),chr(10),'') as cus_name
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no
,replace(replace(t1.zm_auth_flag,chr(13),''),chr(10),'') as zm_auth_flag
,replace(replace(t1.hasjbadmit,chr(13),''),chr(10),'') as hasjbadmit
,replace(replace(t1.approve_status,chr(13),''),chr(10),'') as approve_status
,replace(replace(t1.fail_reason,chr(13),''),chr(10),'') as fail_reason
,t1.apply_amount as apply_amount
,t1.ruling_ir as ruling_ir
,replace(replace(t1.risk_rating,chr(13),''),chr(10),'') as risk_rating
,replace(replace(t1.solvency_ratings,chr(13),''),chr(10),'') as solvency_ratings
,replace(replace(t1.change_result_reason,chr(13),''),chr(10),'') as change_result_reason
,replace(replace(t1.start_date,chr(13),''),chr(10),'') as start_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.model_type,chr(13),''),chr(10),'') as model_type
,replace(replace(t1.platform_access,chr(13),''),chr(10),'') as platform_access
,replace(replace(t1.cus_id,chr(13),''),chr(10),'') as cus_id
,replace(replace(t1.is_get_cus_code,chr(13),''),chr(10),'') as is_get_cus_code
,replace(replace(t1.inform_flag,chr(13),''),chr(10),'') as inform_flag
,replace(replace(t1.is_check_inspect,chr(13),''),chr(10),'') as is_check_inspect
,replace(replace(t1.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t1.prd_name,chr(13),''),chr(10),'') as prd_name
,replace(replace(t1.last_advice_date,chr(13),''),chr(10),'') as last_advice_date
,replace(replace(t1.is_check_fqz,chr(13),''),chr(10),'') as is_check_fqz
,replace(replace(t1.is_intercept,chr(13),''),chr(10),'') as is_intercept
,replace(replace(t1.refuse_reason,chr(13),''),chr(10),'') as refuse_reason
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
 from iol.rcrs_myjb_iqp_loan_app T1
where to_char(to_date(apply_date,'yyyy-mm-dd'),'yyyymmdd')='${batch_date}' and start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_rcrs_myjb_iqp_loan_app.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes