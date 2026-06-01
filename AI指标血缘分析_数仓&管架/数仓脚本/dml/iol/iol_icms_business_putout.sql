/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_business_putout
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
create table ${iol_schema}.icms_business_putout_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_business_putout
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_putout_op purge;
drop table ${iol_schema}.icms_business_putout_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_putout_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_putout where 0=1;

create table ${iol_schema}.icms_business_putout_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_putout where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_putout_cl(
            serialno -- 出账流水号
            ,executerate -- 执行利率
            ,repaycycle -- 还款周期
            ,pigeonholedate -- 归档日期
            ,gainamount -- 递变幅度
            ,productid -- 产品编号
            ,purpose -- 贷款用途(手输描述)
            ,pdgpaymethod -- 手续费收取方式
            ,repaydate -- 默认还款日
            ,customerid -- 客户编号
            ,loanaccountnosub -- 贷款入账账号(收款账户)子户号
            ,baserate -- 基准利率
            ,policyid -- 政策编号
            ,occurdate -- 发生日期
            ,paymenttype -- 支付方式
            ,completeflag -- 数据录入完整性标识
            ,inputuserid -- 登记人
            ,subjectno -- 科目代码
            ,putoutorgid -- 出账机构编号(核心机构)
            ,applytype -- 申请类型
            ,approvestatus -- 审批状态
            ,updateuserid -- 更新人
            ,customername -- 客户名称
            ,rateadjustfrequency -- 利率调整周期
            ,putoutdate -- 起息日
            ,updatedate -- 更新日期
            ,segterm -- 指定还款计算期限
            ,inputorgid -- 登记机构
            ,flowtype -- 流程类型
            ,exchangetime -- 交易时间
            ,offsheetflag -- 表内外标志
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,pdgsum -- 手续费金额(元)
            ,jxhjduebillno -- 借新还旧借据号
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,pdgaccountno -- 手续费扣费账户
            ,zftransserialno -- 受托支付止付流水号
            ,contractserialno -- 合同编号
            ,interestrepaycycle -- 结息方式
            ,exchangestate -- 交易状态
            ,bpspreads -- 合同点差
            ,fixedrate -- 固定利率
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,remark -- 备注
            ,ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
            ,ratefloattype -- 利率浮动类型浮动利率类型
            ,islowrisk -- 是否低风险
            ,lendingorgid -- 贷款机构编号(核心机构)
            ,commissionpaysum -- 受托支付金额
            ,clno -- 额度编号
            ,segrptamount -- 指定区段拟还本金金额
            ,bailratio -- 保证金比例(%)
            ,transserialno -- 核心交易流水号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,repaytype -- 还款方式
            ,overduerate -- 逾期执行利率
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,termmonth -- 期限月
            ,maturity -- 到期日
            ,gaincyc -- 递变周期
            ,loanaccountno -- 贷款入账账号
            ,operateuserid -- 经办人
            ,contractsum -- 合同金额
            ,bailtransaccount -- 保证金转出账号
            ,operatedate -- 经办日期
            ,corporgid -- 法人机构编号
            ,currency -- 币种
            ,artificialno -- 文本合同编号
            ,bailsum -- 保证金金额
            ,vouchtype -- 主要担保方式
            ,transdate -- 核心交易日期
            ,secondpayaccount -- 第二还款账号
            ,bailsubaccount -- 保证金子户号
            ,putoutcontrol -- 到日期超批复半年设置，1允许，0禁止
            ,termday -- 期限天
            ,businesssum -- 本次放款金额
            ,occurtype -- 发生类型
            ,operateorgid -- 经办机构
            ,inputdate -- 登记日期
            ,bailaccount -- 保证金账号
            ,bailcurrency -- 保证金币种
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountbankname -- 结算账户(还款账户)开户行
            ,baseratetype -- 基准利率类型
            ,updateorgid -- 更新机构
            ,pdgamorfg -- 手续费是否摊销
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,belongdept -- 所属条线
            ,policyversionid -- 政策版本编号
            ,settlementaccount -- 结算账号(还款账户)
            ,loanusetype -- 借款用途类型
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,duebillserialno -- 借据号
            ,pdgpaypercent -- 手续费率
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,remart -- 计量标记InvestGroup
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,cashconcenaccount -- 资金归集账户
            ,ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
            ,entscale -- 企业规模
            ,isfirstloans -- 是否首次放款-YesNo
            ,ispensionindustry -- 养老产业标识
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,hangseqno -- 挂账账户序列号
            ,relacontractno -- 占用承兑行额度编号
            ,nextsettlementdate -- 下一结息日
            ,lprrefertype -- LPR参照方式
            ,othcustomername -- 对手客户名称
            ,othcustomerid -- 对手客户编号
            ,subproductname -- 子产品名称
            ,renewaltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_putout_op(
            serialno -- 出账流水号
            ,executerate -- 执行利率
            ,repaycycle -- 还款周期
            ,pigeonholedate -- 归档日期
            ,gainamount -- 递变幅度
            ,productid -- 产品编号
            ,purpose -- 贷款用途(手输描述)
            ,pdgpaymethod -- 手续费收取方式
            ,repaydate -- 默认还款日
            ,customerid -- 客户编号
            ,loanaccountnosub -- 贷款入账账号(收款账户)子户号
            ,baserate -- 基准利率
            ,policyid -- 政策编号
            ,occurdate -- 发生日期
            ,paymenttype -- 支付方式
            ,completeflag -- 数据录入完整性标识
            ,inputuserid -- 登记人
            ,subjectno -- 科目代码
            ,putoutorgid -- 出账机构编号(核心机构)
            ,applytype -- 申请类型
            ,approvestatus -- 审批状态
            ,updateuserid -- 更新人
            ,customername -- 客户名称
            ,rateadjustfrequency -- 利率调整周期
            ,putoutdate -- 起息日
            ,updatedate -- 更新日期
            ,segterm -- 指定还款计算期限
            ,inputorgid -- 登记机构
            ,flowtype -- 流程类型
            ,exchangetime -- 交易时间
            ,offsheetflag -- 表内外标志
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,pdgsum -- 手续费金额(元)
            ,jxhjduebillno -- 借新还旧借据号
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,pdgaccountno -- 手续费扣费账户
            ,zftransserialno -- 受托支付止付流水号
            ,contractserialno -- 合同编号
            ,interestrepaycycle -- 结息方式
            ,exchangestate -- 交易状态
            ,bpspreads -- 合同点差
            ,fixedrate -- 固定利率
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,remark -- 备注
            ,ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
            ,ratefloattype -- 利率浮动类型浮动利率类型
            ,islowrisk -- 是否低风险
            ,lendingorgid -- 贷款机构编号(核心机构)
            ,commissionpaysum -- 受托支付金额
            ,clno -- 额度编号
            ,segrptamount -- 指定区段拟还本金金额
            ,bailratio -- 保证金比例(%)
            ,transserialno -- 核心交易流水号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,repaytype -- 还款方式
            ,overduerate -- 逾期执行利率
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,termmonth -- 期限月
            ,maturity -- 到期日
            ,gaincyc -- 递变周期
            ,loanaccountno -- 贷款入账账号
            ,operateuserid -- 经办人
            ,contractsum -- 合同金额
            ,bailtransaccount -- 保证金转出账号
            ,operatedate -- 经办日期
            ,corporgid -- 法人机构编号
            ,currency -- 币种
            ,artificialno -- 文本合同编号
            ,bailsum -- 保证金金额
            ,vouchtype -- 主要担保方式
            ,transdate -- 核心交易日期
            ,secondpayaccount -- 第二还款账号
            ,bailsubaccount -- 保证金子户号
            ,putoutcontrol -- 到日期超批复半年设置，1允许，0禁止
            ,termday -- 期限天
            ,businesssum -- 本次放款金额
            ,occurtype -- 发生类型
            ,operateorgid -- 经办机构
            ,inputdate -- 登记日期
            ,bailaccount -- 保证金账号
            ,bailcurrency -- 保证金币种
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountbankname -- 结算账户(还款账户)开户行
            ,baseratetype -- 基准利率类型
            ,updateorgid -- 更新机构
            ,pdgamorfg -- 手续费是否摊销
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,belongdept -- 所属条线
            ,policyversionid -- 政策版本编号
            ,settlementaccount -- 结算账号(还款账户)
            ,loanusetype -- 借款用途类型
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,duebillserialno -- 借据号
            ,pdgpaypercent -- 手续费率
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,remart -- 计量标记InvestGroup
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,cashconcenaccount -- 资金归集账户
            ,ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
            ,entscale -- 企业规模
            ,isfirstloans -- 是否首次放款-YesNo
            ,ispensionindustry -- 养老产业标识
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,hangseqno -- 挂账账户序列号
            ,relacontractno -- 占用承兑行额度编号
            ,nextsettlementdate -- 下一结息日
            ,lprrefertype -- LPR参照方式
            ,othcustomername -- 对手客户名称
            ,othcustomerid -- 对手客户编号
            ,subproductname -- 子产品名称
            ,renewaltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 出账流水号
    ,nvl(n.executerate, o.executerate) as executerate -- 执行利率
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 还款周期
    ,nvl(n.pigeonholedate, o.pigeonholedate) as pigeonholedate -- 归档日期
    ,nvl(n.gainamount, o.gainamount) as gainamount -- 递变幅度
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.purpose, o.purpose) as purpose -- 贷款用途(手输描述)
    ,nvl(n.pdgpaymethod, o.pdgpaymethod) as pdgpaymethod -- 手续费收取方式
    ,nvl(n.repaydate, o.repaydate) as repaydate -- 默认还款日
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.loanaccountnosub, o.loanaccountnosub) as loanaccountnosub -- 贷款入账账号(收款账户)子户号
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.policyid, o.policyid) as policyid -- 政策编号
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 发生日期
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 数据录入完整性标识
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.subjectno, o.subjectno) as subjectno -- 科目代码
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 出账机构编号(核心机构)
    ,nvl(n.applytype, o.applytype) as applytype -- 申请类型
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.rateadjustfrequency, o.rateadjustfrequency) as rateadjustfrequency -- 利率调整周期
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 起息日
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.segterm, o.segterm) as segterm -- 指定还款计算期限
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.flowtype, o.flowtype) as flowtype -- 流程类型
    ,nvl(n.exchangetime, o.exchangetime) as exchangetime -- 交易时间
    ,nvl(n.offsheetflag, o.offsheetflag) as offsheetflag -- 表内外标志
    ,nvl(n.overdueratefloatvalue, o.overdueratefloatvalue) as overdueratefloatvalue -- 逾期利率浮动值
    ,nvl(n.pdgsum, o.pdgsum) as pdgsum -- 手续费金额(元)
    ,nvl(n.jxhjduebillno, o.jxhjduebillno) as jxhjduebillno -- 借新还旧借据号
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
    ,nvl(n.pdgaccountno, o.pdgaccountno) as pdgaccountno -- 手续费扣费账户
    ,nvl(n.zftransserialno, o.zftransserialno) as zftransserialno -- 受托支付止付流水号
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 合同编号
    ,nvl(n.interestrepaycycle, o.interestrepaycycle) as interestrepaycycle -- 结息方式
    ,nvl(n.exchangestate, o.exchangestate) as exchangestate -- 交易状态
    ,nvl(n.bpspreads, o.bpspreads) as bpspreads -- 合同点差
    ,nvl(n.fixedrate, o.fixedrate) as fixedrate -- 固定利率
    ,nvl(n.floatrange, o.floatrange) as floatrange -- 浮动幅度
    ,nvl(n.overdueratefloattype, o.overdueratefloattype) as overdueratefloattype -- 逾期利率浮动方式
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.ratemodel, o.ratemodel) as ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
    ,nvl(n.ratefloattype, o.ratefloattype) as ratefloattype -- 利率浮动类型浮动利率类型
    ,nvl(n.islowrisk, o.islowrisk) as islowrisk -- 是否低风险
    ,nvl(n.lendingorgid, o.lendingorgid) as lendingorgid -- 贷款机构编号(核心机构)
    ,nvl(n.commissionpaysum, o.commissionpaysum) as commissionpaysum -- 受托支付金额
    ,nvl(n.clno, o.clno) as clno -- 额度编号
    ,nvl(n.segrptamount, o.segrptamount) as segrptamount -- 指定区段拟还本金金额
    ,nvl(n.bailratio, o.bailratio) as bailratio -- 保证金比例(%)
    ,nvl(n.transserialno, o.transserialno) as transserialno -- 核心交易流水号
    ,nvl(n.payfrequencyunit, o.payfrequencyunit) as payfrequencyunit -- 指定周期单位
    ,nvl(n.payfrequency, o.payfrequency) as payfrequency -- 指定周期
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期执行利率
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限月
    ,nvl(n.maturity, o.maturity) as maturity -- 到期日
    ,nvl(n.gaincyc, o.gaincyc) as gaincyc -- 递变周期
    ,nvl(n.loanaccountno, o.loanaccountno) as loanaccountno -- 贷款入账账号
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办人
    ,nvl(n.contractsum, o.contractsum) as contractsum -- 合同金额
    ,nvl(n.bailtransaccount, o.bailtransaccount) as bailtransaccount -- 保证金转出账号
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 经办日期
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.artificialno, o.artificialno) as artificialno -- 文本合同编号
    ,nvl(n.bailsum, o.bailsum) as bailsum -- 保证金金额
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主要担保方式
    ,nvl(n.transdate, o.transdate) as transdate -- 核心交易日期
    ,nvl(n.secondpayaccount, o.secondpayaccount) as secondpayaccount -- 第二还款账号
    ,nvl(n.bailsubaccount, o.bailsubaccount) as bailsubaccount -- 保证金子户号
    ,nvl(n.putoutcontrol, o.putoutcontrol) as putoutcontrol -- 到日期超批复半年设置，1允许，0禁止
    ,nvl(n.termday, o.termday) as termday -- 期限天
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 本次放款金额
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 发生类型
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.bailaccount, o.bailaccount) as bailaccount -- 保证金账号
    ,nvl(n.bailcurrency, o.bailcurrency) as bailcurrency -- 保证金币种
    ,nvl(n.settlementaccountname, o.settlementaccountname) as settlementaccountname -- 结算账户(还款账户)名
    ,nvl(n.loanaccountbankname, o.loanaccountbankname) as loanaccountbankname -- 结算账户(还款账户)开户行
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.pdgamorfg, o.pdgamorfg) as pdgamorfg -- 手续费是否摊销
    ,nvl(n.loanaccountorgid, o.loanaccountorgid) as loanaccountorgid -- 贷款入账(收款账户)账户开户机构
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 所属条线
    ,nvl(n.policyversionid, o.policyversionid) as policyversionid -- 政策版本编号
    ,nvl(n.settlementaccount, o.settlementaccount) as settlementaccount -- 结算账号(还款账户)
    ,nvl(n.loanusetype, o.loanusetype) as loanusetype -- 借款用途类型
    ,nvl(n.loanaccountname, o.loanaccountname) as loanaccountname -- 贷款入账(收款账户)账户名
    ,nvl(n.duebillserialno, o.duebillserialno) as duebillserialno -- 借据号
    ,nvl(n.pdgpaypercent, o.pdgpaypercent) as pdgpaypercent -- 手续费率
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 迁移数据-参数转换前字段值
    ,nvl(n.remart, o.remart) as remart -- 计量标记InvestGroup
    ,nvl(n.ratefloatratioorbp, o.ratefloatratioorbp) as ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
    ,nvl(n.cashconcenaccount, o.cashconcenaccount) as cashconcenaccount -- 资金归集账户
    ,nvl(n.ecodepartmentcode, o.ecodepartmentcode) as ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
    ,nvl(n.entscale, o.entscale) as entscale -- 企业规模
    ,nvl(n.isfirstloans, o.isfirstloans) as isfirstloans -- 是否首次放款-YesNo
    ,nvl(n.ispensionindustry, o.ispensionindustry) as ispensionindustry -- 养老产业标识
    ,nvl(n.migtcustomerid, o.migtcustomerid) as migtcustomerid -- 转换前客户号
    ,nvl(n.migtbusinesstype, o.migtbusinesstype) as migtbusinesstype -- 转换前产品ID
    ,nvl(n.hangseqno, o.hangseqno) as hangseqno -- 挂账账户序列号
    ,nvl(n.relacontractno, o.relacontractno) as relacontractno -- 占用承兑行额度编号
    ,nvl(n.nextsettlementdate, o.nextsettlementdate) as nextsettlementdate -- 下一结息日
    ,nvl(n.lprrefertype, o.lprrefertype) as lprrefertype -- LPR参照方式
    ,nvl(n.othcustomername, o.othcustomername) as othcustomername -- 对手客户名称
    ,nvl(n.othcustomerid, o.othcustomerid) as othcustomerid -- 对手客户编号
    ,nvl(n.subproductname, o.subproductname) as subproductname -- 子产品名称
    ,nvl(n.renewaltype, o.renewaltype) as renewaltype -- 
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
from (select * from ${iol_schema}.icms_business_putout_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_business_putout where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.executerate <> n.executerate
        or o.repaycycle <> n.repaycycle
        or o.pigeonholedate <> n.pigeonholedate
        or o.gainamount <> n.gainamount
        or o.productid <> n.productid
        or o.purpose <> n.purpose
        or o.pdgpaymethod <> n.pdgpaymethod
        or o.repaydate <> n.repaydate
        or o.customerid <> n.customerid
        or o.loanaccountnosub <> n.loanaccountnosub
        or o.baserate <> n.baserate
        or o.policyid <> n.policyid
        or o.occurdate <> n.occurdate
        or o.paymenttype <> n.paymenttype
        or o.completeflag <> n.completeflag
        or o.inputuserid <> n.inputuserid
        or o.subjectno <> n.subjectno
        or o.putoutorgid <> n.putoutorgid
        or o.applytype <> n.applytype
        or o.approvestatus <> n.approvestatus
        or o.updateuserid <> n.updateuserid
        or o.customername <> n.customername
        or o.rateadjustfrequency <> n.rateadjustfrequency
        or o.putoutdate <> n.putoutdate
        or o.updatedate <> n.updatedate
        or o.segterm <> n.segterm
        or o.inputorgid <> n.inputorgid
        or o.flowtype <> n.flowtype
        or o.exchangetime <> n.exchangetime
        or o.offsheetflag <> n.offsheetflag
        or o.overdueratefloatvalue <> n.overdueratefloatvalue
        or o.pdgsum <> n.pdgsum
        or o.jxhjduebillno <> n.jxhjduebillno
        or o.rateadjusttype <> n.rateadjusttype
        or o.pdgaccountno <> n.pdgaccountno
        or o.zftransserialno <> n.zftransserialno
        or o.contractserialno <> n.contractserialno
        or o.interestrepaycycle <> n.interestrepaycycle
        or o.exchangestate <> n.exchangestate
        or o.bpspreads <> n.bpspreads
        or o.fixedrate <> n.fixedrate
        or o.floatrange <> n.floatrange
        or o.overdueratefloattype <> n.overdueratefloattype
        or o.remark <> n.remark
        or o.ratemodel <> n.ratemodel
        or o.ratefloattype <> n.ratefloattype
        or o.islowrisk <> n.islowrisk
        or o.lendingorgid <> n.lendingorgid
        or o.commissionpaysum <> n.commissionpaysum
        or o.clno <> n.clno
        or o.segrptamount <> n.segrptamount
        or o.bailratio <> n.bailratio
        or o.transserialno <> n.transserialno
        or o.payfrequencyunit <> n.payfrequencyunit
        or o.payfrequency <> n.payfrequency
        or o.repaytype <> n.repaytype
        or o.overduerate <> n.overduerate
        or o.migtflag <> n.migtflag
        or o.termmonth <> n.termmonth
        or o.maturity <> n.maturity
        or o.gaincyc <> n.gaincyc
        or o.loanaccountno <> n.loanaccountno
        or o.operateuserid <> n.operateuserid
        or o.contractsum <> n.contractsum
        or o.bailtransaccount <> n.bailtransaccount
        or o.operatedate <> n.operatedate
        or o.corporgid <> n.corporgid
        or o.currency <> n.currency
        or o.artificialno <> n.artificialno
        or o.bailsum <> n.bailsum
        or o.vouchtype <> n.vouchtype
        or o.transdate <> n.transdate
        or o.secondpayaccount <> n.secondpayaccount
        or o.bailsubaccount <> n.bailsubaccount
        or o.putoutcontrol <> n.putoutcontrol
        or o.termday <> n.termday
        or o.businesssum <> n.businesssum
        or o.occurtype <> n.occurtype
        or o.operateorgid <> n.operateorgid
        or o.inputdate <> n.inputdate
        or o.bailaccount <> n.bailaccount
        or o.bailcurrency <> n.bailcurrency
        or o.settlementaccountname <> n.settlementaccountname
        or o.loanaccountbankname <> n.loanaccountbankname
        or o.baseratetype <> n.baseratetype
        or o.updateorgid <> n.updateorgid
        or o.pdgamorfg <> n.pdgamorfg
        or o.loanaccountorgid <> n.loanaccountorgid
        or o.belongdept <> n.belongdept
        or o.policyversionid <> n.policyversionid
        or o.settlementaccount <> n.settlementaccount
        or o.loanusetype <> n.loanusetype
        or o.loanaccountname <> n.loanaccountname
        or o.duebillserialno <> n.duebillserialno
        or o.pdgpaypercent <> n.pdgpaypercent
        or o.migtoldvalue <> n.migtoldvalue
        or o.remart <> n.remart
        or o.ratefloatratioorbp <> n.ratefloatratioorbp
        or o.cashconcenaccount <> n.cashconcenaccount
        or o.ecodepartmentcode <> n.ecodepartmentcode
        or o.entscale <> n.entscale
        or o.isfirstloans <> n.isfirstloans
        or o.ispensionindustry <> n.ispensionindustry
        or o.migtcustomerid <> n.migtcustomerid
        or o.migtbusinesstype <> n.migtbusinesstype
        or o.hangseqno <> n.hangseqno
        or o.relacontractno <> n.relacontractno
        or o.nextsettlementdate <> n.nextsettlementdate
        or o.lprrefertype <> n.lprrefertype
        or o.othcustomername <> n.othcustomername
        or o.othcustomerid <> n.othcustomerid
        or o.subproductname <> n.subproductname
        or o.renewaltype <> n.renewaltype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_putout_cl(
            serialno -- 出账流水号
            ,executerate -- 执行利率
            ,repaycycle -- 还款周期
            ,pigeonholedate -- 归档日期
            ,gainamount -- 递变幅度
            ,productid -- 产品编号
            ,purpose -- 贷款用途(手输描述)
            ,pdgpaymethod -- 手续费收取方式
            ,repaydate -- 默认还款日
            ,customerid -- 客户编号
            ,loanaccountnosub -- 贷款入账账号(收款账户)子户号
            ,baserate -- 基准利率
            ,policyid -- 政策编号
            ,occurdate -- 发生日期
            ,paymenttype -- 支付方式
            ,completeflag -- 数据录入完整性标识
            ,inputuserid -- 登记人
            ,subjectno -- 科目代码
            ,putoutorgid -- 出账机构编号(核心机构)
            ,applytype -- 申请类型
            ,approvestatus -- 审批状态
            ,updateuserid -- 更新人
            ,customername -- 客户名称
            ,rateadjustfrequency -- 利率调整周期
            ,putoutdate -- 起息日
            ,updatedate -- 更新日期
            ,segterm -- 指定还款计算期限
            ,inputorgid -- 登记机构
            ,flowtype -- 流程类型
            ,exchangetime -- 交易时间
            ,offsheetflag -- 表内外标志
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,pdgsum -- 手续费金额(元)
            ,jxhjduebillno -- 借新还旧借据号
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,pdgaccountno -- 手续费扣费账户
            ,zftransserialno -- 受托支付止付流水号
            ,contractserialno -- 合同编号
            ,interestrepaycycle -- 结息方式
            ,exchangestate -- 交易状态
            ,bpspreads -- 合同点差
            ,fixedrate -- 固定利率
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,remark -- 备注
            ,ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
            ,ratefloattype -- 利率浮动类型浮动利率类型
            ,islowrisk -- 是否低风险
            ,lendingorgid -- 贷款机构编号(核心机构)
            ,commissionpaysum -- 受托支付金额
            ,clno -- 额度编号
            ,segrptamount -- 指定区段拟还本金金额
            ,bailratio -- 保证金比例(%)
            ,transserialno -- 核心交易流水号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,repaytype -- 还款方式
            ,overduerate -- 逾期执行利率
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,termmonth -- 期限月
            ,maturity -- 到期日
            ,gaincyc -- 递变周期
            ,loanaccountno -- 贷款入账账号
            ,operateuserid -- 经办人
            ,contractsum -- 合同金额
            ,bailtransaccount -- 保证金转出账号
            ,operatedate -- 经办日期
            ,corporgid -- 法人机构编号
            ,currency -- 币种
            ,artificialno -- 文本合同编号
            ,bailsum -- 保证金金额
            ,vouchtype -- 主要担保方式
            ,transdate -- 核心交易日期
            ,secondpayaccount -- 第二还款账号
            ,bailsubaccount -- 保证金子户号
            ,putoutcontrol -- 到日期超批复半年设置，1允许，0禁止
            ,termday -- 期限天
            ,businesssum -- 本次放款金额
            ,occurtype -- 发生类型
            ,operateorgid -- 经办机构
            ,inputdate -- 登记日期
            ,bailaccount -- 保证金账号
            ,bailcurrency -- 保证金币种
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountbankname -- 结算账户(还款账户)开户行
            ,baseratetype -- 基准利率类型
            ,updateorgid -- 更新机构
            ,pdgamorfg -- 手续费是否摊销
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,belongdept -- 所属条线
            ,policyversionid -- 政策版本编号
            ,settlementaccount -- 结算账号(还款账户)
            ,loanusetype -- 借款用途类型
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,duebillserialno -- 借据号
            ,pdgpaypercent -- 手续费率
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,remart -- 计量标记InvestGroup
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,cashconcenaccount -- 资金归集账户
            ,ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
            ,entscale -- 企业规模
            ,isfirstloans -- 是否首次放款-YesNo
            ,ispensionindustry -- 养老产业标识
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,hangseqno -- 挂账账户序列号
            ,relacontractno -- 占用承兑行额度编号
            ,nextsettlementdate -- 下一结息日
            ,lprrefertype -- LPR参照方式
            ,othcustomername -- 对手客户名称
            ,othcustomerid -- 对手客户编号
            ,subproductname -- 子产品名称
            ,renewaltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_putout_op(
            serialno -- 出账流水号
            ,executerate -- 执行利率
            ,repaycycle -- 还款周期
            ,pigeonholedate -- 归档日期
            ,gainamount -- 递变幅度
            ,productid -- 产品编号
            ,purpose -- 贷款用途(手输描述)
            ,pdgpaymethod -- 手续费收取方式
            ,repaydate -- 默认还款日
            ,customerid -- 客户编号
            ,loanaccountnosub -- 贷款入账账号(收款账户)子户号
            ,baserate -- 基准利率
            ,policyid -- 政策编号
            ,occurdate -- 发生日期
            ,paymenttype -- 支付方式
            ,completeflag -- 数据录入完整性标识
            ,inputuserid -- 登记人
            ,subjectno -- 科目代码
            ,putoutorgid -- 出账机构编号(核心机构)
            ,applytype -- 申请类型
            ,approvestatus -- 审批状态
            ,updateuserid -- 更新人
            ,customername -- 客户名称
            ,rateadjustfrequency -- 利率调整周期
            ,putoutdate -- 起息日
            ,updatedate -- 更新日期
            ,segterm -- 指定还款计算期限
            ,inputorgid -- 登记机构
            ,flowtype -- 流程类型
            ,exchangetime -- 交易时间
            ,offsheetflag -- 表内外标志
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,pdgsum -- 手续费金额(元)
            ,jxhjduebillno -- 借新还旧借据号
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,pdgaccountno -- 手续费扣费账户
            ,zftransserialno -- 受托支付止付流水号
            ,contractserialno -- 合同编号
            ,interestrepaycycle -- 结息方式
            ,exchangestate -- 交易状态
            ,bpspreads -- 合同点差
            ,fixedrate -- 固定利率
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,remark -- 备注
            ,ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
            ,ratefloattype -- 利率浮动类型浮动利率类型
            ,islowrisk -- 是否低风险
            ,lendingorgid -- 贷款机构编号(核心机构)
            ,commissionpaysum -- 受托支付金额
            ,clno -- 额度编号
            ,segrptamount -- 指定区段拟还本金金额
            ,bailratio -- 保证金比例(%)
            ,transserialno -- 核心交易流水号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,repaytype -- 还款方式
            ,overduerate -- 逾期执行利率
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,termmonth -- 期限月
            ,maturity -- 到期日
            ,gaincyc -- 递变周期
            ,loanaccountno -- 贷款入账账号
            ,operateuserid -- 经办人
            ,contractsum -- 合同金额
            ,bailtransaccount -- 保证金转出账号
            ,operatedate -- 经办日期
            ,corporgid -- 法人机构编号
            ,currency -- 币种
            ,artificialno -- 文本合同编号
            ,bailsum -- 保证金金额
            ,vouchtype -- 主要担保方式
            ,transdate -- 核心交易日期
            ,secondpayaccount -- 第二还款账号
            ,bailsubaccount -- 保证金子户号
            ,putoutcontrol -- 到日期超批复半年设置，1允许，0禁止
            ,termday -- 期限天
            ,businesssum -- 本次放款金额
            ,occurtype -- 发生类型
            ,operateorgid -- 经办机构
            ,inputdate -- 登记日期
            ,bailaccount -- 保证金账号
            ,bailcurrency -- 保证金币种
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountbankname -- 结算账户(还款账户)开户行
            ,baseratetype -- 基准利率类型
            ,updateorgid -- 更新机构
            ,pdgamorfg -- 手续费是否摊销
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,belongdept -- 所属条线
            ,policyversionid -- 政策版本编号
            ,settlementaccount -- 结算账号(还款账户)
            ,loanusetype -- 借款用途类型
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,duebillserialno -- 借据号
            ,pdgpaypercent -- 手续费率
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,remart -- 计量标记InvestGroup
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,cashconcenaccount -- 资金归集账户
            ,ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
            ,entscale -- 企业规模
            ,isfirstloans -- 是否首次放款-YesNo
            ,ispensionindustry -- 养老产业标识
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,hangseqno -- 挂账账户序列号
            ,relacontractno -- 占用承兑行额度编号
            ,nextsettlementdate -- 下一结息日
            ,lprrefertype -- LPR参照方式
            ,othcustomername -- 对手客户名称
            ,othcustomerid -- 对手客户编号
            ,subproductname -- 子产品名称
            ,renewaltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 出账流水号
    ,o.executerate -- 执行利率
    ,o.repaycycle -- 还款周期
    ,o.pigeonholedate -- 归档日期
    ,o.gainamount -- 递变幅度
    ,o.productid -- 产品编号
    ,o.purpose -- 贷款用途(手输描述)
    ,o.pdgpaymethod -- 手续费收取方式
    ,o.repaydate -- 默认还款日
    ,o.customerid -- 客户编号
    ,o.loanaccountnosub -- 贷款入账账号(收款账户)子户号
    ,o.baserate -- 基准利率
    ,o.policyid -- 政策编号
    ,o.occurdate -- 发生日期
    ,o.paymenttype -- 支付方式
    ,o.completeflag -- 数据录入完整性标识
    ,o.inputuserid -- 登记人
    ,o.subjectno -- 科目代码
    ,o.putoutorgid -- 出账机构编号(核心机构)
    ,o.applytype -- 申请类型
    ,o.approvestatus -- 审批状态
    ,o.updateuserid -- 更新人
    ,o.customername -- 客户名称
    ,o.rateadjustfrequency -- 利率调整周期
    ,o.putoutdate -- 起息日
    ,o.updatedate -- 更新日期
    ,o.segterm -- 指定还款计算期限
    ,o.inputorgid -- 登记机构
    ,o.flowtype -- 流程类型
    ,o.exchangetime -- 交易时间
    ,o.offsheetflag -- 表内外标志
    ,o.overdueratefloatvalue -- 逾期利率浮动值
    ,o.pdgsum -- 手续费金额(元)
    ,o.jxhjduebillno -- 借新还旧借据号
    ,o.rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
    ,o.pdgaccountno -- 手续费扣费账户
    ,o.zftransserialno -- 受托支付止付流水号
    ,o.contractserialno -- 合同编号
    ,o.interestrepaycycle -- 结息方式
    ,o.exchangestate -- 交易状态
    ,o.bpspreads -- 合同点差
    ,o.fixedrate -- 固定利率
    ,o.floatrange -- 浮动幅度
    ,o.overdueratefloattype -- 逾期利率浮动方式
    ,o.remark -- 备注
    ,o.ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
    ,o.ratefloattype -- 利率浮动类型浮动利率类型
    ,o.islowrisk -- 是否低风险
    ,o.lendingorgid -- 贷款机构编号(核心机构)
    ,o.commissionpaysum -- 受托支付金额
    ,o.clno -- 额度编号
    ,o.segrptamount -- 指定区段拟还本金金额
    ,o.bailratio -- 保证金比例(%)
    ,o.transserialno -- 核心交易流水号
    ,o.payfrequencyunit -- 指定周期单位
    ,o.payfrequency -- 指定周期
    ,o.repaytype -- 还款方式
    ,o.overduerate -- 逾期执行利率
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.termmonth -- 期限月
    ,o.maturity -- 到期日
    ,o.gaincyc -- 递变周期
    ,o.loanaccountno -- 贷款入账账号
    ,o.operateuserid -- 经办人
    ,o.contractsum -- 合同金额
    ,o.bailtransaccount -- 保证金转出账号
    ,o.operatedate -- 经办日期
    ,o.corporgid -- 法人机构编号
    ,o.currency -- 币种
    ,o.artificialno -- 文本合同编号
    ,o.bailsum -- 保证金金额
    ,o.vouchtype -- 主要担保方式
    ,o.transdate -- 核心交易日期
    ,o.secondpayaccount -- 第二还款账号
    ,o.bailsubaccount -- 保证金子户号
    ,o.putoutcontrol -- 到日期超批复半年设置，1允许，0禁止
    ,o.termday -- 期限天
    ,o.businesssum -- 本次放款金额
    ,o.occurtype -- 发生类型
    ,o.operateorgid -- 经办机构
    ,o.inputdate -- 登记日期
    ,o.bailaccount -- 保证金账号
    ,o.bailcurrency -- 保证金币种
    ,o.settlementaccountname -- 结算账户(还款账户)名
    ,o.loanaccountbankname -- 结算账户(还款账户)开户行
    ,o.baseratetype -- 基准利率类型
    ,o.updateorgid -- 更新机构
    ,o.pdgamorfg -- 手续费是否摊销
    ,o.loanaccountorgid -- 贷款入账(收款账户)账户开户机构
    ,o.belongdept -- 所属条线
    ,o.policyversionid -- 政策版本编号
    ,o.settlementaccount -- 结算账号(还款账户)
    ,o.loanusetype -- 借款用途类型
    ,o.loanaccountname -- 贷款入账(收款账户)账户名
    ,o.duebillserialno -- 借据号
    ,o.pdgpaypercent -- 手续费率
    ,o.migtoldvalue -- 迁移数据-参数转换前字段值
    ,o.remart -- 计量标记InvestGroup
    ,o.ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
    ,o.cashconcenaccount -- 资金归集账户
    ,o.ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
    ,o.entscale -- 企业规模
    ,o.isfirstloans -- 是否首次放款-YesNo
    ,o.ispensionindustry -- 养老产业标识
    ,o.migtcustomerid -- 转换前客户号
    ,o.migtbusinesstype -- 转换前产品ID
    ,o.hangseqno -- 挂账账户序列号
    ,o.relacontractno -- 占用承兑行额度编号
    ,o.nextsettlementdate -- 下一结息日
    ,o.lprrefertype -- LPR参照方式
    ,o.othcustomername -- 对手客户名称
    ,o.othcustomerid -- 对手客户编号
    ,o.subproductname -- 子产品名称
    ,o.renewaltype -- 
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
from ${iol_schema}.icms_business_putout_bk o
    left join ${iol_schema}.icms_business_putout_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_business_putout_cl d
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
--truncate table ${iol_schema}.icms_business_putout;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_business_putout') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_business_putout drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_business_putout add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_business_putout exchange partition p_${batch_date} with table ${iol_schema}.icms_business_putout_cl;
alter table ${iol_schema}.icms_business_putout exchange partition p_20991231 with table ${iol_schema}.icms_business_putout_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_business_putout to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_putout_op purge;
drop table ${iol_schema}.icms_business_putout_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_business_putout_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_business_putout',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
