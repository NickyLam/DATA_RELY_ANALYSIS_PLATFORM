/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_cdkhzb
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
create table ${iol_schema}.pams_jxbb_cdkhzb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxbb_cdkhzb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_cdkhzb_op purge;
drop table ${iol_schema}.pams_jxbb_cdkhzb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_cdkhzb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_cdkhzb where 0=1;

create table ${iol_schema}.pams_jxbb_cdkhzb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_cdkhzb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_cdkhzb_cl(
            tjrq -- 统计日期
            ,khdxdh -- 考核对象代号
            ,pm -- 排名
            ,xm -- 项目
            ,ye -- 余额
            ,yrj -- 月日均
            ,nrj -- 年日均
            ,bz -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_cdkhzb_op(
            tjrq -- 统计日期
            ,khdxdh -- 考核对象代号
            ,pm -- 排名
            ,xm -- 项目
            ,ye -- 余额
            ,yrj -- 月日均
            ,nrj -- 年日均
            ,bz -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.pm, o.pm) as pm -- 排名
    ,nvl(n.xm, o.xm) as xm -- 项目
    ,nvl(n.ye, o.ye) as ye -- 余额
    ,nvl(n.yrj, o.yrj) as yrj -- 月日均
    ,nvl(n.nrj, o.nrj) as nrj -- 年日均
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,case when
            n.tjrq is null
            and n.khdxdh is null
            and n.pm is null
            and n.xm is null
            and n.bz is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tjrq is null
            and n.khdxdh is null
            and n.pm is null
            and n.xm is null
            and n.bz is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tjrq is null
            and n.khdxdh is null
            and n.pm is null
            and n.xm is null
            and n.bz is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_jxbb_cdkhzb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxbb_cdkhzb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tjrq = n.tjrq
            and o.khdxdh = n.khdxdh
            and o.pm = n.pm
            and o.xm = n.xm
            and o.bz = n.bz
where (
        o.tjrq is null
        and o.khdxdh is null
        and o.pm is null
        and o.xm is null
        and o.bz is null
    )
    or (
        n.tjrq is null
        and n.khdxdh is null
        and n.pm is null
        and n.xm is null
        and n.bz is null
    )
    or (
        o.ye <> n.ye
        or o.yrj <> n.yrj
        or o.nrj <> n.nrj
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_cdkhzb_cl(
            tjrq -- 统计日期
            ,khdxdh -- 考核对象代号
            ,pm -- 排名
            ,xm -- 项目
            ,ye -- 余额
            ,yrj -- 月日均
            ,nrj -- 年日均
            ,bz -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_cdkhzb_op(
            tjrq -- 统计日期
            ,khdxdh -- 考核对象代号
            ,pm -- 排名
            ,xm -- 项目
            ,ye -- 余额
            ,yrj -- 月日均
            ,nrj -- 年日均
            ,bz -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tjrq -- 统计日期
    ,o.khdxdh -- 考核对象代号
    ,o.pm -- 排名
    ,o.xm -- 项目
    ,o.ye -- 余额
    ,o.yrj -- 月日均
    ,o.nrj -- 年日均
    ,o.bz -- 币种
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_jxbb_cdkhzb_bk o
    left join ${iol_schema}.pams_jxbb_cdkhzb_op n
        on
            o.tjrq = n.tjrq
            and o.khdxdh = n.khdxdh
            and o.pm = n.pm
            and o.xm = n.xm
            and o.bz = n.bz
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxbb_cdkhzb_cl d
        on
            o.tjrq = d.tjrq
            and o.khdxdh = d.khdxdh
            and o.pm = d.pm
            and o.xm = d.xm
            and o.bz = d.bz
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_jxbb_cdkhzb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxbb_cdkhzb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxbb_cdkhzb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxbb_cdkhzb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxbb_cdkhzb exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_cdkhzb_cl;
alter table ${iol_schema}.pams_jxbb_cdkhzb exchange partition p_20991231 with table ${iol_schema}.pams_jxbb_cdkhzb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_cdkhzb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_cdkhzb_op purge;
drop table ${iol_schema}.pams_jxbb_cdkhzb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxbb_cdkhzb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_cdkhzb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
