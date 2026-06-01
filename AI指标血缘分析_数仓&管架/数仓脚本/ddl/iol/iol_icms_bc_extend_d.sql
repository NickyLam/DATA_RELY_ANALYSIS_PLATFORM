/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bc_extend_d
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bc_extend_d
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bc_extend_d purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bc_extend_d(
    serialno varchar2(32) -- 合同编号
    ,locfinancefundsource varchar2(3) -- 地方融资平台偿债资金来源分类
    ,projectartificialno varchar2(64) -- 项目信息文本号
    ,creditincrementtype varchar2(2) -- 主要增信方式
    ,isforeign varchar2(4) -- 是否境外贷款
    ,isyfconfirmed varchar2(18) -- 是否经议付行确认
    ,isventureguaranty varchar2(3) -- 是否创业担保贷款
    ,ventureguarantytype varchar2(3) -- 创业担保贷款类型
    ,rateexplain varchar2(400) -- 利率/费率说明
    ,lctermtype varchar2(18) -- 信用证期限类型
    ,qtxkzbh varchar2(1000) -- 其他许可证编号
    ,graceperiod number(22) -- 远期付款期限(天)
    ,lcopertype varchar2(18) -- 信用证类型
    ,rivalname varchar2(200) -- 交易对手名称
    ,outradio number(24,6) -- 溢短装比例（%）
    ,tradesum number(24,6) -- 贸易合同总金额(元)
    ,careerguaranteeloantype varchar2(18) -- 创业担保贷款类型
    ,proposerpaymentscale number(10,6) -- 贴现利息申请人支付比例(%)
    ,putoutorgid varchar2(32) -- 放贷机构
    ,farmingloanuse varchar2(18) -- 涉农贷款投向
    ,oldlccurrency varchar2(18) -- 母证币种
    ,tradecurrency varchar2(18) -- 委托存款币种
    ,totalcast number(24,6) -- 货物标的
    ,zfsxlx varchar2(8) -- 政府授信类型
    ,xmztz number(18,2) -- 项目总投资
    ,ghxkzbh varchar2(1000) -- 规划许可证编号
    ,discountratenote varchar2(2000) -- 贴现利率说明
    ,ifqueryflag varchar2(2) -- 是否先贴后查
    ,yffdkje number(18,2) -- 银团已发放贷款金额(元)
    ,billnum number(22) -- 汇票数量(张)
    ,lccurrency varchar2(3) -- 信用证币种
    ,loanhandlechannel varchar2(20) -- 贷款办理渠道
    ,mainproduct varchar2(32) -- 经营商品（贸易融资）
    ,repayremark varchar2(400) -- 还款说明
    ,iscounterparty varchar2(1) -- 是否合格中央交易对手
    ,consigneecerttype varchar2(20) -- 管理人/主承销商证件类型
    ,hasoutradio varchar2(2) -- 是否存在溢短装的条款
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,mandatedepacctno varchar2(50) -- 委托存款帐户
    ,productcollectmoney number(20,4) -- 产品募集金额
    ,thirdpartyaccounts varchar2(32) -- 提单号码
    ,beneficiaryname varchar2(200) -- 受益人名称
    ,oldlcno varchar2(32) -- 母证编号
    ,guarantybailaccount varchar2(32) -- 押品转保证金账号
    ,businessinvoicesum number(20,2) -- 商业发票金额
    ,importantloan varchar2(8) -- 重点贷款项目
    ,hpxkzbh varchar2(1000) -- 环评许可证编号
    ,discountsum number(24,6) -- 应收帐款净额(元)
    ,classifyfrequency number(22) -- 检查频率
    ,contextinfo varchar2(400) -- 交易背景描述
    ,purchaserpayintratio number(10,6) -- 贴现利息买方承担比例(%)
    ,thirdparty1type varchar2(10) -- 代付类型
    ,sfgksx varchar2(1) -- 是否国开行授信
    ,consigneename varchar2(80) -- 管理人/主承销商
    ,consigneecertid varchar2(40) -- 管理人/主承销商证件号码
    ,registerinotherbank varchar2(1) -- 是否他行代开
    ,securitiestype varchar2(18) -- 运输方式
    ,termcd varchar2(64) -- 保证金利率档次
    ,tradecontractno varchar2(32) -- 贸易合同号
    ,sfgjxzhy varchar2(1) -- 是否国家限制行业
    ,isconsumerfinance varchar2(1) -- 是否为消费服务类融资
    ,oldlcsum number(24,6) -- 母证金额
    ,bailaccount varchar2(32) -- 保证金帐号
    ,loanquality varchar2(4) -- 贷款性质
    ,interestrate number(24,6) -- 保证金协议利率
    ,zfsxfs varchar2(8) -- 政府授信支持方式
    ,lcsum number(24,6) -- 信用证金额（元）
    ,businessinvoicetype varchar2(60) -- 商业发票种类
    ,useproduct varchar2(32) -- 使用产品（贸易融资）
    ,issupplychainfinance varchar2(1) -- 是否为供应链金融业务
    ,fxfltp varchar2(64) -- 保证金利率类型
    ,supplychainfinancetype varchar2(8) -- 供应链金融业务产品分类
    ,tdtimes varchar2(20) -- 与交易对手成功交易次数
    ,otherarealoan varchar2(18) -- 是否异地业务
    ,purchaserregion varchar2(18) -- 买方所在地区
    ,mandatecustname varchar2(200) -- 委托人
    ,ifagreementflag varchar2(2) -- 是否协议付息
    ,iscareerguaranteeloan varchar2(18) -- 是否创业担保贷款
    ,beneficiarycountryname varchar2(200) -- 受益人所在国家或地区
    ,cargoinfo varchar2(80) -- 货物名称
    ,ifgudingcredit varchar2(1) -- 是否固定资产授信
    ,qtxkz varchar2(150) -- 其他许可证
    ,othercondition varchar2(4000) -- 其他条件和要求
    ,interestmethod varchar2(64) -- 保证金计息方法
    ,isfarming varchar2(1) -- 是否涉农
    ,destination1 varchar2(100) -- 装运地
    ,costpersontype varchar2(80) -- 费用承担人
    ,gksxpz varchar2(8) -- 国开授信品种
    ,zbj number(18,2) -- 资本金
    ,lxpw varchar2(200) -- 立项批文
    ,bailtransaccount varchar2(40) -- 保证金转出帐号
    ,restbalancesum number(10,6) -- 打包成数(%)
    ,businessinvoicecurrency varchar2(3) -- 商业发票币种
    ,drawingtype varchar2(18) -- 提款方式
    ,platformpaycashsource varchar2(18) -- 地方融资平台偿债资金来源分类
    ,lcpaymethod varchar2(18) -- 付款方式
    ,discountcusttype varchar2(100) -- 贴现申请人种类
    ,loantradesum number(24,6) -- 贷款用途交易金额
    ,pdrifd varchar2(64) -- 保证金利率浮动类型
    ,lcno varchar2(32) -- 信用证编号
    ,drawingremark varchar2(400) -- 提款说明
    ,moneytype varchar2(18) -- 委托存款钞汇类别
    ,sfzfsx varchar2(1) -- 是否政府授信
    ,toindustryfund varchar2(1) -- 是否投向产业基金
    ,isgovernfinance varchar2(1) -- 是否涉及政府类融资
    ,farmingloandirect varchar2(3) -- 涉农贷款投向
    ,tdstrenth varchar2(20) -- 交易对手实力
    ,paymentname varchar2(80) -- 付息方
    ,mandatesource varchar2(2) -- 委托贷款资金来源
    ,purchasername varchar2(200) -- 买方名称
    ,productlevel number(20,0) -- 产品分级级别
    ,kgrq varchar2(10) -- 开工日期
    ,noticebankname varchar2(200) -- 通知行
    ,directionrs varchar2(18) -- 行业投向(征信)
    ,gshy varchar2(8) -- 过剩行业
    ,lcquality varchar2(18) -- 信用证性质
    ,offerbilldate varchar2(10) -- 提供单据日期
    ,financesupportmode varchar2(32) -- 贷款财政扶持方式
    ,pwwh varchar2(200) -- 批文文号
    ,realestateloantype varchar2(10) -- 房地产贷款类型
    ,isyfreceive varchar2(18) -- 是否预付应收帐款
    ,corpuspaymethod varchar2(18) -- 还款方式
    ,mfeeratio number(10,6) -- 其他费率(‰)
    ,acceptbankname varchar2(200) -- 承兑行名称
    ,businessinvoiceinfo varchar2(100) -- 商业发票号码
    ,jsydxkzbh varchar2(1000) -- 建设用地许可证编号
    ,mandatecustid varchar2(200) -- 委托人客户
    ,oldlcloadingdate varchar2(10) -- 装运日期
    ,isrz varchar2(2) -- 是否融资合同
    ,isimportantloan varchar2(8) -- 是否重点项目贷款
    ,tdyears varchar2(20) -- 与交易对手合作年限
    ,destination2 varchar2(100) -- 货物运输目的地
    ,farmingloantype varchar2(18) -- 涉农贷款主体类型
    ,pdrifm varchar2(64) -- 保证金利率浮动方式
    ,tradingassets varchar2(100) -- 交易资产
    ,farmingsubjecttype varchar2(3) -- 涉农贷款主体类型
    ,lccdflag varchar2(18) -- 远期信用证是否已承兑
    ,lcapplyserialno varchar2(48) -- 开证申请书编号
    ,issjorcs varchar2(2) -- 是否三旧改造或城市更新项目
    ,bailcurrency varchar2(18) -- 保证金币种
    ,duepaymethod varchar2(18) -- 应收帐款预付方式
    ,consignmentloandirect varchar2(5) -- 委托贷款特殊投向
    ,loantraderatio number(10,6) -- 贷款金额占交易价款比例(%)
    ,discountdrafttype varchar2(100) -- 贴现的商业承兑汇票类别
    ,creditattribute varchar2(3) -- 合同类型
    ,sgxkzbh varchar2(1000) -- 施工许可证编号
    ,guarantytype varchar2(12) -- 担保/操作模式(担保切分必选项)
    ,fundsource varchar2(18) -- 资金来源
    ,factoringtype varchar2(18) -- 保理类型
    ,pdrifv varchar2(64) -- 保证金浮动值
    ,bondno varchar2(150) -- 标的产品编号
    ,lctype varchar2(18) -- 信用证种类
    ,financier varchar2(200) -- 实际融资人
    ,businessprop number(10,6) -- 放款成数(%)
    ,isdebttoequity varchar2(1) -- 是否投向市场化债转股
    ,guaranteehprojecttype varchar2(3) -- 保障性安居工程贷款类型LoanPurposeType
    ,landuseno varchar2(1000) -- 土地使用证编号
    ,landusedate date -- 土地使用证日期
    ,landplanpermitno varchar2(1000) -- 用地规划许可证编号
    ,landplanpermitdate date -- 用地规划许可证日期
    ,constructpermitdate date -- 施工许可证日期
    ,projectplanpermitdate date -- 工程规划许可证日期
    ,buyername varchar2(600) -- 购货方名称
    ,sellername varchar2(600) -- 销货方名称
    ,tradetransactioncontent varchar2(3000) -- 贸易交易内容
    ,transferacc varchar2(1) -- 应收账款转让方式 码值:TransferBL
    ,isprojectfinancing varchar2(1) -- 是否项目融资
    ,jsydxkzrq date -- 建设用地许可证日期
    ,projectname varchar2(200) -- 项目名称
    ,advancedmanuflag varchar2(2) -- 先进制造业标志（0-否，1-是）
    ,cultureindustryflag varchar2(2) -- 文化产业标志（0-否，1-是）
    ,industrialrestructuringtype varchar2(4) -- 客户产业结构调整类型
    ,onlynewentflag varchar2(2) -- 专精特新中小企业标志（0-否，1-是）
    ,onlynewsmallentflag varchar2(2) -- 专精特新小巨人企业标志（0-否，1-是）
    ,strategicemergingindustrytype varchar2(4) -- 战略性新兴产业类型
    ,transformationandupgradeid varchar2(2) -- 工业企业技术改造升级标志（0-否，1-是）
    ,interestrepaycycle varchar2(18) -- 结息方式
    ,operationstartdate date -- 运营开始日期
    ,isoverssocipproj varchar2(4) -- 是否投向政府和社会资本合作（PPP）项目
    ,isnewmechissueloan varchar2(4) -- 是否新机制发放贷款
    ,iscoverdbbalance varchar2(2) -- 预测现金流是否覆盖借款余额
    ,isadvancedindustry varchar2(2) -- 是否高技术服务业贷款
    ,advancedindustryloantype varchar2(32) -- 高技术服务业贷款类型
    ,guarantybailsubaccount varchar2(5) -- 
    ,limitcoreent varchar2(64) -- 
    ,paymentaccount varchar2(64) -- 
    ,factoringcredittype varchar2(4) -- 
    ,belongitem varchar2(4) -- 
    ,lcsumrate number(15,8) -- 
    ,maxpdrifv number(11,7) -- 
    ,isguaranteeloan varchar2(4) -- 
    ,collectionnumbers varchar2(32) -- 
    ,remittancenumbers varchar2(32) -- 
    ,lcloanflag varchar2(32) -- 
    ,scanstatus varchar2(10) -- 
    ,discountrate number(15,8) -- 
    ,tradcontractno varchar2(200) -- 
    ,claimterm varchar2(200) -- 
    ,agentbankname varchar2(100) -- 
    ,agentbankno varchar2(100) -- 
    ,issuedbusinessno varchar2(100) -- 
    ,confirmbankname varchar2(200) -- 
    ,confirmbankid varchar2(100) -- 
    ,guaranteetype varchar2(10) -- 
    ,guaranteesum number(24,6) -- 
    ,finishterm number -- 
    ,proquestionupdatedate date -- 
    ,scanuserid varchar2(8) -- 
    ,scanusername varchar2(200) -- 
    ,bizuniqueno varchar2(200) -- 
    ,ratestartmode varchar2(1) -- 
    ,compoundintflag varchar2(1) -- 
    ,compoundintfloatvalue number(12,2) -- 
    ,compoundintratio number(15,8) -- 
    ,stopintflag varchar2(1) -- 
    ,tagcompleteflag varchar2(4) -- 
    ,capitalsourcebailtransaccount varchar2(128) -- 
    ,capitalsourcebailsum number(24,6) -- 
    ,capitalsourcebustype varchar2(32) -- 
    ,stoppayacct varchar2(128) -- 
    ,subacctnum varchar2(64) -- 
    ,depositsum number(24,6) -- 
    ,xztflag varchar2(32) -- 
    ,isrealestateloan varchar2(8) -- 是否属于房地产开发贷款
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
grant select on ${iol_schema}.icms_bc_extend_d to ${iml_schema};
grant select on ${iol_schema}.icms_bc_extend_d to ${icl_schema};
grant select on ${iol_schema}.icms_bc_extend_d to ${idl_schema};
grant select on ${iol_schema}.icms_bc_extend_d to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bc_extend_d is '对公传统信贷业务合同个性化信息';
comment on column ${iol_schema}.icms_bc_extend_d.serialno is '合同编号';
comment on column ${iol_schema}.icms_bc_extend_d.locfinancefundsource is '地方融资平台偿债资金来源分类';
comment on column ${iol_schema}.icms_bc_extend_d.projectartificialno is '项目信息文本号';
comment on column ${iol_schema}.icms_bc_extend_d.creditincrementtype is '主要增信方式';
comment on column ${iol_schema}.icms_bc_extend_d.isforeign is '是否境外贷款';
comment on column ${iol_schema}.icms_bc_extend_d.isyfconfirmed is '是否经议付行确认';
comment on column ${iol_schema}.icms_bc_extend_d.isventureguaranty is '是否创业担保贷款';
comment on column ${iol_schema}.icms_bc_extend_d.ventureguarantytype is '创业担保贷款类型';
comment on column ${iol_schema}.icms_bc_extend_d.rateexplain is '利率/费率说明';
comment on column ${iol_schema}.icms_bc_extend_d.lctermtype is '信用证期限类型';
comment on column ${iol_schema}.icms_bc_extend_d.qtxkzbh is '其他许可证编号';
comment on column ${iol_schema}.icms_bc_extend_d.graceperiod is '远期付款期限(天)';
comment on column ${iol_schema}.icms_bc_extend_d.lcopertype is '信用证类型';
comment on column ${iol_schema}.icms_bc_extend_d.rivalname is '交易对手名称';
comment on column ${iol_schema}.icms_bc_extend_d.outradio is '溢短装比例（%）';
comment on column ${iol_schema}.icms_bc_extend_d.tradesum is '贸易合同总金额(元)';
comment on column ${iol_schema}.icms_bc_extend_d.careerguaranteeloantype is '创业担保贷款类型';
comment on column ${iol_schema}.icms_bc_extend_d.proposerpaymentscale is '贴现利息申请人支付比例(%)';
comment on column ${iol_schema}.icms_bc_extend_d.putoutorgid is '放贷机构';
comment on column ${iol_schema}.icms_bc_extend_d.farmingloanuse is '涉农贷款投向';
comment on column ${iol_schema}.icms_bc_extend_d.oldlccurrency is '母证币种';
comment on column ${iol_schema}.icms_bc_extend_d.tradecurrency is '委托存款币种';
comment on column ${iol_schema}.icms_bc_extend_d.totalcast is '货物标的';
comment on column ${iol_schema}.icms_bc_extend_d.zfsxlx is '政府授信类型';
comment on column ${iol_schema}.icms_bc_extend_d.xmztz is '项目总投资';
comment on column ${iol_schema}.icms_bc_extend_d.ghxkzbh is '规划许可证编号';
comment on column ${iol_schema}.icms_bc_extend_d.discountratenote is '贴现利率说明';
comment on column ${iol_schema}.icms_bc_extend_d.ifqueryflag is '是否先贴后查';
comment on column ${iol_schema}.icms_bc_extend_d.yffdkje is '银团已发放贷款金额(元)';
comment on column ${iol_schema}.icms_bc_extend_d.billnum is '汇票数量(张)';
comment on column ${iol_schema}.icms_bc_extend_d.lccurrency is '信用证币种';
comment on column ${iol_schema}.icms_bc_extend_d.loanhandlechannel is '贷款办理渠道';
comment on column ${iol_schema}.icms_bc_extend_d.mainproduct is '经营商品（贸易融资）';
comment on column ${iol_schema}.icms_bc_extend_d.repayremark is '还款说明';
comment on column ${iol_schema}.icms_bc_extend_d.iscounterparty is '是否合格中央交易对手';
comment on column ${iol_schema}.icms_bc_extend_d.consigneecerttype is '管理人/主承销商证件类型';
comment on column ${iol_schema}.icms_bc_extend_d.hasoutradio is '是否存在溢短装的条款';
comment on column ${iol_schema}.icms_bc_extend_d.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_bc_extend_d.mandatedepacctno is '委托存款帐户';
comment on column ${iol_schema}.icms_bc_extend_d.productcollectmoney is '产品募集金额';
comment on column ${iol_schema}.icms_bc_extend_d.thirdpartyaccounts is '提单号码';
comment on column ${iol_schema}.icms_bc_extend_d.beneficiaryname is '受益人名称';
comment on column ${iol_schema}.icms_bc_extend_d.oldlcno is '母证编号';
comment on column ${iol_schema}.icms_bc_extend_d.guarantybailaccount is '押品转保证金账号';
comment on column ${iol_schema}.icms_bc_extend_d.businessinvoicesum is '商业发票金额';
comment on column ${iol_schema}.icms_bc_extend_d.importantloan is '重点贷款项目';
comment on column ${iol_schema}.icms_bc_extend_d.hpxkzbh is '环评许可证编号';
comment on column ${iol_schema}.icms_bc_extend_d.discountsum is '应收帐款净额(元)';
comment on column ${iol_schema}.icms_bc_extend_d.classifyfrequency is '检查频率';
comment on column ${iol_schema}.icms_bc_extend_d.contextinfo is '交易背景描述';
comment on column ${iol_schema}.icms_bc_extend_d.purchaserpayintratio is '贴现利息买方承担比例(%)';
comment on column ${iol_schema}.icms_bc_extend_d.thirdparty1type is '代付类型';
comment on column ${iol_schema}.icms_bc_extend_d.sfgksx is '是否国开行授信';
comment on column ${iol_schema}.icms_bc_extend_d.consigneename is '管理人/主承销商';
comment on column ${iol_schema}.icms_bc_extend_d.consigneecertid is '管理人/主承销商证件号码';
comment on column ${iol_schema}.icms_bc_extend_d.registerinotherbank is '是否他行代开';
comment on column ${iol_schema}.icms_bc_extend_d.securitiestype is '运输方式';
comment on column ${iol_schema}.icms_bc_extend_d.termcd is '保证金利率档次';
comment on column ${iol_schema}.icms_bc_extend_d.tradecontractno is '贸易合同号';
comment on column ${iol_schema}.icms_bc_extend_d.sfgjxzhy is '是否国家限制行业';
comment on column ${iol_schema}.icms_bc_extend_d.isconsumerfinance is '是否为消费服务类融资';
comment on column ${iol_schema}.icms_bc_extend_d.oldlcsum is '母证金额';
comment on column ${iol_schema}.icms_bc_extend_d.bailaccount is '保证金帐号';
comment on column ${iol_schema}.icms_bc_extend_d.loanquality is '贷款性质';
comment on column ${iol_schema}.icms_bc_extend_d.interestrate is '保证金协议利率';
comment on column ${iol_schema}.icms_bc_extend_d.zfsxfs is '政府授信支持方式';
comment on column ${iol_schema}.icms_bc_extend_d.lcsum is '信用证金额（元）';
comment on column ${iol_schema}.icms_bc_extend_d.businessinvoicetype is '商业发票种类';
comment on column ${iol_schema}.icms_bc_extend_d.useproduct is '使用产品（贸易融资）';
comment on column ${iol_schema}.icms_bc_extend_d.issupplychainfinance is '是否为供应链金融业务';
comment on column ${iol_schema}.icms_bc_extend_d.fxfltp is '保证金利率类型';
comment on column ${iol_schema}.icms_bc_extend_d.supplychainfinancetype is '供应链金融业务产品分类';
comment on column ${iol_schema}.icms_bc_extend_d.tdtimes is '与交易对手成功交易次数';
comment on column ${iol_schema}.icms_bc_extend_d.otherarealoan is '是否异地业务';
comment on column ${iol_schema}.icms_bc_extend_d.purchaserregion is '买方所在地区';
comment on column ${iol_schema}.icms_bc_extend_d.mandatecustname is '委托人';
comment on column ${iol_schema}.icms_bc_extend_d.ifagreementflag is '是否协议付息';
comment on column ${iol_schema}.icms_bc_extend_d.iscareerguaranteeloan is '是否创业担保贷款';
comment on column ${iol_schema}.icms_bc_extend_d.beneficiarycountryname is '受益人所在国家或地区';
comment on column ${iol_schema}.icms_bc_extend_d.cargoinfo is '货物名称';
comment on column ${iol_schema}.icms_bc_extend_d.ifgudingcredit is '是否固定资产授信';
comment on column ${iol_schema}.icms_bc_extend_d.qtxkz is '其他许可证';
comment on column ${iol_schema}.icms_bc_extend_d.othercondition is '其他条件和要求';
comment on column ${iol_schema}.icms_bc_extend_d.interestmethod is '保证金计息方法';
comment on column ${iol_schema}.icms_bc_extend_d.isfarming is '是否涉农';
comment on column ${iol_schema}.icms_bc_extend_d.destination1 is '装运地';
comment on column ${iol_schema}.icms_bc_extend_d.costpersontype is '费用承担人';
comment on column ${iol_schema}.icms_bc_extend_d.gksxpz is '国开授信品种';
comment on column ${iol_schema}.icms_bc_extend_d.zbj is '资本金';
comment on column ${iol_schema}.icms_bc_extend_d.lxpw is '立项批文';
comment on column ${iol_schema}.icms_bc_extend_d.bailtransaccount is '保证金转出帐号';
comment on column ${iol_schema}.icms_bc_extend_d.restbalancesum is '打包成数(%)';
comment on column ${iol_schema}.icms_bc_extend_d.businessinvoicecurrency is '商业发票币种';
comment on column ${iol_schema}.icms_bc_extend_d.drawingtype is '提款方式';
comment on column ${iol_schema}.icms_bc_extend_d.platformpaycashsource is '地方融资平台偿债资金来源分类';
comment on column ${iol_schema}.icms_bc_extend_d.lcpaymethod is '付款方式';
comment on column ${iol_schema}.icms_bc_extend_d.discountcusttype is '贴现申请人种类';
comment on column ${iol_schema}.icms_bc_extend_d.loantradesum is '贷款用途交易金额';
comment on column ${iol_schema}.icms_bc_extend_d.pdrifd is '保证金利率浮动类型';
comment on column ${iol_schema}.icms_bc_extend_d.lcno is '信用证编号';
comment on column ${iol_schema}.icms_bc_extend_d.drawingremark is '提款说明';
comment on column ${iol_schema}.icms_bc_extend_d.moneytype is '委托存款钞汇类别';
comment on column ${iol_schema}.icms_bc_extend_d.sfzfsx is '是否政府授信';
comment on column ${iol_schema}.icms_bc_extend_d.toindustryfund is '是否投向产业基金';
comment on column ${iol_schema}.icms_bc_extend_d.isgovernfinance is '是否涉及政府类融资';
comment on column ${iol_schema}.icms_bc_extend_d.farmingloandirect is '涉农贷款投向';
comment on column ${iol_schema}.icms_bc_extend_d.tdstrenth is '交易对手实力';
comment on column ${iol_schema}.icms_bc_extend_d.paymentname is '付息方';
comment on column ${iol_schema}.icms_bc_extend_d.mandatesource is '委托贷款资金来源';
comment on column ${iol_schema}.icms_bc_extend_d.purchasername is '买方名称';
comment on column ${iol_schema}.icms_bc_extend_d.productlevel is '产品分级级别';
comment on column ${iol_schema}.icms_bc_extend_d.kgrq is '开工日期';
comment on column ${iol_schema}.icms_bc_extend_d.noticebankname is '通知行';
comment on column ${iol_schema}.icms_bc_extend_d.directionrs is '行业投向(征信)';
comment on column ${iol_schema}.icms_bc_extend_d.gshy is '过剩行业';
comment on column ${iol_schema}.icms_bc_extend_d.lcquality is '信用证性质';
comment on column ${iol_schema}.icms_bc_extend_d.offerbilldate is '提供单据日期';
comment on column ${iol_schema}.icms_bc_extend_d.financesupportmode is '贷款财政扶持方式';
comment on column ${iol_schema}.icms_bc_extend_d.pwwh is '批文文号';
comment on column ${iol_schema}.icms_bc_extend_d.realestateloantype is '房地产贷款类型';
comment on column ${iol_schema}.icms_bc_extend_d.isyfreceive is '是否预付应收帐款';
comment on column ${iol_schema}.icms_bc_extend_d.corpuspaymethod is '还款方式';
comment on column ${iol_schema}.icms_bc_extend_d.mfeeratio is '其他费率(‰)';
comment on column ${iol_schema}.icms_bc_extend_d.acceptbankname is '承兑行名称';
comment on column ${iol_schema}.icms_bc_extend_d.businessinvoiceinfo is '商业发票号码';
comment on column ${iol_schema}.icms_bc_extend_d.jsydxkzbh is '建设用地许可证编号';
comment on column ${iol_schema}.icms_bc_extend_d.mandatecustid is '委托人客户';
comment on column ${iol_schema}.icms_bc_extend_d.oldlcloadingdate is '装运日期';
comment on column ${iol_schema}.icms_bc_extend_d.isrz is '是否融资合同';
comment on column ${iol_schema}.icms_bc_extend_d.isimportantloan is '是否重点项目贷款';
comment on column ${iol_schema}.icms_bc_extend_d.tdyears is '与交易对手合作年限';
comment on column ${iol_schema}.icms_bc_extend_d.destination2 is '货物运输目的地';
comment on column ${iol_schema}.icms_bc_extend_d.farmingloantype is '涉农贷款主体类型';
comment on column ${iol_schema}.icms_bc_extend_d.pdrifm is '保证金利率浮动方式';
comment on column ${iol_schema}.icms_bc_extend_d.tradingassets is '交易资产';
comment on column ${iol_schema}.icms_bc_extend_d.farmingsubjecttype is '涉农贷款主体类型';
comment on column ${iol_schema}.icms_bc_extend_d.lccdflag is '远期信用证是否已承兑';
comment on column ${iol_schema}.icms_bc_extend_d.lcapplyserialno is '开证申请书编号';
comment on column ${iol_schema}.icms_bc_extend_d.issjorcs is '是否三旧改造或城市更新项目';
comment on column ${iol_schema}.icms_bc_extend_d.bailcurrency is '保证金币种';
comment on column ${iol_schema}.icms_bc_extend_d.duepaymethod is '应收帐款预付方式';
comment on column ${iol_schema}.icms_bc_extend_d.consignmentloandirect is '委托贷款特殊投向';
comment on column ${iol_schema}.icms_bc_extend_d.loantraderatio is '贷款金额占交易价款比例(%)';
comment on column ${iol_schema}.icms_bc_extend_d.discountdrafttype is '贴现的商业承兑汇票类别';
comment on column ${iol_schema}.icms_bc_extend_d.creditattribute is '合同类型';
comment on column ${iol_schema}.icms_bc_extend_d.sgxkzbh is '施工许可证编号';
comment on column ${iol_schema}.icms_bc_extend_d.guarantytype is '担保/操作模式(担保切分必选项)';
comment on column ${iol_schema}.icms_bc_extend_d.fundsource is '资金来源';
comment on column ${iol_schema}.icms_bc_extend_d.factoringtype is '保理类型';
comment on column ${iol_schema}.icms_bc_extend_d.pdrifv is '保证金浮动值';
comment on column ${iol_schema}.icms_bc_extend_d.bondno is '标的产品编号';
comment on column ${iol_schema}.icms_bc_extend_d.lctype is '信用证种类';
comment on column ${iol_schema}.icms_bc_extend_d.financier is '实际融资人';
comment on column ${iol_schema}.icms_bc_extend_d.businessprop is '放款成数(%)';
comment on column ${iol_schema}.icms_bc_extend_d.isdebttoequity is '是否投向市场化债转股';
comment on column ${iol_schema}.icms_bc_extend_d.guaranteehprojecttype is '保障性安居工程贷款类型LoanPurposeType';
comment on column ${iol_schema}.icms_bc_extend_d.landuseno is '土地使用证编号';
comment on column ${iol_schema}.icms_bc_extend_d.landusedate is '土地使用证日期';
comment on column ${iol_schema}.icms_bc_extend_d.landplanpermitno is '用地规划许可证编号';
comment on column ${iol_schema}.icms_bc_extend_d.landplanpermitdate is '用地规划许可证日期';
comment on column ${iol_schema}.icms_bc_extend_d.constructpermitdate is '施工许可证日期';
comment on column ${iol_schema}.icms_bc_extend_d.projectplanpermitdate is '工程规划许可证日期';
comment on column ${iol_schema}.icms_bc_extend_d.buyername is '购货方名称';
comment on column ${iol_schema}.icms_bc_extend_d.sellername is '销货方名称';
comment on column ${iol_schema}.icms_bc_extend_d.tradetransactioncontent is '贸易交易内容';
comment on column ${iol_schema}.icms_bc_extend_d.transferacc is '应收账款转让方式 码值:TransferBL';
comment on column ${iol_schema}.icms_bc_extend_d.isprojectfinancing is '是否项目融资';
comment on column ${iol_schema}.icms_bc_extend_d.jsydxkzrq is '建设用地许可证日期';
comment on column ${iol_schema}.icms_bc_extend_d.projectname is '项目名称';
comment on column ${iol_schema}.icms_bc_extend_d.advancedmanuflag is '先进制造业标志（0-否，1-是）';
comment on column ${iol_schema}.icms_bc_extend_d.cultureindustryflag is '文化产业标志（0-否，1-是）';
comment on column ${iol_schema}.icms_bc_extend_d.industrialrestructuringtype is '客户产业结构调整类型';
comment on column ${iol_schema}.icms_bc_extend_d.onlynewentflag is '专精特新中小企业标志（0-否，1-是）';
comment on column ${iol_schema}.icms_bc_extend_d.onlynewsmallentflag is '专精特新小巨人企业标志（0-否，1-是）';
comment on column ${iol_schema}.icms_bc_extend_d.strategicemergingindustrytype is '战略性新兴产业类型';
comment on column ${iol_schema}.icms_bc_extend_d.transformationandupgradeid is '工业企业技术改造升级标志（0-否，1-是）';
comment on column ${iol_schema}.icms_bc_extend_d.interestrepaycycle is '结息方式';
comment on column ${iol_schema}.icms_bc_extend_d.operationstartdate is '运营开始日期';
comment on column ${iol_schema}.icms_bc_extend_d.isoverssocipproj is '是否投向政府和社会资本合作（PPP）项目';
comment on column ${iol_schema}.icms_bc_extend_d.isnewmechissueloan is '是否新机制发放贷款';
comment on column ${iol_schema}.icms_bc_extend_d.iscoverdbbalance is '预测现金流是否覆盖借款余额';
comment on column ${iol_schema}.icms_bc_extend_d.isadvancedindustry is '是否高技术服务业贷款';
comment on column ${iol_schema}.icms_bc_extend_d.advancedindustryloantype is '高技术服务业贷款类型';
comment on column ${iol_schema}.icms_bc_extend_d.guarantybailsubaccount is '';
comment on column ${iol_schema}.icms_bc_extend_d.limitcoreent is '';
comment on column ${iol_schema}.icms_bc_extend_d.paymentaccount is '';
comment on column ${iol_schema}.icms_bc_extend_d.factoringcredittype is '';
comment on column ${iol_schema}.icms_bc_extend_d.belongitem is '';
comment on column ${iol_schema}.icms_bc_extend_d.lcsumrate is '';
comment on column ${iol_schema}.icms_bc_extend_d.maxpdrifv is '';
comment on column ${iol_schema}.icms_bc_extend_d.isguaranteeloan is '';
comment on column ${iol_schema}.icms_bc_extend_d.collectionnumbers is '';
comment on column ${iol_schema}.icms_bc_extend_d.remittancenumbers is '';
comment on column ${iol_schema}.icms_bc_extend_d.lcloanflag is '';
comment on column ${iol_schema}.icms_bc_extend_d.scanstatus is '';
comment on column ${iol_schema}.icms_bc_extend_d.discountrate is '';
comment on column ${iol_schema}.icms_bc_extend_d.tradcontractno is '';
comment on column ${iol_schema}.icms_bc_extend_d.claimterm is '';
comment on column ${iol_schema}.icms_bc_extend_d.agentbankname is '';
comment on column ${iol_schema}.icms_bc_extend_d.agentbankno is '';
comment on column ${iol_schema}.icms_bc_extend_d.issuedbusinessno is '';
comment on column ${iol_schema}.icms_bc_extend_d.confirmbankname is '';
comment on column ${iol_schema}.icms_bc_extend_d.confirmbankid is '';
comment on column ${iol_schema}.icms_bc_extend_d.guaranteetype is '';
comment on column ${iol_schema}.icms_bc_extend_d.guaranteesum is '';
comment on column ${iol_schema}.icms_bc_extend_d.finishterm is '';
comment on column ${iol_schema}.icms_bc_extend_d.proquestionupdatedate is '';
comment on column ${iol_schema}.icms_bc_extend_d.scanuserid is '';
comment on column ${iol_schema}.icms_bc_extend_d.scanusername is '';
comment on column ${iol_schema}.icms_bc_extend_d.bizuniqueno is '';
comment on column ${iol_schema}.icms_bc_extend_d.ratestartmode is '';
comment on column ${iol_schema}.icms_bc_extend_d.compoundintflag is '';
comment on column ${iol_schema}.icms_bc_extend_d.compoundintfloatvalue is '';
comment on column ${iol_schema}.icms_bc_extend_d.compoundintratio is '';
comment on column ${iol_schema}.icms_bc_extend_d.stopintflag is '';
comment on column ${iol_schema}.icms_bc_extend_d.tagcompleteflag is '';
comment on column ${iol_schema}.icms_bc_extend_d.capitalsourcebailtransaccount is '';
comment on column ${iol_schema}.icms_bc_extend_d.capitalsourcebailsum is '';
comment on column ${iol_schema}.icms_bc_extend_d.capitalsourcebustype is '';
comment on column ${iol_schema}.icms_bc_extend_d.stoppayacct is '';
comment on column ${iol_schema}.icms_bc_extend_d.subacctnum is '';
comment on column ${iol_schema}.icms_bc_extend_d.depositsum is '';
comment on column ${iol_schema}.icms_bc_extend_d.xztflag is '';
comment on column ${iol_schema}.icms_bc_extend_d.isrealestateloan is '是否属于房地产开发贷款';
comment on column ${iol_schema}.icms_bc_extend_d.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bc_extend_d.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bc_extend_d.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bc_extend_d.etl_timestamp is 'ETL处理时间戳';
