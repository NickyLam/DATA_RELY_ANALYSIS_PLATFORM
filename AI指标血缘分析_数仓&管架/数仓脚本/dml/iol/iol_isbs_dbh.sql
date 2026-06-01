/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_dbh
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
create table ${iol_schema}.isbs_dbh_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_dbh;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_dbh_op purge;
drop table ${iol_schema}.isbs_dbh_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbh_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_dbh where 0=1;

create table ${iol_schema}.isbs_dbh_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_dbh where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_dbh_cl(
            inr -- 
            ,tmpref -- 
            ,ownextkey -- 
            ,ver -- 
            ,actiontype -- 
            ,actiondesc -- 
            ,rptno -- 
            ,country -- 
            ,paytype -- 
            ,txcode -- 
            ,tc1amt -- 
            ,txrem -- 
            ,txcode2 -- 
            ,tc2amt -- 
            ,tx2rem -- 
            ,isref -- 
            ,crtuser -- 
            ,inptelc -- 
            ,rptdate -- 
            ,regno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_dbh_op(
            inr -- 
            ,tmpref -- 
            ,ownextkey -- 
            ,ver -- 
            ,actiontype -- 
            ,actiondesc -- 
            ,rptno -- 
            ,country -- 
            ,paytype -- 
            ,txcode -- 
            ,tc1amt -- 
            ,txrem -- 
            ,txcode2 -- 
            ,tc2amt -- 
            ,tx2rem -- 
            ,isref -- 
            ,crtuser -- 
            ,inptelc -- 
            ,rptdate -- 
            ,regno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.tmpref, o.tmpref) as tmpref -- 
    ,nvl(n.ownextkey, o.ownextkey) as ownextkey -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.actiontype, o.actiontype) as actiontype -- 
    ,nvl(n.actiondesc, o.actiondesc) as actiondesc -- 
    ,nvl(n.rptno, o.rptno) as rptno -- 
    ,nvl(n.country, o.country) as country -- 
    ,nvl(n.paytype, o.paytype) as paytype -- 
    ,nvl(n.txcode, o.txcode) as txcode -- 
    ,nvl(n.tc1amt, o.tc1amt) as tc1amt -- 
    ,nvl(n.txrem, o.txrem) as txrem -- 
    ,nvl(n.txcode2, o.txcode2) as txcode2 -- 
    ,nvl(n.tc2amt, o.tc2amt) as tc2amt -- 
    ,nvl(n.tx2rem, o.tx2rem) as tx2rem -- 
    ,nvl(n.isref, o.isref) as isref -- 
    ,nvl(n.crtuser, o.crtuser) as crtuser -- 
    ,nvl(n.inptelc, o.inptelc) as inptelc -- 
    ,nvl(n.rptdate, o.rptdate) as rptdate -- 
    ,nvl(n.regno, o.regno) as regno -- 
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_dbh_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_dbh where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.tmpref <> n.tmpref
        or o.ownextkey <> n.ownextkey
        or o.ver <> n.ver
        or o.actiontype <> n.actiontype
        or o.actiondesc <> n.actiondesc
        or o.rptno <> n.rptno
        or o.country <> n.country
        or o.paytype <> n.paytype
        or o.txcode <> n.txcode
        or o.tc1amt <> n.tc1amt
        or o.txrem <> n.txrem
        or o.txcode2 <> n.txcode2
        or o.tc2amt <> n.tc2amt
        or o.tx2rem <> n.tx2rem
        or o.isref <> n.isref
        or o.crtuser <> n.crtuser
        or o.inptelc <> n.inptelc
        or o.rptdate <> n.rptdate
        or o.regno <> n.regno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_dbh_cl(
            inr -- 
            ,tmpref -- 
            ,ownextkey -- 
            ,ver -- 
            ,actiontype -- 
            ,actiondesc -- 
            ,rptno -- 
            ,country -- 
            ,paytype -- 
            ,txcode -- 
            ,tc1amt -- 
            ,txrem -- 
            ,txcode2 -- 
            ,tc2amt -- 
            ,tx2rem -- 
            ,isref -- 
            ,crtuser -- 
            ,inptelc -- 
            ,rptdate -- 
            ,regno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_dbh_op(
            inr -- 
            ,tmpref -- 
            ,ownextkey -- 
            ,ver -- 
            ,actiontype -- 
            ,actiondesc -- 
            ,rptno -- 
            ,country -- 
            ,paytype -- 
            ,txcode -- 
            ,tc1amt -- 
            ,txrem -- 
            ,txcode2 -- 
            ,tc2amt -- 
            ,tx2rem -- 
            ,isref -- 
            ,crtuser -- 
            ,inptelc -- 
            ,rptdate -- 
            ,regno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 
    ,o.tmpref -- 
    ,o.ownextkey -- 
    ,o.ver -- 
    ,o.actiontype -- 
    ,o.actiondesc -- 
    ,o.rptno -- 
    ,o.country -- 
    ,o.paytype -- 
    ,o.txcode -- 
    ,o.tc1amt -- 
    ,o.txrem -- 
    ,o.txcode2 -- 
    ,o.tc2amt -- 
    ,o.tx2rem -- 
    ,o.isref -- 
    ,o.crtuser -- 
    ,o.inptelc -- 
    ,o.rptdate -- 
    ,o.regno -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_dbh_bk o
    left join ${iol_schema}.isbs_dbh_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_dbh_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_dbh;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_dbh exchange partition p_19000101 with table ${iol_schema}.isbs_dbh_cl;
alter table ${iol_schema}.isbs_dbh exchange partition p_20991231 with table ${iol_schema}.isbs_dbh_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_dbh to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_dbh_op purge;
drop table ${iol_schema}.isbs_dbh_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_dbh_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_dbh',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
