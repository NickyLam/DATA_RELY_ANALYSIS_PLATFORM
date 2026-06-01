/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_comer_build_info
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
alter table ${idl_schema}.oass_ast_col_comer_build_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_comer_build_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_comer_build_info (
etl_dt  --ETL处理日期
,house_used_flg  --一手二手标志
,two_in_one_flg  --两证合一标志
,rel_esat_wat_id  --房产证号
,all_mtg_flg  --全部抵押标志
,bs_cont_id  --买卖合同编号
,buy_dt  --购房日期
,buy_amt  --购房金额
,arch_area  --建筑面积
,usbl_area  --实用面积
,build_year  --建成年份
,build_age  --楼龄
,stru_type_cd  --结构类型代码
,local_prov_cd  --所在省代码
,local_city_cd  --所在市代码
,local_rg_cd  --所在区代码
,street_name  --街道名称
,dplat_id  --门牌编号
,rel_esat_wat_rgst_addr  --不动产权证登记地址
,floor_cnt  --楼层数
,tot_floor_cnt  --总楼层数
,status_cd  --状态代码
,prop_tenor  --产权期限
,land_use_right_id  --土地证号
,land_char_cd  --土地所有权性质代码
,land_get_way_cd  --土地取得方式代码
,land_use_right_begin_dt  --土地使用权起始日期
,land_use_right_exp_dt  --土地使用权到期日期
,land_use_right_years  --土地使用权年限
,land_usage_cd  --土地用途代码
,other_prop_cert_flg  --已有他项权证标志
,other_comnt  --其他说明
,rent_flg  --出租标志
,tentry_name  --承租人名称
,rent_begin_dt  --出租起始日期
,rent_exp_dt  --出租到期日期
,rent_situ_comnt  --出租情况说明
,curr_cd  --币种代码
,prop_surp_tenor  --产权剩余期限
,monly_mgmt_fee  --每月管理费
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.house_used_flg,chr(13),''),chr(10),'') as house_used_flg --一手二手标志
,replace(replace(t1.two_in_one_flg,chr(13),''),chr(10),'') as two_in_one_flg --两证合一标志
,replace(replace(t1.rel_esat_wat_id,chr(13),''),chr(10),'') as rel_esat_wat_id --房产证号
,replace(replace(t1.all_mtg_flg,chr(13),''),chr(10),'') as all_mtg_flg --全部抵押标志
,replace(replace(t1.bs_cont_id,chr(13),''),chr(10),'') as bs_cont_id --买卖合同编号
,t1.buy_dt as buy_dt --购房日期
,t1.buy_amt as buy_amt --购房金额
,t1.arch_area as arch_area --建筑面积
,t1.usbl_area as usbl_area --实用面积
,replace(replace(t1.build_year,chr(13),''),chr(10),'') as build_year --建成年份
,t1.build_age as build_age --楼龄
,replace(replace(t1.stru_type_cd,chr(13),''),chr(10),'') as stru_type_cd --结构类型代码
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd --所在省代码
,replace(replace(t1.local_city_cd,chr(13),''),chr(10),'') as local_city_cd --所在市代码
,replace(replace(t1.local_rg_cd,chr(13),''),chr(10),'') as local_rg_cd --所在区代码
,replace(replace(t1.street_name,chr(13),''),chr(10),'') as street_name --街道名称
,replace(replace(t1.dplat_id,chr(13),''),chr(10),'') as dplat_id --门牌编号
,replace(replace(t1.rel_esat_wat_rgst_addr,chr(13),''),chr(10),'') as rel_esat_wat_rgst_addr --不动产权证登记地址
,replace(replace(t1.floor_cnt,chr(13),''),chr(10),'') as floor_cnt --楼层数
,t1.tot_floor_cnt as tot_floor_cnt --总楼层数
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd --状态代码
,t1.prop_tenor as prop_tenor --产权期限
,replace(replace(t1.land_use_right_id,chr(13),''),chr(10),'') as land_use_right_id --土地证号
,replace(replace(t1.land_char_cd,chr(13),''),chr(10),'') as land_char_cd --土地所有权性质代码
,replace(replace(t1.land_get_way_cd,chr(13),''),chr(10),'') as land_get_way_cd --土地取得方式代码
,t1.land_use_right_begin_dt as land_use_right_begin_dt --土地使用权起始日期
,t1.land_use_right_exp_dt as land_use_right_exp_dt --土地使用权到期日期
,t1.land_use_right_years as land_use_right_years --土地使用权年限
,replace(replace(t1.land_usage_cd,chr(13),''),chr(10),'') as land_usage_cd --土地用途代码
,replace(replace(t1.other_prop_cert_flg,chr(13),''),chr(10),'') as other_prop_cert_flg --已有他项权证标志
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt --其他说明
,replace(replace(t1.rent_flg,chr(13),''),chr(10),'') as rent_flg --出租标志
,replace(replace(t1.tentry_name,chr(13),''),chr(10),'') as tentry_name --承租人名称
,t1.rent_begin_dt as rent_begin_dt --出租起始日期
,t1.rent_exp_dt as rent_exp_dt --出租到期日期
,replace(replace(t1.rent_situ_comnt,chr(13),''),chr(10),'') as rent_situ_comnt --出租情况说明
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.prop_surp_tenor as prop_surp_tenor --产权剩余期限
,t1.monly_mgmt_fee as monly_mgmt_fee --每月管理费
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_comer_build_info t1    --押品商业用房信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_comer_build_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
