/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orws_t_emp_edu_resume
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
create table ${iol_schema}.orws_t_emp_edu_resume_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orws_t_emp_edu_resume
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_t_emp_edu_resume_op purge;
drop table ${iol_schema}.orws_t_emp_edu_resume_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_emp_edu_resume_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_t_emp_edu_resume where 0=1;

create table ${iol_schema}.orws_t_emp_edu_resume_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_t_emp_edu_resume where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_t_emp_edu_resume_cl(
            id -- 
            ,emp_info -- 
            ,begin_date -- 
            ,end_date -- 
            ,university -- 
            ,profession -- 
            ,academic -- 
            ,degree -- 
            ,is_fulltime -- 
            ,creator -- 
            ,editor -- 
            ,create_time -- 
            ,edit_time -- 
            ,is_economics -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_t_emp_edu_resume_op(
            id -- 
            ,emp_info -- 
            ,begin_date -- 
            ,end_date -- 
            ,university -- 
            ,profession -- 
            ,academic -- 
            ,degree -- 
            ,is_fulltime -- 
            ,creator -- 
            ,editor -- 
            ,create_time -- 
            ,edit_time -- 
            ,is_economics -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.emp_info, o.emp_info) as emp_info -- 
    ,nvl(n.begin_date, o.begin_date) as begin_date -- 
    ,nvl(n.end_date, o.end_date) as end_date -- 
    ,nvl(n.university, o.university) as university -- 
    ,nvl(n.profession, o.profession) as profession -- 
    ,nvl(n.academic, o.academic) as academic -- 
    ,nvl(n.degree, o.degree) as degree -- 
    ,nvl(n.is_fulltime, o.is_fulltime) as is_fulltime -- 
    ,nvl(n.creator, o.creator) as creator -- 
    ,nvl(n.editor, o.editor) as editor -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.edit_time, o.edit_time) as edit_time -- 
    ,nvl(n.is_economics, o.is_economics) as is_economics -- 
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.orws_t_emp_edu_resume_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orws_t_emp_edu_resume where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.emp_info <> n.emp_info
        or o.begin_date <> n.begin_date
        or o.end_date <> n.end_date
        or o.university <> n.university
        or o.profession <> n.profession
        or o.academic <> n.academic
        or o.degree <> n.degree
        or o.is_fulltime <> n.is_fulltime
        or o.creator <> n.creator
        or o.editor <> n.editor
        or o.create_time <> n.create_time
        or o.edit_time <> n.edit_time
        or o.is_economics <> n.is_economics
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_t_emp_edu_resume_cl(
            id -- 
            ,emp_info -- 
            ,begin_date -- 
            ,end_date -- 
            ,university -- 
            ,profession -- 
            ,academic -- 
            ,degree -- 
            ,is_fulltime -- 
            ,creator -- 
            ,editor -- 
            ,create_time -- 
            ,edit_time -- 
            ,is_economics -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_t_emp_edu_resume_op(
            id -- 
            ,emp_info -- 
            ,begin_date -- 
            ,end_date -- 
            ,university -- 
            ,profession -- 
            ,academic -- 
            ,degree -- 
            ,is_fulltime -- 
            ,creator -- 
            ,editor -- 
            ,create_time -- 
            ,edit_time -- 
            ,is_economics -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.emp_info -- 
    ,o.begin_date -- 
    ,o.end_date -- 
    ,o.university -- 
    ,o.profession -- 
    ,o.academic -- 
    ,o.degree -- 
    ,o.is_fulltime -- 
    ,o.creator -- 
    ,o.editor -- 
    ,o.create_time -- 
    ,o.edit_time -- 
    ,o.is_economics -- 
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
from ${iol_schema}.orws_t_emp_edu_resume_bk o
    left join ${iol_schema}.orws_t_emp_edu_resume_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orws_t_emp_edu_resume_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.orws_t_emp_edu_resume;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('orws_t_emp_edu_resume') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.orws_t_emp_edu_resume drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.orws_t_emp_edu_resume add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.orws_t_emp_edu_resume exchange partition p_${batch_date} with table ${iol_schema}.orws_t_emp_edu_resume_cl;
alter table ${iol_schema}.orws_t_emp_edu_resume exchange partition p_20991231 with table ${iol_schema}.orws_t_emp_edu_resume_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orws_t_emp_edu_resume to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_t_emp_edu_resume_op purge;
drop table ${iol_schema}.orws_t_emp_edu_resume_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orws_t_emp_edu_resume_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orws_t_emp_edu_resume',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
