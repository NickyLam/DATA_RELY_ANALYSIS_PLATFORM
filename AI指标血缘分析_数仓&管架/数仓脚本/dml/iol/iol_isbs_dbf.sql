/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_dbf
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
create table ${iol_schema}.isbs_dbf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_dbf;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_dbf_op purge;
drop table ${iol_schema}.isbs_dbf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_dbf where 0=1;

create table ${iol_schema}.isbs_dbf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_dbf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_dbf_cl(
            inr -- 
            ,tmpref -- 
            ,ownextkey -- 
            ,ver -- 
            ,actiontype -- 
            ,actiondesc -- 
            ,rptno -- 
            ,custype -- 
            ,idcode -- 
            ,custcod -- 
            ,custnm -- 
            ,oppuser -- 
            ,txccy -- 
            ,txamt -- 
            ,exrate -- 
            ,lcyamt -- 
            ,lcyacc -- 
            ,fcyamt -- 
            ,fcyacc -- 
            ,othamt -- 
            ,othacc -- 
            ,methods -- 
            ,buscode -- 
            ,actuccy -- 
            ,actuamt -- 
            ,outchargeccy -- 
            ,outchargeamt -- 
            ,lcbgno -- 
            ,issdate -- 
            ,tenor -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_dbf_op(
            inr -- 
            ,tmpref -- 
            ,ownextkey -- 
            ,ver -- 
            ,actiontype -- 
            ,actiondesc -- 
            ,rptno -- 
            ,custype -- 
            ,idcode -- 
            ,custcod -- 
            ,custnm -- 
            ,oppuser -- 
            ,txccy -- 
            ,txamt -- 
            ,exrate -- 
            ,lcyamt -- 
            ,lcyacc -- 
            ,fcyamt -- 
            ,fcyacc -- 
            ,othamt -- 
            ,othacc -- 
            ,methods -- 
            ,buscode -- 
            ,actuccy -- 
            ,actuamt -- 
            ,outchargeccy -- 
            ,outchargeamt -- 
            ,lcbgno -- 
            ,issdate -- 
            ,tenor -- 
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
    ,nvl(n.custype, o.custype) as custype -- 
    ,nvl(n.idcode, o.idcode) as idcode -- 
    ,nvl(n.custcod, o.custcod) as custcod -- 
    ,nvl(n.custnm, o.custnm) as custnm -- 
    ,nvl(n.oppuser, o.oppuser) as oppuser -- 
    ,nvl(n.txccy, o.txccy) as txccy -- 
    ,nvl(n.txamt, o.txamt) as txamt -- 
    ,nvl(n.exrate, o.exrate) as exrate -- 
    ,nvl(n.lcyamt, o.lcyamt) as lcyamt -- 
    ,nvl(n.lcyacc, o.lcyacc) as lcyacc -- 
    ,nvl(n.fcyamt, o.fcyamt) as fcyamt -- 
    ,nvl(n.fcyacc, o.fcyacc) as fcyacc -- 
    ,nvl(n.othamt, o.othamt) as othamt -- 
    ,nvl(n.othacc, o.othacc) as othacc -- 
    ,nvl(n.methods, o.methods) as methods -- 
    ,nvl(n.buscode, o.buscode) as buscode -- 
    ,nvl(n.actuccy, o.actuccy) as actuccy -- 
    ,nvl(n.actuamt, o.actuamt) as actuamt -- 
    ,nvl(n.outchargeccy, o.outchargeccy) as outchargeccy -- 
    ,nvl(n.outchargeamt, o.outchargeamt) as outchargeamt -- 
    ,nvl(n.lcbgno, o.lcbgno) as lcbgno -- 
    ,nvl(n.issdate, o.issdate) as issdate -- 
    ,nvl(n.tenor, o.tenor) as tenor -- 
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
from (select * from ${iol_schema}.isbs_dbf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_dbf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.custype <> n.custype
        or o.idcode <> n.idcode
        or o.custcod <> n.custcod
        or o.custnm <> n.custnm
        or o.oppuser <> n.oppuser
        or o.txccy <> n.txccy
        or o.txamt <> n.txamt
        or o.exrate <> n.exrate
        or o.lcyamt <> n.lcyamt
        or o.lcyacc <> n.lcyacc
        or o.fcyamt <> n.fcyamt
        or o.fcyacc <> n.fcyacc
        or o.othamt <> n.othamt
        or o.othacc <> n.othacc
        or o.methods <> n.methods
        or o.buscode <> n.buscode
        or o.actuccy <> n.actuccy
        or o.actuamt <> n.actuamt
        or o.outchargeccy <> n.outchargeccy
        or o.outchargeamt <> n.outchargeamt
        or o.lcbgno <> n.lcbgno
        or o.issdate <> n.issdate
        or o.tenor <> n.tenor
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_dbf_cl(
            inr -- 
            ,tmpref -- 
            ,ownextkey -- 
            ,ver -- 
            ,actiontype -- 
            ,actiondesc -- 
            ,rptno -- 
            ,custype -- 
            ,idcode -- 
            ,custcod -- 
            ,custnm -- 
            ,oppuser -- 
            ,txccy -- 
            ,txamt -- 
            ,exrate -- 
            ,lcyamt -- 
            ,lcyacc -- 
            ,fcyamt -- 
            ,fcyacc -- 
            ,othamt -- 
            ,othacc -- 
            ,methods -- 
            ,buscode -- 
            ,actuccy -- 
            ,actuamt -- 
            ,outchargeccy -- 
            ,outchargeamt -- 
            ,lcbgno -- 
            ,issdate -- 
            ,tenor -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_dbf_op(
            inr -- 
            ,tmpref -- 
            ,ownextkey -- 
            ,ver -- 
            ,actiontype -- 
            ,actiondesc -- 
            ,rptno -- 
            ,custype -- 
            ,idcode -- 
            ,custcod -- 
            ,custnm -- 
            ,oppuser -- 
            ,txccy -- 
            ,txamt -- 
            ,exrate -- 
            ,lcyamt -- 
            ,lcyacc -- 
            ,fcyamt -- 
            ,fcyacc -- 
            ,othamt -- 
            ,othacc -- 
            ,methods -- 
            ,buscode -- 
            ,actuccy -- 
            ,actuamt -- 
            ,outchargeccy -- 
            ,outchargeamt -- 
            ,lcbgno -- 
            ,issdate -- 
            ,tenor -- 
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
    ,o.custype -- 
    ,o.idcode -- 
    ,o.custcod -- 
    ,o.custnm -- 
    ,o.oppuser -- 
    ,o.txccy -- 
    ,o.txamt -- 
    ,o.exrate -- 
    ,o.lcyamt -- 
    ,o.lcyacc -- 
    ,o.fcyamt -- 
    ,o.fcyacc -- 
    ,o.othamt -- 
    ,o.othacc -- 
    ,o.methods -- 
    ,o.buscode -- 
    ,o.actuccy -- 
    ,o.actuamt -- 
    ,o.outchargeccy -- 
    ,o.outchargeamt -- 
    ,o.lcbgno -- 
    ,o.issdate -- 
    ,o.tenor -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_dbf_bk o
    left join ${iol_schema}.isbs_dbf_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_dbf_cl d
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
-- truncate table ${iol_schema}.isbs_dbf;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_dbf exchange partition p_19000101 with table ${iol_schema}.isbs_dbf_cl;
alter table ${iol_schema}.isbs_dbf exchange partition p_20991231 with table ${iol_schema}.isbs_dbf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_dbf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_dbf_op purge;
drop table ${iol_schema}.isbs_dbf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_dbf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_dbf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
