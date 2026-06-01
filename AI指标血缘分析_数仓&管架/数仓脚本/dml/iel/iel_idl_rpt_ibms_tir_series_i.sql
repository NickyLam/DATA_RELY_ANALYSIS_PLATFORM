: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_ibms_tir_series_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_ibms_tir_series.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.ETL_DT
,t1.i_code
,t1.a_type
,t1.m_type
,t1.dp_close
,t1.dp_high
,t1.dp_low
,t1.dp_ask
,t1.dp_bid
,t1.dp_mid
,t1.beg_date
,t1.end_date
,t1.imp_date
,t1.pipe_id
,t1.dp_bank
,t1.imp_time
,t1.dp_id
,t1.source_time
,t1.state
,t1.update_user
from ${idl_schema}.rpt_ibms_tir_series t1 
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_ibms_tir_series.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes