/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_khfa_khzb_jg
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
create table ${iol_schema}.pams_khfa_khzb_jg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_khfa_khzb_jg;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_khfa_khzb_jg_op purge;
drop table ${iol_schema}.pams_khfa_khzb_jg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_khfa_khzb_jg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_khfa_khzb_jg where 0=1;

create table ${iol_schema}.pams_khfa_khzb_jg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_khfa_khzb_jg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_khfa_khzb_jg_cl(
            khzbdh -- 考核指标代号
            ,khzbmc -- 考核指标名称
            ,zbdh -- 指标代号
            ,sdbs -- 时段标识
            ,bz -- 币种
            ,tjkj -- 统计口径
            ,zbpx -- 指标排序
            ,ydsfzs -- 移动是否展示
            ,ydbm -- 移动别名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_khfa_khzb_jg_op(
            khzbdh -- 考核指标代号
            ,khzbmc -- 考核指标名称
            ,zbdh -- 指标代号
            ,sdbs -- 时段标识
            ,bz -- 币种
            ,tjkj -- 统计口径
            ,zbpx -- 指标排序
            ,ydsfzs -- 移动是否展示
            ,ydbm -- 移动别名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.khzbdh, o.khzbdh) as khzbdh -- 考核指标代号
    ,nvl(n.khzbmc, o.khzbmc) as khzbmc -- 考核指标名称
    ,nvl(n.zbdh, o.zbdh) as zbdh -- 指标代号
    ,nvl(n.sdbs, o.sdbs) as sdbs -- 时段标识
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.tjkj, o.tjkj) as tjkj -- 统计口径
    ,nvl(n.zbpx, o.zbpx) as zbpx -- 指标排序
    ,nvl(n.ydsfzs, o.ydsfzs) as ydsfzs -- 移动是否展示
    ,nvl(n.ydbm, o.ydbm) as ydbm -- 移动别名
    ,case when
            n.khzbdh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.khzbdh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.khzbdh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_khfa_khzb_jg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_khfa_khzb_jg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.khzbdh = n.khzbdh
where (
        o.khzbdh is null
    )
    or (
        n.khzbdh is null
    )
    or (
        o.khzbmc <> n.khzbmc
        or o.zbdh <> n.zbdh
        or o.sdbs <> n.sdbs
        or o.bz <> n.bz
        or o.tjkj <> n.tjkj
        or o.zbpx <> n.zbpx
        or o.ydsfzs <> n.ydsfzs
        or o.ydbm <> n.ydbm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_khfa_khzb_jg_cl(
            khzbdh -- 考核指标代号
            ,khzbmc -- 考核指标名称
            ,zbdh -- 指标代号
            ,sdbs -- 时段标识
            ,bz -- 币种
            ,tjkj -- 统计口径
            ,zbpx -- 指标排序
            ,ydsfzs -- 移动是否展示
            ,ydbm -- 移动别名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_khfa_khzb_jg_op(
            khzbdh -- 考核指标代号
            ,khzbmc -- 考核指标名称
            ,zbdh -- 指标代号
            ,sdbs -- 时段标识
            ,bz -- 币种
            ,tjkj -- 统计口径
            ,zbpx -- 指标排序
            ,ydsfzs -- 移动是否展示
            ,ydbm -- 移动别名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.khzbdh -- 考核指标代号
    ,o.khzbmc -- 考核指标名称
    ,o.zbdh -- 指标代号
    ,o.sdbs -- 时段标识
    ,o.bz -- 币种
    ,o.tjkj -- 统计口径
    ,o.zbpx -- 指标排序
    ,o.ydsfzs -- 移动是否展示
    ,o.ydbm -- 移动别名
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_khfa_khzb_jg_bk o
    left join ${iol_schema}.pams_khfa_khzb_jg_op n
        on
            o.khzbdh = n.khzbdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_khfa_khzb_jg_cl d
        on
            o.khzbdh = d.khzbdh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.pams_khfa_khzb_jg;

-- 4.2 exchange partition
alter table ${iol_schema}.pams_khfa_khzb_jg exchange partition p_19000101 with table ${iol_schema}.pams_khfa_khzb_jg_cl;
alter table ${iol_schema}.pams_khfa_khzb_jg exchange partition p_20991231 with table ${iol_schema}.pams_khfa_khzb_jg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_khfa_khzb_jg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_khfa_khzb_jg_op purge;
drop table ${iol_schema}.pams_khfa_khzb_jg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_khfa_khzb_jg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_khfa_khzb_jg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
