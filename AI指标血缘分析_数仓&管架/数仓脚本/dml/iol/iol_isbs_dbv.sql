/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_dbv
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
create table ${iol_schema}.isbs_dbv_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_dbv;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_dbv_op purge;
drop table ${iol_schema}.isbs_dbv_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbv_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_dbv where 0=1;

create table ${iol_schema}.isbs_dbv_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_dbv where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_dbv_cl(
            rptno -- 
            ,usedetail -- 
            ,usetype -- 
            ,ver -- 
            ,rptdate -- 
            ,crtuser -- 
            ,actiontype -- 
            ,tmpref -- 
            ,inptelc -- 
            ,regno -- 
            ,actiondesc -- 
            ,txcode -- 
            ,ownextkey -- 
            ,inr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_dbv_op(
            rptno -- 
            ,usedetail -- 
            ,usetype -- 
            ,ver -- 
            ,rptdate -- 
            ,crtuser -- 
            ,actiontype -- 
            ,tmpref -- 
            ,inptelc -- 
            ,regno -- 
            ,actiondesc -- 
            ,txcode -- 
            ,ownextkey -- 
            ,inr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rptno, o.rptno) as rptno -- 
    ,nvl(n.usedetail, o.usedetail) as usedetail -- 
    ,nvl(n.usetype, o.usetype) as usetype -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.rptdate, o.rptdate) as rptdate -- 
    ,nvl(n.crtuser, o.crtuser) as crtuser -- 
    ,nvl(n.actiontype, o.actiontype) as actiontype -- 
    ,nvl(n.tmpref, o.tmpref) as tmpref -- 
    ,nvl(n.inptelc, o.inptelc) as inptelc -- 
    ,nvl(n.regno, o.regno) as regno -- 
    ,nvl(n.actiondesc, o.actiondesc) as actiondesc -- 
    ,nvl(n.txcode, o.txcode) as txcode -- 
    ,nvl(n.ownextkey, o.ownextkey) as ownextkey -- 
    ,nvl(n.inr, o.inr) as inr -- 
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
from (select * from ${iol_schema}.isbs_dbv_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_dbv where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.rptno <> n.rptno
        or o.usedetail <> n.usedetail
        or o.usetype <> n.usetype
        or o.ver <> n.ver
        or o.rptdate <> n.rptdate
        or o.crtuser <> n.crtuser
        or o.actiontype <> n.actiontype
        or o.tmpref <> n.tmpref
        or o.inptelc <> n.inptelc
        or o.regno <> n.regno
        or o.actiondesc <> n.actiondesc
        or o.txcode <> n.txcode
        or o.ownextkey <> n.ownextkey
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_dbv_cl(
            rptno -- 
            ,usedetail -- 
            ,usetype -- 
            ,ver -- 
            ,rptdate -- 
            ,crtuser -- 
            ,actiontype -- 
            ,tmpref -- 
            ,inptelc -- 
            ,regno -- 
            ,actiondesc -- 
            ,txcode -- 
            ,ownextkey -- 
            ,inr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_dbv_op(
            rptno -- 
            ,usedetail -- 
            ,usetype -- 
            ,ver -- 
            ,rptdate -- 
            ,crtuser -- 
            ,actiontype -- 
            ,tmpref -- 
            ,inptelc -- 
            ,regno -- 
            ,actiondesc -- 
            ,txcode -- 
            ,ownextkey -- 
            ,inr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rptno -- 
    ,o.usedetail -- 
    ,o.usetype -- 
    ,o.ver -- 
    ,o.rptdate -- 
    ,o.crtuser -- 
    ,o.actiontype -- 
    ,o.tmpref -- 
    ,o.inptelc -- 
    ,o.regno -- 
    ,o.actiondesc -- 
    ,o.txcode -- 
    ,o.ownextkey -- 
    ,o.inr -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_dbv_bk o
    left join ${iol_schema}.isbs_dbv_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_dbv_cl d
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
-- truncate table ${iol_schema}.isbs_dbv;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_dbv exchange partition p_19000101 with table ${iol_schema}.isbs_dbv_cl;
alter table ${iol_schema}.isbs_dbv exchange partition p_20991231 with table ${iol_schema}.isbs_dbv_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_dbv to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_dbv_op purge;
drop table ${iol_schema}.isbs_dbv_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_dbv_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_dbv',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
