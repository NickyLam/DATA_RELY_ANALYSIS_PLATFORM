/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_crss_upl_business_apply
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.oass_crss_upl_business_apply drop partition p_${retain_week};
alter table ${idl_schema}.oass_crss_upl_business_apply drop partition p_${batch_date};


-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_crss_upl_business_apply add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_crss_upl_business_apply (
    etl_dt  -- 数据日期
    ,serialno  -- 流水号
    ,relativeserialno  -- 相关流水号
    ,occurdate  -- 发生日期
    ,customerid  -- 客户编号
    ,customername  -- 客户名称
    ,businesstype  -- 业务品种
    ,businesssubtype  -- 业务子类型
    ,occurtype  -- 发生类型
    ,fundsource  -- 资金来源
    ,operatetype  -- 操作方式
    ,currenylist  -- 可融通币种表
    ,currencymode  -- 汇率计算模式
    ,businesstypelist  -- 可混用品种表
    ,calculatemode  -- 额度金额占用计算模式
    ,useorglist  -- 额度可使用机构范围
    ,cycleflag  -- 额度是否循环
    ,flowreduceflag  -- 额度是否简化审批流程
    ,contractflag  -- 额度是否需要签署协议
    ,subcontractflag  -- 额度下业务是否需要签署合同
    ,selfuseflag  -- 额度自用或他用
    ,creditaggreement  -- 使用授信协议号
    ,relativeagreement  -- 其他相关协议号
    ,loanflag  -- (new)是否可以直接申请出帐
    ,totalsum  -- 银行融资总额
    ,ourrole  -- 我行参与角色
    ,reversibility  -- 有无追索权
    ,billnum  -- 票据数量（张）
    ,housetype  -- 房产类型
    ,lctermtype  -- 信用证期限类型
    ,riskattribute  -- 风险类型
    ,suretype  -- 对外担保类型
    ,safeguardtype  -- 保函类型
    ,businesscurrency  -- 币种
    ,businesssum  -- 承贷金额
    ,businessprop  -- 贷款成数
    ,termyear  -- 期限年
    ,termmonth  -- 期限月
    ,termday  -- 期限日
    ,lgterm  -- 远期信用证付款期限
    ,baseratetype  -- 基准利率类型
    ,baserate  -- 基准利率
    ,ratefloattype  -- 浮动类型
    ,ratefloat  -- 利率浮动
    ,businessrate  -- 利率
    ,ictype  -- 计息方式
    ,iccyc  -- 计息周期
    ,pdgratio  -- 手续费比例
    ,pdgsum  -- 手续费金额
    ,pdgpaymethod  -- 手续费支付方式
    ,pdgpayperiod  -- (new)收费周期
    ,promisesfeeratio  -- (new)承诺费率
    ,promisesfeesum  -- (new)承诺费金额
    ,promisesfeeperiod  -- (new)承诺费计收期
    ,promisesfeebegin  -- (new)承诺费计收起始日
    ,mfeeratio  -- 托管费率
    ,mfeesum  -- 管理费金额
    ,mfeepaymethod  -- 管理费支付方式
    ,agentfee  -- (new)代理费
    ,dealfee  -- (new)安排费
    ,totalcast  -- (new)总成本
    ,discountinterest  -- (new)贴现利息
    ,purchaserinterest  -- (new)买方应付贴现利息
    ,bargainorinterest  -- (new)卖方应付贴现利息
    ,discountsum  -- (new)实付贴现金额
    ,bailratio  -- 保证金比例
    ,bailcurrency  -- (new)保证金币种
    ,bailsum  -- 保证金金额
    ,bailaccount  -- 保证金帐号
    ,fineratetype  -- 罚息利率类型
    ,finerate  -- 罚息利率
    ,drawingtype  -- (new)提款方式
    ,firstdrawingdate  -- (new)首次提款日期
    ,drawingperiod  -- (new)提款期限
    ,paytimes  -- 还款期次
    ,paycyc  -- (new)还款方式
    ,graceperiod  -- 还款宽限期(月)
    ,overdraftperiod  -- (new)连续透支期
    ,oldlcno  -- (new)原信用证编号
    ,oldlctermtype  -- (new)原信用证期限类型
    ,oldlccurrency  -- (new)原信用证币种
    ,oldlcsum  -- (new)原信用证金额
    ,oldlcloadingdate  -- (new)原信用证装期
    ,oldlcvaliddate  -- (new)原信用证效期
    ,direction  -- 投向
    ,purpose  -- 用途
    ,planallocation  -- 用款计划
    ,immediacypaysource  -- (new)直接还款来源
    ,paysource  -- 还款来源
    ,corpuspaymethod  -- 本金还款方式
    ,interestpaymethod  -- 利息支付方式
    ,thirdparty1  -- (new)涉及第三方1
    ,thirdpartyid1  -- (new)第三方法人代码1
    ,thirdparty2  -- (new)涉及第三方2
    ,thirdpartyid2  -- (new)第三方法人代码2
    ,thirdparty3  -- (new)涉及第三方3
    ,thirdpartyid3  -- (new)第三方法人代码3
    ,thirdpartyregion  -- 涉及第三方所在地区和国家
    ,thirdpartyaccounts  -- (new)第三方帐号
    ,cargoinfo  -- (new)货物名称
    ,projectname  -- (new)贷款项目名称
    ,operationinfo  -- (new)业务信息
    ,contextinfo  -- (new)背景信息
    ,securitiestype  -- (new)有价证券类型
    ,securitiesregion  -- (new)有价证券发行地
    ,constructionarea  -- (new)建筑面积
    ,usearea  -- (new)使用面积
    ,flag1  -- (new)是否1
    ,flag2  -- (new)是否2
    ,flag3  -- (new)是否3
    ,tradecontractno  -- (new)相关贸易合同号
    ,invoiceno  -- (new)增值税发票
    ,tradecurrency  -- (new)贸易合同币种
    ,tradesum  -- (new)贸易合同金额
    ,paymentdate  -- (new)最迟对外付汇日期
    ,operationmode  -- (new)业务模式
    ,vouchclass  -- 担保形式
    ,vouchtype  -- 主要担保方式
    ,vouchtype1  -- 担保方式1
    ,vouchtype2  -- 担保方式2
    ,vouchflag  -- (new)有无其他担保方式
    ,warrantor  -- 主要担保人
    ,warrantorid  -- 主要担保人代码
    ,othercondition  -- (new)其他条件和要求
    ,guarantyvalue  -- 担保总价值
    ,guarantyrate  -- 抵质押率
    ,baseevaluateresult  -- 基期信用等级
    ,riskrate  -- 综合风险度
    ,lowrisk  -- 是否低风险业务
    ,otherarealoan  -- (new)是否异地贷款
    ,lowriskbailsum  -- 低风险担保金额
    ,originalputoutdate  -- 首次发放日
    ,extendtimes  -- 展期次数
    ,lngotimes  -- 借新还旧次数
    ,golntimes  -- 还旧借新次数
    ,drtimes  -- 债务重组次数
    ,baseclassifyresult  -- 基期风险分类结果
    ,applytype  -- 申请方式
    ,bailrate  -- 保证金比率
    ,finishorg  -- 终批机构级别
    ,operateorgid  -- 经办机构
    ,operateuserid  -- 经办人
    ,operatedate  -- 经办日期
    ,inputorgid  -- 登记机构
    ,inputuserid  -- 登记人
    ,inputdate  -- 登记日期
    ,updatedate  -- 更新日期
    ,pigeonholedate  -- 归档日期
    ,remark  -- 备注
    ,flag4  -- (new)付款币种
    ,paycurrency  -- (new)是否4
    ,paydate  -- (new)付款时间
    ,describe1  -- 描述1
    ,describe2  -- 描述2
    ,classifyresult  -- 五级分类结果
    ,classifydate  -- 最新风险分类时间
    ,classifyfrequency  -- 分类频率
    ,vouchnewflag  -- 
    ,adjustratetype  -- 利率调整方式
    ,adjustrateterm  -- 利率调整月数
    ,rateadjustcyc  -- 利率调整周期
    ,fzanbalance  -- 发展商入帐净额
    ,acceptinttype  -- 收息类型
    ,fixcyc  -- 固定周期
    ,thirdpartyadd1  -- (new)涉及第三方地址1
    ,thirdpartyzip1  -- (new)第三方法人邮编1
    ,thirdpartyadd2  -- (new)涉及第三方地址2
    ,thirdpartyzip2  -- (new)第三方法人邮编2
    ,thirdpartyadd3  -- (new)涉及第三方地址3
    ,thirdpartyzip3  -- (new)第三方法人邮编3
    ,effectarea  -- 信用证有效地
    ,termdate1  -- 最晚装运期
    ,termdate2  -- 交单期
    ,termdate3  -- 付款期限
    ,ratio  -- 比例
    ,tempsaveflag  -- 暂存标志
    ,creditcycle  -- (new)额度是否可循环
    ,gainamount  -- 等比（等额）递变幅度
    ,gaincyc  -- 等比（等额）递变周期
    ,holdcorpus  -- 保留本金
    ,incomeorgid  -- 入账机构编号
    ,mainrepaymentmethod  -- 还款方式
    ,payaccountname  -- 还款账户名
    ,payaccountno  -- 还款账户
    ,paymentmode  -- 付款方式
    ,ratemode  -- 利率执行方式
    ,flag5  -- (new)是否已登记审批
    ,defaultpaydate  -- 统一还款日
    ,batchpaymentflag  -- 是否参与批扣
    ,loanaccountno  -- 入账账户
    ,loankind  -- 期限类型
    ,introducerid  -- 介绍人编号
    ,salechannelid  -- 渠道单位编码
    ,bar_code_no  -- 资料扫描编码
    ,schemeno  -- 方案编号
    ,preapproverid  -- 面签人姓名
    ,saleteamid  -- 营销单位编码
    ,signedplace  -- 签约地点
    ,purposetype  -- 贷款用途
    ,qualitycontrolflag  -- 质量控制
    ,approvesum  -- 最新审批金额
    ,approvelevel  -- 审批级别
    ,trustaccname  -- 提前还款申请人
    ,trustfundacctname  -- 推荐人姓名
    ,flag7  -- 
    ,usedbailsum  -- 已占用保证金金额
    ,subbusinesstype  -- 助贷默认业务品种
    ,usedsum  -- 已占用额度
    ,orginalbusinessum  -- 原贷款金额
    ,changetypeflag  -- 是否变更业务品种
    ,guarinten  -- 担保意向
    ,isreconsider  -- 是否人工申诉(1:是 2:否)
    ,reconreason  -- 申诉理由
    ,iscompulsapproval  -- 是否强制人工审批
    ,payaccountname2  -- 第二还款账户名
    ,payaccountno2  -- 第二还款账户
    ,housenmber1  -- 房产证号
    ,houseareacode1  -- 房产证地址区划代码
    ,houseadd1  -- 房产证地址详细地址
    ,housetype1  -- 房屋性质(住房、商住两用房、写字楼)
    ,isguaranty1  -- 是否抵押
    ,persons1  -- 共有产权人数
    ,havecount1  -- 借款人产权份额
    ,amount1  -- 面积
    ,price1  -- 均价
    ,housenmber2  -- 房产证号
    ,houseareacode2  -- 房产证地址区划代码
    ,houseadd2  -- 房产证地址详细地址
    ,housetype2  -- 房屋性质(住房、商住两用房、写字楼)
    ,isguaranty2  -- 是否抵押
    ,persons2  -- 共有产权人数
    ,havecount2  -- 借款人产权份额
    ,amount2  -- 面积
    ,price2  -- 均价
    ,ifdkqy  -- 是否发起代扣管理费签约
    ,iskyd  -- 是否快易贷
    ,corpguarserialno  -- 担保公司流水号
    ,guarusedsum  -- 担保公司已占用额度
    ,start_dt  -- 
    ,end_dt  -- 
    ,id_mark  -- 
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.serialno,chr(13),''),chr(10),'')  -- 流水号
    ,replace(replace(t1.relativeserialno,chr(13),''),chr(10),'')  -- 相关流水号
    ,replace(replace(t1.occurdate,chr(13),''),chr(10),'')  -- 发生日期
    ,replace(replace(t1.customerid,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.customername,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.businesstype,chr(13),''),chr(10),'')  -- 业务品种
    ,replace(replace(t1.businesssubtype,chr(13),''),chr(10),'')  -- 业务子类型
    ,replace(replace(t1.occurtype,chr(13),''),chr(10),'')  -- 发生类型
    ,replace(replace(t1.fundsource,chr(13),''),chr(10),'')  -- 资金来源
    ,replace(replace(t1.operatetype,chr(13),''),chr(10),'')  -- 操作方式
    ,replace(replace(t1.currenylist,chr(13),''),chr(10),'')  -- 可融通币种表
    ,replace(replace(t1.currencymode,chr(13),''),chr(10),'')  -- 汇率计算模式
    ,replace(replace(t1.businesstypelist,chr(13),''),chr(10),'')  -- 可混用品种表
    ,replace(replace(t1.calculatemode,chr(13),''),chr(10),'')  -- 额度金额占用计算模式
    ,replace(replace(t1.useorglist,chr(13),''),chr(10),'')  -- 额度可使用机构范围
    ,replace(replace(t1.cycleflag,chr(13),''),chr(10),'')  -- 额度是否循环
    ,replace(replace(t1.flowreduceflag,chr(13),''),chr(10),'')  -- 额度是否简化审批流程
    ,replace(replace(t1.contractflag,chr(13),''),chr(10),'')  -- 额度是否需要签署协议
    ,replace(replace(t1.subcontractflag,chr(13),''),chr(10),'')  -- 额度下业务是否需要签署合同
    ,replace(replace(t1.selfuseflag,chr(13),''),chr(10),'')  -- 额度自用或他用
    ,replace(replace(t1.creditaggreement,chr(13),''),chr(10),'')  -- 使用授信协议号
    ,replace(replace(t1.relativeagreement,chr(13),''),chr(10),'')  -- 其他相关协议号
    ,replace(replace(t1.loanflag,chr(13),''),chr(10),'')  -- (new)是否可以直接申请出帐
    ,t1.totalsum  -- 银行融资总额
    ,replace(replace(t1.ourrole,chr(13),''),chr(10),'')  -- 我行参与角色
    ,replace(replace(t1.reversibility,chr(13),''),chr(10),'')  -- 有无追索权
    ,t1.billnum  -- 票据数量（张）
    ,replace(replace(t1.housetype,chr(13),''),chr(10),'')  -- 房产类型
    ,replace(replace(t1.lctermtype,chr(13),''),chr(10),'')  -- 信用证期限类型
    ,replace(replace(t1.riskattribute,chr(13),''),chr(10),'')  -- 风险类型
    ,replace(replace(t1.suretype,chr(13),''),chr(10),'')  -- 对外担保类型
    ,replace(replace(t1.safeguardtype,chr(13),''),chr(10),'')  -- 保函类型
    ,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'')  -- 币种
    ,t1.businesssum  -- 承贷金额
    ,t1.businessprop  -- 贷款成数
    ,t1.termyear  -- 期限年
    ,t1.termmonth  -- 期限月
    ,t1.termday  -- 期限日
    ,t1.lgterm  -- 远期信用证付款期限
    ,replace(replace(t1.baseratetype,chr(13),''),chr(10),'')  -- 基准利率类型
    ,t1.baserate  -- 基准利率
    ,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'')  -- 浮动类型
    ,t1.ratefloat  -- 利率浮动
    ,t1.businessrate  -- 利率
    ,replace(replace(t1.ictype,chr(13),''),chr(10),'')  -- 计息方式
    ,replace(replace(t1.iccyc,chr(13),''),chr(10),'')  -- 计息周期
    ,t1.pdgratio  -- 手续费比例
    ,t1.pdgsum  -- 手续费金额
    ,replace(replace(t1.pdgpaymethod,chr(13),''),chr(10),'')  -- 手续费支付方式
    ,replace(replace(t1.pdgpayperiod,chr(13),''),chr(10),'')  -- (new)收费周期
    ,t1.promisesfeeratio  -- (new)承诺费率
    ,t1.promisesfeesum  -- (new)承诺费金额
    ,t1.promisesfeeperiod  -- (new)承诺费计收期
    ,replace(replace(t1.promisesfeebegin,chr(13),''),chr(10),'')  -- (new)承诺费计收起始日
    ,t1.mfeeratio  -- 托管费率
    ,t1.mfeesum  -- 管理费金额
    ,replace(replace(t1.mfeepaymethod,chr(13),''),chr(10),'')  -- 管理费支付方式
    ,t1.agentfee  -- (new)代理费
    ,t1.dealfee  -- (new)安排费
    ,t1.totalcast  -- (new)总成本
    ,t1.discountinterest  -- (new)贴现利息
    ,t1.purchaserinterest  -- (new)买方应付贴现利息
    ,t1.bargainorinterest  -- (new)卖方应付贴现利息
    ,t1.discountsum  -- (new)实付贴现金额
    ,t1.bailratio  -- 保证金比例
    ,replace(replace(t1.bailcurrency,chr(13),''),chr(10),'')  -- (new)保证金币种
    ,t1.bailsum  -- 保证金金额
    ,replace(replace(t1.bailaccount,chr(13),''),chr(10),'')  -- 保证金帐号
    ,replace(replace(t1.fineratetype,chr(13),''),chr(10),'')  -- 罚息利率类型
    ,t1.finerate  -- 罚息利率
    ,replace(replace(t1.drawingtype,chr(13),''),chr(10),'')  -- (new)提款方式
    ,replace(replace(t1.firstdrawingdate,chr(13),''),chr(10),'')  -- (new)首次提款日期
    ,t1.drawingperiod  -- (new)提款期限
    ,t1.paytimes  -- 还款期次
    ,replace(replace(t1.paycyc,chr(13),''),chr(10),'')  -- (new)还款方式
    ,t1.graceperiod  -- 还款宽限期(月)
    ,t1.overdraftperiod  -- (new)连续透支期
    ,replace(replace(t1.oldlcno,chr(13),''),chr(10),'')  -- (new)原信用证编号
    ,replace(replace(t1.oldlctermtype,chr(13),''),chr(10),'')  -- (new)原信用证期限类型
    ,replace(replace(t1.oldlccurrency,chr(13),''),chr(10),'')  -- (new)原信用证币种
    ,t1.oldlcsum  -- (new)原信用证金额
    ,replace(replace(t1.oldlcloadingdate,chr(13),''),chr(10),'')  -- (new)原信用证装期
    ,replace(replace(t1.oldlcvaliddate,chr(13),''),chr(10),'')  -- (new)原信用证效期
    ,replace(replace(t1.direction,chr(13),''),chr(10),'')  -- 投向
    ,replace(replace(t1.purpose,chr(13),''),chr(10),'')  -- 用途
    ,replace(replace(t1.planallocation,chr(13),''),chr(10),'')  -- 用款计划
    ,replace(replace(t1.immediacypaysource,chr(13),''),chr(10),'')  -- (new)直接还款来源
    ,replace(replace(t1.paysource,chr(13),''),chr(10),'')  -- 还款来源
    ,replace(replace(t1.corpuspaymethod,chr(13),''),chr(10),'')  -- 本金还款方式
    ,replace(replace(t1.interestpaymethod,chr(13),''),chr(10),'')  -- 利息支付方式
    ,replace(replace(t1.thirdparty1,chr(13),''),chr(10),'')  -- (new)涉及第三方1
    ,replace(replace(t1.thirdpartyid1,chr(13),''),chr(10),'')  -- (new)第三方法人代码1
    ,replace(replace(t1.thirdparty2,chr(13),''),chr(10),'')  -- (new)涉及第三方2
    ,replace(replace(t1.thirdpartyid2,chr(13),''),chr(10),'')  -- (new)第三方法人代码2
    ,replace(replace(t1.thirdparty3,chr(13),''),chr(10),'')  -- (new)涉及第三方3
    ,replace(replace(t1.thirdpartyid3,chr(13),''),chr(10),'')  -- (new)第三方法人代码3
    ,replace(replace(t1.thirdpartyregion,chr(13),''),chr(10),'')  -- 涉及第三方所在地区和国家
    ,replace(replace(t1.thirdpartyaccounts,chr(13),''),chr(10),'')  -- (new)第三方帐号
    ,replace(replace(t1.cargoinfo,chr(13),''),chr(10),'')  -- (new)货物名称
    ,replace(replace(t1.projectname,chr(13),''),chr(10),'')  -- (new)贷款项目名称
    ,replace(replace(t1.operationinfo,chr(13),''),chr(10),'')  -- (new)业务信息
    ,replace(replace(t1.contextinfo,chr(13),''),chr(10),'')  -- (new)背景信息
    ,replace(replace(t1.securitiestype,chr(13),''),chr(10),'')  -- (new)有价证券类型
    ,replace(replace(t1.securitiesregion,chr(13),''),chr(10),'')  -- (new)有价证券发行地
    ,t1.constructionarea  -- (new)建筑面积
    ,t1.usearea  -- (new)使用面积
    ,replace(replace(t1.flag1,chr(13),''),chr(10),'')  -- (new)是否1
    ,replace(replace(t1.flag2,chr(13),''),chr(10),'')  -- (new)是否2
    ,replace(replace(t1.flag3,chr(13),''),chr(10),'')  -- (new)是否3
    ,replace(replace(t1.tradecontractno,chr(13),''),chr(10),'')  -- (new)相关贸易合同号
    ,replace(replace(t1.invoiceno,chr(13),''),chr(10),'')  -- (new)增值税发票
    ,replace(replace(t1.tradecurrency,chr(13),''),chr(10),'')  -- (new)贸易合同币种
    ,t1.tradesum  -- (new)贸易合同金额
    ,replace(replace(t1.paymentdate,chr(13),''),chr(10),'')  -- (new)最迟对外付汇日期
    ,replace(replace(t1.operationmode,chr(13),''),chr(10),'')  -- (new)业务模式
    ,replace(replace(t1.vouchclass,chr(13),''),chr(10),'')  -- 担保形式
    ,replace(replace(t1.vouchtype,chr(13),''),chr(10),'')  -- 主要担保方式
    ,replace(replace(t1.vouchtype1,chr(13),''),chr(10),'')  -- 担保方式1
    ,replace(replace(t1.vouchtype2,chr(13),''),chr(10),'')  -- 担保方式2
    ,replace(replace(t1.vouchflag,chr(13),''),chr(10),'')  -- (new)有无其他担保方式
    ,replace(replace(t1.warrantor,chr(13),''),chr(10),'')  -- 主要担保人
    ,replace(replace(t1.warrantorid,chr(13),''),chr(10),'')  -- 主要担保人代码
    ,replace(replace(t1.othercondition,chr(13),''),chr(10),'')  -- (new)其他条件和要求
    ,t1.guarantyvalue  -- 担保总价值
    ,t1.guarantyrate  -- 抵质押率
    ,replace(replace(t1.baseevaluateresult,chr(13),''),chr(10),'')  -- 基期信用等级
    ,t1.riskrate  -- 综合风险度
    ,replace(replace(t1.lowrisk,chr(13),''),chr(10),'')  -- 是否低风险业务
    ,replace(replace(t1.otherarealoan,chr(13),''),chr(10),'')  -- (new)是否异地贷款
    ,t1.lowriskbailsum  -- 低风险担保金额
    ,replace(replace(t1.originalputoutdate,chr(13),''),chr(10),'')  -- 首次发放日
    ,t1.extendtimes  -- 展期次数
    ,t1.lngotimes  -- 借新还旧次数
    ,t1.golntimes  -- 还旧借新次数
    ,t1.drtimes  -- 债务重组次数
    ,replace(replace(t1.baseclassifyresult,chr(13),''),chr(10),'')  -- 基期风险分类结果
    ,replace(replace(t1.applytype,chr(13),''),chr(10),'')  -- 申请方式
    ,t1.bailrate  -- 保证金比率
    ,replace(replace(t1.finishorg,chr(13),''),chr(10),'')  -- 终批机构级别
    ,replace(replace(t1.operateorgid,chr(13),''),chr(10),'')  -- 经办机构
    ,replace(replace(t1.operateuserid,chr(13),''),chr(10),'')  -- 经办人
    ,replace(replace(t1.operatedate,chr(13),''),chr(10),'')  -- 经办日期
    ,replace(replace(t1.inputorgid,chr(13),''),chr(10),'')  -- 登记机构
    ,replace(replace(t1.inputuserid,chr(13),''),chr(10),'')  -- 登记人
    ,replace(replace(t1.inputdate,chr(13),''),chr(10),'')  -- 登记日期
    ,replace(replace(t1.updatedate,chr(13),''),chr(10),'')  -- 更新日期
    ,replace(replace(t1.pigeonholedate,chr(13),''),chr(10),'')  -- 归档日期
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.flag4,chr(13),''),chr(10),'')  -- (new)付款币种
    ,replace(replace(t1.paycurrency,chr(13),''),chr(10),'')  -- (new)是否4
    ,replace(replace(t1.paydate,chr(13),''),chr(10),'')  -- (new)付款时间
    ,replace(replace(t1.describe1,chr(13),''),chr(10),'')  -- 描述1
    ,replace(replace(t1.describe2,chr(13),''),chr(10),'')  -- 描述2
    ,replace(replace(t1.classifyresult,chr(13),''),chr(10),'')  -- 五级分类结果
    ,replace(replace(t1.classifydate,chr(13),''),chr(10),'')  -- 最新风险分类时间
    ,t1.classifyfrequency  -- 分类频率
    ,replace(replace(t1.vouchnewflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.adjustratetype,chr(13),''),chr(10),'')  -- 利率调整方式
    ,replace(replace(t1.adjustrateterm,chr(13),''),chr(10),'')  -- 利率调整月数
    ,replace(replace(t1.rateadjustcyc,chr(13),''),chr(10),'')  -- 利率调整周期
    ,t1.fzanbalance  -- 发展商入帐净额
    ,replace(replace(t1.acceptinttype,chr(13),''),chr(10),'')  -- 收息类型
    ,t1.fixcyc  -- 固定周期
    ,replace(replace(t1.thirdpartyadd1,chr(13),''),chr(10),'')  -- (new)涉及第三方地址1
    ,replace(replace(t1.thirdpartyzip1,chr(13),''),chr(10),'')  -- (new)第三方法人邮编1
    ,replace(replace(t1.thirdpartyadd2,chr(13),''),chr(10),'')  -- (new)涉及第三方地址2
    ,replace(replace(t1.thirdpartyzip2,chr(13),''),chr(10),'')  -- (new)第三方法人邮编2
    ,replace(replace(t1.thirdpartyadd3,chr(13),''),chr(10),'')  -- (new)涉及第三方地址3
    ,replace(replace(t1.thirdpartyzip3,chr(13),''),chr(10),'')  -- (new)第三方法人邮编3
    ,replace(replace(t1.effectarea,chr(13),''),chr(10),'')  -- 信用证有效地
    ,replace(replace(t1.termdate1,chr(13),''),chr(10),'')  -- 最晚装运期
    ,replace(replace(t1.termdate2,chr(13),''),chr(10),'')  -- 交单期
    ,replace(replace(t1.termdate3,chr(13),''),chr(10),'')  -- 付款期限
    ,t1.ratio  -- 比例
    ,replace(replace(t1.tempsaveflag,chr(13),''),chr(10),'')  -- 暂存标志
    ,replace(replace(t1.creditcycle,chr(13),''),chr(10),'')  -- (new)额度是否可循环
    ,t1.gainamount  -- 等比（等额）递变幅度
    ,t1.gaincyc  -- 等比（等额）递变周期
    ,t1.holdcorpus  -- 保留本金
    ,replace(replace(t1.incomeorgid,chr(13),''),chr(10),'')  -- 入账机构编号
    ,replace(replace(t1.mainrepaymentmethod,chr(13),''),chr(10),'')  -- 还款方式
    ,replace(replace(t1.payaccountname,chr(13),''),chr(10),'')  -- 还款账户名
    ,replace(replace(t1.payaccountno,chr(13),''),chr(10),'')  -- 还款账户
    ,replace(replace(t1.paymentmode,chr(13),''),chr(10),'')  -- 付款方式
    ,replace(replace(t1.ratemode,chr(13),''),chr(10),'')  -- 利率执行方式
    ,replace(replace(t1.flag5,chr(13),''),chr(10),'')  -- (new)是否已登记审批
    ,replace(replace(t1.defaultpaydate,chr(13),''),chr(10),'')  -- 统一还款日
    ,replace(replace(t1.batchpaymentflag,chr(13),''),chr(10),'')  -- 是否参与批扣
    ,replace(replace(t1.loanaccountno,chr(13),''),chr(10),'')  -- 入账账户
    ,replace(replace(t1.loankind,chr(13),''),chr(10),'')  -- 期限类型
    ,replace(replace(t1.introducerid,chr(13),''),chr(10),'')  -- 介绍人编号
    ,replace(replace(t1.salechannelid,chr(13),''),chr(10),'')  -- 渠道单位编码
    ,replace(replace(t1.bar_code_no,chr(13),''),chr(10),'')  -- 资料扫描编码
    ,replace(replace(t1.schemeno,chr(13),''),chr(10),'')  -- 方案编号
    ,replace(replace(t1.preapproverid,chr(13),''),chr(10),'')  -- 面签人姓名
    ,replace(replace(t1.saleteamid,chr(13),''),chr(10),'')  -- 营销单位编码
    ,replace(replace(t1.signedplace,chr(13),''),chr(10),'')  -- 签约地点
    ,replace(replace(t1.purposetype,chr(13),''),chr(10),'')  -- 贷款用途
    ,replace(replace(t1.qualitycontrolflag,chr(13),''),chr(10),'')  -- 质量控制
    ,t1.approvesum  -- 最新审批金额
    ,replace(replace(t1.approvelevel,chr(13),''),chr(10),'')  -- 审批级别
    ,replace(replace(t1.trustaccname,chr(13),''),chr(10),'')  -- 提前还款申请人
    ,replace(replace(t1.trustfundacctname,chr(13),''),chr(10),'')  -- 推荐人姓名
    ,replace(replace(t1.flag7,chr(13),''),chr(10),'')  -- 
    ,t1.usedbailsum  -- 已占用保证金金额
    ,replace(replace(t1.subbusinesstype,chr(13),''),chr(10),'')  -- 助贷默认业务品种
    ,t1.usedsum  -- 已占用额度
    ,t1.orginalbusinessum  -- 原贷款金额
    ,replace(replace(t1.changetypeflag,chr(13),''),chr(10),'')  -- 是否变更业务品种
    ,replace(replace(t1.guarinten,chr(13),''),chr(10),'')  -- 担保意向
    ,replace(replace(t1.isreconsider,chr(13),''),chr(10),'')  -- 是否人工申诉(1:是 2:否)
    ,replace(replace(t1.reconreason,chr(13),''),chr(10),'')  -- 申诉理由
    ,replace(replace(t1.iscompulsapproval,chr(13),''),chr(10),'')  -- 是否强制人工审批
    ,replace(replace(t1.payaccountname2,chr(13),''),chr(10),'')  -- 第二还款账户名
    ,replace(replace(t1.payaccountno2,chr(13),''),chr(10),'')  -- 第二还款账户
    ,replace(replace(t1.housenmber1,chr(13),''),chr(10),'')  -- 房产证号
    ,replace(replace(t1.houseareacode1,chr(13),''),chr(10),'')  -- 房产证地址区划代码
    ,replace(replace(t1.houseadd1,chr(13),''),chr(10),'')  -- 房产证地址详细地址
    ,replace(replace(t1.housetype1,chr(13),''),chr(10),'')  -- 房屋性质(住房、商住两用房、写字楼)
    ,replace(replace(t1.isguaranty1,chr(13),''),chr(10),'')  -- 是否抵押
    ,replace(replace(t1.persons1,chr(13),''),chr(10),'')  -- 共有产权人数
    ,t1.havecount1  -- 借款人产权份额
    ,t1.amount1  -- 面积
    ,t1.price1  -- 均价
    ,replace(replace(t1.housenmber2,chr(13),''),chr(10),'')  -- 房产证号
    ,replace(replace(t1.houseareacode2,chr(13),''),chr(10),'')  -- 房产证地址区划代码
    ,replace(replace(t1.houseadd2,chr(13),''),chr(10),'')  -- 房产证地址详细地址
    ,replace(replace(t1.housetype2,chr(13),''),chr(10),'')  -- 房屋性质(住房、商住两用房、写字楼)
    ,replace(replace(t1.isguaranty2,chr(13),''),chr(10),'')  -- 是否抵押
    ,replace(replace(t1.persons2,chr(13),''),chr(10),'')  -- 共有产权人数
    ,t1.havecount2  -- 借款人产权份额
    ,t1.amount2  -- 面积
    ,t1.price2  -- 均价
    ,replace(replace(t1.ifdkqy,chr(13),''),chr(10),'')  -- 是否发起代扣管理费签约
    ,replace(replace(t1.iskyd,chr(13),''),chr(10),'')  -- 是否快易贷
    ,replace(replace(t1.corpguarserialno,chr(13),''),chr(10),'')  -- 担保公司流水号
    ,t1.guarusedsum  -- 担保公司已占用额度
    ,t1.start_dt  -- 
    ,t1.end_dt  -- 
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.crss_upl_business_apply t1    --微贷业务申请表
where t1.start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_crss_upl_business_apply',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);