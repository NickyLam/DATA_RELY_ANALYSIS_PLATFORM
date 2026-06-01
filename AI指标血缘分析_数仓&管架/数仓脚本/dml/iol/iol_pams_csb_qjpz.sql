/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_csb_qjpz
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
create table ${iol_schema}.pams_csb_qjpz_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_csb_qjpz;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_csb_qjpz_op purge;
drop table ${iol_schema}.pams_csb_qjpz_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_qjpz_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_csb_qjpz where 0=1;

create table ${iol_schema}.pams_csb_qjpz_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_csb_qjpz where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_csb_qjpz_cl(
            qjmc -- 区间名称
            ,qjsx -- 区间上限
            ,qsrq -- 起始日期
            ,jsrq -- 结束日期
            ,qjxx -- 区间下限
            ,qjz -- 区间值
            ,sxxms -- 上下限描述
            ,qjms -- 区间描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_csb_qjpz_op(
            qjmc -- 区间名称
            ,qjsx -- 区间上限
            ,qsrq -- 起始日期
            ,jsrq -- 结束日期
            ,qjxx -- 区间下限
            ,qjz -- 区间值
            ,sxxms -- 上下限描述
            ,qjms -- 区间描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.qjmc, o.qjmc) as qjmc -- 区间名称
    ,nvl(n.qjsx, o.qjsx) as qjsx -- 区间上限
    ,nvl(n.qsrq, o.qsrq) as qsrq -- 起始日期
    ,nvl(n.jsrq, o.jsrq) as jsrq -- 结束日期
    ,nvl(n.qjxx, o.qjxx) as qjxx -- 区间下限
    ,nvl(n.qjz, o.qjz) as qjz -- 区间值
    ,nvl(n.sxxms, o.sxxms) as sxxms -- 上下限描述
    ,nvl(n.qjms, o.qjms) as qjms -- 区间描述
    ,case when
            n.qjmc is null
            and n.qjsx is null
            and n.qsrq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.qjmc is null
            and n.qjsx is null
            and n.qsrq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.qjmc is null
            and n.qjsx is null
            and n.qsrq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_csb_qjpz_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_csb_qjpz where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.qjmc = n.qjmc
            and o.qjsx = n.qjsx
            and o.qsrq = n.qsrq
where (
        o.qjmc is null
        and o.qjsx is null
        and o.qsrq is null
    )
    or (
        n.qjmc is null
        and n.qjsx is null
        and n.qsrq is null
    )
    or (
        o.jsrq <> n.jsrq
        or o.qjxx <> n.qjxx
        or o.qjz <> n.qjz
        or o.sxxms <> n.sxxms
        or o.qjms <> n.qjms
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_csb_qjpz_cl(
            qjmc -- 区间名称
            ,qjsx -- 区间上限
            ,qsrq -- 起始日期
            ,jsrq -- 结束日期
            ,qjxx -- 区间下限
            ,qjz -- 区间值
            ,sxxms -- 上下限描述
            ,qjms -- 区间描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_csb_qjpz_op(
            qjmc -- 区间名称
            ,qjsx -- 区间上限
            ,qsrq -- 起始日期
            ,jsrq -- 结束日期
            ,qjxx -- 区间下限
            ,qjz -- 区间值
            ,sxxms -- 上下限描述
            ,qjms -- 区间描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.qjmc -- 区间名称
    ,o.qjsx -- 区间上限
    ,o.qsrq -- 起始日期
    ,o.jsrq -- 结束日期
    ,o.qjxx -- 区间下限
    ,o.qjz -- 区间值
    ,o.sxxms -- 上下限描述
    ,o.qjms -- 区间描述
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_csb_qjpz_bk o
    left join ${iol_schema}.pams_csb_qjpz_op n
        on
            o.qjmc = n.qjmc
            and o.qjsx = n.qjsx
            and o.qsrq = n.qsrq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_csb_qjpz_cl d
        on
            o.qjmc = d.qjmc
            and o.qjsx = d.qjsx
            and o.qsrq = d.qsrq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.pams_csb_qjpz;

-- 4.2 exchange partition
alter table ${iol_schema}.pams_csb_qjpz exchange partition p_19000101 with table ${iol_schema}.pams_csb_qjpz_cl;
alter table ${iol_schema}.pams_csb_qjpz exchange partition p_20991231 with table ${iol_schema}.pams_csb_qjpz_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_csb_qjpz to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_csb_qjpz_op purge;
drop table ${iol_schema}.pams_csb_qjpz_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_csb_qjpz_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_csb_qjpz',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
