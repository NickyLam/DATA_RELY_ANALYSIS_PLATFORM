/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_crss_upl_business_approve
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.oass_crss_upl_business_approve
whenever sqlerror continue none;
drop table ${idl_schema}.oass_crss_upl_business_approve purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.oass_crss_upl_business_approve(
    etl_dt date -- 数据日期
    ,serialno varchar2(32) -- 流水号
    ,relativeserialno varchar2(32) -- 相关申请流水号
    ,occurdate varchar2(10) -- 发生日期
    ,customerid varchar2(32) -- 客户编号
    ,customername varchar2(80) -- 客户名称
    ,businesstype varchar2(18) -- 业务品种
    ,businesssubtype varchar2(18) -- 业务子类型
    ,occurtype varchar2(18) -- 发生类型
    ,currenylist varchar2(18) -- 可融通币种表
    ,currencymode varchar2(18) -- 汇率计算模式
    ,businesstypelist varchar2(18) -- 可混用品种表
    ,calculatemode varchar2(18) -- 额度金额占用计算模式
    ,useorglist varchar2(18) -- 额度可使用机构范围
    ,flowreduceflag varchar2(18) -- 额度是否简化审批流程
    ,contractflag varchar2(18) -- 额度是否需要签署协议
    ,subcontractflag varchar2(18) -- 额度下业务是否需要签署合同
    ,selfuseflag varchar2(18) -- 额度自用或他用
    ,creditaggreement varchar2(32) -- 使用授信协议号
    ,relativeagreement varchar2(32) -- 其他相关协议号
    ,loanflag varchar2(18) -- (new)是否可以直接申请出帐
    ,totalsum number(24,6) -- 银行融资总额
    ,ourrole varchar2(18) -- 我行参与角色
    ,reversibility varchar2(18) -- 有无追索权
    ,billnum number -- 票据数量（张）
    ,housetype varchar2(18) -- 房产类型
    ,lctermtype varchar2(18) -- 信用证期限类型
    ,riskattribute varchar2(18) -- 风险类型
    ,suretype varchar2(18) -- 对外担保类型
    ,safeguardtype varchar2(18) -- 保函类型
    ,creditbusiness varchar2(18) -- 单项额度指定品种
    ,businesscurrency varchar2(18) -- 币种
    ,businesssum number(24,6) -- 置换总金额
    ,businessprop number(24,6) -- 贷款成数
    ,termyear number -- 期限年
    ,termmonth number -- 期限月
    ,termday number -- 期限日
    ,lgterm number -- 远期信用证付款期限
    ,baseratetype varchar2(18) -- 基准利率类型
    ,baserate number(24,10) -- 基准利率
    ,ratefloattype varchar2(18) -- 浮动类型
    ,ratefloat number(24,10) -- 利率浮动
    ,businessrate number(24,10) -- 利率
    ,ictype varchar2(18) -- 计息方式
    ,iccyc varchar2(18) -- 计息周期
    ,pdgratio number(10,6) -- 手续费比例
    ,pdgsum number(24,6) -- 手续费金额
    ,pdgpaymethod varchar2(18) -- 手续费支付方式
    ,pdgpayperiod varchar2(18) -- (new)收费周期
    ,promisesfeeratio number(10,6) -- (new)承诺费率
    ,promisesfeesum number(24,6) -- (new)承诺费金额
    ,promisesfeeperiod number -- (new)承诺费计收期
    ,promisesfeebegin varchar2(10) -- (new)承诺费计收起始日
    ,mfeeratio number(10,6) -- 管理费比例
    ,mfeesum number(24,6) -- 管理费金额
    ,mfeepaymethod varchar2(18) -- 管理费支付方式
    ,agentfee number(24,6) -- (new)代理费
    ,dealfee number(24,6) -- (new)安排费
    ,totalcast number(24,6) -- (new)总成本
    ,discountinterest number(24,6) -- (new)贴现利息
    ,purchaserinterest number(24,6) -- (new)买方应付贴现利息
    ,bargainorinterest number(24,6) -- (new)卖方应付贴现利息
    ,discountsum number(24,6) -- (new)实付贴现金额
    ,bailratio number(10,6) -- 保证金比例
    ,bailcurrency varchar2(18) -- (new)保证金币种
    ,bailsum number(24,6) -- 保证金金额
    ,bailaccount varchar2(32) -- 保证金帐号
    ,fineratetype varchar2(3) -- 罚息利率类型
    ,finerate number(24,10) -- 罚息利率
    ,drawingtype varchar2(18) -- (new)提款方式
    ,firstdrawingdate varchar2(10) -- (new)首次提款日期
    ,drawingperiod number -- (new)提款期限
    ,paytimes number -- 还款期次
    ,paycyc varchar2(18) -- (new)还款方式
    ,graceperiod number -- 还款宽限期(月)
    ,overdraftperiod number -- (new)连续透支期
    ,oldlcno varchar2(32) -- (new)原信用证编号
    ,oldlctermtype varchar2(18) -- (new)原信用证期限类型
    ,oldlccurrency varchar2(18) -- (new)原信用证币种
    ,oldlcsum number(24,6) -- (new)原信用证金额
    ,oldlcloadingdate varchar2(10) -- (new)原信用证装期
    ,oldlcvaliddate varchar2(10) -- (new)原信用证效期
    ,direction varchar2(18) -- 投向
    ,purpose varchar2(500) -- 用途
    ,planallocation varchar2(500) -- 用款计划
    ,immediacypaysource varchar2(500) -- (new)直接还款来源
    ,paysource varchar2(500) -- 还款来源
    ,corpuspaymethod varchar2(18) -- 本金还款方式
    ,interestpaymethod varchar2(18) -- 利息支付方式
    ,thirdparty1 varchar2(200) -- (new)涉及第三方1
    ,thirdpartyid1 varchar2(32) -- (new)第三方法人代码1
    ,thirdparty2 varchar2(200) -- (new)涉及第三方2
    ,thirdpartyid2 varchar2(32) -- (new)第三方法人代码2
    ,thirdparty3 varchar2(200) -- (new)涉及第三方3
    ,thirdpartyid3 varchar2(32) -- (new)第三方法人代码3
    ,thirdpartyregion varchar2(250) -- 涉及第三方所在地区和国家
    ,thirdpartyaccounts varchar2(32) -- (new)第三方帐号
    ,cargoinfo varchar2(80) -- (new)货物名称
    ,projectname varchar2(80) -- (new)贷款项目名称
    ,operationinfo varchar2(500) -- (new)业务信息
    ,contextinfo varchar2(500) -- (new)背景信息
    ,securitiestype varchar2(18) -- (new)有价证券类型
    ,securitiesregion varchar2(18) -- (new)有价证券发行地
    ,constructionarea number(24,6) -- (new)建筑面积
    ,usearea number(24,6) -- (new)使用面积
    ,flag1 varchar2(18) -- (new)是否1
    ,flag2 varchar2(18) -- (new)是否2
    ,flag3 varchar2(18) -- (new)是否3
    ,tradecontractno varchar2(200) -- (new)相关贸易合同号
    ,invoiceno varchar2(32) -- (new)增值税发票
    ,tradecurrency varchar2(18) -- (new)贸易合同币种
    ,tradesum number(24,6) -- (new)贸易合同金额
    ,paymentdate varchar2(10) -- (new)最迟对外付汇日期
    ,operationmode varchar2(18) -- (new)业务模式
    ,vouchclass varchar2(18) -- 担保形式
    ,vouchtype varchar2(18) -- 主要担保方式
    ,vouchtype1 varchar2(18) -- 担保方式1
    ,vouchtype2 varchar2(18) -- 担保方式2
    ,vouchflag varchar2(18) -- (new)有无其他担保方式
    ,warrantor varchar2(80) -- 主要担保人
    ,warrantorid varchar2(32) -- 主要担保人代码
    ,othercondition varchar2(500) -- (new)其他条件和要求
    ,guarantyvalue number(24,6) -- 担保总价值
    ,guarantyrate number(10,6) -- 担保率
    ,baseevaluateresult varchar2(18) -- 基期信用等级
    ,riskrate number(24,6) -- 综合风险度
    ,lowrisk varchar2(18) -- 是否低风险业务
    ,otherarealoan varchar2(18) -- (new)是否异地贷款
    ,lowriskbailsum number(24,6) -- 低风险担保金额
    ,originalputoutdate varchar2(10) -- 首次发放日
    ,extendtimes number -- 展期次数
    ,lngotimes number -- 借新还旧次数
    ,golntimes number -- 还旧借新次数
    ,drtimes number -- 债务重组次数
    ,baseclassifyresult varchar2(18) -- 基期风险分类结果
    ,applytype varchar2(18) -- 申请方式
    ,bailrate number(24,6) -- 保证金比率
    ,finishorg varchar2(18) -- 终批机构级别
    ,describe1 varchar2(500) -- 描述1
    ,operateorgid varchar2(32) -- 经办机构
    ,operateuserid varchar2(32) -- 经办人
    ,operatedate varchar2(10) -- 经办日期
    ,inputorgid varchar2(32) -- 登记机构
    ,inputuserid varchar2(32) -- 登记人
    ,inputdate varchar2(20) -- 登记日期
    ,updatedate varchar2(10) -- 更新日期
    ,pigeonholedate varchar2(10) -- 归档日期
    ,remark varchar2(500) -- 备注
    ,paycurrency varchar2(18) -- (new)付款币种
    ,paydate varchar2(10) -- (new)付款时间
    ,flag4 varchar2(18) -- (new)是否4
    ,fundsource varchar2(18) -- 资金来源
    ,operatetype varchar2(18) -- 操作方式
    ,approvetype varchar2(20) -- 批复类型
    ,cycleflag varchar2(20) -- 循环标志
    ,classifyresult varchar2(80) -- 五级分类结果
    ,classifydate varchar2(10) -- 最新风险分类时间
    ,classifyfrequency number -- 分类频率
    ,vouchnewflag varchar2(20) -- 
    ,adjustratetype varchar2(18) -- 利率调整方式
    ,adjustrateterm varchar2(18) -- 利率调整月数
    ,rateadjustcyc varchar2(18) -- 利率调整周期
    ,fzanbalance number(24,6) -- 发展商入帐净额
    ,acceptinttype varchar2(18) -- 收息类型
    ,ratio number(24,6) -- 比例
    ,thirdpartyadd1 varchar2(80) -- (new)涉及第三方地址1
    ,thirdpartyzip1 varchar2(32) -- (new)第三方法人邮编1
    ,thirdpartyadd2 varchar2(80) -- (new)涉及第三方地址2
    ,thirdpartyzip2 varchar2(32) -- (new)第三方法人邮编2
    ,thirdpartyadd3 varchar2(80) -- (new)涉及第三方地址3
    ,thirdpartyzip3 varchar2(32) -- (new)第三方法人邮编3
    ,effectarea varchar2(18) -- 信用证有效地
    ,termdate1 varchar2(10) -- 最晚装运期
    ,termdate2 varchar2(10) -- 交单期
    ,termdate3 varchar2(10) -- 付款期限
    ,fixcyc number -- 固定周期
    ,describe2 varchar2(200) -- 描述2
    ,approveopinion varchar2(4000) -- 最终审批意见
    ,tempsaveflag varchar2(18) -- 暂存标志
    ,creditcycle varchar2(18) -- (new)额度是否循环
    ,cyclemonths number -- 指定月的利率重定价月数
    ,holdcorpus number(20,4) -- 保留本金
    ,incomeorgid varchar2(32) -- 入账机构
    ,mainrepaymentmethod varchar2(10) -- 还款方式
    ,payaccountname varchar2(80) -- 还款账户名
    ,payaccountno varchar2(40) -- 还款账户
    ,paymentmode varchar2(10) -- 支付方式
    ,ratemode varchar2(10) -- 利率执行方式
    ,flag5 varchar2(10) -- (new)是否已登记合同
    ,defaultpaydate varchar2(10) -- 统一还款日
    ,batchpaymentflag varchar2(1) -- 是否参与批扣
    ,loanaccountno varchar2(32) -- 入账账户
    ,loankind varchar2(10) -- 期限类型
    ,classifyresulteleven varchar2(18) -- 风险分类
    ,effectflag varchar2(3) -- 生效标志
    ,approvedate varchar2(10) -- 审批通过日
    ,creditmode varchar2(18) -- 授信模式
    ,riskacctno varchar2(200) -- 风险金账户
    ,riskacctname varchar2(80) -- 风险金账户名
    ,risksum number(24,6) -- 代扣风险金金额
    ,otherfee number(24,6) -- 其他费用金额
    ,subbusinesstype varchar2(32) -- 助贷业务品种
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
grant select on ${idl_schema}.oass_crss_upl_business_approve to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_crss_upl_business_approve is '微贷业务批复表';
comment on column ${idl_schema}.oass_crss_upl_business_approve.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.serialno is '流水号';
comment on column ${idl_schema}.oass_crss_upl_business_approve.relativeserialno is '相关申请流水号';
comment on column ${idl_schema}.oass_crss_upl_business_approve.occurdate is '发生日期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.customerid is '客户编号';
comment on column ${idl_schema}.oass_crss_upl_business_approve.customername is '客户名称';
comment on column ${idl_schema}.oass_crss_upl_business_approve.businesstype is '业务品种';
comment on column ${idl_schema}.oass_crss_upl_business_approve.businesssubtype is '业务子类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.occurtype is '发生类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.currenylist is '可融通币种表';
comment on column ${idl_schema}.oass_crss_upl_business_approve.currencymode is '汇率计算模式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.businesstypelist is '可混用品种表';
comment on column ${idl_schema}.oass_crss_upl_business_approve.calculatemode is '额度金额占用计算模式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.useorglist is '额度可使用机构范围';
comment on column ${idl_schema}.oass_crss_upl_business_approve.flowreduceflag is '额度是否简化审批流程';
comment on column ${idl_schema}.oass_crss_upl_business_approve.contractflag is '额度是否需要签署协议';
comment on column ${idl_schema}.oass_crss_upl_business_approve.subcontractflag is '额度下业务是否需要签署合同';
comment on column ${idl_schema}.oass_crss_upl_business_approve.selfuseflag is '额度自用或他用';
comment on column ${idl_schema}.oass_crss_upl_business_approve.creditaggreement is '使用授信协议号';
comment on column ${idl_schema}.oass_crss_upl_business_approve.relativeagreement is '其他相关协议号';
comment on column ${idl_schema}.oass_crss_upl_business_approve.loanflag is '(new)是否可以直接申请出帐';
comment on column ${idl_schema}.oass_crss_upl_business_approve.totalsum is '银行融资总额';
comment on column ${idl_schema}.oass_crss_upl_business_approve.ourrole is '我行参与角色';
comment on column ${idl_schema}.oass_crss_upl_business_approve.reversibility is '有无追索权';
comment on column ${idl_schema}.oass_crss_upl_business_approve.billnum is '票据数量（张）';
comment on column ${idl_schema}.oass_crss_upl_business_approve.housetype is '房产类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.lctermtype is '信用证期限类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.riskattribute is '风险类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.suretype is '对外担保类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.safeguardtype is '保函类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.creditbusiness is '单项额度指定品种';
comment on column ${idl_schema}.oass_crss_upl_business_approve.businesscurrency is '币种';
comment on column ${idl_schema}.oass_crss_upl_business_approve.businesssum is '置换总金额';
comment on column ${idl_schema}.oass_crss_upl_business_approve.businessprop is '贷款成数';
comment on column ${idl_schema}.oass_crss_upl_business_approve.termyear is '期限年';
comment on column ${idl_schema}.oass_crss_upl_business_approve.termmonth is '期限月';
comment on column ${idl_schema}.oass_crss_upl_business_approve.termday is '期限日';
comment on column ${idl_schema}.oass_crss_upl_business_approve.lgterm is '远期信用证付款期限';
comment on column ${idl_schema}.oass_crss_upl_business_approve.baseratetype is '基准利率类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.baserate is '基准利率';
comment on column ${idl_schema}.oass_crss_upl_business_approve.ratefloattype is '浮动类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.ratefloat is '利率浮动';
comment on column ${idl_schema}.oass_crss_upl_business_approve.businessrate is '利率';
comment on column ${idl_schema}.oass_crss_upl_business_approve.ictype is '计息方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.iccyc is '计息周期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.pdgratio is '手续费比例';
comment on column ${idl_schema}.oass_crss_upl_business_approve.pdgsum is '手续费金额';
comment on column ${idl_schema}.oass_crss_upl_business_approve.pdgpaymethod is '手续费支付方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.pdgpayperiod is '(new)收费周期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.promisesfeeratio is '(new)承诺费率';
comment on column ${idl_schema}.oass_crss_upl_business_approve.promisesfeesum is '(new)承诺费金额';
comment on column ${idl_schema}.oass_crss_upl_business_approve.promisesfeeperiod is '(new)承诺费计收期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.promisesfeebegin is '(new)承诺费计收起始日';
comment on column ${idl_schema}.oass_crss_upl_business_approve.mfeeratio is '管理费比例';
comment on column ${idl_schema}.oass_crss_upl_business_approve.mfeesum is '管理费金额';
comment on column ${idl_schema}.oass_crss_upl_business_approve.mfeepaymethod is '管理费支付方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.agentfee is '(new)代理费';
comment on column ${idl_schema}.oass_crss_upl_business_approve.dealfee is '(new)安排费';
comment on column ${idl_schema}.oass_crss_upl_business_approve.totalcast is '(new)总成本';
comment on column ${idl_schema}.oass_crss_upl_business_approve.discountinterest is '(new)贴现利息';
comment on column ${idl_schema}.oass_crss_upl_business_approve.purchaserinterest is '(new)买方应付贴现利息';
comment on column ${idl_schema}.oass_crss_upl_business_approve.bargainorinterest is '(new)卖方应付贴现利息';
comment on column ${idl_schema}.oass_crss_upl_business_approve.discountsum is '(new)实付贴现金额';
comment on column ${idl_schema}.oass_crss_upl_business_approve.bailratio is '保证金比例';
comment on column ${idl_schema}.oass_crss_upl_business_approve.bailcurrency is '(new)保证金币种';
comment on column ${idl_schema}.oass_crss_upl_business_approve.bailsum is '保证金金额';
comment on column ${idl_schema}.oass_crss_upl_business_approve.bailaccount is '保证金帐号';
comment on column ${idl_schema}.oass_crss_upl_business_approve.fineratetype is '罚息利率类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.finerate is '罚息利率';
comment on column ${idl_schema}.oass_crss_upl_business_approve.drawingtype is '(new)提款方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.firstdrawingdate is '(new)首次提款日期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.drawingperiod is '(new)提款期限';
comment on column ${idl_schema}.oass_crss_upl_business_approve.paytimes is '还款期次';
comment on column ${idl_schema}.oass_crss_upl_business_approve.paycyc is '(new)还款方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.graceperiod is '还款宽限期(月)';
comment on column ${idl_schema}.oass_crss_upl_business_approve.overdraftperiod is '(new)连续透支期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.oldlcno is '(new)原信用证编号';
comment on column ${idl_schema}.oass_crss_upl_business_approve.oldlctermtype is '(new)原信用证期限类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.oldlccurrency is '(new)原信用证币种';
comment on column ${idl_schema}.oass_crss_upl_business_approve.oldlcsum is '(new)原信用证金额';
comment on column ${idl_schema}.oass_crss_upl_business_approve.oldlcloadingdate is '(new)原信用证装期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.oldlcvaliddate is '(new)原信用证效期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.direction is '投向';
comment on column ${idl_schema}.oass_crss_upl_business_approve.purpose is '用途';
comment on column ${idl_schema}.oass_crss_upl_business_approve.planallocation is '用款计划';
comment on column ${idl_schema}.oass_crss_upl_business_approve.immediacypaysource is '(new)直接还款来源';
comment on column ${idl_schema}.oass_crss_upl_business_approve.paysource is '还款来源';
comment on column ${idl_schema}.oass_crss_upl_business_approve.corpuspaymethod is '本金还款方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.interestpaymethod is '利息支付方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdparty1 is '(new)涉及第三方1';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdpartyid1 is '(new)第三方法人代码1';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdparty2 is '(new)涉及第三方2';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdpartyid2 is '(new)第三方法人代码2';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdparty3 is '(new)涉及第三方3';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdpartyid3 is '(new)第三方法人代码3';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdpartyregion is '涉及第三方所在地区和国家';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdpartyaccounts is '(new)第三方帐号';
comment on column ${idl_schema}.oass_crss_upl_business_approve.cargoinfo is '(new)货物名称';
comment on column ${idl_schema}.oass_crss_upl_business_approve.projectname is '(new)贷款项目名称';
comment on column ${idl_schema}.oass_crss_upl_business_approve.operationinfo is '(new)业务信息';
comment on column ${idl_schema}.oass_crss_upl_business_approve.contextinfo is '(new)背景信息';
comment on column ${idl_schema}.oass_crss_upl_business_approve.securitiestype is '(new)有价证券类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.securitiesregion is '(new)有价证券发行地';
comment on column ${idl_schema}.oass_crss_upl_business_approve.constructionarea is '(new)建筑面积';
comment on column ${idl_schema}.oass_crss_upl_business_approve.usearea is '(new)使用面积';
comment on column ${idl_schema}.oass_crss_upl_business_approve.flag1 is '(new)是否1';
comment on column ${idl_schema}.oass_crss_upl_business_approve.flag2 is '(new)是否2';
comment on column ${idl_schema}.oass_crss_upl_business_approve.flag3 is '(new)是否3';
comment on column ${idl_schema}.oass_crss_upl_business_approve.tradecontractno is '(new)相关贸易合同号';
comment on column ${idl_schema}.oass_crss_upl_business_approve.invoiceno is '(new)增值税发票';
comment on column ${idl_schema}.oass_crss_upl_business_approve.tradecurrency is '(new)贸易合同币种';
comment on column ${idl_schema}.oass_crss_upl_business_approve.tradesum is '(new)贸易合同金额';
comment on column ${idl_schema}.oass_crss_upl_business_approve.paymentdate is '(new)最迟对外付汇日期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.operationmode is '(new)业务模式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.vouchclass is '担保形式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.vouchtype is '主要担保方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.vouchtype1 is '担保方式1';
comment on column ${idl_schema}.oass_crss_upl_business_approve.vouchtype2 is '担保方式2';
comment on column ${idl_schema}.oass_crss_upl_business_approve.vouchflag is '(new)有无其他担保方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.warrantor is '主要担保人';
comment on column ${idl_schema}.oass_crss_upl_business_approve.warrantorid is '主要担保人代码';
comment on column ${idl_schema}.oass_crss_upl_business_approve.othercondition is '(new)其他条件和要求';
comment on column ${idl_schema}.oass_crss_upl_business_approve.guarantyvalue is '担保总价值';
comment on column ${idl_schema}.oass_crss_upl_business_approve.guarantyrate is '担保率';
comment on column ${idl_schema}.oass_crss_upl_business_approve.baseevaluateresult is '基期信用等级';
comment on column ${idl_schema}.oass_crss_upl_business_approve.riskrate is '综合风险度';
comment on column ${idl_schema}.oass_crss_upl_business_approve.lowrisk is '是否低风险业务';
comment on column ${idl_schema}.oass_crss_upl_business_approve.otherarealoan is '(new)是否异地贷款';
comment on column ${idl_schema}.oass_crss_upl_business_approve.lowriskbailsum is '低风险担保金额';
comment on column ${idl_schema}.oass_crss_upl_business_approve.originalputoutdate is '首次发放日';
comment on column ${idl_schema}.oass_crss_upl_business_approve.extendtimes is '展期次数';
comment on column ${idl_schema}.oass_crss_upl_business_approve.lngotimes is '借新还旧次数';
comment on column ${idl_schema}.oass_crss_upl_business_approve.golntimes is '还旧借新次数';
comment on column ${idl_schema}.oass_crss_upl_business_approve.drtimes is '债务重组次数';
comment on column ${idl_schema}.oass_crss_upl_business_approve.baseclassifyresult is '基期风险分类结果';
comment on column ${idl_schema}.oass_crss_upl_business_approve.applytype is '申请方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.bailrate is '保证金比率';
comment on column ${idl_schema}.oass_crss_upl_business_approve.finishorg is '终批机构级别';
comment on column ${idl_schema}.oass_crss_upl_business_approve.describe1 is '描述1';
comment on column ${idl_schema}.oass_crss_upl_business_approve.operateorgid is '经办机构';
comment on column ${idl_schema}.oass_crss_upl_business_approve.operateuserid is '经办人';
comment on column ${idl_schema}.oass_crss_upl_business_approve.operatedate is '经办日期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.inputorgid is '登记机构';
comment on column ${idl_schema}.oass_crss_upl_business_approve.inputuserid is '登记人';
comment on column ${idl_schema}.oass_crss_upl_business_approve.inputdate is '登记日期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.updatedate is '更新日期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.pigeonholedate is '归档日期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.remark is '备注';
comment on column ${idl_schema}.oass_crss_upl_business_approve.paycurrency is '(new)付款币种';
comment on column ${idl_schema}.oass_crss_upl_business_approve.paydate is '(new)付款时间';
comment on column ${idl_schema}.oass_crss_upl_business_approve.flag4 is '(new)是否4';
comment on column ${idl_schema}.oass_crss_upl_business_approve.fundsource is '资金来源';
comment on column ${idl_schema}.oass_crss_upl_business_approve.operatetype is '操作方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.approvetype is '批复类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.cycleflag is '循环标志';
comment on column ${idl_schema}.oass_crss_upl_business_approve.classifyresult is '五级分类结果';
comment on column ${idl_schema}.oass_crss_upl_business_approve.classifydate is '最新风险分类时间';
comment on column ${idl_schema}.oass_crss_upl_business_approve.classifyfrequency is '分类频率';
comment on column ${idl_schema}.oass_crss_upl_business_approve.vouchnewflag is '';
comment on column ${idl_schema}.oass_crss_upl_business_approve.adjustratetype is '利率调整方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.adjustrateterm is '利率调整月数';
comment on column ${idl_schema}.oass_crss_upl_business_approve.rateadjustcyc is '利率调整周期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.fzanbalance is '发展商入帐净额';
comment on column ${idl_schema}.oass_crss_upl_business_approve.acceptinttype is '收息类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.ratio is '比例';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdpartyadd1 is '(new)涉及第三方地址1';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdpartyzip1 is '(new)第三方法人邮编1';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdpartyadd2 is '(new)涉及第三方地址2';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdpartyzip2 is '(new)第三方法人邮编2';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdpartyadd3 is '(new)涉及第三方地址3';
comment on column ${idl_schema}.oass_crss_upl_business_approve.thirdpartyzip3 is '(new)第三方法人邮编3';
comment on column ${idl_schema}.oass_crss_upl_business_approve.effectarea is '信用证有效地';
comment on column ${idl_schema}.oass_crss_upl_business_approve.termdate1 is '最晚装运期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.termdate2 is '交单期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.termdate3 is '付款期限';
comment on column ${idl_schema}.oass_crss_upl_business_approve.fixcyc is '固定周期';
comment on column ${idl_schema}.oass_crss_upl_business_approve.describe2 is '描述2';
comment on column ${idl_schema}.oass_crss_upl_business_approve.approveopinion is '最终审批意见';
comment on column ${idl_schema}.oass_crss_upl_business_approve.tempsaveflag is '暂存标志';
comment on column ${idl_schema}.oass_crss_upl_business_approve.creditcycle is '(new)额度是否循环';
comment on column ${idl_schema}.oass_crss_upl_business_approve.cyclemonths is '指定月的利率重定价月数';
comment on column ${idl_schema}.oass_crss_upl_business_approve.holdcorpus is '保留本金';
comment on column ${idl_schema}.oass_crss_upl_business_approve.incomeorgid is '入账机构';
comment on column ${idl_schema}.oass_crss_upl_business_approve.mainrepaymentmethod is '还款方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.payaccountname is '还款账户名';
comment on column ${idl_schema}.oass_crss_upl_business_approve.payaccountno is '还款账户';
comment on column ${idl_schema}.oass_crss_upl_business_approve.paymentmode is '支付方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.ratemode is '利率执行方式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.flag5 is '(new)是否已登记合同';
comment on column ${idl_schema}.oass_crss_upl_business_approve.defaultpaydate is '统一还款日';
comment on column ${idl_schema}.oass_crss_upl_business_approve.batchpaymentflag is '是否参与批扣';
comment on column ${idl_schema}.oass_crss_upl_business_approve.loanaccountno is '入账账户';
comment on column ${idl_schema}.oass_crss_upl_business_approve.loankind is '期限类型';
comment on column ${idl_schema}.oass_crss_upl_business_approve.classifyresulteleven is '风险分类';
comment on column ${idl_schema}.oass_crss_upl_business_approve.effectflag is '生效标志';
comment on column ${idl_schema}.oass_crss_upl_business_approve.approvedate is '审批通过日';
comment on column ${idl_schema}.oass_crss_upl_business_approve.creditmode is '授信模式';
comment on column ${idl_schema}.oass_crss_upl_business_approve.riskacctno is '风险金账户';
comment on column ${idl_schema}.oass_crss_upl_business_approve.riskacctname is '风险金账户名';
comment on column ${idl_schema}.oass_crss_upl_business_approve.risksum is '代扣风险金金额';
comment on column ${idl_schema}.oass_crss_upl_business_approve.otherfee is '其他费用金额';
comment on column ${idl_schema}.oass_crss_upl_business_approve.subbusinesstype is '助贷业务品种';
comment on column ${idl_schema}.oass_crss_upl_business_approve.payaccountname2 is '第二还款账户名';
comment on column ${idl_schema}.oass_crss_upl_business_approve.payaccountno2 is '第二还款账户';
comment on column ${idl_schema}.oass_crss_upl_business_approve.start_dt is '';
comment on column ${idl_schema}.oass_crss_upl_business_approve.end_dt is '';
comment on column ${idl_schema}.oass_crss_upl_business_approve.id_mark is '';
comment on column ${idl_schema}.oass_crss_upl_business_approve.etl_timestamp is '';
