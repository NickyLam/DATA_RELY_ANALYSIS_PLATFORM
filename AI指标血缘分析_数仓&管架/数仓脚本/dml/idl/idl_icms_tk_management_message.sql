/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_tk_management_message
CreateDate: 20250724
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_tk_management_message drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_tk_management_message add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_tk_management_message (
serialno  --流水号
,objectno  --对象流水
,asstaskno  --关联任务流水号
,objecttype  --消息大类(crwal：客户风险贷后预警;alc：投贷后检查任务)
,messagetype  --消息小类
,subject  --消息主题
,content  --消息主体内容
,inputdate  --登记日期
,datacount  --明细数据行数(对应tk_management_data_detail关联行数)
,etl_dt  --ETL处理日期
,etl_timestamp  --ETL处理时间戳
)
select
replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --流水号
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno --对象流水
,replace(replace(t1.asstaskno,chr(13),''),chr(10),'') as asstaskno --关联任务流水号
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype --消息大类(crwal：客户风险贷后预警;alc：投贷后检查任务)
,replace(replace(t1.messagetype,chr(13),''),chr(10),'') as messagetype --消息小类
,replace(replace(t1.subject,chr(13),''),chr(10),'') as subject --消息主题
,replace(replace(t1.content,chr(13),''),chr(10),'') as content --消息主体内容
,t1.inputdate as inputdate --登记日期
,t1.datacount as datacount --明细数据行数(对应tk_management_data_detail关联行数)
,to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --ETL处理时间戳
from ${iol_schema}.icms_tk_management_message t1    --经营平台推送消息明细表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') - 1;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_tk_management_message',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
