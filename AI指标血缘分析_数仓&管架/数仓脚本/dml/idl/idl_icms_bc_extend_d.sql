/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_bc_extend_d
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
alter table ${idl_schema}.icms_bc_extend_d drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_bc_extend_d add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_bc_extend_d (
etl_dt  --ETL处理日期
,serialno  --合同编号
,tradesum  --贸易合同总金额(元)
,isrz  --是否融资合同
,creditattribute  --合同类型
,tradecontractno  --贸易合同号
,lctype  --信用证种类
,lcsum  --信用证金额（元）
,lccurrency  --信用证币种
,lcno  --信用证编号
,thirdpartyaccounts  --提单号码
,pwwh  --批文文号
,lxpw  --立项批文
,lcopertype  --信用证类型
,lccdflag  --远期信用证是否已承兑
,lctermtype  --信用证期限类型
,lcquality  --信用证性质
,destination1  --装运地
,oldlcloadingdate  --装运日期
,graceperiod  --远期付款期限(天)
,costpersontype  --费用承担人
,mfeeratio  --其他费率(‰)
,rateexplain  --利率/费率说明
,cargoinfo  --货物名称
,totalcast  --货物标的
,destination2  --货物运输目的地
,oldlcno  --母证编号
,oldlccurrency  --母证币种
,oldlcsum  --母证金额
,discountsum  --应收帐款净额(元)
,zfsxlx  --政府授信类型
,contextinfo  --交易背景描述
,ifgudingcredit  --是否固定资产授信
,moneytype  --委托存款钞汇类别
,restbalancesum  --打包成数(%)
,guarantytype  --担保/操作模式(担保切分必选项)
,othercondition  --其他条件和要求
,mandatesource  --委托贷款资金来源
,isyfconfirmed  --是否经议付行确认
,purchaserpayintratio  --贴现利息买方承担比例(%)
,ifqueryflag  --是否先贴后查
,iscounterparty  --是否合格中央交易对手
,bailaccount  --保证金帐号
,bailcurrency  --保证金币种
,bailtransaccount  --保证金转出帐号
,guarantybailaccount  --押品转保证金账号
,interestrate  --保证金协议利率
,fxfltp  --保证金利率类型
,pdrifv  --保证金浮动值
,pdrifd  --保证金利率浮动类型
,pdrifm  --保证金利率浮动方式
,interestmethod  --保证金计息方法
,termcd  --保证金利率档次
,mandatecustname  --委托人
,repayremark  --还款说明
,ventureguarantytype  --创业担保贷款类型
,isconsumerfinance  --是否为消费服务类融资
,lcpaymethod  --付款方式
,drawingremark  --提款说明
,loantraderatio  --贷款金额占交易价款比例(%)
,mainproduct  --经营商品（贸易融资）
,billnum  --汇票数量(张)
,discountdrafttype  --贴现的商业承兑汇票类别
,businessinvoiceinfo  --商业发票号码
,businessinvoicetype  --商业发票种类
,businessinvoicecurrency  --商业发票币种
,businessinvoicesum  --商业发票金额
,qtxkzbh  --其他许可证编号
,qtxkz  --其他许可证
,hpxkzbh  --环评许可证编号
,jsydxkzbh  --建设用地许可证编号
,ghxkzbh  --规划许可证编号
,sgxkzbh  --施工许可证编号
,corpuspaymethod  --还款方式
,toindustryfund  --是否投向产业基金
,consignmentloandirect  --委托贷款特殊投向
,isventureguaranty  --是否创业担保贷款
,securitiestype  --运输方式
,mandatedepacctno  --委托存款帐户
,bondno  --标的产品编号
,productcollectmoney  --产品募集金额
,productlevel  --产品分级级别
,gshy  --过剩行业
,purchaserregion  --买方所在地区
,isfarming  --是否涉农
,rivalname  --交易对手名称
,farmingloandirect  --涉农贷款投向
,businessprop  --放款成数(%)
,registerinotherbank  --是否他行代开
,zbj  --资本金
,consigneename  --管理人/主承销商
,consigneecerttype  --管理人/主承销商证件类型
,consigneecertid  --管理人/主承销商证件号码
,useproduct  --使用产品（贸易融资）
,beneficiarycountryname  --受益人所在国家或地区
,purchasername  --买方名称
,farmingsubjecttype  --涉农贷款主体类型
,lcapplyserialno  --开证申请书编号
,mandatecustid  --委托人客户
,isimportantloan  --是否重点项目贷款
,discountratenote  --贴现利率说明
,factoringtype  --保理类型
,ifagreementflag  --是否协议付息
,kgrq  --开工日期
,sfgksx  --是否国开行授信
,offerbilldate  --提供单据日期
,financier  --实际融资人
,discountcusttype  --贴现申请人种类
,isgovernfinance  --是否涉及政府类融资
,financesupportmode  --贷款财政扶持方式
,issjorcs  --是否三旧改造或城市更新项目
,yffdkje  --银团已发放贷款金额(元)
,fundsource  --资金来源
,zfsxfs  --政府授信支持方式
,directionrs  --行业投向(征信)
,classifyfrequency  --检查频率
,supplychainfinancetype  --供应链金融业务产品分类
,projectartificialno  --项目信息文本号
,hasoutradio  --是否存在溢短装的条款
,beneficiaryname  --受益人名称
,tradecurrency  --委托存款币种
,isyfreceive  --是否预付应收帐款
,acceptbankname  --承兑行名称
,tdyears  --与交易对手合作年限
,putoutorgid  --放贷机构
,gksxpz  --国开授信品种
,loantradesum  --贷款用途交易金额
,sfzfsx  --是否政府授信
,isdebttoequity  --是否投向市场化债转股
,creditincrementtype  --主要增信方式
,outradio  --溢短装比例（%）
,loanquality  --贷款性质
,issupplychainfinance  --是否为供应链金融业务
,noticebankname  --通知行
,tdtimes  --与交易对手成功交易次数
,paymentname  --付息方
,tradingassets  --交易资产
,loanhandlechannel  --贷款办理渠道
,thirdparty1type  --代付类型
,otherarealoan  --是否异地业务
,realestateloantype  --房地产贷款类型
,proposerpaymentscale  --贴现利息申请人支付比例(%)
,xmztz  --项目总投资
,sfgjxzhy  --是否国家限制行业
,tdstrenth  --交易对手实力
,locfinancefundsource  --地方融资平台偿债资金来源分类
,importantloan  --重点贷款项目
,duepaymethod  --应收帐款预付方式
,drawingtype  --提款方式
,start_dt  --开始日期
,end_dt  --结束日期
,id_mark  --删除标识
,careerguaranteeloantype  --创业担保贷款类型
,farmingloanuse  --涉农贷款投向
,iscareerguaranteeloan  --是否创业担保贷款
,platformpaycashsource  --地方融资平台偿债资金来源分类
,farmingloantype  --涉农贷款主体类型
,isforeign  --是否境外贷款
,migtflag  --
,guaranteehprojecttype  --保障性安居工程贷款类型LoanPurposeType
,landuseno  --土地使用证编号
,landusedate  --土地使用证日期
,landplanpermitno  --用地规划许可证编号
,landplanpermitdate  --用地规划许可证日期
,constructpermitdate  --施工许可证日期
,projectplanpermitdate  --工程规划许可证日期
,buyername  --购货方名称
,sellername  --销货方名称
,tradetransactioncontent  --贸易交易内容

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --合同编号
,t1.tradesum as tradesum --贸易合同总金额(元)
,replace(replace(t1.isrz,chr(13),''),chr(10),'') as isrz --是否融资合同
,replace(replace(t1.creditattribute,chr(13),''),chr(10),'') as creditattribute --合同类型
,replace(replace(t1.tradecontractno,chr(13),''),chr(10),'') as tradecontractno --贸易合同号
,replace(replace(t1.lctype,chr(13),''),chr(10),'') as lctype --信用证种类
,t1.lcsum as lcsum --信用证金额（元）
,replace(replace(t1.lccurrency,chr(13),''),chr(10),'') as lccurrency --信用证币种
,replace(replace(t1.lcno,chr(13),''),chr(10),'') as lcno --信用证编号
,replace(replace(t1.thirdpartyaccounts,chr(13),''),chr(10),'') as thirdpartyaccounts --提单号码
,replace(replace(t1.pwwh,chr(13),''),chr(10),'') as pwwh --批文文号
,replace(replace(t1.lxpw,chr(13),''),chr(10),'') as lxpw --立项批文
,replace(replace(t1.lcopertype,chr(13),''),chr(10),'') as lcopertype --信用证类型
,replace(replace(t1.lccdflag,chr(13),''),chr(10),'') as lccdflag --远期信用证是否已承兑
,replace(replace(t1.lctermtype,chr(13),''),chr(10),'') as lctermtype --信用证期限类型
,replace(replace(t1.lcquality,chr(13),''),chr(10),'') as lcquality --信用证性质
,replace(replace(t1.destination1,chr(13),''),chr(10),'') as destination1 --装运地
,replace(replace(t1.oldlcloadingdate,chr(13),''),chr(10),'') as oldlcloadingdate --装运日期
,t1.graceperiod as graceperiod --远期付款期限(天)
,replace(replace(t1.costpersontype,chr(13),''),chr(10),'') as costpersontype --费用承担人
,t1.mfeeratio as mfeeratio --其他费率(‰)
,replace(replace(t1.rateexplain,chr(13),''),chr(10),'') as rateexplain --利率/费率说明
,replace(replace(t1.cargoinfo,chr(13),''),chr(10),'') as cargoinfo --货物名称
,t1.totalcast as totalcast --货物标的
,replace(replace(t1.destination2,chr(13),''),chr(10),'') as destination2 --货物运输目的地
,replace(replace(t1.oldlcno,chr(13),''),chr(10),'') as oldlcno --母证编号
,replace(replace(t1.oldlccurrency,chr(13),''),chr(10),'') as oldlccurrency --母证币种
,t1.oldlcsum as oldlcsum --母证金额
,t1.discountsum as discountsum --应收帐款净额(元)
,replace(replace(t1.zfsxlx,chr(13),''),chr(10),'') as zfsxlx --政府授信类型
,replace(replace(t1.contextinfo,chr(13),''),chr(10),'') as contextinfo --交易背景描述
,replace(replace(t1.ifgudingcredit,chr(13),''),chr(10),'') as ifgudingcredit --是否固定资产授信
,replace(replace(t1.moneytype,chr(13),''),chr(10),'') as moneytype --委托存款钞汇类别
,t1.restbalancesum as restbalancesum --打包成数(%)
,replace(replace(t1.guarantytype,chr(13),''),chr(10),'') as guarantytype --担保/操作模式(担保切分必选项)
,replace(replace(t1.othercondition,chr(13),''),chr(10),'') as othercondition --其他条件和要求
,replace(replace(t1.mandatesource,chr(13),''),chr(10),'') as mandatesource --委托贷款资金来源
,replace(replace(t1.isyfconfirmed,chr(13),''),chr(10),'') as isyfconfirmed --是否经议付行确认
,t1.purchaserpayintratio as purchaserpayintratio --贴现利息买方承担比例(%)
,replace(replace(t1.ifqueryflag,chr(13),''),chr(10),'') as ifqueryflag --是否先贴后查
,replace(replace(t1.iscounterparty,chr(13),''),chr(10),'') as iscounterparty --是否合格中央交易对手
,replace(replace(t1.bailaccount,chr(13),''),chr(10),'') as bailaccount --保证金帐号
,replace(replace(t1.bailcurrency,chr(13),''),chr(10),'') as bailcurrency --保证金币种
,replace(replace(t1.bailtransaccount,chr(13),''),chr(10),'') as bailtransaccount --保证金转出帐号
,replace(replace(t1.guarantybailaccount,chr(13),''),chr(10),'') as guarantybailaccount --押品转保证金账号
,t1.interestrate as interestrate --保证金协议利率
,replace(replace(t1.fxfltp,chr(13),''),chr(10),'') as fxfltp --保证金利率类型
,replace(replace(t1.pdrifv,chr(13),''),chr(10),'') as pdrifv --保证金浮动值
,replace(replace(t1.pdrifd,chr(13),''),chr(10),'') as pdrifd --保证金利率浮动类型
,replace(replace(t1.pdrifm,chr(13),''),chr(10),'') as pdrifm --保证金利率浮动方式
,replace(replace(t1.interestmethod,chr(13),''),chr(10),'') as interestmethod --保证金计息方法
,replace(replace(t1.termcd,chr(13),''),chr(10),'') as termcd --保证金利率档次
,replace(replace(t1.mandatecustname,chr(13),''),chr(10),'') as mandatecustname --委托人
,replace(replace(t1.repayremark,chr(13),''),chr(10),'') as repayremark --还款说明
,replace(replace(t1.ventureguarantytype,chr(13),''),chr(10),'') as ventureguarantytype --创业担保贷款类型
,replace(replace(t1.isconsumerfinance,chr(13),''),chr(10),'') as isconsumerfinance --是否为消费服务类融资
,replace(replace(t1.lcpaymethod,chr(13),''),chr(10),'') as lcpaymethod --付款方式
,replace(replace(t1.drawingremark,chr(13),''),chr(10),'') as drawingremark --提款说明
,t1.loantraderatio as loantraderatio --贷款金额占交易价款比例(%)
,replace(replace(t1.mainproduct,chr(13),''),chr(10),'') as mainproduct --经营商品（贸易融资）
,t1.billnum as billnum --汇票数量(张)
,replace(replace(t1.discountdrafttype,chr(13),''),chr(10),'') as discountdrafttype --贴现的商业承兑汇票类别
,replace(replace(t1.businessinvoiceinfo,chr(13),''),chr(10),'') as businessinvoiceinfo --商业发票号码
,replace(replace(t1.businessinvoicetype,chr(13),''),chr(10),'') as businessinvoicetype --商业发票种类
,replace(replace(t1.businessinvoicecurrency,chr(13),''),chr(10),'') as businessinvoicecurrency --商业发票币种
,t1.businessinvoicesum as businessinvoicesum --商业发票金额
,replace(replace(t1.qtxkzbh,chr(13),''),chr(10),'') as qtxkzbh --其他许可证编号
,replace(replace(t1.qtxkz,chr(13),''),chr(10),'') as qtxkz --其他许可证
,replace(replace(t1.hpxkzbh,chr(13),''),chr(10),'') as hpxkzbh --环评许可证编号
,replace(replace(t1.jsydxkzbh,chr(13),''),chr(10),'') as jsydxkzbh --建设用地许可证编号
,replace(replace(t1.ghxkzbh,chr(13),''),chr(10),'') as ghxkzbh --规划许可证编号
,replace(replace(t1.sgxkzbh,chr(13),''),chr(10),'') as sgxkzbh --施工许可证编号
,replace(replace(t1.corpuspaymethod,chr(13),''),chr(10),'') as corpuspaymethod --还款方式
,replace(replace(t1.toindustryfund,chr(13),''),chr(10),'') as toindustryfund --是否投向产业基金
,replace(replace(t1.consignmentloandirect,chr(13),''),chr(10),'') as consignmentloandirect --委托贷款特殊投向
,replace(replace(t1.isventureguaranty,chr(13),''),chr(10),'') as isventureguaranty --是否创业担保贷款
,replace(replace(t1.securitiestype,chr(13),''),chr(10),'') as securitiestype --运输方式
,replace(replace(t1.mandatedepacctno,chr(13),''),chr(10),'') as mandatedepacctno --委托存款帐户
,replace(replace(t1.bondno,chr(13),''),chr(10),'') as bondno --标的产品编号
,t1.productcollectmoney as productcollectmoney --产品募集金额
,t1.productlevel as productlevel --产品分级级别
,replace(replace(t1.gshy,chr(13),''),chr(10),'') as gshy --过剩行业
,replace(replace(t1.purchaserregion,chr(13),''),chr(10),'') as purchaserregion --买方所在地区
,replace(replace(t1.isfarming,chr(13),''),chr(10),'') as isfarming --是否涉农
,replace(replace(t1.rivalname,chr(13),''),chr(10),'') as rivalname --交易对手名称
,replace(replace(t1.farmingloandirect,chr(13),''),chr(10),'') as farmingloandirect --涉农贷款投向
,t1.businessprop as businessprop --放款成数(%)
,replace(replace(t1.registerinotherbank,chr(13),''),chr(10),'') as registerinotherbank --是否他行代开
,t1.zbj as zbj --资本金
,replace(replace(t1.consigneename,chr(13),''),chr(10),'') as consigneename --管理人/主承销商
,replace(replace(t1.consigneecerttype,chr(13),''),chr(10),'') as consigneecerttype --管理人/主承销商证件类型
,replace(replace(t1.consigneecertid,chr(13),''),chr(10),'') as consigneecertid --管理人/主承销商证件号码
,replace(replace(t1.useproduct,chr(13),''),chr(10),'') as useproduct --使用产品（贸易融资）
,replace(replace(t1.beneficiarycountryname,chr(13),''),chr(10),'') as beneficiarycountryname --受益人所在国家或地区
,replace(replace(t1.purchasername,chr(13),''),chr(10),'') as purchasername --买方名称
,replace(replace(t1.farmingsubjecttype,chr(13),''),chr(10),'') as farmingsubjecttype --涉农贷款主体类型
,replace(replace(t1.lcapplyserialno,chr(13),''),chr(10),'') as lcapplyserialno --开证申请书编号
,replace(replace(t1.mandatecustid,chr(13),''),chr(10),'') as mandatecustid --委托人客户
,replace(replace(t1.isimportantloan,chr(13),''),chr(10),'') as isimportantloan --是否重点项目贷款
,replace(replace(t1.discountratenote,chr(13),''),chr(10),'') as discountratenote --贴现利率说明
,replace(replace(t1.factoringtype,chr(13),''),chr(10),'') as factoringtype --保理类型
,replace(replace(t1.ifagreementflag,chr(13),''),chr(10),'') as ifagreementflag --是否协议付息
,replace(replace(t1.kgrq,chr(13),''),chr(10),'') as kgrq --开工日期
,replace(replace(t1.sfgksx,chr(13),''),chr(10),'') as sfgksx --是否国开行授信
,replace(replace(t1.offerbilldate,chr(13),''),chr(10),'') as offerbilldate --提供单据日期
,replace(replace(t1.financier,chr(13),''),chr(10),'') as financier --实际融资人
,replace(replace(t1.discountcusttype,chr(13),''),chr(10),'') as discountcusttype --贴现申请人种类
,replace(replace(t1.isgovernfinance,chr(13),''),chr(10),'') as isgovernfinance --是否涉及政府类融资
,replace(replace(t1.financesupportmode,chr(13),''),chr(10),'') as financesupportmode --贷款财政扶持方式
,replace(replace(t1.issjorcs,chr(13),''),chr(10),'') as issjorcs --是否三旧改造或城市更新项目
,t1.yffdkje as yffdkje --银团已发放贷款金额(元)
,replace(replace(t1.fundsource,chr(13),''),chr(10),'') as fundsource --资金来源
,replace(replace(t1.zfsxfs,chr(13),''),chr(10),'') as zfsxfs --政府授信支持方式
,replace(replace(t1.directionrs,chr(13),''),chr(10),'') as directionrs --行业投向(征信)
,t1.classifyfrequency as classifyfrequency --检查频率
,replace(replace(t1.supplychainfinancetype,chr(13),''),chr(10),'') as supplychainfinancetype --供应链金融业务产品分类
,replace(replace(t1.projectartificialno,chr(13),''),chr(10),'') as projectartificialno --项目信息文本号
,replace(replace(t1.hasoutradio,chr(13),''),chr(10),'') as hasoutradio --是否存在溢短装的条款
,replace(replace(t1.beneficiaryname,chr(13),''),chr(10),'') as beneficiaryname --受益人名称
,replace(replace(t1.tradecurrency,chr(13),''),chr(10),'') as tradecurrency --委托存款币种
,replace(replace(t1.isyfreceive,chr(13),''),chr(10),'') as isyfreceive --是否预付应收帐款
,replace(replace(t1.acceptbankname,chr(13),''),chr(10),'') as acceptbankname --承兑行名称
,replace(replace(t1.tdyears,chr(13),''),chr(10),'') as tdyears --与交易对手合作年限
,replace(replace(t1.putoutorgid,chr(13),''),chr(10),'') as putoutorgid --放贷机构
,replace(replace(t1.gksxpz,chr(13),''),chr(10),'') as gksxpz --国开授信品种
,t1.loantradesum as loantradesum --贷款用途交易金额
,replace(replace(t1.sfzfsx,chr(13),''),chr(10),'') as sfzfsx --是否政府授信
,replace(replace(t1.isdebttoequity,chr(13),''),chr(10),'') as isdebttoequity --是否投向市场化债转股
,replace(replace(t1.creditincrementtype,chr(13),''),chr(10),'') as creditincrementtype --主要增信方式
,t1.outradio as outradio --溢短装比例（%）
,replace(replace(t1.loanquality,chr(13),''),chr(10),'') as loanquality --贷款性质
,replace(replace(t1.issupplychainfinance,chr(13),''),chr(10),'') as issupplychainfinance --是否为供应链金融业务
,replace(replace(t1.noticebankname,chr(13),''),chr(10),'') as noticebankname --通知行
,replace(replace(t1.tdtimes,chr(13),''),chr(10),'') as tdtimes --与交易对手成功交易次数
,replace(replace(t1.paymentname,chr(13),''),chr(10),'') as paymentname --付息方
,replace(replace(t1.tradingassets,chr(13),''),chr(10),'') as tradingassets --交易资产
,replace(replace(t1.loanhandlechannel,chr(13),''),chr(10),'') as loanhandlechannel --贷款办理渠道
,replace(replace(t1.thirdparty1type,chr(13),''),chr(10),'') as thirdparty1type --代付类型
,replace(replace(t1.otherarealoan,chr(13),''),chr(10),'') as otherarealoan --是否异地业务
,replace(replace(t1.realestateloantype,chr(13),''),chr(10),'') as realestateloantype --房地产贷款类型
,t1.proposerpaymentscale as proposerpaymentscale --贴现利息申请人支付比例(%)
,t1.xmztz as xmztz --项目总投资
,replace(replace(t1.sfgjxzhy,chr(13),''),chr(10),'') as sfgjxzhy --是否国家限制行业
,replace(replace(t1.tdstrenth,chr(13),''),chr(10),'') as tdstrenth --交易对手实力
,replace(replace(t1.locfinancefundsource,chr(13),''),chr(10),'') as locfinancefundsource --地方融资平台偿债资金来源分类
,replace(replace(t1.importantloan,chr(13),''),chr(10),'') as importantloan --重点贷款项目
,replace(replace(t1.duepaymethod,chr(13),''),chr(10),'') as duepaymethod --应收帐款预付方式
,replace(replace(t1.drawingtype,chr(13),''),chr(10),'') as drawingtype --提款方式
,t1.start_dt as start_dt --开始日期
,t1.end_dt as end_dt --结束日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --删除标识
,replace(replace(t1.careerguaranteeloantype,chr(13),''),chr(10),'') as careerguaranteeloantype --创业担保贷款类型
,replace(replace(t1.farmingloanuse,chr(13),''),chr(10),'') as farmingloanuse --涉农贷款投向
,replace(replace(t1.iscareerguaranteeloan,chr(13),''),chr(10),'') as iscareerguaranteeloan --是否创业担保贷款
,replace(replace(t1.platformpaycashsource,chr(13),''),chr(10),'') as platformpaycashsource --地方融资平台偿债资金来源分类
,replace(replace(t1.farmingloantype,chr(13),''),chr(10),'') as farmingloantype --涉农贷款主体类型
,replace(replace(t1.isforeign,chr(13),''),chr(10),'') as isforeign --是否境外贷款
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --
,replace(replace(t1.guaranteehprojecttype,chr(13),''),chr(10),'') as guaranteehprojecttype --保障性安居工程贷款类型LoanPurposeType
,replace(replace(t1.landuseno,chr(13),''),chr(10),'') as landuseno --土地使用证编号
,t1.landusedate as landusedate --土地使用证日期
,replace(replace(t1.landplanpermitno,chr(13),''),chr(10),'') as landplanpermitno --用地规划许可证编号
,t1.landplanpermitdate as landplanpermitdate --用地规划许可证日期
,t1.constructpermitdate as constructpermitdate --施工许可证日期
,t1.projectplanpermitdate as projectplanpermitdate --工程规划许可证日期
,replace(replace(t1.buyername,chr(13),''),chr(10),'') as buyername --购货方名称
,replace(replace(t1.sellername,chr(13),''),chr(10),'') as sellername --销货方名称
,replace(replace(t1.tradetransactioncontent,chr(13),''),chr(10),'') as tradetransactioncontent --贸易交易内容
from ${iol_schema}.icms_bc_extend_d t1    --对公传统信贷业务合同个性化信息
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_bc_extend_d',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
