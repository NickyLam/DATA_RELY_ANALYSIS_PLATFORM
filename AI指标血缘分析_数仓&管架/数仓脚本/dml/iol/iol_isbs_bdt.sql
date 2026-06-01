/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_bdt
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
create table ${iol_schema}.isbs_bdt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_bdt;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bdt_op purge;
drop table ${iol_schema}.isbs_bdt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bdt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bdt where 0=1;

create table ${iol_schema}.isbs_bdt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bdt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bdt_cl(
            inr -- 
            ,docdis -- 
            ,docins -- 
            ,prsdoc -- 
            ,disdoc -- 
            ,aplins -- 
            ,matper -- 
            ,comcon -- 
            ,setinsbr -- 
            ,roggod -- 
            ,pordis -- 
            ,delplc -- 
            ,vesnam -- 
            ,relstoadr -- 
            ,chaded -- 
            ,chaadd -- 
            ,fldmodblk -- 
            ,nartxt77a -- 
            ,contag72 -- 
            ,contag79 -- 
            ,docdisdef -- 
            ,docdisflg -- 
            ,disdocdef -- 
            ,disdocflg -- 
            ,porlod -- 
            ,notpty -- 
            ,voynum -- 
            ,carnam -- 
            ,ctrstm -- 
            ,sndrmk -- 寄单索款修改备注
            ,accrmk -- 到期付款确认备注
            ,dcrrmk  -- 拒付备注
            ,setrmk  -- 付款备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bdt_op(
            inr -- 
            ,docdis -- 
            ,docins -- 
            ,prsdoc -- 
            ,disdoc -- 
            ,aplins -- 
            ,matper -- 
            ,comcon -- 
            ,setinsbr -- 
            ,roggod -- 
            ,pordis -- 
            ,delplc -- 
            ,vesnam -- 
            ,relstoadr -- 
            ,chaded -- 
            ,chaadd -- 
            ,fldmodblk -- 
            ,nartxt77a -- 
            ,contag72 -- 
            ,contag79 -- 
            ,docdisdef -- 
            ,docdisflg -- 
            ,disdocdef -- 
            ,disdocflg -- 
            ,porlod -- 
            ,notpty -- 
            ,voynum -- 
            ,carnam -- 
            ,ctrstm -- 
            ,sndrmk -- 寄单索款修改备注
            ,accrmk -- 到期付款确认备注
            ,dcrrmk  -- 拒付备注
            ,setrmk  -- 付款备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.docdis, o.docdis) as docdis -- 
    ,nvl(n.docins, o.docins) as docins -- 
    ,nvl(n.prsdoc, o.prsdoc) as prsdoc -- 
    ,nvl(n.disdoc, o.disdoc) as disdoc -- 
    ,nvl(n.aplins, o.aplins) as aplins -- 
    ,nvl(n.matper, o.matper) as matper -- 
    ,nvl(n.comcon, o.comcon) as comcon -- 
    ,nvl(n.setinsbr, o.setinsbr) as setinsbr -- 
    ,nvl(n.roggod, o.roggod) as roggod -- 
    ,nvl(n.pordis, o.pordis) as pordis -- 
    ,nvl(n.delplc, o.delplc) as delplc -- 
    ,nvl(n.vesnam, o.vesnam) as vesnam -- 
    ,nvl(n.relstoadr, o.relstoadr) as relstoadr -- 
    ,nvl(n.chaded, o.chaded) as chaded -- 
    ,nvl(n.chaadd, o.chaadd) as chaadd -- 
    ,nvl(n.fldmodblk, o.fldmodblk) as fldmodblk -- 
    ,nvl(n.nartxt77a, o.nartxt77a) as nartxt77a -- 
    ,nvl(n.contag72, o.contag72) as contag72 -- 
    ,nvl(n.contag79, o.contag79) as contag79 -- 
    ,nvl(n.docdisdef, o.docdisdef) as docdisdef -- 
    ,nvl(n.docdisflg, o.docdisflg) as docdisflg -- 
    ,nvl(n.disdocdef, o.disdocdef) as disdocdef -- 
    ,nvl(n.disdocflg, o.disdocflg) as disdocflg -- 
    ,nvl(n.porlod, o.porlod) as porlod -- 
    ,nvl(n.notpty, o.notpty) as notpty -- 
    ,nvl(n.voynum, o.voynum) as voynum -- 
    ,nvl(n.carnam, o.carnam) as carnam -- 
    ,nvl(n.ctrstm, o.ctrstm) as ctrstm -- 
    ,nvl(n.sndrmk, o.sndrmk) as sndrmk -- 寄单索款修改备注
    ,nvl(n.accrmk, o.accrmk) as accrmk -- 到期付款确认备注
    ,nvl(n.dcrrmk , o.dcrrmk ) as dcrrmk  -- 拒付备注
    ,nvl(n.setrmk , o.setrmk ) as setrmk  -- 付款备注
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
from (select * from ${iol_schema}.isbs_bdt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_bdt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.docdis <> n.docdis
        or o.docins <> n.docins
        or o.prsdoc <> n.prsdoc
        or o.disdoc <> n.disdoc
        or o.aplins <> n.aplins
        or o.matper <> n.matper
        or o.comcon <> n.comcon
        or o.setinsbr <> n.setinsbr
        or o.roggod <> n.roggod
        or o.pordis <> n.pordis
        or o.delplc <> n.delplc
        or o.vesnam <> n.vesnam
        or o.relstoadr <> n.relstoadr
        or o.chaded <> n.chaded
        or o.chaadd <> n.chaadd
        or o.fldmodblk <> n.fldmodblk
        or o.nartxt77a <> n.nartxt77a
        or o.contag72 <> n.contag72
        or o.contag79 <> n.contag79
        or o.docdisdef <> n.docdisdef
        or o.docdisflg <> n.docdisflg
        or o.disdocdef <> n.disdocdef
        or o.disdocflg <> n.disdocflg
        or o.porlod <> n.porlod
        or o.notpty <> n.notpty
        or o.voynum <> n.voynum
        or o.carnam <> n.carnam
        or o.ctrstm <> n.ctrstm
        or o.sndrmk <> n.sndrmk
        or o.accrmk <> n.accrmk
        or o.dcrrmk  <> n.dcrrmk 
        or o.setrmk  <> n.setrmk 
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bdt_cl(
            inr -- 
            ,docdis -- 
            ,docins -- 
            ,prsdoc -- 
            ,disdoc -- 
            ,aplins -- 
            ,matper -- 
            ,comcon -- 
            ,setinsbr -- 
            ,roggod -- 
            ,pordis -- 
            ,delplc -- 
            ,vesnam -- 
            ,relstoadr -- 
            ,chaded -- 
            ,chaadd -- 
            ,fldmodblk -- 
            ,nartxt77a -- 
            ,contag72 -- 
            ,contag79 -- 
            ,docdisdef -- 
            ,docdisflg -- 
            ,disdocdef -- 
            ,disdocflg -- 
            ,porlod -- 
            ,notpty -- 
            ,voynum -- 
            ,carnam -- 
            ,ctrstm -- 
            ,sndrmk -- 寄单索款修改备注
            ,accrmk -- 到期付款确认备注
            ,dcrrmk  -- 拒付备注
            ,setrmk  -- 付款备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bdt_op(
            inr -- 
            ,docdis -- 
            ,docins -- 
            ,prsdoc -- 
            ,disdoc -- 
            ,aplins -- 
            ,matper -- 
            ,comcon -- 
            ,setinsbr -- 
            ,roggod -- 
            ,pordis -- 
            ,delplc -- 
            ,vesnam -- 
            ,relstoadr -- 
            ,chaded -- 
            ,chaadd -- 
            ,fldmodblk -- 
            ,nartxt77a -- 
            ,contag72 -- 
            ,contag79 -- 
            ,docdisdef -- 
            ,docdisflg -- 
            ,disdocdef -- 
            ,disdocflg -- 
            ,porlod -- 
            ,notpty -- 
            ,voynum -- 
            ,carnam -- 
            ,ctrstm -- 
            ,sndrmk -- 寄单索款修改备注
            ,accrmk -- 到期付款确认备注
            ,dcrrmk  -- 拒付备注
            ,setrmk  -- 付款备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 
    ,o.docdis -- 
    ,o.docins -- 
    ,o.prsdoc -- 
    ,o.disdoc -- 
    ,o.aplins -- 
    ,o.matper -- 
    ,o.comcon -- 
    ,o.setinsbr -- 
    ,o.roggod -- 
    ,o.pordis -- 
    ,o.delplc -- 
    ,o.vesnam -- 
    ,o.relstoadr -- 
    ,o.chaded -- 
    ,o.chaadd -- 
    ,o.fldmodblk -- 
    ,o.nartxt77a -- 
    ,o.contag72 -- 
    ,o.contag79 -- 
    ,o.docdisdef -- 
    ,o.docdisflg -- 
    ,o.disdocdef -- 
    ,o.disdocflg -- 
    ,o.porlod -- 
    ,o.notpty -- 
    ,o.voynum -- 
    ,o.carnam -- 
    ,o.ctrstm -- 
    ,o.sndrmk -- 寄单索款修改备注
    ,o.accrmk -- 到期付款确认备注
    ,o.dcrrmk  -- 拒付备注
    ,o.setrmk  -- 付款备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_bdt_bk o
    left join ${iol_schema}.isbs_bdt_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bdt_cl d
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
-- truncate table ${iol_schema}.isbs_bdt;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_bdt exchange partition p_19000101 with table ${iol_schema}.isbs_bdt_cl;
alter table ${iol_schema}.isbs_bdt exchange partition p_20991231 with table ${iol_schema}.isbs_bdt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_bdt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bdt_op purge;
drop table ${iol_schema}.isbs_bdt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_bdt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_bdt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
