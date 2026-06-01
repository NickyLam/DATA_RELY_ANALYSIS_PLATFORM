/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_orws_yygj
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


-- 2.1 删除当前日期数据，支持重跑
whenever sqlerror continue none;
delete from ${itl_schema}.itl_orws_yygj;
commit;

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_orws_yygj (
    etl_dt,
    ID,
    ORGANNUM,
    RISK_LEVEL,
    NUM,
    TASK_DATE,
    CRAETE_DATE,
    TYPE_NAME,
    PROBLEMER_NO,
    PROBLEMER_NAME,
    etl_timestamp
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt,
    T1.ID as ID,
    T1.ORGANNUM AS ORGANNUM,
    T1.RISK_LEVEL AS RISK_LEVEL,
    T1.NUM AS NUM,
    T1.TASK_DATE AS TASK_DATE,
    T1.CRAETE_DATE AS CRAETE_DATE,
    T1.TYPE_NAME AS TYPE_NAME,
    T1.PROBLEMER_NO AS PROBLEMER_NO,
    T1.PROBLEMER_NAME AS PROBLEMER_NAME,
    to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp
from ${msl_schema}.msl_orws_yygj t1    --营运管架系统数据表
where t1.task_date <= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_orws_yygj',degree => 8, cascade => true);