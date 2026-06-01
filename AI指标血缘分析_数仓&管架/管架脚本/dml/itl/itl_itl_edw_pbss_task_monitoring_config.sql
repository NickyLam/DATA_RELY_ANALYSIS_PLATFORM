/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pbss_task_monitoring_config
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
--营运管驾Itl层存放历史数据
alter table ${itl_schema}.itl_edw_pbss_task_monitoring_config drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pbss_task_monitoring_config drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pbss_task_monitoring_config add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pbss_task_monitoring_config partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt -- 数据日期
    ,id -- 主键
    ,task_monitoring_code -- 流程银行任务监控分类code
    ,task_monitoring_name -- 流程银行任务监控分类name
    ,star -- 分类状态[0:未配置,1:已配置]
    ,task_monitoring_type -- 流程银行任务监控分类[1:业务类型大类,2:业务类型明细,3:岗位]
    ,parent_id -- 业务类型明细所属大类ID
    ,ave_mission -- 人均待处理任务数
    ,tache_type -- 环节类型
    ,start_dt -- 开始日期
    ,end_dt -- 结束日期
    ,id_mark -- 删除标识
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(etl_dt, to_date('00010101', 'yyyymmdd')) as etl_dt -- 数据日期
    ,nvl(trim(id), ' ') as id -- 主键
    ,nvl(trim(task_monitoring_code), ' ') as task_monitoring_code -- 流程银行任务监控分类code
    ,nvl(trim(task_monitoring_name), ' ') as task_monitoring_name -- 流程银行任务监控分类name
    ,nvl(trim(star), ' ') as star -- 分类状态[0:未配置,1:已配置]
    ,nvl(trim(task_monitoring_type), ' ') as task_monitoring_type -- 流程银行任务监控分类[1:业务类型大类,2:业务类型明细,3:岗位]
    ,nvl(trim(parent_id), ' ') as parent_id -- 业务类型明细所属大类ID
    ,nvl(trim(ave_mission), ' ') as ave_mission -- 人均待处理任务数
    ,nvl(trim(tache_type), ' ') as tache_type -- 环节类型
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始日期
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束日期
    ,nvl(trim(id_mark), ' ') as id_mark -- 删除标识
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pbss_task_monitoring_config
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pbss_task_monitoring_config to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pbss_task_monitoring_config',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);