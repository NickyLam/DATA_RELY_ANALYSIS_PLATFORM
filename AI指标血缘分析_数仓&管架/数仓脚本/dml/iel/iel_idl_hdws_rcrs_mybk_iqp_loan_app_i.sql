: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_rcrs_mybk_iqp_loan_app_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_rcrs_mybk_iqp_loan_app.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.serno
,t1.apply_no
,t1.prd_code
,t1.prd_name
,t1.apply_date
,t1.cert_type
,t1.cert_code
,t1.cus_name
,t1.cus_id
,t1.is_get_cus_code
,t1.platform_access
,t1.platform_admit
,t1.platform_rate_limit
,t1.platform_rate_bottom
,t1.fail_reason
,t1.apply_amount
,t1.ruling_ir
,t1.is_check_inspect
,t1.start_date
,t1.end_date
,t1.approve_status
,t1.inform_flag
,t1.inform_final_flag
,t1.last_advice_date
,t1.input_id
,t1.input_br_id
,t1.businessmodel
,t1.target_jy_flag2
,t1.target_jy_flag3
,t1.farmer_flag
,t1.is_cs_check_rule
,t1.is_zs_check_rule
,t1.refuse_code
,t1.ack_msg
,t1.is_check_rule
,t1.cs_approve_status
,t1.request_id
,t1.is_cs_intercept
,t1.is_zs_intercept
,t1.mobile
,t1.zs_request_id
,t1.cs_sys_id
,t1.zs_sys_id
,t1.loan_ar
,t1.ar_no
,t1.bsn_type
,t1.act_cert_type
,t1.act_cert_no
,t1.act_cert_name
,t1.staff_num
,t1.income
,t1.lpr_limit
,t1.lpr_bottom
,t1.float_rate_bp_limit
,t1.float_rate_bp_bottom
,t1.rate_float_mode_limit
,t1.rate_float_mode_bottom
,t1.apply_times
,t1.cust_inst
,t1.cs_app_result
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_rcrs_mybk_iqp_loan_app t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_rcrs_mybk_iqp_loan_app.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes