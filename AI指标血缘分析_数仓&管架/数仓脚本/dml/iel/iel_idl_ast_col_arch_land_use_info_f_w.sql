: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_arch_land_use_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_arch_land_use_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.rel_esat_wat_id as rel_esat_wat_id
,t.land_char_cd as land_char_cd
,t.land_get_way_cd as land_get_way_cd
,t.land_use_right_begin_dt as land_use_right_begin_dt
,t.land_use_right_exp_dt as land_use_right_exp_dt
,t.land_usage_cd as land_usage_cd
,t.land_use_right_area as land_use_right_area
,t.idle_land_type_cd as idle_land_type_cd
,t.local_prov_cd as local_prov_cd
,t.local_city_cd as local_city_cd
,t.local_rg_cd as local_rg_cd
,t.street_name as street_name
,t.phys_addr as phys_addr
,t.parcel_id as parcel_id
,t.buy_dt as buy_dt
,t.buy_amt as buy_amt
,t.attachmen_flg as attachmen_flg
,t.attachmen_type_cd as attachmen_type_cd
,t.build_qtty as build_qtty
,t.attachmen_owner_name as attachmen_owner_name
,t.attachmen_owner_type_cd as attachmen_owner_type_cd
,t.attachmen_tot_area as attachmen_tot_area
,t.other_comnt as other_comnt
,t.curr_cd as curr_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_col_arch_land_use_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_arch_land_use_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes