: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_t01_exch_rate_tab_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_t01_exch_rate_tab.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,ccy_cd
,ccy_name
,convt_usd_exch_rate
,convt_rmb_exch_rate
from ${idl_schema}.hdws_dul_d_ccrm_t01_exch_rate_tab
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_t01_exch_rate_tab.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes