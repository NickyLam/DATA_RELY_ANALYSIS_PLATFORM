/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ibms_ttrd_accounting_cash_obj
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj drop partition p_${last_date};
alter table ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ibms_ttrd_accounting_cash_obj (
    etl_dt  -- 数据日期
    ,obj_id  -- 对象Id
    ,tsk_id  -- 任务Id
    ,beg_date  -- 开始日期
    ,end_date  -- 结束日期
    ,ext_cash_acct_id  -- 外部资金账户
    ,cash_acct_id  -- 内部资金账户
    ,currency  -- 币种
    ,real_amount  -- 余额
    ,real_margin  -- 期货保证金
    ,open_time  -- 开仓时间
    ,update_time  -- 更新时间
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.obj_id,chr(13),''),chr(10),'')  -- 对象Id
    ,replace(replace(t1.tsk_id,chr(13),''),chr(10),'')  -- 任务Id
    ,replace(replace(t1.beg_date,chr(13),''),chr(10),'')  -- 开始日期
    ,replace(replace(t1.end_date,chr(13),''),chr(10),'')  -- 结束日期
    ,replace(replace(t1.ext_cash_acct_id,chr(13),''),chr(10),'')  -- 外部资金账户
    ,replace(replace(t1.cash_acct_id,chr(13),''),chr(10),'')  -- 内部资金账户
    ,replace(replace(t1.currency,chr(13),''),chr(10),'')  -- 币种
    ,t1.real_amount  -- 余额
    ,t1.real_margin  -- 期货保证金
    ,replace(replace(t1.open_time,chr(13),''),chr(10),'')  -- 开仓时间
    ,replace(replace(t1.update_time,chr(13),''),chr(10),'')  -- 更新时间
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ibms_ttrd_accounting_cash_obj t1    --同业活期账户信息
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ibms_ttrd_accounting_cash_obj',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);