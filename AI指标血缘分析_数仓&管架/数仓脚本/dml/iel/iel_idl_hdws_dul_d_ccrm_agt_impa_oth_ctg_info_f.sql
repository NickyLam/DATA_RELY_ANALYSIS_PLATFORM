: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_impa_oth_ctg_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_impa_oth_ctg_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
coll_id
,etl_dt
,ctrl_name
,right_vchr_num
,qty
,ori_val
,store_site
,memo
,data_src_cd
from ${idl_schema}.hdws_dul_d_ccrm_agt_impa_oth_ctg_info 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_impa_oth_ctg_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes