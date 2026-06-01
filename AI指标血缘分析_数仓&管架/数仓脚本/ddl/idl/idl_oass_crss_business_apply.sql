/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_crss_business_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.oass_crss_business_apply
whenever sqlerror continue none;
drop table ${idl_schema}.oass_crss_business_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.oass_crss_business_apply(
    etl_dt date -- 数据日期
    ,serialno varchar2(32) -- 
    ,relativeserialno varchar2(32) -- 
    ,occurdate varchar2(10) -- 
    ,customerid varchar2(32) -- 
    ,customername varchar2(80) -- 
    ,businesstype varchar2(32) -- 
    ,businesssubtype varchar2(18) -- 
    ,occurtype varchar2(18) -- 
    ,fundsource varchar2(18) -- 
    ,operatetype varchar2(18) -- 
    ,currenylist varchar2(18) -- 
    ,currencymode varchar2(18) -- 
    ,businesstypelist varchar2(18) -- 
    ,calculatemode varchar2(18) -- 
    ,useorglist varchar2(18) -- 
    ,cycleflag varchar2(18) -- 
    ,flowreduceflag varchar2(18) -- 
    ,contractflag varchar2(18) -- 
    ,subcontractflag varchar2(18) -- 
    ,selfuseflag varchar2(18) -- 
    ,creditaggreement varchar2(32) -- 
    ,relativeagreement varchar2(32) -- 
    ,loanflag varchar2(18) -- 
    ,totalsum number(24,6) -- 
    ,ourrole varchar2(18) -- 
    ,reversibility varchar2(18) -- 
    ,billnum number -- 
    ,housetype varchar2(18) -- 
    ,lctermtype varchar2(18) -- 
    ,riskattribute varchar2(18) -- 
    ,suretype varchar2(18) -- 
    ,safeguardtype varchar2(18) -- 
    ,businesscurrency varchar2(18) -- 
    ,businesssum number(24,6) -- 
    ,businessprop number(10,6) -- 
    ,termyear number -- 
    ,termmonth number -- 
    ,termday number -- 
    ,lgterm number -- 
    ,baseratetype varchar2(18) -- 
    ,baserate number(10,6) -- 
    ,ratefloattype varchar2(18) -- 
    ,ratefloat number(10,6) -- 
    ,businessrate number(10,6) -- 
    ,ictype varchar2(18) -- 
    ,iccyc varchar2(18) -- 
    ,pdgratio number(10,6) -- 
    ,pdgsum number(24,6) -- 
    ,pdgpaymethod varchar2(18) -- 
    ,pdgpayperiod varchar2(18) -- 
    ,promisesfeeratio number(10,6) -- 
    ,promisesfeesum number(24,6) -- 
    ,promisesfeeperiod number -- 
    ,promisesfeebegin varchar2(10) -- 
    ,mfeeratio number(10,6) -- 
    ,mfeesum number(24,6) -- 
    ,mfeepaymethod varchar2(18) -- 
    ,agentfee number(24,6) -- 
    ,dealfee number(24,6) -- 
    ,totalcast number(24,6) -- 
    ,discountinterest number(24,6) -- 
    ,purchaserinterest number(24,6) -- 
    ,bargainorinterest number(24,6) -- 
    ,discountsum number(24,6) -- 
    ,bailratio number(10,6) -- 
    ,bailcurrency varchar2(18) -- 
    ,bailsum number(24,6) -- 
    ,bailaccount varchar2(32) -- 
    ,fineratetype varchar2(18) -- 
    ,finerate number(10,6) -- 
    ,drawingtype varchar2(18) -- 
    ,firstdrawingdate varchar2(10) -- 
    ,drawingperiod number -- 
    ,paytimes number -- 
    ,paycyc varchar2(18) -- 
    ,graceperiod number -- 
    ,overdraftperiod number -- 
    ,oldlcno varchar2(32) -- 
    ,oldlctermtype varchar2(18) -- 
    ,oldlccurrency varchar2(18) -- 
    ,oldlcsum number(24,6) -- 
    ,oldlcloadingdate varchar2(10) -- 
    ,oldlcvaliddate varchar2(10) -- 
    ,direction varchar2(18) -- 
    ,purpose varchar2(2000) -- 
    ,planallocation varchar2(200) -- 
    ,immediacypaysource varchar2(200) -- 
    ,paysource varchar2(200) -- 
    ,corpuspaymethod varchar2(18) -- 
    ,interestpaymethod varchar2(18) -- 
    ,thirdparty1 varchar2(200) -- 
    ,thirdpartyid1 varchar2(32) -- 
    ,thirdparty2 varchar2(200) -- 
    ,thirdpartyid2 varchar2(32) -- 
    ,thirdparty3 varchar2(200) -- 
    ,thirdpartyid3 varchar2(32) -- 
    ,thirdpartyregion varchar2(18) -- 
    ,thirdpartyaccounts varchar2(32) -- 
    ,cargoinfo varchar2(80) -- 
    ,projectname varchar2(80) -- 
    ,operationinfo char(400) -- 
    ,contextinfo varchar2(200) -- 
    ,securitiestype varchar2(18) -- 
    ,securitiesregion varchar2(18) -- 
    ,constructionarea number(24,6) -- 
    ,usearea number(24,6) -- 
    ,flag1 varchar2(18) -- 
    ,flag2 varchar2(18) -- 
    ,flag3 varchar2(18) -- 
    ,tradecontractno varchar2(32) -- 
    ,invoiceno varchar2(32) -- 
    ,tradecurrency varchar2(18) -- 
    ,tradesum number(24,6) -- 
    ,paymentdate varchar2(10) -- 
    ,operationmode varchar2(18) -- 
    ,vouchclass varchar2(18) -- 
    ,vouchtype varchar2(18) -- 
    ,vouchtype1 varchar2(18) -- 
    ,vouchtype2 varchar2(18) -- 
    ,vouchflag varchar2(18) -- 
    ,warrantor varchar2(80) -- 
    ,warrantorid varchar2(32) -- 
    ,othercondition varchar2(4000) -- 
    ,guarantyvalue number(24,6) -- 
    ,guarantyrate number(10,6) -- 
    ,baseevaluateresult varchar2(18) -- 
    ,riskrate number(24,6) -- 
    ,lowrisk varchar2(18) -- 
    ,otherarealoan varchar2(18) -- 
    ,lowriskbailsum number(24,6) -- 
    ,originalputoutdate varchar2(10) -- 
    ,extendtimes number -- 
    ,lngotimes number -- 
    ,golntimes number -- 
    ,drtimes number -- 
    ,baseclassifyresult varchar2(18) -- 
    ,applytype varchar2(20) -- 
    ,bailrate number(24,6) -- 
    ,finishorg varchar2(18) -- 
    ,operateorgid varchar2(32) -- 
    ,operateuserid varchar2(32) -- 
    ,operatedate varchar2(10) -- 
    ,inputorgid varchar2(32) -- 
    ,inputuserid varchar2(32) -- 
    ,inputdate varchar2(10) -- 
    ,updatedate varchar2(10) -- 
    ,pigeonholedate varchar2(10) -- 
    ,remark varchar2(200) -- 
    ,flag4 varchar2(18) -- 
    ,paycurrency varchar2(18) -- 
    ,paydate varchar2(10) -- 
    ,describe1 varchar2(200) -- 
    ,describe2 varchar2(200) -- 
    ,classifyresult varchar2(80) -- 
    ,classifydate varchar2(10) -- 
    ,classifyfrequency number -- 
    ,vouchnewflag varchar2(20) -- 
    ,adjustratetype varchar2(18) -- 
    ,adjustrateterm varchar2(18) -- 
    ,rateadjustcyc varchar2(18) -- 
    ,fzanbalance number(24,6) -- 
    ,acceptinttype varchar2(18) -- 
    ,fixcyc number -- 
    ,thirdpartyadd1 varchar2(80) -- 
    ,thirdpartyzip1 varchar2(32) -- 
    ,thirdpartyadd2 varchar2(80) -- 
    ,thirdpartyzip2 varchar2(32) -- 
    ,thirdpartyadd3 varchar2(80) -- 
    ,thirdpartyzip3 varchar2(32) -- 
    ,effectarea varchar2(18) -- 
    ,termdate1 varchar2(10) -- 
    ,termdate2 varchar2(10) -- 
    ,termdate3 varchar2(10) -- 
    ,ratio number(24,6) -- 
    ,tempsaveflag varchar2(18) -- 
    ,flag5 varchar2(18) -- 
    ,creditcycle varchar2(18) -- 
    ,guarantyflag varchar2(18) -- 
    ,isliquidity varchar2(4) -- 
    ,isfixed varchar2(4) -- 
    ,isproject varchar2(4) -- 
    ,nrelativecontractno varchar2(20) -- 新一贷关联房贷
    ,relativeaggreement varchar2(40) -- 关联的循环贷款协议号
    ,signedplace varchar2(30) -- 签约地点
    ,otherdatum varchar2(40) -- 附件材料(代码:OtherDatum)
    ,ltvvalue varchar2(10) -- 贷款成数
    ,savetype varchar2(10) -- 救治类型(代码:SaveType)---借新还旧使用
    ,channel varchar2(10) -- 营销渠道类型(代码:Channel)
    ,buyno varchar2(20) -- 订购编号
    ,betterrateflag varchar2(10) -- 有无优质客户利率优惠(代码:HaveNot)
    ,entname varchar2(32) -- 合作商名称
    ,introducerid varchar2(32) -- 介绍人编号
    ,orderno varchar2(20) -- 订单编号
    ,gracetermflag varchar2(10) -- 宽限期单位(代码:TermUnit)
    ,graceterm number(22) -- 宽限期
    ,holdbalance number(22) -- 保留金额（对气球贷的保留本金）尾款金额
    ,dunloanratio number(22) -- 费用收取比例
    ,preapproverid varchar2(32) -- 初审人ID
    ,fundserialno varchar2(40) -- 公积金受理编号
    ,mainreturntype varchar2(18) -- 主还款方式(代码:MainReturnMethod)
    ,cguarantypeople number(22) -- 抵押物权人人数```暂未使用
    ,turnratio number(22) -- 周转额度比例
    ,salechannelid varchar2(32) -- 营销渠道编号(类型为中介,开发商)
    ,bar_code_no varchar2(32) -- 影像条形码
    ,poundagerate number(22) -- 车贷手续费率
    ,approvedate varchar2(10) -- 审批通过日期
    ,isnewcustomer varchar2(20) -- 是否为黑名单客户
    ,salemode varchar2(10) -- 销售方式(代码:SaleMode)
    ,loanpreference varchar2(10) -- 老客户优惠(代码:LoanPreference)
    ,approvelevel varchar2(20) -- 审批级别
    ,schemeno varchar2(20) -- 方案编号
    ,abysum number(22) -- 赎楼金额
    ,loadrelabarcode varchar2(32) -- 赎楼贷款关联申请条形码
    ,otherdatumremark varchar2(100) -- 其他附件材料说明
    ,greensetdate varchar2(32) -- 绿色通道设置时间
    ,gaincyc number(22) -- 等比（等额）递变周期
    ,csinglnassure number(22) -- 个人保证人人数
    ,sellerinformation varchar2(400) -- 营销人员信息说明
    ,accountopenfee number(22) -- 个人贷款账户开户费
    ,ratemode varchar2(18) -- 利率执行方式(代码:RateMode)
    ,loanrelacontractno varchar2(32) -- 增值贷关联房贷合同号
    ,formerserialno varchar2(40) -- 相关流水号:重组贷款原合同号，借新换旧业务关联合同号
    ,tradebarcode varchar2(32) -- 商易贷关联条形码
    ,feetype varchar2(10) -- 费用类型(代码:LoanFeeType)
    ,houseareage number(22) -- 购房面积
    ,otherpurpose varchar2(100) -- 贷款其他用途---存单质押用
    ,hasbothflag varchar2(10) -- 是否属于转加按(代码:YesNo)
    ,currency varchar2(3) -- 币种(代码:Currency)
    ,ctogetherborrower number(22) -- 共同借款人人数
    ,isnewcustomertime varchar2(20) -- 黑名单检查时间
    ,applyinsuranceflag varchar2(10) -- 是否申请贷款保险保障(代码:YesNo)
    ,accountexpenses number(22) -- 费用
    ,guarantyhouse number(22) -- 抵押房产套数
    ,datatype varchar2(2) -- 0 老系统数据   1  新系统数据
    ,greenflag varchar2(10) -- 是否绿色通道业务(代码:YesNo)
    ,gracetermpay number(22) -- 宽限期固定还款额
    ,dunloanresource varchar2(100) -- 委托贷款资金来源
    ,spreadername varchar2(32) -- 推广人编号(车贷专用)
    ,pddid varchar2(32) -- 
    ,carintroducername varchar2(20) -- 业务经办人(车贷专用)
    ,approveresult varchar2(32) -- 审批结果
    ,buyhouseproperty varchar2(10) -- 所购房屋性质(代码:BuyHouseProperty)
    ,gatheringcardid varchar2(80) -- 收款账户卡/账号
    ,loantermflag varchar2(10) -- 贷款期限类型  默认为月M(代码:TermUnit)
    ,loanpurposeamt number(22) -- 贷款用途金额
    ,moneyproportion number(22) -- 金额比例
    ,dundepositno varchar2(32) -- 委托资金存款账号
    ,gainamount number(22) -- 等比（等额）递变幅度
    ,commissionfee number(22) -- 信用卡车贷回佣费用
    ,feemethod varchar2(10) -- 费用收取方式(代码:FeeMethod)
    ,presignflag varchar2(10) -- 是否预签合同(代码:YesNo)
    ,returnperiod varchar2(18) -- 还款周期(代码:PayCyc)
    ,houseprice number(22) -- 购房价格
    ,signaddress varchar2(32) -- 签约地点
    ,housecount number(22) -- 购房套数
    ,paymentmode varchar2(10) -- 付款方式
    ,ratecode varchar2(18) -- 利率类型(代码:RateCode)
    ,calcterm number(22) -- 还款计算期(月)
    ,approvesum number(22) -- 最新审批金额
    ,edumfee number(22) -- 额度管理费
    ,buyaddress varchar2(32) -- 购买的物业地址
    ,gatheringname varchar2(80) -- 划款账户户名
    ,paytype varchar2(3) -- 缴费方式
    ,crdid varchar2(18) -- 
    ,paymentcardid varchar2(80) -- 还款账户卡号
    ,operateusermind varchar2(200) -- 经办单位负责人意见
    ,buyhousetype varchar2(10) -- 所购房产类型(代码:BuyHouseType)
    ,faremoneytype varchar2(10) -- 费用收取类型(代码:FareMoneytType)
    ,sendchitflag varchar2(10) -- 是否需要短信提醒(代码:YesNo)
    ,oapproveflag varchar2(10) -- 是否例外审批件YesNo
    ,loanterm number(22) -- 贷款期限
    ,schemenofalg varchar2(1) -- 标识是否风控征信（YesNo）
    ,schemenoflag varchar2(10) -- 出国贷是否提取贷款---存单质押用(代码:YesNo)
    ,returntype varchar2(18) -- 子还款方式(代码:ReturnMethod)
    ,saleteamid varchar2(32) -- 营销单位名称(直销,网点)
    ,dealerid varchar2(32) -- 车贷商编号
    ,loantrustfee number(22) -- 委托贷款手续费
    ,deductaccno varchar2(40) -- 贷款结算账号（小消使用）
    ,backfee number(22) -- 信用卡车贷返利费用
    ,cycleratio number(22) -- 循环子额度占比
    ,goldflag varchar2(10) -- 是否申请按揭金(代码:YesNo)
    ,sealtype varchar2(20) -- 印章类型(代码:SealType)
    ,transferaccount varchar2(40) -- 转入账户账号（小消使用）
    ,ratedescribe varchar2(32) -- 
    ,creditmode varchar2(8) -- 
    ,isfinance varchar2(36) -- 
    ,industrytype varchar2(18) -- 
    ,artificialno varchar2(30) -- 
    ,analystno varchar2(32) -- 
    ,isrelative varchar2(1) -- 
    ,effectflag varchar2(3) -- 
    ,customertype varchar2(20) -- 
    ,archiveflag varchar2(2) -- 
    ,changeflag varchar2(2) -- 
    ,originalserialno varchar2(32) -- 
    ,flag varchar2(1) -- 
    ,ifcommerce varchar2(1) -- 
    ,mortgagecreditserialno varchar2(32) -- 按揭额度流水号
    ,mortgagecreditowner varchar2(80) -- 按揭额度所有人
    ,isstraight varchar2(10) -- 是否直客式
    ,professionalflag varchar2(2) -- 
    ,suremodel varchar2(2) -- 
    ,issme varchar2(1) -- 
    ,transcount varchar2(2) -- 
    ,accountno varchar2(36) -- 签约帐号
    ,maturity varchar2(32) -- 签约到期日
    ,istrans varchar2(2) -- 
    ,carbrand varchar2(100) -- 
    ,cartype varchar2(100) -- 
    ,carnumber varchar2(100) -- 
    ,chariotnumber varchar2(100) -- 
    ,motornumber varchar2(100) -- 
    ,financialcreditserialno varchar2(32) -- 商圈(群)客户额度批复流水号
    ,financialcreditowner varchar2(80) -- 商圈(群)客户名称
    ,isfinancialcredit varchar2(80) -- 是否商圈授信
    ,financialmodel varchar2(4000) -- 集群客户操作模式
    ,issmeandretail varchar2(1) -- 是否我行小微企业并且走零售条线
    ,ruleid varchar2(32) -- 授权规则编号
    ,buyhousedetail varchar2(10) -- 购房细分：1-购一手房，2-购二手房，3-购其他类型住房，4-购商铺，5-购写字楼，6-购厂房，7-购其他商业用房
    ,thirdparty1type varchar2(10) -- 代付类型：1-买方押汇，2-打包放款，3-卖方押汇，4-国内信用证项下贴现
    ,thirdorgname varchar2(100) -- 代付行,承兑行
    ,issjsh varchar2(1) -- 是否随借随还(1是2否)
    ,sjshserialno varchar2(32) -- 生效的随借随还申请号码
    ,isinuse varchar2(1) -- 添加维护标志1正常2不维护
    ,busirisktype varchar2(20) -- 风险类型
    ,playtype varchar2(2) -- 参与方式
    ,otherlimitno varchar2(32) -- 他用额度编号
    ,otherlimittype varchar2(32) -- 他用额度类型
    ,otherlimitownerid varchar2(32) -- 他用额度所有人
    ,iskyd varchar2(1) -- 是否快易贷
    ,authvouchtype varchar2(18) -- 授权权限_担保方式
    ,zbxxm varchar2(200) -- 主办行行名
    ,cdxxm varchar2(200) -- 参贷行行名
    ,dlxxm varchar2(200) -- 代理行行名
    ,dlcdbz varchar2(1) -- 代理参贷标志
    ,sqdkze number(18,2) -- 申请银团贷款总额
    ,jxhjcontractno varchar2(32) -- 借新还旧业务关联的原业务合同
    ,creditflowtype varchar2(20) -- 同业授信业务流程类型
    ,hxtyapproveresult varchar2(20) -- 同业授信终审结论
    ,isneedparallelwork varchar2(2) -- 是否需风险经理平行作业
    ,investway varchar2(2) -- 投资方式
    ,investtarget varchar2(160) -- 投资标的
    ,publicorg varchar2(2) -- 发行场所
    ,onlineamount number(24,6) -- 线上额度
    ,businesssumentpart number(24,6) -- 集团授信额度公司部分
    ,totalsumentpart number(24,6) -- 集团授信敞口公司部分
    ,businesssumtypart number(24,6) -- 集团授信额度同业部分
    ,totalsumtypart number(24,6) -- 集团授信额度同业部分
    ,creditarea varchar2(2) -- 授信区域:01 本地 02 省内异地 03 省外异地
    ,isestatefinance varchar2(2) -- 是否涉及房地产融资
    ,isgovernfinance varchar2(2) -- 是否涉及政府类融资
    ,isconsumerfinance varchar2(2) -- 是否为消费服务类融资
    ,isbeltroadfinance varchar2(2) -- 是否为一带一路建设投融资
    ,isgreenfinance varchar2(2) -- 是否为绿色信贷融资
    ,islikeloan varchar2(2) -- 是否类信贷
    ,iscangenerateapprove varchar2(8) -- 是否可以登记批复:No-不可以登记批复 否则-可以登记批复
    ,hxtyoperateorg varchar2(2) -- 同业归口管理部门
    ,classifyresulteleven varchar2(18) -- 资产风险分类
    ,outclassifylevel varchar2(18) -- 外部债项评级
    ,outclassifyorg varchar2(200) -- 评级机构
    ,outclassifydate varchar2(10) -- 评级日期
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
grant select on ${idl_schema}.oass_crss_business_apply to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_crss_business_apply is '业务申请信息';
comment on column ${idl_schema}.oass_crss_business_apply.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_crss_business_apply.serialno is '';
comment on column ${idl_schema}.oass_crss_business_apply.relativeserialno is '';
comment on column ${idl_schema}.oass_crss_business_apply.occurdate is '';
comment on column ${idl_schema}.oass_crss_business_apply.customerid is '';
comment on column ${idl_schema}.oass_crss_business_apply.customername is '';
comment on column ${idl_schema}.oass_crss_business_apply.businesstype is '';
comment on column ${idl_schema}.oass_crss_business_apply.businesssubtype is '';
comment on column ${idl_schema}.oass_crss_business_apply.occurtype is '';
comment on column ${idl_schema}.oass_crss_business_apply.fundsource is '';
comment on column ${idl_schema}.oass_crss_business_apply.operatetype is '';
comment on column ${idl_schema}.oass_crss_business_apply.currenylist is '';
comment on column ${idl_schema}.oass_crss_business_apply.currencymode is '';
comment on column ${idl_schema}.oass_crss_business_apply.businesstypelist is '';
comment on column ${idl_schema}.oass_crss_business_apply.calculatemode is '';
comment on column ${idl_schema}.oass_crss_business_apply.useorglist is '';
comment on column ${idl_schema}.oass_crss_business_apply.cycleflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.flowreduceflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.contractflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.subcontractflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.selfuseflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.creditaggreement is '';
comment on column ${idl_schema}.oass_crss_business_apply.relativeagreement is '';
comment on column ${idl_schema}.oass_crss_business_apply.loanflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.totalsum is '';
comment on column ${idl_schema}.oass_crss_business_apply.ourrole is '';
comment on column ${idl_schema}.oass_crss_business_apply.reversibility is '';
comment on column ${idl_schema}.oass_crss_business_apply.billnum is '';
comment on column ${idl_schema}.oass_crss_business_apply.housetype is '';
comment on column ${idl_schema}.oass_crss_business_apply.lctermtype is '';
comment on column ${idl_schema}.oass_crss_business_apply.riskattribute is '';
comment on column ${idl_schema}.oass_crss_business_apply.suretype is '';
comment on column ${idl_schema}.oass_crss_business_apply.safeguardtype is '';
comment on column ${idl_schema}.oass_crss_business_apply.businesscurrency is '';
comment on column ${idl_schema}.oass_crss_business_apply.businesssum is '';
comment on column ${idl_schema}.oass_crss_business_apply.businessprop is '';
comment on column ${idl_schema}.oass_crss_business_apply.termyear is '';
comment on column ${idl_schema}.oass_crss_business_apply.termmonth is '';
comment on column ${idl_schema}.oass_crss_business_apply.termday is '';
comment on column ${idl_schema}.oass_crss_business_apply.lgterm is '';
comment on column ${idl_schema}.oass_crss_business_apply.baseratetype is '';
comment on column ${idl_schema}.oass_crss_business_apply.baserate is '';
comment on column ${idl_schema}.oass_crss_business_apply.ratefloattype is '';
comment on column ${idl_schema}.oass_crss_business_apply.ratefloat is '';
comment on column ${idl_schema}.oass_crss_business_apply.businessrate is '';
comment on column ${idl_schema}.oass_crss_business_apply.ictype is '';
comment on column ${idl_schema}.oass_crss_business_apply.iccyc is '';
comment on column ${idl_schema}.oass_crss_business_apply.pdgratio is '';
comment on column ${idl_schema}.oass_crss_business_apply.pdgsum is '';
comment on column ${idl_schema}.oass_crss_business_apply.pdgpaymethod is '';
comment on column ${idl_schema}.oass_crss_business_apply.pdgpayperiod is '';
comment on column ${idl_schema}.oass_crss_business_apply.promisesfeeratio is '';
comment on column ${idl_schema}.oass_crss_business_apply.promisesfeesum is '';
comment on column ${idl_schema}.oass_crss_business_apply.promisesfeeperiod is '';
comment on column ${idl_schema}.oass_crss_business_apply.promisesfeebegin is '';
comment on column ${idl_schema}.oass_crss_business_apply.mfeeratio is '';
comment on column ${idl_schema}.oass_crss_business_apply.mfeesum is '';
comment on column ${idl_schema}.oass_crss_business_apply.mfeepaymethod is '';
comment on column ${idl_schema}.oass_crss_business_apply.agentfee is '';
comment on column ${idl_schema}.oass_crss_business_apply.dealfee is '';
comment on column ${idl_schema}.oass_crss_business_apply.totalcast is '';
comment on column ${idl_schema}.oass_crss_business_apply.discountinterest is '';
comment on column ${idl_schema}.oass_crss_business_apply.purchaserinterest is '';
comment on column ${idl_schema}.oass_crss_business_apply.bargainorinterest is '';
comment on column ${idl_schema}.oass_crss_business_apply.discountsum is '';
comment on column ${idl_schema}.oass_crss_business_apply.bailratio is '';
comment on column ${idl_schema}.oass_crss_business_apply.bailcurrency is '';
comment on column ${idl_schema}.oass_crss_business_apply.bailsum is '';
comment on column ${idl_schema}.oass_crss_business_apply.bailaccount is '';
comment on column ${idl_schema}.oass_crss_business_apply.fineratetype is '';
comment on column ${idl_schema}.oass_crss_business_apply.finerate is '';
comment on column ${idl_schema}.oass_crss_business_apply.drawingtype is '';
comment on column ${idl_schema}.oass_crss_business_apply.firstdrawingdate is '';
comment on column ${idl_schema}.oass_crss_business_apply.drawingperiod is '';
comment on column ${idl_schema}.oass_crss_business_apply.paytimes is '';
comment on column ${idl_schema}.oass_crss_business_apply.paycyc is '';
comment on column ${idl_schema}.oass_crss_business_apply.graceperiod is '';
comment on column ${idl_schema}.oass_crss_business_apply.overdraftperiod is '';
comment on column ${idl_schema}.oass_crss_business_apply.oldlcno is '';
comment on column ${idl_schema}.oass_crss_business_apply.oldlctermtype is '';
comment on column ${idl_schema}.oass_crss_business_apply.oldlccurrency is '';
comment on column ${idl_schema}.oass_crss_business_apply.oldlcsum is '';
comment on column ${idl_schema}.oass_crss_business_apply.oldlcloadingdate is '';
comment on column ${idl_schema}.oass_crss_business_apply.oldlcvaliddate is '';
comment on column ${idl_schema}.oass_crss_business_apply.direction is '';
comment on column ${idl_schema}.oass_crss_business_apply.purpose is '';
comment on column ${idl_schema}.oass_crss_business_apply.planallocation is '';
comment on column ${idl_schema}.oass_crss_business_apply.immediacypaysource is '';
comment on column ${idl_schema}.oass_crss_business_apply.paysource is '';
comment on column ${idl_schema}.oass_crss_business_apply.corpuspaymethod is '';
comment on column ${idl_schema}.oass_crss_business_apply.interestpaymethod is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdparty1 is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdpartyid1 is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdparty2 is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdpartyid2 is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdparty3 is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdpartyid3 is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdpartyregion is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdpartyaccounts is '';
comment on column ${idl_schema}.oass_crss_business_apply.cargoinfo is '';
comment on column ${idl_schema}.oass_crss_business_apply.projectname is '';
comment on column ${idl_schema}.oass_crss_business_apply.operationinfo is '';
comment on column ${idl_schema}.oass_crss_business_apply.contextinfo is '';
comment on column ${idl_schema}.oass_crss_business_apply.securitiestype is '';
comment on column ${idl_schema}.oass_crss_business_apply.securitiesregion is '';
comment on column ${idl_schema}.oass_crss_business_apply.constructionarea is '';
comment on column ${idl_schema}.oass_crss_business_apply.usearea is '';
comment on column ${idl_schema}.oass_crss_business_apply.flag1 is '';
comment on column ${idl_schema}.oass_crss_business_apply.flag2 is '';
comment on column ${idl_schema}.oass_crss_business_apply.flag3 is '';
comment on column ${idl_schema}.oass_crss_business_apply.tradecontractno is '';
comment on column ${idl_schema}.oass_crss_business_apply.invoiceno is '';
comment on column ${idl_schema}.oass_crss_business_apply.tradecurrency is '';
comment on column ${idl_schema}.oass_crss_business_apply.tradesum is '';
comment on column ${idl_schema}.oass_crss_business_apply.paymentdate is '';
comment on column ${idl_schema}.oass_crss_business_apply.operationmode is '';
comment on column ${idl_schema}.oass_crss_business_apply.vouchclass is '';
comment on column ${idl_schema}.oass_crss_business_apply.vouchtype is '';
comment on column ${idl_schema}.oass_crss_business_apply.vouchtype1 is '';
comment on column ${idl_schema}.oass_crss_business_apply.vouchtype2 is '';
comment on column ${idl_schema}.oass_crss_business_apply.vouchflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.warrantor is '';
comment on column ${idl_schema}.oass_crss_business_apply.warrantorid is '';
comment on column ${idl_schema}.oass_crss_business_apply.othercondition is '';
comment on column ${idl_schema}.oass_crss_business_apply.guarantyvalue is '';
comment on column ${idl_schema}.oass_crss_business_apply.guarantyrate is '';
comment on column ${idl_schema}.oass_crss_business_apply.baseevaluateresult is '';
comment on column ${idl_schema}.oass_crss_business_apply.riskrate is '';
comment on column ${idl_schema}.oass_crss_business_apply.lowrisk is '';
comment on column ${idl_schema}.oass_crss_business_apply.otherarealoan is '';
comment on column ${idl_schema}.oass_crss_business_apply.lowriskbailsum is '';
comment on column ${idl_schema}.oass_crss_business_apply.originalputoutdate is '';
comment on column ${idl_schema}.oass_crss_business_apply.extendtimes is '';
comment on column ${idl_schema}.oass_crss_business_apply.lngotimes is '';
comment on column ${idl_schema}.oass_crss_business_apply.golntimes is '';
comment on column ${idl_schema}.oass_crss_business_apply.drtimes is '';
comment on column ${idl_schema}.oass_crss_business_apply.baseclassifyresult is '';
comment on column ${idl_schema}.oass_crss_business_apply.applytype is '';
comment on column ${idl_schema}.oass_crss_business_apply.bailrate is '';
comment on column ${idl_schema}.oass_crss_business_apply.finishorg is '';
comment on column ${idl_schema}.oass_crss_business_apply.operateorgid is '';
comment on column ${idl_schema}.oass_crss_business_apply.operateuserid is '';
comment on column ${idl_schema}.oass_crss_business_apply.operatedate is '';
comment on column ${idl_schema}.oass_crss_business_apply.inputorgid is '';
comment on column ${idl_schema}.oass_crss_business_apply.inputuserid is '';
comment on column ${idl_schema}.oass_crss_business_apply.inputdate is '';
comment on column ${idl_schema}.oass_crss_business_apply.updatedate is '';
comment on column ${idl_schema}.oass_crss_business_apply.pigeonholedate is '';
comment on column ${idl_schema}.oass_crss_business_apply.remark is '';
comment on column ${idl_schema}.oass_crss_business_apply.flag4 is '';
comment on column ${idl_schema}.oass_crss_business_apply.paycurrency is '';
comment on column ${idl_schema}.oass_crss_business_apply.paydate is '';
comment on column ${idl_schema}.oass_crss_business_apply.describe1 is '';
comment on column ${idl_schema}.oass_crss_business_apply.describe2 is '';
comment on column ${idl_schema}.oass_crss_business_apply.classifyresult is '';
comment on column ${idl_schema}.oass_crss_business_apply.classifydate is '';
comment on column ${idl_schema}.oass_crss_business_apply.classifyfrequency is '';
comment on column ${idl_schema}.oass_crss_business_apply.vouchnewflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.adjustratetype is '';
comment on column ${idl_schema}.oass_crss_business_apply.adjustrateterm is '';
comment on column ${idl_schema}.oass_crss_business_apply.rateadjustcyc is '';
comment on column ${idl_schema}.oass_crss_business_apply.fzanbalance is '';
comment on column ${idl_schema}.oass_crss_business_apply.acceptinttype is '';
comment on column ${idl_schema}.oass_crss_business_apply.fixcyc is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdpartyadd1 is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdpartyzip1 is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdpartyadd2 is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdpartyzip2 is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdpartyadd3 is '';
comment on column ${idl_schema}.oass_crss_business_apply.thirdpartyzip3 is '';
comment on column ${idl_schema}.oass_crss_business_apply.effectarea is '';
comment on column ${idl_schema}.oass_crss_business_apply.termdate1 is '';
comment on column ${idl_schema}.oass_crss_business_apply.termdate2 is '';
comment on column ${idl_schema}.oass_crss_business_apply.termdate3 is '';
comment on column ${idl_schema}.oass_crss_business_apply.ratio is '';
comment on column ${idl_schema}.oass_crss_business_apply.tempsaveflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.flag5 is '';
comment on column ${idl_schema}.oass_crss_business_apply.creditcycle is '';
comment on column ${idl_schema}.oass_crss_business_apply.guarantyflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.isliquidity is '';
comment on column ${idl_schema}.oass_crss_business_apply.isfixed is '';
comment on column ${idl_schema}.oass_crss_business_apply.isproject is '';
comment on column ${idl_schema}.oass_crss_business_apply.nrelativecontractno is '新一贷关联房贷';
comment on column ${idl_schema}.oass_crss_business_apply.relativeaggreement is '关联的循环贷款协议号';
comment on column ${idl_schema}.oass_crss_business_apply.signedplace is '签约地点';
comment on column ${idl_schema}.oass_crss_business_apply.otherdatum is '附件材料(代码:OtherDatum)';
comment on column ${idl_schema}.oass_crss_business_apply.ltvvalue is '贷款成数';
comment on column ${idl_schema}.oass_crss_business_apply.savetype is '救治类型(代码:SaveType)---借新还旧使用';
comment on column ${idl_schema}.oass_crss_business_apply.channel is '营销渠道类型(代码:Channel)';
comment on column ${idl_schema}.oass_crss_business_apply.buyno is '订购编号';
comment on column ${idl_schema}.oass_crss_business_apply.betterrateflag is '有无优质客户利率优惠(代码:HaveNot)';
comment on column ${idl_schema}.oass_crss_business_apply.entname is '合作商名称';
comment on column ${idl_schema}.oass_crss_business_apply.introducerid is '介绍人编号';
comment on column ${idl_schema}.oass_crss_business_apply.orderno is '订单编号';
comment on column ${idl_schema}.oass_crss_business_apply.gracetermflag is '宽限期单位(代码:TermUnit)';
comment on column ${idl_schema}.oass_crss_business_apply.graceterm is '宽限期';
comment on column ${idl_schema}.oass_crss_business_apply.holdbalance is '保留金额（对气球贷的保留本金）尾款金额';
comment on column ${idl_schema}.oass_crss_business_apply.dunloanratio is '费用收取比例';
comment on column ${idl_schema}.oass_crss_business_apply.preapproverid is '初审人ID';
comment on column ${idl_schema}.oass_crss_business_apply.fundserialno is '公积金受理编号';
comment on column ${idl_schema}.oass_crss_business_apply.mainreturntype is '主还款方式(代码:MainReturnMethod)';
comment on column ${idl_schema}.oass_crss_business_apply.cguarantypeople is '抵押物权人人数```暂未使用';
comment on column ${idl_schema}.oass_crss_business_apply.turnratio is '周转额度比例';
comment on column ${idl_schema}.oass_crss_business_apply.salechannelid is '营销渠道编号(类型为中介,开发商)';
comment on column ${idl_schema}.oass_crss_business_apply.bar_code_no is '影像条形码';
comment on column ${idl_schema}.oass_crss_business_apply.poundagerate is '车贷手续费率';
comment on column ${idl_schema}.oass_crss_business_apply.approvedate is '审批通过日期';
comment on column ${idl_schema}.oass_crss_business_apply.isnewcustomer is '是否为黑名单客户';
comment on column ${idl_schema}.oass_crss_business_apply.salemode is '销售方式(代码:SaleMode)';
comment on column ${idl_schema}.oass_crss_business_apply.loanpreference is '老客户优惠(代码:LoanPreference)';
comment on column ${idl_schema}.oass_crss_business_apply.approvelevel is '审批级别';
comment on column ${idl_schema}.oass_crss_business_apply.schemeno is '方案编号';
comment on column ${idl_schema}.oass_crss_business_apply.abysum is '赎楼金额';
comment on column ${idl_schema}.oass_crss_business_apply.loadrelabarcode is '赎楼贷款关联申请条形码';
comment on column ${idl_schema}.oass_crss_business_apply.otherdatumremark is '其他附件材料说明';
comment on column ${idl_schema}.oass_crss_business_apply.greensetdate is '绿色通道设置时间';
comment on column ${idl_schema}.oass_crss_business_apply.gaincyc is '等比（等额）递变周期';
comment on column ${idl_schema}.oass_crss_business_apply.csinglnassure is '个人保证人人数';
comment on column ${idl_schema}.oass_crss_business_apply.sellerinformation is '营销人员信息说明';
comment on column ${idl_schema}.oass_crss_business_apply.accountopenfee is '个人贷款账户开户费';
comment on column ${idl_schema}.oass_crss_business_apply.ratemode is '利率执行方式(代码:RateMode)';
comment on column ${idl_schema}.oass_crss_business_apply.loanrelacontractno is '增值贷关联房贷合同号';
comment on column ${idl_schema}.oass_crss_business_apply.formerserialno is '相关流水号:重组贷款原合同号，借新换旧业务关联合同号';
comment on column ${idl_schema}.oass_crss_business_apply.tradebarcode is '商易贷关联条形码';
comment on column ${idl_schema}.oass_crss_business_apply.feetype is '费用类型(代码:LoanFeeType)';
comment on column ${idl_schema}.oass_crss_business_apply.houseareage is '购房面积';
comment on column ${idl_schema}.oass_crss_business_apply.otherpurpose is '贷款其他用途---存单质押用';
comment on column ${idl_schema}.oass_crss_business_apply.hasbothflag is '是否属于转加按(代码:YesNo)';
comment on column ${idl_schema}.oass_crss_business_apply.currency is '币种(代码:Currency)';
comment on column ${idl_schema}.oass_crss_business_apply.ctogetherborrower is '共同借款人人数';
comment on column ${idl_schema}.oass_crss_business_apply.isnewcustomertime is '黑名单检查时间';
comment on column ${idl_schema}.oass_crss_business_apply.applyinsuranceflag is '是否申请贷款保险保障(代码:YesNo)';
comment on column ${idl_schema}.oass_crss_business_apply.accountexpenses is '费用';
comment on column ${idl_schema}.oass_crss_business_apply.guarantyhouse is '抵押房产套数';
comment on column ${idl_schema}.oass_crss_business_apply.datatype is '0 老系统数据   1  新系统数据';
comment on column ${idl_schema}.oass_crss_business_apply.greenflag is '是否绿色通道业务(代码:YesNo)';
comment on column ${idl_schema}.oass_crss_business_apply.gracetermpay is '宽限期固定还款额';
comment on column ${idl_schema}.oass_crss_business_apply.dunloanresource is '委托贷款资金来源';
comment on column ${idl_schema}.oass_crss_business_apply.spreadername is '推广人编号(车贷专用)';
comment on column ${idl_schema}.oass_crss_business_apply.pddid is '';
comment on column ${idl_schema}.oass_crss_business_apply.carintroducername is '业务经办人(车贷专用)';
comment on column ${idl_schema}.oass_crss_business_apply.approveresult is '审批结果';
comment on column ${idl_schema}.oass_crss_business_apply.buyhouseproperty is '所购房屋性质(代码:BuyHouseProperty)';
comment on column ${idl_schema}.oass_crss_business_apply.gatheringcardid is '收款账户卡/账号';
comment on column ${idl_schema}.oass_crss_business_apply.loantermflag is '贷款期限类型  默认为月M(代码:TermUnit)';
comment on column ${idl_schema}.oass_crss_business_apply.loanpurposeamt is '贷款用途金额';
comment on column ${idl_schema}.oass_crss_business_apply.moneyproportion is '金额比例';
comment on column ${idl_schema}.oass_crss_business_apply.dundepositno is '委托资金存款账号';
comment on column ${idl_schema}.oass_crss_business_apply.gainamount is '等比（等额）递变幅度';
comment on column ${idl_schema}.oass_crss_business_apply.commissionfee is '信用卡车贷回佣费用';
comment on column ${idl_schema}.oass_crss_business_apply.feemethod is '费用收取方式(代码:FeeMethod)';
comment on column ${idl_schema}.oass_crss_business_apply.presignflag is '是否预签合同(代码:YesNo)';
comment on column ${idl_schema}.oass_crss_business_apply.returnperiod is '还款周期(代码:PayCyc)';
comment on column ${idl_schema}.oass_crss_business_apply.houseprice is '购房价格';
comment on column ${idl_schema}.oass_crss_business_apply.signaddress is '签约地点';
comment on column ${idl_schema}.oass_crss_business_apply.housecount is '购房套数';
comment on column ${idl_schema}.oass_crss_business_apply.paymentmode is '付款方式';
comment on column ${idl_schema}.oass_crss_business_apply.ratecode is '利率类型(代码:RateCode)';
comment on column ${idl_schema}.oass_crss_business_apply.calcterm is '还款计算期(月)';
comment on column ${idl_schema}.oass_crss_business_apply.approvesum is '最新审批金额';
comment on column ${idl_schema}.oass_crss_business_apply.edumfee is '额度管理费';
comment on column ${idl_schema}.oass_crss_business_apply.buyaddress is '购买的物业地址';
comment on column ${idl_schema}.oass_crss_business_apply.gatheringname is '划款账户户名';
comment on column ${idl_schema}.oass_crss_business_apply.paytype is '缴费方式';
comment on column ${idl_schema}.oass_crss_business_apply.crdid is '';
comment on column ${idl_schema}.oass_crss_business_apply.paymentcardid is '还款账户卡号';
comment on column ${idl_schema}.oass_crss_business_apply.operateusermind is '经办单位负责人意见';
comment on column ${idl_schema}.oass_crss_business_apply.buyhousetype is '所购房产类型(代码:BuyHouseType)';
comment on column ${idl_schema}.oass_crss_business_apply.faremoneytype is '费用收取类型(代码:FareMoneytType)';
comment on column ${idl_schema}.oass_crss_business_apply.sendchitflag is '是否需要短信提醒(代码:YesNo)';
comment on column ${idl_schema}.oass_crss_business_apply.oapproveflag is '是否例外审批件YesNo';
comment on column ${idl_schema}.oass_crss_business_apply.loanterm is '贷款期限';
comment on column ${idl_schema}.oass_crss_business_apply.schemenofalg is '标识是否风控征信（YesNo）';
comment on column ${idl_schema}.oass_crss_business_apply.schemenoflag is '出国贷是否提取贷款---存单质押用(代码:YesNo)';
comment on column ${idl_schema}.oass_crss_business_apply.returntype is '子还款方式(代码:ReturnMethod)';
comment on column ${idl_schema}.oass_crss_business_apply.saleteamid is '营销单位名称(直销,网点)';
comment on column ${idl_schema}.oass_crss_business_apply.dealerid is '车贷商编号';
comment on column ${idl_schema}.oass_crss_business_apply.loantrustfee is '委托贷款手续费';
comment on column ${idl_schema}.oass_crss_business_apply.deductaccno is '贷款结算账号（小消使用）';
comment on column ${idl_schema}.oass_crss_business_apply.backfee is '信用卡车贷返利费用';
comment on column ${idl_schema}.oass_crss_business_apply.cycleratio is '循环子额度占比';
comment on column ${idl_schema}.oass_crss_business_apply.goldflag is '是否申请按揭金(代码:YesNo)';
comment on column ${idl_schema}.oass_crss_business_apply.sealtype is '印章类型(代码:SealType)';
comment on column ${idl_schema}.oass_crss_business_apply.transferaccount is '转入账户账号（小消使用）';
comment on column ${idl_schema}.oass_crss_business_apply.ratedescribe is '';
comment on column ${idl_schema}.oass_crss_business_apply.creditmode is '';
comment on column ${idl_schema}.oass_crss_business_apply.isfinance is '';
comment on column ${idl_schema}.oass_crss_business_apply.industrytype is '';
comment on column ${idl_schema}.oass_crss_business_apply.artificialno is '';
comment on column ${idl_schema}.oass_crss_business_apply.analystno is '';
comment on column ${idl_schema}.oass_crss_business_apply.isrelative is '';
comment on column ${idl_schema}.oass_crss_business_apply.effectflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.customertype is '';
comment on column ${idl_schema}.oass_crss_business_apply.archiveflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.changeflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.originalserialno is '';
comment on column ${idl_schema}.oass_crss_business_apply.flag is '';
comment on column ${idl_schema}.oass_crss_business_apply.ifcommerce is '';
comment on column ${idl_schema}.oass_crss_business_apply.mortgagecreditserialno is '按揭额度流水号';
comment on column ${idl_schema}.oass_crss_business_apply.mortgagecreditowner is '按揭额度所有人';
comment on column ${idl_schema}.oass_crss_business_apply.isstraight is '是否直客式';
comment on column ${idl_schema}.oass_crss_business_apply.professionalflag is '';
comment on column ${idl_schema}.oass_crss_business_apply.suremodel is '';
comment on column ${idl_schema}.oass_crss_business_apply.issme is '';
comment on column ${idl_schema}.oass_crss_business_apply.transcount is '';
comment on column ${idl_schema}.oass_crss_business_apply.accountno is '签约帐号';
comment on column ${idl_schema}.oass_crss_business_apply.maturity is '签约到期日';
comment on column ${idl_schema}.oass_crss_business_apply.istrans is '';
comment on column ${idl_schema}.oass_crss_business_apply.carbrand is '';
comment on column ${idl_schema}.oass_crss_business_apply.cartype is '';
comment on column ${idl_schema}.oass_crss_business_apply.carnumber is '';
comment on column ${idl_schema}.oass_crss_business_apply.chariotnumber is '';
comment on column ${idl_schema}.oass_crss_business_apply.motornumber is '';
comment on column ${idl_schema}.oass_crss_business_apply.financialcreditserialno is '商圈(群)客户额度批复流水号';
comment on column ${idl_schema}.oass_crss_business_apply.financialcreditowner is '商圈(群)客户名称';
comment on column ${idl_schema}.oass_crss_business_apply.isfinancialcredit is '是否商圈授信';
comment on column ${idl_schema}.oass_crss_business_apply.financialmodel is '集群客户操作模式';
comment on column ${idl_schema}.oass_crss_business_apply.issmeandretail is '是否我行小微企业并且走零售条线';
comment on column ${idl_schema}.oass_crss_business_apply.ruleid is '授权规则编号';
comment on column ${idl_schema}.oass_crss_business_apply.buyhousedetail is '购房细分：1-购一手房，2-购二手房，3-购其他类型住房，4-购商铺，5-购写字楼，6-购厂房，7-购其他商业用房';
comment on column ${idl_schema}.oass_crss_business_apply.thirdparty1type is '代付类型：1-买方押汇，2-打包放款，3-卖方押汇，4-国内信用证项下贴现';
comment on column ${idl_schema}.oass_crss_business_apply.thirdorgname is '代付行,承兑行';
comment on column ${idl_schema}.oass_crss_business_apply.issjsh is '是否随借随还(1是2否)';
comment on column ${idl_schema}.oass_crss_business_apply.sjshserialno is '生效的随借随还申请号码';
comment on column ${idl_schema}.oass_crss_business_apply.isinuse is '添加维护标志1正常2不维护';
comment on column ${idl_schema}.oass_crss_business_apply.busirisktype is '风险类型';
comment on column ${idl_schema}.oass_crss_business_apply.playtype is '参与方式';
comment on column ${idl_schema}.oass_crss_business_apply.otherlimitno is '他用额度编号';
comment on column ${idl_schema}.oass_crss_business_apply.otherlimittype is '他用额度类型';
comment on column ${idl_schema}.oass_crss_business_apply.otherlimitownerid is '他用额度所有人';
comment on column ${idl_schema}.oass_crss_business_apply.iskyd is '是否快易贷';
comment on column ${idl_schema}.oass_crss_business_apply.authvouchtype is '授权权限_担保方式';
comment on column ${idl_schema}.oass_crss_business_apply.zbxxm is '主办行行名';
comment on column ${idl_schema}.oass_crss_business_apply.cdxxm is '参贷行行名';
comment on column ${idl_schema}.oass_crss_business_apply.dlxxm is '代理行行名';
comment on column ${idl_schema}.oass_crss_business_apply.dlcdbz is '代理参贷标志';
comment on column ${idl_schema}.oass_crss_business_apply.sqdkze is '申请银团贷款总额';
comment on column ${idl_schema}.oass_crss_business_apply.jxhjcontractno is '借新还旧业务关联的原业务合同';
comment on column ${idl_schema}.oass_crss_business_apply.creditflowtype is '同业授信业务流程类型';
comment on column ${idl_schema}.oass_crss_business_apply.hxtyapproveresult is '同业授信终审结论';
comment on column ${idl_schema}.oass_crss_business_apply.isneedparallelwork is '是否需风险经理平行作业';
comment on column ${idl_schema}.oass_crss_business_apply.investway is '投资方式';
comment on column ${idl_schema}.oass_crss_business_apply.investtarget is '投资标的';
comment on column ${idl_schema}.oass_crss_business_apply.publicorg is '发行场所';
comment on column ${idl_schema}.oass_crss_business_apply.onlineamount is '线上额度';
comment on column ${idl_schema}.oass_crss_business_apply.businesssumentpart is '集团授信额度公司部分';
comment on column ${idl_schema}.oass_crss_business_apply.totalsumentpart is '集团授信敞口公司部分';
comment on column ${idl_schema}.oass_crss_business_apply.businesssumtypart is '集团授信额度同业部分';
comment on column ${idl_schema}.oass_crss_business_apply.totalsumtypart is '集团授信额度同业部分';
comment on column ${idl_schema}.oass_crss_business_apply.creditarea is '授信区域:01 本地 02 省内异地 03 省外异地';
comment on column ${idl_schema}.oass_crss_business_apply.isestatefinance is '是否涉及房地产融资';
comment on column ${idl_schema}.oass_crss_business_apply.isgovernfinance is '是否涉及政府类融资';
comment on column ${idl_schema}.oass_crss_business_apply.isconsumerfinance is '是否为消费服务类融资';
comment on column ${idl_schema}.oass_crss_business_apply.isbeltroadfinance is '是否为一带一路建设投融资';
comment on column ${idl_schema}.oass_crss_business_apply.isgreenfinance is '是否为绿色信贷融资';
comment on column ${idl_schema}.oass_crss_business_apply.islikeloan is '是否类信贷';
comment on column ${idl_schema}.oass_crss_business_apply.iscangenerateapprove is '是否可以登记批复:No-不可以登记批复 否则-可以登记批复';
comment on column ${idl_schema}.oass_crss_business_apply.hxtyoperateorg is '同业归口管理部门';
comment on column ${idl_schema}.oass_crss_business_apply.classifyresulteleven is '资产风险分类';
comment on column ${idl_schema}.oass_crss_business_apply.outclassifylevel is '外部债项评级';
comment on column ${idl_schema}.oass_crss_business_apply.outclassifyorg is '评级机构';
comment on column ${idl_schema}.oass_crss_business_apply.outclassifydate is '评级日期';
comment on column ${idl_schema}.oass_crss_business_apply.start_dt is '';
comment on column ${idl_schema}.oass_crss_business_apply.end_dt is '';
comment on column ${idl_schema}.oass_crss_business_apply.id_mark is '';
comment on column ${idl_schema}.oass_crss_business_apply.etl_timestamp is '';
