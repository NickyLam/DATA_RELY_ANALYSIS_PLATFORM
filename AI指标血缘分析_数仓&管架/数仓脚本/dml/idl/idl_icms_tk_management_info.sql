/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_tk_management_info
CreateDate: 20241105
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_tk_management_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_tk_management_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_tk_management_info (
serialno  --流水号
,batchdate  --批次日期
,userid  --推送用户编号
,userdomainid  --推送用户域账号
,customerid  --客户号
,customername  --客户名称
,inputdate  --登记日期
,etl_dt  --etl处理日期
,etl_timestamp --etl处理时间戳

)
select
replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --流水号
,replace(replace(t1.batchdate,chr(13),''),chr(10),'') as batchdate --批次日期
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid --推送用户编号
,replace(replace(t1.userdomainid,chr(13),''),chr(10),'') as userdomainid --推送用户域账号
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid --客户号
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername --客户名称
,t1.inputdate as inputdate --登记日期
,to_date('${batch_date}','yyyymmdd') as etl_dt --etl处理日期
,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --etl处理时间戳

from ${iol_schema}.icms_tk_management_info t1    --经营平台推送消息主表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') - 1;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_tk_management_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
