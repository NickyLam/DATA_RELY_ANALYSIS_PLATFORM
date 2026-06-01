/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_khdx_jg
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
create table ${iol_schema}.pams_khdx_jg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_khdx_jg;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_khdx_jg_op purge;
drop table ${iol_schema}.pams_khdx_jg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_khdx_jg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_khdx_jg where 0=1;

create table ${iol_schema}.pams_khdx_jg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_khdx_jg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_khdx_jg_cl(
            khdxdh -- 考核对象代号
            ,jgdh -- 机构代号
            ,jgmc -- 机构名称
            ,jyjgbz -- 经营机构标志
            ,pxbz -- 排序标志
            ,zxzt -- 注销状态
            ,zxrq -- 注销日期
            ,fhdh -- 分行代号
            ,fhbz -- 分行标志
            ,jgdj -- 机构登记
            ,jgqc -- 机构全称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_khdx_jg_op(
            khdxdh -- 考核对象代号
            ,jgdh -- 机构代号
            ,jgmc -- 机构名称
            ,jyjgbz -- 经营机构标志
            ,pxbz -- 排序标志
            ,zxzt -- 注销状态
            ,zxrq -- 注销日期
            ,fhdh -- 分行代号
            ,fhbz -- 分行标志
            ,jgdj -- 机构登记
            ,jgqc -- 机构全称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 机构代号
    ,nvl(n.jgmc, o.jgmc) as jgmc -- 机构名称
    ,nvl(n.jyjgbz, o.jyjgbz) as jyjgbz -- 经营机构标志
    ,nvl(n.pxbz, o.pxbz) as pxbz -- 排序标志
    ,nvl(n.zxzt, o.zxzt) as zxzt -- 注销状态
    ,nvl(n.zxrq, o.zxrq) as zxrq -- 注销日期
    ,nvl(n.fhdh, o.fhdh) as fhdh -- 分行代号
    ,nvl(n.fhbz, o.fhbz) as fhbz -- 分行标志
    ,nvl(n.jgdj, o.jgdj) as jgdj -- 机构登记
    ,nvl(n.jgqc, o.jgqc) as jgqc -- 机构全称
    ,case when
            n.khdxdh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.khdxdh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.khdxdh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_khdx_jg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_khdx_jg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.khdxdh = n.khdxdh
where (
        o.khdxdh is null
    )
    or (
        n.khdxdh is null
    )
    or (
        o.jgdh <> n.jgdh
        or o.jgmc <> n.jgmc
        or o.jyjgbz <> n.jyjgbz
        or o.pxbz <> n.pxbz
        or o.zxzt <> n.zxzt
        or o.zxrq <> n.zxrq
        or o.fhdh <> n.fhdh
        or o.fhbz <> n.fhbz
        or o.jgdj <> n.jgdj
        or o.jgqc <> n.jgqc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_khdx_jg_cl(
            khdxdh -- 考核对象代号
            ,jgdh -- 机构代号
            ,jgmc -- 机构名称
            ,jyjgbz -- 经营机构标志
            ,pxbz -- 排序标志
            ,zxzt -- 注销状态
            ,zxrq -- 注销日期
            ,fhdh -- 分行代号
            ,fhbz -- 分行标志
            ,jgdj -- 机构登记
            ,jgqc -- 机构全称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_khdx_jg_op(
            khdxdh -- 考核对象代号
            ,jgdh -- 机构代号
            ,jgmc -- 机构名称
            ,jyjgbz -- 经营机构标志
            ,pxbz -- 排序标志
            ,zxzt -- 注销状态
            ,zxrq -- 注销日期
            ,fhdh -- 分行代号
            ,fhbz -- 分行标志
            ,jgdj -- 机构登记
            ,jgqc -- 机构全称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.khdxdh -- 考核对象代号
    ,o.jgdh -- 机构代号
    ,o.jgmc -- 机构名称
    ,o.jyjgbz -- 经营机构标志
    ,o.pxbz -- 排序标志
    ,o.zxzt -- 注销状态
    ,o.zxrq -- 注销日期
    ,o.fhdh -- 分行代号
    ,o.fhbz -- 分行标志
    ,o.jgdj -- 机构登记
    ,o.jgqc -- 机构全称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_khdx_jg_bk o
    left join ${iol_schema}.pams_khdx_jg_op n
        on
            o.khdxdh = n.khdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_khdx_jg_cl d
        on
            o.khdxdh = d.khdxdh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.pams_khdx_jg;

-- 4.2 exchange partition
alter table ${iol_schema}.pams_khdx_jg exchange partition p_19000101 with table ${iol_schema}.pams_khdx_jg_cl;
alter table ${iol_schema}.pams_khdx_jg exchange partition p_20991231 with table ${iol_schema}.pams_khdx_jg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_khdx_jg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_khdx_jg_op purge;
drop table ${iol_schema}.pams_khdx_jg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_khdx_jg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_khdx_jg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
