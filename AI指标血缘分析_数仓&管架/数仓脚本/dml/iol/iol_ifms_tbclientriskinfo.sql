/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbclientriskinfo
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
create table ${iol_schema}.ifms_tbclientriskinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbclientriskinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbclientriskinfo_op purge;
drop table ${iol_schema}.ifms_tbclientriskinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbclientriskinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbclientriskinfo where 0=1;

create table ${iol_schema}.ifms_tbclientriskinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbclientriskinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbclientriskinfo_cl(
            in_client_no -- 
            ,prd_type -- 
            ,high_risk_flag -- 
            ,risk_counter_flag -- 
            ,risk_level -- 
            ,risk_date -- 
            ,last_modify_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbclientriskinfo_op(
            in_client_no -- 
            ,prd_type -- 
            ,high_risk_flag -- 
            ,risk_counter_flag -- 
            ,risk_level -- 
            ,risk_date -- 
            ,last_modify_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 
    ,nvl(n.high_risk_flag, o.high_risk_flag) as high_risk_flag -- 
    ,nvl(n.risk_counter_flag, o.risk_counter_flag) as risk_counter_flag -- 
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 
    ,nvl(n.risk_date, o.risk_date) as risk_date -- 
    ,nvl(n.last_modify_date, o.last_modify_date) as last_modify_date -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,case when
            n.in_client_no is null
            and n.prd_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.in_client_no is null
            and n.prd_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.in_client_no is null
            and n.prd_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbclientriskinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbclientriskinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.in_client_no = n.in_client_no
            and o.prd_type = n.prd_type
where (
        o.in_client_no is null
        and o.prd_type is null
    )
    or (
        n.in_client_no is null
        and n.prd_type is null
    )
    or (
        o.high_risk_flag <> n.high_risk_flag
        or o.risk_counter_flag <> n.risk_counter_flag
        or o.risk_level <> n.risk_level
        or o.risk_date <> n.risk_date
        or o.last_modify_date <> n.last_modify_date
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
        into ${iol_schema}.ifms_tbclientriskinfo_cl(
            in_client_no -- 
            ,prd_type -- 
            ,high_risk_flag -- 
            ,risk_counter_flag -- 
            ,risk_level -- 
            ,risk_date -- 
            ,last_modify_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbclientriskinfo_op(
            in_client_no -- 
            ,prd_type -- 
            ,high_risk_flag -- 
            ,risk_counter_flag -- 
            ,risk_level -- 
            ,risk_date -- 
            ,last_modify_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.in_client_no -- 
    ,o.prd_type -- 
    ,o.high_risk_flag -- 
    ,o.risk_counter_flag -- 
    ,o.risk_level -- 
    ,o.risk_date -- 
    ,o.last_modify_date -- 
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
from ${iol_schema}.ifms_tbclientriskinfo_bk o
    left join ${iol_schema}.ifms_tbclientriskinfo_op n
        on
            o.in_client_no = n.in_client_no
            and o.prd_type = n.prd_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbclientriskinfo_cl d
        on
            o.in_client_no = d.in_client_no
            and o.prd_type = d.prd_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbclientriskinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbclientriskinfo exchange partition p_19000101 with table ${iol_schema}.ifms_tbclientriskinfo_cl;
alter table ${iol_schema}.ifms_tbclientriskinfo exchange partition p_20991231 with table ${iol_schema}.ifms_tbclientriskinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbclientriskinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbclientriskinfo_op purge;
drop table ${iol_schema}.ifms_tbclientriskinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbclientriskinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbclientriskinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
