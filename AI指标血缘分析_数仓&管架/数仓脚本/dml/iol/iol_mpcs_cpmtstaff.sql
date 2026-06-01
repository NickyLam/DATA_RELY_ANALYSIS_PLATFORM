/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_cpmtstaff
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
create table ${iol_schema}.mpcs_cpmtstaff_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_cpmtstaff;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_cpmtstaff_op purge;
drop table ${iol_schema}.mpcs_cpmtstaff_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_cpmtstaff_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_cpmtstaff where 0=1;

create table ${iol_schema}.mpcs_cpmtstaff_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_cpmtstaff where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_cpmtstaff_cl(
            staffno -- 
            ,tlrtype -- 
            ,staffname -- 
            ,sex -- 
            ,birthday -- 
            ,idtype -- 
            ,idno -- 
            ,ofinstno -- 
            ,ofdeptno -- 
            ,stafftype -- 
            ,mobile -- 
            ,email -- 
            ,safemode -- 
            ,signpswd -- 
            ,pswdchgdt -- 
            ,rowstat -- 
            ,upddt -- 
            ,updtm -- 
            ,ygno -- 
            ,motto -- 
            ,ofdeptnm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_cpmtstaff_op(
            staffno -- 
            ,tlrtype -- 
            ,staffname -- 
            ,sex -- 
            ,birthday -- 
            ,idtype -- 
            ,idno -- 
            ,ofinstno -- 
            ,ofdeptno -- 
            ,stafftype -- 
            ,mobile -- 
            ,email -- 
            ,safemode -- 
            ,signpswd -- 
            ,pswdchgdt -- 
            ,rowstat -- 
            ,upddt -- 
            ,updtm -- 
            ,ygno -- 
            ,motto -- 
            ,ofdeptnm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.staffno, o.staffno) as staffno -- 
    ,nvl(n.tlrtype, o.tlrtype) as tlrtype -- 
    ,nvl(n.staffname, o.staffname) as staffname -- 
    ,nvl(n.sex, o.sex) as sex -- 
    ,nvl(n.birthday, o.birthday) as birthday -- 
    ,nvl(n.idtype, o.idtype) as idtype -- 
    ,nvl(n.idno, o.idno) as idno -- 
    ,nvl(n.ofinstno, o.ofinstno) as ofinstno -- 
    ,nvl(n.ofdeptno, o.ofdeptno) as ofdeptno -- 
    ,nvl(n.stafftype, o.stafftype) as stafftype -- 
    ,nvl(n.mobile, o.mobile) as mobile -- 
    ,nvl(n.email, o.email) as email -- 
    ,nvl(n.safemode, o.safemode) as safemode -- 
    ,nvl(n.signpswd, o.signpswd) as signpswd -- 
    ,nvl(n.pswdchgdt, o.pswdchgdt) as pswdchgdt -- 
    ,nvl(n.rowstat, o.rowstat) as rowstat -- 
    ,nvl(n.upddt, o.upddt) as upddt -- 
    ,nvl(n.updtm, o.updtm) as updtm -- 
    ,nvl(n.ygno, o.ygno) as ygno -- 
    ,nvl(n.motto, o.motto) as motto -- 
    ,nvl(n.ofdeptnm, o.ofdeptnm) as ofdeptnm -- 
    ,case when
            n.staffno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.staffno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.staffno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_cpmtstaff_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_cpmtstaff where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.staffno = n.staffno
where (
        o.staffno is null
    )
    or (
        n.staffno is null
    )
    or (
        o.tlrtype <> n.tlrtype
        or o.staffname <> n.staffname
        or o.sex <> n.sex
        or o.birthday <> n.birthday
        or o.idtype <> n.idtype
        or o.idno <> n.idno
        or o.ofinstno <> n.ofinstno
        or o.ofdeptno <> n.ofdeptno
        or o.stafftype <> n.stafftype
        or o.mobile <> n.mobile
        or o.email <> n.email
        or o.safemode <> n.safemode
        or o.signpswd <> n.signpswd
        or o.pswdchgdt <> n.pswdchgdt
        or o.rowstat <> n.rowstat
        or o.upddt <> n.upddt
        or o.updtm <> n.updtm
        or o.ygno <> n.ygno
        or o.motto <> n.motto
        or o.ofdeptnm <> n.ofdeptnm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_cpmtstaff_cl(
            staffno -- 
            ,tlrtype -- 
            ,staffname -- 
            ,sex -- 
            ,birthday -- 
            ,idtype -- 
            ,idno -- 
            ,ofinstno -- 
            ,ofdeptno -- 
            ,stafftype -- 
            ,mobile -- 
            ,email -- 
            ,safemode -- 
            ,signpswd -- 
            ,pswdchgdt -- 
            ,rowstat -- 
            ,upddt -- 
            ,updtm -- 
            ,ygno -- 
            ,motto -- 
            ,ofdeptnm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_cpmtstaff_op(
            staffno -- 
            ,tlrtype -- 
            ,staffname -- 
            ,sex -- 
            ,birthday -- 
            ,idtype -- 
            ,idno -- 
            ,ofinstno -- 
            ,ofdeptno -- 
            ,stafftype -- 
            ,mobile -- 
            ,email -- 
            ,safemode -- 
            ,signpswd -- 
            ,pswdchgdt -- 
            ,rowstat -- 
            ,upddt -- 
            ,updtm -- 
            ,ygno -- 
            ,motto -- 
            ,ofdeptnm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.staffno -- 
    ,o.tlrtype -- 
    ,o.staffname -- 
    ,o.sex -- 
    ,o.birthday -- 
    ,o.idtype -- 
    ,o.idno -- 
    ,o.ofinstno -- 
    ,o.ofdeptno -- 
    ,o.stafftype -- 
    ,o.mobile -- 
    ,o.email -- 
    ,o.safemode -- 
    ,o.signpswd -- 
    ,o.pswdchgdt -- 
    ,o.rowstat -- 
    ,o.upddt -- 
    ,o.updtm -- 
    ,o.ygno -- 
    ,o.motto -- 
    ,o.ofdeptnm -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_cpmtstaff_bk o
    left join ${iol_schema}.mpcs_cpmtstaff_op n
        on
            o.staffno = n.staffno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_cpmtstaff_cl d
        on
            o.staffno = d.staffno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_cpmtstaff;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_cpmtstaff exchange partition p_19000101 with table ${iol_schema}.mpcs_cpmtstaff_cl;
alter table ${iol_schema}.mpcs_cpmtstaff exchange partition p_20991231 with table ${iol_schema}.mpcs_cpmtstaff_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_cpmtstaff to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_cpmtstaff_op purge;
drop table ${iol_schema}.mpcs_cpmtstaff_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_cpmtstaff_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_cpmtstaff',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
