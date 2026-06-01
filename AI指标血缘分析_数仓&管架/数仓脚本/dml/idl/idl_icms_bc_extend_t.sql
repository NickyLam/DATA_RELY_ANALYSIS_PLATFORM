/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_bc_extend_t
CreateDate: 20221109
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_bc_extend_t drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_bc_extend_t add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_bc_extend_t (
etl_dt  --ETL处理日期
,serialno  --合同编号
,rivalname  --交易对手名称
,consigneename  --管理人/主承销商
,consigneecerttype  --管理人/主承销商证件类型
,consigneecertid  --管理人/主承销商证件号码
,financier  --实际融资人
,iscounterparty  --是否合格中央交易对手
,fundsource  --资金来源
,investway  --投资方式
,managemodel  --管理模式
,tradingassets  --交易资产
,toindustryfund  --是否投向产业基金
,isdebttoequity  --是否投向市场化债转股
,isgovernfinance  --是否涉及政府类融资
,isconsumerfinance  --是否为消费服务类融资
,bondno  --标的产品编号
,bondname  --债券名称
,investkind  --投资性质
,canseparate  --是否可分离
,canbacktosale  --是否含有回售选择权
,begindate  --回售申请起始日
,salebackenddate  --回售申请截止日
,businessmarkettype  --交易市场类型
,businessmarketname  --交易市场名称
,paymentdate  --兑付日期
,outerevaluate1  --债券外部评级结果（发行时）
,outerevaluate2  --债券外部评级结果（购买时）
,outerevaluate3  --债券外部评级结果（当前）
,couponrate  --票面利率
,transactionprice  --成交净价
,transactionrate  --成交利率
,transactoinamount  --成交量
,transactiondate  --实际交割日期
,creditincrementtype  --主要增信方式
,islikeloan  --是否类信贷
,isclassflag  --是否分级
,productlevel  --产品分级级别
,productcollectmoney  --产品募集金额
,finalinvestdirecttype  --最终投向类型
,mandatecustname  --委托人名称
,mandatecustid  --委托人ID
,acceptbankid  --承兑行行号
,billacptdate  --出票日(票据)
,billno  --票据号码
,billcurrency  --票据币种(票据)
,billmaturity  --到期日(票据)
,chuantoutype  --穿透类型
,econtractname  --合同名称(信托资管)
,econtracttype  --合同类型(信托资管)
,guarantytype  --担保/操作模式(担保切分必选项)
,guranteerate  --质押率/初始履约保障比例
,contractitems  --合同期次
,isimportantloan  --是否重点项目贷款
,importantloan  --重点贷款项目
,operationtype  --业务类型
,acceptbankname  --承兑行名称
,backtosaletype  --回购类型
,beneficiaryname  --受益人名称
,beneficiaryyieldrate  --受益人的预计年净收益率
,beneficiaryacctno  --受益人账户
,ifgudingcredit  --是否固定资产授信
,manageratetype  --管理费费率及计提方式
,othercondition  --其他条件和要求
,subtotalprices  --认购总价
,ztacceptbankname  --直贴行名称
,ztacceptbankid  --直贴行行号
,relztacceptbankcustid  --直贴行我行客户编号
,iswhzt  --是否我行直贴票据
,corpuspaymethod  --还款方式
,creditattribute  --合同类型
,depositratetype  --托管费费率及计提方式
,expectyieldrate  --预期收益率
,tradecontractno  --贸易合同号
,acceptcustomerid  --承兑行我行客户编号
,entrustyieldtype  --信托收益计提方式
,isbalancedeposit  --是否结算性存款
,isfillassetsinfo  --是否已完整录入全部底层资产信息
,raisefundpurpose  --募集资金用途
,raisemoneyaccountid  --募集资金账户
,repayinteresttype  --还本付息方式(输入)
,businessinvoicesum  --商业发票金额
,financesupportmode  --贷款财政扶持方式
,businessinvoiceinfo  --商业发票号码
,businessinvoicetype  --商业发票种类
,entrustinterestrate  --信托报酬率
,rateexplain  --利率/费率说明
,circulatestockamount  --流通股本(万股)
,issupplychainfinance  --是否为供应链金融业务
,supplychainfinancetype  --供应链金融业务产品分类
,businessinvoicecurrency  --商业发票币种
,entrustinterestratetype  --信托报酬率计提方式
,gshy  --过剩行业
,baileename  --受托人名称
,gksxpz  --国开授信品种
,issuer  --发行人/融资者
,pcline  --平仓线
,sfgksx  --是否国开行授信
,sfzfsx  --是否政府授信
,zfsxfs  --政府授信支持方式
,zfsxlx  --政府授信类型
,ztrate  --转贴现利率(%)
,billsum  --票面金额（元）
,enddate  --到期日期(ABS)
,tdtimes  --与交易对手成功交易次数
,tdyears  --与交易对手合作年限
,trusteename  --托管人名称
,billkind  --票据种类
,billtype  --票据类型
,deadline  --期限(标的)
,issuesum  --发行金额(元)
,sfgjxzhy  --是否国家限制行业
,tradesum  --贸易合同总金额(元)
,alarmline  --预警线
,custodianname  --管理人名称
,depositno  --存单号码
,isfarming  --是否涉农
,repayremark  --还款说明
,stockcode  --标的股票代码
,stockname  --标的股票名称
,tdstrenth  --交易对手实力
,absabnname  --ABS/ABN名称
,bdindustry  --标的公司行业分类
,billwriter  --出票人
,entrustacc  --信托专户
,issueprice  --发行价格
,issuescale  --发行规模
,partybname  --借款人
,priequname  --私募债名称
,subscriber  --认购人/投资者
,useproduct  --使用产品（贸易融资）
,contextinfo  --交易背景描述
,drawingremark  --提款说明
,contractsum  --合同资金(信托资管)
,depositname  --存单简称
,directionrs  --行业投向(征信)
,drawingtype  --提款方式
,issueamount  --发行量(元)
,mainproduct  --经营商品（贸易融资）
,stockamount  --总股本(万股)
,consigneeid  --管理人/主承销商客户编号
,rivalid  --同业交易对手
,start_dt  --开始日期
,end_dt  --结束日期
,id_mark  --删除标识
,accountcatagory  --账户类别
,datatype  --业务来源（pj.票据系统供数 lc.理财资管系统供数 zj.资金系统供数 zh.同业综合业务系统供数）
,migtflag  --
,salebackbegindate  --回售申请起始日
,assetno  --资产唯一标识

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --合同编号
,replace(replace(t1.rivalname,chr(13),''),chr(10),'') as rivalname --交易对手名称
,replace(replace(t1.consigneename,chr(13),''),chr(10),'') as consigneename --管理人/主承销商
,replace(replace(t1.consigneecerttype,chr(13),''),chr(10),'') as consigneecerttype --管理人/主承销商证件类型
,replace(replace(t1.consigneecertid,chr(13),''),chr(10),'') as consigneecertid --管理人/主承销商证件号码
,replace(replace(t1.financier,chr(13),''),chr(10),'') as financier --实际融资人
,replace(replace(t1.iscounterparty,chr(13),''),chr(10),'') as iscounterparty --是否合格中央交易对手
,replace(replace(t1.fundsource,chr(13),''),chr(10),'') as fundsource --资金来源
,replace(replace(t1.investway,chr(13),''),chr(10),'') as investway --投资方式
,replace(replace(t1.managemodel,chr(13),''),chr(10),'') as managemodel --管理模式
,replace(replace(t1.tradingassets,chr(13),''),chr(10),'') as tradingassets --交易资产
,replace(replace(t1.toindustryfund,chr(13),''),chr(10),'') as toindustryfund --是否投向产业基金
,replace(replace(t1.isdebttoequity,chr(13),''),chr(10),'') as isdebttoequity --是否投向市场化债转股
,replace(replace(t1.isgovernfinance,chr(13),''),chr(10),'') as isgovernfinance --是否涉及政府类融资
,replace(replace(t1.isconsumerfinance,chr(13),''),chr(10),'') as isconsumerfinance --是否为消费服务类融资
,replace(replace(t1.bondno,chr(13),''),chr(10),'') as bondno --标的产品编号
,replace(replace(t1.bondname,chr(13),''),chr(10),'') as bondname --债券名称
,replace(replace(t1.investkind,chr(13),''),chr(10),'') as investkind --投资性质
,replace(replace(t1.canseparate,chr(13),''),chr(10),'') as canseparate --是否可分离
,replace(replace(t1.canbacktosale,chr(13),''),chr(10),'') as canbacktosale --是否含有回售选择权
,t1.begindate as begindate --回售申请起始日
,replace(replace(t1.salebackenddate,chr(13),''),chr(10),'') as salebackenddate --回售申请截止日
,replace(replace(t1.businessmarkettype,chr(13),''),chr(10),'') as businessmarkettype --交易市场类型
,replace(replace(t1.businessmarketname,chr(13),''),chr(10),'') as businessmarketname --交易市场名称
,t1.paymentdate as paymentdate --兑付日期
,replace(replace(t1.outerevaluate1,chr(13),''),chr(10),'') as outerevaluate1 --债券外部评级结果（发行时）
,replace(replace(t1.outerevaluate2,chr(13),''),chr(10),'') as outerevaluate2 --债券外部评级结果（购买时）
,replace(replace(t1.outerevaluate3,chr(13),''),chr(10),'') as outerevaluate3 --债券外部评级结果（当前）
,t1.couponrate as couponrate --票面利率
,t1.transactionprice as transactionprice --成交净价
,t1.transactionrate as transactionrate --成交利率
,replace(replace(t1.transactoinamount,chr(13),''),chr(10),'') as transactoinamount --成交量
,t1.transactiondate as transactiondate --实际交割日期
,replace(replace(t1.creditincrementtype,chr(13),''),chr(10),'') as creditincrementtype --主要增信方式
,replace(replace(t1.islikeloan,chr(13),''),chr(10),'') as islikeloan --是否类信贷
,replace(replace(t1.isclassflag,chr(13),''),chr(10),'') as isclassflag --是否分级
,t1.productlevel as productlevel --产品分级级别
,t1.productcollectmoney as productcollectmoney --产品募集金额
,replace(replace(t1.finalinvestdirecttype,chr(13),''),chr(10),'') as finalinvestdirecttype --最终投向类型
,replace(replace(t1.mandatecustname,chr(13),''),chr(10),'') as mandatecustname --委托人名称
,replace(replace(t1.mandatecustid,chr(13),''),chr(10),'') as mandatecustid --委托人ID
,replace(replace(t1.acceptbankid,chr(13),''),chr(10),'') as acceptbankid --承兑行行号
,replace(replace(t1.billacptdate,chr(13),''),chr(10),'') as billacptdate --出票日(票据)
,replace(replace(t1.billno,chr(13),''),chr(10),'') as billno --票据号码
,replace(replace(t1.billcurrency,chr(13),''),chr(10),'') as billcurrency --票据币种(票据)
,replace(replace(t1.billmaturity,chr(13),''),chr(10),'') as billmaturity --到期日(票据)
,replace(replace(t1.chuantoutype,chr(13),''),chr(10),'') as chuantoutype --穿透类型
,replace(replace(t1.econtractname,chr(13),''),chr(10),'') as econtractname --合同名称(信托资管)
,replace(replace(t1.econtracttype,chr(13),''),chr(10),'') as econtracttype --合同类型(信托资管)
,replace(replace(t1.guarantytype,chr(13),''),chr(10),'') as guarantytype --担保/操作模式(担保切分必选项)
,t1.guranteerate as guranteerate --质押率/初始履约保障比例
,t1.contractitems as contractitems --合同期次
,replace(replace(t1.isimportantloan,chr(13),''),chr(10),'') as isimportantloan --是否重点项目贷款
,replace(replace(t1.importantloan,chr(13),''),chr(10),'') as importantloan --重点贷款项目
,replace(replace(t1.operationtype,chr(13),''),chr(10),'') as operationtype --业务类型
,replace(replace(t1.acceptbankname,chr(13),''),chr(10),'') as acceptbankname --承兑行名称
,replace(replace(t1.backtosaletype,chr(13),''),chr(10),'') as backtosaletype --回购类型
,replace(replace(t1.beneficiaryname,chr(13),''),chr(10),'') as beneficiaryname --受益人名称
,t1.beneficiaryyieldrate as beneficiaryyieldrate --受益人的预计年净收益率
,replace(replace(t1.beneficiaryacctno,chr(13),''),chr(10),'') as beneficiaryacctno --受益人账户
,replace(replace(t1.ifgudingcredit,chr(13),''),chr(10),'') as ifgudingcredit --是否固定资产授信
,replace(replace(t1.manageratetype,chr(13),''),chr(10),'') as manageratetype --管理费费率及计提方式
,replace(replace(t1.othercondition,chr(13),''),chr(10),'') as othercondition --其他条件和要求
,t1.subtotalprices as subtotalprices --认购总价
,replace(replace(t1.ztacceptbankname,chr(13),''),chr(10),'') as ztacceptbankname --直贴行名称
,replace(replace(t1.ztacceptbankid,chr(13),''),chr(10),'') as ztacceptbankid --直贴行行号
,replace(replace(t1.relztacceptbankcustid,chr(13),''),chr(10),'') as relztacceptbankcustid --直贴行我行客户编号
,replace(replace(t1.iswhzt,chr(13),''),chr(10),'') as iswhzt --是否我行直贴票据
,replace(replace(t1.corpuspaymethod,chr(13),''),chr(10),'') as corpuspaymethod --还款方式
,replace(replace(t1.creditattribute,chr(13),''),chr(10),'') as creditattribute --合同类型
,replace(replace(t1.depositratetype,chr(13),''),chr(10),'') as depositratetype --托管费费率及计提方式
,t1.expectyieldrate as expectyieldrate --预期收益率
,replace(replace(t1.tradecontractno,chr(13),''),chr(10),'') as tradecontractno --贸易合同号
,replace(replace(t1.acceptcustomerid,chr(13),''),chr(10),'') as acceptcustomerid --承兑行我行客户编号
,replace(replace(t1.entrustyieldtype,chr(13),''),chr(10),'') as entrustyieldtype --信托收益计提方式
,replace(replace(t1.isbalancedeposit,chr(13),''),chr(10),'') as isbalancedeposit --是否结算性存款
,replace(replace(t1.isfillassetsinfo,chr(13),''),chr(10),'') as isfillassetsinfo --是否已完整录入全部底层资产信息
,replace(replace(t1.raisefundpurpose,chr(13),''),chr(10),'') as raisefundpurpose --募集资金用途
,replace(replace(t1.raisemoneyaccountid,chr(13),''),chr(10),'') as raisemoneyaccountid --募集资金账户
,replace(replace(t1.repayinteresttype,chr(13),''),chr(10),'') as repayinteresttype --还本付息方式(输入)
,t1.businessinvoicesum as businessinvoicesum --商业发票金额
,replace(replace(t1.financesupportmode,chr(13),''),chr(10),'') as financesupportmode --贷款财政扶持方式
,replace(replace(t1.businessinvoiceinfo,chr(13),''),chr(10),'') as businessinvoiceinfo --商业发票号码
,replace(replace(t1.businessinvoicetype,chr(13),''),chr(10),'') as businessinvoicetype --商业发票种类
,t1.entrustinterestrate as entrustinterestrate --信托报酬率
,replace(replace(t1.rateexplain,chr(13),''),chr(10),'') as rateexplain --利率/费率说明
,t1.circulatestockamount as circulatestockamount --流通股本(万股)
,replace(replace(t1.issupplychainfinance,chr(13),''),chr(10),'') as issupplychainfinance --是否为供应链金融业务
,replace(replace(t1.supplychainfinancetype,chr(13),''),chr(10),'') as supplychainfinancetype --供应链金融业务产品分类
,replace(replace(t1.businessinvoicecurrency,chr(13),''),chr(10),'') as businessinvoicecurrency --商业发票币种
,replace(replace(t1.entrustinterestratetype,chr(13),''),chr(10),'') as entrustinterestratetype --信托报酬率计提方式
,replace(replace(t1.gshy,chr(13),''),chr(10),'') as gshy --过剩行业
,replace(replace(t1.baileename,chr(13),''),chr(10),'') as baileename --受托人名称
,replace(replace(t1.gksxpz,chr(13),''),chr(10),'') as gksxpz --国开授信品种
,replace(replace(t1.issuer,chr(13),''),chr(10),'') as issuer --发行人/融资者
,replace(replace(t1.pcline,chr(13),''),chr(10),'') as pcline --平仓线
,replace(replace(t1.sfgksx,chr(13),''),chr(10),'') as sfgksx --是否国开行授信
,replace(replace(t1.sfzfsx,chr(13),''),chr(10),'') as sfzfsx --是否政府授信
,replace(replace(t1.zfsxfs,chr(13),''),chr(10),'') as zfsxfs --政府授信支持方式
,replace(replace(t1.zfsxlx,chr(13),''),chr(10),'') as zfsxlx --政府授信类型
,t1.ztrate as ztrate --转贴现利率(%)
,t1.billsum as billsum --票面金额（元）
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate --到期日期(ABS)
,replace(replace(t1.tdtimes,chr(13),''),chr(10),'') as tdtimes --与交易对手成功交易次数
,replace(replace(t1.tdyears,chr(13),''),chr(10),'') as tdyears --与交易对手合作年限
,replace(replace(t1.trusteename,chr(13),''),chr(10),'') as trusteename --托管人名称
,replace(replace(t1.billkind,chr(13),''),chr(10),'') as billkind --票据种类
,replace(replace(t1.billtype,chr(13),''),chr(10),'') as billtype --票据类型
,t1.deadline as deadline --期限(标的)
,t1.issuesum as issuesum --发行金额(元)
,replace(replace(t1.sfgjxzhy,chr(13),''),chr(10),'') as sfgjxzhy --是否国家限制行业
,t1.tradesum as tradesum --贸易合同总金额(元)
,replace(replace(t1.alarmline,chr(13),''),chr(10),'') as alarmline --预警线
,replace(replace(t1.custodianname,chr(13),''),chr(10),'') as custodianname --管理人名称
,replace(replace(t1.depositno,chr(13),''),chr(10),'') as depositno --存单号码
,replace(replace(t1.isfarming,chr(13),''),chr(10),'') as isfarming --是否涉农
,replace(replace(t1.repayremark,chr(13),''),chr(10),'') as repayremark --还款说明
,replace(replace(t1.stockcode,chr(13),''),chr(10),'') as stockcode --标的股票代码
,replace(replace(t1.stockname,chr(13),''),chr(10),'') as stockname --标的股票名称
,replace(replace(t1.tdstrenth,chr(13),''),chr(10),'') as tdstrenth --交易对手实力
,replace(replace(t1.absabnname,chr(13),''),chr(10),'') as absabnname --ABS/ABN名称
,replace(replace(t1.bdindustry,chr(13),''),chr(10),'') as bdindustry --标的公司行业分类
,replace(replace(t1.billwriter,chr(13),''),chr(10),'') as billwriter --出票人
,replace(replace(t1.entrustacc,chr(13),''),chr(10),'') as entrustacc --信托专户
,t1.issueprice as issueprice --发行价格
,replace(replace(t1.issuescale,chr(13),''),chr(10),'') as issuescale --发行规模
,replace(replace(t1.partybname,chr(13),''),chr(10),'') as partybname --借款人
,replace(replace(t1.priequname,chr(13),''),chr(10),'') as priequname --私募债名称
,replace(replace(t1.subscriber,chr(13),''),chr(10),'') as subscriber --认购人/投资者
,replace(replace(t1.useproduct,chr(13),''),chr(10),'') as useproduct --使用产品（贸易融资）
,replace(replace(t1.contextinfo,chr(13),''),chr(10),'') as contextinfo --交易背景描述
,replace(replace(t1.drawingremark,chr(13),''),chr(10),'') as drawingremark --提款说明
,t1.contractsum as contractsum --合同资金(信托资管)
,replace(replace(t1.depositname,chr(13),''),chr(10),'') as depositname --存单简称
,replace(replace(t1.directionrs,chr(13),''),chr(10),'') as directionrs --行业投向(征信)
,replace(replace(t1.drawingtype,chr(13),''),chr(10),'') as drawingtype --提款方式
,t1.issueamount as issueamount --发行量(元)
,replace(replace(t1.mainproduct,chr(13),''),chr(10),'') as mainproduct --经营商品（贸易融资）
,t1.stockamount as stockamount --总股本(万股)
,replace(replace(t1.consigneeid,chr(13),''),chr(10),'') as consigneeid --管理人/主承销商客户编号
,replace(replace(t1.rivalid,chr(13),''),chr(10),'') as rivalid --同业交易对手
,t1.start_dt as start_dt --开始日期
,t1.end_dt as end_dt --结束日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --删除标识
,replace(replace(t1.accountcatagory,chr(13),''),chr(10),'') as accountcatagory --账户类别
,replace(replace(t1.datatype,chr(13),''),chr(10),'') as datatype --业务来源（pj.票据系统供数 lc.理财资管系统供数 zj.资金系统供数 zh.同业综合业务系统供数）
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --
,replace(replace(t1.salebackbegindate,chr(13),''),chr(10),'') as salebackbegindate --回售申请起始日
,replace(replace(t1.assetno,chr(13),''),chr(10),'') as assetno --资产唯一标识
from ${iol_schema}.icms_bc_extend_t t1    --同业投融资业务合同个性化信息
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_bc_extend_t',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
