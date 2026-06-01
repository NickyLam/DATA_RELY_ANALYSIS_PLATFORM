/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_motor_vehic_info
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_ast_col_motor_vehic_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_motor_vehic_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_motor_vehic_info (
etl_dt  --ETL处理日期
,exchg_inpwn_rgst_id  --交易所质押登记编号
,drv_lics_id  --行驶证编号
,chassis_no  --车架号
,engine_id  --发动机编号
,lics_plat_num  --车牌照号码
,house_used_flg  --一手二手标志
,local_prov_cd  --所在省代码
,local_city_cd  --所在市代码
,brand_prod_manuf_name  --品牌生产厂商名称
,model_spec  --型号规格
,displment  --排量
,chg_speed_type_cd  --变速类型代码
,leave_factory_dt  --出厂日期
,design_use_exp_dt  --设计使用到期日期
,steer_mile_cnt  --行驶里程数
,oper_vehic_flg  --运营车辆标志
,oper_car_type_cd  --运营车类型代码
,inv_id  --发票编号
,other_comnt  --其他说明
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.exchg_inpwn_rgst_id,chr(13),''),chr(10),'') as exchg_inpwn_rgst_id --交易所质押登记编号
,replace(replace(t1.drv_lics_id,chr(13),''),chr(10),'') as drv_lics_id --行驶证编号
,replace(replace(t1.chassis_no,chr(13),''),chr(10),'') as chassis_no --车架号
,replace(replace(t1.engine_id,chr(13),''),chr(10),'') as engine_id --发动机编号
,replace(replace(t1.lics_plat_num,chr(13),''),chr(10),'') as lics_plat_num --车牌照号码
,replace(replace(t1.house_used_flg,chr(13),''),chr(10),'') as house_used_flg --一手二手标志
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd --所在省代码
,replace(replace(t1.local_city_cd,chr(13),''),chr(10),'') as local_city_cd --所在市代码
,replace(replace(t1.brand_prod_manuf_name,chr(13),''),chr(10),'') as brand_prod_manuf_name --品牌生产厂商名称
,replace(replace(t1.model_spec,chr(13),''),chr(10),'') as model_spec --型号规格
,t1.displment as displment --排量
,replace(replace(t1.chg_speed_type_cd,chr(13),''),chr(10),'') as chg_speed_type_cd --变速类型代码
,t1.leave_factory_dt as leave_factory_dt --出厂日期
,t1.design_use_exp_dt as design_use_exp_dt --设计使用到期日期
,t1.steer_mile_cnt as steer_mile_cnt --行驶里程数
,replace(replace(t1.oper_vehic_flg,chr(13),''),chr(10),'') as oper_vehic_flg --运营车辆标志
,replace(replace(t1.oper_car_type_cd,chr(13),''),chr(10),'') as oper_car_type_cd --运营车类型代码
,replace(replace(t1.inv_id,chr(13),''),chr(10),'') as inv_id --发票编号
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt --其他说明
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_motor_vehic_info t1    --押品机动车信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_motor_vehic_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
