/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pcls_yxyd_loan_collect
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
--alter table ${itl_schema}.itl_edw_pcls_yxyd_loan_collect drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pcls_yxyd_loan_collect drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pcls_yxyd_loan_collect add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pcls_yxyd_loan_collect partition for (to_date('${batch_date}','yyyymmdd')) (
    month_due -- 统计月
    ,prin_amt -- 应还金额
    ,prin_cnt -- 应还人数
    ,dpd1_amt -- dpd1金额
    ,dpd4_amt -- dpd4金额
    ,dpd8_amt -- dpd8金额
    ,dpd1_cnt -- dpd1客户数
    ,dpd4_cnt -- dpd4客户数
    ,dpd8_cnt -- dpd8客户数
    ,delinquency_rate -- 入催率
    ,delinquency_3_rate -- 逾期3天转移率
    ,delinquency_7_rate -- 逾期7天转移率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(month_due), ' ') as month_due -- 统计月
    ,nvl(trim(prin_amt), 0) as prin_amt -- 应还金额
    ,nvl(trim(prin_cnt), 0) as prin_cnt -- 应还人数
    ,nvl(trim(dpd1_amt), 0) as dpd1_amt -- dpd1金额
    ,nvl(trim(dpd4_amt), 0) as dpd4_amt -- dpd4金额
    ,nvl(trim(dpd8_amt), 0) as dpd8_amt -- dpd8金额
    ,nvl(trim(dpd1_cnt), 0) as dpd1_cnt -- dpd1客户数
    ,nvl(trim(dpd4_cnt), 0) as dpd4_cnt -- dpd4客户数
    ,nvl(trim(dpd8_cnt), 0) as dpd8_cnt -- dpd8客户数
    ,nvl(trim(delinquency_rate), 0) as delinquency_rate -- 入催率
    ,nvl(trim(delinquency_3_rate), 0) as delinquency_3_rate -- 逾期3天转移率
    ,nvl(trim(delinquency_7_rate), 0) as delinquency_7_rate -- 逾期7天转移率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pcls_yxyd_loan_collect
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pcls_yxyd_loan_collect to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pcls_yxyd_loan_collect',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);