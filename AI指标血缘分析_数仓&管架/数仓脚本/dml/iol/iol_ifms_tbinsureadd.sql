/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbinsureadd
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
create table ${iol_schema}.ifms_tbinsureadd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbinsureadd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsureadd_op purge;
drop table ${iol_schema}.ifms_tbinsureadd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsureadd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsureadd where 0=1;

create table ${iol_schema}.ifms_tbinsureadd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsureadd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsureadd_cl(
            prd_add_code -- 
            ,prd_add_name -- 
            ,ta_code -- 
            ,prd_code -- 
            ,add_code -- 
            ,fee_unit -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsureadd_op(
            prd_add_code -- 
            ,prd_add_name -- 
            ,ta_code -- 
            ,prd_code -- 
            ,add_code -- 
            ,fee_unit -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prd_add_code, o.prd_add_code) as prd_add_code -- 
    ,nvl(n.prd_add_name, o.prd_add_name) as prd_add_name -- 
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.add_code, o.add_code) as add_code -- 
    ,nvl(n.fee_unit, o.fee_unit) as fee_unit -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,case when
            n.prd_add_code is null
            and n.ta_code is null
            and n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_add_code is null
            and n.ta_code is null
            and n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_add_code is null
            and n.ta_code is null
            and n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbinsureadd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbinsureadd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_add_code = n.prd_add_code
            and o.ta_code = n.ta_code
            and o.prd_code = n.prd_code
where (
        o.prd_add_code is null
        and o.ta_code is null
        and o.prd_code is null
    )
    or (
        n.prd_add_code is null
        and n.ta_code is null
        and n.prd_code is null
    )
    or (
        o.prd_add_name <> n.prd_add_name
        or o.add_code <> n.add_code
        or o.fee_unit <> n.fee_unit
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsureadd_cl(
            prd_add_code -- 
            ,prd_add_name -- 
            ,ta_code -- 
            ,prd_code -- 
            ,add_code -- 
            ,fee_unit -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsureadd_op(
            prd_add_code -- 
            ,prd_add_name -- 
            ,ta_code -- 
            ,prd_code -- 
            ,add_code -- 
            ,fee_unit -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prd_add_code -- 
    ,o.prd_add_name -- 
    ,o.ta_code -- 
    ,o.prd_code -- 
    ,o.add_code -- 
    ,o.fee_unit -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbinsureadd_bk o
    left join ${iol_schema}.ifms_tbinsureadd_op n
        on
            o.prd_add_code = n.prd_add_code
            and o.ta_code = n.ta_code
            and o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbinsureadd_cl d
        on
            o.prd_add_code = d.prd_add_code
            and o.ta_code = d.ta_code
            and o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbinsureadd;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbinsureadd exchange partition p_19000101 with table ${iol_schema}.ifms_tbinsureadd_cl;
alter table ${iol_schema}.ifms_tbinsureadd exchange partition p_20991231 with table ${iol_schema}.ifms_tbinsureadd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbinsureadd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsureadd_op purge;
drop table ${iol_schema}.ifms_tbinsureadd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbinsureadd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbinsureadd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
