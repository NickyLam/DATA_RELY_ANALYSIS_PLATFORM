/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_om_jobtype
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
create table ${iol_schema}.nhrs_om_jobtype_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_om_jobtype
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_om_jobtype_op purge;
drop table ${iol_schema}.nhrs_om_jobtype_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_om_jobtype_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_om_jobtype where 0=1;

create table ${iol_schema}.nhrs_om_jobtype_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_om_jobtype where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_om_jobtype_cl(
            creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,dr -- 
            ,enablestate -- 
            ,father_pk -- 
            ,innercode -- 
            ,jobtypecode -- 
            ,jobtypedesc -- 
            ,jobtypename -- 
            ,jobtypename2 -- 
            ,jobtypename3 -- 
            ,jobtypename4 -- 
            ,jobtypename5 -- 
            ,jobtypename6 -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,originaldocid -- 
            ,pk_grade_source -- 
            ,pk_group -- 
            ,pk_jobtype -- 
            ,pk_org -- 
            ,pvtjobgrade -- 
            ,redefineflag -- 
            ,ts -- 
            ,type_level -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_om_jobtype_op(
            creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,dr -- 
            ,enablestate -- 
            ,father_pk -- 
            ,innercode -- 
            ,jobtypecode -- 
            ,jobtypedesc -- 
            ,jobtypename -- 
            ,jobtypename2 -- 
            ,jobtypename3 -- 
            ,jobtypename4 -- 
            ,jobtypename5 -- 
            ,jobtypename6 -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,originaldocid -- 
            ,pk_grade_source -- 
            ,pk_group -- 
            ,pk_jobtype -- 
            ,pk_org -- 
            ,pvtjobgrade -- 
            ,redefineflag -- 
            ,ts -- 
            ,type_level -- 
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
    ,nvl(n.father_pk, o.father_pk) as father_pk -- 
    ,nvl(n.innercode, o.innercode) as innercode -- 
    ,nvl(n.jobtypecode, o.jobtypecode) as jobtypecode -- 
    ,nvl(n.jobtypedesc, o.jobtypedesc) as jobtypedesc -- 
    ,nvl(n.jobtypename, o.jobtypename) as jobtypename -- 
    ,nvl(n.jobtypename2, o.jobtypename2) as jobtypename2 -- 
    ,nvl(n.jobtypename3, o.jobtypename3) as jobtypename3 -- 
    ,nvl(n.jobtypename4, o.jobtypename4) as jobtypename4 -- 
    ,nvl(n.jobtypename5, o.jobtypename5) as jobtypename5 -- 
    ,nvl(n.jobtypename6, o.jobtypename6) as jobtypename6 -- 
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.originaldocid, o.originaldocid) as originaldocid -- 
    ,nvl(n.pk_grade_source, o.pk_grade_source) as pk_grade_source -- 
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 
    ,nvl(n.pk_jobtype, o.pk_jobtype) as pk_jobtype -- 
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 
    ,nvl(n.pvtjobgrade, o.pvtjobgrade) as pvtjobgrade -- 
    ,nvl(n.redefineflag, o.redefineflag) as redefineflag -- 
    ,nvl(n.ts, o.ts) as ts -- 
    ,nvl(n.type_level, o.type_level) as type_level -- 
    ,case when
            n.pk_jobtype is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_jobtype is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_jobtype is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_om_jobtype_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_om_jobtype where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_jobtype = n.pk_jobtype
where (
        o.pk_jobtype is null
    )
    or (
        n.pk_jobtype is null
    )
    or (
        o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.dr <> n.dr
        or o.enablestate <> n.enablestate
        or o.father_pk <> n.father_pk
        or o.innercode <> n.innercode
        or o.jobtypecode <> n.jobtypecode
        or o.jobtypedesc <> n.jobtypedesc
        or o.jobtypename <> n.jobtypename
        or o.jobtypename2 <> n.jobtypename2
        or o.jobtypename3 <> n.jobtypename3
        or o.jobtypename4 <> n.jobtypename4
        or o.jobtypename5 <> n.jobtypename5
        or o.jobtypename6 <> n.jobtypename6
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.originaldocid <> n.originaldocid
        or o.pk_grade_source <> n.pk_grade_source
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pvtjobgrade <> n.pvtjobgrade
        or o.redefineflag <> n.redefineflag
        or o.ts <> n.ts
        or o.type_level <> n.type_level
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_om_jobtype_cl(
            creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,dr -- 
            ,enablestate -- 
            ,father_pk -- 
            ,innercode -- 
            ,jobtypecode -- 
            ,jobtypedesc -- 
            ,jobtypename -- 
            ,jobtypename2 -- 
            ,jobtypename3 -- 
            ,jobtypename4 -- 
            ,jobtypename5 -- 
            ,jobtypename6 -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,originaldocid -- 
            ,pk_grade_source -- 
            ,pk_group -- 
            ,pk_jobtype -- 
            ,pk_org -- 
            ,pvtjobgrade -- 
            ,redefineflag -- 
            ,ts -- 
            ,type_level -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_om_jobtype_op(
            creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,dr -- 
            ,enablestate -- 
            ,father_pk -- 
            ,innercode -- 
            ,jobtypecode -- 
            ,jobtypedesc -- 
            ,jobtypename -- 
            ,jobtypename2 -- 
            ,jobtypename3 -- 
            ,jobtypename4 -- 
            ,jobtypename5 -- 
            ,jobtypename6 -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,originaldocid -- 
            ,pk_grade_source -- 
            ,pk_group -- 
            ,pk_jobtype -- 
            ,pk_org -- 
            ,pvtjobgrade -- 
            ,redefineflag -- 
            ,ts -- 
            ,type_level -- 
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
    ,o.father_pk -- 
    ,o.innercode -- 
    ,o.jobtypecode -- 
    ,o.jobtypedesc -- 
    ,o.jobtypename -- 
    ,o.jobtypename2 -- 
    ,o.jobtypename3 -- 
    ,o.jobtypename4 -- 
    ,o.jobtypename5 -- 
    ,o.jobtypename6 -- 
    ,o.modifiedtime -- 
    ,o.modifier -- 
    ,o.originaldocid -- 
    ,o.pk_grade_source -- 
    ,o.pk_group -- 
    ,o.pk_jobtype -- 
    ,o.pk_org -- 
    ,o.pvtjobgrade -- 
    ,o.redefineflag -- 
    ,o.ts -- 
    ,o.type_level -- 
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
from ${iol_schema}.nhrs_om_jobtype_bk o
    left join ${iol_schema}.nhrs_om_jobtype_op n
        on
            o.pk_jobtype = n.pk_jobtype
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_om_jobtype_cl d
        on
            o.pk_jobtype = d.pk_jobtype
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_om_jobtype;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_om_jobtype') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_om_jobtype drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_om_jobtype add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_om_jobtype exchange partition p_${batch_date} with table ${iol_schema}.nhrs_om_jobtype_cl;
alter table ${iol_schema}.nhrs_om_jobtype exchange partition p_20991231 with table ${iol_schema}.nhrs_om_jobtype_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_om_jobtype to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_om_jobtype_op purge;
drop table ${iol_schema}.nhrs_om_jobtype_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_om_jobtype_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_om_jobtype',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
