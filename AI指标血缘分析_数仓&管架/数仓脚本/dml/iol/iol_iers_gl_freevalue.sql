/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_gl_freevalue
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
create table ${iol_schema}.iers_gl_freevalue_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_gl_freevalue
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_gl_freevalue_op purge;
drop table ${iol_schema}.iers_gl_freevalue_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_gl_freevalue_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_gl_freevalue where 0=1;

create table ${iol_schema}.iers_gl_freevalue_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_gl_freevalue where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_gl_freevalue_cl(
            dr -- 删除标志
            ,freevalueid -- 辅助核算id
            ,pk_group -- 集团
            ,ts -- 时间戳
            ,typevalue1 -- 自定义
            ,typevalue2 -- 自定义
            ,typevalue3 -- 自定义
            ,typevalue4 -- 自定义
            ,typevalue5 -- 自定义
            ,typevalue6 -- 自定义
            ,typevalue7 -- 自定义
            ,typevalue8 -- 自定义
            ,typevalue9 -- 自定义
            ,typevaluemd5 -- 自定义
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_gl_freevalue_op(
            dr -- 删除标志
            ,freevalueid -- 辅助核算id
            ,pk_group -- 集团
            ,ts -- 时间戳
            ,typevalue1 -- 自定义
            ,typevalue2 -- 自定义
            ,typevalue3 -- 自定义
            ,typevalue4 -- 自定义
            ,typevalue5 -- 自定义
            ,typevalue6 -- 自定义
            ,typevalue7 -- 自定义
            ,typevalue8 -- 自定义
            ,typevalue9 -- 自定义
            ,typevaluemd5 -- 自定义
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.freevalueid, o.freevalueid) as freevalueid -- 辅助核算id
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 集团
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.typevalue1, o.typevalue1) as typevalue1 -- 自定义
    ,nvl(n.typevalue2, o.typevalue2) as typevalue2 -- 自定义
    ,nvl(n.typevalue3, o.typevalue3) as typevalue3 -- 自定义
    ,nvl(n.typevalue4, o.typevalue4) as typevalue4 -- 自定义
    ,nvl(n.typevalue5, o.typevalue5) as typevalue5 -- 自定义
    ,nvl(n.typevalue6, o.typevalue6) as typevalue6 -- 自定义
    ,nvl(n.typevalue7, o.typevalue7) as typevalue7 -- 自定义
    ,nvl(n.typevalue8, o.typevalue8) as typevalue8 -- 自定义
    ,nvl(n.typevalue9, o.typevalue9) as typevalue9 -- 自定义
    ,nvl(n.typevaluemd5, o.typevaluemd5) as typevaluemd5 -- 自定义
    ,case when
            n.freevalueid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.freevalueid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.freevalueid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_gl_freevalue_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_gl_freevalue where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.freevalueid = n.freevalueid
where (
        o.freevalueid is null
    )
    or (
        n.freevalueid is null
    )
    or (
        o.dr <> n.dr
        or o.pk_group <> n.pk_group
        or o.ts <> n.ts
        or o.typevalue1 <> n.typevalue1
        or o.typevalue2 <> n.typevalue2
        or o.typevalue3 <> n.typevalue3
        or o.typevalue4 <> n.typevalue4
        or o.typevalue5 <> n.typevalue5
        or o.typevalue6 <> n.typevalue6
        or o.typevalue7 <> n.typevalue7
        or o.typevalue8 <> n.typevalue8
        or o.typevalue9 <> n.typevalue9
        or o.typevaluemd5 <> n.typevaluemd5
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_gl_freevalue_cl(
            dr -- 删除标志
            ,freevalueid -- 辅助核算id
            ,pk_group -- 集团
            ,ts -- 时间戳
            ,typevalue1 -- 自定义
            ,typevalue2 -- 自定义
            ,typevalue3 -- 自定义
            ,typevalue4 -- 自定义
            ,typevalue5 -- 自定义
            ,typevalue6 -- 自定义
            ,typevalue7 -- 自定义
            ,typevalue8 -- 自定义
            ,typevalue9 -- 自定义
            ,typevaluemd5 -- 自定义
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_gl_freevalue_op(
            dr -- 删除标志
            ,freevalueid -- 辅助核算id
            ,pk_group -- 集团
            ,ts -- 时间戳
            ,typevalue1 -- 自定义
            ,typevalue2 -- 自定义
            ,typevalue3 -- 自定义
            ,typevalue4 -- 自定义
            ,typevalue5 -- 自定义
            ,typevalue6 -- 自定义
            ,typevalue7 -- 自定义
            ,typevalue8 -- 自定义
            ,typevalue9 -- 自定义
            ,typevaluemd5 -- 自定义
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.dr -- 删除标志
    ,o.freevalueid -- 辅助核算id
    ,o.pk_group -- 集团
    ,o.ts -- 时间戳
    ,o.typevalue1 -- 自定义
    ,o.typevalue2 -- 自定义
    ,o.typevalue3 -- 自定义
    ,o.typevalue4 -- 自定义
    ,o.typevalue5 -- 自定义
    ,o.typevalue6 -- 自定义
    ,o.typevalue7 -- 自定义
    ,o.typevalue8 -- 自定义
    ,o.typevalue9 -- 自定义
    ,o.typevaluemd5 -- 自定义
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
from ${iol_schema}.iers_gl_freevalue_bk o
    left join ${iol_schema}.iers_gl_freevalue_op n
        on
            o.freevalueid = n.freevalueid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_gl_freevalue_cl d
        on
            o.freevalueid = d.freevalueid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_gl_freevalue;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_gl_freevalue') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_gl_freevalue drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_gl_freevalue add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_gl_freevalue exchange partition p_${batch_date} with table ${iol_schema}.iers_gl_freevalue_cl;
alter table ${iol_schema}.iers_gl_freevalue exchange partition p_20991231 with table ${iol_schema}.iers_gl_freevalue_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_gl_freevalue to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_gl_freevalue_op purge;
drop table ${iol_schema}.iers_gl_freevalue_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_gl_freevalue_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_gl_freevalue',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
