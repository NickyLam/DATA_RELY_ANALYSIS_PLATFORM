/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_other_estate_info
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
alter table ${idl_schema}.oass_ast_col_other_estate_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_other_estate_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_other_estate_info (
etl_dt  --ETL处理日期
,ready_house_flg  --现房标志
,presell_lics_id  --预售许可证编号
,house_used_flg  --一手二手标志
,two_in_one_flg  --两证合一标志
,rel_esat_wat_id  --房产证号
,all_mtg_flg  --全部抵押标志
,bs_cont_id  --买卖合同编号
,buy_dt  --购房日期
,buy_amt  --购房金额
,purch_estate_flg  --本次申购房产标志
,uniq_housing_flg  --唯一住房标志
,arch_area  --建筑面积
,usbl_area  --实用面积
,build_year  --建成年份
,prop_tenor  --产权期限
,build_age  --楼龄
,orient_cd  --朝向代码
,stru_type_cd  --结构类型代码
,local_prov_cd  --所在省代码
,local_city_cd  --所在市代码
,local_rg_cd  --所在区代码
,street_name  --街道名称
,street_id  --街道编号
,dplat_id  --门牌编号
,rel_esat_wat_rgst_addr  --不动产权证登记地址
,estat_name  --楼盘名称
,floor_cnt  --楼层数
,tot_floor_cnt  --总楼层数
,land_use_right_id  --土地证号
,land_char_cd  --土地所有权性质代码
,land_get_way_cd  --土地取得方式代码
,land_use_right_begin_dt  --土地使用权起始日期
,land_use_right_exp_dt  --土地使用权到期日期
,land_use_right_years  --土地使用权年限
,land_usage_cd  --土地用途代码
,other_prop_cert_flg  --已有他项权证标志
,curr_cd  --币种代码
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.ready_house_flg,chr(13),''),chr(10),'') as ready_house_flg --现房标志
,replace(replace(t1.presell_lics_id,chr(13),''),chr(10),'') as presell_lics_id --预售许可证编号
,replace(replace(t1.house_used_flg,chr(13),''),chr(10),'') as house_used_flg --一手二手标志
,replace(replace(t1.two_in_one_flg,chr(13),''),chr(10),'') as two_in_one_flg --两证合一标志
,replace(replace(t1.rel_esat_wat_id,chr(13),''),chr(10),'') as rel_esat_wat_id --房产证号
,replace(replace(t1.all_mtg_flg,chr(13),''),chr(10),'') as all_mtg_flg --全部抵押标志
,replace(replace(t1.bs_cont_id,chr(13),''),chr(10),'') as bs_cont_id --买卖合同编号
,t1.buy_dt as buy_dt --购房日期
,t1.buy_amt as buy_amt --购房金额
,replace(replace(t1.purch_estate_flg,chr(13),''),chr(10),'') as purch_estate_flg --本次申购房产标志
,replace(replace(t1.uniq_housing_flg,chr(13),''),chr(10),'') as uniq_housing_flg --唯一住房标志
,t1.arch_area as arch_area --建筑面积
,t1.usbl_area as usbl_area --实用面积
,replace(replace(t1.build_year,chr(13),''),chr(10),'') as build_year --建成年份
,t1.prop_tenor as prop_tenor --产权期限
,t1.build_age as build_age --楼龄
,replace(replace(t1.orient_cd,chr(13),''),chr(10),'') as orient_cd --朝向代码
,replace(replace(t1.stru_type_cd,chr(13),''),chr(10),'') as stru_type_cd --结构类型代码
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd --所在省代码
,replace(replace(t1.local_city_cd,chr(13),''),chr(10),'') as local_city_cd --所在市代码
,replace(replace(t1.local_rg_cd,chr(13),''),chr(10),'') as local_rg_cd --所在区代码
,replace(replace(t1.street_name,chr(13),''),chr(10),'') as street_name --街道名称
,replace(replace(t1.street_id,chr(13),''),chr(10),'') as street_id --街道编号
,replace(replace(t1.dplat_id,chr(13),''),chr(10),'') as dplat_id --门牌编号
,replace(replace(t1.rel_esat_wat_rgst_addr,chr(13),''),chr(10),'') as rel_esat_wat_rgst_addr --不动产权证登记地址
,replace(replace(t1.estat_name,chr(13),''),chr(10),'') as estat_name --楼盘名称
,replace(replace(t1.floor_cnt,chr(13),''),chr(10),'') as floor_cnt --楼层数
,t1.tot_floor_cnt as tot_floor_cnt --总楼层数
,replace(replace(t1.land_use_right_id,chr(13),''),chr(10),'') as land_use_right_id --土地证号
,replace(replace(t1.land_char_cd,chr(13),''),chr(10),'') as land_char_cd --土地所有权性质代码
,replace(replace(t1.land_get_way_cd,chr(13),''),chr(10),'') as land_get_way_cd --土地取得方式代码
,t1.land_use_right_begin_dt as land_use_right_begin_dt --土地使用权起始日期
,t1.land_use_right_exp_dt as land_use_right_exp_dt --土地使用权到期日期
,t1.land_use_right_years as land_use_right_years --土地使用权年限
,replace(replace(t1.land_usage_cd,chr(13),''),chr(10),'') as land_usage_cd --土地用途代码
,replace(replace(t1.other_prop_cert_flg,chr(13),''),chr(10),'') as other_prop_cert_flg --已有他项权证标志
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_other_estate_info t1    --押品其他房地产信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_other_estate_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
