: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_gare_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_gare_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.single_pro_cert_flg as single_pro_cert_flg
,t1.gare_type_cd as gare_type_cd
,t1.bs_cont_id as bs_cont_id
,t1.buy_dt as buy_dt
,t1.buy_amt as buy_amt
,t1.arch_area as arch_area
,t1.usbl_area as usbl_area
,t1.build_year as build_year
,t1.local_prov_cd as local_prov_cd
,t1.local_city_cd as local_city_cd
,t1.local_rg_cd as local_rg_cd
,t1.street_name as street_name
,t1.street_id as street_id
,t1.dplat_id as dplat_id
,t1.rel_esat_wat_rgst_addr as rel_esat_wat_rgst_addr
,t1.estat_name as estat_name
,t1.prop_tenor as prop_tenor
,t1.other_prop_cert_flg as other_prop_cert_flg
,t1.other_comnt as other_comnt
,t1.two_in_one_flg as two_in_one_flg
,t1.rel_esat_wat_id as rel_esat_wat_id
,t1.land_char_cd as land_char_cd
,t1.land_use_area as land_use_area
,t1.land_get_way_cd as land_get_way_cd
,t1.land_use_right_begin_dt as land_use_right_begin_dt
,t1.land_use_right_exp_dt as land_use_right_exp_dt
,t1.land_use_right_years as land_use_right_years
,t1.land_usage_cd as land_usage_cd
,t1.rent_flg as rent_flg
,t1.tentry_name as tentry_name
,t1.rent_begin_dt as rent_begin_dt
,t1.rent_exp_dt as rent_exp_dt
,t1.rent_situ_comnt as rent_situ_comnt
,t1.curr_cd as curr_cd
,t1.land_use_right_id as land_use_right_id
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_gare_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_gare_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
