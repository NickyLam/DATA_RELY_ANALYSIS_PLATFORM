: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_crdt_guar_rela_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_crdt_guar_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
crdt_contr_id
,assoc_guar_contr_id
,assoc_agt_modf
,etl_dt
,last_update_dt
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_agt_crdt_guar_rela 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_crdt_guar_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes