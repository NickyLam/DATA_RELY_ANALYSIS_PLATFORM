/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_it_credguarcorres
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
create table ${iol_schema}.mims_it_credguarcorres_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_it_credguarcorres;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_it_credguarcorres_op purge;
drop table ${iol_schema}.mims_it_credguarcorres_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_it_credguarcorres_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_it_credguarcorres where 0=1;

create table ${iol_schema}.mims_it_credguarcorres_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_it_credguarcorres where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_it_credguarcorres_cl(
            credno -- 
            ,guarno -- 
            ,guartype -- 
            ,guarrate -- 
            ,guarorder -- 
            ,guarperiod -- 
            ,datasourceflag -- 
            ,barsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_it_credguarcorres_op(
            credno -- 
            ,guarno -- 
            ,guartype -- 
            ,guarrate -- 
            ,guarorder -- 
            ,guarperiod -- 
            ,datasourceflag -- 
            ,barsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.credno, o.credno) as credno -- 
    ,nvl(n.guarno, o.guarno) as guarno -- 
    ,nvl(n.guartype, o.guartype) as guartype -- 
    ,nvl(n.guarrate, o.guarrate) as guarrate -- 
    ,nvl(n.guarorder, o.guarorder) as guarorder -- 
    ,nvl(n.guarperiod, o.guarperiod) as guarperiod -- 
    ,nvl(n.datasourceflag, o.datasourceflag) as datasourceflag -- 
    ,nvl(n.barsign, o.barsign) as barsign -- 
    ,case when
            n.credno is null
            and n.guarno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.credno is null
            and n.guarno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.credno is null
            and n.guarno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_it_credguarcorres_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_it_credguarcorres where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.credno = n.credno
            and o.guarno = n.guarno
where (
        o.credno is null
        and o.guarno is null
    )
    or (
        n.credno is null
        and n.guarno is null
    )
    or (
        o.guartype <> n.guartype
        or o.guarrate <> n.guarrate
        or o.guarorder <> n.guarorder
        or o.guarperiod <> n.guarperiod
        or o.datasourceflag <> n.datasourceflag
        or o.barsign <> n.barsign
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_it_credguarcorres_cl(
            credno -- 
            ,guarno -- 
            ,guartype -- 
            ,guarrate -- 
            ,guarorder -- 
            ,guarperiod -- 
            ,datasourceflag -- 
            ,barsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_it_credguarcorres_op(
            credno -- 
            ,guarno -- 
            ,guartype -- 
            ,guarrate -- 
            ,guarorder -- 
            ,guarperiod -- 
            ,datasourceflag -- 
            ,barsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.credno -- 
    ,o.guarno -- 
    ,o.guartype -- 
    ,o.guarrate -- 
    ,o.guarorder -- 
    ,o.guarperiod -- 
    ,o.datasourceflag -- 
    ,o.barsign -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_it_credguarcorres_bk o
    left join ${iol_schema}.mims_it_credguarcorres_op n
        on
            o.credno = n.credno
            and o.guarno = n.guarno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_it_credguarcorres_cl d
        on
            o.credno = d.credno
            and o.guarno = d.guarno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_it_credguarcorres;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_it_credguarcorres exchange partition p_19000101 with table ${iol_schema}.mims_it_credguarcorres_cl;
alter table ${iol_schema}.mims_it_credguarcorres exchange partition p_20991231 with table ${iol_schema}.mims_it_credguarcorres_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_it_credguarcorres to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_it_credguarcorres_op purge;
drop table ${iol_schema}.mims_it_credguarcorres_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_it_credguarcorres_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_it_credguarcorres',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
