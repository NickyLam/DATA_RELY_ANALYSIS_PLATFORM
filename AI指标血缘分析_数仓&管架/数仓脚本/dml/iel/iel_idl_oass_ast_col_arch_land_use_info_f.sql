: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_arch_land_use_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_arch_land_use_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.rel_esat_wat_id as rel_esat_wat_id
,t1.land_char_cd as land_char_cd
,t1.land_get_way_cd as land_get_way_cd
,t1.land_use_right_begin_dt as land_use_right_begin_dt
,t1.land_use_right_exp_dt as land_use_right_exp_dt
,t1.land_usage_cd as land_usage_cd
,t1.land_use_right_area as land_use_right_area
,t1.idle_land_type_cd as idle_land_type_cd
,t1.local_prov_cd as local_prov_cd
,t1.local_city_cd as local_city_cd
,t1.local_rg_cd as local_rg_cd
,t1.street_name as street_name
,t1.phys_addr as phys_addr
,t1.parcel_id as parcel_id
,t1.buy_dt as buy_dt
,t1.buy_amt as buy_amt
,t1.attachmen_flg as attachmen_flg
,t1.attachmen_type_cd as attachmen_type_cd
,t1.build_qtty as build_qtty
,t1.attachmen_owner_name as attachmen_owner_name
,t1.attachmen_owner_type_cd as attachmen_owner_type_cd
,t1.attachmen_tot_area as attachmen_tot_area
,t1.other_comnt as other_comnt
,t1.curr_cd as curr_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_arch_land_use_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_arch_land_use_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
