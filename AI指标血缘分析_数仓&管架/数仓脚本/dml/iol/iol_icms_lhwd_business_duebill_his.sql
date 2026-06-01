/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lhwd_business_duebill_his
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
create table ${iol_schema}.icms_lhwd_business_duebill_his_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lhwd_business_duebill_his
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhwd_business_duebill_his_op purge;
drop table ${iol_schema}.icms_lhwd_business_duebill_his_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_business_duebill_his_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhwd_business_duebill_his where 0=1;

create table ${iol_schema}.icms_lhwd_business_duebill_his_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhwd_business_duebill_his where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lhwd_business_duebill_his_cl(
            bizdate -- 数据日期 批次日期 yyyyMMdd
            ,serialno -- 借据编号（第三方/行内）
            ,hxbdserialno -- 借据编号（行内）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,putoutserialno -- 出账编号
            ,contractserialno -- 业务合同编号
            ,applyno -- 全局流水号（第三方）
            ,businessmodel -- 业务模式（第三方）
            ,vouchtype -- 担保方式
            ,productid -- 产品编号（行内）
            ,productno -- 产品编号（第三方）
            ,businesssum -- 借据金额
            ,currency -- 借据币种
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,repaycycle -- 还款周期
            ,graceperiod -- 宽限期
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,executerate -- 执行利率
            ,rateadjusttype -- 执行利率调整方式
            ,rateadjustfrequency -- 执行利率调整周期
            ,floatrange -- 执行利率浮动点差BP
            ,overduedays -- 逾期天数
            ,overduedate -- 逾期日期
            ,overduerate -- 逾期利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动比例（%）
            ,compoundrate -- 复利利率
            ,dzhxstatus -- 核销标志
            ,wrndate -- 核销日期
            ,wrnpriamt -- 核销本金
            ,wrnintamt -- 核销利息
            ,balance -- 借据余额
            ,intamtbjbalance -- 正常本金余额
            ,intamtlxbalance -- 正常利息余额
            ,overduebjbalance -- 逾期本金余额
            ,overduelxbalance -- 逾期利息余额
            ,capitalpenaltybalance -- 罚息余额
            ,interestpenaltybalance -- 复息余额
            ,ysintamt -- 应收利息
            ,ysodpamt -- 应收罚息
            ,ysodiamt -- 应收复息
            ,reversalflag -- 冲正标志
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 贷款五级分类认定日期
            ,remart -- 计量标记-资产三分类
            ,repaytype -- 还款方式
            ,paymenttype -- 放款支付方式
            ,putoutorgid -- 出账机构编号(核心机构)
            ,paymentaccountno -- 入账账户
            ,paymentaccounttype -- 入账账户类型
            ,paymentaccountname -- 入账账户名
            ,paymentaccountbankname -- 入账账户开户机构
            ,repayaccountno -- 还款账号
            ,repayaccounttype -- 还款账户类型
            ,repayaccountname -- 还款账户名
            ,repayaccountbankname -- 还款账户开户机构
            ,bankcontriratio -- 银行出资比例
            ,totalterms -- 借据还款计划总期数
            ,curterms -- 当前期数
            ,unclearperiods -- 未结清期数
            ,businessstatus -- 借据状态
            ,finishdate -- 借据结清日期
            ,putoutdate -- 发放日期
            ,maturity -- 借据到期日
            ,creditchannel -- 授信渠道
            ,intnalloantype -- 行内贷款类型代码
            ,acrunonacru -- 应计非应计代码
            ,intsetway -- 结息方式代码
            ,intaccrway -- 计息方式代码
            ,intratfloatway -- 利率浮动方式代码
            ,intratfloatdir -- 利率浮动方向代码
            ,accountflag -- 记账标志
            ,intrat -- 固收利率
            ,tdacruint -- 当日应计利息
            ,intoverduedays -- 利息逾期天数
            ,intoverduedate -- 利息逾期日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhwd_business_duebill_his_op(
            bizdate -- 数据日期 批次日期 yyyyMMdd
            ,serialno -- 借据编号（第三方/行内）
            ,hxbdserialno -- 借据编号（行内）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,putoutserialno -- 出账编号
            ,contractserialno -- 业务合同编号
            ,applyno -- 全局流水号（第三方）
            ,businessmodel -- 业务模式（第三方）
            ,vouchtype -- 担保方式
            ,productid -- 产品编号（行内）
            ,productno -- 产品编号（第三方）
            ,businesssum -- 借据金额
            ,currency -- 借据币种
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,repaycycle -- 还款周期
            ,graceperiod -- 宽限期
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,executerate -- 执行利率
            ,rateadjusttype -- 执行利率调整方式
            ,rateadjustfrequency -- 执行利率调整周期
            ,floatrange -- 执行利率浮动点差BP
            ,overduedays -- 逾期天数
            ,overduedate -- 逾期日期
            ,overduerate -- 逾期利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动比例（%）
            ,compoundrate -- 复利利率
            ,dzhxstatus -- 核销标志
            ,wrndate -- 核销日期
            ,wrnpriamt -- 核销本金
            ,wrnintamt -- 核销利息
            ,balance -- 借据余额
            ,intamtbjbalance -- 正常本金余额
            ,intamtlxbalance -- 正常利息余额
            ,overduebjbalance -- 逾期本金余额
            ,overduelxbalance -- 逾期利息余额
            ,capitalpenaltybalance -- 罚息余额
            ,interestpenaltybalance -- 复息余额
            ,ysintamt -- 应收利息
            ,ysodpamt -- 应收罚息
            ,ysodiamt -- 应收复息
            ,reversalflag -- 冲正标志
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 贷款五级分类认定日期
            ,remart -- 计量标记-资产三分类
            ,repaytype -- 还款方式
            ,paymenttype -- 放款支付方式
            ,putoutorgid -- 出账机构编号(核心机构)
            ,paymentaccountno -- 入账账户
            ,paymentaccounttype -- 入账账户类型
            ,paymentaccountname -- 入账账户名
            ,paymentaccountbankname -- 入账账户开户机构
            ,repayaccountno -- 还款账号
            ,repayaccounttype -- 还款账户类型
            ,repayaccountname -- 还款账户名
            ,repayaccountbankname -- 还款账户开户机构
            ,bankcontriratio -- 银行出资比例
            ,totalterms -- 借据还款计划总期数
            ,curterms -- 当前期数
            ,unclearperiods -- 未结清期数
            ,businessstatus -- 借据状态
            ,finishdate -- 借据结清日期
            ,putoutdate -- 发放日期
            ,maturity -- 借据到期日
            ,creditchannel -- 授信渠道
            ,intnalloantype -- 行内贷款类型代码
            ,acrunonacru -- 应计非应计代码
            ,intsetway -- 结息方式代码
            ,intaccrway -- 计息方式代码
            ,intratfloatway -- 利率浮动方式代码
            ,intratfloatdir -- 利率浮动方向代码
            ,accountflag -- 记账标志
            ,intrat -- 固收利率
            ,tdacruint -- 当日应计利息
            ,intoverduedays -- 利息逾期天数
            ,intoverduedate -- 利息逾期日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bizdate, o.bizdate) as bizdate -- 数据日期 批次日期 yyyyMMdd
    ,nvl(n.serialno, o.serialno) as serialno -- 借据编号（第三方/行内）
    ,nvl(n.hxbdserialno, o.hxbdserialno) as hxbdserialno -- 借据编号（行内）
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.putoutserialno, o.putoutserialno) as putoutserialno -- 出账编号
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 业务合同编号
    ,nvl(n.applyno, o.applyno) as applyno -- 全局流水号（第三方）
    ,nvl(n.businessmodel, o.businessmodel) as businessmodel -- 业务模式（第三方）
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 担保方式
    ,nvl(n.productid, o.productid) as productid -- 产品编号（行内）
    ,nvl(n.productno, o.productno) as productno -- 产品编号（第三方）
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 借据金额
    ,nvl(n.currency, o.currency) as currency -- 借据币种
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限(月)
    ,nvl(n.termday, o.termday) as termday -- 期限(天)
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 还款周期
    ,nvl(n.graceperiod, o.graceperiod) as graceperiod -- 宽限期
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.executerate, o.executerate) as executerate -- 执行利率
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 执行利率调整方式
    ,nvl(n.rateadjustfrequency, o.rateadjustfrequency) as rateadjustfrequency -- 执行利率调整周期
    ,nvl(n.floatrange, o.floatrange) as floatrange -- 执行利率浮动点差BP
    ,nvl(n.overduedays, o.overduedays) as overduedays -- 逾期天数
    ,nvl(n.overduedate, o.overduedate) as overduedate -- 逾期日期
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期利率
    ,nvl(n.overdueratefloattype, o.overdueratefloattype) as overdueratefloattype -- 逾期利率浮动方式
    ,nvl(n.overdueratefloatvalue, o.overdueratefloatvalue) as overdueratefloatvalue -- 逾期利率浮动比例（%）
    ,nvl(n.compoundrate, o.compoundrate) as compoundrate -- 复利利率
    ,nvl(n.dzhxstatus, o.dzhxstatus) as dzhxstatus -- 核销标志
    ,nvl(n.wrndate, o.wrndate) as wrndate -- 核销日期
    ,nvl(n.wrnpriamt, o.wrnpriamt) as wrnpriamt -- 核销本金
    ,nvl(n.wrnintamt, o.wrnintamt) as wrnintamt -- 核销利息
    ,nvl(n.balance, o.balance) as balance -- 借据余额
    ,nvl(n.intamtbjbalance, o.intamtbjbalance) as intamtbjbalance -- 正常本金余额
    ,nvl(n.intamtlxbalance, o.intamtlxbalance) as intamtlxbalance -- 正常利息余额
    ,nvl(n.overduebjbalance, o.overduebjbalance) as overduebjbalance -- 逾期本金余额
    ,nvl(n.overduelxbalance, o.overduelxbalance) as overduelxbalance -- 逾期利息余额
    ,nvl(n.capitalpenaltybalance, o.capitalpenaltybalance) as capitalpenaltybalance -- 罚息余额
    ,nvl(n.interestpenaltybalance, o.interestpenaltybalance) as interestpenaltybalance -- 复息余额
    ,nvl(n.ysintamt, o.ysintamt) as ysintamt -- 应收利息
    ,nvl(n.ysodpamt, o.ysodpamt) as ysodpamt -- 应收罚息
    ,nvl(n.ysodiamt, o.ysodiamt) as ysodiamt -- 应收复息
    ,nvl(n.reversalflag, o.reversalflag) as reversalflag -- 冲正标志
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 贷款五级分类
    ,nvl(n.classifydate, o.classifydate) as classifydate -- 贷款五级分类认定日期
    ,nvl(n.remart, o.remart) as remart -- 计量标记-资产三分类
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 放款支付方式
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 出账机构编号(核心机构)
    ,nvl(n.paymentaccountno, o.paymentaccountno) as paymentaccountno -- 入账账户
    ,nvl(n.paymentaccounttype, o.paymentaccounttype) as paymentaccounttype -- 入账账户类型
    ,nvl(n.paymentaccountname, o.paymentaccountname) as paymentaccountname -- 入账账户名
    ,nvl(n.paymentaccountbankname, o.paymentaccountbankname) as paymentaccountbankname -- 入账账户开户机构
    ,nvl(n.repayaccountno, o.repayaccountno) as repayaccountno -- 还款账号
    ,nvl(n.repayaccounttype, o.repayaccounttype) as repayaccounttype -- 还款账户类型
    ,nvl(n.repayaccountname, o.repayaccountname) as repayaccountname -- 还款账户名
    ,nvl(n.repayaccountbankname, o.repayaccountbankname) as repayaccountbankname -- 还款账户开户机构
    ,nvl(n.bankcontriratio, o.bankcontriratio) as bankcontriratio -- 银行出资比例
    ,nvl(n.totalterms, o.totalterms) as totalterms -- 借据还款计划总期数
    ,nvl(n.curterms, o.curterms) as curterms -- 当前期数
    ,nvl(n.unclearperiods, o.unclearperiods) as unclearperiods -- 未结清期数
    ,nvl(n.businessstatus, o.businessstatus) as businessstatus -- 借据状态
    ,nvl(n.finishdate, o.finishdate) as finishdate -- 借据结清日期
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 发放日期
    ,nvl(n.maturity, o.maturity) as maturity -- 借据到期日
    ,nvl(n.creditchannel, o.creditchannel) as creditchannel -- 授信渠道
    ,nvl(n.intnalloantype, o.intnalloantype) as intnalloantype -- 行内贷款类型代码
    ,nvl(n.acrunonacru, o.acrunonacru) as acrunonacru -- 应计非应计代码
    ,nvl(n.intsetway, o.intsetway) as intsetway -- 结息方式代码
    ,nvl(n.intaccrway, o.intaccrway) as intaccrway -- 计息方式代码
    ,nvl(n.intratfloatway, o.intratfloatway) as intratfloatway -- 利率浮动方式代码
    ,nvl(n.intratfloatdir, o.intratfloatdir) as intratfloatdir -- 利率浮动方向代码
    ,nvl(n.accountflag, o.accountflag) as accountflag -- 记账标志
    ,nvl(n.intrat, o.intrat) as intrat -- 固收利率
    ,nvl(n.tdacruint, o.tdacruint) as tdacruint -- 当日应计利息
    ,nvl(n.intoverduedays, o.intoverduedays) as intoverduedays -- 利息逾期天数
    ,nvl(n.intoverduedate, o.intoverduedate) as intoverduedate -- 利息逾期日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,case when
            n.bizdate is null
            and n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bizdate is null
            and n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bizdate is null
            and n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_lhwd_business_duebill_his_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lhwd_business_duebill_his where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bizdate = n.bizdate
            and o.serialno = n.serialno
