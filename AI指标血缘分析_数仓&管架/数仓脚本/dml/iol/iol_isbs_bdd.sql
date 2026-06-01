/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_bdd
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
create table ${iol_schema}.isbs_bdd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_bdd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bdd_op purge;
drop table ${iol_schema}.isbs_bdd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bdd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bdd where 0=1;

create table ${iol_schema}.isbs_bdd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bdd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bdd_cl(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,ownusr -- 
            ,credat -- 
            ,opndat -- 
            ,clsdat -- 
            ,pnttyp -- 
            ,pntinr -- 
            ,predat -- 
            ,shpdat -- 
            ,spddat -- 
            ,totdat -- 
            ,advdat -- 
            ,matdat -- 
            ,rcvdat -- 
            ,disdat -- 
            ,docflg -- 
            ,rejflg -- 
            ,approvcod -- 
            ,relgodflg -- 
            ,relgoddat -- 
            ,trpdocnum -- 
            ,frepayflg -- 
            ,ver -- 
            ,advtyp -- 
            ,reltyp -- 
            ,expdat -- 
            ,rtoaplflg -- 
            ,trpdoctyp -- 
            ,tradat -- 
            ,tramod -- 
            ,mattxtflg -- 
            ,dscinsflg -- 
            ,docprbrol -- 
            ,docsta -- 
            ,igndisflg -- 
            ,totcur -- 
            ,totamt -- 
            ,payrol -- 
            ,acpnowflg -- 
            ,orddat -- 
            ,advdocflg -- 
            ,etyextkey -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,ngrcod -- 
            ,sgdinr -- 
            ,blnum -- 
            ,shgref -- 
            ,fincod -- 
            ,fintyp -- 
            ,nraflg -- 
            ,qsqdbh -- 
            ,invnum -- 
            ,concur -- 
            ,conamt -- 
            ,comno -- 
            ,expmno -- 快递单号
            ,rcssta -- 追索权
            ,paytyp -- 付款类型
            ,clrmtd -- 清算方式
            ,bilpro -- 单据处理类型
            ,sndref -- 寄单索款编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bdd_op(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,ownusr -- 
            ,credat -- 
            ,opndat -- 
            ,clsdat -- 
            ,pnttyp -- 
            ,pntinr -- 
            ,predat -- 
            ,shpdat -- 
            ,spddat -- 
            ,totdat -- 
            ,advdat -- 
            ,matdat -- 
            ,rcvdat -- 
            ,disdat -- 
            ,docflg -- 
            ,rejflg -- 
            ,approvcod -- 
            ,relgodflg -- 
            ,relgoddat -- 
            ,trpdocnum -- 
            ,frepayflg -- 
            ,ver -- 
            ,advtyp -- 
            ,reltyp -- 
            ,expdat -- 
            ,rtoaplflg -- 
            ,trpdoctyp -- 
            ,tradat -- 
            ,tramod -- 
            ,mattxtflg -- 
            ,dscinsflg -- 
            ,docprbrol -- 
            ,docsta -- 
            ,igndisflg -- 
            ,totcur -- 
            ,totamt -- 
            ,payrol -- 
            ,acpnowflg -- 
            ,orddat -- 
            ,advdocflg -- 
            ,etyextkey -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,ngrcod -- 
            ,sgdinr -- 
            ,blnum -- 
            ,shgref -- 
            ,fincod -- 
            ,fintyp -- 
            ,nraflg -- 
            ,qsqdbh -- 
            ,invnum -- 
            ,concur -- 
            ,conamt -- 
            ,comno -- 
            ,expmno -- 快递单号
            ,rcssta -- 追索权
            ,paytyp -- 付款类型
            ,clrmtd -- 清算方式
            ,bilpro -- 单据处理类型
            ,sndref -- 寄单索款编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.ownref, o.ownref) as ownref -- 
    ,nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 
    ,nvl(n.credat, o.credat) as credat -- 
    ,nvl(n.opndat, o.opndat) as opndat -- 
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 
    ,nvl(n.pnttyp, o.pnttyp) as pnttyp -- 
    ,nvl(n.pntinr, o.pntinr) as pntinr -- 
    ,nvl(n.predat, o.predat) as predat -- 
    ,nvl(n.shpdat, o.shpdat) as shpdat -- 
    ,nvl(n.spddat, o.spddat) as spddat -- 
    ,nvl(n.totdat, o.totdat) as totdat -- 
    ,nvl(n.advdat, o.advdat) as advdat -- 
    ,nvl(n.matdat, o.matdat) as matdat -- 
    ,nvl(n.rcvdat, o.rcvdat) as rcvdat -- 
    ,nvl(n.disdat, o.disdat) as disdat -- 
    ,nvl(n.docflg, o.docflg) as docflg -- 
    ,nvl(n.rejflg, o.rejflg) as rejflg -- 
    ,nvl(n.approvcod, o.approvcod) as approvcod -- 
    ,nvl(n.relgodflg, o.relgodflg) as relgodflg -- 
    ,nvl(n.relgoddat, o.relgoddat) as relgoddat -- 
    ,nvl(n.trpdocnum, o.trpdocnum) as trpdocnum -- 
    ,nvl(n.frepayflg, o.frepayflg) as frepayflg -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.advtyp, o.advtyp) as advtyp -- 
    ,nvl(n.reltyp, o.reltyp) as reltyp -- 
    ,nvl(n.expdat, o.expdat) as expdat -- 
    ,nvl(n.rtoaplflg, o.rtoaplflg) as rtoaplflg -- 
    ,nvl(n.trpdoctyp, o.trpdoctyp) as trpdoctyp -- 
    ,nvl(n.tradat, o.tradat) as tradat -- 
    ,nvl(n.tramod, o.tramod) as tramod -- 
    ,nvl(n.mattxtflg, o.mattxtflg) as mattxtflg -- 
    ,nvl(n.dscinsflg, o.dscinsflg) as dscinsflg -- 
    ,nvl(n.docprbrol, o.docprbrol) as docprbrol -- 
    ,nvl(n.docsta, o.docsta) as docsta -- 
    ,nvl(n.igndisflg, o.igndisflg) as igndisflg -- 
    ,nvl(n.totcur, o.totcur) as totcur -- 
    ,nvl(n.totamt, o.totamt) as totamt -- 
    ,nvl(n.payrol, o.payrol) as payrol -- 
    ,nvl(n.acpnowflg, o.acpnowflg) as acpnowflg -- 
    ,nvl(n.orddat, o.orddat) as orddat -- 
    ,nvl(n.advdocflg, o.advdocflg) as advdocflg -- 
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,nvl(n.ngrcod, o.ngrcod) as ngrcod -- 
    ,nvl(n.sgdinr, o.sgdinr) as sgdinr -- 
    ,nvl(n.blnum, o.blnum) as blnum -- 
    ,nvl(n.shgref, o.shgref) as shgref -- 
    ,nvl(n.fincod, o.fincod) as fincod -- 
    ,nvl(n.fintyp, o.fintyp) as fintyp -- 
    ,nvl(n.nraflg, o.nraflg) as nraflg -- 
    ,nvl(n.qsqdbh, o.qsqdbh) as qsqdbh -- 
    ,nvl(n.invnum, o.invnum) as invnum -- 
    ,nvl(n.concur, o.concur) as concur -- 
    ,nvl(n.conamt, o.conamt) as conamt -- 
    ,nvl(n.comno, o.comno) as comno -- 
    ,nvl(n.expmno, o.expmno) as expmno -- 快递单号
    ,nvl(n.rcssta, o.rcssta) as rcssta -- 追索权
    ,nvl(n.paytyp, o.paytyp) as paytyp -- 付款类型
    ,nvl(n.clrmtd, o.clrmtd) as clrmtd -- 清算方式
    ,nvl(n.bilpro, o.bilpro) as bilpro -- 单据处理类型
    ,nvl(n.sndref, o.sndref) as sndref -- 寄单索款编号
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
from (select * from ${iol_schema}.isbs_bdd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_bdd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.ownusr <> n.ownusr
        or o.credat <> n.credat
        or o.opndat <> n.opndat
        or o.clsdat <> n.clsdat
        or o.pnttyp <> n.pnttyp
        or o.pntinr <> n.pntinr
        or o.predat <> n.predat
        or o.shpdat <> n.shpdat
        or o.spddat <> n.spddat
        or o.totdat <> n.totdat
        or o.advdat <> n.advdat
        or o.matdat <> n.matdat
        or o.rcvdat <> n.rcvdat
        or o.disdat <> n.disdat
        or o.docflg <> n.docflg
        or o.rejflg <> n.rejflg
        or o.approvcod <> n.approvcod
        or o.relgodflg <> n.relgodflg
        or o.relgoddat <> n.relgoddat
        or o.trpdocnum <> n.trpdocnum
        or o.frepayflg <> n.frepayflg
        or o.ver <> n.ver
        or o.advtyp <> n.advtyp
        or o.reltyp <> n.reltyp
        or o.expdat <> n.expdat
        or o.rtoaplflg <> n.rtoaplflg
        or o.trpdoctyp <> n.trpdoctyp
        or o.tradat <> n.tradat
        or o.tramod <> n.tramod
        or o.mattxtflg <> n.mattxtflg
        or o.dscinsflg <> n.dscinsflg
        or o.docprbrol <> n.docprbrol
        or o.docsta <> n.docsta
        or o.igndisflg <> n.igndisflg
        or o.totcur <> n.totcur
        or o.totamt <> n.totamt
        or o.payrol <> n.payrol
        or o.acpnowflg <> n.acpnowflg
        or o.orddat <> n.orddat
        or o.advdocflg <> n.advdocflg
        or o.etyextkey <> n.etyextkey
        or o.bchkeyinr <> n.bchkeyinr
        or o.branchinr <> n.branchinr
        or o.ngrcod <> n.ngrcod
        or o.sgdinr <> n.sgdinr
        or o.blnum <> n.blnum
        or o.shgref <> n.shgref
        or o.fincod <> n.fincod
        or o.fintyp <> n.fintyp
        or o.nraflg <> n.nraflg
        or o.qsqdbh <> n.qsqdbh
        or o.invnum <> n.invnum
        or o.concur <> n.concur
        or o.conamt <> n.conamt
        or o.comno <> n.comno
        or o.expmno <> n.expmno
        or o.rcssta <> n.rcssta
        or o.paytyp <> n.paytyp
        or o.clrmtd <> n.clrmtd
        or o.bilpro <> n.bilpro
        or o.sndref <> n.sndref
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bdd_cl(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,ownusr -- 
            ,credat -- 
            ,opndat -- 
            ,clsdat -- 
            ,pnttyp -- 
            ,pntinr -- 
            ,predat -- 
            ,shpdat -- 
            ,spddat -- 
            ,totdat -- 
            ,advdat -- 
            ,matdat -- 
            ,rcvdat -- 
            ,disdat -- 
            ,docflg -- 
            ,rejflg -- 
            ,approvcod -- 
            ,relgodflg -- 
            ,relgoddat -- 
            ,trpdocnum -- 
            ,frepayflg -- 
            ,ver -- 
            ,advtyp -- 
            ,reltyp -- 
            ,expdat -- 
            ,rtoaplflg -- 
            ,trpdoctyp -- 
            ,tradat -- 
            ,tramod -- 
            ,mattxtflg -- 
            ,dscinsflg -- 
            ,docprbrol -- 
            ,docsta -- 
            ,igndisflg -- 
            ,totcur -- 
            ,totamt -- 
            ,payrol -- 
            ,acpnowflg -- 
            ,orddat -- 
            ,advdocflg -- 
            ,etyextkey -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,ngrcod -- 
            ,sgdinr -- 
            ,blnum -- 
            ,shgref -- 
            ,fincod -- 
            ,fintyp -- 
            ,nraflg -- 
            ,qsqdbh -- 
            ,invnum -- 
            ,concur -- 
            ,conamt -- 
            ,comno -- 
            ,expmno -- 快递单号
            ,rcssta -- 追索权
            ,paytyp -- 付款类型
            ,clrmtd -- 清算方式
            ,bilpro -- 单据处理类型
            ,sndref -- 寄单索款编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bdd_op(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,ownusr -- 
            ,credat -- 
            ,opndat -- 
            ,clsdat -- 
            ,pnttyp -- 
            ,pntinr -- 
            ,predat -- 
            ,shpdat -- 
            ,spddat -- 
            ,totdat -- 
            ,advdat -- 
            ,matdat -- 
            ,rcvdat -- 
            ,disdat -- 
            ,docflg -- 
            ,rejflg -- 
            ,approvcod -- 
            ,relgodflg -- 
            ,relgoddat -- 
            ,trpdocnum -- 
            ,frepayflg -- 
            ,ver -- 
            ,advtyp -- 
            ,reltyp -- 
            ,expdat -- 
            ,rtoaplflg -- 
            ,trpdoctyp -- 
            ,tradat -- 
            ,tramod -- 
            ,mattxtflg -- 
            ,dscinsflg -- 
            ,docprbrol -- 
            ,docsta -- 
            ,igndisflg -- 
            ,totcur -- 
            ,totamt -- 
            ,payrol -- 
            ,acpnowflg -- 
            ,orddat -- 
            ,advdocflg -- 
            ,etyextkey -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,ngrcod -- 
            ,sgdinr -- 
            ,blnum -- 
            ,shgref -- 
            ,fincod -- 
            ,fintyp -- 
            ,nraflg -- 
            ,qsqdbh -- 
            ,invnum -- 
            ,concur -- 
            ,conamt -- 
            ,comno -- 
            ,expmno -- 快递单号
            ,rcssta -- 追索权
            ,paytyp -- 付款类型
            ,clrmtd -- 清算方式
            ,bilpro -- 单据处理类型
            ,sndref -- 寄单索款编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 
    ,o.ownref -- 
    ,o.nam -- 
    ,o.ownusr -- 
    ,o.credat -- 
    ,o.opndat -- 
    ,o.clsdat -- 
    ,o.pnttyp -- 
    ,o.pntinr -- 
    ,o.predat -- 
    ,o.shpdat -- 
    ,o.spddat -- 
    ,o.totdat -- 
    ,o.advdat -- 
    ,o.matdat -- 
    ,o.rcvdat -- 
    ,o.disdat -- 
    ,o.docflg -- 
    ,o.rejflg -- 
    ,o.approvcod -- 
    ,o.relgodflg -- 
    ,o.relgoddat -- 
    ,o.trpdocnum -- 
    ,o.frepayflg -- 
    ,o.ver -- 
    ,o.advtyp -- 
    ,o.reltyp -- 
    ,o.expdat -- 
    ,o.rtoaplflg -- 
    ,o.trpdoctyp -- 
    ,o.tradat -- 
    ,o.tramod -- 
    ,o.mattxtflg -- 
    ,o.dscinsflg -- 
    ,o.docprbrol -- 
    ,o.docsta -- 
    ,o.igndisflg -- 
    ,o.totcur -- 
    ,o.totamt -- 
    ,o.payrol -- 
    ,o.acpnowflg -- 
    ,o.orddat -- 
    ,o.advdocflg -- 
    ,o.etyextkey -- 
    ,o.bchkeyinr -- 
    ,o.branchinr -- 
    ,o.ngrcod -- 
    ,o.sgdinr -- 
    ,o.blnum -- 
    ,o.shgref -- 
    ,o.fincod -- 
    ,o.fintyp -- 
    ,o.nraflg -- 
    ,o.qsqdbh -- 
    ,o.invnum -- 
    ,o.concur -- 
    ,o.conamt -- 
    ,o.comno -- 
    ,o.expmno -- 快递单号
    ,o.rcssta -- 追索权
    ,o.paytyp -- 付款类型
    ,o.clrmtd -- 清算方式
    ,o.bilpro -- 单据处理类型
    ,o.sndref -- 寄单索款编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_bdd_bk o
    left join ${iol_schema}.isbs_bdd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bdd_cl d
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
-- truncate table ${iol_schema}.isbs_bdd;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_bdd exchange partition p_19000101 with table ${iol_schema}.isbs_bdd_cl;
alter table ${iol_schema}.isbs_bdd exchange partition p_20991231 with table ${iol_schema}.isbs_bdd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_bdd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bdd_op purge;
drop table ${iol_schema}.isbs_bdd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_bdd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_bdd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
