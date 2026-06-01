/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a60datadict
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
create table ${iol_schema}.mpcs_a60datadict_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a60datadict
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a60datadict_op purge;
drop table ${iol_schema}.mpcs_a60datadict_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60datadict_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a60datadict where 0=1;

create table ${iol_schema}.mpcs_a60datadict_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a60datadict where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a60datadict_cl(
            name -- 字典名称
            ,key -- 字典KEY
            ,value -- 字典值
            ,stat -- 状态0-无效1-有效
            ,reserve1 -- 预留1
            ,reserve2 -- 预留2
            ,reserve3 -- 预留3
            ,reserve4 -- 预留4
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a60datadict_op(
            name -- 字典名称
            ,key -- 字典KEY
            ,value -- 字典值
            ,stat -- 状态0-无效1-有效
            ,reserve1 -- 预留1
            ,reserve2 -- 预留2
            ,reserve3 -- 预留3
            ,reserve4 -- 预留4
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.name, o.name) as name -- 字典名称
    ,nvl(n.key, o.key) as key -- 字典KEY
    ,nvl(n.value, o.value) as value -- 字典值
    ,nvl(n.stat, o.stat) as stat -- 状态0-无效1-有效
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 预留1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 预留2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 预留3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 预留4
    ,case when
            n.name is null
            and n.key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.name is null
            and n.key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.name is null
            and n.key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a60datadict_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a60datadict where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.name = n.name
            and o.key = n.key
where (
        o.name is null
        and o.key is null
    )
    or (
        n.name is null
        and n.key is null
    )
    or (
        o.value <> n.value
        or o.stat <> n.stat
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a60datadict_cl(
            name -- 字典名称
            ,key -- 字典KEY
            ,value -- 字典值
            ,stat -- 状态0-无效1-有效
            ,reserve1 -- 预留1
            ,reserve2 -- 预留2
            ,reserve3 -- 预留3
            ,reserve4 -- 预留4
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a60datadict_op(
            name -- 字典名称
            ,key -- 字典KEY
            ,value -- 字典值
            ,stat -- 状态0-无效1-有效
            ,reserve1 -- 预留1
            ,reserve2 -- 预留2
            ,reserve3 -- 预留3
            ,reserve4 -- 预留4
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.name -- 字典名称
    ,o.key -- 字典KEY
    ,o.value -- 字典值
    ,o.stat -- 状态0-无效1-有效
    ,o.reserve1 -- 预留1
    ,o.reserve2 -- 预留2
    ,o.reserve3 -- 预留3
    ,o.reserve4 -- 预留4
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
from ${iol_schema}.mpcs_a60datadict_bk o
    left join ${iol_schema}.mpcs_a60datadict_op n
        on
            o.name = n.name
            and o.key = n.key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a60datadict_cl d
        on
            o.name = d.name
            and o.key = d.key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a60datadict;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a60datadict') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a60datadict drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a60datadict add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a60datadict exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a60datadict_cl;
alter table ${iol_schema}.mpcs_a60datadict exchange partition p_20991231 with table ${iol_schema}.mpcs_a60datadict_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a60datadict to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a60datadict_op purge;
drop table ${iol_schema}.mpcs_a60datadict_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a60datadict_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a60datadict',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
