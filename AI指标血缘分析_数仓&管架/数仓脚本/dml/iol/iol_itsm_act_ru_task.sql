/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_itsm_act_ru_task
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.itsm_act_ru_task_ex purge;
alter table ${iol_schema}.itsm_act_ru_task add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.itsm_act_ru_task;

-- 2.3 insert data to ex table
create table ${iol_schema}.itsm_act_ru_task_ex nologging
compress
as
select * from ${iol_schema}.itsm_act_ru_task where 0=1;

insert /*+ append */ into ${iol_schema}.itsm_act_ru_task_ex(
    id_ -- 任务序号
    ,rev_ -- 类型
    ,execution_id_ -- 执行编号
    ,proc_inst_id_ -- 任务句柄
    ,proc_def_id_ -- 模型编号
    ,scope_id_ -- 
    ,sub_scope_id_ -- 
    ,scope_type_ -- 
    ,scope_definition_id_ -- 
    ,name_ -- 节点名称
    ,parent_task_id_ -- 父节点任务ID
    ,description_ -- 
    ,task_def_key_ -- 节点编号
    ,owner_ -- 原处理人
    ,assignee_ -- 当前处理人
    ,delegation_ -- 说明
    ,priority_ -- 权重
    ,create_time_ -- 任务开始时间
    ,due_date_ -- 
    ,category_ -- 
    ,suspension_state_ -- 悬挂状态
    ,tenant_id_ -- 
    ,form_key_ -- 
    ,claim_time_ -- 告警时间
    ,is_count_enabled_ -- 是否计数
    ,var_count_ -- 计算值
    ,id_link_count_ -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id_ -- 任务序号
    ,rev_ -- 类型
    ,execution_id_ -- 执行编号
    ,proc_inst_id_ -- 任务句柄
    ,proc_def_id_ -- 模型编号
    ,scope_id_ -- 
    ,sub_scope_id_ -- 
    ,scope_type_ -- 
    ,scope_definition_id_ -- 
    ,name_ -- 节点名称
    ,parent_task_id_ -- 父节点任务ID
    ,description_ -- 
    ,task_def_key_ -- 节点编号
    ,owner_ -- 原处理人
    ,assignee_ -- 当前处理人
    ,delegation_ -- 说明
    ,priority_ -- 权重
    ,create_time_ -- 任务开始时间
    ,due_date_ -- 
    ,category_ -- 
    ,suspension_state_ -- 悬挂状态
    ,tenant_id_ -- 
    ,form_key_ -- 
    ,claim_time_ -- 告警时间
    ,is_count_enabled_ -- 是否计数
    ,var_count_ -- 计算值
    ,id_link_count_ -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.itsm_act_ru_task
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.itsm_act_ru_task exchange partition p_${batch_date} with table ${iol_schema}.itsm_act_ru_task_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.itsm_act_ru_task to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.itsm_act_ru_task_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'itsm_act_ru_task',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);