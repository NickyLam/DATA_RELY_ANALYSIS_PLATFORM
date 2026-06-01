/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_uuss_uus_domain
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
alter table ${idl_schema}.oass_uuss_uus_domain drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_uuss_uus_domain add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_uuss_uus_domain (
etl_dt  --数据日期
,name  --姓名
,sysstatus  --员工系统状态 1-正常 2-锁定
,companycountrycode  --单位电话国际区号
,companyareacode  --单位电话国内区号
,companyphone  --单位电话
,companysubphone  --单位电话分机号
,mobile  --移动电话
,post  --邮政编码
,address  --详细地址
,email  --电子邮箱
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,domainid  --域帐号
,employeeid  --员工编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.name,chr(13),''),chr(10),'') as name --姓名
,replace(replace(t1.sysstatus,chr(13),''),chr(10),'') as sysstatus --员工系统状态 1-正常 2-锁定
,replace(replace(t1.companycountrycode,chr(13),''),chr(10),'') as companycountrycode --单位电话国际区号
,replace(replace(t1.companyareacode,chr(13),''),chr(10),'') as companyareacode --单位电话国内区号
,replace(replace(t1.companyphone,chr(13),''),chr(10),'') as companyphone --单位电话
,replace(replace(t1.companysubphone,chr(13),''),chr(10),'') as companysubphone --单位电话分机号
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile --移动电话
,replace(replace(t1.post,chr(13),''),chr(10),'') as post --邮政编码
,replace(replace(t1.address,chr(13),''),chr(10),'') as address --详细地址
,replace(replace(t1.email,chr(13),''),chr(10),'') as email --电子邮箱
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.domainid,chr(13),''),chr(10),'') as domainid --域帐号
,replace(replace(t1.employeeid,chr(13),''),chr(10),'') as employeeid --员工编号
from ${iol_schema}.uuss_uus_domain t1    --域用户信息表
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_uuss_uus_domain',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
