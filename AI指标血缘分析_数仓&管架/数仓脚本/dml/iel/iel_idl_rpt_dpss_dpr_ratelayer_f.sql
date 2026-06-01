: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_dpss_dpr_ratelayer_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_dpss_dpr_ratelayer.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.ledge_cod,chr(13),''),chr(10),'') as ledge_cod
,replace(replace(t1.bckmk_rcal_ratecod,chr(13),''),chr(10),'') as bckmk_rcal_ratecod
,replace(replace(t1.dpact_no,chr(13),''),chr(10),'') as dpact_no
,replace(replace(t1.cust_num,chr(13),''),chr(10),'') as cust_num
,replace(replace(t1.curr_code,chr(13),''),chr(10),'') as curr_code
,replace(replace(t1.rate_seqno,chr(13),''),chr(10),'') as rate_seqno
,replace(replace(t1.rate_name,chr(13),''),chr(10),'') as rate_name
,replace(replace(t1.acct_dep_term,chr(13),''),chr(10),'') as acct_dep_term
,replace(replace(t1.dep_term,chr(13),''),chr(10),'') as dep_term
,t1.int_days as int_days
,t1.rate_level as rate_level
,replace(replace(t1.bed_mthd,chr(13),''),chr(10),'') as bed_mthd
,replace(replace(t1.eff_date,chr(13),''),chr(10),'') as eff_date
,t1.benchmark_rate as benchmark_rate
,replace(replace(t1.rate_float_kind,chr(13),''),chr(10),'') as rate_float_kind
,t1.rate_float_value as rate_float_value
,t1.exec_rate as exec_rate
,t1.rate_change_field as rate_change_field
,replace(replace(t1.if_flag,chr(13),''),chr(10),'') as if_flag
,replace(replace(t1.rate_near_way,chr(13),''),chr(10),'') as rate_near_way
,replace(replace(t1.due_date,chr(13),''),chr(10),'') as due_date
,replace(replace(t1.mod_opr,chr(13),''),chr(10),'') as mod_opr
,replace(replace(t1.mod_date,chr(13),''),chr(10),'') as mod_date
,replace(replace(t1.mod_unit,chr(13),''),chr(10),'') as mod_unit
,t1.mod_time as mod_time
,t1.time_sign as time_sign
,replace(replace(t1.record_sts,chr(13),''),chr(10),'') as record_sts
 from iol.dpss_dpr_ratelayer T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_dpss_dpr_ratelayer.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes