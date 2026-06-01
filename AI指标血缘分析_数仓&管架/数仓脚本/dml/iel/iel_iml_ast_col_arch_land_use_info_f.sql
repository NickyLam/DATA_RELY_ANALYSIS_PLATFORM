: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_arch_land_use_info_f
CreateDate: 20221021
FileName:   ${iel_data_path}/ast_col_arch_land_use_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(asset_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(rel_esat_wat_id,chr(13),''),chr(10),'')
,replace(replace(land_char_cd,chr(13),''),chr(10),'')
,replace(replace(land_get_way_cd,chr(13),''),chr(10),'')
,land_use_right_begin_dt
,land_use_right_exp_dt
,replace(replace(land_usage_cd,chr(13),''),chr(10),'')
,land_use_right_area
,replace(replace(idle_land_type_cd,chr(13),''),chr(10),'')
,replace(replace(local_prov_cd,chr(13),''),chr(10),'')
,replace(replace(local_city_cd,chr(13),''),chr(10),'')
,replace(replace(local_rg_cd,chr(13),''),chr(10),'')
,replace(replace(street_name,chr(13),''),chr(10),'')
,replace(replace(phys_addr,chr(13),''),chr(10),'')
,replace(replace(parcel_id,chr(13),''),chr(10),'')
,buy_dt
,buy_amt
,replace(replace(attachmen_flg,chr(13),''),chr(10),'')
,replace(replace(attachmen_type_cd,chr(13),''),chr(10),'')
,build_qtty
,replace(replace(attachmen_owner_name,chr(13),''),chr(10),'')
,replace(replace(attachmen_owner_type_cd,chr(13),''),chr(10),'')
,attachmen_tot_area
,replace(replace(other_comnt,chr(13),''),chr(10),'')
,replace(replace(curr_cd,chr(13),''),chr(10),'')
,create_dt
,update_dt
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.ast_col_arch_land_use_info t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_arch_land_use_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
