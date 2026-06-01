/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alss_rate_ol_cust_curr
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
create table ${iol_schema}.alss_rate_ol_cust_curr_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.alss_rate_ol_cust_curr
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.alss_rate_ol_cust_curr_op purge;
drop table ${iol_schema}.alss_rate_ol_cust_curr_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_rate_ol_cust_curr_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.alss_rate_ol_cust_curr where 0=1;

create table ${iol_schema}.alss_rate_ol_cust_curr_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.alss_rate_ol_cust_curr where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.alss_rate_ol_cust_curr_cl(
            curr_id -- 主键
            ,rate_id -- 商户号(主键)
            ,rate_name -- 商户名称
            ,chanl_code -- 场景code
            ,chanl_name -- 场景名称
            ,model_code -- 模型code
            ,model_name -- 模型名称
            ,event_code -- 事件code
            ,event_name -- 事件名称
            ,method_code -- 触发方式
            ,method_name -- 触发方式名称
            ,score -- 分值
            ,level_name -- 评分等级名称
            ,namelist -- 所属名单
            ,oper -- 更新者
            ,rate_time -- 评级时间
            ,next_rate_time -- 下次评级时间
            ,state -- 状态(0：关闭评级；1：开启评级)
            ,develop_dept -- 运营机构
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,cust_type -- 
            ,view_status -- 
            ,risk_list -- 上一次评级命中黑名单
            ,risk_time -- 上一次评级命中黑名单时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.alss_rate_ol_cust_curr_op(
            curr_id -- 主键
            ,rate_id -- 商户号(主键)
            ,rate_name -- 商户名称
            ,chanl_code -- 场景code
            ,chanl_name -- 场景名称
            ,model_code -- 模型code
            ,model_name -- 模型名称
            ,event_code -- 事件code
            ,event_name -- 事件名称
            ,method_code -- 触发方式
            ,method_name -- 触发方式名称
            ,score -- 分值
            ,level_name -- 评分等级名称
            ,namelist -- 所属名单
            ,oper -- 更新者
            ,rate_time -- 评级时间
            ,next_rate_time -- 下次评级时间
            ,state -- 状态(0：关闭评级；1：开启评级)
            ,develop_dept -- 运营机构
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,cust_type -- 
            ,view_status -- 
            ,risk_list -- 上一次评级命中黑名单
            ,risk_time -- 上一次评级命中黑名单时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.curr_id, o.curr_id) as curr_id -- 主键
    ,nvl(n.rate_id, o.rate_id) as rate_id -- 商户号(主键)
    ,nvl(n.rate_name, o.rate_name) as rate_name -- 商户名称
    ,nvl(n.chanl_code, o.chanl_code) as chanl_code -- 场景code
    ,nvl(n.chanl_name, o.chanl_name) as chanl_name -- 场景名称
    ,nvl(n.model_code, o.model_code) as model_code -- 模型code
    ,nvl(n.model_name, o.model_name) as model_name -- 模型名称
    ,nvl(n.event_code, o.event_code) as event_code -- 事件code
    ,nvl(n.event_name, o.event_name) as event_name -- 事件名称
    ,nvl(n.method_code, o.method_code) as method_code -- 触发方式
    ,nvl(n.method_name, o.method_name) as method_name -- 触发方式名称
    ,nvl(n.score, o.score) as score -- 分值
    ,nvl(n.level_name, o.level_name) as level_name -- 评分等级名称
    ,nvl(n.namelist, o.namelist) as namelist -- 所属名单
    ,nvl(n.oper, o.oper) as oper -- 更新者
    ,nvl(n.rate_time, o.rate_time) as rate_time -- 评级时间
    ,nvl(n.next_rate_time, o.next_rate_time) as next_rate_time -- 下次评级时间
    ,nvl(n.state, o.state) as state -- 状态(0：关闭评级；1：开启评级)
    ,nvl(n.develop_dept, o.develop_dept) as develop_dept -- 运营机构
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 
    ,nvl(n.view_status, o.view_status) as view_status -- 
    ,nvl(n.risk_list, o.risk_list) as risk_list -- 上一次评级命中黑名单
    ,nvl(n.risk_time, o.risk_time) as risk_time -- 上一次评级命中黑名单时间
    ,case when
            n.curr_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.curr_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.curr_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.alss_rate_ol_cust_curr_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.alss_rate_ol_cust_curr where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.curr_id = n.curr_id
where (
        o.curr_id is null
    )
    or (
        n.curr_id is null
    )
    or (
        o.rate_id <> n.rate_id
        or o.rate_name <> n.rate_name
        or o.chanl_code <> n.chanl_code
        or o.chanl_name <> n.chanl_name
        or o.model_code <> n.model_code
        or o.model_name <> n.model_name
        or o.event_code <> n.event_code
        or o.event_name <> n.event_name
        or o.method_code <> n.method_code
        or o.method_name <> n.method_name
        or o.score <> n.score
        or o.level_name <> n.level_name
        or o.namelist <> n.namelist
        or o.oper <> n.oper
        or o.rate_time <> n.rate_time
        or o.next_rate_time <> n.next_rate_time
        or o.state <> n.state
        or o.develop_dept <> n.develop_dept
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.cust_type <> n.cust_type
        or o.view_status <> n.view_status
        or o.risk_list <> n.risk_list
        or o.risk_time <> n.risk_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.alss_rate_ol_cust_curr_cl(
            curr_id -- 主键
            ,rate_id -- 商户号(主键)
            ,rate_name -- 商户名称
            ,chanl_code -- 场景code
            ,chanl_name -- 场景名称
            ,model_code -- 模型code
            ,model_name -- 模型名称
            ,event_code -- 事件code
            ,event_name -- 事件名称
            ,method_code -- 触发方式
            ,method_name -- 触发方式名称
            ,score -- 分值
            ,level_name -- 评分等级名称
            ,namelist -- 所属名单
            ,oper -- 更新者
            ,rate_time -- 评级时间
            ,next_rate_time -- 下次评级时间
            ,state -- 状态(0：关闭评级；1：开启评级)
            ,develop_dept -- 运营机构
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,cust_type -- 
            ,view_status -- 
            ,risk_list -- 上一次评级命中黑名单
            ,risk_time -- 上一次评级命中黑名单时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.alss_rate_ol_cust_curr_op(
            curr_id -- 主键
            ,rate_id -- 商户号(主键)
            ,rate_name -- 商户名称
            ,chanl_code -- 场景code
            ,chanl_name -- 场景名称
            ,model_code -- 模型code
            ,model_name -- 模型名称
            ,event_code -- 事件code
            ,event_name -- 事件名称
            ,method_code -- 触发方式
            ,method_name -- 触发方式名称
            ,score -- 分值
            ,level_name -- 评分等级名称
            ,namelist -- 所属名单
            ,oper -- 更新者
            ,rate_time -- 评级时间
            ,next_rate_time -- 下次评级时间
            ,state -- 状态(0：关闭评级；1：开启评级)
            ,develop_dept -- 运营机构
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,cust_type -- 
            ,view_status -- 
            ,risk_list -- 上一次评级命中黑名单
            ,risk_time -- 上一次评级命中黑名单时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.curr_id -- 主键
    ,o.rate_id -- 商户号(主键)
    ,o.rate_name -- 商户名称
    ,o.chanl_code -- 场景code
    ,o.chanl_name -- 场景名称
    ,o.model_code -- 模型code
    ,o.model_name -- 模型名称
    ,o.event_code -- 事件code
    ,o.event_name -- 事件名称
    ,o.method_code -- 触发方式
    ,o.method_name -- 触发方式名称
    ,o.score -- 分值
    ,o.level_name -- 评分等级名称
    ,o.namelist -- 所属名单
    ,o.oper -- 更新者
    ,o.rate_time -- 评级时间
    ,o.next_rate_time -- 下次评级时间
    ,o.state -- 状态(0：关闭评级；1：开启评级)
    ,o.develop_dept -- 运营机构
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
    ,o.cust_type -- 
    ,o.view_status -- 
    ,o.risk_list -- 上一次评级命中黑名单
    ,o.risk_time -- 上一次评级命中黑名单时间
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
from ${iol_schema}.alss_rate_ol_cust_curr_bk o
    left join ${iol_schema}.alss_rate_ol_cust_curr_op n
        on
            o.curr_id = n.curr_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.alss_rate_ol_cust_curr_cl d
        on
            o.curr_id = d.curr_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.alss_rate_ol_cust_curr;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('alss_rate_ol_cust_curr') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.alss_rate_ol_cust_curr drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.alss_rate_ol_cust_curr add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.alss_rate_ol_cust_curr exchange partition p_${batch_date} with table ${iol_schema}.alss_rate_ol_cust_curr_cl;
alter table ${iol_schema}.alss_rate_ol_cust_curr exchange partition p_20991231 with table ${iol_schema}.alss_rate_ol_cust_curr_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alss_rate_ol_cust_curr to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.alss_rate_ol_cust_curr_op purge;
drop table ${iol_schema}.alss_rate_ol_cust_curr_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.alss_rate_ol_cust_curr_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alss_rate_ol_cust_curr',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
