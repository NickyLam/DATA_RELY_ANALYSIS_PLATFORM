/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_estat_avg_info
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
alter table ${idl_schema}.oass_ast_estat_avg_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_estat_avg_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_estat_avg_info (
etl_dt  --数据日期
,lp_id  --法人编号
,local_prov_cd  --所在省代码
,local_city_cd  --所在市代码
,local_rg_cd  --所在区代码
,estat_name  --楼盘名称
,ext_estim_price  --外部评估价格
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,batch_dt  --批次日期
,estat_id  --楼盘编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd --所在省代码
,replace(replace(t1.local_city_cd,chr(13),''),chr(10),'') as local_city_cd --所在市代码
,replace(replace(t1.local_rg_cd,chr(13),''),chr(10),'') as local_rg_cd --所在区代码
,replace(replace(t1.estat_name,chr(13),''),chr(10),'') as estat_name --楼盘名称
,t1.ext_estim_price as ext_estim_price --外部评估价格
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.batch_dt,chr(13),''),chr(10),'') as batch_dt --批次日期
,replace(replace(t1.estat_id,chr(13),''),chr(10),'') as estat_id --楼盘编号
from ${iml_schema}.ast_estat_avg_info t1    --楼盘均价信息
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_estat_avg_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
