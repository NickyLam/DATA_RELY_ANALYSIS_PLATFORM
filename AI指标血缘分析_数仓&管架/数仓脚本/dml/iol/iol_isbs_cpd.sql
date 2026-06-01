/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_cpd
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
create table ${iol_schema}.isbs_cpd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_cpd
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_cpd_op purge;
drop table ${iol_schema}.isbs_cpd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cpd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_cpd where 0=1;

create table ${iol_schema}.isbs_cpd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_cpd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_cpd_cl(
            inr -- 唯一id
            ,ownref -- 交易参考号
            ,nam -- 交易描述
            ,pyeptyinr -- 收款人的inr
            ,pyeptainr -- 收款人的地址
            ,pyenam -- 收款人的描述
            ,pyeref -- 收款人的参考号
            ,pybptyinr -- 付款银行的inr
            ,pybptainr -- 付款银行地址的inr
            ,pybnam -- 付款银行名称
            ,pybref -- 付款银行参考号
            ,orcptyinr -- 汇款人ptyinr
            ,orcptainr -- 汇款人ptainr
            ,orcnam -- 汇款人名称
            ,orcref -- 汇款人参考号
            ,oriptyinr -- 汇款行ptyinr
            ,oriptainr -- 汇款行ptainr
            ,orinam -- 汇款行名称
            ,oriref -- 汇款行参考号
            ,valdat -- 起息日
            ,opndat -- 交易开始时间
            ,clsdat -- 交易关闭时间
            ,chato -- 费用
            ,credat -- 建立日期
            ,ownusr -- 操作用户
            ,ver -- 版本号
            ,detchgcod -- 详细费用
            ,paytyp -- 付款类型
            ,stagod -- 货物代码
            ,stacty -- 国家代码
            ,etyextkey -- 实体关键字
            ,sysno -- 清算编号
            ,othbch -- 所属行
            ,gors -- 收款对象
            ,feecur -- 国外费用币种
            ,feeamt -- 国外费用金额
            ,trntyp -- 汇款性质
            ,paytype -- 汇款方式
            ,paydat -- 付款日期
            ,clityp -- 客户类型
            ,trdint -- 结汇类型
            ,curf33b -- 原始币种
            ,cur71f -- 发报行扣费币种
            ,amt71f -- 发报行扣费金额
            ,amtf33b -- 原始金额
            ,f36 -- 汇率
            ,f23e -- 指令代码
            ,f23b -- 银行操作码
            ,trdout -- 售汇类型
            ,swftyp -- 报文类型
            ,trdinr -- trd表inr
            ,rel21 -- 参考号
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,accmod -- 处理类型
            ,sztyp -- 收支类型
            ,sndbanref -- 发报行原始编号
            ,orcact -- 汇款人帐号
            ,pyeact -- 收款人帐号
            ,canflg -- 退汇标志
            ,nraflg -- nra标志
            ,qsqdbh -- 清算渠道
            ,zjcflg -- 跨境资金池标识
            ,edtyp -- 资金池业务类型
            ,basamt -- 资金池业务本金
            ,intamt -- 资金池业务利息
            ,stzfref -- 受托支付编号
            ,duebillno -- 受托支付出账借据号
            ,gpiflg -- gpi业务标识
            ,acstyp -- gpi mt199报文反馈码
            ,qufflg -- 询价标识（线上汇款业务是否有做过询价）
            ,feeacc -- 扣费账号（线上汇款业务的费用承担方为our时带入客户扣费账号）
            ,resno -- 限制编号
            ,isbxt -- 是否北向通
            ,bxtamt -- 金额
            ,bxtsamt -- 北向通金额
            ,iskds -- 是否跨境电商标识
            ,sbflg -- 申报标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_cpd_op(
            inr -- 唯一id
            ,ownref -- 交易参考号
            ,nam -- 交易描述
            ,pyeptyinr -- 收款人的inr
            ,pyeptainr -- 收款人的地址
            ,pyenam -- 收款人的描述
            ,pyeref -- 收款人的参考号
            ,pybptyinr -- 付款银行的inr
            ,pybptainr -- 付款银行地址的inr
            ,pybnam -- 付款银行名称
            ,pybref -- 付款银行参考号
            ,orcptyinr -- 汇款人ptyinr
            ,orcptainr -- 汇款人ptainr
            ,orcnam -- 汇款人名称
            ,orcref -- 汇款人参考号
            ,oriptyinr -- 汇款行ptyinr
            ,oriptainr -- 汇款行ptainr
            ,orinam -- 汇款行名称
            ,oriref -- 汇款行参考号
            ,valdat -- 起息日
            ,opndat -- 交易开始时间
            ,clsdat -- 交易关闭时间
            ,chato -- 费用
            ,credat -- 建立日期
            ,ownusr -- 操作用户
            ,ver -- 版本号
            ,detchgcod -- 详细费用
            ,paytyp -- 付款类型
            ,stagod -- 货物代码
            ,stacty -- 国家代码
            ,etyextkey -- 实体关键字
            ,sysno -- 清算编号
            ,othbch -- 所属行
            ,gors -- 收款对象
            ,feecur -- 国外费用币种
            ,feeamt -- 国外费用金额
            ,trntyp -- 汇款性质
            ,paytype -- 汇款方式
            ,paydat -- 付款日期
            ,clityp -- 客户类型
            ,trdint -- 结汇类型
            ,curf33b -- 原始币种
            ,cur71f -- 发报行扣费币种
            ,amt71f -- 发报行扣费金额
            ,amtf33b -- 原始金额
            ,f36 -- 汇率
            ,f23e -- 指令代码
            ,f23b -- 银行操作码
            ,trdout -- 售汇类型
            ,swftyp -- 报文类型
            ,trdinr -- trd表inr
            ,rel21 -- 参考号
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,accmod -- 处理类型
            ,sztyp -- 收支类型
            ,sndbanref -- 发报行原始编号
            ,orcact -- 汇款人帐号
            ,pyeact -- 收款人帐号
            ,canflg -- 退汇标志
            ,nraflg -- nra标志
            ,qsqdbh -- 清算渠道
            ,zjcflg -- 跨境资金池标识
            ,edtyp -- 资金池业务类型
            ,basamt -- 资金池业务本金
            ,intamt -- 资金池业务利息
            ,stzfref -- 受托支付编号
            ,duebillno -- 受托支付出账借据号
            ,gpiflg -- gpi业务标识
            ,acstyp -- gpi mt199报文反馈码
            ,qufflg -- 询价标识（线上汇款业务是否有做过询价）
            ,feeacc -- 扣费账号（线上汇款业务的费用承担方为our时带入客户扣费账号）
            ,resno -- 限制编号
            ,isbxt -- 是否北向通
            ,bxtamt -- 金额
            ,bxtsamt -- 北向通金额
            ,iskds -- 是否跨境电商标识
            ,sbflg -- 申报标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 唯一id
    ,nvl(n.ownref, o.ownref) as ownref -- 交易参考号
    ,nvl(n.nam, o.nam) as nam -- 交易描述
    ,nvl(n.pyeptyinr, o.pyeptyinr) as pyeptyinr -- 收款人的inr
    ,nvl(n.pyeptainr, o.pyeptainr) as pyeptainr -- 收款人的地址
    ,nvl(n.pyenam, o.pyenam) as pyenam -- 收款人的描述
    ,nvl(n.pyeref, o.pyeref) as pyeref -- 收款人的参考号
    ,nvl(n.pybptyinr, o.pybptyinr) as pybptyinr -- 付款银行的inr
    ,nvl(n.pybptainr, o.pybptainr) as pybptainr -- 付款银行地址的inr
    ,nvl(n.pybnam, o.pybnam) as pybnam -- 付款银行名称
    ,nvl(n.pybref, o.pybref) as pybref -- 付款银行参考号
    ,nvl(n.orcptyinr, o.orcptyinr) as orcptyinr -- 汇款人ptyinr
    ,nvl(n.orcptainr, o.orcptainr) as orcptainr -- 汇款人ptainr
    ,nvl(n.orcnam, o.orcnam) as orcnam -- 汇款人名称
    ,nvl(n.orcref, o.orcref) as orcref -- 汇款人参考号
    ,nvl(n.oriptyinr, o.oriptyinr) as oriptyinr -- 汇款行ptyinr
    ,nvl(n.oriptainr, o.oriptainr) as oriptainr -- 汇款行ptainr
    ,nvl(n.orinam, o.orinam) as orinam -- 汇款行名称
    ,nvl(n.oriref, o.oriref) as oriref -- 汇款行参考号
    ,nvl(n.valdat, o.valdat) as valdat -- 起息日
    ,nvl(n.opndat, o.opndat) as opndat -- 交易开始时间
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 交易关闭时间
    ,nvl(n.chato, o.chato) as chato -- 费用
    ,nvl(n.credat, o.credat) as credat -- 建立日期
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 操作用户
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.detchgcod, o.detchgcod) as detchgcod -- 详细费用
    ,nvl(n.paytyp, o.paytyp) as paytyp -- 付款类型
    ,nvl(n.stagod, o.stagod) as stagod -- 货物代码
    ,nvl(n.stacty, o.stacty) as stacty -- 国家代码
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 实体关键字
    ,nvl(n.sysno, o.sysno) as sysno -- 清算编号
    ,nvl(n.othbch, o.othbch) as othbch -- 所属行
    ,nvl(n.gors, o.gors) as gors -- 收款对象
    ,nvl(n.feecur, o.feecur) as feecur -- 国外费用币种
    ,nvl(n.feeamt, o.feeamt) as feeamt -- 国外费用金额
    ,nvl(n.trntyp, o.trntyp) as trntyp -- 汇款性质
    ,nvl(n.paytype, o.paytype) as paytype -- 汇款方式
    ,nvl(n.paydat, o.paydat) as paydat -- 付款日期
    ,nvl(n.clityp, o.clityp) as clityp -- 客户类型
    ,nvl(n.trdint, o.trdint) as trdint -- 结汇类型
    ,nvl(n.curf33b, o.curf33b) as curf33b -- 原始币种
    ,nvl(n.cur71f, o.cur71f) as cur71f -- 发报行扣费币种
    ,nvl(n.amt71f, o.amt71f) as amt71f -- 发报行扣费金额
    ,nvl(n.amtf33b, o.amtf33b) as amtf33b -- 原始金额
    ,nvl(n.f36, o.f36) as f36 -- 汇率
    ,nvl(n.f23e, o.f23e) as f23e -- 指令代码
    ,nvl(n.f23b, o.f23b) as f23b -- 银行操作码
    ,nvl(n.trdout, o.trdout) as trdout -- 售汇类型
    ,nvl(n.swftyp, o.swftyp) as swftyp -- 报文类型
    ,nvl(n.trdinr, o.trdinr) as trdinr -- trd表inr
    ,nvl(n.rel21, o.rel21) as rel21 -- 参考号
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 所属机构号
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 经办机构号
    ,nvl(n.accmod, o.accmod) as accmod -- 处理类型
    ,nvl(n.sztyp, o.sztyp) as sztyp -- 收支类型
    ,nvl(n.sndbanref, o.sndbanref) as sndbanref -- 发报行原始编号
    ,nvl(n.orcact, o.orcact) as orcact -- 汇款人帐号
    ,nvl(n.pyeact, o.pyeact) as pyeact -- 收款人帐号
    ,nvl(n.canflg, o.canflg) as canflg -- 退汇标志
    ,nvl(n.nraflg, o.nraflg) as nraflg -- nra标志
    ,nvl(n.qsqdbh, o.qsqdbh) as qsqdbh -- 清算渠道
    ,nvl(n.zjcflg, o.zjcflg) as zjcflg -- 跨境资金池标识
    ,nvl(n.edtyp, o.edtyp) as edtyp -- 资金池业务类型
    ,nvl(n.basamt, o.basamt) as basamt -- 资金池业务本金
    ,nvl(n.intamt, o.intamt) as intamt -- 资金池业务利息
    ,nvl(n.stzfref, o.stzfref) as stzfref -- 受托支付编号
    ,nvl(n.duebillno, o.duebillno) as duebillno -- 受托支付出账借据号
    ,nvl(n.gpiflg, o.gpiflg) as gpiflg -- gpi业务标识
    ,nvl(n.acstyp, o.acstyp) as acstyp -- gpi mt199报文反馈码
    ,nvl(n.qufflg, o.qufflg) as qufflg -- 询价标识（线上汇款业务是否有做过询价）
    ,nvl(n.feeacc, o.feeacc) as feeacc -- 扣费账号（线上汇款业务的费用承担方为our时带入客户扣费账号）
    ,nvl(n.resno, o.resno) as resno -- 限制编号
    ,nvl(n.isbxt, o.isbxt) as isbxt -- 是否北向通
    ,nvl(n.bxtamt, o.bxtamt) as bxtamt -- 金额
    ,nvl(n.bxtsamt, o.bxtsamt) as bxtsamt -- 北向通金额
    ,nvl(n.iskds, o.iskds) as iskds -- 是否跨境电商标识
    ,nvl(n.sbflg, o.sbflg) as sbflg -- 申报标识
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
from (select * from ${iol_schema}.isbs_cpd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_cpd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.pyeptyinr <> n.pyeptyinr
        or o.pyeptainr <> n.pyeptainr
        or o.pyenam <> n.pyenam
        or o.pyeref <> n.pyeref
        or o.pybptyinr <> n.pybptyinr
        or o.pybptainr <> n.pybptainr
        or o.pybnam <> n.pybnam
        or o.pybref <> n.pybref
        or o.orcptyinr <> n.orcptyinr
        or o.orcptainr <> n.orcptainr
        or o.orcnam <> n.orcnam
        or o.orcref <> n.orcref
        or o.oriptyinr <> n.oriptyinr
        or o.oriptainr <> n.oriptainr
        or o.orinam <> n.orinam
        or o.oriref <> n.oriref
        or o.valdat <> n.valdat
        or o.opndat <> n.opndat
        or o.clsdat <> n.clsdat
        or o.chato <> n.chato
        or o.credat <> n.credat
        or o.ownusr <> n.ownusr
        or o.ver <> n.ver
        or o.detchgcod <> n.detchgcod
        or o.paytyp <> n.paytyp
        or o.stagod <> n.stagod
        or o.stacty <> n.stacty
        or o.etyextkey <> n.etyextkey
        or o.sysno <> n.sysno
        or o.othbch <> n.othbch
        or o.gors <> n.gors
        or o.feecur <> n.feecur
        or o.feeamt <> n.feeamt
        or o.trntyp <> n.trntyp
        or o.paytype <> n.paytype
        or o.paydat <> n.paydat
        or o.clityp <> n.clityp
        or o.trdint <> n.trdint
        or o.curf33b <> n.curf33b
        or o.cur71f <> n.cur71f
        or o.amt71f <> n.amt71f
        or o.amtf33b <> n.amtf33b
        or o.f36 <> n.f36
        or o.f23e <> n.f23e
        or o.f23b <> n.f23b
        or o.trdout <> n.trdout
        or o.swftyp <> n.swftyp
        or o.trdinr <> n.trdinr
        or o.rel21 <> n.rel21
        or o.branchinr <> n.branchinr
        or o.bchkeyinr <> n.bchkeyinr
        or o.accmod <> n.accmod
        or o.sztyp <> n.sztyp
        or o.sndbanref <> n.sndbanref
        or o.orcact <> n.orcact
        or o.pyeact <> n.pyeact
        or o.canflg <> n.canflg
        or o.nraflg <> n.nraflg
        or o.qsqdbh <> n.qsqdbh
        or o.zjcflg <> n.zjcflg
        or o.edtyp <> n.edtyp
        or o.basamt <> n.basamt
        or o.intamt <> n.intamt
        or o.stzfref <> n.stzfref
        or o.duebillno <> n.duebillno
        or o.gpiflg <> n.gpiflg
        or o.acstyp <> n.acstyp
        or o.qufflg <> n.qufflg
        or o.feeacc <> n.feeacc
        or o.resno <> n.resno
        or o.isbxt <> n.isbxt
        or o.bxtamt <> n.bxtamt
        or o.bxtsamt <> n.bxtsamt
        or o.iskds <> n.iskds
        or o.sbflg <> n.sbflg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_cpd_cl(
            inr -- 唯一id
            ,ownref -- 交易参考号
            ,nam -- 交易描述
            ,pyeptyinr -- 收款人的inr
            ,pyeptainr -- 收款人的地址
            ,pyenam -- 收款人的描述
            ,pyeref -- 收款人的参考号
            ,pybptyinr -- 付款银行的inr
            ,pybptainr -- 付款银行地址的inr
            ,pybnam -- 付款银行名称
            ,pybref -- 付款银行参考号
            ,orcptyinr -- 汇款人ptyinr
            ,orcptainr -- 汇款人ptainr
            ,orcnam -- 汇款人名称
            ,orcref -- 汇款人参考号
            ,oriptyinr -- 汇款行ptyinr
            ,oriptainr -- 汇款行ptainr
            ,orinam -- 汇款行名称
            ,oriref -- 汇款行参考号
            ,valdat -- 起息日
            ,opndat -- 交易开始时间
            ,clsdat -- 交易关闭时间
            ,chato -- 费用
            ,credat -- 建立日期
            ,ownusr -- 操作用户
            ,ver -- 版本号
            ,detchgcod -- 详细费用
            ,paytyp -- 付款类型
            ,stagod -- 货物代码
            ,stacty -- 国家代码
            ,etyextkey -- 实体关键字
            ,sysno -- 清算编号
            ,othbch -- 所属行
            ,gors -- 收款对象
            ,feecur -- 国外费用币种
            ,feeamt -- 国外费用金额
            ,trntyp -- 汇款性质
            ,paytype -- 汇款方式
            ,paydat -- 付款日期
            ,clityp -- 客户类型
            ,trdint -- 结汇类型
            ,curf33b -- 原始币种
            ,cur71f -- 发报行扣费币种
            ,amt71f -- 发报行扣费金额
            ,amtf33b -- 原始金额
            ,f36 -- 汇率
            ,f23e -- 指令代码
            ,f23b -- 银行操作码
            ,trdout -- 售汇类型
            ,swftyp -- 报文类型
            ,trdinr -- trd表inr
            ,rel21 -- 参考号
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,accmod -- 处理类型
            ,sztyp -- 收支类型
            ,sndbanref -- 发报行原始编号
            ,orcact -- 汇款人帐号
            ,pyeact -- 收款人帐号
            ,canflg -- 退汇标志
            ,nraflg -- nra标志
            ,qsqdbh -- 清算渠道
            ,zjcflg -- 跨境资金池标识
            ,edtyp -- 资金池业务类型
            ,basamt -- 资金池业务本金
            ,intamt -- 资金池业务利息
            ,stzfref -- 受托支付编号
            ,duebillno -- 受托支付出账借据号
            ,gpiflg -- gpi业务标识
            ,acstyp -- gpi mt199报文反馈码
            ,qufflg -- 询价标识（线上汇款业务是否有做过询价）
            ,feeacc -- 扣费账号（线上汇款业务的费用承担方为our时带入客户扣费账号）
            ,resno -- 限制编号
            ,isbxt -- 是否北向通
            ,bxtamt -- 金额
            ,bxtsamt -- 北向通金额
            ,iskds -- 是否跨境电商标识
            ,sbflg -- 申报标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_cpd_op(
            inr -- 唯一id
            ,ownref -- 交易参考号
            ,nam -- 交易描述
            ,pyeptyinr -- 收款人的inr
            ,pyeptainr -- 收款人的地址
            ,pyenam -- 收款人的描述
            ,pyeref -- 收款人的参考号
            ,pybptyinr -- 付款银行的inr
            ,pybptainr -- 付款银行地址的inr
            ,pybnam -- 付款银行名称
            ,pybref -- 付款银行参考号
            ,orcptyinr -- 汇款人ptyinr
            ,orcptainr -- 汇款人ptainr
            ,orcnam -- 汇款人名称
            ,orcref -- 汇款人参考号
            ,oriptyinr -- 汇款行ptyinr
            ,oriptainr -- 汇款行ptainr
            ,orinam -- 汇款行名称
            ,oriref -- 汇款行参考号
            ,valdat -- 起息日
            ,opndat -- 交易开始时间
            ,clsdat -- 交易关闭时间
            ,chato -- 费用
            ,credat -- 建立日期
            ,ownusr -- 操作用户
            ,ver -- 版本号
            ,detchgcod -- 详细费用
            ,paytyp -- 付款类型
            ,stagod -- 货物代码
            ,stacty -- 国家代码
            ,etyextkey -- 实体关键字
            ,sysno -- 清算编号
            ,othbch -- 所属行
            ,gors -- 收款对象
            ,feecur -- 国外费用币种
            ,feeamt -- 国外费用金额
            ,trntyp -- 汇款性质
            ,paytype -- 汇款方式
            ,paydat -- 付款日期
            ,clityp -- 客户类型
            ,trdint -- 结汇类型
            ,curf33b -- 原始币种
            ,cur71f -- 发报行扣费币种
            ,amt71f -- 发报行扣费金额
            ,amtf33b -- 原始金额
            ,f36 -- 汇率
            ,f23e -- 指令代码
            ,f23b -- 银行操作码
            ,trdout -- 售汇类型
            ,swftyp -- 报文类型
            ,trdinr -- trd表inr
            ,rel21 -- 参考号
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,accmod -- 处理类型
            ,sztyp -- 收支类型
            ,sndbanref -- 发报行原始编号
            ,orcact -- 汇款人帐号
            ,pyeact -- 收款人帐号
            ,canflg -- 退汇标志
            ,nraflg -- nra标志
            ,qsqdbh -- 清算渠道
            ,zjcflg -- 跨境资金池标识
            ,edtyp -- 资金池业务类型
            ,basamt -- 资金池业务本金
            ,intamt -- 资金池业务利息
            ,stzfref -- 受托支付编号
            ,duebillno -- 受托支付出账借据号
            ,gpiflg -- gpi业务标识
            ,acstyp -- gpi mt199报文反馈码
            ,qufflg -- 询价标识（线上汇款业务是否有做过询价）
            ,feeacc -- 扣费账号（线上汇款业务的费用承担方为our时带入客户扣费账号）
            ,resno -- 限制编号
            ,isbxt -- 是否北向通
            ,bxtamt -- 金额
            ,bxtsamt -- 北向通金额
            ,iskds -- 是否跨境电商标识
            ,sbflg -- 申报标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 唯一id
    ,o.ownref -- 交易参考号
    ,o.nam -- 交易描述
    ,o.pyeptyinr -- 收款人的inr
    ,o.pyeptainr -- 收款人的地址
    ,o.pyenam -- 收款人的描述
    ,o.pyeref -- 收款人的参考号
    ,o.pybptyinr -- 付款银行的inr
    ,o.pybptainr -- 付款银行地址的inr
    ,o.pybnam -- 付款银行名称
    ,o.pybref -- 付款银行参考号
    ,o.orcptyinr -- 汇款人ptyinr
    ,o.orcptainr -- 汇款人ptainr
    ,o.orcnam -- 汇款人名称
    ,o.orcref -- 汇款人参考号
    ,o.oriptyinr -- 汇款行ptyinr
    ,o.oriptainr -- 汇款行ptainr
    ,o.orinam -- 汇款行名称
    ,o.oriref -- 汇款行参考号
    ,o.valdat -- 起息日
    ,o.opndat -- 交易开始时间
    ,o.clsdat -- 交易关闭时间
    ,o.chato -- 费用
    ,o.credat -- 建立日期
    ,o.ownusr -- 操作用户
    ,o.ver -- 版本号
    ,o.detchgcod -- 详细费用
    ,o.paytyp -- 付款类型
    ,o.stagod -- 货物代码
    ,o.stacty -- 国家代码
    ,o.etyextkey -- 实体关键字
    ,o.sysno -- 清算编号
    ,o.othbch -- 所属行
    ,o.gors -- 收款对象
    ,o.feecur -- 国外费用币种
    ,o.feeamt -- 国外费用金额
    ,o.trntyp -- 汇款性质
    ,o.paytype -- 汇款方式
    ,o.paydat -- 付款日期
    ,o.clityp -- 客户类型
    ,o.trdint -- 结汇类型
    ,o.curf33b -- 原始币种
    ,o.cur71f -- 发报行扣费币种
    ,o.amt71f -- 发报行扣费金额
    ,o.amtf33b -- 原始金额
    ,o.f36 -- 汇率
    ,o.f23e -- 指令代码
    ,o.f23b -- 银行操作码
    ,o.trdout -- 售汇类型
    ,o.swftyp -- 报文类型
    ,o.trdinr -- trd表inr
    ,o.rel21 -- 参考号
    ,o.branchinr -- 所属机构号
    ,o.bchkeyinr -- 经办机构号
    ,o.accmod -- 处理类型
    ,o.sztyp -- 收支类型
    ,o.sndbanref -- 发报行原始编号
    ,o.orcact -- 汇款人帐号
    ,o.pyeact -- 收款人帐号
    ,o.canflg -- 退汇标志
    ,o.nraflg -- nra标志
    ,o.qsqdbh -- 清算渠道
    ,o.zjcflg -- 跨境资金池标识
    ,o.edtyp -- 资金池业务类型
    ,o.basamt -- 资金池业务本金
    ,o.intamt -- 资金池业务利息
    ,o.stzfref -- 受托支付编号
    ,o.duebillno -- 受托支付出账借据号
    ,o.gpiflg -- gpi业务标识
    ,o.acstyp -- gpi mt199报文反馈码
    ,o.qufflg -- 询价标识（线上汇款业务是否有做过询价）
    ,o.feeacc -- 扣费账号（线上汇款业务的费用承担方为our时带入客户扣费账号）
    ,o.resno -- 限制编号
    ,o.isbxt -- 是否北向通
    ,o.bxtamt -- 金额
    ,o.bxtsamt -- 北向通金额
    ,o.iskds -- 是否跨境电商标识
    ,o.sbflg -- 申报标识
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
from ${iol_schema}.isbs_cpd_bk o
    left join ${iol_schema}.isbs_cpd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_cpd_cl d
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
--truncate table ${iol_schema}.isbs_cpd;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_cpd') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_cpd drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_cpd add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_cpd exchange partition p_${batch_date} with table ${iol_schema}.isbs_cpd_cl;
alter table ${iol_schema}.isbs_cpd exchange partition p_20991231 with table ${iol_schema}.isbs_cpd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_cpd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_cpd_op purge;
drop table ${iol_schema}.isbs_cpd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_cpd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_cpd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
