/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bp_extend_d
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bp_extend_d
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bp_extend_d purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bp_extend_d(
    serialno varchar2(64) -- 出账流水号
    ,billtype varchar2(16) -- 票据类型
    ,careflag varchar2(1) -- 是否托管
    ,paybankname varchar2(100) -- 代付行
    ,keyno varchar2(40) -- 票据唯一标识号
    ,tradesum1 number(24,6) -- 贸易融资相关金额1
    ,chaggeaddress varchar2(200) -- 地址（福费廷用）
    ,tradesum2 number(24,6) -- 贸易融资相关金额2
    ,resumeinttype varchar2(18) -- 计复息标志
    ,linkname varchar2(10) -- 联系人（福费廷用）
    ,aboutbankname varchar2(100) -- 受益人、收款人开户行行名
    ,bailpdrifm varchar2(1) -- 保证金利率浮动方式
    ,bfintg varchar2(1) -- 是否预收息or先付利息摊销标志
    ,accountopenbankname varchar2(80) -- 结算帐号开户行名称
    ,bailmaturity varchar2(10) -- 保证金到期日
    ,capitalreturnflag varchar2(1) -- 本金自动归还标志
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,fbsnumber varchar2(50) -- 信用证编号\业务编号FBS
    ,assureorgid varchar2(64) -- 担保机构编号(我行分支机构)
    ,invoicenumber varchar2(50) -- 发票号码
    ,tradetype1 varchar2(18) -- 代收或托收类型
    ,bailexchangestate varchar2(2) -- 保证金交易状态
    ,cdexchangedate varchar2(10) -- 承兑记账交易日期
    ,acptdate varchar2(10) -- 出票日
    ,loantype varchar2(18) -- 贷款类型
    ,czflag varchar2(1) -- 冲账标志
    ,paymode varchar2(10) -- 保函支付方式
    ,acceptorname varchar2(180) -- 承兑人名称
    ,othertxbalance number(24,6) -- 买方付息金额
    ,accountnocustomer varchar2(80) -- 结算帐号客户名称
    ,tradedate1 varchar2(20) -- 贸易融资相关日期1
    ,acceptorbankname varchar2(180) -- 承兑人开户行名称
    ,compoundintratio number(15,8) -- 复利利率
    ,textno varchar2(60) -- 总合同文本编号（福费廷用）
    ,instrt number(11,7) -- 同业代付计提利率（%）
    ,tradecurrecy2 varchar2(18) -- 贸易融资相关币种2
    ,repaymentplanflag varchar2(1) -- 信贷发放还款计划标志
    ,chargephone varchar2(40) -- 电话（福费廷用）
    ,tradetermmonth2 number(22) -- 贸易融资相关期限2
    ,ratestartmode varchar2(1) -- 利率启用方式
    ,autocontrolflag varchar2(1) -- 自动回收控制开关
    ,loantermthing varchar2(2) -- 放款条件是否落实
    ,bailfxfltp varchar2(1) -- 保证金利率类型
    ,gatheringname varchar2(200) -- 收票人全称
    ,principalaccountno varchar2(50) -- 委托存款账号
    ,openbankname varchar2(80) -- 出口信用证开证行名称、开证行ID
    ,aboutbankname2 varchar2(150) -- 保函受益人
    ,preinttype varchar2(18) -- 预收息标志
    ,loantermcontrolflag varchar2(1) -- 出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
    ,acceptancebank varchar2(200) -- 承兑行行号（福费廷）
    ,tradedate2 varchar2(20) -- 贸易融资相关日期2
    ,otherdraweracctno varchar2(40) -- 买方付息账户号
    ,principalsubaccountno varchar2(5) -- 委托存款子户号
    ,continuepayflag varchar2(1) -- 持续扣款标志
    ,billno varchar2(32) -- 票据号码
    ,approveorgid varchar2(32) -- 复核机构
    ,clientaccountno varchar2(40) -- 委托人存款账号
    ,repayexchangestate varchar2(2) -- 还款计划交易状态
    ,chargename varchar2(40) -- 负责人（福费廷用）
    ,commercetype varchar2(3) -- 贸易融资类型
    ,tradetermmonth1 number(22) -- 贸易融资相关期限1
    ,dprinpaymethod varchar2(18) -- 代付本金还款方式
    ,lprtype varchar2(10) -- LPR参照方式
    ,loanaccountnoorgname varchar2(80) -- 贷款帐号开户行名称
    ,isrz varchar2(2) -- 是否融资系统出账1是0否
    ,period number(10,0) -- 分期贷款总期数
    ,approveuserid varchar2(32) -- 复核人
    ,traderate1 number(10,6) -- 福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
    ,repurchaseflag varchar2(1) -- 是否回购（赎回）
    ,deposittermtype varchar2(1) -- 保证金期限类型
    ,linkphone varchar2(40) -- 联系人手机号（福费廷用）
    ,termtype varchar2(5) -- 期限类型
    ,loanaccountnocustomer varchar2(80) -- 贷款帐号客户名称
    ,pdgpaypercent2 number(6,2) -- 手续费率(委托贷款)
    ,bailinterestrate number(24,6) -- 保证金协议利率
    ,cdexchangeno varchar2(32) -- 承兑记账交易流水号
    ,businesssubtype varchar2(18) -- 保函类型
    ,tradeserialno1 varchar2(40) -- 贸易融资业务编号1
    ,txregister varchar2(2) -- 票据登记状态
    ,amlresult varchar2(1) -- 反洗钱评级结果
    ,compoundintfloatvalue number(12,2) -- 复利利率浮动比例
    ,paysum number(24,6) -- 工本费
    ,name1 varchar2(100) -- 汇票承兑人名称
    ,fundsource varchar2(4) -- 资金来源
    ,stopintflag varchar2(1) -- 是否停息
    ,lnbal number(18,2) -- 同业代付本金
    ,acceptorbankno varchar2(12) -- 承兑人开户行行号
    ,confirmingbank varchar2(200) -- 保兑行行号（福费廷）
    ,chargefax varchar2(40) -- 传真（福费廷用）
    ,pdgsum2 number(24,6) -- 手续费金额(元)(承兑汇票)
    ,depositbaserate number(15,8) -- 存款基准利率
    ,lcsum number(24,6) -- 信用证金额（元）
    ,traderate2 number(10,6) -- 贸易融资相关比例或利率2
    ,tradecurrecy1 varchar2(18) -- 贸易融资相关币种1
    ,isfinanceguarantee varchar2(1) -- 是否融资性保函
    ,putoutno varchar2(40) -- 出账号
    ,bailpdrifd varchar2(3) -- 保证金利率浮动类型
    ,depositterm number(10,0) -- 存期期限
    ,billclass varchar2(16) -- 票据种类
    ,tradesum3 number(24,6) -- 贸易融资相关金额3
    ,tradecurrecy3 varchar2(18) -- 贸易融资相关币种3
    ,queryabnormitything varchar2(2) -- 贷款卡当日查询是否有异常情况
    ,creditaggreement varchar2(32) -- 使用授信额度协议号
    ,exchangetype varchar2(18) -- 出帐交易代码
    ,bailterm varchar2(4) -- 保证金利率档次
    ,bailpdrifv number(11,7) -- 保证金浮动值
    ,interestreturnflag varchar2(1) -- 利息自动归还标志
    ,compoundintflag varchar2(1) -- 是否收复息标志
    ,chargepost varchar2(100) -- 职务（福费廷用）
    ,isbankaccount varchar2(1) -- 受益人账号是否本行
    ,fixcyc number(22) -- 计息天数
    ,ordinaryormonthly varchar2(18) -- 普通分期还款标志
    ,unpaidbankname varchar2(200) -- 代付行名称
    ,approvedate varchar2(10) -- 复核日期
    ,linkemail varchar2(40) -- 联系人电子邮箱（福费廷用）
    ,discountsum number(24,6) -- 利息金额
    ,loanaccountno2 varchar2(64) -- 贷款帐号
    ,abnormitything varchar2(1000) -- 贷款卡异常情况说明
    ,tradeserialno2 varchar2(40) -- 贸易融资业务编号2
    ,bailinterestmethod varchar2(10) -- 保证金计息方法
    ,trantp varchar2(2) -- 手续费收费方式(票据)
    ,poolfinancingflag varchar2(1) -- 是否已签订池融资协议
    ,isbelongterm varchar2(2) -- 是否靠档计息
    ,contractsignfee number(24,6) -- 签约手续费
    ,aboutbankid varchar2(64) -- 信用证受益人客户号
    ,isfixedrate varchar2(10) -- 利率是否固定
    ,opencustomer varchar2(200) -- 信用证开证人
    ,sellstatus varchar2(10) -- 卖出状态
    ,otherreceivedbankno varchar2(14) -- 对方收款行号
    ,otherreceivedname varchar2(32) -- 对方收款账号
    ,otherreceivedaccname varchar2(128) -- 对方收款户名
    ,otherreceivedbankname varchar2(128) -- 对方收款行名称
    ,creditbeneficiary varchar2(200) -- 信用证收益人名称
    ,actualloanaccountno varchar2(64) -- 贷款实际入账账号
    ,replaceolddept varchar2(1) -- 是否置换旧债
    ,isproxydp varchar2(4) -- 是否代理交单
    ,sqdkze number(18,2) -- 申请银团贷款总额
    ,socialcreditcode varchar2(100) -- 统一社会信用代码
    ,buychannel varchar2(4) -- 买入渠道
    ,islinkoutpay varchar2(4) -- 是否联动对外支付
    ,post varchar2(256) -- 附言
    ,payinterestcustomer varchar2(10) -- 付息客户
    ,purchasercustflag varchar2(10) -- 买方是否为我行客户
    ,othercustomerid varchar2(64) -- 买方客户号
    ,othercustomername varchar2(200) -- 买方客户名称
    ,finalmerger varchar2(10) -- 是否末期合并：0否，1是
    ,lcsumrate number(15,8) -- 信用证金额上浮比例
    ,linkchargeintflag varchar2(10) -- 是否联动扣收利息
    ,isactualddamtflag varchar2(2) -- 是否按实际放款金额冻结标志
    ,maxpdrifv number(11,7) -- 保证金浮动上限
    ,ismergeentrpayment varchar2(10) -- 是否合并受托支付
    ,ownfunds number(24,6) -- 自有资金
    ,ownfundsacctno varchar2(64) -- 自有资金账号
    ,ownfundsacctname varchar2(64) -- 自有资金账户名称
    ,ownfundsacctccy varchar2(10) -- 自有资金账户币种
    ,arrivalnumbers varchar2(32) -- 到单编号
    ,claimamount number(24,6) -- 索偿金额
    ,businessamount number(24,6) -- 业务金额
    ,marketflows varchar2(6) -- 市场流转次数，含到我行
    ,servicecontent varchar2(600) -- 货物/服务品种
    ,scanstatus varchar2(10) -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
    ,priceorderno varchar2(128) -- 定价单号
    ,priceapprovestatus varchar2(10) -- 定价单审批状态
    ,priceenddate varchar2(10) -- 定价单生效截止日
    ,pledgetype varchar2(10) -- 质押类型
    ,submitputoutcentertime date -- 提交放款中心时间
    ,iscentralizedaccount varchar2(5) -- 是否集中出账
    ,issuedbusinessno varchar2(100) -- 代开保函业务编号
    ,bhstartdate date -- 保函生效日期
    ,bhmaturity date -- 保函失效日期
    ,guaranteebusinessno varchar2(100) -- 保函业务编号
    ,guaranteesum number(24,6) -- 保函金额
    ,issuedate date -- 开立日期
    ,guaranteeputoutstatus varchar2(4) -- 保函信息状态(code:guaranteeputoutstatus)
    ,isreplenishment varchar2(10) -- 是否补录完成
    ,scanuserid varchar2(8) -- 扫描人
    ,scanusername varchar2(200) -- 扫描人名称
    ,bizuniqueno varchar2(200) -- 业务唯一流水号（票据/供应链）
    ,isxdapprove varchar2(2) -- 是否信贷审批（票据/供应链推送流程）
    ,isignoreresult varchar2(2) -- 是否忽略不动产查册策略结果
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_bp_extend_d to ${iml_schema};
grant select on ${iol_schema}.icms_bp_extend_d to ${icl_schema};
grant select on ${iol_schema}.icms_bp_extend_d to ${idl_schema};
grant select on ${iol_schema}.icms_bp_extend_d to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bp_extend_d is '对公传统信贷业务出账附表';
comment on column ${iol_schema}.icms_bp_extend_d.serialno is '出账流水号';
comment on column ${iol_schema}.icms_bp_extend_d.billtype is '票据类型';
comment on column ${iol_schema}.icms_bp_extend_d.careflag is '是否托管';
comment on column ${iol_schema}.icms_bp_extend_d.paybankname is '代付行';
comment on column ${iol_schema}.icms_bp_extend_d.keyno is '票据唯一标识号';
comment on column ${iol_schema}.icms_bp_extend_d.tradesum1 is '贸易融资相关金额1';
comment on column ${iol_schema}.icms_bp_extend_d.chaggeaddress is '地址（福费廷用）';
comment on column ${iol_schema}.icms_bp_extend_d.tradesum2 is '贸易融资相关金额2';
comment on column ${iol_schema}.icms_bp_extend_d.resumeinttype is '计复息标志';
comment on column ${iol_schema}.icms_bp_extend_d.linkname is '联系人（福费廷用）';
comment on column ${iol_schema}.icms_bp_extend_d.aboutbankname is '受益人、收款人开户行行名';
comment on column ${iol_schema}.icms_bp_extend_d.bailpdrifm is '保证金利率浮动方式';
comment on column ${iol_schema}.icms_bp_extend_d.bfintg is '是否预收息or先付利息摊销标志';
comment on column ${iol_schema}.icms_bp_extend_d.accountopenbankname is '结算帐号开户行名称';
comment on column ${iol_schema}.icms_bp_extend_d.bailmaturity is '保证金到期日';
comment on column ${iol_schema}.icms_bp_extend_d.capitalreturnflag is '本金自动归还标志';
comment on column ${iol_schema}.icms_bp_extend_d.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_bp_extend_d.fbsnumber is '信用证编号\业务编号FBS';
comment on column ${iol_schema}.icms_bp_extend_d.assureorgid is '担保机构编号(我行分支机构)';
comment on column ${iol_schema}.icms_bp_extend_d.invoicenumber is '发票号码';
comment on column ${iol_schema}.icms_bp_extend_d.tradetype1 is '代收或托收类型';
comment on column ${iol_schema}.icms_bp_extend_d.bailexchangestate is '保证金交易状态';
comment on column ${iol_schema}.icms_bp_extend_d.cdexchangedate is '承兑记账交易日期';
comment on column ${iol_schema}.icms_bp_extend_d.acptdate is '出票日';
comment on column ${iol_schema}.icms_bp_extend_d.loantype is '贷款类型';
comment on column ${iol_schema}.icms_bp_extend_d.czflag is '冲账标志';
comment on column ${iol_schema}.icms_bp_extend_d.paymode is '保函支付方式';
comment on column ${iol_schema}.icms_bp_extend_d.acceptorname is '承兑人名称';
comment on column ${iol_schema}.icms_bp_extend_d.othertxbalance is '买方付息金额';
comment on column ${iol_schema}.icms_bp_extend_d.accountnocustomer is '结算帐号客户名称';
comment on column ${iol_schema}.icms_bp_extend_d.tradedate1 is '贸易融资相关日期1';
comment on column ${iol_schema}.icms_bp_extend_d.acceptorbankname is '承兑人开户行名称';
comment on column ${iol_schema}.icms_bp_extend_d.compoundintratio is '复利利率';
comment on column ${iol_schema}.icms_bp_extend_d.textno is '总合同文本编号（福费廷用）';
comment on column ${iol_schema}.icms_bp_extend_d.instrt is '同业代付计提利率（%）';
comment on column ${iol_schema}.icms_bp_extend_d.tradecurrecy2 is '贸易融资相关币种2';
comment on column ${iol_schema}.icms_bp_extend_d.repaymentplanflag is '信贷发放还款计划标志';
comment on column ${iol_schema}.icms_bp_extend_d.chargephone is '电话（福费廷用）';
comment on column ${iol_schema}.icms_bp_extend_d.tradetermmonth2 is '贸易融资相关期限2';
comment on column ${iol_schema}.icms_bp_extend_d.ratestartmode is '利率启用方式';
comment on column ${iol_schema}.icms_bp_extend_d.autocontrolflag is '自动回收控制开关';
comment on column ${iol_schema}.icms_bp_extend_d.loantermthing is '放款条件是否落实';
comment on column ${iol_schema}.icms_bp_extend_d.bailfxfltp is '保证金利率类型';
comment on column ${iol_schema}.icms_bp_extend_d.gatheringname is '收票人全称';
comment on column ${iol_schema}.icms_bp_extend_d.principalaccountno is '委托存款账号';
comment on column ${iol_schema}.icms_bp_extend_d.openbankname is '出口信用证开证行名称、开证行ID';
comment on column ${iol_schema}.icms_bp_extend_d.aboutbankname2 is '保函受益人';
comment on column ${iol_schema}.icms_bp_extend_d.preinttype is '预收息标志';
comment on column ${iol_schema}.icms_bp_extend_d.loantermcontrolflag is '出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验';
comment on column ${iol_schema}.icms_bp_extend_d.acceptancebank is '承兑行行号（福费廷）';
comment on column ${iol_schema}.icms_bp_extend_d.tradedate2 is '贸易融资相关日期2';
comment on column ${iol_schema}.icms_bp_extend_d.otherdraweracctno is '买方付息账户号';
comment on column ${iol_schema}.icms_bp_extend_d.principalsubaccountno is '委托存款子户号';
comment on column ${iol_schema}.icms_bp_extend_d.continuepayflag is '持续扣款标志';
comment on column ${iol_schema}.icms_bp_extend_d.billno is '票据号码';
comment on column ${iol_schema}.icms_bp_extend_d.approveorgid is '复核机构';
comment on column ${iol_schema}.icms_bp_extend_d.clientaccountno is '委托人存款账号';
comment on column ${iol_schema}.icms_bp_extend_d.repayexchangestate is '还款计划交易状态';
comment on column ${iol_schema}.icms_bp_extend_d.chargename is '负责人（福费廷用）';
comment on column ${iol_schema}.icms_bp_extend_d.commercetype is '贸易融资类型';
comment on column ${iol_schema}.icms_bp_extend_d.tradetermmonth1 is '贸易融资相关期限1';
comment on column ${iol_schema}.icms_bp_extend_d.dprinpaymethod is '代付本金还款方式';
comment on column ${iol_schema}.icms_bp_extend_d.lprtype is 'LPR参照方式';
comment on column ${iol_schema}.icms_bp_extend_d.loanaccountnoorgname is '贷款帐号开户行名称';
comment on column ${iol_schema}.icms_bp_extend_d.isrz is '是否融资系统出账1是0否';
comment on column ${iol_schema}.icms_bp_extend_d.period is '分期贷款总期数';
comment on column ${iol_schema}.icms_bp_extend_d.approveuserid is '复核人';
comment on column ${iol_schema}.icms_bp_extend_d.traderate1 is '福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）';
comment on column ${iol_schema}.icms_bp_extend_d.repurchaseflag is '是否回购（赎回）';
comment on column ${iol_schema}.icms_bp_extend_d.deposittermtype is '保证金期限类型';
comment on column ${iol_schema}.icms_bp_extend_d.linkphone is '联系人手机号（福费廷用）';
comment on column ${iol_schema}.icms_bp_extend_d.termtype is '期限类型';
comment on column ${iol_schema}.icms_bp_extend_d.loanaccountnocustomer is '贷款帐号客户名称';
comment on column ${iol_schema}.icms_bp_extend_d.pdgpaypercent2 is '手续费率(委托贷款)';
comment on column ${iol_schema}.icms_bp_extend_d.bailinterestrate is '保证金协议利率';
comment on column ${iol_schema}.icms_bp_extend_d.cdexchangeno is '承兑记账交易流水号';
comment on column ${iol_schema}.icms_bp_extend_d.businesssubtype is '保函类型';
comment on column ${iol_schema}.icms_bp_extend_d.tradeserialno1 is '贸易融资业务编号1';
comment on column ${iol_schema}.icms_bp_extend_d.txregister is '票据登记状态';
comment on column ${iol_schema}.icms_bp_extend_d.amlresult is '反洗钱评级结果';
comment on column ${iol_schema}.icms_bp_extend_d.compoundintfloatvalue is '复利利率浮动比例';
comment on column ${iol_schema}.icms_bp_extend_d.paysum is '工本费';
comment on column ${iol_schema}.icms_bp_extend_d.name1 is '汇票承兑人名称';
comment on column ${iol_schema}.icms_bp_extend_d.fundsource is '资金来源';
comment on column ${iol_schema}.icms_bp_extend_d.stopintflag is '是否停息';
comment on column ${iol_schema}.icms_bp_extend_d.lnbal is '同业代付本金';
comment on column ${iol_schema}.icms_bp_extend_d.acceptorbankno is '承兑人开户行行号';
comment on column ${iol_schema}.icms_bp_extend_d.confirmingbank is '保兑行行号（福费廷）';
comment on column ${iol_schema}.icms_bp_extend_d.chargefax is '传真（福费廷用）';
comment on column ${iol_schema}.icms_bp_extend_d.pdgsum2 is '手续费金额(元)(承兑汇票)';
comment on column ${iol_schema}.icms_bp_extend_d.depositbaserate is '存款基准利率';
comment on column ${iol_schema}.icms_bp_extend_d.lcsum is '信用证金额（元）';
comment on column ${iol_schema}.icms_bp_extend_d.traderate2 is '贸易融资相关比例或利率2';
comment on column ${iol_schema}.icms_bp_extend_d.tradecurrecy1 is '贸易融资相关币种1';
comment on column ${iol_schema}.icms_bp_extend_d.isfinanceguarantee is '是否融资性保函';
comment on column ${iol_schema}.icms_bp_extend_d.putoutno is '出账号';
comment on column ${iol_schema}.icms_bp_extend_d.bailpdrifd is '保证金利率浮动类型';
comment on column ${iol_schema}.icms_bp_extend_d.depositterm is '存期期限';
comment on column ${iol_schema}.icms_bp_extend_d.billclass is '票据种类';
comment on column ${iol_schema}.icms_bp_extend_d.tradesum3 is '贸易融资相关金额3';
comment on column ${iol_schema}.icms_bp_extend_d.tradecurrecy3 is '贸易融资相关币种3';
comment on column ${iol_schema}.icms_bp_extend_d.queryabnormitything is '贷款卡当日查询是否有异常情况';
comment on column ${iol_schema}.icms_bp_extend_d.creditaggreement is '使用授信额度协议号';
comment on column ${iol_schema}.icms_bp_extend_d.exchangetype is '出帐交易代码';
comment on column ${iol_schema}.icms_bp_extend_d.bailterm is '保证金利率档次';
comment on column ${iol_schema}.icms_bp_extend_d.bailpdrifv is '保证金浮动值';
comment on column ${iol_schema}.icms_bp_extend_d.interestreturnflag is '利息自动归还标志';
comment on column ${iol_schema}.icms_bp_extend_d.compoundintflag is '是否收复息标志';
comment on column ${iol_schema}.icms_bp_extend_d.chargepost is '职务（福费廷用）';
comment on column ${iol_schema}.icms_bp_extend_d.isbankaccount is '受益人账号是否本行';
comment on column ${iol_schema}.icms_bp_extend_d.fixcyc is '计息天数';
comment on column ${iol_schema}.icms_bp_extend_d.ordinaryormonthly is '普通分期还款标志';
comment on column ${iol_schema}.icms_bp_extend_d.unpaidbankname is '代付行名称';
comment on column ${iol_schema}.icms_bp_extend_d.approvedate is '复核日期';
comment on column ${iol_schema}.icms_bp_extend_d.linkemail is '联系人电子邮箱（福费廷用）';
comment on column ${iol_schema}.icms_bp_extend_d.discountsum is '利息金额';
comment on column ${iol_schema}.icms_bp_extend_d.loanaccountno2 is '贷款帐号';
comment on column ${iol_schema}.icms_bp_extend_d.abnormitything is '贷款卡异常情况说明';
comment on column ${iol_schema}.icms_bp_extend_d.tradeserialno2 is '贸易融资业务编号2';
comment on column ${iol_schema}.icms_bp_extend_d.bailinterestmethod is '保证金计息方法';
comment on column ${iol_schema}.icms_bp_extend_d.trantp is '手续费收费方式(票据)';
comment on column ${iol_schema}.icms_bp_extend_d.poolfinancingflag is '是否已签订池融资协议';
comment on column ${iol_schema}.icms_bp_extend_d.isbelongterm is '是否靠档计息';
comment on column ${iol_schema}.icms_bp_extend_d.contractsignfee is '签约手续费';
comment on column ${iol_schema}.icms_bp_extend_d.aboutbankid is '信用证受益人客户号';
comment on column ${iol_schema}.icms_bp_extend_d.isfixedrate is '利率是否固定';
comment on column ${iol_schema}.icms_bp_extend_d.opencustomer is '信用证开证人';
comment on column ${iol_schema}.icms_bp_extend_d.sellstatus is '卖出状态';
comment on column ${iol_schema}.icms_bp_extend_d.otherreceivedbankno is '对方收款行号';
comment on column ${iol_schema}.icms_bp_extend_d.otherreceivedname is '对方收款账号';
comment on column ${iol_schema}.icms_bp_extend_d.otherreceivedaccname is '对方收款户名';
comment on column ${iol_schema}.icms_bp_extend_d.otherreceivedbankname is '对方收款行名称';
comment on column ${iol_schema}.icms_bp_extend_d.creditbeneficiary is '信用证收益人名称';
comment on column ${iol_schema}.icms_bp_extend_d.actualloanaccountno is '贷款实际入账账号';
comment on column ${iol_schema}.icms_bp_extend_d.replaceolddept is '是否置换旧债';
comment on column ${iol_schema}.icms_bp_extend_d.isproxydp is '是否代理交单';
comment on column ${iol_schema}.icms_bp_extend_d.sqdkze is '申请银团贷款总额';
comment on column ${iol_schema}.icms_bp_extend_d.socialcreditcode is '统一社会信用代码';
comment on column ${iol_schema}.icms_bp_extend_d.buychannel is '买入渠道';
comment on column ${iol_schema}.icms_bp_extend_d.islinkoutpay is '是否联动对外支付';
comment on column ${iol_schema}.icms_bp_extend_d.post is '附言';
comment on column ${iol_schema}.icms_bp_extend_d.payinterestcustomer is '付息客户';
comment on column ${iol_schema}.icms_bp_extend_d.purchasercustflag is '买方是否为我行客户';
comment on column ${iol_schema}.icms_bp_extend_d.othercustomerid is '买方客户号';
comment on column ${iol_schema}.icms_bp_extend_d.othercustomername is '买方客户名称';
comment on column ${iol_schema}.icms_bp_extend_d.finalmerger is '是否末期合并：0否，1是';
comment on column ${iol_schema}.icms_bp_extend_d.lcsumrate is '信用证金额上浮比例';
comment on column ${iol_schema}.icms_bp_extend_d.linkchargeintflag is '是否联动扣收利息';
comment on column ${iol_schema}.icms_bp_extend_d.isactualddamtflag is '是否按实际放款金额冻结标志';
comment on column ${iol_schema}.icms_bp_extend_d.maxpdrifv is '保证金浮动上限';
comment on column ${iol_schema}.icms_bp_extend_d.ismergeentrpayment is '是否合并受托支付';
comment on column ${iol_schema}.icms_bp_extend_d.ownfunds is '自有资金';
comment on column ${iol_schema}.icms_bp_extend_d.ownfundsacctno is '自有资金账号';
comment on column ${iol_schema}.icms_bp_extend_d.ownfundsacctname is '自有资金账户名称';
comment on column ${iol_schema}.icms_bp_extend_d.ownfundsacctccy is '自有资金账户币种';
comment on column ${iol_schema}.icms_bp_extend_d.arrivalnumbers is '到单编号';
comment on column ${iol_schema}.icms_bp_extend_d.claimamount is '索偿金额';
comment on column ${iol_schema}.icms_bp_extend_d.businessamount is '业务金额';
comment on column ${iol_schema}.icms_bp_extend_d.marketflows is '市场流转次数，含到我行';
comment on column ${iol_schema}.icms_bp_extend_d.servicecontent is '货物/服务品种';
comment on column ${iol_schema}.icms_bp_extend_d.scanstatus is '扫描任务状态(0-扫描中、1-扫描完成、2-撤销)';
comment on column ${iol_schema}.icms_bp_extend_d.priceorderno is '定价单号';
comment on column ${iol_schema}.icms_bp_extend_d.priceapprovestatus is '定价单审批状态';
comment on column ${iol_schema}.icms_bp_extend_d.priceenddate is '定价单生效截止日';
comment on column ${iol_schema}.icms_bp_extend_d.pledgetype is '质押类型';
comment on column ${iol_schema}.icms_bp_extend_d.submitputoutcentertime is '提交放款中心时间';
comment on column ${iol_schema}.icms_bp_extend_d.iscentralizedaccount is '是否集中出账';
comment on column ${iol_schema}.icms_bp_extend_d.issuedbusinessno is '代开保函业务编号';
comment on column ${iol_schema}.icms_bp_extend_d.bhstartdate is '保函生效日期';
comment on column ${iol_schema}.icms_bp_extend_d.bhmaturity is '保函失效日期';
comment on column ${iol_schema}.icms_bp_extend_d.guaranteebusinessno is '保函业务编号';
comment on column ${iol_schema}.icms_bp_extend_d.guaranteesum is '保函金额';
comment on column ${iol_schema}.icms_bp_extend_d.issuedate is '开立日期';
comment on column ${iol_schema}.icms_bp_extend_d.guaranteeputoutstatus is '保函信息状态(code:guaranteeputoutstatus)';
comment on column ${iol_schema}.icms_bp_extend_d.isreplenishment is '是否补录完成';
comment on column ${iol_schema}.icms_bp_extend_d.scanuserid is '扫描人';
comment on column ${iol_schema}.icms_bp_extend_d.scanusername is '扫描人名称';
comment on column ${iol_schema}.icms_bp_extend_d.bizuniqueno is '业务唯一流水号（票据/供应链）';
comment on column ${iol_schema}.icms_bp_extend_d.isxdapprove is '是否信贷审批（票据/供应链推送流程）';
comment on column ${iol_schema}.icms_bp_extend_d.isignoreresult is '是否忽略不动产查册策略结果';
comment on column ${iol_schema}.icms_bp_extend_d.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bp_extend_d.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bp_extend_d.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bp_extend_d.etl_timestamp is 'ETL处理时间戳';
