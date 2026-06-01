/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_ltd
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
create table ${iol_schema}.isbs_ltd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_ltd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ltd_op purge;
drop table ${iol_schema}.isbs_ltd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ltd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ltd where 0=1;

create table ${iol_schema}.isbs_ltd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ltd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ltd_cl(
            avbwth -- 
            ,stacty -- 
            ,spcbenflg -- 
            ,chato -- 
            ,nomtop -- 
            ,nomton -- 
            ,expplc -- 
            ,inr -- 
            ,shpto -- 
            ,avbby -- 
            ,adlflg -- 
            ,prepers18 -- 
            ,ver -- 
            ,porloa -- 
            ,shpfro -- 
            ,amedat -- 
            ,shptrs -- 
            ,credat -- 
            ,redclsflg -- 
            ,prepertxts18 -- 
            ,lcrtyp -- 
            ,ownref -- 
            ,clsdat -- 
            ,nam -- 
            ,tenmaxday -- 
            ,rmbcha -- 
            ,shppar -- 
            ,nomspc -- 
            ,ledinr -- 
            ,advnbr -- 
            ,apprul -- 
            ,shppars18 -- 
            ,docsubflg -- 
            ,expdat -- 
            ,shpdat -- 
            ,pordis -- 
            ,spcrcbflg -- 
            ,rmbflg -- 
            ,amenbr -- 
            ,apprulrmb -- 
            ,utlnbr -- 
            ,ownusr -- 
            ,etyextkey -- 
            ,opndat -- 
            ,shptrss18 -- 
            ,cnfins -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,apprultxt -- 
            ,autdat -- 
            ,rmbact -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ltd_op(
            avbwth -- 
            ,stacty -- 
            ,spcbenflg -- 
            ,chato -- 
            ,nomtop -- 
            ,nomton -- 
            ,expplc -- 
            ,inr -- 
            ,shpto -- 
            ,avbby -- 
            ,adlflg -- 
            ,prepers18 -- 
            ,ver -- 
            ,porloa -- 
            ,shpfro -- 
            ,amedat -- 
            ,shptrs -- 
            ,credat -- 
            ,redclsflg -- 
            ,prepertxts18 -- 
            ,lcrtyp -- 
            ,ownref -- 
            ,clsdat -- 
            ,nam -- 
            ,tenmaxday -- 
            ,rmbcha -- 
            ,shppar -- 
            ,nomspc -- 
            ,ledinr -- 
            ,advnbr -- 
            ,apprul -- 
            ,shppars18 -- 
            ,docsubflg -- 
            ,expdat -- 
            ,shpdat -- 
            ,pordis -- 
            ,spcrcbflg -- 
            ,rmbflg -- 
            ,amenbr -- 
            ,apprulrmb -- 
            ,utlnbr -- 
            ,ownusr -- 
            ,etyextkey -- 
            ,opndat -- 
            ,shptrss18 -- 
            ,cnfins -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,apprultxt -- 
            ,autdat -- 
            ,rmbact -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.avbwth, o.avbwth) as avbwth -- 
    ,nvl(n.stacty, o.stacty) as stacty -- 
    ,nvl(n.spcbenflg, o.spcbenflg) as spcbenflg -- 
    ,nvl(n.chato, o.chato) as chato -- 
    ,nvl(n.nomtop, o.nomtop) as nomtop -- 
    ,nvl(n.nomton, o.nomton) as nomton -- 
    ,nvl(n.expplc, o.expplc) as expplc -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.shpto, o.shpto) as shpto -- 
    ,nvl(n.avbby, o.avbby) as avbby -- 
    ,nvl(n.adlflg, o.adlflg) as adlflg -- 
    ,nvl(n.prepers18, o.prepers18) as prepers18 -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.porloa, o.porloa) as porloa -- 
    ,nvl(n.shpfro, o.shpfro) as shpfro -- 
    ,nvl(n.amedat, o.amedat) as amedat -- 
    ,nvl(n.shptrs, o.shptrs) as shptrs -- 
    ,nvl(n.credat, o.credat) as credat -- 
    ,nvl(n.redclsflg, o.redclsflg) as redclsflg -- 
    ,nvl(n.prepertxts18, o.prepertxts18) as prepertxts18 -- 
    ,nvl(n.lcrtyp, o.lcrtyp) as lcrtyp -- 
    ,nvl(n.ownref, o.ownref) as ownref -- 
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 
    ,nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.tenmaxday, o.tenmaxday) as tenmaxday -- 
    ,nvl(n.rmbcha, o.rmbcha) as rmbcha -- 
    ,nvl(n.shppar, o.shppar) as shppar -- 
    ,nvl(n.nomspc, o.nomspc) as nomspc -- 
    ,nvl(n.ledinr, o.ledinr) as ledinr -- 
    ,nvl(n.advnbr, o.advnbr) as advnbr -- 
    ,nvl(n.apprul, o.apprul) as apprul -- 
    ,nvl(n.shppars18, o.shppars18) as shppars18 -- 
    ,nvl(n.docsubflg, o.docsubflg) as docsubflg -- 
    ,nvl(n.expdat, o.expdat) as expdat -- 
    ,nvl(n.shpdat, o.shpdat) as shpdat -- 
    ,nvl(n.pordis, o.pordis) as pordis -- 
    ,nvl(n.spcrcbflg, o.spcrcbflg) as spcrcbflg -- 
    ,nvl(n.rmbflg, o.rmbflg) as rmbflg -- 
    ,nvl(n.amenbr, o.amenbr) as amenbr -- 
    ,nvl(n.apprulrmb, o.apprulrmb) as apprulrmb -- 
    ,nvl(n.utlnbr, o.utlnbr) as utlnbr -- 
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 
    ,nvl(n.opndat, o.opndat) as opndat -- 
    ,nvl(n.shptrss18, o.shptrss18) as shptrss18 -- 
    ,nvl(n.cnfins, o.cnfins) as cnfins -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.apprultxt, o.apprultxt) as apprultxt -- 
    ,nvl(n.autdat, o.autdat) as autdat -- 
    ,nvl(n.rmbact, o.rmbact) as rmbact -- 
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
from (select * from ${iol_schema}.isbs_ltd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_ltd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.avbwth <> n.avbwth
        or o.stacty <> n.stacty
        or o.spcbenflg <> n.spcbenflg
        or o.chato <> n.chato
        or o.nomtop <> n.nomtop
        or o.nomton <> n.nomton
        or o.expplc <> n.expplc
        or o.shpto <> n.shpto
        or o.avbby <> n.avbby
        or o.adlflg <> n.adlflg
        or o.prepers18 <> n.prepers18
        or o.ver <> n.ver
        or o.porloa <> n.porloa
        or o.shpfro <> n.shpfro
        or o.amedat <> n.amedat
        or o.shptrs <> n.shptrs
        or o.credat <> n.credat
        or o.redclsflg <> n.redclsflg
        or o.prepertxts18 <> n.prepertxts18
        or o.lcrtyp <> n.lcrtyp
        or o.ownref <> n.ownref
        or o.clsdat <> n.clsdat
        or o.nam <> n.nam
        or o.tenmaxday <> n.tenmaxday
        or o.rmbcha <> n.rmbcha
        or o.shppar <> n.shppar
        or o.nomspc <> n.nomspc
        or o.ledinr <> n.ledinr
        or o.advnbr <> n.advnbr
        or o.apprul <> n.apprul
        or o.shppars18 <> n.shppars18
        or o.docsubflg <> n.docsubflg
        or o.expdat <> n.expdat
        or o.shpdat <> n.shpdat
        or o.pordis <> n.pordis
        or o.spcrcbflg <> n.spcrcbflg
        or o.rmbflg <> n.rmbflg
        or o.amenbr <> n.amenbr
        or o.apprulrmb <> n.apprulrmb
        or o.utlnbr <> n.utlnbr
        or o.ownusr <> n.ownusr
        or o.etyextkey <> n.etyextkey
        or o.opndat <> n.opndat
        or o.shptrss18 <> n.shptrss18
        or o.cnfins <> n.cnfins
        or o.branchinr <> n.branchinr
        or o.bchkeyinr <> n.bchkeyinr
        or o.apprultxt <> n.apprultxt
        or o.autdat <> n.autdat
        or o.rmbact <> n.rmbact
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ltd_cl(
            avbwth -- 
            ,stacty -- 
            ,spcbenflg -- 
            ,chato -- 
            ,nomtop -- 
            ,nomton -- 
            ,expplc -- 
            ,inr -- 
            ,shpto -- 
            ,avbby -- 
            ,adlflg -- 
            ,prepers18 -- 
            ,ver -- 
            ,porloa -- 
            ,shpfro -- 
            ,amedat -- 
            ,shptrs -- 
            ,credat -- 
            ,redclsflg -- 
            ,prepertxts18 -- 
            ,lcrtyp -- 
            ,ownref -- 
            ,clsdat -- 
            ,nam -- 
            ,tenmaxday -- 
            ,rmbcha -- 
            ,shppar -- 
            ,nomspc -- 
            ,ledinr -- 
            ,advnbr -- 
            ,apprul -- 
            ,shppars18 -- 
            ,docsubflg -- 
            ,expdat -- 
            ,shpdat -- 
            ,pordis -- 
            ,spcrcbflg -- 
            ,rmbflg -- 
            ,amenbr -- 
            ,apprulrmb -- 
            ,utlnbr -- 
            ,ownusr -- 
            ,etyextkey -- 
            ,opndat -- 
            ,shptrss18 -- 
            ,cnfins -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,apprultxt -- 
            ,autdat -- 
            ,rmbact -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ltd_op(
            avbwth -- 
            ,stacty -- 
            ,spcbenflg -- 
            ,chato -- 
            ,nomtop -- 
            ,nomton -- 
            ,expplc -- 
            ,inr -- 
            ,shpto -- 
            ,avbby -- 
            ,adlflg -- 
            ,prepers18 -- 
            ,ver -- 
            ,porloa -- 
            ,shpfro -- 
            ,amedat -- 
            ,shptrs -- 
            ,credat -- 
            ,redclsflg -- 
            ,prepertxts18 -- 
            ,lcrtyp -- 
            ,ownref -- 
            ,clsdat -- 
            ,nam -- 
            ,tenmaxday -- 
            ,rmbcha -- 
            ,shppar -- 
            ,nomspc -- 
            ,ledinr -- 
            ,advnbr -- 
            ,apprul -- 
            ,shppars18 -- 
            ,docsubflg -- 
            ,expdat -- 
            ,shpdat -- 
            ,pordis -- 
            ,spcrcbflg -- 
            ,rmbflg -- 
            ,amenbr -- 
            ,apprulrmb -- 
            ,utlnbr -- 
            ,ownusr -- 
            ,etyextkey -- 
            ,opndat -- 
            ,shptrss18 -- 
            ,cnfins -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,apprultxt -- 
            ,autdat -- 
            ,rmbact -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.avbwth -- 
    ,o.stacty -- 
    ,o.spcbenflg -- 
    ,o.chato -- 
    ,o.nomtop -- 
    ,o.nomton -- 
    ,o.expplc -- 
    ,o.inr -- 
    ,o.shpto -- 
    ,o.avbby -- 
    ,o.adlflg -- 
    ,o.prepers18 -- 
    ,o.ver -- 
    ,o.porloa -- 
    ,o.shpfro -- 
    ,o.amedat -- 
    ,o.shptrs -- 
    ,o.credat -- 
    ,o.redclsflg -- 
    ,o.prepertxts18 -- 
    ,o.lcrtyp -- 
    ,o.ownref -- 
    ,o.clsdat -- 
    ,o.nam -- 
    ,o.tenmaxday -- 
    ,o.rmbcha -- 
    ,o.shppar -- 
    ,o.nomspc -- 
    ,o.ledinr -- 
    ,o.advnbr -- 
    ,o.apprul -- 
    ,o.shppars18 -- 
    ,o.docsubflg -- 
    ,o.expdat -- 
    ,o.shpdat -- 
    ,o.pordis -- 
    ,o.spcrcbflg -- 
    ,o.rmbflg -- 
    ,o.amenbr -- 
    ,o.apprulrmb -- 
    ,o.utlnbr -- 
    ,o.ownusr -- 
    ,o.etyextkey -- 
    ,o.opndat -- 
    ,o.shptrss18 -- 
    ,o.cnfins -- 
    ,o.branchinr -- 
    ,o.bchkeyinr -- 
    ,o.apprultxt -- 
    ,o.autdat -- 
    ,o.rmbact -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_ltd_bk o
    left join ${iol_schema}.isbs_ltd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_ltd_cl d
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
-- truncate table ${iol_schema}.isbs_ltd;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_ltd exchange partition p_19000101 with table ${iol_schema}.isbs_ltd_cl;
alter table ${iol_schema}.isbs_ltd exchange partition p_20991231 with table ${iol_schema}.isbs_ltd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_ltd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ltd_op purge;
drop table ${iol_schema}.isbs_ltd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_ltd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_ltd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
