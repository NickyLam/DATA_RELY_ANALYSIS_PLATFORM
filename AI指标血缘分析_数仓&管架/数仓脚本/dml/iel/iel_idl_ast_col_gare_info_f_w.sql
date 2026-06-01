: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_gare_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_gare_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.single_pro_cert_flg as single_pro_cert_flg
,t.gare_type_cd as gare_type_cd
,t.bs_cont_id as bs_cont_id
,t.buy_dt as buy_dt
,t.buy_amt as buy_amt
,t.arch_area as arch_area
,t.usbl_area as usbl_area
,t.build_year as build_year
,t.local_prov_cd as local_prov_cd
,t.local_city_cd as local_city_cd
,t.local_rg_cd as local_rg_cd
,t.street_name as street_name
,t.street_id as street_id
,t.dplat_id as dplat_id
,t.rel_esat_wat_rgst_addr as rel_esat_wat_rgst_addr
,t.estat_name as estat_name
,t.prop_tenor as prop_tenor
,t.other_prop_cert_flg as other_prop_cert_flg
,t.other_comnt as other_comnt
,t.two_in_one_flg as two_in_one_flg
,t.rel_esat_wat_id as rel_esat_wat_id
,t.land_char_cd as land_char_cd
,t.land_use_area as land_use_area
,t.land_get_way_cd as land_get_way_cd
,t.land_use_right_begin_dt as land_use_right_begin_dt
,t.land_use_right_exp_dt as land_use_right_exp_dt
,t.land_use_right_years as land_use_right_years
,t.land_usage_cd as land_usage_cd
,t.rent_flg as rent_flg
,t.tentry_name as tentry_name
,t.rent_begin_dt as rent_begin_dt
,t.rent_exp_dt as rent_exp_dt
,t.rent_situ_comnt as rent_situ_comnt
,t.curr_cd as curr_cd
,t.land_use_right_id as land_use_right_id
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_col_gare_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_gare_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes