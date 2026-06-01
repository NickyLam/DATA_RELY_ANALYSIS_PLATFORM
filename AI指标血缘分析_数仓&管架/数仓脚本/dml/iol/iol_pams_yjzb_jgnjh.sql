/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_yjzb_jgnjh
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
create table ${iol_schema}.pams_yjzb_jgnjh_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_yjzb_jgnjh;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_yjzb_jgnjh_op purge;
drop table ${iol_schema}.pams_yjzb_jgnjh_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_yjzb_jgnjh_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_yjzb_jgnjh where 0=1;

create table ${iol_schema}.pams_yjzb_jgnjh_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_yjzb_jgnjh where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_yjzb_jgnjh_cl(
            khnf -- 考核年份
            ,khzbdh -- 考核指标代号
            ,khdxdh -- 考核对象代号
            ,jhz -- 计划值
            ,lzz -- 力争值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_yjzb_jgnjh_op(
            khnf -- 考核年份
            ,khzbdh -- 考核指标代号
            ,khdxdh -- 考核对象代号
            ,jhz -- 计划值
            ,lzz -- 力争值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.khnf, o.khnf) as khnf -- 考核年份
    ,nvl(n.khzbdh, o.khzbdh) as khzbdh -- 考核指标代号
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.jhz, o.jhz) as jhz -- 计划值
    ,nvl(n.lzz, o.lzz) as lzz -- 力争值
    ,case when
            n.khnf is null
            and n.khzbdh is null
            and n.khdxdh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.khnf is null
            and n.khzbdh is null
            and n.khdxdh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.khnf is null
            and n.khzbdh is null
            and n.khdxdh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_yjzb_jgnjh_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_yjzb_jgnjh where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.khnf = n.khnf
            and o.khzbdh = n.khzbdh
            and o.khdxdh = n.khdxdh
where (
        o.khnf is null
        and o.khzbdh is null
        and o.khdxdh is null
    )
    or (
        n.khnf is null
        and n.khzbdh is null
        and n.khdxdh is null
    )
    or (
        o.jhz <> n.jhz
        or o.lzz <> n.lzz
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_yjzb_jgnjh_cl(
            khnf -- 考核年份
            ,khzbdh -- 考核指标代号
            ,khdxdh -- 考核对象代号
            ,jhz -- 计划值
            ,lzz -- 力争值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_yjzb_jgnjh_op(
            khnf -- 考核年份
            ,khzbdh -- 考核指标代号
            ,khdxdh -- 考核对象代号
            ,jhz -- 计划值
            ,lzz -- 力争值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.khnf -- 考核年份
    ,o.khzbdh -- 考核指标代号
    ,o.khdxdh -- 考核对象代号
    ,o.jhz -- 计划值
    ,o.lzz -- 力争值
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_yjzb_jgnjh_bk o
    left join ${iol_schema}.pams_yjzb_jgnjh_op n
        on
            o.khnf = n.khnf
            and o.khzbdh = n.khzbdh
            and o.khdxdh = n.khdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_yjzb_jgnjh_cl d
        on
            o.khnf = d.khnf
            and o.khzbdh = d.khzbdh
            and o.khdxdh = d.khdxdh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.pams_yjzb_jgnjh;

-- 4.2 exchange partition
alter table ${iol_schema}.pams_yjzb_jgnjh exchange partition p_19000101 with table ${iol_schema}.pams_yjzb_jgnjh_cl;
alter table ${iol_schema}.pams_yjzb_jgnjh exchange partition p_20991231 with table ${iol_schema}.pams_yjzb_jgnjh_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_yjzb_jgnjh to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_yjzb_jgnjh_op purge;
drop table ${iol_schema}.pams_yjzb_jgnjh_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_yjzb_jgnjh_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_yjzb_jgnjh',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
