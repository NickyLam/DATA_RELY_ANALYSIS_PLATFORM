/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_noas_oa_form_suggestion
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
create table ${iol_schema}.noas_oa_form_suggestion_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.noas_oa_form_suggestion
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_form_suggestion_op purge;
drop table ${iol_schema}.noas_oa_form_suggestion_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_form_suggestion_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_form_suggestion where 0=1;

create table ${iol_schema}.noas_oa_form_suggestion_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_form_suggestion where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_form_suggestion_cl(
            suggestion_id -- 审批意见标识
            ,party_id -- 人员ID
            ,node_id -- 节点ID
            ,organ_code -- 机构
            ,process_ins_id -- 流程实体ID
            ,suggestion_time -- 审批时间
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,party_id_dummy -- 人员-迁移用
            ,organ_code_dummy -- 机构-迁移用
            ,assignee_role_id -- 处理人角色
            ,suggestion -- 审批意见
            ,act_ru_task_id -- 任务ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_form_suggestion_op(
            suggestion_id -- 审批意见标识
            ,party_id -- 人员ID
            ,node_id -- 节点ID
            ,organ_code -- 机构
            ,process_ins_id -- 流程实体ID
            ,suggestion_time -- 审批时间
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,party_id_dummy -- 人员-迁移用
            ,organ_code_dummy -- 机构-迁移用
            ,assignee_role_id -- 处理人角色
            ,suggestion -- 审批意见
            ,act_ru_task_id -- 任务ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.suggestion_id, o.suggestion_id) as suggestion_id -- 审批意见标识
    ,nvl(n.party_id, o.party_id) as party_id -- 人员ID
    ,nvl(n.node_id, o.node_id) as node_id -- 节点ID
    ,nvl(n.organ_code, o.organ_code) as organ_code -- 机构
    ,nvl(n.process_ins_id, o.process_ins_id) as process_ins_id -- 流程实体ID
    ,nvl(n.suggestion_time, o.suggestion_time) as suggestion_time -- 审批时间
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 最后更新时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 最后更新事务时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 创建事务时间
    ,nvl(n.party_id_dummy, o.party_id_dummy) as party_id_dummy -- 人员-迁移用
    ,nvl(n.organ_code_dummy, o.organ_code_dummy) as organ_code_dummy -- 机构-迁移用
    ,nvl(n.assignee_role_id, o.assignee_role_id) as assignee_role_id -- 处理人角色
    ,nvl(n.suggestion, o.suggestion) as suggestion -- 审批意见
    ,nvl(n.act_ru_task_id, o.act_ru_task_id) as act_ru_task_id -- 任务ID
    ,case when
            n.suggestion_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.suggestion_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.suggestion_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.noas_oa_form_suggestion_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.noas_oa_form_suggestion where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.suggestion_id = n.suggestion_id
where (
        o.suggestion_id is null
    )
    or (
        n.suggestion_id is null
    )
    or (
        o.party_id <> n.party_id
        or o.node_id <> n.node_id
        or o.organ_code <> n.organ_code
        or o.process_ins_id <> n.process_ins_id
        or o.suggestion_time <> n.suggestion_time
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.party_id_dummy <> n.party_id_dummy
        or o.organ_code_dummy <> n.organ_code_dummy
        or o.assignee_role_id <> n.assignee_role_id
        or o.suggestion <> n.suggestion
        or o.act_ru_task_id <> n.act_ru_task_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_form_suggestion_cl(
            suggestion_id -- 审批意见标识
            ,party_id -- 人员ID
            ,node_id -- 节点ID
            ,organ_code -- 机构
            ,process_ins_id -- 流程实体ID
            ,suggestion_time -- 审批时间
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,party_id_dummy -- 人员-迁移用
            ,organ_code_dummy -- 机构-迁移用
            ,assignee_role_id -- 处理人角色
            ,suggestion -- 审批意见
            ,act_ru_task_id -- 任务ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_form_suggestion_op(
            suggestion_id -- 审批意见标识
            ,party_id -- 人员ID
            ,node_id -- 节点ID
            ,organ_code -- 机构
            ,process_ins_id -- 流程实体ID
            ,suggestion_time -- 审批时间
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,party_id_dummy -- 人员-迁移用
            ,organ_code_dummy -- 机构-迁移用
            ,assignee_role_id -- 处理人角色
            ,suggestion -- 审批意见
            ,act_ru_task_id -- 任务ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.suggestion_id -- 审批意见标识
    ,o.party_id -- 人员ID
    ,o.node_id -- 节点ID
    ,o.organ_code -- 机构
    ,o.process_ins_id -- 流程实体ID
    ,o.suggestion_time -- 审批时间
    ,o.last_updated_stamp -- 最后更新时间
    ,o.last_updated_tx_stamp -- 最后更新事务时间
    ,o.created_stamp -- 创建时间
    ,o.created_tx_stamp -- 创建事务时间
    ,o.party_id_dummy -- 人员-迁移用
    ,o.organ_code_dummy -- 机构-迁移用
    ,o.assignee_role_id -- 处理人角色
    ,o.suggestion -- 审批意见
    ,o.act_ru_task_id -- 任务ID
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
from ${iol_schema}.noas_oa_form_suggestion_bk o
    left join ${iol_schema}.noas_oa_form_suggestion_op n
        on
            o.suggestion_id = n.suggestion_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.noas_oa_form_suggestion_cl d
        on
            o.suggestion_id = d.suggestion_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.noas_oa_form_suggestion;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('noas_oa_form_suggestion') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.noas_oa_form_suggestion drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.noas_oa_form_suggestion add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.noas_oa_form_suggestion exchange partition p_${batch_date} with table ${iol_schema}.noas_oa_form_suggestion_cl;
alter table ${iol_schema}.noas_oa_form_suggestion exchange partition p_20991231 with table ${iol_schema}.noas_oa_form_suggestion_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.noas_oa_form_suggestion to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_form_suggestion_op purge;
drop table ${iol_schema}.noas_oa_form_suggestion_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.noas_oa_form_suggestion_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'noas_oa_form_suggestion',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
