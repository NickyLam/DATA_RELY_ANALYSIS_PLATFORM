: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_cnstring_proj_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_cnstring_proj_info_w.f.${batch_date}.dat
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
,t.land_use_right_years as land_use_right_years
,t.land_area as land_area
,t.land_tranf_fee_amt as land_tranf_fee_amt
,t.land_tranf_fee_dlvy_flg as land_tranf_fee_dlvy_flg
,t.attach_tranf_fee_amt as attach_tranf_fee_amt
,t.land_usage_cd as land_usage_cd
,t.proj_proj_name as proj_proj_name
,t.cnstr_land_use_permit_id as cnstr_land_use_permit_id
,t.cnstr_proj_plan_permit_id as cnstr_proj_plan_permit_id
,t.proj_cnstr_lics_id as proj_cnstr_lics_id
,t.start_work_dt as start_work_dt
,t.expect_cmplt_dt as expect_cmplt_dt
,t.proj_expect_tot_cost as proj_expect_tot_cost
,t.arch_area as arch_area
,t.tot_floor_cnt as tot_floor_cnt
,t.rent_flg as rent_flg
,t.local_prov_cd as local_prov_cd
,t.local_city_cd as local_city_cd
,t.local_rg_cd as local_rg_cd
,t.street_name as street_name
,t.dplat_id as dplat_id
,t.phys_addr as phys_addr
,t.other_comnt as other_comnt
,t.curr_cd as curr_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_col_cnstring_proj_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_cnstring_proj_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes