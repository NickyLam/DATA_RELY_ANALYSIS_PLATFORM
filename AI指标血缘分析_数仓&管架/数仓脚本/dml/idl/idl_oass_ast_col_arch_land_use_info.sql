/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_arch_land_use_info
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
alter table ${idl_schema}.oass_ast_col_arch_land_use_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_arch_land_use_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_arch_land_use_info (
etl_dt  --ETL处理日期
,rel_esat_wat_id  --房产证号
,land_char_cd  --土地所有权性质代码
,land_get_way_cd  --土地取得方式代码
,land_use_right_begin_dt  --土地使用权起始日期
,land_use_right_exp_dt  --土地使用权到期日期
,land_usage_cd  --土地用途代码
,land_use_right_area  --土地使用权面积
,idle_land_type_cd  --闲置土地类型代码
,local_prov_cd  --所在省代码
,local_city_cd  --所在市代码
,local_rg_cd  --所在区代码
,street_name  --街道名称
,phys_addr  --物理地址
,parcel_id  --宗地编号
,buy_dt  --购入日期
,buy_amt  --购入金额
,attachmen_flg  --附着物标志
,attachmen_type_cd  --附着物类型代码
,build_qtty  --建筑物数量
,attachmen_owner_name  --附着物所有人名称
,attachmen_owner_type_cd  --附着物所有人类型代码
,attachmen_tot_area  --附着物总面积
,other_comnt  --其他说明
,curr_cd  --币种代码
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.rel_esat_wat_id,chr(13),''),chr(10),'') as rel_esat_wat_id --房产证号
,replace(replace(t1.land_char_cd,chr(13),''),chr(10),'') as land_char_cd --土地所有权性质代码
,replace(replace(t1.land_get_way_cd,chr(13),''),chr(10),'') as land_get_way_cd --土地取得方式代码
,t1.land_use_right_begin_dt as land_use_right_begin_dt --土地使用权起始日期
,t1.land_use_right_exp_dt as land_use_right_exp_dt --土地使用权到期日期
,replace(replace(t1.land_usage_cd,chr(13),''),chr(10),'') as land_usage_cd --土地用途代码
,t1.land_use_right_area as land_use_right_area --土地使用权面积
,replace(replace(t1.idle_land_type_cd,chr(13),''),chr(10),'') as idle_land_type_cd --闲置土地类型代码
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd --所在省代码
,replace(replace(t1.local_city_cd,chr(13),''),chr(10),'') as local_city_cd --所在市代码
,replace(replace(t1.local_rg_cd,chr(13),''),chr(10),'') as local_rg_cd --所在区代码
,replace(replace(t1.street_name,chr(13),''),chr(10),'') as street_name --街道名称
,replace(replace(t1.phys_addr,chr(13),''),chr(10),'') as phys_addr --物理地址
,replace(replace(t1.parcel_id,chr(13),''),chr(10),'') as parcel_id --宗地编号
,t1.buy_dt as buy_dt --购入日期
,t1.buy_amt as buy_amt --购入金额
,replace(replace(t1.attachmen_flg,chr(13),''),chr(10),'') as attachmen_flg --附着物标志
,replace(replace(t1.attachmen_type_cd,chr(13),''),chr(10),'') as attachmen_type_cd --附着物类型代码
,t1.build_qtty as build_qtty --建筑物数量
,replace(replace(t1.attachmen_owner_name,chr(13),''),chr(10),'') as attachmen_owner_name --附着物所有人名称
,replace(replace(t1.attachmen_owner_type_cd,chr(13),''),chr(10),'') as attachmen_owner_type_cd --附着物所有人类型代码
,t1.attachmen_tot_area as attachmen_tot_area --附着物总面积
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt --其他说明
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_arch_land_use_info t1    --押品建设用地使用权信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_arch_land_use_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
