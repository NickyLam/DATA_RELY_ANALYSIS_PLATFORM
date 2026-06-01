: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_asset_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_asset_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.asset_type_cd as asset_type_cd
,t.asset_name as asset_name
,t.create_dt as create_dt
,t.update_dt as update_dt
,t.id_mark as id_mark
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
from ${idl_schema}.ast_asset t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_asset_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes