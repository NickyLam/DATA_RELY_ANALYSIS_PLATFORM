/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_orws_t_report_data
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
alter table ${itl_schema}.itl_edw_orws_t_report_data drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_orws_t_report_data drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_orws_t_report_data add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_orws_t_report_data partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt -- 数据日期
    ,id -- 主键
    ,bmc_id -- 业务监测内容
    ,yesterday_condition -- 当天情况
    ,sb_confirmation_feedback -- 详情确认反馈支行上报
    ,bb_confirmation_feedback -- 详情确认反馈分行上报
    ,hb_confirmation_feedback -- 详情确认反馈总行上报
    ,is_count -- 是否汇总
    ,mmd_id -- 模型监控数据编号
    ,executive_organ_id -- 任务执行机构
    ,rdata_level -- 数据级别
    ,task_id -- 任务id
    ,rdata_status -- 数据状态
    ,problem_id -- 问题流程编号
    ,flow_up_status -- 是否后续跟踪
    ,risk_level -- 风险等级
    ,approve_status -- 审批状态
    ,reportto_node_id -- 上报节点
    ,business_date -- 业务日期
    ,templatetype_id -- 模板id
    ,sb_status_feedback -- 是否正常支行上报
    ,bb_status_feedback -- 是否正常分行上报
    ,hb_status_feedback -- 是否正常总行上报
    ,is_overdue -- 是否超期处理
    ,upgrade_date -- 风险升级日期
    ,approve_days -- 处理天数
    ,flow_up_id -- 跟进数据id
    ,approve_date -- 数据处理日期
    ,is_manualup -- 是否手动升级
    ,start_dt -- 开始日期
    ,end_dt -- 结束日期
    ,id_mark -- 删除标识
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(etl_dt, to_date('00010101', 'yyyymmdd')) as etl_dt -- 数据日期
    ,nvl(trim(id), 0) as id -- 主键
    ,nvl(trim(bmc_id), 0) as bmc_id -- 业务监测内容
    ,nvl(trim(yesterday_condition), ' ') as yesterday_condition -- 当天情况
    ,nvl(trim(sb_confirmation_feedback), ' ') as sb_confirmation_feedback -- 详情确认反馈支行上报
    ,nvl(trim(bb_confirmation_feedback), ' ') as bb_confirmation_feedback -- 详情确认反馈分行上报
    ,nvl(trim(hb_confirmation_feedback), ' ') as hb_confirmation_feedback -- 详情确认反馈总行上报
    ,nvl(trim(is_count), ' ') as is_count -- 是否汇总
    ,nvl(trim(mmd_id), 0) as mmd_id -- 模型监控数据编号
    ,nvl(trim(executive_organ_id), 0) as executive_organ_id -- 任务执行机构
    ,nvl(trim(rdata_level), ' ') as rdata_level -- 数据级别
    ,nvl(trim(task_id), 0) as task_id -- 任务id
    ,nvl(trim(rdata_status), ' ') as rdata_status -- 数据状态
    ,nvl(trim(problem_id), 0) as problem_id -- 问题流程编号
    ,nvl(trim(flow_up_status), 0) as flow_up_status -- 是否后续跟踪
    ,nvl(trim(risk_level), 0) as risk_level -- 风险等级
    ,nvl(trim(approve_status), 0) as approve_status -- 审批状态
    ,nvl(trim(reportto_node_id), 0) as reportto_node_id -- 上报节点
    ,nvl(trim(business_date), ' ') as business_date -- 业务日期
    ,nvl(trim(templatetype_id), ' ') as templatetype_id -- 模板id
    ,nvl(trim(sb_status_feedback), ' ') as sb_status_feedback -- 是否正常支行上报
    ,nvl(trim(bb_status_feedback), ' ') as bb_status_feedback -- 是否正常分行上报
    ,nvl(trim(hb_status_feedback), ' ') as hb_status_feedback -- 是否正常总行上报
    ,nvl(trim(is_overdue), 0) as is_overdue -- 是否超期处理
    ,nvl(upgrade_date, to_timestamp('00010101', 'yyyymmdd')) as upgrade_date -- 风险升级日期
    ,nvl(trim(approve_days), 0) as approve_days -- 处理天数
    ,nvl(trim(flow_up_id), 0) as flow_up_id -- 跟进数据id
    ,nvl(approve_date, to_timestamp('00010101', 'yyyymmdd')) as approve_date -- 数据处理日期
    ,nvl(trim(is_manualup), 0) as is_manualup -- 是否手动升级
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始日期
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束日期
    ,nvl(trim(id_mark), ' ') as id_mark -- 删除标识
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_orws_t_report_data
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_orws_t_report_data to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_orws_t_report_data',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);