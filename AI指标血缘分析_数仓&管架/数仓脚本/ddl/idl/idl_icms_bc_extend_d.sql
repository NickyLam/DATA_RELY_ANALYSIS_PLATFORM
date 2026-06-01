/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_bc_extend_d
CreateDate: 20221109
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icms_bc_extend_d purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icms_bc_extend_d(
etl_dt date --ETL处理日期
,serialno varchar2(32) --合同编号
,tradesum number(24,6) --贸易合同总金额(元)
,isrz varchar2(3) --是否融资合同
,creditattribute varchar2(5) --合同类型
,tradecontractno varchar2(32) --贸易合同号
,lctype varchar2(27) --信用证种类
,lcsum number(24,6) --信用证金额（元）
,lccurrency varchar2(3) --信用证币种
,lcno varchar2(32) --信用证编号
,thirdpartyaccounts varchar2(32) --提单号码
,pwwh varchar2(200) --批文文号
,lxpw varchar2(300) --立项批文
,lcopertype varchar2(27) --信用证类型
,lccdflag varchar2(18) --远期信用证是否已承兑
,lctermtype varchar2(27) --信用证期限类型
,lcquality varchar2(27) --信用证性质
,destination1 varchar2(150) --装运地
,oldlcloadingdate varchar2(10) --装运日期
,graceperiod number(22) --远期付款期限(天)
,costpersontype varchar2(120) --费用承担人
,mfeeratio number(10,6) --其他费率(‰)
,rateexplain varchar2(600) --利率/费率说明
,cargoinfo varchar2(120) --货物名称
,totalcast number(24,6) --货物标的
,destination2 varchar2(150) --货物运输目的地
,oldlcno varchar2(32) --母证编号
,oldlccurrency varchar2(27) --母证币种
,oldlcsum number(24,6) --母证金额
,discountsum number(24,6) --应收帐款净额(元)
,zfsxlx varchar2(12) --政府授信类型
,contextinfo varchar2(600) --交易背景描述
,ifgudingcredit varchar2(1) --是否固定资产授信
,moneytype varchar2(27) --委托存款钞汇类别
,restbalancesum number(10,6) --打包成数(%)
,guarantytype varchar2(18) --担保/操作模式(担保切分必选项)
,othercondition varchar2(4000) --其他条件和要求
,mandatesource varchar2(3) --委托贷款资金来源
,isyfconfirmed varchar2(27) --是否经议付行确认
,purchaserpayintratio number(10,6) --贴现利息买方承担比例(%)
,ifqueryflag varchar2(3) --是否先贴后查
,iscounterparty varchar2(1) --是否合格中央交易对手
,bailaccount varchar2(32) --保证金帐号
,bailcurrency varchar2(27) --保证金币种
,bailtransaccount varchar2(40) --保证金转出帐号
,guarantybailaccount varchar2(32) --押品转保证金账号
,interestrate number(24,6) --保证金协议利率
,fxfltp varchar2(96) --保证金利率类型
,pdrifv varchar2(96) --保证金浮动值
,pdrifd varchar2(96) --保证金利率浮动类型
,pdrifm varchar2(96) --保证金利率浮动方式
,interestmethod varchar2(96) --保证金计息方法
,termcd varchar2(64) --保证金利率档次
,mandatecustname varchar2(300) --委托人
,repayremark varchar2(600) --还款说明
,ventureguarantytype varchar2(5) --创业担保贷款类型
,isconsumerfinance varchar2(1) --是否为消费服务类融资
,lcpaymethod varchar2(27) --付款方式
,drawingremark varchar2(600) --提款说明
,loantraderatio number(10,6) --贷款金额占交易价款比例(%)
,mainproduct varchar2(48) --经营商品（贸易融资）
,billnum number(22) --汇票数量(张)
,discountdrafttype varchar2(150) --贴现的商业承兑汇票类别
,businessinvoiceinfo varchar2(100) --商业发票号码
,businessinvoicetype varchar2(90) --商业发票种类
,businessinvoicecurrency varchar2(3) --商业发票币种
,businessinvoicesum number(20,2) --商业发票金额
,qtxkzbh varchar2(1000) --其他许可证编号
,qtxkz varchar2(225) --其他许可证
,hpxkzbh varchar2(1000) --环评许可证编号
,jsydxkzbh varchar2(1000) --建设用地许可证编号
,ghxkzbh varchar2(1000) --规划许可证编号
,sgxkzbh varchar2(1000) --施工许可证编号
,corpuspaymethod varchar2(27) --还款方式
,toindustryfund varchar2(1) --是否投向产业基金
,consignmentloandirect varchar2(8) --委托贷款特殊投向
,isventureguaranty varchar2(5) --是否创业担保贷款
,securitiestype varchar2(27) --运输方式
,mandatedepacctno varchar2(75) --委托存款帐户
,bondno varchar2(150) --标的产品编号
,productcollectmoney number(20,4) --产品募集金额
,productlevel number(20) --产品分级级别
,gshy varchar2(12) --过剩行业
,purchaserregion varchar2(27) --买方所在地区
,isfarming varchar2(1) --是否涉农
,rivalname varchar2(200) --交易对手名称
,farmingloandirect varchar2(5) --涉农贷款投向
,businessprop number(10,6) --放款成数(%)
,registerinotherbank varchar2(1) --是否他行代开
,zbj number(18,2) --资本金
,consigneename varchar2(120) --管理人/主承销商
,consigneecerttype varchar2(30) --管理人/主承销商证件类型
,consigneecertid varchar2(40) --管理人/主承销商证件号码
,useproduct varchar2(48) --使用产品（贸易融资）
,beneficiarycountryname varchar2(300) --受益人所在国家或地区
,purchasername varchar2(300) --买方名称
,farmingsubjecttype varchar2(5) --涉农贷款主体类型
,lcapplyserialno varchar2(48) --开证申请书编号
,mandatecustid varchar2(300) --委托人客户
,isimportantloan varchar2(12) --是否重点项目贷款
,discountratenote varchar2(3000) --贴现利率说明
,factoringtype varchar2(27) --保理类型
,ifagreementflag varchar2(3) --是否协议付息
,kgrq varchar2(10) --开工日期
,sfgksx varchar2(1) --是否国开行授信
,offerbilldate varchar2(10) --提供单据日期
,financier varchar2(300) --实际融资人
,discountcusttype varchar2(150) --贴现申请人种类
,isgovernfinance varchar2(1) --是否涉及政府类融资
,financesupportmode varchar2(48) --贷款财政扶持方式
,issjorcs varchar2(3) --是否三旧改造或城市更新项目
,yffdkje number(18,2) --银团已发放贷款金额(元)
,fundsource varchar2(27) --资金来源
,zfsxfs varchar2(12) --政府授信支持方式
,directionrs varchar2(27) --行业投向(征信)
,classifyfrequency number(22) --检查频率
,supplychainfinancetype varchar2(12) --供应链金融业务产品分类
,projectartificialno varchar2(64) --项目信息文本号
,hasoutradio varchar2(3) --是否存在溢短装的条款
,beneficiaryname varchar2(300) --受益人名称
,tradecurrency varchar2(27) --委托存款币种
,isyfreceive varchar2(27) --是否预付应收帐款
,acceptbankname varchar2(300) --承兑行名称
,tdyears varchar2(30) --与交易对手合作年限
,putoutorgid varchar2(48) --放贷机构
,gksxpz varchar2(12) --国开授信品种
,loantradesum number(24,6) --贷款用途交易金额
,sfzfsx varchar2(1) --是否政府授信
,isdebttoequity varchar2(1) --是否投向市场化债转股
,creditincrementtype varchar2(3) --主要增信方式
,outradio number(24,6) --溢短装比例（%）
,loanquality varchar2(6) --贷款性质
,issupplychainfinance varchar2(1) --是否为供应链金融业务
,noticebankname varchar2(300) --通知行
,tdtimes varchar2(30) --与交易对手成功交易次数
,paymentname varchar2(120) --付息方
,tradingassets varchar2(150) --交易资产
,loanhandlechannel varchar2(30) --贷款办理渠道
,thirdparty1type varchar2(15) --代付类型
,otherarealoan varchar2(27) --是否异地业务
,realestateloantype varchar2(15) --房地产贷款类型
,proposerpaymentscale number(10,6) --贴现利息申请人支付比例(%)
,xmztz number(18,2) --项目总投资
,sfgjxzhy varchar2(1) --是否国家限制行业
,tdstrenth varchar2(30) --交易对手实力
,locfinancefundsource varchar2(5) --地方融资平台偿债资金来源分类
,importantloan varchar2(12) --重点贷款项目
,duepaymethod varchar2(27) --应收帐款预付方式
,drawingtype varchar2(27) --提款方式
,start_dt date --开始日期
,end_dt date --结束日期
,id_mark varchar2(10) --删除标识
,careerguaranteeloantype varchar2(27) --创业担保贷款类型
,farmingloanuse varchar2(27) --涉农贷款投向
,iscareerguaranteeloan varchar2(27) --是否创业担保贷款
,platformpaycashsource varchar2(27) --地方融资平台偿债资金来源分类
,farmingloantype varchar2(27) --涉农贷款主体类型
,isforeign varchar2(6) --是否境外贷款
,migtflag varchar2(120) --迁移标志：crs rcr ilc upl
,guaranteehprojecttype varchar2(5) --保障性安居工程贷款类型LoanPurposeType
,landuseno varchar2(1000) --土地使用证编号
,landusedate date --土地使用证日期
,landplanpermitno varchar2(1000) --用地规划许可证编号
,landplanpermitdate date --用地规划许可证日期
,constructpermitdate date --施工许可证日期
,projectplanpermitdate date --工程规划许可证日期
,buyername varchar2(900) --购货方名称
,sellername varchar2(900) --销货方名称
,tradetransactioncontent varchar2(4000) --贸易交易内容

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icms_bc_extend_d to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_bc_extend_d is '对公传统信贷业务合同个性化信息';
comment on column ${idl_schema}.icms_bc_extend_d.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.icms_bc_extend_d.serialno is '合同编号';
comment on column ${idl_schema}.icms_bc_extend_d.tradesum is '贸易合同总金额(元)';
comment on column ${idl_schema}.icms_bc_extend_d.isrz is '是否融资合同';
comment on column ${idl_schema}.icms_bc_extend_d.creditattribute is '合同类型';
comment on column ${idl_schema}.icms_bc_extend_d.tradecontractno is '贸易合同号';
comment on column ${idl_schema}.icms_bc_extend_d.lctype is '信用证种类';
comment on column ${idl_schema}.icms_bc_extend_d.lcsum is '信用证金额（元）';
comment on column ${idl_schema}.icms_bc_extend_d.lccurrency is '信用证币种';
comment on column ${idl_schema}.icms_bc_extend_d.lcno is '信用证编号';
comment on column ${idl_schema}.icms_bc_extend_d.thirdpartyaccounts is '提单号码';
comment on column ${idl_schema}.icms_bc_extend_d.pwwh is '批文文号';
comment on column ${idl_schema}.icms_bc_extend_d.lxpw is '立项批文';
comment on column ${idl_schema}.icms_bc_extend_d.lcopertype is '信用证类型';
comment on column ${idl_schema}.icms_bc_extend_d.lccdflag is '远期信用证是否已承兑';
comment on column ${idl_schema}.icms_bc_extend_d.lctermtype is '信用证期限类型';
comment on column ${idl_schema}.icms_bc_extend_d.lcquality is '信用证性质';
comment on column ${idl_schema}.icms_bc_extend_d.destination1 is '装运地';
comment on column ${idl_schema}.icms_bc_extend_d.oldlcloadingdate is '装运日期';
comment on column ${idl_schema}.icms_bc_extend_d.graceperiod is '远期付款期限(天)';
comment on column ${idl_schema}.icms_bc_extend_d.costpersontype is '费用承担人';
comment on column ${idl_schema}.icms_bc_extend_d.mfeeratio is '其他费率(‰)';
comment on column ${idl_schema}.icms_bc_extend_d.rateexplain is '利率/费率说明';
comment on column ${idl_schema}.icms_bc_extend_d.cargoinfo is '货物名称';
comment on column ${idl_schema}.icms_bc_extend_d.totalcast is '货物标的';
comment on column ${idl_schema}.icms_bc_extend_d.destination2 is '货物运输目的地';
comment on column ${idl_schema}.icms_bc_extend_d.oldlcno is '母证编号';
comment on column ${idl_schema}.icms_bc_extend_d.oldlccurrency is '母证币种';
comment on column ${idl_schema}.icms_bc_extend_d.oldlcsum is '母证金额';
comment on column ${idl_schema}.icms_bc_extend_d.discountsum is '应收帐款净额(元)';
comment on column ${idl_schema}.icms_bc_extend_d.zfsxlx is '政府授信类型';
comment on column ${idl_schema}.icms_bc_extend_d.contextinfo is '交易背景描述';
comment on column ${idl_schema}.icms_bc_extend_d.ifgudingcredit is '是否固定资产授信';
comment on column ${idl_schema}.icms_bc_extend_d.moneytype is '委托存款钞汇类别';
comment on column ${idl_schema}.icms_bc_extend_d.restbalancesum is '打包成数(%)';
comment on column ${idl_schema}.icms_bc_extend_d.guarantytype is '担保/操作模式(担保切分必选项)';
comment on column ${idl_schema}.icms_bc_extend_d.othercondition is '其他条件和要求';
comment on column ${idl_schema}.icms_bc_extend_d.mandatesource is '委托贷款资金来源';
comment on column ${idl_schema}.icms_bc_extend_d.isyfconfirmed is '是否经议付行确认';
comment on column ${idl_schema}.icms_bc_extend_d.purchaserpayintratio is '贴现利息买方承担比例(%)';
comment on column ${idl_schema}.icms_bc_extend_d.ifqueryflag is '是否先贴后查';
comment on column ${idl_schema}.icms_bc_extend_d.iscounterparty is '是否合格中央交易对手';
comment on column ${idl_schema}.icms_bc_extend_d.bailaccount is '保证金帐号';
comment on column ${idl_schema}.icms_bc_extend_d.bailcurrency is '保证金币种';
comment on column ${idl_schema}.icms_bc_extend_d.bailtransaccount is '保证金转出帐号';
comment on column ${idl_schema}.icms_bc_extend_d.guarantybailaccount is '押品转保证金账号';
comment on column ${idl_schema}.icms_bc_extend_d.interestrate is '保证金协议利率';
comment on column ${idl_schema}.icms_bc_extend_d.fxfltp is '保证金利率类型';
comment on column ${idl_schema}.icms_bc_extend_d.pdrifv is '保证金浮动值';
comment on column ${idl_schema}.icms_bc_extend_d.pdrifd is '保证金利率浮动类型';
comment on column ${idl_schema}.icms_bc_extend_d.pdrifm is '保证金利率浮动方式';
comment on column ${idl_schema}.icms_bc_extend_d.interestmethod is '保证金计息方法';
comment on column ${idl_schema}.icms_bc_extend_d.termcd is '保证金利率档次';
comment on column ${idl_schema}.icms_bc_extend_d.mandatecustname is '委托人';
comment on column ${idl_schema}.icms_bc_extend_d.repayremark is '还款说明';
comment on column ${idl_schema}.icms_bc_extend_d.ventureguarantytype is '创业担保贷款类型';
comment on column ${idl_schema}.icms_bc_extend_d.isconsumerfinance is '是否为消费服务类融资';
comment on column ${idl_schema}.icms_bc_extend_d.lcpaymethod is '付款方式';
comment on column ${idl_schema}.icms_bc_extend_d.drawingremark is '提款说明';
comment on column ${idl_schema}.icms_bc_extend_d.loantraderatio is '贷款金额占交易价款比例(%)';
comment on column ${idl_schema}.icms_bc_extend_d.mainproduct is '经营商品（贸易融资）';
comment on column ${idl_schema}.icms_bc_extend_d.billnum is '汇票数量(张)';
comment on column ${idl_schema}.icms_bc_extend_d.discountdrafttype is '贴现的商业承兑汇票类别';
comment on column ${idl_schema}.icms_bc_extend_d.businessinvoiceinfo is '商业发票号码';
comment on column ${idl_schema}.icms_bc_extend_d.businessinvoicetype is '商业发票种类';
comment on column ${idl_schema}.icms_bc_extend_d.businessinvoicecurrency is '商业发票币种';
comment on column ${idl_schema}.icms_bc_extend_d.businessinvoicesum is '商业发票金额';
comment on column ${idl_schema}.icms_bc_extend_d.qtxkzbh is '其他许可证编号';
comment on column ${idl_schema}.icms_bc_extend_d.qtxkz is '其他许可证';
comment on column ${idl_schema}.icms_bc_extend_d.hpxkzbh is '环评许可证编号';
comment on column ${idl_schema}.icms_bc_extend_d.jsydxkzbh is '建设用地许可证编号';
comment on column ${idl_schema}.icms_bc_extend_d.ghxkzbh is '规划许可证编号';
comment on column ${idl_schema}.icms_bc_extend_d.sgxkzbh is '施工许可证编号';
comment on column ${idl_schema}.icms_bc_extend_d.corpuspaymethod is '还款方式';
comment on column ${idl_schema}.icms_bc_extend_d.toindustryfund is '是否投向产业基金';
comment on column ${idl_schema}.icms_bc_extend_d.consignmentloandirect is '委托贷款特殊投向';
comment on column ${idl_schema}.icms_bc_extend_d.isventureguaranty is '是否创业担保贷款';
comment on column ${idl_schema}.icms_bc_extend_d.securitiestype is '运输方式';
comment on column ${idl_schema}.icms_bc_extend_d.mandatedepacctno is '委托存款帐户';
comment on column ${idl_schema}.icms_bc_extend_d.bondno is '标的产品编号';
comment on column ${idl_schema}.icms_bc_extend_d.productcollectmoney is '产品募集金额';
comment on column ${idl_schema}.icms_bc_extend_d.productlevel is '产品分级级别';
comment on column ${idl_schema}.icms_bc_extend_d.gshy is '过剩行业';
comment on column ${idl_schema}.icms_bc_extend_d.purchaserregion is '买方所在地区';
comment on column ${idl_schema}.icms_bc_extend_d.isfarming is '是否涉农';
comment on column ${idl_schema}.icms_bc_extend_d.rivalname is '交易对手名称';
comment on column ${idl_schema}.icms_bc_extend_d.farmingloandirect is '涉农贷款投向';
comment on column ${idl_schema}.icms_bc_extend_d.businessprop is '放款成数(%)';
comment on column ${idl_schema}.icms_bc_extend_d.registerinotherbank is '是否他行代开';
comment on column ${idl_schema}.icms_bc_extend_d.zbj is '资本金';
comment on column ${idl_schema}.icms_bc_extend_d.consigneename is '管理人/主承销商';
comment on column ${idl_schema}.icms_bc_extend_d.consigneecerttype is '管理人/主承销商证件类型';
comment on column ${idl_schema}.icms_bc_extend_d.consigneecertid is '管理人/主承销商证件号码';
comment on column ${idl_schema}.icms_bc_extend_d.useproduct is '使用产品（贸易融资）';
comment on column ${idl_schema}.icms_bc_extend_d.beneficiarycountryname is '受益人所在国家或地区';
comment on column ${idl_schema}.icms_bc_extend_d.purchasername is '买方名称';
comment on column ${idl_schema}.icms_bc_extend_d.farmingsubjecttype is '涉农贷款主体类型';
comment on column ${idl_schema}.icms_bc_extend_d.lcapplyserialno is '开证申请书编号';
comment on column ${idl_schema}.icms_bc_extend_d.mandatecustid is '委托人客户';
comment on column ${idl_schema}.icms_bc_extend_d.isimportantloan is '是否重点项目贷款';
comment on column ${idl_schema}.icms_bc_extend_d.discountratenote is '贴现利率说明';
comment on column ${idl_schema}.icms_bc_extend_d.factoringtype is '保理类型';
comment on column ${idl_schema}.icms_bc_extend_d.ifagreementflag is '是否协议付息';
comment on column ${idl_schema}.icms_bc_extend_d.kgrq is '开工日期';
comment on column ${idl_schema}.icms_bc_extend_d.sfgksx is '是否国开行授信';
comment on column ${idl_schema}.icms_bc_extend_d.offerbilldate is '提供单据日期';
comment on column ${idl_schema}.icms_bc_extend_d.financier is '实际融资人';
comment on column ${idl_schema}.icms_bc_extend_d.discountcusttype is '贴现申请人种类';
comment on column ${idl_schema}.icms_bc_extend_d.isgovernfinance is '是否涉及政府类融资';
comment on column ${idl_schema}.icms_bc_extend_d.financesupportmode is '贷款财政扶持方式';
comment on column ${idl_schema}.icms_bc_extend_d.issjorcs is '是否三旧改造或城市更新项目';
comment on column ${idl_schema}.icms_bc_extend_d.yffdkje is '银团已发放贷款金额(元)';
comment on column ${idl_schema}.icms_bc_extend_d.fundsource is '资金来源';
comment on column ${idl_schema}.icms_bc_extend_d.zfsxfs is '政府授信支持方式';
comment on column ${idl_schema}.icms_bc_extend_d.directionrs is '行业投向(征信)';
comment on column ${idl_schema}.icms_bc_extend_d.classifyfrequency is '检查频率';
comment on column ${idl_schema}.icms_bc_extend_d.supplychainfinancetype is '供应链金融业务产品分类';
comment on column ${idl_schema}.icms_bc_extend_d.projectartificialno is '项目信息文本号';
comment on column ${idl_schema}.icms_bc_extend_d.hasoutradio is '是否存在溢短装的条款';
comment on column ${idl_schema}.icms_bc_extend_d.beneficiaryname is '受益人名称';
comment on column ${idl_schema}.icms_bc_extend_d.tradecurrency is '委托存款币种';
comment on column ${idl_schema}.icms_bc_extend_d.isyfreceive is '是否预付应收帐款';
comment on column ${idl_schema}.icms_bc_extend_d.acceptbankname is '承兑行名称';
comment on column ${idl_schema}.icms_bc_extend_d.tdyears is '与交易对手合作年限';
comment on column ${idl_schema}.icms_bc_extend_d.putoutorgid is '放贷机构';
comment on column ${idl_schema}.icms_bc_extend_d.gksxpz is '国开授信品种';
comment on column ${idl_schema}.icms_bc_extend_d.loantradesum is '贷款用途交易金额';
comment on column ${idl_schema}.icms_bc_extend_d.sfzfsx is '是否政府授信';
comment on column ${idl_schema}.icms_bc_extend_d.isdebttoequity is '是否投向市场化债转股';
comment on column ${idl_schema}.icms_bc_extend_d.creditincrementtype is '主要增信方式';
comment on column ${idl_schema}.icms_bc_extend_d.outradio is '溢短装比例（%）';
comment on column ${idl_schema}.icms_bc_extend_d.loanquality is '贷款性质';
comment on column ${idl_schema}.icms_bc_extend_d.issupplychainfinance is '是否为供应链金融业务';
comment on column ${idl_schema}.icms_bc_extend_d.noticebankname is '通知行';
comment on column ${idl_schema}.icms_bc_extend_d.tdtimes is '与交易对手成功交易次数';
comment on column ${idl_schema}.icms_bc_extend_d.paymentname is '付息方';
comment on column ${idl_schema}.icms_bc_extend_d.tradingassets is '交易资产';
comment on column ${idl_schema}.icms_bc_extend_d.loanhandlechannel is '贷款办理渠道';
comment on column ${idl_schema}.icms_bc_extend_d.thirdparty1type is '代付类型';
comment on column ${idl_schema}.icms_bc_extend_d.otherarealoan is '是否异地业务';
comment on column ${idl_schema}.icms_bc_extend_d.realestateloantype is '房地产贷款类型';
comment on column ${idl_schema}.icms_bc_extend_d.proposerpaymentscale is '贴现利息申请人支付比例(%)';
comment on column ${idl_schema}.icms_bc_extend_d.xmztz is '项目总投资';
comment on column ${idl_schema}.icms_bc_extend_d.sfgjxzhy is '是否国家限制行业';
comment on column ${idl_schema}.icms_bc_extend_d.tdstrenth is '交易对手实力';
comment on column ${idl_schema}.icms_bc_extend_d.locfinancefundsource is '地方融资平台偿债资金来源分类';
comment on column ${idl_schema}.icms_bc_extend_d.importantloan is '重点贷款项目';
comment on column ${idl_schema}.icms_bc_extend_d.duepaymethod is '应收帐款预付方式';
comment on column ${idl_schema}.icms_bc_extend_d.drawingtype is '提款方式';
comment on column ${idl_schema}.icms_bc_extend_d.start_dt is '开始日期';
comment on column ${idl_schema}.icms_bc_extend_d.end_dt is '结束日期';
comment on column ${idl_schema}.icms_bc_extend_d.id_mark is '删除标识';
comment on column ${idl_schema}.icms_bc_extend_d.careerguaranteeloantype is '创业担保贷款类型';
comment on column ${idl_schema}.icms_bc_extend_d.farmingloanuse is '涉农贷款投向';
comment on column ${idl_schema}.icms_bc_extend_d.iscareerguaranteeloan is '是否创业担保贷款';
comment on column ${idl_schema}.icms_bc_extend_d.platformpaycashsource is '地方融资平台偿债资金来源分类';
comment on column ${idl_schema}.icms_bc_extend_d.farmingloantype is '涉农贷款主体类型';
comment on column ${idl_schema}.icms_bc_extend_d.isforeign is '是否境外贷款';
comment on column ${idl_schema}.icms_bc_extend_d.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${idl_schema}.icms_bc_extend_d.guaranteehprojecttype is '保障性安居工程贷款类型LoanPurposeType';
comment on column ${idl_schema}.icms_bc_extend_d.landuseno is '土地使用证编号';
comment on column ${idl_schema}.icms_bc_extend_d.landusedate is '土地使用证日期';
comment on column ${idl_schema}.icms_bc_extend_d.landplanpermitno is '用地规划许可证编号';
comment on column ${idl_schema}.icms_bc_extend_d.landplanpermitdate is '用地规划许可证日期';
comment on column ${idl_schema}.icms_bc_extend_d.constructpermitdate is '施工许可证日期';
comment on column ${idl_schema}.icms_bc_extend_d.projectplanpermitdate is '工程规划许可证日期';
comment on column ${idl_schema}.icms_bc_extend_d.buyername is '购货方名称';
comment on column ${idl_schema}.icms_bc_extend_d.sellername is '销货方名称';
comment on column ${idl_schema}.icms_bc_extend_d.tradetransactioncontent is '贸易交易内容';

