/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uuss_uus_userroleinfo
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
create table ${iol_schema}.uuss_uus_userroleinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.uuss_uus_userroleinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uuss_uus_userroleinfo_op purge;
drop table ${iol_schema}.uuss_uus_userroleinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uuss_uus_userroleinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uuss_uus_userroleinfo where 0=1;

create table ${iol_schema}.uuss_uus_userroleinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uuss_uus_userroleinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uuss_uus_userroleinfo_cl(
            domainid -- 域账号
            ,sysid -- 系统标识
            ,unitno -- 商户
            ,subunitno -- 子商户
            ,rolecode -- 角色代码
            ,rolename -- 角色名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uuss_uus_userroleinfo_op(
            domainid -- 域账号
            ,sysid -- 系统标识
            ,unitno -- 商户
            ,subunitno -- 子商户
            ,rolecode -- 角色代码
            ,rolename -- 角色名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.domainid, o.domainid) as domainid -- 域账号
    ,nvl(n.sysid, o.sysid) as sysid -- 系统标识
    ,nvl(n.unitno, o.unitno) as unitno -- 商户
    ,nvl(n.subunitno, o.subunitno) as subunitno -- 子商户
    ,nvl(n.rolecode, o.rolecode) as rolecode -- 角色代码
    ,nvl(n.rolename, o.rolename) as rolename -- 角色名称
    ,case when
            n.domainid is null
            and n.sysid is null
            and n.unitno is null
            and n.subunitno is null
            and n.rolecode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.domainid is null
            and n.sysid is null
            and n.unitno is null
            and n.subunitno is null
            and n.rolecode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.domainid is null
            and n.sysid is null
            and n.unitno is null
            and n.subunitno is null
            and n.rolecode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.uuss_uus_userroleinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.uuss_uus_userroleinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.domainid = n.domainid
            and o.sysid = n.sysid
            and o.unitno = n.unitno
            and o.subunitno = n.subunitno
            and o.rolecode = n.rolecode
where (
        o.domainid is null
        and o.sysid is null
        and o.unitno is null
        and o.subunitno is null
        and o.rolecode is null
    )
    or (
        n.domainid is null
        and n.sysid is null
        and n.unitno is null
        and n.subunitno is null
        and n.rolecode is null
    )
    or (
        o.rolename <> n.rolename
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uuss_uus_userroleinfo_cl(
            domainid -- 域账号
            ,sysid -- 系统标识
            ,unitno -- 商户
            ,subunitno -- 子商户
            ,rolecode -- 角色代码
            ,rolename -- 角色名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uuss_uus_userroleinfo_op(
            domainid -- 域账号
            ,sysid -- 系统标识
            ,unitno -- 商户
            ,subunitno -- 子商户
            ,rolecode -- 角色代码
            ,rolename -- 角色名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.domainid -- 域账号
    ,o.sysid -- 系统标识
    ,o.unitno -- 商户
    ,o.subunitno -- 子商户
    ,o.rolecode -- 角色代码
    ,o.rolename -- 角色名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.uuss_uus_userroleinfo_bk o
    left join ${iol_schema}.uuss_uus_userroleinfo_op n
        on
            o.domainid = n.domainid
            and o.sysid = n.sysid
            and o.unitno = n.unitno
            and o.subunitno = n.subunitno
            and o.rolecode = n.rolecode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.uuss_uus_userroleinfo_cl d
        on
            o.domainid = d.domainid
            and o.sysid = d.sysid
            and o.unitno = d.unitno
            and o.subunitno = d.subunitno
            and o.rolecode = d.rolecode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.uuss_uus_userroleinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.uuss_uus_userroleinfo exchange partition p_19000101 with table ${iol_schema}.uuss_uus_userroleinfo_cl;
alter table ${iol_schema}.uuss_uus_userroleinfo exchange partition p_20991231 with table ${iol_schema}.uuss_uus_userroleinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uuss_uus_userroleinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uuss_uus_userroleinfo_op purge;
drop table ${iol_schema}.uuss_uus_userroleinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.uuss_uus_userroleinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uuss_uus_userroleinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
