/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uuss_uus_tellerno
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
create table ${iol_schema}.uuss_uus_tellerno_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.uuss_uus_tellerno;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uuss_uus_tellerno_op purge;
drop table ${iol_schema}.uuss_uus_tellerno_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uuss_uus_tellerno_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uuss_uus_tellerno where 0=1;

create table ${iol_schema}.uuss_uus_tellerno_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uuss_uus_tellerno where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uuss_uus_tellerno_cl(
            employeeid -- 员工编号
            ,tellermanagerid -- 柜员主管编号
            ,attachorgan -- 柜员所属机构
            ,tellerno -- 柜员号
            ,tellerlevel -- 柜员级别
            ,organcode -- 所在部门编号
            ,status -- 柜员状态：0-正常，1-注销
            ,userna -- 柜员名称
            ,ussatg -- 平账状态
            ,lastlg -- 最后登录日期
            ,lstrdt -- 最后交易日期
            ,usertp -- 柜员类型
            ,menugp -- 超级柜员标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uuss_uus_tellerno_op(
            employeeid -- 员工编号
            ,tellermanagerid -- 柜员主管编号
            ,attachorgan -- 柜员所属机构
            ,tellerno -- 柜员号
            ,tellerlevel -- 柜员级别
            ,organcode -- 所在部门编号
            ,status -- 柜员状态：0-正常，1-注销
            ,userna -- 柜员名称
            ,ussatg -- 平账状态
            ,lastlg -- 最后登录日期
            ,lstrdt -- 最后交易日期
            ,usertp -- 柜员类型
            ,menugp -- 超级柜员标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.employeeid, o.employeeid) as employeeid -- 员工编号
    ,nvl(n.tellermanagerid, o.tellermanagerid) as tellermanagerid -- 柜员主管编号
    ,nvl(n.attachorgan, o.attachorgan) as attachorgan -- 柜员所属机构
    ,nvl(n.tellerno, o.tellerno) as tellerno -- 柜员号
    ,nvl(n.tellerlevel, o.tellerlevel) as tellerlevel -- 柜员级别
    ,nvl(n.organcode, o.organcode) as organcode -- 所在部门编号
    ,nvl(n.status, o.status) as status -- 柜员状态：0-正常，1-注销
    ,nvl(n.userna, o.userna) as userna -- 柜员名称
    ,nvl(n.ussatg, o.ussatg) as ussatg -- 平账状态
    ,nvl(n.lastlg, o.lastlg) as lastlg -- 最后登录日期
    ,nvl(n.lstrdt, o.lstrdt) as lstrdt -- 最后交易日期
    ,nvl(n.usertp, o.usertp) as usertp -- 柜员类型
    ,nvl(n.menugp, o.menugp) as menugp -- 超级柜员标志
    ,case when
            n.tellerno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tellerno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tellerno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.uuss_uus_tellerno_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.uuss_uus_tellerno where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tellerno = n.tellerno
where (
        o.tellerno is null
    )
    or (
        n.tellerno is null
    )
    or (
        o.employeeid <> n.employeeid
        or o.tellermanagerid <> n.tellermanagerid
        or o.attachorgan <> n.attachorgan
        or o.tellerlevel <> n.tellerlevel
        or o.organcode <> n.organcode
        or o.status <> n.status
        or o.userna <> n.userna
        or o.ussatg <> n.ussatg
        or o.lastlg <> n.lastlg
        or o.lstrdt <> n.lstrdt
        or o.usertp <> n.usertp
        or o.menugp <> n.menugp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uuss_uus_tellerno_cl(
            employeeid -- 员工编号
            ,tellermanagerid -- 柜员主管编号
            ,attachorgan -- 柜员所属机构
            ,tellerno -- 柜员号
            ,tellerlevel -- 柜员级别
            ,organcode -- 所在部门编号
            ,status -- 柜员状态：0-正常，1-注销
            ,userna -- 柜员名称
            ,ussatg -- 平账状态
            ,lastlg -- 最后登录日期
            ,lstrdt -- 最后交易日期
            ,usertp -- 柜员类型
            ,menugp -- 超级柜员标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uuss_uus_tellerno_op(
            employeeid -- 员工编号
            ,tellermanagerid -- 柜员主管编号
            ,attachorgan -- 柜员所属机构
            ,tellerno -- 柜员号
            ,tellerlevel -- 柜员级别
            ,organcode -- 所在部门编号
            ,status -- 柜员状态：0-正常，1-注销
            ,userna -- 柜员名称
            ,ussatg -- 平账状态
            ,lastlg -- 最后登录日期
            ,lstrdt -- 最后交易日期
            ,usertp -- 柜员类型
            ,menugp -- 超级柜员标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.employeeid -- 员工编号
    ,o.tellermanagerid -- 柜员主管编号
    ,o.attachorgan -- 柜员所属机构
    ,o.tellerno -- 柜员号
    ,o.tellerlevel -- 柜员级别
    ,o.organcode -- 所在部门编号
    ,o.status -- 柜员状态：0-正常，1-注销
    ,o.userna -- 柜员名称
    ,o.ussatg -- 平账状态
    ,o.lastlg -- 最后登录日期
    ,o.lstrdt -- 最后交易日期
    ,o.usertp -- 柜员类型
    ,o.menugp -- 超级柜员标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.uuss_uus_tellerno_bk o
    left join ${iol_schema}.uuss_uus_tellerno_op n
        on
            o.tellerno = n.tellerno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.uuss_uus_tellerno_cl d
        on
            o.tellerno = d.tellerno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.uuss_uus_tellerno;

-- 4.2 exchange partition
alter table ${iol_schema}.uuss_uus_tellerno exchange partition p_19000101 with table ${iol_schema}.uuss_uus_tellerno_cl;
alter table ${iol_schema}.uuss_uus_tellerno exchange partition p_20991231 with table ${iol_schema}.uuss_uus_tellerno_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uuss_uus_tellerno to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uuss_uus_tellerno_op purge;
drop table ${iol_schema}.uuss_uus_tellerno_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.uuss_uus_tellerno_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uuss_uus_tellerno',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
