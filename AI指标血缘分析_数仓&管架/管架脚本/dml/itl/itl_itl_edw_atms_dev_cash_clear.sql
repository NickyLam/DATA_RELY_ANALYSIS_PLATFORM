/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_atms_dev_cash_clear
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
alter table ${itl_schema}.itl_edw_atms_dev_cash_clear drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_atms_dev_cash_clear drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_atms_dev_cash_clear add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_atms_dev_cash_clear partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,dev_no  -- 设备号
    ,addcash_id  -- 加钞标识（当前日期+编号，编号为两位，从00~99）
    ,addcash_datetime  -- 加钞日期
    ,addcash_amount  -- 加钞金额
    ,addcash_type  -- 加钞面值集合 如50,100多种面值以逗号分割
    ,addcash_count  -- 加钞张数 如 1000,2000 多种面值与AddCashType的面值对应，同样以逗号分割
    ,clear_datetime  -- 清机时间
    ,addcash_left  -- 主机尾箱余额
    ,addcash_lastamount  -- 钞箱剩余金额（不包括回收箱）
    ,addcash_retractcount  -- 回收箱张数
    ,deposit_count  -- 存款总笔数
    ,deposit_amount  -- 存款总金额
    ,withdraw_count  -- 取款总笔数
    ,withdraw_amount  -- 取款总金额
    ,clear_id  -- 
    ,cashutil_amount  -- 
    ,cashby_handcount  -- 
    ,add_id  -- 
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.dev_no,chr(13),''),chr(10),'')  -- 设备号
    ,replace(replace(t1.addcash_id,chr(13),''),chr(10),'')  -- 加钞标识（当前日期+编号，编号为两位，从00~99）
    ,replace(replace(t1.addcash_datetime,chr(13),''),chr(10),'')  -- 加钞日期
    ,t1.addcash_amount  -- 加钞金额
    ,replace(replace(t1.addcash_type,chr(13),''),chr(10),'')  -- 加钞面值集合 如50,100多种面值以逗号分割
    ,replace(replace(t1.addcash_count,chr(13),''),chr(10),'')  -- 加钞张数 如 1000,2000 多种面值与AddCashType的面值对应，同样以逗号分割
    ,replace(replace(t1.clear_datetime,chr(13),''),chr(10),'')  -- 清机时间
    ,t1.addcash_left  -- 主机尾箱余额
    ,t1.addcash_lastamount  -- 钞箱剩余金额（不包括回收箱）
    ,t1.addcash_retractcount  -- 回收箱张数
    ,t1.deposit_count  -- 存款总笔数
    ,t1.deposit_amount  -- 存款总金额
    ,t1.withdraw_count  -- 取款总笔数
    ,t1.withdraw_amount  -- 取款总金额
    ,replace(replace(t1.clear_id,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cashutil_amount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cashby_handcount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.add_id,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from ${msl_schema}.msl_edw_atms_dev_cash_clear t1    --设备清加钞信息表
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_atms_dev_cash_clear',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);