/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_crss_business_putout
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
alter table ${idl_schema}.oass_crss_business_putout drop partition p_${retain_week};
alter table ${idl_schema}.oass_crss_business_putout drop partition p_${batch_date};


-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_crss_business_putout add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_crss_business_putout (
    etl_dt  -- 数据日期
    ,serialno  -- 
    ,customerid  -- 
    ,customername  -- 
    ,businesstype  -- 
    ,businesscurrency  -- 
    ,businesssum  -- 
    ,termyear  -- 
    ,termmonth  -- 
    ,termday  -- 
    ,putoutdate  -- 
    ,maturity  -- 
    ,businessrate  -- 
    ,ictype  -- 
    ,iccyc  -- 
    ,paycyc  -- 
    ,corpuspaymethod  -- 
    ,subjectno  -- 
    ,dealbegintime  -- 
    ,dealendtime  -- 
    ,dealflag  -- 
    ,operateorgid  -- 
    ,operateuserid  -- 
    ,operatedate  -- 
    ,inputorgid  -- 
    ,inputuserid  -- 
    ,inputdate  -- 
    ,updatedate  -- 
    ,pigeonholedate  -- 
    ,remark  -- 
    ,occurdate  -- 
    ,baseratetype  -- 
    ,baserate  -- 
    ,ratefloattype  -- 
    ,ratefloat  -- 
    ,contractserialno  -- 
    ,duebillserialno  -- 
    ,artificialno  -- 
    ,relativeaccountno  -- 
    ,accountno  -- 
    ,loanaccountno  -- 
    ,loantype  -- 
    ,creditlineflag  -- 
    ,creditaggreement  -- 
    ,contractsum  -- 
    ,purpose  -- 
    ,adjustratetype  -- 
    ,fixcyc  -- 
    ,backrate  -- 
    ,acceptinttype  -- 
    ,preinttype  -- 
    ,resumeinttype  -- 
    ,secondpayaccount  -- 
    ,overinttype  -- 
    ,rateadjustcyc  -- 
    ,guarantyno  -- 
    ,riskrate  -- 
    ,consignaccountno  -- 
    ,mostlyduebillno  -- 
    ,negotiateno  -- 
    ,creditkind  -- 
    ,pdgsum  -- 
    ,pdgaccountno  -- 
    ,pdgpaymethod  -- 
    ,businesssubtype  -- 
    ,businesssubtype1  -- 
    ,exchangetype  -- 
    ,exchangestate  -- 
    ,exchangeserialno  -- 
    ,adjustrateterm  -- 
    ,projectno  -- 
    ,fzaccountno  -- 
    ,fzanbalance  -- 
    ,ccode  -- 
    ,cdate  -- 
    ,fzguabalance  -- 
    ,pztype  -- 
    ,billno  -- 
    ,gatheringname  -- 
    ,aboutbankname  -- 
    ,interserialno  -- 
    ,billresource  -- 
    ,bailaccount  -- 
    ,aboutbankid  -- 
    ,billsum  -- 
    ,ratetype  -- 
    ,billrisk  -- 
    ,openbankname  -- 开证行行名/信用证下出口押汇出口信用证开证行
    ,openbankadd  -- 
    ,openbankzip  -- 
    ,type1  -- 
    ,type2  -- 
    ,type3  -- 
    ,type4  -- 
    ,type5  -- 
    ,type6  -- 
    ,type7  -- 
    ,aboutbankid2  -- 
    ,aboutbankname2  -- 
    ,aboutbankid3  -- 
    ,name1  -- 
    ,address1  -- 
    ,name2  -- 
    ,address2  -- 
    ,zip2  -- 
    ,address3  -- 
    ,term1  -- 
    ,term2  -- 
    ,term3  -- 
    ,vouchtype  -- 
    ,bailcurrency  -- 
    ,bailratio  -- 
    ,mfeepaymethod  -- 
    ,securitiestype  -- 
    ,type8  -- 
    ,type9  -- 
    ,thirdpartyaccounts  -- 
    ,thirdpartyid1  -- 
    ,ccyc  -- 
    ,loanterm  -- 
    ,relativeputoutno  -- 
    ,printtimes  -- 
    ,tempsaveflag  -- 
    ,paymentmode  -- 
    ,greenchannelflag  -- 
    ,lowrisk  -- 
    ,iswritecont  -- 是否签署授信合同
    ,putoutorgid  -- 出账日期
    ,principalaccountno  -- 委托存款账号
    ,clientaccountno  -- 委托人存款账号
    ,lendingorgid  -- 贷款机构
    ,capitalreturnflag  -- 本金自动归还标志
    ,interestreturnflag  -- 利息自动归还标志
    ,rategenre  -- 利率重定价
    ,installmentsmenthod  -- 分期贷款还款方式
    ,overduefloat  -- 逾期贷款利率浮动比例
    ,overduerate  -- 逾期贷款执行利率
    ,period  -- 分期贷款总期数
    ,commitmentflag  -- 贷款承诺标志
    ,commitmenttype  -- 承诺类型
    ,principalsubaccountno  -- 委托存款子户号
    ,paymenttype  -- 款项使用类型
    ,compoundintflag  -- 是否收复息标志
    ,termtype  -- 期限
    ,pdgpaypercent  -- 委托贷款手续费收取比例
    ,corpuspaydate  -- 按揭还款日
    ,purposetype  -- 用途
    ,repaymentplanflag  -- 信贷发放还款计划标志
    ,stopintflag  -- 是否停息
    ,commissionpaysum  -- 委托支付金额
    ,loancommitmentno  -- 贷款承诺协议号
    ,approveorgid  -- 复核机构
    ,approveuserid  -- 复核人
    ,approvedate  -- 复核日期
    ,corpuspaymenthod  -- 还款方式
    ,receiversubaccountno  -- 收款人子户号
    ,receiveraccountno  -- 收款人账号
    ,dischargesflag  -- 贴息标志
    ,dischargesaccountno  -- 贴息人存款账号
    ,dischargespercent  -- 贴息比例
    ,dischargesdate  -- 贴息到期日
    ,exchangetime  -- 交易时间
    ,bailsubaccount  -- 保证金子户号
    ,bailsum  -- 保证金金额
    ,assureorgid  -- 担保机构
    ,direction  -- 
    ,bailterm  -- 保证金存期
    ,bailexchangestate  -- 保证金交易状态
    ,repayexchangestate  -- 还款计划交易状态
    ,queryabnormitything  -- 
    ,abnormitything  -- 
    ,loantermthing  -- 
    ,fbsnumber  -- 国结系统编号（BP/AD/OC…)//进口押汇信用证号、进口代收押汇进口代收业务编号、信用证下出口押汇信用证通知号、打包放款信用证通知号、出口托收押汇出口托收业务编号、福费廷出口信用证通知号、短期出口信用保险项下押汇业务出口业务编号、国际贸易融资项下同业代付代付业务编号
    ,invoicenumber  -- 
    ,sfgksx  -- 
    ,gksxpz  -- 
    ,sfzfsx  -- 
    ,zfsxlx  -- 
    ,sfgjxzhy  -- 
    ,gshy  -- 
    ,dktx  -- 
    ,commercetype  -- 
    ,paymode  -- 
    ,zfsxfs  -- 
    ,paymodedesc  -- 
    ,isfinanceguarantee  -- 
    ,accountnoorgname  -- 
    ,accountnocustomer  -- 
    ,loanaccountnocustomer  -- 
    ,loanaccountnoorgname  -- 
    ,operationtype  -- 
    ,paysum  -- 手续费
    ,manualpay  -- 工本费
    ,keyno  -- 单笔票据唯一标示
    ,billclass  -- 票据性质
    ,billtype  -- 票据类型
    ,careflag  -- 是否代保管
    ,repurchaseflag  -- 是否回购（赎回）
    ,discountsum  -- 贴现利息
    ,billbusinesstype  -- 业务种类
    ,putoutno  -- 出账号
    ,batchno  -- 
    ,addcertificateflag  -- 
    ,waitecertificateflag  -- 
    ,otherdraweracctno  -- 第三方付息账户
    ,othertxbalance  -- 第三方付息金额
    ,czflag  -- 冲账标志
    ,lcsum  -- 信用证金额
    ,carbrand  -- 
    ,cartype  -- 
    ,carnumber  -- 
    ,chariotnumber  -- 
    ,motornumber  -- 
    ,acptdate  -- 
    ,interestmethod  -- 计息方法
    ,interestrate  -- 协议利率
    ,bailmaturity  -- 保证金到期日
    ,receivername  -- 收款人名称
    ,isfromebank  -- 是否网银放款（1为是2等其他为否）
    ,orginalduebill  -- 续贷业务对应的原借据
    ,loankind  -- 贷款种类
    ,tradeserialno1  -- 国际贸易融资业务相关编号(信用证项下出口押汇出口信用证号（开证行信用证编号）、打包放款信用证号、进口T/T融资进口T/T业务编号、出口T/T融资出口T/T业务编号、福费廷出口信用证号)
    ,tradeserialno2  -- 国际贸易融资业务相关编号(进口押汇来单号、信用证下出口押汇出口信用证寄单号、打包放款出口信用证寄单号、福费廷出口寄单编号、)
    ,tradecurrecy1  -- 国际贸易融资业务相关币种（进口押汇来单币种、进口代收押汇来单币种、进口T/T押汇汇款币种、信用证下出口押汇索汇币种、打包放款信用证币种、出口托收押汇托收币种、福费廷索汇币种、）
    ,tradecurrecy2  -- 国际贸易融资业务相关币种（进口代收押汇押汇币种、进口T/T押汇融资币种、出口T/T押汇融资币种、信用证下出口押汇押汇币种、打包放款融资币种、出口托收押汇押汇币种、福费廷承兑币种、出口退税帐户托管融资业务融资币种、国际贸易融资项下同业代付代付币种）
    ,tradecurrecy3  -- 国际贸易融资业务相关币种（出口T/T押汇发票币种、福费廷贴现币种、出口退税帐户托管融资业务应退未退金额币种、国际贸易融资项下同业代付汇票币种（来单或发票币种））
    ,tradesum1  -- 国际贸易融资业务相关金额（进口押汇来单金额（待付款金额、汇票金额）、进口代收押汇单据金额（待付款金额）、进口T/T押汇汇款金额、信用证下出口押汇索汇金额、打包放款信用证金额、出口托收押汇托收金额、福费廷索汇金额、短期出口信用保险项下押汇业务押汇金额、）
    ,tradesum2  -- 国际贸易融资业务相关金额（进口代收押汇押汇金额、进口T/T押汇融资金额、出口T/T押汇融资金额、信用证下出口押汇押汇金额、打包放款融资金额、出口托收押汇押汇金额、福费廷承兑金额、出口退税帐户托管融资业务融资金额、短期出口信用保险项下押汇业务出运货物申报金额、国际贸易融资项下同业代付代付金额、）
    ,tradesum3  -- 国际贸易融资业务相关金额（出口T/T押汇发票金额、福费廷贴现金额、出口退税帐户托管融资业务应退未退金额、短期出口信用保险项下押汇业务信用限额余额、国际贸易融资项下同业代付汇票金额（来单或发票金额））
    ,tradedate1  -- 国际贸易融资业务相关日期（进口押汇来单付款日、信用证下出口押汇信用证付款日、出口托收押汇D/A到期付款日（如果托收类型选择D/A）、福费廷信用证到期付款日、国际贸易融资项下同业代付代付起息日、）
    ,tradedate2  -- 国际贸易融资业务相关日期（信用证下出口押汇远期信用证到期付款日、福费廷远期信用证到期付款日、）
    ,tradetermmonth1  -- 国际贸易融资业务相关期限（进口押汇信用证付款期限、进口代收押汇D/A代收期限（如果托收类型选择D/A）、进口T/T押汇融资期限、出口T/T押汇融资期限、打包放款信用证期限、福费廷贴现天数、短期出口信用保险项下押汇业务押汇期限、）
    ,tradetermmonth2  -- 国际贸易融资业务相关期限（进口押汇押汇期限、进口代收押汇押汇期限、出口T/T押汇出口合同付款期限、信用证下出口押汇押汇期限、打包放款融资期限、出口托收押汇押汇期限、福费廷融资期限、出口退税帐户托管融资业务融资期限、）
    ,tradetermmonth3  -- 国际贸易融资业务相关期限（国际贸易融资项下同业代付代付期限）
    ,traderate1  -- 福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
    ,traderate2  -- 出口退税帐户托管融资业务融资比例、短期出口信用保险项下押汇业务赔偿比例、
    ,tradetype1  -- 进口代收押汇代收类型（D/A或D/P）、出口托收押汇托收类型（D/A或D/P）
    ,bfintg  -- 先付利息摊销标志
    ,paybankname  -- 国际贸易融资项下同业代付代付行
    ,isinuse  -- 添加维护标志1正常2不维护
    ,bailtransaccount  -- 
    ,daynum  -- 单笔透支有效天数
    ,lncmam  -- 透支承诺费
    ,ovdrmi  -- 起透金额
    ,loanam  -- 透支额度
    ,accountno1  -- 透支账户账号
    ,oblopt  -- 使用余额选择
    ,bengdt  -- 业务提醒短信发送时机
    ,lontyp  -- 透支贷款方式
    ,odrputoutdate  -- 法透额度起始日
    ,odrmaturity  -- 法透额度到期日
    ,whitelist  -- 法人透支白名单
    ,putoutcontrol  -- 到日期超批复半年设置，1允许，0禁止
    ,txregister  -- 纸票贴现登记状态：0 未登记，1 已登记
    ,loantermcontrolflag  -- 出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
    ,acceptor  -- 承兑人名称
    ,acceptorbankno  -- 承兑人开户行号
    ,acceptorbankname  -- 承兑人开户行名称
    ,fxfltp  -- 利率类型（核心xdfrzf、cdjzjk加）
    ,pdrifd  -- 利率浮动类型
    ,pdrifm  -- 利率浮动方式
    ,pdrifv  -- 浮动值
    ,jxhjduebillno  -- 借新还旧的某笔旧借据
    ,odrnextmonth  -- 法透不跨月 1-是
    ,odrfreeinterest  -- 法透不跨月免息天数
    ,amorfg  -- 手续费是否摊销
    ,trantp  -- 手续费收费方式
    ,amorsq  -- 摊销流水号
    ,exchangedate  -- 承兑记账交易日期
    ,exchangeno  -- 承兑记账交易流水号
    ,isrz  -- 是否融资系统出账 1是0否
    ,financier  -- 实际融资人
    ,hxtycapitalsource  -- 同业资金来源
    ,adjustratedate  -- 利率调整日
    ,countbasis  -- 计息基础
    ,bigcreditbankid  -- 大额支付行号
    ,principalaccountname  -- 放款账户名称
    ,principalbankname  -- 放款账户开户行名称
    ,accountindir  -- 开户行地址号
    ,ret_msg  -- 开户行地址名称
    ,clearingtype  -- 
    ,ishxbank  -- 是否本行
    ,hxtypurpose  -- 用途(手工输入,非标标准出账业务)
    ,start_dt  -- 
    ,end_dt  -- 
    ,id_mark  -- 
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.serialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.customerid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.customername,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesstype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'')  -- 
    ,t1.businesssum  -- 
    ,t1.termyear  -- 
    ,t1.termmonth  -- 
    ,t1.termday  -- 
    ,replace(replace(t1.putoutdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.maturity,chr(13),''),chr(10),'')  -- 
    ,t1.businessrate  -- 
    ,replace(replace(t1.ictype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.iccyc,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paycyc,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.corpuspaymethod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.subjectno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.dealbegintime,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.dealendtime,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.dealflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operateorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operateuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pigeonholedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.occurdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.baseratetype,chr(13),''),chr(10),'')  -- 
    ,t1.baserate  -- 
    ,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'')  -- 
    ,t1.ratefloat  -- 
    ,replace(replace(t1.contractserialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.duebillserialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.artificialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.relativeaccountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.accountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loanaccountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loantype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditlineflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditaggreement,chr(13),''),chr(10),'')  -- 
    ,t1.contractsum  -- 
    ,replace(replace(t1.purpose,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.adjustratetype,chr(13),''),chr(10),'')  -- 
    ,t1.fixcyc  -- 
    ,t1.backrate  -- 
    ,replace(replace(t1.acceptinttype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.preinttype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.resumeinttype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.secondpayaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.overinttype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.rateadjustcyc,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantyno,chr(13),''),chr(10),'')  -- 
    ,t1.riskrate  -- 
    ,replace(replace(t1.consignaccountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mostlyduebillno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.negotiateno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditkind,chr(13),''),chr(10),'')  -- 
    ,t1.pdgsum  -- 
    ,replace(replace(t1.pdgaccountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pdgpaymethod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesssubtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesssubtype1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.exchangetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.exchangestate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.exchangeserialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.adjustrateterm,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.projectno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fzaccountno,chr(13),''),chr(10),'')  -- 
    ,t1.fzanbalance  -- 
    ,replace(replace(t1.ccode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cdate,chr(13),''),chr(10),'')  -- 
    ,t1.fzguabalance  -- 
    ,replace(replace(t1.pztype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.billno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.gatheringname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutbankname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.interserialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.billresource,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bailaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutbankid,chr(13),''),chr(10),'')  -- 
    ,t1.billsum  -- 
    ,replace(replace(t1.ratetype,chr(13),''),chr(10),'')  -- 
    ,t1.billrisk  -- 
    ,replace(replace(t1.openbankname,chr(13),''),chr(10),'')  -- 开证行行名/信用证下出口押汇出口信用证开证行
    ,replace(replace(t1.openbankadd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.openbankzip,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.type1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.type2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.type3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.type4,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.type5,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.type6,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.type7,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutbankid2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutbankname2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutbankid3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.name1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.address1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.name2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.address2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.zip2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.address3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.term1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.term2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.term3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vouchtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bailcurrency,chr(13),''),chr(10),'')  -- 
    ,t1.bailratio  -- 
    ,replace(replace(t1.mfeepaymethod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.securitiestype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.type8,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.type9,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyaccounts,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyid1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ccyc,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loanterm,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.relativeputoutno,chr(13),''),chr(10),'')  -- 
    ,t1.printtimes  -- 
    ,replace(replace(t1.tempsaveflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paymentmode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.greenchannelflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.lowrisk,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.iswritecont,chr(13),''),chr(10),'')  -- 是否签署授信合同
    ,replace(replace(t1.putoutorgid,chr(13),''),chr(10),'')  -- 出账日期
    ,replace(replace(t1.principalaccountno,chr(13),''),chr(10),'')  -- 委托存款账号
    ,replace(replace(t1.clientaccountno,chr(13),''),chr(10),'')  -- 委托人存款账号
    ,replace(replace(t1.lendingorgid,chr(13),''),chr(10),'')  -- 贷款机构
    ,replace(replace(t1.capitalreturnflag,chr(13),''),chr(10),'')  -- 本金自动归还标志
    ,replace(replace(t1.interestreturnflag,chr(13),''),chr(10),'')  -- 利息自动归还标志
    ,replace(replace(t1.rategenre,chr(13),''),chr(10),'')  -- 利率重定价
    ,replace(replace(t1.installmentsmenthod,chr(13),''),chr(10),'')  -- 分期贷款还款方式
    ,t1.overduefloat  -- 逾期贷款利率浮动比例
    ,t1.overduerate  -- 逾期贷款执行利率
    ,t1.period  -- 分期贷款总期数
    ,replace(replace(t1.commitmentflag,chr(13),''),chr(10),'')  -- 贷款承诺标志
    ,replace(replace(t1.commitmenttype,chr(13),''),chr(10),'')  -- 承诺类型
    ,replace(replace(t1.principalsubaccountno,chr(13),''),chr(10),'')  -- 委托存款子户号
    ,replace(replace(t1.paymenttype,chr(13),''),chr(10),'')  -- 款项使用类型
    ,replace(replace(t1.compoundintflag,chr(13),''),chr(10),'')  -- 是否收复息标志
    ,replace(replace(t1.termtype,chr(13),''),chr(10),'')  -- 期限
    ,t1.pdgpaypercent  -- 委托贷款手续费收取比例
    ,replace(replace(t1.corpuspaydate,chr(13),''),chr(10),'')  -- 按揭还款日
    ,replace(replace(t1.purposetype,chr(13),''),chr(10),'')  -- 用途
    ,replace(replace(t1.repaymentplanflag,chr(13),''),chr(10),'')  -- 信贷发放还款计划标志
    ,replace(replace(t1.stopintflag,chr(13),''),chr(10),'')  -- 是否停息
    ,t1.commissionpaysum  -- 委托支付金额
    ,replace(replace(t1.loancommitmentno,chr(13),''),chr(10),'')  -- 贷款承诺协议号
    ,replace(replace(t1.approveorgid,chr(13),''),chr(10),'')  -- 复核机构
    ,replace(replace(t1.approveuserid,chr(13),''),chr(10),'')  -- 复核人
    ,replace(replace(t1.approvedate,chr(13),''),chr(10),'')  -- 复核日期
    ,replace(replace(t1.corpuspaymenthod,chr(13),''),chr(10),'')  -- 还款方式
    ,replace(replace(t1.receiversubaccountno,chr(13),''),chr(10),'')  -- 收款人子户号
    ,replace(replace(t1.receiveraccountno,chr(13),''),chr(10),'')  -- 收款人账号
    ,replace(replace(t1.dischargesflag,chr(13),''),chr(10),'')  -- 贴息标志
    ,replace(replace(t1.dischargesaccountno,chr(13),''),chr(10),'')  -- 贴息人存款账号
    ,t1.dischargespercent  -- 贴息比例
    ,replace(replace(t1.dischargesdate,chr(13),''),chr(10),'')  -- 贴息到期日
    ,replace(replace(t1.exchangetime,chr(13),''),chr(10),'')  -- 交易时间
    ,replace(replace(t1.bailsubaccount,chr(13),''),chr(10),'')  -- 保证金子户号
    ,t1.bailsum  -- 保证金金额
    ,replace(replace(t1.assureorgid,chr(13),''),chr(10),'')  -- 担保机构
    ,replace(replace(t1.direction,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bailterm,chr(13),''),chr(10),'')  -- 保证金存期
    ,replace(replace(t1.bailexchangestate,chr(13),''),chr(10),'')  -- 保证金交易状态
    ,replace(replace(t1.repayexchangestate,chr(13),''),chr(10),'')  -- 还款计划交易状态
    ,replace(replace(t1.queryabnormitything,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.abnormitything,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loantermthing,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fbsnumber,chr(13),''),chr(10),'')  -- 国结系统编号（BP/AD/OC…)//进口押汇信用证号、进口代收押汇进口代收业务编号、信用证下出口押汇信用证通知号、打包放款信用证通知号、出口托收押汇出口托收业务编号、福费廷出口信用证通知号、短期出口信用保险项下押汇业务出口业务编号、国际贸易融资项下同业代付代付业务编号
    ,replace(replace(t1.invoicenumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sfgksx,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.gksxpz,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sfzfsx,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.zfsxlx,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sfgjxzhy,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.gshy,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.dktx,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.commercetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paymode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.zfsxfs,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paymodedesc,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isfinanceguarantee,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.accountnoorgname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.accountnocustomer,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loanaccountnocustomer,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loanaccountnoorgname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operationtype,chr(13),''),chr(10),'')  -- 
    ,t1.paysum  -- 手续费
    ,t1.manualpay  -- 工本费
    ,replace(replace(t1.keyno,chr(13),''),chr(10),'')  -- 单笔票据唯一标示
    ,replace(replace(t1.billclass,chr(13),''),chr(10),'')  -- 票据性质
    ,replace(replace(t1.billtype,chr(13),''),chr(10),'')  -- 票据类型
    ,replace(replace(t1.careflag,chr(13),''),chr(10),'')  -- 是否代保管
    ,replace(replace(t1.repurchaseflag,chr(13),''),chr(10),'')  -- 是否回购（赎回）
    ,t1.discountsum  -- 贴现利息
    ,replace(replace(t1.billbusinesstype,chr(13),''),chr(10),'')  -- 业务种类
    ,replace(replace(t1.putoutno,chr(13),''),chr(10),'')  -- 出账号
    ,replace(replace(t1.batchno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.addcertificateflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.waitecertificateflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.otherdraweracctno,chr(13),''),chr(10),'')  -- 第三方付息账户
    ,t1.othertxbalance  -- 第三方付息金额
    ,replace(replace(t1.czflag,chr(13),''),chr(10),'')  -- 冲账标志
    ,t1.lcsum  -- 信用证金额
    ,replace(replace(t1.carbrand,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cartype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.carnumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.chariotnumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.motornumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.acptdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.interestmethod,chr(13),''),chr(10),'')  -- 计息方法
    ,t1.interestrate  -- 协议利率
    ,replace(replace(t1.bailmaturity,chr(13),''),chr(10),'')  -- 保证金到期日
    ,replace(replace(t1.receivername,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.isfromebank,chr(13),''),chr(10),'')  -- 是否网银放款（1为是2等其他为否）
    ,replace(replace(t1.orginalduebill,chr(13),''),chr(10),'')  -- 续贷业务对应的原借据
    ,replace(replace(t1.loankind,chr(13),''),chr(10),'')  -- 贷款种类
    ,replace(replace(t1.tradeserialno1,chr(13),''),chr(10),'')  -- 国际贸易融资业务相关编号(信用证项下出口押汇出口信用证号（开证行信用证编号）、打包放款信用证号、进口T/T融资进口T/T业务编号、出口T/T融资出口T/T业务编号、福费廷出口信用证号)
    ,replace(replace(t1.tradeserialno2,chr(13),''),chr(10),'')  -- 国际贸易融资业务相关编号(进口押汇来单号、信用证下出口押汇出口信用证寄单号、打包放款出口信用证寄单号、福费廷出口寄单编号、)
    ,replace(replace(t1.tradecurrecy1,chr(13),''),chr(10),'')  -- 国际贸易融资业务相关币种（进口押汇来单币种、进口代收押汇来单币种、进口T/T押汇汇款币种、信用证下出口押汇索汇币种、打包放款信用证币种、出口托收押汇托收币种、福费廷索汇币种、）
    ,replace(replace(t1.tradecurrecy2,chr(13),''),chr(10),'')  -- 国际贸易融资业务相关币种（进口代收押汇押汇币种、进口T/T押汇融资币种、出口T/T押汇融资币种、信用证下出口押汇押汇币种、打包放款融资币种、出口托收押汇押汇币种、福费廷承兑币种、出口退税帐户托管融资业务融资币种、国际贸易融资项下同业代付代付币种）
    ,replace(replace(t1.tradecurrecy3,chr(13),''),chr(10),'')  -- 国际贸易融资业务相关币种（出口T/T押汇发票币种、福费廷贴现币种、出口退税帐户托管融资业务应退未退金额币种、国际贸易融资项下同业代付汇票币种（来单或发票币种））
    ,t1.tradesum1  -- 国际贸易融资业务相关金额（进口押汇来单金额（待付款金额、汇票金额）、进口代收押汇单据金额（待付款金额）、进口T/T押汇汇款金额、信用证下出口押汇索汇金额、打包放款信用证金额、出口托收押汇托收金额、福费廷索汇金额、短期出口信用保险项下押汇业务押汇金额、）
    ,t1.tradesum2  -- 国际贸易融资业务相关金额（进口代收押汇押汇金额、进口T/T押汇融资金额、出口T/T押汇融资金额、信用证下出口押汇押汇金额、打包放款融资金额、出口托收押汇押汇金额、福费廷承兑金额、出口退税帐户托管融资业务融资金额、短期出口信用保险项下押汇业务出运货物申报金额、国际贸易融资项下同业代付代付金额、）
    ,t1.tradesum3  -- 国际贸易融资业务相关金额（出口T/T押汇发票金额、福费廷贴现金额、出口退税帐户托管融资业务应退未退金额、短期出口信用保险项下押汇业务信用限额余额、国际贸易融资项下同业代付汇票金额（来单或发票金额））
    ,replace(replace(t1.tradedate1,chr(13),''),chr(10),'')  -- 国际贸易融资业务相关日期（进口押汇来单付款日、信用证下出口押汇信用证付款日、出口托收押汇D/A到期付款日（如果托收类型选择D/A）、福费廷信用证到期付款日、国际贸易融资项下同业代付代付起息日、）
    ,replace(replace(t1.tradedate2,chr(13),''),chr(10),'')  -- 国际贸易融资业务相关日期（信用证下出口押汇远期信用证到期付款日、福费廷远期信用证到期付款日、）
    ,t1.tradetermmonth1  -- 国际贸易融资业务相关期限（进口押汇信用证付款期限、进口代收押汇D/A代收期限（如果托收类型选择D/A）、进口T/T押汇融资期限、出口T/T押汇融资期限、打包放款信用证期限、福费廷贴现天数、短期出口信用保险项下押汇业务押汇期限、）
    ,t1.tradetermmonth2  -- 国际贸易融资业务相关期限（进口押汇押汇期限、进口代收押汇押汇期限、出口T/T押汇出口合同付款期限、信用证下出口押汇押汇期限、打包放款融资期限、出口托收押汇押汇期限、福费廷融资期限、出口退税帐户托管融资业务融资期限、）
    ,t1.tradetermmonth3  -- 国际贸易融资业务相关期限（国际贸易融资项下同业代付代付期限）
    ,t1.traderate1  -- 福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
    ,t1.traderate2  -- 出口退税帐户托管融资业务融资比例、短期出口信用保险项下押汇业务赔偿比例、
    ,replace(replace(t1.tradetype1,chr(13),''),chr(10),'')  -- 进口代收押汇代收类型（D/A或D/P）、出口托收押汇托收类型（D/A或D/P）
    ,replace(replace(t1.bfintg,chr(13),''),chr(10),'')  -- 先付利息摊销标志
    ,replace(replace(t1.paybankname,chr(13),''),chr(10),'')  -- 国际贸易融资项下同业代付代付行
    ,replace(replace(t1.isinuse,chr(13),''),chr(10),'')  -- 添加维护标志1正常2不维护
    ,replace(replace(t1.bailtransaccount,chr(13),''),chr(10),'')  -- 
    ,t1.daynum  -- 单笔透支有效天数
    ,t1.lncmam  -- 透支承诺费
    ,t1.ovdrmi  -- 起透金额
    ,t1.loanam  -- 透支额度
    ,replace(replace(t1.accountno1,chr(13),''),chr(10),'')  -- 透支账户账号
    ,replace(replace(t1.oblopt,chr(13),''),chr(10),'')  -- 使用余额选择
    ,replace(replace(t1.bengdt,chr(13),''),chr(10),'')  -- 业务提醒短信发送时机
    ,replace(replace(t1.lontyp,chr(13),''),chr(10),'')  -- 透支贷款方式
    ,replace(replace(t1.odrputoutdate,chr(13),''),chr(10),'')  -- 法透额度起始日
    ,replace(replace(t1.odrmaturity,chr(13),''),chr(10),'')  -- 法透额度到期日
    ,replace(replace(t1.whitelist,chr(13),''),chr(10),'')  -- 法人透支白名单
    ,replace(replace(t1.putoutcontrol,chr(13),''),chr(10),'')  -- 到日期超批复半年设置，1允许，0禁止
    ,replace(replace(t1.txregister,chr(13),''),chr(10),'')  -- 纸票贴现登记状态：0 未登记，1 已登记
    ,replace(replace(t1.loantermcontrolflag,chr(13),''),chr(10),'')  -- 出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
    ,replace(replace(t1.acceptor,chr(13),''),chr(10),'')  -- 承兑人名称
    ,replace(replace(t1.acceptorbankno,chr(13),''),chr(10),'')  -- 承兑人开户行号
    ,replace(replace(t1.acceptorbankname,chr(13),''),chr(10),'')  -- 承兑人开户行名称
    ,replace(replace(t1.fxfltp,chr(13),''),chr(10),'')  -- 利率类型（核心xdfrzf、cdjzjk加）
    ,replace(replace(t1.pdrifd,chr(13),''),chr(10),'')  -- 利率浮动类型
    ,replace(replace(t1.pdrifm,chr(13),''),chr(10),'')  -- 利率浮动方式
    ,t1.pdrifv  -- 浮动值
    ,replace(replace(t1.jxhjduebillno,chr(13),''),chr(10),'')  -- 借新还旧的某笔旧借据
    ,replace(replace(t1.odrnextmonth,chr(13),''),chr(10),'')  -- 法透不跨月 1-是
    ,t1.odrfreeinterest  -- 法透不跨月免息天数
    ,replace(replace(t1.amorfg,chr(13),''),chr(10),'')  -- 手续费是否摊销
    ,replace(replace(t1.trantp,chr(13),''),chr(10),'')  -- 手续费收费方式
    ,replace(replace(t1.amorsq,chr(13),''),chr(10),'')  -- 摊销流水号
    ,replace(replace(t1.exchangedate,chr(13),''),chr(10),'')  -- 承兑记账交易日期
    ,replace(replace(t1.exchangeno,chr(13),''),chr(10),'')  -- 承兑记账交易流水号
    ,replace(replace(t1.isrz,chr(13),''),chr(10),'')  -- 是否融资系统出账 1是0否
    ,replace(replace(t1.financier,chr(13),''),chr(10),'')  -- 实际融资人
    ,replace(replace(t1.hxtycapitalsource,chr(13),''),chr(10),'')  -- 同业资金来源
    ,t1.adjustratedate  -- 利率调整日
    ,replace(replace(t1.countbasis,chr(13),''),chr(10),'')  -- 计息基础
    ,replace(replace(t1.bigcreditbankid,chr(13),''),chr(10),'')  -- 大额支付行号
    ,replace(replace(t1.principalaccountname,chr(13),''),chr(10),'')  -- 放款账户名称
    ,replace(replace(t1.principalbankname,chr(13),''),chr(10),'')  -- 放款账户开户行名称
    ,replace(replace(t1.accountindir,chr(13),''),chr(10),'')  -- 开户行地址号
    ,replace(replace(t1.ret_msg,chr(13),''),chr(10),'')  -- 开户行地址名称
    ,replace(replace(t1.clearingtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ishxbank,chr(13),''),chr(10),'')  -- 是否本行
    ,replace(replace(t1.hxtypurpose,chr(13),''),chr(10),'')  -- 用途(手工输入,非标标准出账业务)
    ,t1.start_dt  -- 
    ,t1.end_dt  -- 
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.crss_business_putout t1    --业务出帐通知单
where t1.start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_crss_business_putout',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);