/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_ucl
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
create table ${iol_schema}.isbs_ucl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_ucl;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ucl_op purge;
drop table ${iol_schema}.isbs_ucl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ucl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ucl where 0=1;

create table ${iol_schema}.isbs_ucl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ucl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ucl_cl(
            assignflg -- 
            ,objlst -- 
            ,usr -- 
            ,usrdef -- 
            ,mannam -- 
            ,branchinr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ucl_op(
            assignflg -- 
            ,objlst -- 
            ,usr -- 
            ,usrdef -- 
            ,mannam -- 
            ,branchinr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.assignflg, o.assignflg) as assignflg -- 
    ,nvl(n.objlst, o.objlst) as objlst -- 
    ,nvl(n.usr, o.usr) as usr -- 
    ,nvl(n.usrdef, o.usrdef) as usrdef -- 
    ,nvl(n.mannam, o.mannam) as mannam -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,case when
            n.usr is null
            and n.branchinr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.usr is null
            and n.branchinr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.usr is null
            and n.branchinr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_ucl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_ucl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.usr = n.usr
            and o.branchinr = n.branchinr
where (
        o.usr is null
        and o.branchinr is null
    )
    or (
        n.usr is null
        and n.branchinr is null
    )
    or (
        o.assignflg <> n.assignflg
        or o.objlst <> n.objlst
        or o.usrdef <> n.usrdef
        or o.mannam <> n.mannam
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ucl_cl(
            assignflg -- 
            ,objlst -- 
            ,usr -- 
            ,usrdef -- 
            ,mannam -- 
            ,branchinr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ucl_op(
            assignflg -- 
            ,objlst -- 
            ,usr -- 
            ,usrdef -- 
            ,mannam -- 
            ,branchinr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.assignflg -- 
    ,o.objlst -- 
    ,o.usr -- 
    ,o.usrdef -- 
    ,o.mannam -- 
    ,o.branchinr -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_ucl_bk o
    left join ${iol_schema}.isbs_ucl_op n
        on
            o.usr = n.usr
            and o.branchinr = n.branchinr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_ucl_cl d
        on
            o.usr = d.usr
            and o.branchinr = d.branchinr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_ucl;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_ucl exchange partition p_19000101 with table ${iol_schema}.isbs_ucl_cl;
alter table ${iol_schema}.isbs_ucl exchange partition p_20991231 with table ${iol_schema}.isbs_ucl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_ucl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ucl_op purge;
drop table ${iol_schema}.isbs_ucl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_ucl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_ucl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
