/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pcls_yxyd_sj_info
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
--alter table ${itl_schema}.itl_edw_pcls_yxyd_sj_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pcls_yxyd_sj_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pcls_yxyd_sj_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pcls_yxyd_sj_info partition for (to_date('${batch_date}','yyyymmdd')) (
    rj_rule_big -- 首拒原因（大类）
    ,rj_rule -- 首拒原因
    ,t_1_cnt -- T-1申请笔数
    ,t_2_cnt -- T-2申请笔数
    ,t_3_cnt -- T-3申请笔数
    ,t_4_cnt -- T-4申请笔数
    ,t_5_cnt -- T-5申请笔数
    ,t_6_cnt -- T-6申请笔数
    ,t_7_cnt -- T-7申请笔数
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(rj_rule_big), ' ') as rj_rule_big -- 首拒原因（大类）
    ,nvl(trim(rj_rule), ' ') as rj_rule -- 首拒原因
    ,nvl(trim(t_1_cnt), 0) as t_1_cnt -- T-1申请笔数
    ,nvl(trim(t_2_cnt), 0) as t_2_cnt -- T-2申请笔数
    ,nvl(trim(t_3_cnt), 0) as t_3_cnt -- T-3申请笔数
    ,nvl(trim(t_4_cnt), 0) as t_4_cnt -- T-4申请笔数
    ,nvl(trim(t_5_cnt), 0) as t_5_cnt -- T-5申请笔数
    ,nvl(trim(t_6_cnt), 0) as t_6_cnt -- T-6申请笔数
    ,nvl(trim(t_7_cnt), 0) as t_7_cnt -- T-7申请笔数
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pcls_yxyd_sj_info
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pcls_yxyd_sj_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pcls_yxyd_sj_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);