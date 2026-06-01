/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_tinstrument_inst_grade
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
create table ${iol_schema}.ibms_tinstrument_inst_grade_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_tinstrument_inst_grade
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tinstrument_inst_grade_op purge;
drop table ${iol_schema}.ibms_tinstrument_inst_grade_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tinstrument_inst_grade_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tinstrument_inst_grade where 0=1;

create table ${iol_schema}.ibms_tinstrument_inst_grade_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tinstrument_inst_grade where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tinstrument_inst_grade_cl(
            i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,rating_type -- 外部 1内部
            ,grade -- 
            ,pipe_id -- 
            ,imp_date -- 
            ,s_grade -- 
            ,rating_institution -- 
            ,inside_grade -- 内部评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tinstrument_inst_grade_op(
            i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,rating_type -- 外部 1内部
            ,grade -- 
            ,pipe_id -- 
            ,imp_date -- 
            ,s_grade -- 
            ,rating_institution -- 
            ,inside_grade -- 内部评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 
    ,nvl(n.a_type, o.a_type) as a_type -- 
    ,nvl(n.m_type, o.m_type) as m_type -- 
    ,nvl(n.rating_type, o.rating_type) as rating_type -- 外部 1内部
    ,nvl(n.grade, o.grade) as grade -- 
    ,nvl(n.pipe_id, o.pipe_id) as pipe_id -- 
    ,nvl(n.imp_date, o.imp_date) as imp_date -- 
    ,nvl(n.s_grade, o.s_grade) as s_grade -- 
    ,nvl(n.rating_institution, o.rating_institution) as rating_institution -- 
    ,nvl(n.inside_grade, o.inside_grade) as inside_grade -- 内部评级
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.rating_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.rating_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.rating_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_tinstrument_inst_grade_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_tinstrument_inst_grade where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.rating_type = n.rating_type
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
        and o.rating_type is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
        and n.rating_type is null
    )
    or (
        o.grade <> n.grade
        or o.pipe_id <> n.pipe_id
        or o.imp_date <> n.imp_date
        or o.s_grade <> n.s_grade
        or o.rating_institution <> n.rating_institution
        or o.inside_grade <> n.inside_grade
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tinstrument_inst_grade_cl(
            i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,rating_type -- 外部 1内部
            ,grade -- 
            ,pipe_id -- 
            ,imp_date -- 
            ,s_grade -- 
            ,rating_institution -- 
            ,inside_grade -- 内部评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tinstrument_inst_grade_op(
            i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,rating_type -- 外部 1内部
            ,grade -- 
            ,pipe_id -- 
            ,imp_date -- 
            ,s_grade -- 
            ,rating_institution -- 
            ,inside_grade -- 内部评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 
    ,o.a_type -- 
    ,o.m_type -- 
    ,o.rating_type -- 外部 1内部
    ,o.grade -- 
    ,o.pipe_id -- 
    ,o.imp_date -- 
    ,o.s_grade -- 
    ,o.rating_institution -- 
    ,o.inside_grade -- 内部评级
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
from ${iol_schema}.ibms_tinstrument_inst_grade_bk o
    left join ${iol_schema}.ibms_tinstrument_inst_grade_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.rating_type = n.rating_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_tinstrument_inst_grade_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
            and o.rating_type = d.rating_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_tinstrument_inst_grade;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_tinstrument_inst_grade') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_tinstrument_inst_grade drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_tinstrument_inst_grade add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_tinstrument_inst_grade exchange partition p_${batch_date} with table ${iol_schema}.ibms_tinstrument_inst_grade_cl;
alter table ${iol_schema}.ibms_tinstrument_inst_grade exchange partition p_20991231 with table ${iol_schema}.ibms_tinstrument_inst_grade_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_tinstrument_inst_grade to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tinstrument_inst_grade_op purge;
drop table ${iol_schema}.ibms_tinstrument_inst_grade_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_tinstrument_inst_grade_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_tinstrument_inst_grade',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
