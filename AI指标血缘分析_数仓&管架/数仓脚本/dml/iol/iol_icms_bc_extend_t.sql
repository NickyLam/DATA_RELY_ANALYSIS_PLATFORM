/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bc_extend_t
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
create table ${iol_schema}.icms_bc_extend_t_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bc_extend_t
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bc_extend_t_op purge;
drop table ${iol_schema}.icms_bc_extend_t_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bc_extend_t_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bc_extend_t where 0=1;

create table ${iol_schema}.icms_bc_extend_t_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bc_extend_t where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bc_extend_t_cl(
            serialno -- 合同编号
            ,rivalname -- 交易对手名称
            ,consigneename -- 发行公司名称
            ,consigneecerttype -- 管理人/主承销商证件类型
            ,consigneecertid -- 管理人/主承销商证件号码
            ,financier -- 实际融资人
            ,iscounterparty -- 是否合格中央交易对手
            ,fundsource -- 资金来源
            ,investway -- 投资方式
            ,managemodel -- 管理模式
            ,tradingassets -- 交易资产
            ,toindustryfund -- 是否投向产业基金
            ,isdebttoequity -- 是否投向市场化债转股
            ,isgovernfinance -- 是否涉及政府类融资
            ,isconsumerfinance -- 是否为消费服务类融资
            ,bondno -- 标的产品编号
            ,bondname -- 标的产品名称
            ,investkind -- 投资性质
            ,canseparate -- 是否可分离
            ,canbacktosale -- 是否含有回售选择权
            ,salebackbegindate -- 回售申请起始日
            ,salebackenddate -- 回售申请截止日
            ,businessmarkettype -- 交易市场类型
            ,businessmarketname -- 交易市场名称
            ,begindate -- 债券发行日期
            ,paymentdate -- 协议到期日期
            ,outerevaluate1 -- 债券外部评级结果（发行时）
            ,outerevaluate2 -- 债券外部评级结果（购买时）
            ,outerevaluate3 -- 债券外部评级结果（当前）
            ,couponrate -- 票面利率
            ,transactionprice -- 成交净价
            ,transactionrate -- 成交利率
            ,transactoinamount -- 成交量
            ,transactiondate -- 实际交割日期
            ,creditincrementtype -- 主要增信方式
            ,islikeloan -- 是否类信贷
            ,isclassflag -- 是否分级
            ,productlevel -- 产品分级级别
            ,productcollectmoney -- 债券面值
            ,finalinvestdirecttype -- 最终投向类型
            ,mandatecustname -- 委托人名称
            ,mandatecustid -- 委托人ID
            ,acceptbankid -- 承兑行行号
            ,billacptdate -- 出票日(票据)
            ,billcurrency -- 票据币种(票据)
            ,billmaturity -- 到期日(票据)
            ,chuantoutype -- 穿透类型
            ,econtractname -- 合同名称(信托资管)
            ,econtracttype -- 合同类型(信托资管)
            ,guarantytype -- 担保/操作模式(担保切分必选项)
            ,guranteerate -- 质押率/初始履约保障比例
            ,contractitems -- 合同期次
            ,importantloan -- 重点贷款项目
            ,operationtype -- 业务类型
            ,acceptbankname -- 承兑行名称
            ,backtosaletype -- 回购类型
            ,beneficiaryacctno -- 受益人账户
            ,ifgudingcredit -- 是否固定资产授信
            ,manageratetype -- 管理费费率及计提方式
            ,othercondition -- 其他条件和要求
            ,subtotalprices -- 认购总价
            ,ztacceptbankid -- 直贴行行号
            ,corpuspaymethod -- 还款方式
            ,creditattribute -- 合同类型
            ,depositratetype -- 托管费费率及计提方式
            ,expectyieldrate -- 预期收益率
            ,isimportantloan -- 是否重点项目贷款
            ,tradecontractno -- 贸易合同号
            ,acceptcustomerid -- 承兑行我行客户编号
            ,entrustyieldtype -- 信托收益计提方式
            ,isbalancedeposit -- 是否结算性存款
            ,isfillassetsinfo -- 是否已完整录入全部底层资产信息
            ,raisefundpurpose -- 募集资金用途
            ,ztacceptbankname -- 直贴行名称
            ,raisemoneyaccountid -- 募集资金账户
            ,repayinteresttype -- 还本付息方式(输入)
            ,businessinvoicesum -- 商业发票金额
            ,financesupportmode -- 贷款财政扶持方式
            ,businessinvoiceinfo -- 商业发票号码
            ,businessinvoicetype -- 商业发票种类
            ,entrustinterestrate -- 信托报酬率
            ,rateexplain -- 利率/费率说明
            ,beneficiaryyieldrate -- 受益人的预计年净收益率
            ,circulatestockamount -- 流通股本(万股)
            ,issupplychainfinance -- 是否为供应链金融业务
            ,relztacceptbankcustid -- 直贴行我行客户编号
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,businessinvoicecurrency -- 商业发票币种
            ,entrustinterestratetype -- 信托报酬率计提方式
            ,gshy -- 过剩行业
            ,baileename -- 受托人名称
            ,billno -- 票据号码
            ,gksxpz -- 国开授信品种
            ,issuer -- 发行人/融资者
            ,iswhzt -- 是否我行直贴票据
            ,pcline -- 平仓线
            ,sfgksx -- 是否国开行授信
            ,sfzfsx -- 是否政府授信
            ,zfsxfs -- 政府授信支持方式
            ,zfsxlx -- 政府授信类型
            ,ztrate -- 转贴现利率(%)
            ,billsum -- 票面金额（元）
            ,enddate -- 到期日期(ABS)
            ,tdtimes -- 与交易对手成功交易次数
            ,tdyears -- 与交易对手合作年限
            ,trusteename -- 托管人名称
            ,billkind -- 票据种类
            ,billtype -- 票据类型
            ,deadline -- 期限(标的)
            ,issuesum -- 发行金额(元)
            ,sfgjxzhy -- 是否国家限制行业
            ,tradesum -- 贸易合同总金额(元)
            ,alarmline -- 预警线
            ,custodianname -- 管理人名称
            ,depositno -- 存单号码
            ,isfarming -- 是否涉农贷款标志
            ,repayremark -- 还款说明
            ,stockcode -- 标的股票代码
            ,stockname -- 标的股票名称
            ,tdstrenth -- 交易对手实力
            ,absabnname -- ABS/ABN名称
            ,bdindustry -- 标的公司行业分类
            ,billwriter -- 出票人
            ,entrustacc -- 信托专户
            ,issueprice -- 发行价格
            ,issuescale -- 发行规模
            ,partybname -- 借款人
            ,priequname -- 私募债名称
            ,subscriber -- 认购人/投资者
            ,useproduct -- 使用产品（贸易融资）
            ,contextinfo -- 交易背景描述
            ,drawingremark -- 提款说明
            ,contractsum -- 合同资金(信托资管)
            ,depositname -- 存单简称
            ,directionrs -- 行业投向(征信)
            ,drawingtype -- 提款方式
            ,issueamount -- 发行量(元)
            ,mainproduct -- 经营商品（贸易融资）
            ,stockamount -- 总股本(万股)
            ,beneficiaryname -- 受益人名称
            ,consigneeid -- 管理人/主承销商客户编号
            ,rivalid -- 同业交易对手
            ,datatype -- 业务来源（PJ,票据系统供数 LC,理财资管系统供数 ZJ,资金系统供数 ZH,同业综合业务系统供数）
            ,accountcatagory -- 账户类别
            ,migtflag -- 迁移标志
            ,assetno -- 资产唯一标识
            ,interestrepaycycle -- 
            ,shortbondno -- 
            ,oldassetno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bc_extend_t_op(
            serialno -- 合同编号
            ,rivalname -- 交易对手名称
            ,consigneename -- 发行公司名称
            ,consigneecerttype -- 管理人/主承销商证件类型
            ,consigneecertid -- 管理人/主承销商证件号码
            ,financier -- 实际融资人
            ,iscounterparty -- 是否合格中央交易对手
            ,fundsource -- 资金来源
            ,investway -- 投资方式
            ,managemodel -- 管理模式
            ,tradingassets -- 交易资产
            ,toindustryfund -- 是否投向产业基金
            ,isdebttoequity -- 是否投向市场化债转股
            ,isgovernfinance -- 是否涉及政府类融资
            ,isconsumerfinance -- 是否为消费服务类融资
            ,bondno -- 标的产品编号
            ,bondname -- 标的产品名称
            ,investkind -- 投资性质
            ,canseparate -- 是否可分离
            ,canbacktosale -- 是否含有回售选择权
            ,salebackbegindate -- 回售申请起始日
            ,salebackenddate -- 回售申请截止日
            ,businessmarkettype -- 交易市场类型
            ,businessmarketname -- 交易市场名称
            ,begindate -- 债券发行日期
            ,paymentdate -- 协议到期日期
            ,outerevaluate1 -- 债券外部评级结果（发行时）
            ,outerevaluate2 -- 债券外部评级结果（购买时）
            ,outerevaluate3 -- 债券外部评级结果（当前）
            ,couponrate -- 票面利率
            ,transactionprice -- 成交净价
            ,transactionrate -- 成交利率
            ,transactoinamount -- 成交量
            ,transactiondate -- 实际交割日期
            ,creditincrementtype -- 主要增信方式
            ,islikeloan -- 是否类信贷
            ,isclassflag -- 是否分级
            ,productlevel -- 产品分级级别
            ,productcollectmoney -- 债券面值
            ,finalinvestdirecttype -- 最终投向类型
            ,mandatecustname -- 委托人名称
            ,mandatecustid -- 委托人ID
            ,acceptbankid -- 承兑行行号
            ,billacptdate -- 出票日(票据)
            ,billcurrency -- 票据币种(票据)
            ,billmaturity -- 到期日(票据)
            ,chuantoutype -- 穿透类型
            ,econtractname -- 合同名称(信托资管)
            ,econtracttype -- 合同类型(信托资管)
            ,guarantytype -- 担保/操作模式(担保切分必选项)
            ,guranteerate -- 质押率/初始履约保障比例
            ,contractitems -- 合同期次
            ,importantloan -- 重点贷款项目
            ,operationtype -- 业务类型
            ,acceptbankname -- 承兑行名称
            ,backtosaletype -- 回购类型
            ,beneficiaryacctno -- 受益人账户
            ,ifgudingcredit -- 是否固定资产授信
            ,manageratetype -- 管理费费率及计提方式
            ,othercondition -- 其他条件和要求
            ,subtotalprices -- 认购总价
            ,ztacceptbankid -- 直贴行行号
            ,corpuspaymethod -- 还款方式
            ,creditattribute -- 合同类型
            ,depositratetype -- 托管费费率及计提方式
            ,expectyieldrate -- 预期收益率
            ,isimportantloan -- 是否重点项目贷款
            ,tradecontractno -- 贸易合同号
            ,acceptcustomerid -- 承兑行我行客户编号
            ,entrustyieldtype -- 信托收益计提方式
            ,isbalancedeposit -- 是否结算性存款
            ,isfillassetsinfo -- 是否已完整录入全部底层资产信息
            ,raisefundpurpose -- 募集资金用途
            ,ztacceptbankname -- 直贴行名称
            ,raisemoneyaccountid -- 募集资金账户
            ,repayinteresttype -- 还本付息方式(输入)
            ,businessinvoicesum -- 商业发票金额
            ,financesupportmode -- 贷款财政扶持方式
            ,businessinvoiceinfo -- 商业发票号码
            ,businessinvoicetype -- 商业发票种类
            ,entrustinterestrate -- 信托报酬率
            ,rateexplain -- 利率/费率说明
            ,beneficiaryyieldrate -- 受益人的预计年净收益率
            ,circulatestockamount -- 流通股本(万股)
            ,issupplychainfinance -- 是否为供应链金融业务
            ,relztacceptbankcustid -- 直贴行我行客户编号
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,businessinvoicecurrency -- 商业发票币种
            ,entrustinterestratetype -- 信托报酬率计提方式
            ,gshy -- 过剩行业
            ,baileename -- 受托人名称
            ,billno -- 票据号码
            ,gksxpz -- 国开授信品种
            ,issuer -- 发行人/融资者
            ,iswhzt -- 是否我行直贴票据
            ,pcline -- 平仓线
            ,sfgksx -- 是否国开行授信
            ,sfzfsx -- 是否政府授信
            ,zfsxfs -- 政府授信支持方式
            ,zfsxlx -- 政府授信类型
            ,ztrate -- 转贴现利率(%)
            ,billsum -- 票面金额（元）
            ,enddate -- 到期日期(ABS)
            ,tdtimes -- 与交易对手成功交易次数
            ,tdyears -- 与交易对手合作年限
            ,trusteename -- 托管人名称
            ,billkind -- 票据种类
            ,billtype -- 票据类型
            ,deadline -- 期限(标的)
            ,issuesum -- 发行金额(元)
            ,sfgjxzhy -- 是否国家限制行业
            ,tradesum -- 贸易合同总金额(元)
            ,alarmline -- 预警线
            ,custodianname -- 管理人名称
            ,depositno -- 存单号码
            ,isfarming -- 是否涉农贷款标志
            ,repayremark -- 还款说明
            ,stockcode -- 标的股票代码
            ,stockname -- 标的股票名称
            ,tdstrenth -- 交易对手实力
            ,absabnname -- ABS/ABN名称
            ,bdindustry -- 标的公司行业分类
            ,billwriter -- 出票人
            ,entrustacc -- 信托专户
            ,issueprice -- 发行价格
            ,issuescale -- 发行规模
            ,partybname -- 借款人
            ,priequname -- 私募债名称
            ,subscriber -- 认购人/投资者
            ,useproduct -- 使用产品（贸易融资）
            ,contextinfo -- 交易背景描述
            ,drawingremark -- 提款说明
            ,contractsum -- 合同资金(信托资管)
            ,depositname -- 存单简称
            ,directionrs -- 行业投向(征信)
            ,drawingtype -- 提款方式
            ,issueamount -- 发行量(元)
            ,mainproduct -- 经营商品（贸易融资）
            ,stockamount -- 总股本(万股)
            ,beneficiaryname -- 受益人名称
            ,consigneeid -- 管理人/主承销商客户编号
            ,rivalid -- 同业交易对手
            ,datatype -- 业务来源（PJ,票据系统供数 LC,理财资管系统供数 ZJ,资金系统供数 ZH,同业综合业务系统供数）
            ,accountcatagory -- 账户类别
            ,migtflag -- 迁移标志
            ,assetno -- 资产唯一标识
            ,interestrepaycycle -- 
            ,shortbondno -- 
            ,oldassetno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 合同编号
    ,nvl(n.rivalname, o.rivalname) as rivalname -- 交易对手名称
    ,nvl(n.consigneename, o.consigneename) as consigneename -- 发行公司名称
    ,nvl(n.consigneecerttype, o.consigneecerttype) as consigneecerttype -- 管理人/主承销商证件类型
    ,nvl(n.consigneecertid, o.consigneecertid) as consigneecertid -- 管理人/主承销商证件号码
    ,nvl(n.financier, o.financier) as financier -- 实际融资人
    ,nvl(n.iscounterparty, o.iscounterparty) as iscounterparty -- 是否合格中央交易对手
    ,nvl(n.fundsource, o.fundsource) as fundsource -- 资金来源
    ,nvl(n.investway, o.investway) as investway -- 投资方式
    ,nvl(n.managemodel, o.managemodel) as managemodel -- 管理模式
    ,nvl(n.tradingassets, o.tradingassets) as tradingassets -- 交易资产
    ,nvl(n.toindustryfund, o.toindustryfund) as toindustryfund -- 是否投向产业基金
    ,nvl(n.isdebttoequity, o.isdebttoequity) as isdebttoequity -- 是否投向市场化债转股
    ,nvl(n.isgovernfinance, o.isgovernfinance) as isgovernfinance -- 是否涉及政府类融资
    ,nvl(n.isconsumerfinance, o.isconsumerfinance) as isconsumerfinance -- 是否为消费服务类融资
    ,nvl(n.bondno, o.bondno) as bondno -- 标的产品编号
    ,nvl(n.bondname, o.bondname) as bondname -- 标的产品名称
    ,nvl(n.investkind, o.investkind) as investkind -- 投资性质
    ,nvl(n.canseparate, o.canseparate) as canseparate -- 是否可分离
    ,nvl(n.canbacktosale, o.canbacktosale) as canbacktosale -- 是否含有回售选择权
    ,nvl(n.salebackbegindate, o.salebackbegindate) as salebackbegindate -- 回售申请起始日
    ,nvl(n.salebackenddate, o.salebackenddate) as salebackenddate -- 回售申请截止日
    ,nvl(n.businessmarkettype, o.businessmarkettype) as businessmarkettype -- 交易市场类型
    ,nvl(n.businessmarketname, o.businessmarketname) as businessmarketname -- 交易市场名称
    ,nvl(n.begindate, o.begindate) as begindate -- 债券发行日期
    ,nvl(n.paymentdate, o.paymentdate) as paymentdate -- 协议到期日期
    ,nvl(n.outerevaluate1, o.outerevaluate1) as outerevaluate1 -- 债券外部评级结果（发行时）
    ,nvl(n.outerevaluate2, o.outerevaluate2) as outerevaluate2 -- 债券外部评级结果（购买时）
    ,nvl(n.outerevaluate3, o.outerevaluate3) as outerevaluate3 -- 债券外部评级结果（当前）
    ,nvl(n.couponrate, o.couponrate) as couponrate -- 票面利率
    ,nvl(n.transactionprice, o.transactionprice) as transactionprice -- 成交净价
    ,nvl(n.transactionrate, o.transactionrate) as transactionrate -- 成交利率
    ,nvl(n.transactoinamount, o.transactoinamount) as transactoinamount -- 成交量
    ,nvl(n.transactiondate, o.transactiondate) as transactiondate -- 实际交割日期
    ,nvl(n.creditincrementtype, o.creditincrementtype) as creditincrementtype -- 主要增信方式
    ,nvl(n.islikeloan, o.islikeloan) as islikeloan -- 是否类信贷
    ,nvl(n.isclassflag, o.isclassflag) as isclassflag -- 是否分级
    ,nvl(n.productlevel, o.productlevel) as productlevel -- 产品分级级别
    ,nvl(n.productcollectmoney, o.productcollectmoney) as productcollectmoney -- 债券面值
    ,nvl(n.finalinvestdirecttype, o.finalinvestdirecttype) as finalinvestdirecttype -- 最终投向类型
    ,nvl(n.mandatecustname, o.mandatecustname) as mandatecustname -- 委托人名称
    ,nvl(n.mandatecustid, o.mandatecustid) as mandatecustid -- 委托人ID
    ,nvl(n.acceptbankid, o.acceptbankid) as acceptbankid -- 承兑行行号
    ,nvl(n.billacptdate, o.billacptdate) as billacptdate -- 出票日(票据)
    ,nvl(n.billcurrency, o.billcurrency) as billcurrency -- 票据币种(票据)
    ,nvl(n.billmaturity, o.billmaturity) as billmaturity -- 到期日(票据)
    ,nvl(n.chuantoutype, o.chuantoutype) as chuantoutype -- 穿透类型
    ,nvl(n.econtractname, o.econtractname) as econtractname -- 合同名称(信托资管)
    ,nvl(n.econtracttype, o.econtracttype) as econtracttype -- 合同类型(信托资管)
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 担保/操作模式(担保切分必选项)
    ,nvl(n.guranteerate, o.guranteerate) as guranteerate -- 质押率/初始履约保障比例
    ,nvl(n.contractitems, o.contractitems) as contractitems -- 合同期次
    ,nvl(n.importantloan, o.importantloan) as importantloan -- 重点贷款项目
    ,nvl(n.operationtype, o.operationtype) as operationtype -- 业务类型
    ,nvl(n.acceptbankname, o.acceptbankname) as acceptbankname -- 承兑行名称
    ,nvl(n.backtosaletype, o.backtosaletype) as backtosaletype -- 回购类型
    ,nvl(n.beneficiaryacctno, o.beneficiaryacctno) as beneficiaryacctno -- 受益人账户
    ,nvl(n.ifgudingcredit, o.ifgudingcredit) as ifgudingcredit -- 是否固定资产授信
    ,nvl(n.manageratetype, o.manageratetype) as manageratetype -- 管理费费率及计提方式
    ,nvl(n.othercondition, o.othercondition) as othercondition -- 其他条件和要求
    ,nvl(n.subtotalprices, o.subtotalprices) as subtotalprices -- 认购总价
    ,nvl(n.ztacceptbankid, o.ztacceptbankid) as ztacceptbankid -- 直贴行行号
    ,nvl(n.corpuspaymethod, o.corpuspaymethod) as corpuspaymethod -- 还款方式
    ,nvl(n.creditattribute, o.creditattribute) as creditattribute -- 合同类型
    ,nvl(n.depositratetype, o.depositratetype) as depositratetype -- 托管费费率及计提方式
    ,nvl(n.expectyieldrate, o.expectyieldrate) as expectyieldrate -- 预期收益率
    ,nvl(n.isimportantloan, o.isimportantloan) as isimportantloan -- 是否重点项目贷款
    ,nvl(n.tradecontractno, o.tradecontractno) as tradecontractno -- 贸易合同号
    ,nvl(n.acceptcustomerid, o.acceptcustomerid) as acceptcustomerid -- 承兑行我行客户编号
    ,nvl(n.entrustyieldtype, o.entrustyieldtype) as entrustyieldtype -- 信托收益计提方式
    ,nvl(n.isbalancedeposit, o.isbalancedeposit) as isbalancedeposit -- 是否结算性存款
    ,nvl(n.isfillassetsinfo, o.isfillassetsinfo) as isfillassetsinfo -- 是否已完整录入全部底层资产信息
    ,nvl(n.raisefundpurpose, o.raisefundpurpose) as raisefundpurpose -- 募集资金用途
    ,nvl(n.ztacceptbankname, o.ztacceptbankname) as ztacceptbankname -- 直贴行名称
    ,nvl(n.raisemoneyaccountid, o.raisemoneyaccountid) as raisemoneyaccountid -- 募集资金账户
    ,nvl(n.repayinteresttype, o.repayinteresttype) as repayinteresttype -- 还本付息方式(输入)
    ,nvl(n.businessinvoicesum, o.businessinvoicesum) as businessinvoicesum -- 商业发票金额
    ,nvl(n.financesupportmode, o.financesupportmode) as financesupportmode -- 贷款财政扶持方式
    ,nvl(n.businessinvoiceinfo, o.businessinvoiceinfo) as businessinvoiceinfo -- 商业发票号码
    ,nvl(n.businessinvoicetype, o.businessinvoicetype) as businessinvoicetype -- 商业发票种类
    ,nvl(n.entrustinterestrate, o.entrustinterestrate) as entrustinterestrate -- 信托报酬率
    ,nvl(n.rateexplain, o.rateexplain) as rateexplain -- 利率/费率说明
    ,nvl(n.beneficiaryyieldrate, o.beneficiaryyieldrate) as beneficiaryyieldrate -- 受益人的预计年净收益率
    ,nvl(n.circulatestockamount, o.circulatestockamount) as circulatestockamount -- 流通股本(万股)
    ,nvl(n.issupplychainfinance, o.issupplychainfinance) as issupplychainfinance -- 是否为供应链金融业务
    ,nvl(n.relztacceptbankcustid, o.relztacceptbankcustid) as relztacceptbankcustid -- 直贴行我行客户编号
    ,nvl(n.supplychainfinancetype, o.supplychainfinancetype) as supplychainfinancetype -- 供应链金融业务产品分类
    ,nvl(n.businessinvoicecurrency, o.businessinvoicecurrency) as businessinvoicecurrency -- 商业发票币种
    ,nvl(n.entrustinterestratetype, o.entrustinterestratetype) as entrustinterestratetype -- 信托报酬率计提方式
    ,nvl(n.gshy, o.gshy) as gshy -- 过剩行业
    ,nvl(n.baileename, o.baileename) as baileename -- 受托人名称
    ,nvl(n.billno, o.billno) as billno -- 票据号码
    ,nvl(n.gksxpz, o.gksxpz) as gksxpz -- 国开授信品种
    ,nvl(n.issuer, o.issuer) as issuer -- 发行人/融资者
    ,nvl(n.iswhzt, o.iswhzt) as iswhzt -- 是否我行直贴票据
    ,nvl(n.pcline, o.pcline) as pcline -- 平仓线
    ,nvl(n.sfgksx, o.sfgksx) as sfgksx -- 是否国开行授信
    ,nvl(n.sfzfsx, o.sfzfsx) as sfzfsx -- 是否政府授信
    ,nvl(n.zfsxfs, o.zfsxfs) as zfsxfs -- 政府授信支持方式
    ,nvl(n.zfsxlx, o.zfsxlx) as zfsxlx -- 政府授信类型
    ,nvl(n.ztrate, o.ztrate) as ztrate -- 转贴现利率(%)
    ,nvl(n.billsum, o.billsum) as billsum -- 票面金额（元）
    ,nvl(n.enddate, o.enddate) as enddate -- 到期日期(ABS)
    ,nvl(n.tdtimes, o.tdtimes) as tdtimes -- 与交易对手成功交易次数
    ,nvl(n.tdyears, o.tdyears) as tdyears -- 与交易对手合作年限
    ,nvl(n.trusteename, o.trusteename) as trusteename -- 托管人名称
    ,nvl(n.billkind, o.billkind) as billkind -- 票据种类
    ,nvl(n.billtype, o.billtype) as billtype -- 票据类型
    ,nvl(n.deadline, o.deadline) as deadline -- 期限(标的)
    ,nvl(n.issuesum, o.issuesum) as issuesum -- 发行金额(元)
    ,nvl(n.sfgjxzhy, o.sfgjxzhy) as sfgjxzhy -- 是否国家限制行业
    ,nvl(n.tradesum, o.tradesum) as tradesum -- 贸易合同总金额(元)
    ,nvl(n.alarmline, o.alarmline) as alarmline -- 预警线
    ,nvl(n.custodianname, o.custodianname) as custodianname -- 管理人名称
    ,nvl(n.depositno, o.depositno) as depositno -- 存单号码
    ,nvl(n.isfarming, o.isfarming) as isfarming -- 是否涉农贷款标志
    ,nvl(n.repayremark, o.repayremark) as repayremark -- 还款说明
    ,nvl(n.stockcode, o.stockcode) as stockcode -- 标的股票代码
    ,nvl(n.stockname, o.stockname) as stockname -- 标的股票名称
    ,nvl(n.tdstrenth, o.tdstrenth) as tdstrenth -- 交易对手实力
    ,nvl(n.absabnname, o.absabnname) as absabnname -- ABS/ABN名称
    ,nvl(n.bdindustry, o.bdindustry) as bdindustry -- 标的公司行业分类
    ,nvl(n.billwriter, o.billwriter) as billwriter -- 出票人
    ,nvl(n.entrustacc, o.entrustacc) as entrustacc -- 信托专户
    ,nvl(n.issueprice, o.issueprice) as issueprice -- 发行价格
    ,nvl(n.issuescale, o.issuescale) as issuescale -- 发行规模
    ,nvl(n.partybname, o.partybname) as partybname -- 借款人
    ,nvl(n.priequname, o.priequname) as priequname -- 私募债名称
    ,nvl(n.subscriber, o.subscriber) as subscriber -- 认购人/投资者
    ,nvl(n.useproduct, o.useproduct) as useproduct -- 使用产品（贸易融资）
    ,nvl(n.contextinfo, o.contextinfo) as contextinfo -- 交易背景描述
    ,nvl(n.drawingremark, o.drawingremark) as drawingremark -- 提款说明
    ,nvl(n.contractsum, o.contractsum) as contractsum -- 合同资金(信托资管)
    ,nvl(n.depositname, o.depositname) as depositname -- 存单简称
    ,nvl(n.directionrs, o.directionrs) as directionrs -- 行业投向(征信)
    ,nvl(n.drawingtype, o.drawingtype) as drawingtype -- 提款方式
    ,nvl(n.issueamount, o.issueamount) as issueamount -- 发行量(元)
    ,nvl(n.mainproduct, o.mainproduct) as mainproduct -- 经营商品（贸易融资）
    ,nvl(n.stockamount, o.stockamount) as stockamount -- 总股本(万股)
    ,nvl(n.beneficiaryname, o.beneficiaryname) as beneficiaryname -- 受益人名称
    ,nvl(n.consigneeid, o.consigneeid) as consigneeid -- 管理人/主承销商客户编号
    ,nvl(n.rivalid, o.rivalid) as rivalid -- 同业交易对手
    ,nvl(n.datatype, o.datatype) as datatype -- 业务来源（PJ,票据系统供数 LC,理财资管系统供数 ZJ,资金系统供数 ZH,同业综合业务系统供数）
    ,nvl(n.accountcatagory, o.accountcatagory) as accountcatagory -- 账户类别
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志
    ,nvl(n.assetno, o.assetno) as assetno -- 资产唯一标识
    ,nvl(n.interestrepaycycle, o.interestrepaycycle) as interestrepaycycle -- 
    ,nvl(n.shortbondno, o.shortbondno) as shortbondno -- 
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
from (select * from ${iol_schema}.icms_bc_extend_t_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bc_extend_t where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.rivalname <> n.rivalname
        or o.consigneename <> n.consigneename
        or o.consigneecerttype <> n.consigneecerttype
        or o.consigneecertid <> n.consigneecertid
        or o.financier <> n.financier
        or o.iscounterparty <> n.iscounterparty
        or o.fundsource <> n.fundsource
        or o.investway <> n.investway
        or o.managemodel <> n.managemodel
        or o.tradingassets <> n.tradingassets
        or o.toindustryfund <> n.toindustryfund
        or o.isdebttoequity <> n.isdebttoequity
        or o.isgovernfinance <> n.isgovernfinance
        or o.isconsumerfinance <> n.isconsumerfinance
        or o.bondno <> n.bondno
        or o.bondname <> n.bondname
        or o.investkind <> n.investkind
        or o.canseparate <> n.canseparate
        or o.canbacktosale <> n.canbacktosale
        or o.salebackbegindate <> n.salebackbegindate
        or o.salebackenddate <> n.salebackenddate
        or o.businessmarkettype <> n.businessmarkettype
        or o.businessmarketname <> n.businessmarketname
        or o.begindate <> n.begindate
        or o.paymentdate <> n.paymentdate
        or o.outerevaluate1 <> n.outerevaluate1
        or o.outerevaluate2 <> n.outerevaluate2
        or o.outerevaluate3 <> n.outerevaluate3
        or o.couponrate <> n.couponrate
        or o.transactionprice <> n.transactionprice
        or o.transactionrate <> n.transactionrate
        or o.transactoinamount <> n.transactoinamount
        or o.transactiondate <> n.transactiondate
        or o.creditincrementtype <> n.creditincrementtype
        or o.islikeloan <> n.islikeloan
        or o.isclassflag <> n.isclassflag
        or o.productlevel <> n.productlevel
        or o.productcollectmoney <> n.productcollectmoney
        or o.finalinvestdirecttype <> n.finalinvestdirecttype
        or o.mandatecustname <> n.mandatecustname
        or o.mandatecustid <> n.mandatecustid
        or o.acceptbankid <> n.acceptbankid
        or o.billacptdate <> n.billacptdate
        or o.billcurrency <> n.billcurrency
        or o.billmaturity <> n.billmaturity
        or o.chuantoutype <> n.chuantoutype
        or o.econtractname <> n.econtractname
        or o.econtracttype <> n.econtracttype
        or o.guarantytype <> n.guarantytype
        or o.guranteerate <> n.guranteerate
        or o.contractitems <> n.contractitems
        or o.importantloan <> n.importantloan
        or o.operationtype <> n.operationtype
        or o.acceptbankname <> n.acceptbankname
        or o.backtosaletype <> n.backtosaletype
        or o.beneficiaryacctno <> n.beneficiaryacctno
        or o.ifgudingcredit <> n.ifgudingcredit
        or o.manageratetype <> n.manageratetype
        or o.othercondition <> n.othercondition
        or o.subtotalprices <> n.subtotalprices
        or o.ztacceptbankid <> n.ztacceptbankid
        or o.corpuspaymethod <> n.corpuspaymethod
        or o.creditattribute <> n.creditattribute
        or o.depositratetype <> n.depositratetype
        or o.expectyieldrate <> n.expectyieldrate
        or o.isimportantloan <> n.isimportantloan
        or o.tradecontractno <> n.tradecontractno
        or o.acceptcustomerid <> n.acceptcustomerid
        or o.entrustyieldtype <> n.entrustyieldtype
        or o.isbalancedeposit <> n.isbalancedeposit
        or o.isfillassetsinfo <> n.isfillassetsinfo
        or o.raisefundpurpose <> n.raisefundpurpose
        or o.ztacceptbankname <> n.ztacceptbankname
        or o.raisemoneyaccountid <> n.raisemoneyaccountid
        or o.repayinteresttype <> n.repayinteresttype
        or o.businessinvoicesum <> n.businessinvoicesum
        or o.financesupportmode <> n.financesupportmode
        or o.businessinvoiceinfo <> n.businessinvoiceinfo
        or o.businessinvoicetype <> n.businessinvoicetype
        or o.entrustinterestrate <> n.entrustinterestrate
        or o.rateexplain <> n.rateexplain
        or o.beneficiaryyieldrate <> n.beneficiaryyieldrate
        or o.circulatestockamount <> n.circulatestockamount
        or o.issupplychainfinance <> n.issupplychainfinance
        or o.relztacceptbankcustid <> n.relztacceptbankcustid
        or o.supplychainfinancetype <> n.supplychainfinancetype
        or o.businessinvoicecurrency <> n.businessinvoicecurrency
        or o.entrustinterestratetype <> n.entrustinterestratetype
        or o.gshy <> n.gshy
        or o.baileename <> n.baileename
        or o.billno <> n.billno
        or o.gksxpz <> n.gksxpz
        or o.issuer <> n.issuer
        or o.iswhzt <> n.iswhzt
        or o.pcline <> n.pcline
        or o.sfgksx <> n.sfgksx
        or o.sfzfsx <> n.sfzfsx
        or o.zfsxfs <> n.zfsxfs
        or o.zfsxlx <> n.zfsxlx
        or o.ztrate <> n.ztrate
        or o.billsum <> n.billsum
        or o.enddate <> n.enddate
        or o.tdtimes <> n.tdtimes
        or o.tdyears <> n.tdyears
        or o.trusteename <> n.trusteename
        or o.billkind <> n.billkind
        or o.billtype <> n.billtype
        or o.deadline <> n.deadline
        or o.issuesum <> n.issuesum
        or o.sfgjxzhy <> n.sfgjxzhy
        or o.tradesum <> n.tradesum
        or o.alarmline <> n.alarmline
        or o.custodianname <> n.custodianname
        or o.depositno <> n.depositno
        or o.isfarming <> n.isfarming
        or o.repayremark <> n.repayremark
        or o.stockcode <> n.stockcode
        or o.stockname <> n.stockname
        or o.tdstrenth <> n.tdstrenth
        or o.absabnname <> n.absabnname
        or o.bdindustry <> n.bdindustry
        or o.billwriter <> n.billwriter
        or o.entrustacc <> n.entrustacc
        or o.issueprice <> n.issueprice
        or o.issuescale <> n.issuescale
        or o.partybname <> n.partybname
        or o.priequname <> n.priequname
        or o.subscriber <> n.subscriber
        or o.useproduct <> n.useproduct
        or o.contextinfo <> n.contextinfo
        or o.drawingremark <> n.drawingremark
        or o.contractsum <> n.contractsum
        or o.depositname <> n.depositname
        or o.directionrs <> n.directionrs
        or o.drawingtype <> n.drawingtype
        or o.issueamount <> n.issueamount
        or o.mainproduct <> n.mainproduct
        or o.stockamount <> n.stockamount
        or o.beneficiaryname <> n.beneficiaryname
        or o.consigneeid <> n.consigneeid
        or o.rivalid <> n.rivalid
        or o.datatype <> n.datatype
        or o.accountcatagory <> n.accountcatagory
        or o.migtflag <> n.migtflag
        or o.assetno <> n.assetno
        or o.interestrepaycycle <> n.interestrepaycycle
        or o.shortbondno <> n.shortbondno
        or o.oldassetno <> n.oldassetno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bc_extend_t_cl(
            serialno -- 合同编号
            ,rivalname -- 交易对手名称
            ,consigneename -- 发行公司名称
            ,consigneecerttype -- 管理人/主承销商证件类型
            ,consigneecertid -- 管理人/主承销商证件号码
            ,financier -- 实际融资人
            ,iscounterparty -- 是否合格中央交易对手
            ,fundsource -- 资金来源
            ,investway -- 投资方式
            ,managemodel -- 管理模式
            ,tradingassets -- 交易资产
            ,toindustryfund -- 是否投向产业基金
            ,isdebttoequity -- 是否投向市场化债转股
            ,isgovernfinance -- 是否涉及政府类融资
            ,isconsumerfinance -- 是否为消费服务类融资
            ,bondno -- 标的产品编号
            ,bondname -- 标的产品名称
            ,investkind -- 投资性质
            ,canseparate -- 是否可分离
            ,canbacktosale -- 是否含有回售选择权
            ,salebackbegindate -- 回售申请起始日
            ,salebackenddate -- 回售申请截止日
            ,businessmarkettype -- 交易市场类型
            ,businessmarketname -- 交易市场名称
            ,begindate -- 债券发行日期
            ,paymentdate -- 协议到期日期
            ,outerevaluate1 -- 债券外部评级结果（发行时）
            ,outerevaluate2 -- 债券外部评级结果（购买时）
            ,outerevaluate3 -- 债券外部评级结果（当前）
            ,couponrate -- 票面利率
            ,transactionprice -- 成交净价
            ,transactionrate -- 成交利率
            ,transactoinamount -- 成交量
            ,transactiondate -- 实际交割日期
            ,creditincrementtype -- 主要增信方式
            ,islikeloan -- 是否类信贷
            ,isclassflag -- 是否分级
            ,productlevel -- 产品分级级别
            ,productcollectmoney -- 债券面值
            ,finalinvestdirecttype -- 最终投向类型
            ,mandatecustname -- 委托人名称
            ,mandatecustid -- 委托人ID
            ,acceptbankid -- 承兑行行号
            ,billacptdate -- 出票日(票据)
            ,billcurrency -- 票据币种(票据)
            ,billmaturity -- 到期日(票据)
            ,chuantoutype -- 穿透类型
            ,econtractname -- 合同名称(信托资管)
            ,econtracttype -- 合同类型(信托资管)
            ,guarantytype -- 担保/操作模式(担保切分必选项)
            ,guranteerate -- 质押率/初始履约保障比例
            ,contractitems -- 合同期次
            ,importantloan -- 重点贷款项目
            ,operationtype -- 业务类型
            ,acceptbankname -- 承兑行名称
            ,backtosaletype -- 回购类型
            ,beneficiaryacctno -- 受益人账户
            ,ifgudingcredit -- 是否固定资产授信
            ,manageratetype -- 管理费费率及计提方式
            ,othercondition -- 其他条件和要求
            ,subtotalprices -- 认购总价
            ,ztacceptbankid -- 直贴行行号
            ,corpuspaymethod -- 还款方式
            ,creditattribute -- 合同类型
            ,depositratetype -- 托管费费率及计提方式
            ,expectyieldrate -- 预期收益率
            ,isimportantloan -- 是否重点项目贷款
            ,tradecontractno -- 贸易合同号
            ,acceptcustomerid -- 承兑行我行客户编号
            ,entrustyieldtype -- 信托收益计提方式
            ,isbalancedeposit -- 是否结算性存款
            ,isfillassetsinfo -- 是否已完整录入全部底层资产信息
            ,raisefundpurpose -- 募集资金用途
            ,ztacceptbankname -- 直贴行名称
            ,raisemoneyaccountid -- 募集资金账户
            ,repayinteresttype -- 还本付息方式(输入)
            ,businessinvoicesum -- 商业发票金额
            ,financesupportmode -- 贷款财政扶持方式
            ,businessinvoiceinfo -- 商业发票号码
            ,businessinvoicetype -- 商业发票种类
            ,entrustinterestrate -- 信托报酬率
            ,rateexplain -- 利率/费率说明
            ,beneficiaryyieldrate -- 受益人的预计年净收益率
            ,circulatestockamount -- 流通股本(万股)
            ,issupplychainfinance -- 是否为供应链金融业务
            ,relztacceptbankcustid -- 直贴行我行客户编号
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,businessinvoicecurrency -- 商业发票币种
            ,entrustinterestratetype -- 信托报酬率计提方式
            ,gshy -- 过剩行业
            ,baileename -- 受托人名称
            ,billno -- 票据号码
            ,gksxpz -- 国开授信品种
            ,issuer -- 发行人/融资者
            ,iswhzt -- 是否我行直贴票据
            ,pcline -- 平仓线
            ,sfgksx -- 是否国开行授信
            ,sfzfsx -- 是否政府授信
            ,zfsxfs -- 政府授信支持方式
            ,zfsxlx -- 政府授信类型
            ,ztrate -- 转贴现利率(%)
            ,billsum -- 票面金额（元）
            ,enddate -- 到期日期(ABS)
            ,tdtimes -- 与交易对手成功交易次数
            ,tdyears -- 与交易对手合作年限
            ,trusteename -- 托管人名称
            ,billkind -- 票据种类
            ,billtype -- 票据类型
            ,deadline -- 期限(标的)
            ,issuesum -- 发行金额(元)
            ,sfgjxzhy -- 是否国家限制行业
            ,tradesum -- 贸易合同总金额(元)
            ,alarmline -- 预警线
            ,custodianname -- 管理人名称
            ,depositno -- 存单号码
            ,isfarming -- 是否涉农贷款标志
            ,repayremark -- 还款说明
            ,stockcode -- 标的股票代码
            ,stockname -- 标的股票名称
            ,tdstrenth -- 交易对手实力
            ,absabnname -- ABS/ABN名称
            ,bdindustry -- 标的公司行业分类
            ,billwriter -- 出票人
            ,entrustacc -- 信托专户
            ,issueprice -- 发行价格
            ,issuescale -- 发行规模
            ,partybname -- 借款人
            ,priequname -- 私募债名称
            ,subscriber -- 认购人/投资者
            ,useproduct -- 使用产品（贸易融资）
            ,contextinfo -- 交易背景描述
            ,drawingremark -- 提款说明
            ,contractsum -- 合同资金(信托资管)
            ,depositname -- 存单简称
            ,directionrs -- 行业投向(征信)
            ,drawingtype -- 提款方式
            ,issueamount -- 发行量(元)
            ,mainproduct -- 经营商品（贸易融资）
            ,stockamount -- 总股本(万股)
            ,beneficiaryname -- 受益人名称
            ,consigneeid -- 管理人/主承销商客户编号
            ,rivalid -- 同业交易对手
            ,datatype -- 业务来源（PJ,票据系统供数 LC,理财资管系统供数 ZJ,资金系统供数 ZH,同业综合业务系统供数）
            ,accountcatagory -- 账户类别
            ,migtflag -- 迁移标志
            ,assetno -- 资产唯一标识
            ,interestrepaycycle -- 
            ,shortbondno -- 
            ,oldassetno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bc_extend_t_op(
            serialno -- 合同编号
            ,rivalname -- 交易对手名称
            ,consigneename -- 发行公司名称
            ,consigneecerttype -- 管理人/主承销商证件类型
            ,consigneecertid -- 管理人/主承销商证件号码
            ,financier -- 实际融资人
            ,iscounterparty -- 是否合格中央交易对手
            ,fundsource -- 资金来源
            ,investway -- 投资方式
            ,managemodel -- 管理模式
            ,tradingassets -- 交易资产
            ,toindustryfund -- 是否投向产业基金
            ,isdebttoequity -- 是否投向市场化债转股
            ,isgovernfinance -- 是否涉及政府类融资
            ,isconsumerfinance -- 是否为消费服务类融资
            ,bondno -- 标的产品编号
            ,bondname -- 标的产品名称
            ,investkind -- 投资性质
            ,canseparate -- 是否可分离
            ,canbacktosale -- 是否含有回售选择权
            ,salebackbegindate -- 回售申请起始日
            ,salebackenddate -- 回售申请截止日
            ,businessmarkettype -- 交易市场类型
            ,businessmarketname -- 交易市场名称
            ,begindate -- 债券发行日期
            ,paymentdate -- 协议到期日期
            ,outerevaluate1 -- 债券外部评级结果（发行时）
            ,outerevaluate2 -- 债券外部评级结果（购买时）
            ,outerevaluate3 -- 债券外部评级结果（当前）
            ,couponrate -- 票面利率
            ,transactionprice -- 成交净价
            ,transactionrate -- 成交利率
            ,transactoinamount -- 成交量
            ,transactiondate -- 实际交割日期
            ,creditincrementtype -- 主要增信方式
            ,islikeloan -- 是否类信贷
            ,isclassflag -- 是否分级
            ,productlevel -- 产品分级级别
            ,productcollectmoney -- 债券面值
            ,finalinvestdirecttype -- 最终投向类型
            ,mandatecustname -- 委托人名称
            ,mandatecustid -- 委托人ID
            ,acceptbankid -- 承兑行行号
            ,billacptdate -- 出票日(票据)
            ,billcurrency -- 票据币种(票据)
            ,billmaturity -- 到期日(票据)
            ,chuantoutype -- 穿透类型
            ,econtractname -- 合同名称(信托资管)
            ,econtracttype -- 合同类型(信托资管)
            ,guarantytype -- 担保/操作模式(担保切分必选项)
            ,guranteerate -- 质押率/初始履约保障比例
            ,contractitems -- 合同期次
            ,importantloan -- 重点贷款项目
            ,operationtype -- 业务类型
            ,acceptbankname -- 承兑行名称
            ,backtosaletype -- 回购类型
            ,beneficiaryacctno -- 受益人账户
            ,ifgudingcredit -- 是否固定资产授信
            ,manageratetype -- 管理费费率及计提方式
            ,othercondition -- 其他条件和要求
            ,subtotalprices -- 认购总价
            ,ztacceptbankid -- 直贴行行号
            ,corpuspaymethod -- 还款方式
            ,creditattribute -- 合同类型
            ,depositratetype -- 托管费费率及计提方式
            ,expectyieldrate -- 预期收益率
            ,isimportantloan -- 是否重点项目贷款
            ,tradecontractno -- 贸易合同号
            ,acceptcustomerid -- 承兑行我行客户编号
            ,entrustyieldtype -- 信托收益计提方式
            ,isbalancedeposit -- 是否结算性存款
            ,isfillassetsinfo -- 是否已完整录入全部底层资产信息
            ,raisefundpurpose -- 募集资金用途
            ,ztacceptbankname -- 直贴行名称
            ,raisemoneyaccountid -- 募集资金账户
            ,repayinteresttype -- 还本付息方式(输入)
            ,businessinvoicesum -- 商业发票金额
            ,financesupportmode -- 贷款财政扶持方式
            ,businessinvoiceinfo -- 商业发票号码
            ,businessinvoicetype -- 商业发票种类
            ,entrustinterestrate -- 信托报酬率
            ,rateexplain -- 利率/费率说明
            ,beneficiaryyieldrate -- 受益人的预计年净收益率
            ,circulatestockamount -- 流通股本(万股)
            ,issupplychainfinance -- 是否为供应链金融业务
            ,relztacceptbankcustid -- 直贴行我行客户编号
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,businessinvoicecurrency -- 商业发票币种
            ,entrustinterestratetype -- 信托报酬率计提方式
            ,gshy -- 过剩行业
            ,baileename -- 受托人名称
            ,billno -- 票据号码
            ,gksxpz -- 国开授信品种
            ,issuer -- 发行人/融资者
            ,iswhzt -- 是否我行直贴票据
            ,pcline -- 平仓线
            ,sfgksx -- 是否国开行授信
            ,sfzfsx -- 是否政府授信
            ,zfsxfs -- 政府授信支持方式
            ,zfsxlx -- 政府授信类型
            ,ztrate -- 转贴现利率(%)
            ,billsum -- 票面金额（元）
            ,enddate -- 到期日期(ABS)
            ,tdtimes -- 与交易对手成功交易次数
            ,tdyears -- 与交易对手合作年限
            ,trusteename -- 托管人名称
            ,billkind -- 票据种类
            ,billtype -- 票据类型
            ,deadline -- 期限(标的)
            ,issuesum -- 发行金额(元)
            ,sfgjxzhy -- 是否国家限制行业
            ,tradesum -- 贸易合同总金额(元)
            ,alarmline -- 预警线
            ,custodianname -- 管理人名称
            ,depositno -- 存单号码
            ,isfarming -- 是否涉农贷款标志
            ,repayremark -- 还款说明
            ,stockcode -- 标的股票代码
            ,stockname -- 标的股票名称
            ,tdstrenth -- 交易对手实力
            ,absabnname -- ABS/ABN名称
            ,bdindustry -- 标的公司行业分类
            ,billwriter -- 出票人
            ,entrustacc -- 信托专户
            ,issueprice -- 发行价格
            ,issuescale -- 发行规模
            ,partybname -- 借款人
            ,priequname -- 私募债名称
            ,subscriber -- 认购人/投资者
            ,useproduct -- 使用产品（贸易融资）
            ,contextinfo -- 交易背景描述
            ,drawingremark -- 提款说明
            ,contractsum -- 合同资金(信托资管)
            ,depositname -- 存单简称
            ,directionrs -- 行业投向(征信)
            ,drawingtype -- 提款方式
            ,issueamount -- 发行量(元)
            ,mainproduct -- 经营商品（贸易融资）
            ,stockamount -- 总股本(万股)
            ,beneficiaryname -- 受益人名称
            ,consigneeid -- 管理人/主承销商客户编号
            ,rivalid -- 同业交易对手
            ,datatype -- 业务来源（PJ,票据系统供数 LC,理财资管系统供数 ZJ,资金系统供数 ZH,同业综合业务系统供数）
            ,accountcatagory -- 账户类别
            ,migtflag -- 迁移标志
            ,assetno -- 资产唯一标识
            ,interestrepaycycle -- 
            ,shortbondno -- 
            ,oldassetno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 合同编号
    ,o.rivalname -- 交易对手名称
    ,o.consigneename -- 发行公司名称
    ,o.consigneecerttype -- 管理人/主承销商证件类型
    ,o.consigneecertid -- 管理人/主承销商证件号码
    ,o.financier -- 实际融资人
    ,o.iscounterparty -- 是否合格中央交易对手
    ,o.fundsource -- 资金来源
    ,o.investway -- 投资方式
    ,o.managemodel -- 管理模式
    ,o.tradingassets -- 交易资产
    ,o.toindustryfund -- 是否投向产业基金
    ,o.isdebttoequity -- 是否投向市场化债转股
    ,o.isgovernfinance -- 是否涉及政府类融资
    ,o.isconsumerfinance -- 是否为消费服务类融资
    ,o.bondno -- 标的产品编号
    ,o.bondname -- 标的产品名称
    ,o.investkind -- 投资性质
    ,o.canseparate -- 是否可分离
    ,o.canbacktosale -- 是否含有回售选择权
    ,o.salebackbegindate -- 回售申请起始日
    ,o.salebackenddate -- 回售申请截止日
    ,o.businessmarkettype -- 交易市场类型
    ,o.businessmarketname -- 交易市场名称
    ,o.begindate -- 债券发行日期
    ,o.paymentdate -- 协议到期日期
    ,o.outerevaluate1 -- 债券外部评级结果（发行时）
    ,o.outerevaluate2 -- 债券外部评级结果（购买时）
    ,o.outerevaluate3 -- 债券外部评级结果（当前）
    ,o.couponrate -- 票面利率
    ,o.transactionprice -- 成交净价
    ,o.transactionrate -- 成交利率
    ,o.transactoinamount -- 成交量
    ,o.transactiondate -- 实际交割日期
    ,o.creditincrementtype -- 主要增信方式
    ,o.islikeloan -- 是否类信贷
    ,o.isclassflag -- 是否分级
    ,o.productlevel -- 产品分级级别
    ,o.productcollectmoney -- 债券面值
    ,o.finalinvestdirecttype -- 最终投向类型
    ,o.mandatecustname -- 委托人名称
    ,o.mandatecustid -- 委托人ID
    ,o.acceptbankid -- 承兑行行号
    ,o.billacptdate -- 出票日(票据)
    ,o.billcurrency -- 票据币种(票据)
    ,o.billmaturity -- 到期日(票据)
    ,o.chuantoutype -- 穿透类型
    ,o.econtractname -- 合同名称(信托资管)
    ,o.econtracttype -- 合同类型(信托资管)
    ,o.guarantytype -- 担保/操作模式(担保切分必选项)
    ,o.guranteerate -- 质押率/初始履约保障比例
    ,o.contractitems -- 合同期次
    ,o.importantloan -- 重点贷款项目
    ,o.operationtype -- 业务类型
    ,o.acceptbankname -- 承兑行名称
    ,o.backtosaletype -- 回购类型
    ,o.beneficiaryacctno -- 受益人账户
    ,o.ifgudingcredit -- 是否固定资产授信
    ,o.manageratetype -- 管理费费率及计提方式
    ,o.othercondition -- 其他条件和要求
    ,o.subtotalprices -- 认购总价
    ,o.ztacceptbankid -- 直贴行行号
    ,o.corpuspaymethod -- 还款方式
    ,o.creditattribute -- 合同类型
    ,o.depositratetype -- 托管费费率及计提方式
    ,o.expectyieldrate -- 预期收益率
    ,o.isimportantloan -- 是否重点项目贷款
    ,o.tradecontractno -- 贸易合同号
    ,o.acceptcustomerid -- 承兑行我行客户编号
    ,o.entrustyieldtype -- 信托收益计提方式
    ,o.isbalancedeposit -- 是否结算性存款
    ,o.isfillassetsinfo -- 是否已完整录入全部底层资产信息
    ,o.raisefundpurpose -- 募集资金用途
    ,o.ztacceptbankname -- 直贴行名称
    ,o.raisemoneyaccountid -- 募集资金账户
    ,o.repayinteresttype -- 还本付息方式(输入)
    ,o.businessinvoicesum -- 商业发票金额
    ,o.financesupportmode -- 贷款财政扶持方式
    ,o.businessinvoiceinfo -- 商业发票号码
    ,o.businessinvoicetype -- 商业发票种类
    ,o.entrustinterestrate -- 信托报酬率
    ,o.rateexplain -- 利率/费率说明
    ,o.beneficiaryyieldrate -- 受益人的预计年净收益率
    ,o.circulatestockamount -- 流通股本(万股)
    ,o.issupplychainfinance -- 是否为供应链金融业务
    ,o.relztacceptbankcustid -- 直贴行我行客户编号
    ,o.supplychainfinancetype -- 供应链金融业务产品分类
    ,o.businessinvoicecurrency -- 商业发票币种
    ,o.entrustinterestratetype -- 信托报酬率计提方式
    ,o.gshy -- 过剩行业
    ,o.baileename -- 受托人名称
    ,o.billno -- 票据号码
    ,o.gksxpz -- 国开授信品种
    ,o.issuer -- 发行人/融资者
    ,o.iswhzt -- 是否我行直贴票据
    ,o.pcline -- 平仓线
    ,o.sfgksx -- 是否国开行授信
    ,o.sfzfsx -- 是否政府授信
    ,o.zfsxfs -- 政府授信支持方式
    ,o.zfsxlx -- 政府授信类型
    ,o.ztrate -- 转贴现利率(%)
    ,o.billsum -- 票面金额（元）
    ,o.enddate -- 到期日期(ABS)
    ,o.tdtimes -- 与交易对手成功交易次数
    ,o.tdyears -- 与交易对手合作年限
    ,o.trusteename -- 托管人名称
    ,o.billkind -- 票据种类
    ,o.billtype -- 票据类型
    ,o.deadline -- 期限(标的)
    ,o.issuesum -- 发行金额(元)
    ,o.sfgjxzhy -- 是否国家限制行业
    ,o.tradesum -- 贸易合同总金额(元)
    ,o.alarmline -- 预警线
    ,o.custodianname -- 管理人名称
    ,o.depositno -- 存单号码
    ,o.isfarming -- 是否涉农贷款标志
    ,o.repayremark -- 还款说明
    ,o.stockcode -- 标的股票代码
    ,o.stockname -- 标的股票名称
    ,o.tdstrenth -- 交易对手实力
    ,o.absabnname -- ABS/ABN名称
    ,o.bdindustry -- 标的公司行业分类
    ,o.billwriter -- 出票人
    ,o.entrustacc -- 信托专户
    ,o.issueprice -- 发行价格
    ,o.issuescale -- 发行规模
    ,o.partybname -- 借款人
    ,o.priequname -- 私募债名称
    ,o.subscriber -- 认购人/投资者
    ,o.useproduct -- 使用产品（贸易融资）
    ,o.contextinfo -- 交易背景描述
    ,o.drawingremark -- 提款说明
    ,o.contractsum -- 合同资金(信托资管)
    ,o.depositname -- 存单简称
    ,o.directionrs -- 行业投向(征信)
    ,o.drawingtype -- 提款方式
    ,o.issueamount -- 发行量(元)
    ,o.mainproduct -- 经营商品（贸易融资）
    ,o.stockamount -- 总股本(万股)
    ,o.beneficiaryname -- 受益人名称
    ,o.consigneeid -- 管理人/主承销商客户编号
    ,o.rivalid -- 同业交易对手
    ,o.datatype -- 业务来源（PJ,票据系统供数 LC,理财资管系统供数 ZJ,资金系统供数 ZH,同业综合业务系统供数）
    ,o.accountcatagory -- 账户类别
    ,o.migtflag -- 迁移标志
    ,o.assetno -- 资产唯一标识
    ,o.interestrepaycycle -- 
    ,o.shortbondno -- 
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
from ${iol_schema}.icms_bc_extend_t_bk o
    left join ${iol_schema}.icms_bc_extend_t_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bc_extend_t_cl d
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
--truncate table ${iol_schema}.icms_bc_extend_t;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bc_extend_t') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bc_extend_t drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bc_extend_t add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bc_extend_t exchange partition p_${batch_date} with table ${iol_schema}.icms_bc_extend_t_cl;
alter table ${iol_schema}.icms_bc_extend_t exchange partition p_20991231 with table ${iol_schema}.icms_bc_extend_t_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bc_extend_t to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bc_extend_t_op purge;
drop table ${iol_schema}.icms_bc_extend_t_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bc_extend_t_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bc_extend_t',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
