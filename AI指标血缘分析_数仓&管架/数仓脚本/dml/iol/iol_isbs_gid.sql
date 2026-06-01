/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_gid
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
create table ${iol_schema}.isbs_gid_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_gid
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_gid_op purge;
drop table ${iol_schema}.isbs_gid_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_gid_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_gid where 0=1;

create table ${iol_schema}.isbs_gid_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_gid where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_gid_cl(
            inr -- 保函内部ID号
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,ownusr -- 负责人
            ,credat -- 创建日期
            ,opndat -- 保函生效日，定义保函有效的开始日期
            ,clsdat -- 结束日期
            ,oldref -- 以前的业务号
            ,amedat -- 最后一次修改日期
            ,orddat -- 客户订单日期
            ,amenbr -- 修改次数
            ,pndclm -- 为决的索偿次数
            ,chato -- 费用流向，保函开立GITOPN交易中业务人员手工选择                                                                          1. On applicant side      赋值U                                                                                                                 2.On beneficariy side   赋值B                                                                                                      3.Other  赋值O
            ,expdat -- 保函的到期日，定义保函的期满日期
            ,liadat -- liability定义负载的有效期
            ,stacty -- Country Code
            ,ver -- 版本号
            ,hndtyp -- 保函开立类型
            ,gidtxtmodflg -- 修改交易文本
            ,gtxinr -- 产生文本INR
            ,giduil -- 语言
            ,expflg -- 效期标志
            ,liaflg -- 选择赋值X,不选赋值空
            ,orcdat -- 初始交易日期, 显示初始保函的日期
            ,orcref -- 合同号
            ,orccur -- 初始交易币种
            ,orcamt -- 初始交易金额
            ,orcrat -- 初始交易汇率
            ,sndto -- 保函发给
            ,purcan -- 取消原因
            ,tenref -- 
            ,tendat -- 
            ,avidat -- 
            ,tenclsdat -- 
            ,decrea -- 
            ,jurplc -- 
            ,jurlaw -- 
            ,acc -- 
            ,resflg -- 
            ,stagod -- 
            ,redamt -- 
            ,redcur -- 
            ,reddat -- 
            ,outcur -- 
            ,outamt -- 
            ,cnfsta -- 
            ,partcon -- 
            ,cnfdat -- 
            ,cnfflg -- 
            ,revflg -- 
            ,etyextkey -- 
            ,gartyp -- 
            ,trmdat -- 
            ,legfrm -- 
            ,inudat -- 
            ,feecoldat -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,teskeyunc -- 
            ,juscod -- 
            ,cunqii -- 
            ,bilvvv -- 
            ,decflg -- 
            ,rskrat -- 
            ,cshpct -- 
            ,guaflg -- 
            ,fincod -- 
            ,fintyp -- 
            ,relcshpct -- 
            ,garfin -- 
            ,purpos -- 
            ,plsiss -- 代开标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_gid_op(
            inr -- 保函内部ID号
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,ownusr -- 负责人
            ,credat -- 创建日期
            ,opndat -- 保函生效日，定义保函有效的开始日期
            ,clsdat -- 结束日期
            ,oldref -- 以前的业务号
            ,amedat -- 最后一次修改日期
            ,orddat -- 客户订单日期
            ,amenbr -- 修改次数
            ,pndclm -- 为决的索偿次数
            ,chato -- 费用流向，保函开立GITOPN交易中业务人员手工选择                                                                          1. On applicant side      赋值U                                                                                                                 2.On beneficariy side   赋值B                                                                                                      3.Other  赋值O
            ,expdat -- 保函的到期日，定义保函的期满日期
            ,liadat -- liability定义负载的有效期
            ,stacty -- Country Code
            ,ver -- 版本号
            ,hndtyp -- 保函开立类型
            ,gidtxtmodflg -- 修改交易文本
            ,gtxinr -- 产生文本INR
            ,giduil -- 语言
            ,expflg -- 效期标志
            ,liaflg -- 选择赋值X,不选赋值空
            ,orcdat -- 初始交易日期, 显示初始保函的日期
            ,orcref -- 合同号
            ,orccur -- 初始交易币种
            ,orcamt -- 初始交易金额
            ,orcrat -- 初始交易汇率
            ,sndto -- 保函发给
            ,purcan -- 取消原因
            ,tenref -- 
            ,tendat -- 
            ,avidat -- 
            ,tenclsdat -- 
            ,decrea -- 
            ,jurplc -- 
            ,jurlaw -- 
            ,acc -- 
            ,resflg -- 
            ,stagod -- 
            ,redamt -- 
            ,redcur -- 
            ,reddat -- 
            ,outcur -- 
            ,outamt -- 
            ,cnfsta -- 
            ,partcon -- 
            ,cnfdat -- 
            ,cnfflg -- 
            ,revflg -- 
            ,etyextkey -- 
            ,gartyp -- 
            ,trmdat -- 
            ,legfrm -- 
            ,inudat -- 
            ,feecoldat -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,teskeyunc -- 
            ,juscod -- 
            ,cunqii -- 
            ,bilvvv -- 
            ,decflg -- 
            ,rskrat -- 
            ,cshpct -- 
            ,guaflg -- 
            ,fincod -- 
            ,fintyp -- 
            ,relcshpct -- 
            ,garfin -- 
            ,purpos -- 
            ,plsiss -- 代开标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 保函内部ID号
    ,nvl(n.ownref, o.ownref) as ownref -- 参考号
    ,nvl(n.nam, o.nam) as nam -- 交易名称
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 负责人
    ,nvl(n.credat, o.credat) as credat -- 创建日期
    ,nvl(n.opndat, o.opndat) as opndat -- 保函生效日，定义保函有效的开始日期
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 结束日期
    ,nvl(n.oldref, o.oldref) as oldref -- 以前的业务号
    ,nvl(n.amedat, o.amedat) as amedat -- 最后一次修改日期
    ,nvl(n.orddat, o.orddat) as orddat -- 客户订单日期
    ,nvl(n.amenbr, o.amenbr) as amenbr -- 修改次数
    ,nvl(n.pndclm, o.pndclm) as pndclm -- 为决的索偿次数
    ,nvl(n.chato, o.chato) as chato -- 费用流向，保函开立GITOPN交易中业务人员手工选择                                                                          1. On applicant side      赋值U                                                                                                                 2.On beneficariy side   赋值B                                                                                                      3.Other  赋值O
    ,nvl(n.expdat, o.expdat) as expdat -- 保函的到期日，定义保函的期满日期
    ,nvl(n.liadat, o.liadat) as liadat -- liability定义负载的有效期
    ,nvl(n.stacty, o.stacty) as stacty -- Country Code
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.hndtyp, o.hndtyp) as hndtyp -- 保函开立类型
    ,nvl(n.gidtxtmodflg, o.gidtxtmodflg) as gidtxtmodflg -- 修改交易文本
    ,nvl(n.gtxinr, o.gtxinr) as gtxinr -- 产生文本INR
    ,nvl(n.giduil, o.giduil) as giduil -- 语言
    ,nvl(n.expflg, o.expflg) as expflg -- 效期标志
    ,nvl(n.liaflg, o.liaflg) as liaflg -- 选择赋值X,不选赋值空
    ,nvl(n.orcdat, o.orcdat) as orcdat -- 初始交易日期, 显示初始保函的日期
    ,nvl(n.orcref, o.orcref) as orcref -- 合同号
    ,nvl(n.orccur, o.orccur) as orccur -- 初始交易币种
    ,nvl(n.orcamt, o.orcamt) as orcamt -- 初始交易金额
    ,nvl(n.orcrat, o.orcrat) as orcrat -- 初始交易汇率
    ,nvl(n.sndto, o.sndto) as sndto -- 保函发给
    ,nvl(n.purcan, o.purcan) as purcan -- 取消原因
    ,nvl(n.tenref, o.tenref) as tenref -- 
    ,nvl(n.tendat, o.tendat) as tendat -- 
    ,nvl(n.avidat, o.avidat) as avidat -- 
    ,nvl(n.tenclsdat, o.tenclsdat) as tenclsdat -- 
    ,nvl(n.decrea, o.decrea) as decrea -- 
    ,nvl(n.jurplc, o.jurplc) as jurplc -- 
    ,nvl(n.jurlaw, o.jurlaw) as jurlaw -- 
    ,nvl(n.acc, o.acc) as acc -- 
    ,nvl(n.resflg, o.resflg) as resflg -- 
    ,nvl(n.stagod, o.stagod) as stagod -- 
    ,nvl(n.redamt, o.redamt) as redamt -- 
    ,nvl(n.redcur, o.redcur) as redcur -- 
    ,nvl(n.reddat, o.reddat) as reddat -- 
    ,nvl(n.outcur, o.outcur) as outcur -- 
    ,nvl(n.outamt, o.outamt) as outamt -- 
    ,nvl(n.cnfsta, o.cnfsta) as cnfsta -- 
    ,nvl(n.partcon, o.partcon) as partcon -- 
    ,nvl(n.cnfdat, o.cnfdat) as cnfdat -- 
    ,nvl(n.cnfflg, o.cnfflg) as cnfflg -- 
    ,nvl(n.revflg, o.revflg) as revflg -- 
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 
    ,nvl(n.gartyp, o.gartyp) as gartyp -- 
    ,nvl(n.trmdat, o.trmdat) as trmdat -- 
    ,nvl(n.legfrm, o.legfrm) as legfrm -- 
    ,nvl(n.inudat, o.inudat) as inudat -- 
    ,nvl(n.feecoldat, o.feecoldat) as feecoldat -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,nvl(n.teskeyunc, o.teskeyunc) as teskeyunc -- 
    ,nvl(n.juscod, o.juscod) as juscod -- 
    ,nvl(n.cunqii, o.cunqii) as cunqii -- 
    ,nvl(n.bilvvv, o.bilvvv) as bilvvv -- 
    ,nvl(n.decflg, o.decflg) as decflg -- 
    ,nvl(n.rskrat, o.rskrat) as rskrat -- 
    ,nvl(n.cshpct, o.cshpct) as cshpct -- 
    ,nvl(n.guaflg, o.guaflg) as guaflg -- 
    ,nvl(n.fincod, o.fincod) as fincod -- 
    ,nvl(n.fintyp, o.fintyp) as fintyp -- 
    ,nvl(n.relcshpct, o.relcshpct) as relcshpct -- 
    ,nvl(n.garfin, o.garfin) as garfin -- 
    ,nvl(n.purpos, o.purpos) as purpos -- 
    ,nvl(n.plsiss, o.plsiss) as plsiss -- 代开标志
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
from (select * from ${iol_schema}.isbs_gid_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_gid where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.oldref <> n.oldref
        or o.amedat <> n.amedat
        or o.orddat <> n.orddat
        or o.amenbr <> n.amenbr
        or o.pndclm <> n.pndclm
        or o.chato <> n.chato
        or o.expdat <> n.expdat
        or o.liadat <> n.liadat
        or o.stacty <> n.stacty
        or o.ver <> n.ver
        or o.hndtyp <> n.hndtyp
        or o.gidtxtmodflg <> n.gidtxtmodflg
        or o.gtxinr <> n.gtxinr
        or o.giduil <> n.giduil
        or o.expflg <> n.expflg
        or o.liaflg <> n.liaflg
        or o.orcdat <> n.orcdat
        or o.orcref <> n.orcref
        or o.orccur <> n.orccur
        or o.orcamt <> n.orcamt
        or o.orcrat <> n.orcrat
        or o.sndto <> n.sndto
        or o.purcan <> n.purcan
        or o.tenref <> n.tenref
        or o.tendat <> n.tendat
        or o.avidat <> n.avidat
        or o.tenclsdat <> n.tenclsdat
        or o.decrea <> n.decrea
        or o.jurplc <> n.jurplc
        or o.jurlaw <> n.jurlaw
        or o.acc <> n.acc
        or o.resflg <> n.resflg
        or o.stagod <> n.stagod
        or o.redamt <> n.redamt
        or o.redcur <> n.redcur
        or o.reddat <> n.reddat
        or o.outcur <> n.outcur
        or o.outamt <> n.outamt
        or o.cnfsta <> n.cnfsta
        or o.partcon <> n.partcon
        or o.cnfdat <> n.cnfdat
        or o.cnfflg <> n.cnfflg
        or o.revflg <> n.revflg
        or o.etyextkey <> n.etyextkey
        or o.gartyp <> n.gartyp
        or o.trmdat <> n.trmdat
        or o.legfrm <> n.legfrm
        or o.inudat <> n.inudat
        or o.feecoldat <> n.feecoldat
        or o.bchkeyinr <> n.bchkeyinr
        or o.branchinr <> n.branchinr
        or o.teskeyunc <> n.teskeyunc
        or o.juscod <> n.juscod
        or o.cunqii <> n.cunqii
        or o.bilvvv <> n.bilvvv
        or o.decflg <> n.decflg
        or o.rskrat <> n.rskrat
        or o.cshpct <> n.cshpct
        or o.guaflg <> n.guaflg
        or o.fincod <> n.fincod
        or o.fintyp <> n.fintyp
        or o.relcshpct <> n.relcshpct
        or o.garfin <> n.garfin
        or o.purpos <> n.purpos
        or o.plsiss <> n.plsiss
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_gid_cl(
            inr -- 保函内部ID号
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,ownusr -- 负责人
            ,credat -- 创建日期
            ,opndat -- 保函生效日，定义保函有效的开始日期
            ,clsdat -- 结束日期
            ,oldref -- 以前的业务号
            ,amedat -- 最后一次修改日期
            ,orddat -- 客户订单日期
            ,amenbr -- 修改次数
            ,pndclm -- 为决的索偿次数
            ,chato -- 费用流向，保函开立GITOPN交易中业务人员手工选择                                                                          1. On applicant side      赋值U                                                                                                                 2.On beneficariy side   赋值B                                                                                                      3.Other  赋值O
            ,expdat -- 保函的到期日，定义保函的期满日期
            ,liadat -- liability定义负载的有效期
            ,stacty -- Country Code
            ,ver -- 版本号
            ,hndtyp -- 保函开立类型
            ,gidtxtmodflg -- 修改交易文本
            ,gtxinr -- 产生文本INR
            ,giduil -- 语言
            ,expflg -- 效期标志
            ,liaflg -- 选择赋值X,不选赋值空
            ,orcdat -- 初始交易日期, 显示初始保函的日期
            ,orcref -- 合同号
            ,orccur -- 初始交易币种
            ,orcamt -- 初始交易金额
            ,orcrat -- 初始交易汇率
            ,sndto -- 保函发给
            ,purcan -- 取消原因
            ,tenref -- 
            ,tendat -- 
            ,avidat -- 
            ,tenclsdat -- 
            ,decrea -- 
            ,jurplc -- 
            ,jurlaw -- 
            ,acc -- 
            ,resflg -- 
            ,stagod -- 
            ,redamt -- 
            ,redcur -- 
            ,reddat -- 
            ,outcur -- 
            ,outamt -- 
            ,cnfsta -- 
            ,partcon -- 
            ,cnfdat -- 
            ,cnfflg -- 
            ,revflg -- 
            ,etyextkey -- 
            ,gartyp -- 
            ,trmdat -- 
            ,legfrm -- 
            ,inudat -- 
            ,feecoldat -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,teskeyunc -- 
            ,juscod -- 
            ,cunqii -- 
            ,bilvvv -- 
            ,decflg -- 
            ,rskrat -- 
            ,cshpct -- 
            ,guaflg -- 
            ,fincod -- 
            ,fintyp -- 
            ,relcshpct -- 
            ,garfin -- 
            ,purpos -- 
            ,plsiss -- 代开标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_gid_op(
            inr -- 保函内部ID号
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,ownusr -- 负责人
            ,credat -- 创建日期
            ,opndat -- 保函生效日，定义保函有效的开始日期
            ,clsdat -- 结束日期
            ,oldref -- 以前的业务号
            ,amedat -- 最后一次修改日期
            ,orddat -- 客户订单日期
            ,amenbr -- 修改次数
            ,pndclm -- 为决的索偿次数
            ,chato -- 费用流向，保函开立GITOPN交易中业务人员手工选择                                                                          1. On applicant side      赋值U                                                                                                                 2.On beneficariy side   赋值B                                                                                                      3.Other  赋值O
            ,expdat -- 保函的到期日，定义保函的期满日期
            ,liadat -- liability定义负载的有效期
            ,stacty -- Country Code
            ,ver -- 版本号
            ,hndtyp -- 保函开立类型
            ,gidtxtmodflg -- 修改交易文本
            ,gtxinr -- 产生文本INR
            ,giduil -- 语言
            ,expflg -- 效期标志
            ,liaflg -- 选择赋值X,不选赋值空
            ,orcdat -- 初始交易日期, 显示初始保函的日期
            ,orcref -- 合同号
            ,orccur -- 初始交易币种
            ,orcamt -- 初始交易金额
            ,orcrat -- 初始交易汇率
            ,sndto -- 保函发给
            ,purcan -- 取消原因
            ,tenref -- 
            ,tendat -- 
            ,avidat -- 
            ,tenclsdat -- 
            ,decrea -- 
            ,jurplc -- 
            ,jurlaw -- 
            ,acc -- 
            ,resflg -- 
            ,stagod -- 
            ,redamt -- 
            ,redcur -- 
            ,reddat -- 
            ,outcur -- 
            ,outamt -- 
            ,cnfsta -- 
            ,partcon -- 
            ,cnfdat -- 
            ,cnfflg -- 
            ,revflg -- 
            ,etyextkey -- 
            ,gartyp -- 
            ,trmdat -- 
            ,legfrm -- 
            ,inudat -- 
            ,feecoldat -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,teskeyunc -- 
            ,juscod -- 
            ,cunqii -- 
            ,bilvvv -- 
            ,decflg -- 
            ,rskrat -- 
            ,cshpct -- 
            ,guaflg -- 
            ,fincod -- 
            ,fintyp -- 
            ,relcshpct -- 
            ,garfin -- 
            ,purpos -- 
            ,plsiss -- 代开标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 保函内部ID号
    ,o.ownref -- 参考号
    ,o.nam -- 交易名称
    ,o.ownusr -- 负责人
    ,o.credat -- 创建日期
    ,o.opndat -- 保函生效日，定义保函有效的开始日期
    ,o.clsdat -- 结束日期
    ,o.oldref -- 以前的业务号
    ,o.amedat -- 最后一次修改日期
    ,o.orddat -- 客户订单日期
    ,o.amenbr -- 修改次数
    ,o.pndclm -- 为决的索偿次数
    ,o.chato -- 费用流向，保函开立GITOPN交易中业务人员手工选择                                                                          1. On applicant side      赋值U                                                                                                                 2.On beneficariy side   赋值B                                                                                                      3.Other  赋值O
    ,o.expdat -- 保函的到期日，定义保函的期满日期
    ,o.liadat -- liability定义负载的有效期
    ,o.stacty -- Country Code
    ,o.ver -- 版本号
    ,o.hndtyp -- 保函开立类型
    ,o.gidtxtmodflg -- 修改交易文本
    ,o.gtxinr -- 产生文本INR
    ,o.giduil -- 语言
    ,o.expflg -- 效期标志
    ,o.liaflg -- 选择赋值X,不选赋值空
    ,o.orcdat -- 初始交易日期, 显示初始保函的日期
    ,o.orcref -- 合同号
    ,o.orccur -- 初始交易币种
    ,o.orcamt -- 初始交易金额
    ,o.orcrat -- 初始交易汇率
    ,o.sndto -- 保函发给
    ,o.purcan -- 取消原因
    ,o.tenref -- 
    ,o.tendat -- 
    ,o.avidat -- 
    ,o.tenclsdat -- 
    ,o.decrea -- 
    ,o.jurplc -- 
    ,o.jurlaw -- 
    ,o.acc -- 
    ,o.resflg -- 
    ,o.stagod -- 
    ,o.redamt -- 
    ,o.redcur -- 
    ,o.reddat -- 
    ,o.outcur -- 
    ,o.outamt -- 
    ,o.cnfsta -- 
    ,o.partcon -- 
    ,o.cnfdat -- 
    ,o.cnfflg -- 
    ,o.revflg -- 
    ,o.etyextkey -- 
    ,o.gartyp -- 
    ,o.trmdat -- 
    ,o.legfrm -- 
    ,o.inudat -- 
    ,o.feecoldat -- 
    ,o.bchkeyinr -- 
    ,o.branchinr -- 
    ,o.teskeyunc -- 
    ,o.juscod -- 
    ,o.cunqii -- 
    ,o.bilvvv -- 
    ,o.decflg -- 
    ,o.rskrat -- 
    ,o.cshpct -- 
    ,o.guaflg -- 
    ,o.fincod -- 
    ,o.fintyp -- 
    ,o.relcshpct -- 
    ,o.garfin -- 
    ,o.purpos -- 
    ,o.plsiss -- 代开标志
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
from ${iol_schema}.isbs_gid_bk o
    left join ${iol_schema}.isbs_gid_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_gid_cl d
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
--truncate table ${iol_schema}.isbs_gid;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_gid') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_gid drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_gid add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_gid exchange partition p_${batch_date} with table ${iol_schema}.isbs_gid_cl;
alter table ${iol_schema}.isbs_gid exchange partition p_20991231 with table ${iol_schema}.isbs_gid_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_gid to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_gid_op purge;
drop table ${iol_schema}.isbs_gid_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_gid_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_gid',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