where (
        o.bizdate is null
        and o.serialno is null
    )
    or (
        n.bizdate is null
        and n.serialno is null
    )
    or (
        o.hxbdserialno <> n.hxbdserialno
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.putoutserialno <> n.putoutserialno
        or o.contractserialno <> n.contractserialno
        or o.applyno <> n.applyno
        or o.businessmodel <> n.businessmodel
        or o.vouchtype <> n.vouchtype
        or o.productid <> n.productid
        or o.productno <> n.productno
        or o.businesssum <> n.businesssum
        or o.currency <> n.currency
        or o.termmonth <> n.termmonth
        or o.termday <> n.termday
        or o.repaycycle <> n.repaycycle
        or o.graceperiod <> n.graceperiod
        or o.baseratetype <> n.baseratetype
        or o.baserate <> n.baserate
        or o.executerate <> n.executerate
        or o.rateadjusttype <> n.rateadjusttype
        or o.rateadjustfrequency <> n.rateadjustfrequency
        or o.floatrange <> n.floatrange
        or o.overduedays <> n.overduedays
        or o.overduedate <> n.overduedate
        or o.overduerate <> n.overduerate
        or o.overdueratefloattype <> n.overdueratefloattype
        or o.overdueratefloatvalue <> n.overdueratefloatvalue
        or o.compoundrate <> n.compoundrate
        or o.dzhxstatus <> n.dzhxstatus
        or o.wrndate <> n.wrndate
        or o.wrnpriamt <> n.wrnpriamt
        or o.wrnintamt <> n.wrnintamt
        or o.balance <> n.balance
        or o.intamtbjbalance <> n.intamtbjbalance
        or o.intamtlxbalance <> n.intamtlxbalance
        or o.overduebjbalance <> n.overduebjbalance
        or o.overduelxbalance <> n.overduelxbalance
        or o.capitalpenaltybalance <> n.capitalpenaltybalance
        or o.interestpenaltybalance <> n.interestpenaltybalance
        or o.ysintamt <> n.ysintamt
        or o.ysodpamt <> n.ysodpamt
        or o.ysodiamt <> n.ysodiamt
        or o.reversalflag <> n.reversalflag
        or o.classifyresult <> n.classifyresult
        or o.classifydate <> n.classifydate
        or o.remart <> n.remart
        or o.repaytype <> n.repaytype
        or o.paymenttype <> n.paymenttype
        or o.putoutorgid <> n.putoutorgid
        or o.paymentaccountno <> n.paymentaccountno
        or o.paymentaccounttype <> n.paymentaccounttype
        or o.paymentaccountname <> n.paymentaccountname
        or o.paymentaccountbankname <> n.paymentaccountbankname
        or o.repayaccountno <> n.repayaccountno
        or o.repayaccounttype <> n.repayaccounttype
        or o.repayaccountname <> n.repayaccountname
        or o.repayaccountbankname <> n.repayaccountbankname
        or o.bankcontriratio <> n.bankcontriratio
        or o.totalterms <> n.totalterms
        or o.curterms <> n.curterms
        or o.unclearperiods <> n.unclearperiods
        or o.businessstatus <> n.businessstatus
        or o.finishdate <> n.finishdate
        or o.putoutdate <> n.putoutdate
        or o.maturity <> n.maturity
        or o.creditchannel <> n.creditchannel
        or o.intnalloantype <> n.intnalloantype
        or o.acrunonacru <> n.acrunonacru
        or o.intsetway <> n.intsetway
        or o.intaccrway <> n.intaccrway
        or o.intratfloatway <> n.intratfloatway
        or o.intratfloatdir <> n.intratfloatdir
        or o.accountflag <> n.accountflag
        or o.intrat <> n.intrat
        or o.tdacruint <> n.tdacruint
        or o.intoverduedays <> n.intoverduedays
        or o.intoverduedate <> n.intoverduedate
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lhwd_business_duebill_his_cl(
            bizdate -- 数据日期 批次日期 yyyyMMdd
            ,serialno -- 借据编号（第三方/行内）
            ,hxbdserialno -- 借据编号（行内）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,putoutserialno -- 出账编号
            ,contractserialno -- 业务合同编号
            ,applyno -- 全局流水号（第三方）
            ,businessmodel -- 业务模式（第三方）
            ,vouchtype -- 担保方式
            ,productid -- 产品编号（行内）
            ,productno -- 产品编号（第三方）
            ,businesssum -- 借据金额
            ,currency -- 借据币种
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,repaycycle -- 还款周期
            ,graceperiod -- 宽限期
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,executerate -- 执行利率
            ,rateadjusttype -- 执行利率调整方式
            ,rateadjustfrequency -- 执行利率调整周期
            ,floatrange -- 执行利率浮动点差BP
            ,overduedays -- 逾期天数
            ,overduedate -- 逾期日期
            ,overduerate -- 逾期利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动比例（%）
            ,compoundrate -- 复利利率
            ,dzhxstatus -- 核销标志
            ,wrndate -- 核销日期
            ,wrnpriamt -- 核销本金
            ,wrnintamt -- 核销利息
            ,balance -- 借据余额
            ,intamtbjbalance -- 正常本金余额
            ,intamtlxbalance -- 正常利息余额
            ,overduebjbalance -- 逾期本金余额
            ,overduelxbalance -- 逾期利息余额
            ,capitalpenaltybalance -- 罚息余额
            ,interestpenaltybalance -- 复息余额
            ,ysintamt -- 应收利息
            ,ysodpamt -- 应收罚息
            ,ysodiamt -- 应收复息
            ,reversalflag -- 冲正标志
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 贷款五级分类认定日期
            ,remart -- 计量标记-资产三分类
            ,repaytype -- 还款方式
            ,paymenttype -- 放款支付方式
            ,putoutorgid -- 出账机构编号(核心机构)
            ,paymentaccountno -- 入账账户
            ,paymentaccounttype -- 入账账户类型
            ,paymentaccountname -- 入账账户名
            ,paymentaccountbankname -- 入账账户开户机构
            ,repayaccountno -- 还款账号
            ,repayaccounttype -- 还款账户类型
            ,repayaccountname -- 还款账户名
            ,repayaccountbankname -- 还款账户开户机构
            ,bankcontriratio -- 银行出资比例
            ,totalterms -- 借据还款计划总期数
            ,curterms -- 当前期数
            ,unclearperiods -- 未结清期数
            ,businessstatus -- 借据状态
            ,finishdate -- 借据结清日期
            ,putoutdate -- 发放日期
            ,maturity -- 借据到期日
            ,creditchannel -- 授信渠道
            ,intnalloantype -- 行内贷款类型代码
            ,acrunonacru -- 应计非应计代码
            ,intsetway -- 结息方式代码
            ,intaccrway -- 计息方式代码
            ,intratfloatway -- 利率浮动方式代码
            ,intratfloatdir -- 利率浮动方向代码
            ,accountflag -- 记账标志
            ,intrat -- 固收利率
            ,tdacruint -- 当日应计利息
            ,intoverduedays -- 利息逾期天数
            ,intoverduedate -- 利息逾期日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhwd_business_duebill_his_op(
            bizdate -- 数据日期 批次日期 yyyyMMdd
            ,serialno -- 借据编号（第三方/行内）
            ,hxbdserialno -- 借据编号（行内）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,putoutserialno -- 出账编号
            ,contractserialno -- 业务合同编号
            ,applyno -- 全局流水号（第三方）
            ,businessmodel -- 业务模式（第三方）
            ,vouchtype -- 担保方式
            ,productid -- 产品编号（行内）
            ,productno -- 产品编号（第三方）
            ,businesssum -- 借据金额
            ,currency -- 借据币种
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,repaycycle -- 还款周期
            ,graceperiod -- 宽限期
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,executerate -- 执行利率
            ,rateadjusttype -- 执行利率调整方式
            ,rateadjustfrequency -- 执行利率调整周期
            ,floatrange -- 执行利率浮动点差BP
            ,overduedays -- 逾期天数
            ,overduedate -- 逾期日期
            ,overduerate -- 逾期利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动比例（%）
            ,compoundrate -- 复利利率
            ,dzhxstatus -- 核销标志
            ,wrndate -- 核销日期
            ,wrnpriamt -- 核销本金
            ,wrnintamt -- 核销利息
            ,balance -- 借据余额
            ,intamtbjbalance -- 正常本金余额
            ,intamtlxbalance -- 正常利息余额
            ,overduebjbalance -- 逾期本金余额
            ,overduelxbalance -- 逾期利息余额
            ,capitalpenaltybalance -- 罚息余额
            ,interestpenaltybalance -- 复息余额
            ,ysintamt -- 应收利息
            ,ysodpamt -- 应收罚息
            ,ysodiamt -- 应收复息
            ,reversalflag -- 冲正标志
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 贷款五级分类认定日期
            ,remart -- 计量标记-资产三分类
            ,repaytype -- 还款方式
            ,paymenttype -- 放款支付方式
            ,putoutorgid -- 出账机构编号(核心机构)
            ,paymentaccountno -- 入账账户
            ,paymentaccounttype -- 入账账户类型
            ,paymentaccountname -- 入账账户名
            ,paymentaccountbankname -- 入账账户开户机构
            ,repayaccountno -- 还款账号
            ,repayaccounttype -- 还款账户类型
            ,repayaccountname -- 还款账户名
            ,repayaccountbankname -- 还款账户开户机构
            ,bankcontriratio -- 银行出资比例
            ,totalterms -- 借据还款计划总期数
            ,curterms -- 当前期数
            ,unclearperiods -- 未结清期数
            ,businessstatus -- 借据状态
            ,finishdate -- 借据结清日期
            ,putoutdate -- 发放日期
            ,maturity -- 借据到期日
            ,creditchannel -- 授信渠道
            ,intnalloantype -- 行内贷款类型代码
            ,acrunonacru -- 应计非应计代码
            ,intsetway -- 结息方式代码
            ,intaccrway -- 计息方式代码
            ,intratfloatway -- 利率浮动方式代码
            ,intratfloatdir -- 利率浮动方向代码
            ,accountflag -- 记账标志
            ,intrat -- 固收利率
            ,tdacruint -- 当日应计利息
            ,intoverduedays -- 利息逾期天数
            ,intoverduedate -- 利息逾期日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bizdate -- 数据日期 批次日期 yyyyMMdd
    ,o.serialno -- 借据编号（第三方/行内）
    ,o.hxbdserialno -- 借据编号（行内）
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.putoutserialno -- 出账编号
    ,o.contractserialno -- 业务合同编号
    ,o.applyno -- 全局流水号（第三方）
    ,o.businessmodel -- 业务模式（第三方）
    ,o.vouchtype -- 担保方式
    ,o.productid -- 产品编号（行内）
    ,o.productno -- 产品编号（第三方）
    ,o.businesssum -- 借据金额
    ,o.currency -- 借据币种
    ,o.termmonth -- 期限(月)
    ,o.termday -- 期限(天)
    ,o.repaycycle -- 还款周期
    ,o.graceperiod -- 宽限期
    ,o.baseratetype -- 基准利率类型
    ,o.baserate -- 基准利率
    ,o.executerate -- 执行利率
    ,o.rateadjusttype -- 执行利率调整方式
    ,o.rateadjustfrequency -- 执行利率调整周期
    ,o.floatrange -- 执行利率浮动点差BP
    ,o.overduedays -- 逾期天数
    ,o.overduedate -- 逾期日期
    ,o.overduerate -- 逾期利率
    ,o.overdueratefloattype -- 逾期利率浮动方式
    ,o.overdueratefloatvalue -- 逾期利率浮动比例（%）
    ,o.compoundrate -- 复利利率
    ,o.dzhxstatus -- 核销标志
    ,o.wrndate -- 核销日期
    ,o.wrnpriamt -- 核销本金
    ,o.wrnintamt -- 核销利息
    ,o.balance -- 借据余额
    ,o.intamtbjbalance -- 正常本金余额
    ,o.intamtlxbalance -- 正常利息余额
    ,o.overduebjbalance -- 逾期本金余额
    ,o.overduelxbalance -- 逾期利息余额
    ,o.capitalpenaltybalance -- 罚息余额
    ,o.interestpenaltybalance -- 复息余额
    ,o.ysintamt -- 应收利息
    ,o.ysodpamt -- 应收罚息
    ,o.ysodiamt -- 应收复息
    ,o.reversalflag -- 冲正标志
    ,o.classifyresult -- 贷款五级分类
    ,o.classifydate -- 贷款五级分类认定日期
    ,o.remart -- 计量标记-资产三分类
    ,o.repaytype -- 还款方式
    ,o.paymenttype -- 放款支付方式
    ,o.putoutorgid -- 出账机构编号(核心机构)
    ,o.paymentaccountno -- 入账账户
    ,o.paymentaccounttype -- 入账账户类型
    ,o.paymentaccountname -- 入账账户名
    ,o.paymentaccountbankname -- 入账账户开户机构
    ,o.repayaccountno -- 还款账号
    ,o.repayaccounttype -- 还款账户类型
    ,o.repayaccountname -- 还款账户名
    ,o.repayaccountbankname -- 还款账户开户机构
    ,o.bankcontriratio -- 银行出资比例
    ,o.totalterms -- 借据还款计划总期数
    ,o.curterms -- 当前期数
    ,o.unclearperiods -- 未结清期数
    ,o.businessstatus -- 借据状态
    ,o.finishdate -- 借据结清日期
    ,o.putoutdate -- 发放日期
    ,o.maturity -- 借据到期日
    ,o.creditchannel -- 授信渠道
    ,o.intnalloantype -- 行内贷款类型代码
    ,o.acrunonacru -- 应计非应计代码
    ,o.intsetway -- 结息方式代码
    ,o.intaccrway -- 计息方式代码
    ,o.intratfloatway -- 利率浮动方式代码
    ,o.intratfloatdir -- 利率浮动方向代码
    ,o.accountflag -- 记账标志
    ,o.intrat -- 固收利率
    ,o.tdacruint -- 当日应计利息
    ,o.intoverduedays -- 利息逾期天数
    ,o.intoverduedate -- 利息逾期日期
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
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
from ${iol_schema}.icms_lhwd_business_duebill_his_bk o
    left join ${iol_schema}.icms_lhwd_business_duebill_his_op n
        on
            o.bizdate = n.bizdate
            and o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lhwd_business_duebill_his_cl d
        on
            o.bizdate = d.bizdate
            and o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_lhwd_business_duebill_his;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lhwd_business_duebill_his') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lhwd_business_duebill_his drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lhwd_business_duebill_his add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lhwd_business_duebill_his exchange partition p_${batch_date} with table ${iol_schema}.icms_lhwd_business_duebill_his_cl;
alter table ${iol_schema}.icms_lhwd_business_duebill_his exchange partition p_20991231 with table ${iol_schema}.icms_lhwd_business_duebill_his_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lhwd_business_duebill_his to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhwd_business_duebill_his_op purge;
drop table ${iol_schema}.icms_lhwd_business_duebill_his_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lhwd_business_duebill_his_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lhwd_business_duebill_his',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
