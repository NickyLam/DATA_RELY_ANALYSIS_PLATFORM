: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_guar_land_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_guar_land_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
coll_id
,etl_dt
,land_acq_dt
,land_area
,land_trmi_usage_dt
,pla_on_situ_comm
,remi_price
,remi_dlv_situ_cd
,shd_mend_remi_amt
,data_src_cd
from ${idl_schema}.hdws_dul_d_ccrm_agt_guar_land_info
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_guar_land_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes