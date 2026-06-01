/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_yjzb_jgyjh
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
create table ${iol_schema}.pams_yjzb_jgyjh_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_yjzb_jgyjh;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_yjzb_jgyjh_op purge;
drop table ${iol_schema}.pams_yjzb_jgyjh_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_yjzb_jgyjh_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_yjzb_jgyjh where 0=1;

create table ${iol_schema}.pams_yjzb_jgyjh_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_yjzb_jgyjh where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_yjzb_jgyjh_cl(
            khnf -- 考核年份
            ,khzbdh -- 考核指标代号
            ,khdxdh -- 考核对象代号
            ,jhz1 -- 计划值1
            ,lzz1 -- 力争值1
            ,jhz2 -- 计划值2
            ,lzz2 -- 力争值2
            ,jhz3 -- 计划值3
            ,lzz3 -- 力争值3
            ,jhz4 -- 计划值4
            ,lzz4 -- 力争值4
            ,jhz5 -- 计划值5
            ,lzz5 -- 力争值5
            ,jhz6 -- 计划值6
            ,lzz6 -- 力争值6
            ,jhz7 -- 计划值7
            ,lzz7 -- 力争值7
            ,jhz8 -- 计划值8
            ,lzz8 -- 力争值8
            ,jhz9 -- 计划值9
            ,lzz9 -- 力争值9
            ,jhz10 -- 计划值10
            ,lzz10 -- 力争值10
            ,jhz11 -- 计划值11
            ,lzz11 -- 力争值11
            ,jhz12 -- 计划值12
            ,lzz12 -- 力争值12
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_yjzb_jgyjh_op(
            khnf -- 考核年份
            ,khzbdh -- 考核指标代号
            ,khdxdh -- 考核对象代号
            ,jhz1 -- 计划值1
            ,lzz1 -- 力争值1
            ,jhz2 -- 计划值2
            ,lzz2 -- 力争值2
            ,jhz3 -- 计划值3
            ,lzz3 -- 力争值3
            ,jhz4 -- 计划值4
            ,lzz4 -- 力争值4
            ,jhz5 -- 计划值5
            ,lzz5 -- 力争值5
            ,jhz6 -- 计划值6
            ,lzz6 -- 力争值6
            ,jhz7 -- 计划值7
            ,lzz7 -- 力争值7
            ,jhz8 -- 计划值8
            ,lzz8 -- 力争值8
            ,jhz9 -- 计划值9
            ,lzz9 -- 力争值9
            ,jhz10 -- 计划值10
            ,lzz10 -- 力争值10
            ,jhz11 -- 计划值11
            ,lzz11 -- 力争值11
            ,jhz12 -- 计划值12
            ,lzz12 -- 力争值12
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.khnf, o.khnf) as khnf -- 考核年份
    ,nvl(n.khzbdh, o.khzbdh) as khzbdh -- 考核指标代号
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.jhz1, o.jhz1) as jhz1 -- 计划值1
    ,nvl(n.lzz1, o.lzz1) as lzz1 -- 力争值1
    ,nvl(n.jhz2, o.jhz2) as jhz2 -- 计划值2
    ,nvl(n.lzz2, o.lzz2) as lzz2 -- 力争值2
    ,nvl(n.jhz3, o.jhz3) as jhz3 -- 计划值3
    ,nvl(n.lzz3, o.lzz3) as lzz3 -- 力争值3
    ,nvl(n.jhz4, o.jhz4) as jhz4 -- 计划值4
    ,nvl(n.lzz4, o.lzz4) as lzz4 -- 力争值4
    ,nvl(n.jhz5, o.jhz5) as jhz5 -- 计划值5
    ,nvl(n.lzz5, o.lzz5) as lzz5 -- 力争值5
    ,nvl(n.jhz6, o.jhz6) as jhz6 -- 计划值6
    ,nvl(n.lzz6, o.lzz6) as lzz6 -- 力争值6
    ,nvl(n.jhz7, o.jhz7) as jhz7 -- 计划值7
    ,nvl(n.lzz7, o.lzz7) as lzz7 -- 力争值7
    ,nvl(n.jhz8, o.jhz8) as jhz8 -- 计划值8
    ,nvl(n.lzz8, o.lzz8) as lzz8 -- 力争值8
    ,nvl(n.jhz9, o.jhz9) as jhz9 -- 计划值9
    ,nvl(n.lzz9, o.lzz9) as lzz9 -- 力争值9
    ,nvl(n.jhz10, o.jhz10) as jhz10 -- 计划值10
    ,nvl(n.lzz10, o.lzz10) as lzz10 -- 力争值10
    ,nvl(n.jhz11, o.jhz11) as jhz11 -- 计划值11
    ,nvl(n.lzz11, o.lzz11) as lzz11 -- 力争值11
    ,nvl(n.jhz12, o.jhz12) as jhz12 -- 计划值12
    ,nvl(n.lzz12, o.lzz12) as lzz12 -- 力争值12
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
from (select * from ${iol_schema}.pams_yjzb_jgyjh_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_yjzb_jgyjh where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        o.jhz1 <> n.jhz1
        or o.lzz1 <> n.lzz1
        or o.jhz2 <> n.jhz2
        or o.lzz2 <> n.lzz2
        or o.jhz3 <> n.jhz3
        or o.lzz3 <> n.lzz3
        or o.jhz4 <> n.jhz4
        or o.lzz4 <> n.lzz4
        or o.jhz5 <> n.jhz5
        or o.lzz5 <> n.lzz5
        or o.jhz6 <> n.jhz6
        or o.lzz6 <> n.lzz6
        or o.jhz7 <> n.jhz7
        or o.lzz7 <> n.lzz7
        or o.jhz8 <> n.jhz8
        or o.lzz8 <> n.lzz8
        or o.jhz9 <> n.jhz9
        or o.lzz9 <> n.lzz9
        or o.jhz10 <> n.jhz10
        or o.lzz10 <> n.lzz10
        or o.jhz11 <> n.jhz11
        or o.lzz11 <> n.lzz11
        or o.jhz12 <> n.jhz12
        or o.lzz12 <> n.lzz12
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_yjzb_jgyjh_cl(
            khnf -- 考核年份
            ,khzbdh -- 考核指标代号
            ,khdxdh -- 考核对象代号
            ,jhz1 -- 计划值1
            ,lzz1 -- 力争值1
            ,jhz2 -- 计划值2
            ,lzz2 -- 力争值2
            ,jhz3 -- 计划值3
            ,lzz3 -- 力争值3
            ,jhz4 -- 计划值4
            ,lzz4 -- 力争值4
            ,jhz5 -- 计划值5
            ,lzz5 -- 力争值5
            ,jhz6 -- 计划值6
            ,lzz6 -- 力争值6
            ,jhz7 -- 计划值7
            ,lzz7 -- 力争值7
            ,jhz8 -- 计划值8
            ,lzz8 -- 力争值8
            ,jhz9 -- 计划值9
            ,lzz9 -- 力争值9
            ,jhz10 -- 计划值10
            ,lzz10 -- 力争值10
            ,jhz11 -- 计划值11
            ,lzz11 -- 力争值11
            ,jhz12 -- 计划值12
            ,lzz12 -- 力争值12
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_yjzb_jgyjh_op(
            khnf -- 考核年份
            ,khzbdh -- 考核指标代号
            ,khdxdh -- 考核对象代号
            ,jhz1 -- 计划值1
            ,lzz1 -- 力争值1
            ,jhz2 -- 计划值2
            ,lzz2 -- 力争值2
            ,jhz3 -- 计划值3
            ,lzz3 -- 力争值3
            ,jhz4 -- 计划值4
            ,lzz4 -- 力争值4
            ,jhz5 -- 计划值5
            ,lzz5 -- 力争值5
            ,jhz6 -- 计划值6
            ,lzz6 -- 力争值6
            ,jhz7 -- 计划值7
            ,lzz7 -- 力争值7
            ,jhz8 -- 计划值8
            ,lzz8 -- 力争值8
            ,jhz9 -- 计划值9
            ,lzz9 -- 力争值9
            ,jhz10 -- 计划值10
            ,lzz10 -- 力争值10
            ,jhz11 -- 计划值11
            ,lzz11 -- 力争值11
            ,jhz12 -- 计划值12
            ,lzz12 -- 力争值12
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.khnf -- 考核年份
    ,o.khzbdh -- 考核指标代号
    ,o.khdxdh -- 考核对象代号
    ,o.jhz1 -- 计划值1
    ,o.lzz1 -- 力争值1
    ,o.jhz2 -- 计划值2
    ,o.lzz2 -- 力争值2
    ,o.jhz3 -- 计划值3
    ,o.lzz3 -- 力争值3
    ,o.jhz4 -- 计划值4
    ,o.lzz4 -- 力争值4
    ,o.jhz5 -- 计划值5
    ,o.lzz5 -- 力争值5
    ,o.jhz6 -- 计划值6
    ,o.lzz6 -- 力争值6
    ,o.jhz7 -- 计划值7
    ,o.lzz7 -- 力争值7
    ,o.jhz8 -- 计划值8
    ,o.lzz8 -- 力争值8
    ,o.jhz9 -- 计划值9
    ,o.lzz9 -- 力争值9
    ,o.jhz10 -- 计划值10
    ,o.lzz10 -- 力争值10
    ,o.jhz11 -- 计划值11
    ,o.lzz11 -- 力争值11
    ,o.jhz12 -- 计划值12
    ,o.lzz12 -- 力争值12
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_yjzb_jgyjh_bk o
    left join ${iol_schema}.pams_yjzb_jgyjh_op n
        on
            o.khnf = n.khnf
            and o.khzbdh = n.khzbdh
            and o.khdxdh = n.khdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_yjzb_jgyjh_cl d
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
-- truncate table ${iol_schema}.pams_yjzb_jgyjh;

-- 4.2 exchange partition
alter table ${iol_schema}.pams_yjzb_jgyjh exchange partition p_19000101 with table ${iol_schema}.pams_yjzb_jgyjh_cl;
alter table ${iol_schema}.pams_yjzb_jgyjh exchange partition p_20991231 with table ${iol_schema}.pams_yjzb_jgyjh_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_yjzb_jgyjh to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_yjzb_jgyjh_op purge;
drop table ${iol_schema}.pams_yjzb_jgyjh_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_yjzb_jgyjh_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_yjzb_jgyjh',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
