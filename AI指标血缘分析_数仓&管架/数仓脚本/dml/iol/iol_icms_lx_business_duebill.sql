/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lx_business_duebill
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
create table ${iol_schema}.icms_lx_business_duebill_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lx_business_duebill
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lx_business_duebill_op purge;
drop table ${iol_schema}.icms_lx_business_duebill_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_business_duebill_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_business_duebill where 0=1;

create table ${iol_schema}.icms_lx_business_duebill_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_business_duebill where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lx_business_duebill_cl(
            capitalloanno -- 借据号
            ,putoutserialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,status -- 状态
            ,termmonth -- 期限
            ,ratemodel -- 利率模式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,executerate -- 执行利率
            ,overduerate -- 逾期利率
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,classifyresult -- 贷款五级分类
            ,applydate -- 申请日期
            ,startdate -- 开始日期
            ,enddate -- 到期日期
            ,overduedate -- 逾期日期
            ,cleardate -- 结清日期
            ,encashamt -- 借据金额
            ,currency -- 币种
            ,repaymode -- 还款方式
            ,repaycycle -- 还款周期
            ,totalterms -- 总期数
            ,curterm -- 当前期数
            ,repayday -- 还款日
            ,graceday -- 宽限期
            ,loanstatus -- 贷款状态
            ,loanform -- 贷款形态
            ,printotal -- 应还本金
            ,prinrepay -- 已还本金
            ,prinbal -- 正常本金余额
            ,ovdprinbal -- 逾期本金余额
            ,intplan -- 计划利息
            ,inttotal -- 应还利息
            ,intrepay -- 已还利息
            ,intdiscount -- 减免利息
            ,intbal -- 利息余额
            ,ovdintbal -- 逾期利息余额
            ,pnltinttotal -- 应收罚息
            ,pnltintrepay -- 已还罚息
            ,pnltintdiscount -- 减免罚息
            ,pnltintbal -- 罚息余额
            ,prepmtfeerepay -- 已还提前还款手续费
            ,outloanchannelno -- 平台订单号
            ,daysovd -- 逾期天数
            ,interesttransferstatus -- 非应计状态
            ,loanresponsetime -- 支付返回成功时间
            ,writeoffstatus -- 核销状态
            ,writeofftime -- 核销时间
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,startterm -- 开始期序
            ,endterm -- 结束期序
            ,intrate -- 正常利率
            ,intrateunit -- 正常利率类型
            ,ovdrate -- 罚息利率
            ,ovdrateunit -- 罚息利率类型
            ,prepmtfeerate -- 提前还款手续费率
            ,remart -- 计量标记-资产三分类
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,vouchtype -- 担保方式
            ,repaynum -- 还款账户
            ,repaynumtype -- 还款账户类型
            ,paymentnum -- 入账账户
            ,paymentnumtype -- 入账账户类型
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,putoutorgid -- 账务机构
            ,manageorgid -- 管理机构
            ,productid -- 产品编号
            ,loanpurpose -- 投向行业
            ,interesttype -- 计息方式
            ,bankproportion -- 银行出资比例
            ,fivecateadjdate -- 五级分类认定日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lx_business_duebill_op(
            capitalloanno -- 借据号
            ,putoutserialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,status -- 状态
            ,termmonth -- 期限
            ,ratemodel -- 利率模式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,executerate -- 执行利率
            ,overduerate -- 逾期利率
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,classifyresult -- 贷款五级分类
            ,applydate -- 申请日期
            ,startdate -- 开始日期
            ,enddate -- 到期日期
            ,overduedate -- 逾期日期
            ,cleardate -- 结清日期
            ,encashamt -- 借据金额
            ,currency -- 币种
            ,repaymode -- 还款方式
            ,repaycycle -- 还款周期
            ,totalterms -- 总期数
            ,curterm -- 当前期数
            ,repayday -- 还款日
            ,graceday -- 宽限期
            ,loanstatus -- 贷款状态
            ,loanform -- 贷款形态
            ,printotal -- 应还本金
            ,prinrepay -- 已还本金
            ,prinbal -- 正常本金余额
            ,ovdprinbal -- 逾期本金余额
            ,intplan -- 计划利息
            ,inttotal -- 应还利息
            ,intrepay -- 已还利息
            ,intdiscount -- 减免利息
            ,intbal -- 利息余额
            ,ovdintbal -- 逾期利息余额
            ,pnltinttotal -- 应收罚息
            ,pnltintrepay -- 已还罚息
            ,pnltintdiscount -- 减免罚息
            ,pnltintbal -- 罚息余额
            ,prepmtfeerepay -- 已还提前还款手续费
            ,outloanchannelno -- 平台订单号
            ,daysovd -- 逾期天数
            ,interesttransferstatus -- 非应计状态
            ,loanresponsetime -- 支付返回成功时间
            ,writeoffstatus -- 核销状态
            ,writeofftime -- 核销时间
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,startterm -- 开始期序
            ,endterm -- 结束期序
            ,intrate -- 正常利率
            ,intrateunit -- 正常利率类型
            ,ovdrate -- 罚息利率
            ,ovdrateunit -- 罚息利率类型
            ,prepmtfeerate -- 提前还款手续费率
            ,remart -- 计量标记-资产三分类
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,vouchtype -- 担保方式
            ,repaynum -- 还款账户
            ,repaynumtype -- 还款账户类型
            ,paymentnum -- 入账账户
            ,paymentnumtype -- 入账账户类型
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,putoutorgid -- 账务机构
            ,manageorgid -- 管理机构
            ,productid -- 产品编号
            ,loanpurpose -- 投向行业
            ,interesttype -- 计息方式
            ,bankproportion -- 银行出资比例
            ,fivecateadjdate -- 五级分类认定日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.capitalloanno, o.capitalloanno) as capitalloanno -- 借据号
    ,nvl(n.putoutserialno, o.putoutserialno) as putoutserialno -- 出账流水号
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 合同流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限
    ,nvl(n.ratemodel, o.ratemodel) as ratemodel -- 利率模式
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.ratefloattype, o.ratefloattype) as ratefloattype -- 利率浮动方式
    ,nvl(n.executerate, o.executerate) as executerate -- 执行利率
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期利率
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 利率调整方式
    ,nvl(n.rateadjustfrequency, o.rateadjustfrequency) as rateadjustfrequency -- 利率调整周期
    ,nvl(n.floatrange, o.floatrange) as floatrange -- 浮动幅度
    ,nvl(n.overdueratefloattype, o.overdueratefloattype) as overdueratefloattype -- 逾期利率浮动方式
    ,nvl(n.overdueratefloatvalue, o.overdueratefloatvalue) as overdueratefloatvalue -- 逾期利率浮动值
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 贷款五级分类
    ,nvl(n.applydate, o.applydate) as applydate -- 申请日期
    ,nvl(n.startdate, o.startdate) as startdate -- 开始日期
    ,nvl(n.enddate, o.enddate) as enddate -- 到期日期
    ,nvl(n.overduedate, o.overduedate) as overduedate -- 逾期日期
    ,nvl(n.cleardate, o.cleardate) as cleardate -- 结清日期
    ,nvl(n.encashamt, o.encashamt) as encashamt -- 借据金额
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.repaymode, o.repaymode) as repaymode -- 还款方式
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 还款周期
    ,nvl(n.totalterms, o.totalterms) as totalterms -- 总期数
    ,nvl(n.curterm, o.curterm) as curterm -- 当前期数
    ,nvl(n.repayday, o.repayday) as repayday -- 还款日
    ,nvl(n.graceday, o.graceday) as graceday -- 宽限期
    ,nvl(n.loanstatus, o.loanstatus) as loanstatus -- 贷款状态
    ,nvl(n.loanform, o.loanform) as loanform -- 贷款形态
    ,nvl(n.printotal, o.printotal) as printotal -- 应还本金
    ,nvl(n.prinrepay, o.prinrepay) as prinrepay -- 已还本金
    ,nvl(n.prinbal, o.prinbal) as prinbal -- 正常本金余额
    ,nvl(n.ovdprinbal, o.ovdprinbal) as ovdprinbal -- 逾期本金余额
    ,nvl(n.intplan, o.intplan) as intplan -- 计划利息
    ,nvl(n.inttotal, o.inttotal) as inttotal -- 应还利息
    ,nvl(n.intrepay, o.intrepay) as intrepay -- 已还利息
    ,nvl(n.intdiscount, o.intdiscount) as intdiscount -- 减免利息
    ,nvl(n.intbal, o.intbal) as intbal -- 利息余额
    ,nvl(n.ovdintbal, o.ovdintbal) as ovdintbal -- 逾期利息余额
    ,nvl(n.pnltinttotal, o.pnltinttotal) as pnltinttotal -- 应收罚息
    ,nvl(n.pnltintrepay, o.pnltintrepay) as pnltintrepay -- 已还罚息
    ,nvl(n.pnltintdiscount, o.pnltintdiscount) as pnltintdiscount -- 减免罚息
    ,nvl(n.pnltintbal, o.pnltintbal) as pnltintbal -- 罚息余额
    ,nvl(n.prepmtfeerepay, o.prepmtfeerepay) as prepmtfeerepay -- 已还提前还款手续费
    ,nvl(n.outloanchannelno, o.outloanchannelno) as outloanchannelno -- 平台订单号
    ,nvl(n.daysovd, o.daysovd) as daysovd -- 逾期天数
    ,nvl(n.interesttransferstatus, o.interesttransferstatus) as interesttransferstatus -- 非应计状态
    ,nvl(n.loanresponsetime, o.loanresponsetime) as loanresponsetime -- 支付返回成功时间
    ,nvl(n.writeoffstatus, o.writeoffstatus) as writeoffstatus -- 核销状态
    ,nvl(n.writeofftime, o.writeofftime) as writeofftime -- 核销时间
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.startterm, o.startterm) as startterm -- 开始期序
    ,nvl(n.endterm, o.endterm) as endterm -- 结束期序
    ,nvl(n.intrate, o.intrate) as intrate -- 正常利率
    ,nvl(n.intrateunit, o.intrateunit) as intrateunit -- 正常利率类型
    ,nvl(n.ovdrate, o.ovdrate) as ovdrate -- 罚息利率
    ,nvl(n.ovdrateunit, o.ovdrateunit) as ovdrateunit -- 罚息利率类型
    ,nvl(n.prepmtfeerate, o.prepmtfeerate) as prepmtfeerate -- 提前还款手续费率
    ,nvl(n.remart, o.remart) as remart -- 计量标记-资产三分类
    ,nvl(n.dailyint, o.dailyint) as dailyint -- 当日计提利息
    ,nvl(n.dailypnltint, o.dailypnltint) as dailypnltint -- 当日计提罚息
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 担保方式
    ,nvl(n.repaynum, o.repaynum) as repaynum -- 还款账户
    ,nvl(n.repaynumtype, o.repaynumtype) as repaynumtype -- 还款账户类型
    ,nvl(n.paymentnum, o.paymentnum) as paymentnum -- 入账账户
    ,nvl(n.paymentnumtype, o.paymentnumtype) as paymentnumtype -- 入账账户类型
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办人
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 账务机构
    ,nvl(n.manageorgid, o.manageorgid) as manageorgid -- 管理机构
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.loanpurpose, o.loanpurpose) as loanpurpose -- 投向行业
    ,nvl(n.interesttype, o.interesttype) as interesttype -- 计息方式
    ,nvl(n.bankproportion, o.bankproportion) as bankproportion -- 银行出资比例
    ,nvl(n.fivecateadjdate, o.fivecateadjdate) as fivecateadjdate -- 五级分类认定日期
    ,case when
            n.capitalloanno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.capitalloanno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.capitalloanno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_lx_business_duebill_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lx_business_duebill where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.capitalloanno = n.capitalloanno
