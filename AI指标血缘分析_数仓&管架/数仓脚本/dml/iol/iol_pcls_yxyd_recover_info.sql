/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pcls_yxyd_recover_info
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
drop table ${iol_schema}.pcls_yxyd_recover_info_ex purge;
alter table ${iol_schema}.pcls_yxyd_recover_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.pcls_yxyd_recover_info;

-- 2.3 insert data to ex table
create table ${iol_schema}.pcls_yxyd_recover_info_ex nologging
compress
as
select * from ${iol_schema}.pcls_yxyd_recover_info where 0=1;

insert /*+ append */ into ${iol_schema}.pcls_yxyd_recover_info_ex(
    month_loan -- 放款月份
    ,loan_amt -- 放款金额
    ,m1_amt -- M1金额
    ,m2_amt -- M2金额
    ,m3_amt -- M3金额
    ,m3plus_amt -- M3+金额
    ,m1_recover_amt -- M1催回金额
    ,m2_recover_amt -- M2催回金额
    ,m3_recover_amt -- M3催回金额
    ,m3plus_recover_amt -- M3+催回金额
    ,m1_recover_percent -- M1催回率
    ,m2_recover_percent -- M2催回率
    ,m3_recover_percent -- M3催回率
    ,m3plus_recover_percent -- M3+催回率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    month_loan -- 放款月份
    ,loan_amt -- 放款金额
    ,m1_amt -- M1金额
    ,m2_amt -- M2金额
    ,m3_amt -- M3金额
    ,m3plus_amt -- M3+金额
    ,m1_recover_amt -- M1催回金额
    ,m2_recover_amt -- M2催回金额
    ,m3_recover_amt -- M3催回金额
    ,m3plus_recover_amt -- M3+催回金额
    ,m1_recover_percent -- M1催回率
    ,m2_recover_percent -- M2催回率
    ,m3_recover_percent -- M3催回率
    ,m3plus_recover_percent -- M3+催回率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pcls_yxyd_recover_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pcls_yxyd_recover_info exchange partition p_${batch_date} with table ${iol_schema}.pcls_yxyd_recover_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pcls_yxyd_recover_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pcls_yxyd_recover_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pcls_yxyd_recover_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);