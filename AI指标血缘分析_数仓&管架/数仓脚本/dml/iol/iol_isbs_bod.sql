/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_bod
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
create table ${iol_schema}.isbs_bod_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_bod;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bod_op purge;
drop table ${iol_schema}.isbs_bod_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bod_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bod where 0=1;

create table ${iol_schema}.isbs_bod_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bod where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bod_cl(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,agtref -- 
            ,agtact -- 
            ,agtcom -- 
            ,shpdat -- 
            ,predat -- 
            ,rcvdat -- 
            ,opndat -- 
            ,advdat -- 
            ,matdat -- 
            ,clsdat -- 
            ,doctypcod -- 
            ,matperbeg -- 
            ,matpercnt -- 
            ,matpertyp -- 
            ,trpdoctyp -- 
            ,trpdocnum -- 
            ,tradat -- 
            ,tramod -- 
            ,shpfro -- 
            ,shpto -- 
            ,waicolcod -- 
            ,wairmtcod -- 
            ,chato -- 
            ,stacty -- 
            ,stagod -- 
            ,credat -- 
            ,ownusr -- 
            ,ver -- 
            ,focflg -- 
            ,dircolflg -- 
            ,ccdpurflg -- 
            ,ccdndrflg -- 
            ,issdat -- 
            ,paydocnum -- 
            ,paydoctyp -- 
            ,mattxtflg -- 
            ,othins -- 
            ,docsta -- 
            ,resflg -- 
            ,amenbr -- 
            ,msgrol -- 
            ,etyextkey -- 
            ,lescom -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,nraflg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bod_op(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,agtref -- 
            ,agtact -- 
            ,agtcom -- 
            ,shpdat -- 
            ,predat -- 
            ,rcvdat -- 
            ,opndat -- 
            ,advdat -- 
            ,matdat -- 
            ,clsdat -- 
            ,doctypcod -- 
            ,matperbeg -- 
            ,matpercnt -- 
            ,matpertyp -- 
            ,trpdoctyp -- 
            ,trpdocnum -- 
            ,tradat -- 
            ,tramod -- 
            ,shpfro -- 
            ,shpto -- 
            ,waicolcod -- 
            ,wairmtcod -- 
            ,chato -- 
            ,stacty -- 
            ,stagod -- 
            ,credat -- 
            ,ownusr -- 
            ,ver -- 
            ,focflg -- 
            ,dircolflg -- 
            ,ccdpurflg -- 
            ,ccdndrflg -- 
            ,issdat -- 
            ,paydocnum -- 
            ,paydoctyp -- 
            ,mattxtflg -- 
            ,othins -- 
            ,docsta -- 
            ,resflg -- 
            ,amenbr -- 
            ,msgrol -- 
            ,etyextkey -- 
            ,lescom -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,nraflg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.ownref, o.ownref) as ownref -- 
    ,nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.agtref, o.agtref) as agtref -- 
    ,nvl(n.agtact, o.agtact) as agtact -- 
    ,nvl(n.agtcom, o.agtcom) as agtcom -- 
    ,nvl(n.shpdat, o.shpdat) as shpdat -- 
    ,nvl(n.predat, o.predat) as predat -- 
    ,nvl(n.rcvdat, o.rcvdat) as rcvdat -- 
    ,nvl(n.opndat, o.opndat) as opndat -- 
    ,nvl(n.advdat, o.advdat) as advdat -- 
    ,nvl(n.matdat, o.matdat) as matdat -- 
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 
    ,nvl(n.doctypcod, o.doctypcod) as doctypcod -- 
    ,nvl(n.matperbeg, o.matperbeg) as matperbeg -- 
    ,nvl(n.matpercnt, o.matpercnt) as matpercnt -- 
    ,nvl(n.matpertyp, o.matpertyp) as matpertyp -- 
    ,nvl(n.trpdoctyp, o.trpdoctyp) as trpdoctyp -- 
    ,nvl(n.trpdocnum, o.trpdocnum) as trpdocnum -- 
    ,nvl(n.tradat, o.tradat) as tradat -- 
    ,nvl(n.tramod, o.tramod) as tramod -- 
    ,nvl(n.shpfro, o.shpfro) as shpfro -- 
    ,nvl(n.shpto, o.shpto) as shpto -- 
    ,nvl(n.waicolcod, o.waicolcod) as waicolcod -- 
    ,nvl(n.wairmtcod, o.wairmtcod) as wairmtcod -- 
    ,nvl(n.chato, o.chato) as chato -- 
    ,nvl(n.stacty, o.stacty) as stacty -- 
    ,nvl(n.stagod, o.stagod) as stagod -- 
    ,nvl(n.credat, o.credat) as credat -- 
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.focflg, o.focflg) as focflg -- 
    ,nvl(n.dircolflg, o.dircolflg) as dircolflg -- 
    ,nvl(n.ccdpurflg, o.ccdpurflg) as ccdpurflg -- 
    ,nvl(n.ccdndrflg, o.ccdndrflg) as ccdndrflg -- 
    ,nvl(n.issdat, o.issdat) as issdat -- 
    ,nvl(n.paydocnum, o.paydocnum) as paydocnum -- 
    ,nvl(n.paydoctyp, o.paydoctyp) as paydoctyp -- 
    ,nvl(n.mattxtflg, o.mattxtflg) as mattxtflg -- 
    ,nvl(n.othins, o.othins) as othins -- 
    ,nvl(n.docsta, o.docsta) as docsta -- 
    ,nvl(n.resflg, o.resflg) as resflg -- 
    ,nvl(n.amenbr, o.amenbr) as amenbr -- 
    ,nvl(n.msgrol, o.msgrol) as msgrol -- 
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 
    ,nvl(n.lescom, o.lescom) as lescom -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.nraflg, o.nraflg) as nraflg -- 
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
from (select * from ${iol_schema}.isbs_bod_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_bod where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.ownref <> n.ownref
        or o.nam <> n.nam
        or o.agtref <> n.agtref
        or o.agtact <> n.agtact
        or o.agtcom <> n.agtcom
        or o.shpdat <> n.shpdat
        or o.predat <> n.predat
        or o.rcvdat <> n.rcvdat
        or o.opndat <> n.opndat
        or o.advdat <> n.advdat
        or o.matdat <> n.matdat
        or o.clsdat <> n.clsdat
        or o.doctypcod <> n.doctypcod
        or o.matperbeg <> n.matperbeg
        or o.matpercnt <> n.matpercnt
        or o.matpertyp <> n.matpertyp
        or o.trpdoctyp <> n.trpdoctyp
        or o.trpdocnum <> n.trpdocnum
        or o.tradat <> n.tradat
        or o.tramod <> n.tramod
        or o.shpfro <> n.shpfro
        or o.shpto <> n.shpto
        or o.waicolcod <> n.waicolcod
        or o.wairmtcod <> n.wairmtcod
        or o.chato <> n.chato
        or o.stacty <> n.stacty
        or o.stagod <> n.stagod
        or o.credat <> n.credat
        or o.ownusr <> n.ownusr
        or o.ver <> n.ver
        or o.focflg <> n.focflg
        or o.dircolflg <> n.dircolflg
        or o.ccdpurflg <> n.ccdpurflg
        or o.ccdndrflg <> n.ccdndrflg
        or o.issdat <> n.issdat
        or o.paydocnum <> n.paydocnum
        or o.paydoctyp <> n.paydoctyp
        or o.mattxtflg <> n.mattxtflg
        or o.othins <> n.othins
        or o.docsta <> n.docsta
        or o.resflg <> n.resflg
        or o.amenbr <> n.amenbr
        or o.msgrol <> n.msgrol
        or o.etyextkey <> n.etyextkey
        or o.lescom <> n.lescom
        or o.branchinr <> n.branchinr
        or o.bchkeyinr <> n.bchkeyinr
        or o.nraflg <> n.nraflg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bod_cl(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,agtref -- 
            ,agtact -- 
            ,agtcom -- 
            ,shpdat -- 
            ,predat -- 
            ,rcvdat -- 
            ,opndat -- 
            ,advdat -- 
            ,matdat -- 
            ,clsdat -- 
            ,doctypcod -- 
            ,matperbeg -- 
            ,matpercnt -- 
            ,matpertyp -- 
            ,trpdoctyp -- 
            ,trpdocnum -- 
            ,tradat -- 
            ,tramod -- 
            ,shpfro -- 
            ,shpto -- 
            ,waicolcod -- 
            ,wairmtcod -- 
            ,chato -- 
            ,stacty -- 
            ,stagod -- 
            ,credat -- 
            ,ownusr -- 
            ,ver -- 
            ,focflg -- 
            ,dircolflg -- 
            ,ccdpurflg -- 
            ,ccdndrflg -- 
            ,issdat -- 
            ,paydocnum -- 
            ,paydoctyp -- 
            ,mattxtflg -- 
            ,othins -- 
            ,docsta -- 
            ,resflg -- 
            ,amenbr -- 
            ,msgrol -- 
            ,etyextkey -- 
            ,lescom -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,nraflg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bod_op(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,agtref -- 
            ,agtact -- 
            ,agtcom -- 
            ,shpdat -- 
            ,predat -- 
            ,rcvdat -- 
            ,opndat -- 
            ,advdat -- 
            ,matdat -- 
            ,clsdat -- 
            ,doctypcod -- 
            ,matperbeg -- 
            ,matpercnt -- 
            ,matpertyp -- 
            ,trpdoctyp -- 
            ,trpdocnum -- 
            ,tradat -- 
            ,tramod -- 
            ,shpfro -- 
            ,shpto -- 
            ,waicolcod -- 
            ,wairmtcod -- 
            ,chato -- 
            ,stacty -- 
            ,stagod -- 
            ,credat -- 
            ,ownusr -- 
            ,ver -- 
            ,focflg -- 
            ,dircolflg -- 
            ,ccdpurflg -- 
            ,ccdndrflg -- 
            ,issdat -- 
            ,paydocnum -- 
            ,paydoctyp -- 
            ,mattxtflg -- 
            ,othins -- 
            ,docsta -- 
            ,resflg -- 
            ,amenbr -- 
            ,msgrol -- 
            ,etyextkey -- 
            ,lescom -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,nraflg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 
    ,o.ownref -- 
    ,o.nam -- 
    ,o.agtref -- 
    ,o.agtact -- 
    ,o.agtcom -- 
    ,o.shpdat -- 
    ,o.predat -- 
    ,o.rcvdat -- 
    ,o.opndat -- 
    ,o.advdat -- 
    ,o.matdat -- 
    ,o.clsdat -- 
    ,o.doctypcod -- 
    ,o.matperbeg -- 
    ,o.matpercnt -- 
    ,o.matpertyp -- 
    ,o.trpdoctyp -- 
    ,o.trpdocnum -- 
    ,o.tradat -- 
    ,o.tramod -- 
    ,o.shpfro -- 
    ,o.shpto -- 
    ,o.waicolcod -- 
    ,o.wairmtcod -- 
    ,o.chato -- 
    ,o.stacty -- 
    ,o.stagod -- 
    ,o.credat -- 
    ,o.ownusr -- 
    ,o.ver -- 
    ,o.focflg -- 
    ,o.dircolflg -- 
    ,o.ccdpurflg -- 
    ,o.ccdndrflg -- 
    ,o.issdat -- 
    ,o.paydocnum -- 
    ,o.paydoctyp -- 
    ,o.mattxtflg -- 
    ,o.othins -- 
    ,o.docsta -- 
    ,o.resflg -- 
    ,o.amenbr -- 
    ,o.msgrol -- 
    ,o.etyextkey -- 
    ,o.lescom -- 
    ,o.branchinr -- 
    ,o.bchkeyinr -- 
    ,o.nraflg -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_bod_bk o
    left join ${iol_schema}.isbs_bod_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bod_cl d
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
-- truncate table ${iol_schema}.isbs_bod;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_bod exchange partition p_19000101 with table ${iol_schema}.isbs_bod_cl;
alter table ${iol_schema}.isbs_bod exchange partition p_20991231 with table ${iol_schema}.isbs_bod_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_bod to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bod_op purge;
drop table ${iol_schema}.isbs_bod_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_bod_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_bod',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
