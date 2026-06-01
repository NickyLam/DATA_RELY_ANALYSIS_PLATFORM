/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orws_t_report_task
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
create table ${iol_schema}.orws_t_report_task_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orws_t_report_task
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_t_report_task_op purge;
drop table ${iol_schema}.orws_t_report_task_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_report_task_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_t_report_task where 0=1;

create table ${iol_schema}.orws_t_report_task_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_t_report_task where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_t_report_task_cl(
            id -- 主键
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_t_report_task_op(
            id -- 主键
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.task_title, o.task_title) as task_title -- 任务标题
    ,nvl(n.task_status, o.task_status) as task_status -- 当前节点
    ,nvl(n.explain_advise, o.explain_advise) as explain_advise -- 说明建议
    ,nvl(n.verification_opinion, o.verification_opinion) as verification_opinion -- 核实意见
    ,nvl(n.executive_organ_id, o.executive_organ_id) as executive_organ_id -- 任务执行机构
    ,nvl(n.task_level, o.task_level) as task_level -- 任务级别
    ,nvl(n.parent_organ_id, o.parent_organ_id) as parent_organ_id -- 上级机构
    ,nvl(n.parent_task_id, o.parent_task_id) as parent_task_id -- 上级任务
    ,nvl(n.task_create_date, o.task_create_date) as task_create_date -- 创建时间
    ,nvl(n.task_report_date, o.task_report_date) as task_report_date -- 上报时间
    ,nvl(n.task_update_date, o.task_update_date) as task_update_date -- 修改时间
    ,nvl(n.is_delete, o.is_delete) as is_delete -- 是否删除
    ,nvl(n.curr_operator_id, o.curr_operator_id) as curr_operator_id -- 当前操作人
    ,nvl(n.operator_entry_time, o.operator_entry_time) as operator_entry_time -- 操作人进入时间
    ,nvl(n.business_date, o.business_date) as business_date -- 业务日期
    ,nvl(n.curr_node_id, o.curr_node_id) as curr_node_id -- 当前节点
    ,nvl(n.temp_verification_opinion, o.temp_verification_opinion) as temp_verification_opinion -- 临时核实意见
    ,nvl(n.is_selected, o.is_selected) as is_selected -- 是否选中
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
from (select * from ${iol_schema}.orws_t_report_task_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orws_t_report_task where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.task_title <> n.task_title
        or o.task_status <> n.task_status
        or o.explain_advise <> n.explain_advise
        or o.verification_opinion <> n.verification_opinion
        or o.executive_organ_id <> n.executive_organ_id
        or o.task_level <> n.task_level
        or o.parent_organ_id <> n.parent_organ_id
        or o.parent_task_id <> n.parent_task_id
        or o.task_create_date <> n.task_create_date
        or o.task_report_date <> n.task_report_date
        or o.task_update_date <> n.task_update_date
        or o.is_delete <> n.is_delete
        or o.curr_operator_id <> n.curr_operator_id
        or o.operator_entry_time <> n.operator_entry_time
        or o.business_date <> n.business_date
        or o.curr_node_id <> n.curr_node_id
        or o.temp_verification_opinion <> n.temp_verification_opinion
        or o.is_selected <> n.is_selected
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_t_report_task_cl(
            id -- 主键
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_t_report_task_op(
            id -- 主键
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.task_title -- 任务标题
    ,o.task_status -- 当前节点
    ,o.explain_advise -- 说明建议
    ,o.verification_opinion -- 核实意见
    ,o.executive_organ_id -- 任务执行机构
    ,o.task_level -- 任务级别
    ,o.parent_organ_id -- 上级机构
    ,o.parent_task_id -- 上级任务
    ,o.task_create_date -- 创建时间
    ,o.task_report_date -- 上报时间
    ,o.task_update_date -- 修改时间
    ,o.is_delete -- 是否删除
    ,o.curr_operator_id -- 当前操作人
    ,o.operator_entry_time -- 操作人进入时间
    ,o.business_date -- 业务日期
    ,o.curr_node_id -- 当前节点
    ,o.temp_verification_opinion -- 临时核实意见
    ,o.is_selected -- 是否选中
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
from ${iol_schema}.orws_t_report_task_bk o
    left join ${iol_schema}.orws_t_report_task_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orws_t_report_task_cl d
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
--truncate table ${iol_schema}.orws_t_report_task;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('orws_t_report_task') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.orws_t_report_task drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.orws_t_report_task add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.orws_t_report_task exchange partition p_${batch_date} with table ${iol_schema}.orws_t_report_task_cl;
alter table ${iol_schema}.orws_t_report_task exchange partition p_20991231 with table ${iol_schema}.orws_t_report_task_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orws_t_report_task to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_t_report_task_op purge;
drop table ${iol_schema}.orws_t_report_task_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orws_t_report_task_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orws_t_report_task',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
