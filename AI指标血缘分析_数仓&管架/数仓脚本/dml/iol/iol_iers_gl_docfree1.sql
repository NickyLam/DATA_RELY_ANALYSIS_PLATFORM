/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_gl_docfree1
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
create table ${iol_schema}.iers_gl_docfree1_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_gl_docfree1
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_gl_docfree1_op purge;
drop table ${iol_schema}.iers_gl_docfree1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_gl_docfree1_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_gl_docfree1 where 0=1;

create table ${iol_schema}.iers_gl_docfree1_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_gl_docfree1 where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_gl_docfree1_cl(
            assid -- 
            ,dr -- 
            ,f1 -- 
            ,f10 -- 
            ,f11 -- 
            ,f12 -- 
            ,f13 -- 
            ,f14 -- 
            ,f15 -- 
            ,f16 -- 
            ,f17 -- 
            ,f18 -- 
            ,f19 -- 
            ,f2 -- 
            ,f20 -- 
            ,f21 -- 
            ,f22 -- 
            ,f23 -- 
            ,f24 -- 
            ,f25 -- 
            ,f26 -- 
            ,f27 -- 
            ,f28 -- 
            ,f29 -- 
            ,f3 -- 
            ,f30 -- 
            ,f4 -- 
            ,f5 -- 
            ,f6 -- 
            ,f7 -- 
            ,f8 -- 
            ,f9 -- 
            ,pk_group -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_gl_docfree1_op(
            assid -- 
            ,dr -- 
            ,f1 -- 
            ,f10 -- 
            ,f11 -- 
            ,f12 -- 
            ,f13 -- 
            ,f14 -- 
            ,f15 -- 
            ,f16 -- 
            ,f17 -- 
            ,f18 -- 
            ,f19 -- 
            ,f2 -- 
            ,f20 -- 
            ,f21 -- 
            ,f22 -- 
            ,f23 -- 
            ,f24 -- 
            ,f25 -- 
            ,f26 -- 
            ,f27 -- 
            ,f28 -- 
            ,f29 -- 
            ,f3 -- 
            ,f30 -- 
            ,f4 -- 
            ,f5 -- 
            ,f6 -- 
            ,f7 -- 
            ,f8 -- 
            ,f9 -- 
            ,pk_group -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.assid, o.assid) as assid -- 
    ,nvl(n.dr, o.dr) as dr -- 
    ,nvl(n.f1, o.f1) as f1 -- 
    ,nvl(n.f10, o.f10) as f10 -- 
    ,nvl(n.f11, o.f11) as f11 -- 
    ,nvl(n.f12, o.f12) as f12 -- 
    ,nvl(n.f13, o.f13) as f13 -- 
    ,nvl(n.f14, o.f14) as f14 -- 
    ,nvl(n.f15, o.f15) as f15 -- 
    ,nvl(n.f16, o.f16) as f16 -- 
    ,nvl(n.f17, o.f17) as f17 -- 
    ,nvl(n.f18, o.f18) as f18 -- 
    ,nvl(n.f19, o.f19) as f19 -- 
    ,nvl(n.f2, o.f2) as f2 -- 
    ,nvl(n.f20, o.f20) as f20 -- 
    ,nvl(n.f21, o.f21) as f21 -- 
    ,nvl(n.f22, o.f22) as f22 -- 
    ,nvl(n.f23, o.f23) as f23 -- 
    ,nvl(n.f24, o.f24) as f24 -- 
    ,nvl(n.f25, o.f25) as f25 -- 
    ,nvl(n.f26, o.f26) as f26 -- 
    ,nvl(n.f27, o.f27) as f27 -- 
    ,nvl(n.f28, o.f28) as f28 -- 
    ,nvl(n.f29, o.f29) as f29 -- 
    ,nvl(n.f3, o.f3) as f3 -- 
    ,nvl(n.f30, o.f30) as f30 -- 
    ,nvl(n.f4, o.f4) as f4 -- 
    ,nvl(n.f5, o.f5) as f5 -- 
    ,nvl(n.f6, o.f6) as f6 -- 
    ,nvl(n.f7, o.f7) as f7 -- 
    ,nvl(n.f8, o.f8) as f8 -- 
    ,nvl(n.f9, o.f9) as f9 -- 
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 
    ,nvl(n.ts, o.ts) as ts -- 
    ,case when
            n.assid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.assid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.assid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_gl_docfree1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_gl_docfree1 where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.assid = n.assid
where (
        o.assid is null
    )
    or (
        n.assid is null
    )
    or (
        o.dr <> n.dr
        or o.f1 <> n.f1
        or o.f10 <> n.f10
        or o.f11 <> n.f11
        or o.f12 <> n.f12
        or o.f13 <> n.f13
        or o.f14 <> n.f14
        or o.f15 <> n.f15
        or o.f16 <> n.f16
        or o.f17 <> n.f17
        or o.f18 <> n.f18
        or o.f19 <> n.f19
        or o.f2 <> n.f2
        or o.f20 <> n.f20
        or o.f21 <> n.f21
        or o.f22 <> n.f22
        or o.f23 <> n.f23
        or o.f24 <> n.f24
        or o.f25 <> n.f25
        or o.f26 <> n.f26
        or o.f27 <> n.f27
        or o.f28 <> n.f28
        or o.f29 <> n.f29
        or o.f3 <> n.f3
        or o.f30 <> n.f30
        or o.f4 <> n.f4
        or o.f5 <> n.f5
        or o.f6 <> n.f6
        or o.f7 <> n.f7
        or o.f8 <> n.f8
        or o.f9 <> n.f9
        or o.pk_group <> n.pk_group
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_gl_docfree1_cl(
            assid -- 
            ,dr -- 
            ,f1 -- 
            ,f10 -- 
            ,f11 -- 
            ,f12 -- 
            ,f13 -- 
            ,f14 -- 
            ,f15 -- 
            ,f16 -- 
            ,f17 -- 
            ,f18 -- 
            ,f19 -- 
            ,f2 -- 
            ,f20 -- 
            ,f21 -- 
            ,f22 -- 
            ,f23 -- 
            ,f24 -- 
            ,f25 -- 
            ,f26 -- 
            ,f27 -- 
            ,f28 -- 
            ,f29 -- 
            ,f3 -- 
            ,f30 -- 
            ,f4 -- 
            ,f5 -- 
            ,f6 -- 
            ,f7 -- 
            ,f8 -- 
            ,f9 -- 
            ,pk_group -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_gl_docfree1_op(
            assid -- 
            ,dr -- 
            ,f1 -- 
            ,f10 -- 
            ,f11 -- 
            ,f12 -- 
            ,f13 -- 
            ,f14 -- 
            ,f15 -- 
            ,f16 -- 
            ,f17 -- 
            ,f18 -- 
            ,f19 -- 
            ,f2 -- 
            ,f20 -- 
            ,f21 -- 
            ,f22 -- 
            ,f23 -- 
            ,f24 -- 
            ,f25 -- 
            ,f26 -- 
            ,f27 -- 
            ,f28 -- 
            ,f29 -- 
            ,f3 -- 
            ,f30 -- 
            ,f4 -- 
            ,f5 -- 
            ,f6 -- 
            ,f7 -- 
            ,f8 -- 
            ,f9 -- 
            ,pk_group -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.assid -- 
    ,o.dr -- 
    ,o.f1 -- 
    ,o.f10 -- 
    ,o.f11 -- 
    ,o.f12 -- 
    ,o.f13 -- 
    ,o.f14 -- 
    ,o.f15 -- 
    ,o.f16 -- 
    ,o.f17 -- 
    ,o.f18 -- 
    ,o.f19 -- 
    ,o.f2 -- 
    ,o.f20 -- 
    ,o.f21 -- 
    ,o.f22 -- 
    ,o.f23 -- 
    ,o.f24 -- 
    ,o.f25 -- 
    ,o.f26 -- 
    ,o.f27 -- 
    ,o.f28 -- 
    ,o.f29 -- 
    ,o.f3 -- 
    ,o.f30 -- 
    ,o.f4 -- 
    ,o.f5 -- 
    ,o.f6 -- 
    ,o.f7 -- 
    ,o.f8 -- 
    ,o.f9 -- 
    ,o.pk_group -- 
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
from ${iol_schema}.iers_gl_docfree1_bk o
    left join ${iol_schema}.iers_gl_docfree1_op n
        on
            o.assid = n.assid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_gl_docfree1_cl d
        on
            o.assid = d.assid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_gl_docfree1;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_gl_docfree1') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_gl_docfree1 drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_gl_docfree1 add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_gl_docfree1 exchange partition p_${batch_date} with table ${iol_schema}.iers_gl_docfree1_cl;
alter table ${iol_schema}.iers_gl_docfree1 exchange partition p_20991231 with table ${iol_schema}.iers_gl_docfree1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_gl_docfree1 to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_gl_docfree1_op purge;
drop table ${iol_schema}.iers_gl_docfree1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_gl_docfree1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_gl_docfree1',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
