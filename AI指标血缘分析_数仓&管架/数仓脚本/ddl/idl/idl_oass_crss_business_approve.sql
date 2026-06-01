/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_crss_business_approve
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.oass_crss_business_approve
whenever sqlerror continue none;
drop table ${idl_schema}.oass_crss_business_approve purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.oass_crss_business_approve(
    etl_dt date -- 数据日期
    ,serialno varchar2(32) -- 
    ,relativeserialno varchar2(32) -- 
    ,occurdate varchar2(10) -- 
    ,customerid varchar2(32) -- 
    ,customername varchar2(80) -- 
    ,businesstype varchar2(18) -- 
    ,businesssubtype varchar2(18) -- 
    ,occurtype varchar2(18) -- 
    ,currenylist varchar2(18) -- 
    ,currencymode varchar2(18) -- 
    ,businesstypelist varchar2(18) -- 
    ,calculatemode varchar2(18) -- 
    ,useorglist varchar2(18) -- 
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
    ,creditbusiness varchar2(18) -- 
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
    ,operationinfo varchar2(400) -- 
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
    ,applytype varchar2(32) -- 
    ,bailrate number(24,6) -- 
    ,finishorg varchar2(18) -- 
    ,describe1 varchar2(200) -- 
    ,operateorgid varchar2(32) -- 
    ,operateuserid varchar2(32) -- 
    ,operatedate varchar2(10) -- 
    ,inputorgid varchar2(32) -- 
    ,inputuserid varchar2(32) -- 
    ,inputdate varchar2(20) -- 
    ,updatedate varchar2(10) -- 
    ,pigeonholedate varchar2(10) -- 
    ,remark varchar2(200) -- 
    ,paycurrency varchar2(18) -- 
    ,paydate varchar2(10) -- 
    ,flag4 varchar2(18) -- 
    ,fundsource varchar2(18) -- 
    ,operatetype varchar2(18) -- 
    ,approvetype varchar2(20) -- 
    ,cycleflag varchar2(20) -- 
    ,classifyresult varchar2(80) -- 
    ,classifydate varchar2(10) -- 
    ,classifyfrequency number -- 
    ,vouchnewflag varchar2(20) -- 
    ,adjustratetype varchar2(18) -- 
    ,adjustrateterm varchar2(18) -- 
    ,rateadjustcyc varchar2(18) -- 
    ,fzanbalance number(24,6) -- 
    ,acceptinttype varchar2(18) -- 
    ,ratio number(24,6) -- 
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
    ,fixcyc number -- 
    ,describe2 varchar2(200) -- 
    ,approveopinion varchar2(4000) -- 最终审批意见
    ,tempsaveflag varchar2(18) -- 
    ,approvedate varchar2(10) -- 
    ,flag5 varchar2(18) -- 
    ,creditcycle varchar2(18) -- 
    ,guarantyflag varchar2(18) -- 
    ,effectflag varchar2(3) -- 
    ,creditmode varchar2(18) -- 
    ,artificialno varchar2(32) -- 
    ,returntype varchar2(18) -- 
    ,holdbalance number(22) -- 
    ,returnperiod varchar2(18) -- 
    ,loantermflag varchar2(10) -- 
    ,mainreturntype varchar2(18) -- 
    ,schemeno varchar2(20) -- 
    ,ltvvalue varchar2(10) -- 
    ,ratemode varchar2(18) -- 
    ,loanterm number(22) -- 
    ,otherpurpose varchar2(100) -- 
    ,currency varchar2(3) -- 
    ,cguarantypeople number(22) -- 
    ,buyhousetype varchar2(10) -- 
    ,buyhouseproperty varchar2(10) -- 
    ,houseareage number(22) -- 
    ,houseprice number(22) -- 
    ,housecount number(22) -- 
    ,paymentmode varchar2(10) -- 
    ,fundserialno varchar2(40) -- 
    ,ctogetherborrower number(22) -- 
    ,csinglnassure number(22) -- 
    ,guarantyhouse number(22) -- 
    ,abysum number(22) -- 
    ,applyinsuranceflag varchar2(10) -- 
    ,sendchitflag varchar2(10) -- 
    ,ratecode varchar2(18) -- 
    ,calcterm number(22) -- 
    ,classifyresulteleven varchar2(18) -- 
    ,reinforceflag varchar2(5) -- 
    ,approveopinion1 varchar2(4000) -- 最终审批意见2
    ,accountno varchar2(36) -- 签约帐号
    ,maturity varchar2(32) -- 签约到期日
    ,istrans varchar2(2) -- 
    ,carbrand varchar2(100) -- 
    ,cartype varchar2(100) -- 
    ,carnumber varchar2(100) -- 
    ,chariotnumber varchar2(100) -- 
    ,motornumber varchar2(100) -- 
    ,rateopinion varchar2(18) -- 客户评级
    ,preeffectflag varchar2(3) -- 变更前批复状态
    ,iscontinueoversee varchar2(1) -- 是否继续监测
    ,buyhousedetail varchar2(10) -- 购房细分：1-购一手房，2-购二手房，3-购其他类型住房，4-购商铺，5-购写字楼，6-购厂房，7-购其他商业用房
    ,thirdparty1type varchar2(10) -- 代付类型：1-买方押汇，2-打包放款，3-卖方押汇，4-国内信用证项下贴现
    ,thirdorgname varchar2(100) -- 代付行,承兑行
    ,approveopinion6 varchar2(4000) -- 审批意见续一
    ,approveopinion7 varchar2(4000) -- 审批意见续二
    ,priattribute varchar2(10) -- 低风险/类低风险业务类型
    ,oldeffectflag varchar2(3) -- 备份生效标志
    ,availableothersum number(24,6) -- 可用他用额度
    ,isinuse varchar2(1) -- 添加维护标志1正常2不维护
    ,busirisktype varchar2(20) -- 风险类型
    ,playtype varchar2(2) -- 参与方式
    ,otherlimitno varchar2(32) -- 他用额度编号
    ,otherlimittype varchar2(32) -- 他用额度类型
    ,otherlimitownerid varchar2(32) -- 他用额度所有人
    ,zbxxm varchar2(200) -- 主办行行名
    ,cdxxm varchar2(200) -- 参贷行行名
    ,dlxxm varchar2(200) -- 代理行行名
    ,dlcdbz varchar2(1) -- 代理参贷标志
    ,sqdkze number(18,2) -- 申请银团贷款总额
    ,precreditcycle varchar2(18) -- 变更前额度是否循环标志
    ,fszqinput varchar2(1) -- 买入返售债券专项额度手工登记 1-未完成 2-已完成
    ,reinforcechecker varchar2(10) -- 补登复核人
    ,onlineamount number(24,6) -- 线上额度
    ,businesssumentpart number(24,6) -- 集团授信额度公司部分
    ,totalsumentpart number(24,6) -- 集团授信敞口公司部分
    ,businesssumtypart number(24,6) -- 集团授信额度同业部分
    ,totalsumtypart number(24,6) -- 集团授信额度同业部分
    ,hxtyapproveresult varchar2(15) -- 终审结论(华兴同业使用):agree-同意、reject-否决、toContinue-待续议
    ,investway varchar2(2) -- 投资方式
    ,investtarget varchar2(160) -- 投资标的
    ,publicorg varchar2(2) -- 发行场所
    ,creditflowtype varchar2(20) -- 同业授信业务流程类型
    ,isyeartocheck varchar2(4) -- 是否年审（Code:YesNo）
    ,sqcheckyeardate varchar2(10) -- 上期年审日期
    ,bqcheckyeardate varchar2(10) -- 本期年审日期
    ,checkyearstatus varchar2(1) -- 年审进行状态(0或空 未进行  1进行中)
    ,approveenddate varchar2(10) -- 终审通过日期
    ,creditarea varchar2(2) -- 授信区域:01 本地 02 省内异地 03 省外异地
    ,isestatefinance varchar2(2) -- 是否涉及房地产融资
    ,isgovernfinance varchar2(2) -- 是否涉及政府类融资
    ,isconsumerfinance varchar2(2) -- 是否为消费服务类融资
    ,isbeltroadfinance varchar2(2) -- 是否为一带一路建设投融资
    ,isgreenfinance varchar2(2) -- 是否为绿色信贷融资
    ,islikeloan varchar2(2) -- 是否类信贷
    ,reinforcetype varchar2(2) -- 补登来源 dg-对公 空-同业
    ,outclassifylevel varchar2(18) -- 外部债项评级
    ,outclassifyorg varchar2(200) -- 评级机构
    ,outclassifydate varchar2(10) -- 评级日期
    ,hxtyoperateorg varchar2(2) -- 同业归口管理部门
    ,approvecodeno varchar2(18) -- 批复编号(YYYY###,如20180001)
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
grant select on ${idl_schema}.oass_crss_business_approve to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_crss_business_approve is '业务批准信息';
comment on column ${idl_schema}.oass_crss_business_approve.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_crss_business_approve.serialno is '';
comment on column ${idl_schema}.oass_crss_business_approve.relativeserialno is '';
comment on column ${idl_schema}.oass_crss_business_approve.occurdate is '';
comment on column ${idl_schema}.oass_crss_business_approve.customerid is '';
comment on column ${idl_schema}.oass_crss_business_approve.customername is '';
comment on column ${idl_schema}.oass_crss_business_approve.businesstype is '';
comment on column ${idl_schema}.oass_crss_business_approve.businesssubtype is '';
comment on column ${idl_schema}.oass_crss_business_approve.occurtype is '';
comment on column ${idl_schema}.oass_crss_business_approve.currenylist is '';
comment on column ${idl_schema}.oass_crss_business_approve.currencymode is '';
comment on column ${idl_schema}.oass_crss_business_approve.businesstypelist is '';
comment on column ${idl_schema}.oass_crss_business_approve.calculatemode is '';
comment on column ${idl_schema}.oass_crss_business_approve.useorglist is '';
comment on column ${idl_schema}.oass_crss_business_approve.flowreduceflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.contractflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.subcontractflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.selfuseflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.creditaggreement is '';
comment on column ${idl_schema}.oass_crss_business_approve.relativeagreement is '';
comment on column ${idl_schema}.oass_crss_business_approve.loanflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.totalsum is '';
comment on column ${idl_schema}.oass_crss_business_approve.ourrole is '';
comment on column ${idl_schema}.oass_crss_business_approve.reversibility is '';
comment on column ${idl_schema}.oass_crss_business_approve.billnum is '';
comment on column ${idl_schema}.oass_crss_business_approve.housetype is '';
comment on column ${idl_schema}.oass_crss_business_approve.lctermtype is '';
comment on column ${idl_schema}.oass_crss_business_approve.riskattribute is '';
comment on column ${idl_schema}.oass_crss_business_approve.suretype is '';
comment on column ${idl_schema}.oass_crss_business_approve.safeguardtype is '';
comment on column ${idl_schema}.oass_crss_business_approve.creditbusiness is '';
comment on column ${idl_schema}.oass_crss_business_approve.businesscurrency is '';
comment on column ${idl_schema}.oass_crss_business_approve.businesssum is '';
comment on column ${idl_schema}.oass_crss_business_approve.businessprop is '';
comment on column ${idl_schema}.oass_crss_business_approve.termyear is '';
comment on column ${idl_schema}.oass_crss_business_approve.termmonth is '';
comment on column ${idl_schema}.oass_crss_business_approve.termday is '';
comment on column ${idl_schema}.oass_crss_business_approve.lgterm is '';
comment on column ${idl_schema}.oass_crss_business_approve.baseratetype is '';
comment on column ${idl_schema}.oass_crss_business_approve.baserate is '';
comment on column ${idl_schema}.oass_crss_business_approve.ratefloattype is '';
comment on column ${idl_schema}.oass_crss_business_approve.ratefloat is '';
comment on column ${idl_schema}.oass_crss_business_approve.businessrate is '';
comment on column ${idl_schema}.oass_crss_business_approve.ictype is '';
comment on column ${idl_schema}.oass_crss_business_approve.iccyc is '';
comment on column ${idl_schema}.oass_crss_business_approve.pdgratio is '';
comment on column ${idl_schema}.oass_crss_business_approve.pdgsum is '';
comment on column ${idl_schema}.oass_crss_business_approve.pdgpaymethod is '';
comment on column ${idl_schema}.oass_crss_business_approve.pdgpayperiod is '';
comment on column ${idl_schema}.oass_crss_business_approve.promisesfeeratio is '';
comment on column ${idl_schema}.oass_crss_business_approve.promisesfeesum is '';
comment on column ${idl_schema}.oass_crss_business_approve.promisesfeeperiod is '';
comment on column ${idl_schema}.oass_crss_business_approve.promisesfeebegin is '';
comment on column ${idl_schema}.oass_crss_business_approve.mfeeratio is '';
comment on column ${idl_schema}.oass_crss_business_approve.mfeesum is '';
comment on column ${idl_schema}.oass_crss_business_approve.mfeepaymethod is '';
comment on column ${idl_schema}.oass_crss_business_approve.agentfee is '';
comment on column ${idl_schema}.oass_crss_business_approve.dealfee is '';
comment on column ${idl_schema}.oass_crss_business_approve.totalcast is '';
comment on column ${idl_schema}.oass_crss_business_approve.discountinterest is '';
comment on column ${idl_schema}.oass_crss_business_approve.purchaserinterest is '';
comment on column ${idl_schema}.oass_crss_business_approve.bargainorinterest is '';
comment on column ${idl_schema}.oass_crss_business_approve.discountsum is '';
comment on column ${idl_schema}.oass_crss_business_approve.bailratio is '';
comment on column ${idl_schema}.oass_crss_business_approve.bailcurrency is '';
comment on column ${idl_schema}.oass_crss_business_approve.bailsum is '';
comment on column ${idl_schema}.oass_crss_business_approve.bailaccount is '';
comment on column ${idl_schema}.oass_crss_business_approve.fineratetype is '';
comment on column ${idl_schema}.oass_crss_business_approve.finerate is '';
comment on column ${idl_schema}.oass_crss_business_approve.drawingtype is '';
comment on column ${idl_schema}.oass_crss_business_approve.firstdrawingdate is '';
comment on column ${idl_schema}.oass_crss_business_approve.drawingperiod is '';
comment on column ${idl_schema}.oass_crss_business_approve.paytimes is '';
comment on column ${idl_schema}.oass_crss_business_approve.paycyc is '';
comment on column ${idl_schema}.oass_crss_business_approve.graceperiod is '';
comment on column ${idl_schema}.oass_crss_business_approve.overdraftperiod is '';
comment on column ${idl_schema}.oass_crss_business_approve.oldlcno is '';
comment on column ${idl_schema}.oass_crss_business_approve.oldlctermtype is '';
comment on column ${idl_schema}.oass_crss_business_approve.oldlccurrency is '';
comment on column ${idl_schema}.oass_crss_business_approve.oldlcsum is '';
comment on column ${idl_schema}.oass_crss_business_approve.oldlcloadingdate is '';
comment on column ${idl_schema}.oass_crss_business_approve.oldlcvaliddate is '';
comment on column ${idl_schema}.oass_crss_business_approve.direction is '';
comment on column ${idl_schema}.oass_crss_business_approve.purpose is '';
comment on column ${idl_schema}.oass_crss_business_approve.planallocation is '';
comment on column ${idl_schema}.oass_crss_business_approve.immediacypaysource is '';
comment on column ${idl_schema}.oass_crss_business_approve.paysource is '';
comment on column ${idl_schema}.oass_crss_business_approve.corpuspaymethod is '';
comment on column ${idl_schema}.oass_crss_business_approve.interestpaymethod is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdparty1 is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdpartyid1 is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdparty2 is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdpartyid2 is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdparty3 is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdpartyid3 is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdpartyregion is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdpartyaccounts is '';
comment on column ${idl_schema}.oass_crss_business_approve.cargoinfo is '';
comment on column ${idl_schema}.oass_crss_business_approve.projectname is '';
comment on column ${idl_schema}.oass_crss_business_approve.operationinfo is '';
comment on column ${idl_schema}.oass_crss_business_approve.contextinfo is '';
comment on column ${idl_schema}.oass_crss_business_approve.securitiestype is '';
comment on column ${idl_schema}.oass_crss_business_approve.securitiesregion is '';
comment on column ${idl_schema}.oass_crss_business_approve.constructionarea is '';
comment on column ${idl_schema}.oass_crss_business_approve.usearea is '';
comment on column ${idl_schema}.oass_crss_business_approve.flag1 is '';
comment on column ${idl_schema}.oass_crss_business_approve.flag2 is '';
comment on column ${idl_schema}.oass_crss_business_approve.flag3 is '';
comment on column ${idl_schema}.oass_crss_business_approve.tradecontractno is '';
comment on column ${idl_schema}.oass_crss_business_approve.invoiceno is '';
comment on column ${idl_schema}.oass_crss_business_approve.tradecurrency is '';
comment on column ${idl_schema}.oass_crss_business_approve.tradesum is '';
comment on column ${idl_schema}.oass_crss_business_approve.paymentdate is '';
comment on column ${idl_schema}.oass_crss_business_approve.operationmode is '';
comment on column ${idl_schema}.oass_crss_business_approve.vouchclass is '';
comment on column ${idl_schema}.oass_crss_business_approve.vouchtype is '';
comment on column ${idl_schema}.oass_crss_business_approve.vouchtype1 is '';
comment on column ${idl_schema}.oass_crss_business_approve.vouchtype2 is '';
comment on column ${idl_schema}.oass_crss_business_approve.vouchflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.warrantor is '';
comment on column ${idl_schema}.oass_crss_business_approve.warrantorid is '';
comment on column ${idl_schema}.oass_crss_business_approve.othercondition is '';
comment on column ${idl_schema}.oass_crss_business_approve.guarantyvalue is '';
comment on column ${idl_schema}.oass_crss_business_approve.guarantyrate is '';
comment on column ${idl_schema}.oass_crss_business_approve.baseevaluateresult is '';
comment on column ${idl_schema}.oass_crss_business_approve.riskrate is '';
comment on column ${idl_schema}.oass_crss_business_approve.lowrisk is '';
comment on column ${idl_schema}.oass_crss_business_approve.otherarealoan is '';
comment on column ${idl_schema}.oass_crss_business_approve.lowriskbailsum is '';
comment on column ${idl_schema}.oass_crss_business_approve.originalputoutdate is '';
comment on column ${idl_schema}.oass_crss_business_approve.extendtimes is '';
comment on column ${idl_schema}.oass_crss_business_approve.lngotimes is '';
comment on column ${idl_schema}.oass_crss_business_approve.golntimes is '';
comment on column ${idl_schema}.oass_crss_business_approve.drtimes is '';
comment on column ${idl_schema}.oass_crss_business_approve.baseclassifyresult is '';
comment on column ${idl_schema}.oass_crss_business_approve.applytype is '';
comment on column ${idl_schema}.oass_crss_business_approve.bailrate is '';
comment on column ${idl_schema}.oass_crss_business_approve.finishorg is '';
comment on column ${idl_schema}.oass_crss_business_approve.describe1 is '';
comment on column ${idl_schema}.oass_crss_business_approve.operateorgid is '';
comment on column ${idl_schema}.oass_crss_business_approve.operateuserid is '';
comment on column ${idl_schema}.oass_crss_business_approve.operatedate is '';
comment on column ${idl_schema}.oass_crss_business_approve.inputorgid is '';
comment on column ${idl_schema}.oass_crss_business_approve.inputuserid is '';
comment on column ${idl_schema}.oass_crss_business_approve.inputdate is '';
comment on column ${idl_schema}.oass_crss_business_approve.updatedate is '';
comment on column ${idl_schema}.oass_crss_business_approve.pigeonholedate is '';
comment on column ${idl_schema}.oass_crss_business_approve.remark is '';
comment on column ${idl_schema}.oass_crss_business_approve.paycurrency is '';
comment on column ${idl_schema}.oass_crss_business_approve.paydate is '';
comment on column ${idl_schema}.oass_crss_business_approve.flag4 is '';
comment on column ${idl_schema}.oass_crss_business_approve.fundsource is '';
comment on column ${idl_schema}.oass_crss_business_approve.operatetype is '';
comment on column ${idl_schema}.oass_crss_business_approve.approvetype is '';
comment on column ${idl_schema}.oass_crss_business_approve.cycleflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.classifyresult is '';
comment on column ${idl_schema}.oass_crss_business_approve.classifydate is '';
comment on column ${idl_schema}.oass_crss_business_approve.classifyfrequency is '';
comment on column ${idl_schema}.oass_crss_business_approve.vouchnewflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.adjustratetype is '';
comment on column ${idl_schema}.oass_crss_business_approve.adjustrateterm is '';
comment on column ${idl_schema}.oass_crss_business_approve.rateadjustcyc is '';
comment on column ${idl_schema}.oass_crss_business_approve.fzanbalance is '';
comment on column ${idl_schema}.oass_crss_business_approve.acceptinttype is '';
comment on column ${idl_schema}.oass_crss_business_approve.ratio is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdpartyadd1 is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdpartyzip1 is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdpartyadd2 is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdpartyzip2 is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdpartyadd3 is '';
comment on column ${idl_schema}.oass_crss_business_approve.thirdpartyzip3 is '';
comment on column ${idl_schema}.oass_crss_business_approve.effectarea is '';
comment on column ${idl_schema}.oass_crss_business_approve.termdate1 is '';
comment on column ${idl_schema}.oass_crss_business_approve.termdate2 is '';
comment on column ${idl_schema}.oass_crss_business_approve.termdate3 is '';
comment on column ${idl_schema}.oass_crss_business_approve.fixcyc is '';
comment on column ${idl_schema}.oass_crss_business_approve.describe2 is '';
comment on column ${idl_schema}.oass_crss_business_approve.approveopinion is '最终审批意见';
comment on column ${idl_schema}.oass_crss_business_approve.tempsaveflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.approvedate is '';
comment on column ${idl_schema}.oass_crss_business_approve.flag5 is '';
comment on column ${idl_schema}.oass_crss_business_approve.creditcycle is '';
comment on column ${idl_schema}.oass_crss_business_approve.guarantyflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.effectflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.creditmode is '';
comment on column ${idl_schema}.oass_crss_business_approve.artificialno is '';
comment on column ${idl_schema}.oass_crss_business_approve.returntype is '';
comment on column ${idl_schema}.oass_crss_business_approve.holdbalance is '';
comment on column ${idl_schema}.oass_crss_business_approve.returnperiod is '';
comment on column ${idl_schema}.oass_crss_business_approve.loantermflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.mainreturntype is '';
comment on column ${idl_schema}.oass_crss_business_approve.schemeno is '';
comment on column ${idl_schema}.oass_crss_business_approve.ltvvalue is '';
comment on column ${idl_schema}.oass_crss_business_approve.ratemode is '';
comment on column ${idl_schema}.oass_crss_business_approve.loanterm is '';
comment on column ${idl_schema}.oass_crss_business_approve.otherpurpose is '';
comment on column ${idl_schema}.oass_crss_business_approve.currency is '';
comment on column ${idl_schema}.oass_crss_business_approve.cguarantypeople is '';
comment on column ${idl_schema}.oass_crss_business_approve.buyhousetype is '';
comment on column ${idl_schema}.oass_crss_business_approve.buyhouseproperty is '';
comment on column ${idl_schema}.oass_crss_business_approve.houseareage is '';
comment on column ${idl_schema}.oass_crss_business_approve.houseprice is '';
comment on column ${idl_schema}.oass_crss_business_approve.housecount is '';
comment on column ${idl_schema}.oass_crss_business_approve.paymentmode is '';
comment on column ${idl_schema}.oass_crss_business_approve.fundserialno is '';
comment on column ${idl_schema}.oass_crss_business_approve.ctogetherborrower is '';
comment on column ${idl_schema}.oass_crss_business_approve.csinglnassure is '';
comment on column ${idl_schema}.oass_crss_business_approve.guarantyhouse is '';
comment on column ${idl_schema}.oass_crss_business_approve.abysum is '';
comment on column ${idl_schema}.oass_crss_business_approve.applyinsuranceflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.sendchitflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.ratecode is '';
comment on column ${idl_schema}.oass_crss_business_approve.calcterm is '';
comment on column ${idl_schema}.oass_crss_business_approve.classifyresulteleven is '';
comment on column ${idl_schema}.oass_crss_business_approve.reinforceflag is '';
comment on column ${idl_schema}.oass_crss_business_approve.approveopinion1 is '最终审批意见2';
comment on column ${idl_schema}.oass_crss_business_approve.accountno is '签约帐号';
comment on column ${idl_schema}.oass_crss_business_approve.maturity is '签约到期日';
comment on column ${idl_schema}.oass_crss_business_approve.istrans is '';
comment on column ${idl_schema}.oass_crss_business_approve.carbrand is '';
comment on column ${idl_schema}.oass_crss_business_approve.cartype is '';
comment on column ${idl_schema}.oass_crss_business_approve.carnumber is '';
comment on column ${idl_schema}.oass_crss_business_approve.chariotnumber is '';
comment on column ${idl_schema}.oass_crss_business_approve.motornumber is '';
comment on column ${idl_schema}.oass_crss_business_approve.rateopinion is '客户评级';
comment on column ${idl_schema}.oass_crss_business_approve.preeffectflag is '变更前批复状态';
comment on column ${idl_schema}.oass_crss_business_approve.iscontinueoversee is '是否继续监测';
comment on column ${idl_schema}.oass_crss_business_approve.buyhousedetail is '购房细分：1-购一手房，2-购二手房，3-购其他类型住房，4-购商铺，5-购写字楼，6-购厂房，7-购其他商业用房';
comment on column ${idl_schema}.oass_crss_business_approve.thirdparty1type is '代付类型：1-买方押汇，2-打包放款，3-卖方押汇，4-国内信用证项下贴现';
comment on column ${idl_schema}.oass_crss_business_approve.thirdorgname is '代付行,承兑行';
comment on column ${idl_schema}.oass_crss_business_approve.approveopinion6 is '审批意见续一';
comment on column ${idl_schema}.oass_crss_business_approve.approveopinion7 is '审批意见续二';
comment on column ${idl_schema}.oass_crss_business_approve.priattribute is '低风险/类低风险业务类型';
comment on column ${idl_schema}.oass_crss_business_approve.oldeffectflag is '备份生效标志';
comment on column ${idl_schema}.oass_crss_business_approve.availableothersum is '可用他用额度';
comment on column ${idl_schema}.oass_crss_business_approve.isinuse is '添加维护标志1正常2不维护';
comment on column ${idl_schema}.oass_crss_business_approve.busirisktype is '风险类型';
comment on column ${idl_schema}.oass_crss_business_approve.playtype is '参与方式';
comment on column ${idl_schema}.oass_crss_business_approve.otherlimitno is '他用额度编号';
comment on column ${idl_schema}.oass_crss_business_approve.otherlimittype is '他用额度类型';
comment on column ${idl_schema}.oass_crss_business_approve.otherlimitownerid is '他用额度所有人';
comment on column ${idl_schema}.oass_crss_business_approve.zbxxm is '主办行行名';
comment on column ${idl_schema}.oass_crss_business_approve.cdxxm is '参贷行行名';
comment on column ${idl_schema}.oass_crss_business_approve.dlxxm is '代理行行名';
comment on column ${idl_schema}.oass_crss_business_approve.dlcdbz is '代理参贷标志';
comment on column ${idl_schema}.oass_crss_business_approve.sqdkze is '申请银团贷款总额';
comment on column ${idl_schema}.oass_crss_business_approve.precreditcycle is '变更前额度是否循环标志';
comment on column ${idl_schema}.oass_crss_business_approve.fszqinput is '买入返售债券专项额度手工登记 1-未完成 2-已完成';
comment on column ${idl_schema}.oass_crss_business_approve.reinforcechecker is '补登复核人';
comment on column ${idl_schema}.oass_crss_business_approve.onlineamount is '线上额度';
comment on column ${idl_schema}.oass_crss_business_approve.businesssumentpart is '集团授信额度公司部分';
comment on column ${idl_schema}.oass_crss_business_approve.totalsumentpart is '集团授信敞口公司部分';
comment on column ${idl_schema}.oass_crss_business_approve.businesssumtypart is '集团授信额度同业部分';
comment on column ${idl_schema}.oass_crss_business_approve.totalsumtypart is '集团授信额度同业部分';
comment on column ${idl_schema}.oass_crss_business_approve.hxtyapproveresult is '终审结论(华兴同业使用):agree-同意、reject-否决、toContinue-待续议';
comment on column ${idl_schema}.oass_crss_business_approve.investway is '投资方式';
comment on column ${idl_schema}.oass_crss_business_approve.investtarget is '投资标的';
comment on column ${idl_schema}.oass_crss_business_approve.publicorg is '发行场所';
comment on column ${idl_schema}.oass_crss_business_approve.creditflowtype is '同业授信业务流程类型';
comment on column ${idl_schema}.oass_crss_business_approve.isyeartocheck is '是否年审（Code:YesNo）';
comment on column ${idl_schema}.oass_crss_business_approve.sqcheckyeardate is '上期年审日期';
comment on column ${idl_schema}.oass_crss_business_approve.bqcheckyeardate is '本期年审日期';
comment on column ${idl_schema}.oass_crss_business_approve.checkyearstatus is '年审进行状态(0或空 未进行  1进行中)';
comment on column ${idl_schema}.oass_crss_business_approve.approveenddate is '终审通过日期';
comment on column ${idl_schema}.oass_crss_business_approve.creditarea is '授信区域:01 本地 02 省内异地 03 省外异地';
comment on column ${idl_schema}.oass_crss_business_approve.isestatefinance is '是否涉及房地产融资';
comment on column ${idl_schema}.oass_crss_business_approve.isgovernfinance is '是否涉及政府类融资';
comment on column ${idl_schema}.oass_crss_business_approve.isconsumerfinance is '是否为消费服务类融资';
comment on column ${idl_schema}.oass_crss_business_approve.isbeltroadfinance is '是否为一带一路建设投融资';
comment on column ${idl_schema}.oass_crss_business_approve.isgreenfinance is '是否为绿色信贷融资';
comment on column ${idl_schema}.oass_crss_business_approve.islikeloan is '是否类信贷';
comment on column ${idl_schema}.oass_crss_business_approve.reinforcetype is '补登来源 dg-对公 空-同业';
comment on column ${idl_schema}.oass_crss_business_approve.outclassifylevel is '外部债项评级';
comment on column ${idl_schema}.oass_crss_business_approve.outclassifyorg is '评级机构';
comment on column ${idl_schema}.oass_crss_business_approve.outclassifydate is '评级日期';
comment on column ${idl_schema}.oass_crss_business_approve.hxtyoperateorg is '同业归口管理部门';
comment on column ${idl_schema}.oass_crss_business_approve.approvecodeno is '批复编号(YYYY###,如20180001)';
comment on column ${idl_schema}.oass_crss_business_approve.start_dt is '';
comment on column ${idl_schema}.oass_crss_business_approve.end_dt is '';
comment on column ${idl_schema}.oass_crss_business_approve.id_mark is '';
comment on column ${idl_schema}.oass_crss_business_approve.etl_timestamp is '';
