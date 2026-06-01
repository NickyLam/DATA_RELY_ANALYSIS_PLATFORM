/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_lid
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
create table ${iol_schema}.isbs_lid_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_lid
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_lid_op purge;
drop table ${iol_schema}.isbs_lid_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_lid_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_lid where 0=1;

create table ${iol_schema}.isbs_lid_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_lid where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_lid_cl(
            inr -- 进口信用证id号
            ,ownref -- 参考号
            ,nam -- 标识交易的外部显示名称
            ,ownusr -- 参考号
            ,credat -- 开证或注册日期
            ,opndat -- 开证日期
            ,clsdat -- 结束日期
            ,advnam -- 通知行名称
            ,advref -- 通知行参考号
            ,amedat -- 上次修改日期
            ,amenbr -- 修改次数
            ,aplnam -- 申请人名称
            ,aplref -- 申请人参考号
            ,avbby -- 指定方式
            ,avbwth -- 指定方式
            ,bennam -- 收益人名字
            ,benref -- 受益人参考号
            ,chato -- 费用流向
            ,cnfdet -- 保兑状态
            ,expdat -- 效期，指定信用证的效期
            ,expplc -- 交单地点
            ,lcrtyp -- 信用证的格式
            ,nomspc -- 规格数量
            ,nomtop -- 溢短装
            ,nomton -- 溢短装
            ,preadvdt -- 预通知日期
            ,rmbact -- 偿付行用户帐号
            ,rmbcha -- 偿付行费用
            ,rmbflg -- 偿付标志
            ,shpdat -- 装船日期
            ,shpfro -- 装船地点
            ,porloa -- 装货港
            ,pordis -- 卸货港
            ,shppar -- 分装
            ,shpto -- 运货地点
            ,shptrs -- 转载[shptrs]
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,utlnbr -- 利用数目
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
            ,dflg -- 
            ,guaflg -- 
            ,tratyp -- 
            ,opnamo -- 
            ,ameflg -- 
            ,cretyp -- 
            ,tadtyp -- 
            ,shpins -- 
            ,sermod -- 
            ,serfro -- 
            ,negflg -- 
            ,comflg -- 
            ,insdat -- 
            ,shppars18 -- 
            ,shptrss18 -- 
            ,spcbenflg -- 
            ,spcrcbflg -- 
            ,prepertxts18 -- 
            ,prepers18 -- 
            ,zytyp -- 
            ,productname -- 
            ,contractno -- 
            ,concur -- 
            ,conamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_lid_op(
            inr -- 进口信用证id号
            ,ownref -- 参考号
            ,nam -- 标识交易的外部显示名称
            ,ownusr -- 参考号
            ,credat -- 开证或注册日期
            ,opndat -- 开证日期
            ,clsdat -- 结束日期
            ,advnam -- 通知行名称
            ,advref -- 通知行参考号
            ,amedat -- 上次修改日期
            ,amenbr -- 修改次数
            ,aplnam -- 申请人名称
            ,aplref -- 申请人参考号
            ,avbby -- 指定方式
            ,avbwth -- 指定方式
            ,bennam -- 收益人名字
            ,benref -- 受益人参考号
            ,chato -- 费用流向
            ,cnfdet -- 保兑状态
            ,expdat -- 效期，指定信用证的效期
            ,expplc -- 交单地点
            ,lcrtyp -- 信用证的格式
            ,nomspc -- 规格数量
            ,nomtop -- 溢短装
            ,nomton -- 溢短装
            ,preadvdt -- 预通知日期
            ,rmbact -- 偿付行用户帐号
            ,rmbcha -- 偿付行费用
            ,rmbflg -- 偿付标志
            ,shpdat -- 装船日期
            ,shpfro -- 装船地点
            ,porloa -- 装货港
            ,pordis -- 卸货港
            ,shppar -- 分装
            ,shpto -- 运货地点
            ,shptrs -- 转载[shptrs]
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,utlnbr -- 利用数目
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
            ,dflg -- 
            ,guaflg -- 
            ,tratyp -- 
            ,opnamo -- 
            ,ameflg -- 
            ,cretyp -- 
            ,tadtyp -- 
            ,shpins -- 
            ,sermod -- 
            ,serfro -- 
            ,negflg -- 
            ,comflg -- 
            ,insdat -- 
            ,shppars18 -- 
            ,shptrss18 -- 
            ,spcbenflg -- 
            ,spcrcbflg -- 
            ,prepertxts18 -- 
            ,prepers18 -- 
            ,zytyp -- 
            ,productname -- 
            ,contractno -- 
            ,concur -- 
            ,conamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 进口信用证id号
    ,nvl(n.ownref, o.ownref) as ownref -- 参考号
    ,nvl(n.nam, o.nam) as nam -- 标识交易的外部显示名称
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 参考号
    ,nvl(n.credat, o.credat) as credat -- 开证或注册日期
    ,nvl(n.opndat, o.opndat) as opndat -- 开证日期
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 结束日期
    ,nvl(n.advnam, o.advnam) as advnam -- 通知行名称
    ,nvl(n.advref, o.advref) as advref -- 通知行参考号
    ,nvl(n.amedat, o.amedat) as amedat -- 上次修改日期
    ,nvl(n.amenbr, o.amenbr) as amenbr -- 修改次数
    ,nvl(n.aplnam, o.aplnam) as aplnam -- 申请人名称
    ,nvl(n.aplref, o.aplref) as aplref -- 申请人参考号
    ,nvl(n.avbby, o.avbby) as avbby -- 指定方式
    ,nvl(n.avbwth, o.avbwth) as avbwth -- 指定方式
    ,nvl(n.bennam, o.bennam) as bennam -- 收益人名字
    ,nvl(n.benref, o.benref) as benref -- 受益人参考号
    ,nvl(n.chato, o.chato) as chato -- 费用流向
    ,nvl(n.cnfdet, o.cnfdet) as cnfdet -- 保兑状态
    ,nvl(n.expdat, o.expdat) as expdat -- 效期，指定信用证的效期
    ,nvl(n.expplc, o.expplc) as expplc -- 交单地点
    ,nvl(n.lcrtyp, o.lcrtyp) as lcrtyp -- 信用证的格式
    ,nvl(n.nomspc, o.nomspc) as nomspc -- 规格数量
    ,nvl(n.nomtop, o.nomtop) as nomtop -- 溢短装
    ,nvl(n.nomton, o.nomton) as nomton -- 溢短装
    ,nvl(n.preadvdt, o.preadvdt) as preadvdt -- 预通知日期
    ,nvl(n.rmbact, o.rmbact) as rmbact -- 偿付行用户帐号
    ,nvl(n.rmbcha, o.rmbcha) as rmbcha -- 偿付行费用
    ,nvl(n.rmbflg, o.rmbflg) as rmbflg -- 偿付标志
    ,nvl(n.shpdat, o.shpdat) as shpdat -- 装船日期
    ,nvl(n.shpfro, o.shpfro) as shpfro -- 装船地点
    ,nvl(n.porloa, o.porloa) as porloa -- 装货港
    ,nvl(n.pordis, o.pordis) as pordis -- 卸货港
    ,nvl(n.shppar, o.shppar) as shppar -- 分装
    ,nvl(n.shpto, o.shpto) as shpto -- 运货地点
    ,nvl(n.shptrs, o.shptrs) as shptrs -- 转载[shptrs]
    ,nvl(n.stacty, o.stacty) as stacty -- 国家代码
    ,nvl(n.stagod, o.stagod) as stagod -- 货物代码
    ,nvl(n.utlnbr, o.utlnbr) as utlnbr -- 利用数目
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
    ,nvl(n.dflg, o.dflg) as dflg -- 
    ,nvl(n.guaflg, o.guaflg) as guaflg -- 
    ,nvl(n.tratyp, o.tratyp) as tratyp -- 
    ,nvl(n.opnamo, o.opnamo) as opnamo -- 
    ,nvl(n.ameflg, o.ameflg) as ameflg -- 
    ,nvl(n.cretyp, o.cretyp) as cretyp -- 
    ,nvl(n.tadtyp, o.tadtyp) as tadtyp -- 
    ,nvl(n.shpins, o.shpins) as shpins -- 
    ,nvl(n.sermod, o.sermod) as sermod -- 
    ,nvl(n.serfro, o.serfro) as serfro -- 
    ,nvl(n.negflg, o.negflg) as negflg -- 
    ,nvl(n.comflg, o.comflg) as comflg -- 
    ,nvl(n.insdat, o.insdat) as insdat -- 
    ,nvl(n.shppars18, o.shppars18) as shppars18 -- 
    ,nvl(n.shptrss18, o.shptrss18) as shptrss18 -- 
    ,nvl(n.spcbenflg, o.spcbenflg) as spcbenflg -- 
    ,nvl(n.spcrcbflg, o.spcrcbflg) as spcrcbflg -- 
    ,nvl(n.prepertxts18, o.prepertxts18) as prepertxts18 -- 
    ,nvl(n.prepers18, o.prepers18) as prepers18 -- 
    ,nvl(n.zytyp, o.zytyp) as zytyp -- 
    ,nvl(n.productname, o.productname) as productname -- 
    ,nvl(n.contractno, o.contractno) as contractno -- 
    ,nvl(n.concur, o.concur) as concur -- 
    ,nvl(n.conamt, o.conamt) as conamt -- 
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
from (select * from ${iol_schema}.isbs_lid_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_lid where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.dflg <> n.dflg
        or o.guaflg <> n.guaflg
        or o.tratyp <> n.tratyp
        or o.opnamo <> n.opnamo
        or o.ameflg <> n.ameflg
        or o.cretyp <> n.cretyp
        or o.tadtyp <> n.tadtyp
        or o.shpins <> n.shpins
        or o.sermod <> n.sermod
        or o.serfro <> n.serfro
        or o.negflg <> n.negflg
        or o.comflg <> n.comflg
        or o.insdat <> n.insdat
        or o.shppars18 <> n.shppars18
        or o.shptrss18 <> n.shptrss18
        or o.spcbenflg <> n.spcbenflg
        or o.spcrcbflg <> n.spcrcbflg
        or o.prepertxts18 <> n.prepertxts18
        or o.prepers18 <> n.prepers18
        or o.zytyp <> n.zytyp
        or o.productname <> n.productname
        or o.contractno <> n.contractno
        or o.concur <> n.concur
        or o.conamt <> n.conamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_lid_cl(
            inr -- 进口信用证id号
            ,ownref -- 参考号
            ,nam -- 标识交易的外部显示名称
            ,ownusr -- 参考号
            ,credat -- 开证或注册日期
            ,opndat -- 开证日期
            ,clsdat -- 结束日期
            ,advnam -- 通知行名称
            ,advref -- 通知行参考号
            ,amedat -- 上次修改日期
            ,amenbr -- 修改次数
            ,aplnam -- 申请人名称
            ,aplref -- 申请人参考号
            ,avbby -- 指定方式
            ,avbwth -- 指定方式
            ,bennam -- 收益人名字
            ,benref -- 受益人参考号
            ,chato -- 费用流向
            ,cnfdet -- 保兑状态
            ,expdat -- 效期，指定信用证的效期
            ,expplc -- 交单地点
            ,lcrtyp -- 信用证的格式
            ,nomspc -- 规格数量
            ,nomtop -- 溢短装
            ,nomton -- 溢短装
            ,preadvdt -- 预通知日期
            ,rmbact -- 偿付行用户帐号
            ,rmbcha -- 偿付行费用
            ,rmbflg -- 偿付标志
            ,shpdat -- 装船日期
            ,shpfro -- 装船地点
            ,porloa -- 装货港
            ,pordis -- 卸货港
            ,shppar -- 分装
            ,shpto -- 运货地点
            ,shptrs -- 转载[shptrs]
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,utlnbr -- 利用数目
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
            ,dflg -- 
            ,guaflg -- 
            ,tratyp -- 
            ,opnamo -- 
            ,ameflg -- 
            ,cretyp -- 
            ,tadtyp -- 
            ,shpins -- 
            ,sermod -- 
            ,serfro -- 
            ,negflg -- 
            ,comflg -- 
            ,insdat -- 
            ,shppars18 -- 
            ,shptrss18 -- 
            ,spcbenflg -- 
            ,spcrcbflg -- 
            ,prepertxts18 -- 
            ,prepers18 -- 
            ,zytyp -- 
            ,productname -- 
            ,contractno -- 
            ,concur -- 
            ,conamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_lid_op(
            inr -- 进口信用证id号
            ,ownref -- 参考号
            ,nam -- 标识交易的外部显示名称
            ,ownusr -- 参考号
            ,credat -- 开证或注册日期
            ,opndat -- 开证日期
            ,clsdat -- 结束日期
            ,advnam -- 通知行名称
            ,advref -- 通知行参考号
            ,amedat -- 上次修改日期
            ,amenbr -- 修改次数
            ,aplnam -- 申请人名称
            ,aplref -- 申请人参考号
            ,avbby -- 指定方式
            ,avbwth -- 指定方式
            ,bennam -- 收益人名字
            ,benref -- 受益人参考号
            ,chato -- 费用流向
            ,cnfdet -- 保兑状态
            ,expdat -- 效期，指定信用证的效期
            ,expplc -- 交单地点
            ,lcrtyp -- 信用证的格式
            ,nomspc -- 规格数量
            ,nomtop -- 溢短装
            ,nomton -- 溢短装
            ,preadvdt -- 预通知日期
            ,rmbact -- 偿付行用户帐号
            ,rmbcha -- 偿付行费用
            ,rmbflg -- 偿付标志
            ,shpdat -- 装船日期
            ,shpfro -- 装船地点
            ,porloa -- 装货港
            ,pordis -- 卸货港
            ,shppar -- 分装
            ,shpto -- 运货地点
            ,shptrs -- 转载[shptrs]
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,utlnbr -- 利用数目
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
            ,dflg -- 
            ,guaflg -- 
            ,tratyp -- 
            ,opnamo -- 
            ,ameflg -- 
            ,cretyp -- 
            ,tadtyp -- 
            ,shpins -- 
            ,sermod -- 
            ,serfro -- 
            ,negflg -- 
            ,comflg -- 
            ,insdat -- 
            ,shppars18 -- 
            ,shptrss18 -- 
            ,spcbenflg -- 
            ,spcrcbflg -- 
            ,prepertxts18 -- 
            ,prepers18 -- 
            ,zytyp -- 
            ,productname -- 
            ,contractno -- 
            ,concur -- 
            ,conamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 进口信用证id号
    ,o.ownref -- 参考号
    ,o.nam -- 标识交易的外部显示名称
    ,o.ownusr -- 参考号
    ,o.credat -- 开证或注册日期
    ,o.opndat -- 开证日期
    ,o.clsdat -- 结束日期
    ,o.advnam -- 通知行名称
    ,o.advref -- 通知行参考号
    ,o.amedat -- 上次修改日期
    ,o.amenbr -- 修改次数
    ,o.aplnam -- 申请人名称
    ,o.aplref -- 申请人参考号
    ,o.avbby -- 指定方式
    ,o.avbwth -- 指定方式
    ,o.bennam -- 收益人名字
    ,o.benref -- 受益人参考号
    ,o.chato -- 费用流向
    ,o.cnfdet -- 保兑状态
    ,o.expdat -- 效期，指定信用证的效期
    ,o.expplc -- 交单地点
    ,o.lcrtyp -- 信用证的格式
    ,o.nomspc -- 规格数量
    ,o.nomtop -- 溢短装
    ,o.nomton -- 溢短装
    ,o.preadvdt -- 预通知日期
    ,o.rmbact -- 偿付行用户帐号
    ,o.rmbcha -- 偿付行费用
    ,o.rmbflg -- 偿付标志
    ,o.shpdat -- 装船日期
    ,o.shpfro -- 装船地点
    ,o.porloa -- 装货港
    ,o.pordis -- 卸货港
    ,o.shppar -- 分装
    ,o.shpto -- 运货地点
    ,o.shptrs -- 转载[shptrs]
    ,o.stacty -- 国家代码
    ,o.stagod -- 货物代码
    ,o.utlnbr -- 利用数目
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
    ,o.dflg -- 
    ,o.guaflg -- 
    ,o.tratyp -- 
    ,o.opnamo -- 
    ,o.ameflg -- 
    ,o.cretyp -- 
    ,o.tadtyp -- 
    ,o.shpins -- 
    ,o.sermod -- 
    ,o.serfro -- 
    ,o.negflg -- 
    ,o.comflg -- 
    ,o.insdat -- 
    ,o.shppars18 -- 
    ,o.shptrss18 -- 
    ,o.spcbenflg -- 
    ,o.spcrcbflg -- 
    ,o.prepertxts18 -- 
    ,o.prepers18 -- 
    ,o.zytyp -- 
    ,o.productname -- 
    ,o.contractno -- 
    ,o.concur -- 
    ,o.conamt -- 
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
from ${iol_schema}.isbs_lid_bk o
    left join ${iol_schema}.isbs_lid_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_lid_cl d
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
--truncate table ${iol_schema}.isbs_lid;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_lid') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_lid drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_lid add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_lid exchange partition p_${batch_date} with table ${iol_schema}.isbs_lid_cl;
alter table ${iol_schema}.isbs_lid exchange partition p_20991231 with table ${iol_schema}.isbs_lid_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_lid to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_lid_op purge;
drop table ${iol_schema}.isbs_lid_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_lid_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_lid',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
