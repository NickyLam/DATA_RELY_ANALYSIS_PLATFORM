/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbinstinfo
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
create table ${iol_schema}.ifms_tbinstinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbinstinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinstinfo_op purge;
drop table ${iol_schema}.ifms_tbinstinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinstinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinstinfo where 0=1;

create table ${iol_schema}.ifms_tbinstinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinstinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinstinfo_cl(
            in_client_no -- 
            ,inst_type -- 
            ,repr_name -- 
            ,repr_id_type -- 
            ,repr_id_code -- 
            ,actor_name -- 
            ,actor_id_type -- 
            ,actor_id_code -- 
            ,link_name -- 
            ,link_id_type -- 
            ,link_id_code -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinstinfo_op(
            in_client_no -- 
            ,inst_type -- 
            ,repr_name -- 
            ,repr_id_type -- 
            ,repr_id_code -- 
            ,actor_name -- 
            ,actor_id_type -- 
            ,actor_id_code -- 
            ,link_name -- 
            ,link_id_type -- 
            ,link_id_code -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.inst_type, o.inst_type) as inst_type -- 
    ,nvl(n.repr_name, o.repr_name) as repr_name -- 
    ,nvl(n.repr_id_type, o.repr_id_type) as repr_id_type -- 
    ,nvl(n.repr_id_code, o.repr_id_code) as repr_id_code -- 
    ,nvl(n.actor_name, o.actor_name) as actor_name -- 
    ,nvl(n.actor_id_type, o.actor_id_type) as actor_id_type -- 
    ,nvl(n.actor_id_code, o.actor_id_code) as actor_id_code -- 
    ,nvl(n.link_name, o.link_name) as link_name -- 
    ,nvl(n.link_id_type, o.link_id_type) as link_id_type -- 
    ,nvl(n.link_id_code, o.link_id_code) as link_id_code -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,case when
            n.in_client_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.in_client_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.in_client_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbinstinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbinstinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.in_client_no = n.in_client_no
where (
        o.in_client_no is null
    )
    or (
        n.in_client_no is null
    )
    or (
        o.inst_type <> n.inst_type
        or o.repr_name <> n.repr_name
        or o.repr_id_type <> n.repr_id_type
        or o.repr_id_code <> n.repr_id_code
        or o.actor_name <> n.actor_name
        or o.actor_id_type <> n.actor_id_type
        or o.actor_id_code <> n.actor_id_code
        or o.link_name <> n.link_name
        or o.link_id_type <> n.link_id_type
        or o.link_id_code <> n.link_id_code
        or o.reserve1 <> n.reserve1
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinstinfo_cl(
            in_client_no -- 
            ,inst_type -- 
            ,repr_name -- 
            ,repr_id_type -- 
            ,repr_id_code -- 
            ,actor_name -- 
            ,actor_id_type -- 
            ,actor_id_code -- 
            ,link_name -- 
            ,link_id_type -- 
            ,link_id_code -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinstinfo_op(
            in_client_no -- 
            ,inst_type -- 
            ,repr_name -- 
            ,repr_id_type -- 
            ,repr_id_code -- 
            ,actor_name -- 
            ,actor_id_type -- 
            ,actor_id_code -- 
            ,link_name -- 
            ,link_id_type -- 
            ,link_id_code -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.in_client_no -- 
    ,o.inst_type -- 
    ,o.repr_name -- 
    ,o.repr_id_type -- 
    ,o.repr_id_code -- 
    ,o.actor_name -- 
    ,o.actor_id_type -- 
    ,o.actor_id_code -- 
    ,o.link_name -- 
    ,o.link_id_type -- 
    ,o.link_id_code -- 
    ,o.reserve1 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbinstinfo_bk o
    left join ${iol_schema}.ifms_tbinstinfo_op n
        on
            o.in_client_no = n.in_client_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbinstinfo_cl d
        on
            o.in_client_no = d.in_client_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbinstinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbinstinfo exchange partition p_19000101 with table ${iol_schema}.ifms_tbinstinfo_cl;
alter table ${iol_schema}.ifms_tbinstinfo exchange partition p_20991231 with table ${iol_schema}.ifms_tbinstinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbinstinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinstinfo_op purge;
drop table ${iol_schema}.ifms_tbinstinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbinstinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbinstinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
