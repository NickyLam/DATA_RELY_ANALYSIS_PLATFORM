/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_creditqualify
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
create table ${iol_schema}.mims_si_creditqualify_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_creditqualify
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_creditqualify_op purge;
drop table ${iol_schema}.mims_si_creditqualify_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_creditqualify_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_creditqualify where 0=1;

create table ${iol_schema}.mims_si_creditqualify_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_creditqualify where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_creditqualify_cl(
            sccode -- 
            ,applycode -- 
            ,isrelation -- 
            ,isworkable -- 
            ,guarrelation -- 
            ,guarresult -- 
            ,qztypeishg -- 
            ,qzishgtools -- 
            ,qzhgtoolstype -- 
            ,nptypeishg -- 
            ,npishgtools -- 
            ,nphgtoolstype -- 
            ,guarmoney -- 
            ,guarrate -- 
            ,bzguarmethod -- 
            ,bzmethod -- 
            ,guarcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_creditqualify_op(
            sccode -- 
            ,applycode -- 
            ,isrelation -- 
            ,isworkable -- 
            ,guarrelation -- 
            ,guarresult -- 
            ,qztypeishg -- 
            ,qzishgtools -- 
            ,qzhgtoolstype -- 
            ,nptypeishg -- 
            ,npishgtools -- 
            ,nphgtoolstype -- 
            ,guarmoney -- 
            ,guarrate -- 
            ,bzguarmethod -- 
            ,bzmethod -- 
            ,guarcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.applycode, o.applycode) as applycode -- 
    ,nvl(n.isrelation, o.isrelation) as isrelation -- 
    ,nvl(n.isworkable, o.isworkable) as isworkable -- 
    ,nvl(n.guarrelation, o.guarrelation) as guarrelation -- 
    ,nvl(n.guarresult, o.guarresult) as guarresult -- 
    ,nvl(n.qztypeishg, o.qztypeishg) as qztypeishg -- 
    ,nvl(n.qzishgtools, o.qzishgtools) as qzishgtools -- 
    ,nvl(n.qzhgtoolstype, o.qzhgtoolstype) as qzhgtoolstype -- 
    ,nvl(n.nptypeishg, o.nptypeishg) as nptypeishg -- 
    ,nvl(n.npishgtools, o.npishgtools) as npishgtools -- 
    ,nvl(n.nphgtoolstype, o.nphgtoolstype) as nphgtoolstype -- 
    ,nvl(n.guarmoney, o.guarmoney) as guarmoney -- 
    ,nvl(n.guarrate, o.guarrate) as guarrate -- 
    ,nvl(n.bzguarmethod, o.bzguarmethod) as bzguarmethod -- 
    ,nvl(n.bzmethod, o.bzmethod) as bzmethod -- 
    ,nvl(n.guarcurrency, o.guarcurrency) as guarcurrency -- 
    ,case when
            n.sccode is null
            and n.applycode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
            and n.applycode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
            and n.applycode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_creditqualify_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_creditqualify where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
            and o.applycode = n.applycode
where (
        o.sccode is null
        and o.applycode is null
    )
    or (
        n.sccode is null
        and n.applycode is null
    )
    or (
        o.isrelation <> n.isrelation
        or o.isworkable <> n.isworkable
        or o.guarrelation <> n.guarrelation
        or o.guarresult <> n.guarresult
        or o.qztypeishg <> n.qztypeishg
        or o.qzishgtools <> n.qzishgtools
        or o.qzhgtoolstype <> n.qzhgtoolstype
        or o.nptypeishg <> n.nptypeishg
        or o.npishgtools <> n.npishgtools
        or o.nphgtoolstype <> n.nphgtoolstype
        or o.guarmoney <> n.guarmoney
        or o.guarrate <> n.guarrate
        or o.bzguarmethod <> n.bzguarmethod
        or o.bzmethod <> n.bzmethod
        or o.guarcurrency <> n.guarcurrency
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_creditqualify_cl(
            sccode -- 
            ,applycode -- 
            ,isrelation -- 
            ,isworkable -- 
            ,guarrelation -- 
            ,guarresult -- 
            ,qztypeishg -- 
            ,qzishgtools -- 
            ,qzhgtoolstype -- 
            ,nptypeishg -- 
            ,npishgtools -- 
            ,nphgtoolstype -- 
            ,guarmoney -- 
            ,guarrate -- 
            ,bzguarmethod -- 
            ,bzmethod -- 
            ,guarcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_creditqualify_op(
            sccode -- 
            ,applycode -- 
            ,isrelation -- 
            ,isworkable -- 
            ,guarrelation -- 
            ,guarresult -- 
            ,qztypeishg -- 
            ,qzishgtools -- 
            ,qzhgtoolstype -- 
            ,nptypeishg -- 
            ,npishgtools -- 
            ,nphgtoolstype -- 
            ,guarmoney -- 
            ,guarrate -- 
            ,bzguarmethod -- 
            ,bzmethod -- 
            ,guarcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.applycode -- 
    ,o.isrelation -- 
    ,o.isworkable -- 
    ,o.guarrelation -- 
    ,o.guarresult -- 
    ,o.qztypeishg -- 
    ,o.qzishgtools -- 
    ,o.qzhgtoolstype -- 
    ,o.nptypeishg -- 
    ,o.npishgtools -- 
    ,o.nphgtoolstype -- 
    ,o.guarmoney -- 
    ,o.guarrate -- 
    ,o.bzguarmethod -- 
    ,o.bzmethod -- 
    ,o.guarcurrency -- 
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
from ${iol_schema}.mims_si_creditqualify_bk o
    left join ${iol_schema}.mims_si_creditqualify_op n
        on
            o.sccode = n.sccode
            and o.applycode = n.applycode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_creditqualify_cl d
        on
            o.sccode = d.sccode
            and o.applycode = d.applycode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_si_creditqualify;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_si_creditqualify') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_si_creditqualify drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_si_creditqualify add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_si_creditqualify exchange partition p_${batch_date} with table ${iol_schema}.mims_si_creditqualify_cl;
alter table ${iol_schema}.mims_si_creditqualify exchange partition p_20991231 with table ${iol_schema}.mims_si_creditqualify_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_creditqualify to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_creditqualify_op purge;
drop table ${iol_schema}.mims_si_creditqualify_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_creditqualify_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_creditqualify',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
