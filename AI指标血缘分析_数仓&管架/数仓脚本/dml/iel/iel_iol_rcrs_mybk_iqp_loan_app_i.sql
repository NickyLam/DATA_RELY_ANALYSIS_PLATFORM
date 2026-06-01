: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_mybk_iqp_loan_app_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_mybk_iqp_loan_app.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.apply_no,chr(13),''),chr(10),'') as apply_no
,replace(replace(t.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t.prd_name,chr(13),''),chr(10),'') as prd_name
,replace(replace(t.apply_date,chr(13),''),chr(10),'') as apply_date
,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t.cert_code,chr(13),''),chr(10),'') as cert_code
,replace(replace(t.cus_name,chr(13),''),chr(10),'') as cus_name
,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
,replace(replace(t.is_get_cus_code,chr(13),''),chr(10),'') as is_get_cus_code
,replace(replace(t.platform_access,chr(13),''),chr(10),'') as platform_access
,t.platform_admit as platform_admit
,t.platform_rate_limit as platform_rate_limit
,t.platform_rate_bottom as platform_rate_bottom
,replace(replace(t.fail_reason,chr(13),''),chr(10),'') as fail_reason
,t.apply_amount as apply_amount
,t.ruling_ir as ruling_ir
,t.is_check_inspect as is_check_inspect
,replace(replace(t.start_date,chr(13),''),chr(10),'') as start_date
,replace(replace(t.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t.approve_status,chr(13),''),chr(10),'') as approve_status
,replace(replace(t.inform_flag,chr(13),''),chr(10),'') as inform_flag
,replace(replace(t.inform_final_flag,chr(13),''),chr(10),'') as inform_final_flag
,replace(replace(t.last_advice_date,chr(13),''),chr(10),'') as last_advice_date
,replace(replace(t.input_id,chr(13),''),chr(10),'') as input_id
,replace(replace(t.input_br_id,chr(13),''),chr(10),'') as input_br_id
,replace(replace(t.businessmodel,chr(13),''),chr(10),'') as businessmodel
,replace(replace(t.target_jy_flag2,chr(13),''),chr(10),'') as target_jy_flag2
,replace(replace(t.target_jy_flag3,chr(13),''),chr(10),'') as target_jy_flag3
,replace(replace(t.farmer_flag,chr(13),''),chr(10),'') as farmer_flag
,replace(replace(t.is_cs_check_rule,chr(13),''),chr(10),'') as is_cs_check_rule
,replace(replace(t.is_zs_check_rule,chr(13),''),chr(10),'') as is_zs_check_rule
,replace(replace(t.refuse_code,chr(13),''),chr(10),'') as refuse_code
,replace(replace(t.ack_msg,chr(13),''),chr(10),'') as ack_msg
,replace(replace(t.is_check_rule,chr(13),''),chr(10),'') as is_check_rule
,replace(replace(t.cs_approve_status,chr(13),''),chr(10),'') as cs_approve_status
,replace(replace(t.request_id,chr(13),''),chr(10),'') as request_id
,replace(replace(t.is_cs_intercept,chr(13),''),chr(10),'') as is_cs_intercept
,replace(replace(t.is_zs_intercept,chr(13),''),chr(10),'') as is_zs_intercept
,replace(replace(t.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t.zs_request_id,chr(13),''),chr(10),'') as zs_request_id
,replace(replace(t.cs_sys_id,chr(13),''),chr(10),'') as cs_sys_id
,replace(replace(t.zs_sys_id,chr(13),''),chr(10),'') as zs_sys_id
,replace(replace(t.loan_ar,chr(13),''),chr(10),'') as loan_ar
,replace(replace(t.ar_no,chr(13),''),chr(10),'') as ar_no
,replace(replace(t.bsn_type,chr(13),''),chr(10),'') as bsn_type
,replace(replace(t.act_cert_type,chr(13),''),chr(10),'') as act_cert_type
,replace(replace(t.act_cert_no,chr(13),''),chr(10),'') as act_cert_no
,replace(replace(t.act_cert_name,chr(13),''),chr(10),'') as act_cert_name
,replace(replace(t.staff_num,chr(13),''),chr(10),'') as staff_num
,replace(replace(t.income,chr(13),''),chr(10),'') as income
,t.lpr_limit as lpr_limit
,t.lpr_bottom as lpr_bottom
,t.float_rate_bp_limit as float_rate_bp_limit
,t.float_rate_bp_bottom as float_rate_bp_bottom
,replace(replace(t.rate_float_mode_limit,chr(13),''),chr(10),'') as rate_float_mode_limit
,replace(replace(t.rate_float_mode_bottom,chr(13),''),chr(10),'') as rate_float_mode_bottom
,replace(replace(t.apply_times,chr(13),''),chr(10),'') as apply_times
,replace(replace(t.cust_inst,chr(13),''),chr(10),'') as cust_inst
,replace(replace(t.cs_app_result,chr(13),''),chr(10),'') as cs_app_result
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.RCRS_MYBK_IQP_LOAN_APP t 
where to_char(to_date(apply_date,'yyyy-MM-dd'),'yyyymmdd')='${batch_date}'
and start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_mybk_iqp_loan_app.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes