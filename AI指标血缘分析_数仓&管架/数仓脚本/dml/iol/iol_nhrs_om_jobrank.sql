/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_om_jobrank
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
create table ${iol_schema}.nhrs_om_jobrank_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_om_jobrank
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_om_jobrank_op purge;
drop table ${iol_schema}.nhrs_om_jobrank_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_om_jobrank_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_om_jobrank where 0=1;

create table ${iol_schema}.nhrs_om_jobrank_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_om_jobrank where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_om_jobrank_cl(
            creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,dr -- 
            ,enablestate -- 
            ,jobrankcode -- 
            ,jobrankdesc -- 
            ,jobrankname -- 
            ,jobrankname2 -- 
            ,jobrankname3 -- 
            ,jobrankname4 -- 
            ,jobrankname5 -- 
            ,jobrankname6 -- 
            ,jobrankorder -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,pk_group -- 
            ,pk_jobrank -- 
            ,pk_org -- 
            ,sealflag -- 
            ,ts -- 
            ,usedflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_om_jobrank_op(
            creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,dr -- 
            ,enablestate -- 
            ,jobrankcode -- 
            ,jobrankdesc -- 
            ,jobrankname -- 
            ,jobrankname2 -- 
            ,jobrankname3 -- 
            ,jobrankname4 -- 
            ,jobrankname5 -- 
            ,jobrankname6 -- 
            ,jobrankorder -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,pk_group -- 
            ,pk_jobrank -- 
            ,pk_org -- 
            ,sealflag -- 
            ,ts -- 
            ,usedflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.creationtime, o.creationtime) as creationtime -- 
    ,nvl(n.creator, o.creator) as creator -- 
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 
    ,nvl(n.dr, o.dr) as dr -- 
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 
    ,nvl(n.jobrankcode, o.jobrankcode) as jobrankcode -- 
    ,nvl(n.jobrankdesc, o.jobrankdesc) as jobrankdesc -- 
    ,nvl(n.jobrankname, o.jobrankname) as jobrankname -- 
    ,nvl(n.jobrankname2, o.jobrankname2) as jobrankname2 -- 
    ,nvl(n.jobrankname3, o.jobrankname3) as jobrankname3 -- 
    ,nvl(n.jobrankname4, o.jobrankname4) as jobrankname4 -- 
    ,nvl(n.jobrankname5, o.jobrankname5) as jobrankname5 -- 
    ,nvl(n.jobrankname6, o.jobrankname6) as jobrankname6 -- 
    ,nvl(n.jobrankorder, o.jobrankorder) as jobrankorder -- 
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 
    ,nvl(n.pk_jobrank, o.pk_jobrank) as pk_jobrank -- 
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 
    ,nvl(n.sealflag, o.sealflag) as sealflag -- 
    ,nvl(n.ts, o.ts) as ts -- 
    ,nvl(n.usedflag, o.usedflag) as usedflag -- 
    ,case when
            n.pk_jobrank is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_jobrank is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_jobrank is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_om_jobrank_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_om_jobrank where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_jobrank = n.pk_jobrank
where (
        o.pk_jobrank is null
    )
    or (
        n.pk_jobrank is null
    )
    or (
        o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.dr <> n.dr
        or o.enablestate <> n.enablestate
        or o.jobrankcode <> n.jobrankcode
        or o.jobrankdesc <> n.jobrankdesc
        or o.jobrankname <> n.jobrankname
        or o.jobrankname2 <> n.jobrankname2
        or o.jobrankname3 <> n.jobrankname3
        or o.jobrankname4 <> n.jobrankname4
        or o.jobrankname5 <> n.jobrankname5
        or o.jobrankname6 <> n.jobrankname6
        or o.jobrankorder <> n.jobrankorder
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.sealflag <> n.sealflag
        or o.ts <> n.ts
        or o.usedflag <> n.usedflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_om_jobrank_cl(
            creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,dr -- 
            ,enablestate -- 
            ,jobrankcode -- 
            ,jobrankdesc -- 
            ,jobrankname -- 
            ,jobrankname2 -- 
            ,jobrankname3 -- 
            ,jobrankname4 -- 
            ,jobrankname5 -- 
            ,jobrankname6 -- 
            ,jobrankorder -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,pk_group -- 
            ,pk_jobrank -- 
            ,pk_org -- 
            ,sealflag -- 
            ,ts -- 
            ,usedflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_om_jobrank_op(
            creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,dr -- 
            ,enablestate -- 
            ,jobrankcode -- 
            ,jobrankdesc -- 
            ,jobrankname -- 
            ,jobrankname2 -- 
            ,jobrankname3 -- 
            ,jobrankname4 -- 
            ,jobrankname5 -- 
            ,jobrankname6 -- 
            ,jobrankorder -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,pk_group -- 
            ,pk_jobrank -- 
            ,pk_org -- 
            ,sealflag -- 
            ,ts -- 
            ,usedflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.creationtime -- 
    ,o.creator -- 
    ,o.dataoriginflag -- 
    ,o.dr -- 
    ,o.enablestate -- 
    ,o.jobrankcode -- 
    ,o.jobrankdesc -- 
    ,o.jobrankname -- 
    ,o.jobrankname2 -- 
    ,o.jobrankname3 -- 
    ,o.jobrankname4 -- 
    ,o.jobrankname5 -- 
    ,o.jobrankname6 -- 
    ,o.jobrankorder -- 
    ,o.modifiedtime -- 
    ,o.modifier -- 
    ,o.pk_group -- 
    ,o.pk_jobrank -- 
    ,o.pk_org -- 
    ,o.sealflag -- 
    ,o.ts -- 
    ,o.usedflag -- 
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
from ${iol_schema}.nhrs_om_jobrank_bk o
    left join ${iol_schema}.nhrs_om_jobrank_op n
        on
            o.pk_jobrank = n.pk_jobrank
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_om_jobrank_cl d
        on
            o.pk_jobrank = d.pk_jobrank
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_om_jobrank;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_om_jobrank') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_om_jobrank drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_om_jobrank add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_om_jobrank exchange partition p_${batch_date} with table ${iol_schema}.nhrs_om_jobrank_cl;
alter table ${iol_schema}.nhrs_om_jobrank exchange partition p_20991231 with table ${iol_schema}.nhrs_om_jobrank_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_om_jobrank to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_om_jobrank_op purge;
drop table ${iol_schema}.nhrs_om_jobrank_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_om_jobrank_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_om_jobrank',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
