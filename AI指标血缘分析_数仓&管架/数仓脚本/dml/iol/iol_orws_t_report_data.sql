/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orws_t_report_data
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.orws_t_report_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orws_t_report_data
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_t_report_data_op purge;
drop table ${iol_schema}.orws_t_report_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_report_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_t_report_data where 0=1;

create table ${iol_schema}.orws_t_report_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_t_report_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_t_report_data_cl(
            id -- 主键
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_t_report_data_op(
            id -- 主键
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.bmc_id, o.bmc_id) as bmc_id -- 业务监测内容
    ,nvl(n.yesterday_condition, o.yesterday_condition) as yesterday_condition -- 当天情况
    ,nvl(n.sb_confirmation_feedback, o.sb_confirmation_feedback) as sb_confirmation_feedback -- 详情确认反馈支行上报
    ,nvl(n.bb_confirmation_feedback, o.bb_confirmation_feedback) as bb_confirmation_feedback -- 详情确认反馈分行上报
    ,nvl(n.hb_confirmation_feedback, o.hb_confirmation_feedback) as hb_confirmation_feedback -- 详情确认反馈总行上报
    ,nvl(n.is_count, o.is_count) as is_count -- 是否汇总
    ,nvl(n.mmd_id, o.mmd_id) as mmd_id -- 模型监控数据编号
    ,nvl(n.executive_organ_id, o.executive_organ_id) as executive_organ_id -- 任务执行机构
    ,nvl(n.rdata_level, o.rdata_level) as rdata_level -- 数据级别
    ,nvl(n.task_id, o.task_id) as task_id -- 任务id
    ,nvl(n.rdata_status, o.rdata_status) as rdata_status -- 数据状态
    ,nvl(n.problem_id, o.problem_id) as problem_id -- 问题流程编号
    ,nvl(n.flow_up_status, o.flow_up_status) as flow_up_status -- 是否后续跟踪
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 风险等级
    ,nvl(n.approve_status, o.approve_status) as approve_status -- 审批状态
    ,nvl(n.reportto_node_id, o.reportto_node_id) as reportto_node_id -- 上报节点
    ,nvl(n.business_date, o.business_date) as business_date -- 业务日期
    ,nvl(n.templatetype_id, o.templatetype_id) as templatetype_id -- 模板id
    ,nvl(n.sb_status_feedback, o.sb_status_feedback) as sb_status_feedback -- 是否正常支行上报
    ,nvl(n.bb_status_feedback, o.bb_status_feedback) as bb_status_feedback -- 是否正常分行上报
    ,nvl(n.hb_status_feedback, o.hb_status_feedback) as hb_status_feedback -- 是否正常总行上报
    ,nvl(n.is_overdue, o.is_overdue) as is_overdue -- 是否超期处理
    ,nvl(n.upgrade_date, o.upgrade_date) as upgrade_date -- 风险升级日期
    ,nvl(n.approve_days, o.approve_days) as approve_days -- 处理天数
    ,nvl(n.flow_up_id, o.flow_up_id) as flow_up_id -- 跟进数据id
    ,nvl(n.approve_date, o.approve_date) as approve_date -- 数据处理日期
    ,nvl(n.is_manualup, o.is_manualup) as is_manualup -- 是否手动升级
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.orws_t_report_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orws_t_report_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.bmc_id <> n.bmc_id
        or o.yesterday_condition <> n.yesterday_condition
        or o.sb_confirmation_feedback <> n.sb_confirmation_feedback
        or o.bb_confirmation_feedback <> n.bb_confirmation_feedback
        or o.hb_confirmation_feedback <> n.hb_confirmation_feedback
        or o.is_count <> n.is_count
        or o.mmd_id <> n.mmd_id
        or o.executive_organ_id <> n.executive_organ_id
        or o.rdata_level <> n.rdata_level
        or o.task_id <> n.task_id
        or o.rdata_status <> n.rdata_status
        or o.problem_id <> n.problem_id
        or o.flow_up_status <> n.flow_up_status
        or o.risk_level <> n.risk_level
        or o.approve_status <> n.approve_status
        or o.reportto_node_id <> n.reportto_node_id
        or o.business_date <> n.business_date
        or o.templatetype_id <> n.templatetype_id
        or o.sb_status_feedback <> n.sb_status_feedback
        or o.bb_status_feedback <> n.bb_status_feedback
        or o.hb_status_feedback <> n.hb_status_feedback
        or o.is_overdue <> n.is_overdue
        or o.upgrade_date <> n.upgrade_date
        or o.approve_days <> n.approve_days
        or o.flow_up_id <> n.flow_up_id
        or o.approve_date <> n.approve_date
        or o.is_manualup <> n.is_manualup
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_t_report_data_cl(
            id -- 主键
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_t_report_data_op(
            id -- 主键
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.bmc_id -- 业务监测内容
    ,o.yesterday_condition -- 当天情况
    ,o.sb_confirmation_feedback -- 详情确认反馈支行上报
    ,o.bb_confirmation_feedback -- 详情确认反馈分行上报
    ,o.hb_confirmation_feedback -- 详情确认反馈总行上报
    ,o.is_count -- 是否汇总
    ,o.mmd_id -- 模型监控数据编号
    ,o.executive_organ_id -- 任务执行机构
    ,o.rdata_level -- 数据级别
    ,o.task_id -- 任务id
    ,o.rdata_status -- 数据状态
    ,o.problem_id -- 问题流程编号
    ,o.flow_up_status -- 是否后续跟踪
    ,o.risk_level -- 风险等级
    ,o.approve_status -- 审批状态
    ,o.reportto_node_id -- 上报节点
    ,o.business_date -- 业务日期
    ,o.templatetype_id -- 模板id
    ,o.sb_status_feedback -- 是否正常支行上报
    ,o.bb_status_feedback -- 是否正常分行上报
    ,o.hb_status_feedback -- 是否正常总行上报
    ,o.is_overdue -- 是否超期处理
    ,o.upgrade_date -- 风险升级日期
    ,o.approve_days -- 处理天数
    ,o.flow_up_id -- 跟进数据id
    ,o.approve_date -- 数据处理日期
    ,o.is_manualup -- 是否手动升级
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.orws_t_report_data_bk o
    left join ${iol_schema}.orws_t_report_data_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orws_t_report_data_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.orws_t_report_data;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('orws_t_report_data') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.orws_t_report_data drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.orws_t_report_data add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.orws_t_report_data exchange partition p_${batch_date} with table ${iol_schema}.orws_t_report_data_cl;
alter table ${iol_schema}.orws_t_report_data exchange partition p_20991231 with table ${iol_schema}.orws_t_report_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orws_t_report_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_t_report_data_op purge;
drop table ${iol_schema}.orws_t_report_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orws_t_report_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orws_t_report_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
