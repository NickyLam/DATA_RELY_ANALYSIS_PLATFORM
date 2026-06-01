/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbms_t_oa_corpapply
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
create table ${iol_schema}.tbms_t_oa_corpapply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbms_t_oa_corpapply;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbms_t_oa_corpapply_op purge;
drop table ${iol_schema}.tbms_t_oa_corpapply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_oa_corpapply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbms_t_oa_corpapply where 0=1;

create table ${iol_schema}.tbms_t_oa_corpapply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbms_t_oa_corpapply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbms_t_oa_corpapply_cl(
            flowid -- 
            ,flowname -- 
            ,cpytempletid -- 
            ,companyid -- 
            ,uaid -- 
            ,applyuaid -- 
            ,status -- 
            ,content -- 
            ,summary -- 
            ,sys_ctime -- 
            ,sys_utime -- 
            ,sys_valid -- 
            ,lockstatus -- 
            ,printcount -- 
            ,appletuaid -- 
            ,flowsourcetype -- 
            ,pid -- 
            ,clientinfo -- 存储客户信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbms_t_oa_corpapply_op(
            flowid -- 
            ,flowname -- 
            ,cpytempletid -- 
            ,companyid -- 
            ,uaid -- 
            ,applyuaid -- 
            ,status -- 
            ,content -- 
            ,summary -- 
            ,sys_ctime -- 
            ,sys_utime -- 
            ,sys_valid -- 
            ,lockstatus -- 
            ,printcount -- 
            ,appletuaid -- 
            ,flowsourcetype -- 
            ,pid -- 
            ,clientinfo -- 存储客户信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.flowid, o.flowid) as flowid -- 
    ,nvl(n.flowname, o.flowname) as flowname -- 
    ,nvl(n.cpytempletid, o.cpytempletid) as cpytempletid -- 
    ,nvl(n.companyid, o.companyid) as companyid -- 
    ,nvl(n.uaid, o.uaid) as uaid -- 
    ,nvl(n.applyuaid, o.applyuaid) as applyuaid -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.content, o.content) as content -- 
    ,nvl(n.summary, o.summary) as summary -- 
    ,nvl(n.sys_ctime, o.sys_ctime) as sys_ctime -- 
    ,nvl(n.sys_utime, o.sys_utime) as sys_utime -- 
    ,nvl(n.sys_valid, o.sys_valid) as sys_valid -- 
    ,nvl(n.lockstatus, o.lockstatus) as lockstatus -- 
    ,nvl(n.printcount, o.printcount) as printcount -- 
    ,nvl(n.appletuaid, o.appletuaid) as appletuaid -- 
    ,nvl(n.flowsourcetype, o.flowsourcetype) as flowsourcetype -- 
    ,nvl(n.pid, o.pid) as pid -- 
    ,nvl(n.clientinfo, o.clientinfo) as clientinfo -- 存储客户信息
    ,case when
            n.flowid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.flowid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.flowid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbms_t_oa_corpapply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbms_t_oa_corpapply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.flowid = n.flowid
where (
        o.flowid is null
    )
    or (
        n.flowid is null
    )
    or (
        o.flowname <> n.flowname
        or o.cpytempletid <> n.cpytempletid
        or o.companyid <> n.companyid
        or o.uaid <> n.uaid
        or o.applyuaid <> n.applyuaid
        or o.status <> n.status
        or o.content <> n.content
        or o.summary <> n.summary
        or o.sys_ctime <> n.sys_ctime
        or o.sys_utime <> n.sys_utime
        or o.sys_valid <> n.sys_valid
        or o.lockstatus <> n.lockstatus
        or o.printcount <> n.printcount
        or o.appletuaid <> n.appletuaid
        or o.flowsourcetype <> n.flowsourcetype
        or o.pid <> n.pid
        or o.clientinfo <> n.clientinfo
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbms_t_oa_corpapply_cl(
            flowid -- 
            ,flowname -- 
            ,cpytempletid -- 
            ,companyid -- 
            ,uaid -- 
            ,applyuaid -- 
            ,status -- 
            ,content -- 
            ,summary -- 
            ,sys_ctime -- 
            ,sys_utime -- 
            ,sys_valid -- 
            ,lockstatus -- 
            ,printcount -- 
            ,appletuaid -- 
            ,flowsourcetype -- 
            ,pid -- 
            ,clientinfo -- 存储客户信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbms_t_oa_corpapply_op(
            flowid -- 
            ,flowname -- 
            ,cpytempletid -- 
            ,companyid -- 
            ,uaid -- 
            ,applyuaid -- 
            ,status -- 
            ,content -- 
            ,summary -- 
            ,sys_ctime -- 
            ,sys_utime -- 
            ,sys_valid -- 
            ,lockstatus -- 
            ,printcount -- 
            ,appletuaid -- 
            ,flowsourcetype -- 
            ,pid -- 
            ,clientinfo -- 存储客户信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.flowid -- 
    ,o.flowname -- 
    ,o.cpytempletid -- 
    ,o.companyid -- 
    ,o.uaid -- 
    ,o.applyuaid -- 
    ,o.status -- 
    ,o.content -- 
    ,o.summary -- 
    ,o.sys_ctime -- 
    ,o.sys_utime -- 
    ,o.sys_valid -- 
    ,o.lockstatus -- 
    ,o.printcount -- 
    ,o.appletuaid -- 
    ,o.flowsourcetype -- 
    ,o.pid -- 
    ,o.clientinfo -- 存储客户信息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbms_t_oa_corpapply_bk o
    left join ${iol_schema}.tbms_t_oa_corpapply_op n
        on
            o.flowid = n.flowid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbms_t_oa_corpapply_cl d
        on
            o.flowid = d.flowid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbms_t_oa_corpapply;

-- 4.2 exchange partition
alter table ${iol_schema}.tbms_t_oa_corpapply exchange partition p_19000101 with table ${iol_schema}.tbms_t_oa_corpapply_cl;
alter table ${iol_schema}.tbms_t_oa_corpapply exchange partition p_20991231 with table ${iol_schema}.tbms_t_oa_corpapply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbms_t_oa_corpapply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbms_t_oa_corpapply_op purge;
drop table ${iol_schema}.tbms_t_oa_corpapply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbms_t_oa_corpapply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbms_t_oa_corpapply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
