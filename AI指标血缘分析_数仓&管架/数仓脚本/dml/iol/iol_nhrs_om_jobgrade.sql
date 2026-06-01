/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_om_jobgrade
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
create table ${iol_schema}.nhrs_om_jobgrade_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_om_jobgrade
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_om_jobgrade_op purge;
drop table ${iol_schema}.nhrs_om_jobgrade_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_om_jobgrade_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_om_jobgrade where 0=1;

create table ${iol_schema}.nhrs_om_jobgrade_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_om_jobgrade where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_om_jobgrade_cl(
            dataoriginflag -- 
            ,dr -- 
            ,jobgradecode -- 
            ,jobgradedesc -- 
            ,jobgradename -- 
            ,jobgradename2 -- 
            ,jobgradename3 -- 
            ,jobgradename4 -- 
            ,jobgradename5 -- 
            ,jobgradename6 -- 
            ,pk_job -- 
            ,pk_jobgrade -- 
            ,pk_jobrank -- 
            ,pk_jobtype -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_om_jobgrade_op(
            dataoriginflag -- 
            ,dr -- 
            ,jobgradecode -- 
            ,jobgradedesc -- 
            ,jobgradename -- 
            ,jobgradename2 -- 
            ,jobgradename3 -- 
            ,jobgradename4 -- 
            ,jobgradename5 -- 
            ,jobgradename6 -- 
            ,pk_job -- 
            ,pk_jobgrade -- 
            ,pk_jobrank -- 
            ,pk_jobtype -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 
    ,nvl(n.dr, o.dr) as dr -- 
    ,nvl(n.jobgradecode, o.jobgradecode) as jobgradecode -- 
    ,nvl(n.jobgradedesc, o.jobgradedesc) as jobgradedesc -- 
    ,nvl(n.jobgradename, o.jobgradename) as jobgradename -- 
    ,nvl(n.jobgradename2, o.jobgradename2) as jobgradename2 -- 
    ,nvl(n.jobgradename3, o.jobgradename3) as jobgradename3 -- 
    ,nvl(n.jobgradename4, o.jobgradename4) as jobgradename4 -- 
    ,nvl(n.jobgradename5, o.jobgradename5) as jobgradename5 -- 
    ,nvl(n.jobgradename6, o.jobgradename6) as jobgradename6 -- 
    ,nvl(n.pk_job, o.pk_job) as pk_job -- 
    ,nvl(n.pk_jobgrade, o.pk_jobgrade) as pk_jobgrade -- 
    ,nvl(n.pk_jobrank, o.pk_jobrank) as pk_jobrank -- 
    ,nvl(n.pk_jobtype, o.pk_jobtype) as pk_jobtype -- 
    ,nvl(n.ts, o.ts) as ts -- 
    ,case when
            n.pk_jobgrade is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_jobgrade is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_jobgrade is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_om_jobgrade_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_om_jobgrade where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_jobgrade = n.pk_jobgrade
where (
        o.pk_jobgrade is null
    )
    or (
        n.pk_jobgrade is null
    )
    or (
        o.dataoriginflag <> n.dataoriginflag
        or o.dr <> n.dr
        or o.jobgradecode <> n.jobgradecode
        or o.jobgradedesc <> n.jobgradedesc
        or o.jobgradename <> n.jobgradename
        or o.jobgradename2 <> n.jobgradename2
        or o.jobgradename3 <> n.jobgradename3
        or o.jobgradename4 <> n.jobgradename4
        or o.jobgradename5 <> n.jobgradename5
        or o.jobgradename6 <> n.jobgradename6
        or o.pk_job <> n.pk_job
        or o.pk_jobrank <> n.pk_jobrank
        or o.pk_jobtype <> n.pk_jobtype
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_om_jobgrade_cl(
            dataoriginflag -- 
            ,dr -- 
            ,jobgradecode -- 
            ,jobgradedesc -- 
            ,jobgradename -- 
            ,jobgradename2 -- 
            ,jobgradename3 -- 
            ,jobgradename4 -- 
            ,jobgradename5 -- 
            ,jobgradename6 -- 
            ,pk_job -- 
            ,pk_jobgrade -- 
            ,pk_jobrank -- 
            ,pk_jobtype -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_om_jobgrade_op(
            dataoriginflag -- 
            ,dr -- 
            ,jobgradecode -- 
            ,jobgradedesc -- 
            ,jobgradename -- 
            ,jobgradename2 -- 
            ,jobgradename3 -- 
            ,jobgradename4 -- 
            ,jobgradename5 -- 
            ,jobgradename6 -- 
            ,pk_job -- 
            ,pk_jobgrade -- 
            ,pk_jobrank -- 
            ,pk_jobtype -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.dataoriginflag -- 
    ,o.dr -- 
    ,o.jobgradecode -- 
    ,o.jobgradedesc -- 
    ,o.jobgradename -- 
    ,o.jobgradename2 -- 
    ,o.jobgradename3 -- 
    ,o.jobgradename4 -- 
    ,o.jobgradename5 -- 
    ,o.jobgradename6 -- 
    ,o.pk_job -- 
    ,o.pk_jobgrade -- 
    ,o.pk_jobrank -- 
    ,o.pk_jobtype -- 
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
from ${iol_schema}.nhrs_om_jobgrade_bk o
    left join ${iol_schema}.nhrs_om_jobgrade_op n
        on
            o.pk_jobgrade = n.pk_jobgrade
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_om_jobgrade_cl d
        on
            o.pk_jobgrade = d.pk_jobgrade
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_om_jobgrade;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_om_jobgrade') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_om_jobgrade drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_om_jobgrade add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_om_jobgrade exchange partition p_${batch_date} with table ${iol_schema}.nhrs_om_jobgrade_cl;
alter table ${iol_schema}.nhrs_om_jobgrade exchange partition p_20991231 with table ${iol_schema}.nhrs_om_jobgrade_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_om_jobgrade to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_om_jobgrade_op purge;
drop table ${iol_schema}.nhrs_om_jobgrade_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_om_jobgrade_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_om_jobgrade',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
