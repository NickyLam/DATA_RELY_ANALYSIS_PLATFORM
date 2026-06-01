: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_cdc_fp_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_cdc_fp.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t.security_code,chr(13),''),chr(10),'') as security_code
,t.pricing_date as pricing_date
,replace(replace(t.market,chr(13),''),chr(10),'') as market
,t.ttm as ttm
,replace(replace(t.reliability,chr(13),''),chr(10),'') as reliability
,t.dp as dp
,t.cp as cp
,t.yield as yield
,t.duration as duration
,t.mduration as mduration
,t.valid as valid
,t.lastupdate as lastupdate
,to_date('${batch_date}','yyyymmdd') as etl_dt
,t.etl_timestamp as etl_timestamp
,t.ai as ai
,t.end_dp as end_dp
,t.cdc_yield as cdc_yield
,t.cdc_md as cdc_md
,t.cdc_convexity as cdc_convexity
from ${iol_schema}.ctms_tbs_v_cdc_fp t
where to_date(pricing_date,'yyyymmdd') = to_date('${batch_date}','yyyymmdd')
and etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_cdc_fp.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes