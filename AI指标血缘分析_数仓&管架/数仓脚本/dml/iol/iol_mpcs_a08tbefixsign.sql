/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a08tbefixsign
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
create table ${iol_schema}.mpcs_a08tbefixsign_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a08tbefixsign
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08tbefixsign_op purge;
drop table ${iol_schema}.mpcs_a08tbefixsign_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tbefixsign_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08tbefixsign where 0=1;

create table ${iol_schema}.mpcs_a08tbefixsign_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08tbefixsign where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08tbefixsign_cl(
            unitcd -- 
            ,cntrsq -- 
            ,citycd -- 
            ,cntrtp -- 
            ,bustype -- 
            ,servtype -- 
            ,cntrno -- 
            ,cntrst -- 
            ,iotype -- 
            ,recvbk -- 
            ,rebkna -- 
            ,recvac -- 
            ,recvna -- 
            ,pyerbk -- 
            ,pybkna -- 
            ,pyerac -- 
            ,pyerna -- 
            ,signdt -- 
            ,cncldt -- 
            ,userid -- 
            ,brchno -- 
            ,modidt -- 
            ,modius -- 
            ,remark -- 
            ,rcvupbrn -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08tbefixsign_op(
            unitcd -- 
            ,cntrsq -- 
            ,citycd -- 
            ,cntrtp -- 
            ,bustype -- 
            ,servtype -- 
            ,cntrno -- 
            ,cntrst -- 
            ,iotype -- 
            ,recvbk -- 
            ,rebkna -- 
            ,recvac -- 
            ,recvna -- 
            ,pyerbk -- 
            ,pybkna -- 
            ,pyerac -- 
            ,pyerna -- 
            ,signdt -- 
            ,cncldt -- 
            ,userid -- 
            ,brchno -- 
            ,modidt -- 
            ,modius -- 
            ,remark -- 
            ,rcvupbrn -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.unitcd, o.unitcd) as unitcd -- 
    ,nvl(n.cntrsq, o.cntrsq) as cntrsq -- 
    ,nvl(n.citycd, o.citycd) as citycd -- 
    ,nvl(n.cntrtp, o.cntrtp) as cntrtp -- 
    ,nvl(n.bustype, o.bustype) as bustype -- 
    ,nvl(n.servtype, o.servtype) as servtype -- 
    ,nvl(n.cntrno, o.cntrno) as cntrno -- 
    ,nvl(n.cntrst, o.cntrst) as cntrst -- 
    ,nvl(n.iotype, o.iotype) as iotype -- 
    ,nvl(n.recvbk, o.recvbk) as recvbk -- 
    ,nvl(n.rebkna, o.rebkna) as rebkna -- 
    ,nvl(n.recvac, o.recvac) as recvac -- 
    ,nvl(n.recvna, o.recvna) as recvna -- 
    ,nvl(n.pyerbk, o.pyerbk) as pyerbk -- 
    ,nvl(n.pybkna, o.pybkna) as pybkna -- 
    ,nvl(n.pyerac, o.pyerac) as pyerac -- 
    ,nvl(n.pyerna, o.pyerna) as pyerna -- 
    ,nvl(n.signdt, o.signdt) as signdt -- 
    ,nvl(n.cncldt, o.cncldt) as cncldt -- 
    ,nvl(n.userid, o.userid) as userid -- 
    ,nvl(n.brchno, o.brchno) as brchno -- 
    ,nvl(n.modidt, o.modidt) as modidt -- 
    ,nvl(n.modius, o.modius) as modius -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.rcvupbrn, o.rcvupbrn) as rcvupbrn -- 
    ,case when
            n.cntrno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cntrno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cntrno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a08tbefixsign_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a08tbefixsign where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cntrno = n.cntrno
