/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_rgst_info
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
alter table ${idl_schema}.oass_ast_col_rgst_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_rgst_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_rgst_info (
etl_dt  --ETL处理日期
,rgst_seq_num  --登记序号
,rgst_org_name  --登记机构名称
,rgst_val  --已抵押价值
,rgst_dt  --登记日期
,rgst_exp_dt  --登记有效终止日期
,pre_mtg_flg  --预抵押标志
,pre_mtg_rgst_dt  --预抵押登记日期
,pre_mtg_rgst_invalid_dt  --预抵押登记失效日期
,operr_id  --操作员编号
,rgst_cert_id  --登记证书编号
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.rgst_seq_num,chr(13),''),chr(10),'') as rgst_seq_num --登记序号
,replace(replace(t1.rgst_org_name,chr(13),''),chr(10),'') as rgst_org_name --登记机构名称
,t1.rgst_val as rgst_val --已抵押价值
,t1.rgst_dt as rgst_dt --登记日期
,t1.rgst_exp_dt as rgst_exp_dt --登记有效终止日期
,replace(replace(t1.pre_mtg_flg,chr(13),''),chr(10),'') as pre_mtg_flg --预抵押标志
,t1.pre_mtg_rgst_dt as pre_mtg_rgst_dt --预抵押登记日期
,t1.pre_mtg_rgst_invalid_dt as pre_mtg_rgst_invalid_dt --预抵押登记失效日期
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id --操作员编号
,replace(replace(t1.rgst_cert_id,chr(13),''),chr(10),'') as rgst_cert_id --登记证书编号
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_rgst_info t1    --押品登记信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_rgst_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
