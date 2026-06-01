/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a49teftrantypeinfo
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
create table ${iol_schema}.mpcs_a49teftrantypeinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a49teftrantypeinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a49teftrantypeinfo_op purge;
drop table ${iol_schema}.mpcs_a49teftrantypeinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49teftrantypeinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a49teftrantypeinfo where 0=1;

create table ${iol_schema}.mpcs_a49teftrantypeinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a49teftrantypeinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a49teftrantypeinfo_cl(
            trantype -- 种类代码
            ,trantypenm -- 种类说明
            ,reserver -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a49teftrantypeinfo_op(
            trantype -- 种类代码
            ,trantypenm -- 种类说明
            ,reserver -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trantype, o.trantype) as trantype -- 种类代码
    ,nvl(n.trantypenm, o.trantypenm) as trantypenm -- 种类说明
    ,nvl(n.reserver, o.reserver) as reserver -- 
    ,case when
            n.trantype is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trantype is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trantype is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a49teftrantypeinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a49teftrantypeinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trantype = n.trantype
where (
        o.trantype is null
    )
    or (
        n.trantype is null
    )
    or (
        o.trantypenm <> n.trantypenm
        or o.reserver <> n.reserver
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a49teftrantypeinfo_cl(
            trantype -- 种类代码
            ,trantypenm -- 种类说明
            ,reserver -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a49teftrantypeinfo_op(
            trantype -- 种类代码
            ,trantypenm -- 种类说明
            ,reserver -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trantype -- 种类代码
    ,o.trantypenm -- 种类说明
    ,o.reserver -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a49teftrantypeinfo_bk o
    left join ${iol_schema}.mpcs_a49teftrantypeinfo_op n
        on
            o.trantype = n.trantype
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a49teftrantypeinfo_cl d
        on
            o.trantype = d.trantype
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a49teftrantypeinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a49teftrantypeinfo exchange partition p_19000101 with table ${iol_schema}.mpcs_a49teftrantypeinfo_cl;
alter table ${iol_schema}.mpcs_a49teftrantypeinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a49teftrantypeinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a49teftrantypeinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a49teftrantypeinfo_op purge;
drop table ${iol_schema}.mpcs_a49teftrantypeinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a49teftrantypeinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a49teftrantypeinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
