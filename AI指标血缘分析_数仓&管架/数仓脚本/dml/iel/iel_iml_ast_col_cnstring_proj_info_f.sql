: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_cnstring_proj_info_f
CreateDate: 20251010
FileName:   ${iel_data_path}/ast_col_cnstring_proj_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.rel_esat_wat_id,chr(13),''),chr(10),'') as rel_esat_wat_id
,replace(replace(t1.land_char_cd,chr(13),''),chr(10),'') as land_char_cd
,replace(replace(t1.land_get_way_cd,chr(13),''),chr(10),'') as land_get_way_cd
,land_use_right_begin_dt
,land_use_right_exp_dt
,land_use_right_years
,land_area
,land_tranf_fee_amt
,replace(replace(t1.land_tranf_fee_dlvy_flg,chr(13),''),chr(10),'') as land_tranf_fee_dlvy_flg
,attach_tranf_fee_amt
,replace(replace(t1.land_usage_cd,chr(13),''),chr(10),'') as land_usage_cd
,replace(replace(t1.proj_proj_name,chr(13),''),chr(10),'') as proj_proj_name
,replace(replace(t1.cnstr_land_use_permit_id,chr(13),''),chr(10),'') as cnstr_land_use_permit_id
,replace(replace(t1.cnstr_proj_plan_permit_id,chr(13),''),chr(10),'') as cnstr_proj_plan_permit_id
,replace(replace(t1.proj_cnstr_lics_id,chr(13),''),chr(10),'') as proj_cnstr_lics_id
,start_work_dt
,expect_cmplt_dt
,proj_expect_tot_cost
,arch_area
,tot_floor_cnt
,replace(replace(t1.rent_flg,chr(13),''),chr(10),'') as rent_flg
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd
,replace(replace(t1.local_city_cd,chr(13),''),chr(10),'') as local_city_cd
,replace(replace(t1.local_rg_cd,chr(13),''),chr(10),'') as local_rg_cd
,replace(replace(t1.street_name,chr(13),''),chr(10),'') as street_name
,replace(replace(t1.dplat_id,chr(13),''),chr(10),'') as dplat_id
,replace(replace(t1.phys_addr,chr(13),''),chr(10),'') as phys_addr
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,rent_anl_inco
,replace(replace(t1.house_cmplt_flg,chr(13),''),chr(10),'') as house_cmplt_flg
,create_dt
,update_dt

from ${iml_schema}.ast_col_cnstring_proj_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_cnstring_proj_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
