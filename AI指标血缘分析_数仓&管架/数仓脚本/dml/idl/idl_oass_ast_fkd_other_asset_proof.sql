/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_fkd_other_asset_proof
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
alter table ${idl_schema}.oass_ast_fkd_other_asset_proof drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_fkd_other_asset_proof add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_fkd_other_asset_proof (
etl_dt  --数据日期
,asset_proof_list_id  --资产证明列表编号
,bus_flow_num  --业务流水号
,other_asset_proof_type  --其他资产证明类型
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.asset_proof_list_id,chr(13),''),chr(10),'') as asset_proof_list_id --资产证明列表编号
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num --业务流水号
,replace(replace(t1.other_asset_proof_type,chr(13),''),chr(10),'') as other_asset_proof_type --其他资产证明类型
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_fkd_other_asset_proof t1    --房快贷其他资产证明
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_fkd_other_asset_proof',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
