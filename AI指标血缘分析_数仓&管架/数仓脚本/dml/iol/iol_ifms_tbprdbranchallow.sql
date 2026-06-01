/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbprdbranchallow
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
create table ${iol_schema}.ifms_tbprdbranchallow_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbprdbranchallow;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbprdbranchallow_op purge;
drop table ${iol_schema}.ifms_tbprdbranchallow_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbprdbranchallow_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbprdbranchallow where 0=1;

create table ${iol_schema}.ifms_tbprdbranchallow_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbprdbranchallow where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbprdbranchallow_cl(
            prd_code -- 
            ,internal_branch -- 
            ,enable_flag -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbprdbranchallow_op(
            prd_code -- 
            ,internal_branch -- 
            ,enable_flag -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.internal_branch, o.internal_branch) as internal_branch -- 
    ,nvl(n.enable_flag, o.enable_flag) as enable_flag -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,case when
            n.prd_code is null
            and n.internal_branch is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_code is null
            and n.internal_branch is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_code is null
            and n.internal_branch is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbprdbranchallow_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbprdbranchallow where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_code = n.prd_code
            and o.internal_branch = n.internal_branch
where (
        o.prd_code is null
        and o.internal_branch is null
    )
    or (
        n.prd_code is null
        and n.internal_branch is null
    )
    or (
        o.enable_flag <> n.enable_flag
        or o.reserve1 <> n.reserve1
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbprdbranchallow_cl(
            prd_code -- 
            ,internal_branch -- 
            ,enable_flag -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbprdbranchallow_op(
            prd_code -- 
            ,internal_branch -- 
            ,enable_flag -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prd_code -- 
    ,o.internal_branch -- 
    ,o.enable_flag -- 
    ,o.reserve1 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbprdbranchallow_bk o
    left join ${iol_schema}.ifms_tbprdbranchallow_op n
        on
            o.prd_code = n.prd_code
            and o.internal_branch = n.internal_branch
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbprdbranchallow_cl d
        on
            o.prd_code = d.prd_code
            and o.internal_branch = d.internal_branch
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbprdbranchallow;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbprdbranchallow exchange partition p_19000101 with table ${iol_schema}.ifms_tbprdbranchallow_cl;
alter table ${iol_schema}.ifms_tbprdbranchallow exchange partition p_20991231 with table ${iol_schema}.ifms_tbprdbranchallow_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbprdbranchallow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbprdbranchallow_op purge;
drop table ${iol_schema}.ifms_tbprdbranchallow_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbprdbranchallow_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbprdbranchallow',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
