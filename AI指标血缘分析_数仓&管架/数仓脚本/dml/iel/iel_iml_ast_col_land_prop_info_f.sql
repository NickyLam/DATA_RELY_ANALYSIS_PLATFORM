: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_land_prop_info_f
CreateDate: 20250928
FileName:   ${iel_data_path}/ast_col_land_prop_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.land_cert_id,chr(13),''),chr(10),'') as land_cert_id
,replace(replace(t1.land_use_char_cd,chr(13),''),chr(10),'') as land_use_char_cd
,replace(replace(t1.land_use_right_subclass_cd,chr(13),''),chr(10),'') as land_use_right_subclass_cd
,replace(replace(t1.land_use_right_get_way_cd,chr(13),''),chr(10),'') as land_use_right_get_way_cd
,land_use_right_effect_dt
,land_use_right_exp_dt
,replace(replace(t1.land_usage_cd,chr(13),''),chr(10),'') as land_usage_cd
,land_use_right_area
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd
,replace(replace(t1.city_cd,chr(13),''),chr(10),'') as city_cd
,replace(replace(t1.local_county_rg_cd,chr(13),''),chr(10),'') as local_county_rg_cd
,replace(replace(t1.local_street,chr(13),''),chr(10),'') as local_street
,replace(replace(t1.land_dtl_addr,chr(13),''),chr(10),'') as land_dtl_addr
,replace(replace(t1.parcel_num,chr(13),''),chr(10),'') as parcel_num
,buy_dt
,buy_price
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.have_land_up_attachmen_flg,chr(13),''),chr(10),'') as have_land_up_attachmen_flg
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt

from ${iml_schema}.ast_col_land_prop_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_land_prop_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
