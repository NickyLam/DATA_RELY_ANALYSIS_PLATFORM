: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_other_mtg_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_other_mtg_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.col_name as col_name
,t1.col_qtty as col_qtty
,t1.measure_corp_cd as measure_corp_cd
,t1.col_val as col_val
,t1.col_store_addr as col_store_addr
,t1.prop_get_dt as prop_get_dt
,t1.col_ori_price_val as col_ori_price_val
,t1.other_comnt as other_comnt
,t1.curr_cd as curr_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_other_mtg_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_other_mtg_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
