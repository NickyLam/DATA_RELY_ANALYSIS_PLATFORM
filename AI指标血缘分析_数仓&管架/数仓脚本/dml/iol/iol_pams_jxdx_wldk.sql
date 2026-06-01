/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_wldk
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
create table ${iol_schema}.pams_jxdx_wldk_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_wldk
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_wldk_op purge;
drop table ${iol_schema}.pams_jxdx_wldk_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_wldk_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_wldk where 0=1;

create table ${iol_schema}.pams_jxdx_wldk_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_wldk where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_wldk_cl(
            jxdxdh -- 
            ,wdbh -- 
            ,bz -- 
            ,jgdh -- 
            ,kmh -- 
            ,khrq -- 
            ,dqrq -- 
            ,zhye -- 
            ,khje -- 
            ,ywpz -- 
            ,cpbh -- 
            ,jxfs -- 
            ,hkfs -- 
            ,qxrq -- 
            ,txhydm -- 
            ,txdm -- 
            ,llfddm -- 
            ,jxbz -- 
            ,jqbz -- 
            ,hxbz -- 
            ,nll -- 
            ,jzll -- 
            ,yqzxll -- 
            ,ysyjlx -- 
            ,dyhkbj -- 
            ,dqhklx -- 
            ,yqbj -- 
            ,ljyswslxje -- 
            ,yqlx -- 
            ,hxbj -- 
            ,hxlx -- 
            ,xczhje -- 
            ,xczflx -- 
            ,tjrq -- 统计日期
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_wldk_op(
            jxdxdh -- 
            ,wdbh -- 
            ,bz -- 
            ,jgdh -- 
            ,kmh -- 
            ,khrq -- 
            ,dqrq -- 
            ,zhye -- 
            ,khje -- 
            ,ywpz -- 
            ,cpbh -- 
            ,jxfs -- 
            ,hkfs -- 
            ,qxrq -- 
            ,txhydm -- 
            ,txdm -- 
            ,llfddm -- 
            ,jxbz -- 
            ,jqbz -- 
            ,hxbz -- 
            ,nll -- 
            ,jzll -- 
            ,yqzxll -- 
            ,ysyjlx -- 
            ,dyhkbj -- 
            ,dqhklx -- 
            ,yqbj -- 
            ,ljyswslxje -- 
            ,yqlx -- 
            ,hxbj -- 
            ,hxlx -- 
            ,xczhje -- 
            ,xczflx -- 
            ,tjrq -- 统计日期
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 
    ,nvl(n.wdbh, o.wdbh) as wdbh -- 
    ,nvl(n.bz, o.bz) as bz -- 
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 
    ,nvl(n.kmh, o.kmh) as kmh -- 
    ,nvl(n.khrq, o.khrq) as khrq -- 
    ,nvl(n.dqrq, o.dqrq) as dqrq -- 
    ,nvl(n.zhye, o.zhye) as zhye -- 
    ,nvl(n.khje, o.khje) as khje -- 
    ,nvl(n.ywpz, o.ywpz) as ywpz -- 
    ,nvl(n.cpbh, o.cpbh) as cpbh -- 
    ,nvl(n.jxfs, o.jxfs) as jxfs -- 
    ,nvl(n.hkfs, o.hkfs) as hkfs -- 
    ,nvl(n.qxrq, o.qxrq) as qxrq -- 
    ,nvl(n.txhydm, o.txhydm) as txhydm -- 
    ,nvl(n.txdm, o.txdm) as txdm -- 
    ,nvl(n.llfddm, o.llfddm) as llfddm -- 
    ,nvl(n.jxbz, o.jxbz) as jxbz -- 
    ,nvl(n.jqbz, o.jqbz) as jqbz -- 
    ,nvl(n.hxbz, o.hxbz) as hxbz -- 
    ,nvl(n.nll, o.nll) as nll -- 
    ,nvl(n.jzll, o.jzll) as jzll -- 
    ,nvl(n.yqzxll, o.yqzxll) as yqzxll -- 
    ,nvl(n.ysyjlx, o.ysyjlx) as ysyjlx -- 
    ,nvl(n.dyhkbj, o.dyhkbj) as dyhkbj -- 
    ,nvl(n.dqhklx, o.dqhklx) as dqhklx -- 
    ,nvl(n.yqbj, o.yqbj) as yqbj -- 
    ,nvl(n.ljyswslxje, o.ljyswslxje) as ljyswslxje -- 
    ,nvl(n.yqlx, o.yqlx) as yqlx -- 
    ,nvl(n.hxbj, o.hxbj) as hxbj -- 
    ,nvl(n.hxlx, o.hxlx) as hxlx -- 
    ,nvl(n.xczhje, o.xczhje) as xczhje -- 
    ,nvl(n.xczflx, o.xczflx) as xczflx -- 
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,case when
            n.jxdxdh is null
            and n.wdbh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.jxdxdh is null
            and n.wdbh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.jxdxdh is null
            and n.wdbh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_jxdx_wldk_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_wldk where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
            and o.wdbh = n.wdbh
where (
        o.jxdxdh is null
        and o.wdbh is null
    )
    or (
        n.jxdxdh is null
        and n.wdbh is null
    )
    or (
        o.bz <> n.bz
        or o.jgdh <> n.jgdh
        or o.kmh <> n.kmh
        or o.khrq <> n.khrq
        or o.dqrq <> n.dqrq
        or o.zhye <> n.zhye
        or o.khje <> n.khje
        or o.ywpz <> n.ywpz
        or o.cpbh <> n.cpbh
        or o.jxfs <> n.jxfs
        or o.hkfs <> n.hkfs
        or o.qxrq <> n.qxrq
        or o.txhydm <> n.txhydm
        or o.txdm <> n.txdm
        or o.llfddm <> n.llfddm
        or o.jxbz <> n.jxbz
        or o.jqbz <> n.jqbz
        or o.hxbz <> n.hxbz
        or o.nll <> n.nll
        or o.jzll <> n.jzll
        or o.yqzxll <> n.yqzxll
        or o.ysyjlx <> n.ysyjlx
        or o.dyhkbj <> n.dyhkbj
        or o.dqhklx <> n.dqhklx
        or o.yqbj <> n.yqbj
        or o.ljyswslxje <> n.ljyswslxje
        or o.yqlx <> n.yqlx
        or o.hxbj <> n.hxbj
        or o.hxlx <> n.hxlx
        or o.xczhje <> n.xczhje
        or o.xczflx <> n.xczflx
        or o.tjrq <> n.tjrq
        or o.khdxdh <> n.khdxdh
        or o.gxhslx <> n.gxhslx
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_wldk_cl(
            jxdxdh -- 
            ,wdbh -- 
            ,bz -- 
            ,jgdh -- 
            ,kmh -- 
            ,khrq -- 
            ,dqrq -- 
            ,zhye -- 
            ,khje -- 
            ,ywpz -- 
            ,cpbh -- 
            ,jxfs -- 
            ,hkfs -- 
            ,qxrq -- 
            ,txhydm -- 
            ,txdm -- 
            ,llfddm -- 
            ,jxbz -- 
            ,jqbz -- 
            ,hxbz -- 
            ,nll -- 
            ,jzll -- 
            ,yqzxll -- 
            ,ysyjlx -- 
            ,dyhkbj -- 
            ,dqhklx -- 
            ,yqbj -- 
            ,ljyswslxje -- 
            ,yqlx -- 
            ,hxbj -- 
            ,hxlx -- 
            ,xczhje -- 
            ,xczflx -- 
            ,tjrq -- 统计日期
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_wldk_op(
            jxdxdh -- 
            ,wdbh -- 
            ,bz -- 
            ,jgdh -- 
            ,kmh -- 
            ,khrq -- 
            ,dqrq -- 
            ,zhye -- 
            ,khje -- 
            ,ywpz -- 
            ,cpbh -- 
            ,jxfs -- 
            ,hkfs -- 
            ,qxrq -- 
            ,txhydm -- 
            ,txdm -- 
            ,llfddm -- 
            ,jxbz -- 
            ,jqbz -- 
            ,hxbz -- 
            ,nll -- 
            ,jzll -- 
            ,yqzxll -- 
            ,ysyjlx -- 
            ,dyhkbj -- 
            ,dqhklx -- 
            ,yqbj -- 
            ,ljyswslxje -- 
            ,yqlx -- 
            ,hxbj -- 
            ,hxlx -- 
            ,xczhje -- 
            ,xczflx -- 
            ,tjrq -- 统计日期
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 
    ,o.wdbh -- 
    ,o.bz -- 
    ,o.jgdh -- 
    ,o.kmh -- 
    ,o.khrq -- 
    ,o.dqrq -- 
    ,o.zhye -- 
    ,o.khje -- 
    ,o.ywpz -- 
    ,o.cpbh -- 
    ,o.jxfs -- 
    ,o.hkfs -- 
    ,o.qxrq -- 
    ,o.txhydm -- 
    ,o.txdm -- 
    ,o.llfddm -- 
    ,o.jxbz -- 
    ,o.jqbz -- 
    ,o.hxbz -- 
    ,o.nll -- 
    ,o.jzll -- 
    ,o.yqzxll -- 
    ,o.ysyjlx -- 
    ,o.dyhkbj -- 
    ,o.dqhklx -- 
    ,o.yqbj -- 
    ,o.ljyswslxje -- 
    ,o.yqlx -- 
    ,o.hxbj -- 
    ,o.hxlx -- 
    ,o.xczhje -- 
    ,o.xczflx -- 
    ,o.tjrq -- 统计日期
    ,o.khdxdh -- 考核对象代号
    ,o.gxhslx -- 关系函数类型
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
from ${iol_schema}.pams_jxdx_wldk_bk o
    left join ${iol_schema}.pams_jxdx_wldk_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.wdbh = n.wdbh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_wldk_cl d
        on
            o.jxdxdh = d.jxdxdh
            and o.wdbh = d.wdbh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_jxdx_wldk;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_wldk') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_wldk drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_wldk add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_wldk exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_wldk_cl;
alter table ${iol_schema}.pams_jxdx_wldk exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_wldk_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_wldk to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_wldk_op purge;
drop table ${iol_schema}.pams_jxdx_wldk_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_wldk_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_wldk',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
