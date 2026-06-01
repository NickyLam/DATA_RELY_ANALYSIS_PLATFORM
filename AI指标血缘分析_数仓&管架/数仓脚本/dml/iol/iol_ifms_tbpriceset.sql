/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbpriceset
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
create table ${iol_schema}.ifms_tbpriceset_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbpriceset;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbpriceset_op purge;
drop table ${iol_schema}.ifms_tbpriceset_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbpriceset_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbpriceset where 0=1;

create table ${iol_schema}.ifms_tbpriceset_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbpriceset where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbpriceset_cl(
            serial_no -- 
            ,prd_code -- 
            ,valid_date -- 
            ,price_mode -- 
            ,seller_code -- 
            ,client_group -- 
            ,client_type -- 
            ,seller_type -- 
            ,channel -- 
            ,hold_days -- 
            ,min_hold_days -- 
            ,max_hold_days -- 
            ,min_hold_amt -- 
            ,max_hold_amt -- 
            ,client_ratio -- 
            ,bank_ratio -- 
            ,min_income -- 
            ,max_income -- 
            ,default_flag -- 
            ,amt1 -- 
            ,ratio1 -- 
            ,ratio2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbpriceset_op(
            serial_no -- 
            ,prd_code -- 
            ,valid_date -- 
            ,price_mode -- 
            ,seller_code -- 
            ,client_group -- 
            ,client_type -- 
            ,seller_type -- 
            ,channel -- 
            ,hold_days -- 
            ,min_hold_days -- 
            ,max_hold_days -- 
            ,min_hold_amt -- 
            ,max_hold_amt -- 
            ,client_ratio -- 
            ,bank_ratio -- 
            ,min_income -- 
            ,max_income -- 
            ,default_flag -- 
            ,amt1 -- 
            ,ratio1 -- 
            ,ratio2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serial_no, o.serial_no) as serial_no -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.valid_date, o.valid_date) as valid_date -- 
    ,nvl(n.price_mode, o.price_mode) as price_mode -- 
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 
    ,nvl(n.client_group, o.client_group) as client_group -- 
    ,nvl(n.client_type, o.client_type) as client_type -- 
    ,nvl(n.seller_type, o.seller_type) as seller_type -- 
    ,nvl(n.channel, o.channel) as channel -- 
    ,nvl(n.hold_days, o.hold_days) as hold_days -- 
    ,nvl(n.min_hold_days, o.min_hold_days) as min_hold_days -- 
    ,nvl(n.max_hold_days, o.max_hold_days) as max_hold_days -- 
    ,nvl(n.min_hold_amt, o.min_hold_amt) as min_hold_amt -- 
    ,nvl(n.max_hold_amt, o.max_hold_amt) as max_hold_amt -- 
    ,nvl(n.client_ratio, o.client_ratio) as client_ratio -- 
    ,nvl(n.bank_ratio, o.bank_ratio) as bank_ratio -- 
    ,nvl(n.min_income, o.min_income) as min_income -- 
    ,nvl(n.max_income, o.max_income) as max_income -- 
    ,nvl(n.default_flag, o.default_flag) as default_flag -- 
    ,nvl(n.amt1, o.amt1) as amt1 -- 
    ,nvl(n.ratio1, o.ratio1) as ratio1 -- 
    ,nvl(n.ratio2, o.ratio2) as ratio2 -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,case when
            n.serial_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serial_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serial_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbpriceset_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbpriceset where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serial_no = n.serial_no
where (
        o.serial_no is null
    )
    or (
        n.serial_no is null
    )
    or (
        o.prd_code <> n.prd_code
        or o.valid_date <> n.valid_date
        or o.price_mode <> n.price_mode
        or o.seller_code <> n.seller_code
        or o.client_group <> n.client_group
        or o.client_type <> n.client_type
        or o.seller_type <> n.seller_type
        or o.channel <> n.channel
        or o.hold_days <> n.hold_days
        or o.min_hold_days <> n.min_hold_days
        or o.max_hold_days <> n.max_hold_days
        or o.min_hold_amt <> n.min_hold_amt
        or o.max_hold_amt <> n.max_hold_amt
        or o.client_ratio <> n.client_ratio
        or o.bank_ratio <> n.bank_ratio
        or o.min_income <> n.min_income
        or o.max_income <> n.max_income
        or o.default_flag <> n.default_flag
        or o.amt1 <> n.amt1
        or o.ratio1 <> n.ratio1
        or o.ratio2 <> n.ratio2
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbpriceset_cl(
            serial_no -- 
            ,prd_code -- 
            ,valid_date -- 
            ,price_mode -- 
            ,seller_code -- 
            ,client_group -- 
            ,client_type -- 
            ,seller_type -- 
            ,channel -- 
            ,hold_days -- 
            ,min_hold_days -- 
            ,max_hold_days -- 
            ,min_hold_amt -- 
            ,max_hold_amt -- 
            ,client_ratio -- 
            ,bank_ratio -- 
            ,min_income -- 
            ,max_income -- 
            ,default_flag -- 
            ,amt1 -- 
            ,ratio1 -- 
            ,ratio2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbpriceset_op(
            serial_no -- 
            ,prd_code -- 
            ,valid_date -- 
            ,price_mode -- 
            ,seller_code -- 
            ,client_group -- 
            ,client_type -- 
            ,seller_type -- 
            ,channel -- 
            ,hold_days -- 
            ,min_hold_days -- 
            ,max_hold_days -- 
            ,min_hold_amt -- 
            ,max_hold_amt -- 
            ,client_ratio -- 
            ,bank_ratio -- 
            ,min_income -- 
            ,max_income -- 
            ,default_flag -- 
            ,amt1 -- 
            ,ratio1 -- 
            ,ratio2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serial_no -- 
    ,o.prd_code -- 
    ,o.valid_date -- 
    ,o.price_mode -- 
    ,o.seller_code -- 
    ,o.client_group -- 
    ,o.client_type -- 
    ,o.seller_type -- 
    ,o.channel -- 
    ,o.hold_days -- 
    ,o.min_hold_days -- 
    ,o.max_hold_days -- 
    ,o.min_hold_amt -- 
    ,o.max_hold_amt -- 
    ,o.client_ratio -- 
    ,o.bank_ratio -- 
    ,o.min_income -- 
    ,o.max_income -- 
    ,o.default_flag -- 
    ,o.amt1 -- 
    ,o.ratio1 -- 
    ,o.ratio2 -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbpriceset_bk o
    left join ${iol_schema}.ifms_tbpriceset_op n
        on
            o.serial_no = n.serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbpriceset_cl d
        on
            o.serial_no = d.serial_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbpriceset;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbpriceset exchange partition p_19000101 with table ${iol_schema}.ifms_tbpriceset_cl;
alter table ${iol_schema}.ifms_tbpriceset exchange partition p_20991231 with table ${iol_schema}.ifms_tbpriceset_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbpriceset to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbpriceset_op purge;
drop table ${iol_schema}.ifms_tbpriceset_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbpriceset_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbpriceset',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
