/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_clock_in_record
CreateDate: 20250509
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_clock_in_record drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_clock_in_record add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_clock_in_record (
etl_dt  --数据日期
,serialno  --流水号
,opttype  --操作类型
,clockintype  --打卡类型
,ptytype  --客户类型
,ptyname  --客户姓名
,cellphonenum  --手机号
,loaninteamt  --贷款意向金额(元)
,wthrcancel  --是否作废
,cancelreason  --作废原因
,ptymanagerid  --客户经理编号
,ptymanagername  --客户经理姓名
,taskstatus  --任务状态
,inputuserid  --登记人
,inputorgid  --登记机构
,inputdate  --登记日期
,updateuserid  --更新人
,updateorgid  --更新机构
,updatedate  --更新日期
,finishtime  --完成时间

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --流水号
,replace(replace(t1.opttype,chr(13),''),chr(10),'') as opttype --操作类型
,replace(replace(t1.clockintype,chr(13),''),chr(10),'') as clockintype --打卡类型
,replace(replace(t1.ptytype,chr(13),''),chr(10),'') as ptytype --客户类型
,replace(replace(t1.ptyname,chr(13),''),chr(10),'') as ptyname --客户姓名
,replace(replace(t1.cellphonenum,chr(13),''),chr(10),'') as cellphonenum --手机号
,t1.loaninteamt as loaninteamt --贷款意向金额(元)
,replace(replace(t1.wthrcancel,chr(13),''),chr(10),'') as wthrcancel --是否作废
,replace(replace(t1.cancelreason,chr(13),''),chr(10),'') as cancelreason --作废原因
,replace(replace(t1.ptymanagerid,chr(13),''),chr(10),'') as ptymanagerid --客户经理编号
,replace(replace(t1.ptymanagername,chr(13),''),chr(10),'') as ptymanagername --客户经理姓名
,replace(replace(t1.taskstatus,chr(13),''),chr(10),'') as taskstatus --任务状态
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid --登记人
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid --登记机构
,t1.inputdate as inputdate --登记日期
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid --更新人
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid --更新机构
,t1.updatedate as updatedate --更新日期
,t1.finishtime as finishtime --完成时间
from ${iol_schema}.icms_clock_in_record t1    --打卡记录表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_clock_in_record',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
