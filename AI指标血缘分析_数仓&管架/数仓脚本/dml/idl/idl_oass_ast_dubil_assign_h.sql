/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_dubil_assign_h
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
alter table ${idl_schema}.oass_ast_dubil_assign_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_dubil_assign_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_dubil_assign_h (
etl_dt  --数据日期
,dubil_id  --借据编号
,loan_assign_bal  --贷款分配余额
,dubil_bal  --借据余额
,splt_col_latest_val  --拆分押品最新价值
,splt_col_insto_val  --拆分押品入库价值
,in_out_tab_flg  --表内外标志
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id --借据编号
,t1.loan_assign_bal as loan_assign_bal --贷款分配余额
,t1.dubil_bal as dubil_bal --借据余额
,t1.splt_col_latest_val as splt_col_latest_val --拆分押品最新价值
,t1.splt_col_insto_val as splt_col_insto_val --拆分押品入库价值
,replace(replace(t1.in_out_tab_flg,chr(13),''),chr(10),'') as in_out_tab_flg --表内外标志
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_dubil_assign_h t1    --资产借据分配历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_dubil_assign_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
