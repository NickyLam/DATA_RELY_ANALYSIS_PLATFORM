/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_bc_extend_t
CreateDate: 20221109
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icms_bc_extend_t purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icms_bc_extend_t(
etl_dt date --ETL处理日期
,serialno varchar2(32) --合同编号
,rivalname varchar2(200) --交易对手名称
,consigneename varchar2(200) --管理人/主承销商
,consigneecerttype varchar2(20) --管理人/主承销商证件类型
,consigneecertid varchar2(40) --管理人/主承销商证件号码
,financier varchar2(200) --实际融资人
,iscounterparty varchar2(1) --是否合格中央交易对手
,fundsource varchar2(18) --资金来源
,investway varchar2(2) --投资方式
,managemodel varchar2(2) --管理模式
,tradingassets varchar2(200) --交易资产
,toindustryfund varchar2(1) --是否投向产业基金
,isdebttoequity varchar2(1) --是否投向市场化债转股
,isgovernfinance varchar2(1) --是否涉及政府类融资
,isconsumerfinance varchar2(1) --是否为消费服务类融资
,bondno varchar2(150) --标的产品编号
,bondname varchar2(200) --债券名称
,investkind varchar2(2) --投资性质
,canseparate varchar2(1) --是否可分离
,canbacktosale varchar2(1) --是否含有回售选择权
,begindate date --回售申请起始日
,salebackenddate varchar2(10) --回售申请截止日
,businessmarkettype varchar2(3) --交易市场类型
,businessmarketname varchar2(80) --交易市场名称
,paymentdate date --兑付日期
,outerevaluate1 varchar2(6) --债券外部评级结果（发行时）
,outerevaluate2 varchar2(6) --债券外部评级结果（购买时）
,outerevaluate3 varchar2(6) --债券外部评级结果（当前）
,couponrate number(10,6) --票面利率
,transactionprice number(24,6) --成交净价
,transactionrate number(10,6) --成交利率
,transactoinamount varchar2(80) --成交量
,transactiondate date --实际交割日期
,creditincrementtype varchar2(2) --主要增信方式
,islikeloan varchar2(2) --是否类信贷
,isclassflag varchar2(5) --是否分级
,productlevel number(20) --产品分级级别
,productcollectmoney number(24,6) --产品募集金额
,finalinvestdirecttype varchar2(5) --最终投向类型
,mandatecustname varchar2(200) --委托人名称
,mandatecustid varchar2(200) --委托人ID
,acceptbankid varchar2(32) --承兑行行号
,billacptdate varchar2(10) --出票日(票据)
,billno varchar2(32) --票据号码
,billcurrency varchar2(3) --票据币种(票据)
,billmaturity varchar2(10) --到期日(票据)
,chuantoutype varchar2(10) --穿透类型
,econtractname varchar2(80) --合同名称(信托资管)
,econtracttype varchar2(10) --合同类型(信托资管)
,guarantytype varchar2(12) --担保/操作模式(担保切分必选项)
,guranteerate number(10,6) --质押率/初始履约保障比例
,contractitems number(22) --合同期次
,isimportantloan varchar2(8) --是否重点项目贷款
,importantloan varchar2(8) --重点贷款项目
,operationtype varchar2(2) --业务类型
,acceptbankname varchar2(200) --承兑行名称
,backtosaletype varchar2(3) --回购类型
,beneficiaryname varchar2(200) --受益人名称
,beneficiaryyieldrate number(24,6) --受益人的预计年净收益率
,beneficiaryacctno varchar2(50) --受益人账户
,ifgudingcredit varchar2(1) --是否固定资产授信
,manageratetype varchar2(18) --管理费费率及计提方式
,othercondition varchar2(4000) --其他条件和要求
,subtotalprices number(24,6) --认购总价
,ztacceptbankname varchar2(100) --直贴行名称
,ztacceptbankid varchar2(32) --直贴行行号
,relztacceptbankcustid varchar2(32) --直贴行我行客户编号
,iswhzt varchar2(1) --是否我行直贴票据
,corpuspaymethod varchar2(18) --还款方式
,creditattribute varchar2(3) --合同类型
,depositratetype varchar2(18) --托管费费率及计提方式
,expectyieldrate number(24,6) --预期收益率
,tradecontractno varchar2(32) --贸易合同号
,acceptcustomerid varchar2(32) --承兑行我行客户编号
,entrustyieldtype varchar2(18) --信托收益计提方式
,isbalancedeposit varchar2(1) --是否结算性存款
,isfillassetsinfo varchar2(1) --是否已完整录入全部底层资产信息
,raisefundpurpose varchar2(200) --募集资金用途
,raisemoneyaccountid varchar2(80) --募集资金账户
,repayinteresttype varchar2(100) --还本付息方式(输入)
,businessinvoicesum number(20,2) --商业发票金额
,financesupportmode varchar2(32) --贷款财政扶持方式
,businessinvoiceinfo varchar2(100) --商业发票号码
,businessinvoicetype varchar2(60) --商业发票种类
,entrustinterestrate number(24,6) --信托报酬率
,rateexplain varchar2(200) --利率/费率说明
,circulatestockamount number(24,6) --流通股本(万股)
,issupplychainfinance varchar2(1) --是否为供应链金融业务
,supplychainfinancetype varchar2(8) --供应链金融业务产品分类
,businessinvoicecurrency varchar2(3) --商业发票币种
,entrustinterestratetype varchar2(18) --信托报酬率计提方式
,gshy varchar2(8) --过剩行业
,baileename varchar2(80) --受托人名称
,gksxpz varchar2(8) --国开授信品种
,issuer varchar2(80) --发行人/融资者
,pcline varchar2(100) --平仓线
,sfgksx varchar2(1) --是否国开行授信
,sfzfsx varchar2(1) --是否政府授信
,zfsxfs varchar2(8) --政府授信支持方式
,zfsxlx varchar2(8) --政府授信类型
,ztrate number(24,6) --转贴现利率(%)
,billsum number(24,6) --票面金额（元）
,enddate varchar2(10) --到期日期(ABS)
,tdtimes varchar2(20) --与交易对手成功交易次数
,tdyears varchar2(20) --与交易对手合作年限
,trusteename varchar2(80) --托管人名称
,billkind varchar2(2) --票据种类
,billtype varchar2(2) --票据类型
,deadline number(24,6) --期限(标的)
,issuesum number(24,6) --发行金额(元)
,sfgjxzhy varchar2(1) --是否国家限制行业
,tradesum number(24,6) --贸易合同总金额(元)
,alarmline varchar2(100) --预警线
,custodianname varchar2(80) --管理人名称
,depositno varchar2(32) --存单号码
,isfarming varchar2(1) --是否涉农
,repayremark varchar2(400) --还款说明
,stockcode varchar2(32) --标的股票代码
,stockname varchar2(80) --标的股票名称
,tdstrenth varchar2(20) --交易对手实力
,absabnname varchar2(150) --ABS/ABN名称
,bdindustry varchar2(30) --标的公司行业分类
,billwriter varchar2(40) --出票人
,entrustacc varchar2(40) --信托专户
,issueprice number(24,6) --发行价格
,issuescale varchar2(200) --发行规模
,partybname varchar2(80) --借款人
,priequname varchar2(80) --私募债名称
,subscriber varchar2(80) --认购人/投资者
,useproduct varchar2(32) --使用产品（贸易融资）
,contextinfo varchar2(200) --交易背景描述
,drawingremark varchar2(200) --提款说明
,contractsum number(24,6) --合同资金(信托资管)
,depositname varchar2(40) --存单简称
,directionrs varchar2(18) --行业投向(征信)
,drawingtype varchar2(18) --提款方式
,issueamount number(24,6) --发行量(元)
,mainproduct varchar2(32) --经营商品（贸易融资）
,stockamount number(24,6) --总股本(万股)
,consigneeid varchar2(32) --管理人/主承销商客户编号
,rivalid varchar2(32) --同业交易对手
,start_dt date --开始日期
,end_dt date --结束日期
,id_mark varchar2(10) --删除标识
,accountcatagory varchar2(40) --账户类别
,datatype varchar2(10) --业务来源（pj.票据系统供数 lc.理财资管系统供数 zj.资金系统供数 zh.同业综合业务系统供数）
,migtflag varchar2(80) --
,salebackbegindate varchar2(10) --回售申请起始日
,assetno varchar2(100) --资产唯一标识

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icms_bc_extend_t to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_bc_extend_t is '同业投融资业务合同个性化信息';
comment on column ${idl_schema}.icms_bc_extend_t.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.icms_bc_extend_t.serialno is '合同编号';
comment on column ${idl_schema}.icms_bc_extend_t.rivalname is '交易对手名称';
comment on column ${idl_schema}.icms_bc_extend_t.consigneename is '管理人/主承销商';
comment on column ${idl_schema}.icms_bc_extend_t.consigneecerttype is '管理人/主承销商证件类型';
comment on column ${idl_schema}.icms_bc_extend_t.consigneecertid is '管理人/主承销商证件号码';
comment on column ${idl_schema}.icms_bc_extend_t.financier is '实际融资人';
comment on column ${idl_schema}.icms_bc_extend_t.iscounterparty is '是否合格中央交易对手';
comment on column ${idl_schema}.icms_bc_extend_t.fundsource is '资金来源';
comment on column ${idl_schema}.icms_bc_extend_t.investway is '投资方式';
comment on column ${idl_schema}.icms_bc_extend_t.managemodel is '管理模式';
comment on column ${idl_schema}.icms_bc_extend_t.tradingassets is '交易资产';
comment on column ${idl_schema}.icms_bc_extend_t.toindustryfund is '是否投向产业基金';
comment on column ${idl_schema}.icms_bc_extend_t.isdebttoequity is '是否投向市场化债转股';
comment on column ${idl_schema}.icms_bc_extend_t.isgovernfinance is '是否涉及政府类融资';
comment on column ${idl_schema}.icms_bc_extend_t.isconsumerfinance is '是否为消费服务类融资';
comment on column ${idl_schema}.icms_bc_extend_t.bondno is '标的产品编号';
comment on column ${idl_schema}.icms_bc_extend_t.bondname is '债券名称';
comment on column ${idl_schema}.icms_bc_extend_t.investkind is '投资性质';
comment on column ${idl_schema}.icms_bc_extend_t.canseparate is '是否可分离';
comment on column ${idl_schema}.icms_bc_extend_t.canbacktosale is '是否含有回售选择权';
comment on column ${idl_schema}.icms_bc_extend_t.begindate is '回售申请起始日';
comment on column ${idl_schema}.icms_bc_extend_t.salebackenddate is '回售申请截止日';
comment on column ${idl_schema}.icms_bc_extend_t.businessmarkettype is '交易市场类型';
comment on column ${idl_schema}.icms_bc_extend_t.businessmarketname is '交易市场名称';
comment on column ${idl_schema}.icms_bc_extend_t.paymentdate is '兑付日期';
comment on column ${idl_schema}.icms_bc_extend_t.outerevaluate1 is '债券外部评级结果（发行时）';
comment on column ${idl_schema}.icms_bc_extend_t.outerevaluate2 is '债券外部评级结果（购买时）';
comment on column ${idl_schema}.icms_bc_extend_t.outerevaluate3 is '债券外部评级结果（当前）';
comment on column ${idl_schema}.icms_bc_extend_t.couponrate is '票面利率';
comment on column ${idl_schema}.icms_bc_extend_t.transactionprice is '成交净价';
comment on column ${idl_schema}.icms_bc_extend_t.transactionrate is '成交利率';
comment on column ${idl_schema}.icms_bc_extend_t.transactoinamount is '成交量';
comment on column ${idl_schema}.icms_bc_extend_t.transactiondate is '实际交割日期';
comment on column ${idl_schema}.icms_bc_extend_t.creditincrementtype is '主要增信方式';
comment on column ${idl_schema}.icms_bc_extend_t.islikeloan is '是否类信贷';
comment on column ${idl_schema}.icms_bc_extend_t.isclassflag is '是否分级';
comment on column ${idl_schema}.icms_bc_extend_t.productlevel is '产品分级级别';
comment on column ${idl_schema}.icms_bc_extend_t.productcollectmoney is '产品募集金额';
comment on column ${idl_schema}.icms_bc_extend_t.finalinvestdirecttype is '最终投向类型';
comment on column ${idl_schema}.icms_bc_extend_t.mandatecustname is '委托人名称';
comment on column ${idl_schema}.icms_bc_extend_t.mandatecustid is '委托人ID';
comment on column ${idl_schema}.icms_bc_extend_t.acceptbankid is '承兑行行号';
comment on column ${idl_schema}.icms_bc_extend_t.billacptdate is '出票日(票据)';
comment on column ${idl_schema}.icms_bc_extend_t.billno is '票据号码';
comment on column ${idl_schema}.icms_bc_extend_t.billcurrency is '票据币种(票据)';
comment on column ${idl_schema}.icms_bc_extend_t.billmaturity is '到期日(票据)';
comment on column ${idl_schema}.icms_bc_extend_t.chuantoutype is '穿透类型';
comment on column ${idl_schema}.icms_bc_extend_t.econtractname is '合同名称(信托资管)';
comment on column ${idl_schema}.icms_bc_extend_t.econtracttype is '合同类型(信托资管)';
comment on column ${idl_schema}.icms_bc_extend_t.guarantytype is '担保/操作模式(担保切分必选项)';
comment on column ${idl_schema}.icms_bc_extend_t.guranteerate is '质押率/初始履约保障比例';
comment on column ${idl_schema}.icms_bc_extend_t.contractitems is '合同期次';
comment on column ${idl_schema}.icms_bc_extend_t.isimportantloan is '是否重点项目贷款';
comment on column ${idl_schema}.icms_bc_extend_t.importantloan is '重点贷款项目';
comment on column ${idl_schema}.icms_bc_extend_t.operationtype is '业务类型';
comment on column ${idl_schema}.icms_bc_extend_t.acceptbankname is '承兑行名称';
comment on column ${idl_schema}.icms_bc_extend_t.backtosaletype is '回购类型';
comment on column ${idl_schema}.icms_bc_extend_t.beneficiaryname is '受益人名称';
comment on column ${idl_schema}.icms_bc_extend_t.beneficiaryyieldrate is '受益人的预计年净收益率';
comment on column ${idl_schema}.icms_bc_extend_t.beneficiaryacctno is '受益人账户';
comment on column ${idl_schema}.icms_bc_extend_t.ifgudingcredit is '是否固定资产授信';
comment on column ${idl_schema}.icms_bc_extend_t.manageratetype is '管理费费率及计提方式';
comment on column ${idl_schema}.icms_bc_extend_t.othercondition is '其他条件和要求';
comment on column ${idl_schema}.icms_bc_extend_t.subtotalprices is '认购总价';
comment on column ${idl_schema}.icms_bc_extend_t.ztacceptbankname is '直贴行名称';
comment on column ${idl_schema}.icms_bc_extend_t.ztacceptbankid is '直贴行行号';
comment on column ${idl_schema}.icms_bc_extend_t.relztacceptbankcustid is '直贴行我行客户编号';
comment on column ${idl_schema}.icms_bc_extend_t.iswhzt is '是否我行直贴票据';
comment on column ${idl_schema}.icms_bc_extend_t.corpuspaymethod is '还款方式';
comment on column ${idl_schema}.icms_bc_extend_t.creditattribute is '合同类型';
comment on column ${idl_schema}.icms_bc_extend_t.depositratetype is '托管费费率及计提方式';
comment on column ${idl_schema}.icms_bc_extend_t.expectyieldrate is '预期收益率';
comment on column ${idl_schema}.icms_bc_extend_t.tradecontractno is '贸易合同号';
comment on column ${idl_schema}.icms_bc_extend_t.acceptcustomerid is '承兑行我行客户编号';
comment on column ${idl_schema}.icms_bc_extend_t.entrustyieldtype is '信托收益计提方式';
comment on column ${idl_schema}.icms_bc_extend_t.isbalancedeposit is '是否结算性存款';
comment on column ${idl_schema}.icms_bc_extend_t.isfillassetsinfo is '是否已完整录入全部底层资产信息';
comment on column ${idl_schema}.icms_bc_extend_t.raisefundpurpose is '募集资金用途';
comment on column ${idl_schema}.icms_bc_extend_t.raisemoneyaccountid is '募集资金账户';
comment on column ${idl_schema}.icms_bc_extend_t.repayinteresttype is '还本付息方式(输入)';
comment on column ${idl_schema}.icms_bc_extend_t.businessinvoicesum is '商业发票金额';
comment on column ${idl_schema}.icms_bc_extend_t.financesupportmode is '贷款财政扶持方式';
comment on column ${idl_schema}.icms_bc_extend_t.businessinvoiceinfo is '商业发票号码';
comment on column ${idl_schema}.icms_bc_extend_t.businessinvoicetype is '商业发票种类';
comment on column ${idl_schema}.icms_bc_extend_t.entrustinterestrate is '信托报酬率';
comment on column ${idl_schema}.icms_bc_extend_t.rateexplain is '利率/费率说明';
comment on column ${idl_schema}.icms_bc_extend_t.circulatestockamount is '流通股本(万股)';
comment on column ${idl_schema}.icms_bc_extend_t.issupplychainfinance is '是否为供应链金融业务';
comment on column ${idl_schema}.icms_bc_extend_t.supplychainfinancetype is '供应链金融业务产品分类';
comment on column ${idl_schema}.icms_bc_extend_t.businessinvoicecurrency is '商业发票币种';
comment on column ${idl_schema}.icms_bc_extend_t.entrustinterestratetype is '信托报酬率计提方式';
comment on column ${idl_schema}.icms_bc_extend_t.gshy is '过剩行业';
comment on column ${idl_schema}.icms_bc_extend_t.baileename is '受托人名称';
comment on column ${idl_schema}.icms_bc_extend_t.gksxpz is '国开授信品种';
comment on column ${idl_schema}.icms_bc_extend_t.issuer is '发行人/融资者';
comment on column ${idl_schema}.icms_bc_extend_t.pcline is '平仓线';
comment on column ${idl_schema}.icms_bc_extend_t.sfgksx is '是否国开行授信';
comment on column ${idl_schema}.icms_bc_extend_t.sfzfsx is '是否政府授信';
comment on column ${idl_schema}.icms_bc_extend_t.zfsxfs is '政府授信支持方式';
comment on column ${idl_schema}.icms_bc_extend_t.zfsxlx is '政府授信类型';
comment on column ${idl_schema}.icms_bc_extend_t.ztrate is '转贴现利率(%)';
comment on column ${idl_schema}.icms_bc_extend_t.billsum is '票面金额（元）';
comment on column ${idl_schema}.icms_bc_extend_t.enddate is '到期日期(ABS)';
comment on column ${idl_schema}.icms_bc_extend_t.tdtimes is '与交易对手成功交易次数';
comment on column ${idl_schema}.icms_bc_extend_t.tdyears is '与交易对手合作年限';
comment on column ${idl_schema}.icms_bc_extend_t.trusteename is '托管人名称';
comment on column ${idl_schema}.icms_bc_extend_t.billkind is '票据种类';
comment on column ${idl_schema}.icms_bc_extend_t.billtype is '票据类型';
comment on column ${idl_schema}.icms_bc_extend_t.deadline is '期限(标的)';
comment on column ${idl_schema}.icms_bc_extend_t.issuesum is '发行金额(元)';
comment on column ${idl_schema}.icms_bc_extend_t.sfgjxzhy is '是否国家限制行业';
comment on column ${idl_schema}.icms_bc_extend_t.tradesum is '贸易合同总金额(元)';
comment on column ${idl_schema}.icms_bc_extend_t.alarmline is '预警线';
comment on column ${idl_schema}.icms_bc_extend_t.custodianname is '管理人名称';
comment on column ${idl_schema}.icms_bc_extend_t.depositno is '存单号码';
comment on column ${idl_schema}.icms_bc_extend_t.isfarming is '是否涉农';
comment on column ${idl_schema}.icms_bc_extend_t.repayremark is '还款说明';
comment on column ${idl_schema}.icms_bc_extend_t.stockcode is '标的股票代码';
comment on column ${idl_schema}.icms_bc_extend_t.stockname is '标的股票名称';
comment on column ${idl_schema}.icms_bc_extend_t.tdstrenth is '交易对手实力';
comment on column ${idl_schema}.icms_bc_extend_t.absabnname is 'ABS/ABN名称';
comment on column ${idl_schema}.icms_bc_extend_t.bdindustry is '标的公司行业分类';
comment on column ${idl_schema}.icms_bc_extend_t.billwriter is '出票人';
comment on column ${idl_schema}.icms_bc_extend_t.entrustacc is '信托专户';
comment on column ${idl_schema}.icms_bc_extend_t.issueprice is '发行价格';
comment on column ${idl_schema}.icms_bc_extend_t.issuescale is '发行规模';
comment on column ${idl_schema}.icms_bc_extend_t.partybname is '借款人';
comment on column ${idl_schema}.icms_bc_extend_t.priequname is '私募债名称';
comment on column ${idl_schema}.icms_bc_extend_t.subscriber is '认购人/投资者';
comment on column ${idl_schema}.icms_bc_extend_t.useproduct is '使用产品（贸易融资）';
comment on column ${idl_schema}.icms_bc_extend_t.contextinfo is '交易背景描述';
comment on column ${idl_schema}.icms_bc_extend_t.drawingremark is '提款说明';
comment on column ${idl_schema}.icms_bc_extend_t.contractsum is '合同资金(信托资管)';
comment on column ${idl_schema}.icms_bc_extend_t.depositname is '存单简称';
comment on column ${idl_schema}.icms_bc_extend_t.directionrs is '行业投向(征信)';
comment on column ${idl_schema}.icms_bc_extend_t.drawingtype is '提款方式';
comment on column ${idl_schema}.icms_bc_extend_t.issueamount is '发行量(元)';
comment on column ${idl_schema}.icms_bc_extend_t.mainproduct is '经营商品（贸易融资）';
comment on column ${idl_schema}.icms_bc_extend_t.stockamount is '总股本(万股)';
comment on column ${idl_schema}.icms_bc_extend_t.consigneeid is '管理人/主承销商客户编号';
comment on column ${idl_schema}.icms_bc_extend_t.rivalid is '同业交易对手';
comment on column ${idl_schema}.icms_bc_extend_t.start_dt is '开始日期';
comment on column ${idl_schema}.icms_bc_extend_t.end_dt is '结束日期';
comment on column ${idl_schema}.icms_bc_extend_t.id_mark is '删除标识';
comment on column ${idl_schema}.icms_bc_extend_t.accountcatagory is '账户类别';
comment on column ${idl_schema}.icms_bc_extend_t.datatype is '业务来源（pj.票据系统供数 lc.理财资管系统供数 zj.资金系统供数 zh.同业综合业务系统供数）';
comment on column ${idl_schema}.icms_bc_extend_t.migtflag is '';
comment on column ${idl_schema}.icms_bc_extend_t.salebackbegindate is '回售申请起始日';
comment on column ${idl_schema}.icms_bc_extend_t.assetno is '资产唯一标识';

