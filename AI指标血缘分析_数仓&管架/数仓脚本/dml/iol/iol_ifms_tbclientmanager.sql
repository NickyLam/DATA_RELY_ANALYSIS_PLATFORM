/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbclientmanager
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
create table ${iol_schema}.ifms_tbclientmanager_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbclientmanager;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbclientmanager_op purge;
drop table ${iol_schema}.ifms_tbclientmanager_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbclientmanager_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbclientmanager where 0=1;

create table ${iol_schema}.ifms_tbclientmanager_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbclientmanager where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbclientmanager_cl(
            client_manager -- 
            ,manager_name -- 
            ,branch_no -- 
            ,up_manager -- 
            ,manager_level -- 
            ,prd_rights -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbclientmanager_op(
            client_manager -- 
            ,manager_name -- 
            ,branch_no -- 
            ,up_manager -- 
            ,manager_level -- 
            ,prd_rights -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_manager, o.client_manager) as client_manager -- 
    ,nvl(n.manager_name, o.manager_name) as manager_name -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.up_manager, o.up_manager) as up_manager -- 
    ,nvl(n.manager_level, o.manager_level) as manager_level -- 
    ,nvl(n.prd_rights, o.prd_rights) as prd_rights -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,case when
            n.client_manager is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.client_manager is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.client_manager is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbclientmanager_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbclientmanager where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.client_manager = n.client_manager
where (
        o.client_manager is null
    )
    or (
        n.client_manager is null
    )
    or (
        o.manager_name <> n.manager_name
        or o.branch_no <> n.branch_no
        or o.up_manager <> n.up_manager
        or o.manager_level <> n.manager_level
        or o.prd_rights <> n.prd_rights
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbclientmanager_cl(
            client_manager -- 
            ,manager_name -- 
            ,branch_no -- 
            ,up_manager -- 
            ,manager_level -- 
            ,prd_rights -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbclientmanager_op(
            client_manager -- 
            ,manager_name -- 
            ,branch_no -- 
            ,up_manager -- 
            ,manager_level -- 
            ,prd_rights -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_manager -- 
    ,o.manager_name -- 
    ,o.branch_no -- 
    ,o.up_manager -- 
    ,o.manager_level -- 
    ,o.prd_rights -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbclientmanager_bk o
    left join ${iol_schema}.ifms_tbclientmanager_op n
        on
            o.client_manager = n.client_manager
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbclientmanager_cl d
        on
            o.client_manager = d.client_manager
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbclientmanager;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbclientmanager exchange partition p_19000101 with table ${iol_schema}.ifms_tbclientmanager_cl;
alter table ${iol_schema}.ifms_tbclientmanager exchange partition p_20991231 with table ${iol_schema}.ifms_tbclientmanager_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbclientmanager to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbclientmanager_op purge;
drop table ${iol_schema}.ifms_tbclientmanager_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbclientmanager_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbclientmanager',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
