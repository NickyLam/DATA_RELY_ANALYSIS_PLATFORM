/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crss_business_duebill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.crss_business_duebill
whenever sqlerror continue none;
drop table ${idl_schema}.crss_business_duebill purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.crss_business_duebill(
    etl_dt date -- 数据日期   
    ,serialno varchar2(40) -- 借据号(账号)   
    ,relativeserialno1 varchar2(40) -- 相关出帐流水号   
    ,relativeserialno2 varchar2(40) -- 相关合同流水号   
    ,subjectno varchar2(20) -- 会计科目   
    ,mfcustomerid varchar2(40) -- 主机客户号   
    ,customerid varchar2(40) -- 客户编号   
    ,customername varchar2(80) -- 客户名称   
    ,businesstype varchar2(18) -- 业务品种   
    ,businesssubtype varchar2(20) -- 业务品种子类型   
    ,businessstatus varchar2(20) -- 业务形态   
    ,businesscurrency varchar2(20) -- 业务币种   
    ,businesssum number(24,6) -- 金额   
    ,putoutdate varchar2(10) -- 发放日期   
    ,maturity varchar2(10) -- 约定到期日   
    ,actualmaturity varchar2(10) -- 执行到期日   
    ,businessrate number(24,10) -- 利率   
    ,actualbusinessrate number(10,6) -- 执行利率   
    ,ictype varchar2(20) -- 计息方式   
    ,iccyc varchar2(20) -- 计息周期   
    ,paytimes number -- 还款期次   
    ,paycyc varchar2(20) -- 还款周期   
    ,corpuspaymethod varchar2(20) -- 本金还款方式   
    ,extendtimes number -- 展期次数   
    ,reorgtimes number -- 债务重组次数   
    ,renewtimes number -- 借新还旧次数   
    ,golntimes number -- 还旧借新次数   
    ,balance number(24,6) -- 本金余额   
    ,normalbalance number(24,6) -- 正常余额   
    ,overduebalance number(24,6) -- 逾期金额   
    ,dullbalance number(24,6) -- 呆滞余额   
    ,badbalance number(24,6) -- 呆帐余额   
    ,interestbalance1 number(24,6) -- 表内欠息余额   
    ,interestbalance2 number(24,6) -- 表外欠息余额   
    ,finebalance1 number(24,6) -- 本金罚息   
    ,finebalance2 number(24,6) -- 利息罚息   
    ,receivebalance number(24,6) -- 到单金额   
    ,payedbalance number(24,6) -- 付款金额   
    ,overduedays number -- 逾期天数   
    ,payaccount varchar2(40) -- 存款帐号   
    ,putoutaccount varchar2(40) -- 放款帐号   
    ,paybackaccount varchar2(40) -- 还款帐号   
    ,payinterestaccount varchar2(40) -- 还息帐号   
    ,oweinterestdays number -- 欠息天数   
    ,tabalance number(24,6) -- 分期业务欠本金   
    ,tainterestbalance number(24,6) -- 分期业务欠利息   
    ,tatimes number(24,6) -- 累计欠款期数   
    ,lcatimes number(24,6) -- 连续欠款期数   
    ,saledate varchar2(10) -- 卖出日期   
    ,finishtype varchar2(20) -- 终结类型   
    ,finishdate varchar2(10) -- 终结日期   
    ,mfareaid varchar2(20) -- 主机地区号   
    ,mforgid varchar2(20) -- 主机机构号   
    ,mfuserid varchar2(20) -- 主机柜员号   
    ,operateorgid varchar2(20) -- 经办机构   
    ,operateuserid varchar2(20) -- 经办人   
    ,inputorgid varchar2(20) -- 登记机构   
    ,inputuserid varchar2(20) -- 登记人   
    ,inputdate varchar2(10) -- 输入日期   
    ,updatedate varchar2(10) -- 更新日期   
    ,inoutflag varchar2(40) -- (Del)表内表外标志   
    ,dealflag varchar2(1) -- (Del)处理标志   
    ,occurdate varchar2(10) -- (Del)发生日期   
    ,businessprop number(10,6) -- (Del)贷款成数   
    ,benefitcorp varchar2(40) -- (Del)受益人   
    ,actualtermmonth number -- (Del)实际期限月   
    ,actualtermday number -- (Del)实际期限日   
    ,baseratetype varchar2(20) -- (Del)基准利率类型   
    ,baserate number(24,6) -- (Del)基准利率   
    ,ratefloattype varchar2(20) -- (Del)浮动类型   
    ,ratefloat number(24,6) -- (Del)浮动利率   
    ,timsflag varchar2(40) -- (Del)分期业务标志   
    ,bailratio number(10,6) -- (Del)担保费率   
    ,logoutdate varchar2(10) -- (Del)注销日期   
    ,cancellogoutdate varchar2(10) -- (Del)解除注销日期   
    ,bailsum number(24,6) -- (Del)保证金金额   
    ,bailaccount varchar2(40) -- (Del)保证金帐号   
    ,purpose varchar2(200) -- (Del)用途   
    ,advanceflag varchar2(20) -- 垫款标志   
    ,relativeduebillno varchar2(40) -- 相关借据流水号   
    ,actualartificialno varchar2(40) -- 实际合同号   
    ,accountno varchar2(40) -- 结算帐号   
    ,loanaccountno varchar2(40) -- 贷款入账账号   
    ,secondpayaccount varchar2(40) -- 第二还款帐号   
    ,adjustratetype varchar2(20) -- 利率调整方式   
    ,adjustrateterm varchar2(20) -- 利率调整月数   
    ,overinttype varchar2(20) -- 逾期计息方式   
    ,rateadjustcyc varchar2(20) -- 利率调整周期   
    ,pdgaccountno varchar2(40) -- 手续费支出帐号   
    ,deductdate varchar2(10) -- 扣款日期   
    ,fzanbalance number(24,6) -- 发展商入帐净额   
    ,acceptinttype varchar2(20) -- 收息类型   
    ,ratio number(24,6) -- 比例   
    ,thirdpartyadd1 varchar2(80) -- (new)涉及第三方地址1   
    ,thirdpartyzip1 varchar2(40) -- (new)第三方法人邮编1   
    ,thirdpartyadd2 varchar2(80) -- (new)涉及第三方地址2   
    ,thirdpartyzip2 varchar2(40) -- (new)第三方法人邮编2   
    ,termdate1 varchar2(10) -- 最晚装运期   
    ,termdate2 varchar2(10) -- 交单期   
    ,termdate3 varchar2(10) -- 付款期限   
    ,describe2 varchar2(200) -- 描述2   
    ,fixcyc number -- 固定周期   
    ,thirdparty1 varchar2(200) -- (new)涉及第三方1   
    ,thirdpartyid1 varchar2(40) -- (new)第三方法人代码1   
    ,thirdparty2 varchar2(200) -- (new)涉及第三方2   
    ,thirdparty3 varchar2(200) -- (new)涉及第三方3   
    ,type1 varchar2(20) -- 通知行类别   
    ,type2 varchar2(20) -- 受益行类别   
    ,type3 varchar2(20) -- 议付行类别   
    ,billno varchar2(40) -- 票据号   
    ,flag1 varchar2(20) -- (new)是否1   
    ,flag2 varchar2(20) -- (new)是否2   
    ,flag3 varchar2(20) -- (new)是否3   
    ,thirdpartyregion varchar2(20) -- 涉及第三方所在地区和国家   
    ,thirdpartyaccounts varchar2(40) -- (new)第三方帐号   
    ,cargoinfo varchar2(80) -- (new)货物名称   
    ,securitiestype varchar2(20) -- (new)有价证券类型   
    ,securitiesregion varchar2(20) -- (new)有价证券发行地   
    ,aboutbankid2 varchar2(40) -- 受益行行号   
    ,aboutbankname2 varchar2(80) -- 受益行行名   
    ,aboutbankid3 varchar2(40) -- 议付行行号   
    ,aboutbankname varchar2(80) -- 收款行行名   
    ,aboutbankid varchar2(40) -- 收款行行号   
    ,oldlctermtype varchar2(20) -- (new)原信用证期限类型   
    ,negotiateno varchar2(40) -- 押汇编号   
    ,creditkind varchar2(20) -- 贷款形式   
    ,gatheringname varchar2(80) -- 收款人户名   
    ,preinttype varchar2(20) -- 预收息标志   
    ,resumeinttype varchar2(20) -- 计复息标志   
    ,guarantyno varchar2(40) -- 抵质押物编号   
    ,pztype varchar2(20) -- 凭证种类   
    ,graceperiod number -- 还款宽限期(月)   
    ,oldlcvaliddate varchar2(10) -- (new)原信用证效期   
    ,mfeepaymethod varchar2(20) -- 管理费支付方式   
    ,describe1 varchar2(200) -- 描述1   
    ,tradecontractno varchar2(40) -- (new)相关贸易合同号   
    ,loantype varchar2(20) -- 贷款类型   
    ,fixterm number(24,6) -- 周期   
    ,cancelsum number(24,6) -- 核销金额   
    ,cancelinterest number(24,6) -- 核销利息   
    ,bailacount varchar2(40) -- 保证金帐号   
    ,classify4 varchar2(18) -- 四级分类   
    ,classifyresult varchar2(18) -- 五级分类结果   
    ,returntype varchar2(18) -- 还款方式   
    ,bailpercent number(10,6) -- 保证金比例   
    ,paymenttype varchar2(18) -- 信用证付款期限   
    ,termsfreq varchar2(18) -- 还款频率   
    ,overduedate varchar2(10) -- 逾期日期   
    ,oweinterestdate varchar2(10) -- 欠息日期   
    ,lcstatus varchar2(18) -- 信用证状态   
    ,ichangedate varchar2(10) -- 变更时间   
    ,vouchtype varchar2(10) -- 主要担保方式   
    ,actualbusinessratefix number(10,6) -- 初始执行年利率   
    ,lastclassifyresult varchar2(10) -- 上期风险分类   
    ,classifyresulteleven varchar2(10) -- 五级分类结果   
    ,guaranteeno varchar2(10) -- 保函协议号   
    ,surplusphases number(24,6) -- 剩余期数   
    ,eacmprincipal number(24,6) -- 每期扣款额本金利息   
    ,overduerate number(11,7) -- 逾期利率   
    ,mainorgid varchar2(20) -- 机构代号   
    ,loanspecies varchar2(5) -- 贷款种类   
    ,advanceflagsum number(24,6) -- 受益人   
    ,advanceflagno varchar2(40) -- 垫款借据号   
    ,compensationsum number(24,6) -- 赔付金额   
    ,logouttype varchar2(2) -- 注销类型   
    ,logoutno varchar2(32) -- 注销流水   
    ,openno varchar2(32) -- 开立流水   
    ,opendate varchar2(18) -- 开立日期   
    ,premiumrate number(24,6) -- 费率   
    ,benefitcorpbank varchar2(80) -- 受益人开户行   
    ,benefitcorpname varchar2(80) -- 受益人   
    ,overdueinterest number(24,6) -- 逾期利息   
    ,fixflag varchar2(1) -- 补登借据标志   
    ,intdate varchar2(10) -- 下一结息日   
    ,accountbalance number(24,6) -- 还款账号余额   
    ,accountuserbalance number(24,6) -- 还款账户可用余额   
    ,termtype varchar2(10) -- 期限类型(短期、中长期)   
    ,termmonthtype varchar2(10) -- 期限分段(三个月以内、三个月至六个月、六个月至一年、一年至两年、两年至三年、三年至五年、五年至十年、十年以上)   
    ,insum number(24,6) -- 累计归还本金   
    ,interestinsum number(24,6) -- 累计归还利息   
    ,classifydate varchar2(10) -- 评级日期   
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
    ,istran varchar2(16) -- 是否转让   
    ,remart varchar2(100) -- 计量标记   
    ,littlecreditstatus varchar2(40) -- 支小再状态   
    ,reselltype varchar2(2) -- 01境内转让、02行内转让、03跨境转让   
    ,ztrate number(24,6) -- 转贴现利率   
    ,ztacceptbankid varchar2(32) --    
    ,ztacceptbankname varchar2(80) --    
    ,start_dt date -- 开始日期   
    ,end_dt date -- 结束日期   
    ,id_mark varchar2(10) -- 删除标识   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.crss_business_duebill to ${iel_schema};

-- comment
comment on table ${idl_schema}.crss_business_duebill is '业务借据(账户)信息';
comment on column ${idl_schema}.crss_business_duebill.etl_dt is '数据日期';
comment on column ${idl_schema}.crss_business_duebill.serialno is '借据号(账号)';
comment on column ${idl_schema}.crss_business_duebill.relativeserialno1 is '相关出帐流水号';
comment on column ${idl_schema}.crss_business_duebill.relativeserialno2 is '相关合同流水号';
comment on column ${idl_schema}.crss_business_duebill.subjectno is '会计科目';
comment on column ${idl_schema}.crss_business_duebill.mfcustomerid is '主机客户号';
comment on column ${idl_schema}.crss_business_duebill.customerid is '客户编号';
comment on column ${idl_schema}.crss_business_duebill.customername is '客户名称';
comment on column ${idl_schema}.crss_business_duebill.businesstype is '业务品种';
comment on column ${idl_schema}.crss_business_duebill.businesssubtype is '业务品种子类型';
comment on column ${idl_schema}.crss_business_duebill.businessstatus is '业务形态';
comment on column ${idl_schema}.crss_business_duebill.businesscurrency is '业务币种';
comment on column ${idl_schema}.crss_business_duebill.businesssum is '金额';
comment on column ${idl_schema}.crss_business_duebill.putoutdate is '发放日期';
comment on column ${idl_schema}.crss_business_duebill.maturity is '约定到期日';
comment on column ${idl_schema}.crss_business_duebill.actualmaturity is '执行到期日';
comment on column ${idl_schema}.crss_business_duebill.businessrate is '利率';
comment on column ${idl_schema}.crss_business_duebill.actualbusinessrate is '执行利率';
comment on column ${idl_schema}.crss_business_duebill.ictype is '计息方式';
comment on column ${idl_schema}.crss_business_duebill.iccyc is '计息周期';
comment on column ${idl_schema}.crss_business_duebill.paytimes is '还款期次';
comment on column ${idl_schema}.crss_business_duebill.paycyc is '还款周期';
comment on column ${idl_schema}.crss_business_duebill.corpuspaymethod is '本金还款方式';
comment on column ${idl_schema}.crss_business_duebill.extendtimes is '展期次数';
comment on column ${idl_schema}.crss_business_duebill.reorgtimes is '债务重组次数';
comment on column ${idl_schema}.crss_business_duebill.renewtimes is '借新还旧次数';
comment on column ${idl_schema}.crss_business_duebill.golntimes is '还旧借新次数';
comment on column ${idl_schema}.crss_business_duebill.balance is '本金余额';
comment on column ${idl_schema}.crss_business_duebill.normalbalance is '正常余额';
comment on column ${idl_schema}.crss_business_duebill.overduebalance is '逾期金额';
comment on column ${idl_schema}.crss_business_duebill.dullbalance is '呆滞余额';
comment on column ${idl_schema}.crss_business_duebill.badbalance is '呆帐余额';
comment on column ${idl_schema}.crss_business_duebill.interestbalance1 is '表内欠息余额';
comment on column ${idl_schema}.crss_business_duebill.interestbalance2 is '表外欠息余额';
comment on column ${idl_schema}.crss_business_duebill.finebalance1 is '本金罚息';
comment on column ${idl_schema}.crss_business_duebill.finebalance2 is '利息罚息';
comment on column ${idl_schema}.crss_business_duebill.receivebalance is '到单金额';
comment on column ${idl_schema}.crss_business_duebill.payedbalance is '付款金额';
comment on column ${idl_schema}.crss_business_duebill.overduedays is '逾期天数';
comment on column ${idl_schema}.crss_business_duebill.payaccount is '存款帐号';
comment on column ${idl_schema}.crss_business_duebill.putoutaccount is '放款帐号';
comment on column ${idl_schema}.crss_business_duebill.paybackaccount is '还款帐号';
comment on column ${idl_schema}.crss_business_duebill.payinterestaccount is '还息帐号';
comment on column ${idl_schema}.crss_business_duebill.oweinterestdays is '欠息天数';
comment on column ${idl_schema}.crss_business_duebill.tabalance is '分期业务欠本金';
comment on column ${idl_schema}.crss_business_duebill.tainterestbalance is '分期业务欠利息';
comment on column ${idl_schema}.crss_business_duebill.tatimes is '累计欠款期数';
comment on column ${idl_schema}.crss_business_duebill.lcatimes is '连续欠款期数';
comment on column ${idl_schema}.crss_business_duebill.saledate is '卖出日期';
comment on column ${idl_schema}.crss_business_duebill.finishtype is '终结类型';
comment on column ${idl_schema}.crss_business_duebill.finishdate is '终结日期';
comment on column ${idl_schema}.crss_business_duebill.mfareaid is '主机地区号';
comment on column ${idl_schema}.crss_business_duebill.mforgid is '主机机构号';
comment on column ${idl_schema}.crss_business_duebill.mfuserid is '主机柜员号';
comment on column ${idl_schema}.crss_business_duebill.operateorgid is '经办机构';
comment on column ${idl_schema}.crss_business_duebill.operateuserid is '经办人';
comment on column ${idl_schema}.crss_business_duebill.inputorgid is '登记机构';
comment on column ${idl_schema}.crss_business_duebill.inputuserid is '登记人';
comment on column ${idl_schema}.crss_business_duebill.inputdate is '输入日期';
comment on column ${idl_schema}.crss_business_duebill.updatedate is '更新日期';
comment on column ${idl_schema}.crss_business_duebill.inoutflag is '(Del)表内表外标志';
comment on column ${idl_schema}.crss_business_duebill.dealflag is '(Del)处理标志';
comment on column ${idl_schema}.crss_business_duebill.occurdate is '(Del)发生日期';
comment on column ${idl_schema}.crss_business_duebill.businessprop is '(Del)贷款成数';
comment on column ${idl_schema}.crss_business_duebill.benefitcorp is '(Del)受益人';
comment on column ${idl_schema}.crss_business_duebill.actualtermmonth is '(Del)实际期限月';
comment on column ${idl_schema}.crss_business_duebill.actualtermday is '(Del)实际期限日';
comment on column ${idl_schema}.crss_business_duebill.baseratetype is '(Del)基准利率类型';
comment on column ${idl_schema}.crss_business_duebill.baserate is '(Del)基准利率';
comment on column ${idl_schema}.crss_business_duebill.ratefloattype is '(Del)浮动类型';
comment on column ${idl_schema}.crss_business_duebill.ratefloat is '(Del)浮动利率';
comment on column ${idl_schema}.crss_business_duebill.timsflag is '(Del)分期业务标志';
comment on column ${idl_schema}.crss_business_duebill.bailratio is '(Del)担保费率';
comment on column ${idl_schema}.crss_business_duebill.logoutdate is '(Del)注销日期';
comment on column ${idl_schema}.crss_business_duebill.cancellogoutdate is '(Del)解除注销日期';
comment on column ${idl_schema}.crss_business_duebill.bailsum is '(Del)保证金金额';
comment on column ${idl_schema}.crss_business_duebill.bailaccount is '(Del)保证金帐号';
comment on column ${idl_schema}.crss_business_duebill.purpose is '(Del)用途';
comment on column ${idl_schema}.crss_business_duebill.advanceflag is '垫款标志';
comment on column ${idl_schema}.crss_business_duebill.relativeduebillno is '相关借据流水号';
comment on column ${idl_schema}.crss_business_duebill.actualartificialno is '实际合同号';
comment on column ${idl_schema}.crss_business_duebill.accountno is '结算帐号';
comment on column ${idl_schema}.crss_business_duebill.loanaccountno is '贷款入账账号';
comment on column ${idl_schema}.crss_business_duebill.secondpayaccount is '第二还款帐号';
comment on column ${idl_schema}.crss_business_duebill.adjustratetype is '利率调整方式';
comment on column ${idl_schema}.crss_business_duebill.adjustrateterm is '利率调整月数';
comment on column ${idl_schema}.crss_business_duebill.overinttype is '逾期计息方式';
comment on column ${idl_schema}.crss_business_duebill.rateadjustcyc is '利率调整周期';
comment on column ${idl_schema}.crss_business_duebill.pdgaccountno is '手续费支出帐号';
comment on column ${idl_schema}.crss_business_duebill.deductdate is '扣款日期';
comment on column ${idl_schema}.crss_business_duebill.fzanbalance is '发展商入帐净额';
comment on column ${idl_schema}.crss_business_duebill.acceptinttype is '收息类型';
comment on column ${idl_schema}.crss_business_duebill.ratio is '比例';
comment on column ${idl_schema}.crss_business_duebill.thirdpartyadd1 is '(new)涉及第三方地址1';
comment on column ${idl_schema}.crss_business_duebill.thirdpartyzip1 is '(new)第三方法人邮编1';
comment on column ${idl_schema}.crss_business_duebill.thirdpartyadd2 is '(new)涉及第三方地址2';
comment on column ${idl_schema}.crss_business_duebill.thirdpartyzip2 is '(new)第三方法人邮编2';
comment on column ${idl_schema}.crss_business_duebill.termdate1 is '最晚装运期';
comment on column ${idl_schema}.crss_business_duebill.termdate2 is '交单期';
comment on column ${idl_schema}.crss_business_duebill.termdate3 is '付款期限';
comment on column ${idl_schema}.crss_business_duebill.describe2 is '描述2';
comment on column ${idl_schema}.crss_business_duebill.fixcyc is '固定周期';
comment on column ${idl_schema}.crss_business_duebill.thirdparty1 is '(new)涉及第三方1';
comment on column ${idl_schema}.crss_business_duebill.thirdpartyid1 is '(new)第三方法人代码1';
comment on column ${idl_schema}.crss_business_duebill.thirdparty2 is '(new)涉及第三方2';
comment on column ${idl_schema}.crss_business_duebill.thirdparty3 is '(new)涉及第三方3';
comment on column ${idl_schema}.crss_business_duebill.type1 is '通知行类别';
comment on column ${idl_schema}.crss_business_duebill.type2 is '受益行类别';
comment on column ${idl_schema}.crss_business_duebill.type3 is '议付行类别';
comment on column ${idl_schema}.crss_business_duebill.billno is '票据号';
comment on column ${idl_schema}.crss_business_duebill.flag1 is '(new)是否1';
comment on column ${idl_schema}.crss_business_duebill.flag2 is '(new)是否2';
comment on column ${idl_schema}.crss_business_duebill.flag3 is '(new)是否3';
comment on column ${idl_schema}.crss_business_duebill.thirdpartyregion is '涉及第三方所在地区和国家';
comment on column ${idl_schema}.crss_business_duebill.thirdpartyaccounts is '(new)第三方帐号';
comment on column ${idl_schema}.crss_business_duebill.cargoinfo is '(new)货物名称';
comment on column ${idl_schema}.crss_business_duebill.securitiestype is '(new)有价证券类型';
comment on column ${idl_schema}.crss_business_duebill.securitiesregion is '(new)有价证券发行地';
comment on column ${idl_schema}.crss_business_duebill.aboutbankid2 is '受益行行号';
comment on column ${idl_schema}.crss_business_duebill.aboutbankname2 is '受益行行名';
comment on column ${idl_schema}.crss_business_duebill.aboutbankid3 is '议付行行号';
comment on column ${idl_schema}.crss_business_duebill.aboutbankname is '收款行行名';
comment on column ${idl_schema}.crss_business_duebill.aboutbankid is '收款行行号';
comment on column ${idl_schema}.crss_business_duebill.oldlctermtype is '(new)原信用证期限类型';
comment on column ${idl_schema}.crss_business_duebill.negotiateno is '押汇编号';
comment on column ${idl_schema}.crss_business_duebill.creditkind is '贷款形式';
comment on column ${idl_schema}.crss_business_duebill.gatheringname is '收款人户名';
comment on column ${idl_schema}.crss_business_duebill.preinttype is '预收息标志';
comment on column ${idl_schema}.crss_business_duebill.resumeinttype is '计复息标志';
comment on column ${idl_schema}.crss_business_duebill.guarantyno is '抵质押物编号';
comment on column ${idl_schema}.crss_business_duebill.pztype is '凭证种类';
comment on column ${idl_schema}.crss_business_duebill.graceperiod is '还款宽限期(月)';
comment on column ${idl_schema}.crss_business_duebill.oldlcvaliddate is '(new)原信用证效期';
comment on column ${idl_schema}.crss_business_duebill.mfeepaymethod is '管理费支付方式';
comment on column ${idl_schema}.crss_business_duebill.describe1 is '描述1';
comment on column ${idl_schema}.crss_business_duebill.tradecontractno is '(new)相关贸易合同号';
comment on column ${idl_schema}.crss_business_duebill.loantype is '贷款类型';
comment on column ${idl_schema}.crss_business_duebill.fixterm is '周期';
comment on column ${idl_schema}.crss_business_duebill.cancelsum is '核销金额';
comment on column ${idl_schema}.crss_business_duebill.cancelinterest is '核销利息';
comment on column ${idl_schema}.crss_business_duebill.bailacount is '保证金帐号';
comment on column ${idl_schema}.crss_business_duebill.classify4 is '四级分类';
comment on column ${idl_schema}.crss_business_duebill.classifyresult is '五级分类结果';
comment on column ${idl_schema}.crss_business_duebill.returntype is '还款方式';
comment on column ${idl_schema}.crss_business_duebill.bailpercent is '保证金比例';
comment on column ${idl_schema}.crss_business_duebill.paymenttype is '信用证付款期限';
comment on column ${idl_schema}.crss_business_duebill.termsfreq is '还款频率';
comment on column ${idl_schema}.crss_business_duebill.overduedate is '逾期日期';
comment on column ${idl_schema}.crss_business_duebill.oweinterestdate is '欠息日期';
comment on column ${idl_schema}.crss_business_duebill.lcstatus is '信用证状态';
comment on column ${idl_schema}.crss_business_duebill.ichangedate is '变更时间';
comment on column ${idl_schema}.crss_business_duebill.vouchtype is '主要担保方式';
comment on column ${idl_schema}.crss_business_duebill.actualbusinessratefix is '初始执行年利率';
comment on column ${idl_schema}.crss_business_duebill.lastclassifyresult is '上期风险分类';
comment on column ${idl_schema}.crss_business_duebill.classifyresulteleven is '五级分类结果';
comment on column ${idl_schema}.crss_business_duebill.guaranteeno is '保函协议号';
comment on column ${idl_schema}.crss_business_duebill.surplusphases is '剩余期数';
comment on column ${idl_schema}.crss_business_duebill.eacmprincipal is '每期扣款额本金利息';
comment on column ${idl_schema}.crss_business_duebill.overduerate is '逾期利率';
comment on column ${idl_schema}.crss_business_duebill.mainorgid is '机构代号';
comment on column ${idl_schema}.crss_business_duebill.loanspecies is '贷款种类';
comment on column ${idl_schema}.crss_business_duebill.advanceflagsum is '受益人';
comment on column ${idl_schema}.crss_business_duebill.advanceflagno is '垫款借据号';
comment on column ${idl_schema}.crss_business_duebill.compensationsum is '赔付金额';
comment on column ${idl_schema}.crss_business_duebill.logouttype is '注销类型';
comment on column ${idl_schema}.crss_business_duebill.logoutno is '注销流水';
comment on column ${idl_schema}.crss_business_duebill.openno is '开立流水';
comment on column ${idl_schema}.crss_business_duebill.opendate is '开立日期';
comment on column ${idl_schema}.crss_business_duebill.premiumrate is '费率';
comment on column ${idl_schema}.crss_business_duebill.benefitcorpbank is '受益人开户行';
comment on column ${idl_schema}.crss_business_duebill.benefitcorpname is '受益人';
comment on column ${idl_schema}.crss_business_duebill.overdueinterest is '逾期利息';
comment on column ${idl_schema}.crss_business_duebill.fixflag is '补登借据标志';
comment on column ${idl_schema}.crss_business_duebill.intdate is '下一结息日';
comment on column ${idl_schema}.crss_business_duebill.accountbalance is '还款账号余额';
comment on column ${idl_schema}.crss_business_duebill.accountuserbalance is '还款账户可用余额';
comment on column ${idl_schema}.crss_business_duebill.termtype is '期限类型(短期、中长期)';
comment on column ${idl_schema}.crss_business_duebill.termmonthtype is '期限分段(三个月以内、三个月至六个月、六个月至一年、一年至两年、两年至三年、三年至五年、五年至十年、十年以上)';
comment on column ${idl_schema}.crss_business_duebill.insum is '累计归还本金';
comment on column ${idl_schema}.crss_business_duebill.interestinsum is '累计归还利息';
comment on column ${idl_schema}.crss_business_duebill.classifydate is '评级日期';
comment on column ${idl_schema}.crss_business_duebill.nextperiodreturnprincipaldate is '下一期还本日期';
comment on column ${idl_schema}.crss_business_duebill.nextperiodreturnprincipalsum is '下一期还本金额';
comment on column ${idl_schema}.crss_business_duebill.nextperiodreturninterestdate is '下一期还息日期';
comment on column ${idl_schema}.crss_business_duebill.nextperiodreturninterestsum is '下一期还息金额';
comment on column ${idl_schema}.crss_business_duebill.duebalance is '暂存借据余额';
comment on column ${idl_schema}.crss_business_duebill.balancechangedate is '借据余额变化日期';
comment on column ${idl_schema}.crss_business_duebill.oldictype is '原还款方式代码';
comment on column ${idl_schema}.crss_business_duebill.isinuse is '添加维护标志1正常2不维护';
comment on column ${idl_schema}.crss_business_duebill.dzhxstatus is '呆账核销状态 1-待核销 2-已核销';
comment on column ${idl_schema}.crss_business_duebill.hxtype is '核销类别 码值(DZHXType)';
comment on column ${idl_schema}.crss_business_duebill.hxinrate is '核销表内利息';
comment on column ${idl_schema}.crss_business_duebill.hxoutrate is '核销表外利息';
comment on column ${idl_schema}.crss_business_duebill.legal is '诉讼费';
comment on column ${idl_schema}.crss_business_duebill.reinforcechecker is '补登复核人';
comment on column ${idl_schema}.crss_business_duebill.batchno is '批量新增借据关键字段';
comment on column ${idl_schema}.crss_business_duebill.tcustomerid is '资金交易系统实际融资人客户编号';
comment on column ${idl_schema}.crss_business_duebill.tcustomername is '资金交易系统实际融资人客户名称';
comment on column ${idl_schema}.crss_business_duebill.transdate is '同业综合业务系统交易日期';
comment on column ${idl_schema}.crss_business_duebill.billtype is '票据类型';
comment on column ${idl_schema}.crss_business_duebill.billkind is '票据种类';
comment on column ${idl_schema}.crss_business_duebill.datatype is '批量数据来源（PJ.票据系统供数 LC.理财资管系统供数 ZJ.资金系统供数 ZH.同业综合业务系统供数）';
comment on column ${idl_schema}.crss_business_duebill.acceptbankid is '承兑行行号';
comment on column ${idl_schema}.crss_business_duebill.acceptbankname is '承兑行行名';
comment on column ${idl_schema}.crss_business_duebill.keyno is '票据唯一标识';
comment on column ${idl_schema}.crss_business_duebill.istran is '是否转让';
comment on column ${idl_schema}.crss_business_duebill.remart is '计量标记';
comment on column ${idl_schema}.crss_business_duebill.littlecreditstatus is '支小再状态';
comment on column ${idl_schema}.crss_business_duebill.reselltype is '01境内转让、02行内转让、03跨境转让';
comment on column ${idl_schema}.crss_business_duebill.ztrate is '转贴现利率';
comment on column ${idl_schema}.crss_business_duebill.ztacceptbankid is '';
comment on column ${idl_schema}.crss_business_duebill.ztacceptbankname is '';
comment on column ${idl_schema}.crss_business_duebill.start_dt is '开始日期';
comment on column ${idl_schema}.crss_business_duebill.end_dt is '结束日期';
comment on column ${idl_schema}.crss_business_duebill.id_mark is '删除标识';
comment on column ${idl_schema}.crss_business_duebill.etl_timestamp is '数据处理时间';