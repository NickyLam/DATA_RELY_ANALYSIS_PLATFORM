/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_other_mtg_info
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
alter table ${idl_schema}.oass_ast_col_other_mtg_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_other_mtg_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_other_mtg_info (
etl_dt  --ETL处理日期
,col_name  --押品名称
,col_qtty  --押品数量
,measure_corp_cd  --计量单位代码
,col_val  --押品价值
,col_store_addr  --押品存放地址
,prop_get_dt  --所有权取得日期
,col_ori_price_val  --押品原价值
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
,replace(replace(t1.col_name,chr(13),''),chr(10),'') as col_name --押品名称
,t1.col_qtty as col_qtty --押品数量
,replace(replace(t1.measure_corp_cd,chr(13),''),chr(10),'') as measure_corp_cd --计量单位代码
,t1.col_val as col_val --押品价值
,replace(replace(t1.col_store_addr,chr(13),''),chr(10),'') as col_store_addr --押品存放地址
,t1.prop_get_dt as prop_get_dt --所有权取得日期
,t1.col_ori_price_val as col_ori_price_val --押品原价值
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt --其他说明
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_other_mtg_info t1    --押品其他抵押物信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_other_mtg_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
