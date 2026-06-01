/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_orws_t_report_task
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
alter table ${itl_schema}.itl_edw_orws_t_report_task drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_orws_t_report_task drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_orws_t_report_task add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_orws_t_report_task partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt -- 数据日期
    ,id -- 主键
    ,task_title -- 任务标题
    ,task_status -- 当前节点
    ,explain_advise -- 说明建议
    ,verification_opinion -- 核实意见
    ,executive_organ_id -- 任务执行机构
    ,task_level -- 任务级别
    ,parent_organ_id -- 上级机构
    ,parent_task_id -- 上级任务
    ,task_create_date -- 创建时间
    ,task_report_date -- 上报时间
    ,task_update_date -- 修改时间
    ,is_delete -- 是否删除
    ,curr_operator_id -- 当前操作人
    ,operator_entry_time -- 操作人进入时间
    ,business_date -- 业务日期
    ,curr_node_id -- 当前节点
    ,temp_verification_opinion -- 临时核实意见
    ,is_selected -- 是否选中
    ,start_dt -- 开始日期
    ,end_dt -- 结束日期
    ,id_mark -- 删除标识
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(etl_dt, to_date('00010101', 'yyyymmdd')) as etl_dt -- 数据日期
    ,nvl(trim(id), 0) as id -- 主键
    ,nvl(trim(task_title), ' ') as task_title -- 任务标题
    ,nvl(trim(task_status), ' ') as task_status -- 当前节点
    ,nvl(trim(explain_advise), ' ') as explain_advise -- 说明建议
    ,nvl(trim(verification_opinion), ' ') as verification_opinion -- 核实意见
    ,nvl(trim(executive_organ_id), 0) as executive_organ_id -- 任务执行机构
    ,nvl(trim(task_level), ' ') as task_level -- 任务级别
    ,nvl(trim(parent_organ_id), 0) as parent_organ_id -- 上级机构
    ,nvl(trim(parent_task_id), 0) as parent_task_id -- 上级任务
    ,nvl(task_create_date, to_timestamp('00010101', 'yyyymmdd')) as task_create_date -- 创建时间
    ,nvl(task_report_date, to_timestamp('00010101', 'yyyymmdd')) as task_report_date -- 上报时间
    ,nvl(task_update_date, to_timestamp('00010101', 'yyyymmdd')) as task_update_date -- 修改时间
    ,nvl(trim(is_delete), ' ') as is_delete -- 是否删除
    ,nvl(trim(curr_operator_id), 0) as curr_operator_id -- 当前操作人
    ,nvl(operator_entry_time, to_timestamp('00010101', 'yyyymmdd')) as operator_entry_time -- 操作人进入时间
    ,nvl(business_date, to_timestamp('00010101', 'yyyymmdd')) as business_date -- 业务日期
    ,nvl(trim(curr_node_id), 0) as curr_node_id -- 当前节点
    ,nvl(trim(temp_verification_opinion), ' ') as temp_verification_opinion -- 临时核实意见
    ,nvl(trim(is_selected), ' ') as is_selected -- 是否选中
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始日期
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束日期
    ,nvl(trim(id_mark), ' ') as id_mark -- 删除标识
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_orws_t_report_task
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_orws_t_report_task to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_orws_t_report_task',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);