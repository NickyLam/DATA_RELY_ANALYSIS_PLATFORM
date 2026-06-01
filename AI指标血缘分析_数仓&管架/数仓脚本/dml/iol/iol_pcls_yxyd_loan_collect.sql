/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pcls_yxyd_loan_collect
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pcls_yxyd_loan_collect_ex purge;
alter table ${iol_schema}.pcls_yxyd_loan_collect add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.pcls_yxyd_loan_collect;

-- 2.3 insert data to ex table
create table ${iol_schema}.pcls_yxyd_loan_collect_ex nologging
compress
as
select * from ${iol_schema}.pcls_yxyd_loan_collect where 0=1;

insert /*+ append */ into ${iol_schema}.pcls_yxyd_loan_collect_ex(
    month_due -- 统计月
    ,prin_amt -- 应还金额
    ,prin_cnt -- 应还人数
    ,dpd1_amt -- DPD1金额
    ,dpd4_amt -- DPD4金额
    ,dpd8_amt -- DPD8金额
    ,dpd1_cnt -- DPD1客户数
    ,dpd4_cnt -- DPD4客户数
    ,dpd8_cnt -- dpd8客户数
    ,delinquency_rate -- 入催率
    ,delinquency_3_rate -- 逾期3天转移率
    ,delinquency_7_rate -- 逾期7天转移率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    month_due -- 统计月
    ,prin_amt -- 应还金额
    ,prin_cnt -- 应还人数
    ,dpd1_amt -- DPD1金额
    ,dpd4_amt -- DPD4金额
    ,dpd8_amt -- DPD8金额
    ,dpd1_cnt -- DPD1客户数
    ,dpd4_cnt -- DPD4客户数
    ,dpd8_cnt -- dpd8客户数
    ,delinquency_rate -- 入催率
    ,delinquency_3_rate -- 逾期3天转移率
    ,delinquency_7_rate -- 逾期7天转移率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pcls_yxyd_loan_collect
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pcls_yxyd_loan_collect exchange partition p_${batch_date} with table ${iol_schema}.pcls_yxyd_loan_collect_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pcls_yxyd_loan_collect to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pcls_yxyd_loan_collect_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pcls_yxyd_loan_collect',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);