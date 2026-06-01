/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_bmd
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
create table ${iol_schema}.isbs_bmd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_bmd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bmd_op purge;
drop table ${iol_schema}.isbs_bmd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bmd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bmd where 0=1;

create table ${iol_schema}.isbs_bmd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bmd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bmd_cl(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,pnttyp -- 
            ,pntinr -- 
            ,predat -- 
            ,rcvdat -- 
            ,shpdat -- 
            ,advdat -- 
            ,matdat -- 
            ,doctypcod -- 
            ,opndat -- 
            ,clsdat -- 
            ,credat -- 
            ,ownusr -- 
            ,ver -- 
            ,approvcod -- 
            ,frepayflg -- 
            ,docprbrol -- 
            ,payrol -- 
            ,orddat -- 
            ,mattxtflg -- 
            ,dscinsflg -- 
            ,acpnowflg -- 
            ,advtyp -- 
            ,disdat -- 
            ,totcur -- 
            ,totamt -- 
            ,totdat -- 
            ,docsta -- 
            ,docrol -- 
            ,docrolflg -- 
            ,dta770snd -- 
            ,advdocflg -- 
            ,etyextkey -- 
            ,rmbrol -- 
            ,lescom -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,nraflg -- 
            ,clmcur -- 
            ,clmamt -- 
            ,expmno -- 快递单号
            ,rcssta -- 追索权
            ,paytyp -- 付款类型
            ,clrmtd -- 清算方式
            ,bilpro -- 单据处理类型
            ,dckref -- 到单编号
            ,isnegflg -- 议付标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bmd_op(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,pnttyp -- 
            ,pntinr -- 
            ,predat -- 
            ,rcvdat -- 
            ,shpdat -- 
            ,advdat -- 
            ,matdat -- 
            ,doctypcod -- 
            ,opndat -- 
            ,clsdat -- 
            ,credat -- 
            ,ownusr -- 
            ,ver -- 
            ,approvcod -- 
            ,frepayflg -- 
            ,docprbrol -- 
            ,payrol -- 
            ,orddat -- 
            ,mattxtflg -- 
            ,dscinsflg -- 
            ,acpnowflg -- 
            ,advtyp -- 
            ,disdat -- 
            ,totcur -- 
            ,totamt -- 
            ,totdat -- 
            ,docsta -- 
            ,docrol -- 
            ,docrolflg -- 
            ,dta770snd -- 
            ,advdocflg -- 
            ,etyextkey -- 
            ,rmbrol -- 
            ,lescom -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,nraflg -- 
            ,clmcur -- 
            ,clmamt -- 
            ,expmno -- 快递单号
            ,rcssta -- 追索权
            ,paytyp -- 付款类型
            ,clrmtd -- 清算方式
            ,bilpro -- 单据处理类型
            ,dckref -- 到单编号
            ,isnegflg -- 议付标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.ownref, o.ownref) as ownref -- 
    ,nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.pnttyp, o.pnttyp) as pnttyp -- 
    ,nvl(n.pntinr, o.pntinr) as pntinr -- 
    ,nvl(n.predat, o.predat) as predat -- 
    ,nvl(n.rcvdat, o.rcvdat) as rcvdat -- 
    ,nvl(n.shpdat, o.shpdat) as shpdat -- 
    ,nvl(n.advdat, o.advdat) as advdat -- 
    ,nvl(n.matdat, o.matdat) as matdat -- 
    ,nvl(n.doctypcod, o.doctypcod) as doctypcod -- 
    ,nvl(n.opndat, o.opndat) as opndat -- 
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 
    ,nvl(n.credat, o.credat) as credat -- 
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.approvcod, o.approvcod) as approvcod -- 
    ,nvl(n.frepayflg, o.frepayflg) as frepayflg -- 
    ,nvl(n.docprbrol, o.docprbrol) as docprbrol -- 
    ,nvl(n.payrol, o.payrol) as payrol -- 
    ,nvl(n.orddat, o.orddat) as orddat -- 
    ,nvl(n.mattxtflg, o.mattxtflg) as mattxtflg -- 
    ,nvl(n.dscinsflg, o.dscinsflg) as dscinsflg -- 
    ,nvl(n.acpnowflg, o.acpnowflg) as acpnowflg -- 
    ,nvl(n.advtyp, o.advtyp) as advtyp -- 
    ,nvl(n.disdat, o.disdat) as disdat -- 
    ,nvl(n.totcur, o.totcur) as totcur -- 
    ,nvl(n.totamt, o.totamt) as totamt -- 
    ,nvl(n.totdat, o.totdat) as totdat -- 
    ,nvl(n.docsta, o.docsta) as docsta -- 
    ,nvl(n.docrol, o.docrol) as docrol -- 
    ,nvl(n.docrolflg, o.docrolflg) as docrolflg -- 
    ,nvl(n.dta770snd, o.dta770snd) as dta770snd -- 
    ,nvl(n.advdocflg, o.advdocflg) as advdocflg -- 
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 
    ,nvl(n.rmbrol, o.rmbrol) as rmbrol -- 
    ,nvl(n.lescom, o.lescom) as lescom -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,nvl(n.nraflg, o.nraflg) as nraflg -- 
    ,nvl(n.clmcur, o.clmcur) as clmcur -- 
    ,nvl(n.clmamt, o.clmamt) as clmamt -- 
    ,nvl(n.expmno, o.expmno) as expmno -- 快递单号
    ,nvl(n.rcssta, o.rcssta) as rcssta -- 追索权
    ,nvl(n.paytyp, o.paytyp) as paytyp -- 付款类型
    ,nvl(n.clrmtd, o.clrmtd) as clrmtd -- 清算方式
    ,nvl(n.bilpro, o.bilpro) as bilpro -- 单据处理类型
    ,nvl(n.dckref, o.dckref) as dckref -- 到单编号
    ,nvl(n.isnegflg, o.isnegflg) as isnegflg -- 议付标志
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
from (select * from ${iol_schema}.isbs_bmd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_bmd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.pnttyp <> n.pnttyp
        or o.pntinr <> n.pntinr
        or o.predat <> n.predat
        or o.rcvdat <> n.rcvdat
        or o.shpdat <> n.shpdat
        or o.advdat <> n.advdat
        or o.matdat <> n.matdat
        or o.doctypcod <> n.doctypcod
        or o.opndat <> n.opndat
        or o.clsdat <> n.clsdat
        or o.credat <> n.credat
        or o.ownusr <> n.ownusr
        or o.ver <> n.ver
        or o.approvcod <> n.approvcod
        or o.frepayflg <> n.frepayflg
        or o.docprbrol <> n.docprbrol
        or o.payrol <> n.payrol
        or o.orddat <> n.orddat
        or o.mattxtflg <> n.mattxtflg
        or o.dscinsflg <> n.dscinsflg
        or o.acpnowflg <> n.acpnowflg
        or o.advtyp <> n.advtyp
        or o.disdat <> n.disdat
        or o.totcur <> n.totcur
        or o.totamt <> n.totamt
        or o.totdat <> n.totdat
        or o.docsta <> n.docsta
        or o.docrol <> n.docrol
        or o.docrolflg <> n.docrolflg
        or o.dta770snd <> n.dta770snd
        or o.advdocflg <> n.advdocflg
        or o.etyextkey <> n.etyextkey
        or o.rmbrol <> n.rmbrol
        or o.lescom <> n.lescom
        or o.bchkeyinr <> n.bchkeyinr
        or o.branchinr <> n.branchinr
        or o.nraflg <> n.nraflg
        or o.clmcur <> n.clmcur
        or o.clmamt <> n.clmamt
        or o.expmno <> n.expmno
        or o.rcssta <> n.rcssta
        or o.paytyp <> n.paytyp
        or o.clrmtd <> n.clrmtd
        or o.bilpro <> n.bilpro
        or o.dckref <> n.dckref
        or o.isnegflg <> n.isnegflg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bmd_cl(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,pnttyp -- 
            ,pntinr -- 
            ,predat -- 
            ,rcvdat -- 
            ,shpdat -- 
            ,advdat -- 
            ,matdat -- 
            ,doctypcod -- 
            ,opndat -- 
            ,clsdat -- 
            ,credat -- 
            ,ownusr -- 
            ,ver -- 
            ,approvcod -- 
            ,frepayflg -- 
            ,docprbrol -- 
            ,payrol -- 
            ,orddat -- 
            ,mattxtflg -- 
            ,dscinsflg -- 
            ,acpnowflg -- 
            ,advtyp -- 
            ,disdat -- 
            ,totcur -- 
            ,totamt -- 
            ,totdat -- 
            ,docsta -- 
            ,docrol -- 
            ,docrolflg -- 
            ,dta770snd -- 
            ,advdocflg -- 
            ,etyextkey -- 
            ,rmbrol -- 
            ,lescom -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,nraflg -- 
            ,clmcur -- 
            ,clmamt -- 
            ,expmno -- 快递单号
            ,rcssta -- 追索权
            ,paytyp -- 付款类型
            ,clrmtd -- 清算方式
            ,bilpro -- 单据处理类型
            ,dckref -- 到单编号
            ,isnegflg -- 议付标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bmd_op(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,pnttyp -- 
            ,pntinr -- 
            ,predat -- 
            ,rcvdat -- 
            ,shpdat -- 
            ,advdat -- 
            ,matdat -- 
            ,doctypcod -- 
            ,opndat -- 
            ,clsdat -- 
            ,credat -- 
            ,ownusr -- 
            ,ver -- 
            ,approvcod -- 
            ,frepayflg -- 
            ,docprbrol -- 
            ,payrol -- 
            ,orddat -- 
            ,mattxtflg -- 
            ,dscinsflg -- 
            ,acpnowflg -- 
            ,advtyp -- 
            ,disdat -- 
            ,totcur -- 
            ,totamt -- 
            ,totdat -- 
            ,docsta -- 
            ,docrol -- 
            ,docrolflg -- 
            ,dta770snd -- 
            ,advdocflg -- 
            ,etyextkey -- 
            ,rmbrol -- 
            ,lescom -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,nraflg -- 
            ,clmcur -- 
            ,clmamt -- 
            ,expmno -- 快递单号
            ,rcssta -- 追索权
            ,paytyp -- 付款类型
            ,clrmtd -- 清算方式
            ,bilpro -- 单据处理类型
            ,dckref -- 到单编号
            ,isnegflg -- 议付标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 
    ,o.ownref -- 
    ,o.nam -- 
    ,o.pnttyp -- 
    ,o.pntinr -- 
    ,o.predat -- 
    ,o.rcvdat -- 
    ,o.shpdat -- 
    ,o.advdat -- 
    ,o.matdat -- 
    ,o.doctypcod -- 
    ,o.opndat -- 
    ,o.clsdat -- 
    ,o.credat -- 
    ,o.ownusr -- 
    ,o.ver -- 
    ,o.approvcod -- 
    ,o.frepayflg -- 
    ,o.docprbrol -- 
    ,o.payrol -- 
    ,o.orddat -- 
    ,o.mattxtflg -- 
    ,o.dscinsflg -- 
    ,o.acpnowflg -- 
    ,o.advtyp -- 
    ,o.disdat -- 
    ,o.totcur -- 
    ,o.totamt -- 
    ,o.totdat -- 
    ,o.docsta -- 
    ,o.docrol -- 
    ,o.docrolflg -- 
    ,o.dta770snd -- 
    ,o.advdocflg -- 
    ,o.etyextkey -- 
    ,o.rmbrol -- 
    ,o.lescom -- 
    ,o.bchkeyinr -- 
    ,o.branchinr -- 
    ,o.nraflg -- 
    ,o.clmcur -- 
    ,o.clmamt -- 
    ,o.expmno -- 快递单号
    ,o.rcssta -- 追索权
    ,o.paytyp -- 付款类型
    ,o.clrmtd -- 清算方式
    ,o.bilpro -- 单据处理类型
    ,o.dckref -- 到单编号
    ,o.isnegflg -- 议付标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_bmd_bk o
    left join ${iol_schema}.isbs_bmd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bmd_cl d
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
-- truncate table ${iol_schema}.isbs_bmd;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_bmd exchange partition p_19000101 with table ${iol_schema}.isbs_bmd_cl;
alter table ${iol_schema}.isbs_bmd exchange partition p_20991231 with table ${iol_schema}.isbs_bmd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_bmd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bmd_op purge;
drop table ${iol_schema}.isbs_bmd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_bmd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_bmd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
