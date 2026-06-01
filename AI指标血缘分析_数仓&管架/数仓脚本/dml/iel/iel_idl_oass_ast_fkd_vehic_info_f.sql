: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_fkd_vehic_info_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_ast_fkd_vehic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.bus_flow_num as bus_flow_num
,t1.vehic_model as vehic_model
,t1.vehic_price as vehic_price
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.vehic_list_id as vehic_list_id

from ${idl_schema}.oass_ast_fkd_vehic_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_fkd_vehic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
