/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lhwd_business_putout
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
create table ${iol_schema}.icms_lhwd_business_putout_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lhwd_business_putout
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhwd_business_putout_op purge;
drop table ${iol_schema}.icms_lhwd_business_putout_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_business_putout_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhwd_business_putout where 0=1;

create table ${iol_schema}.icms_lhwd_business_putout_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhwd_business_putout where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lhwd_business_putout_cl(
            serialno -- 流水号
            ,relacontractno -- 关联合同编号
            ,thirdrequestno -- 放款请求流水号（第三方）
            ,thirdduebillserialno -- 借据号（第三方）
            ,applyno -- 全局流水号（第三方）
            ,businessmodel -- 业务模式（第三方）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,currency -- 币种
            ,businesssum -- 出账金额
            ,putoutdate -- 出账日期
            ,putouttime -- 放款时间
            ,bizdate -- 业务日期
            ,productid -- 产品编号（行内）
            ,productno -- 产品编号（第三方）
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 贷款开始日期
            ,maturity -- 贷款到期日期
            ,iscycle -- 循环标志
            ,vouchtype -- 担保方式
            ,repaytype -- 还款方式
            ,paymenttype -- 支付方式
            ,nationalindustrytype -- 贷款投向行业
            ,loanusetype -- 贷款用途
            ,repaycycle -- 还款周期
            ,graceperiod -- 宽限期
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,executerate -- 执行利率
            ,bankcontriratio -- 银行出资比例
            ,rateadjusttype -- 执行利率调整方式
            ,rateadjustfrequency -- 执行利率调整周期
            ,floatrange -- 执行利率浮动点差BP
            ,overduerate -- 逾期利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动比例（%）
            ,bankreservephone -- 银行卡预留手机号
            ,paymentaccountno -- 入账账户
            ,paymentaccountname -- 入账账户名
            ,paymentaccountbankname -- 入账账户开户机构
            ,paymentaccounttype -- 入账账户类型
            ,repayaccountno -- 还款账号
            ,repayaccounttype -- 还款账户类型
            ,repayaccountname -- 还款账户名
            ,repayaccountbankname -- 还款账户开户机构
            ,putoutorgid -- 出账机构编号(核心机构)
            ,approvestatus -- 审批状态
            ,putoutstatus -- 出账状态
            ,transcationno -- 清算交易编号
            ,creditchannel -- 授信渠道
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhwd_business_putout_op(
            serialno -- 流水号
            ,relacontractno -- 关联合同编号
            ,thirdrequestno -- 放款请求流水号（第三方）
            ,thirdduebillserialno -- 借据号（第三方）
            ,applyno -- 全局流水号（第三方）
            ,businessmodel -- 业务模式（第三方）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,currency -- 币种
            ,businesssum -- 出账金额
            ,putoutdate -- 出账日期
            ,putouttime -- 放款时间
            ,bizdate -- 业务日期
            ,productid -- 产品编号（行内）
            ,productno -- 产品编号（第三方）
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 贷款开始日期
            ,maturity -- 贷款到期日期
            ,iscycle -- 循环标志
            ,vouchtype -- 担保方式
            ,repaytype -- 还款方式
            ,paymenttype -- 支付方式
            ,nationalindustrytype -- 贷款投向行业
            ,loanusetype -- 贷款用途
            ,repaycycle -- 还款周期
            ,graceperiod -- 宽限期
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,executerate -- 执行利率
            ,bankcontriratio -- 银行出资比例
            ,rateadjusttype -- 执行利率调整方式
            ,rateadjustfrequency -- 执行利率调整周期
            ,floatrange -- 执行利率浮动点差BP
            ,overduerate -- 逾期利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动比例（%）
            ,bankreservephone -- 银行卡预留手机号
            ,paymentaccountno -- 入账账户
            ,paymentaccountname -- 入账账户名
            ,paymentaccountbankname -- 入账账户开户机构
            ,paymentaccounttype -- 入账账户类型
            ,repayaccountno -- 还款账号
            ,repayaccounttype -- 还款账户类型
            ,repayaccountname -- 还款账户名
            ,repayaccountbankname -- 还款账户开户机构
            ,putoutorgid -- 出账机构编号(核心机构)
            ,approvestatus -- 审批状态
            ,putoutstatus -- 出账状态
            ,transcationno -- 清算交易编号
            ,creditchannel -- 授信渠道
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.relacontractno, o.relacontractno) as relacontractno -- 关联合同编号
    ,nvl(n.thirdrequestno, o.thirdrequestno) as thirdrequestno -- 放款请求流水号（第三方）
    ,nvl(n.thirdduebillserialno, o.thirdduebillserialno) as thirdduebillserialno -- 借据号（第三方）
    ,nvl(n.applyno, o.applyno) as applyno -- 全局流水号（第三方）
    ,nvl(n.businessmodel, o.businessmodel) as businessmodel -- 业务模式（第三方）
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 出账金额
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 出账日期
    ,nvl(n.putouttime, o.putouttime) as putouttime -- 放款时间
    ,nvl(n.bizdate, o.bizdate) as bizdate -- 业务日期
    ,nvl(n.productid, o.productid) as productid -- 产品编号（行内）
    ,nvl(n.productno, o.productno) as productno -- 产品编号（第三方）
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限(月)
    ,nvl(n.termday, o.termday) as termday -- 期限(天)
    ,nvl(n.startdate, o.startdate) as startdate -- 贷款开始日期
    ,nvl(n.maturity, o.maturity) as maturity -- 贷款到期日期
    ,nvl(n.iscycle, o.iscycle) as iscycle -- 循环标志
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 担保方式
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式
    ,nvl(n.nationalindustrytype, o.nationalindustrytype) as nationalindustrytype -- 贷款投向行业
    ,nvl(n.loanusetype, o.loanusetype) as loanusetype -- 贷款用途
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 还款周期
    ,nvl(n.graceperiod, o.graceperiod) as graceperiod -- 宽限期
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.executerate, o.executerate) as executerate -- 执行利率
    ,nvl(n.bankcontriratio, o.bankcontriratio) as bankcontriratio -- 银行出资比例
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 执行利率调整方式
    ,nvl(n.rateadjustfrequency, o.rateadjustfrequency) as rateadjustfrequency -- 执行利率调整周期
    ,nvl(n.floatrange, o.floatrange) as floatrange -- 执行利率浮动点差BP
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期利率
    ,nvl(n.overdueratefloattype, o.overdueratefloattype) as overdueratefloattype -- 逾期利率浮动方式
    ,nvl(n.overdueratefloatvalue, o.overdueratefloatvalue) as overdueratefloatvalue -- 逾期利率浮动比例（%）
    ,nvl(n.bankreservephone, o.bankreservephone) as bankreservephone -- 银行卡预留手机号
    ,nvl(n.paymentaccountno, o.paymentaccountno) as paymentaccountno -- 入账账户
    ,nvl(n.paymentaccountname, o.paymentaccountname) as paymentaccountname -- 入账账户名
    ,nvl(n.paymentaccountbankname, o.paymentaccountbankname) as paymentaccountbankname -- 入账账户开户机构
    ,nvl(n.paymentaccounttype, o.paymentaccounttype) as paymentaccounttype -- 入账账户类型
    ,nvl(n.repayaccountno, o.repayaccountno) as repayaccountno -- 还款账号
    ,nvl(n.repayaccounttype, o.repayaccounttype) as repayaccounttype -- 还款账户类型
    ,nvl(n.repayaccountname, o.repayaccountname) as repayaccountname -- 还款账户名
    ,nvl(n.repayaccountbankname, o.repayaccountbankname) as repayaccountbankname -- 还款账户开户机构
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 出账机构编号(核心机构)
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.putoutstatus, o.putoutstatus) as putoutstatus -- 出账状态
    ,nvl(n.transcationno, o.transcationno) as transcationno -- 清算交易编号
    ,nvl(n.creditchannel, o.creditchannel) as creditchannel -- 授信渠道
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
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
from (select * from ${iol_schema}.icms_lhwd_business_putout_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lhwd_business_putout where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.relacontractno <> n.relacontractno
        or o.thirdrequestno <> n.thirdrequestno
        or o.thirdduebillserialno <> n.thirdduebillserialno
        or o.applyno <> n.applyno
        or o.businessmodel <> n.businessmodel
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.currency <> n.currency
        or o.businesssum <> n.businesssum
        or o.putoutdate <> n.putoutdate
        or o.putouttime <> n.putouttime
        or o.bizdate <> n.bizdate
        or o.productid <> n.productid
        or o.productno <> n.productno
        or o.termmonth <> n.termmonth
        or o.termday <> n.termday
        or o.startdate <> n.startdate
        or o.maturity <> n.maturity
        or o.iscycle <> n.iscycle
        or o.vouchtype <> n.vouchtype
        or o.repaytype <> n.repaytype
        or o.paymenttype <> n.paymenttype
        or o.nationalindustrytype <> n.nationalindustrytype
        or o.loanusetype <> n.loanusetype
        or o.repaycycle <> n.repaycycle
        or o.graceperiod <> n.graceperiod
        or o.baseratetype <> n.baseratetype
        or o.baserate <> n.baserate
        or o.executerate <> n.executerate
        or o.bankcontriratio <> n.bankcontriratio
        or o.rateadjusttype <> n.rateadjusttype
        or o.rateadjustfrequency <> n.rateadjustfrequency
        or o.floatrange <> n.floatrange
        or o.overduerate <> n.overduerate
        or o.overdueratefloattype <> n.overdueratefloattype
        or o.overdueratefloatvalue <> n.overdueratefloatvalue
        or o.bankreservephone <> n.bankreservephone
        or o.paymentaccountno <> n.paymentaccountno
        or o.paymentaccountname <> n.paymentaccountname
        or o.paymentaccountbankname <> n.paymentaccountbankname
        or o.paymentaccounttype <> n.paymentaccounttype
        or o.repayaccountno <> n.repayaccountno
        or o.repayaccounttype <> n.repayaccounttype
        or o.repayaccountname <> n.repayaccountname
        or o.repayaccountbankname <> n.repayaccountbankname
        or o.putoutorgid <> n.putoutorgid
        or o.approvestatus <> n.approvestatus
        or o.putoutstatus <> n.putoutstatus
        or o.transcationno <> n.transcationno
        or o.creditchannel <> n.creditchannel
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
        into ${iol_schema}.icms_lhwd_business_putout_cl(
            serialno -- 流水号
            ,relacontractno -- 关联合同编号
            ,thirdrequestno -- 放款请求流水号（第三方）
            ,thirdduebillserialno -- 借据号（第三方）
            ,applyno -- 全局流水号（第三方）
            ,businessmodel -- 业务模式（第三方）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,currency -- 币种
            ,businesssum -- 出账金额
            ,putoutdate -- 出账日期
            ,putouttime -- 放款时间
            ,bizdate -- 业务日期
            ,productid -- 产品编号（行内）
            ,productno -- 产品编号（第三方）
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 贷款开始日期
            ,maturity -- 贷款到期日期
            ,iscycle -- 循环标志
            ,vouchtype -- 担保方式
            ,repaytype -- 还款方式
            ,paymenttype -- 支付方式
            ,nationalindustrytype -- 贷款投向行业
            ,loanusetype -- 贷款用途
            ,repaycycle -- 还款周期
            ,graceperiod -- 宽限期
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,executerate -- 执行利率
            ,bankcontriratio -- 银行出资比例
            ,rateadjusttype -- 执行利率调整方式
            ,rateadjustfrequency -- 执行利率调整周期
            ,floatrange -- 执行利率浮动点差BP
            ,overduerate -- 逾期利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动比例（%）
            ,bankreservephone -- 银行卡预留手机号
            ,paymentaccountno -- 入账账户
            ,paymentaccountname -- 入账账户名
            ,paymentaccountbankname -- 入账账户开户机构
            ,paymentaccounttype -- 入账账户类型
            ,repayaccountno -- 还款账号
            ,repayaccounttype -- 还款账户类型
            ,repayaccountname -- 还款账户名
            ,repayaccountbankname -- 还款账户开户机构
            ,putoutorgid -- 出账机构编号(核心机构)
            ,approvestatus -- 审批状态
            ,putoutstatus -- 出账状态
            ,transcationno -- 清算交易编号
            ,creditchannel -- 授信渠道
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhwd_business_putout_op(
            serialno -- 流水号
            ,relacontractno -- 关联合同编号
            ,thirdrequestno -- 放款请求流水号（第三方）
            ,thirdduebillserialno -- 借据号（第三方）
            ,applyno -- 全局流水号（第三方）
            ,businessmodel -- 业务模式（第三方）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,currency -- 币种
            ,businesssum -- 出账金额
            ,putoutdate -- 出账日期
            ,putouttime -- 放款时间
            ,bizdate -- 业务日期
            ,productid -- 产品编号（行内）
            ,productno -- 产品编号（第三方）
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 贷款开始日期
            ,maturity -- 贷款到期日期
            ,iscycle -- 循环标志
            ,vouchtype -- 担保方式
            ,repaytype -- 还款方式
            ,paymenttype -- 支付方式
            ,nationalindustrytype -- 贷款投向行业
            ,loanusetype -- 贷款用途
            ,repaycycle -- 还款周期
            ,graceperiod -- 宽限期
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,executerate -- 执行利率
            ,bankcontriratio -- 银行出资比例
            ,rateadjusttype -- 执行利率调整方式
            ,rateadjustfrequency -- 执行利率调整周期
            ,floatrange -- 执行利率浮动点差BP
            ,overduerate -- 逾期利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动比例（%）
            ,bankreservephone -- 银行卡预留手机号
            ,paymentaccountno -- 入账账户
            ,paymentaccountname -- 入账账户名
            ,paymentaccountbankname -- 入账账户开户机构
            ,paymentaccounttype -- 入账账户类型
            ,repayaccountno -- 还款账号
            ,repayaccounttype -- 还款账户类型
            ,repayaccountname -- 还款账户名
            ,repayaccountbankname -- 还款账户开户机构
            ,putoutorgid -- 出账机构编号(核心机构)
            ,approvestatus -- 审批状态
            ,putoutstatus -- 出账状态
            ,transcationno -- 清算交易编号
            ,creditchannel -- 授信渠道
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.relacontractno -- 关联合同编号
    ,o.thirdrequestno -- 放款请求流水号（第三方）
    ,o.thirdduebillserialno -- 借据号（第三方）
    ,o.applyno -- 全局流水号（第三方）
    ,o.businessmodel -- 业务模式（第三方）
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.currency -- 币种
    ,o.businesssum -- 出账金额
    ,o.putoutdate -- 出账日期
    ,o.putouttime -- 放款时间
    ,o.bizdate -- 业务日期
    ,o.productid -- 产品编号（行内）
    ,o.productno -- 产品编号（第三方）
    ,o.termmonth -- 期限(月)
    ,o.termday -- 期限(天)
    ,o.startdate -- 贷款开始日期
    ,o.maturity -- 贷款到期日期
    ,o.iscycle -- 循环标志
    ,o.vouchtype -- 担保方式
    ,o.repaytype -- 还款方式
    ,o.paymenttype -- 支付方式
    ,o.nationalindustrytype -- 贷款投向行业
    ,o.loanusetype -- 贷款用途
    ,o.repaycycle -- 还款周期
    ,o.graceperiod -- 宽限期
    ,o.baseratetype -- 基准利率类型
    ,o.baserate -- 基准利率
    ,o.executerate -- 执行利率
    ,o.bankcontriratio -- 银行出资比例
    ,o.rateadjusttype -- 执行利率调整方式
    ,o.rateadjustfrequency -- 执行利率调整周期
    ,o.floatrange -- 执行利率浮动点差BP
    ,o.overduerate -- 逾期利率
    ,o.overdueratefloattype -- 逾期利率浮动方式
    ,o.overdueratefloatvalue -- 逾期利率浮动比例（%）
    ,o.bankreservephone -- 银行卡预留手机号
    ,o.paymentaccountno -- 入账账户
    ,o.paymentaccountname -- 入账账户名
    ,o.paymentaccountbankname -- 入账账户开户机构
    ,o.paymentaccounttype -- 入账账户类型
    ,o.repayaccountno -- 还款账号
    ,o.repayaccounttype -- 还款账户类型
    ,o.repayaccountname -- 还款账户名
    ,o.repayaccountbankname -- 还款账户开户机构
    ,o.putoutorgid -- 出账机构编号(核心机构)
    ,o.approvestatus -- 审批状态
    ,o.putoutstatus -- 出账状态
    ,o.transcationno -- 清算交易编号
    ,o.creditchannel -- 授信渠道
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新时间
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
from ${iol_schema}.icms_lhwd_business_putout_bk o
    left join ${iol_schema}.icms_lhwd_business_putout_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lhwd_business_putout_cl d
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
--truncate table ${iol_schema}.icms_lhwd_business_putout;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lhwd_business_putout') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lhwd_business_putout drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lhwd_business_putout add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lhwd_business_putout exchange partition p_${batch_date} with table ${iol_schema}.icms_lhwd_business_putout_cl;
alter table ${iol_schema}.icms_lhwd_business_putout exchange partition p_20991231 with table ${iol_schema}.icms_lhwd_business_putout_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lhwd_business_putout to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhwd_business_putout_op purge;
drop table ${iol_schema}.icms_lhwd_business_putout_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lhwd_business_putout_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lhwd_business_putout',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
