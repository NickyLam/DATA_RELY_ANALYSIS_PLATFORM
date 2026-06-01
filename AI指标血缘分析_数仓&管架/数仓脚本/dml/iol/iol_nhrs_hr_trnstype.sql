/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_hr_trnstype
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
create table ${iol_schema}.nhrs_hr_trnstype_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_hr_trnstype
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hr_trnstype_op purge;
drop table ${iol_schema}.nhrs_hr_trnstype_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hr_trnstype_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hr_trnstype where 0=1;

create table ${iol_schema}.nhrs_hr_trnstype_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hr_trnstype where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hr_trnstype_cl(
            creationtime -- 
            ,creator -- 
            ,dr -- 
            ,enablestate -- 
            ,ishrss -- 
            ,memo -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_trnstype -- 
            ,systypeflag -- 
            ,trnsevent -- 
            ,trnstypecode -- 
            ,trnstypename -- 
            ,trnstypename2 -- 
            ,trnstypename3 -- 
            ,trnstypename4 -- 
            ,trnstypename5 -- 
            ,trnstypename6 -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hr_trnstype_op(
            creationtime -- 
            ,creator -- 
            ,dr -- 
            ,enablestate -- 
            ,ishrss -- 
            ,memo -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_trnstype -- 
            ,systypeflag -- 
            ,trnsevent -- 
            ,trnstypecode -- 
            ,trnstypename -- 
            ,trnstypename2 -- 
            ,trnstypename3 -- 
            ,trnstypename4 -- 
            ,trnstypename5 -- 
            ,trnstypename6 -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.creationtime, o.creationtime) as creationtime -- 
    ,nvl(n.creator, o.creator) as creator -- 
    ,nvl(n.dr, o.dr) as dr -- 
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 
    ,nvl(n.ishrss, o.ishrss) as ishrss -- 
    ,nvl(n.memo, o.memo) as memo -- 
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 
    ,nvl(n.pk_trnstype, o.pk_trnstype) as pk_trnstype -- 
    ,nvl(n.systypeflag, o.systypeflag) as systypeflag -- 
    ,nvl(n.trnsevent, o.trnsevent) as trnsevent -- 
    ,nvl(n.trnstypecode, o.trnstypecode) as trnstypecode -- 
    ,nvl(n.trnstypename, o.trnstypename) as trnstypename -- 
    ,nvl(n.trnstypename2, o.trnstypename2) as trnstypename2 -- 
    ,nvl(n.trnstypename3, o.trnstypename3) as trnstypename3 -- 
    ,nvl(n.trnstypename4, o.trnstypename4) as trnstypename4 -- 
    ,nvl(n.trnstypename5, o.trnstypename5) as trnstypename5 -- 
    ,nvl(n.trnstypename6, o.trnstypename6) as trnstypename6 -- 
    ,nvl(n.ts, o.ts) as ts -- 
    ,case when
            n.pk_trnstype is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_trnstype is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_trnstype is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_hr_trnstype_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_hr_trnstype where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_trnstype = n.pk_trnstype
where (
        o.pk_trnstype is null
    )
    or (
        n.pk_trnstype is null
    )
    or (
        o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dr <> n.dr
        or o.enablestate <> n.enablestate
        or o.ishrss <> n.ishrss
        or o.memo <> n.memo
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.systypeflag <> n.systypeflag
        or o.trnsevent <> n.trnsevent
        or o.trnstypecode <> n.trnstypecode
        or o.trnstypename <> n.trnstypename
        or o.trnstypename2 <> n.trnstypename2
        or o.trnstypename3 <> n.trnstypename3
        or o.trnstypename4 <> n.trnstypename4
        or o.trnstypename5 <> n.trnstypename5
        or o.trnstypename6 <> n.trnstypename6
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hr_trnstype_cl(
            creationtime -- 
            ,creator -- 
            ,dr -- 
            ,enablestate -- 
            ,ishrss -- 
            ,memo -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_trnstype -- 
            ,systypeflag -- 
            ,trnsevent -- 
            ,trnstypecode -- 
            ,trnstypename -- 
            ,trnstypename2 -- 
            ,trnstypename3 -- 
            ,trnstypename4 -- 
            ,trnstypename5 -- 
            ,trnstypename6 -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hr_trnstype_op(
            creationtime -- 
            ,creator -- 
            ,dr -- 
            ,enablestate -- 
            ,ishrss -- 
            ,memo -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_trnstype -- 
            ,systypeflag -- 
            ,trnsevent -- 
            ,trnstypecode -- 
            ,trnstypename -- 
            ,trnstypename2 -- 
            ,trnstypename3 -- 
            ,trnstypename4 -- 
            ,trnstypename5 -- 
            ,trnstypename6 -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.creationtime -- 
    ,o.creator -- 
    ,o.dr -- 
    ,o.enablestate -- 
    ,o.ishrss -- 
    ,o.memo -- 
    ,o.modifiedtime -- 
    ,o.modifier -- 
    ,o.pk_group -- 
    ,o.pk_org -- 
    ,o.pk_trnstype -- 
    ,o.systypeflag -- 
    ,o.trnsevent -- 
    ,o.trnstypecode -- 
    ,o.trnstypename -- 
    ,o.trnstypename2 -- 
    ,o.trnstypename3 -- 
    ,o.trnstypename4 -- 
    ,o.trnstypename5 -- 
    ,o.trnstypename6 -- 
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
from ${iol_schema}.nhrs_hr_trnstype_bk o
    left join ${iol_schema}.nhrs_hr_trnstype_op n
        on
            o.pk_trnstype = n.pk_trnstype
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_hr_trnstype_cl d
        on
            o.pk_trnstype = d.pk_trnstype
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_hr_trnstype;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_hr_trnstype') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_hr_trnstype drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_hr_trnstype add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_hr_trnstype exchange partition p_${batch_date} with table ${iol_schema}.nhrs_hr_trnstype_cl;
alter table ${iol_schema}.nhrs_hr_trnstype exchange partition p_20991231 with table ${iol_schema}.nhrs_hr_trnstype_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_hr_trnstype to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hr_trnstype_op purge;
drop table ${iol_schema}.nhrs_hr_trnstype_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_hr_trnstype_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_hr_trnstype',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
