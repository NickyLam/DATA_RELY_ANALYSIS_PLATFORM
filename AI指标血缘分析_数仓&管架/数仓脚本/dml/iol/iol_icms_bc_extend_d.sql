/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bc_extend_d
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
create table ${iol_schema}.icms_bc_extend_d_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bc_extend_d
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bc_extend_d_op purge;
drop table ${iol_schema}.icms_bc_extend_d_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bc_extend_d_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bc_extend_d where 0=1;

create table ${iol_schema}.icms_bc_extend_d_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bc_extend_d where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bc_extend_d_cl(
            serialno -- 合同编号
            ,locfinancefundsource -- 地方融资平台偿债资金来源分类
            ,projectartificialno -- 项目信息文本号
            ,creditincrementtype -- 主要增信方式
            ,isforeign -- 是否境外贷款
            ,isyfconfirmed -- 是否经议付行确认
            ,isventureguaranty -- 是否创业担保贷款
            ,ventureguarantytype -- 创业担保贷款类型
            ,rateexplain -- 利率/费率说明
            ,lctermtype -- 信用证期限类型
            ,qtxkzbh -- 其他许可证编号
            ,graceperiod -- 远期付款期限(天)
            ,lcopertype -- 信用证类型
            ,rivalname -- 交易对手名称
            ,outradio -- 溢短装比例（%）
            ,tradesum -- 贸易合同总金额(元)
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,proposerpaymentscale -- 贴现利息申请人支付比例(%)
            ,putoutorgid -- 放贷机构
            ,farmingloanuse -- 涉农贷款投向
            ,oldlccurrency -- 母证币种
            ,tradecurrency -- 委托存款币种
            ,totalcast -- 货物标的
            ,zfsxlx -- 政府授信类型
            ,xmztz -- 项目总投资
            ,ghxkzbh -- 规划许可证编号
            ,discountratenote -- 贴现利率说明
            ,ifqueryflag -- 是否先贴后查
            ,yffdkje -- 银团已发放贷款金额(元)
            ,billnum -- 汇票数量(张)
            ,lccurrency -- 信用证币种
            ,loanhandlechannel -- 贷款办理渠道
            ,mainproduct -- 经营商品（贸易融资）
            ,repayremark -- 还款说明
            ,iscounterparty -- 是否合格中央交易对手
            ,consigneecerttype -- 管理人/主承销商证件类型
            ,hasoutradio -- 是否存在溢短装的条款
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,mandatedepacctno -- 委托存款帐户
            ,productcollectmoney -- 产品募集金额
            ,thirdpartyaccounts -- 提单号码
            ,beneficiaryname -- 受益人名称
            ,oldlcno -- 母证编号
            ,guarantybailaccount -- 押品转保证金账号
            ,businessinvoicesum -- 商业发票金额
            ,importantloan -- 重点贷款项目
            ,hpxkzbh -- 环评许可证编号
            ,discountsum -- 应收帐款净额(元)
            ,classifyfrequency -- 检查频率
            ,contextinfo -- 交易背景描述
            ,purchaserpayintratio -- 贴现利息买方承担比例(%)
            ,thirdparty1type -- 代付类型
            ,sfgksx -- 是否国开行授信
            ,consigneename -- 管理人/主承销商
            ,consigneecertid -- 管理人/主承销商证件号码
            ,registerinotherbank -- 是否他行代开
            ,securitiestype -- 运输方式
            ,termcd -- 保证金利率档次
            ,tradecontractno -- 贸易合同号
            ,sfgjxzhy -- 是否国家限制行业
            ,isconsumerfinance -- 是否为消费服务类融资
            ,oldlcsum -- 母证金额
            ,bailaccount -- 保证金帐号
            ,loanquality -- 贷款性质
            ,interestrate -- 保证金协议利率
            ,zfsxfs -- 政府授信支持方式
            ,lcsum -- 信用证金额（元）
            ,businessinvoicetype -- 商业发票种类
            ,useproduct -- 使用产品（贸易融资）
            ,issupplychainfinance -- 是否为供应链金融业务
            ,fxfltp -- 保证金利率类型
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,tdtimes -- 与交易对手成功交易次数
            ,otherarealoan -- 是否异地业务
            ,purchaserregion -- 买方所在地区
            ,mandatecustname -- 委托人
            ,ifagreementflag -- 是否协议付息
            ,iscareerguaranteeloan -- 是否创业担保贷款
            ,beneficiarycountryname -- 受益人所在国家或地区
            ,cargoinfo -- 货物名称
            ,ifgudingcredit -- 是否固定资产授信
            ,qtxkz -- 其他许可证
            ,othercondition -- 其他条件和要求
            ,interestmethod -- 保证金计息方法
            ,isfarming -- 是否涉农
            ,destination1 -- 装运地
            ,costpersontype -- 费用承担人
            ,gksxpz -- 国开授信品种
            ,zbj -- 资本金
            ,lxpw -- 立项批文
            ,bailtransaccount -- 保证金转出帐号
            ,restbalancesum -- 打包成数(%)
            ,businessinvoicecurrency -- 商业发票币种
            ,drawingtype -- 提款方式
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,lcpaymethod -- 付款方式
            ,discountcusttype -- 贴现申请人种类
            ,loantradesum -- 贷款用途交易金额
            ,pdrifd -- 保证金利率浮动类型
            ,lcno -- 信用证编号
            ,drawingremark -- 提款说明
            ,moneytype -- 委托存款钞汇类别
            ,sfzfsx -- 是否政府授信
            ,toindustryfund -- 是否投向产业基金
            ,isgovernfinance -- 是否涉及政府类融资
            ,farmingloandirect -- 涉农贷款投向
            ,tdstrenth -- 交易对手实力
            ,paymentname -- 付息方
            ,mandatesource -- 委托贷款资金来源
            ,purchasername -- 买方名称
            ,productlevel -- 产品分级级别
            ,kgrq -- 开工日期
            ,noticebankname -- 通知行
            ,directionrs -- 行业投向(征信)
            ,gshy -- 过剩行业
            ,lcquality -- 信用证性质
            ,offerbilldate -- 提供单据日期
            ,financesupportmode -- 贷款财政扶持方式
            ,pwwh -- 批文文号
            ,realestateloantype -- 房地产贷款类型
            ,isyfreceive -- 是否预付应收帐款
            ,corpuspaymethod -- 还款方式
            ,mfeeratio -- 其他费率(‰)
            ,acceptbankname -- 承兑行名称
            ,businessinvoiceinfo -- 商业发票号码
            ,jsydxkzbh -- 建设用地许可证编号
            ,mandatecustid -- 委托人客户
            ,oldlcloadingdate -- 装运日期
            ,isrz -- 是否融资合同
            ,isimportantloan -- 是否重点项目贷款
            ,tdyears -- 与交易对手合作年限
            ,destination2 -- 货物运输目的地
            ,farmingloantype -- 涉农贷款主体类型
            ,pdrifm -- 保证金利率浮动方式
            ,tradingassets -- 交易资产
            ,farmingsubjecttype -- 涉农贷款主体类型
            ,lccdflag -- 远期信用证是否已承兑
            ,lcapplyserialno -- 开证申请书编号
            ,issjorcs -- 是否三旧改造或城市更新项目
            ,bailcurrency -- 保证金币种
            ,duepaymethod -- 应收帐款预付方式
            ,consignmentloandirect -- 委托贷款特殊投向
            ,loantraderatio -- 贷款金额占交易价款比例(%)
            ,discountdrafttype -- 贴现的商业承兑汇票类别
            ,creditattribute -- 合同类型
            ,sgxkzbh -- 施工许可证编号
            ,guarantytype -- 担保/操作模式(担保切分必选项)
            ,fundsource -- 资金来源
            ,factoringtype -- 保理类型
            ,pdrifv -- 保证金浮动值
            ,bondno -- 标的产品编号
            ,lctype -- 信用证种类
            ,financier -- 实际融资人
            ,businessprop -- 放款成数(%)
            ,isdebttoequity -- 是否投向市场化债转股
            ,guaranteehprojecttype -- 保障性安居工程贷款类型LoanPurposeType
            ,landuseno -- 土地使用证编号
            ,landusedate -- 土地使用证日期
            ,landplanpermitno -- 用地规划许可证编号
            ,landplanpermitdate -- 用地规划许可证日期
            ,constructpermitdate -- 施工许可证日期
            ,projectplanpermitdate -- 工程规划许可证日期
            ,buyername -- 购货方名称
            ,sellername -- 销货方名称
            ,tradetransactioncontent -- 贸易交易内容
            ,transferacc -- 应收账款转让方式 码值:TransferBL
            ,isprojectfinancing -- 是否项目融资
            ,jsydxkzrq -- 建设用地许可证日期
            ,projectname -- 项目名称
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,industrialrestructuringtype -- 客户产业结构调整类型
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,strategicemergingindustrytype -- 战略性新兴产业类型
            ,transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
            ,interestrepaycycle -- 结息方式
            ,operationstartdate -- 运营开始日期
            ,isoverssocipproj -- 是否投向政府和社会资本合作（PPP）项目
            ,isnewmechissueloan -- 是否新机制发放贷款
            ,iscoverdbbalance -- 预测现金流是否覆盖借款余额
            ,isadvancedindustry -- 是否高技术服务业贷款
            ,advancedindustryloantype -- 高技术服务业贷款类型
            ,guarantybailsubaccount -- 
            ,limitcoreent -- 
            ,paymentaccount -- 
            ,factoringcredittype -- 
            ,belongitem -- 
            ,lcsumrate -- 
            ,maxpdrifv -- 
            ,isguaranteeloan -- 
            ,collectionnumbers -- 
            ,remittancenumbers -- 
            ,lcloanflag -- 
            ,scanstatus -- 
            ,discountrate -- 
            ,tradcontractno -- 
            ,claimterm -- 
            ,agentbankname -- 
            ,agentbankno -- 
            ,issuedbusinessno -- 
            ,confirmbankname -- 
            ,confirmbankid -- 
            ,guaranteetype -- 
            ,guaranteesum -- 
            ,finishterm -- 
            ,proquestionupdatedate -- 
            ,scanuserid -- 
            ,scanusername -- 
            ,bizuniqueno -- 
            ,ratestartmode -- 
            ,compoundintflag -- 
            ,compoundintfloatvalue -- 
            ,compoundintratio -- 
            ,stopintflag -- 
            ,tagcompleteflag -- 
            ,capitalsourcebailtransaccount -- 
            ,capitalsourcebailsum -- 
            ,capitalsourcebustype -- 
            ,stoppayacct -- 
            ,subacctnum -- 
            ,depositsum -- 
            ,xztflag -- 
            ,isrealestateloan -- 是否属于房地产开发贷款
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bc_extend_d_op(
            serialno -- 合同编号
            ,locfinancefundsource -- 地方融资平台偿债资金来源分类
            ,projectartificialno -- 项目信息文本号
            ,creditincrementtype -- 主要增信方式
            ,isforeign -- 是否境外贷款
            ,isyfconfirmed -- 是否经议付行确认
            ,isventureguaranty -- 是否创业担保贷款
            ,ventureguarantytype -- 创业担保贷款类型
            ,rateexplain -- 利率/费率说明
            ,lctermtype -- 信用证期限类型
            ,qtxkzbh -- 其他许可证编号
            ,graceperiod -- 远期付款期限(天)
            ,lcopertype -- 信用证类型
            ,rivalname -- 交易对手名称
            ,outradio -- 溢短装比例（%）
            ,tradesum -- 贸易合同总金额(元)
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,proposerpaymentscale -- 贴现利息申请人支付比例(%)
            ,putoutorgid -- 放贷机构
            ,farmingloanuse -- 涉农贷款投向
            ,oldlccurrency -- 母证币种
            ,tradecurrency -- 委托存款币种
            ,totalcast -- 货物标的
            ,zfsxlx -- 政府授信类型
            ,xmztz -- 项目总投资
            ,ghxkzbh -- 规划许可证编号
            ,discountratenote -- 贴现利率说明
            ,ifqueryflag -- 是否先贴后查
            ,yffdkje -- 银团已发放贷款金额(元)
            ,billnum -- 汇票数量(张)
            ,lccurrency -- 信用证币种
            ,loanhandlechannel -- 贷款办理渠道
            ,mainproduct -- 经营商品（贸易融资）
            ,repayremark -- 还款说明
            ,iscounterparty -- 是否合格中央交易对手
            ,consigneecerttype -- 管理人/主承销商证件类型
            ,hasoutradio -- 是否存在溢短装的条款
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,mandatedepacctno -- 委托存款帐户
            ,productcollectmoney -- 产品募集金额
            ,thirdpartyaccounts -- 提单号码
            ,beneficiaryname -- 受益人名称
            ,oldlcno -- 母证编号
            ,guarantybailaccount -- 押品转保证金账号
            ,businessinvoicesum -- 商业发票金额
            ,importantloan -- 重点贷款项目
            ,hpxkzbh -- 环评许可证编号
            ,discountsum -- 应收帐款净额(元)
            ,classifyfrequency -- 检查频率
            ,contextinfo -- 交易背景描述
            ,purchaserpayintratio -- 贴现利息买方承担比例(%)
            ,thirdparty1type -- 代付类型
            ,sfgksx -- 是否国开行授信
            ,consigneename -- 管理人/主承销商
            ,consigneecertid -- 管理人/主承销商证件号码
            ,registerinotherbank -- 是否他行代开
            ,securitiestype -- 运输方式
            ,termcd -- 保证金利率档次
            ,tradecontractno -- 贸易合同号
            ,sfgjxzhy -- 是否国家限制行业
            ,isconsumerfinance -- 是否为消费服务类融资
            ,oldlcsum -- 母证金额
            ,bailaccount -- 保证金帐号
            ,loanquality -- 贷款性质
            ,interestrate -- 保证金协议利率
            ,zfsxfs -- 政府授信支持方式
            ,lcsum -- 信用证金额（元）
            ,businessinvoicetype -- 商业发票种类
            ,useproduct -- 使用产品（贸易融资）
            ,issupplychainfinance -- 是否为供应链金融业务
            ,fxfltp -- 保证金利率类型
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,tdtimes -- 与交易对手成功交易次数
            ,otherarealoan -- 是否异地业务
            ,purchaserregion -- 买方所在地区
            ,mandatecustname -- 委托人
            ,ifagreementflag -- 是否协议付息
            ,iscareerguaranteeloan -- 是否创业担保贷款
            ,beneficiarycountryname -- 受益人所在国家或地区
            ,cargoinfo -- 货物名称
            ,ifgudingcredit -- 是否固定资产授信
            ,qtxkz -- 其他许可证
            ,othercondition -- 其他条件和要求
            ,interestmethod -- 保证金计息方法
            ,isfarming -- 是否涉农
            ,destination1 -- 装运地
            ,costpersontype -- 费用承担人
            ,gksxpz -- 国开授信品种
            ,zbj -- 资本金
            ,lxpw -- 立项批文
            ,bailtransaccount -- 保证金转出帐号
            ,restbalancesum -- 打包成数(%)
            ,businessinvoicecurrency -- 商业发票币种
            ,drawingtype -- 提款方式
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,lcpaymethod -- 付款方式
            ,discountcusttype -- 贴现申请人种类
            ,loantradesum -- 贷款用途交易金额
            ,pdrifd -- 保证金利率浮动类型
            ,lcno -- 信用证编号
            ,drawingremark -- 提款说明
            ,moneytype -- 委托存款钞汇类别
            ,sfzfsx -- 是否政府授信
            ,toindustryfund -- 是否投向产业基金
            ,isgovernfinance -- 是否涉及政府类融资
            ,farmingloandirect -- 涉农贷款投向
            ,tdstrenth -- 交易对手实力
            ,paymentname -- 付息方
            ,mandatesource -- 委托贷款资金来源
            ,purchasername -- 买方名称
            ,productlevel -- 产品分级级别
            ,kgrq -- 开工日期
            ,noticebankname -- 通知行
            ,directionrs -- 行业投向(征信)
            ,gshy -- 过剩行业
            ,lcquality -- 信用证性质
            ,offerbilldate -- 提供单据日期
            ,financesupportmode -- 贷款财政扶持方式
            ,pwwh -- 批文文号
            ,realestateloantype -- 房地产贷款类型
            ,isyfreceive -- 是否预付应收帐款
            ,corpuspaymethod -- 还款方式
            ,mfeeratio -- 其他费率(‰)
            ,acceptbankname -- 承兑行名称
            ,businessinvoiceinfo -- 商业发票号码
            ,jsydxkzbh -- 建设用地许可证编号
            ,mandatecustid -- 委托人客户
            ,oldlcloadingdate -- 装运日期
            ,isrz -- 是否融资合同
            ,isimportantloan -- 是否重点项目贷款
            ,tdyears -- 与交易对手合作年限
            ,destination2 -- 货物运输目的地
            ,farmingloantype -- 涉农贷款主体类型
            ,pdrifm -- 保证金利率浮动方式
            ,tradingassets -- 交易资产
            ,farmingsubjecttype -- 涉农贷款主体类型
            ,lccdflag -- 远期信用证是否已承兑
            ,lcapplyserialno -- 开证申请书编号
            ,issjorcs -- 是否三旧改造或城市更新项目
            ,bailcurrency -- 保证金币种
            ,duepaymethod -- 应收帐款预付方式
            ,consignmentloandirect -- 委托贷款特殊投向
            ,loantraderatio -- 贷款金额占交易价款比例(%)
            ,discountdrafttype -- 贴现的商业承兑汇票类别
            ,creditattribute -- 合同类型
            ,sgxkzbh -- 施工许可证编号
            ,guarantytype -- 担保/操作模式(担保切分必选项)
            ,fundsource -- 资金来源
            ,factoringtype -- 保理类型
            ,pdrifv -- 保证金浮动值
            ,bondno -- 标的产品编号
            ,lctype -- 信用证种类
            ,financier -- 实际融资人
            ,businessprop -- 放款成数(%)
            ,isdebttoequity -- 是否投向市场化债转股
            ,guaranteehprojecttype -- 保障性安居工程贷款类型LoanPurposeType
            ,landuseno -- 土地使用证编号
            ,landusedate -- 土地使用证日期
            ,landplanpermitno -- 用地规划许可证编号
            ,landplanpermitdate -- 用地规划许可证日期
            ,constructpermitdate -- 施工许可证日期
            ,projectplanpermitdate -- 工程规划许可证日期
            ,buyername -- 购货方名称
            ,sellername -- 销货方名称
            ,tradetransactioncontent -- 贸易交易内容
            ,transferacc -- 应收账款转让方式 码值:TransferBL
            ,isprojectfinancing -- 是否项目融资
            ,jsydxkzrq -- 建设用地许可证日期
            ,projectname -- 项目名称
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,industrialrestructuringtype -- 客户产业结构调整类型
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,strategicemergingindustrytype -- 战略性新兴产业类型
            ,transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
            ,interestrepaycycle -- 结息方式
            ,operationstartdate -- 运营开始日期
            ,isoverssocipproj -- 是否投向政府和社会资本合作（PPP）项目
            ,isnewmechissueloan -- 是否新机制发放贷款
            ,iscoverdbbalance -- 预测现金流是否覆盖借款余额
            ,isadvancedindustry -- 是否高技术服务业贷款
            ,advancedindustryloantype -- 高技术服务业贷款类型
            ,guarantybailsubaccount -- 
            ,limitcoreent -- 
            ,paymentaccount -- 
            ,factoringcredittype -- 
            ,belongitem -- 
            ,lcsumrate -- 
            ,maxpdrifv -- 
            ,isguaranteeloan -- 
            ,collectionnumbers -- 
            ,remittancenumbers -- 
            ,lcloanflag -- 
            ,scanstatus -- 
            ,discountrate -- 
            ,tradcontractno -- 
            ,claimterm -- 
            ,agentbankname -- 
            ,agentbankno -- 
            ,issuedbusinessno -- 
            ,confirmbankname -- 
            ,confirmbankid -- 
            ,guaranteetype -- 
            ,guaranteesum -- 
            ,finishterm -- 
            ,proquestionupdatedate -- 
            ,scanuserid -- 
            ,scanusername -- 
            ,bizuniqueno -- 
            ,ratestartmode -- 
            ,compoundintflag -- 
            ,compoundintfloatvalue -- 
            ,compoundintratio -- 
            ,stopintflag -- 
            ,tagcompleteflag -- 
            ,capitalsourcebailtransaccount -- 
            ,capitalsourcebailsum -- 
            ,capitalsourcebustype -- 
            ,stoppayacct -- 
            ,subacctnum -- 
            ,depositsum -- 
            ,xztflag -- 
            ,isrealestateloan -- 是否属于房地产开发贷款
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 合同编号
    ,nvl(n.locfinancefundsource, o.locfinancefundsource) as locfinancefundsource -- 地方融资平台偿债资金来源分类
    ,nvl(n.projectartificialno, o.projectartificialno) as projectartificialno -- 项目信息文本号
    ,nvl(n.creditincrementtype, o.creditincrementtype) as creditincrementtype -- 主要增信方式
    ,nvl(n.isforeign, o.isforeign) as isforeign -- 是否境外贷款
    ,nvl(n.isyfconfirmed, o.isyfconfirmed) as isyfconfirmed -- 是否经议付行确认
    ,nvl(n.isventureguaranty, o.isventureguaranty) as isventureguaranty -- 是否创业担保贷款
    ,nvl(n.ventureguarantytype, o.ventureguarantytype) as ventureguarantytype -- 创业担保贷款类型
    ,nvl(n.rateexplain, o.rateexplain) as rateexplain -- 利率/费率说明
    ,nvl(n.lctermtype, o.lctermtype) as lctermtype -- 信用证期限类型
    ,nvl(n.qtxkzbh, o.qtxkzbh) as qtxkzbh -- 其他许可证编号
    ,nvl(n.graceperiod, o.graceperiod) as graceperiod -- 远期付款期限(天)
    ,nvl(n.lcopertype, o.lcopertype) as lcopertype -- 信用证类型
    ,nvl(n.rivalname, o.rivalname) as rivalname -- 交易对手名称
    ,nvl(n.outradio, o.outradio) as outradio -- 溢短装比例（%）
    ,nvl(n.tradesum, o.tradesum) as tradesum -- 贸易合同总金额(元)
    ,nvl(n.careerguaranteeloantype, o.careerguaranteeloantype) as careerguaranteeloantype -- 创业担保贷款类型
    ,nvl(n.proposerpaymentscale, o.proposerpaymentscale) as proposerpaymentscale -- 贴现利息申请人支付比例(%)
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 放贷机构
    ,nvl(n.farmingloanuse, o.farmingloanuse) as farmingloanuse -- 涉农贷款投向
    ,nvl(n.oldlccurrency, o.oldlccurrency) as oldlccurrency -- 母证币种
    ,nvl(n.tradecurrency, o.tradecurrency) as tradecurrency -- 委托存款币种
    ,nvl(n.totalcast, o.totalcast) as totalcast -- 货物标的
    ,nvl(n.zfsxlx, o.zfsxlx) as zfsxlx -- 政府授信类型
    ,nvl(n.xmztz, o.xmztz) as xmztz -- 项目总投资
    ,nvl(n.ghxkzbh, o.ghxkzbh) as ghxkzbh -- 规划许可证编号
    ,nvl(n.discountratenote, o.discountratenote) as discountratenote -- 贴现利率说明
    ,nvl(n.ifqueryflag, o.ifqueryflag) as ifqueryflag -- 是否先贴后查
    ,nvl(n.yffdkje, o.yffdkje) as yffdkje -- 银团已发放贷款金额(元)
    ,nvl(n.billnum, o.billnum) as billnum -- 汇票数量(张)
    ,nvl(n.lccurrency, o.lccurrency) as lccurrency -- 信用证币种
    ,nvl(n.loanhandlechannel, o.loanhandlechannel) as loanhandlechannel -- 贷款办理渠道
    ,nvl(n.mainproduct, o.mainproduct) as mainproduct -- 经营商品（贸易融资）
    ,nvl(n.repayremark, o.repayremark) as repayremark -- 还款说明
    ,nvl(n.iscounterparty, o.iscounterparty) as iscounterparty -- 是否合格中央交易对手
    ,nvl(n.consigneecerttype, o.consigneecerttype) as consigneecerttype -- 管理人/主承销商证件类型
    ,nvl(n.hasoutradio, o.hasoutradio) as hasoutradio -- 是否存在溢短装的条款
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.mandatedepacctno, o.mandatedepacctno) as mandatedepacctno -- 委托存款帐户
    ,nvl(n.productcollectmoney, o.productcollectmoney) as productcollectmoney -- 产品募集金额
    ,nvl(n.thirdpartyaccounts, o.thirdpartyaccounts) as thirdpartyaccounts -- 提单号码
    ,nvl(n.beneficiaryname, o.beneficiaryname) as beneficiaryname -- 受益人名称
    ,nvl(n.oldlcno, o.oldlcno) as oldlcno -- 母证编号
    ,nvl(n.guarantybailaccount, o.guarantybailaccount) as guarantybailaccount -- 押品转保证金账号
    ,nvl(n.businessinvoicesum, o.businessinvoicesum) as businessinvoicesum -- 商业发票金额
    ,nvl(n.importantloan, o.importantloan) as importantloan -- 重点贷款项目
    ,nvl(n.hpxkzbh, o.hpxkzbh) as hpxkzbh -- 环评许可证编号
    ,nvl(n.discountsum, o.discountsum) as discountsum -- 应收帐款净额(元)
    ,nvl(n.classifyfrequency, o.classifyfrequency) as classifyfrequency -- 检查频率
    ,nvl(n.contextinfo, o.contextinfo) as contextinfo -- 交易背景描述
    ,nvl(n.purchaserpayintratio, o.purchaserpayintratio) as purchaserpayintratio -- 贴现利息买方承担比例(%)
    ,nvl(n.thirdparty1type, o.thirdparty1type) as thirdparty1type -- 代付类型
    ,nvl(n.sfgksx, o.sfgksx) as sfgksx -- 是否国开行授信
    ,nvl(n.consigneename, o.consigneename) as consigneename -- 管理人/主承销商
    ,nvl(n.consigneecertid, o.consigneecertid) as consigneecertid -- 管理人/主承销商证件号码
    ,nvl(n.registerinotherbank, o.registerinotherbank) as registerinotherbank -- 是否他行代开
    ,nvl(n.securitiestype, o.securitiestype) as securitiestype -- 运输方式
    ,nvl(n.termcd, o.termcd) as termcd -- 保证金利率档次
    ,nvl(n.tradecontractno, o.tradecontractno) as tradecontractno -- 贸易合同号
    ,nvl(n.sfgjxzhy, o.sfgjxzhy) as sfgjxzhy -- 是否国家限制行业
    ,nvl(n.isconsumerfinance, o.isconsumerfinance) as isconsumerfinance -- 是否为消费服务类融资
    ,nvl(n.oldlcsum, o.oldlcsum) as oldlcsum -- 母证金额
    ,nvl(n.bailaccount, o.bailaccount) as bailaccount -- 保证金帐号
    ,nvl(n.loanquality, o.loanquality) as loanquality -- 贷款性质
    ,nvl(n.interestrate, o.interestrate) as interestrate -- 保证金协议利率
    ,nvl(n.zfsxfs, o.zfsxfs) as zfsxfs -- 政府授信支持方式
    ,nvl(n.lcsum, o.lcsum) as lcsum -- 信用证金额（元）
    ,nvl(n.businessinvoicetype, o.businessinvoicetype) as businessinvoicetype -- 商业发票种类
    ,nvl(n.useproduct, o.useproduct) as useproduct -- 使用产品（贸易融资）
    ,nvl(n.issupplychainfinance, o.issupplychainfinance) as issupplychainfinance -- 是否为供应链金融业务
    ,nvl(n.fxfltp, o.fxfltp) as fxfltp -- 保证金利率类型
    ,nvl(n.supplychainfinancetype, o.supplychainfinancetype) as supplychainfinancetype -- 供应链金融业务产品分类
    ,nvl(n.tdtimes, o.tdtimes) as tdtimes -- 与交易对手成功交易次数
    ,nvl(n.otherarealoan, o.otherarealoan) as otherarealoan -- 是否异地业务
    ,nvl(n.purchaserregion, o.purchaserregion) as purchaserregion -- 买方所在地区
    ,nvl(n.mandatecustname, o.mandatecustname) as mandatecustname -- 委托人
    ,nvl(n.ifagreementflag, o.ifagreementflag) as ifagreementflag -- 是否协议付息
    ,nvl(n.iscareerguaranteeloan, o.iscareerguaranteeloan) as iscareerguaranteeloan -- 是否创业担保贷款
    ,nvl(n.beneficiarycountryname, o.beneficiarycountryname) as beneficiarycountryname -- 受益人所在国家或地区
    ,nvl(n.cargoinfo, o.cargoinfo) as cargoinfo -- 货物名称
    ,nvl(n.ifgudingcredit, o.ifgudingcredit) as ifgudingcredit -- 是否固定资产授信
    ,nvl(n.qtxkz, o.qtxkz) as qtxkz -- 其他许可证
    ,nvl(n.othercondition, o.othercondition) as othercondition -- 其他条件和要求
    ,nvl(n.interestmethod, o.interestmethod) as interestmethod -- 保证金计息方法
    ,nvl(n.isfarming, o.isfarming) as isfarming -- 是否涉农
    ,nvl(n.destination1, o.destination1) as destination1 -- 装运地
    ,nvl(n.costpersontype, o.costpersontype) as costpersontype -- 费用承担人
    ,nvl(n.gksxpz, o.gksxpz) as gksxpz -- 国开授信品种
    ,nvl(n.zbj, o.zbj) as zbj -- 资本金
    ,nvl(n.lxpw, o.lxpw) as lxpw -- 立项批文
    ,nvl(n.bailtransaccount, o.bailtransaccount) as bailtransaccount -- 保证金转出帐号
    ,nvl(n.restbalancesum, o.restbalancesum) as restbalancesum -- 打包成数(%)
    ,nvl(n.businessinvoicecurrency, o.businessinvoicecurrency) as businessinvoicecurrency -- 商业发票币种
    ,nvl(n.drawingtype, o.drawingtype) as drawingtype -- 提款方式
    ,nvl(n.platformpaycashsource, o.platformpaycashsource) as platformpaycashsource -- 地方融资平台偿债资金来源分类
    ,nvl(n.lcpaymethod, o.lcpaymethod) as lcpaymethod -- 付款方式
    ,nvl(n.discountcusttype, o.discountcusttype) as discountcusttype -- 贴现申请人种类
    ,nvl(n.loantradesum, o.loantradesum) as loantradesum -- 贷款用途交易金额
    ,nvl(n.pdrifd, o.pdrifd) as pdrifd -- 保证金利率浮动类型
    ,nvl(n.lcno, o.lcno) as lcno -- 信用证编号
    ,nvl(n.drawingremark, o.drawingremark) as drawingremark -- 提款说明
    ,nvl(n.moneytype, o.moneytype) as moneytype -- 委托存款钞汇类别
    ,nvl(n.sfzfsx, o.sfzfsx) as sfzfsx -- 是否政府授信
    ,nvl(n.toindustryfund, o.toindustryfund) as toindustryfund -- 是否投向产业基金
    ,nvl(n.isgovernfinance, o.isgovernfinance) as isgovernfinance -- 是否涉及政府类融资
    ,nvl(n.farmingloandirect, o.farmingloandirect) as farmingloandirect -- 涉农贷款投向
    ,nvl(n.tdstrenth, o.tdstrenth) as tdstrenth -- 交易对手实力
    ,nvl(n.paymentname, o.paymentname) as paymentname -- 付息方
    ,nvl(n.mandatesource, o.mandatesource) as mandatesource -- 委托贷款资金来源
    ,nvl(n.purchasername, o.purchasername) as purchasername -- 买方名称
    ,nvl(n.productlevel, o.productlevel) as productlevel -- 产品分级级别
    ,nvl(n.kgrq, o.kgrq) as kgrq -- 开工日期
    ,nvl(n.noticebankname, o.noticebankname) as noticebankname -- 通知行
    ,nvl(n.directionrs, o.directionrs) as directionrs -- 行业投向(征信)
    ,nvl(n.gshy, o.gshy) as gshy -- 过剩行业
    ,nvl(n.lcquality, o.lcquality) as lcquality -- 信用证性质
    ,nvl(n.offerbilldate, o.offerbilldate) as offerbilldate -- 提供单据日期
    ,nvl(n.financesupportmode, o.financesupportmode) as financesupportmode -- 贷款财政扶持方式
    ,nvl(n.pwwh, o.pwwh) as pwwh -- 批文文号
    ,nvl(n.realestateloantype, o.realestateloantype) as realestateloantype -- 房地产贷款类型
    ,nvl(n.isyfreceive, o.isyfreceive) as isyfreceive -- 是否预付应收帐款
    ,nvl(n.corpuspaymethod, o.corpuspaymethod) as corpuspaymethod -- 还款方式
    ,nvl(n.mfeeratio, o.mfeeratio) as mfeeratio -- 其他费率(‰)
    ,nvl(n.acceptbankname, o.acceptbankname) as acceptbankname -- 承兑行名称
    ,nvl(n.businessinvoiceinfo, o.businessinvoiceinfo) as businessinvoiceinfo -- 商业发票号码
    ,nvl(n.jsydxkzbh, o.jsydxkzbh) as jsydxkzbh -- 建设用地许可证编号
    ,nvl(n.mandatecustid, o.mandatecustid) as mandatecustid -- 委托人客户
    ,nvl(n.oldlcloadingdate, o.oldlcloadingdate) as oldlcloadingdate -- 装运日期
    ,nvl(n.isrz, o.isrz) as isrz -- 是否融资合同
    ,nvl(n.isimportantloan, o.isimportantloan) as isimportantloan -- 是否重点项目贷款
    ,nvl(n.tdyears, o.tdyears) as tdyears -- 与交易对手合作年限
    ,nvl(n.destination2, o.destination2) as destination2 -- 货物运输目的地
    ,nvl(n.farmingloantype, o.farmingloantype) as farmingloantype -- 涉农贷款主体类型
    ,nvl(n.pdrifm, o.pdrifm) as pdrifm -- 保证金利率浮动方式
    ,nvl(n.tradingassets, o.tradingassets) as tradingassets -- 交易资产
    ,nvl(n.farmingsubjecttype, o.farmingsubjecttype) as farmingsubjecttype -- 涉农贷款主体类型
    ,nvl(n.lccdflag, o.lccdflag) as lccdflag -- 远期信用证是否已承兑
    ,nvl(n.lcapplyserialno, o.lcapplyserialno) as lcapplyserialno -- 开证申请书编号
    ,nvl(n.issjorcs, o.issjorcs) as issjorcs -- 是否三旧改造或城市更新项目
    ,nvl(n.bailcurrency, o.bailcurrency) as bailcurrency -- 保证金币种
    ,nvl(n.duepaymethod, o.duepaymethod) as duepaymethod -- 应收帐款预付方式
    ,nvl(n.consignmentloandirect, o.consignmentloandirect) as consignmentloandirect -- 委托贷款特殊投向
    ,nvl(n.loantraderatio, o.loantraderatio) as loantraderatio -- 贷款金额占交易价款比例(%)
    ,nvl(n.discountdrafttype, o.discountdrafttype) as discountdrafttype -- 贴现的商业承兑汇票类别
    ,nvl(n.creditattribute, o.creditattribute) as creditattribute -- 合同类型
    ,nvl(n.sgxkzbh, o.sgxkzbh) as sgxkzbh -- 施工许可证编号
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 担保/操作模式(担保切分必选项)
    ,nvl(n.fundsource, o.fundsource) as fundsource -- 资金来源
    ,nvl(n.factoringtype, o.factoringtype) as factoringtype -- 保理类型
    ,nvl(n.pdrifv, o.pdrifv) as pdrifv -- 保证金浮动值
    ,nvl(n.bondno, o.bondno) as bondno -- 标的产品编号
    ,nvl(n.lctype, o.lctype) as lctype -- 信用证种类
    ,nvl(n.financier, o.financier) as financier -- 实际融资人
    ,nvl(n.businessprop, o.businessprop) as businessprop -- 放款成数(%)
    ,nvl(n.isdebttoequity, o.isdebttoequity) as isdebttoequity -- 是否投向市场化债转股
    ,nvl(n.guaranteehprojecttype, o.guaranteehprojecttype) as guaranteehprojecttype -- 保障性安居工程贷款类型LoanPurposeType
    ,nvl(n.landuseno, o.landuseno) as landuseno -- 土地使用证编号
    ,nvl(n.landusedate, o.landusedate) as landusedate -- 土地使用证日期
    ,nvl(n.landplanpermitno, o.landplanpermitno) as landplanpermitno -- 用地规划许可证编号
    ,nvl(n.landplanpermitdate, o.landplanpermitdate) as landplanpermitdate -- 用地规划许可证日期
    ,nvl(n.constructpermitdate, o.constructpermitdate) as constructpermitdate -- 施工许可证日期
    ,nvl(n.projectplanpermitdate, o.projectplanpermitdate) as projectplanpermitdate -- 工程规划许可证日期
    ,nvl(n.buyername, o.buyername) as buyername -- 购货方名称
    ,nvl(n.sellername, o.sellername) as sellername -- 销货方名称
    ,nvl(n.tradetransactioncontent, o.tradetransactioncontent) as tradetransactioncontent -- 贸易交易内容
    ,nvl(n.transferacc, o.transferacc) as transferacc -- 应收账款转让方式 码值:TransferBL
    ,nvl(n.isprojectfinancing, o.isprojectfinancing) as isprojectfinancing -- 是否项目融资
    ,nvl(n.jsydxkzrq, o.jsydxkzrq) as jsydxkzrq -- 建设用地许可证日期
    ,nvl(n.projectname, o.projectname) as projectname -- 项目名称
    ,nvl(n.advancedmanuflag, o.advancedmanuflag) as advancedmanuflag -- 先进制造业标志（0-否，1-是）
    ,nvl(n.cultureindustryflag, o.cultureindustryflag) as cultureindustryflag -- 文化产业标志（0-否，1-是）
    ,nvl(n.industrialrestructuringtype, o.industrialrestructuringtype) as industrialrestructuringtype -- 客户产业结构调整类型
    ,nvl(n.onlynewentflag, o.onlynewentflag) as onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
    ,nvl(n.onlynewsmallentflag, o.onlynewsmallentflag) as onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
    ,nvl(n.strategicemergingindustrytype, o.strategicemergingindustrytype) as strategicemergingindustrytype -- 战略性新兴产业类型
    ,nvl(n.transformationandupgradeid, o.transformationandupgradeid) as transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
    ,nvl(n.interestrepaycycle, o.interestrepaycycle) as interestrepaycycle -- 结息方式
    ,nvl(n.operationstartdate, o.operationstartdate) as operationstartdate -- 运营开始日期
    ,nvl(n.isoverssocipproj, o.isoverssocipproj) as isoverssocipproj -- 是否投向政府和社会资本合作（PPP）项目
    ,nvl(n.isnewmechissueloan, o.isnewmechissueloan) as isnewmechissueloan -- 是否新机制发放贷款
    ,nvl(n.iscoverdbbalance, o.iscoverdbbalance) as iscoverdbbalance -- 预测现金流是否覆盖借款余额
    ,nvl(n.isadvancedindustry, o.isadvancedindustry) as isadvancedindustry -- 是否高技术服务业贷款
    ,nvl(n.advancedindustryloantype, o.advancedindustryloantype) as advancedindustryloantype -- 高技术服务业贷款类型
    ,nvl(n.guarantybailsubaccount, o.guarantybailsubaccount) as guarantybailsubaccount -- 
    ,nvl(n.limitcoreent, o.limitcoreent) as limitcoreent -- 
    ,nvl(n.paymentaccount, o.paymentaccount) as paymentaccount -- 
    ,nvl(n.factoringcredittype, o.factoringcredittype) as factoringcredittype -- 
    ,nvl(n.belongitem, o.belongitem) as belongitem -- 
    ,nvl(n.lcsumrate, o.lcsumrate) as lcsumrate -- 
    ,nvl(n.maxpdrifv, o.maxpdrifv) as maxpdrifv -- 
    ,nvl(n.isguaranteeloan, o.isguaranteeloan) as isguaranteeloan -- 
    ,nvl(n.collectionnumbers, o.collectionnumbers) as collectionnumbers -- 
    ,nvl(n.remittancenumbers, o.remittancenumbers) as remittancenumbers -- 
    ,nvl(n.lcloanflag, o.lcloanflag) as lcloanflag -- 
    ,nvl(n.scanstatus, o.scanstatus) as scanstatus -- 
    ,nvl(n.discountrate, o.discountrate) as discountrate -- 
    ,nvl(n.tradcontractno, o.tradcontractno) as tradcontractno -- 
    ,nvl(n.claimterm, o.claimterm) as claimterm -- 
    ,nvl(n.agentbankname, o.agentbankname) as agentbankname -- 
    ,nvl(n.agentbankno, o.agentbankno) as agentbankno -- 
    ,nvl(n.issuedbusinessno, o.issuedbusinessno) as issuedbusinessno -- 
    ,nvl(n.confirmbankname, o.confirmbankname) as confirmbankname -- 
    ,nvl(n.confirmbankid, o.confirmbankid) as confirmbankid -- 
    ,nvl(n.guaranteetype, o.guaranteetype) as guaranteetype -- 
    ,nvl(n.guaranteesum, o.guaranteesum) as guaranteesum -- 
    ,nvl(n.finishterm, o.finishterm) as finishterm -- 
    ,nvl(n.proquestionupdatedate, o.proquestionupdatedate) as proquestionupdatedate -- 
    ,nvl(n.scanuserid, o.scanuserid) as scanuserid -- 
    ,nvl(n.scanusername, o.scanusername) as scanusername -- 
    ,nvl(n.bizuniqueno, o.bizuniqueno) as bizuniqueno -- 
    ,nvl(n.ratestartmode, o.ratestartmode) as ratestartmode -- 
    ,nvl(n.compoundintflag, o.compoundintflag) as compoundintflag -- 
    ,nvl(n.compoundintfloatvalue, o.compoundintfloatvalue) as compoundintfloatvalue -- 
    ,nvl(n.compoundintratio, o.compoundintratio) as compoundintratio -- 
    ,nvl(n.stopintflag, o.stopintflag) as stopintflag -- 
    ,nvl(n.tagcompleteflag, o.tagcompleteflag) as tagcompleteflag -- 
    ,nvl(n.capitalsourcebailtransaccount, o.capitalsourcebailtransaccount) as capitalsourcebailtransaccount -- 
    ,nvl(n.capitalsourcebailsum, o.capitalsourcebailsum) as capitalsourcebailsum -- 
    ,nvl(n.capitalsourcebustype, o.capitalsourcebustype) as capitalsourcebustype -- 
    ,nvl(n.stoppayacct, o.stoppayacct) as stoppayacct -- 
    ,nvl(n.subacctnum, o.subacctnum) as subacctnum -- 
    ,nvl(n.depositsum, o.depositsum) as depositsum -- 
    ,nvl(n.xztflag, o.xztflag) as xztflag -- 
    ,nvl(n.isrealestateloan, o.isrealestateloan) as isrealestateloan -- 是否属于房地产开发贷款
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
from (select * from ${iol_schema}.icms_bc_extend_d_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bc_extend_d where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.locfinancefundsource <> n.locfinancefundsource
        or o.projectartificialno <> n.projectartificialno
        or o.creditincrementtype <> n.creditincrementtype
        or o.isforeign <> n.isforeign
        or o.isyfconfirmed <> n.isyfconfirmed
        or o.isventureguaranty <> n.isventureguaranty
        or o.ventureguarantytype <> n.ventureguarantytype
        or o.rateexplain <> n.rateexplain
        or o.lctermtype <> n.lctermtype
        or o.qtxkzbh <> n.qtxkzbh
        or o.graceperiod <> n.graceperiod
        or o.lcopertype <> n.lcopertype
        or o.rivalname <> n.rivalname
        or o.outradio <> n.outradio
        or o.tradesum <> n.tradesum
        or o.careerguaranteeloantype <> n.careerguaranteeloantype
        or o.proposerpaymentscale <> n.proposerpaymentscale
        or o.putoutorgid <> n.putoutorgid
        or o.farmingloanuse <> n.farmingloanuse
        or o.oldlccurrency <> n.oldlccurrency
        or o.tradecurrency <> n.tradecurrency
        or o.totalcast <> n.totalcast
        or o.zfsxlx <> n.zfsxlx
        or o.xmztz <> n.xmztz
        or o.ghxkzbh <> n.ghxkzbh
        or o.discountratenote <> n.discountratenote
        or o.ifqueryflag <> n.ifqueryflag
        or o.yffdkje <> n.yffdkje
        or o.billnum <> n.billnum
        or o.lccurrency <> n.lccurrency
        or o.loanhandlechannel <> n.loanhandlechannel
        or o.mainproduct <> n.mainproduct
        or o.repayremark <> n.repayremark
        or o.iscounterparty <> n.iscounterparty
        or o.consigneecerttype <> n.consigneecerttype
        or o.hasoutradio <> n.hasoutradio
        or o.migtflag <> n.migtflag
        or o.mandatedepacctno <> n.mandatedepacctno
        or o.productcollectmoney <> n.productcollectmoney
        or o.thirdpartyaccounts <> n.thirdpartyaccounts
        or o.beneficiaryname <> n.beneficiaryname
        or o.oldlcno <> n.oldlcno
        or o.guarantybailaccount <> n.guarantybailaccount
        or o.businessinvoicesum <> n.businessinvoicesum
        or o.importantloan <> n.importantloan
        or o.hpxkzbh <> n.hpxkzbh
        or o.discountsum <> n.discountsum
        or o.classifyfrequency <> n.classifyfrequency
        or o.contextinfo <> n.contextinfo
        or o.purchaserpayintratio <> n.purchaserpayintratio
        or o.thirdparty1type <> n.thirdparty1type
        or o.sfgksx <> n.sfgksx
        or o.consigneename <> n.consigneename
        or o.consigneecertid <> n.consigneecertid
        or o.registerinotherbank <> n.registerinotherbank
        or o.securitiestype <> n.securitiestype
        or o.termcd <> n.termcd
        or o.tradecontractno <> n.tradecontractno
        or o.sfgjxzhy <> n.sfgjxzhy
        or o.isconsumerfinance <> n.isconsumerfinance
        or o.oldlcsum <> n.oldlcsum
        or o.bailaccount <> n.bailaccount
        or o.loanquality <> n.loanquality
        or o.interestrate <> n.interestrate
        or o.zfsxfs <> n.zfsxfs
        or o.lcsum <> n.lcsum
        or o.businessinvoicetype <> n.businessinvoicetype
        or o.useproduct <> n.useproduct
        or o.issupplychainfinance <> n.issupplychainfinance
        or o.fxfltp <> n.fxfltp
        or o.supplychainfinancetype <> n.supplychainfinancetype
        or o.tdtimes <> n.tdtimes
        or o.otherarealoan <> n.otherarealoan
        or o.purchaserregion <> n.purchaserregion
        or o.mandatecustname <> n.mandatecustname
        or o.ifagreementflag <> n.ifagreementflag
        or o.iscareerguaranteeloan <> n.iscareerguaranteeloan
        or o.beneficiarycountryname <> n.beneficiarycountryname
        or o.cargoinfo <> n.cargoinfo
        or o.ifgudingcredit <> n.ifgudingcredit
        or o.qtxkz <> n.qtxkz
        or o.othercondition <> n.othercondition
        or o.interestmethod <> n.interestmethod
        or o.isfarming <> n.isfarming
        or o.destination1 <> n.destination1
        or o.costpersontype <> n.costpersontype
        or o.gksxpz <> n.gksxpz
        or o.zbj <> n.zbj
        or o.lxpw <> n.lxpw
        or o.bailtransaccount <> n.bailtransaccount
        or o.restbalancesum <> n.restbalancesum
        or o.businessinvoicecurrency <> n.businessinvoicecurrency
        or o.drawingtype <> n.drawingtype
        or o.platformpaycashsource <> n.platformpaycashsource
        or o.lcpaymethod <> n.lcpaymethod
        or o.discountcusttype <> n.discountcusttype
        or o.loantradesum <> n.loantradesum
        or o.pdrifd <> n.pdrifd
        or o.lcno <> n.lcno
        or o.drawingremark <> n.drawingremark
        or o.moneytype <> n.moneytype
        or o.sfzfsx <> n.sfzfsx
        or o.toindustryfund <> n.toindustryfund
        or o.isgovernfinance <> n.isgovernfinance
        or o.farmingloandirect <> n.farmingloandirect
        or o.tdstrenth <> n.tdstrenth
        or o.paymentname <> n.paymentname
        or o.mandatesource <> n.mandatesource
        or o.purchasername <> n.purchasername
        or o.productlevel <> n.productlevel
        or o.kgrq <> n.kgrq
        or o.noticebankname <> n.noticebankname
        or o.directionrs <> n.directionrs
        or o.gshy <> n.gshy
        or o.lcquality <> n.lcquality
        or o.offerbilldate <> n.offerbilldate
        or o.financesupportmode <> n.financesupportmode
        or o.pwwh <> n.pwwh
        or o.realestateloantype <> n.realestateloantype
        or o.isyfreceive <> n.isyfreceive
        or o.corpuspaymethod <> n.corpuspaymethod
        or o.mfeeratio <> n.mfeeratio
        or o.acceptbankname <> n.acceptbankname
        or o.businessinvoiceinfo <> n.businessinvoiceinfo
        or o.jsydxkzbh <> n.jsydxkzbh
        or o.mandatecustid <> n.mandatecustid
        or o.oldlcloadingdate <> n.oldlcloadingdate
        or o.isrz <> n.isrz
        or o.isimportantloan <> n.isimportantloan
        or o.tdyears <> n.tdyears
        or o.destination2 <> n.destination2
        or o.farmingloantype <> n.farmingloantype
        or o.pdrifm <> n.pdrifm
        or o.tradingassets <> n.tradingassets
        or o.farmingsubjecttype <> n.farmingsubjecttype
        or o.lccdflag <> n.lccdflag
        or o.lcapplyserialno <> n.lcapplyserialno
        or o.issjorcs <> n.issjorcs
        or o.bailcurrency <> n.bailcurrency
        or o.duepaymethod <> n.duepaymethod
        or o.consignmentloandirect <> n.consignmentloandirect
        or o.loantraderatio <> n.loantraderatio
        or o.discountdrafttype <> n.discountdrafttype
        or o.creditattribute <> n.creditattribute
        or o.sgxkzbh <> n.sgxkzbh
        or o.guarantytype <> n.guarantytype
        or o.fundsource <> n.fundsource
        or o.factoringtype <> n.factoringtype
        or o.pdrifv <> n.pdrifv
        or o.bondno <> n.bondno
        or o.lctype <> n.lctype
        or o.financier <> n.financier
        or o.businessprop <> n.businessprop
        or o.isdebttoequity <> n.isdebttoequity
        or o.guaranteehprojecttype <> n.guaranteehprojecttype
        or o.landuseno <> n.landuseno
        or o.landusedate <> n.landusedate
        or o.landplanpermitno <> n.landplanpermitno
        or o.landplanpermitdate <> n.landplanpermitdate
        or o.constructpermitdate <> n.constructpermitdate
        or o.projectplanpermitdate <> n.projectplanpermitdate
        or o.buyername <> n.buyername
        or o.sellername <> n.sellername
        or o.tradetransactioncontent <> n.tradetransactioncontent
        or o.transferacc <> n.transferacc
        or o.isprojectfinancing <> n.isprojectfinancing
        or o.jsydxkzrq <> n.jsydxkzrq
        or o.projectname <> n.projectname
        or o.advancedmanuflag <> n.advancedmanuflag
        or o.cultureindustryflag <> n.cultureindustryflag
        or o.industrialrestructuringtype <> n.industrialrestructuringtype
        or o.onlynewentflag <> n.onlynewentflag
        or o.onlynewsmallentflag <> n.onlynewsmallentflag
        or o.strategicemergingindustrytype <> n.strategicemergingindustrytype
        or o.transformationandupgradeid <> n.transformationandupgradeid
        or o.interestrepaycycle <> n.interestrepaycycle
        or o.operationstartdate <> n.operationstartdate
        or o.isoverssocipproj <> n.isoverssocipproj
        or o.isnewmechissueloan <> n.isnewmechissueloan
        or o.iscoverdbbalance <> n.iscoverdbbalance
        or o.isadvancedindustry <> n.isadvancedindustry
        or o.advancedindustryloantype <> n.advancedindustryloantype
        or o.guarantybailsubaccount <> n.guarantybailsubaccount
        or o.limitcoreent <> n.limitcoreent
        or o.paymentaccount <> n.paymentaccount
        or o.factoringcredittype <> n.factoringcredittype
        or o.belongitem <> n.belongitem
        or o.lcsumrate <> n.lcsumrate
        or o.maxpdrifv <> n.maxpdrifv
        or o.isguaranteeloan <> n.isguaranteeloan
        or o.collectionnumbers <> n.collectionnumbers
        or o.remittancenumbers <> n.remittancenumbers
        or o.lcloanflag <> n.lcloanflag
        or o.scanstatus <> n.scanstatus
        or o.discountrate <> n.discountrate
        or o.tradcontractno <> n.tradcontractno
        or o.claimterm <> n.claimterm
        or o.agentbankname <> n.agentbankname
        or o.agentbankno <> n.agentbankno
        or o.issuedbusinessno <> n.issuedbusinessno
        or o.confirmbankname <> n.confirmbankname
        or o.confirmbankid <> n.confirmbankid
        or o.guaranteetype <> n.guaranteetype
        or o.guaranteesum <> n.guaranteesum
        or o.finishterm <> n.finishterm
        or o.proquestionupdatedate <> n.proquestionupdatedate
        or o.scanuserid <> n.scanuserid
        or o.scanusername <> n.scanusername
        or o.bizuniqueno <> n.bizuniqueno
        or o.ratestartmode <> n.ratestartmode
        or o.compoundintflag <> n.compoundintflag
        or o.compoundintfloatvalue <> n.compoundintfloatvalue
        or o.compoundintratio <> n.compoundintratio
        or o.stopintflag <> n.stopintflag
        or o.tagcompleteflag <> n.tagcompleteflag
        or o.capitalsourcebailtransaccount <> n.capitalsourcebailtransaccount
        or o.capitalsourcebailsum <> n.capitalsourcebailsum
        or o.capitalsourcebustype <> n.capitalsourcebustype
        or o.stoppayacct <> n.stoppayacct
        or o.subacctnum <> n.subacctnum
        or o.depositsum <> n.depositsum
        or o.xztflag <> n.xztflag
        or o.isrealestateloan <> n.isrealestateloan
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bc_extend_d_cl(
            serialno -- 合同编号
            ,locfinancefundsource -- 地方融资平台偿债资金来源分类
            ,projectartificialno -- 项目信息文本号
            ,creditincrementtype -- 主要增信方式
            ,isforeign -- 是否境外贷款
            ,isyfconfirmed -- 是否经议付行确认
            ,isventureguaranty -- 是否创业担保贷款
            ,ventureguarantytype -- 创业担保贷款类型
            ,rateexplain -- 利率/费率说明
            ,lctermtype -- 信用证期限类型
            ,qtxkzbh -- 其他许可证编号
            ,graceperiod -- 远期付款期限(天)
            ,lcopertype -- 信用证类型
            ,rivalname -- 交易对手名称
            ,outradio -- 溢短装比例（%）
            ,tradesum -- 贸易合同总金额(元)
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,proposerpaymentscale -- 贴现利息申请人支付比例(%)
            ,putoutorgid -- 放贷机构
            ,farmingloanuse -- 涉农贷款投向
            ,oldlccurrency -- 母证币种
            ,tradecurrency -- 委托存款币种
            ,totalcast -- 货物标的
            ,zfsxlx -- 政府授信类型
            ,xmztz -- 项目总投资
            ,ghxkzbh -- 规划许可证编号
            ,discountratenote -- 贴现利率说明
            ,ifqueryflag -- 是否先贴后查
            ,yffdkje -- 银团已发放贷款金额(元)
            ,billnum -- 汇票数量(张)
            ,lccurrency -- 信用证币种
            ,loanhandlechannel -- 贷款办理渠道
            ,mainproduct -- 经营商品（贸易融资）
            ,repayremark -- 还款说明
            ,iscounterparty -- 是否合格中央交易对手
            ,consigneecerttype -- 管理人/主承销商证件类型
            ,hasoutradio -- 是否存在溢短装的条款
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,mandatedepacctno -- 委托存款帐户
            ,productcollectmoney -- 产品募集金额
            ,thirdpartyaccounts -- 提单号码
            ,beneficiaryname -- 受益人名称
            ,oldlcno -- 母证编号
            ,guarantybailaccount -- 押品转保证金账号
            ,businessinvoicesum -- 商业发票金额
            ,importantloan -- 重点贷款项目
            ,hpxkzbh -- 环评许可证编号
            ,discountsum -- 应收帐款净额(元)
            ,classifyfrequency -- 检查频率
            ,contextinfo -- 交易背景描述
            ,purchaserpayintratio -- 贴现利息买方承担比例(%)
            ,thirdparty1type -- 代付类型
            ,sfgksx -- 是否国开行授信
            ,consigneename -- 管理人/主承销商
            ,consigneecertid -- 管理人/主承销商证件号码
            ,registerinotherbank -- 是否他行代开
            ,securitiestype -- 运输方式
            ,termcd -- 保证金利率档次
            ,tradecontractno -- 贸易合同号
            ,sfgjxzhy -- 是否国家限制行业
            ,isconsumerfinance -- 是否为消费服务类融资
            ,oldlcsum -- 母证金额
            ,bailaccount -- 保证金帐号
            ,loanquality -- 贷款性质
            ,interestrate -- 保证金协议利率
            ,zfsxfs -- 政府授信支持方式
            ,lcsum -- 信用证金额（元）
            ,businessinvoicetype -- 商业发票种类
            ,useproduct -- 使用产品（贸易融资）
            ,issupplychainfinance -- 是否为供应链金融业务
            ,fxfltp -- 保证金利率类型
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,tdtimes -- 与交易对手成功交易次数
            ,otherarealoan -- 是否异地业务
            ,purchaserregion -- 买方所在地区
            ,mandatecustname -- 委托人
            ,ifagreementflag -- 是否协议付息
            ,iscareerguaranteeloan -- 是否创业担保贷款
            ,beneficiarycountryname -- 受益人所在国家或地区
            ,cargoinfo -- 货物名称
            ,ifgudingcredit -- 是否固定资产授信
            ,qtxkz -- 其他许可证
            ,othercondition -- 其他条件和要求
            ,interestmethod -- 保证金计息方法
            ,isfarming -- 是否涉农
            ,destination1 -- 装运地
            ,costpersontype -- 费用承担人
            ,gksxpz -- 国开授信品种
            ,zbj -- 资本金
            ,lxpw -- 立项批文
            ,bailtransaccount -- 保证金转出帐号
            ,restbalancesum -- 打包成数(%)
            ,businessinvoicecurrency -- 商业发票币种
            ,drawingtype -- 提款方式
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,lcpaymethod -- 付款方式
            ,discountcusttype -- 贴现申请人种类
            ,loantradesum -- 贷款用途交易金额
            ,pdrifd -- 保证金利率浮动类型
            ,lcno -- 信用证编号
            ,drawingremark -- 提款说明
            ,moneytype -- 委托存款钞汇类别
            ,sfzfsx -- 是否政府授信
            ,toindustryfund -- 是否投向产业基金
            ,isgovernfinance -- 是否涉及政府类融资
            ,farmingloandirect -- 涉农贷款投向
            ,tdstrenth -- 交易对手实力
            ,paymentname -- 付息方
            ,mandatesource -- 委托贷款资金来源
            ,purchasername -- 买方名称
            ,productlevel -- 产品分级级别
            ,kgrq -- 开工日期
            ,noticebankname -- 通知行
            ,directionrs -- 行业投向(征信)
            ,gshy -- 过剩行业
            ,lcquality -- 信用证性质
            ,offerbilldate -- 提供单据日期
            ,financesupportmode -- 贷款财政扶持方式
            ,pwwh -- 批文文号
            ,realestateloantype -- 房地产贷款类型
            ,isyfreceive -- 是否预付应收帐款
            ,corpuspaymethod -- 还款方式
            ,mfeeratio -- 其他费率(‰)
            ,acceptbankname -- 承兑行名称
            ,businessinvoiceinfo -- 商业发票号码
            ,jsydxkzbh -- 建设用地许可证编号
            ,mandatecustid -- 委托人客户
            ,oldlcloadingdate -- 装运日期
            ,isrz -- 是否融资合同
            ,isimportantloan -- 是否重点项目贷款
            ,tdyears -- 与交易对手合作年限
            ,destination2 -- 货物运输目的地
            ,farmingloantype -- 涉农贷款主体类型
            ,pdrifm -- 保证金利率浮动方式
            ,tradingassets -- 交易资产
            ,farmingsubjecttype -- 涉农贷款主体类型
            ,lccdflag -- 远期信用证是否已承兑
            ,lcapplyserialno -- 开证申请书编号
            ,issjorcs -- 是否三旧改造或城市更新项目
            ,bailcurrency -- 保证金币种
            ,duepaymethod -- 应收帐款预付方式
            ,consignmentloandirect -- 委托贷款特殊投向
            ,loantraderatio -- 贷款金额占交易价款比例(%)
            ,discountdrafttype -- 贴现的商业承兑汇票类别
            ,creditattribute -- 合同类型
            ,sgxkzbh -- 施工许可证编号
            ,guarantytype -- 担保/操作模式(担保切分必选项)
            ,fundsource -- 资金来源
            ,factoringtype -- 保理类型
            ,pdrifv -- 保证金浮动值
            ,bondno -- 标的产品编号
            ,lctype -- 信用证种类
            ,financier -- 实际融资人
            ,businessprop -- 放款成数(%)
            ,isdebttoequity -- 是否投向市场化债转股
            ,guaranteehprojecttype -- 保障性安居工程贷款类型LoanPurposeType
            ,landuseno -- 土地使用证编号
            ,landusedate -- 土地使用证日期
            ,landplanpermitno -- 用地规划许可证编号
            ,landplanpermitdate -- 用地规划许可证日期
            ,constructpermitdate -- 施工许可证日期
            ,projectplanpermitdate -- 工程规划许可证日期
            ,buyername -- 购货方名称
            ,sellername -- 销货方名称
            ,tradetransactioncontent -- 贸易交易内容
            ,transferacc -- 应收账款转让方式 码值:TransferBL
            ,isprojectfinancing -- 是否项目融资
            ,jsydxkzrq -- 建设用地许可证日期
            ,projectname -- 项目名称
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,industrialrestructuringtype -- 客户产业结构调整类型
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,strategicemergingindustrytype -- 战略性新兴产业类型
            ,transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
            ,interestrepaycycle -- 结息方式
            ,operationstartdate -- 运营开始日期
            ,isoverssocipproj -- 是否投向政府和社会资本合作（PPP）项目
            ,isnewmechissueloan -- 是否新机制发放贷款
            ,iscoverdbbalance -- 预测现金流是否覆盖借款余额
            ,isadvancedindustry -- 是否高技术服务业贷款
            ,advancedindustryloantype -- 高技术服务业贷款类型
            ,guarantybailsubaccount -- 
            ,limitcoreent -- 
            ,paymentaccount -- 
            ,factoringcredittype -- 
            ,belongitem -- 
            ,lcsumrate -- 
            ,maxpdrifv -- 
            ,isguaranteeloan -- 
            ,collectionnumbers -- 
            ,remittancenumbers -- 
            ,lcloanflag -- 
            ,scanstatus -- 
            ,discountrate -- 
            ,tradcontractno -- 
            ,claimterm -- 
            ,agentbankname -- 
            ,agentbankno -- 
            ,issuedbusinessno -- 
            ,confirmbankname -- 
            ,confirmbankid -- 
            ,guaranteetype -- 
            ,guaranteesum -- 
            ,finishterm -- 
            ,proquestionupdatedate -- 
            ,scanuserid -- 
            ,scanusername -- 
            ,bizuniqueno -- 
            ,ratestartmode -- 
            ,compoundintflag -- 
            ,compoundintfloatvalue -- 
            ,compoundintratio -- 
            ,stopintflag -- 
            ,tagcompleteflag -- 
            ,capitalsourcebailtransaccount -- 
            ,capitalsourcebailsum -- 
            ,capitalsourcebustype -- 
            ,stoppayacct -- 
            ,subacctnum -- 
            ,depositsum -- 
            ,xztflag -- 
            ,isrealestateloan -- 是否属于房地产开发贷款
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bc_extend_d_op(
            serialno -- 合同编号
            ,locfinancefundsource -- 地方融资平台偿债资金来源分类
            ,projectartificialno -- 项目信息文本号
            ,creditincrementtype -- 主要增信方式
            ,isforeign -- 是否境外贷款
            ,isyfconfirmed -- 是否经议付行确认
            ,isventureguaranty -- 是否创业担保贷款
            ,ventureguarantytype -- 创业担保贷款类型
            ,rateexplain -- 利率/费率说明
            ,lctermtype -- 信用证期限类型
            ,qtxkzbh -- 其他许可证编号
            ,graceperiod -- 远期付款期限(天)
            ,lcopertype -- 信用证类型
            ,rivalname -- 交易对手名称
            ,outradio -- 溢短装比例（%）
            ,tradesum -- 贸易合同总金额(元)
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,proposerpaymentscale -- 贴现利息申请人支付比例(%)
            ,putoutorgid -- 放贷机构
            ,farmingloanuse -- 涉农贷款投向
            ,oldlccurrency -- 母证币种
            ,tradecurrency -- 委托存款币种
            ,totalcast -- 货物标的
            ,zfsxlx -- 政府授信类型
            ,xmztz -- 项目总投资
            ,ghxkzbh -- 规划许可证编号
            ,discountratenote -- 贴现利率说明
            ,ifqueryflag -- 是否先贴后查
            ,yffdkje -- 银团已发放贷款金额(元)
            ,billnum -- 汇票数量(张)
            ,lccurrency -- 信用证币种
            ,loanhandlechannel -- 贷款办理渠道
            ,mainproduct -- 经营商品（贸易融资）
            ,repayremark -- 还款说明
            ,iscounterparty -- 是否合格中央交易对手
            ,consigneecerttype -- 管理人/主承销商证件类型
            ,hasoutradio -- 是否存在溢短装的条款
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,mandatedepacctno -- 委托存款帐户
            ,productcollectmoney -- 产品募集金额
            ,thirdpartyaccounts -- 提单号码
            ,beneficiaryname -- 受益人名称
            ,oldlcno -- 母证编号
            ,guarantybailaccount -- 押品转保证金账号
            ,businessinvoicesum -- 商业发票金额
            ,importantloan -- 重点贷款项目
            ,hpxkzbh -- 环评许可证编号
            ,discountsum -- 应收帐款净额(元)
            ,classifyfrequency -- 检查频率
            ,contextinfo -- 交易背景描述
            ,purchaserpayintratio -- 贴现利息买方承担比例(%)
            ,thirdparty1type -- 代付类型
            ,sfgksx -- 是否国开行授信
            ,consigneename -- 管理人/主承销商
            ,consigneecertid -- 管理人/主承销商证件号码
            ,registerinotherbank -- 是否他行代开
            ,securitiestype -- 运输方式
            ,termcd -- 保证金利率档次
            ,tradecontractno -- 贸易合同号
            ,sfgjxzhy -- 是否国家限制行业
            ,isconsumerfinance -- 是否为消费服务类融资
            ,oldlcsum -- 母证金额
            ,bailaccount -- 保证金帐号
            ,loanquality -- 贷款性质
            ,interestrate -- 保证金协议利率
            ,zfsxfs -- 政府授信支持方式
            ,lcsum -- 信用证金额（元）
            ,businessinvoicetype -- 商业发票种类
            ,useproduct -- 使用产品（贸易融资）
            ,issupplychainfinance -- 是否为供应链金融业务
            ,fxfltp -- 保证金利率类型
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,tdtimes -- 与交易对手成功交易次数
            ,otherarealoan -- 是否异地业务
            ,purchaserregion -- 买方所在地区
            ,mandatecustname -- 委托人
            ,ifagreementflag -- 是否协议付息
            ,iscareerguaranteeloan -- 是否创业担保贷款
            ,beneficiarycountryname -- 受益人所在国家或地区
            ,cargoinfo -- 货物名称
            ,ifgudingcredit -- 是否固定资产授信
            ,qtxkz -- 其他许可证
            ,othercondition -- 其他条件和要求
            ,interestmethod -- 保证金计息方法
            ,isfarming -- 是否涉农
            ,destination1 -- 装运地
            ,costpersontype -- 费用承担人
            ,gksxpz -- 国开授信品种
            ,zbj -- 资本金
            ,lxpw -- 立项批文
            ,bailtransaccount -- 保证金转出帐号
            ,restbalancesum -- 打包成数(%)
            ,businessinvoicecurrency -- 商业发票币种
            ,drawingtype -- 提款方式
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,lcpaymethod -- 付款方式
            ,discountcusttype -- 贴现申请人种类
            ,loantradesum -- 贷款用途交易金额
            ,pdrifd -- 保证金利率浮动类型
            ,lcno -- 信用证编号
            ,drawingremark -- 提款说明
            ,moneytype -- 委托存款钞汇类别
            ,sfzfsx -- 是否政府授信
            ,toindustryfund -- 是否投向产业基金
            ,isgovernfinance -- 是否涉及政府类融资
            ,farmingloandirect -- 涉农贷款投向
            ,tdstrenth -- 交易对手实力
            ,paymentname -- 付息方
            ,mandatesource -- 委托贷款资金来源
            ,purchasername -- 买方名称
            ,productlevel -- 产品分级级别
            ,kgrq -- 开工日期
            ,noticebankname -- 通知行
            ,directionrs -- 行业投向(征信)
            ,gshy -- 过剩行业
            ,lcquality -- 信用证性质
            ,offerbilldate -- 提供单据日期
            ,financesupportmode -- 贷款财政扶持方式
            ,pwwh -- 批文文号
            ,realestateloantype -- 房地产贷款类型
            ,isyfreceive -- 是否预付应收帐款
            ,corpuspaymethod -- 还款方式
            ,mfeeratio -- 其他费率(‰)
            ,acceptbankname -- 承兑行名称
            ,businessinvoiceinfo -- 商业发票号码
            ,jsydxkzbh -- 建设用地许可证编号
            ,mandatecustid -- 委托人客户
            ,oldlcloadingdate -- 装运日期
            ,isrz -- 是否融资合同
            ,isimportantloan -- 是否重点项目贷款
            ,tdyears -- 与交易对手合作年限
            ,destination2 -- 货物运输目的地
            ,farmingloantype -- 涉农贷款主体类型
            ,pdrifm -- 保证金利率浮动方式
            ,tradingassets -- 交易资产
            ,farmingsubjecttype -- 涉农贷款主体类型
            ,lccdflag -- 远期信用证是否已承兑
            ,lcapplyserialno -- 开证申请书编号
            ,issjorcs -- 是否三旧改造或城市更新项目
            ,bailcurrency -- 保证金币种
            ,duepaymethod -- 应收帐款预付方式
            ,consignmentloandirect -- 委托贷款特殊投向
            ,loantraderatio -- 贷款金额占交易价款比例(%)
            ,discountdrafttype -- 贴现的商业承兑汇票类别
            ,creditattribute -- 合同类型
            ,sgxkzbh -- 施工许可证编号
            ,guarantytype -- 担保/操作模式(担保切分必选项)
            ,fundsource -- 资金来源
            ,factoringtype -- 保理类型
            ,pdrifv -- 保证金浮动值
            ,bondno -- 标的产品编号
            ,lctype -- 信用证种类
            ,financier -- 实际融资人
            ,businessprop -- 放款成数(%)
            ,isdebttoequity -- 是否投向市场化债转股
            ,guaranteehprojecttype -- 保障性安居工程贷款类型LoanPurposeType
            ,landuseno -- 土地使用证编号
            ,landusedate -- 土地使用证日期
            ,landplanpermitno -- 用地规划许可证编号
            ,landplanpermitdate -- 用地规划许可证日期
            ,constructpermitdate -- 施工许可证日期
            ,projectplanpermitdate -- 工程规划许可证日期
            ,buyername -- 购货方名称
            ,sellername -- 销货方名称
            ,tradetransactioncontent -- 贸易交易内容
            ,transferacc -- 应收账款转让方式 码值:TransferBL
            ,isprojectfinancing -- 是否项目融资
            ,jsydxkzrq -- 建设用地许可证日期
            ,projectname -- 项目名称
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,industrialrestructuringtype -- 客户产业结构调整类型
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,strategicemergingindustrytype -- 战略性新兴产业类型
            ,transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
            ,interestrepaycycle -- 结息方式
            ,operationstartdate -- 运营开始日期
            ,isoverssocipproj -- 是否投向政府和社会资本合作（PPP）项目
            ,isnewmechissueloan -- 是否新机制发放贷款
            ,iscoverdbbalance -- 预测现金流是否覆盖借款余额
            ,isadvancedindustry -- 是否高技术服务业贷款
            ,advancedindustryloantype -- 高技术服务业贷款类型
            ,guarantybailsubaccount -- 
            ,limitcoreent -- 
            ,paymentaccount -- 
            ,factoringcredittype -- 
            ,belongitem -- 
            ,lcsumrate -- 
            ,maxpdrifv -- 
            ,isguaranteeloan -- 
            ,collectionnumbers -- 
            ,remittancenumbers -- 
            ,lcloanflag -- 
            ,scanstatus -- 
            ,discountrate -- 
            ,tradcontractno -- 
            ,claimterm -- 
            ,agentbankname -- 
            ,agentbankno -- 
            ,issuedbusinessno -- 
            ,confirmbankname -- 
            ,confirmbankid -- 
            ,guaranteetype -- 
            ,guaranteesum -- 
            ,finishterm -- 
            ,proquestionupdatedate -- 
            ,scanuserid -- 
            ,scanusername -- 
            ,bizuniqueno -- 
            ,ratestartmode -- 
            ,compoundintflag -- 
            ,compoundintfloatvalue -- 
            ,compoundintratio -- 
            ,stopintflag -- 
            ,tagcompleteflag -- 
            ,capitalsourcebailtransaccount -- 
            ,capitalsourcebailsum -- 
            ,capitalsourcebustype -- 
            ,stoppayacct -- 
            ,subacctnum -- 
            ,depositsum -- 
            ,xztflag -- 
            ,isrealestateloan -- 是否属于房地产开发贷款
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 合同编号
    ,o.locfinancefundsource -- 地方融资平台偿债资金来源分类
    ,o.projectartificialno -- 项目信息文本号
    ,o.creditincrementtype -- 主要增信方式
    ,o.isforeign -- 是否境外贷款
    ,o.isyfconfirmed -- 是否经议付行确认
    ,o.isventureguaranty -- 是否创业担保贷款
    ,o.ventureguarantytype -- 创业担保贷款类型
    ,o.rateexplain -- 利率/费率说明
    ,o.lctermtype -- 信用证期限类型
    ,o.qtxkzbh -- 其他许可证编号
    ,o.graceperiod -- 远期付款期限(天)
    ,o.lcopertype -- 信用证类型
    ,o.rivalname -- 交易对手名称
    ,o.outradio -- 溢短装比例（%）
    ,o.tradesum -- 贸易合同总金额(元)
    ,o.careerguaranteeloantype -- 创业担保贷款类型
    ,o.proposerpaymentscale -- 贴现利息申请人支付比例(%)
    ,o.putoutorgid -- 放贷机构
    ,o.farmingloanuse -- 涉农贷款投向
    ,o.oldlccurrency -- 母证币种
    ,o.tradecurrency -- 委托存款币种
    ,o.totalcast -- 货物标的
    ,o.zfsxlx -- 政府授信类型
    ,o.xmztz -- 项目总投资
    ,o.ghxkzbh -- 规划许可证编号
    ,o.discountratenote -- 贴现利率说明
    ,o.ifqueryflag -- 是否先贴后查
    ,o.yffdkje -- 银团已发放贷款金额(元)
    ,o.billnum -- 汇票数量(张)
    ,o.lccurrency -- 信用证币种
    ,o.loanhandlechannel -- 贷款办理渠道
    ,o.mainproduct -- 经营商品（贸易融资）
    ,o.repayremark -- 还款说明
    ,o.iscounterparty -- 是否合格中央交易对手
    ,o.consigneecerttype -- 管理人/主承销商证件类型
    ,o.hasoutradio -- 是否存在溢短装的条款
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.mandatedepacctno -- 委托存款帐户
    ,o.productcollectmoney -- 产品募集金额
    ,o.thirdpartyaccounts -- 提单号码
    ,o.beneficiaryname -- 受益人名称
    ,o.oldlcno -- 母证编号
    ,o.guarantybailaccount -- 押品转保证金账号
    ,o.businessinvoicesum -- 商业发票金额
    ,o.importantloan -- 重点贷款项目
    ,o.hpxkzbh -- 环评许可证编号
    ,o.discountsum -- 应收帐款净额(元)
    ,o.classifyfrequency -- 检查频率
    ,o.contextinfo -- 交易背景描述
    ,o.purchaserpayintratio -- 贴现利息买方承担比例(%)
    ,o.thirdparty1type -- 代付类型
    ,o.sfgksx -- 是否国开行授信
    ,o.consigneename -- 管理人/主承销商
    ,o.consigneecertid -- 管理人/主承销商证件号码
    ,o.registerinotherbank -- 是否他行代开
    ,o.securitiestype -- 运输方式
    ,o.termcd -- 保证金利率档次
    ,o.tradecontractno -- 贸易合同号
    ,o.sfgjxzhy -- 是否国家限制行业
    ,o.isconsumerfinance -- 是否为消费服务类融资
    ,o.oldlcsum -- 母证金额
    ,o.bailaccount -- 保证金帐号
    ,o.loanquality -- 贷款性质
    ,o.interestrate -- 保证金协议利率
    ,o.zfsxfs -- 政府授信支持方式
    ,o.lcsum -- 信用证金额（元）
    ,o.businessinvoicetype -- 商业发票种类
    ,o.useproduct -- 使用产品（贸易融资）
    ,o.issupplychainfinance -- 是否为供应链金融业务
    ,o.fxfltp -- 保证金利率类型
    ,o.supplychainfinancetype -- 供应链金融业务产品分类
    ,o.tdtimes -- 与交易对手成功交易次数
    ,o.otherarealoan -- 是否异地业务
    ,o.purchaserregion -- 买方所在地区
    ,o.mandatecustname -- 委托人
    ,o.ifagreementflag -- 是否协议付息
    ,o.iscareerguaranteeloan -- 是否创业担保贷款
    ,o.beneficiarycountryname -- 受益人所在国家或地区
    ,o.cargoinfo -- 货物名称
    ,o.ifgudingcredit -- 是否固定资产授信
    ,o.qtxkz -- 其他许可证
    ,o.othercondition -- 其他条件和要求
    ,o.interestmethod -- 保证金计息方法
    ,o.isfarming -- 是否涉农
    ,o.destination1 -- 装运地
    ,o.costpersontype -- 费用承担人
    ,o.gksxpz -- 国开授信品种
    ,o.zbj -- 资本金
    ,o.lxpw -- 立项批文
    ,o.bailtransaccount -- 保证金转出帐号
    ,o.restbalancesum -- 打包成数(%)
    ,o.businessinvoicecurrency -- 商业发票币种
    ,o.drawingtype -- 提款方式
    ,o.platformpaycashsource -- 地方融资平台偿债资金来源分类
    ,o.lcpaymethod -- 付款方式
    ,o.discountcusttype -- 贴现申请人种类
    ,o.loantradesum -- 贷款用途交易金额
    ,o.pdrifd -- 保证金利率浮动类型
    ,o.lcno -- 信用证编号
    ,o.drawingremark -- 提款说明
    ,o.moneytype -- 委托存款钞汇类别
    ,o.sfzfsx -- 是否政府授信
    ,o.toindustryfund -- 是否投向产业基金
    ,o.isgovernfinance -- 是否涉及政府类融资
    ,o.farmingloandirect -- 涉农贷款投向
    ,o.tdstrenth -- 交易对手实力
    ,o.paymentname -- 付息方
    ,o.mandatesource -- 委托贷款资金来源
    ,o.purchasername -- 买方名称
    ,o.productlevel -- 产品分级级别
    ,o.kgrq -- 开工日期
    ,o.noticebankname -- 通知行
    ,o.directionrs -- 行业投向(征信)
    ,o.gshy -- 过剩行业
    ,o.lcquality -- 信用证性质
    ,o.offerbilldate -- 提供单据日期
    ,o.financesupportmode -- 贷款财政扶持方式
    ,o.pwwh -- 批文文号
    ,o.realestateloantype -- 房地产贷款类型
    ,o.isyfreceive -- 是否预付应收帐款
    ,o.corpuspaymethod -- 还款方式
    ,o.mfeeratio -- 其他费率(‰)
    ,o.acceptbankname -- 承兑行名称
    ,o.businessinvoiceinfo -- 商业发票号码
    ,o.jsydxkzbh -- 建设用地许可证编号
    ,o.mandatecustid -- 委托人客户
    ,o.oldlcloadingdate -- 装运日期
    ,o.isrz -- 是否融资合同
    ,o.isimportantloan -- 是否重点项目贷款
    ,o.tdyears -- 与交易对手合作年限
    ,o.destination2 -- 货物运输目的地
    ,o.farmingloantype -- 涉农贷款主体类型
    ,o.pdrifm -- 保证金利率浮动方式
    ,o.tradingassets -- 交易资产
    ,o.farmingsubjecttype -- 涉农贷款主体类型
    ,o.lccdflag -- 远期信用证是否已承兑
    ,o.lcapplyserialno -- 开证申请书编号
    ,o.issjorcs -- 是否三旧改造或城市更新项目
    ,o.bailcurrency -- 保证金币种
    ,o.duepaymethod -- 应收帐款预付方式
    ,o.consignmentloandirect -- 委托贷款特殊投向
    ,o.loantraderatio -- 贷款金额占交易价款比例(%)
    ,o.discountdrafttype -- 贴现的商业承兑汇票类别
    ,o.creditattribute -- 合同类型
    ,o.sgxkzbh -- 施工许可证编号
    ,o.guarantytype -- 担保/操作模式(担保切分必选项)
    ,o.fundsource -- 资金来源
    ,o.factoringtype -- 保理类型
    ,o.pdrifv -- 保证金浮动值
    ,o.bondno -- 标的产品编号
    ,o.lctype -- 信用证种类
    ,o.financier -- 实际融资人
    ,o.businessprop -- 放款成数(%)
    ,o.isdebttoequity -- 是否投向市场化债转股
    ,o.guaranteehprojecttype -- 保障性安居工程贷款类型LoanPurposeType
    ,o.landuseno -- 土地使用证编号
    ,o.landusedate -- 土地使用证日期
    ,o.landplanpermitno -- 用地规划许可证编号
    ,o.landplanpermitdate -- 用地规划许可证日期
    ,o.constructpermitdate -- 施工许可证日期
    ,o.projectplanpermitdate -- 工程规划许可证日期
    ,o.buyername -- 购货方名称
    ,o.sellername -- 销货方名称
    ,o.tradetransactioncontent -- 贸易交易内容
    ,o.transferacc -- 应收账款转让方式 码值:TransferBL
    ,o.isprojectfinancing -- 是否项目融资
    ,o.jsydxkzrq -- 建设用地许可证日期
    ,o.projectname -- 项目名称
    ,o.advancedmanuflag -- 先进制造业标志（0-否，1-是）
    ,o.cultureindustryflag -- 文化产业标志（0-否，1-是）
    ,o.industrialrestructuringtype -- 客户产业结构调整类型
    ,o.onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
    ,o.onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
    ,o.strategicemergingindustrytype -- 战略性新兴产业类型
    ,o.transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
    ,o.interestrepaycycle -- 结息方式
    ,o.operationstartdate -- 运营开始日期
    ,o.isoverssocipproj -- 是否投向政府和社会资本合作（PPP）项目
    ,o.isnewmechissueloan -- 是否新机制发放贷款
    ,o.iscoverdbbalance -- 预测现金流是否覆盖借款余额
    ,o.isadvancedindustry -- 是否高技术服务业贷款
    ,o.advancedindustryloantype -- 高技术服务业贷款类型
    ,o.guarantybailsubaccount -- 
    ,o.limitcoreent -- 
    ,o.paymentaccount -- 
    ,o.factoringcredittype -- 
    ,o.belongitem -- 
    ,o.lcsumrate -- 
    ,o.maxpdrifv -- 
    ,o.isguaranteeloan -- 
    ,o.collectionnumbers -- 
    ,o.remittancenumbers -- 
    ,o.lcloanflag -- 
    ,o.scanstatus -- 
    ,o.discountrate -- 
    ,o.tradcontractno -- 
    ,o.claimterm -- 
    ,o.agentbankname -- 
    ,o.agentbankno -- 
    ,o.issuedbusinessno -- 
    ,o.confirmbankname -- 
    ,o.confirmbankid -- 
    ,o.guaranteetype -- 
    ,o.guaranteesum -- 
    ,o.finishterm -- 
    ,o.proquestionupdatedate -- 
    ,o.scanuserid -- 
    ,o.scanusername -- 
    ,o.bizuniqueno -- 
    ,o.ratestartmode -- 
    ,o.compoundintflag -- 
    ,o.compoundintfloatvalue -- 
    ,o.compoundintratio -- 
    ,o.stopintflag -- 
    ,o.tagcompleteflag -- 
    ,o.capitalsourcebailtransaccount -- 
    ,o.capitalsourcebailsum -- 
    ,o.capitalsourcebustype -- 
    ,o.stoppayacct -- 
    ,o.subacctnum -- 
    ,o.depositsum -- 
    ,o.xztflag -- 
    ,o.isrealestateloan -- 是否属于房地产开发贷款
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
from ${iol_schema}.icms_bc_extend_d_bk o
    left join ${iol_schema}.icms_bc_extend_d_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bc_extend_d_cl d
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
--truncate table ${iol_schema}.icms_bc_extend_d;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bc_extend_d') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bc_extend_d drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bc_extend_d add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bc_extend_d exchange partition p_${batch_date} with table ${iol_schema}.icms_bc_extend_d_cl;
alter table ${iol_schema}.icms_bc_extend_d exchange partition p_20991231 with table ${iol_schema}.icms_bc_extend_d_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bc_extend_d to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bc_extend_d_op purge;
drop table ${iol_schema}.icms_bc_extend_d_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bc_extend_d_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bc_extend_d',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
