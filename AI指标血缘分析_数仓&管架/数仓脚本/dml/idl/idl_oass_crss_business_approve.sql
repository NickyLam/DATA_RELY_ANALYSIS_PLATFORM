/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_crss_business_approve
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
alter table ${idl_schema}.oass_crss_business_approve drop partition p_${retain_week};
alter table ${idl_schema}.oass_crss_business_approve drop partition p_${batch_date};


-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_crss_business_approve add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_crss_business_approve (
    etl_dt  -- 数据日期
    ,serialno  -- 
    ,relativeserialno  -- 
    ,occurdate  -- 
    ,customerid  -- 
    ,customername  -- 
    ,businesstype  -- 
    ,businesssubtype  -- 
    ,occurtype  -- 
    ,currenylist  -- 
    ,currencymode  -- 
    ,businesstypelist  -- 
    ,calculatemode  -- 
    ,useorglist  -- 
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
    ,creditbusiness  -- 
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
    ,describe1  -- 
    ,operateorgid  -- 
    ,operateuserid  -- 
    ,operatedate  -- 
    ,inputorgid  -- 
    ,inputuserid  -- 
    ,inputdate  -- 
    ,updatedate  -- 
    ,pigeonholedate  -- 
    ,remark  -- 
    ,paycurrency  -- 
    ,paydate  -- 
    ,flag4  -- 
    ,fundsource  -- 
    ,operatetype  -- 
    ,approvetype  -- 
    ,cycleflag  -- 
    ,classifyresult  -- 
    ,classifydate  -- 
    ,classifyfrequency  -- 
    ,vouchnewflag  -- 
    ,adjustratetype  -- 
    ,adjustrateterm  -- 
    ,rateadjustcyc  -- 
    ,fzanbalance  -- 
    ,acceptinttype  -- 
    ,ratio  -- 
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
    ,fixcyc  -- 
    ,describe2  -- 
    ,approveopinion  -- 最终审批意见
    ,tempsaveflag  -- 
    ,approvedate  -- 
    ,flag5  -- 
    ,creditcycle  -- 
    ,guarantyflag  -- 
    ,effectflag  -- 
    ,creditmode  -- 
    ,artificialno  -- 
    ,returntype  -- 
    ,holdbalance  -- 
    ,returnperiod  -- 
    ,loantermflag  -- 
    ,mainreturntype  -- 
    ,schemeno  -- 
    ,ltvvalue  -- 
    ,ratemode  -- 
    ,loanterm  -- 
    ,otherpurpose  -- 
    ,currency  -- 
    ,cguarantypeople  -- 
    ,buyhousetype  -- 
    ,buyhouseproperty  -- 
    ,houseareage  -- 
    ,houseprice  -- 
    ,housecount  -- 
    ,paymentmode  -- 
    ,fundserialno  -- 
    ,ctogetherborrower  -- 
    ,csinglnassure  -- 
    ,guarantyhouse  -- 
    ,abysum  -- 
    ,applyinsuranceflag  -- 
    ,sendchitflag  -- 
    ,ratecode  -- 
    ,calcterm  -- 
    ,classifyresulteleven  -- 
    ,reinforceflag  -- 
    ,approveopinion1  -- 最终审批意见2
    ,accountno  -- 签约帐号
    ,maturity  -- 签约到期日
    ,istrans  -- 
    ,carbrand  -- 
    ,cartype  -- 
    ,carnumber  -- 
    ,chariotnumber  -- 
    ,motornumber  -- 
    ,rateopinion  -- 客户评级
    ,preeffectflag  -- 变更前批复状态
    ,iscontinueoversee  -- 是否继续监测
    ,buyhousedetail  -- 购房细分：1-购一手房，2-购二手房，3-购其他类型住房，4-购商铺，5-购写字楼，6-购厂房，7-购其他商业用房
    ,thirdparty1type  -- 代付类型：1-买方押汇，2-打包放款，3-卖方押汇，4-国内信用证项下贴现
    ,thirdorgname  -- 代付行,承兑行
    ,approveopinion6  -- 审批意见续一
    ,approveopinion7  -- 审批意见续二
    ,priattribute  -- 低风险/类低风险业务类型
    ,oldeffectflag  -- 备份生效标志
    ,availableothersum  -- 可用他用额度
    ,isinuse  -- 添加维护标志1正常2不维护
    ,busirisktype  -- 风险类型
    ,playtype  -- 参与方式
    ,otherlimitno  -- 他用额度编号
    ,otherlimittype  -- 他用额度类型
    ,otherlimitownerid  -- 他用额度所有人
    ,zbxxm  -- 主办行行名
    ,cdxxm  -- 参贷行行名
    ,dlxxm  -- 代理行行名
    ,dlcdbz  -- 代理参贷标志
    ,sqdkze  -- 申请银团贷款总额
    ,precreditcycle  -- 变更前额度是否循环标志
    ,fszqinput  -- 买入返售债券专项额度手工登记 1-未完成 2-已完成
    ,reinforcechecker  -- 补登复核人
    ,onlineamount  -- 线上额度
    ,businesssumentpart  -- 集团授信额度公司部分
    ,totalsumentpart  -- 集团授信敞口公司部分
    ,businesssumtypart  -- 集团授信额度同业部分
    ,totalsumtypart  -- 集团授信额度同业部分
    ,hxtyapproveresult  -- 终审结论(华兴同业使用):agree-同意、reject-否决、toContinue-待续议
    ,investway  -- 投资方式
    ,investtarget  -- 投资标的
    ,publicorg  -- 发行场所
    ,creditflowtype  -- 同业授信业务流程类型
    ,isyeartocheck  -- 是否年审（Code:YesNo）
    ,sqcheckyeardate  -- 上期年审日期
    ,bqcheckyeardate  -- 本期年审日期
    ,checkyearstatus  -- 年审进行状态(0或空 未进行  1进行中)
    ,approveenddate  -- 终审通过日期
    ,creditarea  -- 授信区域:01 本地 02 省内异地 03 省外异地
    ,isestatefinance  -- 是否涉及房地产融资
    ,isgovernfinance  -- 是否涉及政府类融资
    ,isconsumerfinance  -- 是否为消费服务类融资
    ,isbeltroadfinance  -- 是否为一带一路建设投融资
    ,isgreenfinance  -- 是否为绿色信贷融资
    ,islikeloan  -- 是否类信贷
    ,reinforcetype  -- 补登来源 dg-对公 空-同业
    ,outclassifylevel  -- 外部债项评级
    ,outclassifyorg  -- 评级机构
    ,outclassifydate  -- 评级日期
    ,hxtyoperateorg  -- 同业归口管理部门
    ,approvecodeno  -- 批复编号(YYYY###,如20180001)
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
    ,replace(replace(t1.currenylist,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.currencymode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesstypelist,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.calculatemode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.useorglist,chr(13),''),chr(10),'')  -- 
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
    ,replace(replace(t1.creditbusiness,chr(13),''),chr(10),'')  -- 
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
    ,replace(replace(t1.describe1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operateorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operateuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pigeonholedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paycurrency,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paydate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag4,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fundsource,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operatetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.approvetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cycleflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.classifyresult,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.classifydate,chr(13),''),chr(10),'')  -- 
    ,t1.classifyfrequency  -- 
    ,replace(replace(t1.vouchnewflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.adjustratetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.adjustrateterm,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.rateadjustcyc,chr(13),''),chr(10),'')  -- 
    ,t1.fzanbalance  -- 
    ,replace(replace(t1.acceptinttype,chr(13),''),chr(10),'')  -- 
    ,t1.ratio  -- 
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
    ,t1.fixcyc  -- 
    ,replace(replace(t1.describe2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.approveopinion,chr(13),''),chr(10),'')  -- 最终审批意见
    ,replace(replace(t1.tempsaveflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.approvedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag5,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditcycle,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantyflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.effectflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditmode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.artificialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.returntype,chr(13),''),chr(10),'')  -- 
    ,t1.holdbalance  -- 
    ,replace(replace(t1.returnperiod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loantermflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mainreturntype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.schemeno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ltvvalue,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ratemode,chr(13),''),chr(10),'')  -- 
    ,t1.loanterm  -- 
    ,replace(replace(t1.otherpurpose,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.currency,chr(13),''),chr(10),'')  -- 
    ,t1.cguarantypeople  -- 
    ,replace(replace(t1.buyhousetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.buyhouseproperty,chr(13),''),chr(10),'')  -- 
    ,t1.houseareage  -- 
    ,t1.houseprice  -- 
    ,t1.housecount  -- 
    ,replace(replace(t1.paymentmode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fundserialno,chr(13),''),chr(10),'')  -- 
    ,t1.ctogetherborrower  -- 
    ,t1.csinglnassure  -- 
    ,t1.guarantyhouse  -- 
    ,t1.abysum  -- 
    ,replace(replace(t1.applyinsuranceflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sendchitflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ratecode,chr(13),''),chr(10),'')  -- 
    ,t1.calcterm  -- 
    ,replace(replace(t1.classifyresulteleven,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.reinforceflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.approveopinion1,chr(13),''),chr(10),'')  -- 最终审批意见2
    ,replace(replace(t1.accountno,chr(13),''),chr(10),'')  -- 签约帐号
    ,replace(replace(t1.maturity,chr(13),''),chr(10),'')  -- 签约到期日
    ,replace(replace(t1.istrans,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.carbrand,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cartype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.carnumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.chariotnumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.motornumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.rateopinion,chr(13),''),chr(10),'')  -- 客户评级
    ,replace(replace(t1.preeffectflag,chr(13),''),chr(10),'')  -- 变更前批复状态
    ,replace(replace(t1.iscontinueoversee,chr(13),''),chr(10),'')  -- 是否继续监测
    ,replace(replace(t1.buyhousedetail,chr(13),''),chr(10),'')  -- 购房细分：1-购一手房，2-购二手房，3-购其他类型住房，4-购商铺，5-购写字楼，6-购厂房，7-购其他商业用房
    ,replace(replace(t1.thirdparty1type,chr(13),''),chr(10),'')  -- 代付类型：1-买方押汇，2-打包放款，3-卖方押汇，4-国内信用证项下贴现
    ,replace(replace(t1.thirdorgname,chr(13),''),chr(10),'')  -- 代付行,承兑行
    ,replace(replace(t1.approveopinion6,chr(13),''),chr(10),'')  -- 审批意见续一
    ,replace(replace(t1.approveopinion7,chr(13),''),chr(10),'')  -- 审批意见续二
    ,replace(replace(t1.priattribute,chr(13),''),chr(10),'')  -- 低风险/类低风险业务类型
    ,replace(replace(t1.oldeffectflag,chr(13),''),chr(10),'')  -- 备份生效标志
    ,t1.availableothersum  -- 可用他用额度
    ,replace(replace(t1.isinuse,chr(13),''),chr(10),'')  -- 添加维护标志1正常2不维护
    ,replace(replace(t1.busirisktype,chr(13),''),chr(10),'')  -- 风险类型
    ,replace(replace(t1.playtype,chr(13),''),chr(10),'')  -- 参与方式
    ,replace(replace(t1.otherlimitno,chr(13),''),chr(10),'')  -- 他用额度编号
    ,replace(replace(t1.otherlimittype,chr(13),''),chr(10),'')  -- 他用额度类型
    ,replace(replace(t1.otherlimitownerid,chr(13),''),chr(10),'')  -- 他用额度所有人
    ,replace(replace(t1.zbxxm,chr(13),''),chr(10),'')  -- 主办行行名
    ,replace(replace(t1.cdxxm,chr(13),''),chr(10),'')  -- 参贷行行名
    ,replace(replace(t1.dlxxm,chr(13),''),chr(10),'')  -- 代理行行名
    ,replace(replace(t1.dlcdbz,chr(13),''),chr(10),'')  -- 代理参贷标志
    ,t1.sqdkze  -- 申请银团贷款总额
    ,replace(replace(t1.precreditcycle,chr(13),''),chr(10),'')  -- 变更前额度是否循环标志
    ,replace(replace(t1.fszqinput,chr(13),''),chr(10),'')  -- 买入返售债券专项额度手工登记 1-未完成 2-已完成
    ,replace(replace(t1.reinforcechecker,chr(13),''),chr(10),'')  -- 补登复核人
    ,t1.onlineamount  -- 线上额度
    ,t1.businesssumentpart  -- 集团授信额度公司部分
    ,t1.totalsumentpart  -- 集团授信敞口公司部分
    ,t1.businesssumtypart  -- 集团授信额度同业部分
    ,t1.totalsumtypart  -- 集团授信额度同业部分
    ,replace(replace(t1.hxtyapproveresult,chr(13),''),chr(10),'')  -- 终审结论(华兴同业使用):agree-同意、reject-否决、toContinue-待续议
    ,replace(replace(t1.investway,chr(13),''),chr(10),'')  -- 投资方式
    ,replace(replace(t1.investtarget,chr(13),''),chr(10),'')  -- 投资标的
    ,replace(replace(t1.publicorg,chr(13),''),chr(10),'')  -- 发行场所
    ,replace(replace(t1.creditflowtype,chr(13),''),chr(10),'')  -- 同业授信业务流程类型
    ,replace(replace(t1.isyeartocheck,chr(13),''),chr(10),'')  -- 是否年审（Code:YesNo）
    ,replace(replace(t1.sqcheckyeardate,chr(13),''),chr(10),'')  -- 上期年审日期
    ,replace(replace(t1.bqcheckyeardate,chr(13),''),chr(10),'')  -- 本期年审日期
    ,replace(replace(t1.checkyearstatus,chr(13),''),chr(10),'')  -- 年审进行状态(0或空 未进行  1进行中)
    ,replace(replace(t1.approveenddate,chr(13),''),chr(10),'')  -- 终审通过日期
    ,replace(replace(t1.creditarea,chr(13),''),chr(10),'')  -- 授信区域:01 本地 02 省内异地 03 省外异地
    ,replace(replace(t1.isestatefinance,chr(13),''),chr(10),'')  -- 是否涉及房地产融资
    ,replace(replace(t1.isgovernfinance,chr(13),''),chr(10),'')  -- 是否涉及政府类融资
    ,replace(replace(t1.isconsumerfinance,chr(13),''),chr(10),'')  -- 是否为消费服务类融资
    ,replace(replace(t1.isbeltroadfinance,chr(13),''),chr(10),'')  -- 是否为一带一路建设投融资
    ,replace(replace(t1.isgreenfinance,chr(13),''),chr(10),'')  -- 是否为绿色信贷融资
    ,replace(replace(t1.islikeloan,chr(13),''),chr(10),'')  -- 是否类信贷
    ,replace(replace(t1.reinforcetype,chr(13),''),chr(10),'')  -- 补登来源 dg-对公 空-同业
    ,replace(replace(t1.outclassifylevel,chr(13),''),chr(10),'')  -- 外部债项评级
    ,replace(replace(t1.outclassifyorg,chr(13),''),chr(10),'')  -- 评级机构
    ,replace(replace(t1.outclassifydate,chr(13),''),chr(10),'')  -- 评级日期
    ,replace(replace(t1.hxtyoperateorg,chr(13),''),chr(10),'')  -- 同业归口管理部门
    ,replace(replace(t1.approvecodeno,chr(13),''),chr(10),'')  -- 批复编号(YYYY###,如20180001)
    ,t1.start_dt  -- 
    ,t1.end_dt  -- 
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.crss_business_approve t1    --业务批准信息
where t1.start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_crss_business_approve',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);