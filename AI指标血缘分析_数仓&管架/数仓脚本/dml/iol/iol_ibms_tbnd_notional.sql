/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_tbnd_notional
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
create table ${iol_schema}.ibms_tbnd_notional_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_tbnd_notional;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tbnd_notional_op purge;
drop table ${iol_schema}.ibms_tbnd_notional_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tbnd_notional_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tbnd_notional where 0=1;

create table ${iol_schema}.ibms_tbnd_notional_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tbnd_notional where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tbnd_notional_cl(
            d_code -- 债券内部代码
            ,i_code -- 交易代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,b_exec_date -- 生效日
            ,b_notional -- 剩余本金
            ,pipe_id -- 导入管道
            ,imp_date -- 导入日期
            ,imp_time -- 导入时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tbnd_notional_op(
            d_code -- 债券内部代码
            ,i_code -- 交易代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,b_exec_date -- 生效日
            ,b_notional -- 剩余本金
            ,pipe_id -- 导入管道
            ,imp_date -- 导入日期
            ,imp_time -- 导入时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.d_code, o.d_code) as d_code -- 债券内部代码
    ,nvl(n.i_code, o.i_code) as i_code -- 交易代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.b_exec_date, o.b_exec_date) as b_exec_date -- 生效日
    ,nvl(n.b_notional, o.b_notional) as b_notional -- 剩余本金
    ,nvl(n.pipe_id, o.pipe_id) as pipe_id -- 导入管道
    ,nvl(n.imp_date, o.imp_date) as imp_date -- 导入日期
    ,nvl(n.imp_time, o.imp_time) as imp_time -- 导入时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.b_exec_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.b_exec_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.b_exec_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_tbnd_notional_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_tbnd_notional where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.b_exec_date = n.b_exec_date
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
        and o.b_exec_date is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
        and n.b_exec_date is null
    )
    or (
        o.d_code <> n.d_code
        or o.b_notional <> n.b_notional
        or o.pipe_id <> n.pipe_id
        or o.imp_date <> n.imp_date
        or o.imp_time <> n.imp_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tbnd_notional_cl(
            d_code -- 债券内部代码
            ,i_code -- 交易代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,b_exec_date -- 生效日
            ,b_notional -- 剩余本金
            ,pipe_id -- 导入管道
            ,imp_date -- 导入日期
            ,imp_time -- 导入时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tbnd_notional_op(
            d_code -- 债券内部代码
            ,i_code -- 交易代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,b_exec_date -- 生效日
            ,b_notional -- 剩余本金
            ,pipe_id -- 导入管道
            ,imp_date -- 导入日期
            ,imp_time -- 导入时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.d_code -- 债券内部代码
    ,o.i_code -- 交易代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.b_exec_date -- 生效日
    ,o.b_notional -- 剩余本金
    ,o.pipe_id -- 导入管道
    ,o.imp_date -- 导入日期
    ,o.imp_time -- 导入时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_tbnd_notional_bk o
    left join ${iol_schema}.ibms_tbnd_notional_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.b_exec_date = n.b_exec_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_tbnd_notional_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
            and o.b_exec_date = d.b_exec_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_tbnd_notional;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_tbnd_notional exchange partition p_19000101 with table ${iol_schema}.ibms_tbnd_notional_cl;
alter table ${iol_schema}.ibms_tbnd_notional exchange partition p_20991231 with table ${iol_schema}.ibms_tbnd_notional_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_tbnd_notional to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tbnd_notional_op purge;
drop table ${iol_schema}.ibms_tbnd_notional_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_tbnd_notional_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_tbnd_notional',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
