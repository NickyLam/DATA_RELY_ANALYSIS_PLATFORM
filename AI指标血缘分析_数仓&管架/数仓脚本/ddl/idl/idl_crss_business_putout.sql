/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crss_business_putout
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.crss_business_putout
whenever sqlerror continue none;
drop table ${idl_schema}.crss_business_putout purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.crss_business_putout(
    etl_dt date -- 数据日期   
    ,serialno varchar2(32) --    
    ,customerid varchar2(32) --    
    ,customername varchar2(80) --    
    ,businesstype varchar2(18) --    
    ,businesscurrency varchar2(18) --    
    ,businesssum number(24,6) --    
    ,termyear number --    
    ,termmonth number --    
    ,termday number --    
    ,putoutdate varchar2(10) --    
    ,maturity varchar2(10) --    
    ,businessrate number(10,6) --    
    ,ictype varchar2(18) --    
    ,iccyc varchar2(18) --    
    ,paycyc varchar2(18) --    
    ,corpuspaymethod varchar2(18) --    
    ,subjectno varchar2(20) --    
    ,dealbegintime varchar2(20) --    
    ,dealendtime varchar2(20) --    
    ,dealflag varchar2(1) --    
    ,operateorgid varchar2(32) --    
    ,operateuserid varchar2(32) --    
    ,operatedate varchar2(10) --    
    ,inputorgid varchar2(32) --    
    ,inputuserid varchar2(32) --    
    ,inputdate varchar2(10) --    
    ,updatedate varchar2(10) --    
    ,pigeonholedate varchar2(10) --    
    ,remark varchar2(200) --    
    ,occurdate varchar2(10) --    
    ,baseratetype varchar2(18) --    
    ,baserate number(24,6) --    
    ,ratefloattype varchar2(18) --    
    ,ratefloat number(24,6) --    
    ,contractserialno varchar2(32) --    
    ,duebillserialno varchar2(40) --    
    ,artificialno varchar2(64) --    
    ,relativeaccountno varchar2(32) --    
    ,accountno varchar2(40) --    
    ,loanaccountno varchar2(32) --    
    ,loantype varchar2(18) --    
    ,creditlineflag varchar2(18) --    
    ,creditaggreement varchar2(32) --    
    ,contractsum number(24,6) --    
    ,purpose varchar2(200) --    
    ,adjustratetype varchar2(18) --    
    ,fixcyc number --    
    ,backrate number(10,6) --    
    ,acceptinttype varchar2(18) --    
    ,preinttype varchar2(18) --    
    ,resumeinttype varchar2(18) --    
    ,secondpayaccount varchar2(32) --    
    ,overinttype varchar2(18) --    
    ,rateadjustcyc varchar2(18) --    
    ,guarantyno varchar2(32) --    
    ,riskrate number(24,6) --    
    ,consignaccountno varchar2(32) --    
    ,mostlyduebillno varchar2(32) --    
    ,negotiateno varchar2(32) --    
    ,creditkind varchar2(18) --    
    ,pdgsum number(24,6) --    
    ,pdgaccountno varchar2(32) --    
    ,pdgpaymethod varchar2(18) --    
    ,businesssubtype varchar2(18) --    
    ,businesssubtype1 varchar2(18) --    
    ,exchangetype varchar2(18) --    
    ,exchangestate varchar2(18) --    
    ,exchangeserialno varchar2(32) --    
    ,adjustrateterm varchar2(18) --    
    ,projectno varchar2(32) --    
    ,fzaccountno varchar2(32) --    
    ,fzanbalance number(24,6) --    
    ,ccode varchar2(32) --    
    ,cdate varchar2(10) --    
    ,fzguabalance number(24,6) --    
    ,pztype varchar2(18) --    
    ,billno varchar2(32) --    
    ,gatheringname varchar2(80) --    
    ,aboutbankname varchar2(80) --    
    ,interserialno varchar2(32) --    
    ,billresource varchar2(18) --    
    ,bailaccount varchar2(40) --    
    ,aboutbankid varchar2(32) --    
    ,billsum number(24,6) --    
    ,ratetype varchar2(18) --    
    ,billrisk number --    
    ,openbankname varchar2(80) -- 开证行行名/信用证下出口押汇出口信用证开证行   
    ,openbankadd varchar2(80) --    
    ,openbankzip varchar2(18) --    
    ,type1 varchar2(18) --    
    ,type2 varchar2(18) --    
    ,type3 varchar2(18) --    
    ,type4 varchar2(18) --    
    ,type5 varchar2(18) --    
    ,type6 varchar2(18) --    
    ,type7 varchar2(18) --    
    ,aboutbankid2 varchar2(32) --    
    ,aboutbankname2 varchar2(80) --    
    ,aboutbankid3 varchar2(32) --    
    ,name1 varchar2(80) --    
    ,address1 varchar2(80) --    
    ,name2 varchar2(80) --    
    ,address2 varchar2(80) --    
    ,zip2 varchar2(32) --    
    ,address3 varchar2(80) --    
    ,term1 varchar2(18) --    
    ,term2 varchar2(18) --    
    ,term3 varchar2(18) --    
    ,vouchtype varchar2(18) --    
    ,bailcurrency varchar2(18) --    
    ,bailratio number(24,6) --    
    ,mfeepaymethod varchar2(18) --    
    ,securitiestype varchar2(18) --    
    ,type8 varchar2(200) --    
    ,type9 varchar2(200) --    
    ,thirdpartyaccounts varchar2(32) --    
    ,thirdpartyid1 varchar2(32) --    
    ,ccyc varchar2(18) --    
    ,loanterm varchar2(18) --    
    ,relativeputoutno varchar2(32) --    
    ,printtimes number --    
    ,tempsaveflag varchar2(18) --    
    ,paymentmode varchar2(20) --    
    ,greenchannelflag varchar2(1) --    
    ,lowrisk varchar2(18) --    
    ,iswritecont varchar2(1) -- 是否签署授信合同   
    ,putoutorgid varchar2(32) -- 出账日期   
    ,principalaccountno varchar2(40) -- 委托存款账号   
    ,clientaccountno varchar2(40) -- 委托人存款账号   
    ,lendingorgid varchar2(80) -- 贷款机构   
    ,capitalreturnflag varchar2(1) -- 本金自动归还标志   
    ,interestreturnflag varchar2(1) -- 利息自动归还标志   
    ,rategenre varchar2(5) -- 利率重定价   
    ,installmentsmenthod varchar2(5) -- 分期贷款还款方式   
    ,overduefloat number(6,2) -- 逾期贷款利率浮动比例   
    ,overduerate number(11,7) -- 逾期贷款执行利率   
    ,period number(10) -- 分期贷款总期数   
    ,commitmentflag varchar2(1) -- 贷款承诺标志   
    ,commitmenttype varchar2(1) -- 承诺类型   
    ,principalsubaccountno varchar2(5) -- 委托存款子户号   
    ,paymenttype varchar2(1) -- 款项使用类型   
    ,compoundintflag varchar2(1) -- 是否收复息标志   
    ,termtype varchar2(5) -- 期限   
    ,pdgpaypercent number(6,2) -- 委托贷款手续费收取比例   
    ,corpuspaydate varchar2(10) -- 按揭还款日   
    ,purposetype varchar2(2) -- 用途   
    ,repaymentplanflag varchar2(1) -- 信贷发放还款计划标志   
    ,stopintflag varchar2(1) -- 是否停息   
    ,commissionpaysum number(18,2) -- 委托支付金额   
    ,loancommitmentno varchar2(30) -- 贷款承诺协议号   
    ,approveorgid varchar2(32) -- 复核机构   
    ,approveuserid varchar2(32) -- 复核人   
    ,approvedate varchar2(10) -- 复核日期   
    ,corpuspaymenthod varchar2(18) -- 还款方式   
    ,receiversubaccountno varchar2(5) -- 收款人子户号   
    ,receiveraccountno varchar2(40) -- 收款人账号   
    ,dischargesflag varchar2(1) -- 贴息标志   
    ,dischargesaccountno varchar2(40) -- 贴息人存款账号   
    ,dischargespercent number(10,2) -- 贴息比例   
    ,dischargesdate varchar2(10) -- 贴息到期日   
    ,exchangetime varchar2(20) -- 交易时间   
    ,bailsubaccount varchar2(5) -- 保证金子户号   
    ,bailsum number(18,2) -- 保证金金额   
    ,assureorgid varchar2(6) -- 担保机构   
    ,direction varchar2(18) --    
    ,bailterm varchar2(3) -- 保证金存期   
    ,bailexchangestate varchar2(2) -- 保证金交易状态   
    ,repayexchangestate varchar2(2) -- 还款计划交易状态   
    ,queryabnormitything varchar2(2) --    
    ,abnormitything varchar2(1000) --    
    ,loantermthing varchar2(2) --    
    ,fbsnumber varchar2(40) -- 国结系统编号（BP/AD/OC…)//进口押汇信用证号、进口代收押汇进口代收业务编号、信用证下出口押汇信用证通知号、打包放款信用证通知号、出口托收押汇出口托收业务编号、福费廷出口信用证通知号、短期出口信用保险项下押汇业务出口业务编号、国际贸易融资项下同业代付代付业务编号   
    ,invoicenumber varchar2(40) --    
    ,sfgksx varchar2(2) --    
    ,gksxpz varchar2(2) --    
    ,sfzfsx varchar2(2) --    
    ,zfsxlx varchar2(2) --    
    ,sfgjxzhy varchar2(2) --    
    ,gshy varchar2(2) --    
    ,dktx varchar2(2) --    
    ,commercetype varchar2(3) --    
    ,paymode varchar2(10) --    
    ,zfsxfs varchar2(2) --    
    ,paymodedesc varchar2(2000) --    
    ,isfinanceguarantee varchar2(1) --    
    ,accountnoorgname varchar2(80) --    
    ,accountnocustomer varchar2(80) --    
    ,loanaccountnocustomer varchar2(80) --    
    ,loanaccountnoorgname varchar2(80) --    
    ,operationtype varchar2(2) --    
    ,paysum number(24,6) -- 手续费   
    ,manualpay number(24,6) -- 工本费   
    ,keyno varchar2(40) -- 单笔票据唯一标示   
    ,billclass varchar2(16) -- 票据性质   
    ,billtype varchar2(16) -- 票据类型   
    ,careflag varchar2(1) -- 是否代保管   
    ,repurchaseflag varchar2(1) -- 是否回购（赎回）   
    ,discountsum number(24,6) -- 贴现利息   
    ,billbusinesstype varchar2(10) -- 业务种类   
    ,putoutno varchar2(40) -- 出账号   
    ,batchno varchar2(40) --    
    ,addcertificateflag varchar2(1) --    
    ,waitecertificateflag varchar2(1) --    
    ,otherdraweracctno varchar2(40) -- 第三方付息账户   
    ,othertxbalance number(24,6) -- 第三方付息金额   
    ,czflag varchar2(1) -- 冲账标志   
    ,lcsum number(24,6) -- 信用证金额   
    ,carbrand varchar2(100) --    
    ,cartype varchar2(100) --    
    ,carnumber varchar2(100) --    
    ,chariotnumber varchar2(100) --    
    ,motornumber varchar2(100) --    
    ,acptdate varchar2(10) --    
    ,interestmethod varchar2(10) -- 计息方法   
    ,interestrate number(24,6) -- 协议利率   
    ,bailmaturity varchar2(10) -- 保证金到期日   
    ,receivername varchar2(80) -- 收款人名称   
    ,isfromebank varchar2(1) -- 是否网银放款（1为是2等其他为否）   
    ,orginalduebill varchar2(40) -- 续贷业务对应的原借据   
    ,loankind varchar2(1) -- 贷款种类   
    ,tradeserialno1 varchar2(40) -- 国际贸易融资业务相关编号(信用证项下出口押汇出口信用证号（开证行信用证编号）、打包放款信用证号、进口T/T融资进口T/T业务编号、出口T/T融资出口T/T业务编号、福费廷出口信用证号)   
    ,tradeserialno2 varchar2(40) -- 国际贸易融资业务相关编号(进口押汇来单号、信用证下出口押汇出口信用证寄单号、打包放款出口信用证寄单号、福费廷出口寄单编号、)   
    ,tradecurrecy1 varchar2(18) -- 国际贸易融资业务相关币种（进口押汇来单币种、进口代收押汇来单币种、进口T/T押汇汇款币种、信用证下出口押汇索汇币种、打包放款信用证币种、出口托收押汇托收币种、福费廷索汇币种、）   
    ,tradecurrecy2 varchar2(18) -- 国际贸易融资业务相关币种（进口代收押汇押汇币种、进口T/T押汇融资币种、出口T/T押汇融资币种、信用证下出口押汇押汇币种、打包放款融资币种、出口托收押汇押汇币种、福费廷承兑币种、出口退税帐户托管融资业务融资币种、国际贸易融资项下同业代付代付币种）   
    ,tradecurrecy3 varchar2(18) -- 国际贸易融资业务相关币种（出口T/T押汇发票币种、福费廷贴现币种、出口退税帐户托管融资业务应退未退金额币种、国际贸易融资项下同业代付汇票币种（来单或发票币种））   
    ,tradesum1 number(24,6) -- 国际贸易融资业务相关金额（进口押汇来单金额（待付款金额、汇票金额）、进口代收押汇单据金额（待付款金额）、进口T/T押汇汇款金额、信用证下出口押汇索汇金额、打包放款信用证金额、出口托收押汇托收金额、福费廷索汇金额、短期出口信用保险项下押汇业务押汇金额、）   
    ,tradesum2 number(24,6) -- 国际贸易融资业务相关金额（进口代收押汇押汇金额、进口T/T押汇融资金额、出口T/T押汇融资金额、信用证下出口押汇押汇金额、打包放款融资金额、出口托收押汇押汇金额、福费廷承兑金额、出口退税帐户托管融资业务融资金额、短期出口信用保险项下押汇业务出运货物申报金额、国际贸易融资项下同业代付代付金额、）   
    ,tradesum3 number(24,6) -- 国际贸易融资业务相关金额（出口T/T押汇发票金额、福费廷贴现金额、出口退税帐户托管融资业务应退未退金额、短期出口信用保险项下押汇业务信用限额余额、国际贸易融资项下同业代付汇票金额（来单或发票金额））   
    ,tradedate1 varchar2(20) -- 国际贸易融资业务相关日期（进口押汇来单付款日、信用证下出口押汇信用证付款日、出口托收押汇D/A到期付款日（如果托收类型选择D/A）、福费廷信用证到期付款日、国际贸易融资项下同业代付代付起息日、）   
    ,tradedate2 varchar2(20) -- 国际贸易融资业务相关日期（信用证下出口押汇远期信用证到期付款日、福费廷远期信用证到期付款日、）   
    ,tradetermmonth1 number -- 国际贸易融资业务相关期限（进口押汇信用证付款期限、进口代收押汇D/A代收期限（如果托收类型选择D/A）、进口T/T押汇融资期限、出口T/T押汇融资期限、打包放款信用证期限、福费廷贴现天数、短期出口信用保险项下押汇业务押汇期限、）   
    ,tradetermmonth2 number -- 国际贸易融资业务相关期限（进口押汇押汇期限、进口代收押汇押汇期限、出口T/T押汇出口合同付款期限、信用证下出口押汇押汇期限、打包放款融资期限、出口托收押汇押汇期限、福费廷融资期限、出口退税帐户托管融资业务融资期限、）   
    ,tradetermmonth3 number -- 国际贸易融资业务相关期限（国际贸易融资项下同业代付代付期限）   
    ,traderate1 number(10,6) -- 福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）   
    ,traderate2 number(10,6) -- 出口退税帐户托管融资业务融资比例、短期出口信用保险项下押汇业务赔偿比例、   
    ,tradetype1 varchar2(18) -- 进口代收押汇代收类型（D/A或D/P）、出口托收押汇托收类型（D/A或D/P）   
    ,bfintg varchar2(1) -- 先付利息摊销标志   
    ,paybankname varchar2(100) -- 国际贸易融资项下同业代付代付行   
    ,isinuse varchar2(1) -- 添加维护标志1正常2不维护   
    ,bailtransaccount varchar2(40) --    
    ,daynum number -- 单笔透支有效天数   
    ,lncmam number(24,6) -- 透支承诺费   
    ,ovdrmi number(24,6) -- 起透金额   
    ,loanam number(24,6) -- 透支额度   
    ,accountno1 varchar2(40) -- 透支账户账号   
    ,oblopt varchar2(1) -- 使用余额选择   
    ,bengdt varchar2(1) -- 业务提醒短信发送时机   
    ,lontyp varchar2(1) -- 透支贷款方式   
    ,odrputoutdate varchar2(10) -- 法透额度起始日   
    ,odrmaturity varchar2(10) -- 法透额度到期日   
    ,whitelist varchar2(3000) -- 法人透支白名单   
    ,putoutcontrol varchar2(1) -- 到日期超批复半年设置，1允许，0禁止   
    ,txregister varchar2(2) -- 纸票贴现登记状态：0 未登记，1 已登记   
    ,loantermcontrolflag varchar2(1) -- 出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验   
    ,acceptor varchar2(180) -- 承兑人名称   
    ,acceptorbankno varchar2(12) -- 承兑人开户行号   
    ,acceptorbankname varchar2(180) -- 承兑人开户行名称   
    ,fxfltp varchar2(1) -- 利率类型（核心xdfrzf、cdjzjk加）   
    ,pdrifd varchar2(3) -- 利率浮动类型   
    ,pdrifm varchar2(1) -- 利率浮动方式   
    ,pdrifv number(11,7) -- 浮动值   
    ,jxhjduebillno varchar2(40) -- 借新还旧的某笔旧借据   
    ,odrnextmonth varchar2(1) -- 法透不跨月 1-是   
    ,odrfreeinterest number -- 法透不跨月免息天数   
    ,amorfg varchar2(1) -- 手续费是否摊销   
    ,trantp varchar2(2) -- 手续费收费方式   
    ,amorsq varchar2(40) -- 摊销流水号   
    ,exchangedate varchar2(10) -- 承兑记账交易日期   
    ,exchangeno varchar2(32) -- 承兑记账交易流水号   
    ,isrz varchar2(2) -- 是否融资系统出账 1是0否   
    ,financier varchar2(32) -- 实际融资人   
    ,hxtycapitalsource varchar2(4) -- 同业资金来源   
    ,adjustratedate number(10) -- 利率调整日   
    ,countbasis varchar2(20) -- 计息基础   
    ,bigcreditbankid varchar2(100) -- 大额支付行号   
    ,principalaccountname varchar2(40) -- 放款账户名称   
    ,principalbankname varchar2(40) -- 放款账户开户行名称   
    ,accountindir varchar2(180) -- 开户行地址号   
    ,ret_msg varchar2(2000) -- 开户行地址名称   
    ,clearingtype varchar2(10) --    
    ,ishxbank varchar2(2) -- 是否本行   
    ,hxtypurpose varchar2(2000) -- 用途(手工输入,非标标准出账业务)   
    ,remart varchar2(100) -- 计量标记   
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
grant select on ${idl_schema}.crss_business_putout to ${iel_schema};

