: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_prod_rela_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_prod_rela_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.agt_prod_rela_type_cd as agt_prod_rela_type_cd
,t1.prod_id as prod_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_prod_rela_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')-1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_prod_rela_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
