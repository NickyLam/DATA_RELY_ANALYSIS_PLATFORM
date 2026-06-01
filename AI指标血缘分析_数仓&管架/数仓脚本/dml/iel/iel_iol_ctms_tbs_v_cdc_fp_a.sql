: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_cdc_fp_a
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_cdc_fp.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select security_code
,pricing_date
,market
,ttm
,reliability
,dp
,cp
,yield
,duration
,mduration
,valid
,lastupdate
,etl_dt
,etl_timestamp from iol.ctms_tbs_v_cdc_fp where etl_dt < to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_cdc_fp.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes