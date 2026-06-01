/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_bd_defdoc
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
create table ${iol_schema}.nhrs_bd_defdoc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_bd_defdoc
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_bd_defdoc_op purge;
drop table ${iol_schema}.nhrs_bd_defdoc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_bd_defdoc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_bd_defdoc where 0=1;

create table ${iol_schema}.nhrs_bd_defdoc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_bd_defdoc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_bd_defdoc_cl(
            code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,datatype -- 
            ,dr -- 
            ,enablestate -- 
            ,innercode -- 
            ,memo -- 
            ,mnecode -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,pid -- 
            ,pk_defdoc -- 
            ,pk_defdoclist -- 
            ,pk_group -- 
            ,pk_org -- 
            ,shortname -- 
            ,shortname2 -- 
            ,shortname3 -- 
            ,shortname4 -- 
            ,shortname5 -- 
            ,shortname6 -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_bd_defdoc_op(
            code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,datatype -- 
            ,dr -- 
            ,enablestate -- 
            ,innercode -- 
            ,memo -- 
            ,mnecode -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,pid -- 
            ,pk_defdoc -- 
            ,pk_defdoclist -- 
            ,pk_group -- 
            ,pk_org -- 
            ,shortname -- 
            ,shortname2 -- 
            ,shortname3 -- 
            ,shortname4 -- 
            ,shortname5 -- 
            ,shortname6 -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.code, o.code) as code -- 
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 
    ,nvl(n.creator, o.creator) as creator -- 
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 
    ,nvl(n.datatype, o.datatype) as datatype -- 
    ,nvl(n.dr, o.dr) as dr -- 
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 
    ,nvl(n.innercode, o.innercode) as innercode -- 
    ,nvl(n.memo, o.memo) as memo -- 
    ,nvl(n.mnecode, o.mnecode) as mnecode -- 
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.name, o.name) as name -- 
    ,nvl(n.name2, o.name2) as name2 -- 
    ,nvl(n.name3, o.name3) as name3 -- 
    ,nvl(n.name4, o.name4) as name4 -- 
    ,nvl(n.name5, o.name5) as name5 -- 
    ,nvl(n.name6, o.name6) as name6 -- 
    ,nvl(n.pid, o.pid) as pid -- 
    ,nvl(n.pk_defdoc, o.pk_defdoc) as pk_defdoc -- 
    ,nvl(n.pk_defdoclist, o.pk_defdoclist) as pk_defdoclist -- 
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 
    ,nvl(n.shortname, o.shortname) as shortname -- 
    ,nvl(n.shortname2, o.shortname2) as shortname2 -- 
    ,nvl(n.shortname3, o.shortname3) as shortname3 -- 
    ,nvl(n.shortname4, o.shortname4) as shortname4 -- 
    ,nvl(n.shortname5, o.shortname5) as shortname5 -- 
    ,nvl(n.shortname6, o.shortname6) as shortname6 -- 
    ,nvl(n.ts, o.ts) as ts -- 
    ,case when
            n.pk_defdoc is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_defdoc is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_defdoc is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_bd_defdoc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_bd_defdoc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_defdoc = n.pk_defdoc
where (
        o.pk_defdoc is null
    )
    or (
        n.pk_defdoc is null
    )
    or (
        o.code <> n.code
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.datatype <> n.datatype
        or o.dr <> n.dr
        or o.enablestate <> n.enablestate
        or o.innercode <> n.innercode
        or o.memo <> n.memo
        or o.mnecode <> n.mnecode
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.name <> n.name
        or o.name2 <> n.name2
        or o.name3 <> n.name3
        or o.name4 <> n.name4
        or o.name5 <> n.name5
        or o.name6 <> n.name6
        or o.pid <> n.pid
        or o.pk_defdoclist <> n.pk_defdoclist
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.shortname <> n.shortname
        or o.shortname2 <> n.shortname2
        or o.shortname3 <> n.shortname3
        or o.shortname4 <> n.shortname4
        or o.shortname5 <> n.shortname5
        or o.shortname6 <> n.shortname6
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_bd_defdoc_cl(
            code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,datatype -- 
            ,dr -- 
            ,enablestate -- 
            ,innercode -- 
            ,memo -- 
            ,mnecode -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,pid -- 
            ,pk_defdoc -- 
            ,pk_defdoclist -- 
            ,pk_group -- 
            ,pk_org -- 
            ,shortname -- 
            ,shortname2 -- 
            ,shortname3 -- 
            ,shortname4 -- 
            ,shortname5 -- 
            ,shortname6 -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_bd_defdoc_op(
            code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,datatype -- 
            ,dr -- 
            ,enablestate -- 
            ,innercode -- 
            ,memo -- 
            ,mnecode -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,pid -- 
            ,pk_defdoc -- 
            ,pk_defdoclist -- 
            ,pk_group -- 
            ,pk_org -- 
            ,shortname -- 
            ,shortname2 -- 
            ,shortname3 -- 
            ,shortname4 -- 
            ,shortname5 -- 
            ,shortname6 -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.code -- 
    ,o.creationtime -- 
    ,o.creator -- 
    ,o.dataoriginflag -- 
    ,o.datatype -- 
    ,o.dr -- 
    ,o.enablestate -- 
    ,o.innercode -- 
    ,o.memo -- 
    ,o.mnecode -- 
    ,o.modifiedtime -- 
    ,o.modifier -- 
    ,o.name -- 
    ,o.name2 -- 
    ,o.name3 -- 
    ,o.name4 -- 
    ,o.name5 -- 
    ,o.name6 -- 
    ,o.pid -- 
    ,o.pk_defdoc -- 
    ,o.pk_defdoclist -- 
    ,o.pk_group -- 
    ,o.pk_org -- 
    ,o.shortname -- 
    ,o.shortname2 -- 
    ,o.shortname3 -- 
    ,o.shortname4 -- 
    ,o.shortname5 -- 
    ,o.shortname6 -- 
    ,o.ts -- 
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
from ${iol_schema}.nhrs_bd_defdoc_bk o
    left join ${iol_schema}.nhrs_bd_defdoc_op n
        on
            o.pk_defdoc = n.pk_defdoc
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_bd_defdoc_cl d
        on
            o.pk_defdoc = d.pk_defdoc
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_bd_defdoc;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_bd_defdoc') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_bd_defdoc drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_bd_defdoc add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_bd_defdoc exchange partition p_${batch_date} with table ${iol_schema}.nhrs_bd_defdoc_cl;
alter table ${iol_schema}.nhrs_bd_defdoc exchange partition p_20991231 with table ${iol_schema}.nhrs_bd_defdoc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_bd_defdoc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_bd_defdoc_op purge;
drop table ${iol_schema}.nhrs_bd_defdoc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_bd_defdoc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_bd_defdoc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