where (
        o.cntrno is null
    )
    or (
        n.cntrno is null
    )
    or (
        o.unitcd <> n.unitcd
        or o.cntrsq <> n.cntrsq
        or o.citycd <> n.citycd
        or o.cntrtp <> n.cntrtp
        or o.bustype <> n.bustype
        or o.servtype <> n.servtype
        or o.cntrst <> n.cntrst
        or o.iotype <> n.iotype
        or o.recvbk <> n.recvbk
        or o.rebkna <> n.rebkna
        or o.recvac <> n.recvac
        or o.recvna <> n.recvna
        or o.pyerbk <> n.pyerbk
        or o.pybkna <> n.pybkna
        or o.pyerac <> n.pyerac
        or o.pyerna <> n.pyerna
        or o.signdt <> n.signdt
        or o.cncldt <> n.cncldt
        or o.userid <> n.userid
        or o.brchno <> n.brchno
        or o.modidt <> n.modidt
        or o.modius <> n.modius
        or o.remark <> n.remark
        or o.rcvupbrn <> n.rcvupbrn
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08tbefixsign_cl(
            unitcd -- 
            ,cntrsq -- 
            ,citycd -- 
            ,cntrtp -- 
            ,bustype -- 
            ,servtype -- 
            ,cntrno -- 
            ,cntrst -- 
            ,iotype -- 
            ,recvbk -- 
            ,rebkna -- 
            ,recvac -- 
            ,recvna -- 
            ,pyerbk -- 
            ,pybkna -- 
            ,pyerac -- 
            ,pyerna -- 
            ,signdt -- 
            ,cncldt -- 
            ,userid -- 
            ,brchno -- 
            ,modidt -- 
            ,modius -- 
            ,remark -- 
            ,rcvupbrn -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08tbefixsign_op(
            unitcd -- 
            ,cntrsq -- 
            ,citycd -- 
            ,cntrtp -- 
            ,bustype -- 
            ,servtype -- 
            ,cntrno -- 
            ,cntrst -- 
            ,iotype -- 
            ,recvbk -- 
            ,rebkna -- 
            ,recvac -- 
            ,recvna -- 
            ,pyerbk -- 
            ,pybkna -- 
            ,pyerac -- 
            ,pyerna -- 
            ,signdt -- 
            ,cncldt -- 
            ,userid -- 
            ,brchno -- 
            ,modidt -- 
            ,modius -- 
            ,remark -- 
            ,rcvupbrn -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.unitcd -- 
    ,o.cntrsq -- 
    ,o.citycd -- 
    ,o.cntrtp -- 
    ,o.bustype -- 
    ,o.servtype -- 
    ,o.cntrno -- 
    ,o.cntrst -- 
    ,o.iotype -- 
    ,o.recvbk -- 
    ,o.rebkna -- 
    ,o.recvac -- 
    ,o.recvna -- 
    ,o.pyerbk -- 
    ,o.pybkna -- 
    ,o.pyerac -- 
    ,o.pyerna -- 
    ,o.signdt -- 
    ,o.cncldt -- 
    ,o.userid -- 
    ,o.brchno -- 
    ,o.modidt -- 
    ,o.modius -- 
    ,o.remark -- 
    ,o.rcvupbrn -- 
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
from ${iol_schema}.mpcs_a08tbefixsign_bk o
    left join ${iol_schema}.mpcs_a08tbefixsign_op n
        on
            o.cntrno = n.cntrno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a08tbefixsign_cl d
        on
            o.cntrno = d.cntrno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a08tbefixsign;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a08tbefixsign') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a08tbefixsign drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a08tbefixsign add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a08tbefixsign exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a08tbefixsign_cl;
alter table ${iol_schema}.mpcs_a08tbefixsign exchange partition p_20991231 with table ${iol_schema}.mpcs_a08tbefixsign_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a08tbefixsign to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08tbefixsign_op purge;
drop table ${iol_schema}.mpcs_a08tbefixsign_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a08tbefixsign_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a08tbefixsign',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
