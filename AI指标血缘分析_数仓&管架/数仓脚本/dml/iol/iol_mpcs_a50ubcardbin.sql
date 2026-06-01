/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a50ubcardbin
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
create table ${iol_schema}.mpcs_a50ubcardbin_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a50ubcardbin;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a50ubcardbin_op purge;
drop table ${iol_schema}.mpcs_a50ubcardbin_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a50ubcardbin_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a50ubcardbin where 0=1;

create table ${iol_schema}.mpcs_a50ubcardbin_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a50ubcardbin where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a50ubcardbin_cl(
            pinblock -- 卡BIN
            ,flag -- 内卡标识: 1-有效;0-无效
            ,cardlen -- 
            ,binlen -- 
            ,bintype -- 
            ,updtime -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a50ubcardbin_op(
            pinblock -- 卡BIN
            ,flag -- 内卡标识: 1-有效;0-无效
            ,cardlen -- 
            ,binlen -- 
            ,bintype -- 
            ,updtime -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pinblock, o.pinblock) as pinblock -- 卡BIN
    ,nvl(n.flag, o.flag) as flag -- 内卡标识: 1-有效;0-无效
    ,nvl(n.cardlen, o.cardlen) as cardlen -- 
    ,nvl(n.binlen, o.binlen) as binlen -- 
    ,nvl(n.bintype, o.bintype) as bintype -- 
    ,nvl(n.updtime, o.updtime) as updtime -- 
    ,case when
            n.pinblock is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pinblock is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pinblock is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a50ubcardbin_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a50ubcardbin where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pinblock = n.pinblock
where (
        o.pinblock is null
    )
    or (
        n.pinblock is null
    )
    or (
        o.flag <> n.flag
        or o.cardlen <> n.cardlen
        or o.binlen <> n.binlen
        or o.bintype <> n.bintype
        or o.updtime <> n.updtime
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a50ubcardbin_cl(
            pinblock -- 卡BIN
            ,flag -- 内卡标识: 1-有效;0-无效
            ,cardlen -- 
            ,binlen -- 
            ,bintype -- 
            ,updtime -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a50ubcardbin_op(
            pinblock -- 卡BIN
            ,flag -- 内卡标识: 1-有效;0-无效
            ,cardlen -- 
            ,binlen -- 
            ,bintype -- 
            ,updtime -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pinblock -- 卡BIN
    ,o.flag -- 内卡标识: 1-有效;0-无效
    ,o.cardlen -- 
    ,o.binlen -- 
    ,o.bintype -- 
    ,o.updtime -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a50ubcardbin_bk o
    left join ${iol_schema}.mpcs_a50ubcardbin_op n
        on
            o.pinblock = n.pinblock
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a50ubcardbin_cl d
        on
            o.pinblock = d.pinblock
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a50ubcardbin;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a50ubcardbin exchange partition p_19000101 with table ${iol_schema}.mpcs_a50ubcardbin_cl;
alter table ${iol_schema}.mpcs_a50ubcardbin exchange partition p_20991231 with table ${iol_schema}.mpcs_a50ubcardbin_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a50ubcardbin to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a50ubcardbin_op purge;
drop table ${iol_schema}.mpcs_a50ubcardbin_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a50ubcardbin_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a50ubcardbin',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
