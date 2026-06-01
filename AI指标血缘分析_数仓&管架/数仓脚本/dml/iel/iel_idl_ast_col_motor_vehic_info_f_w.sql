: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_motor_vehic_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_motor_vehic_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt 
,t.asset_id
,t.lp_id
,t.exchg_inpwn_rgst_id
,t.drv_lics_id
,t.chassis_no
,t.engine_id
,t.lics_plat_num
,t.house_used_flg
,t.local_prov_cd
,t.local_city_cd
,t.brand_prod_manuf_name
,t.model_spec
,t.displment
,t.chg_speed_type_cd
,t.leave_factory_dt
,t.design_use_exp_dt
,t.steer_mile_cnt
,t.oper_vehic_flg
,t.oper_car_type_cd
,t.inv_id
,t.other_comnt
,t.create_dt
,t.update_dt
,t.id_mark
from ${idl_schema}.ast_col_motor_vehic_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_motor_vehic_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes