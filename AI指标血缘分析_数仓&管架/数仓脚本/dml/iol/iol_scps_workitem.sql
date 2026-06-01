/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_workitem
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
create table ${iol_schema}.scps_workitem_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_workitem
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_workitem_op purge;
drop table ${iol_schema}.scps_workitem_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_workitem_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_workitem where 0=1;

create table ${iol_schema}.scps_workitem_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_workitem where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_workitem_cl(
            id -- 工作项id
            ,name -- 工作项名称
            ,atiid -- 活动实例id
            ,priid -- 流程实例id
            ,priname -- 流程实例名称
            ,executor -- 执行人
            ,createtime -- 创建时间
            ,checkouttime -- 检出时间
            ,checkintime -- 检入时间
            ,passedtime -- 耗时
            ,state -- 状态
            ,description -- 工作项描述
            ,priority -- 优先级
            ,weightiness -- 权重
            ,groupid -- 分组id
            ,appid -- 应用id
            ,input_time -- 录入时间
            ,update_time -- 最后一次修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_workitem_op(
            id -- 工作项id
            ,name -- 工作项名称
            ,atiid -- 活动实例id
            ,priid -- 流程实例id
            ,priname -- 流程实例名称
            ,executor -- 执行人
            ,createtime -- 创建时间
            ,checkouttime -- 检出时间
            ,checkintime -- 检入时间
            ,passedtime -- 耗时
            ,state -- 状态
            ,description -- 工作项描述
            ,priority -- 优先级
            ,weightiness -- 权重
            ,groupid -- 分组id
            ,appid -- 应用id
            ,input_time -- 录入时间
            ,update_time -- 最后一次修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 工作项id
    ,nvl(n.name, o.name) as name -- 工作项名称
    ,nvl(n.atiid, o.atiid) as atiid -- 活动实例id
    ,nvl(n.priid, o.priid) as priid -- 流程实例id
    ,nvl(n.priname, o.priname) as priname -- 流程实例名称
    ,nvl(n.executor, o.executor) as executor -- 执行人
    ,nvl(n.createtime, o.createtime) as createtime -- 创建时间
    ,nvl(n.checkouttime, o.checkouttime) as checkouttime -- 检出时间
    ,nvl(n.checkintime, o.checkintime) as checkintime -- 检入时间
    ,nvl(n.passedtime, o.passedtime) as passedtime -- 耗时
    ,nvl(n.state, o.state) as state -- 状态
    ,nvl(n.description, o.description) as description -- 工作项描述
    ,nvl(n.priority, o.priority) as priority -- 优先级
    ,nvl(n.weightiness, o.weightiness) as weightiness -- 权重
    ,nvl(n.groupid, o.groupid) as groupid -- 分组id
    ,nvl(n.appid, o.appid) as appid -- 应用id
    ,nvl(n.input_time, o.input_time) as input_time -- 录入时间
    ,nvl(n.update_time, o.update_time) as update_time -- 最后一次修改时间
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
from (select * from ${iol_schema}.scps_workitem_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_workitem where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.name <> n.name
        or o.atiid <> n.atiid
        or o.priid <> n.priid
        or o.priname <> n.priname
        or o.executor <> n.executor
        or o.createtime <> n.createtime
        or o.checkouttime <> n.checkouttime
        or o.checkintime <> n.checkintime
        or o.passedtime <> n.passedtime
        or o.state <> n.state
        or o.description <> n.description
        or o.priority <> n.priority
        or o.weightiness <> n.weightiness
        or o.groupid <> n.groupid
        or o.appid <> n.appid
        or o.input_time <> n.input_time
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_workitem_cl(
            id -- 工作项id
            ,name -- 工作项名称
            ,atiid -- 活动实例id
            ,priid -- 流程实例id
            ,priname -- 流程实例名称
            ,executor -- 执行人
            ,createtime -- 创建时间
            ,checkouttime -- 检出时间
            ,checkintime -- 检入时间
            ,passedtime -- 耗时
            ,state -- 状态
            ,description -- 工作项描述
            ,priority -- 优先级
            ,weightiness -- 权重
            ,groupid -- 分组id
            ,appid -- 应用id
            ,input_time -- 录入时间
            ,update_time -- 最后一次修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_workitem_op(
            id -- 工作项id
            ,name -- 工作项名称
            ,atiid -- 活动实例id
            ,priid -- 流程实例id
            ,priname -- 流程实例名称
            ,executor -- 执行人
            ,createtime -- 创建时间
            ,checkouttime -- 检出时间
            ,checkintime -- 检入时间
            ,passedtime -- 耗时
            ,state -- 状态
            ,description -- 工作项描述
            ,priority -- 优先级
            ,weightiness -- 权重
            ,groupid -- 分组id
            ,appid -- 应用id
            ,input_time -- 录入时间
            ,update_time -- 最后一次修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 工作项id
    ,o.name -- 工作项名称
    ,o.atiid -- 活动实例id
    ,o.priid -- 流程实例id
    ,o.priname -- 流程实例名称
    ,o.executor -- 执行人
    ,o.createtime -- 创建时间
    ,o.checkouttime -- 检出时间
    ,o.checkintime -- 检入时间
    ,o.passedtime -- 耗时
    ,o.state -- 状态
    ,o.description -- 工作项描述
    ,o.priority -- 优先级
    ,o.weightiness -- 权重
    ,o.groupid -- 分组id
    ,o.appid -- 应用id
    ,o.input_time -- 录入时间
    ,o.update_time -- 最后一次修改时间
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
from ${iol_schema}.scps_workitem_bk o
    left join ${iol_schema}.scps_workitem_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_workitem_cl d
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
--truncate table ${iol_schema}.scps_workitem;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_workitem') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_workitem drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_workitem add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_workitem exchange partition p_${batch_date} with table ${iol_schema}.scps_workitem_cl;
alter table ${iol_schema}.scps_workitem exchange partition p_20991231 with table ${iol_schema}.scps_workitem_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_workitem to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_workitem_op purge;
drop table ${iol_schema}.scps_workitem_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_workitem_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_workitem',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
