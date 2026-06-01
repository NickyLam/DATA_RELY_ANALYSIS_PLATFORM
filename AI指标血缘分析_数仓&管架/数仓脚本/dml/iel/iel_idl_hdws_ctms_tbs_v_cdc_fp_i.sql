: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ctms_tbs_v_cdc_fp_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ctms_tbs_v_cdc_fp.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.security_code
,t1.pricing_date
,t1.market
,t1.ttm
,t1.reliability
,t1.dp
,t1.cp
,t1.yield
,t1.duration
,t1.mduration
,t1.valid
,t1.lastupdate
,t1.etl_timestamp
,t1.ai
,t1.end_dp
,t1.cdc_yield
,t1.cdc_md
,t1.cdc_convexity
from ${idl_schema}.hdws_ctms_tbs_v_cdc_fp t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ctms_tbs_v_cdc_fp.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes