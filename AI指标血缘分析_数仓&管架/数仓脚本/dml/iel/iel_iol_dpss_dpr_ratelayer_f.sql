: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_dpss_dpr_ratelayer_f
CreateDate: 20180529
FileName:   ${iel_data_path}/dpss_dpr_ratelayer.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.ledge_cod,chr(13),''),chr(10),'') as ledge_cod
,replace(replace(t.bckmk_rcal_ratecod,chr(13),''),chr(10),'') as bckmk_rcal_ratecod
,replace(replace(t.dpact_no,chr(13),''),chr(10),'') as dpact_no
,replace(replace(t.cust_num,chr(13),''),chr(10),'') as cust_num
,replace(replace(t.curr_code,chr(13),''),chr(10),'') as curr_code
,replace(replace(t.rate_seqno,chr(13),''),chr(10),'') as rate_seqno
,replace(replace(t.rate_name,chr(13),''),chr(10),'') as rate_name
,replace(replace(t.acct_dep_term,chr(13),''),chr(10),'') as acct_dep_term
,replace(replace(t.dep_term,chr(13),''),chr(10),'') as dep_term
,t.rate_level as rate_level
,replace(replace(t.bed_mthd,chr(13),''),chr(10),'') as bed_mthd
,replace(replace(t.eff_date,chr(13),''),chr(10),'') as eff_date
,t.benchmark_rate as benchmark_rate
,replace(replace(t.rate_float_kind,chr(13),''),chr(10),'') as rate_float_kind
,t.rate_float_value as rate_float_value
,t.exec_rate as exec_rate
,t.rate_change_field as rate_change_field
,replace(replace(t.if_flag,chr(13),''),chr(10),'') as if_flag
,replace(replace(t.rate_near_way,chr(13),''),chr(10),'') as rate_near_way
,replace(replace(t.mod_opr,chr(13),''),chr(10),'') as mod_opr
,replace(replace(t.mod_date,chr(13),''),chr(10),'') as mod_date
,replace(replace(t.mod_unit,chr(13),''),chr(10),'') as mod_unit
,t.mod_time as mod_time
,t.time_sign as time_sign
,replace(replace(t.record_sts,chr(13),''),chr(10),'') as record_sts
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.dpss_dpr_ratelayer t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/dpss_dpr_ratelayer.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes