/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_fkd_estate_info
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
alter table ${idl_schema}.oass_ast_fkd_estate_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_fkd_estate_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_fkd_estate_info (
etl_dt  --数据日期
,lp_id  --法人编号
,bus_flow_num  --业务流水号
,city_cd  --城市代码
,city_name  --城市名称
,rg_cd  --区域代码
,rg_name  --区域名称
,estat_id  --楼盘编号
,comm_addr  --小区地址
,estat_position  --楼盘位置
,estate_type_cd  --房产类型代码
,house_id  --楼编号
,floor_num  --楼层号
,unit_num  --单元室号
,estate_fitmt_situ_cd  --房产装修情况代码
,orient_cd  --朝向代码
,estim_corp_name  --评估机构名称
,onl_estim_val  --线上评估价值
,estim_way_cd  --评估方式代码
,formal_estim_val  --正式评估价值
,house_area  --房屋面积
,build_year  --建成年份
,ths_tm_mtg_flg  --本次抵押标志
,empty_flg  --清房标志
,vacy_flg  --空置标志
,rent_flg  --出租标志
,rent_dt  --出租日期
,get_house_dt  --取房日期
,get_house_way_cd  --取房方式代码
,prop_exp_dt  --产权到期日期
,prop_co_ownr_rela_cd  --产权共有人关系代码
,lh_obg_cd  --上手权利人代码
,lh_mtg_amt  --上手抵押金额
,land_char_cd  --土地性质代码
,basm_flg  --地下室标志
,arch_area  --建筑面积
,land_up_area  --地上面积
,land_next_area  --地下面积
,resv_house_qtty  --备用房数量
,resv_house_empty_flg  --备用房清房标志
,resv_house_addr  --备用房地址
,entry_dt  --入抵日期
,relief_dt  --解抵日期
,main_debit_ps_obg_flg  --主借人权利人标志
,spouse_obg_flg  --配偶权利人标志
,house_usage  --房屋用途
,tot_floor_cnt  --总楼层数
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,estate_list_id  --房产列表编号
,asset_id  --资产编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num --业务流水号
,replace(replace(t1.city_cd,chr(13),''),chr(10),'') as city_cd --城市代码
,replace(replace(t1.city_name,chr(13),''),chr(10),'') as city_name --城市名称
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd --区域代码
,replace(replace(t1.rg_name,chr(13),''),chr(10),'') as rg_name --区域名称
,replace(replace(t1.estat_id,chr(13),''),chr(10),'') as estat_id --楼盘编号
,replace(replace(t1.comm_addr,chr(13),''),chr(10),'') as comm_addr --小区地址
,replace(replace(t1.estat_position,chr(13),''),chr(10),'') as estat_position --楼盘位置
,replace(replace(t1.estate_type_cd,chr(13),''),chr(10),'') as estate_type_cd --房产类型代码
,replace(replace(t1.house_id,chr(13),''),chr(10),'') as house_id --楼编号
,replace(replace(t1.floor_num,chr(13),''),chr(10),'') as floor_num --楼层号
,replace(replace(t1.unit_num,chr(13),''),chr(10),'') as unit_num --单元室号
,replace(replace(t1.estate_fitmt_situ_cd,chr(13),''),chr(10),'') as estate_fitmt_situ_cd --房产装修情况代码
,replace(replace(t1.orient_cd,chr(13),''),chr(10),'') as orient_cd --朝向代码
,replace(replace(t1.estim_corp_name,chr(13),''),chr(10),'') as estim_corp_name --评估机构名称
,t1.onl_estim_val as onl_estim_val --线上评估价值
,replace(replace(t1.estim_way_cd,chr(13),''),chr(10),'') as estim_way_cd --评估方式代码
,t1.formal_estim_val as formal_estim_val --正式评估价值
,t1.house_area as house_area --房屋面积
,t1.build_year as build_year --建成年份
,replace(replace(t1.ths_tm_mtg_flg,chr(13),''),chr(10),'') as ths_tm_mtg_flg --本次抵押标志
,replace(replace(t1.empty_flg,chr(13),''),chr(10),'') as empty_flg --清房标志
,replace(replace(t1.vacy_flg,chr(13),''),chr(10),'') as vacy_flg --空置标志
,replace(replace(t1.rent_flg,chr(13),''),chr(10),'') as rent_flg --出租标志
,t1.rent_dt as rent_dt --出租日期
,t1.get_house_dt as get_house_dt --取房日期
,replace(replace(t1.get_house_way_cd,chr(13),''),chr(10),'') as get_house_way_cd --取房方式代码
,replace(replace(t1.prop_exp_dt,chr(13),''),chr(10),'') as prop_exp_dt --产权到期日期
,replace(replace(t1.prop_co_ownr_rela_cd,chr(13),''),chr(10),'') as prop_co_ownr_rela_cd --产权共有人关系代码
,replace(replace(t1.lh_obg_cd,chr(13),''),chr(10),'') as lh_obg_cd --上手权利人代码
,t1.lh_mtg_amt as lh_mtg_amt --上手抵押金额
,replace(replace(t1.land_char_cd,chr(13),''),chr(10),'') as land_char_cd --土地性质代码
,replace(replace(t1.basm_flg,chr(13),''),chr(10),'') as basm_flg --地下室标志
,t1.arch_area as arch_area --建筑面积
,t1.land_up_area as land_up_area --地上面积
,t1.land_next_area as land_next_area --地下面积
,t1.resv_house_qtty as resv_house_qtty --备用房数量
,replace(replace(t1.resv_house_empty_flg,chr(13),''),chr(10),'') as resv_house_empty_flg --备用房清房标志
,replace(replace(t1.resv_house_addr,chr(13),''),chr(10),'') as resv_house_addr --备用房地址
,t1.entry_dt as entry_dt --入抵日期
,t1.relief_dt as relief_dt --解抵日期
,replace(replace(t1.main_debit_ps_obg_flg,chr(13),''),chr(10),'') as main_debit_ps_obg_flg --主借人权利人标志
,replace(replace(t1.spouse_obg_flg,chr(13),''),chr(10),'') as spouse_obg_flg --配偶权利人标志
,replace(replace(t1.house_usage,chr(13),''),chr(10),'') as house_usage --房屋用途
,t1.tot_floor_cnt as tot_floor_cnt --总楼层数
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.estate_list_id,chr(13),''),chr(10),'') as estate_list_id --房产列表编号
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
from ${iml_schema}.ast_fkd_estate_info t1    --房快贷房产信息
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_fkd_estate_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
