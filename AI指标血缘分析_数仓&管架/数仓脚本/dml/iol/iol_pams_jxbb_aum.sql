/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_aum
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
create table ${iol_schema}.pams_jxbb_aum_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxbb_aum
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_aum_op purge;
drop table ${iol_schema}.pams_jxbb_aum_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_aum_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_aum where 0=1;

create table ${iol_schema}.pams_jxbb_aum_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_aum where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_aum_cl(
            jxdxdh -- 
            ,tjrq -- 
            ,khh -- 
            ,khzt -- 
            ,xhrq -- 
            ,aumye -- 
            ,aumyrjye -- 
            ,aumjrjye -- 
            ,aumnrjye -- 
            ,lsaumyrjqj -- 
            ,fhaumyrjqj -- 
            ,xtjhye -- 
            ,xtjhyrj -- 
            ,xtjhnrj -- 
            ,xtjhjrj -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_aum_op(
            jxdxdh -- 
            ,tjrq -- 
            ,khh -- 
            ,khzt -- 
            ,xhrq -- 
            ,aumye -- 
            ,aumyrjye -- 
            ,aumjrjye -- 
            ,aumnrjye -- 
            ,lsaumyrjqj -- 
            ,fhaumyrjqj -- 
            ,xtjhye -- 
            ,xtjhyrj -- 
            ,xtjhnrj -- 
            ,xtjhjrj -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 
    ,nvl(n.khh, o.khh) as khh -- 
    ,nvl(n.khzt, o.khzt) as khzt -- 
    ,nvl(n.xhrq, o.xhrq) as xhrq -- 
    ,nvl(n.aumye, o.aumye) as aumye -- 
    ,nvl(n.aumyrjye, o.aumyrjye) as aumyrjye -- 
    ,nvl(n.aumjrjye, o.aumjrjye) as aumjrjye -- 
    ,nvl(n.aumnrjye, o.aumnrjye) as aumnrjye -- 
    ,nvl(n.lsaumyrjqj, o.lsaumyrjqj) as lsaumyrjqj -- 
    ,nvl(n.fhaumyrjqj, o.fhaumyrjqj) as fhaumyrjqj -- 
    ,nvl(n.xtjhye, o.xtjhye) as xtjhye -- 
    ,nvl(n.xtjhyrj, o.xtjhyrj) as xtjhyrj -- 
    ,nvl(n.xtjhnrj, o.xtjhnrj) as xtjhnrj -- 
    ,nvl(n.xtjhjrj, o.xtjhjrj) as xtjhjrj -- 
    ,case when
            n.jxdxdh is null
            and n.tjrq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.jxdxdh is null
            and n.tjrq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.jxdxdh is null
            and n.tjrq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_jxbb_aum_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxbb_aum where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
            and o.tjrq = n.tjrq
where (
        o.jxdxdh is null
        and o.tjrq is null
    )
    or (
        n.jxdxdh is null
        and n.tjrq is null
    )
    or (
        o.khh <> n.khh
        or o.khzt <> n.khzt
        or o.xhrq <> n.xhrq
        or o.aumye <> n.aumye
        or o.aumyrjye <> n.aumyrjye
        or o.aumjrjye <> n.aumjrjye
        or o.aumnrjye <> n.aumnrjye
        or o.lsaumyrjqj <> n.lsaumyrjqj
        or o.fhaumyrjqj <> n.fhaumyrjqj
        or o.xtjhye <> n.xtjhye
        or o.xtjhyrj <> n.xtjhyrj
        or o.xtjhnrj <> n.xtjhnrj
        or o.xtjhjrj <> n.xtjhjrj
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_aum_cl(
            jxdxdh -- 
            ,tjrq -- 
            ,khh -- 
            ,khzt -- 
            ,xhrq -- 
            ,aumye -- 
            ,aumyrjye -- 
            ,aumjrjye -- 
            ,aumnrjye -- 
            ,lsaumyrjqj -- 
            ,fhaumyrjqj -- 
            ,xtjhye -- 
            ,xtjhyrj -- 
            ,xtjhnrj -- 
            ,xtjhjrj -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_aum_op(
            jxdxdh -- 
            ,tjrq -- 
            ,khh -- 
            ,khzt -- 
            ,xhrq -- 
            ,aumye -- 
            ,aumyrjye -- 
            ,aumjrjye -- 
            ,aumnrjye -- 
            ,lsaumyrjqj -- 
            ,fhaumyrjqj -- 
            ,xtjhye -- 
            ,xtjhyrj -- 
            ,xtjhnrj -- 
            ,xtjhjrj -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 
    ,o.tjrq -- 
    ,o.khh -- 
    ,o.khzt -- 
    ,o.xhrq -- 
    ,o.aumye -- 
    ,o.aumyrjye -- 
    ,o.aumjrjye -- 
    ,o.aumnrjye -- 
    ,o.lsaumyrjqj -- 
    ,o.fhaumyrjqj -- 
    ,o.xtjhye -- 
    ,o.xtjhyrj -- 
    ,o.xtjhnrj -- 
    ,o.xtjhjrj -- 
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
from ${iol_schema}.pams_jxbb_aum_bk o
    left join ${iol_schema}.pams_jxbb_aum_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.tjrq = n.tjrq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxbb_aum_cl d
        on
            o.jxdxdh = d.jxdxdh
            and o.tjrq = d.tjrq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_jxbb_aum;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxbb_aum') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxbb_aum drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxbb_aum add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxbb_aum exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_aum_cl;
alter table ${iol_schema}.pams_jxbb_aum exchange partition p_20991231 with table ${iol_schema}.pams_jxbb_aum_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_aum to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_aum_op purge;
drop table ${iol_schema}.pams_jxbb_aum_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxbb_aum_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_aum',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
