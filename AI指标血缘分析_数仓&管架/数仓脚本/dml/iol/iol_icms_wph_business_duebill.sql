/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wph_business_duebill
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
create table ${iol_schema}.icms_wph_business_duebill_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wph_business_duebill
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_business_duebill_op purge;
drop table ${iol_schema}.icms_wph_business_duebill_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_business_duebill_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_business_duebill where 0=1;

create table ${iol_schema}.icms_wph_business_duebill_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_business_duebill where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_business_duebill_cl(
            serialno -- 借据编号
            ,putoutserialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,baseratetype -- 基准利率类型
            ,repayday -- 还款日
            ,baserate -- 基准利率
            ,overduerate -- 逾期利率
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,classifyresult -- 贷款五级分类
            ,repaycycle -- 还款周期
            ,totalterms -- 总期数
            ,curterm -- 当前期数
            ,putoutorgid -- 账务机构
            ,manageorgid -- 管理机构
            ,productid -- 产品编号
            ,ratemodel -- 利率模式
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式
            ,remart -- 计量标记-资产三分类
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,bankcontriratio -- 银行出资比例
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,hxduebillno -- 核心借据号
            ,loantype -- 贷款类型
            ,clientname -- 客户名称
            ,documenttype -- 证件类型
            ,documentid -- 证件号码
            ,isscountry -- 签证国家
            ,cyclefreq -- 结息周期
            ,termtype -- 贷款期限类型
            ,guarpaiddate -- 代偿结清日期
            ,ddpercencontri -- 合作方出资比例
            ,intpltyrate -- 复利利率
            ,oslamt -- 未到期本金
            ,odipamt -- 逾期复利
            ,writeoff -- 核销标志
            ,writeoffamt -- 核销金额
            ,gracedays -- 宽限期天数
            ,nextrepaydate -- 下一还款日期
            ,accountingstatus -- 核算状态
            ,reasoncode -- 贷款用途
            ,remark1 -- 备用字段1（行外借据号）
            ,remark2 -- 备用字段2
            ,unionguaranteeflag -- 融担模式
            ,guaranteeaid -- 担保方ID1
            ,guaranteearate -- 担保方1担保比例
            ,guaranteeacontractno -- 客户担保合同编号1
            ,guaranteebid -- 担保方ID2
            ,guaranteebrate -- 担保方2担保比例
            ,guaranteebcontractno -- 客户担保合同编号2
            ,putoutdate -- 发放日期
            ,maturity -- 贷款到期日
            ,overduedate -- 逾期日期
            ,cleardate -- 结清日期
            ,encashamt -- 借据金额
            ,currency -- 币种
            ,repaymode -- 还款方式
            ,termmonth -- 期限
            ,customerid -- 客户编号
            ,occurdate -- 发生日期
            ,trandate -- 交易日期
            ,ovdprinbal -- 逾期本金余额
            ,ovdintbal -- 逾期利息余额
            ,pnltintbal -- 罚息余额
            ,wphproductid -- 唯品产品编号
            ,daysovd -- 逾期天数
            ,writeofftime -- 核销时间
            ,executerate -- 执行利率
            ,ovdrate -- 罚息利率
            ,vouchtype -- 担保方式
            ,repaynum -- 还款账户
            ,paymentnum -- 入账账户
            ,balance -- 借据余额
            ,interestrepaycycle -- 结息方式
            ,interestcalculation -- 计息方式
            ,paymentbankname -- 入账账户开户银行名称
            ,paymentbankno -- 还款账户开户银行编号
            ,paymentorgname -- 还款账户开户机构名称
            ,normalamt -- 正常本金
            ,normalintamt -- 正常利息
            ,pnltintoverdue -- 应收欠息
            ,pnltinttotal -- 应收罚息
            ,pnltintamt -- 应收利息
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,bizdate -- 流程日期
            ,pnltodiamt -- 应收复利
            ,classifyresultdate -- 五级分类认定日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_business_duebill_op(
            serialno -- 借据编号
            ,putoutserialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,baseratetype -- 基准利率类型
            ,repayday -- 还款日
            ,baserate -- 基准利率
            ,overduerate -- 逾期利率
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,classifyresult -- 贷款五级分类
            ,repaycycle -- 还款周期
            ,totalterms -- 总期数
            ,curterm -- 当前期数
            ,putoutorgid -- 账务机构
            ,manageorgid -- 管理机构
            ,productid -- 产品编号
            ,ratemodel -- 利率模式
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式
            ,remart -- 计量标记-资产三分类
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,bankcontriratio -- 银行出资比例
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,hxduebillno -- 核心借据号
            ,loantype -- 贷款类型
            ,clientname -- 客户名称
            ,documenttype -- 证件类型
            ,documentid -- 证件号码
            ,isscountry -- 签证国家
            ,cyclefreq -- 结息周期
            ,termtype -- 贷款期限类型
            ,guarpaiddate -- 代偿结清日期
            ,ddpercencontri -- 合作方出资比例
            ,intpltyrate -- 复利利率
            ,oslamt -- 未到期本金
            ,odipamt -- 逾期复利
            ,writeoff -- 核销标志
            ,writeoffamt -- 核销金额
            ,gracedays -- 宽限期天数
            ,nextrepaydate -- 下一还款日期
            ,accountingstatus -- 核算状态
            ,reasoncode -- 贷款用途
            ,remark1 -- 备用字段1（行外借据号）
            ,remark2 -- 备用字段2
            ,unionguaranteeflag -- 融担模式
            ,guaranteeaid -- 担保方ID1
            ,guaranteearate -- 担保方1担保比例
            ,guaranteeacontractno -- 客户担保合同编号1
            ,guaranteebid -- 担保方ID2
            ,guaranteebrate -- 担保方2担保比例
            ,guaranteebcontractno -- 客户担保合同编号2
            ,putoutdate -- 发放日期
            ,maturity -- 贷款到期日
            ,overduedate -- 逾期日期
            ,cleardate -- 结清日期
            ,encashamt -- 借据金额
            ,currency -- 币种
            ,repaymode -- 还款方式
            ,termmonth -- 期限
            ,customerid -- 客户编号
            ,occurdate -- 发生日期
            ,trandate -- 交易日期
            ,ovdprinbal -- 逾期本金余额
            ,ovdintbal -- 逾期利息余额
            ,pnltintbal -- 罚息余额
            ,wphproductid -- 唯品产品编号
            ,daysovd -- 逾期天数
            ,writeofftime -- 核销时间
            ,executerate -- 执行利率
            ,ovdrate -- 罚息利率
            ,vouchtype -- 担保方式
            ,repaynum -- 还款账户
            ,paymentnum -- 入账账户
            ,balance -- 借据余额
            ,interestrepaycycle -- 结息方式
            ,interestcalculation -- 计息方式
            ,paymentbankname -- 入账账户开户银行名称
            ,paymentbankno -- 还款账户开户银行编号
            ,paymentorgname -- 还款账户开户机构名称
            ,normalamt -- 正常本金
            ,normalintamt -- 正常利息
            ,pnltintoverdue -- 应收欠息
            ,pnltinttotal -- 应收罚息
            ,pnltintamt -- 应收利息
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,bizdate -- 流程日期
            ,pnltodiamt -- 应收复利
            ,classifyresultdate -- 五级分类认定日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 借据编号
    ,nvl(n.putoutserialno, o.putoutserialno) as putoutserialno -- 出账流水号
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 合同流水号
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.repayday, o.repayday) as repayday -- 还款日
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期利率
    ,nvl(n.rateadjustfrequency, o.rateadjustfrequency) as rateadjustfrequency -- 利率调整周期
    ,nvl(n.floatrange, o.floatrange) as floatrange -- 浮动幅度
    ,nvl(n.overdueratefloattype, o.overdueratefloattype) as overdueratefloattype -- 逾期利率浮动方式
    ,nvl(n.overdueratefloatvalue, o.overdueratefloatvalue) as overdueratefloatvalue -- 逾期利率浮动值
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 贷款五级分类
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 还款周期
    ,nvl(n.totalterms, o.totalterms) as totalterms -- 总期数
    ,nvl(n.curterm, o.curterm) as curterm -- 当前期数
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 账务机构
    ,nvl(n.manageorgid, o.manageorgid) as manageorgid -- 管理机构
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.ratemodel, o.ratemodel) as ratemodel -- 利率模式
    ,nvl(n.ratefloattype, o.ratefloattype) as ratefloattype -- 利率浮动方式
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 利率调整方式
    ,nvl(n.remart, o.remart) as remart -- 计量标记-资产三分类
    ,nvl(n.dailyint, o.dailyint) as dailyint -- 当日计提利息
    ,nvl(n.dailypnltint, o.dailypnltint) as dailypnltint -- 当日计提罚息
    ,nvl(n.bankcontriratio, o.bankcontriratio) as bankcontriratio -- 银行出资比例
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办人
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.hxduebillno, o.hxduebillno) as hxduebillno -- 核心借据号
    ,nvl(n.loantype, o.loantype) as loantype -- 贷款类型
    ,nvl(n.clientname, o.clientname) as clientname -- 客户名称
    ,nvl(n.documenttype, o.documenttype) as documenttype -- 证件类型
    ,nvl(n.documentid, o.documentid) as documentid -- 证件号码
    ,nvl(n.isscountry, o.isscountry) as isscountry -- 签证国家
    ,nvl(n.cyclefreq, o.cyclefreq) as cyclefreq -- 结息周期
    ,nvl(n.termtype, o.termtype) as termtype -- 贷款期限类型
    ,nvl(n.guarpaiddate, o.guarpaiddate) as guarpaiddate -- 代偿结清日期
    ,nvl(n.ddpercencontri, o.ddpercencontri) as ddpercencontri -- 合作方出资比例
    ,nvl(n.intpltyrate, o.intpltyrate) as intpltyrate -- 复利利率
    ,nvl(n.oslamt, o.oslamt) as oslamt -- 未到期本金
    ,nvl(n.odipamt, o.odipamt) as odipamt -- 逾期复利
    ,nvl(n.writeoff, o.writeoff) as writeoff -- 核销标志
    ,nvl(n.writeoffamt, o.writeoffamt) as writeoffamt -- 核销金额
    ,nvl(n.gracedays, o.gracedays) as gracedays -- 宽限期天数
    ,nvl(n.nextrepaydate, o.nextrepaydate) as nextrepaydate -- 下一还款日期
    ,nvl(n.accountingstatus, o.accountingstatus) as accountingstatus -- 核算状态
    ,nvl(n.reasoncode, o.reasoncode) as reasoncode -- 贷款用途
    ,nvl(n.remark1, o.remark1) as remark1 -- 备用字段1（行外借据号）
    ,nvl(n.remark2, o.remark2) as remark2 -- 备用字段2
    ,nvl(n.unionguaranteeflag, o.unionguaranteeflag) as unionguaranteeflag -- 融担模式
    ,nvl(n.guaranteeaid, o.guaranteeaid) as guaranteeaid -- 担保方ID1
    ,nvl(n.guaranteearate, o.guaranteearate) as guaranteearate -- 担保方1担保比例
    ,nvl(n.guaranteeacontractno, o.guaranteeacontractno) as guaranteeacontractno -- 客户担保合同编号1
    ,nvl(n.guaranteebid, o.guaranteebid) as guaranteebid -- 担保方ID2
    ,nvl(n.guaranteebrate, o.guaranteebrate) as guaranteebrate -- 担保方2担保比例
    ,nvl(n.guaranteebcontractno, o.guaranteebcontractno) as guaranteebcontractno -- 客户担保合同编号2
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 发放日期
    ,nvl(n.maturity, o.maturity) as maturity -- 贷款到期日
    ,nvl(n.overduedate, o.overduedate) as overduedate -- 逾期日期
    ,nvl(n.cleardate, o.cleardate) as cleardate -- 结清日期
    ,nvl(n.encashamt, o.encashamt) as encashamt -- 借据金额
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.repaymode, o.repaymode) as repaymode -- 还款方式
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 发生日期
    ,nvl(n.trandate, o.trandate) as trandate -- 交易日期
    ,nvl(n.ovdprinbal, o.ovdprinbal) as ovdprinbal -- 逾期本金余额
    ,nvl(n.ovdintbal, o.ovdintbal) as ovdintbal -- 逾期利息余额
    ,nvl(n.pnltintbal, o.pnltintbal) as pnltintbal -- 罚息余额
    ,nvl(n.wphproductid, o.wphproductid) as wphproductid -- 唯品产品编号
    ,nvl(n.daysovd, o.daysovd) as daysovd -- 逾期天数
    ,nvl(n.writeofftime, o.writeofftime) as writeofftime -- 核销时间
    ,nvl(n.executerate, o.executerate) as executerate -- 执行利率
    ,nvl(n.ovdrate, o.ovdrate) as ovdrate -- 罚息利率
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 担保方式
    ,nvl(n.repaynum, o.repaynum) as repaynum -- 还款账户
    ,nvl(n.paymentnum, o.paymentnum) as paymentnum -- 入账账户
    ,nvl(n.balance, o.balance) as balance -- 借据余额
    ,nvl(n.interestrepaycycle, o.interestrepaycycle) as interestrepaycycle -- 结息方式
    ,nvl(n.interestcalculation, o.interestcalculation) as interestcalculation -- 计息方式
    ,nvl(n.paymentbankname, o.paymentbankname) as paymentbankname -- 入账账户开户银行名称
    ,nvl(n.paymentbankno, o.paymentbankno) as paymentbankno -- 还款账户开户银行编号
    ,nvl(n.paymentorgname, o.paymentorgname) as paymentorgname -- 还款账户开户机构名称
    ,nvl(n.normalamt, o.normalamt) as normalamt -- 正常本金
    ,nvl(n.normalintamt, o.normalintamt) as normalintamt -- 正常利息
    ,nvl(n.pnltintoverdue, o.pnltintoverdue) as pnltintoverdue -- 应收欠息
    ,nvl(n.pnltinttotal, o.pnltinttotal) as pnltinttotal -- 应收罚息
    ,nvl(n.pnltintamt, o.pnltintamt) as pnltintamt -- 应收利息
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.bizdate, o.bizdate) as bizdate -- 流程日期
    ,nvl(n.pnltodiamt, o.pnltodiamt) as pnltodiamt -- 应收复利
    ,nvl(n.classifyresultdate, o.classifyresultdate) as classifyresultdate -- 五级分类认定日期
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
from (select * from ${iol_schema}.icms_wph_business_duebill_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wph_business_duebill where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.putoutserialno <> n.putoutserialno
        or o.contractserialno <> n.contractserialno
        or o.baseratetype <> n.baseratetype
        or o.repayday <> n.repayday
        or o.baserate <> n.baserate
        or o.overduerate <> n.overduerate
        or o.rateadjustfrequency <> n.rateadjustfrequency
        or o.floatrange <> n.floatrange
        or o.overdueratefloattype <> n.overdueratefloattype
        or o.overdueratefloatvalue <> n.overdueratefloatvalue
        or o.classifyresult <> n.classifyresult
        or o.repaycycle <> n.repaycycle
        or o.totalterms <> n.totalterms
        or o.curterm <> n.curterm
        or o.putoutorgid <> n.putoutorgid
        or o.manageorgid <> n.manageorgid
        or o.productid <> n.productid
        or o.ratemodel <> n.ratemodel
        or o.ratefloattype <> n.ratefloattype
        or o.rateadjusttype <> n.rateadjusttype
        or o.remart <> n.remart
        or o.dailyint <> n.dailyint
        or o.dailypnltint <> n.dailypnltint
        or o.bankcontriratio <> n.bankcontriratio
        or o.operateuserid <> n.operateuserid
        or o.operateorgid <> n.operateorgid
        or o.hxduebillno <> n.hxduebillno
        or o.loantype <> n.loantype
        or o.clientname <> n.clientname
        or o.documenttype <> n.documenttype
        or o.documentid <> n.documentid
        or o.isscountry <> n.isscountry
        or o.cyclefreq <> n.cyclefreq
        or o.termtype <> n.termtype
        or o.guarpaiddate <> n.guarpaiddate
        or o.ddpercencontri <> n.ddpercencontri
        or o.intpltyrate <> n.intpltyrate
        or o.oslamt <> n.oslamt
        or o.odipamt <> n.odipamt
        or o.writeoff <> n.writeoff
        or o.writeoffamt <> n.writeoffamt
        or o.gracedays <> n.gracedays
        or o.nextrepaydate <> n.nextrepaydate
        or o.accountingstatus <> n.accountingstatus
        or o.reasoncode <> n.reasoncode
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.unionguaranteeflag <> n.unionguaranteeflag
        or o.guaranteeaid <> n.guaranteeaid
        or o.guaranteearate <> n.guaranteearate
        or o.guaranteeacontractno <> n.guaranteeacontractno
        or o.guaranteebid <> n.guaranteebid
        or o.guaranteebrate <> n.guaranteebrate
        or o.guaranteebcontractno <> n.guaranteebcontractno
        or o.putoutdate <> n.putoutdate
        or o.maturity <> n.maturity
        or o.overduedate <> n.overduedate
        or o.cleardate <> n.cleardate
        or o.encashamt <> n.encashamt
        or o.currency <> n.currency
        or o.repaymode <> n.repaymode
        or o.termmonth <> n.termmonth
        or o.customerid <> n.customerid
        or o.occurdate <> n.occurdate
        or o.trandate <> n.trandate
        or o.ovdprinbal <> n.ovdprinbal
        or o.ovdintbal <> n.ovdintbal
        or o.pnltintbal <> n.pnltintbal
        or o.wphproductid <> n.wphproductid
        or o.daysovd <> n.daysovd
        or o.writeofftime <> n.writeofftime
        or o.executerate <> n.executerate
        or o.ovdrate <> n.ovdrate
        or o.vouchtype <> n.vouchtype
        or o.repaynum <> n.repaynum
        or o.paymentnum <> n.paymentnum
        or o.balance <> n.balance
        or o.interestrepaycycle <> n.interestrepaycycle
        or o.interestcalculation <> n.interestcalculation
        or o.paymentbankname <> n.paymentbankname
        or o.paymentbankno <> n.paymentbankno
        or o.paymentorgname <> n.paymentorgname
        or o.normalamt <> n.normalamt
        or o.normalintamt <> n.normalintamt
        or o.pnltintoverdue <> n.pnltintoverdue
        or o.pnltinttotal <> n.pnltinttotal
        or o.pnltintamt <> n.pnltintamt
        or o.inputdate <> n.inputdate
        or o.updatedate <> n.updatedate
        or o.bizdate <> n.bizdate
        or o.pnltodiamt <> n.pnltodiamt
        or o.classifyresultdate <> n.classifyresultdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_business_duebill_cl(
            serialno -- 借据编号
            ,putoutserialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,baseratetype -- 基准利率类型
            ,repayday -- 还款日
            ,baserate -- 基准利率
            ,overduerate -- 逾期利率
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,classifyresult -- 贷款五级分类
            ,repaycycle -- 还款周期
            ,totalterms -- 总期数
            ,curterm -- 当前期数
            ,putoutorgid -- 账务机构
            ,manageorgid -- 管理机构
            ,productid -- 产品编号
            ,ratemodel -- 利率模式
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式
            ,remart -- 计量标记-资产三分类
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,bankcontriratio -- 银行出资比例
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,hxduebillno -- 核心借据号
            ,loantype -- 贷款类型
            ,clientname -- 客户名称
            ,documenttype -- 证件类型
            ,documentid -- 证件号码
            ,isscountry -- 签证国家
            ,cyclefreq -- 结息周期
            ,termtype -- 贷款期限类型
            ,guarpaiddate -- 代偿结清日期
            ,ddpercencontri -- 合作方出资比例
            ,intpltyrate -- 复利利率
            ,oslamt -- 未到期本金
            ,odipamt -- 逾期复利
            ,writeoff -- 核销标志
            ,writeoffamt -- 核销金额
            ,gracedays -- 宽限期天数
            ,nextrepaydate -- 下一还款日期
            ,accountingstatus -- 核算状态
            ,reasoncode -- 贷款用途
            ,remark1 -- 备用字段1（行外借据号）
            ,remark2 -- 备用字段2
            ,unionguaranteeflag -- 融担模式
            ,guaranteeaid -- 担保方ID1
            ,guaranteearate -- 担保方1担保比例
            ,guaranteeacontractno -- 客户担保合同编号1
            ,guaranteebid -- 担保方ID2
            ,guaranteebrate -- 担保方2担保比例
            ,guaranteebcontractno -- 客户担保合同编号2
            ,putoutdate -- 发放日期
            ,maturity -- 贷款到期日
            ,overduedate -- 逾期日期
            ,cleardate -- 结清日期
            ,encashamt -- 借据金额
            ,currency -- 币种
            ,repaymode -- 还款方式
            ,termmonth -- 期限
            ,customerid -- 客户编号
            ,occurdate -- 发生日期
            ,trandate -- 交易日期
            ,ovdprinbal -- 逾期本金余额
            ,ovdintbal -- 逾期利息余额
            ,pnltintbal -- 罚息余额
            ,wphproductid -- 唯品产品编号
            ,daysovd -- 逾期天数
            ,writeofftime -- 核销时间
            ,executerate -- 执行利率
            ,ovdrate -- 罚息利率
            ,vouchtype -- 担保方式
            ,repaynum -- 还款账户
            ,paymentnum -- 入账账户
            ,balance -- 借据余额
            ,interestrepaycycle -- 结息方式
            ,interestcalculation -- 计息方式
            ,paymentbankname -- 入账账户开户银行名称
            ,paymentbankno -- 还款账户开户银行编号
            ,paymentorgname -- 还款账户开户机构名称
            ,normalamt -- 正常本金
            ,normalintamt -- 正常利息
            ,pnltintoverdue -- 应收欠息
            ,pnltinttotal -- 应收罚息
            ,pnltintamt -- 应收利息
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,bizdate -- 流程日期
            ,pnltodiamt -- 应收复利
            ,classifyresultdate -- 五级分类认定日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_business_duebill_op(
            serialno -- 借据编号
            ,putoutserialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,baseratetype -- 基准利率类型
            ,repayday -- 还款日
            ,baserate -- 基准利率
            ,overduerate -- 逾期利率
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,classifyresult -- 贷款五级分类
            ,repaycycle -- 还款周期
            ,totalterms -- 总期数
            ,curterm -- 当前期数
            ,putoutorgid -- 账务机构
            ,manageorgid -- 管理机构
            ,productid -- 产品编号
            ,ratemodel -- 利率模式
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式
            ,remart -- 计量标记-资产三分类
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,bankcontriratio -- 银行出资比例
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,hxduebillno -- 核心借据号
            ,loantype -- 贷款类型
            ,clientname -- 客户名称
            ,documenttype -- 证件类型
            ,documentid -- 证件号码
            ,isscountry -- 签证国家
            ,cyclefreq -- 结息周期
            ,termtype -- 贷款期限类型
            ,guarpaiddate -- 代偿结清日期
            ,ddpercencontri -- 合作方出资比例
            ,intpltyrate -- 复利利率
            ,oslamt -- 未到期本金
            ,odipamt -- 逾期复利
            ,writeoff -- 核销标志
            ,writeoffamt -- 核销金额
            ,gracedays -- 宽限期天数
            ,nextrepaydate -- 下一还款日期
            ,accountingstatus -- 核算状态
            ,reasoncode -- 贷款用途
            ,remark1 -- 备用字段1（行外借据号）
            ,remark2 -- 备用字段2
            ,unionguaranteeflag -- 融担模式
            ,guaranteeaid -- 担保方ID1
            ,guaranteearate -- 担保方1担保比例
            ,guaranteeacontractno -- 客户担保合同编号1
            ,guaranteebid -- 担保方ID2
            ,guaranteebrate -- 担保方2担保比例
            ,guaranteebcontractno -- 客户担保合同编号2
            ,putoutdate -- 发放日期
            ,maturity -- 贷款到期日
            ,overduedate -- 逾期日期
            ,cleardate -- 结清日期
            ,encashamt -- 借据金额
            ,currency -- 币种
            ,repaymode -- 还款方式
            ,termmonth -- 期限
            ,customerid -- 客户编号
            ,occurdate -- 发生日期
            ,trandate -- 交易日期
            ,ovdprinbal -- 逾期本金余额
            ,ovdintbal -- 逾期利息余额
            ,pnltintbal -- 罚息余额
            ,wphproductid -- 唯品产品编号
            ,daysovd -- 逾期天数
            ,writeofftime -- 核销时间
            ,executerate -- 执行利率
            ,ovdrate -- 罚息利率
            ,vouchtype -- 担保方式
            ,repaynum -- 还款账户
            ,paymentnum -- 入账账户
            ,balance -- 借据余额
            ,interestrepaycycle -- 结息方式
            ,interestcalculation -- 计息方式
            ,paymentbankname -- 入账账户开户银行名称
            ,paymentbankno -- 还款账户开户银行编号
            ,paymentorgname -- 还款账户开户机构名称
            ,normalamt -- 正常本金
            ,normalintamt -- 正常利息
            ,pnltintoverdue -- 应收欠息
            ,pnltinttotal -- 应收罚息
            ,pnltintamt -- 应收利息
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,bizdate -- 流程日期
            ,pnltodiamt -- 应收复利
            ,classifyresultdate -- 五级分类认定日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 借据编号
    ,o.putoutserialno -- 出账流水号
    ,o.contractserialno -- 合同流水号
    ,o.baseratetype -- 基准利率类型
    ,o.repayday -- 还款日
    ,o.baserate -- 基准利率
    ,o.overduerate -- 逾期利率
    ,o.rateadjustfrequency -- 利率调整周期
    ,o.floatrange -- 浮动幅度
    ,o.overdueratefloattype -- 逾期利率浮动方式
    ,o.overdueratefloatvalue -- 逾期利率浮动值
    ,o.classifyresult -- 贷款五级分类
    ,o.repaycycle -- 还款周期
    ,o.totalterms -- 总期数
    ,o.curterm -- 当前期数
    ,o.putoutorgid -- 账务机构
    ,o.manageorgid -- 管理机构
    ,o.productid -- 产品编号
    ,o.ratemodel -- 利率模式
    ,o.ratefloattype -- 利率浮动方式
    ,o.rateadjusttype -- 利率调整方式
    ,o.remart -- 计量标记-资产三分类
    ,o.dailyint -- 当日计提利息
    ,o.dailypnltint -- 当日计提罚息
    ,o.bankcontriratio -- 银行出资比例
    ,o.operateuserid -- 经办人
    ,o.operateorgid -- 经办机构
    ,o.hxduebillno -- 核心借据号
    ,o.loantype -- 贷款类型
    ,o.clientname -- 客户名称
    ,o.documenttype -- 证件类型
    ,o.documentid -- 证件号码
    ,o.isscountry -- 签证国家
    ,o.cyclefreq -- 结息周期
    ,o.termtype -- 贷款期限类型
    ,o.guarpaiddate -- 代偿结清日期
    ,o.ddpercencontri -- 合作方出资比例
    ,o.intpltyrate -- 复利利率
    ,o.oslamt -- 未到期本金
    ,o.odipamt -- 逾期复利
    ,o.writeoff -- 核销标志
    ,o.writeoffamt -- 核销金额
    ,o.gracedays -- 宽限期天数
    ,o.nextrepaydate -- 下一还款日期
    ,o.accountingstatus -- 核算状态
    ,o.reasoncode -- 贷款用途
    ,o.remark1 -- 备用字段1（行外借据号）
    ,o.remark2 -- 备用字段2
    ,o.unionguaranteeflag -- 融担模式
    ,o.guaranteeaid -- 担保方ID1
    ,o.guaranteearate -- 担保方1担保比例
    ,o.guaranteeacontractno -- 客户担保合同编号1
    ,o.guaranteebid -- 担保方ID2
    ,o.guaranteebrate -- 担保方2担保比例
    ,o.guaranteebcontractno -- 客户担保合同编号2
    ,o.putoutdate -- 发放日期
    ,o.maturity -- 贷款到期日
    ,o.overduedate -- 逾期日期
    ,o.cleardate -- 结清日期
    ,o.encashamt -- 借据金额
    ,o.currency -- 币种
    ,o.repaymode -- 还款方式
    ,o.termmonth -- 期限
    ,o.customerid -- 客户编号
    ,o.occurdate -- 发生日期
    ,o.trandate -- 交易日期
    ,o.ovdprinbal -- 逾期本金余额
    ,o.ovdintbal -- 逾期利息余额
    ,o.pnltintbal -- 罚息余额
    ,o.wphproductid -- 唯品产品编号
    ,o.daysovd -- 逾期天数
    ,o.writeofftime -- 核销时间
    ,o.executerate -- 执行利率
    ,o.ovdrate -- 罚息利率
    ,o.vouchtype -- 担保方式
    ,o.repaynum -- 还款账户
    ,o.paymentnum -- 入账账户
    ,o.balance -- 借据余额
    ,o.interestrepaycycle -- 结息方式
    ,o.interestcalculation -- 计息方式
    ,o.paymentbankname -- 入账账户开户银行名称
    ,o.paymentbankno -- 还款账户开户银行编号
    ,o.paymentorgname -- 还款账户开户机构名称
    ,o.normalamt -- 正常本金
    ,o.normalintamt -- 正常利息
    ,o.pnltintoverdue -- 应收欠息
    ,o.pnltinttotal -- 应收罚息
    ,o.pnltintamt -- 应收利息
    ,o.inputdate -- 登记日期
    ,o.updatedate -- 更新日期
    ,o.bizdate -- 流程日期
    ,o.pnltodiamt -- 应收复利
    ,o.classifyresultdate -- 五级分类认定日期
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
from ${iol_schema}.icms_wph_business_duebill_bk o
    left join ${iol_schema}.icms_wph_business_duebill_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wph_business_duebill_cl d
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
--truncate table ${iol_schema}.icms_wph_business_duebill;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wph_business_duebill') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wph_business_duebill drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wph_business_duebill add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wph_business_duebill exchange partition p_${batch_date} with table ${iol_schema}.icms_wph_business_duebill_cl;
alter table ${iol_schema}.icms_wph_business_duebill exchange partition p_20991231 with table ${iol_schema}.icms_wph_business_duebill_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wph_business_duebill to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_business_duebill_op purge;
drop table ${iol_schema}.icms_wph_business_duebill_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wph_business_duebill_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wph_business_duebill',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
