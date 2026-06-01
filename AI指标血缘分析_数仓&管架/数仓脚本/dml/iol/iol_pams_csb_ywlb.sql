/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_csb_ywlb
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
create table ${iol_schema}.pams_csb_ywlb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_csb_ywlb;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_csb_ywlb_op purge;
drop table ${iol_schema}.pams_csb_ywlb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_ywlb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_csb_ywlb where 0=1;

create table ${iol_schema}.pams_csb_ywlb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_csb_ywlb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_csb_ywlb_cl(
            ywlb -- 业务类别
            ,ms -- 描述
            ,ddlb -- 调度类别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_csb_ywlb_op(
            ywlb -- 业务类别
            ,ms -- 描述
            ,ddlb -- 调度类别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ywlb, o.ywlb) as ywlb -- 业务类别
    ,nvl(n.ms, o.ms) as ms -- 描述
    ,nvl(n.ddlb, o.ddlb) as ddlb -- 调度类别
    ,case when
            n.ywlb is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ywlb is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ywlb is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_csb_ywlb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_csb_ywlb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ywlb = n.ywlb
where (
        o.ywlb is null
    )
    or (
        n.ywlb is null
    )
    or (
        o.ms <> n.ms
        or o.ddlb <> n.ddlb
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_csb_ywlb_cl(
            ywlb -- 业务类别
            ,ms -- 描述
            ,ddlb -- 调度类别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_csb_ywlb_op(
            ywlb -- 业务类别
            ,ms -- 描述
            ,ddlb -- 调度类别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ywlb -- 业务类别
    ,o.ms -- 描述
    ,o.ddlb -- 调度类别
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_csb_ywlb_bk o
    left join ${iol_schema}.pams_csb_ywlb_op n
        on
            o.ywlb = n.ywlb
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_csb_ywlb_cl d
        on
            o.ywlb = d.ywlb
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.pams_csb_ywlb;

-- 4.2 exchange partition
alter table ${iol_schema}.pams_csb_ywlb exchange partition p_19000101 with table ${iol_schema}.pams_csb_ywlb_cl;
alter table ${iol_schema}.pams_csb_ywlb exchange partition p_20991231 with table ${iol_schema}.pams_csb_ywlb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_csb_ywlb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_csb_ywlb_op purge;
drop table ${iol_schema}.pams_csb_ywlb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_csb_ywlb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_csb_ywlb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
