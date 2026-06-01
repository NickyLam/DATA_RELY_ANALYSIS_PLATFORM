/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_crss_business_duebill
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
alter table ${idl_schema}.oass_crss_business_duebill drop partition p_${retain_week};
alter table ${idl_schema}.oass_crss_business_duebill drop partition p_${batch_date};


-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_crss_business_duebill add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_crss_business_duebill (
    etl_dt  -- 数据日期
    ,serialno  -- 
    ,relativeserialno1  -- 
    ,relativeserialno2  -- 
    ,subjectno  -- 
    ,mfcustomerid  -- 
    ,customerid  -- 
    ,customername  -- 
    ,businesstype  -- 
    ,businesssubtype  -- 
    ,businessstatus  -- 
    ,businesscurrency  -- 
    ,businesssum  -- 
    ,putoutdate  -- 
    ,maturity  -- 
    ,actualmaturity  -- 
    ,businessrate  -- 
    ,actualbusinessrate  -- 
    ,ictype  -- 
    ,iccyc  -- 
    ,paytimes  -- 
    ,paycyc  -- 
    ,corpuspaymethod  -- 
    ,extendtimes  -- 
    ,reorgtimes  -- 
    ,renewtimes  -- 
    ,golntimes  -- 
    ,balance  -- 
    ,normalbalance  -- 
    ,overduebalance  -- 
    ,dullbalance  -- 
    ,badbalance  -- 
    ,interestbalance1  -- 
    ,interestbalance2  -- 
    ,finebalance1  -- 
    ,finebalance2  -- 
    ,receivebalance  -- 
    ,payedbalance  -- 
    ,overduedays  -- 
    ,payaccount  -- 
    ,putoutaccount  -- 
    ,paybackaccount  -- 
    ,payinterestaccount  -- 
    ,oweinterestdays  -- 
    ,tabalance  -- 
    ,tainterestbalance  -- 
    ,tatimes  -- 
    ,lcatimes  -- 
    ,saledate  -- 
    ,finishtype  -- 
    ,finishdate  -- 
    ,mfareaid  -- 
    ,mforgid  -- 
    ,mfuserid  -- 
    ,operateorgid  -- 
    ,operateuserid  -- 
    ,inputorgid  -- 
    ,inputuserid  -- 
    ,inputdate  -- 
    ,updatedate  -- 
    ,inoutflag  -- 
    ,dealflag  -- 
    ,occurdate  -- 
    ,businessprop  -- 
    ,benefitcorp  -- 
    ,actualtermmonth  -- 
    ,actualtermday  -- 
    ,baseratetype  -- 
    ,baserate  -- 
    ,ratefloattype  -- 
    ,ratefloat  -- 
    ,timsflag  -- 
    ,bailratio  -- 
    ,logoutdate  -- 
    ,cancellogoutdate  -- 
    ,bailsum  -- 
    ,bailaccount  -- 
    ,purpose  -- 
    ,advanceflag  -- 
    ,relativeduebillno  -- 
    ,actualartificialno  -- 
    ,accountno  -- 
    ,loanaccountno  -- 
    ,secondpayaccount  -- 
    ,adjustratetype  -- 
    ,adjustrateterm  -- 
    ,overinttype  -- 
    ,rateadjustcyc  -- 
    ,pdgaccountno  -- 
    ,deductdate  -- 
    ,fzanbalance  -- 
    ,acceptinttype  -- 
    ,ratio  -- 
    ,thirdpartyadd1  -- 
    ,thirdpartyzip1  -- 
    ,thirdpartyadd2  -- 
    ,thirdpartyzip2  -- 
    ,termdate1  -- 
    ,termdate2  -- 
    ,termdate3  -- 
    ,describe2  -- 
    ,fixcyc  -- 
    ,thirdparty1  -- 
    ,thirdpartyid1  -- 
    ,thirdparty2  -- 
    ,thirdparty3  -- 
    ,type1  -- 
    ,type2  -- 
    ,type3  -- 
    ,billno  -- 
    ,flag1  -- 
    ,flag2  -- 
    ,flag3  -- 
    ,thirdpartyregion  -- 
    ,thirdpartyaccounts  -- 
    ,cargoinfo  -- 
    ,securitiestype  -- 
    ,securitiesregion  -- 
    ,aboutbankid2  -- 
    ,aboutbankname2  -- 
    ,aboutbankid3  -- 
    ,aboutbankname  -- 
    ,aboutbankid  -- 
    ,oldlctermtype  -- 
    ,negotiateno  -- 
    ,creditkind  -- 
    ,gatheringname  -- 
    ,preinttype  -- 
    ,resumeinttype  -- 
    ,guarantyno  -- 
    ,pztype  -- 
    ,graceperiod  -- 
    ,oldlcvaliddate  -- 
    ,mfeepaymethod  -- 
    ,describe1  -- 
    ,tradecontractno  -- 
    ,loantype  -- 
    ,fixterm  -- 
    ,cancelsum  -- 
    ,cancelinterest  -- 
    ,bailacount  -- 
    ,classify4  -- 
    ,classifyresult  -- 
    ,returntype  -- 
    ,bailpercent  -- 
    ,paymenttype  -- 
    ,termsfreq  -- 
    ,overduedate  -- 
    ,oweinterestdate  -- 
    ,lcstatus  -- 
    ,ichangedate  -- 
    ,vouchtype  -- 
    ,actualbusinessratefix  -- 
    ,lastclassifyresult  -- 
    ,classifyresulteleven  -- 
    ,guaranteeno  -- 
    ,surplusphases  -- 
    ,eacmprincipal  -- 
    ,overduerate  -- 
    ,mainorgid  -- 
    ,loanspecies  -- 
    ,advanceflagsum  -- 受益人
    ,advanceflagno  -- 
    ,compensationsum  -- 
    ,logouttype  -- 
    ,logoutno  -- 
    ,openno  -- 
    ,opendate  -- 
    ,premiumrate  -- 
    ,benefitcorpbank  -- 
    ,benefitcorpname  -- 
    ,overdueinterest  -- 
    ,fixflag  -- 补登借据标志
    ,intdate  -- 下一结息日
    ,accountbalance  -- 还款账号余额
    ,accountuserbalance  -- 还款账户可用余额
    ,termtype  -- 期限类型(短期、中长期)
    ,termmonthtype  -- 期限分段(三个月以内、三个月至六个月、六个月至一年、一年至两年、两年至三年、三年至五年、五年至十年、十年以上)
    ,insum  -- 累计归还本金
    ,interestinsum  -- 累计归还利息
    ,classifydate  -- 
    ,nextperiodreturnprincipaldate  -- 下一期还本日期
    ,nextperiodreturnprincipalsum  -- 下一期还本金额
    ,nextperiodreturninterestdate  -- 下一期还息日期
    ,nextperiodreturninterestsum  -- 下一期还息金额
    ,duebalance  -- 暂存借据余额
    ,balancechangedate  -- 借据余额变化日期
    ,oldictype  -- 原还款方式代码
    ,isinuse  -- 添加维护标志1正常2不维护
    ,dzhxstatus  -- 呆账核销状态 1-待核销 2-已核销
    ,hxtype  -- 核销类别 码值(DZHXType)
    ,hxinrate  -- 核销表内利息
    ,hxoutrate  -- 核销表外利息
    ,legal  -- 诉讼费
    ,reinforcechecker  -- 补登复核人
    ,batchno  -- 批量新增借据关键字段
    ,tcustomerid  -- 资金交易系统实际融资人客户编号
    ,tcustomername  -- 资金交易系统实际融资人客户名称
    ,transdate  -- 同业综合业务系统交易日期
    ,billtype  -- 票据类型
    ,billkind  -- 票据种类
    ,datatype  -- 批量数据来源（PJ.票据系统供数 LC.理财资管系统供数 ZJ.资金系统供数 ZH.同业综合业务系统供数）
    ,acceptbankid  -- 承兑行行号
    ,acceptbankname  -- 承兑行行名
    ,keyno  -- 票据唯一标识
    ,istran  -- 票据唯一标识
    ,start_dt  -- 
    ,end_dt  -- 
    ,id_mark  -- 
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.serialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.relativeserialno1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.relativeserialno2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.subjectno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mfcustomerid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.customerid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.customername,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesstype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesssubtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businessstatus,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'')  -- 
    ,t1.businesssum  -- 
    ,replace(replace(t1.putoutdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.maturity,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.actualmaturity,chr(13),''),chr(10),'')  -- 
    ,t1.businessrate  -- 
    ,t1.actualbusinessrate  -- 
    ,replace(replace(t1.ictype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.iccyc,chr(13),''),chr(10),'')  -- 
    ,t1.paytimes  -- 
    ,replace(replace(t1.paycyc,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.corpuspaymethod,chr(13),''),chr(10),'')  -- 
    ,t1.extendtimes  -- 
    ,t1.reorgtimes  -- 
    ,t1.renewtimes  -- 
    ,t1.golntimes  -- 
    ,t1.balance  -- 
    ,t1.normalbalance  -- 
    ,t1.overduebalance  -- 
    ,t1.dullbalance  -- 
    ,t1.badbalance  -- 
    ,t1.interestbalance1  -- 
    ,t1.interestbalance2  -- 
    ,t1.finebalance1  -- 
    ,t1.finebalance2  -- 
    ,t1.receivebalance  -- 
    ,t1.payedbalance  -- 
    ,t1.overduedays  -- 
    ,replace(replace(t1.payaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.putoutaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paybackaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.payinterestaccount,chr(13),''),chr(10),'')  -- 
    ,t1.oweinterestdays  -- 
    ,t1.tabalance  -- 
    ,t1.tainterestbalance  -- 
    ,t1.tatimes  -- 
    ,t1.lcatimes  -- 
    ,replace(replace(t1.saledate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.finishtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.finishdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mfareaid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mforgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mfuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operateorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operateuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inoutflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.dealflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.occurdate,chr(13),''),chr(10),'')  -- 
    ,t1.businessprop  -- 
    ,replace(replace(t1.benefitcorp,chr(13),''),chr(10),'')  -- 
    ,t1.actualtermmonth  -- 
    ,t1.actualtermday  -- 
    ,replace(replace(t1.baseratetype,chr(13),''),chr(10),'')  -- 
    ,t1.baserate  -- 
    ,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'')  -- 
    ,t1.ratefloat  -- 
    ,replace(replace(t1.timsflag,chr(13),''),chr(10),'')  -- 
    ,t1.bailratio  -- 
    ,replace(replace(t1.logoutdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cancellogoutdate,chr(13),''),chr(10),'')  -- 
    ,t1.bailsum  -- 
    ,replace(replace(t1.bailaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.purpose,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.advanceflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.relativeduebillno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.actualartificialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.accountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loanaccountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.secondpayaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.adjustratetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.adjustrateterm,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.overinttype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.rateadjustcyc,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pdgaccountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.deductdate,chr(13),''),chr(10),'')  -- 
    ,t1.fzanbalance  -- 
    ,replace(replace(t1.acceptinttype,chr(13),''),chr(10),'')  -- 
    ,t1.ratio  -- 
    ,replace(replace(t1.thirdpartyadd1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyzip1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyadd2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyzip2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.termdate1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.termdate2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.termdate3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.describe2,chr(13),''),chr(10),'')  -- 
    ,t1.fixcyc  -- 
    ,replace(replace(t1.thirdparty1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyid1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdparty2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdparty3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.type1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.type2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.type3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.billno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyregion,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyaccounts,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cargoinfo,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.securitiestype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.securitiesregion,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutbankid2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutbankname2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutbankid3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutbankname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutbankid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.oldlctermtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.negotiateno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditkind,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.gatheringname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.preinttype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.resumeinttype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantyno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pztype,chr(13),''),chr(10),'')  -- 
    ,t1.graceperiod  -- 
    ,replace(replace(t1.oldlcvaliddate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mfeepaymethod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.describe1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.tradecontractno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loantype,chr(13),''),chr(10),'')  -- 
    ,t1.fixterm  -- 
    ,t1.cancelsum  -- 
    ,t1.cancelinterest  -- 
    ,replace(replace(t1.bailacount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.classify4,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.classifyresult,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.returntype,chr(13),''),chr(10),'')  -- 
    ,t1.bailpercent  -- 
    ,replace(replace(t1.paymenttype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.termsfreq,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.overduedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.oweinterestdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.lcstatus,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ichangedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vouchtype,chr(13),''),chr(10),'')  -- 
    ,t1.actualbusinessratefix  -- 
    ,replace(replace(t1.lastclassifyresult,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.classifyresulteleven,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guaranteeno,chr(13),''),chr(10),'')  -- 
    ,t1.surplusphases  -- 
    ,t1.eacmprincipal  -- 
    ,t1.overduerate  -- 
    ,replace(replace(t1.mainorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loanspecies,chr(13),''),chr(10),'')  -- 
    ,t1.advanceflagsum  -- 受益人
    ,replace(replace(t1.advanceflagno,chr(13),''),chr(10),'')  -- 
    ,t1.compensationsum  -- 
    ,replace(replace(t1.logouttype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.logoutno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.openno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.opendate,chr(13),''),chr(10),'')  -- 
    ,t1.premiumrate  -- 
    ,replace(replace(t1.benefitcorpbank,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.benefitcorpname,chr(13),''),chr(10),'')  -- 
    ,t1.overdueinterest  -- 
    ,replace(replace(t1.fixflag,chr(13),''),chr(10),'')  -- 补登借据标志
    ,replace(replace(t1.intdate,chr(13),''),chr(10),'')  -- 下一结息日
    ,t1.accountbalance  -- 还款账号余额
    ,t1.accountuserbalance  -- 还款账户可用余额
    ,replace(replace(t1.termtype,chr(13),''),chr(10),'')  -- 期限类型(短期、中长期)
    ,replace(replace(t1.termmonthtype,chr(13),''),chr(10),'')  -- 期限分段(三个月以内、三个月至六个月、六个月至一年、一年至两年、两年至三年、三年至五年、五年至十年、十年以上)
    ,t1.insum  -- 累计归还本金
    ,t1.interestinsum  -- 累计归还利息
    ,replace(replace(t1.classifydate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.nextperiodreturnprincipaldate,chr(13),''),chr(10),'')  -- 下一期还本日期
    ,t1.nextperiodreturnprincipalsum  -- 下一期还本金额
    ,replace(replace(t1.nextperiodreturninterestdate,chr(13),''),chr(10),'')  -- 下一期还息日期
    ,t1.nextperiodreturninterestsum  -- 下一期还息金额
    ,t1.duebalance  -- 暂存借据余额
    ,replace(replace(t1.balancechangedate,chr(13),''),chr(10),'')  -- 借据余额变化日期
    ,replace(replace(t1.oldictype,chr(13),''),chr(10),'')  -- 原还款方式代码
    ,replace(replace(t1.isinuse,chr(13),''),chr(10),'')  -- 添加维护标志1正常2不维护
    ,replace(replace(t1.dzhxstatus,chr(13),''),chr(10),'')  -- 呆账核销状态 1-待核销 2-已核销
    ,replace(replace(t1.hxtype,chr(13),''),chr(10),'')  -- 核销类别 码值(DZHXType)
    ,t1.hxinrate  -- 核销表内利息
    ,t1.hxoutrate  -- 核销表外利息
    ,t1.legal  -- 诉讼费
    ,replace(replace(t1.reinforcechecker,chr(13),''),chr(10),'')  -- 补登复核人
    ,replace(replace(t1.batchno,chr(13),''),chr(10),'')  -- 批量新增借据关键字段
    ,replace(replace(t1.tcustomerid,chr(13),''),chr(10),'')  -- 资金交易系统实际融资人客户编号
    ,replace(replace(t1.tcustomername,chr(13),''),chr(10),'')  -- 资金交易系统实际融资人客户名称
    ,replace(replace(t1.transdate,chr(13),''),chr(10),'')  -- 同业综合业务系统交易日期
    ,replace(replace(t1.billtype,chr(13),''),chr(10),'')  -- 票据类型
    ,replace(replace(t1.billkind,chr(13),''),chr(10),'')  -- 票据种类
    ,replace(replace(t1.datatype,chr(13),''),chr(10),'')  -- 批量数据来源（PJ.票据系统供数 LC.理财资管系统供数 ZJ.资金系统供数 ZH.同业综合业务系统供数）
    ,replace(replace(t1.acceptbankid,chr(13),''),chr(10),'')  -- 承兑行行号
    ,replace(replace(t1.acceptbankname,chr(13),''),chr(10),'')  -- 承兑行行名
    ,replace(replace(t1.keyno,chr(13),''),chr(10),'')  -- 票据唯一标识
    ,replace(replace(t1.istran,chr(13),''),chr(10),'')  -- 票据唯一标识
    ,t1.start_dt  -- 
    ,t1.end_dt  -- 
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.crss_business_duebill t1    --业务借据(账户)信息
where t1.start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_crss_business_duebill',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);