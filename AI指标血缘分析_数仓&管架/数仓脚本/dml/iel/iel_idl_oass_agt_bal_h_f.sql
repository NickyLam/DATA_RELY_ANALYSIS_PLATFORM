: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_bal_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_bal_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.bal_type_cd as bal_type_cd
,t1.bal_comb_id as bal_comb_id
,t1.bal_dir_cd as bal_dir_cd
,t1.curr_cd as curr_cd
,t1.bal as bal
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_bal_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_bal_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
