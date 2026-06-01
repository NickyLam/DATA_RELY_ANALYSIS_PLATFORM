/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_crss_upl_business_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.oass_crss_upl_business_apply
whenever sqlerror continue none;
drop table ${idl_schema}.oass_crss_upl_business_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.oass_crss_upl_business_apply(
    etl_dt date -- 数据日期
    ,serialno varchar2(32) -- 流水号
    ,relativeserialno varchar2(32) -- 相关流水号
    ,occurdate varchar2(10) -- 发生日期
    ,customerid varchar2(32) -- 客户编号
    ,customername varchar2(80) -- 客户名称
    ,businesstype varchar2(18) -- 业务品种
    ,businesssubtype varchar2(18) -- 业务子类型
    ,occurtype varchar2(18) -- 发生类型
    ,fundsource varchar2(18) -- 资金来源
    ,operatetype varchar2(18) -- 操作方式
    ,currenylist varchar2(18) -- 可融通币种表
    ,currencymode varchar2(18) -- 汇率计算模式
    ,businesstypelist varchar2(18) -- 可混用品种表
    ,calculatemode varchar2(18) -- 额度金额占用计算模式
    ,useorglist varchar2(18) -- 额度可使用机构范围
    ,cycleflag varchar2(18) -- 额度是否循环
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
    ,businesscurrency varchar2(18) -- 币种
    ,businesssum number(24,6) -- 承贷金额
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
    ,mfeeratio number(10,6) -- 托管费率
    ,mfeesum number(24,6) -- 管理费金额
    ,mfeepaymethod varchar2(18) -- 管理费支付方式
    ,agentfee number(24,6) -- (new)代理费
    ,dealfee number(24,6) -- (new)安排费
    ,totalcast number(24,6) -- (new)总成本
    ,discountinterest number(24,6) -- (new)贴现利息
    ,purchaserinterest number(24,6) -- (new)买方应付贴现利息
    ,bargainorinterest number(24,6) -- (new)卖方应付贴现利息
    ,discountsum number(24,6) -- (new)实付贴现金额
    ,bailratio number(24,6) -- 保证金比例
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
    ,guarantyrate number(10,6) -- 抵质押率
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
    ,operateorgid varchar2(32) -- 经办机构
    ,operateuserid varchar2(32) -- 经办人
    ,operatedate varchar2(10) -- 经办日期
    ,inputorgid varchar2(32) -- 登记机构
    ,inputuserid varchar2(32) -- 登记人
    ,inputdate varchar2(10) -- 登记日期
    ,updatedate varchar2(10) -- 更新日期
    ,pigeonholedate varchar2(10) -- 归档日期
    ,remark varchar2(500) -- 备注
    ,flag4 varchar2(18) -- (new)付款币种
    ,paycurrency varchar2(18) -- (new)是否4
    ,paydate varchar2(10) -- (new)付款时间
    ,describe1 varchar2(500) -- 描述1
    ,describe2 varchar2(200) -- 描述2
    ,classifyresult varchar2(80) -- 五级分类结果
    ,classifydate varchar2(10) -- 最新风险分类时间
    ,classifyfrequency number -- 分类频率
    ,vouchnewflag varchar2(20) -- 
    ,adjustratetype varchar2(18) -- 利率调整方式
    ,adjustrateterm varchar2(18) -- 利率调整月数
    ,rateadjustcyc varchar2(18) -- 利率调整周期
    ,fzanbalance number(24,6) -- 发展商入帐净额
    ,acceptinttype varchar2(18) -- 收息类型
    ,fixcyc number -- 固定周期
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
    ,ratio number(24,6) -- 比例
    ,tempsaveflag varchar2(18) -- 暂存标志
    ,creditcycle varchar2(18) -- (new)额度是否可循环
    ,gainamount number(20,4) -- 等比（等额）递变幅度
    ,gaincyc number -- 等比（等额）递变周期
    ,holdcorpus number(20,4) -- 保留本金
    ,incomeorgid varchar2(32) -- 入账机构编号
    ,mainrepaymentmethod varchar2(10) -- 还款方式
    ,payaccountname varchar2(80) -- 还款账户名
    ,payaccountno varchar2(40) -- 还款账户
    ,paymentmode varchar2(10) -- 付款方式
    ,ratemode varchar2(10) -- 利率执行方式
    ,flag5 varchar2(10) -- (new)是否已登记审批
    ,defaultpaydate varchar2(10) -- 统一还款日
    ,batchpaymentflag varchar2(1) -- 是否参与批扣
    ,loanaccountno varchar2(32) -- 入账账户
    ,loankind varchar2(10) -- 期限类型
    ,introducerid varchar2(32) -- 介绍人编号
    ,salechannelid varchar2(32) -- 渠道单位编码
    ,bar_code_no varchar2(32) -- 资料扫描编码
    ,schemeno varchar2(20) -- 方案编号
    ,preapproverid varchar2(32) -- 面签人姓名
    ,saleteamid varchar2(32) -- 营销单位编码
    ,signedplace varchar2(30) -- 签约地点
    ,purposetype varchar2(32) -- 贷款用途
    ,qualitycontrolflag varchar2(10) -- 质量控制
    ,approvesum number(24,6) -- 最新审批金额
    ,approvelevel varchar2(10) -- 审批级别
    ,trustaccname varchar2(80) -- 提前还款申请人
    ,trustfundacctname varchar2(80) -- 推荐人姓名
    ,flag7 varchar2(18) -- 
    ,usedbailsum number(24,6) -- 已占用保证金金额
    ,subbusinesstype varchar2(32) -- 助贷默认业务品种
    ,usedsum number(24,6) -- 已占用额度
    ,orginalbusinessum number(24,6) -- 原贷款金额
    ,changetypeflag varchar2(2) -- 是否变更业务品种
    ,guarinten varchar2(18) -- 担保意向
    ,isreconsider varchar2(2) -- 是否人工申诉(1:是 2:否)
    ,reconreason varchar2(400) -- 申诉理由
    ,iscompulsapproval varchar2(2) -- 是否强制人工审批
    ,payaccountname2 varchar2(80) -- 第二还款账户名
    ,payaccountno2 varchar2(40) -- 第二还款账户
    ,housenmber1 varchar2(100) -- 房产证号
    ,houseareacode1 varchar2(6) -- 房产证地址区划代码
    ,houseadd1 varchar2(200) -- 房产证地址详细地址
    ,housetype1 varchar2(1) -- 房屋性质(住房、商住两用房、写字楼)
    ,isguaranty1 varchar2(1) -- 是否抵押
    ,persons1 varchar2(1) -- 共有产权人数
    ,havecount1 number(24,6) -- 借款人产权份额
    ,amount1 number(24,6) -- 面积
    ,price1 number(24,6) -- 均价
    ,housenmber2 varchar2(100) -- 房产证号
    ,houseareacode2 varchar2(6) -- 房产证地址区划代码
    ,houseadd2 varchar2(200) -- 房产证地址详细地址
    ,housetype2 varchar2(1) -- 房屋性质(住房、商住两用房、写字楼)
    ,isguaranty2 varchar2(1) -- 是否抵押
    ,persons2 varchar2(1) -- 共有产权人数
    ,havecount2 number(24,6) -- 借款人产权份额
    ,amount2 number(24,6) -- 面积
    ,price2 number(24,6) -- 均价
    ,ifdkqy varchar2(1) -- 是否发起代扣管理费签约
    ,iskyd varchar2(1) -- 是否快易贷
    ,corpguarserialno varchar2(32) -- 担保公司流水号
    ,guarusedsum number(24,6) -- 担保公司已占用额度
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
grant select on ${idl_schema}.oass_crss_upl_business_apply to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_crss_upl_business_apply is '微贷业务申请表';
comment on column ${idl_schema}.oass_crss_upl_business_apply.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.serialno is '流水号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.relativeserialno is '相关流水号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.occurdate is '发生日期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.customerid is '客户编号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.customername is '客户名称';
comment on column ${idl_schema}.oass_crss_upl_business_apply.businesstype is '业务品种';
comment on column ${idl_schema}.oass_crss_upl_business_apply.businesssubtype is '业务子类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.occurtype is '发生类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.fundsource is '资金来源';
comment on column ${idl_schema}.oass_crss_upl_business_apply.operatetype is '操作方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.currenylist is '可融通币种表';
comment on column ${idl_schema}.oass_crss_upl_business_apply.currencymode is '汇率计算模式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.businesstypelist is '可混用品种表';
comment on column ${idl_schema}.oass_crss_upl_business_apply.calculatemode is '额度金额占用计算模式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.useorglist is '额度可使用机构范围';
comment on column ${idl_schema}.oass_crss_upl_business_apply.cycleflag is '额度是否循环';
comment on column ${idl_schema}.oass_crss_upl_business_apply.flowreduceflag is '额度是否简化审批流程';
comment on column ${idl_schema}.oass_crss_upl_business_apply.contractflag is '额度是否需要签署协议';
comment on column ${idl_schema}.oass_crss_upl_business_apply.subcontractflag is '额度下业务是否需要签署合同';
comment on column ${idl_schema}.oass_crss_upl_business_apply.selfuseflag is '额度自用或他用';
comment on column ${idl_schema}.oass_crss_upl_business_apply.creditaggreement is '使用授信协议号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.relativeagreement is '其他相关协议号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.loanflag is '(new)是否可以直接申请出帐';
comment on column ${idl_schema}.oass_crss_upl_business_apply.totalsum is '银行融资总额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.ourrole is '我行参与角色';
comment on column ${idl_schema}.oass_crss_upl_business_apply.reversibility is '有无追索权';
comment on column ${idl_schema}.oass_crss_upl_business_apply.billnum is '票据数量（张）';
comment on column ${idl_schema}.oass_crss_upl_business_apply.housetype is '房产类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.lctermtype is '信用证期限类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.riskattribute is '风险类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.suretype is '对外担保类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.safeguardtype is '保函类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.businesscurrency is '币种';
comment on column ${idl_schema}.oass_crss_upl_business_apply.businesssum is '承贷金额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.businessprop is '贷款成数';
comment on column ${idl_schema}.oass_crss_upl_business_apply.termyear is '期限年';
comment on column ${idl_schema}.oass_crss_upl_business_apply.termmonth is '期限月';
comment on column ${idl_schema}.oass_crss_upl_business_apply.termday is '期限日';
comment on column ${idl_schema}.oass_crss_upl_business_apply.lgterm is '远期信用证付款期限';
comment on column ${idl_schema}.oass_crss_upl_business_apply.baseratetype is '基准利率类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.baserate is '基准利率';
comment on column ${idl_schema}.oass_crss_upl_business_apply.ratefloattype is '浮动类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.ratefloat is '利率浮动';
comment on column ${idl_schema}.oass_crss_upl_business_apply.businessrate is '利率';
comment on column ${idl_schema}.oass_crss_upl_business_apply.ictype is '计息方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.iccyc is '计息周期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.pdgratio is '手续费比例';
comment on column ${idl_schema}.oass_crss_upl_business_apply.pdgsum is '手续费金额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.pdgpaymethod is '手续费支付方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.pdgpayperiod is '(new)收费周期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.promisesfeeratio is '(new)承诺费率';
comment on column ${idl_schema}.oass_crss_upl_business_apply.promisesfeesum is '(new)承诺费金额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.promisesfeeperiod is '(new)承诺费计收期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.promisesfeebegin is '(new)承诺费计收起始日';
comment on column ${idl_schema}.oass_crss_upl_business_apply.mfeeratio is '托管费率';
comment on column ${idl_schema}.oass_crss_upl_business_apply.mfeesum is '管理费金额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.mfeepaymethod is '管理费支付方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.agentfee is '(new)代理费';
comment on column ${idl_schema}.oass_crss_upl_business_apply.dealfee is '(new)安排费';
comment on column ${idl_schema}.oass_crss_upl_business_apply.totalcast is '(new)总成本';
comment on column ${idl_schema}.oass_crss_upl_business_apply.discountinterest is '(new)贴现利息';
comment on column ${idl_schema}.oass_crss_upl_business_apply.purchaserinterest is '(new)买方应付贴现利息';
comment on column ${idl_schema}.oass_crss_upl_business_apply.bargainorinterest is '(new)卖方应付贴现利息';
comment on column ${idl_schema}.oass_crss_upl_business_apply.discountsum is '(new)实付贴现金额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.bailratio is '保证金比例';
comment on column ${idl_schema}.oass_crss_upl_business_apply.bailcurrency is '(new)保证金币种';
comment on column ${idl_schema}.oass_crss_upl_business_apply.bailsum is '保证金金额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.bailaccount is '保证金帐号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.fineratetype is '罚息利率类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.finerate is '罚息利率';
comment on column ${idl_schema}.oass_crss_upl_business_apply.drawingtype is '(new)提款方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.firstdrawingdate is '(new)首次提款日期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.drawingperiod is '(new)提款期限';
comment on column ${idl_schema}.oass_crss_upl_business_apply.paytimes is '还款期次';
comment on column ${idl_schema}.oass_crss_upl_business_apply.paycyc is '(new)还款方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.graceperiod is '还款宽限期(月)';
comment on column ${idl_schema}.oass_crss_upl_business_apply.overdraftperiod is '(new)连续透支期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.oldlcno is '(new)原信用证编号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.oldlctermtype is '(new)原信用证期限类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.oldlccurrency is '(new)原信用证币种';
comment on column ${idl_schema}.oass_crss_upl_business_apply.oldlcsum is '(new)原信用证金额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.oldlcloadingdate is '(new)原信用证装期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.oldlcvaliddate is '(new)原信用证效期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.direction is '投向';
comment on column ${idl_schema}.oass_crss_upl_business_apply.purpose is '用途';
comment on column ${idl_schema}.oass_crss_upl_business_apply.planallocation is '用款计划';
comment on column ${idl_schema}.oass_crss_upl_business_apply.immediacypaysource is '(new)直接还款来源';
comment on column ${idl_schema}.oass_crss_upl_business_apply.paysource is '还款来源';
comment on column ${idl_schema}.oass_crss_upl_business_apply.corpuspaymethod is '本金还款方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.interestpaymethod is '利息支付方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdparty1 is '(new)涉及第三方1';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdpartyid1 is '(new)第三方法人代码1';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdparty2 is '(new)涉及第三方2';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdpartyid2 is '(new)第三方法人代码2';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdparty3 is '(new)涉及第三方3';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdpartyid3 is '(new)第三方法人代码3';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdpartyregion is '涉及第三方所在地区和国家';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdpartyaccounts is '(new)第三方帐号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.cargoinfo is '(new)货物名称';
comment on column ${idl_schema}.oass_crss_upl_business_apply.projectname is '(new)贷款项目名称';
comment on column ${idl_schema}.oass_crss_upl_business_apply.operationinfo is '(new)业务信息';
comment on column ${idl_schema}.oass_crss_upl_business_apply.contextinfo is '(new)背景信息';
comment on column ${idl_schema}.oass_crss_upl_business_apply.securitiestype is '(new)有价证券类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.securitiesregion is '(new)有价证券发行地';
comment on column ${idl_schema}.oass_crss_upl_business_apply.constructionarea is '(new)建筑面积';
comment on column ${idl_schema}.oass_crss_upl_business_apply.usearea is '(new)使用面积';
comment on column ${idl_schema}.oass_crss_upl_business_apply.flag1 is '(new)是否1';
comment on column ${idl_schema}.oass_crss_upl_business_apply.flag2 is '(new)是否2';
comment on column ${idl_schema}.oass_crss_upl_business_apply.flag3 is '(new)是否3';
comment on column ${idl_schema}.oass_crss_upl_business_apply.tradecontractno is '(new)相关贸易合同号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.invoiceno is '(new)增值税发票';
comment on column ${idl_schema}.oass_crss_upl_business_apply.tradecurrency is '(new)贸易合同币种';
comment on column ${idl_schema}.oass_crss_upl_business_apply.tradesum is '(new)贸易合同金额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.paymentdate is '(new)最迟对外付汇日期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.operationmode is '(new)业务模式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.vouchclass is '担保形式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.vouchtype is '主要担保方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.vouchtype1 is '担保方式1';
comment on column ${idl_schema}.oass_crss_upl_business_apply.vouchtype2 is '担保方式2';
comment on column ${idl_schema}.oass_crss_upl_business_apply.vouchflag is '(new)有无其他担保方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.warrantor is '主要担保人';
comment on column ${idl_schema}.oass_crss_upl_business_apply.warrantorid is '主要担保人代码';
comment on column ${idl_schema}.oass_crss_upl_business_apply.othercondition is '(new)其他条件和要求';
comment on column ${idl_schema}.oass_crss_upl_business_apply.guarantyvalue is '担保总价值';
comment on column ${idl_schema}.oass_crss_upl_business_apply.guarantyrate is '抵质押率';
comment on column ${idl_schema}.oass_crss_upl_business_apply.baseevaluateresult is '基期信用等级';
comment on column ${idl_schema}.oass_crss_upl_business_apply.riskrate is '综合风险度';
comment on column ${idl_schema}.oass_crss_upl_business_apply.lowrisk is '是否低风险业务';
comment on column ${idl_schema}.oass_crss_upl_business_apply.otherarealoan is '(new)是否异地贷款';
comment on column ${idl_schema}.oass_crss_upl_business_apply.lowriskbailsum is '低风险担保金额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.originalputoutdate is '首次发放日';
comment on column ${idl_schema}.oass_crss_upl_business_apply.extendtimes is '展期次数';
comment on column ${idl_schema}.oass_crss_upl_business_apply.lngotimes is '借新还旧次数';
comment on column ${idl_schema}.oass_crss_upl_business_apply.golntimes is '还旧借新次数';
comment on column ${idl_schema}.oass_crss_upl_business_apply.drtimes is '债务重组次数';
comment on column ${idl_schema}.oass_crss_upl_business_apply.baseclassifyresult is '基期风险分类结果';
comment on column ${idl_schema}.oass_crss_upl_business_apply.applytype is '申请方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.bailrate is '保证金比率';
comment on column ${idl_schema}.oass_crss_upl_business_apply.finishorg is '终批机构级别';
comment on column ${idl_schema}.oass_crss_upl_business_apply.operateorgid is '经办机构';
comment on column ${idl_schema}.oass_crss_upl_business_apply.operateuserid is '经办人';
comment on column ${idl_schema}.oass_crss_upl_business_apply.operatedate is '经办日期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.inputorgid is '登记机构';
comment on column ${idl_schema}.oass_crss_upl_business_apply.inputuserid is '登记人';
comment on column ${idl_schema}.oass_crss_upl_business_apply.inputdate is '登记日期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.updatedate is '更新日期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.pigeonholedate is '归档日期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.remark is '备注';
comment on column ${idl_schema}.oass_crss_upl_business_apply.flag4 is '(new)付款币种';
comment on column ${idl_schema}.oass_crss_upl_business_apply.paycurrency is '(new)是否4';
comment on column ${idl_schema}.oass_crss_upl_business_apply.paydate is '(new)付款时间';
comment on column ${idl_schema}.oass_crss_upl_business_apply.describe1 is '描述1';
comment on column ${idl_schema}.oass_crss_upl_business_apply.describe2 is '描述2';
comment on column ${idl_schema}.oass_crss_upl_business_apply.classifyresult is '五级分类结果';
comment on column ${idl_schema}.oass_crss_upl_business_apply.classifydate is '最新风险分类时间';
comment on column ${idl_schema}.oass_crss_upl_business_apply.classifyfrequency is '分类频率';
comment on column ${idl_schema}.oass_crss_upl_business_apply.vouchnewflag is '';
comment on column ${idl_schema}.oass_crss_upl_business_apply.adjustratetype is '利率调整方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.adjustrateterm is '利率调整月数';
comment on column ${idl_schema}.oass_crss_upl_business_apply.rateadjustcyc is '利率调整周期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.fzanbalance is '发展商入帐净额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.acceptinttype is '收息类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.fixcyc is '固定周期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdpartyadd1 is '(new)涉及第三方地址1';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdpartyzip1 is '(new)第三方法人邮编1';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdpartyadd2 is '(new)涉及第三方地址2';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdpartyzip2 is '(new)第三方法人邮编2';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdpartyadd3 is '(new)涉及第三方地址3';
comment on column ${idl_schema}.oass_crss_upl_business_apply.thirdpartyzip3 is '(new)第三方法人邮编3';
comment on column ${idl_schema}.oass_crss_upl_business_apply.effectarea is '信用证有效地';
comment on column ${idl_schema}.oass_crss_upl_business_apply.termdate1 is '最晚装运期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.termdate2 is '交单期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.termdate3 is '付款期限';
comment on column ${idl_schema}.oass_crss_upl_business_apply.ratio is '比例';
comment on column ${idl_schema}.oass_crss_upl_business_apply.tempsaveflag is '暂存标志';
comment on column ${idl_schema}.oass_crss_upl_business_apply.creditcycle is '(new)额度是否可循环';
comment on column ${idl_schema}.oass_crss_upl_business_apply.gainamount is '等比（等额）递变幅度';
comment on column ${idl_schema}.oass_crss_upl_business_apply.gaincyc is '等比（等额）递变周期';
comment on column ${idl_schema}.oass_crss_upl_business_apply.holdcorpus is '保留本金';
comment on column ${idl_schema}.oass_crss_upl_business_apply.incomeorgid is '入账机构编号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.mainrepaymentmethod is '还款方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.payaccountname is '还款账户名';
comment on column ${idl_schema}.oass_crss_upl_business_apply.payaccountno is '还款账户';
comment on column ${idl_schema}.oass_crss_upl_business_apply.paymentmode is '付款方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.ratemode is '利率执行方式';
comment on column ${idl_schema}.oass_crss_upl_business_apply.flag5 is '(new)是否已登记审批';
comment on column ${idl_schema}.oass_crss_upl_business_apply.defaultpaydate is '统一还款日';
comment on column ${idl_schema}.oass_crss_upl_business_apply.batchpaymentflag is '是否参与批扣';
comment on column ${idl_schema}.oass_crss_upl_business_apply.loanaccountno is '入账账户';
comment on column ${idl_schema}.oass_crss_upl_business_apply.loankind is '期限类型';
comment on column ${idl_schema}.oass_crss_upl_business_apply.introducerid is '介绍人编号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.salechannelid is '渠道单位编码';
comment on column ${idl_schema}.oass_crss_upl_business_apply.bar_code_no is '资料扫描编码';
comment on column ${idl_schema}.oass_crss_upl_business_apply.schemeno is '方案编号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.preapproverid is '面签人姓名';
comment on column ${idl_schema}.oass_crss_upl_business_apply.saleteamid is '营销单位编码';
comment on column ${idl_schema}.oass_crss_upl_business_apply.signedplace is '签约地点';
comment on column ${idl_schema}.oass_crss_upl_business_apply.purposetype is '贷款用途';
comment on column ${idl_schema}.oass_crss_upl_business_apply.qualitycontrolflag is '质量控制';
comment on column ${idl_schema}.oass_crss_upl_business_apply.approvesum is '最新审批金额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.approvelevel is '审批级别';
comment on column ${idl_schema}.oass_crss_upl_business_apply.trustaccname is '提前还款申请人';
comment on column ${idl_schema}.oass_crss_upl_business_apply.trustfundacctname is '推荐人姓名';
comment on column ${idl_schema}.oass_crss_upl_business_apply.flag7 is '';
comment on column ${idl_schema}.oass_crss_upl_business_apply.usedbailsum is '已占用保证金金额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.subbusinesstype is '助贷默认业务品种';
comment on column ${idl_schema}.oass_crss_upl_business_apply.usedsum is '已占用额度';
comment on column ${idl_schema}.oass_crss_upl_business_apply.orginalbusinessum is '原贷款金额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.changetypeflag is '是否变更业务品种';
comment on column ${idl_schema}.oass_crss_upl_business_apply.guarinten is '担保意向';
comment on column ${idl_schema}.oass_crss_upl_business_apply.isreconsider is '是否人工申诉(1:是 2:否)';
comment on column ${idl_schema}.oass_crss_upl_business_apply.reconreason is '申诉理由';
comment on column ${idl_schema}.oass_crss_upl_business_apply.iscompulsapproval is '是否强制人工审批';
comment on column ${idl_schema}.oass_crss_upl_business_apply.payaccountname2 is '第二还款账户名';
comment on column ${idl_schema}.oass_crss_upl_business_apply.payaccountno2 is '第二还款账户';
comment on column ${idl_schema}.oass_crss_upl_business_apply.housenmber1 is '房产证号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.houseareacode1 is '房产证地址区划代码';
comment on column ${idl_schema}.oass_crss_upl_business_apply.houseadd1 is '房产证地址详细地址';
comment on column ${idl_schema}.oass_crss_upl_business_apply.housetype1 is '房屋性质(住房、商住两用房、写字楼)';
comment on column ${idl_schema}.oass_crss_upl_business_apply.isguaranty1 is '是否抵押';
comment on column ${idl_schema}.oass_crss_upl_business_apply.persons1 is '共有产权人数';
comment on column ${idl_schema}.oass_crss_upl_business_apply.havecount1 is '借款人产权份额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.amount1 is '面积';
comment on column ${idl_schema}.oass_crss_upl_business_apply.price1 is '均价';
comment on column ${idl_schema}.oass_crss_upl_business_apply.housenmber2 is '房产证号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.houseareacode2 is '房产证地址区划代码';
comment on column ${idl_schema}.oass_crss_upl_business_apply.houseadd2 is '房产证地址详细地址';
comment on column ${idl_schema}.oass_crss_upl_business_apply.housetype2 is '房屋性质(住房、商住两用房、写字楼)';
comment on column ${idl_schema}.oass_crss_upl_business_apply.isguaranty2 is '是否抵押';
comment on column ${idl_schema}.oass_crss_upl_business_apply.persons2 is '共有产权人数';
comment on column ${idl_schema}.oass_crss_upl_business_apply.havecount2 is '借款人产权份额';
comment on column ${idl_schema}.oass_crss_upl_business_apply.amount2 is '面积';
comment on column ${idl_schema}.oass_crss_upl_business_apply.price2 is '均价';
comment on column ${idl_schema}.oass_crss_upl_business_apply.ifdkqy is '是否发起代扣管理费签约';
comment on column ${idl_schema}.oass_crss_upl_business_apply.iskyd is '是否快易贷';
comment on column ${idl_schema}.oass_crss_upl_business_apply.corpguarserialno is '担保公司流水号';
comment on column ${idl_schema}.oass_crss_upl_business_apply.guarusedsum is '担保公司已占用额度';
comment on column ${idl_schema}.oass_crss_upl_business_apply.start_dt is '';
comment on column ${idl_schema}.oass_crss_upl_business_apply.end_dt is '';
comment on column ${idl_schema}.oass_crss_upl_business_apply.id_mark is '';
comment on column ${idl_schema}.oass_crss_upl_business_apply.etl_timestamp is '';
