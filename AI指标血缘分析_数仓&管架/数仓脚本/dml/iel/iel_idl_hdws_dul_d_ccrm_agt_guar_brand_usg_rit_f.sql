: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_guar_brand_usg_rit_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_guar_brand_usg_rit.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
coll_id
,etl_dt
,brand_reg_cert_num
,issue_corp
,issue_dt
,agent_org_name
,legal_reps
,data_src_cd
from ${idl_schema}.hdws_dul_d_ccrm_agt_guar_brand_usg_rit
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_guar_brand_usg_rit.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes