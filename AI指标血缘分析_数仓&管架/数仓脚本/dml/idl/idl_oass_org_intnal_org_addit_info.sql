/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_org_intnal_org_addit_info
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
alter table ${idl_schema}.oass_org_intnal_org_addit_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_org_intnal_org_addit_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_org_intnal_org_addit_info (
etl_dt  --ETL处理日期
,bus_lics_num  --营业执照号码
,work_start_tm  --工作开始时间
,work_end_tm  --工作结束时间
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,org_id  --机构编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.bus_lics_num,chr(13),''),chr(10),'') as bus_lics_num --营业执照号码
,replace(replace(t1.work_start_tm,chr(13),''),chr(10),'') as work_start_tm --工作开始时间
,replace(replace(t1.work_end_tm,chr(13),''),chr(10),'') as work_end_tm --工作结束时间
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id --机构编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.org_intnal_org_addit_info t1    --内部机构附加信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_org_intnal_org_addit_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
