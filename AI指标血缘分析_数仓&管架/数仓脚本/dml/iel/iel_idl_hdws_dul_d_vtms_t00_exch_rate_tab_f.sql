: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_vtms_t00_exch_rate_tab_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_vtms_t00_exch_rate_tab.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,t1.last_update_dt as last_update_dt
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.ccy_name,chr(13),''),chr(10),'') as ccy_name
,t1.convt_usd_exch_rate as convt_usd_exch_rate
,t1.convt_rmb_exch_rate as convt_rmb_exch_rate
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
from ${idl_schema}.hdws_dul_d_vtms_t00_exch_rate_tab t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_vtms_t00_exch_rate_tab.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes