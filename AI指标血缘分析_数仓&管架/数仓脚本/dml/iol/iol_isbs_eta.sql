/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_eta
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
create table ${iol_schema}.isbs_eta_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_eta;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_eta_op purge;
drop table ${iol_schema}.isbs_eta_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_eta_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_eta where 0=1;

create table ${iol_schema}.isbs_eta_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_eta where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_eta_cl(
            priflg -- 
            ,inr -- 
            ,bolrid -- 
            ,ety -- 
            ,etgeml -- 
            ,tlx -- 
            ,extkey -- 
            ,etgextkey -- 
            ,nam -- 
            ,fax -- 
            ,eml -- 
            ,tel -- 
            ,blz -- 
            ,ver -- 
            ,tid -- 
            ,bic -- 
            ,web -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_eta_op(
            priflg -- 
            ,inr -- 
            ,bolrid -- 
            ,ety -- 
            ,etgeml -- 
            ,tlx -- 
            ,extkey -- 
            ,etgextkey -- 
            ,nam -- 
            ,fax -- 
            ,eml -- 
            ,tel -- 
            ,blz -- 
            ,ver -- 
            ,tid -- 
            ,bic -- 
            ,web -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.priflg, o.priflg) as priflg -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.bolrid, o.bolrid) as bolrid -- 
    ,nvl(n.ety, o.ety) as ety -- 
    ,nvl(n.etgeml, o.etgeml) as etgeml -- 
    ,nvl(n.tlx, o.tlx) as tlx -- 
    ,nvl(n.extkey, o.extkey) as extkey -- 
    ,nvl(n.etgextkey, o.etgextkey) as etgextkey -- 
    ,nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.fax, o.fax) as fax -- 
    ,nvl(n.eml, o.eml) as eml -- 
    ,nvl(n.tel, o.tel) as tel -- 
    ,nvl(n.blz, o.blz) as blz -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.tid, o.tid) as tid -- 
    ,nvl(n.bic, o.bic) as bic -- 
    ,nvl(n.web, o.web) as web -- 
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
from (select * from ${iol_schema}.isbs_eta_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_eta where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.priflg <> n.priflg
        or o.bolrid <> n.bolrid
        or o.ety <> n.ety
        or o.etgeml <> n.etgeml
        or o.tlx <> n.tlx
        or o.extkey <> n.extkey
        or o.etgextkey <> n.etgextkey
        or o.nam <> n.nam
        or o.fax <> n.fax
        or o.eml <> n.eml
        or o.tel <> n.tel
        or o.blz <> n.blz
        or o.ver <> n.ver
        or o.tid <> n.tid
        or o.bic <> n.bic
        or o.web <> n.web
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_eta_cl(
            priflg -- 
            ,inr -- 
            ,bolrid -- 
            ,ety -- 
            ,etgeml -- 
            ,tlx -- 
            ,extkey -- 
            ,etgextkey -- 
            ,nam -- 
            ,fax -- 
            ,eml -- 
            ,tel -- 
            ,blz -- 
            ,ver -- 
            ,tid -- 
            ,bic -- 
            ,web -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_eta_op(
            priflg -- 
            ,inr -- 
            ,bolrid -- 
            ,ety -- 
            ,etgeml -- 
            ,tlx -- 
            ,extkey -- 
            ,etgextkey -- 
            ,nam -- 
            ,fax -- 
            ,eml -- 
            ,tel -- 
            ,blz -- 
            ,ver -- 
            ,tid -- 
            ,bic -- 
            ,web -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.priflg -- 
    ,o.inr -- 
    ,o.bolrid -- 
    ,o.ety -- 
    ,o.etgeml -- 
    ,o.tlx -- 
    ,o.extkey -- 
    ,o.etgextkey -- 
    ,o.nam -- 
    ,o.fax -- 
    ,o.eml -- 
    ,o.tel -- 
    ,o.blz -- 
    ,o.ver -- 
    ,o.tid -- 
    ,o.bic -- 
    ,o.web -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_eta_bk o
    left join ${iol_schema}.isbs_eta_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_eta_cl d
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
-- truncate table ${iol_schema}.isbs_eta;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_eta exchange partition p_19000101 with table ${iol_schema}.isbs_eta_cl;
alter table ${iol_schema}.isbs_eta exchange partition p_20991231 with table ${iol_schema}.isbs_eta_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_eta to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_eta_op purge;
drop table ${iol_schema}.isbs_eta_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_eta_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_eta',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