where (
        o.capitalloanno is null
    )
    or (
        n.capitalloanno is null
    )
    or (
        o.putoutserialno <> n.putoutserialno
        or o.contractserialno <> n.contractserialno
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.status <> n.status
        or o.termmonth <> n.termmonth
        or o.ratemodel <> n.ratemodel
        or o.baseratetype <> n.baseratetype
        or o.baserate <> n.baserate
        or o.ratefloattype <> n.ratefloattype
        or o.executerate <> n.executerate
        or o.overduerate <> n.overduerate
        or o.rateadjusttype <> n.rateadjusttype
        or o.rateadjustfrequency <> n.rateadjustfrequency
        or o.floatrange <> n.floatrange
        or o.overdueratefloattype <> n.overdueratefloattype
        or o.overdueratefloatvalue <> n.overdueratefloatvalue
        or o.classifyresult <> n.classifyresult
        or o.applydate <> n.applydate
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.overduedate <> n.overduedate
        or o.cleardate <> n.cleardate
        or o.encashamt <> n.encashamt
        or o.currency <> n.currency
        or o.repaymode <> n.repaymode
        or o.repaycycle <> n.repaycycle
        or o.totalterms <> n.totalterms
        or o.curterm <> n.curterm
        or o.repayday <> n.repayday
        or o.graceday <> n.graceday
        or o.loanstatus <> n.loanstatus
        or o.loanform <> n.loanform
        or o.printotal <> n.printotal
        or o.prinrepay <> n.prinrepay
        or o.prinbal <> n.prinbal
        or o.ovdprinbal <> n.ovdprinbal
        or o.intplan <> n.intplan
        or o.inttotal <> n.inttotal
        or o.intrepay <> n.intrepay
        or o.intdiscount <> n.intdiscount
        or o.intbal <> n.intbal
        or o.ovdintbal <> n.ovdintbal
        or o.pnltinttotal <> n.pnltinttotal
        or o.pnltintrepay <> n.pnltintrepay
        or o.pnltintdiscount <> n.pnltintdiscount
        or o.pnltintbal <> n.pnltintbal
        or o.prepmtfeerepay <> n.prepmtfeerepay
        or o.outloanchannelno <> n.outloanchannelno
        or o.daysovd <> n.daysovd
        or o.interesttransferstatus <> n.interesttransferstatus
        or o.loanresponsetime <> n.loanresponsetime
        or o.writeoffstatus <> n.writeoffstatus
        or o.writeofftime <> n.writeofftime
        or o.inputdate <> n.inputdate
        or o.updatedate <> n.updatedate
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.startterm <> n.startterm
        or o.endterm <> n.endterm
        or o.intrate <> n.intrate
        or o.intrateunit <> n.intrateunit
        or o.ovdrate <> n.ovdrate
        or o.ovdrateunit <> n.ovdrateunit
        or o.prepmtfeerate <> n.prepmtfeerate
        or o.remart <> n.remart
        or o.dailyint <> n.dailyint
        or o.dailypnltint <> n.dailypnltint
        or o.vouchtype <> n.vouchtype
        or o.repaynum <> n.repaynum
        or o.repaynumtype <> n.repaynumtype
        or o.paymentnum <> n.paymentnum
        or o.paymentnumtype <> n.paymentnumtype
        or o.operateuserid <> n.operateuserid
        or o.operateorgid <> n.operateorgid
        or o.putoutorgid <> n.putoutorgid
        or o.manageorgid <> n.manageorgid
        or o.productid <> n.productid
        or o.loanpurpose <> n.loanpurpose
        or o.interesttype <> n.interesttype
        or o.bankproportion <> n.bankproportion
        or o.fivecateadjdate <> n.fivecateadjdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lx_business_duebill_cl(
            capitalloanno -- 借据号
            ,putoutserialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,status -- 状态
            ,termmonth -- 期限
            ,ratemodel -- 利率模式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,executerate -- 执行利率
            ,overduerate -- 逾期利率
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,classifyresult -- 贷款五级分类
            ,applydate -- 申请日期
            ,startdate -- 开始日期
            ,enddate -- 到期日期
            ,overduedate -- 逾期日期
            ,cleardate -- 结清日期
            ,encashamt -- 借据金额
            ,currency -- 币种
            ,repaymode -- 还款方式
            ,repaycycle -- 还款周期
            ,totalterms -- 总期数
            ,curterm -- 当前期数
            ,repayday -- 还款日
            ,graceday -- 宽限期
            ,loanstatus -- 贷款状态
            ,loanform -- 贷款形态
            ,printotal -- 应还本金
            ,prinrepay -- 已还本金
            ,prinbal -- 正常本金余额
            ,ovdprinbal -- 逾期本金余额
            ,intplan -- 计划利息
            ,inttotal -- 应还利息
            ,intrepay -- 已还利息
            ,intdiscount -- 减免利息
            ,intbal -- 利息余额
            ,ovdintbal -- 逾期利息余额
            ,pnltinttotal -- 应收罚息
            ,pnltintrepay -- 已还罚息
            ,pnltintdiscount -- 减免罚息
            ,pnltintbal -- 罚息余额
            ,prepmtfeerepay -- 已还提前还款手续费
            ,outloanchannelno -- 平台订单号
            ,daysovd -- 逾期天数
            ,interesttransferstatus -- 非应计状态
            ,loanresponsetime -- 支付返回成功时间
            ,writeoffstatus -- 核销状态
            ,writeofftime -- 核销时间
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,startterm -- 开始期序
            ,endterm -- 结束期序
            ,intrate -- 正常利率
            ,intrateunit -- 正常利率类型
            ,ovdrate -- 罚息利率
            ,ovdrateunit -- 罚息利率类型
            ,prepmtfeerate -- 提前还款手续费率
            ,remart -- 计量标记-资产三分类
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,vouchtype -- 担保方式
            ,repaynum -- 还款账户
            ,repaynumtype -- 还款账户类型
            ,paymentnum -- 入账账户
            ,paymentnumtype -- 入账账户类型
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,putoutorgid -- 账务机构
            ,manageorgid -- 管理机构
            ,productid -- 产品编号
            ,loanpurpose -- 投向行业
            ,interesttype -- 计息方式
            ,bankproportion -- 银行出资比例
            ,fivecateadjdate -- 五级分类认定日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lx_business_duebill_op(
            capitalloanno -- 借据号
            ,putoutserialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,status -- 状态
            ,termmonth -- 期限
            ,ratemodel -- 利率模式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,executerate -- 执行利率
            ,overduerate -- 逾期利率
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,classifyresult -- 贷款五级分类
            ,applydate -- 申请日期
            ,startdate -- 开始日期
            ,enddate -- 到期日期
            ,overduedate -- 逾期日期
            ,cleardate -- 结清日期
            ,encashamt -- 借据金额
            ,currency -- 币种
            ,repaymode -- 还款方式
            ,repaycycle -- 还款周期
            ,totalterms -- 总期数
            ,curterm -- 当前期数
            ,repayday -- 还款日
            ,graceday -- 宽限期
            ,loanstatus -- 贷款状态
            ,loanform -- 贷款形态
            ,printotal -- 应还本金
            ,prinrepay -- 已还本金
            ,prinbal -- 正常本金余额
            ,ovdprinbal -- 逾期本金余额
            ,intplan -- 计划利息
            ,inttotal -- 应还利息
            ,intrepay -- 已还利息
            ,intdiscount -- 减免利息
            ,intbal -- 利息余额
            ,ovdintbal -- 逾期利息余额
            ,pnltinttotal -- 应收罚息
            ,pnltintrepay -- 已还罚息
            ,pnltintdiscount -- 减免罚息
            ,pnltintbal -- 罚息余额
            ,prepmtfeerepay -- 已还提前还款手续费
            ,outloanchannelno -- 平台订单号
            ,daysovd -- 逾期天数
            ,interesttransferstatus -- 非应计状态
            ,loanresponsetime -- 支付返回成功时间
            ,writeoffstatus -- 核销状态
            ,writeofftime -- 核销时间
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,startterm -- 开始期序
            ,endterm -- 结束期序
            ,intrate -- 正常利率
            ,intrateunit -- 正常利率类型
            ,ovdrate -- 罚息利率
            ,ovdrateunit -- 罚息利率类型
            ,prepmtfeerate -- 提前还款手续费率
            ,remart -- 计量标记-资产三分类
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,vouchtype -- 担保方式
            ,repaynum -- 还款账户
            ,repaynumtype -- 还款账户类型
            ,paymentnum -- 入账账户
            ,paymentnumtype -- 入账账户类型
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,putoutorgid -- 账务机构
            ,manageorgid -- 管理机构
            ,productid -- 产品编号
            ,loanpurpose -- 投向行业
            ,interesttype -- 计息方式
            ,bankproportion -- 银行出资比例
            ,fivecateadjdate -- 五级分类认定日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.capitalloanno -- 借据号
    ,o.putoutserialno -- 出账流水号
    ,o.contractserialno -- 合同流水号
    ,o.customerid -- 客户号
    ,o.customername -- 客户名称
    ,o.status -- 状态
    ,o.termmonth -- 期限
    ,o.ratemodel -- 利率模式
    ,o.baseratetype -- 基准利率类型
    ,o.baserate -- 基准利率
    ,o.ratefloattype -- 利率浮动方式
    ,o.executerate -- 执行利率
    ,o.overduerate -- 逾期利率
    ,o.rateadjusttype -- 利率调整方式
    ,o.rateadjustfrequency -- 利率调整周期
    ,o.floatrange -- 浮动幅度
    ,o.overdueratefloattype -- 逾期利率浮动方式
    ,o.overdueratefloatvalue -- 逾期利率浮动值
    ,o.classifyresult -- 贷款五级分类
    ,o.applydate -- 申请日期
    ,o.startdate -- 开始日期
    ,o.enddate -- 到期日期
    ,o.overduedate -- 逾期日期
    ,o.cleardate -- 结清日期
    ,o.encashamt -- 借据金额
    ,o.currency -- 币种
    ,o.repaymode -- 还款方式
    ,o.repaycycle -- 还款周期
    ,o.totalterms -- 总期数
    ,o.curterm -- 当前期数
    ,o.repayday -- 还款日
    ,o.graceday -- 宽限期
    ,o.loanstatus -- 贷款状态
    ,o.loanform -- 贷款形态
    ,o.printotal -- 应还本金
    ,o.prinrepay -- 已还本金
    ,o.prinbal -- 正常本金余额
    ,o.ovdprinbal -- 逾期本金余额
    ,o.intplan -- 计划利息
    ,o.inttotal -- 应还利息
    ,o.intrepay -- 已还利息
    ,o.intdiscount -- 减免利息
    ,o.intbal -- 利息余额
    ,o.ovdintbal -- 逾期利息余额
    ,o.pnltinttotal -- 应收罚息
    ,o.pnltintrepay -- 已还罚息
    ,o.pnltintdiscount -- 减免罚息
    ,o.pnltintbal -- 罚息余额
    ,o.prepmtfeerepay -- 已还提前还款手续费
    ,o.outloanchannelno -- 平台订单号
    ,o.daysovd -- 逾期天数
    ,o.interesttransferstatus -- 非应计状态
    ,o.loanresponsetime -- 支付返回成功时间
    ,o.writeoffstatus -- 核销状态
    ,o.writeofftime -- 核销时间
    ,o.inputdate -- 登记日期
    ,o.updatedate -- 更新日期
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.startterm -- 开始期序
    ,o.endterm -- 结束期序
    ,o.intrate -- 正常利率
    ,o.intrateunit -- 正常利率类型
    ,o.ovdrate -- 罚息利率
    ,o.ovdrateunit -- 罚息利率类型
    ,o.prepmtfeerate -- 提前还款手续费率
    ,o.remart -- 计量标记-资产三分类
    ,o.dailyint -- 当日计提利息
    ,o.dailypnltint -- 当日计提罚息
    ,o.vouchtype -- 担保方式
    ,o.repaynum -- 还款账户
    ,o.repaynumtype -- 还款账户类型
    ,o.paymentnum -- 入账账户
    ,o.paymentnumtype -- 入账账户类型
    ,o.operateuserid -- 经办人
    ,o.operateorgid -- 经办机构
    ,o.putoutorgid -- 账务机构
    ,o.manageorgid -- 管理机构
    ,o.productid -- 产品编号
    ,o.loanpurpose -- 投向行业
    ,o.interesttype -- 计息方式
    ,o.bankproportion -- 银行出资比例
    ,o.fivecateadjdate -- 五级分类认定日期
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
from ${iol_schema}.icms_lx_business_duebill_bk o
    left join ${iol_schema}.icms_lx_business_duebill_op n
        on
            o.capitalloanno = n.capitalloanno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lx_business_duebill_cl d
        on
            o.capitalloanno = d.capitalloanno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_lx_business_duebill;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lx_business_duebill') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lx_business_duebill drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lx_business_duebill add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lx_business_duebill exchange partition p_${batch_date} with table ${iol_schema}.icms_lx_business_duebill_cl;
alter table ${iol_schema}.icms_lx_business_duebill exchange partition p_20991231 with table ${iol_schema}.icms_lx_business_duebill_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lx_business_duebill to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lx_business_duebill_op purge;
drop table ${iol_schema}.icms_lx_business_duebill_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lx_business_duebill_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lx_business_duebill',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
