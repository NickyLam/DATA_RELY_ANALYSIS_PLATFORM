/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_ded
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
create table ${iol_schema}.isbs_ded_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_ded;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ded_op purge;
drop table ${iol_schema}.isbs_ded_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ded_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ded where 0=1;

create table ${iol_schema}.isbs_ded_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ded where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ded_cl(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,opndat -- 
            ,clsdat -- 
            ,ownusr -- 
            ,ver -- 
            ,credat -- 
            ,etyextkey -- 
            ,cnfdat -- 
            ,advdat -- 
            ,issnam -- 
            ,issref -- 
            ,amedat -- 
            ,amenbr -- 
            ,avbby -- 
            ,avbwth -- 
            ,bennam -- 
            ,benref -- 
            ,chato -- 
            ,cnfflg -- 
            ,cnfdet -- 
            ,cnfsta -- 
            ,expdat -- 
            ,expplc -- 
            ,lcrtyp -- 
            ,nomspc -- 
            ,nomtop -- 
            ,nomton -- 
            ,preadvdt -- 
            ,shpdat -- 
            ,shpfro -- 
            ,shppar -- 
            ,shpto -- 
            ,shptrs -- 
            ,stacty -- 
            ,stagod -- 
            ,utlnbr -- 
            ,aplbnkdirsnd -- 
            ,tenmaxday -- 
            ,cnfsnd -- 
            ,revflg -- 
            ,revnbr -- 
            ,revtimes -- 
            ,revdat -- 
            ,revcum -- 
            ,revtyp -- 
            ,cnfins -- 
            ,redclsflg -- 
            ,advnbr -- 
            ,resflg -- 
            ,inctrf -- 
            ,apprul -- 
            ,apprultxt -- 
            ,pordis -- 
            ,porloa -- 
            ,nonban -- 
            ,partcon -- 
            ,collflg -- 
            ,teskeyunc -- 
            ,dbtflg -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,rskrat -- 
            ,tratyp -- 
            ,negflg -- 
            ,cretyp -- 
            ,contractno -- 
            ,shpins -- 
            ,tadtyp -- 
            ,sermod -- 
            ,serfro -- 
            ,comflg -- 
            ,elcflg -- 通过电证标志
            ,concur -- 合同币种
            ,conamt  -- 合同金额
            ,rejame  -- 拒绝修改标志
            ,rejnbr  -- 拒绝修改次数
            ,cantyp  -- 闭卷类型
            ,rejflg  -- 拒绝通知标志
            ,dkflg -- 是否代开
            ,nomtop1  -- 上浮金额（ELCS）
            ,nomton1  -- 下浮金额（ELCS）
            ,kzref -- 信用证编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ded_op(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,opndat -- 
            ,clsdat -- 
            ,ownusr -- 
            ,ver -- 
            ,credat -- 
            ,etyextkey -- 
            ,cnfdat -- 
            ,advdat -- 
            ,issnam -- 
            ,issref -- 
            ,amedat -- 
            ,amenbr -- 
            ,avbby -- 
            ,avbwth -- 
            ,bennam -- 
            ,benref -- 
            ,chato -- 
            ,cnfflg -- 
            ,cnfdet -- 
            ,cnfsta -- 
            ,expdat -- 
            ,expplc -- 
            ,lcrtyp -- 
            ,nomspc -- 
            ,nomtop -- 
            ,nomton -- 
            ,preadvdt -- 
            ,shpdat -- 
            ,shpfro -- 
            ,shppar -- 
            ,shpto -- 
            ,shptrs -- 
            ,stacty -- 
            ,stagod -- 
            ,utlnbr -- 
            ,aplbnkdirsnd -- 
            ,tenmaxday -- 
            ,cnfsnd -- 
            ,revflg -- 
            ,revnbr -- 
            ,revtimes -- 
            ,revdat -- 
            ,revcum -- 
            ,revtyp -- 
            ,cnfins -- 
            ,redclsflg -- 
            ,advnbr -- 
            ,resflg -- 
            ,inctrf -- 
            ,apprul -- 
            ,apprultxt -- 
            ,pordis -- 
            ,porloa -- 
            ,nonban -- 
            ,partcon -- 
            ,collflg -- 
            ,teskeyunc -- 
            ,dbtflg -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,rskrat -- 
            ,tratyp -- 
            ,negflg -- 
            ,cretyp -- 
            ,contractno -- 
            ,shpins -- 
            ,tadtyp -- 
            ,sermod -- 
            ,serfro -- 
            ,comflg -- 
            ,elcflg -- 通过电证标志
            ,concur -- 合同币种
            ,conamt  -- 合同金额
            ,rejame  -- 拒绝修改标志
            ,rejnbr  -- 拒绝修改次数
            ,cantyp  -- 闭卷类型
            ,rejflg  -- 拒绝通知标志
            ,dkflg -- 是否代开
            ,nomtop1  -- 上浮金额（ELCS）
            ,nomton1  -- 下浮金额（ELCS）
            ,kzref -- 信用证编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.ownref, o.ownref) as ownref -- 
    ,nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.opndat, o.opndat) as opndat -- 
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.credat, o.credat) as credat -- 
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 
    ,nvl(n.cnfdat, o.cnfdat) as cnfdat -- 
    ,nvl(n.advdat, o.advdat) as advdat -- 
    ,nvl(n.issnam, o.issnam) as issnam -- 
    ,nvl(n.issref, o.issref) as issref -- 
    ,nvl(n.amedat, o.amedat) as amedat -- 
    ,nvl(n.amenbr, o.amenbr) as amenbr -- 
    ,nvl(n.avbby, o.avbby) as avbby -- 
    ,nvl(n.avbwth, o.avbwth) as avbwth -- 
    ,nvl(n.bennam, o.bennam) as bennam -- 
    ,nvl(n.benref, o.benref) as benref -- 
    ,nvl(n.chato, o.chato) as chato -- 
    ,nvl(n.cnfflg, o.cnfflg) as cnfflg -- 
    ,nvl(n.cnfdet, o.cnfdet) as cnfdet -- 
    ,nvl(n.cnfsta, o.cnfsta) as cnfsta -- 
    ,nvl(n.expdat, o.expdat) as expdat -- 
    ,nvl(n.expplc, o.expplc) as expplc -- 
    ,nvl(n.lcrtyp, o.lcrtyp) as lcrtyp -- 
    ,nvl(n.nomspc, o.nomspc) as nomspc -- 
    ,nvl(n.nomtop, o.nomtop) as nomtop -- 
    ,nvl(n.nomton, o.nomton) as nomton -- 
    ,nvl(n.preadvdt, o.preadvdt) as preadvdt -- 
    ,nvl(n.shpdat, o.shpdat) as shpdat -- 
    ,nvl(n.shpfro, o.shpfro) as shpfro -- 
    ,nvl(n.shppar, o.shppar) as shppar -- 
    ,nvl(n.shpto, o.shpto) as shpto -- 
    ,nvl(n.shptrs, o.shptrs) as shptrs -- 
    ,nvl(n.stacty, o.stacty) as stacty -- 
    ,nvl(n.stagod, o.stagod) as stagod -- 
    ,nvl(n.utlnbr, o.utlnbr) as utlnbr -- 
    ,nvl(n.aplbnkdirsnd, o.aplbnkdirsnd) as aplbnkdirsnd -- 
    ,nvl(n.tenmaxday, o.tenmaxday) as tenmaxday -- 
    ,nvl(n.cnfsnd, o.cnfsnd) as cnfsnd -- 
    ,nvl(n.revflg, o.revflg) as revflg -- 
    ,nvl(n.revnbr, o.revnbr) as revnbr -- 
    ,nvl(n.revtimes, o.revtimes) as revtimes -- 
    ,nvl(n.revdat, o.revdat) as revdat -- 
    ,nvl(n.revcum, o.revcum) as revcum -- 
    ,nvl(n.revtyp, o.revtyp) as revtyp -- 
    ,nvl(n.cnfins, o.cnfins) as cnfins -- 
    ,nvl(n.redclsflg, o.redclsflg) as redclsflg -- 
    ,nvl(n.advnbr, o.advnbr) as advnbr -- 
    ,nvl(n.resflg, o.resflg) as resflg -- 
    ,nvl(n.inctrf, o.inctrf) as inctrf -- 
    ,nvl(n.apprul, o.apprul) as apprul -- 
    ,nvl(n.apprultxt, o.apprultxt) as apprultxt -- 
    ,nvl(n.pordis, o.pordis) as pordis -- 
    ,nvl(n.porloa, o.porloa) as porloa -- 
    ,nvl(n.nonban, o.nonban) as nonban -- 
    ,nvl(n.partcon, o.partcon) as partcon -- 
    ,nvl(n.collflg, o.collflg) as collflg -- 
    ,nvl(n.teskeyunc, o.teskeyunc) as teskeyunc -- 
    ,nvl(n.dbtflg, o.dbtflg) as dbtflg -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.rskrat, o.rskrat) as rskrat -- 
    ,nvl(n.tratyp, o.tratyp) as tratyp -- 
    ,nvl(n.negflg, o.negflg) as negflg -- 
    ,nvl(n.cretyp, o.cretyp) as cretyp -- 
    ,nvl(n.contractno, o.contractno) as contractno -- 
    ,nvl(n.shpins, o.shpins) as shpins -- 
    ,nvl(n.tadtyp, o.tadtyp) as tadtyp -- 
    ,nvl(n.sermod, o.sermod) as sermod -- 
    ,nvl(n.serfro, o.serfro) as serfro -- 
    ,nvl(n.comflg, o.comflg) as comflg -- 
    ,nvl(n.elcflg, o.elcflg) as elcflg -- 通过电证标志
    ,nvl(n.concur, o.concur) as concur -- 合同币种
    ,nvl(n.conamt , o.conamt ) as conamt  -- 合同金额
    ,nvl(n.rejame , o.rejame ) as rejame  -- 拒绝修改标志
    ,nvl(n.rejnbr , o.rejnbr ) as rejnbr  -- 拒绝修改次数
    ,nvl(n.cantyp , o.cantyp ) as cantyp  -- 闭卷类型
    ,nvl(n.rejflg , o.rejflg ) as rejflg  -- 拒绝通知标志
    ,nvl(n.dkflg, o.dkflg) as dkflg -- 是否代开
    ,nvl(n.nomtop1 , o.nomtop1 ) as nomtop1  -- 上浮金额（ELCS）
    ,nvl(n.nomton1 , o.nomton1 ) as nomton1  -- 下浮金额（ELCS）
    ,nvl(n.kzref, o.kzref) as kzref -- 信用证编号
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
from (select * from ${iol_schema}.isbs_ded_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_ded where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.opndat <> n.opndat
        or o.clsdat <> n.clsdat
        or o.ownusr <> n.ownusr
        or o.ver <> n.ver
        or o.credat <> n.credat
        or o.etyextkey <> n.etyextkey
        or o.cnfdat <> n.cnfdat
        or o.advdat <> n.advdat
        or o.issnam <> n.issnam
        or o.issref <> n.issref
        or o.amedat <> n.amedat
        or o.amenbr <> n.amenbr
        or o.avbby <> n.avbby
        or o.avbwth <> n.avbwth
        or o.bennam <> n.bennam
        or o.benref <> n.benref
        or o.chato <> n.chato
        or o.cnfflg <> n.cnfflg
        or o.cnfdet <> n.cnfdet
        or o.cnfsta <> n.cnfsta
        or o.expdat <> n.expdat
        or o.expplc <> n.expplc
        or o.lcrtyp <> n.lcrtyp
        or o.nomspc <> n.nomspc
        or o.nomtop <> n.nomtop
        or o.nomton <> n.nomton
        or o.preadvdt <> n.preadvdt
        or o.shpdat <> n.shpdat
        or o.shpfro <> n.shpfro
        or o.shppar <> n.shppar
        or o.shpto <> n.shpto
        or o.shptrs <> n.shptrs
        or o.stacty <> n.stacty
        or o.stagod <> n.stagod
        or o.utlnbr <> n.utlnbr
        or o.aplbnkdirsnd <> n.aplbnkdirsnd
        or o.tenmaxday <> n.tenmaxday
        or o.cnfsnd <> n.cnfsnd
        or o.revflg <> n.revflg
        or o.revnbr <> n.revnbr
        or o.revtimes <> n.revtimes
        or o.revdat <> n.revdat
        or o.revcum <> n.revcum
        or o.revtyp <> n.revtyp
        or o.cnfins <> n.cnfins
        or o.redclsflg <> n.redclsflg
        or o.advnbr <> n.advnbr
        or o.resflg <> n.resflg
        or o.inctrf <> n.inctrf
        or o.apprul <> n.apprul
        or o.apprultxt <> n.apprultxt
        or o.pordis <> n.pordis
        or o.porloa <> n.porloa
        or o.nonban <> n.nonban
        or o.partcon <> n.partcon
        or o.collflg <> n.collflg
        or o.teskeyunc <> n.teskeyunc
        or o.dbtflg <> n.dbtflg
        or o.branchinr <> n.branchinr
        or o.bchkeyinr <> n.bchkeyinr
        or o.rskrat <> n.rskrat
        or o.tratyp <> n.tratyp
        or o.negflg <> n.negflg
        or o.cretyp <> n.cretyp
        or o.contractno <> n.contractno
        or o.shpins <> n.shpins
        or o.tadtyp <> n.tadtyp
        or o.sermod <> n.sermod
        or o.serfro <> n.serfro
        or o.comflg <> n.comflg
        or o.elcflg <> n.elcflg
        or o.concur <> n.concur
        or o.conamt  <> n.conamt 
        or o.rejame  <> n.rejame 
        or o.rejnbr  <> n.rejnbr 
        or o.cantyp  <> n.cantyp 
        or o.rejflg  <> n.rejflg 
        or o.dkflg <> n.dkflg
        or o.nomtop1  <> n.nomtop1 
        or o.nomton1  <> n.nomton1 
        or o.kzref <> n.kzref
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ded_cl(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,opndat -- 
            ,clsdat -- 
            ,ownusr -- 
            ,ver -- 
            ,credat -- 
            ,etyextkey -- 
            ,cnfdat -- 
            ,advdat -- 
            ,issnam -- 
            ,issref -- 
            ,amedat -- 
            ,amenbr -- 
            ,avbby -- 
            ,avbwth -- 
            ,bennam -- 
            ,benref -- 
            ,chato -- 
            ,cnfflg -- 
            ,cnfdet -- 
            ,cnfsta -- 
            ,expdat -- 
            ,expplc -- 
            ,lcrtyp -- 
            ,nomspc -- 
            ,nomtop -- 
            ,nomton -- 
            ,preadvdt -- 
            ,shpdat -- 
            ,shpfro -- 
            ,shppar -- 
            ,shpto -- 
            ,shptrs -- 
            ,stacty -- 
            ,stagod -- 
            ,utlnbr -- 
            ,aplbnkdirsnd -- 
            ,tenmaxday -- 
            ,cnfsnd -- 
            ,revflg -- 
            ,revnbr -- 
            ,revtimes -- 
            ,revdat -- 
            ,revcum -- 
            ,revtyp -- 
            ,cnfins -- 
            ,redclsflg -- 
            ,advnbr -- 
            ,resflg -- 
            ,inctrf -- 
            ,apprul -- 
            ,apprultxt -- 
            ,pordis -- 
            ,porloa -- 
            ,nonban -- 
            ,partcon -- 
            ,collflg -- 
            ,teskeyunc -- 
            ,dbtflg -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,rskrat -- 
            ,tratyp -- 
            ,negflg -- 
            ,cretyp -- 
            ,contractno -- 
            ,shpins -- 
            ,tadtyp -- 
            ,sermod -- 
            ,serfro -- 
            ,comflg -- 
            ,elcflg -- 通过电证标志
            ,concur -- 合同币种
            ,conamt  -- 合同金额
            ,rejame  -- 拒绝修改标志
            ,rejnbr  -- 拒绝修改次数
            ,cantyp  -- 闭卷类型
            ,rejflg  -- 拒绝通知标志
            ,dkflg -- 是否代开
            ,nomtop1  -- 上浮金额（ELCS）
            ,nomton1  -- 下浮金额（ELCS）
            ,kzref -- 信用证编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ded_op(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,opndat -- 
            ,clsdat -- 
            ,ownusr -- 
            ,ver -- 
            ,credat -- 
            ,etyextkey -- 
            ,cnfdat -- 
            ,advdat -- 
            ,issnam -- 
            ,issref -- 
            ,amedat -- 
            ,amenbr -- 
            ,avbby -- 
            ,avbwth -- 
            ,bennam -- 
            ,benref -- 
            ,chato -- 
            ,cnfflg -- 
            ,cnfdet -- 
            ,cnfsta -- 
            ,expdat -- 
            ,expplc -- 
            ,lcrtyp -- 
            ,nomspc -- 
            ,nomtop -- 
            ,nomton -- 
            ,preadvdt -- 
            ,shpdat -- 
            ,shpfro -- 
            ,shppar -- 
            ,shpto -- 
            ,shptrs -- 
            ,stacty -- 
            ,stagod -- 
            ,utlnbr -- 
            ,aplbnkdirsnd -- 
            ,tenmaxday -- 
            ,cnfsnd -- 
            ,revflg -- 
            ,revnbr -- 
            ,revtimes -- 
            ,revdat -- 
            ,revcum -- 
            ,revtyp -- 
            ,cnfins -- 
            ,redclsflg -- 
            ,advnbr -- 
            ,resflg -- 
            ,inctrf -- 
            ,apprul -- 
            ,apprultxt -- 
            ,pordis -- 
            ,porloa -- 
            ,nonban -- 
            ,partcon -- 
            ,collflg -- 
            ,teskeyunc -- 
            ,dbtflg -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,rskrat -- 
            ,tratyp -- 
            ,negflg -- 
            ,cretyp -- 
            ,contractno -- 
            ,shpins -- 
            ,tadtyp -- 
            ,sermod -- 
            ,serfro -- 
            ,comflg -- 
            ,elcflg -- 通过电证标志
            ,concur -- 合同币种
            ,conamt  -- 合同金额
            ,rejame  -- 拒绝修改标志
            ,rejnbr  -- 拒绝修改次数
            ,cantyp  -- 闭卷类型
            ,rejflg  -- 拒绝通知标志
            ,dkflg -- 是否代开
            ,nomtop1  -- 上浮金额（ELCS）
            ,nomton1  -- 下浮金额（ELCS）
            ,kzref -- 信用证编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 
    ,o.ownref -- 
    ,o.nam -- 
    ,o.opndat -- 
    ,o.clsdat -- 
    ,o.ownusr -- 
    ,o.ver -- 
    ,o.credat -- 
    ,o.etyextkey -- 
    ,o.cnfdat -- 
    ,o.advdat -- 
    ,o.issnam -- 
    ,o.issref -- 
    ,o.amedat -- 
    ,o.amenbr -- 
    ,o.avbby -- 
    ,o.avbwth -- 
    ,o.bennam -- 
    ,o.benref -- 
    ,o.chato -- 
    ,o.cnfflg -- 
    ,o.cnfdet -- 
    ,o.cnfsta -- 
    ,o.expdat -- 
    ,o.expplc -- 
    ,o.lcrtyp -- 
    ,o.nomspc -- 
    ,o.nomtop -- 
    ,o.nomton -- 
    ,o.preadvdt -- 
    ,o.shpdat -- 
    ,o.shpfro -- 
    ,o.shppar -- 
    ,o.shpto -- 
    ,o.shptrs -- 
    ,o.stacty -- 
    ,o.stagod -- 
    ,o.utlnbr -- 
    ,o.aplbnkdirsnd -- 
    ,o.tenmaxday -- 
    ,o.cnfsnd -- 
    ,o.revflg -- 
    ,o.revnbr -- 
    ,o.revtimes -- 
    ,o.revdat -- 
    ,o.revcum -- 
    ,o.revtyp -- 
    ,o.cnfins -- 
    ,o.redclsflg -- 
    ,o.advnbr -- 
    ,o.resflg -- 
    ,o.inctrf -- 
    ,o.apprul -- 
    ,o.apprultxt -- 
    ,o.pordis -- 
    ,o.porloa -- 
    ,o.nonban -- 
    ,o.partcon -- 
    ,o.collflg -- 
    ,o.teskeyunc -- 
    ,o.dbtflg -- 
    ,o.branchinr -- 
    ,o.bchkeyinr -- 
    ,o.rskrat -- 
    ,o.tratyp -- 
    ,o.negflg -- 
    ,o.cretyp -- 
    ,o.contractno -- 
    ,o.shpins -- 
    ,o.tadtyp -- 
    ,o.sermod -- 
    ,o.serfro -- 
    ,o.comflg -- 
    ,o.elcflg -- 通过电证标志
    ,o.concur -- 合同币种
    ,o.conamt  -- 合同金额
    ,o.rejame  -- 拒绝修改标志
    ,o.rejnbr  -- 拒绝修改次数
    ,o.cantyp  -- 闭卷类型
    ,o.rejflg  -- 拒绝通知标志
    ,o.dkflg -- 是否代开
    ,o.nomtop1  -- 上浮金额（ELCS）
    ,o.nomton1  -- 下浮金额（ELCS）
    ,o.kzref -- 信用证编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_ded_bk o
    left join ${iol_schema}.isbs_ded_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_ded_cl d
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
-- truncate table ${iol_schema}.isbs_ded;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_ded exchange partition p_19000101 with table ${iol_schema}.isbs_ded_cl;
alter table ${iol_schema}.isbs_ded exchange partition p_20991231 with table ${iol_schema}.isbs_ded_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_ded to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ded_op purge;
drop table ${iol_schema}.isbs_ded_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_ded_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_ded',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
