/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_btd
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
create table ${iol_schema}.isbs_btd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_btd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_btd_op purge;
drop table ${iol_schema}.isbs_btd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_btd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_btd where 0=1;

create table ${iol_schema}.isbs_btd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_btd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_btd_cl(
            approvcod -- 
            ,totamt -- 
            ,orddatbe1 -- 
            ,rcvdatbe1 -- 
            ,ownusr -- 
            ,disdat -- 
            ,pntinr -- 
            ,advtyp -- 
            ,clsdat -- 
            ,orddatbe2 -- 
            ,opndat -- 
            ,credat -- 
            ,lescom -- 
            ,docprbrolbe1 -- 
            ,nraflg -- 
            ,totdat -- 
            ,inr -- 
            ,nam -- 
            ,mattxtflg -- 
            ,bchkeyinr -- 
            ,frepayflg -- 
            ,branchinr -- 
            ,ownref -- 
            ,etyextkey -- 
            ,rcvdatbe2 -- 
            ,rmbrol -- 
            ,totcur -- 
            ,doctypcod -- 
            ,ver -- 
            ,payrol -- 
            ,shpdat -- 
            ,dscinsflg -- 
            ,docprbrol -- 
            ,matdat -- 
            ,predat -- 
            ,pnttyp -- 
            ,acpnowflg -- 
            ,advdat -- 
            ,docsta -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_btd_op(
            approvcod -- 
            ,totamt -- 
            ,orddatbe1 -- 
            ,rcvdatbe1 -- 
            ,ownusr -- 
            ,disdat -- 
            ,pntinr -- 
            ,advtyp -- 
            ,clsdat -- 
            ,orddatbe2 -- 
            ,opndat -- 
            ,credat -- 
            ,lescom -- 
            ,docprbrolbe1 -- 
            ,nraflg -- 
            ,totdat -- 
            ,inr -- 
            ,nam -- 
            ,mattxtflg -- 
            ,bchkeyinr -- 
            ,frepayflg -- 
            ,branchinr -- 
            ,ownref -- 
            ,etyextkey -- 
            ,rcvdatbe2 -- 
            ,rmbrol -- 
            ,totcur -- 
            ,doctypcod -- 
            ,ver -- 
            ,payrol -- 
            ,shpdat -- 
            ,dscinsflg -- 
            ,docprbrol -- 
            ,matdat -- 
            ,predat -- 
            ,pnttyp -- 
            ,acpnowflg -- 
            ,advdat -- 
            ,docsta -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.approvcod, o.approvcod) as approvcod -- 
    ,nvl(n.totamt, o.totamt) as totamt -- 
    ,nvl(n.orddatbe1, o.orddatbe1) as orddatbe1 -- 
    ,nvl(n.rcvdatbe1, o.rcvdatbe1) as rcvdatbe1 -- 
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 
    ,nvl(n.disdat, o.disdat) as disdat -- 
    ,nvl(n.pntinr, o.pntinr) as pntinr -- 
    ,nvl(n.advtyp, o.advtyp) as advtyp -- 
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 
    ,nvl(n.orddatbe2, o.orddatbe2) as orddatbe2 -- 
    ,nvl(n.opndat, o.opndat) as opndat -- 
    ,nvl(n.credat, o.credat) as credat -- 
    ,nvl(n.lescom, o.lescom) as lescom -- 
    ,nvl(n.docprbrolbe1, o.docprbrolbe1) as docprbrolbe1 -- 
    ,nvl(n.nraflg, o.nraflg) as nraflg -- 
    ,nvl(n.totdat, o.totdat) as totdat -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.mattxtflg, o.mattxtflg) as mattxtflg -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.frepayflg, o.frepayflg) as frepayflg -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,nvl(n.ownref, o.ownref) as ownref -- 
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 
    ,nvl(n.rcvdatbe2, o.rcvdatbe2) as rcvdatbe2 -- 
    ,nvl(n.rmbrol, o.rmbrol) as rmbrol -- 
    ,nvl(n.totcur, o.totcur) as totcur -- 
    ,nvl(n.doctypcod, o.doctypcod) as doctypcod -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.payrol, o.payrol) as payrol -- 
    ,nvl(n.shpdat, o.shpdat) as shpdat -- 
    ,nvl(n.dscinsflg, o.dscinsflg) as dscinsflg -- 
    ,nvl(n.docprbrol, o.docprbrol) as docprbrol -- 
    ,nvl(n.matdat, o.matdat) as matdat -- 
    ,nvl(n.predat, o.predat) as predat -- 
    ,nvl(n.pnttyp, o.pnttyp) as pnttyp -- 
    ,nvl(n.acpnowflg, o.acpnowflg) as acpnowflg -- 
    ,nvl(n.advdat, o.advdat) as advdat -- 
    ,nvl(n.docsta, o.docsta) as docsta -- 
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
from (select * from ${iol_schema}.isbs_btd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_btd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.approvcod <> n.approvcod
        or o.totamt <> n.totamt
        or o.orddatbe1 <> n.orddatbe1
        or o.rcvdatbe1 <> n.rcvdatbe1
        or o.ownusr <> n.ownusr
        or o.disdat <> n.disdat
        or o.pntinr <> n.pntinr
        or o.advtyp <> n.advtyp
        or o.clsdat <> n.clsdat
        or o.orddatbe2 <> n.orddatbe2
        or o.opndat <> n.opndat
        or o.credat <> n.credat
        or o.lescom <> n.lescom
        or o.docprbrolbe1 <> n.docprbrolbe1
        or o.nraflg <> n.nraflg
        or o.totdat <> n.totdat
        or o.nam <> n.nam
        or o.mattxtflg <> n.mattxtflg
        or o.bchkeyinr <> n.bchkeyinr
        or o.frepayflg <> n.frepayflg
        or o.branchinr <> n.branchinr
        or o.ownref <> n.ownref
        or o.etyextkey <> n.etyextkey
        or o.rcvdatbe2 <> n.rcvdatbe2
        or o.rmbrol <> n.rmbrol
        or o.totcur <> n.totcur
        or o.doctypcod <> n.doctypcod
        or o.ver <> n.ver
        or o.payrol <> n.payrol
        or o.shpdat <> n.shpdat
        or o.dscinsflg <> n.dscinsflg
        or o.docprbrol <> n.docprbrol
        or o.matdat <> n.matdat
        or o.predat <> n.predat
        or o.pnttyp <> n.pnttyp
        or o.acpnowflg <> n.acpnowflg
        or o.advdat <> n.advdat
        or o.docsta <> n.docsta
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_btd_cl(
            approvcod -- 
            ,totamt -- 
            ,orddatbe1 -- 
            ,rcvdatbe1 -- 
            ,ownusr -- 
            ,disdat -- 
            ,pntinr -- 
            ,advtyp -- 
            ,clsdat -- 
            ,orddatbe2 -- 
            ,opndat -- 
            ,credat -- 
            ,lescom -- 
            ,docprbrolbe1 -- 
            ,nraflg -- 
            ,totdat -- 
            ,inr -- 
            ,nam -- 
            ,mattxtflg -- 
            ,bchkeyinr -- 
            ,frepayflg -- 
            ,branchinr -- 
            ,ownref -- 
            ,etyextkey -- 
            ,rcvdatbe2 -- 
            ,rmbrol -- 
            ,totcur -- 
            ,doctypcod -- 
            ,ver -- 
            ,payrol -- 
            ,shpdat -- 
            ,dscinsflg -- 
            ,docprbrol -- 
            ,matdat -- 
            ,predat -- 
            ,pnttyp -- 
            ,acpnowflg -- 
            ,advdat -- 
            ,docsta -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_btd_op(
            approvcod -- 
            ,totamt -- 
            ,orddatbe1 -- 
            ,rcvdatbe1 -- 
            ,ownusr -- 
            ,disdat -- 
            ,pntinr -- 
            ,advtyp -- 
            ,clsdat -- 
            ,orddatbe2 -- 
            ,opndat -- 
            ,credat -- 
            ,lescom -- 
            ,docprbrolbe1 -- 
            ,nraflg -- 
            ,totdat -- 
            ,inr -- 
            ,nam -- 
            ,mattxtflg -- 
            ,bchkeyinr -- 
            ,frepayflg -- 
            ,branchinr -- 
            ,ownref -- 
            ,etyextkey -- 
            ,rcvdatbe2 -- 
            ,rmbrol -- 
            ,totcur -- 
            ,doctypcod -- 
            ,ver -- 
            ,payrol -- 
            ,shpdat -- 
            ,dscinsflg -- 
            ,docprbrol -- 
            ,matdat -- 
            ,predat -- 
            ,pnttyp -- 
            ,acpnowflg -- 
            ,advdat -- 
            ,docsta -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.approvcod -- 
    ,o.totamt -- 
    ,o.orddatbe1 -- 
    ,o.rcvdatbe1 -- 
    ,o.ownusr -- 
    ,o.disdat -- 
    ,o.pntinr -- 
    ,o.advtyp -- 
    ,o.clsdat -- 
    ,o.orddatbe2 -- 
    ,o.opndat -- 
    ,o.credat -- 
    ,o.lescom -- 
    ,o.docprbrolbe1 -- 
    ,o.nraflg -- 
    ,o.totdat -- 
    ,o.inr -- 
    ,o.nam -- 
    ,o.mattxtflg -- 
    ,o.bchkeyinr -- 
    ,o.frepayflg -- 
    ,o.branchinr -- 
    ,o.ownref -- 
    ,o.etyextkey -- 
    ,o.rcvdatbe2 -- 
    ,o.rmbrol -- 
    ,o.totcur -- 
    ,o.doctypcod -- 
    ,o.ver -- 
    ,o.payrol -- 
    ,o.shpdat -- 
    ,o.dscinsflg -- 
    ,o.docprbrol -- 
    ,o.matdat -- 
    ,o.predat -- 
    ,o.pnttyp -- 
    ,o.acpnowflg -- 
    ,o.advdat -- 
    ,o.docsta -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_btd_bk o
    left join ${iol_schema}.isbs_btd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_btd_cl d
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
-- truncate table ${iol_schema}.isbs_btd;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_btd exchange partition p_19000101 with table ${iol_schema}.isbs_btd_cl;
alter table ${iol_schema}.isbs_btd exchange partition p_20991231 with table ${iol_schema}.isbs_btd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_btd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_btd_op purge;
drop table ${iol_schema}.isbs_btd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_btd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_btd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
