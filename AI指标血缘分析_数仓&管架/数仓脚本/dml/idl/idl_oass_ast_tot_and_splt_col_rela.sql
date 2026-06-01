/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_tot_and_splt_col_rela
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
alter table ${idl_schema}.oass_ast_tot_and_splt_col_rela drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_tot_and_splt_col_rela add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_tot_and_splt_col_rela (
etl_dt  --数据日期
,lp_id  --法人编号
,sup_chain_sys_merchd_id  --供应链系统商品编号
,invtry_id  --库存编号
,inpwn_id  --质押编号
,guar_contr_no  --担保合同号码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,parent_asset_id  --父资产编号
,sub_asset_id  --子资产编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.sup_chain_sys_merchd_id,chr(13),''),chr(10),'') as sup_chain_sys_merchd_id --供应链系统商品编号
,replace(replace(t1.invtry_id,chr(13),''),chr(10),'') as invtry_id --库存编号
,replace(replace(t1.inpwn_id,chr(13),''),chr(10),'') as inpwn_id --质押编号
,replace(replace(t1.guar_contr_no,chr(13),''),chr(10),'') as guar_contr_no --担保合同号码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.parent_asset_id,chr(13),''),chr(10),'') as parent_asset_id --父资产编号
,replace(replace(t1.sub_asset_id,chr(13),''),chr(10),'') as sub_asset_id --子资产编号
from ${iml_schema}.ast_tot_and_splt_col_rela t1    --总押品与拆分押品关系表
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_tot_and_splt_col_rela',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
