/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_risk_grade_ratio
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
create table ${iol_schema}.ibms_ttrd_risk_grade_ratio_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_risk_grade_ratio
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_risk_grade_ratio_op purge;
drop table ${iol_schema}.ibms_ttrd_risk_grade_ratio_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_risk_grade_ratio_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_risk_grade_ratio where 0=1;

create table ${iol_schema}.ibms_ttrd_risk_grade_ratio_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_risk_grade_ratio where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_risk_grade_ratio_cl(
            id -- 主键
            ,risk_detail -- 资产信息
            ,parent_id -- 所属分类id
            ,is_default_grade -- 评级是否只读
            ,style_level -- 1-加粗2-空一格3-空2哥
            ,check_level -- 0-无控制1-控制子节点小于父节点2-控制子节点和为100
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_risk_grade_ratio_op(
            id -- 主键
            ,risk_detail -- 资产信息
            ,parent_id -- 所属分类id
            ,is_default_grade -- 评级是否只读
            ,style_level -- 1-加粗2-空一格3-空2哥
            ,check_level -- 0-无控制1-控制子节点小于父节点2-控制子节点和为100
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.risk_detail, o.risk_detail) as risk_detail -- 资产信息
    ,nvl(n.parent_id, o.parent_id) as parent_id -- 所属分类id
    ,nvl(n.is_default_grade, o.is_default_grade) as is_default_grade -- 评级是否只读
    ,nvl(n.style_level, o.style_level) as style_level -- 1-加粗2-空一格3-空2哥
    ,nvl(n.check_level, o.check_level) as check_level -- 0-无控制1-控制子节点小于父节点2-控制子节点和为100
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
from (select * from ${iol_schema}.ibms_ttrd_risk_grade_ratio_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_risk_grade_ratio where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.risk_detail <> n.risk_detail
        or o.parent_id <> n.parent_id
        or o.is_default_grade <> n.is_default_grade
        or o.style_level <> n.style_level
        or o.check_level <> n.check_level
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_risk_grade_ratio_cl(
            id -- 主键
            ,risk_detail -- 资产信息
            ,parent_id -- 所属分类id
            ,is_default_grade -- 评级是否只读
            ,style_level -- 1-加粗2-空一格3-空2哥
            ,check_level -- 0-无控制1-控制子节点小于父节点2-控制子节点和为100
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_risk_grade_ratio_op(
            id -- 主键
            ,risk_detail -- 资产信息
            ,parent_id -- 所属分类id
            ,is_default_grade -- 评级是否只读
            ,style_level -- 1-加粗2-空一格3-空2哥
            ,check_level -- 0-无控制1-控制子节点小于父节点2-控制子节点和为100
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.risk_detail -- 资产信息
    ,o.parent_id -- 所属分类id
    ,o.is_default_grade -- 评级是否只读
    ,o.style_level -- 1-加粗2-空一格3-空2哥
    ,o.check_level -- 0-无控制1-控制子节点小于父节点2-控制子节点和为100
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
from ${iol_schema}.ibms_ttrd_risk_grade_ratio_bk o
    left join ${iol_schema}.ibms_ttrd_risk_grade_ratio_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_risk_grade_ratio_cl d
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
--truncate table ${iol_schema}.ibms_ttrd_risk_grade_ratio;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_risk_grade_ratio') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_risk_grade_ratio drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_risk_grade_ratio add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_risk_grade_ratio exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_risk_grade_ratio_cl;
alter table ${iol_schema}.ibms_ttrd_risk_grade_ratio exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_risk_grade_ratio_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_risk_grade_ratio to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_risk_grade_ratio_op purge;
drop table ${iol_schema}.ibms_ttrd_risk_grade_ratio_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_risk_grade_ratio_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_risk_grade_ratio',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
