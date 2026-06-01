/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_rdw_rdw_nation_risk_lmt_situ
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
--alter table ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ drop partition p_${retain_day};
alter table ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ partition for (to_date('${batch_date}','yyyymmdd')) (
    nation_name -- 国别名称
    ,rating_rest -- 风险评级
    ,lmt_ctrl_target_val -- 限制目标值
    ,currt_bal -- 当前余额
    ,comp_last_year -- 对比上年末
    ,comp_last_qua -- 对比上季末
    ,comp_last_month -- 对比上月末
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(nation_name), ' ') as nation_name -- 国别名称
    ,nvl(trim(rating_rest), ' ') as rating_rest -- 风险评级
    ,nvl(trim(lmt_ctrl_target_val), 0) as lmt_ctrl_target_val -- 限制目标值
    ,nvl(trim(currt_bal), 0) as currt_bal -- 当前余额
    ,nvl(trim(comp_last_year), 0) as comp_last_year -- 对比上年末
    ,nvl(trim(comp_last_qua), 0) as comp_last_qua -- 对比上季末
    ,nvl(trim(comp_last_month), 0) as comp_last_month -- 对比上月末
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_rdw_rdw_nation_risk_lmt_situ',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);