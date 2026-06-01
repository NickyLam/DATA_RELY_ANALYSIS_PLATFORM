/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_crss_upl_business_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.oass_crss_upl_business_contract
whenever sqlerror continue none;
drop table ${idl_schema}.oass_crss_upl_business_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.oass_crss_upl_business_contract(
    etl_dt date -- 数据日期
    ,serialno varchar2(32) -- 流水号
    ,relativeserialno varchar2(32) -- 相关批准流水号
    ,artificialno varchar2(60) -- 人工编号
    ,occurdate varchar2(10) -- 发生日期
    ,customerid varchar2(32) -- 客户编号
    ,customername varchar2(80) -- 客户名称
    ,businesstype varchar2(18) -- 业务品种(关联表Business_Type中字段TypeNo)
    ,oldbusinesstype varchar2(18) -- 老业务品种
    ,businesssubtype varchar2(18) -- 业务子类型
    ,occurtype varchar2(18) -- 发生类型(代码：OccurType)
    ,creditdigest varchar2(18) -- 额度是否融通
    ,creditcycle varchar2(18) -- 额度是否循环
    ,credittype varchar2(18) -- 额度品种
    ,currenylist varchar2(18) -- 可融通币种表
    ,currencymode varchar2(18) -- 汇率计算模式
    ,businesstypelist varchar2(18) -- 可混用品种表
    ,calculatemode varchar2(18) -- 额度金额占用计算模式
    ,useorglist varchar2(18) -- 额度可使用机构范围
    ,flowreduceflag varchar2(18) -- 额度是否简化审批流程
    ,contractflag varchar2(18) -- 额度是否需要签署协议(1：是2：否)
    ,subcontractflag varchar2(18) -- 额度下业务是否需要签署合同
    ,selfuseflag varchar2(18) -- 额度自用或他用
    ,creditindex number(10,6) -- 额度占用系数
    ,creditreducesum number(24,6) -- 额度扣减金额
    ,limitationterm varchar2(10) -- 额度使用最迟日期
    ,useterm varchar2(10) -- 额度项下业务最迟到期日期
    ,creditaggreement varchar2(32) -- 使用授信协议号(额度合同流水号)
    ,relativeagreement varchar2(32) -- 其他相关协议号
    ,loanflag varchar2(18) -- 是否可以直接申请出帐(1：是 2：否)
    ,totalsum number(24,6) -- 银行融资总额
    ,ourrole varchar2(18) -- 我行参与角色
    ,reversibility varchar2(18) -- 有无追索权
    ,billnum number -- 票据数量（张）(跑批时候更新)
    ,housetype varchar2(18) -- 房产类型(1：别墅2：商住两住、商用、写字楼3：普通住宅)
    ,lctermtype varchar2(18) -- 信用证期限类型(01：即期02：<90天03：90-180天04：180-360天05：>360天)
    ,riskattribute varchar2(18) -- 低风险类型
    ,suretype varchar2(18) -- 对外担保类型
    ,safeguardtype varchar2(18) -- 保函类型(01：融资性担保02：非融资性担保)
    ,creditbusiness varchar2(18) -- 单项额度指定品种
    ,businesscurrency varchar2(18) -- 币种(代码：Currency)
    ,businesssum number(24,6) -- 金额
    ,businessprop number(24,6) -- 贷款成数
    ,termyear number -- 期限年
    ,termmonth number -- 期限月
    ,termday number -- 期限日
    ,lgterm number -- 远期信用证付款期限
    ,baseratetype varchar2(18) -- 基准利率类型
    ,baserate number(24,10) -- 基准利率
    ,ratefloattype varchar2(18) -- 利率类型(0010：浮动0020：固定)
    ,ratefloat number(24,10) -- 利率浮动
    ,businessrate number(24,10) -- 利率
    ,ictype varchar2(18) -- 收费方式(代码：ChargeType)
    ,iccyc varchar2(18) -- 计息周期
    ,pdgratio number(10,6) -- 手续费比例
    ,pdgsum number(24,6) -- 手续费金额
    ,pdgpaymethod varchar2(18) -- 手续费支付方式
    ,pdgpayperiod varchar2(18) -- 收费周期
    ,promisesfeeratio number(10,6) -- 承诺费率
    ,promisesfeesum number(24,6) -- 承诺费金额
    ,promisesfeeperiod number -- 承诺费计收期
    ,promisesfeebegin varchar2(10) -- 承诺费计收起始日
    ,mfeeratio number(10,6) -- 管理费比例
    ,mfeesum number(24,6) -- 管理费金额
    ,mfeepaymethod varchar2(18) -- 管理费支付方式
    ,agentfee number(24,6) -- 代理费
    ,dealfee number(24,6) -- 安排费
    ,totalcast number(24,6) -- 总成本
    ,discountinterest number(24,6) -- 贴现利息
    ,purchaserinterest number(24,6) -- 买方应付贴现利息
    ,bargainorinterest number(24,6) -- 卖方应付贴现利息
    ,discountsum number(24,6) -- 实付贴现金额
    ,bailratio number(10,6) -- 保证金比例
    ,bailcurrency varchar2(18) -- 保证金币种(代码：Currency)
    ,bailsum number(24,6) -- 保证金金额
    ,bailaccount varchar2(32) -- 保证金帐号
    ,fineratetype varchar2(3) -- 罚息利率类型
    ,finerate number(24,10) -- 罚息利率
    ,drawingtype varchar2(18) -- 提款方式(01：一次提款02：分次提款)
    ,firstdrawingdate varchar2(10) -- 首次提款日期
    ,drawingperiod number -- 提款期限
    ,paytimes number -- 还款期次
    ,paycyc varchar2(18) -- 还本付息方式(1：等额还款法2：等额本金还款3：一次还本付息4：分次付息一次还本)
    ,graceperiod number -- 还款宽限期(月)
    ,overdraftperiod number -- 连续透支期
    ,oldlcno varchar2(32) -- 原信用证编号
    ,oldlctermtype varchar2(18) -- 原信用证期限类型
    ,oldlccurrency varchar2(18) -- 原信用证币种
    ,oldlcsum number(24,6) -- 原信用证金额
    ,oldlcloadingdate varchar2(10) -- 原信用证装期
    ,oldlcvaliddate varchar2(10) -- 原信用证效期
    ,direction varchar2(18) -- 投向(代码：ndustryType)
    ,purpose varchar2(500) -- 用途
    ,planallocation varchar2(500) -- 用款计划
    ,immediacypaysource varchar2(500) -- 直接还款来源
    ,paysource varchar2(500) -- 还款来源
    ,corpuspaymethod varchar2(18) -- 本金还款方式(代码：CorpusPayMeth)
    ,interestpaymethod varchar2(18) -- 利息支付方式(01：按季支付02：按月支付03：一次付清)
    ,putoutdate varchar2(10) -- 约定发放日
    ,maturity varchar2(10) -- 到期日期
    ,thirdparty1 varchar2(200) -- 涉及第三方1
    ,thirdpartyid1 varchar2(32) -- 第三方法人代码1
    ,thirdparty2 varchar2(200) -- 涉及第三方2
    ,thirdpartyid2 varchar2(32) -- 第三方法人代码2
    ,thirdparty3 varchar2(200) -- 涉及第三方3
    ,thirdpartyid3 varchar2(32) -- 第三方法人代码3
    ,thirdpartyregion varchar2(250) -- 涉及第三方所在地区和国家
    ,thirdpartyaccounts varchar2(32) -- 第三方帐号
    ,cargoinfo varchar2(80) -- 货物名称
    ,projectname varchar2(80) -- 贷款项目名称
    ,operationinfo varchar2(500) -- 业务信息
    ,contextinfo varchar2(500) -- 背景信息
    ,securitiestype varchar2(18) -- 有价证券类型(代码：InvoiceType)
    ,securitiesregion varchar2(18) -- 有价证券发行地
    ,constructionarea number(24,6) -- 建筑面积
    ,usearea number(24,6) -- 使用面积
    ,flag1 varchar2(18) -- 是否1(1：是2：否)
    ,flag2 varchar2(18) -- 是否2(1：是2：否)
    ,flag3 varchar2(18) -- 是否3(1：是2：否)
    ,tradecontractno varchar2(200) -- 相关贸易合同号
    ,invoiceno varchar2(32) -- 增值税发票
    ,tradecurrency varchar2(18) -- 贸易合同币种
    ,tradesum number(24,6) -- 贸易合同金额
    ,lcno varchar2(32) -- 信用证编号（或承兑汇票号码）
    ,paymentdate varchar2(10) -- 最迟对外付汇日期
    ,operationmode varchar2(18) -- 业务模式(代码：OperationMode)
    ,begindate varchar2(10) -- 起始日期
    ,enddate varchar2(10) -- 到期日
    ,vouchclass varchar2(18) -- 担保形式
    ,vouchtype varchar2(18) -- 主要担保方式(代码：VouchType)
    ,vouchtype1 varchar2(18) -- 担保方式1
    ,vouchtype2 varchar2(18) -- 担保方式2
    ,vouchflag varchar2(18) -- 有无其他担保方式(1：有2：无)
    ,warrantor varchar2(80) -- 主要担保人
    ,warrantorid varchar2(32) -- 主要担保人代码
    ,othercondition varchar2(500) -- 其他条件和要求
    ,guarantyvalue number(24,6) -- 担保总价值
    ,guarantyrate number(10,6) -- 担保率
    ,baseevaluateresult varchar2(18) -- 基期信用等级
    ,riskrate number(24,6) -- 综合风险度
    ,lowrisk varchar2(18) -- 是否低风险业务(1：有2：无)
    ,otherarealoan varchar2(18) -- 是否异地贷款(1：有2：无)
    ,lowriskbailsum number(24,6) -- 低风险担保金额
    ,applytype varchar2(18) -- 申请方式(代码：ApplyType)
    ,originalputoutdate varchar2(10) -- 首次发放日
    ,extendtimes number -- 展期次数
    ,lngotimes number -- 借新还旧次数
    ,golntimes number -- 还旧借新次数
    ,drtimes number -- 债务重组次数
    ,guarantyno varchar2(32) -- 抵质押编号
    ,putoutsum number(24,6) -- 已出帐金额
    ,actualputoutsum number(24,6) -- 已实际出帐金额
    ,balance number(24,6) -- 当前余额
    ,normalbalance number(24,6) -- 正常余额
    ,overduebalance number(24,6) -- 逾期余额
    ,dullbalance number(24,6) -- 呆滞余额
    ,badbalance number(24,6) -- 呆帐余额
    ,interestbalance1 number(24,6) -- 表内欠息余额
    ,interestbalance2 number(24,6) -- 表外欠息余额
    ,finebalance1 number(24,6) -- 本金罚息
    ,finebalance2 number(24,6) -- 利息罚息
    ,overduedays number -- 逾期天数
    ,oweinterestdays number -- 欠息天数
    ,tabalance number(24,6) -- 分期业务欠本金
    ,tainterestbalance number(24,6) -- 分期业务欠利息
    ,tatimes number -- 累计欠款期数
    ,lcatimes number(24,6) -- 连续欠款期数
    ,pbinterestsum number(24,6) -- 本累计收回利息
    ,pbmfeesum number(24,6) -- 累计收回管理费
    ,pbpdgsum number(24,6) -- 累计收回手续费
    ,pblegalcostsum number(24,6) -- 累计收回诉讼费
    ,polegalcostsum number(24,6) -- 累计付出诉讼费
    ,originalbaddate varchar2(10) -- 首次认定不良日期
    ,baseclassifyresult varchar2(18) -- 基期风险分类结果
    ,classifyresult varchar2(80) -- 五级分类结果
    ,classifytype varchar2(18) -- 最新风险分类方式
    ,classifydate varchar2(10) -- 最新风险分类时间
    ,classifyorgid varchar2(32) -- 最新分类认定机构
    ,reservesum number(24,6) -- 计提准备金
    ,expectlosssum number(24,6) -- 预测损失金额
    ,bailrate number(24,6) -- 保证金比率
    ,finishorg varchar2(18) -- 终批机构级别
    ,finishtype varchar2(18) -- 终结类型
    ,finishdate varchar2(10) -- 终结日期
    ,describe1 varchar2(500) -- 描述1
    ,reinforceflag varchar2(18) -- 补登标志
    ,manageorgid varchar2(32) -- 当前管户机构
    ,manageuserid varchar2(32) -- 当前管户人
    ,recoveryorgid varchar2(500) -- 保全管理机构
    ,recoveryuserid varchar2(500) -- 保全管理人
    ,statorgid varchar2(32) -- 当前统计机构
    ,statuserid varchar2(32) -- 当前统计人
    ,operateorgid varchar2(32) -- 经办机构
    ,operateuserid varchar2(32) -- 经办人
    ,operatedate varchar2(10) -- 经办日期
    ,inputorgid varchar2(32) -- 登记机构
    ,inputuserid varchar2(32) -- 登记人
    ,inputdate varchar2(10) -- 登记日期人
    ,updatedate varchar2(10) -- 更新日期
    ,pigeonholedate varchar2(10) -- 归档日期
    ,remark varchar2(500) -- 备注
    ,flag4 varchar2(18) -- 是否4
    ,paycurrency varchar2(18) -- 付款币种
    ,paydate varchar2(10) -- 付款时间
    ,flag5 varchar2(18) -- 转建行标志
    ,classifysum1 number(24,6) -- 最新分类正常金额
    ,classifysum2 number(24,6) -- 最新分类关注金额
    ,classifysum3 number(24,6) -- 最新分类次级金额
    ,classifysum4 number(24,6) -- 最新分类可疑金额
    ,classifysum5 number(24,6) -- 最新分类损失金额
    ,shifttype varchar2(18) -- 移交类型
    ,operatetype varchar2(18) -- 操作方式
    ,fundsource varchar2(18) -- 资金来源
    ,cycleflag varchar2(18) -- 循环标志
    ,creditfreezeflag varchar2(18) -- 额度是否冻结
    ,shiftbalance number(24,6) -- 移交保全时余额
    ,classifyfrequency number -- 分类频率
    ,classifylevel varchar2(18) -- 认定级别
    ,vouchnewflag varchar2(18) -- 是否新增担保
    ,actualartificialno varchar2(32) -- 实际合同号
    ,deleteflag varchar2(18) -- 合并标志
    ,accountno varchar2(32) -- 结算帐号
    ,loanaccountno varchar2(32) -- 入账账户
    ,secondpayaccount varchar2(32) -- 第二还款帐号
    ,adjustratetype varchar2(18) -- 利率调整方式
    ,adjustrateterm varchar2(18) -- 利率调整月数
    ,overinttype varchar2(18) -- 逾期计息方式
    ,rateadjustcyc varchar2(18) -- 利率调整周期
    ,pdgaccountno varchar2(32) -- 手续费支出帐号
    ,deductdate varchar2(10) -- 扣款日期
    ,fzanbalance number(24,6) -- 发展商入帐净额
    ,acceptinttype varchar2(18) -- 收息类型
    ,ratio number(24,6) -- 比例
    ,thirdpartyadd1 varchar2(80) -- 涉及第三方地址1
    ,thirdpartyzip1 varchar2(32) -- 第三方法人邮编1
    ,thirdpartyadd2 varchar2(80) -- 涉及第三方地址2
    ,thirdpartyzip2 varchar2(32) -- 第三方法人邮编2
    ,thirdpartyadd3 varchar2(80) -- 涉及第三方地址3
    ,thirdpartyzip3 varchar2(32) -- 第三方法人邮编3
    ,effectarea varchar2(18) -- 信用证有效地
    ,termdate1 varchar2(10) -- 最晚装运期
    ,termdate2 varchar2(10) -- 交单期
    ,termdate3 varchar2(10) -- 付款期限
    ,fixcyc number -- 固定周期
    ,describe2 varchar2(100) -- 描述2
    ,cancelsum number(24,6) -- 核销金额
    ,cancelinterest number(24,6) -- 核销利息
    ,loanterm varchar2(18) -- 期限
    ,putoutorgid varchar2(32) -- 放款机构
    ,tempsaveflag varchar2(18) -- 暂存标志
    ,overduedate varchar2(10) -- 逾期日期
    ,oweinterestdate varchar2(10) -- 欠息日期
    ,freezeflag varchar2(1) -- 冻结标志
    ,cyclemonths number -- 指定月的利率重定价月数
    ,gainamount number(20,4) -- 等比（等额）<br>递变幅度
    ,gaincyc number -- 等比（等额）<br>递变周期
    ,holdcorpus number(20,4) -- 保留本金
    ,incomeorgid varchar2(32) -- 入账机构编号
    ,mainrepaymentmethod varchar2(10) -- 还款方式
    ,payaccountname varchar2(80) -- 还款账户名
    ,payaccountno varchar2(40) -- 还款账户
    ,ratemode varchar2(10) -- 利率执行方式
    ,paymentmode varchar2(10) -- 支付方式
    ,transformflag varchar2(1) -- 转授信标志
    ,transformtimes number -- 变更次数
    ,defaultpaydate varchar2(10) -- 统一还款日
    ,batchpaymentflag varchar2(1) -- 是否参与批扣
    ,loankind varchar2(10) -- 期限类型
    ,creditmode varchar2(2) -- 合同类型
    ,effectflag varchar2(3) -- 有效标志位
    ,totalbalance number(24,6) -- 敞口余额
    ,recoverycognuserid varchar2(32) -- 保全业务经理
    ,recoverycognorgid varchar2(32) -- 保全业务机构
    ,classifyresulteleven varchar2(12) -- 十级分类结果
    ,riskacctno varchar2(200) -- 风险金账户
    ,riskacctname varchar2(80) -- 风险金账户名
    ,risksum number(24,6) -- 代扣风险金金额
    ,otherfee number(24,6) -- 其他费用金额
    ,subbusinesstype varchar2(32) -- 助贷业务品种
    ,lastclassifyresult varchar2(10) -- 上次五级分类结果
    ,payaccountname2 varchar2(80) -- 第二还款账户名
    ,payaccountno2 varchar2(40) -- 第二还款账户
    ,start_dt date -- 
    ,end_dt date -- 
    ,id_mark varchar2(10) -- 
    ,etl_timestamp timestamp -- 
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_crss_upl_business_contract to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_crss_upl_business_contract is '微贷业务合同表';
comment on column ${idl_schema}.oass_crss_upl_business_contract.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.serialno is '流水号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.relativeserialno is '相关批准流水号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.artificialno is '人工编号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.occurdate is '发生日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.customerid is '客户编号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.customername is '客户名称';
comment on column ${idl_schema}.oass_crss_upl_business_contract.businesstype is '业务品种(关联表Business_Type中字段TypeNo)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.oldbusinesstype is '老业务品种';
comment on column ${idl_schema}.oass_crss_upl_business_contract.businesssubtype is '业务子类型';
comment on column ${idl_schema}.oass_crss_upl_business_contract.occurtype is '发生类型(代码：OccurType)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.creditdigest is '额度是否融通';
comment on column ${idl_schema}.oass_crss_upl_business_contract.creditcycle is '额度是否循环';
comment on column ${idl_schema}.oass_crss_upl_business_contract.credittype is '额度品种';
comment on column ${idl_schema}.oass_crss_upl_business_contract.currenylist is '可融通币种表';
comment on column ${idl_schema}.oass_crss_upl_business_contract.currencymode is '汇率计算模式';
comment on column ${idl_schema}.oass_crss_upl_business_contract.businesstypelist is '可混用品种表';
comment on column ${idl_schema}.oass_crss_upl_business_contract.calculatemode is '额度金额占用计算模式';
comment on column ${idl_schema}.oass_crss_upl_business_contract.useorglist is '额度可使用机构范围';
comment on column ${idl_schema}.oass_crss_upl_business_contract.flowreduceflag is '额度是否简化审批流程';
comment on column ${idl_schema}.oass_crss_upl_business_contract.contractflag is '额度是否需要签署协议(1：是2：否)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.subcontractflag is '额度下业务是否需要签署合同';
comment on column ${idl_schema}.oass_crss_upl_business_contract.selfuseflag is '额度自用或他用';
comment on column ${idl_schema}.oass_crss_upl_business_contract.creditindex is '额度占用系数';
comment on column ${idl_schema}.oass_crss_upl_business_contract.creditreducesum is '额度扣减金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.limitationterm is '额度使用最迟日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.useterm is '额度项下业务最迟到期日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.creditaggreement is '使用授信协议号(额度合同流水号)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.relativeagreement is '其他相关协议号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.loanflag is '是否可以直接申请出帐(1：是 2：否)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.totalsum is '银行融资总额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.ourrole is '我行参与角色';
comment on column ${idl_schema}.oass_crss_upl_business_contract.reversibility is '有无追索权';
comment on column ${idl_schema}.oass_crss_upl_business_contract.billnum is '票据数量（张）(跑批时候更新)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.housetype is '房产类型(1：别墅2：商住两住、商用、写字楼3：普通住宅)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.lctermtype is '信用证期限类型(01：即期02：<90天03：90-180天04：180-360天05：>360天)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.riskattribute is '低风险类型';
comment on column ${idl_schema}.oass_crss_upl_business_contract.suretype is '对外担保类型';
comment on column ${idl_schema}.oass_crss_upl_business_contract.safeguardtype is '保函类型(01：融资性担保02：非融资性担保)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.creditbusiness is '单项额度指定品种';
comment on column ${idl_schema}.oass_crss_upl_business_contract.businesscurrency is '币种(代码：Currency)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.businesssum is '金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.businessprop is '贷款成数';
comment on column ${idl_schema}.oass_crss_upl_business_contract.termyear is '期限年';
comment on column ${idl_schema}.oass_crss_upl_business_contract.termmonth is '期限月';
comment on column ${idl_schema}.oass_crss_upl_business_contract.termday is '期限日';
comment on column ${idl_schema}.oass_crss_upl_business_contract.lgterm is '远期信用证付款期限';
comment on column ${idl_schema}.oass_crss_upl_business_contract.baseratetype is '基准利率类型';
comment on column ${idl_schema}.oass_crss_upl_business_contract.baserate is '基准利率';
comment on column ${idl_schema}.oass_crss_upl_business_contract.ratefloattype is '利率类型(0010：浮动0020：固定)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.ratefloat is '利率浮动';
comment on column ${idl_schema}.oass_crss_upl_business_contract.businessrate is '利率';
comment on column ${idl_schema}.oass_crss_upl_business_contract.ictype is '收费方式(代码：ChargeType)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.iccyc is '计息周期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.pdgratio is '手续费比例';
comment on column ${idl_schema}.oass_crss_upl_business_contract.pdgsum is '手续费金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.pdgpaymethod is '手续费支付方式';
comment on column ${idl_schema}.oass_crss_upl_business_contract.pdgpayperiod is '收费周期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.promisesfeeratio is '承诺费率';
comment on column ${idl_schema}.oass_crss_upl_business_contract.promisesfeesum is '承诺费金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.promisesfeeperiod is '承诺费计收期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.promisesfeebegin is '承诺费计收起始日';
comment on column ${idl_schema}.oass_crss_upl_business_contract.mfeeratio is '管理费比例';
comment on column ${idl_schema}.oass_crss_upl_business_contract.mfeesum is '管理费金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.mfeepaymethod is '管理费支付方式';
comment on column ${idl_schema}.oass_crss_upl_business_contract.agentfee is '代理费';
comment on column ${idl_schema}.oass_crss_upl_business_contract.dealfee is '安排费';
comment on column ${idl_schema}.oass_crss_upl_business_contract.totalcast is '总成本';
comment on column ${idl_schema}.oass_crss_upl_business_contract.discountinterest is '贴现利息';
comment on column ${idl_schema}.oass_crss_upl_business_contract.purchaserinterest is '买方应付贴现利息';
comment on column ${idl_schema}.oass_crss_upl_business_contract.bargainorinterest is '卖方应付贴现利息';
comment on column ${idl_schema}.oass_crss_upl_business_contract.discountsum is '实付贴现金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.bailratio is '保证金比例';
comment on column ${idl_schema}.oass_crss_upl_business_contract.bailcurrency is '保证金币种(代码：Currency)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.bailsum is '保证金金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.bailaccount is '保证金帐号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.fineratetype is '罚息利率类型';
comment on column ${idl_schema}.oass_crss_upl_business_contract.finerate is '罚息利率';
comment on column ${idl_schema}.oass_crss_upl_business_contract.drawingtype is '提款方式(01：一次提款02：分次提款)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.firstdrawingdate is '首次提款日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.drawingperiod is '提款期限';
comment on column ${idl_schema}.oass_crss_upl_business_contract.paytimes is '还款期次';
comment on column ${idl_schema}.oass_crss_upl_business_contract.paycyc is '还本付息方式(1：等额还款法2：等额本金还款3：一次还本付息4：分次付息一次还本)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.graceperiod is '还款宽限期(月)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.overdraftperiod is '连续透支期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.oldlcno is '原信用证编号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.oldlctermtype is '原信用证期限类型';
comment on column ${idl_schema}.oass_crss_upl_business_contract.oldlccurrency is '原信用证币种';
comment on column ${idl_schema}.oass_crss_upl_business_contract.oldlcsum is '原信用证金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.oldlcloadingdate is '原信用证装期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.oldlcvaliddate is '原信用证效期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.direction is '投向(代码：ndustryType)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.purpose is '用途';
comment on column ${idl_schema}.oass_crss_upl_business_contract.planallocation is '用款计划';
comment on column ${idl_schema}.oass_crss_upl_business_contract.immediacypaysource is '直接还款来源';
comment on column ${idl_schema}.oass_crss_upl_business_contract.paysource is '还款来源';
comment on column ${idl_schema}.oass_crss_upl_business_contract.corpuspaymethod is '本金还款方式(代码：CorpusPayMeth)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.interestpaymethod is '利息支付方式(01：按季支付02：按月支付03：一次付清)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.putoutdate is '约定发放日';
comment on column ${idl_schema}.oass_crss_upl_business_contract.maturity is '到期日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdparty1 is '涉及第三方1';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdpartyid1 is '第三方法人代码1';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdparty2 is '涉及第三方2';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdpartyid2 is '第三方法人代码2';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdparty3 is '涉及第三方3';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdpartyid3 is '第三方法人代码3';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdpartyregion is '涉及第三方所在地区和国家';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdpartyaccounts is '第三方帐号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.cargoinfo is '货物名称';
comment on column ${idl_schema}.oass_crss_upl_business_contract.projectname is '贷款项目名称';
comment on column ${idl_schema}.oass_crss_upl_business_contract.operationinfo is '业务信息';
comment on column ${idl_schema}.oass_crss_upl_business_contract.contextinfo is '背景信息';
comment on column ${idl_schema}.oass_crss_upl_business_contract.securitiestype is '有价证券类型(代码：InvoiceType)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.securitiesregion is '有价证券发行地';
comment on column ${idl_schema}.oass_crss_upl_business_contract.constructionarea is '建筑面积';
comment on column ${idl_schema}.oass_crss_upl_business_contract.usearea is '使用面积';
comment on column ${idl_schema}.oass_crss_upl_business_contract.flag1 is '是否1(1：是2：否)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.flag2 is '是否2(1：是2：否)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.flag3 is '是否3(1：是2：否)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.tradecontractno is '相关贸易合同号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.invoiceno is '增值税发票';
comment on column ${idl_schema}.oass_crss_upl_business_contract.tradecurrency is '贸易合同币种';
comment on column ${idl_schema}.oass_crss_upl_business_contract.tradesum is '贸易合同金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.lcno is '信用证编号（或承兑汇票号码）';
comment on column ${idl_schema}.oass_crss_upl_business_contract.paymentdate is '最迟对外付汇日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.operationmode is '业务模式(代码：OperationMode)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.begindate is '起始日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.enddate is '到期日';
comment on column ${idl_schema}.oass_crss_upl_business_contract.vouchclass is '担保形式';
comment on column ${idl_schema}.oass_crss_upl_business_contract.vouchtype is '主要担保方式(代码：VouchType)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.vouchtype1 is '担保方式1';
comment on column ${idl_schema}.oass_crss_upl_business_contract.vouchtype2 is '担保方式2';
comment on column ${idl_schema}.oass_crss_upl_business_contract.vouchflag is '有无其他担保方式(1：有2：无)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.warrantor is '主要担保人';
comment on column ${idl_schema}.oass_crss_upl_business_contract.warrantorid is '主要担保人代码';
comment on column ${idl_schema}.oass_crss_upl_business_contract.othercondition is '其他条件和要求';
comment on column ${idl_schema}.oass_crss_upl_business_contract.guarantyvalue is '担保总价值';
comment on column ${idl_schema}.oass_crss_upl_business_contract.guarantyrate is '担保率';
comment on column ${idl_schema}.oass_crss_upl_business_contract.baseevaluateresult is '基期信用等级';
comment on column ${idl_schema}.oass_crss_upl_business_contract.riskrate is '综合风险度';
comment on column ${idl_schema}.oass_crss_upl_business_contract.lowrisk is '是否低风险业务(1：有2：无)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.otherarealoan is '是否异地贷款(1：有2：无)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.lowriskbailsum is '低风险担保金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.applytype is '申请方式(代码：ApplyType)';
comment on column ${idl_schema}.oass_crss_upl_business_contract.originalputoutdate is '首次发放日';
comment on column ${idl_schema}.oass_crss_upl_business_contract.extendtimes is '展期次数';
comment on column ${idl_schema}.oass_crss_upl_business_contract.lngotimes is '借新还旧次数';
comment on column ${idl_schema}.oass_crss_upl_business_contract.golntimes is '还旧借新次数';
comment on column ${idl_schema}.oass_crss_upl_business_contract.drtimes is '债务重组次数';
comment on column ${idl_schema}.oass_crss_upl_business_contract.guarantyno is '抵质押编号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.putoutsum is '已出帐金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.actualputoutsum is '已实际出帐金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.balance is '当前余额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.normalbalance is '正常余额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.overduebalance is '逾期余额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.dullbalance is '呆滞余额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.badbalance is '呆帐余额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.interestbalance1 is '表内欠息余额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.interestbalance2 is '表外欠息余额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.finebalance1 is '本金罚息';
comment on column ${idl_schema}.oass_crss_upl_business_contract.finebalance2 is '利息罚息';
comment on column ${idl_schema}.oass_crss_upl_business_contract.overduedays is '逾期天数';
comment on column ${idl_schema}.oass_crss_upl_business_contract.oweinterestdays is '欠息天数';
comment on column ${idl_schema}.oass_crss_upl_business_contract.tabalance is '分期业务欠本金';
comment on column ${idl_schema}.oass_crss_upl_business_contract.tainterestbalance is '分期业务欠利息';
comment on column ${idl_schema}.oass_crss_upl_business_contract.tatimes is '累计欠款期数';
comment on column ${idl_schema}.oass_crss_upl_business_contract.lcatimes is '连续欠款期数';
comment on column ${idl_schema}.oass_crss_upl_business_contract.pbinterestsum is '本累计收回利息';
comment on column ${idl_schema}.oass_crss_upl_business_contract.pbmfeesum is '累计收回管理费';
comment on column ${idl_schema}.oass_crss_upl_business_contract.pbpdgsum is '累计收回手续费';
comment on column ${idl_schema}.oass_crss_upl_business_contract.pblegalcostsum is '累计收回诉讼费';
comment on column ${idl_schema}.oass_crss_upl_business_contract.polegalcostsum is '累计付出诉讼费';
comment on column ${idl_schema}.oass_crss_upl_business_contract.originalbaddate is '首次认定不良日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.baseclassifyresult is '基期风险分类结果';
comment on column ${idl_schema}.oass_crss_upl_business_contract.classifyresult is '五级分类结果';
comment on column ${idl_schema}.oass_crss_upl_business_contract.classifytype is '最新风险分类方式';
comment on column ${idl_schema}.oass_crss_upl_business_contract.classifydate is '最新风险分类时间';
comment on column ${idl_schema}.oass_crss_upl_business_contract.classifyorgid is '最新分类认定机构';
comment on column ${idl_schema}.oass_crss_upl_business_contract.reservesum is '计提准备金';
comment on column ${idl_schema}.oass_crss_upl_business_contract.expectlosssum is '预测损失金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.bailrate is '保证金比率';
comment on column ${idl_schema}.oass_crss_upl_business_contract.finishorg is '终批机构级别';
comment on column ${idl_schema}.oass_crss_upl_business_contract.finishtype is '终结类型';
comment on column ${idl_schema}.oass_crss_upl_business_contract.finishdate is '终结日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.describe1 is '描述1';
comment on column ${idl_schema}.oass_crss_upl_business_contract.reinforceflag is '补登标志';
comment on column ${idl_schema}.oass_crss_upl_business_contract.manageorgid is '当前管户机构';
comment on column ${idl_schema}.oass_crss_upl_business_contract.manageuserid is '当前管户人';
comment on column ${idl_schema}.oass_crss_upl_business_contract.recoveryorgid is '保全管理机构';
comment on column ${idl_schema}.oass_crss_upl_business_contract.recoveryuserid is '保全管理人';
comment on column ${idl_schema}.oass_crss_upl_business_contract.statorgid is '当前统计机构';
comment on column ${idl_schema}.oass_crss_upl_business_contract.statuserid is '当前统计人';
comment on column ${idl_schema}.oass_crss_upl_business_contract.operateorgid is '经办机构';
comment on column ${idl_schema}.oass_crss_upl_business_contract.operateuserid is '经办人';
comment on column ${idl_schema}.oass_crss_upl_business_contract.operatedate is '经办日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.inputorgid is '登记机构';
comment on column ${idl_schema}.oass_crss_upl_business_contract.inputuserid is '登记人';
comment on column ${idl_schema}.oass_crss_upl_business_contract.inputdate is '登记日期人';
comment on column ${idl_schema}.oass_crss_upl_business_contract.updatedate is '更新日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.pigeonholedate is '归档日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.remark is '备注';
comment on column ${idl_schema}.oass_crss_upl_business_contract.flag4 is '是否4';
comment on column ${idl_schema}.oass_crss_upl_business_contract.paycurrency is '付款币种';
comment on column ${idl_schema}.oass_crss_upl_business_contract.paydate is '付款时间';
comment on column ${idl_schema}.oass_crss_upl_business_contract.flag5 is '转建行标志';
comment on column ${idl_schema}.oass_crss_upl_business_contract.classifysum1 is '最新分类正常金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.classifysum2 is '最新分类关注金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.classifysum3 is '最新分类次级金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.classifysum4 is '最新分类可疑金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.classifysum5 is '最新分类损失金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.shifttype is '移交类型';
comment on column ${idl_schema}.oass_crss_upl_business_contract.operatetype is '操作方式';
comment on column ${idl_schema}.oass_crss_upl_business_contract.fundsource is '资金来源';
comment on column ${idl_schema}.oass_crss_upl_business_contract.cycleflag is '循环标志';
comment on column ${idl_schema}.oass_crss_upl_business_contract.creditfreezeflag is '额度是否冻结';
comment on column ${idl_schema}.oass_crss_upl_business_contract.shiftbalance is '移交保全时余额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.classifyfrequency is '分类频率';
comment on column ${idl_schema}.oass_crss_upl_business_contract.classifylevel is '认定级别';
comment on column ${idl_schema}.oass_crss_upl_business_contract.vouchnewflag is '是否新增担保';
comment on column ${idl_schema}.oass_crss_upl_business_contract.actualartificialno is '实际合同号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.deleteflag is '合并标志';
comment on column ${idl_schema}.oass_crss_upl_business_contract.accountno is '结算帐号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.loanaccountno is '入账账户';
comment on column ${idl_schema}.oass_crss_upl_business_contract.secondpayaccount is '第二还款帐号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.adjustratetype is '利率调整方式';
comment on column ${idl_schema}.oass_crss_upl_business_contract.adjustrateterm is '利率调整月数';
comment on column ${idl_schema}.oass_crss_upl_business_contract.overinttype is '逾期计息方式';
comment on column ${idl_schema}.oass_crss_upl_business_contract.rateadjustcyc is '利率调整周期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.pdgaccountno is '手续费支出帐号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.deductdate is '扣款日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.fzanbalance is '发展商入帐净额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.acceptinttype is '收息类型';
comment on column ${idl_schema}.oass_crss_upl_business_contract.ratio is '比例';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdpartyadd1 is '涉及第三方地址1';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdpartyzip1 is '第三方法人邮编1';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdpartyadd2 is '涉及第三方地址2';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdpartyzip2 is '第三方法人邮编2';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdpartyadd3 is '涉及第三方地址3';
comment on column ${idl_schema}.oass_crss_upl_business_contract.thirdpartyzip3 is '第三方法人邮编3';
comment on column ${idl_schema}.oass_crss_upl_business_contract.effectarea is '信用证有效地';
comment on column ${idl_schema}.oass_crss_upl_business_contract.termdate1 is '最晚装运期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.termdate2 is '交单期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.termdate3 is '付款期限';
comment on column ${idl_schema}.oass_crss_upl_business_contract.fixcyc is '固定周期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.describe2 is '描述2';
comment on column ${idl_schema}.oass_crss_upl_business_contract.cancelsum is '核销金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.cancelinterest is '核销利息';
comment on column ${idl_schema}.oass_crss_upl_business_contract.loanterm is '期限';
comment on column ${idl_schema}.oass_crss_upl_business_contract.putoutorgid is '放款机构';
comment on column ${idl_schema}.oass_crss_upl_business_contract.tempsaveflag is '暂存标志';
comment on column ${idl_schema}.oass_crss_upl_business_contract.overduedate is '逾期日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.oweinterestdate is '欠息日期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.freezeflag is '冻结标志';
comment on column ${idl_schema}.oass_crss_upl_business_contract.cyclemonths is '指定月的利率重定价月数';
comment on column ${idl_schema}.oass_crss_upl_business_contract.gainamount is '等比（等额）<br>递变幅度';
comment on column ${idl_schema}.oass_crss_upl_business_contract.gaincyc is '等比（等额）<br>递变周期';
comment on column ${idl_schema}.oass_crss_upl_business_contract.holdcorpus is '保留本金';
comment on column ${idl_schema}.oass_crss_upl_business_contract.incomeorgid is '入账机构编号';
comment on column ${idl_schema}.oass_crss_upl_business_contract.mainrepaymentmethod is '还款方式';
comment on column ${idl_schema}.oass_crss_upl_business_contract.payaccountname is '还款账户名';
comment on column ${idl_schema}.oass_crss_upl_business_contract.payaccountno is '还款账户';
comment on column ${idl_schema}.oass_crss_upl_business_contract.ratemode is '利率执行方式';
comment on column ${idl_schema}.oass_crss_upl_business_contract.paymentmode is '支付方式';
comment on column ${idl_schema}.oass_crss_upl_business_contract.transformflag is '转授信标志';
comment on column ${idl_schema}.oass_crss_upl_business_contract.transformtimes is '变更次数';
comment on column ${idl_schema}.oass_crss_upl_business_contract.defaultpaydate is '统一还款日';
comment on column ${idl_schema}.oass_crss_upl_business_contract.batchpaymentflag is '是否参与批扣';
comment on column ${idl_schema}.oass_crss_upl_business_contract.loankind is '期限类型';
comment on column ${idl_schema}.oass_crss_upl_business_contract.creditmode is '合同类型';
comment on column ${idl_schema}.oass_crss_upl_business_contract.effectflag is '有效标志位';
comment on column ${idl_schema}.oass_crss_upl_business_contract.totalbalance is '敞口余额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.recoverycognuserid is '保全业务经理';
comment on column ${idl_schema}.oass_crss_upl_business_contract.recoverycognorgid is '保全业务机构';
comment on column ${idl_schema}.oass_crss_upl_business_contract.classifyresulteleven is '十级分类结果';
comment on column ${idl_schema}.oass_crss_upl_business_contract.riskacctno is '风险金账户';
comment on column ${idl_schema}.oass_crss_upl_business_contract.riskacctname is '风险金账户名';
comment on column ${idl_schema}.oass_crss_upl_business_contract.risksum is '代扣风险金金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.otherfee is '其他费用金额';
comment on column ${idl_schema}.oass_crss_upl_business_contract.subbusinesstype is '助贷业务品种';
comment on column ${idl_schema}.oass_crss_upl_business_contract.lastclassifyresult is '上次五级分类结果';
comment on column ${idl_schema}.oass_crss_upl_business_contract.payaccountname2 is '第二还款账户名';
comment on column ${idl_schema}.oass_crss_upl_business_contract.payaccountno2 is '第二还款账户';
comment on column ${idl_schema}.oass_crss_upl_business_contract.start_dt is '';
comment on column ${idl_schema}.oass_crss_upl_business_contract.end_dt is '';
comment on column ${idl_schema}.oass_crss_upl_business_contract.id_mark is '';
comment on column ${idl_schema}.oass_crss_upl_business_contract.etl_timestamp is '';
