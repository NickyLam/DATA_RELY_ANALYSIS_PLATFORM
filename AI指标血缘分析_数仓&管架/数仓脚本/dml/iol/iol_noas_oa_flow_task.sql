/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_noas_oa_flow_task
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
create table ${iol_schema}.noas_oa_flow_task_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.noas_oa_flow_task
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_flow_task_op purge;
drop table ${iol_schema}.noas_oa_flow_task_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_flow_task_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_flow_task where 0=1;

create table ${iol_schema}.noas_oa_flow_task_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_flow_task where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_flow_task_cl(
            oa_flow_task_id -- 
            ,task_name -- 
            ,flow_type_id -- 
            ,assignee -- 
            ,assignee_organ_code -- 
            ,assign_date -- 
            ,completed_date -- 
            ,drafted_party_id -- 
            ,drafted_party_organ_code -- 
            ,drafted_date -- 
            ,urgency -- 
            ,task_status -- 
            ,task_url -- 
            ,process_instance_id -- 
            ,batch_no -- 
            ,act_ru_task_id -- 
            ,oa_node_id -- 
            ,parent_flow_task_id -- 
            ,parent_task_party_id -- 
            ,is_wait -- 
            ,notes -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,current_state -- 
            ,assignee_role_id -- 
            ,drafted_party_organ_code_dummy -- 
            ,assignee_dummy -- 
            ,drafted_party_id_dummy -- 
            ,assignee_organ_code_dummy -- 
            ,complete_channel -- 
            ,data_year -- 
            ,authorizer -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_flow_task_op(
            oa_flow_task_id -- 
            ,task_name -- 
            ,flow_type_id -- 
            ,assignee -- 
            ,assignee_organ_code -- 
            ,assign_date -- 
            ,completed_date -- 
            ,drafted_party_id -- 
            ,drafted_party_organ_code -- 
            ,drafted_date -- 
            ,urgency -- 
            ,task_status -- 
            ,task_url -- 
            ,process_instance_id -- 
            ,batch_no -- 
            ,act_ru_task_id -- 
            ,oa_node_id -- 
            ,parent_flow_task_id -- 
            ,parent_task_party_id -- 
            ,is_wait -- 
            ,notes -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,current_state -- 
            ,assignee_role_id -- 
            ,drafted_party_organ_code_dummy -- 
            ,assignee_dummy -- 
            ,drafted_party_id_dummy -- 
            ,assignee_organ_code_dummy -- 
            ,complete_channel -- 
            ,data_year -- 
            ,authorizer -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.oa_flow_task_id, o.oa_flow_task_id) as oa_flow_task_id -- 
    ,nvl(n.task_name, o.task_name) as task_name -- 
    ,nvl(n.flow_type_id, o.flow_type_id) as flow_type_id -- 
    ,nvl(n.assignee, o.assignee) as assignee -- 
    ,nvl(n.assignee_organ_code, o.assignee_organ_code) as assignee_organ_code -- 
    ,nvl(n.assign_date, o.assign_date) as assign_date -- 
    ,nvl(n.completed_date, o.completed_date) as completed_date -- 
    ,nvl(n.drafted_party_id, o.drafted_party_id) as drafted_party_id -- 
    ,nvl(n.drafted_party_organ_code, o.drafted_party_organ_code) as drafted_party_organ_code -- 
    ,nvl(n.drafted_date, o.drafted_date) as drafted_date -- 
    ,nvl(n.urgency, o.urgency) as urgency -- 
    ,nvl(n.task_status, o.task_status) as task_status -- 
    ,nvl(n.task_url, o.task_url) as task_url -- 
    ,nvl(n.process_instance_id, o.process_instance_id) as process_instance_id -- 
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 
    ,nvl(n.act_ru_task_id, o.act_ru_task_id) as act_ru_task_id -- 
    ,nvl(n.oa_node_id, o.oa_node_id) as oa_node_id -- 
    ,nvl(n.parent_flow_task_id, o.parent_flow_task_id) as parent_flow_task_id -- 
    ,nvl(n.parent_task_party_id, o.parent_task_party_id) as parent_task_party_id -- 
    ,nvl(n.is_wait, o.is_wait) as is_wait -- 
    ,nvl(n.notes, o.notes) as notes -- 
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 
    ,nvl(n.current_state, o.current_state) as current_state -- 
    ,nvl(n.assignee_role_id, o.assignee_role_id) as assignee_role_id -- 
    ,nvl(n.drafted_party_organ_code_dummy, o.drafted_party_organ_code_dummy) as drafted_party_organ_code_dummy -- 
    ,nvl(n.assignee_dummy, o.assignee_dummy) as assignee_dummy -- 
    ,nvl(n.drafted_party_id_dummy, o.drafted_party_id_dummy) as drafted_party_id_dummy -- 
    ,nvl(n.assignee_organ_code_dummy, o.assignee_organ_code_dummy) as assignee_organ_code_dummy -- 
    ,nvl(n.complete_channel, o.complete_channel) as complete_channel -- 
    ,nvl(n.data_year, o.data_year) as data_year -- 
    ,nvl(n.authorizer, o.authorizer) as authorizer -- 
    ,case when
            n.oa_flow_task_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.oa_flow_task_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.oa_flow_task_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.noas_oa_flow_task_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.noas_oa_flow_task where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.oa_flow_task_id = n.oa_flow_task_id
where (
        o.oa_flow_task_id is null
    )
    or (
        n.oa_flow_task_id is null
    )
    or (
        o.task_name <> n.task_name
        or o.flow_type_id <> n.flow_type_id
        or o.assignee <> n.assignee
        or o.assignee_organ_code <> n.assignee_organ_code
        or o.assign_date <> n.assign_date
        or o.completed_date <> n.completed_date
        or o.drafted_party_id <> n.drafted_party_id
        or o.drafted_party_organ_code <> n.drafted_party_organ_code
        or o.drafted_date <> n.drafted_date
        or o.urgency <> n.urgency
        or o.task_status <> n.task_status
        or o.task_url <> n.task_url
        or o.process_instance_id <> n.process_instance_id
        or o.batch_no <> n.batch_no
        or o.act_ru_task_id <> n.act_ru_task_id
        or o.oa_node_id <> n.oa_node_id
        or o.parent_flow_task_id <> n.parent_flow_task_id
        or o.parent_task_party_id <> n.parent_task_party_id
        or o.is_wait <> n.is_wait
        or o.notes <> n.notes
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.current_state <> n.current_state
        or o.assignee_role_id <> n.assignee_role_id
        or o.drafted_party_organ_code_dummy <> n.drafted_party_organ_code_dummy
        or o.assignee_dummy <> n.assignee_dummy
        or o.drafted_party_id_dummy <> n.drafted_party_id_dummy
        or o.assignee_organ_code_dummy <> n.assignee_organ_code_dummy
        or o.complete_channel <> n.complete_channel
        or o.data_year <> n.data_year
        or o.authorizer <> n.authorizer
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_flow_task_cl(
            oa_flow_task_id -- 
            ,task_name -- 
            ,flow_type_id -- 
            ,assignee -- 
            ,assignee_organ_code -- 
            ,assign_date -- 
            ,completed_date -- 
            ,drafted_party_id -- 
            ,drafted_party_organ_code -- 
            ,drafted_date -- 
            ,urgency -- 
            ,task_status -- 
            ,task_url -- 
            ,process_instance_id -- 
            ,batch_no -- 
            ,act_ru_task_id -- 
            ,oa_node_id -- 
            ,parent_flow_task_id -- 
            ,parent_task_party_id -- 
            ,is_wait -- 
            ,notes -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,current_state -- 
            ,assignee_role_id -- 
            ,drafted_party_organ_code_dummy -- 
            ,assignee_dummy -- 
            ,drafted_party_id_dummy -- 
            ,assignee_organ_code_dummy -- 
            ,complete_channel -- 
            ,data_year -- 
            ,authorizer -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_flow_task_op(
            oa_flow_task_id -- 
            ,task_name -- 
            ,flow_type_id -- 
            ,assignee -- 
            ,assignee_organ_code -- 
            ,assign_date -- 
            ,completed_date -- 
            ,drafted_party_id -- 
            ,drafted_party_organ_code -- 
            ,drafted_date -- 
            ,urgency -- 
            ,task_status -- 
            ,task_url -- 
            ,process_instance_id -- 
            ,batch_no -- 
            ,act_ru_task_id -- 
            ,oa_node_id -- 
            ,parent_flow_task_id -- 
            ,parent_task_party_id -- 
            ,is_wait -- 
            ,notes -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,current_state -- 
            ,assignee_role_id -- 
            ,drafted_party_organ_code_dummy -- 
            ,assignee_dummy -- 
            ,drafted_party_id_dummy -- 
            ,assignee_organ_code_dummy -- 
            ,complete_channel -- 
            ,data_year -- 
            ,authorizer -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.oa_flow_task_id -- 
    ,o.task_name -- 
    ,o.flow_type_id -- 
    ,o.assignee -- 
    ,o.assignee_organ_code -- 
    ,o.assign_date -- 
    ,o.completed_date -- 
    ,o.drafted_party_id -- 
    ,o.drafted_party_organ_code -- 
    ,o.drafted_date -- 
    ,o.urgency -- 
    ,o.task_status -- 
    ,o.task_url -- 
    ,o.process_instance_id -- 
    ,o.batch_no -- 
    ,o.act_ru_task_id -- 
    ,o.oa_node_id -- 
    ,o.parent_flow_task_id -- 
    ,o.parent_task_party_id -- 
    ,o.is_wait -- 
    ,o.notes -- 
    ,o.last_updated_stamp -- 
    ,o.last_updated_tx_stamp -- 
    ,o.created_stamp -- 
    ,o.created_tx_stamp -- 
    ,o.current_state -- 
    ,o.assignee_role_id -- 
    ,o.drafted_party_organ_code_dummy -- 
    ,o.assignee_dummy -- 
    ,o.drafted_party_id_dummy -- 
    ,o.assignee_organ_code_dummy -- 
    ,o.complete_channel -- 
    ,o.data_year -- 
    ,o.authorizer -- 
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
from ${iol_schema}.noas_oa_flow_task_bk o
    left join ${iol_schema}.noas_oa_flow_task_op n
        on
            o.oa_flow_task_id = n.oa_flow_task_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.noas_oa_flow_task_cl d
        on
            o.oa_flow_task_id = d.oa_flow_task_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.noas_oa_flow_task;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('noas_oa_flow_task') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.noas_oa_flow_task drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.noas_oa_flow_task add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.noas_oa_flow_task exchange partition p_${batch_date} with table ${iol_schema}.noas_oa_flow_task_cl;
alter table ${iol_schema}.noas_oa_flow_task exchange partition p_20991231 with table ${iol_schema}.noas_oa_flow_task_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.noas_oa_flow_task to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_flow_task_op purge;
drop table ${iol_schema}.noas_oa_flow_task_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.noas_oa_flow_task_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'noas_oa_flow_task',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
