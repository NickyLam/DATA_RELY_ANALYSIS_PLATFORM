/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_prft_weight_info
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
alter table ${idl_schema}.oass_ast_col_prft_weight_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_prft_weight_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_prft_weight_info (
etl_dt  --ETL处理日期
,prft_weight_gover_doc_id  --收益权政府批文编号
,prft_weight_gover_doc_name  --收益权政府批文名称
,eqty_cert_id  --权益证书编号
,eqty_owner_name  --权益所有人名称
,eqty_start_dt  --权益开始日期
,eqty_exp_dt  --权益到期日期
,other_comnt  --其他说明
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.prft_weight_gover_doc_id,chr(13),''),chr(10),'') as prft_weight_gover_doc_id --收益权政府批文编号
,replace(replace(t1.prft_weight_gover_doc_name,chr(13),''),chr(10),'') as prft_weight_gover_doc_name --收益权政府批文名称
,replace(replace(t1.eqty_cert_id,chr(13),''),chr(10),'') as eqty_cert_id --权益证书编号
,replace(replace(t1.eqty_owner_name,chr(13),''),chr(10),'') as eqty_owner_name --权益所有人名称
,t1.eqty_start_dt as eqty_start_dt --权益开始日期
,t1.eqty_exp_dt as eqty_exp_dt --权益到期日期
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt --其他说明
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_prft_weight_info t1    --押品收益权信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_prft_weight_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
