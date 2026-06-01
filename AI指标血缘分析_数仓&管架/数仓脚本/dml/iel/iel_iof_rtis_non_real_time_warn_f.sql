: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_rtis_non_real_time_warn_f
CreateDate: 20241212
FileName:   ${iel_data_path}/rtis_non_real_time_warn.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,warn_id
,classify_id
,replace(replace(t1.oper_chnl,chr(13),''),chr(10),'') as oper_chnl
,replace(replace(t1.early_warning_dimension,chr(13),''),chr(10),'') as early_warning_dimension
,replace(replace(t1.order_mainstay_no,chr(13),''),chr(10),'') as order_mainstay_no
,replace(replace(t1.order_mainstay_name,chr(13),''),chr(10),'') as order_mainstay_name
,warning_order_num
,risk_qualitative
,replace(replace(t1.rate_level,chr(13),''),chr(10),'') as rate_level
,early_warning_frequency
,create_time
,update_time
,exp_time
,collect_start_date
,collect_end_date
,trans_vol
,risk_level
,list_status
,replace(replace(t1.oper_user_name,chr(13),''),chr(10),'') as oper_user_name
,replace(replace(t1.control,chr(13),''),chr(10),'') as control
,replace(replace(t1.list_strategy,chr(13),''),chr(10),'') as list_strategy
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.deal_dept,chr(13),''),chr(10),'') as deal_dept
,replace(replace(t1.deal_dept_name,chr(13),''),chr(10),'') as deal_dept_name
,replace(replace(t1.develop_dept,chr(13),''),chr(10),'') as develop_dept
,replace(replace(t1.develop_dept_name,chr(13),''),chr(10),'') as develop_dept_name
,replace(replace(t1.deal_dept_path,chr(13),''),chr(10),'') as deal_dept_path
,replace(replace(t1.develop_dept_path,chr(13),''),chr(10),'') as develop_dept_path
,replace(replace(t1.latest_handle_by,chr(13),''),chr(10),'') as latest_handle_by
,replace(replace(t1.audit_by,chr(13),''),chr(10),'') as audit_by
,replace(replace(t1.data_source,chr(13),''),chr(10),'') as data_source
,replace(replace(t1.task_id,chr(13),''),chr(10),'') as task_id
,replace(replace(t1.act_variable,chr(13),''),chr(10),'') as act_variable
,replace(replace(t1.approve_result,chr(13),''),chr(10),'') as approve_result
,replace(replace(t1.oper_ip_addr,chr(13),''),chr(10),'') as oper_ip_addr
,replace(replace(t1.oper_city,chr(13),''),chr(10),'') as oper_city
,qua_type
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,trans_time
,replace(replace(t1.rule_code_num,chr(13),''),chr(10),'') as rule_code_num
,replace(replace(t1.rule_code_str,chr(13),''),chr(10),'') as rule_code_str
,isexamine
,replace(replace(t1.account_organ,chr(13),''),chr(10),'') as account_organ
,replace(replace(t1.account_organ_id,chr(13),''),chr(10),'') as account_organ_id
,replace(replace(t1.pro_inform_sources,chr(13),''),chr(10),'') as pro_inform_sources
,replace(replace(t1.rule_code_e_num,chr(13),''),chr(10),'') as rule_code_e_num
,replace(replace(t1.score,chr(13),''),chr(10),'') as score
,replace(replace(t1.warnkey,chr(13),''),chr(10),'') as warnkey
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type

from ${iol_schema}.rtis_non_real_time_warn t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rtis_non_real_time_warn.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
