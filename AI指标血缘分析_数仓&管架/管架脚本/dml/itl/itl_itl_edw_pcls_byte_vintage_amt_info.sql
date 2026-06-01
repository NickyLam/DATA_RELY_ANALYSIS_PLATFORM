/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pcls_byte_vintage_amt_info
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
--alter table ${itl_schema}.itl_edw_pcls_byte_vintage_amt_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pcls_byte_vintage_amt_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pcls_byte_vintage_amt_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pcls_byte_vintage_amt_info partition for (to_date('${batch_date}','yyyymmdd')) (
    monthcreated2 -- 统计月
    ,vintage3plus_mob1_amt -- Mob1_vintage3+逾期金额
    ,vintage3plus_mob2_amt -- Mob2_vintage3+逾期金额
    ,vintage3plus_mob3_amt -- Mob3_vintage3+逾期金额
    ,vintage7plus_mob1_amt -- Mob1_vintage7+逾期金额
    ,vintage7plus_mob2_amt -- Mob2_vintage7+逾期金额
    ,vintage7plus_mob3_amt -- Mob3_vintage7+逾期金额
    ,vintage30plus_mob1_amt -- Mob1_vintage30+逾期金额
    ,vintage30plus_mob2_amt -- Mob2_vintage30+逾期金额
    ,vintage30plus_mob3_amt -- Mob3_vintage30+逾期金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(monthcreated2), ' ') as monthcreated2 -- 统计月
    ,nvl(trim(vintage3plus_mob1_amt), 0) as vintage3plus_mob1_amt -- Mob1_vintage3+逾期金额
    ,nvl(trim(vintage3plus_mob2_amt), 0) as vintage3plus_mob2_amt -- Mob2_vintage3+逾期金额
    ,nvl(trim(vintage3plus_mob3_amt), 0) as vintage3plus_mob3_amt -- Mob3_vintage3+逾期金额
    ,nvl(trim(vintage7plus_mob1_amt), 0) as vintage7plus_mob1_amt -- Mob1_vintage7+逾期金额
    ,nvl(trim(vintage7plus_mob2_amt), 0) as vintage7plus_mob2_amt -- Mob2_vintage7+逾期金额
    ,nvl(trim(vintage7plus_mob3_amt), 0) as vintage7plus_mob3_amt -- Mob3_vintage7+逾期金额
    ,nvl(trim(vintage30plus_mob1_amt), 0) as vintage30plus_mob1_amt -- Mob1_vintage30+逾期金额
    ,nvl(trim(vintage30plus_mob2_amt), 0) as vintage30plus_mob2_amt -- Mob2_vintage30+逾期金额
    ,nvl(trim(vintage30plus_mob3_amt), 0) as vintage30plus_mob3_amt -- Mob3_vintage30+逾期金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pcls_byte_vintage_amt_info
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pcls_byte_vintage_amt_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pcls_byte_vintage_amt_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);