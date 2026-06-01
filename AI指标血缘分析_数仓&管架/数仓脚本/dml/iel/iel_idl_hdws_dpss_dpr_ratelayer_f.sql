: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dpss_dpr_ratelayer_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dpss_dpr_ratelayer.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.ledge_cod
,t1.bckmk_rcal_ratecod
,t1.dpact_no
,t1.cust_num
,t1.curr_code
,t1.rate_seqno
,t1.rate_name
,t1.acct_dep_term
,t1.dep_term
,t1.int_days
,t1.rate_level
,t1.bed_mthd
,t1.eff_date
,t1.benchmark_rate
,t1.rate_float_kind
,t1.rate_float_value
,t1.exec_rate
,t1.rate_change_field
,t1.if_flag
,t1.rate_near_way
,t1.due_date
,t1.mod_opr
,t1.mod_date
,t1.mod_unit
,t1.mod_time
,t1.time_sign
,t1.record_sts
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_dpss_dpr_ratelayer t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dpss_dpr_ratelayer.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes