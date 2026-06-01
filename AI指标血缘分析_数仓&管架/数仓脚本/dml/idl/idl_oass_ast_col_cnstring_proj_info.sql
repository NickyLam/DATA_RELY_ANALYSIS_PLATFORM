/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_cnstring_proj_info
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
alter table ${idl_schema}.oass_ast_col_cnstring_proj_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_cnstring_proj_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_cnstring_proj_info (
etl_dt  --ETL处理日期
,rel_esat_wat_id  --房产证号
,land_char_cd  --土地所有权性质代码
,land_get_way_cd  --土地取得方式代码
,land_use_right_begin_dt  --土地使用权起始日期
,land_use_right_exp_dt  --土地使用权到期日期
,land_use_right_years  --土地使用权年限
,land_area  --土地面积
,land_tranf_fee_amt  --土地出让金金额
,land_tranf_fee_dlvy_flg  --土地出让金交付标志
,attach_tranf_fee_amt  --应补出让金金额
,land_usage_cd  --土地用途代码
,proj_proj_name  --工程项目名称
,cnstr_land_use_permit_id  --建设用地规划许可证号
,cnstr_proj_plan_permit_id  --建设工程规划许可证号
,proj_cnstr_lics_id  --建设工程施工许可证号
,start_work_dt  --开工日期
,expect_cmplt_dt  --预计竣工日期
,proj_expect_tot_cost  --工程预计总造价
,arch_area  --建筑面积
,tot_floor_cnt  --总楼层数
,rent_flg  --出租标志
,local_prov_cd  --所在省代码
,local_city_cd  --所在市代码
,local_rg_cd  --所在区代码
,street_name  --街道名称
,dplat_id  --门牌编号
,phys_addr  --物理地址
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
,t1.land_use_right_years as land_use_right_years --土地使用权年限
,t1.land_area as land_area --土地面积
,t1.land_tranf_fee_amt as land_tranf_fee_amt --土地出让金金额
,replace(replace(t1.land_tranf_fee_dlvy_flg,chr(13),''),chr(10),'') as land_tranf_fee_dlvy_flg --土地出让金交付标志
,t1.attach_tranf_fee_amt as attach_tranf_fee_amt --应补出让金金额
,replace(replace(t1.land_usage_cd,chr(13),''),chr(10),'') as land_usage_cd --土地用途代码
,replace(replace(t1.proj_proj_name,chr(13),''),chr(10),'') as proj_proj_name --工程项目名称
,replace(replace(t1.cnstr_land_use_permit_id,chr(13),''),chr(10),'') as cnstr_land_use_permit_id --建设用地规划许可证号
,replace(replace(t1.cnstr_proj_plan_permit_id,chr(13),''),chr(10),'') as cnstr_proj_plan_permit_id --建设工程规划许可证号
,replace(replace(t1.proj_cnstr_lics_id,chr(13),''),chr(10),'') as proj_cnstr_lics_id --建设工程施工许可证号
,t1.start_work_dt as start_work_dt --开工日期
,t1.expect_cmplt_dt as expect_cmplt_dt --预计竣工日期
,t1.proj_expect_tot_cost as proj_expect_tot_cost --工程预计总造价
,t1.arch_area as arch_area --建筑面积
,t1.tot_floor_cnt as tot_floor_cnt --总楼层数
,replace(replace(t1.rent_flg,chr(13),''),chr(10),'') as rent_flg --出租标志
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd --所在省代码
,replace(replace(t1.local_city_cd,chr(13),''),chr(10),'') as local_city_cd --所在市代码
,replace(replace(t1.local_rg_cd,chr(13),''),chr(10),'') as local_rg_cd --所在区代码
,replace(replace(t1.street_name,chr(13),''),chr(10),'') as street_name --街道名称
,replace(replace(t1.dplat_id,chr(13),''),chr(10),'') as dplat_id --门牌编号
,replace(replace(t1.phys_addr,chr(13),''),chr(10),'') as phys_addr --物理地址
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt --其他说明
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_cnstring_proj_info t1    --押品在建工程信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_cnstring_proj_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
