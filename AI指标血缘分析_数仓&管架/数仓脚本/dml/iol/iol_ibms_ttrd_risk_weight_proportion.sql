/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_risk_weight_proportion
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
create table ${iol_schema}.ibms_ttrd_risk_weight_proportion_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_risk_weight_proportion;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_risk_weight_proportion_op purge;
drop table ${iol_schema}.ibms_ttrd_risk_weight_proportion_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_risk_weight_proportion_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_risk_weight_proportion where 0=1;

create table ${iol_schema}.ibms_ttrd_risk_weight_proportion_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_risk_weight_proportion where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_risk_weight_proportion_cl(
            i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,risk_id -- 风险占比表id
            ,proportion -- 占比
            ,update_time -- 生效时间
            ,update_user_id -- 
            ,status -- 
            ,effective_time -- 生效时间
            ,is_current -- 是否为最新数据
            ,id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_risk_weight_proportion_op(
            i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,risk_id -- 风险占比表id
            ,proportion -- 占比
            ,update_time -- 生效时间
            ,update_user_id -- 
            ,status -- 
            ,effective_time -- 生效时间
            ,is_current -- 是否为最新数据
            ,id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 
    ,nvl(n.a_type, o.a_type) as a_type -- 
    ,nvl(n.m_type, o.m_type) as m_type -- 
    ,nvl(n.risk_id, o.risk_id) as risk_id -- 风险占比表id
    ,nvl(n.proportion, o.proportion) as proportion -- 占比
    ,nvl(n.update_time, o.update_time) as update_time -- 生效时间
    ,nvl(n.update_user_id, o.update_user_id) as update_user_id -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.effective_time, o.effective_time) as effective_time -- 生效时间
    ,nvl(n.is_current, o.is_current) as is_current -- 是否为最新数据
    ,nvl(n.id, o.id) as id -- 
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
from (select * from ${iol_schema}.ibms_ttrd_risk_weight_proportion_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_risk_weight_proportion where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.risk_id <> n.risk_id
        or o.proportion <> n.proportion
        or o.update_time <> n.update_time
        or o.update_user_id <> n.update_user_id
        or o.status <> n.status
        or o.effective_time <> n.effective_time
        or o.is_current <> n.is_current
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_risk_weight_proportion_cl(
            i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,risk_id -- 风险占比表id
            ,proportion -- 占比
            ,update_time -- 生效时间
            ,update_user_id -- 
            ,status -- 
            ,effective_time -- 生效时间
            ,is_current -- 是否为最新数据
            ,id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_risk_weight_proportion_op(
            i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,risk_id -- 风险占比表id
            ,proportion -- 占比
            ,update_time -- 生效时间
            ,update_user_id -- 
            ,status -- 
            ,effective_time -- 生效时间
            ,is_current -- 是否为最新数据
            ,id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 
    ,o.a_type -- 
    ,o.m_type -- 
    ,o.risk_id -- 风险占比表id
    ,o.proportion -- 占比
    ,o.update_time -- 生效时间
    ,o.update_user_id -- 
    ,o.status -- 
    ,o.effective_time -- 生效时间
    ,o.is_current -- 是否为最新数据
    ,o.id -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_risk_weight_proportion_bk o
    left join ${iol_schema}.ibms_ttrd_risk_weight_proportion_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_risk_weight_proportion_cl d
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
-- truncate table ${iol_schema}.ibms_ttrd_risk_weight_proportion;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_risk_weight_proportion exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_risk_weight_proportion_cl;
alter table ${iol_schema}.ibms_ttrd_risk_weight_proportion exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_risk_weight_proportion_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_risk_weight_proportion to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_risk_weight_proportion_op purge;
drop table ${iol_schema}.ibms_ttrd_risk_weight_proportion_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_risk_weight_proportion_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_risk_weight_proportion',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
