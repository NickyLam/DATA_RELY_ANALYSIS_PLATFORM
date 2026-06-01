/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_om_job
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
create table ${iol_schema}.nhrs_om_job_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_om_job
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_om_job_op purge;
drop table ${iol_schema}.nhrs_om_job_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_om_job_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_om_job where 0=1;

create table ${iol_schema}.nhrs_om_job_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_om_job where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_om_job_cl(
            creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,defaultjobrank -- 
            ,dr -- 
            ,enablestate -- 
            ,jobcode -- 
            ,jobdesc -- 
            ,jobname -- 
            ,jobname2 -- 
            ,jobname3 -- 
            ,jobname4 -- 
            ,jobname5 -- 
            ,jobname6 -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,originaldocid -- 
            ,pk_grade_source -- 
            ,pk_group -- 
            ,pk_job -- 
            ,pk_jobtype -- 
            ,pk_org -- 
            ,pvtjobgrade -- 
            ,redefineflag -- 
            ,reqedu -- 
            ,reqexp -- 
            ,reqother -- 
            ,reqpro -- 
            ,reqsex -- 
            ,reqtlimit -- 
            ,reqyold -- 
            ,ts -- 
            ,pk_jobrank -- 
            ,glbdef1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_om_job_op(
            creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,defaultjobrank -- 
            ,dr -- 
            ,enablestate -- 
            ,jobcode -- 
            ,jobdesc -- 
            ,jobname -- 
            ,jobname2 -- 
            ,jobname3 -- 
            ,jobname4 -- 
            ,jobname5 -- 
            ,jobname6 -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,originaldocid -- 
            ,pk_grade_source -- 
            ,pk_group -- 
            ,pk_job -- 
            ,pk_jobtype -- 
            ,pk_org -- 
            ,pvtjobgrade -- 
            ,redefineflag -- 
            ,reqedu -- 
            ,reqexp -- 
            ,reqother -- 
            ,reqpro -- 
            ,reqsex -- 
            ,reqtlimit -- 
            ,reqyold -- 
            ,ts -- 
            ,pk_jobrank -- 
            ,glbdef1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.creationtime, o.creationtime) as creationtime -- 
    ,nvl(n.creator, o.creator) as creator -- 
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 
    ,nvl(n.defaultjobrank, o.defaultjobrank) as defaultjobrank -- 
    ,nvl(n.dr, o.dr) as dr -- 
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 
    ,nvl(n.jobcode, o.jobcode) as jobcode -- 
    ,nvl(n.jobdesc, o.jobdesc) as jobdesc -- 
    ,nvl(n.jobname, o.jobname) as jobname -- 
    ,nvl(n.jobname2, o.jobname2) as jobname2 -- 
    ,nvl(n.jobname3, o.jobname3) as jobname3 -- 
    ,nvl(n.jobname4, o.jobname4) as jobname4 -- 
    ,nvl(n.jobname5, o.jobname5) as jobname5 -- 
    ,nvl(n.jobname6, o.jobname6) as jobname6 -- 
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.originaldocid, o.originaldocid) as originaldocid -- 
    ,nvl(n.pk_grade_source, o.pk_grade_source) as pk_grade_source -- 
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 
    ,nvl(n.pk_job, o.pk_job) as pk_job -- 
    ,nvl(n.pk_jobtype, o.pk_jobtype) as pk_jobtype -- 
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 
    ,nvl(n.pvtjobgrade, o.pvtjobgrade) as pvtjobgrade -- 
    ,nvl(n.redefineflag, o.redefineflag) as redefineflag -- 
    ,nvl(n.reqedu, o.reqedu) as reqedu -- 
    ,nvl(n.reqexp, o.reqexp) as reqexp -- 
    ,nvl(n.reqother, o.reqother) as reqother -- 
    ,nvl(n.reqpro, o.reqpro) as reqpro -- 
    ,nvl(n.reqsex, o.reqsex) as reqsex -- 
    ,nvl(n.reqtlimit, o.reqtlimit) as reqtlimit -- 
    ,nvl(n.reqyold, o.reqyold) as reqyold -- 
    ,nvl(n.ts, o.ts) as ts -- 
    ,nvl(n.pk_jobrank, o.pk_jobrank) as pk_jobrank -- 
    ,nvl(n.glbdef1, o.glbdef1) as glbdef1 -- 
    ,case when
            n.pk_job is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_job is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_job is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_om_job_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_om_job where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_job = n.pk_job
