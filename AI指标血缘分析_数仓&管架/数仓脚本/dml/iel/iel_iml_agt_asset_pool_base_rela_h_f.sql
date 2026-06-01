: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_asset_pool_base_rela_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_asset_pool_base_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.asset_pool_id,chr(13),''),chr(10),'') as asset_pool_id
,replace(replace(t1.parent_asset_pool_id,chr(13),''),chr(10),'') as parent_asset_pool_id
,replace(replace(t1.base_asset_id,chr(13),''),chr(10),'') as base_asset_id
,replace(replace(t1.asset_scr_rule_id,chr(13),''),chr(10),'') as asset_scr_rule_id
,replace(replace(t1.obj_type,chr(13),''),chr(10),'') as obj_type

from ${iml_schema}.agt_asset_pool_base_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_asset_pool_base_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
