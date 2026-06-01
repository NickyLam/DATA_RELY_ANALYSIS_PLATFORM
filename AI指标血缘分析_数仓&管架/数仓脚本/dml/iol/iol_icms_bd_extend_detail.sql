/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bd_extend_detail
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
create table ${iol_schema}.icms_bd_extend_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bd_extend_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bd_extend_detail_op purge;
drop table ${iol_schema}.icms_bd_extend_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bd_extend_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bd_extend_detail where 0=1;

create table ${iol_schema}.icms_bd_extend_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bd_extend_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bd_extend_detail_cl(
            serialno -- 借据编号
            ,migtflag -- 
            ,reselltype -- 01境内转让、02行内转让、03跨境转让
            ,ztrate -- 转贴现利率
            ,benefitcorpbank -- 受益人开户行
            ,nextperiodreturninterestdate -- 下一期还息日期
            ,acceptbankid -- 承兑行行号
            ,billtype -- 票据类型
            ,istran -- 转换
            ,tradeorgid -- 交易机构
            ,logoutdate -- (Del)注销日期
            ,openno -- 开立流水
            ,keyno -- 票据唯一标识
            ,fixterm -- 周期
            ,acceptinttype -- 收息类型
            ,eacmprincipal -- 每期扣款额本金利息
            ,fixflag -- 补登借据标志
            ,surplusphases -- 剩余期数
            ,opendate -- 开立日期
            ,benefitcorpname -- 受益人
            ,insum -- 累计归还本金
            ,reinforcechecker -- 补登复核人
            ,ztacceptbankname -- 直贴行行名
            ,duebalance -- 暂存借据余额
            ,legal -- 诉讼费
            ,datatype -- 批量数据来源（PJ,票据系统供数LC,理财资管系统供数ZJ,资金系统供数ZH,同业综合业务系统供数）
            ,littlecreditbatchno -- 支小再批次包
            ,loantype -- 贷款类型
            ,transdate -- 同业综合业务系统交易日期
            ,littlecreditstatus -- 支小再状态
            ,billno -- 票据号
            ,flag1 -- (new)是否1
            ,compensationsum -- 赔付金额
            ,isinuse -- 添加维护标志1正常2不维护
            ,ztacceptbankid -- 直贴行行号
            ,isteachhealth -- 是否文教健康
            ,benefitcorp -- (Del)受益人
            ,businessdept -- 业务部门
            ,aboutbankid2 -- 受益行行号
            ,advanceflagsum -- 垫款金额
            ,nextperiodreturnprincipaldate -- 下一期还本日期
            ,nextperiodreturninterestsum -- 下一期还息金额
            ,billkind -- 票据种类
            ,ictype -- 计息方式
            ,preinttype -- 预收息标志
            ,interestinsum -- 累计归还利息
            ,littlecreditbatchenddate -- 支小再批次到期日
            ,accountcatagory -- 账户类别(代码:AccountCatagory)
            ,aboutbankname2 -- 受益行行名
            ,logouttype -- 注销类型
            ,premiumrate -- 费率
            ,acceptbankname -- 承兑行行名
            ,littlecreditlapsetime -- 支小再失效时间
            ,deductdate -- 扣款日期
            ,logoutno -- 注销流水
            ,nextperiodreturnprincipalsum -- 下一期还本金额
            ,assetno -- 资产唯一标识
            ,actualbalance -- 原币余额
            ,actualbusinesssum -- 原币金额
            ,actualcurrency -- 原币种
            ,exchangerate -- 汇率
            ,ddno -- 序号（银团贷款）
            ,lender -- 联行号
            ,objid -- 同业业务系统OBJID
            ,naccountvalue -- 面值
            ,naccrualinterest -- 应计利息
            ,nbalance -- 账面价值
            ,ninterestadjust -- 利息调整
            ,npvvariation -- 公允价值变动
            ,interexpnum -- 利息支出费用编号
            ,commexpnum -- 手续费支出费用编号
            ,sellstatus -- 卖出状态
            ,overdrafttime -- 
            ,paymentobject -- 
            ,purpose -- 
            ,ftcommission -- 
            ,agreementid -- 
            ,isreceivebill -- 
            ,iscreditrelease -- 
            ,lastmodified -- 
            ,oldassetno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bd_extend_detail_op(
            serialno -- 借据编号
            ,migtflag -- 
            ,reselltype -- 01境内转让、02行内转让、03跨境转让
            ,ztrate -- 转贴现利率
            ,benefitcorpbank -- 受益人开户行
            ,nextperiodreturninterestdate -- 下一期还息日期
            ,acceptbankid -- 承兑行行号
            ,billtype -- 票据类型
            ,istran -- 转换
            ,tradeorgid -- 交易机构
            ,logoutdate -- (Del)注销日期
            ,openno -- 开立流水
            ,keyno -- 票据唯一标识
            ,fixterm -- 周期
            ,acceptinttype -- 收息类型
            ,eacmprincipal -- 每期扣款额本金利息
            ,fixflag -- 补登借据标志
            ,surplusphases -- 剩余期数
            ,opendate -- 开立日期
            ,benefitcorpname -- 受益人
            ,insum -- 累计归还本金
            ,reinforcechecker -- 补登复核人
            ,ztacceptbankname -- 直贴行行名
            ,duebalance -- 暂存借据余额
            ,legal -- 诉讼费
            ,datatype -- 批量数据来源（PJ,票据系统供数LC,理财资管系统供数ZJ,资金系统供数ZH,同业综合业务系统供数）
            ,littlecreditbatchno -- 支小再批次包
            ,loantype -- 贷款类型
            ,transdate -- 同业综合业务系统交易日期
            ,littlecreditstatus -- 支小再状态
            ,billno -- 票据号
            ,flag1 -- (new)是否1
            ,compensationsum -- 赔付金额
            ,isinuse -- 添加维护标志1正常2不维护
            ,ztacceptbankid -- 直贴行行号
            ,isteachhealth -- 是否文教健康
            ,benefitcorp -- (Del)受益人
            ,businessdept -- 业务部门
            ,aboutbankid2 -- 受益行行号
            ,advanceflagsum -- 垫款金额
            ,nextperiodreturnprincipaldate -- 下一期还本日期
            ,nextperiodreturninterestsum -- 下一期还息金额
            ,billkind -- 票据种类
            ,ictype -- 计息方式
            ,preinttype -- 预收息标志
            ,interestinsum -- 累计归还利息
            ,littlecreditbatchenddate -- 支小再批次到期日
            ,accountcatagory -- 账户类别(代码:AccountCatagory)
            ,aboutbankname2 -- 受益行行名
            ,logouttype -- 注销类型
            ,premiumrate -- 费率
            ,acceptbankname -- 承兑行行名
            ,littlecreditlapsetime -- 支小再失效时间
            ,deductdate -- 扣款日期
            ,logoutno -- 注销流水
            ,nextperiodreturnprincipalsum -- 下一期还本金额
            ,assetno -- 资产唯一标识
            ,actualbalance -- 原币余额
            ,actualbusinesssum -- 原币金额
            ,actualcurrency -- 原币种
            ,exchangerate -- 汇率
            ,ddno -- 序号（银团贷款）
            ,lender -- 联行号
            ,objid -- 同业业务系统OBJID
            ,naccountvalue -- 面值
            ,naccrualinterest -- 应计利息
            ,nbalance -- 账面价值
            ,ninterestadjust -- 利息调整
            ,npvvariation -- 公允价值变动
            ,interexpnum -- 利息支出费用编号
            ,commexpnum -- 手续费支出费用编号
            ,sellstatus -- 卖出状态
            ,overdrafttime -- 
            ,paymentobject -- 
            ,purpose -- 
            ,ftcommission -- 
            ,agreementid -- 
            ,isreceivebill -- 
            ,iscreditrelease -- 
            ,lastmodified -- 
            ,oldassetno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 借据编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.reselltype, o.reselltype) as reselltype -- 01境内转让、02行内转让、03跨境转让
    ,nvl(n.ztrate, o.ztrate) as ztrate -- 转贴现利率
    ,nvl(n.benefitcorpbank, o.benefitcorpbank) as benefitcorpbank -- 受益人开户行
    ,nvl(n.nextperiodreturninterestdate, o.nextperiodreturninterestdate) as nextperiodreturninterestdate -- 下一期还息日期
    ,nvl(n.acceptbankid, o.acceptbankid) as acceptbankid -- 承兑行行号
    ,nvl(n.billtype, o.billtype) as billtype -- 票据类型
    ,nvl(n.istran, o.istran) as istran -- 转换
    ,nvl(n.tradeorgid, o.tradeorgid) as tradeorgid -- 交易机构
    ,nvl(n.logoutdate, o.logoutdate) as logoutdate -- (Del)注销日期
    ,nvl(n.openno, o.openno) as openno -- 开立流水
    ,nvl(n.keyno, o.keyno) as keyno -- 票据唯一标识
    ,nvl(n.fixterm, o.fixterm) as fixterm -- 周期
    ,nvl(n.acceptinttype, o.acceptinttype) as acceptinttype -- 收息类型
    ,nvl(n.eacmprincipal, o.eacmprincipal) as eacmprincipal -- 每期扣款额本金利息
    ,nvl(n.fixflag, o.fixflag) as fixflag -- 补登借据标志
    ,nvl(n.surplusphases, o.surplusphases) as surplusphases -- 剩余期数
    ,nvl(n.opendate, o.opendate) as opendate -- 开立日期
    ,nvl(n.benefitcorpname, o.benefitcorpname) as benefitcorpname -- 受益人
    ,nvl(n.insum, o.insum) as insum -- 累计归还本金
    ,nvl(n.reinforcechecker, o.reinforcechecker) as reinforcechecker -- 补登复核人
    ,nvl(n.ztacceptbankname, o.ztacceptbankname) as ztacceptbankname -- 直贴行行名
    ,nvl(n.duebalance, o.duebalance) as duebalance -- 暂存借据余额
    ,nvl(n.legal, o.legal) as legal -- 诉讼费
    ,nvl(n.datatype, o.datatype) as datatype -- 批量数据来源（PJ,票据系统供数LC,理财资管系统供数ZJ,资金系统供数ZH,同业综合业务系统供数）
    ,nvl(n.littlecreditbatchno, o.littlecreditbatchno) as littlecreditbatchno -- 支小再批次包
    ,nvl(n.loantype, o.loantype) as loantype -- 贷款类型
    ,nvl(n.transdate, o.transdate) as transdate -- 同业综合业务系统交易日期
    ,nvl(n.littlecreditstatus, o.littlecreditstatus) as littlecreditstatus -- 支小再状态
    ,nvl(n.billno, o.billno) as billno -- 票据号
    ,nvl(n.flag1, o.flag1) as flag1 -- (new)是否1
    ,nvl(n.compensationsum, o.compensationsum) as compensationsum -- 赔付金额
    ,nvl(n.isinuse, o.isinuse) as isinuse -- 添加维护标志1正常2不维护
    ,nvl(n.ztacceptbankid, o.ztacceptbankid) as ztacceptbankid -- 直贴行行号
    ,nvl(n.isteachhealth, o.isteachhealth) as isteachhealth -- 是否文教健康
    ,nvl(n.benefitcorp, o.benefitcorp) as benefitcorp -- (Del)受益人
    ,nvl(n.businessdept, o.businessdept) as businessdept -- 业务部门
    ,nvl(n.aboutbankid2, o.aboutbankid2) as aboutbankid2 -- 受益行行号
    ,nvl(n.advanceflagsum, o.advanceflagsum) as advanceflagsum -- 垫款金额
    ,nvl(n.nextperiodreturnprincipaldate, o.nextperiodreturnprincipaldate) as nextperiodreturnprincipaldate -- 下一期还本日期
    ,nvl(n.nextperiodreturninterestsum, o.nextperiodreturninterestsum) as nextperiodreturninterestsum -- 下一期还息金额
    ,nvl(n.billkind, o.billkind) as billkind -- 票据种类
    ,nvl(n.ictype, o.ictype) as ictype -- 计息方式
    ,nvl(n.preinttype, o.preinttype) as preinttype -- 预收息标志
    ,nvl(n.interestinsum, o.interestinsum) as interestinsum -- 累计归还利息
    ,nvl(n.littlecreditbatchenddate, o.littlecreditbatchenddate) as littlecreditbatchenddate -- 支小再批次到期日
    ,nvl(n.accountcatagory, o.accountcatagory) as accountcatagory -- 账户类别(代码:AccountCatagory)
    ,nvl(n.aboutbankname2, o.aboutbankname2) as aboutbankname2 -- 受益行行名
    ,nvl(n.logouttype, o.logouttype) as logouttype -- 注销类型
    ,nvl(n.premiumrate, o.premiumrate) as premiumrate -- 费率
    ,nvl(n.acceptbankname, o.acceptbankname) as acceptbankname -- 承兑行行名
    ,nvl(n.littlecreditlapsetime, o.littlecreditlapsetime) as littlecreditlapsetime -- 支小再失效时间
    ,nvl(n.deductdate, o.deductdate) as deductdate -- 扣款日期
    ,nvl(n.logoutno, o.logoutno) as logoutno -- 注销流水
    ,nvl(n.nextperiodreturnprincipalsum, o.nextperiodreturnprincipalsum) as nextperiodreturnprincipalsum -- 下一期还本金额
    ,nvl(n.assetno, o.assetno) as assetno -- 资产唯一标识
    ,nvl(n.actualbalance, o.actualbalance) as actualbalance -- 原币余额
    ,nvl(n.actualbusinesssum, o.actualbusinesssum) as actualbusinesssum -- 原币金额
    ,nvl(n.actualcurrency, o.actualcurrency) as actualcurrency -- 原币种
    ,nvl(n.exchangerate, o.exchangerate) as exchangerate -- 汇率
    ,nvl(n.ddno, o.ddno) as ddno -- 序号（银团贷款）
    ,nvl(n.lender, o.lender) as lender -- 联行号
    ,nvl(n.objid, o.objid) as objid -- 同业业务系统OBJID
    ,nvl(n.naccountvalue, o.naccountvalue) as naccountvalue -- 面值
    ,nvl(n.naccrualinterest, o.naccrualinterest) as naccrualinterest -- 应计利息
    ,nvl(n.nbalance, o.nbalance) as nbalance -- 账面价值
    ,nvl(n.ninterestadjust, o.ninterestadjust) as ninterestadjust -- 利息调整
    ,nvl(n.npvvariation, o.npvvariation) as npvvariation -- 公允价值变动
    ,nvl(n.interexpnum, o.interexpnum) as interexpnum -- 利息支出费用编号
    ,nvl(n.commexpnum, o.commexpnum) as commexpnum -- 手续费支出费用编号
    ,nvl(n.sellstatus, o.sellstatus) as sellstatus -- 卖出状态
    ,nvl(n.overdrafttime, o.overdrafttime) as overdrafttime -- 
    ,nvl(n.paymentobject, o.paymentobject) as paymentobject -- 
    ,nvl(n.purpose, o.purpose) as purpose -- 
    ,nvl(n.ftcommission, o.ftcommission) as ftcommission -- 
    ,nvl(n.agreementid, o.agreementid) as agreementid -- 
    ,nvl(n.isreceivebill, o.isreceivebill) as isreceivebill -- 
    ,nvl(n.iscreditrelease, o.iscreditrelease) as iscreditrelease -- 
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 
    ,nvl(n.oldassetno, o.oldassetno) as oldassetno -- 
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_bd_extend_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bd_extend_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.migtflag <> n.migtflag
        or o.reselltype <> n.reselltype
        or o.ztrate <> n.ztrate
        or o.benefitcorpbank <> n.benefitcorpbank
        or o.nextperiodreturninterestdate <> n.nextperiodreturninterestdate
        or o.acceptbankid <> n.acceptbankid
        or o.billtype <> n.billtype
        or o.istran <> n.istran
        or o.tradeorgid <> n.tradeorgid
        or o.logoutdate <> n.logoutdate
        or o.openno <> n.openno
        or o.keyno <> n.keyno
        or o.fixterm <> n.fixterm
        or o.acceptinttype <> n.acceptinttype
        or o.eacmprincipal <> n.eacmprincipal
        or o.fixflag <> n.fixflag
        or o.surplusphases <> n.surplusphases
        or o.opendate <> n.opendate
        or o.benefitcorpname <> n.benefitcorpname
        or o.insum <> n.insum
        or o.reinforcechecker <> n.reinforcechecker
        or o.ztacceptbankname <> n.ztacceptbankname
        or o.duebalance <> n.duebalance
        or o.legal <> n.legal
        or o.datatype <> n.datatype
        or o.littlecreditbatchno <> n.littlecreditbatchno
        or o.loantype <> n.loantype
        or o.transdate <> n.transdate
        or o.littlecreditstatus <> n.littlecreditstatus
        or o.billno <> n.billno
        or o.flag1 <> n.flag1
        or o.compensationsum <> n.compensationsum
        or o.isinuse <> n.isinuse
        or o.ztacceptbankid <> n.ztacceptbankid
        or o.isteachhealth <> n.isteachhealth
        or o.benefitcorp <> n.benefitcorp
        or o.businessdept <> n.businessdept
        or o.aboutbankid2 <> n.aboutbankid2
        or o.advanceflagsum <> n.advanceflagsum
        or o.nextperiodreturnprincipaldate <> n.nextperiodreturnprincipaldate
        or o.nextperiodreturninterestsum <> n.nextperiodreturninterestsum
        or o.billkind <> n.billkind
        or o.ictype <> n.ictype
        or o.preinttype <> n.preinttype
        or o.interestinsum <> n.interestinsum
        or o.littlecreditbatchenddate <> n.littlecreditbatchenddate
        or o.accountcatagory <> n.accountcatagory
        or o.aboutbankname2 <> n.aboutbankname2
        or o.logouttype <> n.logouttype
        or o.premiumrate <> n.premiumrate
        or o.acceptbankname <> n.acceptbankname
        or o.littlecreditlapsetime <> n.littlecreditlapsetime
        or o.deductdate <> n.deductdate
        or o.logoutno <> n.logoutno
        or o.nextperiodreturnprincipalsum <> n.nextperiodreturnprincipalsum
        or o.assetno <> n.assetno
        or o.actualbalance <> n.actualbalance
        or o.actualbusinesssum <> n.actualbusinesssum
        or o.actualcurrency <> n.actualcurrency
        or o.exchangerate <> n.exchangerate
        or o.ddno <> n.ddno
        or o.lender <> n.lender
        or o.objid <> n.objid
        or o.naccountvalue <> n.naccountvalue
        or o.naccrualinterest <> n.naccrualinterest
        or o.nbalance <> n.nbalance
        or o.ninterestadjust <> n.ninterestadjust
        or o.npvvariation <> n.npvvariation
        or o.interexpnum <> n.interexpnum
        or o.commexpnum <> n.commexpnum
        or o.sellstatus <> n.sellstatus
        or o.overdrafttime <> n.overdrafttime
        or o.paymentobject <> n.paymentobject
        or o.purpose <> n.purpose
        or o.ftcommission <> n.ftcommission
        or o.agreementid <> n.agreementid
        or o.isreceivebill <> n.isreceivebill
        or o.iscreditrelease <> n.iscreditrelease
        or o.lastmodified <> n.lastmodified
        or o.oldassetno <> n.oldassetno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bd_extend_detail_cl(
            serialno -- 借据编号
            ,migtflag -- 
            ,reselltype -- 01境内转让、02行内转让、03跨境转让
            ,ztrate -- 转贴现利率
            ,benefitcorpbank -- 受益人开户行
            ,nextperiodreturninterestdate -- 下一期还息日期
            ,acceptbankid -- 承兑行行号
            ,billtype -- 票据类型
            ,istran -- 转换
            ,tradeorgid -- 交易机构
            ,logoutdate -- (Del)注销日期
            ,openno -- 开立流水
            ,keyno -- 票据唯一标识
            ,fixterm -- 周期
            ,acceptinttype -- 收息类型
            ,eacmprincipal -- 每期扣款额本金利息
            ,fixflag -- 补登借据标志
            ,surplusphases -- 剩余期数
            ,opendate -- 开立日期
            ,benefitcorpname -- 受益人
            ,insum -- 累计归还本金
            ,reinforcechecker -- 补登复核人
            ,ztacceptbankname -- 直贴行行名
            ,duebalance -- 暂存借据余额
            ,legal -- 诉讼费
            ,datatype -- 批量数据来源（PJ,票据系统供数LC,理财资管系统供数ZJ,资金系统供数ZH,同业综合业务系统供数）
            ,littlecreditbatchno -- 支小再批次包
            ,loantype -- 贷款类型
            ,transdate -- 同业综合业务系统交易日期
            ,littlecreditstatus -- 支小再状态
            ,billno -- 票据号
            ,flag1 -- (new)是否1
            ,compensationsum -- 赔付金额
            ,isinuse -- 添加维护标志1正常2不维护
            ,ztacceptbankid -- 直贴行行号
            ,isteachhealth -- 是否文教健康
            ,benefitcorp -- (Del)受益人
            ,businessdept -- 业务部门
            ,aboutbankid2 -- 受益行行号
            ,advanceflagsum -- 垫款金额
            ,nextperiodreturnprincipaldate -- 下一期还本日期
            ,nextperiodreturninterestsum -- 下一期还息金额
            ,billkind -- 票据种类
            ,ictype -- 计息方式
            ,preinttype -- 预收息标志
            ,interestinsum -- 累计归还利息
            ,littlecreditbatchenddate -- 支小再批次到期日
            ,accountcatagory -- 账户类别(代码:AccountCatagory)
            ,aboutbankname2 -- 受益行行名
            ,logouttype -- 注销类型
            ,premiumrate -- 费率
            ,acceptbankname -- 承兑行行名
            ,littlecreditlapsetime -- 支小再失效时间
            ,deductdate -- 扣款日期
            ,logoutno -- 注销流水
            ,nextperiodreturnprincipalsum -- 下一期还本金额
            ,assetno -- 资产唯一标识
            ,actualbalance -- 原币余额
            ,actualbusinesssum -- 原币金额
            ,actualcurrency -- 原币种
            ,exchangerate -- 汇率
            ,ddno -- 序号（银团贷款）
            ,lender -- 联行号
            ,objid -- 同业业务系统OBJID
            ,naccountvalue -- 面值
            ,naccrualinterest -- 应计利息
            ,nbalance -- 账面价值
            ,ninterestadjust -- 利息调整
            ,npvvariation -- 公允价值变动
            ,interexpnum -- 利息支出费用编号
            ,commexpnum -- 手续费支出费用编号
            ,sellstatus -- 卖出状态
            ,overdrafttime -- 
            ,paymentobject -- 
            ,purpose -- 
            ,ftcommission -- 
            ,agreementid -- 
            ,isreceivebill -- 
            ,iscreditrelease -- 
            ,lastmodified -- 
            ,oldassetno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bd_extend_detail_op(
            serialno -- 借据编号
            ,migtflag -- 
            ,reselltype -- 01境内转让、02行内转让、03跨境转让
            ,ztrate -- 转贴现利率
            ,benefitcorpbank -- 受益人开户行
            ,nextperiodreturninterestdate -- 下一期还息日期
            ,acceptbankid -- 承兑行行号
            ,billtype -- 票据类型
            ,istran -- 转换
            ,tradeorgid -- 交易机构
            ,logoutdate -- (Del)注销日期
            ,openno -- 开立流水
            ,keyno -- 票据唯一标识
            ,fixterm -- 周期
            ,acceptinttype -- 收息类型
            ,eacmprincipal -- 每期扣款额本金利息
            ,fixflag -- 补登借据标志
            ,surplusphases -- 剩余期数
            ,opendate -- 开立日期
            ,benefitcorpname -- 受益人
            ,insum -- 累计归还本金
            ,reinforcechecker -- 补登复核人
            ,ztacceptbankname -- 直贴行行名
            ,duebalance -- 暂存借据余额
            ,legal -- 诉讼费
            ,datatype -- 批量数据来源（PJ,票据系统供数LC,理财资管系统供数ZJ,资金系统供数ZH,同业综合业务系统供数）
            ,littlecreditbatchno -- 支小再批次包
            ,loantype -- 贷款类型
            ,transdate -- 同业综合业务系统交易日期
            ,littlecreditstatus -- 支小再状态
            ,billno -- 票据号
            ,flag1 -- (new)是否1
            ,compensationsum -- 赔付金额
            ,isinuse -- 添加维护标志1正常2不维护
            ,ztacceptbankid -- 直贴行行号
            ,isteachhealth -- 是否文教健康
            ,benefitcorp -- (Del)受益人
            ,businessdept -- 业务部门
            ,aboutbankid2 -- 受益行行号
            ,advanceflagsum -- 垫款金额
            ,nextperiodreturnprincipaldate -- 下一期还本日期
            ,nextperiodreturninterestsum -- 下一期还息金额
            ,billkind -- 票据种类
            ,ictype -- 计息方式
            ,preinttype -- 预收息标志
            ,interestinsum -- 累计归还利息
            ,littlecreditbatchenddate -- 支小再批次到期日
            ,accountcatagory -- 账户类别(代码:AccountCatagory)
            ,aboutbankname2 -- 受益行行名
            ,logouttype -- 注销类型
            ,premiumrate -- 费率
            ,acceptbankname -- 承兑行行名
            ,littlecreditlapsetime -- 支小再失效时间
            ,deductdate -- 扣款日期
            ,logoutno -- 注销流水
            ,nextperiodreturnprincipalsum -- 下一期还本金额
            ,assetno -- 资产唯一标识
            ,actualbalance -- 原币余额
            ,actualbusinesssum -- 原币金额
            ,actualcurrency -- 原币种
            ,exchangerate -- 汇率
            ,ddno -- 序号（银团贷款）
            ,lender -- 联行号
            ,objid -- 同业业务系统OBJID
            ,naccountvalue -- 面值
            ,naccrualinterest -- 应计利息
            ,nbalance -- 账面价值
            ,ninterestadjust -- 利息调整
            ,npvvariation -- 公允价值变动
            ,interexpnum -- 利息支出费用编号
            ,commexpnum -- 手续费支出费用编号
            ,sellstatus -- 卖出状态
            ,overdrafttime -- 
            ,paymentobject -- 
            ,purpose -- 
            ,ftcommission -- 
            ,agreementid -- 
            ,isreceivebill -- 
            ,iscreditrelease -- 
            ,lastmodified -- 
            ,oldassetno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 借据编号
    ,o.migtflag -- 
    ,o.reselltype -- 01境内转让、02行内转让、03跨境转让
    ,o.ztrate -- 转贴现利率
    ,o.benefitcorpbank -- 受益人开户行
    ,o.nextperiodreturninterestdate -- 下一期还息日期
    ,o.acceptbankid -- 承兑行行号
    ,o.billtype -- 票据类型
    ,o.istran -- 转换
    ,o.tradeorgid -- 交易机构
    ,o.logoutdate -- (Del)注销日期
    ,o.openno -- 开立流水
    ,o.keyno -- 票据唯一标识
    ,o.fixterm -- 周期
    ,o.acceptinttype -- 收息类型
    ,o.eacmprincipal -- 每期扣款额本金利息
    ,o.fixflag -- 补登借据标志
    ,o.surplusphases -- 剩余期数
    ,o.opendate -- 开立日期
    ,o.benefitcorpname -- 受益人
    ,o.insum -- 累计归还本金
    ,o.reinforcechecker -- 补登复核人
    ,o.ztacceptbankname -- 直贴行行名
    ,o.duebalance -- 暂存借据余额
    ,o.legal -- 诉讼费
    ,o.datatype -- 批量数据来源（PJ,票据系统供数LC,理财资管系统供数ZJ,资金系统供数ZH,同业综合业务系统供数）
    ,o.littlecreditbatchno -- 支小再批次包
    ,o.loantype -- 贷款类型
    ,o.transdate -- 同业综合业务系统交易日期
    ,o.littlecreditstatus -- 支小再状态
    ,o.billno -- 票据号
    ,o.flag1 -- (new)是否1
    ,o.compensationsum -- 赔付金额
    ,o.isinuse -- 添加维护标志1正常2不维护
    ,o.ztacceptbankid -- 直贴行行号
    ,o.isteachhealth -- 是否文教健康
    ,o.benefitcorp -- (Del)受益人
    ,o.businessdept -- 业务部门
    ,o.aboutbankid2 -- 受益行行号
    ,o.advanceflagsum -- 垫款金额
    ,o.nextperiodreturnprincipaldate -- 下一期还本日期
    ,o.nextperiodreturninterestsum -- 下一期还息金额
    ,o.billkind -- 票据种类
    ,o.ictype -- 计息方式
    ,o.preinttype -- 预收息标志
    ,o.interestinsum -- 累计归还利息
    ,o.littlecreditbatchenddate -- 支小再批次到期日
    ,o.accountcatagory -- 账户类别(代码:AccountCatagory)
    ,o.aboutbankname2 -- 受益行行名
    ,o.logouttype -- 注销类型
    ,o.premiumrate -- 费率
    ,o.acceptbankname -- 承兑行行名
    ,o.littlecreditlapsetime -- 支小再失效时间
    ,o.deductdate -- 扣款日期
    ,o.logoutno -- 注销流水
    ,o.nextperiodreturnprincipalsum -- 下一期还本金额
    ,o.assetno -- 资产唯一标识
    ,o.actualbalance -- 原币余额
    ,o.actualbusinesssum -- 原币金额
    ,o.actualcurrency -- 原币种
    ,o.exchangerate -- 汇率
    ,o.ddno -- 序号（银团贷款）
    ,o.lender -- 联行号
    ,o.objid -- 同业业务系统OBJID
    ,o.naccountvalue -- 面值
    ,o.naccrualinterest -- 应计利息
    ,o.nbalance -- 账面价值
    ,o.ninterestadjust -- 利息调整
    ,o.npvvariation -- 公允价值变动
    ,o.interexpnum -- 利息支出费用编号
    ,o.commexpnum -- 手续费支出费用编号
    ,o.sellstatus -- 卖出状态
    ,o.overdrafttime -- 
    ,o.paymentobject -- 
    ,o.purpose -- 
    ,o.ftcommission -- 
    ,o.agreementid -- 
    ,o.isreceivebill -- 
    ,o.iscreditrelease -- 
    ,o.lastmodified -- 
    ,o.oldassetno -- 
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
from ${iol_schema}.icms_bd_extend_detail_bk o
    left join ${iol_schema}.icms_bd_extend_detail_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bd_extend_detail_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_bd_extend_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bd_extend_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bd_extend_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bd_extend_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bd_extend_detail exchange partition p_${batch_date} with table ${iol_schema}.icms_bd_extend_detail_cl;
alter table ${iol_schema}.icms_bd_extend_detail exchange partition p_20991231 with table ${iol_schema}.icms_bd_extend_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bd_extend_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bd_extend_detail_op purge;
drop table ${iol_schema}.icms_bd_extend_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bd_extend_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bd_extend_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
