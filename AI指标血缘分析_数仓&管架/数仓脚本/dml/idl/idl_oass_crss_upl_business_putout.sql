/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_crss_upl_business_putout
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
alter table ${idl_schema}.oass_crss_upl_business_putout drop partition p_${retain_week};
alter table ${idl_schema}.oass_crss_upl_business_putout drop partition p_${batch_date};


-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_crss_upl_business_putout add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_crss_upl_business_putout (
    etl_dt  -- 数据日期
    ,serialno  -- 流水号
    ,customerid  -- 客户编号
    ,customername  -- 客户名称
    ,businesstype  -- 贷款品种
    ,businesscurrency  -- 币种
    ,businesssum  -- 贷款金额
    ,termyear  -- 年
    ,termmonth  -- 月
    ,termday  -- 日
    ,putoutdate  -- 出账日期
    ,maturity  -- 到账日期
    ,businessrate  -- 利率
    ,ictype  -- 计息方式
    ,iccyc  -- 计息周期
    ,paycyc  -- 还款周期
    ,corpuspaymethod  -- 还款方式
    ,subjectno  -- 科目号
    ,dealbegintime  -- 处理开始时间
    ,dealendtime  -- 处理结束时间
    ,dealflag  -- 处理状态
    ,operateorgid  -- 经办机构
    ,operateuserid  -- 经办人
    ,operatedate  -- 
    ,inputorgid  -- 登记机构
    ,inputuserid  -- 登记人
    ,inputdate  -- 登记日期
    ,updatedate  -- 更新日期
    ,pigeonholedate  -- 终结日期
    ,remark  -- 备注
    ,occurdate  -- 发生日期
    ,baseratetype  -- 基准利率
    ,ratefloattype  -- 
    ,contractserialno  -- 合同流水号
    ,duebillserialno  -- 借据流水号
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
    ,openbankname  -- 
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
    ,multi_loan_flag  -- 
    ,multi_pay_flag  -- 
    ,ass_mode  -- 
    ,trust_pay_flag  -- 
    ,fee_mode  -- 
    ,pay_mode  -- 
    ,act_flag  -- 
    ,repay_mode  -- 
    ,ass_type  -- 
    ,bran_code  -- 
    ,deal_bran_code  -- 
    ,accept_bank_no  -- 
    ,contract_no  -- 
    ,apply_no  -- 
    ,cust_no  -- 
    ,ext_contract_no  -- 
    ,lc_no  -- 
    ,acct_seqno  -- 
    ,bill_no  -- 
    ,lc_code  -- 
    ,trust_loan_acct_no  -- 
    ,bail_acct_no  -- 
    ,pay_acct_no  -- 
    ,release_acct_no  -- 
    ,drawing_acct_no  -- 
    ,payee_acct_no  -- 
    ,cust_acct_no  -- 
    ,loan_class  -- 
    ,new_loan_class  -- 
    ,bill_type  -- 
    ,cust_name  -- 
    ,drawing_name  -- 
    ,payee_acct_name  -- 
    ,accept_name  -- 
    ,ben_acct_name  -- 
    ,functionary  -- 
    ,bail_cur_code  -- 
    ,fee_cur_code  -- 
    ,loan_amt  -- 
    ,trust_charge_amt  -- 
    ,fee  -- 
    ,repay_amt  -- 
    ,credited_amt  -- 
    ,max_quota  -- 
    ,draft_amt  -- 
    ,bill_amt  -- 
    ,start_date  -- 
    ,due_date  -- 
    ,draw_date  -- 
    ,setup_date  -- 
    ,prof_day  -- 
    ,overdraft_day  -- 
    ,ext_day  -- 
    ,int_rate_market  -- 
    ,int_rate_cycle  -- 
    ,nor_int_code  -- 
    ,nor_rate_f_mode  -- 
    ,nor_rate_f_prop  -- 
    ,nor_int_rate  -- 
    ,ext_rate_f_prop  -- 
    ,ext_int_rate  -- 
    ,int_mode  -- 
    ,nor_rate_adj_mode  -- 
    ,ovd_rate_f_prop  -- 
    ,ovd_int_rate  -- 
    ,trust_charge_rate  -- 
    ,fee_rate  -- 
    ,real_int_rate  -- 
    ,prop  -- 
    ,pay_prin_intvl  -- 
    ,max_apply_month  -- 
    ,main_purpose  -- 
    ,payee_bank_no  -- 
    ,payee_bank_name  -- 
    ,bail_amt  -- 
    ,cur_code  -- 
    ,loan_bin  -- 
    ,loan_label  -- 
    ,loan_class_name  -- 
    ,avail_quota  -- 
    ,realtiveapplyserialno  -- 
    ,exchangedate  -- 
    ,deduct_min_amt  -- 
    ,rateserialno  -- 
    ,supply_acct_no  -- 
    ,ext_rafe_f_prop  -- 
    ,agent_flag  -- 
    ,mfcustomerid  -- 
    ,supply_acct_no2  -- 定期存款账号2
    ,ext_day2  -- 定期分账号2
    ,ext_rafe_f_prop2  -- 定期比例2(%)
    ,supply_acct_no3  -- 定期存款账号3
    ,ext_day3  -- 定期分账号3
    ,ext_rafe_f_prop3  -- 定期比例3(%)
    ,supply_acct_no4  -- 定期存款账号4
    ,ext_day4  -- 定期分账号4
    ,ext_rafe_f_prop4  -- 定期比例4(%)
    ,supply_acct_no5  -- 定期存款账号5
    ,ext_day5  -- 定期分账号5
    ,ext_rafe_f_prop5  -- 定期比例5(%)
    ,classify4change  -- 四级分类形态转列
    ,depositrate  -- 存单质押比例（%）
    ,depositsum  -- 存单质押金额
    ,depositcurrency  -- 存单质押币种（默认人民币）
    ,chowmatisticsum  -- 理财产品质押金额
    ,chowmatisticcurrency  -- 理财产品币种(默认人民币)
    ,overfinerate  -- 逾期罚息比例(%)
    ,chowmatisticrate  -- 理财产品质押比例(%)
    ,repayplag  -- 还款计划是否发送核心
    ,latestpaydays  -- 最迟回笼天数
    ,elecflag  -- 是否电票标志
    ,discounttype  -- 贴现类型
    ,interestenddate  -- 计息到期日
    ,interestdays  -- 计息天数
    ,interest  -- 利息
    ,payinterest  -- 买方付息利息
    ,businessserialno  -- 业务流水号
    ,elecexchangestate  -- 电票交易状态
    ,paymenttype  -- 支付方式
    ,loantermflag  -- 贷款期限单位
    ,ratemode  -- 利率模式
    ,gaincyc  -- 递变周期
    ,gainamount  -- 递变幅度
    ,mainrepaymentmethod  -- 主还款方式
    ,repaymentmethod  -- 还款方式
    ,incomeorgid  -- 入账机构
    ,payaccountno  -- 还款账号
    ,putoutstatus  -- 出账状态
    ,holdcorpus  -- 保留金额
    ,defaultpaydate  -- 默认还款日
    ,payaccountno1  -- 贴息账号
    ,payaccountname  -- 还款账户名
    ,payaccountname1  -- 贴息账户名
    ,amortizeterm  -- 总摊还期限
    ,graceperioddate  -- 宽限期限
    ,pdgtype  -- 手续费类型
    ,customstamptax  -- 是否代客户缴印花税
    ,loanaccountnotype  -- 入款账号类型
    ,defaultpayacctnotype  -- 还款账号类型
    ,trustaccno  -- 委托人账号
    ,trustaccname  -- 委托人账户名
    ,trustaccnotype  -- 委托账户类型
    ,trustfundacctno  -- 委托人基金专户
    ,trustfundacctname  -- 委托贷款基金专户名
    ,designatedate  -- 利率调整日期
    ,cyclemonths  -- 指定月的利率重定价月数
    ,issmallcorporation  -- 是否小微企业标识
    ,istiexi  -- 是否贴息
    ,subsidyprop  -- 贴息比例
    ,repriceflag  -- 利率调整模式
    ,channelno  -- 渠道号
    ,flag7  -- 是否超额度期限
    ,farmingtype  -- 是否涉农贷款
    ,paymentmode  -- 支付方式
    ,businesssource  -- 
    ,payaccountno2  -- 
    ,payaccountname2  -- 
    ,clearanceacctnotype  -- 
    ,trustdepositaccnotype  -- 
    ,paloaninsureid  -- 
    ,businessratetype  -- 
    ,payment  -- 
    ,payername  -- 
    ,payerbankname  -- 
    ,payerbankaccounts  -- 
    ,isavouch  -- 
    ,specialaccountno  -- 
    ,uncheckaccountno  -- 
    ,isgroupcredit  -- 
    ,pdgaccountnoname  -- 
    ,dkaccountno  -- 
    ,dkaccountname  -- 
    ,fineratemode  -- 
    ,finerate  -- 
    ,tempsaveflag  -- 
    ,paysource  -- 
    ,contextinfo  -- 
    ,drawingtype  -- 
    ,fineratetype  -- 罚息利率类型
    ,fineratefloattype  -- 罚息利率浮动方式
    ,normalpayorder  -- 正常还款顺序
    ,overduepayorder  -- 逾期还款顺序
    ,fineratefloat  -- 
    ,baserate  -- 
    ,ratefloat  -- 
    ,batchpaymentflag  -- 批量还款标志
    ,relativeduebillserialno  -- 
    ,clearanceacctno  -- 结算账号
    ,clearanceacctname  -- 结算账号户名
    ,loankind  -- 期限类型
    ,gjjratemode  -- 
    ,gjjbaseratetype  -- 
    ,gjjratefloattype  -- 
    ,gjjbaserate  -- 
    ,gjjratefloat  -- 
    ,gjjbusinessrate  -- 
    ,gjjrepaymentmethod  -- 
    ,gjjpaycyc  -- 
    ,gjjadjustratetype  -- 
    ,gjjgaincyc  -- 
    ,gjjgainamount  -- 
    ,gjjholdcorpus  -- 
    ,gjjamortizeterm  -- 
    ,gjjbusinesssum  -- 
    ,gjjmainrepaymentmethod  -- 
    ,gjjgraceperioddate  -- 
    ,gjjcyclemonths  -- 
    ,gjjdesignatedate  -- 
    ,sybusinesssum  -- 
    ,gjjfineratetype  -- 
    ,gjjfinerate  -- 
    ,gjjfineratemode  -- 
    ,gjjfineratefloattype  -- 
    ,gjjfineratefloat  -- 
    ,assistuserid  -- 协办客户经理
    ,relativebpserialno  -- 关联放贷流水号
    ,curtype  -- 
    ,payaccountnoattr  -- 
    ,trustaccountnoattr  -- 
    ,paymode  -- 
    ,issignuplloan  -- 
    ,repaymentplanflag  -- 信贷发放还款计划标志
    ,userid  -- 用户编号
    ,begintime  -- 开始时间
    ,actualbegintime  -- 实际开始时间
    ,endtime  -- 结束时间
    ,riskacctno  -- 风险金账户
    ,riskacctname  -- 风险金账户名
    ,risksum  -- 代扣风险金金额
    ,otherfee  -- 其他费用金额
    ,subbusinesstype  -- 助贷业务品种
    ,warrantorid  -- 主要担保人编码
    ,warrantor  -- 主要担保人
    ,payaccountname3  -- 第二还款账户名
    ,payaccountno3  -- 第二还款账户
    ,crstrandate  -- 正向交易日期
    ,crstranseqno  -- 正向交易流水号
    ,start_dt  -- 
    ,end_dt  -- 
    ,id_mark  -- 
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.serialno,chr(13),''),chr(10),'')  -- 流水号
    ,replace(replace(t1.customerid,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.customername,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.businesstype,chr(13),''),chr(10),'')  -- 贷款品种
    ,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'')  -- 币种
    ,t1.businesssum  -- 贷款金额
    ,t1.termyear  -- 年
    ,t1.termmonth  -- 月
    ,t1.termday  -- 日
    ,replace(replace(t1.putoutdate,chr(13),''),chr(10),'')  -- 出账日期
    ,replace(replace(t1.maturity,chr(13),''),chr(10),'')  -- 到账日期
    ,t1.businessrate  -- 利率
    ,replace(replace(t1.ictype,chr(13),''),chr(10),'')  -- 计息方式
    ,replace(replace(t1.iccyc,chr(13),''),chr(10),'')  -- 计息周期
    ,replace(replace(t1.paycyc,chr(13),''),chr(10),'')  -- 还款周期
    ,replace(replace(t1.corpuspaymethod,chr(13),''),chr(10),'')  -- 还款方式
    ,replace(replace(t1.subjectno,chr(13),''),chr(10),'')  -- 科目号
    ,replace(replace(t1.dealbegintime,chr(13),''),chr(10),'')  -- 处理开始时间
    ,replace(replace(t1.dealendtime,chr(13),''),chr(10),'')  -- 处理结束时间
    ,replace(replace(t1.dealflag,chr(13),''),chr(10),'')  -- 处理状态
    ,replace(replace(t1.operateorgid,chr(13),''),chr(10),'')  -- 经办机构
    ,replace(replace(t1.operateuserid,chr(13),''),chr(10),'')  -- 经办人
    ,replace(replace(t1.operatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputorgid,chr(13),''),chr(10),'')  -- 登记机构
    ,replace(replace(t1.inputuserid,chr(13),''),chr(10),'')  -- 登记人
    ,replace(replace(t1.inputdate,chr(13),''),chr(10),'')  -- 登记日期
    ,replace(replace(t1.updatedate,chr(13),''),chr(10),'')  -- 更新日期
    ,replace(replace(t1.pigeonholedate,chr(13),''),chr(10),'')  -- 终结日期
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.occurdate,chr(13),''),chr(10),'')  -- 发生日期
    ,replace(replace(t1.baseratetype,chr(13),''),chr(10),'')  -- 基准利率
    ,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.contractserialno,chr(13),''),chr(10),'')  -- 合同流水号
    ,replace(replace(t1.duebillserialno,chr(13),''),chr(10),'')  -- 借据流水号
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
    ,replace(replace(t1.openbankname,chr(13),''),chr(10),'')  -- 
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
    ,replace(replace(t1.multi_loan_flag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.multi_pay_flag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ass_mode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.trust_pay_flag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fee_mode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pay_mode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.act_flag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.repay_mode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ass_type,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bran_code,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.deal_bran_code,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.accept_bank_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.contract_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.apply_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cust_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ext_contract_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.lc_no,chr(13),''),chr(10),'')  -- 
    ,t1.acct_seqno  -- 
    ,replace(replace(t1.bill_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.lc_code,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.trust_loan_acct_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bail_acct_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pay_acct_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.release_acct_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.drawing_acct_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.payee_acct_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cust_acct_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loan_class,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.new_loan_class,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bill_type,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.drawing_name,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.payee_acct_name,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.accept_name,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ben_acct_name,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.functionary,chr(13),''),chr(10),'')  -- 
    ,t1.bail_cur_code  -- 
    ,t1.fee_cur_code  -- 
    ,t1.loan_amt  -- 
    ,t1.trust_charge_amt  -- 
    ,t1.fee  -- 
    ,t1.repay_amt  -- 
    ,t1.credited_amt  -- 
    ,t1.max_quota  -- 
    ,t1.draft_amt  -- 
    ,t1.bill_amt  -- 
    ,replace(replace(t1.start_date,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.due_date,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.draw_date,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.setup_date,chr(13),''),chr(10),'')  -- 
    ,t1.prof_day  -- 
    ,t1.overdraft_day  -- 
    ,t1.ext_day  -- 
    ,t1.int_rate_market  -- 
    ,t1.int_rate_cycle  -- 
    ,t1.nor_int_code  -- 
    ,replace(replace(t1.nor_rate_f_mode,chr(13),''),chr(10),'')  -- 
    ,t1.nor_rate_f_prop  -- 
    ,t1.nor_int_rate  -- 
    ,t1.ext_rate_f_prop  -- 
    ,t1.ext_int_rate  -- 
    ,replace(replace(t1.int_mode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.nor_rate_adj_mode,chr(13),''),chr(10),'')  -- 
    ,t1.ovd_rate_f_prop  -- 
    ,t1.ovd_int_rate  -- 
    ,t1.trust_charge_rate  -- 
    ,t1.fee_rate  -- 
    ,t1.real_int_rate  -- 
    ,t1.prop  -- 
    ,t1.pay_prin_intvl  -- 
    ,t1.max_apply_month  -- 
    ,replace(replace(t1.main_purpose,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.payee_bank_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.payee_bank_name,chr(13),''),chr(10),'')  -- 
    ,t1.bail_amt  -- 
    ,t1.cur_code  -- 
    ,replace(replace(t1.loan_bin,chr(13),''),chr(10),'')  -- 
    ,t1.loan_label  -- 
    ,replace(replace(t1.loan_class_name,chr(13),''),chr(10),'')  -- 
    ,t1.avail_quota  -- 
    ,replace(replace(t1.realtiveapplyserialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.exchangedate,chr(13),''),chr(10),'')  -- 
    ,t1.deduct_min_amt  -- 
    ,replace(replace(t1.rateserialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.supply_acct_no,chr(13),''),chr(10),'')  -- 
    ,t1.ext_rafe_f_prop  -- 
    ,replace(replace(t1.agent_flag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mfcustomerid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.supply_acct_no2,chr(13),''),chr(10),'')  -- 定期存款账号2
    ,t1.ext_day2  -- 定期分账号2
    ,t1.ext_rafe_f_prop2  -- 定期比例2(%)
    ,replace(replace(t1.supply_acct_no3,chr(13),''),chr(10),'')  -- 定期存款账号3
    ,t1.ext_day3  -- 定期分账号3
    ,t1.ext_rafe_f_prop3  -- 定期比例3(%)
    ,replace(replace(t1.supply_acct_no4,chr(13),''),chr(10),'')  -- 定期存款账号4
    ,t1.ext_day4  -- 定期分账号4
    ,t1.ext_rafe_f_prop4  -- 定期比例4(%)
    ,replace(replace(t1.supply_acct_no5,chr(13),''),chr(10),'')  -- 定期存款账号5
    ,t1.ext_day5  -- 定期分账号5
    ,t1.ext_rafe_f_prop5  -- 定期比例5(%)
    ,replace(replace(t1.classify4change,chr(13),''),chr(10),'')  -- 四级分类形态转列
    ,t1.depositrate  -- 存单质押比例（%）
    ,t1.depositsum  -- 存单质押金额
    ,replace(replace(t1.depositcurrency,chr(13),''),chr(10),'')  -- 存单质押币种（默认人民币）
    ,t1.chowmatisticsum  -- 理财产品质押金额
    ,replace(replace(t1.chowmatisticcurrency,chr(13),''),chr(10),'')  -- 理财产品币种(默认人民币)
    ,t1.overfinerate  -- 逾期罚息比例(%)
    ,t1.chowmatisticrate  -- 理财产品质押比例(%)
    ,replace(replace(t1.repayplag,chr(13),''),chr(10),'')  -- 还款计划是否发送核心
    ,t1.latestpaydays  -- 最迟回笼天数
    ,replace(replace(t1.elecflag,chr(13),''),chr(10),'')  -- 是否电票标志
    ,replace(replace(t1.discounttype,chr(13),''),chr(10),'')  -- 贴现类型
    ,replace(replace(t1.interestenddate,chr(13),''),chr(10),'')  -- 计息到期日
    ,t1.interestdays  -- 计息天数
    ,t1.interest  -- 利息
    ,t1.payinterest  -- 买方付息利息
    ,replace(replace(t1.businessserialno,chr(13),''),chr(10),'')  -- 业务流水号
    ,replace(replace(t1.elecexchangestate,chr(13),''),chr(10),'')  -- 电票交易状态
    ,replace(replace(t1.paymenttype,chr(13),''),chr(10),'')  -- 支付方式
    ,replace(replace(t1.loantermflag,chr(13),''),chr(10),'')  -- 贷款期限单位
    ,replace(replace(t1.ratemode,chr(13),''),chr(10),'')  -- 利率模式
    ,t1.gaincyc  -- 递变周期
    ,t1.gainamount  -- 递变幅度
    ,replace(replace(t1.mainrepaymentmethod,chr(13),''),chr(10),'')  -- 主还款方式
    ,replace(replace(t1.repaymentmethod,chr(13),''),chr(10),'')  -- 还款方式
    ,replace(replace(t1.incomeorgid,chr(13),''),chr(10),'')  -- 入账机构
    ,replace(replace(t1.payaccountno,chr(13),''),chr(10),'')  -- 还款账号
    ,replace(replace(t1.putoutstatus,chr(13),''),chr(10),'')  -- 出账状态
    ,t1.holdcorpus  -- 保留金额
    ,t1.defaultpaydate  -- 默认还款日
    ,replace(replace(t1.payaccountno1,chr(13),''),chr(10),'')  -- 贴息账号
    ,replace(replace(t1.payaccountname,chr(13),''),chr(10),'')  -- 还款账户名
    ,replace(replace(t1.payaccountname1,chr(13),''),chr(10),'')  -- 贴息账户名
    ,replace(replace(t1.amortizeterm,chr(13),''),chr(10),'')  -- 总摊还期限
    ,replace(replace(t1.graceperioddate,chr(13),''),chr(10),'')  -- 宽限期限
    ,replace(replace(t1.pdgtype,chr(13),''),chr(10),'')  -- 手续费类型
    ,replace(replace(t1.customstamptax,chr(13),''),chr(10),'')  -- 是否代客户缴印花税
    ,replace(replace(t1.loanaccountnotype,chr(13),''),chr(10),'')  -- 入款账号类型
    ,replace(replace(t1.defaultpayacctnotype,chr(13),''),chr(10),'')  -- 还款账号类型
    ,replace(replace(t1.trustaccno,chr(13),''),chr(10),'')  -- 委托人账号
    ,replace(replace(t1.trustaccname,chr(13),''),chr(10),'')  -- 委托人账户名
    ,replace(replace(t1.trustaccnotype,chr(13),''),chr(10),'')  -- 委托账户类型
    ,replace(replace(t1.trustfundacctno,chr(13),''),chr(10),'')  -- 委托人基金专户
    ,replace(replace(t1.trustfundacctname,chr(13),''),chr(10),'')  -- 委托贷款基金专户名
    ,replace(replace(t1.designatedate,chr(13),''),chr(10),'')  -- 利率调整日期
    ,t1.cyclemonths  -- 指定月的利率重定价月数
    ,replace(replace(t1.issmallcorporation,chr(13),''),chr(10),'')  -- 是否小微企业标识
    ,replace(replace(t1.istiexi,chr(13),''),chr(10),'')  -- 是否贴息
    ,t1.subsidyprop  -- 贴息比例
    ,replace(replace(t1.repriceflag,chr(13),''),chr(10),'')  -- 利率调整模式
    ,replace(replace(t1.channelno,chr(13),''),chr(10),'')  -- 渠道号
    ,replace(replace(t1.flag7,chr(13),''),chr(10),'')  -- 是否超额度期限
    ,replace(replace(t1.farmingtype,chr(13),''),chr(10),'')  -- 是否涉农贷款
    ,replace(replace(t1.paymentmode,chr(13),''),chr(10),'')  -- 支付方式
    ,replace(replace(t1.businesssource,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.payaccountno2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.payaccountname2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.clearanceacctnotype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.trustdepositaccnotype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paloaninsureid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businessratetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.payment,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.payername,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.payerbankname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.payerbankaccounts,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isavouch,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.specialaccountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.uncheckaccountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isgroupcredit,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pdgaccountnoname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.dkaccountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.dkaccountname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fineratemode,chr(13),''),chr(10),'')  -- 
    ,t1.finerate  -- 
    ,replace(replace(t1.tempsaveflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paysource,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.contextinfo,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.drawingtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fineratetype,chr(13),''),chr(10),'')  -- 罚息利率类型
    ,replace(replace(t1.fineratefloattype,chr(13),''),chr(10),'')  -- 罚息利率浮动方式
    ,replace(replace(t1.normalpayorder,chr(13),''),chr(10),'')  -- 正常还款顺序
    ,replace(replace(t1.overduepayorder,chr(13),''),chr(10),'')  -- 逾期还款顺序
    ,t1.fineratefloat  -- 
    ,t1.baserate  -- 
    ,t1.ratefloat  -- 
    ,replace(replace(t1.batchpaymentflag,chr(13),''),chr(10),'')  -- 批量还款标志
    ,replace(replace(t1.relativeduebillserialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.clearanceacctno,chr(13),''),chr(10),'')  -- 结算账号
    ,replace(replace(t1.clearanceacctname,chr(13),''),chr(10),'')  -- 结算账号户名
    ,replace(replace(t1.loankind,chr(13),''),chr(10),'')  -- 期限类型
    ,replace(replace(t1.gjjratemode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.gjjbaseratetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.gjjratefloattype,chr(13),''),chr(10),'')  -- 
    ,t1.gjjbaserate  -- 
    ,t1.gjjratefloat  -- 
    ,t1.gjjbusinessrate  -- 
    ,replace(replace(t1.gjjrepaymentmethod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.gjjpaycyc,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.gjjadjustratetype,chr(13),''),chr(10),'')  -- 
    ,t1.gjjgaincyc  -- 
    ,t1.gjjgainamount  -- 
    ,t1.gjjholdcorpus  -- 
    ,replace(replace(t1.gjjamortizeterm,chr(13),''),chr(10),'')  -- 
    ,t1.gjjbusinesssum  -- 
    ,replace(replace(t1.gjjmainrepaymentmethod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.gjjgraceperioddate,chr(13),''),chr(10),'')  -- 
    ,t1.gjjcyclemonths  -- 
    ,replace(replace(t1.gjjdesignatedate,chr(13),''),chr(10),'')  -- 
    ,t1.sybusinesssum  -- 
    ,replace(replace(t1.gjjfineratetype,chr(13),''),chr(10),'')  -- 
    ,t1.gjjfinerate  -- 
    ,replace(replace(t1.gjjfineratemode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.gjjfineratefloattype,chr(13),''),chr(10),'')  -- 
    ,t1.gjjfineratefloat  -- 
    ,replace(replace(t1.assistuserid,chr(13),''),chr(10),'')  -- 协办客户经理
    ,replace(replace(t1.relativebpserialno,chr(13),''),chr(10),'')  -- 关联放贷流水号
    ,replace(replace(t1.curtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.payaccountnoattr,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.trustaccountnoattr,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paymode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.issignuplloan,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.repaymentplanflag,chr(13),''),chr(10),'')  -- 信贷发放还款计划标志
    ,replace(replace(t1.userid,chr(13),''),chr(10),'')  -- 用户编号
    ,replace(replace(t1.begintime,chr(13),''),chr(10),'')  -- 开始时间
    ,replace(replace(t1.actualbegintime,chr(13),''),chr(10),'')  -- 实际开始时间
    ,replace(replace(t1.endtime,chr(13),''),chr(10),'')  -- 结束时间
    ,replace(replace(t1.riskacctno,chr(13),''),chr(10),'')  -- 风险金账户
    ,replace(replace(t1.riskacctname,chr(13),''),chr(10),'')  -- 风险金账户名
    ,t1.risksum  -- 代扣风险金金额
    ,t1.otherfee  -- 其他费用金额
    ,replace(replace(t1.subbusinesstype,chr(13),''),chr(10),'')  -- 助贷业务品种
    ,replace(replace(t1.warrantorid,chr(13),''),chr(10),'')  -- 主要担保人编码
    ,replace(replace(t1.warrantor,chr(13),''),chr(10),'')  -- 主要担保人
    ,replace(replace(t1.payaccountname3,chr(13),''),chr(10),'')  -- 第二还款账户名
    ,replace(replace(t1.payaccountno3,chr(13),''),chr(10),'')  -- 第二还款账户
    ,replace(replace(t1.crstrandate,chr(13),''),chr(10),'')  -- 正向交易日期
    ,replace(replace(t1.crstranseqno,chr(13),''),chr(10),'')  -- 正向交易流水号
    ,t1.start_dt  -- 
    ,t1.end_dt  -- 
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.crss_upl_business_putout t1    --微贷业务出账表
where t1.start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_crss_upl_business_putout',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);