where (
        o.pk_job is null
    )
    or (
        n.pk_job is null
    )
    or (
        o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.defaultjobrank <> n.defaultjobrank
        or o.dr <> n.dr
        or o.enablestate <> n.enablestate
        or o.jobcode <> n.jobcode
        or o.jobdesc <> n.jobdesc
        or o.jobname <> n.jobname
        or o.jobname2 <> n.jobname2
        or o.jobname3 <> n.jobname3
        or o.jobname4 <> n.jobname4
        or o.jobname5 <> n.jobname5
        or o.jobname6 <> n.jobname6
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.originaldocid <> n.originaldocid
        or o.pk_grade_source <> n.pk_grade_source
        or o.pk_group <> n.pk_group
        or o.pk_jobtype <> n.pk_jobtype
        or o.pk_org <> n.pk_org
        or o.pvtjobgrade <> n.pvtjobgrade
        or o.redefineflag <> n.redefineflag
        or o.reqedu <> n.reqedu
        or o.reqexp <> n.reqexp
        or o.reqother <> n.reqother
        or o.reqpro <> n.reqpro
        or o.reqsex <> n.reqsex
        or o.reqtlimit <> n.reqtlimit
        or o.reqyold <> n.reqyold
        or o.ts <> n.ts
        or o.pk_jobrank <> n.pk_jobrank
        or o.glbdef1 <> n.glbdef1
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_om_job_cl(
            creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,defaultjobrank -- 
            ,dr -- 
            ,enablestate -- 
            ,jobcode -- 
            ,jobdesc -- 
            ,jobname -- 
            ,jobname2 -- 
            ,jobname3 -- 
            ,jobname4 -- 
            ,jobname5 -- 
            ,jobname6 -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,originaldocid -- 
            ,pk_grade_source -- 
            ,pk_group -- 
            ,pk_job -- 
            ,pk_jobtype -- 
            ,pk_org -- 
            ,pvtjobgrade -- 
            ,redefineflag -- 
            ,reqedu -- 
            ,reqexp -- 
            ,reqother -- 
            ,reqpro -- 
            ,reqsex -- 
            ,reqtlimit -- 
            ,reqyold -- 
            ,ts -- 
            ,pk_jobrank -- 
            ,glbdef1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_om_job_op(
            creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,defaultjobrank -- 
            ,dr -- 
            ,enablestate -- 
            ,jobcode -- 
            ,jobdesc -- 
            ,jobname -- 
            ,jobname2 -- 
            ,jobname3 -- 
            ,jobname4 -- 
            ,jobname5 -- 
            ,jobname6 -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,originaldocid -- 
            ,pk_grade_source -- 
            ,pk_group -- 
            ,pk_job -- 
            ,pk_jobtype -- 
            ,pk_org -- 
            ,pvtjobgrade -- 
            ,redefineflag -- 
            ,reqedu -- 
            ,reqexp -- 
            ,reqother -- 
            ,reqpro -- 
            ,reqsex -- 
            ,reqtlimit -- 
            ,reqyold -- 
            ,ts -- 
            ,pk_jobrank -- 
            ,glbdef1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.creationtime -- 
    ,o.creator -- 
    ,o.dataoriginflag -- 
    ,o.defaultjobrank -- 
    ,o.dr -- 
    ,o.enablestate -- 
    ,o.jobcode -- 
    ,o.jobdesc -- 
    ,o.jobname -- 
    ,o.jobname2 -- 
    ,o.jobname3 -- 
    ,o.jobname4 -- 
    ,o.jobname5 -- 
    ,o.jobname6 -- 
    ,o.modifiedtime -- 
    ,o.modifier -- 
    ,o.originaldocid -- 
    ,o.pk_grade_source -- 
    ,o.pk_group -- 
    ,o.pk_job -- 
    ,o.pk_jobtype -- 
    ,o.pk_org -- 
    ,o.pvtjobgrade -- 
    ,o.redefineflag -- 
    ,o.reqedu -- 
    ,o.reqexp -- 
    ,o.reqother -- 
    ,o.reqpro -- 
    ,o.reqsex -- 
    ,o.reqtlimit -- 
    ,o.reqyold -- 
    ,o.ts -- 
    ,o.pk_jobrank -- 
    ,o.glbdef1 -- 
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
from ${iol_schema}.nhrs_om_job_bk o
    left join ${iol_schema}.nhrs_om_job_op n
        on
            o.pk_job = n.pk_job
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_om_job_cl d
        on
            o.pk_job = d.pk_job
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_om_job;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_om_job') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_om_job drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_om_job add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_om_job exchange partition p_${batch_date} with table ${iol_schema}.nhrs_om_job_cl;
alter table ${iol_schema}.nhrs_om_job exchange partition p_20991231 with table ${iol_schema}.nhrs_om_job_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_om_job to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_om_job_op purge;
drop table ${iol_schema}.nhrs_om_job_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_om_job_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_om_job',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
