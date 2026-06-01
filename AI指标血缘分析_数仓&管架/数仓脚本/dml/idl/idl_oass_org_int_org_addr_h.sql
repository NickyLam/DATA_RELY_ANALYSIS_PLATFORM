/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_org_int_org_addr_h
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
alter table ${idl_schema}.oass_org_int_org_addr_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_org_int_org_addr_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_org_int_org_addr_h (
etl_dt  --数据日期
,tel_num  --电话号码
,zip_cd  --邮政编码
,cty_or_rg_cd  --国家或地区代码
,prov_cd  --省代码
,city_cd  --市代码
,county_cd  --县代码
,dtl_addr  --详细地址
,princ_emply_id  --负责人员工编号
,princ_name  --负责人姓名
,ddd_area_cd  --国内长途区号
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,org_id  --机构编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num --电话号码
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd --邮政编码
,replace(replace(t1.cty_or_rg_cd,chr(13),''),chr(10),'') as cty_or_rg_cd --国家或地区代码
,replace(replace(t1.prov_cd,chr(13),''),chr(10),'') as prov_cd --省代码
,replace(replace(t1.city_cd,chr(13),''),chr(10),'') as city_cd --市代码
,replace(replace(t1.county_cd,chr(13),''),chr(10),'') as county_cd --县代码
,replace(replace(t1.dtl_addr,chr(13),''),chr(10),'') as dtl_addr --详细地址
,replace(replace(t1.princ_emply_id,chr(13),''),chr(10),'') as princ_emply_id --负责人员工编号
,replace(replace(t1.princ_name,chr(13),''),chr(10),'') as princ_name --负责人姓名
,replace(replace(t1.ddd_area_cd,chr(13),''),chr(10),'') as ddd_area_cd --国内长途区号
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id --机构编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.org_int_org_addr_h t1    --内部机构地址历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_org_int_org_addr_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
