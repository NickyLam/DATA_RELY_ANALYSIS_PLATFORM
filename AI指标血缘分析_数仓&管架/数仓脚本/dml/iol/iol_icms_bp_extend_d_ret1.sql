/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bp_extend_d_ret1
CreateDate: 20250703
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);

begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM icms_bp_extend_d_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('icms_bp_extend_d');

  if v_var <> 0 then
    execute immediate 'alter table icms_bp_extend_d drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table icms_bp_extend_d add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_bp_extend_d (
	serialno -- 出账流水号
	,billtype -- 票据类型
	,careflag -- 是否托管
	,paybankname -- 代付行
	,keyno -- 票据唯一标识号
	,tradesum1 -- 贸易融资相关金额1
	,chaggeaddress -- 地址（福费廷用）
	,tradesum2 -- 贸易融资相关金额2
	,resumeinttype -- 计复息标志
	,linkname -- 联系人（福费廷用）
	,aboutbankname -- 受益人、收款人开户行行名
	,bailpdrifm -- 保证金利率浮动方式
	,bfintg -- 是否预收息or先付利息摊销标志
	,accountopenbankname -- 结算帐号开户行名称
	,bailmaturity -- 保证金到期日
	,capitalreturnflag -- 本金自动归还标志
	,migtflag -- 迁移标志：crs rcr ilc upl
	,fbsnumber -- 信用证编号\业务编号FBS
	,assureorgid -- 担保机构编号(我行分支机构)
	,invoicenumber -- 发票号码
	,tradetype1 -- 代收或托收类型
	,bailexchangestate -- 保证金交易状态
	,cdexchangedate -- 承兑记账交易日期
	,acptdate -- 出票日
	,loantype -- 贷款类型
	,czflag -- 冲账标志
	,paymode -- 保函支付方式
	,acceptorname -- 承兑人名称
	,othertxbalance -- 买方付息金额
	,accountnocustomer -- 结算帐号客户名称
	,tradedate1 -- 贸易融资相关日期1
	,acceptorbankname -- 承兑人开户行名称
	,compoundintratio -- 复利利率
	,textno -- 总合同文本编号（福费廷用）
	,instrt -- 同业代付计提利率（%）
	,tradecurrecy2 -- 贸易融资相关币种2
	,repaymentplanflag -- 信贷发放还款计划标志
	,chargephone -- 电话（福费廷用）
	,tradetermmonth2 -- 贸易融资相关期限2
	,ratestartmode -- 利率启用方式
	,autocontrolflag -- 自动回收控制开关
	,loantermthing -- 放款条件是否落实
	,bailfxfltp -- 保证金利率类型
	,gatheringname -- 收票人全称
	,principalaccountno -- 委托存款账号
	,openbankname -- 出口信用证开证行名称、开证行ID
	,aboutbankname2 -- 保函受益人
	,preinttype -- 预收息标志
	,loantermcontrolflag -- 出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
	,acceptancebank -- 承兑行行号（福费廷）
	,tradedate2 -- 贸易融资相关日期2
	,otherdraweracctno -- 买方付息账户号
	,principalsubaccountno -- 委托存款子户号
	,continuepayflag -- 持续扣款标志
	,billno -- 票据号码
	,approveorgid -- 复核机构
	,clientaccountno -- 委托人存款账号
	,repayexchangestate -- 还款计划交易状态
	,chargename -- 负责人（福费廷用）
	,commercetype -- 贸易融资类型
	,tradetermmonth1 -- 贸易融资相关期限1
	,dprinpaymethod -- 代付本金还款方式
	,lprtype -- LPR参照方式
	,loanaccountnoorgname -- 贷款帐号开户行名称
	,isrz -- 是否融资系统出账1是0否
	,period -- 分期贷款总期数
	,approveuserid -- 复核人
	,traderate1 -- 福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
	,repurchaseflag -- 是否回购（赎回）
	,deposittermtype -- 保证金期限类型
	,linkphone -- 联系人手机号（福费廷用）
	,termtype -- 期限类型
	,loanaccountnocustomer -- 贷款帐号客户名称
	,pdgpaypercent2 -- 手续费率(委托贷款)
	,bailinterestrate -- 保证金协议利率
	,cdexchangeno -- 承兑记账交易流水号
	,businesssubtype -- 保函类型
	,tradeserialno1 -- 贸易融资业务编号1
	,txregister -- 票据登记状态
	,amlresult -- 反洗钱评级结果
	,compoundintfloatvalue -- 复利利率浮动比例
	,paysum -- 工本费
	,name1 -- 汇票承兑人名称
	,fundsource -- 资金来源
	,stopintflag -- 是否停息
	,lnbal -- 同业代付本金
	,acceptorbankno -- 承兑人开户行行号
	,confirmingbank -- 保兑行行号（福费廷）
	,chargefax -- 传真（福费廷用）
	,pdgsum2 -- 手续费金额(元)(承兑汇票)
	,depositbaserate -- 存款基准利率
	,lcsum -- 信用证金额（元）
	,traderate2 -- 贸易融资相关比例或利率2
	,tradecurrecy1 -- 贸易融资相关币种1
	,isfinanceguarantee -- 是否融资性保函
	,putoutno -- 出账号
	,bailpdrifd -- 保证金利率浮动类型
	,depositterm -- 存期期限
	,billclass -- 票据种类
	,tradesum3 -- 贸易融资相关金额3
	,tradecurrecy3 -- 贸易融资相关币种3
	,queryabnormitything -- 贷款卡当日查询是否有异常情况
	,creditaggreement -- 使用授信额度协议号
	,exchangetype -- 出帐交易代码
	,bailterm -- 保证金利率档次
	,bailpdrifv -- 保证金浮动值
	,interestreturnflag -- 利息自动归还标志
	,compoundintflag -- 是否收复息标志
	,chargepost -- 职务（福费廷用）
	,isbankaccount -- 受益人账号是否本行
	,fixcyc -- 计息天数
	,ordinaryormonthly -- 普通分期还款标志
	,unpaidbankname -- 代付行名称
	,approvedate -- 复核日期
	,linkemail -- 联系人电子邮箱（福费廷用）
	,discountsum -- 利息金额
	,loanaccountno2 -- 贷款帐号
	,abnormitything -- 贷款卡异常情况说明
	,tradeserialno2 -- 贸易融资业务编号2
	,bailinterestmethod -- 保证金计息方法
	,trantp -- 手续费收费方式(票据)
	,poolfinancingflag -- 是否已签订池融资协议
	,isbelongterm -- 是否靠档计息
	,contractsignfee -- 签约手续费
	,aboutbankid -- 信用证受益人客户号
	,isfixedrate -- 利率是否固定
	,opencustomer -- 信用证开证人
	,sellstatus -- 卖出状态
	,otherreceivedbankno -- 对方收款行号
	,otherreceivedname -- 对方收款账号
	,otherreceivedaccname -- 对方收款户名
	,otherreceivedbankname -- 对方收款行名称
	,creditbeneficiary -- 信用证收益人名称
	,actualloanaccountno -- 贷款实际入账账号
	,replaceolddept -- 是否置换旧债
	,isproxydp -- 是否代理交单
	,sqdkze -- 申请银团贷款总额
	,socialcreditcode -- 统一社会信用代码
	,buychannel -- 买入渠道
	,islinkoutpay -- 是否联动对外支付
	,post -- 附言
	,payinterestcustomer -- 付息客户
	,purchasercustflag -- 买方是否为我行客户
	,othercustomerid -- 买方客户号
	,othercustomername -- 买方客户名称
	,finalmerger -- 是否末期合并：0否，1是
	,lcsumrate -- 信用证金额上浮比例
	,linkchargeintflag -- 是否联动扣收利息
	,isactualddamtflag -- 是否按实际放款金额冻结标志
	,maxpdrifv -- 保证金浮动上限
	,ismergeentrpayment -- 是否合并受托支付
	,ownfunds -- 自有资金
	,ownfundsacctno -- 自有资金账号
	,ownfundsacctname -- 自有资金账户名称
	,ownfundsacctccy -- 自有资金账户币种
	,arrivalnumbers -- 到单编号
	,claimamount -- 索偿金额
	,businessamount -- 业务金额
	,marketflows -- 市场流转次数，含到我行
	,servicecontent -- 货物/服务品种
	,scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
	,priceorderno -- 定价单号
	,priceapprovestatus -- 定价单审批状态
	,priceenddate -- 定价单生效截止日
	,pledgetype -- 质押类型
	,submitputoutcentertime -- 提交放款中心时间
	,iscentralizedaccount -- 是否集中出账
	,issuedbusinessno -- 代开保函业务编号
	,bhstartdate -- 保函生效日期
	,bhmaturity -- 保函失效日期
	,guaranteebusinessno -- 保函业务编号
	,guaranteesum -- 保函金额
	,issuedate -- 开立日期
	,guaranteeputoutstatus -- 保函信息状态(code:guaranteeputoutstatus)
	,isreplenishment -- 是否补录完成
	,scanuserid -- 扫描人
	,scanusername -- 扫描人名称
	,bizuniqueno -- 业务唯一流水号（票据/供应链）
	,isxdapprove -- 是否信贷审批（票据/供应链推送流程）
	,isignoreresult -- 是否忽略不动产查册策略结果
	,start_dt -- 开始时间
	,end_dt -- 结束时间
	,id_mark -- 增删标志
	,etl_timestamp -- ETL处理时间戳
)
select
	serialno as serialno -- 出账流水号
	,billtype as billtype -- 票据类型
	,careflag as careflag -- 是否托管
	,paybankname as paybankname -- 代付行
	,keyno as keyno -- 票据唯一标识号
	,tradesum1 as tradesum1 -- 贸易融资相关金额1
	,chaggeaddress as chaggeaddress -- 地址（福费廷用）
	,tradesum2 as tradesum2 -- 贸易融资相关金额2
	,resumeinttype as resumeinttype -- 计复息标志
	,linkname as linkname -- 联系人（福费廷用）
	,aboutbankname as aboutbankname -- 受益人、收款人开户行行名
	,bailpdrifm as bailpdrifm -- 保证金利率浮动方式
	,bfintg as bfintg -- 是否预收息or先付利息摊销标志
	,accountopenbankname as accountopenbankname -- 结算帐号开户行名称
	,bailmaturity as bailmaturity -- 保证金到期日
	,capitalreturnflag as capitalreturnflag -- 本金自动归还标志
	,migtflag as migtflag -- 迁移标志：crs rcr ilc upl
	,fbsnumber as fbsnumber -- 信用证编号\业务编号FBS
	,assureorgid as assureorgid -- 担保机构编号(我行分支机构)
	,invoicenumber as invoicenumber -- 发票号码
	,tradetype1 as tradetype1 -- 代收或托收类型
	,bailexchangestate as bailexchangestate -- 保证金交易状态
	,cdexchangedate as cdexchangedate -- 承兑记账交易日期
	,acptdate as acptdate -- 出票日
	,loantype as loantype -- 贷款类型
	,czflag as czflag -- 冲账标志
	,paymode as paymode -- 保函支付方式
	,acceptorname as acceptorname -- 承兑人名称
	,othertxbalance as othertxbalance -- 买方付息金额
	,accountnocustomer as accountnocustomer -- 结算帐号客户名称
	,tradedate1 as tradedate1 -- 贸易融资相关日期1
	,acceptorbankname as acceptorbankname -- 承兑人开户行名称
	,compoundintratio as compoundintratio -- 复利利率
	,textno as textno -- 总合同文本编号（福费廷用）
	,instrt as instrt -- 同业代付计提利率（%）
	,tradecurrecy2 as tradecurrecy2 -- 贸易融资相关币种2
	,repaymentplanflag as repaymentplanflag -- 信贷发放还款计划标志
	,chargephone as chargephone -- 电话（福费廷用）
	,tradetermmonth2 as tradetermmonth2 -- 贸易融资相关期限2
	,ratestartmode as ratestartmode -- 利率启用方式
	,autocontrolflag as autocontrolflag -- 自动回收控制开关
	,loantermthing as loantermthing -- 放款条件是否落实
	,bailfxfltp as bailfxfltp -- 保证金利率类型
	,gatheringname as gatheringname -- 收票人全称
	,principalaccountno as principalaccountno -- 委托存款账号
	,openbankname as openbankname -- 出口信用证开证行名称、开证行ID
	,aboutbankname2 as aboutbankname2 -- 保函受益人
	,preinttype as preinttype -- 预收息标志
	,loantermcontrolflag as loantermcontrolflag -- 出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
	,acceptancebank as acceptancebank -- 承兑行行号（福费廷）
	,tradedate2 as tradedate2 -- 贸易融资相关日期2
	,otherdraweracctno as otherdraweracctno -- 买方付息账户号
	,principalsubaccountno as principalsubaccountno -- 委托存款子户号
	,continuepayflag as continuepayflag -- 持续扣款标志
	,billno as billno -- 票据号码
	,approveorgid as approveorgid -- 复核机构
	,clientaccountno as clientaccountno -- 委托人存款账号
	,repayexchangestate as repayexchangestate -- 还款计划交易状态
	,chargename as chargename -- 负责人（福费廷用）
	,commercetype as commercetype -- 贸易融资类型
	,tradetermmonth1 as tradetermmonth1 -- 贸易融资相关期限1
	,dprinpaymethod as dprinpaymethod -- 代付本金还款方式
	,lprtype as lprtype -- LPR参照方式
	,loanaccountnoorgname as loanaccountnoorgname -- 贷款帐号开户行名称
	,isrz as isrz -- 是否融资系统出账1是0否
	,period as period -- 分期贷款总期数
	,approveuserid as approveuserid -- 复核人
	,traderate1 as traderate1 -- 福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
	,repurchaseflag as repurchaseflag -- 是否回购（赎回）
	,deposittermtype as deposittermtype -- 保证金期限类型
	,linkphone as linkphone -- 联系人手机号（福费廷用）
	,termtype as termtype -- 期限类型
	,loanaccountnocustomer as loanaccountnocustomer -- 贷款帐号客户名称
	,pdgpaypercent2 as pdgpaypercent2 -- 手续费率(委托贷款)
	,bailinterestrate as bailinterestrate -- 保证金协议利率
	,cdexchangeno as cdexchangeno -- 承兑记账交易流水号
	,businesssubtype as businesssubtype -- 保函类型
	,tradeserialno1 as tradeserialno1 -- 贸易融资业务编号1
	,txregister as txregister -- 票据登记状态
	,amlresult as amlresult -- 反洗钱评级结果
	,compoundintfloatvalue as compoundintfloatvalue -- 复利利率浮动比例
	,paysum as paysum -- 工本费
	,name1 as name1 -- 汇票承兑人名称
	,fundsource as fundsource -- 资金来源
	,stopintflag as stopintflag -- 是否停息
	,lnbal as lnbal -- 同业代付本金
	,acceptorbankno as acceptorbankno -- 承兑人开户行行号
	,confirmingbank as confirmingbank -- 保兑行行号（福费廷）
	,chargefax as chargefax -- 传真（福费廷用）
	,pdgsum2 as pdgsum2 -- 手续费金额(元)(承兑汇票)
	,depositbaserate as depositbaserate -- 存款基准利率
	,lcsum as lcsum -- 信用证金额（元）
	,traderate2 as traderate2 -- 贸易融资相关比例或利率2
	,tradecurrecy1 as tradecurrecy1 -- 贸易融资相关币种1
	,isfinanceguarantee as isfinanceguarantee -- 是否融资性保函
	,putoutno as putoutno -- 出账号
	,bailpdrifd as bailpdrifd -- 保证金利率浮动类型
	,depositterm as depositterm -- 存期期限
	,billclass as billclass -- 票据种类
	,tradesum3 as tradesum3 -- 贸易融资相关金额3
	,tradecurrecy3 as tradecurrecy3 -- 贸易融资相关币种3
	,queryabnormitything as queryabnormitything -- 贷款卡当日查询是否有异常情况
	,creditaggreement as creditaggreement -- 使用授信额度协议号
	,exchangetype as exchangetype -- 出帐交易代码
	,bailterm as bailterm -- 保证金利率档次
	,bailpdrifv as bailpdrifv -- 保证金浮动值
	,interestreturnflag as interestreturnflag -- 利息自动归还标志
	,compoundintflag as compoundintflag -- 是否收复息标志
	,chargepost as chargepost -- 职务（福费廷用）
	,isbankaccount as isbankaccount -- 受益人账号是否本行
	,fixcyc as fixcyc -- 计息天数
	,ordinaryormonthly as ordinaryormonthly -- 普通分期还款标志
	,unpaidbankname as unpaidbankname -- 代付行名称
	,approvedate as approvedate -- 复核日期
	,linkemail as linkemail -- 联系人电子邮箱（福费廷用）
	,discountsum as discountsum -- 利息金额
	,loanaccountno2 as loanaccountno2 -- 贷款帐号
	,abnormitything as abnormitything -- 贷款卡异常情况说明
	,tradeserialno2 as tradeserialno2 -- 贸易融资业务编号2
	,bailinterestmethod as bailinterestmethod -- 保证金计息方法
	,trantp as trantp -- 手续费收费方式(票据)
	,poolfinancingflag as poolfinancingflag -- 是否已签订池融资协议
	,isbelongterm as isbelongterm -- 是否靠档计息
	,contractsignfee as contractsignfee -- 签约手续费
	,aboutbankid as aboutbankid -- 信用证受益人客户号
	,isfixedrate as isfixedrate -- 利率是否固定
	,opencustomer as opencustomer -- 信用证开证人
	,sellstatus as sellstatus -- 卖出状态
	,otherreceivedbankno as otherreceivedbankno -- 对方收款行号
	,otherreceivedname as otherreceivedname -- 对方收款账号
	,otherreceivedaccname as otherreceivedaccname -- 对方收款户名
	,otherreceivedbankname as otherreceivedbankname -- 对方收款行名称
	,creditbeneficiary as creditbeneficiary -- 信用证收益人名称
	,actualloanaccountno as actualloanaccountno -- 贷款实际入账账号
	,replaceolddept as replaceolddept -- 是否置换旧债
	,isproxydp as isproxydp -- 是否代理交单
	,sqdkze as sqdkze -- 申请银团贷款总额
	,socialcreditcode as socialcreditcode -- 统一社会信用代码
	,buychannel as buychannel -- 买入渠道
	,islinkoutpay as islinkoutpay -- 是否联动对外支付
	,post as post -- 附言
	,payinterestcustomer as payinterestcustomer -- 付息客户
	,purchasercustflag as purchasercustflag -- 买方是否为我行客户
	,othercustomerid as othercustomerid -- 买方客户号
	,othercustomername as othercustomername -- 买方客户名称
	,finalmerger as finalmerger -- 是否末期合并：0否，1是
	,lcsumrate as lcsumrate -- 信用证金额上浮比例
	,linkchargeintflag as linkchargeintflag -- 是否联动扣收利息
	,isactualddamtflag as isactualddamtflag -- 是否按实际放款金额冻结标志
	,maxpdrifv as maxpdrifv -- 保证金浮动上限
	,ismergeentrpayment as ismergeentrpayment -- 是否合并受托支付
	,ownfunds as ownfunds -- 自有资金
	,ownfundsacctno as ownfundsacctno -- 自有资金账号
	,ownfundsacctname as ownfundsacctname -- 自有资金账户名称
	,ownfundsacctccy as ownfundsacctccy -- 自有资金账户币种
	,arrivalnumbers as arrivalnumbers -- 到单编号
	,claimamount as claimamount -- 索偿金额
	,businessamount as businessamount -- 业务金额
	,marketflows as marketflows -- 市场流转次数，含到我行
	,servicecontent as servicecontent -- 货物/服务品种
	,scanstatus as scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
	,priceorderno as priceorderno -- 定价单号
	,priceapprovestatus as priceapprovestatus -- 定价单审批状态
	,priceenddate as priceenddate -- 定价单生效截止日
	,pledgetype as pledgetype -- 质押类型
	,submitputoutcentertime as submitputoutcentertime -- 提交放款中心时间
	,' ' as iscentralizedaccount -- 是否集中出账
	,' ' as issuedbusinessno -- 代开保函业务编号
	,to_date('00010101','yyyymmdd') as bhstartdate -- 保函生效日期
	,to_date('00010101','yyyymmdd') as bhmaturity -- 保函失效日期
	,' ' as guaranteebusinessno -- 保函业务编号
	,0 as guaranteesum -- 保函金额
	,to_date('00010101','yyyymmdd') as issuedate -- 开立日期
	,' ' as guaranteeputoutstatus -- 保函信息状态(code:guaranteeputoutstatus)
	,' ' as isreplenishment -- 是否补录完成
	,' ' as scanuserid -- 扫描人
	,' ' as scanusername -- 扫描人名称
	,' ' as bizuniqueno -- 业务唯一流水号（票据/供应链）
	,' ' as isxdapprove -- 是否信贷审批（票据/供应链推送流程）
	,' ' as isignoreresult -- 是否忽略不动产查册策略结果
	,start_dt as start_dt -- 开始时间
	,end_dt as end_dt -- 结束时间
	,id_mark as id_mark -- 增删标志
	,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bp_extend_d_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

