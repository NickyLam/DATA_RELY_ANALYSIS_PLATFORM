/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_registerinfo
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
create table ${iol_schema}.mims_si_registerinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_registerinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_registerinfo_op purge;
drop table ${iol_schema}.mims_si_registerinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_registerinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_registerinfo where 0=1;

create table ${iol_schema}.mims_si_registerinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_registerinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_registerinfo_cl(
            sccode -- 
            ,regcode -- 
            ,regdptname -- 
            ,regvalue -- 
            ,regdate -- 
            ,regenddate -- 
            ,ymortgage -- 
            ,fmortstartdate -- 
            ,fmortenddate -- 
            ,operatorid -- 
            ,optdate -- 
            ,updates -- 
            ,regno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_registerinfo_op(
            sccode -- 
            ,regcode -- 
            ,regdptname -- 
            ,regvalue -- 
            ,regdate -- 
            ,regenddate -- 
            ,ymortgage -- 
            ,fmortstartdate -- 
            ,fmortenddate -- 
            ,operatorid -- 
            ,optdate -- 
            ,updates -- 
            ,regno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.regcode, o.regcode) as regcode -- 
    ,nvl(n.regdptname, o.regdptname) as regdptname -- 
    ,nvl(n.regvalue, o.regvalue) as regvalue -- 
    ,nvl(n.regdate, o.regdate) as regdate -- 
    ,nvl(n.regenddate, o.regenddate) as regenddate -- 
    ,nvl(n.ymortgage, o.ymortgage) as ymortgage -- 
    ,nvl(n.fmortstartdate, o.fmortstartdate) as fmortstartdate -- 
    ,nvl(n.fmortenddate, o.fmortenddate) as fmortenddate -- 
    ,nvl(n.operatorid, o.operatorid) as operatorid -- 
    ,nvl(n.optdate, o.optdate) as optdate -- 
    ,nvl(n.updates, o.updates) as updates -- 
    ,nvl(n.regno, o.regno) as regno -- 
    ,case when
            n.sccode is null
            and n.regcode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
            and n.regcode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
            and n.regcode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_registerinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_registerinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
            and o.regcode = n.regcode
where (
        o.sccode is null
        and o.regcode is null
    )
    or (
        n.sccode is null
        and n.regcode is null
    )
    or (
        o.regdptname <> n.regdptname
        or o.regvalue <> n.regvalue
        or o.regdate <> n.regdate
        or o.regenddate <> n.regenddate
        or o.ymortgage <> n.ymortgage
        or o.fmortstartdate <> n.fmortstartdate
        or o.fmortenddate <> n.fmortenddate
        or o.operatorid <> n.operatorid
        or o.optdate <> n.optdate
        or o.updates <> n.updates
        or o.regno <> n.regno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_registerinfo_cl(
            sccode -- 
            ,regcode -- 
            ,regdptname -- 
            ,regvalue -- 
            ,regdate -- 
            ,regenddate -- 
            ,ymortgage -- 
            ,fmortstartdate -- 
            ,fmortenddate -- 
            ,operatorid -- 
            ,optdate -- 
            ,updates -- 
            ,regno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_registerinfo_op(
            sccode -- 
            ,regcode -- 
            ,regdptname -- 
            ,regvalue -- 
            ,regdate -- 
            ,regenddate -- 
            ,ymortgage -- 
            ,fmortstartdate -- 
            ,fmortenddate -- 
            ,operatorid -- 
            ,optdate -- 
            ,updates -- 
            ,regno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.regcode -- 
    ,o.regdptname -- 
    ,o.regvalue -- 
    ,o.regdate -- 
    ,o.regenddate -- 
    ,o.ymortgage -- 
    ,o.fmortstartdate -- 
    ,o.fmortenddate -- 
    ,o.operatorid -- 
    ,o.optdate -- 
    ,o.updates -- 
    ,o.regno -- 
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
from ${iol_schema}.mims_si_registerinfo_bk o
    left join ${iol_schema}.mims_si_registerinfo_op n
        on
            o.sccode = n.sccode
            and o.regcode = n.regcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_registerinfo_cl d
        on
            o.sccode = d.sccode
            and o.regcode = d.regcode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_si_registerinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_si_registerinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_si_registerinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_si_registerinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_si_registerinfo exchange partition p_${batch_date} with table ${iol_schema}.mims_si_registerinfo_cl;
alter table ${iol_schema}.mims_si_registerinfo exchange partition p_20991231 with table ${iol_schema}.mims_si_registerinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_registerinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_registerinfo_op purge;
drop table ${iol_schema}.mims_si_registerinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_registerinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_registerinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
