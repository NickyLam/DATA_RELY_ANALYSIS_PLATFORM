/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_dxgx_hyyjgx_lxd
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
create table ${iol_schema}.pams_dxgx_hyyjgx_lxd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_dxgx_hyyjgx_lxd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_dxgx_hyyjgx_lxd_op purge;
drop table ${iol_schema}.pams_dxgx_hyyjgx_lxd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_dxgx_hyyjgx_lxd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_dxgx_hyyjgx_lxd where 0=1;

create table ${iol_schema}.pams_dxgx_hyyjgx_lxd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_dxgx_hyyjgx_lxd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_dxgx_hyyjgx_lxd_cl(
            jxdxdh -- 
            ,khdxdh -- 
            ,fpjs -- 
            ,qsrq -- 
            ,jsrq -- 
            ,gxhslx -- 
            ,yz -- 
            ,clbl -- 
            ,zlbl -- 
            ,gxly -- 
            ,yylsh -- 
            ,gxzt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_dxgx_hyyjgx_lxd_op(
            jxdxdh -- 
            ,khdxdh -- 
            ,fpjs -- 
            ,qsrq -- 
            ,jsrq -- 
            ,gxhslx -- 
            ,yz -- 
            ,clbl -- 
            ,zlbl -- 
            ,gxly -- 
            ,yylsh -- 
            ,gxzt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 
    ,nvl(n.fpjs, o.fpjs) as fpjs -- 
    ,nvl(n.qsrq, o.qsrq) as qsrq -- 
    ,nvl(n.jsrq, o.jsrq) as jsrq -- 
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 
    ,nvl(n.yz, o.yz) as yz -- 
    ,nvl(n.clbl, o.clbl) as clbl -- 
    ,nvl(n.zlbl, o.zlbl) as zlbl -- 
    ,nvl(n.gxly, o.gxly) as gxly -- 
    ,nvl(n.yylsh, o.yylsh) as yylsh -- 
    ,nvl(n.gxzt, o.gxzt) as gxzt -- 
    ,case when
            n.jxdxdh is null
            and n.khdxdh is null
            and n.fpjs is null
            and n.qsrq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.jxdxdh is null
            and n.khdxdh is null
            and n.fpjs is null
            and n.qsrq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.jxdxdh is null
            and n.khdxdh is null
            and n.fpjs is null
            and n.qsrq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_dxgx_hyyjgx_lxd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_dxgx_hyyjgx_lxd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
            and o.khdxdh = n.khdxdh
            and o.fpjs = n.fpjs
            and o.qsrq = n.qsrq
where (
        o.jxdxdh is null
        and o.khdxdh is null
        and o.fpjs is null
        and o.qsrq is null
    )
    or (
        n.jxdxdh is null
        and n.khdxdh is null
        and n.fpjs is null
        and n.qsrq is null
    )
    or (
        o.jsrq <> n.jsrq
        or o.gxhslx <> n.gxhslx
        or o.yz <> n.yz
        or o.clbl <> n.clbl
        or o.zlbl <> n.zlbl
        or o.gxly <> n.gxly
        or o.yylsh <> n.yylsh
        or o.gxzt <> n.gxzt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_dxgx_hyyjgx_lxd_cl(
            jxdxdh -- 
            ,khdxdh -- 
            ,fpjs -- 
            ,qsrq -- 
            ,jsrq -- 
            ,gxhslx -- 
            ,yz -- 
            ,clbl -- 
            ,zlbl -- 
            ,gxly -- 
            ,yylsh -- 
            ,gxzt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_dxgx_hyyjgx_lxd_op(
            jxdxdh -- 
            ,khdxdh -- 
            ,fpjs -- 
            ,qsrq -- 
            ,jsrq -- 
            ,gxhslx -- 
            ,yz -- 
            ,clbl -- 
            ,zlbl -- 
            ,gxly -- 
            ,yylsh -- 
            ,gxzt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 
    ,o.khdxdh -- 
    ,o.fpjs -- 
    ,o.qsrq -- 
    ,o.jsrq -- 
    ,o.gxhslx -- 
    ,o.yz -- 
    ,o.clbl -- 
    ,o.zlbl -- 
    ,o.gxly -- 
    ,o.yylsh -- 
    ,o.gxzt -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_dxgx_hyyjgx_lxd_bk o
    left join ${iol_schema}.pams_dxgx_hyyjgx_lxd_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.khdxdh = n.khdxdh
            and o.fpjs = n.fpjs
            and o.qsrq = n.qsrq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_dxgx_hyyjgx_lxd_cl d
        on
            o.jxdxdh = d.jxdxdh
            and o.khdxdh = d.khdxdh
            and o.fpjs = d.fpjs
            and o.qsrq = d.qsrq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.pams_dxgx_hyyjgx_lxd;

-- 4.2 exchange partition
alter table ${iol_schema}.pams_dxgx_hyyjgx_lxd exchange partition p_19000101 with table ${iol_schema}.pams_dxgx_hyyjgx_lxd_cl;
alter table ${iol_schema}.pams_dxgx_hyyjgx_lxd exchange partition p_20991231 with table ${iol_schema}.pams_dxgx_hyyjgx_lxd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_dxgx_hyyjgx_lxd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_dxgx_hyyjgx_lxd_op purge;
drop table ${iol_schema}.pams_dxgx_hyyjgx_lxd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_dxgx_hyyjgx_lxd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_dxgx_hyyjgx_lxd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
