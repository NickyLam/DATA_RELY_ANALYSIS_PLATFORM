/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a08thvbilltran
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
create table ${iol_schema}.mpcs_a08thvbilltran_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a08thvbilltran;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08thvbilltran_op purge;
drop table ${iol_schema}.mpcs_a08thvbilltran_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08thvbilltran_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08thvbilltran where 0=1;

create table ${iol_schema}.mpcs_a08thvbilltran_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08thvbilltran where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08thvbilltran_cl(
            mainsq -- 
            ,trandt -- 
            ,packno -- 
            ,busino -- 
            ,biflag -- 
            ,busifg -- 
            ,errinf -- 
            ,bepsdt -- 
            ,sequno -- 
            ,recvbk -- 
            ,recvac -- 
            ,recvna -- 
            ,billbk -- 
            ,billac -- 
            ,billna -- 
            ,crcycd -- 
            ,billam -- 
            ,billno -- 
            ,billdt -- 
            ,notedt -- 
            ,passwd -- 
            ,bikind -- 
            ,transt -- 
            ,busflg -- 
            ,dataid -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08thvbilltran_op(
            mainsq -- 
            ,trandt -- 
            ,packno -- 
            ,busino -- 
            ,biflag -- 
            ,busifg -- 
            ,errinf -- 
            ,bepsdt -- 
            ,sequno -- 
            ,recvbk -- 
            ,recvac -- 
            ,recvna -- 
            ,billbk -- 
            ,billac -- 
            ,billna -- 
            ,crcycd -- 
            ,billam -- 
            ,billno -- 
            ,billdt -- 
            ,notedt -- 
            ,passwd -- 
            ,bikind -- 
            ,transt -- 
            ,busflg -- 
            ,dataid -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mainsq, o.mainsq) as mainsq -- 
    ,nvl(n.trandt, o.trandt) as trandt -- 
    ,nvl(n.packno, o.packno) as packno -- 
    ,nvl(n.busino, o.busino) as busino -- 
    ,nvl(n.biflag, o.biflag) as biflag -- 
    ,nvl(n.busifg, o.busifg) as busifg -- 
    ,nvl(n.errinf, o.errinf) as errinf -- 
    ,nvl(n.bepsdt, o.bepsdt) as bepsdt -- 
    ,nvl(n.sequno, o.sequno) as sequno -- 
    ,nvl(n.recvbk, o.recvbk) as recvbk -- 
    ,nvl(n.recvac, o.recvac) as recvac -- 
    ,nvl(n.recvna, o.recvna) as recvna -- 
    ,nvl(n.billbk, o.billbk) as billbk -- 
    ,nvl(n.billac, o.billac) as billac -- 
    ,nvl(n.billna, o.billna) as billna -- 
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 
    ,nvl(n.billam, o.billam) as billam -- 
    ,nvl(n.billno, o.billno) as billno -- 
    ,nvl(n.billdt, o.billdt) as billdt -- 
    ,nvl(n.notedt, o.notedt) as notedt -- 
    ,nvl(n.passwd, o.passwd) as passwd -- 
    ,nvl(n.bikind, o.bikind) as bikind -- 
    ,nvl(n.transt, o.transt) as transt -- 
    ,nvl(n.busflg, o.busflg) as busflg -- 
    ,nvl(n.dataid, o.dataid) as dataid -- 
    ,case when
            n.biflag is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.biflag is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.biflag is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a08thvbilltran_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a08thvbilltran where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.biflag = n.biflag
where (
        o.biflag is null
    )
    or (
        n.biflag is null
    )
    or (
        o.mainsq <> n.mainsq
        or o.trandt <> n.trandt
        or o.packno <> n.packno
        or o.busino <> n.busino
        or o.busifg <> n.busifg
        or o.errinf <> n.errinf
        or o.bepsdt <> n.bepsdt
        or o.sequno <> n.sequno
        or o.recvbk <> n.recvbk
        or o.recvac <> n.recvac
        or o.recvna <> n.recvna
        or o.billbk <> n.billbk
        or o.billac <> n.billac
        or o.billna <> n.billna
        or o.crcycd <> n.crcycd
        or o.billam <> n.billam
        or o.billno <> n.billno
        or o.billdt <> n.billdt
        or o.notedt <> n.notedt
        or o.passwd <> n.passwd
        or o.bikind <> n.bikind
        or o.transt <> n.transt
        or o.busflg <> n.busflg
        or o.dataid <> n.dataid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08thvbilltran_cl(
            mainsq -- 
            ,trandt -- 
            ,packno -- 
            ,busino -- 
            ,biflag -- 
            ,busifg -- 
            ,errinf -- 
            ,bepsdt -- 
            ,sequno -- 
            ,recvbk -- 
            ,recvac -- 
            ,recvna -- 
            ,billbk -- 
            ,billac -- 
            ,billna -- 
            ,crcycd -- 
            ,billam -- 
            ,billno -- 
            ,billdt -- 
            ,notedt -- 
            ,passwd -- 
            ,bikind -- 
            ,transt -- 
            ,busflg -- 
            ,dataid -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08thvbilltran_op(
            mainsq -- 
            ,trandt -- 
            ,packno -- 
            ,busino -- 
            ,biflag -- 
            ,busifg -- 
            ,errinf -- 
            ,bepsdt -- 
            ,sequno -- 
            ,recvbk -- 
            ,recvac -- 
            ,recvna -- 
            ,billbk -- 
            ,billac -- 
            ,billna -- 
            ,crcycd -- 
            ,billam -- 
            ,billno -- 
            ,billdt -- 
            ,notedt -- 
            ,passwd -- 
            ,bikind -- 
            ,transt -- 
            ,busflg -- 
            ,dataid -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mainsq -- 
    ,o.trandt -- 
    ,o.packno -- 
    ,o.busino -- 
    ,o.biflag -- 
    ,o.busifg -- 
    ,o.errinf -- 
    ,o.bepsdt -- 
    ,o.sequno -- 
    ,o.recvbk -- 
    ,o.recvac -- 
    ,o.recvna -- 
    ,o.billbk -- 
    ,o.billac -- 
    ,o.billna -- 
    ,o.crcycd -- 
    ,o.billam -- 
    ,o.billno -- 
    ,o.billdt -- 
    ,o.notedt -- 
    ,o.passwd -- 
    ,o.bikind -- 
    ,o.transt -- 
    ,o.busflg -- 
    ,o.dataid -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a08thvbilltran_bk o
    left join ${iol_schema}.mpcs_a08thvbilltran_op n
        on
            o.biflag = n.biflag
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a08thvbilltran_cl d
        on
            o.biflag = d.biflag
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a08thvbilltran;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a08thvbilltran exchange partition p_19000101 with table ${iol_schema}.mpcs_a08thvbilltran_cl;
alter table ${iol_schema}.mpcs_a08thvbilltran exchange partition p_20991231 with table ${iol_schema}.mpcs_a08thvbilltran_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a08thvbilltran to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08thvbilltran_op purge;
drop table ${iol_schema}.mpcs_a08thvbilltran_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a08thvbilltran_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a08thvbilltran',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
