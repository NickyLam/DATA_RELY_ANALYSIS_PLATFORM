: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_fkd_other_asset_proof_f
CreateDate: 20221021
FileName:   ${iel_data_path}/ast_fkd_other_asset_proof.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(asset_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(asset_proof_list_id,chr(13),''),chr(10),'')
,replace(replace(bus_flow_num,chr(13),''),chr(10),'')
,replace(replace(other_asset_proof_type,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.ast_fkd_other_asset_proof t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_fkd_other_asset_proof.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
