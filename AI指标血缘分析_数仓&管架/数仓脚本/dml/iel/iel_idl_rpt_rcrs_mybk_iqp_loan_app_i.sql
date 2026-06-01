: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_rcrs_mybk_iqp_loan_app_i
CreateDate: 20220306
FileName:   ${iel_data_path}/rpt_rcrs_mybk_iqp_loan_app.i.${batch_date}.dat
IF_mark:    i
Logs:
   sundexin
' \
        query="select
     replace(replace(t1.serno,chr(13),''),chr(10),'') as serno
    ,replace(replace(t1.apply_no,chr(13),''),chr(10),'') as apply_no
    ,replace(replace(t1.prd_code,chr(13),''),chr(10),'') as prd_code
    ,replace(replace(t1.prd_name,chr(13),''),chr(10),'') as prd_name
    ,replace(replace(t1.apply_date,chr(13),''),chr(10),'') as apply_date
    ,replace(replace(t1.cert_type,chr(13),''),chr(10),'') as cert_type
    ,replace(replace(t1.cert_code,chr(13),''),chr(10),'') as cert_code
    ,replace(replace(t1.cus_name,chr(13),''),chr(10),'') as cus_name
    ,replace(replace(t1.cus_id,chr(13),''),chr(10),'') as cus_id
    ,replace(replace(t1.is_get_cus_code,chr(13),''),chr(10),'') as is_get_cus_code
    ,replace(replace(t1.platform_access,chr(13),''),chr(10),'') as platform_access
    ,t1.platform_admit as platform_admit
    ,t1.platform_rate_limit as platform_rate_limit
    ,t1.platform_rate_bottom as platform_rate_bottom
    ,replace(replace(t1.fail_reason,chr(13),''),chr(10),'') as fail_reason
    ,t1.apply_amount as apply_amount
    ,t1.ruling_ir as ruling_ir
    ,t1.is_check_inspect as is_check_inspect
    ,replace(replace(t1.start_date,chr(13),''),chr(10),'') as start_date
    ,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
    ,replace(replace(t1.approve_status,chr(13),''),chr(10),'') as approve_status
    ,replace(replace(t1.inform_flag,chr(13),''),chr(10),'') as inform_flag
    ,replace(replace(t1.inform_final_flag,chr(13),''),chr(10),'') as inform_final_flag
    ,replace(replace(t1.last_advice_date,chr(13),''),chr(10),'') as last_advice_date
    ,replace(replace(t1.input_id,chr(13),''),chr(10),'') as input_id
    ,replace(replace(t1.input_br_id,chr(13),''),chr(10),'') as input_br_id
    ,replace(replace(t1.businessmodel,chr(13),''),chr(10),'') as businessmodel
    ,replace(replace(t1.target_jy_flag2,chr(13),''),chr(10),'') as target_jy_flag2
    ,replace(replace(t1.target_jy_flag3,chr(13),''),chr(10),'') as target_jy_flag3
    ,replace(replace(t1.farmer_flag,chr(13),''),chr(10),'') as farmer_flag
    ,replace(replace(t1.is_cs_check_rule,chr(13),''),chr(10),'') as is_cs_check_rule
    ,replace(replace(t1.is_zs_check_rule,chr(13),''),chr(10),'') as is_zs_check_rule
    ,replace(replace(t1.refuse_code,chr(13),''),chr(10),'') as refuse_code
    ,replace(replace(t1.ack_msg,chr(13),''),chr(10),'') as ack_msg
    ,replace(replace(t1.is_check_rule,chr(13),''),chr(10),'') as is_check_rule
    ,replace(replace(t1.cs_approve_status,chr(13),''),chr(10),'') as cs_approve_status
    ,replace(replace(t1.request_id,chr(13),''),chr(10),'') as request_id
    ,replace(replace(t1.is_cs_intercept,chr(13),''),chr(10),'') as is_cs_intercept
    ,replace(replace(t1.is_zs_intercept,chr(13),''),chr(10),'') as is_zs_intercept
    ,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
    ,replace(replace(t1.zs_request_id,chr(13),''),chr(10),'') as zs_request_id
    ,replace(replace(t1.cs_sys_id,chr(13),''),chr(10),'') as cs_sys_id
    ,replace(replace(t1.zs_sys_id,chr(13),''),chr(10),'') as zs_sys_id
    ,replace(replace(t1.loan_ar,chr(13),''),chr(10),'') as loan_ar
    ,replace(replace(t1.ar_no,chr(13),''),chr(10),'') as ar_no
    ,replace(replace(t1.bsn_type,chr(13),''),chr(10),'') as bsn_type
    ,replace(replace(t1.act_cert_type,chr(13),''),chr(10),'') as act_cert_type
    ,replace(replace(t1.act_cert_no,chr(13),''),chr(10),'') as act_cert_no
    ,replace(replace(t1.act_cert_name,chr(13),''),chr(10),'') as act_cert_name
    ,replace(replace(t1.staff_num,chr(13),''),chr(10),'') as staff_num
    ,replace(replace(t1.income,chr(13),''),chr(10),'') as income
    ,t1.lpr_limit as lpr_limit
    ,t1.lpr_bottom as lpr_bottom
    ,t1.float_rate_bp_limit as float_rate_bp_limit
    ,t1.float_rate_bp_bottom as float_rate_bp_bottom
    ,replace(replace(t1.rate_float_mode_limit,chr(13),''),chr(10),'') as rate_float_mode_limit
    ,replace(replace(t1.rate_float_mode_bottom,chr(13),''),chr(10),'') as rate_float_mode_bottom
    ,replace(replace(t1.apply_times,chr(13),''),chr(10),'') as apply_times
    ,replace(replace(t1.cust_inst,chr(13),''),chr(10),'') as cust_inst
    ,replace(replace(t1.cs_app_result,chr(13),''),chr(10),'') as cs_app_result
    ,replace(replace(t1.bal_status,chr(13),''),chr(10),'') as bal_status
    ,t1.start_dt as start_dt
    ,t1.end_dt as end_dt
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.rcrs_mybk_iqp_loan_app t1
where replace(substr(end_date,1,10),'-','')='${batch_date}' 
and start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_rcrs_mybk_iqp_loan_app.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes