/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_bd_bankaccsub
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
create table ${iol_schema}.iers_bd_bankaccsub_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_bd_bankaccsub
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_bankaccsub_op purge;
drop table ${iol_schema}.iers_bd_bankaccsub_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_bankaccsub_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_bd_bankaccsub where 0=1;

create table ${iol_schema}.iers_bd_bankaccsub_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_bd_bankaccsub where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_bankaccsub_cl(
            accname -- 
            ,accnum -- 
            ,acctype -- 
            ,banknotespec -- 
            ,code -- 
            ,concertedmny -- 
            ,cooverdraf -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,defrozendate -- 
            ,dr -- 
            ,fronzenmny -- 
            ,fronzenstate -- 
            ,frozendate -- 
            ,isconcerted -- 
            ,isdefault -- 
            ,istrade -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,overdraftmny -- 
            ,overdrafttype -- 
            ,payarea -- 
            ,pk_bankaccbas -- 
            ,pk_bankaccsub -- 
            ,pk_currtype -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_bankaccsub_op(
            accname -- 
            ,accnum -- 
            ,acctype -- 
            ,banknotespec -- 
            ,code -- 
            ,concertedmny -- 
            ,cooverdraf -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,defrozendate -- 
            ,dr -- 
            ,fronzenmny -- 
            ,fronzenstate -- 
            ,frozendate -- 
            ,isconcerted -- 
            ,isdefault -- 
            ,istrade -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,overdraftmny -- 
            ,overdrafttype -- 
            ,payarea -- 
            ,pk_bankaccbas -- 
            ,pk_bankaccsub -- 
            ,pk_currtype -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.accname, o.accname) as accname -- 
    ,nvl(n.accnum, o.accnum) as accnum -- 
    ,nvl(n.acctype, o.acctype) as acctype -- 
    ,nvl(n.banknotespec, o.banknotespec) as banknotespec -- 
    ,nvl(n.code, o.code) as code -- 
    ,nvl(n.concertedmny, o.concertedmny) as concertedmny -- 
    ,nvl(n.cooverdraf, o.cooverdraf) as cooverdraf -- 
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 
    ,nvl(n.creator, o.creator) as creator -- 
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 
    ,nvl(n.def1, o.def1) as def1 -- 
    ,nvl(n.def10, o.def10) as def10 -- 
    ,nvl(n.def11, o.def11) as def11 -- 
    ,nvl(n.def12, o.def12) as def12 -- 
    ,nvl(n.def13, o.def13) as def13 -- 
    ,nvl(n.def14, o.def14) as def14 -- 
    ,nvl(n.def15, o.def15) as def15 -- 
    ,nvl(n.def16, o.def16) as def16 -- 
    ,nvl(n.def17, o.def17) as def17 -- 
    ,nvl(n.def18, o.def18) as def18 -- 
    ,nvl(n.def19, o.def19) as def19 -- 
    ,nvl(n.def2, o.def2) as def2 -- 
    ,nvl(n.def20, o.def20) as def20 -- 
    ,nvl(n.def3, o.def3) as def3 -- 
    ,nvl(n.def4, o.def4) as def4 -- 
    ,nvl(n.def5, o.def5) as def5 -- 
    ,nvl(n.def6, o.def6) as def6 -- 
    ,nvl(n.def7, o.def7) as def7 -- 
    ,nvl(n.def8, o.def8) as def8 -- 
    ,nvl(n.def9, o.def9) as def9 -- 
    ,nvl(n.defrozendate, o.defrozendate) as defrozendate -- 
    ,nvl(n.dr, o.dr) as dr -- 
    ,nvl(n.fronzenmny, o.fronzenmny) as fronzenmny -- 
    ,nvl(n.fronzenstate, o.fronzenstate) as fronzenstate -- 
    ,nvl(n.frozendate, o.frozendate) as frozendate -- 
    ,nvl(n.isconcerted, o.isconcerted) as isconcerted -- 
    ,nvl(n.isdefault, o.isdefault) as isdefault -- 
    ,nvl(n.istrade, o.istrade) as istrade -- 
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.name, o.name) as name -- 
    ,nvl(n.name2, o.name2) as name2 -- 
    ,nvl(n.name3, o.name3) as name3 -- 
    ,nvl(n.name4, o.name4) as name4 -- 
    ,nvl(n.name5, o.name5) as name5 -- 
    ,nvl(n.name6, o.name6) as name6 -- 
    ,nvl(n.overdraftmny, o.overdraftmny) as overdraftmny -- 
    ,nvl(n.overdrafttype, o.overdrafttype) as overdrafttype -- 
    ,nvl(n.payarea, o.payarea) as payarea -- 
    ,nvl(n.pk_bankaccbas, o.pk_bankaccbas) as pk_bankaccbas -- 
    ,nvl(n.pk_bankaccsub, o.pk_bankaccsub) as pk_bankaccsub -- 
    ,nvl(n.pk_currtype, o.pk_currtype) as pk_currtype -- 
    ,nvl(n.ts, o.ts) as ts -- 
    ,case when
            n.pk_bankaccsub is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_bankaccsub is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_bankaccsub is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_bd_bankaccsub_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_bd_bankaccsub where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_bankaccsub = n.pk_bankaccsub
where (
        o.pk_bankaccsub is null
    )
    or (
        n.pk_bankaccsub is null
    )
    or (
        o.accname <> n.accname
        or o.accnum <> n.accnum
        or o.acctype <> n.acctype
        or o.banknotespec <> n.banknotespec
        or o.code <> n.code
        or o.concertedmny <> n.concertedmny
        or o.cooverdraf <> n.cooverdraf
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.def1 <> n.def1
        or o.def10 <> n.def10
        or o.def11 <> n.def11
        or o.def12 <> n.def12
        or o.def13 <> n.def13
        or o.def14 <> n.def14
        or o.def15 <> n.def15
        or o.def16 <> n.def16
        or o.def17 <> n.def17
        or o.def18 <> n.def18
        or o.def19 <> n.def19
        or o.def2 <> n.def2
        or o.def20 <> n.def20
        or o.def3 <> n.def3
        or o.def4 <> n.def4
        or o.def5 <> n.def5
        or o.def6 <> n.def6
        or o.def7 <> n.def7
        or o.def8 <> n.def8
        or o.def9 <> n.def9
        or o.defrozendate <> n.defrozendate
        or o.dr <> n.dr
        or o.fronzenmny <> n.fronzenmny
        or o.fronzenstate <> n.fronzenstate
        or o.frozendate <> n.frozendate
        or o.isconcerted <> n.isconcerted
        or o.isdefault <> n.isdefault
        or o.istrade <> n.istrade
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.name <> n.name
        or o.name2 <> n.name2
        or o.name3 <> n.name3
        or o.name4 <> n.name4
        or o.name5 <> n.name5
        or o.name6 <> n.name6
        or o.overdraftmny <> n.overdraftmny
        or o.overdrafttype <> n.overdrafttype
        or o.payarea <> n.payarea
        or o.pk_bankaccbas <> n.pk_bankaccbas
        or o.pk_currtype <> n.pk_currtype
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_bankaccsub_cl(
            accname -- 
            ,accnum -- 
            ,acctype -- 
            ,banknotespec -- 
            ,code -- 
            ,concertedmny -- 
            ,cooverdraf -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,defrozendate -- 
            ,dr -- 
            ,fronzenmny -- 
            ,fronzenstate -- 
            ,frozendate -- 
            ,isconcerted -- 
            ,isdefault -- 
            ,istrade -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,overdraftmny -- 
            ,overdrafttype -- 
            ,payarea -- 
            ,pk_bankaccbas -- 
            ,pk_bankaccsub -- 
            ,pk_currtype -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_bankaccsub_op(
            accname -- 
            ,accnum -- 
            ,acctype -- 
            ,banknotespec -- 
            ,code -- 
            ,concertedmny -- 
            ,cooverdraf -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,defrozendate -- 
            ,dr -- 
            ,fronzenmny -- 
            ,fronzenstate -- 
            ,frozendate -- 
            ,isconcerted -- 
            ,isdefault -- 
            ,istrade -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,overdraftmny -- 
            ,overdrafttype -- 
            ,payarea -- 
            ,pk_bankaccbas -- 
            ,pk_bankaccsub -- 
            ,pk_currtype -- 
            ,ts -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.accname -- 
    ,o.accnum -- 
    ,o.acctype -- 
    ,o.banknotespec -- 
    ,o.code -- 
    ,o.concertedmny -- 
    ,o.cooverdraf -- 
    ,o.creationtime -- 
    ,o.creator -- 
    ,o.dataoriginflag -- 
    ,o.def1 -- 
    ,o.def10 -- 
    ,o.def11 -- 
    ,o.def12 -- 
    ,o.def13 -- 
    ,o.def14 -- 
    ,o.def15 -- 
    ,o.def16 -- 
    ,o.def17 -- 
    ,o.def18 -- 
    ,o.def19 -- 
    ,o.def2 -- 
    ,o.def20 -- 
    ,o.def3 -- 
    ,o.def4 -- 
    ,o.def5 -- 
    ,o.def6 -- 
    ,o.def7 -- 
    ,o.def8 -- 
    ,o.def9 -- 
    ,o.defrozendate -- 
    ,o.dr -- 
    ,o.fronzenmny -- 
    ,o.fronzenstate -- 
    ,o.frozendate -- 
    ,o.isconcerted -- 
    ,o.isdefault -- 
    ,o.istrade -- 
    ,o.modifiedtime -- 
    ,o.modifier -- 
    ,o.name -- 
    ,o.name2 -- 
    ,o.name3 -- 
    ,o.name4 -- 
    ,o.name5 -- 
    ,o.name6 -- 
    ,o.overdraftmny -- 
    ,o.overdrafttype -- 
    ,o.payarea -- 
    ,o.pk_bankaccbas -- 
    ,o.pk_bankaccsub -- 
    ,o.pk_currtype -- 
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
from ${iol_schema}.iers_bd_bankaccsub_bk o
    left join ${iol_schema}.iers_bd_bankaccsub_op n
        on
            o.pk_bankaccsub = n.pk_bankaccsub
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_bd_bankaccsub_cl d
        on
            o.pk_bankaccsub = d.pk_bankaccsub
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_bd_bankaccsub;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_bd_bankaccsub') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_bd_bankaccsub drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_bd_bankaccsub add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_bd_bankaccsub exchange partition p_${batch_date} with table ${iol_schema}.iers_bd_bankaccsub_cl;
alter table ${iol_schema}.iers_bd_bankaccsub exchange partition p_20991231 with table ${iol_schema}.iers_bd_bankaccsub_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_bd_bankaccsub to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_bankaccsub_op purge;
drop table ${iol_schema}.iers_bd_bankaccsub_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_bd_bankaccsub_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_bd_bankaccsub',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
