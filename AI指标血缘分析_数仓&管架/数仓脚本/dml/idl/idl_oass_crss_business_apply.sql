/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_crss_business_apply
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
alter table ${idl_schema}.oass_crss_business_apply drop partition p_${retain_week};
alter table ${idl_schema}.oass_crss_business_apply drop partition p_${batch_date};


-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_crss_business_apply add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_crss_business_apply (
    etl_dt  -- 数据日期
    ,serialno  -- 
    ,relativeserialno  -- 
    ,occurdate  -- 
    ,customerid  -- 
    ,customername  -- 
    ,businesstype  -- 
    ,businesssubtype  -- 
    ,occurtype  -- 
    ,fundsource  -- 
    ,operatetype  -- 
    ,currenylist  -- 
    ,currencymode  -- 
    ,businesstypelist  -- 
    ,calculatemode  -- 
    ,useorglist  -- 
    ,cycleflag  -- 
    ,flowreduceflag  -- 
    ,contractflag  -- 
    ,subcontractflag  -- 
    ,selfuseflag  -- 
    ,creditaggreement  -- 
    ,relativeagreement  -- 
    ,loanflag  -- 
    ,totalsum  -- 
    ,ourrole  -- 
    ,reversibility  -- 
    ,billnum  -- 
    ,housetype  -- 
    ,lctermtype  -- 
    ,riskattribute  -- 
    ,suretype  -- 
    ,safeguardtype  -- 
    ,businesscurrency  -- 
    ,businesssum  -- 
    ,businessprop  -- 
    ,termyear  -- 
    ,termmonth  -- 
    ,termday  -- 
    ,lgterm  -- 
    ,baseratetype  -- 
    ,baserate  -- 
    ,ratefloattype  -- 
    ,ratefloat  -- 
    ,businessrate  -- 
    ,ictype  -- 
    ,iccyc  -- 
    ,pdgratio  -- 
    ,pdgsum  -- 
    ,pdgpaymethod  -- 
    ,pdgpayperiod  -- 
    ,promisesfeeratio  -- 
    ,promisesfeesum  -- 
    ,promisesfeeperiod  -- 
    ,promisesfeebegin  -- 
    ,mfeeratio  -- 
    ,mfeesum  -- 
    ,mfeepaymethod  -- 
    ,agentfee  -- 
    ,dealfee  -- 
    ,totalcast  -- 
    ,discountinterest  -- 
    ,purchaserinterest  -- 
    ,bargainorinterest  -- 
    ,discountsum  -- 
    ,bailratio  -- 
    ,bailcurrency  -- 
    ,bailsum  -- 
    ,bailaccount  -- 
    ,fineratetype  -- 
    ,finerate  -- 
    ,drawingtype  -- 
    ,firstdrawingdate  -- 
    ,drawingperiod  -- 
    ,paytimes  -- 
    ,paycyc  -- 
    ,graceperiod  -- 
    ,overdraftperiod  -- 
    ,oldlcno  -- 
    ,oldlctermtype  -- 
    ,oldlccurrency  -- 
    ,oldlcsum  -- 
    ,oldlcloadingdate  -- 
    ,oldlcvaliddate  -- 
    ,direction  -- 
    ,purpose  -- 
    ,planallocation  -- 
    ,immediacypaysource  -- 
    ,paysource  -- 
    ,corpuspaymethod  -- 
    ,interestpaymethod  -- 
    ,thirdparty1  -- 
    ,thirdpartyid1  -- 
    ,thirdparty2  -- 
    ,thirdpartyid2  -- 
    ,thirdparty3  -- 
    ,thirdpartyid3  -- 
    ,thirdpartyregion  -- 
    ,thirdpartyaccounts  -- 
    ,cargoinfo  -- 
    ,projectname  -- 
    ,operationinfo  -- 
    ,contextinfo  -- 
    ,securitiestype  -- 
    ,securitiesregion  -- 
    ,constructionarea  -- 
    ,usearea  -- 
    ,flag1  -- 
    ,flag2  -- 
    ,flag3  -- 
    ,tradecontractno  -- 
    ,invoiceno  -- 
    ,tradecurrency  -- 
    ,tradesum  -- 
    ,paymentdate  -- 
    ,operationmode  -- 
    ,vouchclass  -- 
    ,vouchtype  -- 
    ,vouchtype1  -- 
    ,vouchtype2  -- 
    ,vouchflag  -- 
    ,warrantor  -- 
    ,warrantorid  -- 
    ,othercondition  -- 
    ,guarantyvalue  -- 
    ,guarantyrate  -- 
    ,baseevaluateresult  -- 
    ,riskrate  -- 
    ,lowrisk  -- 
    ,otherarealoan  -- 
    ,lowriskbailsum  -- 
    ,originalputoutdate  -- 
    ,extendtimes  -- 
    ,lngotimes  -- 
    ,golntimes  -- 
    ,drtimes  -- 
    ,baseclassifyresult  -- 
    ,applytype  -- 
    ,bailrate  -- 
    ,finishorg  -- 
    ,operateorgid  -- 
    ,operateuserid  -- 
    ,operatedate  -- 
    ,inputorgid  -- 
    ,inputuserid  -- 
    ,inputdate  -- 
    ,updatedate  -- 
    ,pigeonholedate  -- 
    ,remark  -- 
    ,flag4  -- 
    ,paycurrency  -- 
    ,paydate  -- 
    ,describe1  -- 
    ,describe2  -- 
    ,classifyresult  -- 
    ,classifydate  -- 
    ,classifyfrequency  -- 
    ,vouchnewflag  -- 
    ,adjustratetype  -- 
    ,adjustrateterm  -- 
    ,rateadjustcyc  -- 
    ,fzanbalance  -- 
    ,acceptinttype  -- 
    ,fixcyc  -- 
    ,thirdpartyadd1  -- 
    ,thirdpartyzip1  -- 
    ,thirdpartyadd2  -- 
    ,thirdpartyzip2  -- 
    ,thirdpartyadd3  -- 
    ,thirdpartyzip3  -- 
    ,effectarea  -- 
    ,termdate1  -- 
    ,termdate2  -- 
    ,termdate3  -- 
    ,ratio  -- 
    ,tempsaveflag  -- 
    ,flag5  -- 
    ,creditcycle  -- 
    ,guarantyflag  -- 
    ,isliquidity  -- 
    ,isfixed  -- 
    ,isproject  -- 
    ,nrelativecontractno  -- 新一贷关联房贷
    ,relativeaggreement  -- 关联的循环贷款协议号
    ,signedplace  -- 签约地点
    ,otherdatum  -- 附件材料(代码:OtherDatum)
    ,ltvvalue  -- 贷款成数
    ,savetype  -- 救治类型(代码:SaveType)---借新还旧使用
    ,channel  -- 营销渠道类型(代码:Channel)
    ,buyno  -- 订购编号
    ,betterrateflag  -- 有无优质客户利率优惠(代码:HaveNot)
    ,entname  -- 合作商名称
    ,introducerid  -- 介绍人编号
    ,orderno  -- 订单编号
    ,gracetermflag  -- 宽限期单位(代码:TermUnit)
    ,graceterm  -- 宽限期
    ,holdbalance  -- 保留金额（对气球贷的保留本金）尾款金额
    ,dunloanratio  -- 费用收取比例
    ,preapproverid  -- 初审人ID
    ,fundserialno  -- 公积金受理编号
    ,mainreturntype  -- 主还款方式(代码:MainReturnMethod)
    ,cguarantypeople  -- 抵押物权人人数```暂未使用
    ,turnratio  -- 周转额度比例
    ,salechannelid  -- 营销渠道编号(类型为中介,开发商)
    ,bar_code_no  -- 影像条形码
    ,poundagerate  -- 车贷手续费率
    ,approvedate  -- 审批通过日期
    ,isnewcustomer  -- 是否为黑名单客户
    ,salemode  -- 销售方式(代码:SaleMode)
    ,loanpreference  -- 老客户优惠(代码:LoanPreference)
    ,approvelevel  -- 审批级别
    ,schemeno  -- 方案编号
    ,abysum  -- 赎楼金额
    ,loadrelabarcode  -- 赎楼贷款关联申请条形码
    ,otherdatumremark  -- 其他附件材料说明
    ,greensetdate  -- 绿色通道设置时间
    ,gaincyc  -- 等比（等额）递变周期
    ,csinglnassure  -- 个人保证人人数
    ,sellerinformation  -- 营销人员信息说明
    ,accountopenfee  -- 个人贷款账户开户费
    ,ratemode  -- 利率执行方式(代码:RateMode)
    ,loanrelacontractno  -- 增值贷关联房贷合同号
    ,formerserialno  -- 相关流水号:重组贷款原合同号，借新换旧业务关联合同号
    ,tradebarcode  -- 商易贷关联条形码
    ,feetype  -- 费用类型(代码:LoanFeeType)
    ,houseareage  -- 购房面积
    ,otherpurpose  -- 贷款其他用途---存单质押用
    ,hasbothflag  -- 是否属于转加按(代码:YesNo)
    ,currency  -- 币种(代码:Currency)
    ,ctogetherborrower  -- 共同借款人人数
    ,isnewcustomertime  -- 黑名单检查时间
    ,applyinsuranceflag  -- 是否申请贷款保险保障(代码:YesNo)
    ,accountexpenses  -- 费用
    ,guarantyhouse  -- 抵押房产套数
    ,datatype  -- 0 老系统数据   1  新系统数据
    ,greenflag  -- 是否绿色通道业务(代码:YesNo)
    ,gracetermpay  -- 宽限期固定还款额
    ,dunloanresource  -- 委托贷款资金来源
    ,spreadername  -- 推广人编号(车贷专用)
    ,pddid  -- 
    ,carintroducername  -- 业务经办人(车贷专用)
    ,approveresult  -- 审批结果
    ,buyhouseproperty  -- 所购房屋性质(代码:BuyHouseProperty)
    ,gatheringcardid  -- 收款账户卡/账号
    ,loantermflag  -- 贷款期限类型  默认为月M(代码:TermUnit)
    ,loanpurposeamt  -- 贷款用途金额
    ,moneyproportion  -- 金额比例
    ,dundepositno  -- 委托资金存款账号
    ,gainamount  -- 等比（等额）递变幅度
    ,commissionfee  -- 信用卡车贷回佣费用
    ,feemethod  -- 费用收取方式(代码:FeeMethod)
    ,presignflag  -- 是否预签合同(代码:YesNo)
    ,returnperiod  -- 还款周期(代码:PayCyc)
    ,houseprice  -- 购房价格
    ,signaddress  -- 签约地点
    ,housecount  -- 购房套数
    ,paymentmode  -- 付款方式
    ,ratecode  -- 利率类型(代码:RateCode)
    ,calcterm  -- 还款计算期(月)
    ,approvesum  -- 最新审批金额
    ,edumfee  -- 额度管理费
    ,buyaddress  -- 购买的物业地址
    ,gatheringname  -- 划款账户户名
    ,paytype  -- 缴费方式
    ,crdid  -- 
    ,paymentcardid  -- 还款账户卡号
    ,operateusermind  -- 经办单位负责人意见
    ,buyhousetype  -- 所购房产类型(代码:BuyHouseType)
    ,faremoneytype  -- 费用收取类型(代码:FareMoneytType)
    ,sendchitflag  -- 是否需要短信提醒(代码:YesNo)
    ,oapproveflag  -- 是否例外审批件YesNo
    ,loanterm  -- 贷款期限
    ,schemenofalg  -- 标识是否风控征信（YesNo）
    ,schemenoflag  -- 出国贷是否提取贷款---存单质押用(代码:YesNo)
    ,returntype  -- 子还款方式(代码:ReturnMethod)
    ,saleteamid  -- 营销单位名称(直销,网点)
    ,dealerid  -- 车贷商编号
    ,loantrustfee  -- 委托贷款手续费
    ,deductaccno  -- 贷款结算账号（小消使用）
    ,backfee  -- 信用卡车贷返利费用
    ,cycleratio  -- 循环子额度占比
    ,goldflag  -- 是否申请按揭金(代码:YesNo)
    ,sealtype  -- 印章类型(代码:SealType)
    ,transferaccount  -- 转入账户账号（小消使用）
    ,ratedescribe  -- 
    ,creditmode  -- 
    ,isfinance  -- 
    ,industrytype  -- 
    ,artificialno  -- 
    ,analystno  -- 
    ,isrelative  -- 
    ,effectflag  -- 
    ,customertype  -- 
    ,archiveflag  -- 
    ,changeflag  -- 
    ,originalserialno  -- 
    ,flag  -- 
    ,ifcommerce  -- 
    ,mortgagecreditserialno  -- 按揭额度流水号
    ,mortgagecreditowner  -- 按揭额度所有人
    ,isstraight  -- 是否直客式
    ,professionalflag  -- 
    ,suremodel  -- 
    ,issme  -- 
    ,transcount  -- 
    ,accountno  -- 签约帐号
    ,maturity  -- 签约到期日
    ,istrans  -- 
    ,carbrand  -- 
    ,cartype  -- 
    ,carnumber  -- 
    ,chariotnumber  -- 
    ,motornumber  -- 
    ,financialcreditserialno  -- 商圈(群)客户额度批复流水号
    ,financialcreditowner  -- 商圈(群)客户名称
    ,isfinancialcredit  -- 是否商圈授信
    ,financialmodel  -- 集群客户操作模式
    ,issmeandretail  -- 是否我行小微企业并且走零售条线
    ,ruleid  -- 授权规则编号
    ,buyhousedetail  -- 购房细分：1-购一手房，2-购二手房，3-购其他类型住房，4-购商铺，5-购写字楼，6-购厂房，7-购其他商业用房
    ,thirdparty1type  -- 代付类型：1-买方押汇，2-打包放款，3-卖方押汇，4-国内信用证项下贴现
    ,thirdorgname  -- 代付行,承兑行
    ,issjsh  -- 是否随借随还(1是2否)
    ,sjshserialno  -- 生效的随借随还申请号码
    ,isinuse  -- 添加维护标志1正常2不维护
    ,busirisktype  -- 风险类型
    ,playtype  -- 参与方式
    ,otherlimitno  -- 他用额度编号
    ,otherlimittype  -- 他用额度类型
    ,otherlimitownerid  -- 他用额度所有人
    ,iskyd  -- 是否快易贷
    ,authvouchtype  -- 授权权限_担保方式
    ,zbxxm  -- 主办行行名
    ,cdxxm  -- 参贷行行名
    ,dlxxm  -- 代理行行名
    ,dlcdbz  -- 代理参贷标志
    ,sqdkze  -- 申请银团贷款总额
    ,jxhjcontractno  -- 借新还旧业务关联的原业务合同
    ,creditflowtype  -- 同业授信业务流程类型
    ,hxtyapproveresult  -- 同业授信终审结论
    ,isneedparallelwork  -- 是否需风险经理平行作业
    ,investway  -- 投资方式
    ,investtarget  -- 投资标的
    ,publicorg  -- 发行场所
    ,onlineamount  -- 线上额度
    ,businesssumentpart  -- 集团授信额度公司部分
    ,totalsumentpart  -- 集团授信敞口公司部分
    ,businesssumtypart  -- 集团授信额度同业部分
    ,totalsumtypart  -- 集团授信额度同业部分
    ,creditarea  -- 授信区域:01 本地 02 省内异地 03 省外异地
    ,isestatefinance  -- 是否涉及房地产融资
    ,isgovernfinance  -- 是否涉及政府类融资
    ,isconsumerfinance  -- 是否为消费服务类融资
    ,isbeltroadfinance  -- 是否为一带一路建设投融资
    ,isgreenfinance  -- 是否为绿色信贷融资
    ,islikeloan  -- 是否类信贷
    ,iscangenerateapprove  -- 是否可以登记批复:No-不可以登记批复 否则-可以登记批复
    ,hxtyoperateorg  -- 同业归口管理部门
    ,classifyresulteleven  -- 资产风险分类
    ,outclassifylevel  -- 外部债项评级
    ,outclassifyorg  -- 评级机构
    ,outclassifydate  -- 评级日期
    ,start_dt  -- 
    ,end_dt  -- 
    ,id_mark  -- 
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.serialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.relativeserialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.occurdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.customerid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.customername,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesstype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesssubtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.occurtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fundsource,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operatetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.currenylist,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.currencymode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesstypelist,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.calculatemode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.useorglist,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cycleflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flowreduceflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.contractflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.subcontractflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.selfuseflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditaggreement,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.relativeagreement,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loanflag,chr(13),''),chr(10),'')  -- 
    ,t1.totalsum  -- 
    ,replace(replace(t1.ourrole,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.reversibility,chr(13),''),chr(10),'')  -- 
    ,t1.billnum  -- 
    ,replace(replace(t1.housetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.lctermtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.riskattribute,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.suretype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.safeguardtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'')  -- 
    ,t1.businesssum  -- 
    ,t1.businessprop  -- 
    ,t1.termyear  -- 
    ,t1.termmonth  -- 
    ,t1.termday  -- 
    ,t1.lgterm  -- 
    ,replace(replace(t1.baseratetype,chr(13),''),chr(10),'')  -- 
    ,t1.baserate  -- 
    ,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'')  -- 
    ,t1.ratefloat  -- 
    ,t1.businessrate  -- 
    ,replace(replace(t1.ictype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.iccyc,chr(13),''),chr(10),'')  -- 
    ,t1.pdgratio  -- 
    ,t1.pdgsum  -- 
    ,replace(replace(t1.pdgpaymethod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pdgpayperiod,chr(13),''),chr(10),'')  -- 
    ,t1.promisesfeeratio  -- 
    ,t1.promisesfeesum  -- 
    ,t1.promisesfeeperiod  -- 
    ,replace(replace(t1.promisesfeebegin,chr(13),''),chr(10),'')  -- 
    ,t1.mfeeratio  -- 
    ,t1.mfeesum  -- 
    ,replace(replace(t1.mfeepaymethod,chr(13),''),chr(10),'')  -- 
    ,t1.agentfee  -- 
    ,t1.dealfee  -- 
    ,t1.totalcast  -- 
    ,t1.discountinterest  -- 
    ,t1.purchaserinterest  -- 
    ,t1.bargainorinterest  -- 
    ,t1.discountsum  -- 
    ,t1.bailratio  -- 
    ,replace(replace(t1.bailcurrency,chr(13),''),chr(10),'')  -- 
    ,t1.bailsum  -- 
    ,replace(replace(t1.bailaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fineratetype,chr(13),''),chr(10),'')  -- 
    ,t1.finerate  -- 
    ,replace(replace(t1.drawingtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.firstdrawingdate,chr(13),''),chr(10),'')  -- 
    ,t1.drawingperiod  -- 
    ,t1.paytimes  -- 
    ,replace(replace(t1.paycyc,chr(13),''),chr(10),'')  -- 
    ,t1.graceperiod  -- 
    ,t1.overdraftperiod  -- 
    ,replace(replace(t1.oldlcno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.oldlctermtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.oldlccurrency,chr(13),''),chr(10),'')  -- 
    ,t1.oldlcsum  -- 
    ,replace(replace(t1.oldlcloadingdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.oldlcvaliddate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.direction,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.purpose,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.planallocation,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.immediacypaysource,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paysource,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.corpuspaymethod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.interestpaymethod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdparty1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyid1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdparty2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyid2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdparty3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyid3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyregion,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyaccounts,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cargoinfo,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.projectname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operationinfo,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.contextinfo,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.securitiestype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.securitiesregion,chr(13),''),chr(10),'')  -- 
    ,t1.constructionarea  -- 
    ,t1.usearea  -- 
    ,replace(replace(t1.flag1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.tradecontractno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.invoiceno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.tradecurrency,chr(13),''),chr(10),'')  -- 
    ,t1.tradesum  -- 
    ,replace(replace(t1.paymentdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operationmode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vouchclass,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vouchtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vouchtype1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vouchtype2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vouchflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.warrantor,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.warrantorid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.othercondition,chr(13),''),chr(10),'')  -- 
    ,t1.guarantyvalue  -- 
    ,t1.guarantyrate  -- 
    ,replace(replace(t1.baseevaluateresult,chr(13),''),chr(10),'')  -- 
    ,t1.riskrate  -- 
    ,replace(replace(t1.lowrisk,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.otherarealoan,chr(13),''),chr(10),'')  -- 
    ,t1.lowriskbailsum  -- 
    ,replace(replace(t1.originalputoutdate,chr(13),''),chr(10),'')  -- 
    ,t1.extendtimes  -- 
    ,t1.lngotimes  -- 
    ,t1.golntimes  -- 
    ,t1.drtimes  -- 
    ,replace(replace(t1.baseclassifyresult,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.applytype,chr(13),''),chr(10),'')  -- 
    ,t1.bailrate  -- 
    ,replace(replace(t1.finishorg,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operateorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operateuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pigeonholedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag4,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paycurrency,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paydate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.describe1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.describe2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.classifyresult,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.classifydate,chr(13),''),chr(10),'')  -- 
    ,t1.classifyfrequency  -- 
    ,replace(replace(t1.vouchnewflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.adjustratetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.adjustrateterm,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.rateadjustcyc,chr(13),''),chr(10),'')  -- 
    ,t1.fzanbalance  -- 
    ,replace(replace(t1.acceptinttype,chr(13),''),chr(10),'')  -- 
    ,t1.fixcyc  -- 
    ,replace(replace(t1.thirdpartyadd1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyzip1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyadd2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyzip2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyadd3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyzip3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.effectarea,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.termdate1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.termdate2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.termdate3,chr(13),''),chr(10),'')  -- 
    ,t1.ratio  -- 
    ,replace(replace(t1.tempsaveflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag5,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditcycle,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantyflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isliquidity,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isfixed,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isproject,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.nrelativecontractno,chr(13),''),chr(10),'')  -- 新一贷关联房贷
    ,replace(replace(t1.relativeaggreement,chr(13),''),chr(10),'')  -- 关联的循环贷款协议号
    ,replace(replace(t1.signedplace,chr(13),''),chr(10),'')  -- 签约地点
    ,replace(replace(t1.otherdatum,chr(13),''),chr(10),'')  -- 附件材料(代码:OtherDatum)
    ,replace(replace(t1.ltvvalue,chr(13),''),chr(10),'')  -- 贷款成数
    ,replace(replace(t1.savetype,chr(13),''),chr(10),'')  -- 救治类型(代码:SaveType)---借新还旧使用
    ,replace(replace(t1.channel,chr(13),''),chr(10),'')  -- 营销渠道类型(代码:Channel)
    ,replace(replace(t1.buyno,chr(13),''),chr(10),'')  -- 订购编号
    ,replace(replace(t1.betterrateflag,chr(13),''),chr(10),'')  -- 有无优质客户利率优惠(代码:HaveNot)
    ,replace(replace(t1.entname,chr(13),''),chr(10),'')  -- 合作商名称
    ,replace(replace(t1.introducerid,chr(13),''),chr(10),'')  -- 介绍人编号
    ,replace(replace(t1.orderno,chr(13),''),chr(10),'')  -- 订单编号
    ,replace(replace(t1.gracetermflag,chr(13),''),chr(10),'')  -- 宽限期单位(代码:TermUnit)
    ,t1.graceterm  -- 宽限期
    ,t1.holdbalance  -- 保留金额（对气球贷的保留本金）尾款金额
    ,t1.dunloanratio  -- 费用收取比例
    ,replace(replace(t1.preapproverid,chr(13),''),chr(10),'')  -- 初审人ID
    ,replace(replace(t1.fundserialno,chr(13),''),chr(10),'')  -- 公积金受理编号
    ,replace(replace(t1.mainreturntype,chr(13),''),chr(10),'')  -- 主还款方式(代码:MainReturnMethod)
    ,t1.cguarantypeople  -- 抵押物权人人数```暂未使用
    ,t1.turnratio  -- 周转额度比例
    ,replace(replace(t1.salechannelid,chr(13),''),chr(10),'')  -- 营销渠道编号(类型为中介,开发商)
    ,replace(replace(t1.bar_code_no,chr(13),''),chr(10),'')  -- 影像条形码
    ,t1.poundagerate  -- 车贷手续费率
    ,replace(replace(t1.approvedate,chr(13),''),chr(10),'')  -- 审批通过日期
    ,replace(replace(t1.isnewcustomer,chr(13),''),chr(10),'')  -- 是否为黑名单客户
    ,replace(replace(t1.salemode,chr(13),''),chr(10),'')  -- 销售方式(代码:SaleMode)
    ,replace(replace(t1.loanpreference,chr(13),''),chr(10),'')  -- 老客户优惠(代码:LoanPreference)
    ,replace(replace(t1.approvelevel,chr(13),''),chr(10),'')  -- 审批级别
    ,replace(replace(t1.schemeno,chr(13),''),chr(10),'')  -- 方案编号
    ,t1.abysum  -- 赎楼金额
    ,replace(replace(t1.loadrelabarcode,chr(13),''),chr(10),'')  -- 赎楼贷款关联申请条形码
    ,replace(replace(t1.otherdatumremark,chr(13),''),chr(10),'')  -- 其他附件材料说明
    ,replace(replace(t1.greensetdate,chr(13),''),chr(10),'')  -- 绿色通道设置时间
    ,t1.gaincyc  -- 等比（等额）递变周期
    ,t1.csinglnassure  -- 个人保证人人数
    ,replace(replace(t1.sellerinformation,chr(13),''),chr(10),'')  -- 营销人员信息说明
    ,t1.accountopenfee  -- 个人贷款账户开户费
    ,replace(replace(t1.ratemode,chr(13),''),chr(10),'')  -- 利率执行方式(代码:RateMode)
    ,replace(replace(t1.loanrelacontractno,chr(13),''),chr(10),'')  -- 增值贷关联房贷合同号
    ,replace(replace(t1.formerserialno,chr(13),''),chr(10),'')  -- 相关流水号:重组贷款原合同号，借新换旧业务关联合同号
    ,replace(replace(t1.tradebarcode,chr(13),''),chr(10),'')  -- 商易贷关联条形码
    ,replace(replace(t1.feetype,chr(13),''),chr(10),'')  -- 费用类型(代码:LoanFeeType)
    ,t1.houseareage  -- 购房面积
    ,replace(replace(t1.otherpurpose,chr(13),''),chr(10),'')  -- 贷款其他用途---存单质押用
    ,replace(replace(t1.hasbothflag,chr(13),''),chr(10),'')  -- 是否属于转加按(代码:YesNo)
    ,replace(replace(t1.currency,chr(13),''),chr(10),'')  -- 币种(代码:Currency)
    ,t1.ctogetherborrower  -- 共同借款人人数
    ,replace(replace(t1.isnewcustomertime,chr(13),''),chr(10),'')  -- 黑名单检查时间
    ,replace(replace(t1.applyinsuranceflag,chr(13),''),chr(10),'')  -- 是否申请贷款保险保障(代码:YesNo)
    ,t1.accountexpenses  -- 费用
    ,t1.guarantyhouse  -- 抵押房产套数
    ,replace(replace(t1.datatype,chr(13),''),chr(10),'')  -- 0 老系统数据   1  新系统数据
    ,replace(replace(t1.greenflag,chr(13),''),chr(10),'')  -- 是否绿色通道业务(代码:YesNo)
    ,t1.gracetermpay  -- 宽限期固定还款额
    ,replace(replace(t1.dunloanresource,chr(13),''),chr(10),'')  -- 委托贷款资金来源
    ,replace(replace(t1.spreadername,chr(13),''),chr(10),'')  -- 推广人编号(车贷专用)
    ,replace(replace(t1.pddid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.carintroducername,chr(13),''),chr(10),'')  -- 业务经办人(车贷专用)
    ,replace(replace(t1.approveresult,chr(13),''),chr(10),'')  -- 审批结果
    ,replace(replace(t1.buyhouseproperty,chr(13),''),chr(10),'')  -- 所购房屋性质(代码:BuyHouseProperty)
    ,replace(replace(t1.gatheringcardid,chr(13),''),chr(10),'')  -- 收款账户卡/账号
    ,replace(replace(t1.loantermflag,chr(13),''),chr(10),'')  -- 贷款期限类型  默认为月M(代码:TermUnit)
    ,t1.loanpurposeamt  -- 贷款用途金额
    ,t1.moneyproportion  -- 金额比例
    ,replace(replace(t1.dundepositno,chr(13),''),chr(10),'')  -- 委托资金存款账号
    ,t1.gainamount  -- 等比（等额）递变幅度
    ,t1.commissionfee  -- 信用卡车贷回佣费用
    ,replace(replace(t1.feemethod,chr(13),''),chr(10),'')  -- 费用收取方式(代码:FeeMethod)
    ,replace(replace(t1.presignflag,chr(13),''),chr(10),'')  -- 是否预签合同(代码:YesNo)
    ,replace(replace(t1.returnperiod,chr(13),''),chr(10),'')  -- 还款周期(代码:PayCyc)
    ,t1.houseprice  -- 购房价格
    ,replace(replace(t1.signaddress,chr(13),''),chr(10),'')  -- 签约地点
    ,t1.housecount  -- 购房套数
    ,replace(replace(t1.paymentmode,chr(13),''),chr(10),'')  -- 付款方式
    ,replace(replace(t1.ratecode,chr(13),''),chr(10),'')  -- 利率类型(代码:RateCode)
    ,t1.calcterm  -- 还款计算期(月)
    ,t1.approvesum  -- 最新审批金额
    ,t1.edumfee  -- 额度管理费
    ,replace(replace(t1.buyaddress,chr(13),''),chr(10),'')  -- 购买的物业地址
    ,replace(replace(t1.gatheringname,chr(13),''),chr(10),'')  -- 划款账户户名
    ,replace(replace(t1.paytype,chr(13),''),chr(10),'')  -- 缴费方式
    ,replace(replace(t1.crdid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paymentcardid,chr(13),''),chr(10),'')  -- 还款账户卡号
    ,replace(replace(t1.operateusermind,chr(13),''),chr(10),'')  -- 经办单位负责人意见
    ,replace(replace(t1.buyhousetype,chr(13),''),chr(10),'')  -- 所购房产类型(代码:BuyHouseType)
    ,replace(replace(t1.faremoneytype,chr(13),''),chr(10),'')  -- 费用收取类型(代码:FareMoneytType)
    ,replace(replace(t1.sendchitflag,chr(13),''),chr(10),'')  -- 是否需要短信提醒(代码:YesNo)
    ,replace(replace(t1.oapproveflag,chr(13),''),chr(10),'')  -- 是否例外审批件YesNo
    ,t1.loanterm  -- 贷款期限
    ,replace(replace(t1.schemenofalg,chr(13),''),chr(10),'')  -- 标识是否风控征信（YesNo）
    ,replace(replace(t1.schemenoflag,chr(13),''),chr(10),'')  -- 出国贷是否提取贷款---存单质押用(代码:YesNo)
    ,replace(replace(t1.returntype,chr(13),''),chr(10),'')  -- 子还款方式(代码:ReturnMethod)
    ,replace(replace(t1.saleteamid,chr(13),''),chr(10),'')  -- 营销单位名称(直销,网点)
    ,replace(replace(t1.dealerid,chr(13),''),chr(10),'')  -- 车贷商编号
    ,t1.loantrustfee  -- 委托贷款手续费
    ,replace(replace(t1.deductaccno,chr(13),''),chr(10),'')  -- 贷款结算账号（小消使用）
    ,t1.backfee  -- 信用卡车贷返利费用
    ,t1.cycleratio  -- 循环子额度占比
    ,replace(replace(t1.goldflag,chr(13),''),chr(10),'')  -- 是否申请按揭金(代码:YesNo)
    ,replace(replace(t1.sealtype,chr(13),''),chr(10),'')  -- 印章类型(代码:SealType)
    ,replace(replace(t1.transferaccount,chr(13),''),chr(10),'')  -- 转入账户账号（小消使用）
    ,replace(replace(t1.ratedescribe,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditmode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isfinance,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.industrytype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.artificialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.analystno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isrelative,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.effectflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.customertype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.archiveflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.changeflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.originalserialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ifcommerce,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mortgagecreditserialno,chr(13),''),chr(10),'')  -- 按揭额度流水号
    ,replace(replace(t1.mortgagecreditowner,chr(13),''),chr(10),'')  -- 按揭额度所有人
    ,replace(replace(t1.isstraight,chr(13),''),chr(10),'')  -- 是否直客式
    ,replace(replace(t1.professionalflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.suremodel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.issme,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.transcount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.accountno,chr(13),''),chr(10),'')  -- 签约帐号
    ,replace(replace(t1.maturity,chr(13),''),chr(10),'')  -- 签约到期日
    ,replace(replace(t1.istrans,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.carbrand,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cartype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.carnumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.chariotnumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.motornumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.financialcreditserialno,chr(13),''),chr(10),'')  -- 商圈(群)客户额度批复流水号
    ,replace(replace(t1.financialcreditowner,chr(13),''),chr(10),'')  -- 商圈(群)客户名称
    ,replace(replace(t1.isfinancialcredit,chr(13),''),chr(10),'')  -- 是否商圈授信
    ,replace(replace(t1.financialmodel,chr(13),''),chr(10),'')  -- 集群客户操作模式
    ,replace(replace(t1.issmeandretail,chr(13),''),chr(10),'')  -- 是否我行小微企业并且走零售条线
    ,replace(replace(t1.ruleid,chr(13),''),chr(10),'')  -- 授权规则编号
    ,replace(replace(t1.buyhousedetail,chr(13),''),chr(10),'')  -- 购房细分：1-购一手房，2-购二手房，3-购其他类型住房，4-购商铺，5-购写字楼，6-购厂房，7-购其他商业用房
    ,replace(replace(t1.thirdparty1type,chr(13),''),chr(10),'')  -- 代付类型：1-买方押汇，2-打包放款，3-卖方押汇，4-国内信用证项下贴现
    ,replace(replace(t1.thirdorgname,chr(13),''),chr(10),'')  -- 代付行,承兑行
    ,replace(replace(t1.issjsh,chr(13),''),chr(10),'')  -- 是否随借随还(1是2否)
    ,replace(replace(t1.sjshserialno,chr(13),''),chr(10),'')  -- 生效的随借随还申请号码
    ,replace(replace(t1.isinuse,chr(13),''),chr(10),'')  -- 添加维护标志1正常2不维护
    ,replace(replace(t1.busirisktype,chr(13),''),chr(10),'')  -- 风险类型
    ,replace(replace(t1.playtype,chr(13),''),chr(10),'')  -- 参与方式
    ,replace(replace(t1.otherlimitno,chr(13),''),chr(10),'')  -- 他用额度编号
    ,replace(replace(t1.otherlimittype,chr(13),''),chr(10),'')  -- 他用额度类型
    ,replace(replace(t1.otherlimitownerid,chr(13),''),chr(10),'')  -- 他用额度所有人
    ,replace(replace(t1.iskyd,chr(13),''),chr(10),'')  -- 是否快易贷
    ,replace(replace(t1.authvouchtype,chr(13),''),chr(10),'')  -- 授权权限_担保方式
    ,replace(replace(t1.zbxxm,chr(13),''),chr(10),'')  -- 主办行行名
    ,replace(replace(t1.cdxxm,chr(13),''),chr(10),'')  -- 参贷行行名
    ,replace(replace(t1.dlxxm,chr(13),''),chr(10),'')  -- 代理行行名
    ,replace(replace(t1.dlcdbz,chr(13),''),chr(10),'')  -- 代理参贷标志
    ,t1.sqdkze  -- 申请银团贷款总额
    ,replace(replace(t1.jxhjcontractno,chr(13),''),chr(10),'')  -- 借新还旧业务关联的原业务合同
    ,replace(replace(t1.creditflowtype,chr(13),''),chr(10),'')  -- 同业授信业务流程类型
    ,replace(replace(t1.hxtyapproveresult,chr(13),''),chr(10),'')  -- 同业授信终审结论
    ,replace(replace(t1.isneedparallelwork,chr(13),''),chr(10),'')  -- 是否需风险经理平行作业
    ,replace(replace(t1.investway,chr(13),''),chr(10),'')  -- 投资方式
    ,replace(replace(t1.investtarget,chr(13),''),chr(10),'')  -- 投资标的
    ,replace(replace(t1.publicorg,chr(13),''),chr(10),'')  -- 发行场所
    ,t1.onlineamount  -- 线上额度
    ,t1.businesssumentpart  -- 集团授信额度公司部分
    ,t1.totalsumentpart  -- 集团授信敞口公司部分
    ,t1.businesssumtypart  -- 集团授信额度同业部分
    ,t1.totalsumtypart  -- 集团授信额度同业部分
    ,replace(replace(t1.creditarea,chr(13),''),chr(10),'')  -- 授信区域:01 本地 02 省内异地 03 省外异地
    ,replace(replace(t1.isestatefinance,chr(13),''),chr(10),'')  -- 是否涉及房地产融资
    ,replace(replace(t1.isgovernfinance,chr(13),''),chr(10),'')  -- 是否涉及政府类融资
    ,replace(replace(t1.isconsumerfinance,chr(13),''),chr(10),'')  -- 是否为消费服务类融资
    ,replace(replace(t1.isbeltroadfinance,chr(13),''),chr(10),'')  -- 是否为一带一路建设投融资
    ,replace(replace(t1.isgreenfinance,chr(13),''),chr(10),'')  -- 是否为绿色信贷融资
    ,replace(replace(t1.islikeloan,chr(13),''),chr(10),'')  -- 是否类信贷
    ,replace(replace(t1.iscangenerateapprove,chr(13),''),chr(10),'')  -- 是否可以登记批复:No-不可以登记批复 否则-可以登记批复
    ,replace(replace(t1.hxtyoperateorg,chr(13),''),chr(10),'')  -- 同业归口管理部门
    ,replace(replace(t1.classifyresulteleven,chr(13),''),chr(10),'')  -- 资产风险分类
    ,replace(replace(t1.outclassifylevel,chr(13),''),chr(10),'')  -- 外部债项评级
    ,replace(replace(t1.outclassifyorg,chr(13),''),chr(10),'')  -- 评级机构
    ,replace(replace(t1.outclassifydate,chr(13),''),chr(10),'')  -- 评级日期
    ,t1.start_dt  -- 
    ,t1.end_dt  -- 
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.crss_business_apply t1    --业务申请信息
where t1.start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_crss_business_apply',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);