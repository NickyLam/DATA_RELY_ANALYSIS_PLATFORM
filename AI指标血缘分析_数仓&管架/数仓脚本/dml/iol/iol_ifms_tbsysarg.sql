/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbsysarg
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
create table ${iol_schema}.ifms_tbsysarg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbsysarg;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbsysarg_op purge;
drop table ${iol_schema}.ifms_tbsysarg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbsysarg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbsysarg where 0=1;

create table ${iol_schema}.ifms_tbsysarg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbsysarg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbsysarg_cl(
            seller_code -- 
            ,bank_name -- 
            ,system_name -- 
            ,bank_short_name -- 
            ,prev_date -- 
            ,init_date -- 
            ,host_check_date -- 
            ,rights -- 
            ,unfrozen_flag -- 
            ,holddays -- 
            ,status -- 
            ,befbkup_date -- 
            ,aftbkup_date -- 
            ,hisbkup_date -- 
            ,fstunloadbeg_date -- 
            ,sharechg_days -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbsysarg_op(
            seller_code -- 
            ,bank_name -- 
            ,system_name -- 
            ,bank_short_name -- 
            ,prev_date -- 
            ,init_date -- 
            ,host_check_date -- 
            ,rights -- 
            ,unfrozen_flag -- 
            ,holddays -- 
            ,status -- 
            ,befbkup_date -- 
            ,aftbkup_date -- 
            ,hisbkup_date -- 
            ,fstunloadbeg_date -- 
            ,sharechg_days -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seller_code, o.seller_code) as seller_code -- 
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 
    ,nvl(n.system_name, o.system_name) as system_name -- 
    ,nvl(n.bank_short_name, o.bank_short_name) as bank_short_name -- 
    ,nvl(n.prev_date, o.prev_date) as prev_date -- 
    ,nvl(n.init_date, o.init_date) as init_date -- 
    ,nvl(n.host_check_date, o.host_check_date) as host_check_date -- 
    ,nvl(n.rights, o.rights) as rights -- 
    ,nvl(n.unfrozen_flag, o.unfrozen_flag) as unfrozen_flag -- 
    ,nvl(n.holddays, o.holddays) as holddays -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.befbkup_date, o.befbkup_date) as befbkup_date -- 
    ,nvl(n.aftbkup_date, o.aftbkup_date) as aftbkup_date -- 
    ,nvl(n.hisbkup_date, o.hisbkup_date) as hisbkup_date -- 
    ,nvl(n.fstunloadbeg_date, o.fstunloadbeg_date) as fstunloadbeg_date -- 
    ,nvl(n.sharechg_days, o.sharechg_days) as sharechg_days -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,case when
            n.seller_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seller_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seller_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbsysarg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbsysarg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seller_code = n.seller_code
where (
        o.seller_code is null
    )
    or (
        n.seller_code is null
    )
    or (
        o.bank_name <> n.bank_name
        or o.system_name <> n.system_name
        or o.bank_short_name <> n.bank_short_name
        or o.prev_date <> n.prev_date
        or o.init_date <> n.init_date
        or o.host_check_date <> n.host_check_date
        or o.rights <> n.rights
        or o.unfrozen_flag <> n.unfrozen_flag
        or o.holddays <> n.holddays
        or o.status <> n.status
        or o.befbkup_date <> n.befbkup_date
        or o.aftbkup_date <> n.aftbkup_date
        or o.hisbkup_date <> n.hisbkup_date
        or o.fstunloadbeg_date <> n.fstunloadbeg_date
        or o.sharechg_days <> n.sharechg_days
        or o.reserve1 <> n.reserve1
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbsysarg_cl(
            seller_code -- 
            ,bank_name -- 
            ,system_name -- 
            ,bank_short_name -- 
            ,prev_date -- 
            ,init_date -- 
            ,host_check_date -- 
            ,rights -- 
            ,unfrozen_flag -- 
            ,holddays -- 
            ,status -- 
            ,befbkup_date -- 
            ,aftbkup_date -- 
            ,hisbkup_date -- 
            ,fstunloadbeg_date -- 
            ,sharechg_days -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbsysarg_op(
            seller_code -- 
            ,bank_name -- 
            ,system_name -- 
            ,bank_short_name -- 
            ,prev_date -- 
            ,init_date -- 
            ,host_check_date -- 
            ,rights -- 
            ,unfrozen_flag -- 
            ,holddays -- 
            ,status -- 
            ,befbkup_date -- 
            ,aftbkup_date -- 
            ,hisbkup_date -- 
            ,fstunloadbeg_date -- 
            ,sharechg_days -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seller_code -- 
    ,o.bank_name -- 
    ,o.system_name -- 
    ,o.bank_short_name -- 
    ,o.prev_date -- 
    ,o.init_date -- 
    ,o.host_check_date -- 
    ,o.rights -- 
    ,o.unfrozen_flag -- 
    ,o.holddays -- 
    ,o.status -- 
    ,o.befbkup_date -- 
    ,o.aftbkup_date -- 
    ,o.hisbkup_date -- 
    ,o.fstunloadbeg_date -- 
    ,o.sharechg_days -- 
    ,o.reserve1 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbsysarg_bk o
    left join ${iol_schema}.ifms_tbsysarg_op n
        on
            o.seller_code = n.seller_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbsysarg_cl d
        on
            o.seller_code = d.seller_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbsysarg;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbsysarg exchange partition p_19000101 with table ${iol_schema}.ifms_tbsysarg_cl;
alter table ${iol_schema}.ifms_tbsysarg exchange partition p_20991231 with table ${iol_schema}.ifms_tbsysarg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbsysarg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbsysarg_op purge;
drop table ${iol_schema}.ifms_tbsysarg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbsysarg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbsysarg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
