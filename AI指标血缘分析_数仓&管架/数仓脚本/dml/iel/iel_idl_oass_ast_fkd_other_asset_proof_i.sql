: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_fkd_other_asset_proof_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_fkd_other_asset_proof.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.asset_proof_list_id as asset_proof_list_id
,t1.bus_flow_num as bus_flow_num
,t1.other_asset_proof_type as other_asset_proof_type
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_fkd_other_asset_proof t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_fkd_other_asset_proof.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