-- comment
comment on table ${idl_schema}.crss_business_putout is '业务出帐通知单';
comment on column ${idl_schema}.crss_business_putout.etl_dt is '数据日期';
comment on column ${idl_schema}.crss_business_putout.serialno is '';
comment on column ${idl_schema}.crss_business_putout.customerid is '';
comment on column ${idl_schema}.crss_business_putout.customername is '';
comment on column ${idl_schema}.crss_business_putout.businesstype is '';
comment on column ${idl_schema}.crss_business_putout.businesscurrency is '';
comment on column ${idl_schema}.crss_business_putout.businesssum is '';
comment on column ${idl_schema}.crss_business_putout.termyear is '';
comment on column ${idl_schema}.crss_business_putout.termmonth is '';
comment on column ${idl_schema}.crss_business_putout.termday is '';
comment on column ${idl_schema}.crss_business_putout.putoutdate is '';
comment on column ${idl_schema}.crss_business_putout.maturity is '';
comment on column ${idl_schema}.crss_business_putout.businessrate is '';
comment on column ${idl_schema}.crss_business_putout.ictype is '';
comment on column ${idl_schema}.crss_business_putout.iccyc is '';
comment on column ${idl_schema}.crss_business_putout.paycyc is '';
comment on column ${idl_schema}.crss_business_putout.corpuspaymethod is '';
comment on column ${idl_schema}.crss_business_putout.subjectno is '';
comment on column ${idl_schema}.crss_business_putout.dealbegintime is '';
comment on column ${idl_schema}.crss_business_putout.dealendtime is '';
comment on column ${idl_schema}.crss_business_putout.dealflag is '';
comment on column ${idl_schema}.crss_business_putout.operateorgid is '';
comment on column ${idl_schema}.crss_business_putout.operateuserid is '';
comment on column ${idl_schema}.crss_business_putout.operatedate is '';
comment on column ${idl_schema}.crss_business_putout.inputorgid is '';
comment on column ${idl_schema}.crss_business_putout.inputuserid is '';
comment on column ${idl_schema}.crss_business_putout.inputdate is '';
comment on column ${idl_schema}.crss_business_putout.updatedate is '';
comment on column ${idl_schema}.crss_business_putout.pigeonholedate is '';
comment on column ${idl_schema}.crss_business_putout.remark is '';
comment on column ${idl_schema}.crss_business_putout.occurdate is '';
comment on column ${idl_schema}.crss_business_putout.baseratetype is '';
comment on column ${idl_schema}.crss_business_putout.baserate is '';
comment on column ${idl_schema}.crss_business_putout.ratefloattype is '';
comment on column ${idl_schema}.crss_business_putout.ratefloat is '';
comment on column ${idl_schema}.crss_business_putout.contractserialno is '';
comment on column ${idl_schema}.crss_business_putout.duebillserialno is '';
comment on column ${idl_schema}.crss_business_putout.artificialno is '';
comment on column ${idl_schema}.crss_business_putout.relativeaccountno is '';
comment on column ${idl_schema}.crss_business_putout.accountno is '';
comment on column ${idl_schema}.crss_business_putout.loanaccountno is '';
comment on column ${idl_schema}.crss_business_putout.loantype is '';
comment on column ${idl_schema}.crss_business_putout.creditlineflag is '';
comment on column ${idl_schema}.crss_business_putout.creditaggreement is '';
comment on column ${idl_schema}.crss_business_putout.contractsum is '';
comment on column ${idl_schema}.crss_business_putout.purpose is '';
comment on column ${idl_schema}.crss_business_putout.adjustratetype is '';
comment on column ${idl_schema}.crss_business_putout.fixcyc is '';
comment on column ${idl_schema}.crss_business_putout.backrate is '';
comment on column ${idl_schema}.crss_business_putout.acceptinttype is '';
comment on column ${idl_schema}.crss_business_putout.preinttype is '';
comment on column ${idl_schema}.crss_business_putout.resumeinttype is '';
comment on column ${idl_schema}.crss_business_putout.secondpayaccount is '';
comment on column ${idl_schema}.crss_business_putout.overinttype is '';
comment on column ${idl_schema}.crss_business_putout.rateadjustcyc is '';
comment on column ${idl_schema}.crss_business_putout.guarantyno is '';
comment on column ${idl_schema}.crss_business_putout.riskrate is '';
comment on column ${idl_schema}.crss_business_putout.consignaccountno is '';
comment on column ${idl_schema}.crss_business_putout.mostlyduebillno is '';
comment on column ${idl_schema}.crss_business_putout.negotiateno is '';
comment on column ${idl_schema}.crss_business_putout.creditkind is '';
comment on column ${idl_schema}.crss_business_putout.pdgsum is '';
comment on column ${idl_schema}.crss_business_putout.pdgaccountno is '';
comment on column ${idl_schema}.crss_business_putout.pdgpaymethod is '';
comment on column ${idl_schema}.crss_business_putout.businesssubtype is '';
comment on column ${idl_schema}.crss_business_putout.businesssubtype1 is '';
comment on column ${idl_schema}.crss_business_putout.exchangetype is '';
comment on column ${idl_schema}.crss_business_putout.exchangestate is '';
comment on column ${idl_schema}.crss_business_putout.exchangeserialno is '';
comment on column ${idl_schema}.crss_business_putout.adjustrateterm is '';
comment on column ${idl_schema}.crss_business_putout.projectno is '';
comment on column ${idl_schema}.crss_business_putout.fzaccountno is '';
comment on column ${idl_schema}.crss_business_putout.fzanbalance is '';
comment on column ${idl_schema}.crss_business_putout.ccode is '';
comment on column ${idl_schema}.crss_business_putout.cdate is '';
comment on column ${idl_schema}.crss_business_putout.fzguabalance is '';
comment on column ${idl_schema}.crss_business_putout.pztype is '';
comment on column ${idl_schema}.crss_business_putout.billno is '';
comment on column ${idl_schema}.crss_business_putout.gatheringname is '';
comment on column ${idl_schema}.crss_business_putout.aboutbankname is '';
comment on column ${idl_schema}.crss_business_putout.interserialno is '';
comment on column ${idl_schema}.crss_business_putout.billresource is '';
comment on column ${idl_schema}.crss_business_putout.bailaccount is '';
comment on column ${idl_schema}.crss_business_putout.aboutbankid is '';
comment on column ${idl_schema}.crss_business_putout.billsum is '';
comment on column ${idl_schema}.crss_business_putout.ratetype is '';
comment on column ${idl_schema}.crss_business_putout.billrisk is '';
comment on column ${idl_schema}.crss_business_putout.openbankname is '开证行行名/信用证下出口押汇出口信用证开证行';
comment on column ${idl_schema}.crss_business_putout.openbankadd is '';
comment on column ${idl_schema}.crss_business_putout.openbankzip is '';
comment on column ${idl_schema}.crss_business_putout.type1 is '';
comment on column ${idl_schema}.crss_business_putout.type2 is '';
comment on column ${idl_schema}.crss_business_putout.type3 is '';
comment on column ${idl_schema}.crss_business_putout.type4 is '';
comment on column ${idl_schema}.crss_business_putout.type5 is '';
comment on column ${idl_schema}.crss_business_putout.type6 is '';
comment on column ${idl_schema}.crss_business_putout.type7 is '';
comment on column ${idl_schema}.crss_business_putout.aboutbankid2 is '';
comment on column ${idl_schema}.crss_business_putout.aboutbankname2 is '';
comment on column ${idl_schema}.crss_business_putout.aboutbankid3 is '';
comment on column ${idl_schema}.crss_business_putout.name1 is '';
comment on column ${idl_schema}.crss_business_putout.address1 is '';
comment on column ${idl_schema}.crss_business_putout.name2 is '';
comment on column ${idl_schema}.crss_business_putout.address2 is '';
comment on column ${idl_schema}.crss_business_putout.zip2 is '';
comment on column ${idl_schema}.crss_business_putout.address3 is '';
comment on column ${idl_schema}.crss_business_putout.term1 is '';
comment on column ${idl_schema}.crss_business_putout.term2 is '';
comment on column ${idl_schema}.crss_business_putout.term3 is '';
comment on column ${idl_schema}.crss_business_putout.vouchtype is '';
comment on column ${idl_schema}.crss_business_putout.bailcurrency is '';
comment on column ${idl_schema}.crss_business_putout.bailratio is '';
comment on column ${idl_schema}.crss_business_putout.mfeepaymethod is '';
comment on column ${idl_schema}.crss_business_putout.securitiestype is '';
comment on column ${idl_schema}.crss_business_putout.type8 is '';
comment on column ${idl_schema}.crss_business_putout.type9 is '';
comment on column ${idl_schema}.crss_business_putout.thirdpartyaccounts is '';
comment on column ${idl_schema}.crss_business_putout.thirdpartyid1 is '';
comment on column ${idl_schema}.crss_business_putout.ccyc is '';
comment on column ${idl_schema}.crss_business_putout.loanterm is '';
comment on column ${idl_schema}.crss_business_putout.relativeputoutno is '';
comment on column ${idl_schema}.crss_business_putout.printtimes is '';
comment on column ${idl_schema}.crss_business_putout.tempsaveflag is '';
comment on column ${idl_schema}.crss_business_putout.paymentmode is '';
comment on column ${idl_schema}.crss_business_putout.greenchannelflag is '';
comment on column ${idl_schema}.crss_business_putout.lowrisk is '';
comment on column ${idl_schema}.crss_business_putout.iswritecont is '是否签署授信合同';
comment on column ${idl_schema}.crss_business_putout.putoutorgid is '出账日期';
comment on column ${idl_schema}.crss_business_putout.principalaccountno is '委托存款账号';
comment on column ${idl_schema}.crss_business_putout.clientaccountno is '委托人存款账号';
comment on column ${idl_schema}.crss_business_putout.lendingorgid is '贷款机构';
comment on column ${idl_schema}.crss_business_putout.capitalreturnflag is '本金自动归还标志';
comment on column ${idl_schema}.crss_business_putout.interestreturnflag is '利息自动归还标志';
comment on column ${idl_schema}.crss_business_putout.rategenre is '利率重定价';
comment on column ${idl_schema}.crss_business_putout.installmentsmenthod is '分期贷款还款方式';
comment on column ${idl_schema}.crss_business_putout.overduefloat is '逾期贷款利率浮动比例';
comment on column ${idl_schema}.crss_business_putout.overduerate is '逾期贷款执行利率';
comment on column ${idl_schema}.crss_business_putout.period is '分期贷款总期数';
comment on column ${idl_schema}.crss_business_putout.commitmentflag is '贷款承诺标志';
comment on column ${idl_schema}.crss_business_putout.commitmenttype is '承诺类型';
comment on column ${idl_schema}.crss_business_putout.principalsubaccountno is '委托存款子户号';
comment on column ${idl_schema}.crss_business_putout.paymenttype is '款项使用类型';
comment on column ${idl_schema}.crss_business_putout.compoundintflag is '是否收复息标志';
comment on column ${idl_schema}.crss_business_putout.termtype is '期限';
comment on column ${idl_schema}.crss_business_putout.pdgpaypercent is '委托贷款手续费收取比例';
comment on column ${idl_schema}.crss_business_putout.corpuspaydate is '按揭还款日';
comment on column ${idl_schema}.crss_business_putout.purposetype is '用途';
comment on column ${idl_schema}.crss_business_putout.repaymentplanflag is '信贷发放还款计划标志';
comment on column ${idl_schema}.crss_business_putout.stopintflag is '是否停息';
comment on column ${idl_schema}.crss_business_putout.commissionpaysum is '委托支付金额';
comment on column ${idl_schema}.crss_business_putout.loancommitmentno is '贷款承诺协议号';
comment on column ${idl_schema}.crss_business_putout.approveorgid is '复核机构';
comment on column ${idl_schema}.crss_business_putout.approveuserid is '复核人';
comment on column ${idl_schema}.crss_business_putout.approvedate is '复核日期';
comment on column ${idl_schema}.crss_business_putout.corpuspaymenthod is '还款方式';
comment on column ${idl_schema}.crss_business_putout.receiversubaccountno is '收款人子户号';
comment on column ${idl_schema}.crss_business_putout.receiveraccountno is '收款人账号';
comment on column ${idl_schema}.crss_business_putout.dischargesflag is '贴息标志';
comment on column ${idl_schema}.crss_business_putout.dischargesaccountno is '贴息人存款账号';
comment on column ${idl_schema}.crss_business_putout.dischargespercent is '贴息比例';
comment on column ${idl_schema}.crss_business_putout.dischargesdate is '贴息到期日';
comment on column ${idl_schema}.crss_business_putout.exchangetime is '交易时间';
comment on column ${idl_schema}.crss_business_putout.bailsubaccount is '保证金子户号';
comment on column ${idl_schema}.crss_business_putout.bailsum is '保证金金额';
comment on column ${idl_schema}.crss_business_putout.assureorgid is '担保机构';
comment on column ${idl_schema}.crss_business_putout.direction is '';
comment on column ${idl_schema}.crss_business_putout.bailterm is '保证金存期';
comment on column ${idl_schema}.crss_business_putout.bailexchangestate is '保证金交易状态';
comment on column ${idl_schema}.crss_business_putout.repayexchangestate is '还款计划交易状态';
comment on column ${idl_schema}.crss_business_putout.queryabnormitything is '';
comment on column ${idl_schema}.crss_business_putout.abnormitything is '';
comment on column ${idl_schema}.crss_business_putout.loantermthing is '';
comment on column ${idl_schema}.crss_business_putout.fbsnumber is '国结系统编号（BP/AD/OC…)//进口押汇信用证号、进口代收押汇进口代收业务编号、信用证下出口押汇信用证通知号、打包放款信用证通知号、出口托收押汇出口托收业务编号、福费廷出口信用证通知号、短期出口信用保险项下押汇业务出口业务编号、国际贸易融资项下同业代付代付业务编号';
comment on column ${idl_schema}.crss_business_putout.invoicenumber is '';
comment on column ${idl_schema}.crss_business_putout.sfgksx is '';
comment on column ${idl_schema}.crss_business_putout.gksxpz is '';
comment on column ${idl_schema}.crss_business_putout.sfzfsx is '';
comment on column ${idl_schema}.crss_business_putout.zfsxlx is '';
comment on column ${idl_schema}.crss_business_putout.sfgjxzhy is '';
comment on column ${idl_schema}.crss_business_putout.gshy is '';
comment on column ${idl_schema}.crss_business_putout.dktx is '';
comment on column ${idl_schema}.crss_business_putout.commercetype is '';
comment on column ${idl_schema}.crss_business_putout.paymode is '';
comment on column ${idl_schema}.crss_business_putout.zfsxfs is '';
comment on column ${idl_schema}.crss_business_putout.paymodedesc is '';
comment on column ${idl_schema}.crss_business_putout.isfinanceguarantee is '';
comment on column ${idl_schema}.crss_business_putout.accountnoorgname is '';
comment on column ${idl_schema}.crss_business_putout.accountnocustomer is '';
comment on column ${idl_schema}.crss_business_putout.loanaccountnocustomer is '';
comment on column ${idl_schema}.crss_business_putout.loanaccountnoorgname is '';
comment on column ${idl_schema}.crss_business_putout.operationtype is '';
comment on column ${idl_schema}.crss_business_putout.paysum is '手续费';
comment on column ${idl_schema}.crss_business_putout.manualpay is '工本费';
comment on column ${idl_schema}.crss_business_putout.keyno is '单笔票据唯一标示';
comment on column ${idl_schema}.crss_business_putout.billclass is '票据性质';
comment on column ${idl_schema}.crss_business_putout.billtype is '票据类型';
comment on column ${idl_schema}.crss_business_putout.careflag is '是否代保管';
comment on column ${idl_schema}.crss_business_putout.repurchaseflag is '是否回购（赎回）';
comment on column ${idl_schema}.crss_business_putout.discountsum is '贴现利息';
comment on column ${idl_schema}.crss_business_putout.billbusinesstype is '业务种类';
comment on column ${idl_schema}.crss_business_putout.putoutno is '出账号';
comment on column ${idl_schema}.crss_business_putout.batchno is '';
comment on column ${idl_schema}.crss_business_putout.addcertificateflag is '';
comment on column ${idl_schema}.crss_business_putout.waitecertificateflag is '';
comment on column ${idl_schema}.crss_business_putout.otherdraweracctno is '第三方付息账户';
comment on column ${idl_schema}.crss_business_putout.othertxbalance is '第三方付息金额';
comment on column ${idl_schema}.crss_business_putout.czflag is '冲账标志';
comment on column ${idl_schema}.crss_business_putout.lcsum is '信用证金额';
comment on column ${idl_schema}.crss_business_putout.carbrand is '';
comment on column ${idl_schema}.crss_business_putout.cartype is '';
comment on column ${idl_schema}.crss_business_putout.carnumber is '';
comment on column ${idl_schema}.crss_business_putout.chariotnumber is '';
comment on column ${idl_schema}.crss_business_putout.motornumber is '';
comment on column ${idl_schema}.crss_business_putout.acptdate is '';
comment on column ${idl_schema}.crss_business_putout.interestmethod is '计息方法';
comment on column ${idl_schema}.crss_business_putout.interestrate is '协议利率';
comment on column ${idl_schema}.crss_business_putout.bailmaturity is '保证金到期日';
comment on column ${idl_schema}.crss_business_putout.receivername is '收款人名称';
comment on column ${idl_schema}.crss_business_putout.isfromebank is '是否网银放款（1为是2等其他为否）';
comment on column ${idl_schema}.crss_business_putout.orginalduebill is '续贷业务对应的原借据';
comment on column ${idl_schema}.crss_business_putout.loankind is '贷款种类';
comment on column ${idl_schema}.crss_business_putout.tradeserialno1 is '国际贸易融资业务相关编号(信用证项下出口押汇出口信用证号（开证行信用证编号）、打包放款信用证号、进口T/T融资进口T/T业务编号、出口T/T融资出口T/T业务编号、福费廷出口信用证号)';
comment on column ${idl_schema}.crss_business_putout.tradeserialno2 is '国际贸易融资业务相关编号(进口押汇来单号、信用证下出口押汇出口信用证寄单号、打包放款出口信用证寄单号、福费廷出口寄单编号、)';
comment on column ${idl_schema}.crss_business_putout.tradecurrecy1 is '国际贸易融资业务相关币种（进口押汇来单币种、进口代收押汇来单币种、进口T/T押汇汇款币种、信用证下出口押汇索汇币种、打包放款信用证币种、出口托收押汇托收币种、福费廷索汇币种、）';
comment on column ${idl_schema}.crss_business_putout.tradecurrecy2 is '国际贸易融资业务相关币种（进口代收押汇押汇币种、进口T/T押汇融资币种、出口T/T押汇融资币种、信用证下出口押汇押汇币种、打包放款融资币种、出口托收押汇押汇币种、福费廷承兑币种、出口退税帐户托管融资业务融资币种、国际贸易融资项下同业代付代付币种）';
comment on column ${idl_schema}.crss_business_putout.tradecurrecy3 is '国际贸易融资业务相关币种（出口T/T押汇发票币种、福费廷贴现币种、出口退税帐户托管融资业务应退未退金额币种、国际贸易融资项下同业代付汇票币种（来单或发票币种））';
comment on column ${idl_schema}.crss_business_putout.tradesum1 is '国际贸易融资业务相关金额（进口押汇来单金额（待付款金额、汇票金额）、进口代收押汇单据金额（待付款金额）、进口T/T押汇汇款金额、信用证下出口押汇索汇金额、打包放款信用证金额、出口托收押汇托收金额、福费廷索汇金额、短期出口信用保险项下押汇业务押汇金额、）';
comment on column ${idl_schema}.crss_business_putout.tradesum2 is '国际贸易融资业务相关金额（进口代收押汇押汇金额、进口T/T押汇融资金额、出口T/T押汇融资金额、信用证下出口押汇押汇金额、打包放款融资金额、出口托收押汇押汇金额、福费廷承兑金额、出口退税帐户托管融资业务融资金额、短期出口信用保险项下押汇业务出运货物申报金额、国际贸易融资项下同业代付代付金额、）';
comment on column ${idl_schema}.crss_business_putout.tradesum3 is '国际贸易融资业务相关金额（出口T/T押汇发票金额、福费廷贴现金额、出口退税帐户托管融资业务应退未退金额、短期出口信用保险项下押汇业务信用限额余额、国际贸易融资项下同业代付汇票金额（来单或发票金额））';
comment on column ${idl_schema}.crss_business_putout.tradedate1 is '国际贸易融资业务相关日期（进口押汇来单付款日、信用证下出口押汇信用证付款日、出口托收押汇D/A到期付款日（如果托收类型选择D/A）、福费廷信用证到期付款日、国际贸易融资项下同业代付代付起息日、）';
comment on column ${idl_schema}.crss_business_putout.tradedate2 is '国际贸易融资业务相关日期（信用证下出口押汇远期信用证到期付款日、福费廷远期信用证到期付款日、）';
comment on column ${idl_schema}.crss_business_putout.tradetermmonth1 is '国际贸易融资业务相关期限（进口押汇信用证付款期限、进口代收押汇D/A代收期限（如果托收类型选择D/A）、进口T/T押汇融资期限、出口T/T押汇融资期限、打包放款信用证期限、福费廷贴现天数、短期出口信用保险项下押汇业务押汇期限、）';
comment on column ${idl_schema}.crss_business_putout.tradetermmonth2 is '国际贸易融资业务相关期限（进口押汇押汇期限、进口代收押汇押汇期限、出口T/T押汇出口合同付款期限、信用证下出口押汇押汇期限、打包放款融资期限、出口托收押汇押汇期限、福费廷融资期限、出口退税帐户托管融资业务融资期限、）';
comment on column ${idl_schema}.crss_business_putout.tradetermmonth3 is '国际贸易融资业务相关期限（国际贸易融资项下同业代付代付期限）';
comment on column ${idl_schema}.crss_business_putout.traderate1 is '福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）';
comment on column ${idl_schema}.crss_business_putout.traderate2 is '出口退税帐户托管融资业务融资比例、短期出口信用保险项下押汇业务赔偿比例、';
comment on column ${idl_schema}.crss_business_putout.tradetype1 is '进口代收押汇代收类型（D/A或D/P）、出口托收押汇托收类型（D/A或D/P）';
comment on column ${idl_schema}.crss_business_putout.bfintg is '先付利息摊销标志';
comment on column ${idl_schema}.crss_business_putout.paybankname is '国际贸易融资项下同业代付代付行';
comment on column ${idl_schema}.crss_business_putout.isinuse is '添加维护标志1正常2不维护';
comment on column ${idl_schema}.crss_business_putout.bailtransaccount is '';
comment on column ${idl_schema}.crss_business_putout.daynum is '单笔透支有效天数';
comment on column ${idl_schema}.crss_business_putout.lncmam is '透支承诺费';
comment on column ${idl_schema}.crss_business_putout.ovdrmi is '起透金额';
comment on column ${idl_schema}.crss_business_putout.loanam is '透支额度';
comment on column ${idl_schema}.crss_business_putout.accountno1 is '透支账户账号';
comment on column ${idl_schema}.crss_business_putout.oblopt is '使用余额选择';
comment on column ${idl_schema}.crss_business_putout.bengdt is '业务提醒短信发送时机';
comment on column ${idl_schema}.crss_business_putout.lontyp is '透支贷款方式';
comment on column ${idl_schema}.crss_business_putout.odrputoutdate is '法透额度起始日';
comment on column ${idl_schema}.crss_business_putout.odrmaturity is '法透额度到期日';
comment on column ${idl_schema}.crss_business_putout.whitelist is '法人透支白名单';
comment on column ${idl_schema}.crss_business_putout.putoutcontrol is '到日期超批复半年设置，1允许，0禁止';
comment on column ${idl_schema}.crss_business_putout.txregister is '纸票贴现登记状态：0 未登记，1 已登记';
comment on column ${idl_schema}.crss_business_putout.loantermcontrolflag is '出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验';
comment on column ${idl_schema}.crss_business_putout.acceptor is '承兑人名称';
comment on column ${idl_schema}.crss_business_putout.acceptorbankno is '承兑人开户行号';
comment on column ${idl_schema}.crss_business_putout.acceptorbankname is '承兑人开户行名称';
comment on column ${idl_schema}.crss_business_putout.fxfltp is '利率类型（核心xdfrzf、cdjzjk加）';
comment on column ${idl_schema}.crss_business_putout.pdrifd is '利率浮动类型';
comment on column ${idl_schema}.crss_business_putout.pdrifm is '利率浮动方式';
comment on column ${idl_schema}.crss_business_putout.pdrifv is '浮动值';
comment on column ${idl_schema}.crss_business_putout.jxhjduebillno is '借新还旧的某笔旧借据';
comment on column ${idl_schema}.crss_business_putout.odrnextmonth is '法透不跨月 1-是';
comment on column ${idl_schema}.crss_business_putout.odrfreeinterest is '法透不跨月免息天数';
comment on column ${idl_schema}.crss_business_putout.amorfg is '手续费是否摊销';
comment on column ${idl_schema}.crss_business_putout.trantp is '手续费收费方式';
comment on column ${idl_schema}.crss_business_putout.amorsq is '摊销流水号';
comment on column ${idl_schema}.crss_business_putout.exchangedate is '承兑记账交易日期';
comment on column ${idl_schema}.crss_business_putout.exchangeno is '承兑记账交易流水号';
comment on column ${idl_schema}.crss_business_putout.isrz is '是否融资系统出账 1是0否';
comment on column ${idl_schema}.crss_business_putout.financier is '实际融资人';
comment on column ${idl_schema}.crss_business_putout.hxtycapitalsource is '同业资金来源';
comment on column ${idl_schema}.crss_business_putout.adjustratedate is '利率调整日';
comment on column ${idl_schema}.crss_business_putout.countbasis is '计息基础';
comment on column ${idl_schema}.crss_business_putout.bigcreditbankid is '大额支付行号';
comment on column ${idl_schema}.crss_business_putout.principalaccountname is '放款账户名称';
comment on column ${idl_schema}.crss_business_putout.principalbankname is '放款账户开户行名称';
comment on column ${idl_schema}.crss_business_putout.accountindir is '开户行地址号';
comment on column ${idl_schema}.crss_business_putout.ret_msg is '开户行地址名称';
comment on column ${idl_schema}.crss_business_putout.clearingtype is '';
comment on column ${idl_schema}.crss_business_putout.ishxbank is '是否本行';
comment on column ${idl_schema}.crss_business_putout.hxtypurpose is '用途(手工输入,非标标准出账业务)';
comment on column ${idl_schema}.crss_business_putout.remart is '计量标记';
comment on column ${idl_schema}.crss_business_putout.start_dt is '开始日期';
comment on column ${idl_schema}.crss_business_putout.end_dt is '结束日期';
comment on column ${idl_schema}.crss_business_putout.id_mark is '删除标识';
comment on column ${idl_schema}.crss_business_putout.etl_timestamp is '数据处理时间';