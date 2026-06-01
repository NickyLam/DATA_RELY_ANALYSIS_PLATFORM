: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_motor_vehic_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_motor_vehic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.exchg_inpwn_rgst_id as exchg_inpwn_rgst_id
,t1.drv_lics_id as drv_lics_id
,t1.chassis_no as chassis_no
,t1.engine_id as engine_id
,t1.lics_plat_num as lics_plat_num
,t1.house_used_flg as house_used_flg
,t1.local_prov_cd as local_prov_cd
,t1.local_city_cd as local_city_cd
,t1.brand_prod_manuf_name as brand_prod_manuf_name
,t1.model_spec as model_spec
,t1.displment as displment
,t1.chg_speed_type_cd as chg_speed_type_cd
,t1.leave_factory_dt as leave_factory_dt
,t1.design_use_exp_dt as design_use_exp_dt
,t1.steer_mile_cnt as steer_mile_cnt
,t1.oper_vehic_flg as oper_vehic_flg
,t1.oper_car_type_cd as oper_car_type_cd
,t1.inv_id as inv_id
,t1.other_comnt as other_comnt
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_motor_vehic_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_motor_vehic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
