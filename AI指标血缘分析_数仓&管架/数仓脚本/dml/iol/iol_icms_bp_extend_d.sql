/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bp_extend_d
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
create table ${iol_schema}.icms_bp_extend_d_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bp_extend_d
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bp_extend_d_op purge;
drop table ${iol_schema}.icms_bp_extend_d_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bp_extend_d_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bp_extend_d where 0=1;

create table ${iol_schema}.icms_bp_extend_d_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bp_extend_d where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bp_extend_d_cl(
            serialno -- 出账流水号
            ,billtype -- 票据类型
            ,careflag -- 是否托管
            ,paybankname -- 代付行
            ,keyno -- 票据唯一标识号
            ,tradesum1 -- 贸易融资相关金额1
            ,chaggeaddress -- 地址（福费廷用）
            ,tradesum2 -- 贸易融资相关金额2
            ,resumeinttype -- 计复息标志
            ,linkname -- 联系人（福费廷用）
            ,aboutbankname -- 受益人、收款人开户行行名
            ,bailpdrifm -- 保证金利率浮动方式
            ,bfintg -- 是否预收息or先付利息摊销标志
            ,accountopenbankname -- 结算帐号开户行名称
            ,bailmaturity -- 保证金到期日
            ,capitalreturnflag -- 本金自动归还标志
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,fbsnumber -- 信用证编号\业务编号FBS
            ,assureorgid -- 担保机构编号(我行分支机构)
            ,invoicenumber -- 发票号码
            ,tradetype1 -- 代收或托收类型
            ,bailexchangestate -- 保证金交易状态
            ,cdexchangedate -- 承兑记账交易日期
            ,acptdate -- 出票日
            ,loantype -- 贷款类型
            ,czflag -- 冲账标志
            ,paymode -- 保函支付方式
            ,acceptorname -- 承兑人名称
            ,othertxbalance -- 买方付息金额
            ,accountnocustomer -- 结算帐号客户名称
            ,tradedate1 -- 贸易融资相关日期1
            ,acceptorbankname -- 承兑人开户行名称
            ,compoundintratio -- 复利利率
            ,textno -- 总合同文本编号（福费廷用）
            ,instrt -- 同业代付计提利率（%）
            ,tradecurrecy2 -- 贸易融资相关币种2
            ,repaymentplanflag -- 信贷发放还款计划标志
            ,chargephone -- 电话（福费廷用）
            ,tradetermmonth2 -- 贸易融资相关期限2
            ,ratestartmode -- 利率启用方式
            ,autocontrolflag -- 自动回收控制开关
            ,loantermthing -- 放款条件是否落实
            ,bailfxfltp -- 保证金利率类型
            ,gatheringname -- 收票人全称
            ,principalaccountno -- 委托存款账号
            ,openbankname -- 出口信用证开证行名称、开证行ID
            ,aboutbankname2 -- 保函受益人
            ,preinttype -- 预收息标志
            ,loantermcontrolflag -- 出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
            ,acceptancebank -- 承兑行行号（福费廷）
            ,tradedate2 -- 贸易融资相关日期2
            ,otherdraweracctno -- 买方付息账户号
            ,principalsubaccountno -- 委托存款子户号
            ,continuepayflag -- 持续扣款标志
            ,billno -- 票据号码
            ,approveorgid -- 复核机构
            ,clientaccountno -- 委托人存款账号
            ,repayexchangestate -- 还款计划交易状态
            ,chargename -- 负责人（福费廷用）
            ,commercetype -- 贸易融资类型
            ,tradetermmonth1 -- 贸易融资相关期限1
            ,dprinpaymethod -- 代付本金还款方式
            ,lprtype -- LPR参照方式
            ,loanaccountnoorgname -- 贷款帐号开户行名称
            ,isrz -- 是否融资系统出账1是0否
            ,period -- 分期贷款总期数
            ,approveuserid -- 复核人
            ,traderate1 -- 福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
            ,repurchaseflag -- 是否回购（赎回）
            ,deposittermtype -- 保证金期限类型
            ,linkphone -- 联系人手机号（福费廷用）
            ,termtype -- 期限类型
            ,loanaccountnocustomer -- 贷款帐号客户名称
            ,pdgpaypercent2 -- 手续费率(委托贷款)
            ,bailinterestrate -- 保证金协议利率
            ,cdexchangeno -- 承兑记账交易流水号
            ,businesssubtype -- 保函类型
            ,tradeserialno1 -- 贸易融资业务编号1
            ,txregister -- 票据登记状态
            ,amlresult -- 反洗钱评级结果
            ,compoundintfloatvalue -- 复利利率浮动比例
            ,paysum -- 工本费
            ,name1 -- 汇票承兑人名称
            ,fundsource -- 资金来源
            ,stopintflag -- 是否停息
            ,lnbal -- 同业代付本金
            ,acceptorbankno -- 承兑人开户行行号
            ,confirmingbank -- 保兑行行号（福费廷）
            ,chargefax -- 传真（福费廷用）
            ,pdgsum2 -- 手续费金额(元)(承兑汇票)
            ,depositbaserate -- 存款基准利率
            ,lcsum -- 信用证金额（元）
            ,traderate2 -- 贸易融资相关比例或利率2
            ,tradecurrecy1 -- 贸易融资相关币种1
            ,isfinanceguarantee -- 是否融资性保函
            ,putoutno -- 出账号
            ,bailpdrifd -- 保证金利率浮动类型
            ,depositterm -- 存期期限
            ,billclass -- 票据种类
            ,tradesum3 -- 贸易融资相关金额3
            ,tradecurrecy3 -- 贸易融资相关币种3
            ,queryabnormitything -- 贷款卡当日查询是否有异常情况
            ,creditaggreement -- 使用授信额度协议号
            ,exchangetype -- 出帐交易代码
            ,bailterm -- 保证金利率档次
            ,bailpdrifv -- 保证金浮动值
            ,interestreturnflag -- 利息自动归还标志
            ,compoundintflag -- 是否收复息标志
            ,chargepost -- 职务（福费廷用）
            ,isbankaccount -- 受益人账号是否本行
            ,fixcyc -- 计息天数
            ,ordinaryormonthly -- 普通分期还款标志
            ,unpaidbankname -- 代付行名称
            ,approvedate -- 复核日期
            ,linkemail -- 联系人电子邮箱（福费廷用）
            ,discountsum -- 利息金额
            ,loanaccountno2 -- 贷款帐号
            ,abnormitything -- 贷款卡异常情况说明
            ,tradeserialno2 -- 贸易融资业务编号2
            ,bailinterestmethod -- 保证金计息方法
            ,trantp -- 手续费收费方式(票据)
            ,poolfinancingflag -- 是否已签订池融资协议
            ,isbelongterm -- 是否靠档计息
            ,contractsignfee -- 签约手续费
            ,aboutbankid -- 信用证受益人客户号
            ,isfixedrate -- 利率是否固定
            ,opencustomer -- 信用证开证人
            ,sellstatus -- 卖出状态
            ,otherreceivedbankno -- 对方收款行号
            ,otherreceivedname -- 对方收款账号
            ,otherreceivedaccname -- 对方收款户名
            ,otherreceivedbankname -- 对方收款行名称
            ,creditbeneficiary -- 信用证收益人名称
            ,actualloanaccountno -- 贷款实际入账账号
            ,replaceolddept -- 是否置换旧债
            ,isproxydp -- 是否代理交单
            ,sqdkze -- 申请银团贷款总额
            ,socialcreditcode -- 统一社会信用代码
            ,buychannel -- 买入渠道
            ,islinkoutpay -- 是否联动对外支付
            ,post -- 附言
            ,payinterestcustomer -- 付息客户
            ,purchasercustflag -- 买方是否为我行客户
            ,othercustomerid -- 买方客户号
            ,othercustomername -- 买方客户名称
            ,finalmerger -- 是否末期合并：0否，1是
            ,lcsumrate -- 信用证金额上浮比例
            ,linkchargeintflag -- 是否联动扣收利息
            ,isactualddamtflag -- 是否按实际放款金额冻结标志
            ,maxpdrifv -- 保证金浮动上限
            ,ismergeentrpayment -- 是否合并受托支付
            ,ownfunds -- 自有资金
            ,ownfundsacctno -- 自有资金账号
            ,ownfundsacctname -- 自有资金账户名称
            ,ownfundsacctccy -- 自有资金账户币种
            ,arrivalnumbers -- 到单编号
            ,claimamount -- 索偿金额
            ,businessamount -- 业务金额
            ,marketflows -- 市场流转次数，含到我行
            ,servicecontent -- 货物/服务品种
            ,scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
            ,priceorderno -- 定价单号
            ,priceapprovestatus -- 定价单审批状态
            ,priceenddate -- 定价单生效截止日
            ,pledgetype -- 质押类型
            ,submitputoutcentertime -- 提交放款中心时间
            ,iscentralizedaccount -- 是否集中出账
            ,issuedbusinessno -- 代开保函业务编号
            ,bhstartdate -- 保函生效日期
            ,bhmaturity -- 保函失效日期
            ,guaranteebusinessno -- 保函业务编号
            ,guaranteesum -- 保函金额
            ,issuedate -- 开立日期
            ,guaranteeputoutstatus -- 保函信息状态(code:guaranteeputoutstatus)
            ,isreplenishment -- 是否补录完成
            ,scanuserid -- 扫描人
            ,scanusername -- 扫描人名称
            ,bizuniqueno -- 业务唯一流水号（票据/供应链）
            ,isxdapprove -- 是否信贷审批（票据/供应链推送流程）
            ,isignoreresult -- 是否忽略不动产查册策略结果
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bp_extend_d_op(
            serialno -- 出账流水号
            ,billtype -- 票据类型
            ,careflag -- 是否托管
            ,paybankname -- 代付行
            ,keyno -- 票据唯一标识号
            ,tradesum1 -- 贸易融资相关金额1
            ,chaggeaddress -- 地址（福费廷用）
            ,tradesum2 -- 贸易融资相关金额2
            ,resumeinttype -- 计复息标志
            ,linkname -- 联系人（福费廷用）
            ,aboutbankname -- 受益人、收款人开户行行名
            ,bailpdrifm -- 保证金利率浮动方式
            ,bfintg -- 是否预收息or先付利息摊销标志
            ,accountopenbankname -- 结算帐号开户行名称
            ,bailmaturity -- 保证金到期日
            ,capitalreturnflag -- 本金自动归还标志
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,fbsnumber -- 信用证编号\业务编号FBS
            ,assureorgid -- 担保机构编号(我行分支机构)
            ,invoicenumber -- 发票号码
            ,tradetype1 -- 代收或托收类型
            ,bailexchangestate -- 保证金交易状态
            ,cdexchangedate -- 承兑记账交易日期
            ,acptdate -- 出票日
            ,loantype -- 贷款类型
            ,czflag -- 冲账标志
            ,paymode -- 保函支付方式
            ,acceptorname -- 承兑人名称
            ,othertxbalance -- 买方付息金额
            ,accountnocustomer -- 结算帐号客户名称
            ,tradedate1 -- 贸易融资相关日期1
            ,acceptorbankname -- 承兑人开户行名称
            ,compoundintratio -- 复利利率
            ,textno -- 总合同文本编号（福费廷用）
            ,instrt -- 同业代付计提利率（%）
            ,tradecurrecy2 -- 贸易融资相关币种2
            ,repaymentplanflag -- 信贷发放还款计划标志
            ,chargephone -- 电话（福费廷用）
            ,tradetermmonth2 -- 贸易融资相关期限2
            ,ratestartmode -- 利率启用方式
            ,autocontrolflag -- 自动回收控制开关
            ,loantermthing -- 放款条件是否落实
            ,bailfxfltp -- 保证金利率类型
            ,gatheringname -- 收票人全称
            ,principalaccountno -- 委托存款账号
            ,openbankname -- 出口信用证开证行名称、开证行ID
            ,aboutbankname2 -- 保函受益人
            ,preinttype -- 预收息标志
            ,loantermcontrolflag -- 出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
            ,acceptancebank -- 承兑行行号（福费廷）
            ,tradedate2 -- 贸易融资相关日期2
            ,otherdraweracctno -- 买方付息账户号
            ,principalsubaccountno -- 委托存款子户号
            ,continuepayflag -- 持续扣款标志
            ,billno -- 票据号码
            ,approveorgid -- 复核机构
            ,clientaccountno -- 委托人存款账号
            ,repayexchangestate -- 还款计划交易状态
            ,chargename -- 负责人（福费廷用）
            ,commercetype -- 贸易融资类型
            ,tradetermmonth1 -- 贸易融资相关期限1
            ,dprinpaymethod -- 代付本金还款方式
            ,lprtype -- LPR参照方式
            ,loanaccountnoorgname -- 贷款帐号开户行名称
            ,isrz -- 是否融资系统出账1是0否
            ,period -- 分期贷款总期数
            ,approveuserid -- 复核人
            ,traderate1 -- 福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
            ,repurchaseflag -- 是否回购（赎回）
            ,deposittermtype -- 保证金期限类型
            ,linkphone -- 联系人手机号（福费廷用）
            ,termtype -- 期限类型
            ,loanaccountnocustomer -- 贷款帐号客户名称
            ,pdgpaypercent2 -- 手续费率(委托贷款)
            ,bailinterestrate -- 保证金协议利率
            ,cdexchangeno -- 承兑记账交易流水号
            ,businesssubtype -- 保函类型
            ,tradeserialno1 -- 贸易融资业务编号1
            ,txregister -- 票据登记状态
            ,amlresult -- 反洗钱评级结果
            ,compoundintfloatvalue -- 复利利率浮动比例
            ,paysum -- 工本费
            ,name1 -- 汇票承兑人名称
            ,fundsource -- 资金来源
            ,stopintflag -- 是否停息
            ,lnbal -- 同业代付本金
            ,acceptorbankno -- 承兑人开户行行号
            ,confirmingbank -- 保兑行行号（福费廷）
            ,chargefax -- 传真（福费廷用）
            ,pdgsum2 -- 手续费金额(元)(承兑汇票)
            ,depositbaserate -- 存款基准利率
            ,lcsum -- 信用证金额（元）
            ,traderate2 -- 贸易融资相关比例或利率2
            ,tradecurrecy1 -- 贸易融资相关币种1
            ,isfinanceguarantee -- 是否融资性保函
            ,putoutno -- 出账号
            ,bailpdrifd -- 保证金利率浮动类型
            ,depositterm -- 存期期限
            ,billclass -- 票据种类
            ,tradesum3 -- 贸易融资相关金额3
            ,tradecurrecy3 -- 贸易融资相关币种3
            ,queryabnormitything -- 贷款卡当日查询是否有异常情况
            ,creditaggreement -- 使用授信额度协议号
            ,exchangetype -- 出帐交易代码
            ,bailterm -- 保证金利率档次
            ,bailpdrifv -- 保证金浮动值
            ,interestreturnflag -- 利息自动归还标志
            ,compoundintflag -- 是否收复息标志
            ,chargepost -- 职务（福费廷用）
            ,isbankaccount -- 受益人账号是否本行
            ,fixcyc -- 计息天数
            ,ordinaryormonthly -- 普通分期还款标志
            ,unpaidbankname -- 代付行名称
            ,approvedate -- 复核日期
            ,linkemail -- 联系人电子邮箱（福费廷用）
            ,discountsum -- 利息金额
            ,loanaccountno2 -- 贷款帐号
            ,abnormitything -- 贷款卡异常情况说明
            ,tradeserialno2 -- 贸易融资业务编号2
            ,bailinterestmethod -- 保证金计息方法
            ,trantp -- 手续费收费方式(票据)
            ,poolfinancingflag -- 是否已签订池融资协议
            ,isbelongterm -- 是否靠档计息
            ,contractsignfee -- 签约手续费
            ,aboutbankid -- 信用证受益人客户号
            ,isfixedrate -- 利率是否固定
            ,opencustomer -- 信用证开证人
            ,sellstatus -- 卖出状态
            ,otherreceivedbankno -- 对方收款行号
            ,otherreceivedname -- 对方收款账号
            ,otherreceivedaccname -- 对方收款户名
            ,otherreceivedbankname -- 对方收款行名称
            ,creditbeneficiary -- 信用证收益人名称
            ,actualloanaccountno -- 贷款实际入账账号
            ,replaceolddept -- 是否置换旧债
            ,isproxydp -- 是否代理交单
            ,sqdkze -- 申请银团贷款总额
            ,socialcreditcode -- 统一社会信用代码
            ,buychannel -- 买入渠道
            ,islinkoutpay -- 是否联动对外支付
            ,post -- 附言
            ,payinterestcustomer -- 付息客户
            ,purchasercustflag -- 买方是否为我行客户
            ,othercustomerid -- 买方客户号
            ,othercustomername -- 买方客户名称
            ,finalmerger -- 是否末期合并：0否，1是
            ,lcsumrate -- 信用证金额上浮比例
            ,linkchargeintflag -- 是否联动扣收利息
            ,isactualddamtflag -- 是否按实际放款金额冻结标志
            ,maxpdrifv -- 保证金浮动上限
            ,ismergeentrpayment -- 是否合并受托支付
            ,ownfunds -- 自有资金
            ,ownfundsacctno -- 自有资金账号
            ,ownfundsacctname -- 自有资金账户名称
            ,ownfundsacctccy -- 自有资金账户币种
            ,arrivalnumbers -- 到单编号
            ,claimamount -- 索偿金额
            ,businessamount -- 业务金额
            ,marketflows -- 市场流转次数，含到我行
            ,servicecontent -- 货物/服务品种
            ,scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
            ,priceorderno -- 定价单号
            ,priceapprovestatus -- 定价单审批状态
            ,priceenddate -- 定价单生效截止日
            ,pledgetype -- 质押类型
            ,submitputoutcentertime -- 提交放款中心时间
            ,iscentralizedaccount -- 是否集中出账
            ,issuedbusinessno -- 代开保函业务编号
            ,bhstartdate -- 保函生效日期
            ,bhmaturity -- 保函失效日期
            ,guaranteebusinessno -- 保函业务编号
            ,guaranteesum -- 保函金额
            ,issuedate -- 开立日期
            ,guaranteeputoutstatus -- 保函信息状态(code:guaranteeputoutstatus)
            ,isreplenishment -- 是否补录完成
            ,scanuserid -- 扫描人
            ,scanusername -- 扫描人名称
            ,bizuniqueno -- 业务唯一流水号（票据/供应链）
            ,isxdapprove -- 是否信贷审批（票据/供应链推送流程）
            ,isignoreresult -- 是否忽略不动产查册策略结果
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 出账流水号
    ,nvl(n.billtype, o.billtype) as billtype -- 票据类型
    ,nvl(n.careflag, o.careflag) as careflag -- 是否托管
    ,nvl(n.paybankname, o.paybankname) as paybankname -- 代付行
    ,nvl(n.keyno, o.keyno) as keyno -- 票据唯一标识号
    ,nvl(n.tradesum1, o.tradesum1) as tradesum1 -- 贸易融资相关金额1
    ,nvl(n.chaggeaddress, o.chaggeaddress) as chaggeaddress -- 地址（福费廷用）
    ,nvl(n.tradesum2, o.tradesum2) as tradesum2 -- 贸易融资相关金额2
    ,nvl(n.resumeinttype, o.resumeinttype) as resumeinttype -- 计复息标志
    ,nvl(n.linkname, o.linkname) as linkname -- 联系人（福费廷用）
    ,nvl(n.aboutbankname, o.aboutbankname) as aboutbankname -- 受益人、收款人开户行行名
    ,nvl(n.bailpdrifm, o.bailpdrifm) as bailpdrifm -- 保证金利率浮动方式
    ,nvl(n.bfintg, o.bfintg) as bfintg -- 是否预收息or先付利息摊销标志
    ,nvl(n.accountopenbankname, o.accountopenbankname) as accountopenbankname -- 结算帐号开户行名称
    ,nvl(n.bailmaturity, o.bailmaturity) as bailmaturity -- 保证金到期日
    ,nvl(n.capitalreturnflag, o.capitalreturnflag) as capitalreturnflag -- 本金自动归还标志
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.fbsnumber, o.fbsnumber) as fbsnumber -- 信用证编号\业务编号FBS
    ,nvl(n.assureorgid, o.assureorgid) as assureorgid -- 担保机构编号(我行分支机构)
    ,nvl(n.invoicenumber, o.invoicenumber) as invoicenumber -- 发票号码
    ,nvl(n.tradetype1, o.tradetype1) as tradetype1 -- 代收或托收类型
    ,nvl(n.bailexchangestate, o.bailexchangestate) as bailexchangestate -- 保证金交易状态
    ,nvl(n.cdexchangedate, o.cdexchangedate) as cdexchangedate -- 承兑记账交易日期
    ,nvl(n.acptdate, o.acptdate) as acptdate -- 出票日
    ,nvl(n.loantype, o.loantype) as loantype -- 贷款类型
    ,nvl(n.czflag, o.czflag) as czflag -- 冲账标志
    ,nvl(n.paymode, o.paymode) as paymode -- 保函支付方式
    ,nvl(n.acceptorname, o.acceptorname) as acceptorname -- 承兑人名称
    ,nvl(n.othertxbalance, o.othertxbalance) as othertxbalance -- 买方付息金额
    ,nvl(n.accountnocustomer, o.accountnocustomer) as accountnocustomer -- 结算帐号客户名称
    ,nvl(n.tradedate1, o.tradedate1) as tradedate1 -- 贸易融资相关日期1
    ,nvl(n.acceptorbankname, o.acceptorbankname) as acceptorbankname -- 承兑人开户行名称
    ,nvl(n.compoundintratio, o.compoundintratio) as compoundintratio -- 复利利率
    ,nvl(n.textno, o.textno) as textno -- 总合同文本编号（福费廷用）
    ,nvl(n.instrt, o.instrt) as instrt -- 同业代付计提利率（%）
    ,nvl(n.tradecurrecy2, o.tradecurrecy2) as tradecurrecy2 -- 贸易融资相关币种2
    ,nvl(n.repaymentplanflag, o.repaymentplanflag) as repaymentplanflag -- 信贷发放还款计划标志
    ,nvl(n.chargephone, o.chargephone) as chargephone -- 电话（福费廷用）
    ,nvl(n.tradetermmonth2, o.tradetermmonth2) as tradetermmonth2 -- 贸易融资相关期限2
    ,nvl(n.ratestartmode, o.ratestartmode) as ratestartmode -- 利率启用方式
    ,nvl(n.autocontrolflag, o.autocontrolflag) as autocontrolflag -- 自动回收控制开关
    ,nvl(n.loantermthing, o.loantermthing) as loantermthing -- 放款条件是否落实
    ,nvl(n.bailfxfltp, o.bailfxfltp) as bailfxfltp -- 保证金利率类型
    ,nvl(n.gatheringname, o.gatheringname) as gatheringname -- 收票人全称
    ,nvl(n.principalaccountno, o.principalaccountno) as principalaccountno -- 委托存款账号
    ,nvl(n.openbankname, o.openbankname) as openbankname -- 出口信用证开证行名称、开证行ID
    ,nvl(n.aboutbankname2, o.aboutbankname2) as aboutbankname2 -- 保函受益人
    ,nvl(n.preinttype, o.preinttype) as preinttype -- 预收息标志
    ,nvl(n.loantermcontrolflag, o.loantermcontrolflag) as loantermcontrolflag -- 出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
    ,nvl(n.acceptancebank, o.acceptancebank) as acceptancebank -- 承兑行行号（福费廷）
    ,nvl(n.tradedate2, o.tradedate2) as tradedate2 -- 贸易融资相关日期2
    ,nvl(n.otherdraweracctno, o.otherdraweracctno) as otherdraweracctno -- 买方付息账户号
    ,nvl(n.principalsubaccountno, o.principalsubaccountno) as principalsubaccountno -- 委托存款子户号
    ,nvl(n.continuepayflag, o.continuepayflag) as continuepayflag -- 持续扣款标志
    ,nvl(n.billno, o.billno) as billno -- 票据号码
    ,nvl(n.approveorgid, o.approveorgid) as approveorgid -- 复核机构
    ,nvl(n.clientaccountno, o.clientaccountno) as clientaccountno -- 委托人存款账号
    ,nvl(n.repayexchangestate, o.repayexchangestate) as repayexchangestate -- 还款计划交易状态
    ,nvl(n.chargename, o.chargename) as chargename -- 负责人（福费廷用）
    ,nvl(n.commercetype, o.commercetype) as commercetype -- 贸易融资类型
    ,nvl(n.tradetermmonth1, o.tradetermmonth1) as tradetermmonth1 -- 贸易融资相关期限1
    ,nvl(n.dprinpaymethod, o.dprinpaymethod) as dprinpaymethod -- 代付本金还款方式
    ,nvl(n.lprtype, o.lprtype) as lprtype -- LPR参照方式
    ,nvl(n.loanaccountnoorgname, o.loanaccountnoorgname) as loanaccountnoorgname -- 贷款帐号开户行名称
    ,nvl(n.isrz, o.isrz) as isrz -- 是否融资系统出账1是0否
    ,nvl(n.period, o.period) as period -- 分期贷款总期数
    ,nvl(n.approveuserid, o.approveuserid) as approveuserid -- 复核人
    ,nvl(n.traderate1, o.traderate1) as traderate1 -- 福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
    ,nvl(n.repurchaseflag, o.repurchaseflag) as repurchaseflag -- 是否回购（赎回）
    ,nvl(n.deposittermtype, o.deposittermtype) as deposittermtype -- 保证金期限类型
    ,nvl(n.linkphone, o.linkphone) as linkphone -- 联系人手机号（福费廷用）
    ,nvl(n.termtype, o.termtype) as termtype -- 期限类型
    ,nvl(n.loanaccountnocustomer, o.loanaccountnocustomer) as loanaccountnocustomer -- 贷款帐号客户名称
    ,nvl(n.pdgpaypercent2, o.pdgpaypercent2) as pdgpaypercent2 -- 手续费率(委托贷款)
    ,nvl(n.bailinterestrate, o.bailinterestrate) as bailinterestrate -- 保证金协议利率
    ,nvl(n.cdexchangeno, o.cdexchangeno) as cdexchangeno -- 承兑记账交易流水号
    ,nvl(n.businesssubtype, o.businesssubtype) as businesssubtype -- 保函类型
    ,nvl(n.tradeserialno1, o.tradeserialno1) as tradeserialno1 -- 贸易融资业务编号1
    ,nvl(n.txregister, o.txregister) as txregister -- 票据登记状态
    ,nvl(n.amlresult, o.amlresult) as amlresult -- 反洗钱评级结果
    ,nvl(n.compoundintfloatvalue, o.compoundintfloatvalue) as compoundintfloatvalue -- 复利利率浮动比例
    ,nvl(n.paysum, o.paysum) as paysum -- 工本费
    ,nvl(n.name1, o.name1) as name1 -- 汇票承兑人名称
    ,nvl(n.fundsource, o.fundsource) as fundsource -- 资金来源
    ,nvl(n.stopintflag, o.stopintflag) as stopintflag -- 是否停息
    ,nvl(n.lnbal, o.lnbal) as lnbal -- 同业代付本金
    ,nvl(n.acceptorbankno, o.acceptorbankno) as acceptorbankno -- 承兑人开户行行号
    ,nvl(n.confirmingbank, o.confirmingbank) as confirmingbank -- 保兑行行号（福费廷）
    ,nvl(n.chargefax, o.chargefax) as chargefax -- 传真（福费廷用）
    ,nvl(n.pdgsum2, o.pdgsum2) as pdgsum2 -- 手续费金额(元)(承兑汇票)
    ,nvl(n.depositbaserate, o.depositbaserate) as depositbaserate -- 存款基准利率
    ,nvl(n.lcsum, o.lcsum) as lcsum -- 信用证金额（元）
    ,nvl(n.traderate2, o.traderate2) as traderate2 -- 贸易融资相关比例或利率2
    ,nvl(n.tradecurrecy1, o.tradecurrecy1) as tradecurrecy1 -- 贸易融资相关币种1
    ,nvl(n.isfinanceguarantee, o.isfinanceguarantee) as isfinanceguarantee -- 是否融资性保函
    ,nvl(n.putoutno, o.putoutno) as putoutno -- 出账号
    ,nvl(n.bailpdrifd, o.bailpdrifd) as bailpdrifd -- 保证金利率浮动类型
    ,nvl(n.depositterm, o.depositterm) as depositterm -- 存期期限
    ,nvl(n.billclass, o.billclass) as billclass -- 票据种类
    ,nvl(n.tradesum3, o.tradesum3) as tradesum3 -- 贸易融资相关金额3
    ,nvl(n.tradecurrecy3, o.tradecurrecy3) as tradecurrecy3 -- 贸易融资相关币种3
    ,nvl(n.queryabnormitything, o.queryabnormitything) as queryabnormitything -- 贷款卡当日查询是否有异常情况
    ,nvl(n.creditaggreement, o.creditaggreement) as creditaggreement -- 使用授信额度协议号
    ,nvl(n.exchangetype, o.exchangetype) as exchangetype -- 出帐交易代码
    ,nvl(n.bailterm, o.bailterm) as bailterm -- 保证金利率档次
    ,nvl(n.bailpdrifv, o.bailpdrifv) as bailpdrifv -- 保证金浮动值
    ,nvl(n.interestreturnflag, o.interestreturnflag) as interestreturnflag -- 利息自动归还标志
    ,nvl(n.compoundintflag, o.compoundintflag) as compoundintflag -- 是否收复息标志
    ,nvl(n.chargepost, o.chargepost) as chargepost -- 职务（福费廷用）
    ,nvl(n.isbankaccount, o.isbankaccount) as isbankaccount -- 受益人账号是否本行
    ,nvl(n.fixcyc, o.fixcyc) as fixcyc -- 计息天数
    ,nvl(n.ordinaryormonthly, o.ordinaryormonthly) as ordinaryormonthly -- 普通分期还款标志
    ,nvl(n.unpaidbankname, o.unpaidbankname) as unpaidbankname -- 代付行名称
    ,nvl(n.approvedate, o.approvedate) as approvedate -- 复核日期
    ,nvl(n.linkemail, o.linkemail) as linkemail -- 联系人电子邮箱（福费廷用）
    ,nvl(n.discountsum, o.discountsum) as discountsum -- 利息金额
    ,nvl(n.loanaccountno2, o.loanaccountno2) as loanaccountno2 -- 贷款帐号
    ,nvl(n.abnormitything, o.abnormitything) as abnormitything -- 贷款卡异常情况说明
    ,nvl(n.tradeserialno2, o.tradeserialno2) as tradeserialno2 -- 贸易融资业务编号2
    ,nvl(n.bailinterestmethod, o.bailinterestmethod) as bailinterestmethod -- 保证金计息方法
    ,nvl(n.trantp, o.trantp) as trantp -- 手续费收费方式(票据)
    ,nvl(n.poolfinancingflag, o.poolfinancingflag) as poolfinancingflag -- 是否已签订池融资协议
    ,nvl(n.isbelongterm, o.isbelongterm) as isbelongterm -- 是否靠档计息
    ,nvl(n.contractsignfee, o.contractsignfee) as contractsignfee -- 签约手续费
    ,nvl(n.aboutbankid, o.aboutbankid) as aboutbankid -- 信用证受益人客户号
    ,nvl(n.isfixedrate, o.isfixedrate) as isfixedrate -- 利率是否固定
    ,nvl(n.opencustomer, o.opencustomer) as opencustomer -- 信用证开证人
    ,nvl(n.sellstatus, o.sellstatus) as sellstatus -- 卖出状态
    ,nvl(n.otherreceivedbankno, o.otherreceivedbankno) as otherreceivedbankno -- 对方收款行号
    ,nvl(n.otherreceivedname, o.otherreceivedname) as otherreceivedname -- 对方收款账号
    ,nvl(n.otherreceivedaccname, o.otherreceivedaccname) as otherreceivedaccname -- 对方收款户名
    ,nvl(n.otherreceivedbankname, o.otherreceivedbankname) as otherreceivedbankname -- 对方收款行名称
    ,nvl(n.creditbeneficiary, o.creditbeneficiary) as creditbeneficiary -- 信用证收益人名称
    ,nvl(n.actualloanaccountno, o.actualloanaccountno) as actualloanaccountno -- 贷款实际入账账号
    ,nvl(n.replaceolddept, o.replaceolddept) as replaceolddept -- 是否置换旧债
    ,nvl(n.isproxydp, o.isproxydp) as isproxydp -- 是否代理交单
    ,nvl(n.sqdkze, o.sqdkze) as sqdkze -- 申请银团贷款总额
    ,nvl(n.socialcreditcode, o.socialcreditcode) as socialcreditcode -- 统一社会信用代码
    ,nvl(n.buychannel, o.buychannel) as buychannel -- 买入渠道
    ,nvl(n.islinkoutpay, o.islinkoutpay) as islinkoutpay -- 是否联动对外支付
    ,nvl(n.post, o.post) as post -- 附言
    ,nvl(n.payinterestcustomer, o.payinterestcustomer) as payinterestcustomer -- 付息客户
    ,nvl(n.purchasercustflag, o.purchasercustflag) as purchasercustflag -- 买方是否为我行客户
    ,nvl(n.othercustomerid, o.othercustomerid) as othercustomerid -- 买方客户号
    ,nvl(n.othercustomername, o.othercustomername) as othercustomername -- 买方客户名称
    ,nvl(n.finalmerger, o.finalmerger) as finalmerger -- 是否末期合并：0否，1是
    ,nvl(n.lcsumrate, o.lcsumrate) as lcsumrate -- 信用证金额上浮比例
    ,nvl(n.linkchargeintflag, o.linkchargeintflag) as linkchargeintflag -- 是否联动扣收利息
    ,nvl(n.isactualddamtflag, o.isactualddamtflag) as isactualddamtflag -- 是否按实际放款金额冻结标志
    ,nvl(n.maxpdrifv, o.maxpdrifv) as maxpdrifv -- 保证金浮动上限
    ,nvl(n.ismergeentrpayment, o.ismergeentrpayment) as ismergeentrpayment -- 是否合并受托支付
    ,nvl(n.ownfunds, o.ownfunds) as ownfunds -- 自有资金
    ,nvl(n.ownfundsacctno, o.ownfundsacctno) as ownfundsacctno -- 自有资金账号
    ,nvl(n.ownfundsacctname, o.ownfundsacctname) as ownfundsacctname -- 自有资金账户名称
    ,nvl(n.ownfundsacctccy, o.ownfundsacctccy) as ownfundsacctccy -- 自有资金账户币种
    ,nvl(n.arrivalnumbers, o.arrivalnumbers) as arrivalnumbers -- 到单编号
    ,nvl(n.claimamount, o.claimamount) as claimamount -- 索偿金额
    ,nvl(n.businessamount, o.businessamount) as businessamount -- 业务金额
    ,nvl(n.marketflows, o.marketflows) as marketflows -- 市场流转次数，含到我行
    ,nvl(n.servicecontent, o.servicecontent) as servicecontent -- 货物/服务品种
    ,nvl(n.scanstatus, o.scanstatus) as scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
    ,nvl(n.priceorderno, o.priceorderno) as priceorderno -- 定价单号
    ,nvl(n.priceapprovestatus, o.priceapprovestatus) as priceapprovestatus -- 定价单审批状态
    ,nvl(n.priceenddate, o.priceenddate) as priceenddate -- 定价单生效截止日
    ,nvl(n.pledgetype, o.pledgetype) as pledgetype -- 质押类型
    ,nvl(n.submitputoutcentertime, o.submitputoutcentertime) as submitputoutcentertime -- 提交放款中心时间
    ,nvl(n.iscentralizedaccount, o.iscentralizedaccount) as iscentralizedaccount -- 是否集中出账
    ,nvl(n.issuedbusinessno, o.issuedbusinessno) as issuedbusinessno -- 代开保函业务编号
    ,nvl(n.bhstartdate, o.bhstartdate) as bhstartdate -- 保函生效日期
    ,nvl(n.bhmaturity, o.bhmaturity) as bhmaturity -- 保函失效日期
    ,nvl(n.guaranteebusinessno, o.guaranteebusinessno) as guaranteebusinessno -- 保函业务编号
    ,nvl(n.guaranteesum, o.guaranteesum) as guaranteesum -- 保函金额
    ,nvl(n.issuedate, o.issuedate) as issuedate -- 开立日期
    ,nvl(n.guaranteeputoutstatus, o.guaranteeputoutstatus) as guaranteeputoutstatus -- 保函信息状态(code:guaranteeputoutstatus)
    ,nvl(n.isreplenishment, o.isreplenishment) as isreplenishment -- 是否补录完成
    ,nvl(n.scanuserid, o.scanuserid) as scanuserid -- 扫描人
    ,nvl(n.scanusername, o.scanusername) as scanusername -- 扫描人名称
    ,nvl(n.bizuniqueno, o.bizuniqueno) as bizuniqueno -- 业务唯一流水号（票据/供应链）
    ,nvl(n.isxdapprove, o.isxdapprove) as isxdapprove -- 是否信贷审批（票据/供应链推送流程）
    ,nvl(n.isignoreresult, o.isignoreresult) as isignoreresult -- 是否忽略不动产查册策略结果
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
from (select * from ${iol_schema}.icms_bp_extend_d_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bp_extend_d where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.billtype <> n.billtype
        or o.careflag <> n.careflag
        or o.paybankname <> n.paybankname
        or o.keyno <> n.keyno
        or o.tradesum1 <> n.tradesum1
        or o.chaggeaddress <> n.chaggeaddress
        or o.tradesum2 <> n.tradesum2
        or o.resumeinttype <> n.resumeinttype
        or o.linkname <> n.linkname
        or o.aboutbankname <> n.aboutbankname
        or o.bailpdrifm <> n.bailpdrifm
        or o.bfintg <> n.bfintg
        or o.accountopenbankname <> n.accountopenbankname
        or o.bailmaturity <> n.bailmaturity
        or o.capitalreturnflag <> n.capitalreturnflag
        or o.migtflag <> n.migtflag
        or o.fbsnumber <> n.fbsnumber
        or o.assureorgid <> n.assureorgid
        or o.invoicenumber <> n.invoicenumber
        or o.tradetype1 <> n.tradetype1
        or o.bailexchangestate <> n.bailexchangestate
        or o.cdexchangedate <> n.cdexchangedate
        or o.acptdate <> n.acptdate
        or o.loantype <> n.loantype
        or o.czflag <> n.czflag
        or o.paymode <> n.paymode
        or o.acceptorname <> n.acceptorname
        or o.othertxbalance <> n.othertxbalance
        or o.accountnocustomer <> n.accountnocustomer
        or o.tradedate1 <> n.tradedate1
        or o.acceptorbankname <> n.acceptorbankname
        or o.compoundintratio <> n.compoundintratio
        or o.textno <> n.textno
        or o.instrt <> n.instrt
        or o.tradecurrecy2 <> n.tradecurrecy2
        or o.repaymentplanflag <> n.repaymentplanflag
        or o.chargephone <> n.chargephone
        or o.tradetermmonth2 <> n.tradetermmonth2
        or o.ratestartmode <> n.ratestartmode
        or o.autocontrolflag <> n.autocontrolflag
        or o.loantermthing <> n.loantermthing
        or o.bailfxfltp <> n.bailfxfltp
        or o.gatheringname <> n.gatheringname
        or o.principalaccountno <> n.principalaccountno
        or o.openbankname <> n.openbankname
        or o.aboutbankname2 <> n.aboutbankname2
        or o.preinttype <> n.preinttype
        or o.loantermcontrolflag <> n.loantermcontrolflag
        or o.acceptancebank <> n.acceptancebank
        or o.tradedate2 <> n.tradedate2
        or o.otherdraweracctno <> n.otherdraweracctno
        or o.principalsubaccountno <> n.principalsubaccountno
        or o.continuepayflag <> n.continuepayflag
        or o.billno <> n.billno
        or o.approveorgid <> n.approveorgid
        or o.clientaccountno <> n.clientaccountno
        or o.repayexchangestate <> n.repayexchangestate
        or o.chargename <> n.chargename
        or o.commercetype <> n.commercetype
        or o.tradetermmonth1 <> n.tradetermmonth1
        or o.dprinpaymethod <> n.dprinpaymethod
        or o.lprtype <> n.lprtype
        or o.loanaccountnoorgname <> n.loanaccountnoorgname
        or o.isrz <> n.isrz
        or o.period <> n.period
        or o.approveuserid <> n.approveuserid
        or o.traderate1 <> n.traderate1
        or o.repurchaseflag <> n.repurchaseflag
        or o.deposittermtype <> n.deposittermtype
        or o.linkphone <> n.linkphone
        or o.termtype <> n.termtype
        or o.loanaccountnocustomer <> n.loanaccountnocustomer
        or o.pdgpaypercent2 <> n.pdgpaypercent2
        or o.bailinterestrate <> n.bailinterestrate
        or o.cdexchangeno <> n.cdexchangeno
        or o.businesssubtype <> n.businesssubtype
        or o.tradeserialno1 <> n.tradeserialno1
        or o.txregister <> n.txregister
        or o.amlresult <> n.amlresult
        or o.compoundintfloatvalue <> n.compoundintfloatvalue
        or o.paysum <> n.paysum
        or o.name1 <> n.name1
        or o.fundsource <> n.fundsource
        or o.stopintflag <> n.stopintflag
        or o.lnbal <> n.lnbal
        or o.acceptorbankno <> n.acceptorbankno
        or o.confirmingbank <> n.confirmingbank
        or o.chargefax <> n.chargefax
        or o.pdgsum2 <> n.pdgsum2
        or o.depositbaserate <> n.depositbaserate
        or o.lcsum <> n.lcsum
        or o.traderate2 <> n.traderate2
        or o.tradecurrecy1 <> n.tradecurrecy1
        or o.isfinanceguarantee <> n.isfinanceguarantee
        or o.putoutno <> n.putoutno
        or o.bailpdrifd <> n.bailpdrifd
        or o.depositterm <> n.depositterm
        or o.billclass <> n.billclass
        or o.tradesum3 <> n.tradesum3
        or o.tradecurrecy3 <> n.tradecurrecy3
        or o.queryabnormitything <> n.queryabnormitything
        or o.creditaggreement <> n.creditaggreement
        or o.exchangetype <> n.exchangetype
        or o.bailterm <> n.bailterm
        or o.bailpdrifv <> n.bailpdrifv
        or o.interestreturnflag <> n.interestreturnflag
        or o.compoundintflag <> n.compoundintflag
        or o.chargepost <> n.chargepost
        or o.isbankaccount <> n.isbankaccount
        or o.fixcyc <> n.fixcyc
        or o.ordinaryormonthly <> n.ordinaryormonthly
        or o.unpaidbankname <> n.unpaidbankname
        or o.approvedate <> n.approvedate
        or o.linkemail <> n.linkemail
        or o.discountsum <> n.discountsum
        or o.loanaccountno2 <> n.loanaccountno2
        or o.abnormitything <> n.abnormitything
        or o.tradeserialno2 <> n.tradeserialno2
        or o.bailinterestmethod <> n.bailinterestmethod
        or o.trantp <> n.trantp
        or o.poolfinancingflag <> n.poolfinancingflag
        or o.isbelongterm <> n.isbelongterm
        or o.contractsignfee <> n.contractsignfee
        or o.aboutbankid <> n.aboutbankid
        or o.isfixedrate <> n.isfixedrate
        or o.opencustomer <> n.opencustomer
        or o.sellstatus <> n.sellstatus
        or o.otherreceivedbankno <> n.otherreceivedbankno
        or o.otherreceivedname <> n.otherreceivedname
        or o.otherreceivedaccname <> n.otherreceivedaccname
        or o.otherreceivedbankname <> n.otherreceivedbankname
        or o.creditbeneficiary <> n.creditbeneficiary
        or o.actualloanaccountno <> n.actualloanaccountno
        or o.replaceolddept <> n.replaceolddept
        or o.isproxydp <> n.isproxydp
        or o.sqdkze <> n.sqdkze
        or o.socialcreditcode <> n.socialcreditcode
        or o.buychannel <> n.buychannel
        or o.islinkoutpay <> n.islinkoutpay
        or o.post <> n.post
        or o.payinterestcustomer <> n.payinterestcustomer
        or o.purchasercustflag <> n.purchasercustflag
        or o.othercustomerid <> n.othercustomerid
        or o.othercustomername <> n.othercustomername
        or o.finalmerger <> n.finalmerger
        or o.lcsumrate <> n.lcsumrate
        or o.linkchargeintflag <> n.linkchargeintflag
        or o.isactualddamtflag <> n.isactualddamtflag
        or o.maxpdrifv <> n.maxpdrifv
        or o.ismergeentrpayment <> n.ismergeentrpayment
        or o.ownfunds <> n.ownfunds
        or o.ownfundsacctno <> n.ownfundsacctno
        or o.ownfundsacctname <> n.ownfundsacctname
        or o.ownfundsacctccy <> n.ownfundsacctccy
        or o.arrivalnumbers <> n.arrivalnumbers
        or o.claimamount <> n.claimamount
        or o.businessamount <> n.businessamount
        or o.marketflows <> n.marketflows
        or o.servicecontent <> n.servicecontent
        or o.scanstatus <> n.scanstatus
        or o.priceorderno <> n.priceorderno
        or o.priceapprovestatus <> n.priceapprovestatus
        or o.priceenddate <> n.priceenddate
        or o.pledgetype <> n.pledgetype
        or o.submitputoutcentertime <> n.submitputoutcentertime
        or o.iscentralizedaccount <> n.iscentralizedaccount
        or o.issuedbusinessno <> n.issuedbusinessno
        or o.bhstartdate <> n.bhstartdate
        or o.bhmaturity <> n.bhmaturity
        or o.guaranteebusinessno <> n.guaranteebusinessno
        or o.guaranteesum <> n.guaranteesum
        or o.issuedate <> n.issuedate
        or o.guaranteeputoutstatus <> n.guaranteeputoutstatus
        or o.isreplenishment <> n.isreplenishment
        or o.scanuserid <> n.scanuserid
        or o.scanusername <> n.scanusername
        or o.bizuniqueno <> n.bizuniqueno
        or o.isxdapprove <> n.isxdapprove
        or o.isignoreresult <> n.isignoreresult
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bp_extend_d_cl(
            serialno -- 出账流水号
            ,billtype -- 票据类型
            ,careflag -- 是否托管
            ,paybankname -- 代付行
            ,keyno -- 票据唯一标识号
            ,tradesum1 -- 贸易融资相关金额1
            ,chaggeaddress -- 地址（福费廷用）
            ,tradesum2 -- 贸易融资相关金额2
            ,resumeinttype -- 计复息标志
            ,linkname -- 联系人（福费廷用）
            ,aboutbankname -- 受益人、收款人开户行行名
            ,bailpdrifm -- 保证金利率浮动方式
            ,bfintg -- 是否预收息or先付利息摊销标志
            ,accountopenbankname -- 结算帐号开户行名称
            ,bailmaturity -- 保证金到期日
            ,capitalreturnflag -- 本金自动归还标志
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,fbsnumber -- 信用证编号\业务编号FBS
            ,assureorgid -- 担保机构编号(我行分支机构)
            ,invoicenumber -- 发票号码
            ,tradetype1 -- 代收或托收类型
            ,bailexchangestate -- 保证金交易状态
            ,cdexchangedate -- 承兑记账交易日期
            ,acptdate -- 出票日
            ,loantype -- 贷款类型
            ,czflag -- 冲账标志
            ,paymode -- 保函支付方式
            ,acceptorname -- 承兑人名称
            ,othertxbalance -- 买方付息金额
            ,accountnocustomer -- 结算帐号客户名称
            ,tradedate1 -- 贸易融资相关日期1
            ,acceptorbankname -- 承兑人开户行名称
            ,compoundintratio -- 复利利率
            ,textno -- 总合同文本编号（福费廷用）
            ,instrt -- 同业代付计提利率（%）
            ,tradecurrecy2 -- 贸易融资相关币种2
            ,repaymentplanflag -- 信贷发放还款计划标志
            ,chargephone -- 电话（福费廷用）
            ,tradetermmonth2 -- 贸易融资相关期限2
            ,ratestartmode -- 利率启用方式
            ,autocontrolflag -- 自动回收控制开关
            ,loantermthing -- 放款条件是否落实
            ,bailfxfltp -- 保证金利率类型
            ,gatheringname -- 收票人全称
            ,principalaccountno -- 委托存款账号
            ,openbankname -- 出口信用证开证行名称、开证行ID
            ,aboutbankname2 -- 保函受益人
            ,preinttype -- 预收息标志
            ,loantermcontrolflag -- 出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
            ,acceptancebank -- 承兑行行号（福费廷）
            ,tradedate2 -- 贸易融资相关日期2
            ,otherdraweracctno -- 买方付息账户号
            ,principalsubaccountno -- 委托存款子户号
            ,continuepayflag -- 持续扣款标志
            ,billno -- 票据号码
            ,approveorgid -- 复核机构
            ,clientaccountno -- 委托人存款账号
            ,repayexchangestate -- 还款计划交易状态
            ,chargename -- 负责人（福费廷用）
            ,commercetype -- 贸易融资类型
            ,tradetermmonth1 -- 贸易融资相关期限1
            ,dprinpaymethod -- 代付本金还款方式
            ,lprtype -- LPR参照方式
            ,loanaccountnoorgname -- 贷款帐号开户行名称
            ,isrz -- 是否融资系统出账1是0否
            ,period -- 分期贷款总期数
            ,approveuserid -- 复核人
            ,traderate1 -- 福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
            ,repurchaseflag -- 是否回购（赎回）
            ,deposittermtype -- 保证金期限类型
            ,linkphone -- 联系人手机号（福费廷用）
            ,termtype -- 期限类型
            ,loanaccountnocustomer -- 贷款帐号客户名称
            ,pdgpaypercent2 -- 手续费率(委托贷款)
            ,bailinterestrate -- 保证金协议利率
            ,cdexchangeno -- 承兑记账交易流水号
            ,businesssubtype -- 保函类型
            ,tradeserialno1 -- 贸易融资业务编号1
            ,txregister -- 票据登记状态
            ,amlresult -- 反洗钱评级结果
            ,compoundintfloatvalue -- 复利利率浮动比例
            ,paysum -- 工本费
            ,name1 -- 汇票承兑人名称
            ,fundsource -- 资金来源
            ,stopintflag -- 是否停息
            ,lnbal -- 同业代付本金
            ,acceptorbankno -- 承兑人开户行行号
            ,confirmingbank -- 保兑行行号（福费廷）
            ,chargefax -- 传真（福费廷用）
            ,pdgsum2 -- 手续费金额(元)(承兑汇票)
            ,depositbaserate -- 存款基准利率
            ,lcsum -- 信用证金额（元）
            ,traderate2 -- 贸易融资相关比例或利率2
            ,tradecurrecy1 -- 贸易融资相关币种1
            ,isfinanceguarantee -- 是否融资性保函
            ,putoutno -- 出账号
            ,bailpdrifd -- 保证金利率浮动类型
            ,depositterm -- 存期期限
            ,billclass -- 票据种类
            ,tradesum3 -- 贸易融资相关金额3
            ,tradecurrecy3 -- 贸易融资相关币种3
            ,queryabnormitything -- 贷款卡当日查询是否有异常情况
            ,creditaggreement -- 使用授信额度协议号
            ,exchangetype -- 出帐交易代码
            ,bailterm -- 保证金利率档次
            ,bailpdrifv -- 保证金浮动值
            ,interestreturnflag -- 利息自动归还标志
            ,compoundintflag -- 是否收复息标志
            ,chargepost -- 职务（福费廷用）
            ,isbankaccount -- 受益人账号是否本行
            ,fixcyc -- 计息天数
            ,ordinaryormonthly -- 普通分期还款标志
            ,unpaidbankname -- 代付行名称
            ,approvedate -- 复核日期
            ,linkemail -- 联系人电子邮箱（福费廷用）
            ,discountsum -- 利息金额
            ,loanaccountno2 -- 贷款帐号
            ,abnormitything -- 贷款卡异常情况说明
            ,tradeserialno2 -- 贸易融资业务编号2
            ,bailinterestmethod -- 保证金计息方法
            ,trantp -- 手续费收费方式(票据)
            ,poolfinancingflag -- 是否已签订池融资协议
            ,isbelongterm -- 是否靠档计息
            ,contractsignfee -- 签约手续费
            ,aboutbankid -- 信用证受益人客户号
            ,isfixedrate -- 利率是否固定
            ,opencustomer -- 信用证开证人
            ,sellstatus -- 卖出状态
            ,otherreceivedbankno -- 对方收款行号
            ,otherreceivedname -- 对方收款账号
            ,otherreceivedaccname -- 对方收款户名
            ,otherreceivedbankname -- 对方收款行名称
            ,creditbeneficiary -- 信用证收益人名称
            ,actualloanaccountno -- 贷款实际入账账号
            ,replaceolddept -- 是否置换旧债
            ,isproxydp -- 是否代理交单
            ,sqdkze -- 申请银团贷款总额
            ,socialcreditcode -- 统一社会信用代码
            ,buychannel -- 买入渠道
            ,islinkoutpay -- 是否联动对外支付
            ,post -- 附言
            ,payinterestcustomer -- 付息客户
            ,purchasercustflag -- 买方是否为我行客户
            ,othercustomerid -- 买方客户号
            ,othercustomername -- 买方客户名称
            ,finalmerger -- 是否末期合并：0否，1是
            ,lcsumrate -- 信用证金额上浮比例
            ,linkchargeintflag -- 是否联动扣收利息
            ,isactualddamtflag -- 是否按实际放款金额冻结标志
            ,maxpdrifv -- 保证金浮动上限
            ,ismergeentrpayment -- 是否合并受托支付
            ,ownfunds -- 自有资金
            ,ownfundsacctno -- 自有资金账号
            ,ownfundsacctname -- 自有资金账户名称
            ,ownfundsacctccy -- 自有资金账户币种
            ,arrivalnumbers -- 到单编号
            ,claimamount -- 索偿金额
            ,businessamount -- 业务金额
            ,marketflows -- 市场流转次数，含到我行
            ,servicecontent -- 货物/服务品种
            ,scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
            ,priceorderno -- 定价单号
            ,priceapprovestatus -- 定价单审批状态
            ,priceenddate -- 定价单生效截止日
            ,pledgetype -- 质押类型
            ,submitputoutcentertime -- 提交放款中心时间
            ,iscentralizedaccount -- 是否集中出账
            ,issuedbusinessno -- 代开保函业务编号
            ,bhstartdate -- 保函生效日期
            ,bhmaturity -- 保函失效日期
            ,guaranteebusinessno -- 保函业务编号
            ,guaranteesum -- 保函金额
            ,issuedate -- 开立日期
            ,guaranteeputoutstatus -- 保函信息状态(code:guaranteeputoutstatus)
            ,isreplenishment -- 是否补录完成
            ,scanuserid -- 扫描人
            ,scanusername -- 扫描人名称
            ,bizuniqueno -- 业务唯一流水号（票据/供应链）
            ,isxdapprove -- 是否信贷审批（票据/供应链推送流程）
            ,isignoreresult -- 是否忽略不动产查册策略结果
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bp_extend_d_op(
            serialno -- 出账流水号
            ,billtype -- 票据类型
            ,careflag -- 是否托管
            ,paybankname -- 代付行
            ,keyno -- 票据唯一标识号
            ,tradesum1 -- 贸易融资相关金额1
            ,chaggeaddress -- 地址（福费廷用）
            ,tradesum2 -- 贸易融资相关金额2
            ,resumeinttype -- 计复息标志
            ,linkname -- 联系人（福费廷用）
            ,aboutbankname -- 受益人、收款人开户行行名
            ,bailpdrifm -- 保证金利率浮动方式
            ,bfintg -- 是否预收息or先付利息摊销标志
            ,accountopenbankname -- 结算帐号开户行名称
            ,bailmaturity -- 保证金到期日
            ,capitalreturnflag -- 本金自动归还标志
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,fbsnumber -- 信用证编号\业务编号FBS
            ,assureorgid -- 担保机构编号(我行分支机构)
            ,invoicenumber -- 发票号码
            ,tradetype1 -- 代收或托收类型
            ,bailexchangestate -- 保证金交易状态
            ,cdexchangedate -- 承兑记账交易日期
            ,acptdate -- 出票日
            ,loantype -- 贷款类型
            ,czflag -- 冲账标志
            ,paymode -- 保函支付方式
            ,acceptorname -- 承兑人名称
            ,othertxbalance -- 买方付息金额
            ,accountnocustomer -- 结算帐号客户名称
            ,tradedate1 -- 贸易融资相关日期1
            ,acceptorbankname -- 承兑人开户行名称
            ,compoundintratio -- 复利利率
            ,textno -- 总合同文本编号（福费廷用）
            ,instrt -- 同业代付计提利率（%）
            ,tradecurrecy2 -- 贸易融资相关币种2
            ,repaymentplanflag -- 信贷发放还款计划标志
            ,chargephone -- 电话（福费廷用）
            ,tradetermmonth2 -- 贸易融资相关期限2
            ,ratestartmode -- 利率启用方式
            ,autocontrolflag -- 自动回收控制开关
            ,loantermthing -- 放款条件是否落实
            ,bailfxfltp -- 保证金利率类型
            ,gatheringname -- 收票人全称
            ,principalaccountno -- 委托存款账号
            ,openbankname -- 出口信用证开证行名称、开证行ID
            ,aboutbankname2 -- 保函受益人
            ,preinttype -- 预收息标志
            ,loantermcontrolflag -- 出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
            ,acceptancebank -- 承兑行行号（福费廷）
            ,tradedate2 -- 贸易融资相关日期2
            ,otherdraweracctno -- 买方付息账户号
            ,principalsubaccountno -- 委托存款子户号
            ,continuepayflag -- 持续扣款标志
            ,billno -- 票据号码
            ,approveorgid -- 复核机构
            ,clientaccountno -- 委托人存款账号
            ,repayexchangestate -- 还款计划交易状态
            ,chargename -- 负责人（福费廷用）
            ,commercetype -- 贸易融资类型
            ,tradetermmonth1 -- 贸易融资相关期限1
            ,dprinpaymethod -- 代付本金还款方式
            ,lprtype -- LPR参照方式
            ,loanaccountnoorgname -- 贷款帐号开户行名称
            ,isrz -- 是否融资系统出账1是0否
            ,period -- 分期贷款总期数
            ,approveuserid -- 复核人
            ,traderate1 -- 福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
            ,repurchaseflag -- 是否回购（赎回）
            ,deposittermtype -- 保证金期限类型
            ,linkphone -- 联系人手机号（福费廷用）
            ,termtype -- 期限类型
            ,loanaccountnocustomer -- 贷款帐号客户名称
            ,pdgpaypercent2 -- 手续费率(委托贷款)
            ,bailinterestrate -- 保证金协议利率
            ,cdexchangeno -- 承兑记账交易流水号
            ,businesssubtype -- 保函类型
            ,tradeserialno1 -- 贸易融资业务编号1
            ,txregister -- 票据登记状态
            ,amlresult -- 反洗钱评级结果
            ,compoundintfloatvalue -- 复利利率浮动比例
            ,paysum -- 工本费
            ,name1 -- 汇票承兑人名称
            ,fundsource -- 资金来源
            ,stopintflag -- 是否停息
            ,lnbal -- 同业代付本金
            ,acceptorbankno -- 承兑人开户行行号
            ,confirmingbank -- 保兑行行号（福费廷）
            ,chargefax -- 传真（福费廷用）
            ,pdgsum2 -- 手续费金额(元)(承兑汇票)
            ,depositbaserate -- 存款基准利率
            ,lcsum -- 信用证金额（元）
            ,traderate2 -- 贸易融资相关比例或利率2
            ,tradecurrecy1 -- 贸易融资相关币种1
            ,isfinanceguarantee -- 是否融资性保函
            ,putoutno -- 出账号
            ,bailpdrifd -- 保证金利率浮动类型
            ,depositterm -- 存期期限
            ,billclass -- 票据种类
            ,tradesum3 -- 贸易融资相关金额3
            ,tradecurrecy3 -- 贸易融资相关币种3
            ,queryabnormitything -- 贷款卡当日查询是否有异常情况
            ,creditaggreement -- 使用授信额度协议号
            ,exchangetype -- 出帐交易代码
            ,bailterm -- 保证金利率档次
            ,bailpdrifv -- 保证金浮动值
            ,interestreturnflag -- 利息自动归还标志
            ,compoundintflag -- 是否收复息标志
            ,chargepost -- 职务（福费廷用）
            ,isbankaccount -- 受益人账号是否本行
            ,fixcyc -- 计息天数
            ,ordinaryormonthly -- 普通分期还款标志
            ,unpaidbankname -- 代付行名称
            ,approvedate -- 复核日期
            ,linkemail -- 联系人电子邮箱（福费廷用）
            ,discountsum -- 利息金额
            ,loanaccountno2 -- 贷款帐号
            ,abnormitything -- 贷款卡异常情况说明
            ,tradeserialno2 -- 贸易融资业务编号2
            ,bailinterestmethod -- 保证金计息方法
            ,trantp -- 手续费收费方式(票据)
            ,poolfinancingflag -- 是否已签订池融资协议
            ,isbelongterm -- 是否靠档计息
            ,contractsignfee -- 签约手续费
            ,aboutbankid -- 信用证受益人客户号
            ,isfixedrate -- 利率是否固定
            ,opencustomer -- 信用证开证人
            ,sellstatus -- 卖出状态
            ,otherreceivedbankno -- 对方收款行号
            ,otherreceivedname -- 对方收款账号
            ,otherreceivedaccname -- 对方收款户名
            ,otherreceivedbankname -- 对方收款行名称
            ,creditbeneficiary -- 信用证收益人名称
            ,actualloanaccountno -- 贷款实际入账账号
            ,replaceolddept -- 是否置换旧债
            ,isproxydp -- 是否代理交单
            ,sqdkze -- 申请银团贷款总额
            ,socialcreditcode -- 统一社会信用代码
            ,buychannel -- 买入渠道
            ,islinkoutpay -- 是否联动对外支付
            ,post -- 附言
            ,payinterestcustomer -- 付息客户
            ,purchasercustflag -- 买方是否为我行客户
            ,othercustomerid -- 买方客户号
            ,othercustomername -- 买方客户名称
            ,finalmerger -- 是否末期合并：0否，1是
            ,lcsumrate -- 信用证金额上浮比例
            ,linkchargeintflag -- 是否联动扣收利息
            ,isactualddamtflag -- 是否按实际放款金额冻结标志
            ,maxpdrifv -- 保证金浮动上限
            ,ismergeentrpayment -- 是否合并受托支付
            ,ownfunds -- 自有资金
            ,ownfundsacctno -- 自有资金账号
            ,ownfundsacctname -- 自有资金账户名称
            ,ownfundsacctccy -- 自有资金账户币种
            ,arrivalnumbers -- 到单编号
            ,claimamount -- 索偿金额
            ,businessamount -- 业务金额
            ,marketflows -- 市场流转次数，含到我行
            ,servicecontent -- 货物/服务品种
            ,scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
            ,priceorderno -- 定价单号
            ,priceapprovestatus -- 定价单审批状态
            ,priceenddate -- 定价单生效截止日
            ,pledgetype -- 质押类型
            ,submitputoutcentertime -- 提交放款中心时间
            ,iscentralizedaccount -- 是否集中出账
            ,issuedbusinessno -- 代开保函业务编号
            ,bhstartdate -- 保函生效日期
            ,bhmaturity -- 保函失效日期
            ,guaranteebusinessno -- 保函业务编号
            ,guaranteesum -- 保函金额
            ,issuedate -- 开立日期
            ,guaranteeputoutstatus -- 保函信息状态(code:guaranteeputoutstatus)
            ,isreplenishment -- 是否补录完成
            ,scanuserid -- 扫描人
            ,scanusername -- 扫描人名称
            ,bizuniqueno -- 业务唯一流水号（票据/供应链）
            ,isxdapprove -- 是否信贷审批（票据/供应链推送流程）
            ,isignoreresult -- 是否忽略不动产查册策略结果
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 出账流水号
    ,o.billtype -- 票据类型
    ,o.careflag -- 是否托管
    ,o.paybankname -- 代付行
    ,o.keyno -- 票据唯一标识号
    ,o.tradesum1 -- 贸易融资相关金额1
    ,o.chaggeaddress -- 地址（福费廷用）
    ,o.tradesum2 -- 贸易融资相关金额2
    ,o.resumeinttype -- 计复息标志
    ,o.linkname -- 联系人（福费廷用）
    ,o.aboutbankname -- 受益人、收款人开户行行名
    ,o.bailpdrifm -- 保证金利率浮动方式
    ,o.bfintg -- 是否预收息or先付利息摊销标志
    ,o.accountopenbankname -- 结算帐号开户行名称
    ,o.bailmaturity -- 保证金到期日
    ,o.capitalreturnflag -- 本金自动归还标志
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.fbsnumber -- 信用证编号\业务编号FBS
    ,o.assureorgid -- 担保机构编号(我行分支机构)
    ,o.invoicenumber -- 发票号码
    ,o.tradetype1 -- 代收或托收类型
    ,o.bailexchangestate -- 保证金交易状态
    ,o.cdexchangedate -- 承兑记账交易日期
    ,o.acptdate -- 出票日
    ,o.loantype -- 贷款类型
    ,o.czflag -- 冲账标志
    ,o.paymode -- 保函支付方式
    ,o.acceptorname -- 承兑人名称
    ,o.othertxbalance -- 买方付息金额
    ,o.accountnocustomer -- 结算帐号客户名称
    ,o.tradedate1 -- 贸易融资相关日期1
    ,o.acceptorbankname -- 承兑人开户行名称
    ,o.compoundintratio -- 复利利率
    ,o.textno -- 总合同文本编号（福费廷用）
    ,o.instrt -- 同业代付计提利率（%）
    ,o.tradecurrecy2 -- 贸易融资相关币种2
    ,o.repaymentplanflag -- 信贷发放还款计划标志
    ,o.chargephone -- 电话（福费廷用）
    ,o.tradetermmonth2 -- 贸易融资相关期限2
    ,o.ratestartmode -- 利率启用方式
    ,o.autocontrolflag -- 自动回收控制开关
    ,o.loantermthing -- 放款条件是否落实
    ,o.bailfxfltp -- 保证金利率类型
    ,o.gatheringname -- 收票人全称
    ,o.principalaccountno -- 委托存款账号
    ,o.openbankname -- 出口信用证开证行名称、开证行ID
    ,o.aboutbankname2 -- 保函受益人
    ,o.preinttype -- 预收息标志
    ,o.loantermcontrolflag -- 出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
    ,o.acceptancebank -- 承兑行行号（福费廷）
    ,o.tradedate2 -- 贸易融资相关日期2
    ,o.otherdraweracctno -- 买方付息账户号
    ,o.principalsubaccountno -- 委托存款子户号
    ,o.continuepayflag -- 持续扣款标志
    ,o.billno -- 票据号码
    ,o.approveorgid -- 复核机构
    ,o.clientaccountno -- 委托人存款账号
    ,o.repayexchangestate -- 还款计划交易状态
    ,o.chargename -- 负责人（福费廷用）
    ,o.commercetype -- 贸易融资类型
    ,o.tradetermmonth1 -- 贸易融资相关期限1
    ,o.dprinpaymethod -- 代付本金还款方式
    ,o.lprtype -- LPR参照方式
    ,o.loanaccountnoorgname -- 贷款帐号开户行名称
    ,o.isrz -- 是否融资系统出账1是0否
    ,o.period -- 分期贷款总期数
    ,o.approveuserid -- 复核人
    ,o.traderate1 -- 福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
    ,o.repurchaseflag -- 是否回购（赎回）
    ,o.deposittermtype -- 保证金期限类型
    ,o.linkphone -- 联系人手机号（福费廷用）
    ,o.termtype -- 期限类型
    ,o.loanaccountnocustomer -- 贷款帐号客户名称
    ,o.pdgpaypercent2 -- 手续费率(委托贷款)
    ,o.bailinterestrate -- 保证金协议利率
    ,o.cdexchangeno -- 承兑记账交易流水号
    ,o.businesssubtype -- 保函类型
    ,o.tradeserialno1 -- 贸易融资业务编号1
    ,o.txregister -- 票据登记状态
    ,o.amlresult -- 反洗钱评级结果
    ,o.compoundintfloatvalue -- 复利利率浮动比例
    ,o.paysum -- 工本费
    ,o.name1 -- 汇票承兑人名称
    ,o.fundsource -- 资金来源
    ,o.stopintflag -- 是否停息
    ,o.lnbal -- 同业代付本金
    ,o.acceptorbankno -- 承兑人开户行行号
    ,o.confirmingbank -- 保兑行行号（福费廷）
    ,o.chargefax -- 传真（福费廷用）
    ,o.pdgsum2 -- 手续费金额(元)(承兑汇票)
    ,o.depositbaserate -- 存款基准利率
    ,o.lcsum -- 信用证金额（元）
    ,o.traderate2 -- 贸易融资相关比例或利率2
    ,o.tradecurrecy1 -- 贸易融资相关币种1
    ,o.isfinanceguarantee -- 是否融资性保函
    ,o.putoutno -- 出账号
    ,o.bailpdrifd -- 保证金利率浮动类型
    ,o.depositterm -- 存期期限
    ,o.billclass -- 票据种类
    ,o.tradesum3 -- 贸易融资相关金额3
    ,o.tradecurrecy3 -- 贸易融资相关币种3
    ,o.queryabnormitything -- 贷款卡当日查询是否有异常情况
    ,o.creditaggreement -- 使用授信额度协议号
    ,o.exchangetype -- 出帐交易代码
    ,o.bailterm -- 保证金利率档次
    ,o.bailpdrifv -- 保证金浮动值
    ,o.interestreturnflag -- 利息自动归还标志
    ,o.compoundintflag -- 是否收复息标志
    ,o.chargepost -- 职务（福费廷用）
    ,o.isbankaccount -- 受益人账号是否本行
    ,o.fixcyc -- 计息天数
    ,o.ordinaryormonthly -- 普通分期还款标志
    ,o.unpaidbankname -- 代付行名称
    ,o.approvedate -- 复核日期
    ,o.linkemail -- 联系人电子邮箱（福费廷用）
    ,o.discountsum -- 利息金额
    ,o.loanaccountno2 -- 贷款帐号
    ,o.abnormitything -- 贷款卡异常情况说明
    ,o.tradeserialno2 -- 贸易融资业务编号2
    ,o.bailinterestmethod -- 保证金计息方法
    ,o.trantp -- 手续费收费方式(票据)
    ,o.poolfinancingflag -- 是否已签订池融资协议
    ,o.isbelongterm -- 是否靠档计息
    ,o.contractsignfee -- 签约手续费
    ,o.aboutbankid -- 信用证受益人客户号
    ,o.isfixedrate -- 利率是否固定
    ,o.opencustomer -- 信用证开证人
    ,o.sellstatus -- 卖出状态
    ,o.otherreceivedbankno -- 对方收款行号
    ,o.otherreceivedname -- 对方收款账号
    ,o.otherreceivedaccname -- 对方收款户名
    ,o.otherreceivedbankname -- 对方收款行名称
    ,o.creditbeneficiary -- 信用证收益人名称
    ,o.actualloanaccountno -- 贷款实际入账账号
    ,o.replaceolddept -- 是否置换旧债
    ,o.isproxydp -- 是否代理交单
    ,o.sqdkze -- 申请银团贷款总额
    ,o.socialcreditcode -- 统一社会信用代码
    ,o.buychannel -- 买入渠道
    ,o.islinkoutpay -- 是否联动对外支付
    ,o.post -- 附言
    ,o.payinterestcustomer -- 付息客户
    ,o.purchasercustflag -- 买方是否为我行客户
    ,o.othercustomerid -- 买方客户号
    ,o.othercustomername -- 买方客户名称
    ,o.finalmerger -- 是否末期合并：0否，1是
    ,o.lcsumrate -- 信用证金额上浮比例
    ,o.linkchargeintflag -- 是否联动扣收利息
    ,o.isactualddamtflag -- 是否按实际放款金额冻结标志
    ,o.maxpdrifv -- 保证金浮动上限
    ,o.ismergeentrpayment -- 是否合并受托支付
    ,o.ownfunds -- 自有资金
    ,o.ownfundsacctno -- 自有资金账号
    ,o.ownfundsacctname -- 自有资金账户名称
    ,o.ownfundsacctccy -- 自有资金账户币种
    ,o.arrivalnumbers -- 到单编号
    ,o.claimamount -- 索偿金额
    ,o.businessamount -- 业务金额
    ,o.marketflows -- 市场流转次数，含到我行
    ,o.servicecontent -- 货物/服务品种
    ,o.scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
    ,o.priceorderno -- 定价单号
    ,o.priceapprovestatus -- 定价单审批状态
    ,o.priceenddate -- 定价单生效截止日
    ,o.pledgetype -- 质押类型
    ,o.submitputoutcentertime -- 提交放款中心时间
    ,o.iscentralizedaccount -- 是否集中出账
    ,o.issuedbusinessno -- 代开保函业务编号
    ,o.bhstartdate -- 保函生效日期
    ,o.bhmaturity -- 保函失效日期
    ,o.guaranteebusinessno -- 保函业务编号
    ,o.guaranteesum -- 保函金额
    ,o.issuedate -- 开立日期
    ,o.guaranteeputoutstatus -- 保函信息状态(code:guaranteeputoutstatus)
    ,o.isreplenishment -- 是否补录完成
    ,o.scanuserid -- 扫描人
    ,o.scanusername -- 扫描人名称
    ,o.bizuniqueno -- 业务唯一流水号（票据/供应链）
    ,o.isxdapprove -- 是否信贷审批（票据/供应链推送流程）
    ,o.isignoreresult -- 是否忽略不动产查册策略结果
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
from ${iol_schema}.icms_bp_extend_d_bk o
    left join ${iol_schema}.icms_bp_extend_d_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bp_extend_d_cl d
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
--truncate table ${iol_schema}.icms_bp_extend_d;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bp_extend_d') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bp_extend_d drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bp_extend_d add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bp_extend_d exchange partition p_${batch_date} with table ${iol_schema}.icms_bp_extend_d_cl;
alter table ${iol_schema}.icms_bp_extend_d exchange partition p_20991231 with table ${iol_schema}.icms_bp_extend_d_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bp_extend_d to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bp_extend_d_op purge;
drop table ${iol_schema}.icms_bp_extend_d_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bp_extend_d_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bp_extend_d',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
