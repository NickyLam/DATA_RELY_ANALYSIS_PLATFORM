/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_bp_extend_d
CreateDate: 20251201
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_bp_extend_d drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_bp_extend_d add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${idl_schema}.icms_bp_extend_d;

-- 2.4 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_bp_extend_d (
etl_dt  --ETL处理时间
,serialno  --出账流水号
,billtype  --票据类型
,careflag  --是否托管
,paybankname  --代付行
,keyno  --票据唯一标识号
,tradesum1  --贸易融资相关金额1
,chaggeaddress  --地址（福费廷用）
,tradesum2  --贸易融资相关金额2
,resumeinttype  --计复息标志
,linkname  --联系人（福费廷用）
,aboutbankname  --受益人、收款人开户行行名
,bailpdrifm  --保证金利率浮动方式
,bfintg  --是否预收息or先付利息摊销标志
,accountopenbankname  --结算帐号开户行名称
,bailmaturity  --保证金到期日
,capitalreturnflag  --本金自动归还标志
,migtflag  --迁移标志：crs rcr ilc upl
,fbsnumber  --信用证编号\业务编号FBS
,assureorgid  --担保机构编号(我行分支机构)
,invoicenumber  --发票号码
,tradetype1  --代收或托收类型
,bailexchangestate  --保证金交易状态
,cdexchangedate  --承兑记账交易日期
,acptdate  --出票日
,loantype  --贷款类型
,czflag  --冲账标志
,paymode  --保函支付方式
,acceptorname  --承兑人名称
,othertxbalance  --买方付息金额
,accountnocustomer  --结算帐号客户名称
,tradedate1  --贸易融资相关日期1
,acceptorbankname  --承兑人开户行名称
,compoundintratio  --复利利率
,textno  --总合同文本编号（福费廷用）
,instrt  --同业代付计提利率（%）
,tradecurrecy2  --贸易融资相关币种2
,repaymentplanflag  --信贷发放还款计划标志
,chargephone  --电话（福费廷用）
,tradetermmonth2  --贸易融资相关期限2
,ratestartmode  --利率启用方式
,autocontrolflag  --自动回收控制开关
,loantermthing  --放款条件是否落实
,bailfxfltp  --保证金利率类型
,gatheringname  --收票人全称
,principalaccountno  --委托存款账号
,openbankname  --出口信用证开证行名称、开证行ID
,aboutbankname2  --保函受益人
,preinttype  --预收息标志
,loantermcontrolflag  --出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
,acceptancebank  --承兑行行号（福费廷）
,tradedate2  --贸易融资相关日期2
,otherdraweracctno  --买方付息账户号
,principalsubaccountno  --委托存款子户号
,continuepayflag  --持续扣款标志
,billno  --票据号码
,approveorgid  --复核机构
,clientaccountno  --委托人存款账号
,repayexchangestate  --还款计划交易状态
,chargename  --负责人（福费廷用）
,commercetype  --贸易融资类型
,tradetermmonth1  --贸易融资相关期限1
,dprinpaymethod  --代付本金还款方式
,lprtype  --LPR参照方式
,loanaccountnoorgname  --贷款帐号开户行名称
,isrz  --是否融资系统出账1是0否
,period  --分期贷款总期数
,approveuserid  --复核人
,traderate1  --福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
,repurchaseflag  --是否回购（赎回）
,deposittermtype  --保证金期限类型
,linkphone  --联系人手机号（福费廷用）
,termtype  --期限类型
,loanaccountnocustomer  --贷款帐号客户名称
,pdgpaypercent2  --手续费率(委托贷款)
,bailinterestrate  --保证金协议利率
,cdexchangeno  --承兑记账交易流水号
,businesssubtype  --保函类型
,tradeserialno1  --贸易融资业务编号1
,txregister  --票据登记状态
,amlresult  --反洗钱评级结果
,compoundintfloatvalue  --复利利率浮动比例
,paysum  --工本费
,name1  --汇票承兑人名称
,fundsource  --资金来源
,stopintflag  --是否停息
,lnbal  --同业代付本金
,acceptorbankno  --承兑人开户行行号
,confirmingbank  --保兑行行号（福费廷）
,chargefax  --传真（福费廷用）
,pdgsum2  --手续费金额(元)(承兑汇票)
,depositbaserate  --存款基准利率
,lcsum  --信用证金额（元）
,traderate2  --贸易融资相关比例或利率2
,tradecurrecy1  --贸易融资相关币种1
,isfinanceguarantee  --是否融资性保函
,putoutno  --出账号
,bailpdrifd  --保证金利率浮动类型
,depositterm  --存期期限
,billclass  --票据种类
,tradesum3  --贸易融资相关金额3
,tradecurrecy3  --贸易融资相关币种3
,queryabnormitything  --贷款卡当日查询是否有异常情况
,creditaggreement  --使用授信额度协议号
,exchangetype  --出帐交易代码
,bailterm  --保证金利率档次
,bailpdrifv  --保证金浮动值
,interestreturnflag  --利息自动归还标志
,compoundintflag  --是否收复息标志
,chargepost  --职务（福费廷用）
,isbankaccount  --受益人账号是否本行
,fixcyc  --计息天数
,ordinaryormonthly  --普通分期还款标志
,unpaidbankname  --代付行名称
,approvedate  --复核日期
,linkemail  --联系人电子邮箱（福费廷用）
,discountsum  --利息金额
,loanaccountno2  --贷款帐号
,abnormitything  --贷款卡异常情况说明
,tradeserialno2  --贸易融资业务编号2
,bailinterestmethod  --保证金计息方法
,trantp  --手续费收费方式(票据)
,poolfinancingflag  --是否已签订池融资协议
,isbelongterm  --是否靠档计息
,contractsignfee  --签约手续费
,aboutbankid  --信用证受益人客户号
,isfixedrate  --利率是否固定
,opencustomer  --信用证开证人
,sellstatus  --卖出状态
,otherreceivedbankno  --对方收款行号
,otherreceivedname  --对方收款账号
,otherreceivedaccname  --对方收款户名
,otherreceivedbankname  --对方收款行名称
,creditbeneficiary  --信用证收益人名称
,actualloanaccountno  --贷款实际入账账号
,replaceolddept  --是否置换旧债
,isproxydp  --是否代理交单
,sqdkze  --申请银团贷款总额
,socialcreditcode  --统一社会信用代码
,buychannel  --买入渠道
,islinkoutpay  --是否联动对外支付
,post  --附言
,payinterestcustomer  --付息客户
,purchasercustflag  --买方是否为我行客户
,othercustomerid  --买方客户号
,othercustomername  --买方客户名称
,finalmerger  --是否末期合并：0否，1是
,lcsumrate  --信用证金额上浮比例
,linkchargeintflag  --是否联动扣收利息
,isactualddamtflag  --是否按实际放款金额冻结标志
,maxpdrifv  --保证金浮动上限
,ismergeentrpayment  --是否合并受托支付
,ownfunds  --自有资金
,ownfundsacctno  --自有资金账号
,ownfundsacctname  --自有资金账户名称
,ownfundsacctccy  --自有资金账户币种
,arrivalnumbers  --到单编号
,claimamount  --索偿金额
,businessamount  --业务金额
,marketflows  --市场流转次数，含到我行
,servicecontent  --货物/服务品种
,scanstatus  --扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
,priceorderno  --定价单号
,priceapprovestatus  --定价单审批状态
,priceenddate  --定价单生效截止日
,pledgetype  --质押类型
,submitputoutcentertime  --提交放款中心时间
,iscentralizedaccount  --是否集中出账
,issuedbusinessno  --代开保函业务编号
,bhstartdate  --保函生效日期
,bhmaturity  --保函失效日期
,guaranteebusinessno  --保函业务编号
,guaranteesum  --保函金额
,issuedate  --开立日期
,guaranteeputoutstatus  --保函信息状态(code:guaranteeputoutstatus)
,isreplenishment  --是否补录完成
,scanuserid  --扫描人
,scanusername  --扫描人名称
,bizuniqueno  --业务唯一流水号（票据/供应链）
,isxdapprove  --是否信贷审批（票据/供应链推送流程）
,isignoreresult  --是否忽略不动产查册策略结果

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理时间
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --出账流水号
,replace(replace(t1.billtype,chr(13),''),chr(10),'') as billtype --票据类型
,replace(replace(t1.careflag,chr(13),''),chr(10),'') as careflag --是否托管
,replace(replace(t1.paybankname,chr(13),''),chr(10),'') as paybankname --代付行
,replace(replace(t1.keyno,chr(13),''),chr(10),'') as keyno --票据唯一标识号
,t1.tradesum1 as tradesum1 --贸易融资相关金额1
,replace(replace(t1.chaggeaddress,chr(13),''),chr(10),'') as chaggeaddress --地址（福费廷用）
,t1.tradesum2 as tradesum2 --贸易融资相关金额2
,replace(replace(t1.resumeinttype,chr(13),''),chr(10),'') as resumeinttype --计复息标志
,replace(replace(t1.linkname,chr(13),''),chr(10),'') as linkname --联系人（福费廷用）
,replace(replace(t1.aboutbankname,chr(13),''),chr(10),'') as aboutbankname --受益人、收款人开户行行名
,replace(replace(t1.bailpdrifm,chr(13),''),chr(10),'') as bailpdrifm --保证金利率浮动方式
,replace(replace(t1.bfintg,chr(13),''),chr(10),'') as bfintg --是否预收息or先付利息摊销标志
,replace(replace(t1.accountopenbankname,chr(13),''),chr(10),'') as accountopenbankname --结算帐号开户行名称
,replace(replace(t1.bailmaturity,chr(13),''),chr(10),'') as bailmaturity --保证金到期日
,replace(replace(t1.capitalreturnflag,chr(13),''),chr(10),'') as capitalreturnflag --本金自动归还标志
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crs rcr ilc upl
,replace(replace(t1.fbsnumber,chr(13),''),chr(10),'') as fbsnumber --信用证编号\业务编号FBS
,replace(replace(t1.assureorgid,chr(13),''),chr(10),'') as assureorgid --担保机构编号(我行分支机构)
,replace(replace(t1.invoicenumber,chr(13),''),chr(10),'') as invoicenumber --发票号码
,replace(replace(t1.tradetype1,chr(13),''),chr(10),'') as tradetype1 --代收或托收类型
,replace(replace(t1.bailexchangestate,chr(13),''),chr(10),'') as bailexchangestate --保证金交易状态
,replace(replace(t1.cdexchangedate,chr(13),''),chr(10),'') as cdexchangedate --承兑记账交易日期
,replace(replace(t1.acptdate,chr(13),''),chr(10),'') as acptdate --出票日
,replace(replace(t1.loantype,chr(13),''),chr(10),'') as loantype --贷款类型
,replace(replace(t1.czflag,chr(13),''),chr(10),'') as czflag --冲账标志
,replace(replace(t1.paymode,chr(13),''),chr(10),'') as paymode --保函支付方式
,replace(replace(t1.acceptorname,chr(13),''),chr(10),'') as acceptorname --承兑人名称
,t1.othertxbalance as othertxbalance --买方付息金额
,replace(replace(t1.accountnocustomer,chr(13),''),chr(10),'') as accountnocustomer --结算帐号客户名称
,replace(replace(t1.tradedate1,chr(13),''),chr(10),'') as tradedate1 --贸易融资相关日期1
,replace(replace(t1.acceptorbankname,chr(13),''),chr(10),'') as acceptorbankname --承兑人开户行名称
,t1.compoundintratio as compoundintratio --复利利率
,replace(replace(t1.textno,chr(13),''),chr(10),'') as textno --总合同文本编号（福费廷用）
,t1.instrt as instrt --同业代付计提利率（%）
,replace(replace(t1.tradecurrecy2,chr(13),''),chr(10),'') as tradecurrecy2 --贸易融资相关币种2
,replace(replace(t1.repaymentplanflag,chr(13),''),chr(10),'') as repaymentplanflag --信贷发放还款计划标志
,replace(replace(t1.chargephone,chr(13),''),chr(10),'') as chargephone --电话（福费廷用）
,t1.tradetermmonth2 as tradetermmonth2 --贸易融资相关期限2
,replace(replace(t1.ratestartmode,chr(13),''),chr(10),'') as ratestartmode --利率启用方式
,replace(replace(t1.autocontrolflag,chr(13),''),chr(10),'') as autocontrolflag --自动回收控制开关
,replace(replace(t1.loantermthing,chr(13),''),chr(10),'') as loantermthing --放款条件是否落实
,replace(replace(t1.bailfxfltp,chr(13),''),chr(10),'') as bailfxfltp --保证金利率类型
,replace(replace(t1.gatheringname,chr(13),''),chr(10),'') as gatheringname --收票人全称
,replace(replace(t1.principalaccountno,chr(13),''),chr(10),'') as principalaccountno --委托存款账号
,replace(replace(t1.openbankname,chr(13),''),chr(10),'') as openbankname --出口信用证开证行名称、开证行ID
,replace(replace(t1.aboutbankname2,chr(13),''),chr(10),'') as aboutbankname2 --保函受益人
,replace(replace(t1.preinttype,chr(13),''),chr(10),'') as preinttype --预收息标志
,replace(replace(t1.loantermcontrolflag,chr(13),''),chr(10),'') as loantermcontrolflag --出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
,replace(replace(t1.acceptancebank,chr(13),''),chr(10),'') as acceptancebank --承兑行行号（福费廷）
,replace(replace(t1.tradedate2,chr(13),''),chr(10),'') as tradedate2 --贸易融资相关日期2
,replace(replace(t1.otherdraweracctno,chr(13),''),chr(10),'') as otherdraweracctno --买方付息账户号
,replace(replace(t1.principalsubaccountno,chr(13),''),chr(10),'') as principalsubaccountno --委托存款子户号
,replace(replace(t1.continuepayflag,chr(13),''),chr(10),'') as continuepayflag --持续扣款标志
,replace(replace(t1.billno,chr(13),''),chr(10),'') as billno --票据号码
,replace(replace(t1.approveorgid,chr(13),''),chr(10),'') as approveorgid --复核机构
,replace(replace(t1.clientaccountno,chr(13),''),chr(10),'') as clientaccountno --委托人存款账号
,replace(replace(t1.repayexchangestate,chr(13),''),chr(10),'') as repayexchangestate --还款计划交易状态
,replace(replace(t1.chargename,chr(13),''),chr(10),'') as chargename --负责人（福费廷用）
,replace(replace(t1.commercetype,chr(13),''),chr(10),'') as commercetype --贸易融资类型
,t1.tradetermmonth1 as tradetermmonth1 --贸易融资相关期限1
,replace(replace(t1.dprinpaymethod,chr(13),''),chr(10),'') as dprinpaymethod --代付本金还款方式
,replace(replace(t1.lprtype,chr(13),''),chr(10),'') as lprtype --LPR参照方式
,replace(replace(t1.loanaccountnoorgname,chr(13),''),chr(10),'') as loanaccountnoorgname --贷款帐号开户行名称
,replace(replace(t1.isrz,chr(13),''),chr(10),'') as isrz --是否融资系统出账1是0否
,t1.period as period --分期贷款总期数
,replace(replace(t1.approveuserid,chr(13),''),chr(10),'') as approveuserid --复核人
,t1.traderate1 as traderate1 --福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
,replace(replace(t1.repurchaseflag,chr(13),''),chr(10),'') as repurchaseflag --是否回购（赎回）
,replace(replace(t1.deposittermtype,chr(13),''),chr(10),'') as deposittermtype --保证金期限类型
,replace(replace(t1.linkphone,chr(13),''),chr(10),'') as linkphone --联系人手机号（福费廷用）
,replace(replace(t1.termtype,chr(13),''),chr(10),'') as termtype --期限类型
,replace(replace(t1.loanaccountnocustomer,chr(13),''),chr(10),'') as loanaccountnocustomer --贷款帐号客户名称
,t1.pdgpaypercent2 as pdgpaypercent2 --手续费率(委托贷款)
,t1.bailinterestrate as bailinterestrate --保证金协议利率
,replace(replace(t1.cdexchangeno,chr(13),''),chr(10),'') as cdexchangeno --承兑记账交易流水号
,replace(replace(t1.businesssubtype,chr(13),''),chr(10),'') as businesssubtype --保函类型
,replace(replace(t1.tradeserialno1,chr(13),''),chr(10),'') as tradeserialno1 --贸易融资业务编号1
,replace(replace(t1.txregister,chr(13),''),chr(10),'') as txregister --票据登记状态
,replace(replace(t1.amlresult,chr(13),''),chr(10),'') as amlresult --反洗钱评级结果
,t1.compoundintfloatvalue as compoundintfloatvalue --复利利率浮动比例
,t1.paysum as paysum --工本费
,replace(replace(t1.name1,chr(13),''),chr(10),'') as name1 --汇票承兑人名称
,replace(replace(t1.fundsource,chr(13),''),chr(10),'') as fundsource --资金来源
,replace(replace(t1.stopintflag,chr(13),''),chr(10),'') as stopintflag --是否停息
,t1.lnbal as lnbal --同业代付本金
,replace(replace(t1.acceptorbankno,chr(13),''),chr(10),'') as acceptorbankno --承兑人开户行行号
,replace(replace(t1.confirmingbank,chr(13),''),chr(10),'') as confirmingbank --保兑行行号（福费廷）
,replace(replace(t1.chargefax,chr(13),''),chr(10),'') as chargefax --传真（福费廷用）
,t1.pdgsum2 as pdgsum2 --手续费金额(元)(承兑汇票)
,t1.depositbaserate as depositbaserate --存款基准利率
,t1.lcsum as lcsum --信用证金额（元）
,t1.traderate2 as traderate2 --贸易融资相关比例或利率2
,replace(replace(t1.tradecurrecy1,chr(13),''),chr(10),'') as tradecurrecy1 --贸易融资相关币种1
,replace(replace(t1.isfinanceguarantee,chr(13),''),chr(10),'') as isfinanceguarantee --是否融资性保函
,replace(replace(t1.putoutno,chr(13),''),chr(10),'') as putoutno --出账号
,replace(replace(t1.bailpdrifd,chr(13),''),chr(10),'') as bailpdrifd --保证金利率浮动类型
,t1.depositterm as depositterm --存期期限
,replace(replace(t1.billclass,chr(13),''),chr(10),'') as billclass --票据种类
,t1.tradesum3 as tradesum3 --贸易融资相关金额3
,replace(replace(t1.tradecurrecy3,chr(13),''),chr(10),'') as tradecurrecy3 --贸易融资相关币种3
,replace(replace(t1.queryabnormitything,chr(13),''),chr(10),'') as queryabnormitything --贷款卡当日查询是否有异常情况
,replace(replace(t1.creditaggreement,chr(13),''),chr(10),'') as creditaggreement --使用授信额度协议号
,replace(replace(t1.exchangetype,chr(13),''),chr(10),'') as exchangetype --出帐交易代码
,replace(replace(t1.bailterm,chr(13),''),chr(10),'') as bailterm --保证金利率档次
,t1.bailpdrifv as bailpdrifv --保证金浮动值
,replace(replace(t1.interestreturnflag,chr(13),''),chr(10),'') as interestreturnflag --利息自动归还标志
,replace(replace(t1.compoundintflag,chr(13),''),chr(10),'') as compoundintflag --是否收复息标志
,replace(replace(t1.chargepost,chr(13),''),chr(10),'') as chargepost --职务（福费廷用）
,replace(replace(t1.isbankaccount,chr(13),''),chr(10),'') as isbankaccount --受益人账号是否本行
,t1.fixcyc as fixcyc --计息天数
,replace(replace(t1.ordinaryormonthly,chr(13),''),chr(10),'') as ordinaryormonthly --普通分期还款标志
,replace(replace(t1.unpaidbankname,chr(13),''),chr(10),'') as unpaidbankname --代付行名称
,replace(replace(t1.approvedate,chr(13),''),chr(10),'') as approvedate --复核日期
,replace(replace(t1.linkemail,chr(13),''),chr(10),'') as linkemail --联系人电子邮箱（福费廷用）
,t1.discountsum as discountsum --利息金额
,replace(replace(t1.loanaccountno2,chr(13),''),chr(10),'') as loanaccountno2 --贷款帐号
,replace(replace(t1.abnormitything,chr(13),''),chr(10),'') as abnormitything --贷款卡异常情况说明
,replace(replace(t1.tradeserialno2,chr(13),''),chr(10),'') as tradeserialno2 --贸易融资业务编号2
,replace(replace(t1.bailinterestmethod,chr(13),''),chr(10),'') as bailinterestmethod --保证金计息方法
,replace(replace(t1.trantp,chr(13),''),chr(10),'') as trantp --手续费收费方式(票据)
,replace(replace(t1.poolfinancingflag,chr(13),''),chr(10),'') as poolfinancingflag --是否已签订池融资协议
,replace(replace(t1.isbelongterm,chr(13),''),chr(10),'') as isbelongterm --是否靠档计息
,t1.contractsignfee as contractsignfee --签约手续费
,replace(replace(t1.aboutbankid,chr(13),''),chr(10),'') as aboutbankid --信用证受益人客户号
,replace(replace(t1.isfixedrate,chr(13),''),chr(10),'') as isfixedrate --利率是否固定
,replace(replace(t1.opencustomer,chr(13),''),chr(10),'') as opencustomer --信用证开证人
,replace(replace(t1.sellstatus,chr(13),''),chr(10),'') as sellstatus --卖出状态
,replace(replace(t1.otherreceivedbankno,chr(13),''),chr(10),'') as otherreceivedbankno --对方收款行号
,replace(replace(t1.otherreceivedname,chr(13),''),chr(10),'') as otherreceivedname --对方收款账号
,replace(replace(t1.otherreceivedaccname,chr(13),''),chr(10),'') as otherreceivedaccname --对方收款户名
,replace(replace(t1.otherreceivedbankname,chr(13),''),chr(10),'') as otherreceivedbankname --对方收款行名称
,replace(replace(t1.creditbeneficiary,chr(13),''),chr(10),'') as creditbeneficiary --信用证收益人名称
,replace(replace(t1.actualloanaccountno,chr(13),''),chr(10),'') as actualloanaccountno --贷款实际入账账号
,replace(replace(t1.replaceolddept,chr(13),''),chr(10),'') as replaceolddept --是否置换旧债
,replace(replace(t1.isproxydp,chr(13),''),chr(10),'') as isproxydp --是否代理交单
,t1.sqdkze as sqdkze --申请银团贷款总额
,replace(replace(t1.socialcreditcode,chr(13),''),chr(10),'') as socialcreditcode --统一社会信用代码
,replace(replace(t1.buychannel,chr(13),''),chr(10),'') as buychannel --买入渠道
,replace(replace(t1.islinkoutpay,chr(13),''),chr(10),'') as islinkoutpay --是否联动对外支付
,replace(replace(t1.post,chr(13),''),chr(10),'') as post --附言
,replace(replace(t1.payinterestcustomer,chr(13),''),chr(10),'') as payinterestcustomer --付息客户
,replace(replace(t1.purchasercustflag,chr(13),''),chr(10),'') as purchasercustflag --买方是否为我行客户
,replace(replace(t1.othercustomerid,chr(13),''),chr(10),'') as othercustomerid --买方客户号
,replace(replace(t1.othercustomername,chr(13),''),chr(10),'') as othercustomername --买方客户名称
,replace(replace(t1.finalmerger,chr(13),''),chr(10),'') as finalmerger --是否末期合并：0否，1是
,t1.lcsumrate as lcsumrate --信用证金额上浮比例
,replace(replace(t1.linkchargeintflag,chr(13),''),chr(10),'') as linkchargeintflag --是否联动扣收利息
,replace(replace(t1.isactualddamtflag,chr(13),''),chr(10),'') as isactualddamtflag --是否按实际放款金额冻结标志
,t1.maxpdrifv as maxpdrifv --保证金浮动上限
,replace(replace(t1.ismergeentrpayment,chr(13),''),chr(10),'') as ismergeentrpayment --是否合并受托支付
,t1.ownfunds as ownfunds --自有资金
,replace(replace(t1.ownfundsacctno,chr(13),''),chr(10),'') as ownfundsacctno --自有资金账号
,replace(replace(t1.ownfundsacctname,chr(13),''),chr(10),'') as ownfundsacctname --自有资金账户名称
,replace(replace(t1.ownfundsacctccy,chr(13),''),chr(10),'') as ownfundsacctccy --自有资金账户币种
,replace(replace(t1.arrivalnumbers,chr(13),''),chr(10),'') as arrivalnumbers --到单编号
,t1.claimamount as claimamount --索偿金额
,t1.businessamount as businessamount --业务金额
,replace(replace(t1.marketflows,chr(13),''),chr(10),'') as marketflows --市场流转次数，含到我行
,replace(replace(t1.servicecontent,chr(13),''),chr(10),'') as servicecontent --货物/服务品种
,replace(replace(t1.scanstatus,chr(13),''),chr(10),'') as scanstatus --扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
,replace(replace(t1.priceorderno,chr(13),''),chr(10),'') as priceorderno --定价单号
,replace(replace(t1.priceapprovestatus,chr(13),''),chr(10),'') as priceapprovestatus --定价单审批状态
,replace(replace(t1.priceenddate,chr(13),''),chr(10),'') as priceenddate --定价单生效截止日
,replace(replace(t1.pledgetype,chr(13),''),chr(10),'') as pledgetype --质押类型
,t1.submitputoutcentertime as submitputoutcentertime --提交放款中心时间
,replace(replace(t1.iscentralizedaccount,chr(13),''),chr(10),'') as iscentralizedaccount --是否集中出账
,replace(replace(t1.issuedbusinessno,chr(13),''),chr(10),'') as issuedbusinessno --代开保函业务编号
,t1.bhstartdate as bhstartdate --保函生效日期
,t1.bhmaturity as bhmaturity --保函失效日期
,replace(replace(t1.guaranteebusinessno,chr(13),''),chr(10),'') as guaranteebusinessno --保函业务编号
,t1.guaranteesum as guaranteesum --保函金额
,t1.issuedate as issuedate --开立日期
,replace(replace(t1.guaranteeputoutstatus,chr(13),''),chr(10),'') as guaranteeputoutstatus --保函信息状态(code:guaranteeputoutstatus)
,replace(replace(t1.isreplenishment,chr(13),''),chr(10),'') as isreplenishment --是否补录完成
,replace(replace(t1.scanuserid,chr(13),''),chr(10),'') as scanuserid --扫描人
,replace(replace(t1.scanusername,chr(13),''),chr(10),'') as scanusername --扫描人名称
,replace(replace(t1.bizuniqueno,chr(13),''),chr(10),'') as bizuniqueno --业务唯一流水号（票据/供应链）
,replace(replace(t1.isxdapprove,chr(13),''),chr(10),'') as isxdapprove --是否信贷审批（票据/供应链推送流程）
,replace(replace(t1.isignoreresult,chr(13),''),chr(10),'') as isignoreresult --是否忽略不动产查册策略结果
from ${iol_schema}.icms_bp_extend_d t1    --对公传统信贷业务出账附表
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_bp_extend_d',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
