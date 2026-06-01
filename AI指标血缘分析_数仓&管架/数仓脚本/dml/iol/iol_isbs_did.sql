/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_did
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
create table ${iol_schema}.isbs_did_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_did
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_did_op purge;
drop table ${iol_schema}.isbs_did_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_did_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_did where 0=1;

create table ${iol_schema}.isbs_did_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_did where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_did_cl(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,ownusr -- 
            ,credat -- 
            ,opndat -- 
            ,clsdat -- 
            ,advnam -- 
            ,advref -- 
            ,amedat -- 
            ,amenbr -- 
            ,aplnam -- 
            ,aplref -- 
            ,avbby -- 
            ,avbwth -- 
            ,bennam -- 
            ,benref -- 
            ,chato -- 
            ,cnfdet -- 
            ,expdat -- 
            ,expplc -- 
            ,lcrtyp -- 
            ,nomspc -- 
            ,nomtop -- 
            ,nomton -- 
            ,preadvdt -- 
            ,rmbact -- 
            ,rmbcha -- 
            ,rmbflg -- 
            ,shpdat -- 
            ,shpfro -- 
            ,porloa -- 
            ,pordis -- 
            ,shppar -- 
            ,shpto -- 
            ,shptrs -- 
            ,stacty -- 
            ,stagod -- 
            ,utlnbr -- 
            ,advnbr -- 
            ,redclsflg -- 
            ,ver -- 
            ,lcityp -- 
            ,b2binr -- 
            ,b2bref -- 
            ,revnbr -- 
            ,revtimes -- 
            ,revflg -- 
            ,revawapl -- 
            ,revdat -- 
            ,revcum -- 
            ,revtyp -- 
            ,initpty -- 
            ,resflg -- 
            ,apprul -- 
            ,apprulrmb -- 
            ,apprultxt -- 
            ,autdat -- 
            ,etyextkey -- 
            ,tenmaxday -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,decflg -- 
            ,cshpct -- 
            ,isstyp -- 
            ,fincod -- 
            ,fintyp -- 
            ,relcshpct -- 
            ,jjh -- 
            ,guaflg -- 
            ,tratyp -- 
            ,opnamo -- 
            ,ameflg -- 
            ,cretyp -- 
            ,tadtyp -- 
            ,shpins -- 
            ,sermod -- 
            ,serfro -- 
            ,comflg -- 
            ,insdat -- 
            ,contractno -- 
            ,negflg -- 
            ,elcflg -- 通过电证标志
            ,concur -- 合同币种
            ,conamt -- 合同金额
            ,rejame -- 拒绝修改标志
            ,cantyp -- 闭卷类型
            ,rejflg -- 拒绝通知标志
            ,tzref -- 通知行编号
            ,nomtop1 -- 上浮金额（elcs）
            ,nomton1 -- 下浮金额（elcs）
            ,zytyp -- 质押类型
            ,productname -- 货物名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_did_op(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,ownusr -- 
            ,credat -- 
            ,opndat -- 
            ,clsdat -- 
            ,advnam -- 
            ,advref -- 
            ,amedat -- 
            ,amenbr -- 
            ,aplnam -- 
            ,aplref -- 
            ,avbby -- 
            ,avbwth -- 
            ,bennam -- 
            ,benref -- 
            ,chato -- 
            ,cnfdet -- 
            ,expdat -- 
            ,expplc -- 
            ,lcrtyp -- 
            ,nomspc -- 
            ,nomtop -- 
            ,nomton -- 
            ,preadvdt -- 
            ,rmbact -- 
            ,rmbcha -- 
            ,rmbflg -- 
            ,shpdat -- 
            ,shpfro -- 
            ,porloa -- 
            ,pordis -- 
            ,shppar -- 
            ,shpto -- 
            ,shptrs -- 
            ,stacty -- 
            ,stagod -- 
            ,utlnbr -- 
            ,advnbr -- 
            ,redclsflg -- 
            ,ver -- 
            ,lcityp -- 
            ,b2binr -- 
            ,b2bref -- 
            ,revnbr -- 
            ,revtimes -- 
            ,revflg -- 
            ,revawapl -- 
            ,revdat -- 
            ,revcum -- 
            ,revtyp -- 
            ,initpty -- 
            ,resflg -- 
            ,apprul -- 
            ,apprulrmb -- 
            ,apprultxt -- 
            ,autdat -- 
            ,etyextkey -- 
            ,tenmaxday -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,decflg -- 
            ,cshpct -- 
            ,isstyp -- 
            ,fincod -- 
            ,fintyp -- 
            ,relcshpct -- 
            ,jjh -- 
            ,guaflg -- 
            ,tratyp -- 
            ,opnamo -- 
            ,ameflg -- 
            ,cretyp -- 
            ,tadtyp -- 
            ,shpins -- 
            ,sermod -- 
            ,serfro -- 
            ,comflg -- 
            ,insdat -- 
            ,contractno -- 
            ,negflg -- 
            ,elcflg -- 通过电证标志
            ,concur -- 合同币种
            ,conamt -- 合同金额
            ,rejame -- 拒绝修改标志
            ,cantyp -- 闭卷类型
            ,rejflg -- 拒绝通知标志
            ,tzref -- 通知行编号
            ,nomtop1 -- 上浮金额（elcs）
            ,nomton1 -- 下浮金额（elcs）
            ,zytyp -- 质押类型
            ,productname -- 货物名称
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
    ,nvl(n.advnam, o.advnam) as advnam -- 
    ,nvl(n.advref, o.advref) as advref -- 
    ,nvl(n.amedat, o.amedat) as amedat -- 
    ,nvl(n.amenbr, o.amenbr) as amenbr -- 
    ,nvl(n.aplnam, o.aplnam) as aplnam -- 
    ,nvl(n.aplref, o.aplref) as aplref -- 
    ,nvl(n.avbby, o.avbby) as avbby -- 
    ,nvl(n.avbwth, o.avbwth) as avbwth -- 
    ,nvl(n.bennam, o.bennam) as bennam -- 
    ,nvl(n.benref, o.benref) as benref -- 
    ,nvl(n.chato, o.chato) as chato -- 
    ,nvl(n.cnfdet, o.cnfdet) as cnfdet -- 
    ,nvl(n.expdat, o.expdat) as expdat -- 
    ,nvl(n.expplc, o.expplc) as expplc -- 
    ,nvl(n.lcrtyp, o.lcrtyp) as lcrtyp -- 
    ,nvl(n.nomspc, o.nomspc) as nomspc -- 
    ,nvl(n.nomtop, o.nomtop) as nomtop -- 
    ,nvl(n.nomton, o.nomton) as nomton -- 
    ,nvl(n.preadvdt, o.preadvdt) as preadvdt -- 
    ,nvl(n.rmbact, o.rmbact) as rmbact -- 
    ,nvl(n.rmbcha, o.rmbcha) as rmbcha -- 
    ,nvl(n.rmbflg, o.rmbflg) as rmbflg -- 
    ,nvl(n.shpdat, o.shpdat) as shpdat -- 
    ,nvl(n.shpfro, o.shpfro) as shpfro -- 
    ,nvl(n.porloa, o.porloa) as porloa -- 
    ,nvl(n.pordis, o.pordis) as pordis -- 
    ,nvl(n.shppar, o.shppar) as shppar -- 
    ,nvl(n.shpto, o.shpto) as shpto -- 
    ,nvl(n.shptrs, o.shptrs) as shptrs -- 
    ,nvl(n.stacty, o.stacty) as stacty -- 
    ,nvl(n.stagod, o.stagod) as stagod -- 
    ,nvl(n.utlnbr, o.utlnbr) as utlnbr -- 
    ,nvl(n.advnbr, o.advnbr) as advnbr -- 
    ,nvl(n.redclsflg, o.redclsflg) as redclsflg -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.lcityp, o.lcityp) as lcityp -- 
    ,nvl(n.b2binr, o.b2binr) as b2binr -- 
    ,nvl(n.b2bref, o.b2bref) as b2bref -- 
    ,nvl(n.revnbr, o.revnbr) as revnbr -- 
    ,nvl(n.revtimes, o.revtimes) as revtimes -- 
    ,nvl(n.revflg, o.revflg) as revflg -- 
    ,nvl(n.revawapl, o.revawapl) as revawapl -- 
    ,nvl(n.revdat, o.revdat) as revdat -- 
    ,nvl(n.revcum, o.revcum) as revcum -- 
    ,nvl(n.revtyp, o.revtyp) as revtyp -- 
    ,nvl(n.initpty, o.initpty) as initpty -- 
    ,nvl(n.resflg, o.resflg) as resflg -- 
    ,nvl(n.apprul, o.apprul) as apprul -- 
    ,nvl(n.apprulrmb, o.apprulrmb) as apprulrmb -- 
    ,nvl(n.apprultxt, o.apprultxt) as apprultxt -- 
    ,nvl(n.autdat, o.autdat) as autdat -- 
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 
    ,nvl(n.tenmaxday, o.tenmaxday) as tenmaxday -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.decflg, o.decflg) as decflg -- 
    ,nvl(n.cshpct, o.cshpct) as cshpct -- 
    ,nvl(n.isstyp, o.isstyp) as isstyp -- 
    ,nvl(n.fincod, o.fincod) as fincod -- 
    ,nvl(n.fintyp, o.fintyp) as fintyp -- 
    ,nvl(n.relcshpct, o.relcshpct) as relcshpct -- 
    ,nvl(n.jjh, o.jjh) as jjh -- 
    ,nvl(n.guaflg, o.guaflg) as guaflg -- 
    ,nvl(n.tratyp, o.tratyp) as tratyp -- 
    ,nvl(n.opnamo, o.opnamo) as opnamo -- 
    ,nvl(n.ameflg, o.ameflg) as ameflg -- 
    ,nvl(n.cretyp, o.cretyp) as cretyp -- 
    ,nvl(n.tadtyp, o.tadtyp) as tadtyp -- 
    ,nvl(n.shpins, o.shpins) as shpins -- 
    ,nvl(n.sermod, o.sermod) as sermod -- 
    ,nvl(n.serfro, o.serfro) as serfro -- 
    ,nvl(n.comflg, o.comflg) as comflg -- 
    ,nvl(n.insdat, o.insdat) as insdat -- 
    ,nvl(n.contractno, o.contractno) as contractno -- 
    ,nvl(n.negflg, o.negflg) as negflg -- 
    ,nvl(n.elcflg, o.elcflg) as elcflg -- 通过电证标志
    ,nvl(n.concur, o.concur) as concur -- 合同币种
    ,nvl(n.conamt, o.conamt) as conamt -- 合同金额
    ,nvl(n.rejame, o.rejame) as rejame -- 拒绝修改标志
    ,nvl(n.cantyp, o.cantyp) as cantyp -- 闭卷类型
    ,nvl(n.rejflg, o.rejflg) as rejflg -- 拒绝通知标志
    ,nvl(n.tzref, o.tzref) as tzref -- 通知行编号
    ,nvl(n.nomtop1, o.nomtop1) as nomtop1 -- 上浮金额（elcs）
    ,nvl(n.nomton1, o.nomton1) as nomton1 -- 下浮金额（elcs）
    ,nvl(n.zytyp, o.zytyp) as zytyp -- 质押类型
    ,nvl(n.productname, o.productname) as productname -- 货物名称
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
from (select * from ${iol_schema}.isbs_did_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_did where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.advnam <> n.advnam
        or o.advref <> n.advref
        or o.amedat <> n.amedat
        or o.amenbr <> n.amenbr
        or o.aplnam <> n.aplnam
        or o.aplref <> n.aplref
        or o.avbby <> n.avbby
        or o.avbwth <> n.avbwth
        or o.bennam <> n.bennam
        or o.benref <> n.benref
        or o.chato <> n.chato
        or o.cnfdet <> n.cnfdet
        or o.expdat <> n.expdat
        or o.expplc <> n.expplc
        or o.lcrtyp <> n.lcrtyp
        or o.nomspc <> n.nomspc
        or o.nomtop <> n.nomtop
        or o.nomton <> n.nomton
        or o.preadvdt <> n.preadvdt
        or o.rmbact <> n.rmbact
        or o.rmbcha <> n.rmbcha
        or o.rmbflg <> n.rmbflg
        or o.shpdat <> n.shpdat
        or o.shpfro <> n.shpfro
        or o.porloa <> n.porloa
        or o.pordis <> n.pordis
        or o.shppar <> n.shppar
        or o.shpto <> n.shpto
        or o.shptrs <> n.shptrs
        or o.stacty <> n.stacty
        or o.stagod <> n.stagod
        or o.utlnbr <> n.utlnbr
        or o.advnbr <> n.advnbr
        or o.redclsflg <> n.redclsflg
        or o.ver <> n.ver
        or o.lcityp <> n.lcityp
        or o.b2binr <> n.b2binr
        or o.b2bref <> n.b2bref
        or o.revnbr <> n.revnbr
        or o.revtimes <> n.revtimes
        or o.revflg <> n.revflg
        or o.revawapl <> n.revawapl
        or o.revdat <> n.revdat
        or o.revcum <> n.revcum
        or o.revtyp <> n.revtyp
        or o.initpty <> n.initpty
        or o.resflg <> n.resflg
        or o.apprul <> n.apprul
        or o.apprulrmb <> n.apprulrmb
        or o.apprultxt <> n.apprultxt
        or o.autdat <> n.autdat
        or o.etyextkey <> n.etyextkey
        or o.tenmaxday <> n.tenmaxday
        or o.branchinr <> n.branchinr
        or o.bchkeyinr <> n.bchkeyinr
        or o.decflg <> n.decflg
        or o.cshpct <> n.cshpct
        or o.isstyp <> n.isstyp
        or o.fincod <> n.fincod
        or o.fintyp <> n.fintyp
        or o.relcshpct <> n.relcshpct
        or o.jjh <> n.jjh
        or o.guaflg <> n.guaflg
        or o.tratyp <> n.tratyp
        or o.opnamo <> n.opnamo
        or o.ameflg <> n.ameflg
        or o.cretyp <> n.cretyp
        or o.tadtyp <> n.tadtyp
        or o.shpins <> n.shpins
        or o.sermod <> n.sermod
        or o.serfro <> n.serfro
        or o.comflg <> n.comflg
        or o.insdat <> n.insdat
        or o.contractno <> n.contractno
        or o.negflg <> n.negflg
        or o.elcflg <> n.elcflg
        or o.concur <> n.concur
        or o.conamt <> n.conamt
        or o.rejame <> n.rejame
        or o.cantyp <> n.cantyp
        or o.rejflg <> n.rejflg
        or o.tzref <> n.tzref
        or o.nomtop1 <> n.nomtop1
        or o.nomton1 <> n.nomton1
        or o.zytyp <> n.zytyp
        or o.productname <> n.productname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_did_cl(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,ownusr -- 
            ,credat -- 
            ,opndat -- 
            ,clsdat -- 
            ,advnam -- 
            ,advref -- 
            ,amedat -- 
            ,amenbr -- 
            ,aplnam -- 
            ,aplref -- 
            ,avbby -- 
            ,avbwth -- 
            ,bennam -- 
            ,benref -- 
            ,chato -- 
            ,cnfdet -- 
            ,expdat -- 
            ,expplc -- 
            ,lcrtyp -- 
            ,nomspc -- 
            ,nomtop -- 
            ,nomton -- 
            ,preadvdt -- 
            ,rmbact -- 
            ,rmbcha -- 
            ,rmbflg -- 
            ,shpdat -- 
            ,shpfro -- 
            ,porloa -- 
            ,pordis -- 
            ,shppar -- 
            ,shpto -- 
            ,shptrs -- 
            ,stacty -- 
            ,stagod -- 
            ,utlnbr -- 
            ,advnbr -- 
            ,redclsflg -- 
            ,ver -- 
            ,lcityp -- 
            ,b2binr -- 
            ,b2bref -- 
            ,revnbr -- 
            ,revtimes -- 
            ,revflg -- 
            ,revawapl -- 
            ,revdat -- 
            ,revcum -- 
            ,revtyp -- 
            ,initpty -- 
            ,resflg -- 
            ,apprul -- 
            ,apprulrmb -- 
            ,apprultxt -- 
            ,autdat -- 
            ,etyextkey -- 
            ,tenmaxday -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,decflg -- 
            ,cshpct -- 
            ,isstyp -- 
            ,fincod -- 
            ,fintyp -- 
            ,relcshpct -- 
            ,jjh -- 
            ,guaflg -- 
            ,tratyp -- 
            ,opnamo -- 
            ,ameflg -- 
            ,cretyp -- 
            ,tadtyp -- 
            ,shpins -- 
            ,sermod -- 
            ,serfro -- 
            ,comflg -- 
            ,insdat -- 
            ,contractno -- 
            ,negflg -- 
            ,elcflg -- 通过电证标志
            ,concur -- 合同币种
            ,conamt -- 合同金额
            ,rejame -- 拒绝修改标志
            ,cantyp -- 闭卷类型
            ,rejflg -- 拒绝通知标志
            ,tzref -- 通知行编号
            ,nomtop1 -- 上浮金额（elcs）
            ,nomton1 -- 下浮金额（elcs）
            ,zytyp -- 质押类型
            ,productname -- 货物名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_did_op(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,ownusr -- 
            ,credat -- 
            ,opndat -- 
            ,clsdat -- 
            ,advnam -- 
            ,advref -- 
            ,amedat -- 
            ,amenbr -- 
            ,aplnam -- 
            ,aplref -- 
            ,avbby -- 
            ,avbwth -- 
            ,bennam -- 
            ,benref -- 
            ,chato -- 
            ,cnfdet -- 
            ,expdat -- 
            ,expplc -- 
            ,lcrtyp -- 
            ,nomspc -- 
            ,nomtop -- 
            ,nomton -- 
            ,preadvdt -- 
            ,rmbact -- 
            ,rmbcha -- 
            ,rmbflg -- 
            ,shpdat -- 
            ,shpfro -- 
            ,porloa -- 
            ,pordis -- 
            ,shppar -- 
            ,shpto -- 
            ,shptrs -- 
            ,stacty -- 
            ,stagod -- 
            ,utlnbr -- 
            ,advnbr -- 
            ,redclsflg -- 
            ,ver -- 
            ,lcityp -- 
            ,b2binr -- 
            ,b2bref -- 
            ,revnbr -- 
            ,revtimes -- 
            ,revflg -- 
            ,revawapl -- 
            ,revdat -- 
            ,revcum -- 
            ,revtyp -- 
            ,initpty -- 
            ,resflg -- 
            ,apprul -- 
            ,apprulrmb -- 
            ,apprultxt -- 
            ,autdat -- 
            ,etyextkey -- 
            ,tenmaxday -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,decflg -- 
            ,cshpct -- 
            ,isstyp -- 
            ,fincod -- 
            ,fintyp -- 
            ,relcshpct -- 
            ,jjh -- 
            ,guaflg -- 
            ,tratyp -- 
            ,opnamo -- 
            ,ameflg -- 
            ,cretyp -- 
            ,tadtyp -- 
            ,shpins -- 
            ,sermod -- 
            ,serfro -- 
            ,comflg -- 
            ,insdat -- 
            ,contractno -- 
            ,negflg -- 
            ,elcflg -- 通过电证标志
            ,concur -- 合同币种
            ,conamt -- 合同金额
            ,rejame -- 拒绝修改标志
            ,cantyp -- 闭卷类型
            ,rejflg -- 拒绝通知标志
            ,tzref -- 通知行编号
            ,nomtop1 -- 上浮金额（elcs）
            ,nomton1 -- 下浮金额（elcs）
            ,zytyp -- 质押类型
            ,productname -- 货物名称
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
    ,o.advnam -- 
    ,o.advref -- 
    ,o.amedat -- 
    ,o.amenbr -- 
    ,o.aplnam -- 
    ,o.aplref -- 
    ,o.avbby -- 
    ,o.avbwth -- 
    ,o.bennam -- 
    ,o.benref -- 
    ,o.chato -- 
    ,o.cnfdet -- 
    ,o.expdat -- 
    ,o.expplc -- 
    ,o.lcrtyp -- 
    ,o.nomspc -- 
    ,o.nomtop -- 
    ,o.nomton -- 
    ,o.preadvdt -- 
    ,o.rmbact -- 
    ,o.rmbcha -- 
    ,o.rmbflg -- 
    ,o.shpdat -- 
    ,o.shpfro -- 
    ,o.porloa -- 
    ,o.pordis -- 
    ,o.shppar -- 
    ,o.shpto -- 
    ,o.shptrs -- 
    ,o.stacty -- 
    ,o.stagod -- 
    ,o.utlnbr -- 
    ,o.advnbr -- 
    ,o.redclsflg -- 
    ,o.ver -- 
    ,o.lcityp -- 
    ,o.b2binr -- 
    ,o.b2bref -- 
    ,o.revnbr -- 
    ,o.revtimes -- 
    ,o.revflg -- 
    ,o.revawapl -- 
    ,o.revdat -- 
    ,o.revcum -- 
    ,o.revtyp -- 
    ,o.initpty -- 
    ,o.resflg -- 
    ,o.apprul -- 
    ,o.apprulrmb -- 
    ,o.apprultxt -- 
    ,o.autdat -- 
    ,o.etyextkey -- 
    ,o.tenmaxday -- 
    ,o.branchinr -- 
    ,o.bchkeyinr -- 
    ,o.decflg -- 
    ,o.cshpct -- 
    ,o.isstyp -- 
    ,o.fincod -- 
    ,o.fintyp -- 
    ,o.relcshpct -- 
    ,o.jjh -- 
    ,o.guaflg -- 
    ,o.tratyp -- 
    ,o.opnamo -- 
    ,o.ameflg -- 
    ,o.cretyp -- 
    ,o.tadtyp -- 
    ,o.shpins -- 
    ,o.sermod -- 
    ,o.serfro -- 
    ,o.comflg -- 
    ,o.insdat -- 
    ,o.contractno -- 
    ,o.negflg -- 
    ,o.elcflg -- 通过电证标志
    ,o.concur -- 合同币种
    ,o.conamt -- 合同金额
    ,o.rejame -- 拒绝修改标志
    ,o.cantyp -- 闭卷类型
    ,o.rejflg -- 拒绝通知标志
    ,o.tzref -- 通知行编号
    ,o.nomtop1 -- 上浮金额（elcs）
    ,o.nomton1 -- 下浮金额（elcs）
    ,o.zytyp -- 质押类型
    ,o.productname -- 货物名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_did_bk o
    left join ${iol_schema}.isbs_did_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_did_cl d
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
--truncate table ${iol_schema}.isbs_did;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_did') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_did drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_did add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_did exchange partition p_${batch_date} with table ${iol_schema}.isbs_did_cl;
alter table ${iol_schema}.isbs_did exchange partition p_20991231 with table ${iol_schema}.isbs_did_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_did to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_did_op purge;
drop table ${iol_schema}.isbs_did_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_did_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_did',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
