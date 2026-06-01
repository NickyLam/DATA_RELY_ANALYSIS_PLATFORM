: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_guar_fore_right_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_guar_fore_right.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
coll_id
,etl_dt
,fore_pla_name
,parc_num
,fore_breed_cd
,main_tree_breed
,stem_qty
,tree_age
,acq_mode_cd
,acq_amt
,fore_right_acq_dt
,fore_area
,fore_right_cert_num
,fore_pla_usg_rit_obli
,fore_or_fore_usg_rit_pers
,fore_pla_use_stdt
,fore_pla_use_due_dt
,data_src_cd
from ${idl_schema}.hdws_dul_d_ccrm_agt_guar_fore_right
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_guar_fore_right.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes