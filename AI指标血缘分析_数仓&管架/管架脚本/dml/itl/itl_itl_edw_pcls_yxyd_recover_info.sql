/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pcls_yxyd_recover_info
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
--alter table ${itl_schema}.itl_edw_pcls_yxyd_recover_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pcls_yxyd_recover_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pcls_yxyd_recover_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pcls_yxyd_recover_info partition for (to_date('${batch_date}','yyyymmdd')) (
    month_loan -- 放款月份
    ,loan_amt -- 放款金额
    ,m1_amt -- m1金额
    ,m2_amt -- m2金额
    ,m3_amt -- m3金额
    ,m3plus_amt -- m3+金额
    ,m1_recover_amt -- m1催回金额
    ,m2_recover_amt -- m2催回金额
    ,m3_recover_amt -- m3催回金额
    ,m3plus_recover_amt -- m3+催回金额
    ,m1_recover_percent -- m1催回率
    ,m2_recover_percent -- m2催回率
    ,m3_recover_percent -- m3催回率
    ,m3plus_recover_percent -- m3+催回率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(month_loan), ' ') as month_loan -- 放款月份
    ,nvl(trim(loan_amt), 0) as loan_amt -- 放款金额
    ,nvl(trim(m1_amt), 0) as m1_amt -- m1金额
    ,nvl(trim(m2_amt), 0) as m2_amt -- m2金额
    ,nvl(trim(m3_amt), 0) as m3_amt -- m3金额
    ,nvl(trim(m3plus_amt), 0) as m3plus_amt -- m3+金额
    ,nvl(trim(m1_recover_amt), 0) as m1_recover_amt -- m1催回金额
    ,nvl(trim(m2_recover_amt), 0) as m2_recover_amt -- m2催回金额
    ,nvl(trim(m3_recover_amt), 0) as m3_recover_amt -- m3催回金额
    ,nvl(trim(m3plus_recover_amt), 0) as m3plus_recover_amt -- m3+催回金额
    ,nvl(trim(m1_recover_percent), 0) as m1_recover_percent -- m1催回率
    ,nvl(trim(m2_recover_percent), 0) as m2_recover_percent -- m2催回率
    ,nvl(trim(m3_recover_percent), 0) as m3_recover_percent -- m3催回率
    ,nvl(trim(m3plus_recover_percent), 0) as m3plus_recover_percent -- m3+催回率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pcls_yxyd_recover_info
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pcls_yxyd_recover_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pcls_yxyd_recover_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);