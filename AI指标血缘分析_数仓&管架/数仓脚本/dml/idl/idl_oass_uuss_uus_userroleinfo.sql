/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_uuss_uus_userroleinfo
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
alter table ${idl_schema}.oass_uuss_uus_userroleinfo drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_uuss_uus_userroleinfo add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_uuss_uus_userroleinfo (
etl_dt  --数据日期
,unitno  --商户
,subunitno  --子商户
,rolecode  --角色代码
,rolename  --角色名称
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,domainid  --域账号
,sysid  --系统标识

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.unitno,chr(13),''),chr(10),'') as unitno --商户
,replace(replace(t1.subunitno,chr(13),''),chr(10),'') as subunitno --子商户
,replace(replace(t1.rolecode,chr(13),''),chr(10),'') as rolecode --角色代码
,replace(replace(t1.rolename,chr(13),''),chr(10),'') as rolename --角色名称
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.domainid,chr(13),''),chr(10),'') as domainid --域账号
,replace(replace(t1.sysid,chr(13),''),chr(10),'') as sysid --系统标识
from ${iol_schema}.uuss_uus_userroleinfo t1    --用户角色信息表
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_uuss_uus_userroleinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
