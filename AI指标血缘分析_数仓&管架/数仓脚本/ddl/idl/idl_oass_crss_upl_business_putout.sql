/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_crss_upl_business_putout
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.oass_crss_upl_business_putout
whenever sqlerror continue none;
drop table ${idl_schema}.oass_crss_upl_business_putout purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.oass_crss_upl_business_putout(
    etl_dt date -- 数据日期
    ,serialno varchar2(32) -- 流水号
    ,customerid varchar2(32) -- 客户编号
    ,customername varchar2(80) -- 客户名称
    ,businesstype varchar2(18) -- 贷款品种
    ,businesscurrency varchar2(18) -- 币种
    ,businesssum number(24,6) -- 贷款金额
    ,termyear number -- 年
    ,termmonth number -- 月
    ,termday number -- 日
    ,putoutdate varchar2(10) -- 出账日期
    ,maturity varchar2(10) -- 到账日期
    ,businessrate number(24,10) -- 利率
    ,ictype varchar2(18) -- 计息方式
    ,iccyc varchar2(18) -- 计息周期
    ,paycyc varchar2(18) -- 还款周期
    ,corpuspaymethod varchar2(18) -- 还款方式
    ,subjectno varchar2(18) -- 科目号
    ,dealbegintime varchar2(20) -- 处理开始时间
    ,dealendtime varchar2(20) -- 处理结束时间
    ,dealflag varchar2(1) -- 处理状态
    ,operateorgid varchar2(32) -- 经办机构
    ,operateuserid varchar2(32) -- 经办人
    ,operatedate varchar2(10) -- 
    ,inputorgid varchar2(32) -- 登记机构
    ,inputuserid varchar2(32) -- 登记人
    ,inputdate varchar2(10) -- 登记日期
    ,updatedate varchar2(10) -- 更新日期
    ,pigeonholedate varchar2(10) -- 终结日期
    ,remark varchar2(200) -- 备注
    ,occurdate varchar2(10) -- 发生日期
    ,baseratetype varchar2(18) -- 基准利率
    ,ratefloattype varchar2(18) -- 
    ,contractserialno varchar2(32) -- 合同流水号
    ,duebillserialno varchar2(32) -- 借据流水号
    ,artificialno varchar2(60) -- 
    ,relativeaccountno varchar2(32) -- 
    ,accountno varchar2(32) -- 
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
    ,bailaccount varchar2(32) -- 
    ,aboutbankid varchar2(32) -- 
    ,billsum number(24,6) -- 
    ,ratetype varchar2(18) -- 
    ,billrisk number -- 
    ,openbankname varchar2(80) -- 
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
    ,mfeepaymethod varchar2(20) -- 
    ,securitiestype varchar2(20) -- 
    ,type8 varchar2(200) -- 
    ,type9 varchar2(200) -- 
    ,thirdpartyaccounts varchar2(40) -- 
    ,thirdpartyid1 varchar2(100) -- 
    ,ccyc varchar2(18) -- 
    ,loanterm varchar2(18) -- 
    ,relativeputoutno varchar2(32) -- 
    ,multi_loan_flag varchar2(10) -- 
    ,multi_pay_flag varchar2(10) -- 
    ,ass_mode varchar2(10) -- 
    ,trust_pay_flag varchar2(10) -- 
    ,fee_mode varchar2(10) -- 
    ,pay_mode varchar2(10) -- 
    ,act_flag varchar2(10) -- 
    ,repay_mode varchar2(10) -- 
    ,ass_type varchar2(10) -- 
    ,bran_code varchar2(20) -- 
    ,deal_bran_code varchar2(20) -- 
    ,accept_bank_no varchar2(20) -- 
    ,contract_no varchar2(40) -- 
    ,apply_no varchar2(40) -- 
    ,cust_no varchar2(30) -- 
    ,ext_contract_no varchar2(30) -- 
    ,lc_no varchar2(20) -- 
    ,acct_seqno number -- 
    ,bill_no varchar2(20) -- 
    ,lc_code varchar2(20) -- 
    ,trust_loan_acct_no varchar2(32) -- 
    ,bail_acct_no varchar2(32) -- 
    ,pay_acct_no varchar2(32) -- 
    ,release_acct_no varchar2(32) -- 
    ,drawing_acct_no varchar2(32) -- 
    ,payee_acct_no varchar2(32) -- 
    ,cust_acct_no varchar2(32) -- 
    ,loan_class varchar2(20) -- 
    ,new_loan_class varchar2(20) -- 
    ,bill_type varchar2(10) -- 
    ,cust_name varchar2(80) -- 
    ,drawing_name varchar2(80) -- 
    ,payee_acct_name varchar2(80) -- 
    ,accept_name varchar2(80) -- 
    ,ben_acct_name varchar2(80) -- 
    ,functionary varchar2(20) -- 
    ,bail_cur_code number -- 
    ,fee_cur_code number -- 
    ,loan_amt number(16,2) -- 
    ,trust_charge_amt number(16,2) -- 
    ,fee number(16,2) -- 
    ,repay_amt number(16,2) -- 
    ,credited_amt number(16,2) -- 
    ,max_quota number(16,2) -- 
    ,draft_amt number(16,2) -- 
    ,bill_amt number(16,2) -- 
    ,start_date varchar2(10) -- 
    ,due_date varchar2(10) -- 
    ,draw_date varchar2(10) -- 
    ,setup_date varchar2(10) -- 
    ,prof_day number -- 
    ,overdraft_day number -- 
    ,ext_day number -- 
    ,int_rate_market number -- 
    ,int_rate_cycle number -- 
    ,nor_int_code number -- 
    ,nor_rate_f_mode varchar2(10) -- 
    ,nor_rate_f_prop number(11,4) -- 
    ,nor_int_rate number(11,4) -- 
    ,ext_rate_f_prop number(11,4) -- 
    ,ext_int_rate number(11,4) -- 
    ,int_mode varchar2(10) -- 
    ,nor_rate_adj_mode varchar2(10) -- 
    ,ovd_rate_f_prop number(11,4) -- 
    ,ovd_int_rate number(11,4) -- 
    ,trust_charge_rate number(11,4) -- 
    ,fee_rate number(11,4) -- 
    ,real_int_rate number(11,4) -- 
    ,prop number(11,4) -- 
    ,pay_prin_intvl number -- 
    ,max_apply_month number -- 
    ,main_purpose varchar2(40) -- 
    ,payee_bank_no varchar2(20) -- 
    ,payee_bank_name varchar2(80) -- 
    ,bail_amt number(16,2) -- 
    ,cur_code number -- 
    ,loan_bin varchar2(12) -- 
    ,loan_label number -- 
    ,loan_class_name varchar2(80) -- 
    ,avail_quota number(16,2) -- 
    ,realtiveapplyserialno varchar2(40) -- 
    ,exchangedate varchar2(20) -- 
    ,deduct_min_amt number(16,2) -- 
    ,rateserialno varchar2(40) -- 
    ,supply_acct_no varchar2(32) -- 
    ,ext_rafe_f_prop number(24,6) -- 
    ,agent_flag varchar2(32) -- 
    ,mfcustomerid varchar2(32) -- 
    ,supply_acct_no2 varchar2(32) -- 定期存款账号2
    ,ext_day2 number -- 定期分账号2
    ,ext_rafe_f_prop2 number(24,6) -- 定期比例2(%)
    ,supply_acct_no3 varchar2(32) -- 定期存款账号3
    ,ext_day3 number -- 定期分账号3
    ,ext_rafe_f_prop3 number(24,6) -- 定期比例3(%)
    ,supply_acct_no4 varchar2(32) -- 定期存款账号4
    ,ext_day4 number -- 定期分账号4
    ,ext_rafe_f_prop4 number(24,6) -- 定期比例4(%)
    ,supply_acct_no5 varchar2(32) -- 定期存款账号5
    ,ext_day5 number -- 定期分账号5
    ,ext_rafe_f_prop5 number(24,6) -- 定期比例5(%)
    ,classify4change varchar2(10) -- 四级分类形态转列
    ,depositrate number(24,6) -- 存单质押比例（%）
    ,depositsum number(24,6) -- 存单质押金额
    ,depositcurrency varchar2(18) -- 存单质押币种（默认人民币）
    ,chowmatisticsum number(24,6) -- 理财产品质押金额
    ,chowmatisticcurrency varchar2(18) -- 理财产品币种(默认人民币)
    ,overfinerate number(24,6) -- 逾期罚息比例(%)
    ,chowmatisticrate number(24,6) -- 理财产品质押比例(%)
    ,repayplag varchar2(2) -- 还款计划是否发送核心
    ,latestpaydays number -- 最迟回笼天数
    ,elecflag varchar2(1) -- 是否电票标志
    ,discounttype varchar2(10) -- 贴现类型
    ,interestenddate varchar2(10) -- 计息到期日
    ,interestdays number(10) -- 计息天数
    ,interest number(24,6) -- 利息
    ,payinterest number(24,6) -- 买方付息利息
    ,businessserialno varchar2(40) -- 业务流水号
    ,elecexchangestate varchar2(18) -- 电票交易状态
    ,paymenttype varchar2(32) -- 支付方式
    ,loantermflag varchar2(3) -- 贷款期限单位
    ,ratemode varchar2(10) -- 利率模式
    ,gaincyc number -- 递变周期
    ,gainamount number(20,4) -- 递变幅度
    ,mainrepaymentmethod varchar2(10) -- 主还款方式
    ,repaymentmethod varchar2(10) -- 还款方式
    ,incomeorgid varchar2(32) -- 入账机构
    ,payaccountno varchar2(40) -- 还款账号
    ,putoutstatus varchar2(2) -- 出账状态
    ,holdcorpus number(20,4) -- 保留金额
    ,defaultpaydate number -- 默认还款日
    ,payaccountno1 varchar2(40) -- 贴息账号
    ,payaccountname varchar2(80) -- 还款账户名
    ,payaccountname1 varchar2(80) -- 贴息账户名
    ,amortizeterm varchar2(10) -- 总摊还期限
    ,graceperioddate varchar2(10) -- 宽限期限
    ,pdgtype varchar2(10) -- 手续费类型
    ,customstamptax varchar2(1) -- 是否代客户缴印花税
    ,loanaccountnotype varchar2(1) -- 入款账号类型
    ,defaultpayacctnotype varchar2(1) -- 还款账号类型
    ,trustaccno varchar2(40) -- 委托人账号
    ,trustaccname varchar2(80) -- 委托人账户名
    ,trustaccnotype varchar2(1) -- 委托账户类型
    ,trustfundacctno varchar2(40) -- 委托人基金专户
    ,trustfundacctname varchar2(40) -- 委托贷款基金专户名
    ,designatedate varchar2(10) -- 利率调整日期
    ,cyclemonths number -- 指定月的利率重定价月数
    ,issmallcorporation varchar2(10) -- 是否小微企业标识
    ,istiexi varchar2(1) -- 是否贴息
    ,subsidyprop number(20,4) -- 贴息比例
    ,repriceflag varchar2(2) -- 利率调整模式
    ,channelno varchar2(80) -- 渠道号
    ,flag7 varchar2(18) -- 是否超额度期限
    ,farmingtype varchar2(1) -- 是否涉农贷款
    ,paymentmode varchar2(10) -- 支付方式
    ,businesssource varchar2(32) -- 
    ,payaccountno2 varchar2(40) -- 
    ,payaccountname2 varchar2(80) -- 
    ,clearanceacctnotype varchar2(1) -- 
    ,trustdepositaccnotype varchar2(1) -- 
    ,paloaninsureid varchar2(32) -- 
    ,businessratetype varchar2(32) -- 
    ,payment varchar2(18) -- 
    ,payername varchar2(200) -- 
    ,payerbankname varchar2(80) -- 
    ,payerbankaccounts varchar2(80) -- 
    ,isavouch varchar2(1) -- 
    ,specialaccountno varchar2(40) -- 
    ,uncheckaccountno varchar2(40) -- 
    ,isgroupcredit varchar2(18) -- 
    ,pdgaccountnoname varchar2(80) -- 
    ,dkaccountno varchar2(32) -- 
    ,dkaccountname varchar2(80) -- 
    ,fineratemode varchar2(10) -- 
    ,finerate number(24,10) -- 
    ,tempsaveflag varchar2(18) -- 
    ,paysource varchar2(500) -- 
    ,contextinfo varchar2(200) -- 
    ,drawingtype varchar2(18) -- 
    ,fineratetype varchar2(3) -- 罚息利率类型
    ,fineratefloattype varchar2(3) -- 罚息利率浮动方式
    ,normalpayorder varchar2(10) -- 正常还款顺序
    ,overduepayorder varchar2(10) -- 逾期还款顺序
    ,fineratefloat number(24,10) -- 
    ,baserate number(24,10) -- 
    ,ratefloat number(24,10) -- 
    ,batchpaymentflag varchar2(1) -- 批量还款标志
    ,relativeduebillserialno varchar2(40) -- 
    ,clearanceacctno varchar2(40) -- 结算账号
    ,clearanceacctname varchar2(80) -- 结算账号户名
    ,loankind varchar2(10) -- 期限类型
    ,gjjratemode varchar2(10) -- 
    ,gjjbaseratetype varchar2(10) -- 
    ,gjjratefloattype varchar2(10) -- 
    ,gjjbaserate number(24,6) -- 
    ,gjjratefloat number(24,6) -- 
    ,gjjbusinessrate number(24,6) -- 
    ,gjjrepaymentmethod varchar2(20) -- 
    ,gjjpaycyc varchar2(10) -- 
    ,gjjadjustratetype varchar2(10) -- 
    ,gjjgaincyc number -- 
    ,gjjgainamount number(24,6) -- 
    ,gjjholdcorpus number(24,6) -- 
    ,gjjamortizeterm varchar2(10) -- 
    ,gjjbusinesssum number(24,6) -- 
    ,gjjmainrepaymentmethod varchar2(20) -- 
    ,gjjgraceperioddate varchar2(10) -- 
    ,gjjcyclemonths number -- 
    ,gjjdesignatedate varchar2(10) -- 
    ,sybusinesssum number(24,6) -- 
    ,gjjfineratetype varchar2(3) -- 
    ,gjjfinerate number(24,10) -- 
    ,gjjfineratemode varchar2(10) -- 
    ,gjjfineratefloattype varchar2(3) -- 
    ,gjjfineratefloat number(24,10) -- 
    ,assistuserid varchar2(32) -- 协办客户经理
    ,relativebpserialno varchar2(32) -- 关联放贷流水号
    ,curtype varchar2(10) -- 
    ,payaccountnoattr varchar2(10) -- 
    ,trustaccountnoattr varchar2(10) -- 
    ,paymode varchar2(1) -- 
    ,issignuplloan varchar2(2) -- 
    ,repaymentplanflag varchar2(1) -- 信贷发放还款计划标志
    ,userid varchar2(32) -- 用户编号
    ,begintime varchar2(20) -- 开始时间
    ,actualbegintime varchar2(20) -- 实际开始时间
    ,endtime varchar2(20) -- 结束时间
    ,riskacctno varchar2(200) -- 风险金账户
    ,riskacctname varchar2(80) -- 风险金账户名
    ,risksum number(24,6) -- 代扣风险金金额
    ,otherfee number(24,6) -- 其他费用金额
    ,subbusinesstype varchar2(32) -- 助贷业务品种
    ,warrantorid varchar2(32) -- 主要担保人编码
    ,warrantor varchar2(132) -- 主要担保人
    ,payaccountname3 varchar2(80) -- 第二还款账户名
    ,payaccountno3 varchar2(40) -- 第二还款账户
    ,crstrandate varchar2(10) -- 正向交易日期
    ,crstranseqno varchar2(40) -- 正向交易流水号
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
grant select on ${idl_schema}.oass_crss_upl_business_putout to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_crss_upl_business_putout is '微贷业务出账表';
comment on column ${idl_schema}.oass_crss_upl_business_putout.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_crss_upl_business_putout.serialno is '流水号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.customerid is '客户编号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.customername is '客户名称';
comment on column ${idl_schema}.oass_crss_upl_business_putout.businesstype is '贷款品种';
comment on column ${idl_schema}.oass_crss_upl_business_putout.businesscurrency is '币种';
comment on column ${idl_schema}.oass_crss_upl_business_putout.businesssum is '贷款金额';
comment on column ${idl_schema}.oass_crss_upl_business_putout.termyear is '年';
comment on column ${idl_schema}.oass_crss_upl_business_putout.termmonth is '月';
comment on column ${idl_schema}.oass_crss_upl_business_putout.termday is '日';
comment on column ${idl_schema}.oass_crss_upl_business_putout.putoutdate is '出账日期';
comment on column ${idl_schema}.oass_crss_upl_business_putout.maturity is '到账日期';
comment on column ${idl_schema}.oass_crss_upl_business_putout.businessrate is '利率';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ictype is '计息方式';
comment on column ${idl_schema}.oass_crss_upl_business_putout.iccyc is '计息周期';
comment on column ${idl_schema}.oass_crss_upl_business_putout.paycyc is '还款周期';
comment on column ${idl_schema}.oass_crss_upl_business_putout.corpuspaymethod is '还款方式';
comment on column ${idl_schema}.oass_crss_upl_business_putout.subjectno is '科目号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.dealbegintime is '处理开始时间';
comment on column ${idl_schema}.oass_crss_upl_business_putout.dealendtime is '处理结束时间';
comment on column ${idl_schema}.oass_crss_upl_business_putout.dealflag is '处理状态';
comment on column ${idl_schema}.oass_crss_upl_business_putout.operateorgid is '经办机构';
comment on column ${idl_schema}.oass_crss_upl_business_putout.operateuserid is '经办人';
comment on column ${idl_schema}.oass_crss_upl_business_putout.operatedate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.inputorgid is '登记机构';
comment on column ${idl_schema}.oass_crss_upl_business_putout.inputuserid is '登记人';
comment on column ${idl_schema}.oass_crss_upl_business_putout.inputdate is '登记日期';
comment on column ${idl_schema}.oass_crss_upl_business_putout.updatedate is '更新日期';
comment on column ${idl_schema}.oass_crss_upl_business_putout.pigeonholedate is '终结日期';
comment on column ${idl_schema}.oass_crss_upl_business_putout.remark is '备注';
comment on column ${idl_schema}.oass_crss_upl_business_putout.occurdate is '发生日期';
comment on column ${idl_schema}.oass_crss_upl_business_putout.baseratetype is '基准利率';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ratefloattype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.contractserialno is '合同流水号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.duebillserialno is '借据流水号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.artificialno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.relativeaccountno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.accountno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.loanaccountno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.loantype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.creditlineflag is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.creditaggreement is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.contractsum is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.purpose is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.adjustratetype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.fixcyc is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.backrate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.acceptinttype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.preinttype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.resumeinttype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.secondpayaccount is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.overinttype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.rateadjustcyc is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.guarantyno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.riskrate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.consignaccountno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.mostlyduebillno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.negotiateno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.creditkind is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.pdgsum is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.pdgaccountno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.pdgpaymethod is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.businesssubtype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.businesssubtype1 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.exchangetype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.exchangestate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.exchangeserialno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.adjustrateterm is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.projectno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.fzaccountno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.fzanbalance is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ccode is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.cdate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.fzguabalance is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.pztype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.billno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gatheringname is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.aboutbankname is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.interserialno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.billresource is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.bailaccount is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.aboutbankid is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.billsum is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ratetype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.billrisk is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.openbankname is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.openbankadd is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.openbankzip is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.type1 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.type2 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.type3 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.type4 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.type5 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.type6 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.type7 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.aboutbankid2 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.aboutbankname2 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.aboutbankid3 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.name1 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.address1 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.name2 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.address2 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.zip2 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.address3 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.term1 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.term2 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.term3 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.vouchtype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.bailcurrency is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.bailratio is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.mfeepaymethod is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.securitiestype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.type8 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.type9 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.thirdpartyaccounts is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.thirdpartyid1 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ccyc is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.loanterm is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.relativeputoutno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.multi_loan_flag is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.multi_pay_flag is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ass_mode is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.trust_pay_flag is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.fee_mode is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.pay_mode is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.act_flag is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.repay_mode is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ass_type is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.bran_code is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.deal_bran_code is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.accept_bank_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.contract_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.apply_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.cust_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ext_contract_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.lc_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.acct_seqno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.bill_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.lc_code is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.trust_loan_acct_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.bail_acct_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.pay_acct_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.release_acct_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.drawing_acct_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payee_acct_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.cust_acct_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.loan_class is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.new_loan_class is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.bill_type is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.cust_name is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.drawing_name is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payee_acct_name is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.accept_name is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ben_acct_name is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.functionary is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.bail_cur_code is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.fee_cur_code is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.loan_amt is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.trust_charge_amt is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.fee is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.repay_amt is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.credited_amt is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.max_quota is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.draft_amt is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.bill_amt is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.start_date is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.due_date is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.draw_date is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.setup_date is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.prof_day is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.overdraft_day is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ext_day is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.int_rate_market is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.int_rate_cycle is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.nor_int_code is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.nor_rate_f_mode is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.nor_rate_f_prop is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.nor_int_rate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ext_rate_f_prop is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ext_int_rate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.int_mode is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.nor_rate_adj_mode is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ovd_rate_f_prop is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ovd_int_rate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.trust_charge_rate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.fee_rate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.real_int_rate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.prop is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.pay_prin_intvl is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.max_apply_month is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.main_purpose is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payee_bank_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payee_bank_name is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.bail_amt is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.cur_code is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.loan_bin is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.loan_label is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.loan_class_name is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.avail_quota is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.realtiveapplyserialno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.exchangedate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.deduct_min_amt is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.rateserialno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.supply_acct_no is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ext_rafe_f_prop is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.agent_flag is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.mfcustomerid is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.supply_acct_no2 is '定期存款账号2';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ext_day2 is '定期分账号2';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ext_rafe_f_prop2 is '定期比例2(%)';
comment on column ${idl_schema}.oass_crss_upl_business_putout.supply_acct_no3 is '定期存款账号3';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ext_day3 is '定期分账号3';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ext_rafe_f_prop3 is '定期比例3(%)';
comment on column ${idl_schema}.oass_crss_upl_business_putout.supply_acct_no4 is '定期存款账号4';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ext_day4 is '定期分账号4';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ext_rafe_f_prop4 is '定期比例4(%)';
comment on column ${idl_schema}.oass_crss_upl_business_putout.supply_acct_no5 is '定期存款账号5';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ext_day5 is '定期分账号5';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ext_rafe_f_prop5 is '定期比例5(%)';
comment on column ${idl_schema}.oass_crss_upl_business_putout.classify4change is '四级分类形态转列';
comment on column ${idl_schema}.oass_crss_upl_business_putout.depositrate is '存单质押比例（%）';
comment on column ${idl_schema}.oass_crss_upl_business_putout.depositsum is '存单质押金额';
comment on column ${idl_schema}.oass_crss_upl_business_putout.depositcurrency is '存单质押币种（默认人民币）';
comment on column ${idl_schema}.oass_crss_upl_business_putout.chowmatisticsum is '理财产品质押金额';
comment on column ${idl_schema}.oass_crss_upl_business_putout.chowmatisticcurrency is '理财产品币种(默认人民币)';
comment on column ${idl_schema}.oass_crss_upl_business_putout.overfinerate is '逾期罚息比例(%)';
comment on column ${idl_schema}.oass_crss_upl_business_putout.chowmatisticrate is '理财产品质押比例(%)';
comment on column ${idl_schema}.oass_crss_upl_business_putout.repayplag is '还款计划是否发送核心';
comment on column ${idl_schema}.oass_crss_upl_business_putout.latestpaydays is '最迟回笼天数';
comment on column ${idl_schema}.oass_crss_upl_business_putout.elecflag is '是否电票标志';
comment on column ${idl_schema}.oass_crss_upl_business_putout.discounttype is '贴现类型';
comment on column ${idl_schema}.oass_crss_upl_business_putout.interestenddate is '计息到期日';
comment on column ${idl_schema}.oass_crss_upl_business_putout.interestdays is '计息天数';
comment on column ${idl_schema}.oass_crss_upl_business_putout.interest is '利息';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payinterest is '买方付息利息';
comment on column ${idl_schema}.oass_crss_upl_business_putout.businessserialno is '业务流水号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.elecexchangestate is '电票交易状态';
comment on column ${idl_schema}.oass_crss_upl_business_putout.paymenttype is '支付方式';
comment on column ${idl_schema}.oass_crss_upl_business_putout.loantermflag is '贷款期限单位';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ratemode is '利率模式';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gaincyc is '递变周期';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gainamount is '递变幅度';
comment on column ${idl_schema}.oass_crss_upl_business_putout.mainrepaymentmethod is '主还款方式';
comment on column ${idl_schema}.oass_crss_upl_business_putout.repaymentmethod is '还款方式';
comment on column ${idl_schema}.oass_crss_upl_business_putout.incomeorgid is '入账机构';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payaccountno is '还款账号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.putoutstatus is '出账状态';
comment on column ${idl_schema}.oass_crss_upl_business_putout.holdcorpus is '保留金额';
comment on column ${idl_schema}.oass_crss_upl_business_putout.defaultpaydate is '默认还款日';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payaccountno1 is '贴息账号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payaccountname is '还款账户名';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payaccountname1 is '贴息账户名';
comment on column ${idl_schema}.oass_crss_upl_business_putout.amortizeterm is '总摊还期限';
comment on column ${idl_schema}.oass_crss_upl_business_putout.graceperioddate is '宽限期限';
comment on column ${idl_schema}.oass_crss_upl_business_putout.pdgtype is '手续费类型';
comment on column ${idl_schema}.oass_crss_upl_business_putout.customstamptax is '是否代客户缴印花税';
comment on column ${idl_schema}.oass_crss_upl_business_putout.loanaccountnotype is '入款账号类型';
comment on column ${idl_schema}.oass_crss_upl_business_putout.defaultpayacctnotype is '还款账号类型';
comment on column ${idl_schema}.oass_crss_upl_business_putout.trustaccno is '委托人账号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.trustaccname is '委托人账户名';
comment on column ${idl_schema}.oass_crss_upl_business_putout.trustaccnotype is '委托账户类型';
comment on column ${idl_schema}.oass_crss_upl_business_putout.trustfundacctno is '委托人基金专户';
comment on column ${idl_schema}.oass_crss_upl_business_putout.trustfundacctname is '委托贷款基金专户名';
comment on column ${idl_schema}.oass_crss_upl_business_putout.designatedate is '利率调整日期';
comment on column ${idl_schema}.oass_crss_upl_business_putout.cyclemonths is '指定月的利率重定价月数';
comment on column ${idl_schema}.oass_crss_upl_business_putout.issmallcorporation is '是否小微企业标识';
comment on column ${idl_schema}.oass_crss_upl_business_putout.istiexi is '是否贴息';
comment on column ${idl_schema}.oass_crss_upl_business_putout.subsidyprop is '贴息比例';
comment on column ${idl_schema}.oass_crss_upl_business_putout.repriceflag is '利率调整模式';
comment on column ${idl_schema}.oass_crss_upl_business_putout.channelno is '渠道号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.flag7 is '是否超额度期限';
comment on column ${idl_schema}.oass_crss_upl_business_putout.farmingtype is '是否涉农贷款';
comment on column ${idl_schema}.oass_crss_upl_business_putout.paymentmode is '支付方式';
comment on column ${idl_schema}.oass_crss_upl_business_putout.businesssource is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payaccountno2 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payaccountname2 is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.clearanceacctnotype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.trustdepositaccnotype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.paloaninsureid is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.businessratetype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payment is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payername is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payerbankname is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payerbankaccounts is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.isavouch is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.specialaccountno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.uncheckaccountno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.isgroupcredit is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.pdgaccountnoname is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.dkaccountno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.dkaccountname is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.fineratemode is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.finerate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.tempsaveflag is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.paysource is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.contextinfo is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.drawingtype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.fineratetype is '罚息利率类型';
comment on column ${idl_schema}.oass_crss_upl_business_putout.fineratefloattype is '罚息利率浮动方式';
comment on column ${idl_schema}.oass_crss_upl_business_putout.normalpayorder is '正常还款顺序';
comment on column ${idl_schema}.oass_crss_upl_business_putout.overduepayorder is '逾期还款顺序';
comment on column ${idl_schema}.oass_crss_upl_business_putout.fineratefloat is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.baserate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.ratefloat is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.batchpaymentflag is '批量还款标志';
comment on column ${idl_schema}.oass_crss_upl_business_putout.relativeduebillserialno is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.clearanceacctno is '结算账号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.clearanceacctname is '结算账号户名';
comment on column ${idl_schema}.oass_crss_upl_business_putout.loankind is '期限类型';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjratemode is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjbaseratetype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjratefloattype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjbaserate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjratefloat is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjbusinessrate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjrepaymentmethod is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjpaycyc is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjadjustratetype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjgaincyc is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjgainamount is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjholdcorpus is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjamortizeterm is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjbusinesssum is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjmainrepaymentmethod is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjgraceperioddate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjcyclemonths is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjdesignatedate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.sybusinesssum is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjfineratetype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjfinerate is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjfineratemode is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjfineratefloattype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.gjjfineratefloat is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.assistuserid is '协办客户经理';
comment on column ${idl_schema}.oass_crss_upl_business_putout.relativebpserialno is '关联放贷流水号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.curtype is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payaccountnoattr is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.trustaccountnoattr is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.paymode is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.issignuplloan is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.repaymentplanflag is '信贷发放还款计划标志';
comment on column ${idl_schema}.oass_crss_upl_business_putout.userid is '用户编号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.begintime is '开始时间';
comment on column ${idl_schema}.oass_crss_upl_business_putout.actualbegintime is '实际开始时间';
comment on column ${idl_schema}.oass_crss_upl_business_putout.endtime is '结束时间';
comment on column ${idl_schema}.oass_crss_upl_business_putout.riskacctno is '风险金账户';
comment on column ${idl_schema}.oass_crss_upl_business_putout.riskacctname is '风险金账户名';
comment on column ${idl_schema}.oass_crss_upl_business_putout.risksum is '代扣风险金金额';
comment on column ${idl_schema}.oass_crss_upl_business_putout.otherfee is '其他费用金额';
comment on column ${idl_schema}.oass_crss_upl_business_putout.subbusinesstype is '助贷业务品种';
comment on column ${idl_schema}.oass_crss_upl_business_putout.warrantorid is '主要担保人编码';
comment on column ${idl_schema}.oass_crss_upl_business_putout.warrantor is '主要担保人';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payaccountname3 is '第二还款账户名';
comment on column ${idl_schema}.oass_crss_upl_business_putout.payaccountno3 is '第二还款账户';
comment on column ${idl_schema}.oass_crss_upl_business_putout.crstrandate is '正向交易日期';
comment on column ${idl_schema}.oass_crss_upl_business_putout.crstranseqno is '正向交易流水号';
comment on column ${idl_schema}.oass_crss_upl_business_putout.start_dt is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.end_dt is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.id_mark is '';
comment on column ${idl_schema}.oass_crss_upl_business_putout.etl_timestamp is '';
