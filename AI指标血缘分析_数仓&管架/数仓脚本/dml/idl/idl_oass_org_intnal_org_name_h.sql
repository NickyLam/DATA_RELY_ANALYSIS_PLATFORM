/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_org_intnal_org_name_h
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
alter table ${idl_schema}.oass_org_intnal_org_name_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_org_intnal_org_name_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_org_intnal_org_name_h (
etl_dt  --数据日期
,intnal_org_name_type_cd  --内部机构名称类型代码
,org_name  --机构名称
,org_abbr  --机构简称
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,org_id  --机构编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.intnal_org_name_type_cd,chr(13),''),chr(10),'') as intnal_org_name_type_cd --内部机构名称类型代码
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name --机构名称
,replace(replace(t1.org_abbr,chr(13),''),chr(10),'') as org_abbr --机构简称
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id --机构编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.org_intnal_org_name_h t1    --内部机构名称历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_org_intnal_org_name_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
