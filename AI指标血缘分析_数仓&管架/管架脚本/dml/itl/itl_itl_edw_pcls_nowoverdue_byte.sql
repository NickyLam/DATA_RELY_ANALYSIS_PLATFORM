/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pcls_nowoverdue_byte
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_pcls_nowoverdue_byte drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pcls_nowoverdue_byte drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pcls_nowoverdue_byte add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pcls_nowoverdue_byte partition for (to_date('${batch_date}','yyyymmdd')) (
    datecreated -- 日期
    ,loan_bal -- 余额
    ,loan_cnt -- 在贷客户数
    ,dpd3plus_cnt -- dpd3+逾期客户数
    ,dpd3plus_amt -- dpd3+逾期金额
    ,dpd3plus_amt_percent -- dpd3+逾期率（金额口径）
    ,dpd7plus_cnt -- dpd7+逾期客户数
    ,dpd7plus_amt -- dpd7+逾期金额
    ,dpd7plus_amt_percent -- dpd7+逾期率（金额口径）
    ,dpd30plus_cnt -- dpd30+逾期客户数
    ,dpd30plus_amt -- dpd30+逾期金额
    ,dpd30plus_amt_percent -- dpd30+逾期率（金额口径）
    ,dpd90plus_cnt -- dpd90+逾期客户数
    ,dpd90plus_amt -- dpd90+逾期金额
    ,dpd90plus_amt_percent -- dpd90+逾期率（金额口径）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(datecreated), ' ') as datecreated -- 日期
    ,nvl(trim(loan_bal), 0) as loan_bal -- 余额
    ,nvl(trim(loan_cnt), 0) as loan_cnt -- 在贷客户数
    ,nvl(trim(dpd3plus_cnt), 0) as dpd3plus_cnt -- dpd3+逾期客户数
    ,nvl(trim(dpd3plus_amt), 0) as dpd3plus_amt -- dpd3+逾期金额
    ,nvl(trim(dpd3plus_amt_percent), 0) as dpd3plus_amt_percent -- dpd3+逾期率（金额口径）
    ,nvl(trim(dpd7plus_cnt), 0) as dpd7plus_cnt -- dpd7+逾期客户数
    ,nvl(trim(dpd7plus_amt), 0) as dpd7plus_amt -- dpd7+逾期金额
    ,nvl(trim(dpd7plus_amt_percent), 0) as dpd7plus_amt_percent -- dpd7+逾期率（金额口径）
    ,nvl(trim(dpd30plus_cnt), 0) as dpd30plus_cnt -- dpd30+逾期客户数
    ,nvl(trim(dpd30plus_amt), 0) as dpd30plus_amt -- dpd30+逾期金额
    ,nvl(trim(dpd30plus_amt_percent), 0) as dpd30plus_amt_percent -- dpd30+逾期率（金额口径）
    ,nvl(trim(dpd90plus_cnt), 0) as dpd90plus_cnt -- dpd90+逾期客户数
    ,nvl(trim(dpd90plus_amt), 0) as dpd90plus_amt -- dpd90+逾期金额
    ,nvl(trim(dpd90plus_amt_percent), 0) as dpd90plus_amt_percent -- dpd90+逾期率（金额口径）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pcls_nowoverdue_byte
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pcls_nowoverdue_byte to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pcls_nowoverdue_byte',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);