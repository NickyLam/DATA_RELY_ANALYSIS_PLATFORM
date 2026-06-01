: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_gare_info_f
CreateDate: 20251010
FileName:   ${iel_data_path}/ast_col_gare_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.single_pro_cert_flg,chr(13),''),chr(10),'') as single_pro_cert_flg
,replace(replace(t1.gare_type_cd,chr(13),''),chr(10),'') as gare_type_cd
,replace(replace(t1.bs_cont_id,chr(13),''),chr(10),'') as bs_cont_id
,buy_dt
,buy_amt
,arch_area
,usbl_area
,replace(replace(t1.build_year,chr(13),''),chr(10),'') as build_year
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd
,replace(replace(t1.local_city_cd,chr(13),''),chr(10),'') as local_city_cd
,replace(replace(t1.local_rg_cd,chr(13),''),chr(10),'') as local_rg_cd
,replace(replace(t1.street_name,chr(13),''),chr(10),'') as street_name
,replace(replace(t1.street_id,chr(13),''),chr(10),'') as street_id
,replace(replace(t1.dplat_id,chr(13),''),chr(10),'') as dplat_id
,replace(replace(t1.rel_esat_wat_rgst_addr,chr(13),''),chr(10),'') as rel_esat_wat_rgst_addr
,replace(replace(t1.estat_name,chr(13),''),chr(10),'') as estat_name
,prop_tenor
,replace(replace(t1.other_prop_cert_flg,chr(13),''),chr(10),'') as other_prop_cert_flg
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt
,replace(replace(t1.two_in_one_flg,chr(13),''),chr(10),'') as two_in_one_flg
,replace(replace(t1.rel_esat_wat_id,chr(13),''),chr(10),'') as rel_esat_wat_id
,replace(replace(t1.land_char_cd,chr(13),''),chr(10),'') as land_char_cd
,land_use_area
,replace(replace(t1.land_get_way_cd,chr(13),''),chr(10),'') as land_get_way_cd
,land_use_right_begin_dt
,land_use_right_exp_dt
,land_use_right_years
,replace(replace(t1.land_usage_cd,chr(13),''),chr(10),'') as land_usage_cd
,replace(replace(t1.rent_flg,chr(13),''),chr(10),'') as rent_flg
,replace(replace(t1.tentry_name,chr(13),''),chr(10),'') as tentry_name
,rent_begin_dt
,rent_exp_dt
,replace(replace(t1.rent_situ_comnt,chr(13),''),chr(10),'') as rent_situ_comnt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.land_use_right_id,chr(13),''),chr(10),'') as land_use_right_id
,rent_anl_inco
,replace(replace(t1.house_cmplt_flg,chr(13),''),chr(10),'') as house_cmplt_flg
,create_dt
,update_dt

from ${iml_schema}.ast_col_gare_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_gare_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
