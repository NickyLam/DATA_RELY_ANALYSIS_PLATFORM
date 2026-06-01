/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_crss_business_duebill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.oass_crss_business_duebill
whenever sqlerror continue none;
drop table ${idl_schema}.oass_crss_business_duebill purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.oass_crss_business_duebill(
    etl_dt date -- 数据日期
    ,serialno varchar2(40) -- 
    ,relativeserialno1 varchar2(40) -- 
    ,relativeserialno2 varchar2(40) -- 
    ,subjectno varchar2(20) -- 
    ,mfcustomerid varchar2(40) -- 
    ,customerid varchar2(40) -- 
    ,customername varchar2(80) -- 
    ,businesstype varchar2(18) -- 
    ,businesssubtype varchar2(20) -- 
    ,businessstatus varchar2(20) -- 
    ,businesscurrency varchar2(20) -- 
    ,businesssum number(24,6) -- 
    ,putoutdate varchar2(10) -- 
    ,maturity varchar2(10) -- 
    ,actualmaturity varchar2(10) -- 
    ,businessrate number(24,10) -- 
    ,actualbusinessrate number(10,6) -- 
    ,ictype varchar2(20) -- 
    ,iccyc varchar2(20) -- 
    ,paytimes number -- 
    ,paycyc varchar2(20) -- 
    ,corpuspaymethod varchar2(20) -- 
    ,extendtimes number -- 
    ,reorgtimes number -- 
    ,renewtimes number -- 
    ,golntimes number -- 
    ,balance number(24,6) -- 
    ,normalbalance number(24,6) -- 
    ,overduebalance number(24,6) -- 
    ,dullbalance number(24,6) -- 
    ,badbalance number(24,6) -- 
    ,interestbalance1 number(24,6) -- 
    ,interestbalance2 number(24,6) -- 
    ,finebalance1 number(24,6) -- 
    ,finebalance2 number(24,6) -- 
    ,receivebalance number(24,6) -- 
    ,payedbalance number(24,6) -- 
    ,overduedays number -- 
    ,payaccount varchar2(40) -- 
    ,putoutaccount varchar2(40) -- 
    ,paybackaccount varchar2(40) -- 
    ,payinterestaccount varchar2(40) -- 
    ,oweinterestdays number -- 
    ,tabalance number(24,6) -- 
    ,tainterestbalance number(24,6) -- 
    ,tatimes number(24,6) -- 
    ,lcatimes number(24,6) -- 
    ,saledate varchar2(10) -- 
    ,finishtype varchar2(20) -- 
    ,finishdate varchar2(10) -- 
    ,mfareaid varchar2(20) -- 
    ,mforgid varchar2(20) -- 
    ,mfuserid varchar2(20) -- 
    ,operateorgid varchar2(20) -- 
    ,operateuserid varchar2(20) -- 
    ,inputorgid varchar2(20) -- 
    ,inputuserid varchar2(20) -- 
    ,inputdate varchar2(10) -- 
    ,updatedate varchar2(10) -- 
    ,inoutflag varchar2(40) -- 
    ,dealflag varchar2(1) -- 
    ,occurdate varchar2(10) -- 
    ,businessprop number(10,6) -- 
    ,benefitcorp varchar2(40) -- 
    ,actualtermmonth number -- 
    ,actualtermday number -- 
    ,baseratetype varchar2(20) -- 
    ,baserate number(24,6) -- 
    ,ratefloattype varchar2(20) -- 
    ,ratefloat number(24,6) -- 
    ,timsflag varchar2(40) -- 
    ,bailratio number(10,6) -- 
    ,logoutdate varchar2(10) -- 
    ,cancellogoutdate varchar2(10) -- 
    ,bailsum number(24,6) -- 
    ,bailaccount varchar2(40) -- 
    ,purpose varchar2(200) -- 
    ,advanceflag varchar2(20) -- 
    ,relativeduebillno varchar2(40) -- 
    ,actualartificialno varchar2(40) -- 
    ,accountno varchar2(40) -- 
    ,loanaccountno varchar2(40) -- 
    ,secondpayaccount varchar2(40) -- 
    ,adjustratetype varchar2(20) -- 
    ,adjustrateterm varchar2(20) -- 
    ,overinttype varchar2(20) -- 
    ,rateadjustcyc varchar2(20) -- 
    ,pdgaccountno varchar2(40) -- 
    ,deductdate varchar2(10) -- 
    ,fzanbalance number(24,6) -- 
    ,acceptinttype varchar2(20) -- 
    ,ratio number(24,6) -- 
    ,thirdpartyadd1 varchar2(80) -- 
    ,thirdpartyzip1 varchar2(40) -- 
    ,thirdpartyadd2 varchar2(80) -- 
    ,thirdpartyzip2 varchar2(40) -- 
    ,termdate1 varchar2(10) -- 
    ,termdate2 varchar2(10) -- 
    ,termdate3 varchar2(10) -- 
    ,describe2 varchar2(200) -- 
    ,fixcyc number -- 
    ,thirdparty1 varchar2(200) -- 
    ,thirdpartyid1 varchar2(40) -- 
    ,thirdparty2 varchar2(200) -- 
    ,thirdparty3 varchar2(200) -- 
    ,type1 varchar2(20) -- 
    ,type2 varchar2(20) -- 
    ,type3 varchar2(20) -- 
    ,billno varchar2(40) -- 
    ,flag1 varchar2(20) -- 
    ,flag2 varchar2(20) -- 
    ,flag3 varchar2(20) -- 
    ,thirdpartyregion varchar2(20) -- 
    ,thirdpartyaccounts varchar2(40) -- 
    ,cargoinfo varchar2(80) -- 
    ,securitiestype varchar2(20) -- 
    ,securitiesregion varchar2(20) -- 
    ,aboutbankid2 varchar2(40) -- 
    ,aboutbankname2 varchar2(80) -- 
    ,aboutbankid3 varchar2(40) -- 
    ,aboutbankname varchar2(80) -- 
    ,aboutbankid varchar2(40) -- 
    ,oldlctermtype varchar2(20) -- 
    ,negotiateno varchar2(40) -- 
    ,creditkind varchar2(20) -- 
    ,gatheringname varchar2(80) -- 
    ,preinttype varchar2(20) -- 
    ,resumeinttype varchar2(20) -- 
    ,guarantyno varchar2(40) -- 
    ,pztype varchar2(20) -- 
    ,graceperiod number -- 
    ,oldlcvaliddate varchar2(10) -- 
    ,mfeepaymethod varchar2(20) -- 
    ,describe1 varchar2(200) -- 
    ,tradecontractno varchar2(40) -- 
    ,loantype varchar2(20) -- 
    ,fixterm number(24,6) -- 
    ,cancelsum number(24,6) -- 
    ,cancelinterest number(24,6) -- 
    ,bailacount varchar2(40) -- 
    ,classify4 varchar2(18) -- 
    ,classifyresult varchar2(18) -- 
    ,returntype varchar2(18) -- 
    ,bailpercent number(10,6) -- 
    ,paymenttype varchar2(18) -- 
    ,termsfreq varchar2(18) -- 
    ,overduedate varchar2(10) -- 
    ,oweinterestdate varchar2(10) -- 
    ,lcstatus varchar2(18) -- 
    ,ichangedate varchar2(10) -- 
    ,vouchtype varchar2(10) -- 
    ,actualbusinessratefix number(10,6) -- 
    ,lastclassifyresult varchar2(10) -- 
    ,classifyresulteleven varchar2(10) -- 
    ,guaranteeno varchar2(10) -- 
    ,surplusphases number(24,6) -- 
    ,eacmprincipal number(24,6) -- 
    ,overduerate number(11,7) -- 
    ,mainorgid varchar2(20) -- 
    ,loanspecies varchar2(5) -- 
    ,advanceflagsum number(24,6) -- 受益人
    ,advanceflagno varchar2(40) -- 
    ,compensationsum number(24,6) -- 
    ,logouttype varchar2(2) -- 
    ,logoutno varchar2(32) -- 
    ,openno varchar2(32) -- 
    ,opendate varchar2(18) -- 
    ,premiumrate number(24,6) -- 
    ,benefitcorpbank varchar2(80) -- 
    ,benefitcorpname varchar2(80) -- 
    ,overdueinterest number(24,6) -- 
    ,fixflag varchar2(1) -- 补登借据标志
    ,intdate varchar2(10) -- 下一结息日
    ,accountbalance number(24,6) -- 还款账号余额
    ,accountuserbalance number(24,6) -- 还款账户可用余额
    ,termtype varchar2(10) -- 期限类型(短期、中长期)
    ,termmonthtype varchar2(10) -- 期限分段(三个月以内、三个月至六个月、六个月至一年、一年至两年、两年至三年、三年至五年、五年至十年、十年以上)
    ,insum number(24,6) -- 累计归还本金
    ,interestinsum number(24,6) -- 累计归还利息
    ,classifydate varchar2(10) -- 
    ,nextperiodreturnprincipaldate varchar2(10) -- 下一期还本日期
    ,nextperiodreturnprincipalsum number(24,6) -- 下一期还本金额
    ,nextperiodreturninterestdate varchar2(10) -- 下一期还息日期
    ,nextperiodreturninterestsum number(24,6) -- 下一期还息金额
    ,duebalance number(24,6) -- 暂存借据余额
    ,balancechangedate varchar2(10) -- 借据余额变化日期
    ,oldictype varchar2(2) -- 原还款方式代码
    ,isinuse varchar2(1) -- 添加维护标志1正常2不维护
    ,dzhxstatus varchar2(2) -- 呆账核销状态 1-待核销 2-已核销
    ,hxtype varchar2(5) -- 核销类别 码值(DZHXType)
    ,hxinrate number(24,6) -- 核销表内利息
    ,hxoutrate number(24,6) -- 核销表外利息
    ,legal number(24,6) -- 诉讼费
    ,reinforcechecker varchar2(10) -- 补登复核人
    ,batchno varchar2(40) -- 批量新增借据关键字段
    ,tcustomerid varchar2(40) -- 资金交易系统实际融资人客户编号
    ,tcustomername varchar2(200) -- 资金交易系统实际融资人客户名称
    ,transdate varchar2(10) -- 同业综合业务系统交易日期
    ,billtype varchar2(10) -- 票据类型
    ,billkind varchar2(10) -- 票据种类
    ,datatype varchar2(10) -- 批量数据来源（PJ.票据系统供数 LC.理财资管系统供数 ZJ.资金系统供数 ZH.同业综合业务系统供数）
    ,acceptbankid varchar2(100) -- 承兑行行号
    ,acceptbankname varchar2(200) -- 承兑行行名
    ,keyno varchar2(40) -- 票据唯一标识
    ,istran varchar2(16) -- 
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
grant select on ${idl_schema}.oass_crss_business_duebill to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_crss_business_duebill is '业务借据(账户)信息';
comment on column ${idl_schema}.oass_crss_business_duebill.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_crss_business_duebill.serialno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.relativeserialno1 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.relativeserialno2 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.subjectno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.mfcustomerid is '';
comment on column ${idl_schema}.oass_crss_business_duebill.customerid is '';
comment on column ${idl_schema}.oass_crss_business_duebill.customername is '';
comment on column ${idl_schema}.oass_crss_business_duebill.businesstype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.businesssubtype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.businessstatus is '';
comment on column ${idl_schema}.oass_crss_business_duebill.businesscurrency is '';
comment on column ${idl_schema}.oass_crss_business_duebill.businesssum is '';
comment on column ${idl_schema}.oass_crss_business_duebill.putoutdate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.maturity is '';
comment on column ${idl_schema}.oass_crss_business_duebill.actualmaturity is '';
comment on column ${idl_schema}.oass_crss_business_duebill.businessrate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.actualbusinessrate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.ictype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.iccyc is '';
comment on column ${idl_schema}.oass_crss_business_duebill.paytimes is '';
comment on column ${idl_schema}.oass_crss_business_duebill.paycyc is '';
comment on column ${idl_schema}.oass_crss_business_duebill.corpuspaymethod is '';
comment on column ${idl_schema}.oass_crss_business_duebill.extendtimes is '';
comment on column ${idl_schema}.oass_crss_business_duebill.reorgtimes is '';
comment on column ${idl_schema}.oass_crss_business_duebill.renewtimes is '';
comment on column ${idl_schema}.oass_crss_business_duebill.golntimes is '';
comment on column ${idl_schema}.oass_crss_business_duebill.balance is '';
comment on column ${idl_schema}.oass_crss_business_duebill.normalbalance is '';
comment on column ${idl_schema}.oass_crss_business_duebill.overduebalance is '';
comment on column ${idl_schema}.oass_crss_business_duebill.dullbalance is '';
comment on column ${idl_schema}.oass_crss_business_duebill.badbalance is '';
comment on column ${idl_schema}.oass_crss_business_duebill.interestbalance1 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.interestbalance2 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.finebalance1 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.finebalance2 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.receivebalance is '';
comment on column ${idl_schema}.oass_crss_business_duebill.payedbalance is '';
comment on column ${idl_schema}.oass_crss_business_duebill.overduedays is '';
comment on column ${idl_schema}.oass_crss_business_duebill.payaccount is '';
comment on column ${idl_schema}.oass_crss_business_duebill.putoutaccount is '';
comment on column ${idl_schema}.oass_crss_business_duebill.paybackaccount is '';
comment on column ${idl_schema}.oass_crss_business_duebill.payinterestaccount is '';
comment on column ${idl_schema}.oass_crss_business_duebill.oweinterestdays is '';
comment on column ${idl_schema}.oass_crss_business_duebill.tabalance is '';
comment on column ${idl_schema}.oass_crss_business_duebill.tainterestbalance is '';
comment on column ${idl_schema}.oass_crss_business_duebill.tatimes is '';
comment on column ${idl_schema}.oass_crss_business_duebill.lcatimes is '';
comment on column ${idl_schema}.oass_crss_business_duebill.saledate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.finishtype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.finishdate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.mfareaid is '';
comment on column ${idl_schema}.oass_crss_business_duebill.mforgid is '';
comment on column ${idl_schema}.oass_crss_business_duebill.mfuserid is '';
comment on column ${idl_schema}.oass_crss_business_duebill.operateorgid is '';
comment on column ${idl_schema}.oass_crss_business_duebill.operateuserid is '';
comment on column ${idl_schema}.oass_crss_business_duebill.inputorgid is '';
comment on column ${idl_schema}.oass_crss_business_duebill.inputuserid is '';
comment on column ${idl_schema}.oass_crss_business_duebill.inputdate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.updatedate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.inoutflag is '';
comment on column ${idl_schema}.oass_crss_business_duebill.dealflag is '';
comment on column ${idl_schema}.oass_crss_business_duebill.occurdate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.businessprop is '';
comment on column ${idl_schema}.oass_crss_business_duebill.benefitcorp is '';
comment on column ${idl_schema}.oass_crss_business_duebill.actualtermmonth is '';
comment on column ${idl_schema}.oass_crss_business_duebill.actualtermday is '';
comment on column ${idl_schema}.oass_crss_business_duebill.baseratetype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.baserate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.ratefloattype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.ratefloat is '';
comment on column ${idl_schema}.oass_crss_business_duebill.timsflag is '';
comment on column ${idl_schema}.oass_crss_business_duebill.bailratio is '';
comment on column ${idl_schema}.oass_crss_business_duebill.logoutdate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.cancellogoutdate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.bailsum is '';
comment on column ${idl_schema}.oass_crss_business_duebill.bailaccount is '';
comment on column ${idl_schema}.oass_crss_business_duebill.purpose is '';
comment on column ${idl_schema}.oass_crss_business_duebill.advanceflag is '';
comment on column ${idl_schema}.oass_crss_business_duebill.relativeduebillno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.actualartificialno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.accountno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.loanaccountno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.secondpayaccount is '';
comment on column ${idl_schema}.oass_crss_business_duebill.adjustratetype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.adjustrateterm is '';
comment on column ${idl_schema}.oass_crss_business_duebill.overinttype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.rateadjustcyc is '';
comment on column ${idl_schema}.oass_crss_business_duebill.pdgaccountno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.deductdate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.fzanbalance is '';
comment on column ${idl_schema}.oass_crss_business_duebill.acceptinttype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.ratio is '';
comment on column ${idl_schema}.oass_crss_business_duebill.thirdpartyadd1 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.thirdpartyzip1 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.thirdpartyadd2 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.thirdpartyzip2 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.termdate1 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.termdate2 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.termdate3 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.describe2 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.fixcyc is '';
comment on column ${idl_schema}.oass_crss_business_duebill.thirdparty1 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.thirdpartyid1 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.thirdparty2 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.thirdparty3 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.type1 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.type2 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.type3 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.billno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.flag1 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.flag2 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.flag3 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.thirdpartyregion is '';
comment on column ${idl_schema}.oass_crss_business_duebill.thirdpartyaccounts is '';
comment on column ${idl_schema}.oass_crss_business_duebill.cargoinfo is '';
comment on column ${idl_schema}.oass_crss_business_duebill.securitiestype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.securitiesregion is '';
comment on column ${idl_schema}.oass_crss_business_duebill.aboutbankid2 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.aboutbankname2 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.aboutbankid3 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.aboutbankname is '';
comment on column ${idl_schema}.oass_crss_business_duebill.aboutbankid is '';
comment on column ${idl_schema}.oass_crss_business_duebill.oldlctermtype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.negotiateno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.creditkind is '';
comment on column ${idl_schema}.oass_crss_business_duebill.gatheringname is '';
comment on column ${idl_schema}.oass_crss_business_duebill.preinttype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.resumeinttype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.guarantyno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.pztype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.graceperiod is '';
comment on column ${idl_schema}.oass_crss_business_duebill.oldlcvaliddate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.mfeepaymethod is '';
comment on column ${idl_schema}.oass_crss_business_duebill.describe1 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.tradecontractno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.loantype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.fixterm is '';
comment on column ${idl_schema}.oass_crss_business_duebill.cancelsum is '';
comment on column ${idl_schema}.oass_crss_business_duebill.cancelinterest is '';
comment on column ${idl_schema}.oass_crss_business_duebill.bailacount is '';
comment on column ${idl_schema}.oass_crss_business_duebill.classify4 is '';
comment on column ${idl_schema}.oass_crss_business_duebill.classifyresult is '';
comment on column ${idl_schema}.oass_crss_business_duebill.returntype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.bailpercent is '';
comment on column ${idl_schema}.oass_crss_business_duebill.paymenttype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.termsfreq is '';
comment on column ${idl_schema}.oass_crss_business_duebill.overduedate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.oweinterestdate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.lcstatus is '';
comment on column ${idl_schema}.oass_crss_business_duebill.ichangedate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.vouchtype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.actualbusinessratefix is '';
comment on column ${idl_schema}.oass_crss_business_duebill.lastclassifyresult is '';
comment on column ${idl_schema}.oass_crss_business_duebill.classifyresulteleven is '';
comment on column ${idl_schema}.oass_crss_business_duebill.guaranteeno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.surplusphases is '';
comment on column ${idl_schema}.oass_crss_business_duebill.eacmprincipal is '';
comment on column ${idl_schema}.oass_crss_business_duebill.overduerate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.mainorgid is '';
comment on column ${idl_schema}.oass_crss_business_duebill.loanspecies is '';
comment on column ${idl_schema}.oass_crss_business_duebill.advanceflagsum is '受益人';
comment on column ${idl_schema}.oass_crss_business_duebill.advanceflagno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.compensationsum is '';
comment on column ${idl_schema}.oass_crss_business_duebill.logouttype is '';
comment on column ${idl_schema}.oass_crss_business_duebill.logoutno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.openno is '';
comment on column ${idl_schema}.oass_crss_business_duebill.opendate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.premiumrate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.benefitcorpbank is '';
comment on column ${idl_schema}.oass_crss_business_duebill.benefitcorpname is '';
comment on column ${idl_schema}.oass_crss_business_duebill.overdueinterest is '';
comment on column ${idl_schema}.oass_crss_business_duebill.fixflag is '补登借据标志';
comment on column ${idl_schema}.oass_crss_business_duebill.intdate is '下一结息日';
comment on column ${idl_schema}.oass_crss_business_duebill.accountbalance is '还款账号余额';
comment on column ${idl_schema}.oass_crss_business_duebill.accountuserbalance is '还款账户可用余额';
comment on column ${idl_schema}.oass_crss_business_duebill.termtype is '期限类型(短期、中长期)';
comment on column ${idl_schema}.oass_crss_business_duebill.termmonthtype is '期限分段(三个月以内、三个月至六个月、六个月至一年、一年至两年、两年至三年、三年至五年、五年至十年、十年以上)';
comment on column ${idl_schema}.oass_crss_business_duebill.insum is '累计归还本金';
comment on column ${idl_schema}.oass_crss_business_duebill.interestinsum is '累计归还利息';
comment on column ${idl_schema}.oass_crss_business_duebill.classifydate is '';
comment on column ${idl_schema}.oass_crss_business_duebill.nextperiodreturnprincipaldate is '下一期还本日期';
comment on column ${idl_schema}.oass_crss_business_duebill.nextperiodreturnprincipalsum is '下一期还本金额';
comment on column ${idl_schema}.oass_crss_business_duebill.nextperiodreturninterestdate is '下一期还息日期';
comment on column ${idl_schema}.oass_crss_business_duebill.nextperiodreturninterestsum is '下一期还息金额';
comment on column ${idl_schema}.oass_crss_business_duebill.duebalance is '暂存借据余额';
comment on column ${idl_schema}.oass_crss_business_duebill.balancechangedate is '借据余额变化日期';
comment on column ${idl_schema}.oass_crss_business_duebill.oldictype is '原还款方式代码';
comment on column ${idl_schema}.oass_crss_business_duebill.isinuse is '添加维护标志1正常2不维护';
comment on column ${idl_schema}.oass_crss_business_duebill.dzhxstatus is '呆账核销状态 1-待核销 2-已核销';
comment on column ${idl_schema}.oass_crss_business_duebill.hxtype is '核销类别 码值(DZHXType)';
comment on column ${idl_schema}.oass_crss_business_duebill.hxinrate is '核销表内利息';
comment on column ${idl_schema}.oass_crss_business_duebill.hxoutrate is '核销表外利息';
comment on column ${idl_schema}.oass_crss_business_duebill.legal is '诉讼费';
comment on column ${idl_schema}.oass_crss_business_duebill.reinforcechecker is '补登复核人';
comment on column ${idl_schema}.oass_crss_business_duebill.batchno is '批量新增借据关键字段';
comment on column ${idl_schema}.oass_crss_business_duebill.tcustomerid is '资金交易系统实际融资人客户编号';
comment on column ${idl_schema}.oass_crss_business_duebill.tcustomername is '资金交易系统实际融资人客户名称';
comment on column ${idl_schema}.oass_crss_business_duebill.transdate is '同业综合业务系统交易日期';
comment on column ${idl_schema}.oass_crss_business_duebill.billtype is '票据类型';
comment on column ${idl_schema}.oass_crss_business_duebill.billkind is '票据种类';
comment on column ${idl_schema}.oass_crss_business_duebill.datatype is '批量数据来源（PJ.票据系统供数 LC.理财资管系统供数 ZJ.资金系统供数 ZH.同业综合业务系统供数）';
comment on column ${idl_schema}.oass_crss_business_duebill.acceptbankid is '承兑行行号';
comment on column ${idl_schema}.oass_crss_business_duebill.acceptbankname is '承兑行行名';
comment on column ${idl_schema}.oass_crss_business_duebill.keyno is '票据唯一标识';
comment on column ${idl_schema}.oass_crss_business_duebill.istran is '';
comment on column ${idl_schema}.oass_crss_business_duebill.start_dt is '';
comment on column ${idl_schema}.oass_crss_business_duebill.end_dt is '';
comment on column ${idl_schema}.oass_crss_business_duebill.id_mark is '';
comment on column ${idl_schema}.oass_crss_business_duebill.etl_timestamp is '';
