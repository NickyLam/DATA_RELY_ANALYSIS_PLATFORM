/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbcashdate
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
create table ${iol_schema}.ifms_tbcashdate_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbcashdate;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbcashdate_op purge;
drop table ${iol_schema}.ifms_tbcashdate_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbcashdate_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbcashdate where 0=1;

create table ${iol_schema}.ifms_tbcashdate_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbcashdate where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbcashdate_cl(
            cash_date -- 
            ,prd_code -- 
            ,deal_status -- 
            ,deal_date -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbcashdate_op(
            cash_date -- 
            ,prd_code -- 
            ,deal_status -- 
            ,deal_date -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cash_date, o.cash_date) as cash_date -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 
    ,nvl(n.deal_date, o.deal_date) as deal_date -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,case when
            n.cash_date is null
            and n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cash_date is null
            and n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cash_date is null
            and n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbcashdate_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbcashdate where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cash_date = n.cash_date
            and o.prd_code = n.prd_code
where (
        o.cash_date is null
        and o.prd_code is null
    )
    or (
        n.cash_date is null
        and n.prd_code is null
    )
    or (
        o.deal_status <> n.deal_status
        or o.deal_date <> n.deal_date
        or o.reserve1 <> n.reserve1
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbcashdate_cl(
            cash_date -- 
            ,prd_code -- 
            ,deal_status -- 
            ,deal_date -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbcashdate_op(
            cash_date -- 
            ,prd_code -- 
            ,deal_status -- 
            ,deal_date -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cash_date -- 
    ,o.prd_code -- 
    ,o.deal_status -- 
    ,o.deal_date -- 
    ,o.reserve1 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbcashdate_bk o
    left join ${iol_schema}.ifms_tbcashdate_op n
        on
            o.cash_date = n.cash_date
            and o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbcashdate_cl d
        on
            o.cash_date = d.cash_date
            and o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbcashdate;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbcashdate exchange partition p_19000101 with table ${iol_schema}.ifms_tbcashdate_cl;
alter table ${iol_schema}.ifms_tbcashdate exchange partition p_20991231 with table ${iol_schema}.ifms_tbcashdate_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbcashdate to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbcashdate_op purge;
drop table ${iol_schema}.ifms_tbcashdate_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbcashdate_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbcashdate',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
