: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_cont_guar_cont_rela_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_cont_guar_cont_rela_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.cont_id as cont_id
,t1.guar_cont_id as guar_cont_id
,t1.guar_type_cd as guar_type_cd
,t1.guar_amt as guar_amt
,t1.guar_curr_cd as guar_curr_cd
,t1.src_sys_cd as src_sys_cd
,t1.strip_line_cd as strip_line_cd
,t1.pri_contr_type_cd as pri_contr_type_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_cont_guar_cont_rela_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_cont_guar_cont_rela_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
