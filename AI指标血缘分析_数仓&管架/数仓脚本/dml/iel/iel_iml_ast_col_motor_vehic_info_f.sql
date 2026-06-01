: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_motor_vehic_info_f
CreateDate: 20250928
FileName:   ${iel_data_path}/ast_col_motor_vehic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.exchg_inpwn_rgst_id,chr(13),''),chr(10),'') as exchg_inpwn_rgst_id
,replace(replace(t1.drv_lics_id,chr(13),''),chr(10),'') as drv_lics_id
,replace(replace(t1.chassis_no,chr(13),''),chr(10),'') as chassis_no
,replace(replace(t1.engine_id,chr(13),''),chr(10),'') as engine_id
,replace(replace(t1.lics_plat_num,chr(13),''),chr(10),'') as lics_plat_num
,replace(replace(t1.house_used_flg,chr(13),''),chr(10),'') as house_used_flg
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd
,replace(replace(t1.local_city_cd,chr(13),''),chr(10),'') as local_city_cd
,replace(replace(t1.brand_prod_manuf_name,chr(13),''),chr(10),'') as brand_prod_manuf_name
,replace(replace(t1.model_spec,chr(13),''),chr(10),'') as model_spec
,displment
,replace(replace(t1.chg_speed_type_cd,chr(13),''),chr(10),'') as chg_speed_type_cd
,leave_factory_dt
,design_use_exp_dt
,steer_mile_cnt
,replace(replace(t1.oper_vehic_flg,chr(13),''),chr(10),'') as oper_vehic_flg
,replace(replace(t1.oper_car_type_cd,chr(13),''),chr(10),'') as oper_car_type_cd
,replace(replace(t1.inv_id,chr(13),''),chr(10),'') as inv_id
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt
,create_dt
,update_dt

from ${iml_schema}.ast_col_motor_vehic_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_motor_vehic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
