: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ast_col_other_mtg_info_f
CreateDate: 20250928
FileName:   ${iel_data_path}/ast_col_other_mtg_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.col_name,chr(13),''),chr(10),'') as col_name
,col_qtty
,replace(replace(t1.measure_corp_cd,chr(13),''),chr(10),'') as measure_corp_cd
,col_val
,replace(replace(t1.col_store_addr,chr(13),''),chr(10),'') as col_store_addr
,prop_get_dt
,col_ori_price_val
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,create_dt
,update_dt

from ${iml_schema}.ast_col_other_mtg_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_other_mtg_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
