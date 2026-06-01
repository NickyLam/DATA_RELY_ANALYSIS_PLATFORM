/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_crss_upl_business_duebill
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
alter table ${idl_schema}.oass_crss_upl_business_duebill drop partition p_${retain_week};
alter table ${idl_schema}.oass_crss_upl_business_duebill drop partition p_${batch_date};


-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_crss_upl_business_duebill add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_crss_upl_business_duebill (
    etl_dt  -- 数据日期
    ,serialno  -- 借据号(账号)
    ,relativeserialno1  -- 相关出帐流水号
    ,relativeserialno2  -- 相关合同流水号
    ,subjectno  -- 会计科目
    ,mfcustomerid  -- 主机客户号
    ,customerid  -- 客户编号
    ,customername  -- 客户名称
    ,businesstype  -- 业务品种
    ,businesssubtype  -- 业务品种子类型
    ,businessstatus  -- 业务形态
    ,businesscurrency  -- 业务币种
    ,businesssum  -- 金额
    ,putoutdate  -- 发放日期
    ,maturity  -- 约定到期日
    ,actualmaturity  -- 执行到期日
    ,businessrate  -- 利率
    ,actualbusinessrate  -- 执行利率
    ,ictype  -- 计息方式
    ,iccyc  -- 计息周期
    ,paytimes  -- 还款期次
    ,paycyc  -- 还款周期
    ,corpuspaymethod  -- 本金还款方式
    ,extendtimes  -- 展期次数
    ,reorgtimes  -- 债务重组次数
    ,renewtimes  -- 借新还旧次数
    ,golntimes  -- 还旧借新次数
    ,balance  -- 本金余额
    ,normalbalance  -- 正常余额
    ,overduebalance  -- 逾期金额
    ,dullbalance  -- 呆滞余额
    ,badbalance  -- 呆帐余额
    ,interestbalance1  -- 表内欠息余额
    ,interestbalance2  -- 表外欠息余额
    ,finebalance1  -- 本金罚息
    ,finebalance2  -- 利息罚息
    ,receivebalance  -- 到单金额
    ,payedbalance  -- 付款金额
    ,overduedays  -- 逾期天数
    ,payaccount  -- 存款帐号
    ,putoutaccount  -- 放款帐号
    ,paybackaccount  -- 还款帐号
    ,payinterestaccount  -- 还息帐号
    ,oweinterestdays  -- 欠息天数
    ,tabalance  -- 分期业务欠本金
    ,tainterestbalance  -- 分期业务欠利息
    ,tatimes  -- 累计欠款期数
    ,lcatimes  -- 连续欠款期数
    ,saledate  -- 卖出日期
    ,finishtype  -- 终结类型
    ,finishdate  -- 终结日期
    ,mfareaid  -- 主机地区号
    ,mforgid  -- 主机机构号
    ,mfuserid  -- 主机柜员号
    ,operateorgid  -- 经办机构
    ,operateuserid  -- 经办人
    ,inputorgid  -- 登记机构
    ,inputuserid  -- 登记人
    ,inputdate  -- 输入日期
    ,updatedate  -- 更新日期
    ,inoutflag  -- 表内表外标志
    ,dealflag  -- 处理标志
    ,occurdate  -- 发生日期
    ,baseratetype  -- 基准利率类型
    ,baserate  -- 基准利率
    ,ratefloattype  -- 浮动类型
    ,ratefloat  -- 浮动利率
    ,purpose  -- 用途
    ,advanceflag  -- 垫款标志
    ,relativeduebillno  -- 相关借据流水号
    ,actualartificialno  -- 实际合同号
    ,accountno  -- 结算帐号
    ,loanaccountno  -- 贷款入账账号
    ,secondpayaccount  -- 第二还款帐号
    ,adjustratetype  -- 利率调整方式
    ,adjustrateterm  -- 利率调整月数
    ,overinttype  -- 逾期计息方式
    ,rateadjustcyc  -- 利率调整周期
    ,pdgaccountno  -- 手续费支出帐号
    ,deductdate  -- 扣款日期
    ,fzanbalance  -- 发展商入帐净额
    ,acceptinttype  -- 收息类型
    ,ratio  -- 比例
    ,termdate1  -- 最晚装运期
    ,termdate2  -- 交单期
    ,termdate3  -- 付款期限
    ,describe2  -- 描述2
    ,fixcyc  -- 固定周期
    ,type1  -- 通知行类别
    ,type2  -- 受益行类别
    ,type3  -- 议付行类别
    ,billno  -- 票据号
    ,flag1  -- (new)是否1
    ,flag2  -- (new)是否2
    ,flag3  -- (new)是否3
    ,aboutbankname  -- 收款行行名
    ,aboutbankid  -- 收款行行号
    ,creditkind  -- 贷款形式
    ,gatheringname  -- 收款人户名
    ,preinttype  -- 预收息标志
    ,resumeinttype  -- 计复息标志
    ,guarantyno  -- 抵质押物编号
    ,pztype  -- 凭证种类
    ,graceperiod  -- 还款宽限期(月)
    ,oldlcvaliddate  -- (new)原信用证效期
    ,mfeepaymethod  -- 管理费支付方式
    ,describe1  -- 描述1
    ,loantype  -- 贷款类型
    ,fixterm  -- 周期
    ,cancelsum  -- 核销金额
    ,cancelinterest  -- 核销利息
    ,bailacount  -- 保证金帐号
    ,classify4  -- 四级分类
    ,classifyresult  -- 五级分类结果
    ,returntype  -- 还款方式
    ,bailpercent  -- 保证金比例
    ,paymenttype  -- 信用证付款期限
    ,termsfreq  -- 还款频率
    ,overduedate  -- 逾期日期
    ,oweinterestdate  -- 欠息日期
    ,lcstatus  -- 信用证状态
    ,vouchtype  -- 主要担保方式
    ,actualbusinessratefix  -- 初始执行年利率
    ,lastclassifyresult  -- 上期风险分类
    ,classifyresulteleven  -- 五级分类结果
    ,guaranteeno  -- 保函协议号
    ,surplusphases  -- 剩余期数
    ,eacmprincipal  -- 每期扣款额本金利息
    ,overduerate  -- 逾期利率
    ,mainorgid  -- 机构代号
    ,loanspecies  -- 贷款种类
    ,advanceflagsum  -- 垫款金额
    ,advanceflagno  -- 垫款借据号
    ,compensationsum  -- 赔付金额
    ,logouttype  -- 注销类型
    ,logoutno  -- 注销流水
    ,openno  -- 开立流水
    ,opendate  -- 开立日期
    ,premiumrate  -- 费率
    ,benefitcorpbank  -- 受益人开户行
    ,benefitcorpname  -- 受益人
    ,overdueinterest  -- 逾期利息
    ,fixflag  -- 补登借据标志
    ,intdate  -- 下一结息日
    ,accountbalance  -- 还款账号余额
    ,accountuserbalance  -- 还款账户可用余额
    ,termtype  -- 期限类型(短期、中长期)
    ,termmonthtype  -- 期限分段(三个月以内、三个月至六个月、六个月至一年、一年至两年、两年至三年、三年至五年、五年至十年、十年以上)
    ,insum  -- 累计归还本金
    ,interestinsum  -- 累计归还利息
    ,classifydate  -- 五级分类日期
    ,nextperiodreturnprincipaldate  -- 下一期还本日期
    ,nextperiodreturnprincipalsum  -- 下一期还本金额
    ,nextperiodreturninterestdate  -- 下一期还息日期
    ,nextperiodreturninterestsum  -- 下一期还息金额
    ,logoutdate  -- 销账日期
    ,bdflag  -- 买断清收标志
    ,duebalance  -- 暂存借据余额
    ,balancechangedate  -- 借据余额变化日期
    ,oldictype  -- 原还款方式代码
    ,dzhxstatus  -- 呆账核销状态 1-待核销 2-已核销
    ,hxtype  -- 核销类别 码值(DZHXType)
    ,hxinrate  -- 核销表内利息
    ,hxoutrate  -- 核销表外利息
    ,legal  -- 诉讼费
    ,changepayaccountname  -- 
    ,changepayaccountno  -- 
    ,yqnormalbalance  -- 逾期管理正常本金
    ,yqbadbalance  -- 逾期管理逾期本金
    ,yqinterest  -- 逾期管理利息
    ,yqfaxi  -- 逾期管理罚息
    ,yqfuli  -- 逾期管理复利
    ,yqtotalsum  -- 逾期管理累计应还
    ,start_dt  -- 
    ,end_dt  -- 
    ,id_mark  -- 
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.serialno,chr(13),''),chr(10),'')  -- 借据号(账号)
    ,replace(replace(t1.relativeserialno1,chr(13),''),chr(10),'')  -- 相关出帐流水号
    ,replace(replace(t1.relativeserialno2,chr(13),''),chr(10),'')  -- 相关合同流水号
    ,replace(replace(t1.subjectno,chr(13),''),chr(10),'')  -- 会计科目
    ,replace(replace(t1.mfcustomerid,chr(13),''),chr(10),'')  -- 主机客户号
    ,replace(replace(t1.customerid,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.customername,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.businesstype,chr(13),''),chr(10),'')  -- 业务品种
    ,replace(replace(t1.businesssubtype,chr(13),''),chr(10),'')  -- 业务品种子类型
    ,replace(replace(t1.businessstatus,chr(13),''),chr(10),'')  -- 业务形态
    ,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'')  -- 业务币种
    ,t1.businesssum  -- 金额
    ,replace(replace(t1.putoutdate,chr(13),''),chr(10),'')  -- 发放日期
    ,replace(replace(t1.maturity,chr(13),''),chr(10),'')  -- 约定到期日
    ,replace(replace(t1.actualmaturity,chr(13),''),chr(10),'')  -- 执行到期日
    ,t1.businessrate  -- 利率
    ,t1.actualbusinessrate  -- 执行利率
    ,replace(replace(t1.ictype,chr(13),''),chr(10),'')  -- 计息方式
    ,replace(replace(t1.iccyc,chr(13),''),chr(10),'')  -- 计息周期
    ,t1.paytimes  -- 还款期次
    ,replace(replace(t1.paycyc,chr(13),''),chr(10),'')  -- 还款周期
    ,replace(replace(t1.corpuspaymethod,chr(13),''),chr(10),'')  -- 本金还款方式
    ,t1.extendtimes  -- 展期次数
    ,t1.reorgtimes  -- 债务重组次数
    ,t1.renewtimes  -- 借新还旧次数
    ,t1.golntimes  -- 还旧借新次数
    ,t1.balance  -- 本金余额
    ,t1.normalbalance  -- 正常余额
    ,t1.overduebalance  -- 逾期金额
    ,t1.dullbalance  -- 呆滞余额
    ,t1.badbalance  -- 呆帐余额
    ,t1.interestbalance1  -- 表内欠息余额
    ,t1.interestbalance2  -- 表外欠息余额
    ,t1.finebalance1  -- 本金罚息
    ,t1.finebalance2  -- 利息罚息
    ,t1.receivebalance  -- 到单金额
    ,t1.payedbalance  -- 付款金额
    ,t1.overduedays  -- 逾期天数
    ,replace(replace(t1.payaccount,chr(13),''),chr(10),'')  -- 存款帐号
    ,replace(replace(t1.putoutaccount,chr(13),''),chr(10),'')  -- 放款帐号
    ,replace(replace(t1.paybackaccount,chr(13),''),chr(10),'')  -- 还款帐号
    ,replace(replace(t1.payinterestaccount,chr(13),''),chr(10),'')  -- 还息帐号
    ,t1.oweinterestdays  -- 欠息天数
    ,t1.tabalance  -- 分期业务欠本金
    ,t1.tainterestbalance  -- 分期业务欠利息
    ,t1.tatimes  -- 累计欠款期数
    ,t1.lcatimes  -- 连续欠款期数
    ,replace(replace(t1.saledate,chr(13),''),chr(10),'')  -- 卖出日期
    ,replace(replace(t1.finishtype,chr(13),''),chr(10),'')  -- 终结类型
    ,replace(replace(t1.finishdate,chr(13),''),chr(10),'')  -- 终结日期
    ,replace(replace(t1.mfareaid,chr(13),''),chr(10),'')  -- 主机地区号
    ,replace(replace(t1.mforgid,chr(13),''),chr(10),'')  -- 主机机构号
    ,replace(replace(t1.mfuserid,chr(13),''),chr(10),'')  -- 主机柜员号
    ,replace(replace(t1.operateorgid,chr(13),''),chr(10),'')  -- 经办机构
    ,replace(replace(t1.operateuserid,chr(13),''),chr(10),'')  -- 经办人
    ,replace(replace(t1.inputorgid,chr(13),''),chr(10),'')  -- 登记机构
    ,replace(replace(t1.inputuserid,chr(13),''),chr(10),'')  -- 登记人
    ,replace(replace(t1.inputdate,chr(13),''),chr(10),'')  -- 输入日期
    ,replace(replace(t1.updatedate,chr(13),''),chr(10),'')  -- 更新日期
    ,replace(replace(t1.inoutflag,chr(13),''),chr(10),'')  -- 表内表外标志
    ,replace(replace(t1.dealflag,chr(13),''),chr(10),'')  -- 处理标志
    ,replace(replace(t1.occurdate,chr(13),''),chr(10),'')  -- 发生日期
    ,replace(replace(t1.baseratetype,chr(13),''),chr(10),'')  -- 基准利率类型
    ,t1.baserate  -- 基准利率
    ,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'')  -- 浮动类型
    ,t1.ratefloat  -- 浮动利率
    ,replace(replace(t1.purpose,chr(13),''),chr(10),'')  -- 用途
    ,replace(replace(t1.advanceflag,chr(13),''),chr(10),'')  -- 垫款标志
    ,replace(replace(t1.relativeduebillno,chr(13),''),chr(10),'')  -- 相关借据流水号
    ,replace(replace(t1.actualartificialno,chr(13),''),chr(10),'')  -- 实际合同号
    ,replace(replace(t1.accountno,chr(13),''),chr(10),'')  -- 结算帐号
    ,replace(replace(t1.loanaccountno,chr(13),''),chr(10),'')  -- 贷款入账账号
    ,replace(replace(t1.secondpayaccount,chr(13),''),chr(10),'')  -- 第二还款帐号
    ,replace(replace(t1.adjustratetype,chr(13),''),chr(10),'')  -- 利率调整方式
    ,replace(replace(t1.adjustrateterm,chr(13),''),chr(10),'')  -- 利率调整月数
    ,replace(replace(t1.overinttype,chr(13),''),chr(10),'')  -- 逾期计息方式
    ,replace(replace(t1.rateadjustcyc,chr(13),''),chr(10),'')  -- 利率调整周期
    ,replace(replace(t1.pdgaccountno,chr(13),''),chr(10),'')  -- 手续费支出帐号
    ,replace(replace(t1.deductdate,chr(13),''),chr(10),'')  -- 扣款日期
    ,t1.fzanbalance  -- 发展商入帐净额
    ,replace(replace(t1.acceptinttype,chr(13),''),chr(10),'')  -- 收息类型
    ,t1.ratio  -- 比例
    ,replace(replace(t1.termdate1,chr(13),''),chr(10),'')  -- 最晚装运期
    ,replace(replace(t1.termdate2,chr(13),''),chr(10),'')  -- 交单期
    ,replace(replace(t1.termdate3,chr(13),''),chr(10),'')  -- 付款期限
    ,replace(replace(t1.describe2,chr(13),''),chr(10),'')  -- 描述2
    ,t1.fixcyc  -- 固定周期
    ,replace(replace(t1.type1,chr(13),''),chr(10),'')  -- 通知行类别
    ,replace(replace(t1.type2,chr(13),''),chr(10),'')  -- 受益行类别
    ,replace(replace(t1.type3,chr(13),''),chr(10),'')  -- 议付行类别
    ,replace(replace(t1.billno,chr(13),''),chr(10),'')  -- 票据号
    ,replace(replace(t1.flag1,chr(13),''),chr(10),'')  -- (new)是否1
    ,replace(replace(t1.flag2,chr(13),''),chr(10),'')  -- (new)是否2
    ,replace(replace(t1.flag3,chr(13),''),chr(10),'')  -- (new)是否3
    ,replace(replace(t1.aboutbankname,chr(13),''),chr(10),'')  -- 收款行行名
    ,replace(replace(t1.aboutbankid,chr(13),''),chr(10),'')  -- 收款行行号
    ,replace(replace(t1.creditkind,chr(13),''),chr(10),'')  -- 贷款形式
    ,replace(replace(t1.gatheringname,chr(13),''),chr(10),'')  -- 收款人户名
    ,replace(replace(t1.preinttype,chr(13),''),chr(10),'')  -- 预收息标志
    ,replace(replace(t1.resumeinttype,chr(13),''),chr(10),'')  -- 计复息标志
    ,replace(replace(t1.guarantyno,chr(13),''),chr(10),'')  -- 抵质押物编号
    ,replace(replace(t1.pztype,chr(13),''),chr(10),'')  -- 凭证种类
    ,t1.graceperiod  -- 还款宽限期(月)
    ,replace(replace(t1.oldlcvaliddate,chr(13),''),chr(10),'')  -- (new)原信用证效期
    ,replace(replace(t1.mfeepaymethod,chr(13),''),chr(10),'')  -- 管理费支付方式
    ,replace(replace(t1.describe1,chr(13),''),chr(10),'')  -- 描述1
    ,replace(replace(t1.loantype,chr(13),''),chr(10),'')  -- 贷款类型
    ,t1.fixterm  -- 周期
    ,t1.cancelsum  -- 核销金额
    ,t1.cancelinterest  -- 核销利息
    ,replace(replace(t1.bailacount,chr(13),''),chr(10),'')  -- 保证金帐号
    ,replace(replace(t1.classify4,chr(13),''),chr(10),'')  -- 四级分类
    ,replace(replace(t1.classifyresult,chr(13),''),chr(10),'')  -- 五级分类结果
    ,replace(replace(t1.returntype,chr(13),''),chr(10),'')  -- 还款方式
    ,t1.bailpercent  -- 保证金比例
    ,replace(replace(t1.paymenttype,chr(13),''),chr(10),'')  -- 信用证付款期限
    ,replace(replace(t1.termsfreq,chr(13),''),chr(10),'')  -- 还款频率
    ,replace(replace(t1.overduedate,chr(13),''),chr(10),'')  -- 逾期日期
    ,replace(replace(t1.oweinterestdate,chr(13),''),chr(10),'')  -- 欠息日期
    ,replace(replace(t1.lcstatus,chr(13),''),chr(10),'')  -- 信用证状态
    ,replace(replace(t1.vouchtype,chr(13),''),chr(10),'')  -- 主要担保方式
    ,t1.actualbusinessratefix  -- 初始执行年利率
    ,replace(replace(t1.lastclassifyresult,chr(13),''),chr(10),'')  -- 上期风险分类
    ,replace(replace(t1.classifyresulteleven,chr(13),''),chr(10),'')  -- 五级分类结果
    ,replace(replace(t1.guaranteeno,chr(13),''),chr(10),'')  -- 保函协议号
    ,t1.surplusphases  -- 剩余期数
    ,t1.eacmprincipal  -- 每期扣款额本金利息
    ,t1.overduerate  -- 逾期利率
    ,replace(replace(t1.mainorgid,chr(13),''),chr(10),'')  -- 机构代号
    ,replace(replace(t1.loanspecies,chr(13),''),chr(10),'')  -- 贷款种类
    ,t1.advanceflagsum  -- 垫款金额
    ,replace(replace(t1.advanceflagno,chr(13),''),chr(10),'')  -- 垫款借据号
    ,t1.compensationsum  -- 赔付金额
    ,replace(replace(t1.logouttype,chr(13),''),chr(10),'')  -- 注销类型
    ,replace(replace(t1.logoutno,chr(13),''),chr(10),'')  -- 注销流水
    ,replace(replace(t1.openno,chr(13),''),chr(10),'')  -- 开立流水
    ,replace(replace(t1.opendate,chr(13),''),chr(10),'')  -- 开立日期
    ,t1.premiumrate  -- 费率
    ,replace(replace(t1.benefitcorpbank,chr(13),''),chr(10),'')  -- 受益人开户行
    ,replace(replace(t1.benefitcorpname,chr(13),''),chr(10),'')  -- 受益人
    ,t1.overdueinterest  -- 逾期利息
    ,replace(replace(t1.fixflag,chr(13),''),chr(10),'')  -- 补登借据标志
    ,replace(replace(t1.intdate,chr(13),''),chr(10),'')  -- 下一结息日
    ,t1.accountbalance  -- 还款账号余额
    ,t1.accountuserbalance  -- 还款账户可用余额
    ,replace(replace(t1.termtype,chr(13),''),chr(10),'')  -- 期限类型(短期、中长期)
    ,replace(replace(t1.termmonthtype,chr(13),''),chr(10),'')  -- 期限分段(三个月以内、三个月至六个月、六个月至一年、一年至两年、两年至三年、三年至五年、五年至十年、十年以上)
    ,t1.insum  -- 累计归还本金
    ,t1.interestinsum  -- 累计归还利息
    ,replace(replace(t1.classifydate,chr(13),''),chr(10),'')  -- 五级分类日期
    ,replace(replace(t1.nextperiodreturnprincipaldate,chr(13),''),chr(10),'')  -- 下一期还本日期
    ,t1.nextperiodreturnprincipalsum  -- 下一期还本金额
    ,replace(replace(t1.nextperiodreturninterestdate,chr(13),''),chr(10),'')  -- 下一期还息日期
    ,t1.nextperiodreturninterestsum  -- 下一期还息金额
    ,replace(replace(t1.logoutdate,chr(13),''),chr(10),'')  -- 销账日期
    ,replace(replace(t1.bdflag,chr(13),''),chr(10),'')  -- 买断清收标志
    ,t1.duebalance  -- 暂存借据余额
    ,replace(replace(t1.balancechangedate,chr(13),''),chr(10),'')  -- 借据余额变化日期
    ,replace(replace(t1.oldictype,chr(13),''),chr(10),'')  -- 原还款方式代码
    ,replace(replace(t1.dzhxstatus,chr(13),''),chr(10),'')  -- 呆账核销状态 1-待核销 2-已核销
    ,replace(replace(t1.hxtype,chr(13),''),chr(10),'')  -- 核销类别 码值(DZHXType)
    ,t1.hxinrate  -- 核销表内利息
    ,t1.hxoutrate  -- 核销表外利息
    ,t1.legal  -- 诉讼费
    ,replace(replace(t1.changepayaccountname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.changepayaccountno,chr(13),''),chr(10),'')  -- 
    ,t1.yqnormalbalance  -- 逾期管理正常本金
    ,t1.yqbadbalance  -- 逾期管理逾期本金
    ,t1.yqinterest  -- 逾期管理利息
    ,t1.yqfaxi  -- 逾期管理罚息
    ,t1.yqfuli  -- 逾期管理复利
    ,t1.yqtotalsum  -- 逾期管理累计应还
    ,t1.start_dt  -- 
    ,t1.end_dt  -- 
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.crss_upl_business_duebill t1    --微贷业务借据表
where t1.start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_crss_upl_business_duebill',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);