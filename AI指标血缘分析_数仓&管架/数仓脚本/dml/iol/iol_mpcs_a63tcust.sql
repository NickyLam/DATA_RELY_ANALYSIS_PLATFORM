/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a63tcust
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
create table ${iol_schema}.mpcs_a63tcust_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a63tcust;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a63tcust_op purge;
drop table ${iol_schema}.mpcs_a63tcust_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a63tcust_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a63tcust where 0=1;

create table ${iol_schema}.mpcs_a63tcust_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a63tcust where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a63tcust_cl(
            custno -- 
            ,custname -- 
            ,signno -- 
            ,signdt -- 
            ,custbrcno -- 
            ,openbrcno -- 
            ,idtype -- 
            ,idno -- 
            ,stat -- 状态:0-正常，1-注销，2-暂停
            ,trnts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a63tcust_op(
            custno -- 
            ,custname -- 
            ,signno -- 
            ,signdt -- 
            ,custbrcno -- 
            ,openbrcno -- 
            ,idtype -- 
            ,idno -- 
            ,stat -- 状态:0-正常，1-注销，2-暂停
            ,trnts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.custno, o.custno) as custno -- 
    ,nvl(n.custname, o.custname) as custname -- 
    ,nvl(n.signno, o.signno) as signno -- 
    ,nvl(n.signdt, o.signdt) as signdt -- 
    ,nvl(n.custbrcno, o.custbrcno) as custbrcno -- 
    ,nvl(n.openbrcno, o.openbrcno) as openbrcno -- 
    ,nvl(n.idtype, o.idtype) as idtype -- 
    ,nvl(n.idno, o.idno) as idno -- 
    ,nvl(n.stat, o.stat) as stat -- 状态:0-正常，1-注销，2-暂停
    ,nvl(n.trnts, o.trnts) as trnts -- 
    ,case when
            n.custno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.custno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.custno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a63tcust_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a63tcust where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.custno = n.custno
where (
        o.custno is null
    )
    or (
        n.custno is null
    )
    or (
        o.custname <> n.custname
        or o.signno <> n.signno
        or o.signdt <> n.signdt
        or o.custbrcno <> n.custbrcno
        or o.openbrcno <> n.openbrcno
        or o.idtype <> n.idtype
        or o.idno <> n.idno
        or o.stat <> n.stat
        or o.trnts <> n.trnts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a63tcust_cl(
            custno -- 
            ,custname -- 
            ,signno -- 
            ,signdt -- 
            ,custbrcno -- 
            ,openbrcno -- 
            ,idtype -- 
            ,idno -- 
            ,stat -- 状态:0-正常，1-注销，2-暂停
            ,trnts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a63tcust_op(
            custno -- 
            ,custname -- 
            ,signno -- 
            ,signdt -- 
            ,custbrcno -- 
            ,openbrcno -- 
            ,idtype -- 
            ,idno -- 
            ,stat -- 状态:0-正常，1-注销，2-暂停
            ,trnts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.custno -- 
    ,o.custname -- 
    ,o.signno -- 
    ,o.signdt -- 
    ,o.custbrcno -- 
    ,o.openbrcno -- 
    ,o.idtype -- 
    ,o.idno -- 
    ,o.stat -- 状态:0-正常，1-注销，2-暂停
    ,o.trnts -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a63tcust_bk o
    left join ${iol_schema}.mpcs_a63tcust_op n
        on
            o.custno = n.custno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a63tcust_cl d
        on
            o.custno = d.custno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a63tcust;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a63tcust exchange partition p_19000101 with table ${iol_schema}.mpcs_a63tcust_cl;
alter table ${iol_schema}.mpcs_a63tcust exchange partition p_20991231 with table ${iol_schema}.mpcs_a63tcust_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a63tcust to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a63tcust_op purge;
drop table ${iol_schema}.mpcs_a63tcust_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a63tcust_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a63tcust',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
