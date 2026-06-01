/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbprdmanager
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
create table ${iol_schema}.ifms_tbprdmanager_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbprdmanager;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbprdmanager_op purge;
drop table ${iol_schema}.ifms_tbprdmanager_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbprdmanager_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbprdmanager where 0=1;

create table ${iol_schema}.ifms_tbprdmanager_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbprdmanager where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbprdmanager_cl(
            prd_manager -- 
            ,manager_shortname -- 
            ,manager_name -- 
            ,position_code -- 
            ,position_name -- 
            ,reg_address -- 
            ,off_address -- 
            ,manager -- 
            ,link_name -- 
            ,link_method -- 
            ,hot_line -- 
            ,web -- 
            ,risk_level -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,company_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbprdmanager_op(
            prd_manager -- 
            ,manager_shortname -- 
            ,manager_name -- 
            ,position_code -- 
            ,position_name -- 
            ,reg_address -- 
            ,off_address -- 
            ,manager -- 
            ,link_name -- 
            ,link_method -- 
            ,hot_line -- 
            ,web -- 
            ,risk_level -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,company_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prd_manager, o.prd_manager) as prd_manager -- 
    ,nvl(n.manager_shortname, o.manager_shortname) as manager_shortname -- 
    ,nvl(n.manager_name, o.manager_name) as manager_name -- 
    ,nvl(n.position_code, o.position_code) as position_code -- 
    ,nvl(n.position_name, o.position_name) as position_name -- 
    ,nvl(n.reg_address, o.reg_address) as reg_address -- 
    ,nvl(n.off_address, o.off_address) as off_address -- 
    ,nvl(n.manager, o.manager) as manager -- 
    ,nvl(n.link_name, o.link_name) as link_name -- 
    ,nvl(n.link_method, o.link_method) as link_method -- 
    ,nvl(n.hot_line, o.hot_line) as hot_line -- 
    ,nvl(n.web, o.web) as web -- 
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.company_code, o.company_code) as company_code -- 
    ,case when
            n.prd_manager is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_manager is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_manager is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbprdmanager_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbprdmanager where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_manager = n.prd_manager
where (
        o.prd_manager is null
    )
    or (
        n.prd_manager is null
    )
    or (
        o.manager_shortname <> n.manager_shortname
        or o.manager_name <> n.manager_name
        or o.position_code <> n.position_code
        or o.position_name <> n.position_name
        or o.reg_address <> n.reg_address
        or o.off_address <> n.off_address
        or o.manager <> n.manager
        or o.link_name <> n.link_name
        or o.link_method <> n.link_method
        or o.hot_line <> n.hot_line
        or o.web <> n.web
        or o.risk_level <> n.risk_level
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.company_code <> n.company_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbprdmanager_cl(
            prd_manager -- 
            ,manager_shortname -- 
            ,manager_name -- 
            ,position_code -- 
            ,position_name -- 
            ,reg_address -- 
            ,off_address -- 
            ,manager -- 
            ,link_name -- 
            ,link_method -- 
            ,hot_line -- 
            ,web -- 
            ,risk_level -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,company_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbprdmanager_op(
            prd_manager -- 
            ,manager_shortname -- 
            ,manager_name -- 
            ,position_code -- 
            ,position_name -- 
            ,reg_address -- 
            ,off_address -- 
            ,manager -- 
            ,link_name -- 
            ,link_method -- 
            ,hot_line -- 
            ,web -- 
            ,risk_level -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,company_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prd_manager -- 
    ,o.manager_shortname -- 
    ,o.manager_name -- 
    ,o.position_code -- 
    ,o.position_name -- 
    ,o.reg_address -- 
    ,o.off_address -- 
    ,o.manager -- 
    ,o.link_name -- 
    ,o.link_method -- 
    ,o.hot_line -- 
    ,o.web -- 
    ,o.risk_level -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.company_code -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbprdmanager_bk o
    left join ${iol_schema}.ifms_tbprdmanager_op n
        on
            o.prd_manager = n.prd_manager
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbprdmanager_cl d
        on
            o.prd_manager = d.prd_manager
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbprdmanager;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbprdmanager exchange partition p_19000101 with table ${iol_schema}.ifms_tbprdmanager_cl;
alter table ${iol_schema}.ifms_tbprdmanager exchange partition p_20991231 with table ${iol_schema}.ifms_tbprdmanager_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbprdmanager to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbprdmanager_op purge;
drop table ${iol_schema}.ifms_tbprdmanager_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbprdmanager_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbprdmanager',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
