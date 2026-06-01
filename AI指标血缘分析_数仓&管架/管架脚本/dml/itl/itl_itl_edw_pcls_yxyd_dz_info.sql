/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pcls_yxyd_dz_info
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
--alter table ${itl_schema}.itl_edw_pcls_yxyd_dz_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pcls_yxyd_dz_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pcls_yxyd_dz_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pcls_yxyd_dz_info partition for (to_date('${batch_date}','yyyymmdd')) (
    draw_dt -- 动支日期
    ,draw_cnt -- 动支笔数
    ,draw_pass_cnt -- 动支成功笔数
    ,draw_pass_percent -- 动支成功率
    ,draw_amt -- 放款金额
    ,draw_amt_avg -- 笔均放款金额
    ,bal -- 贷款余额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(draw_dt), 0) as draw_dt -- 动支日期
    ,nvl(trim(draw_cnt), 0) as draw_cnt -- 动支笔数
    ,nvl(trim(draw_pass_cnt), 0) as draw_pass_cnt -- 动支成功笔数
    ,nvl(trim(draw_pass_percent), 0) as draw_pass_percent -- 动支成功率
    ,nvl(trim(draw_amt), 0) as draw_amt -- 放款金额
    ,nvl(trim(draw_amt_avg), 0) as draw_amt_avg -- 笔均放款金额
    ,nvl(trim(bal), 0) as bal -- 贷款余额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pcls_yxyd_dz_info
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pcls_yxyd_dz_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pcls_yxyd_dz_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);