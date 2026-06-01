/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_inv_info
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
alter table ${idl_schema}.oass_ast_col_inv_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_inv_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_inv_info (
etl_dt  --ETL处理日期
,inv_type_descb  --存货类型描述
,local_prov_cd  --所在省代码
,local_city_cd  --所在市代码
,measure_corp_cd  --计量单位代码
,qtty  --数量
,apprv_price  --核定价格
,supv_corp_supv_flg  --监管公司监管标志
,supv_corp_name  --监管公司名称
,supv_corp_orgnz_cd  --监管公司组织机构代码
,agt_effect_dt  --协议生效日期
,agt_invalid_dt  --协议失效日期
,other_comnt  --其他说明
,other_measure_corp  --其他计量单位
,curr_cd  --币种代码
,mtg_rgst_b_id  --抵押登记书编号
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.inv_type_descb,chr(13),''),chr(10),'') as inv_type_descb --存货类型描述
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd --所在省代码
,replace(replace(t1.local_city_cd,chr(13),''),chr(10),'') as local_city_cd --所在市代码
,replace(replace(t1.measure_corp_cd,chr(13),''),chr(10),'') as measure_corp_cd --计量单位代码
,t1.qtty as qtty --数量
,t1.apprv_price as apprv_price --核定价格
,replace(replace(t1.supv_corp_supv_flg,chr(13),''),chr(10),'') as supv_corp_supv_flg --监管公司监管标志
,replace(replace(t1.supv_corp_name,chr(13),''),chr(10),'') as supv_corp_name --监管公司名称
,replace(replace(t1.supv_corp_orgnz_cd,chr(13),''),chr(10),'') as supv_corp_orgnz_cd --监管公司组织机构代码
,t1.agt_effect_dt as agt_effect_dt --协议生效日期
,t1.agt_invalid_dt as agt_invalid_dt --协议失效日期
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt --其他说明
,replace(replace(t1.other_measure_corp,chr(13),''),chr(10),'') as other_measure_corp --其他计量单位
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,replace(replace(t1.mtg_rgst_b_id,chr(13),''),chr(10),'') as mtg_rgst_b_id --抵押登记书编号
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_inv_info t1    --押品存货信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_inv_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
