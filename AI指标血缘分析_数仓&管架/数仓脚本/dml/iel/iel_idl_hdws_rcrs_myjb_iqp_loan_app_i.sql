: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_rcrs_myjb_iqp_loan_app_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_rcrs_myjb_iqp_loan_app.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.serno
,t1.apply_no
,t1.apply_date
,t1.cert_type
,t1.cert_code
,t1.cert_valid_end_date
,t1.cus_name
,t1.mobile_no
,t1.zm_auth_flag
,t1.hasjbadmit
,t1.approve_status
,t1.fail_reason
,t1.apply_amount
,t1.ruling_ir
,t1.risk_rating
,t1.solvency_ratings
,t1.change_result_reason
,t1.start_date
,t1.end_date
,t1.model_type
,t1.platform_access
,t1.cus_id
,t1.is_get_cus_code
,t1.inform_flag
,t1.is_check_inspect
,t1.prd_code
,t1.prd_name
,t1.last_advice_date
,t1.is_check_fqz
,t1.is_intercept
,t1.refuse_reason
,t1.sys_id
,t1.promote_reason
,t1.promote_type
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_rcrs_myjb_iqp_loan_app t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_rcrs_myjb_iqp_loan_app.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes