: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_cnstring_proj_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_cnstring_proj_info.f.${batch_date}.dat
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
,t1.land_use_right_years as land_use_right_years
,t1.land_area as land_area
,t1.land_tranf_fee_amt as land_tranf_fee_amt
,t1.land_tranf_fee_dlvy_flg as land_tranf_fee_dlvy_flg
,t1.attach_tranf_fee_amt as attach_tranf_fee_amt
,t1.land_usage_cd as land_usage_cd
,t1.proj_proj_name as proj_proj_name
,t1.cnstr_land_use_permit_id as cnstr_land_use_permit_id
,t1.cnstr_proj_plan_permit_id as cnstr_proj_plan_permit_id
,t1.proj_cnstr_lics_id as proj_cnstr_lics_id
,t1.start_work_dt as start_work_dt
,t1.expect_cmplt_dt as expect_cmplt_dt
,t1.proj_expect_tot_cost as proj_expect_tot_cost
,t1.arch_area as arch_area
,t1.tot_floor_cnt as tot_floor_cnt
,t1.rent_flg as rent_flg
,t1.local_prov_cd as local_prov_cd
,t1.local_city_cd as local_city_cd
,t1.local_rg_cd as local_rg_cd
,t1.street_name as street_name
,t1.dplat_id as dplat_id
,t1.phys_addr as phys_addr
,t1.other_comnt as other_comnt
,t1.curr_cd as curr_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_cnstring_proj_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_cnstring_proj_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
