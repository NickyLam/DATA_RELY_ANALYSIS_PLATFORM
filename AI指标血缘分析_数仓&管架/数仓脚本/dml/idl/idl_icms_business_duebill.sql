/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_business_duebill
CreateDate: 20250612
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_business_duebill drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_business_duebill add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_business_duebill (
etl_dt  --数据日期
,serialno  --借据编号
,putoutserialno  --关联出账编号
,contractserialno  --关联合同编号
,occurdate  --发生日期
,occurtype  --贷款发放类型
,vouchtype  --主担保方式
,customerid  --客户编号
,customername  --客户名称
,productid  --产品编号
,currency  --币种
,businesssum  --放款金额
,termmonth  --期限(月)
,termday  --期限(天)
,putoutdate  --发放日期
,maturity  --约定到期日
,actualmaturity  --实际到期日
,ratemodel  --利率模式
,baseratetype  --基准利率类型
,baserate  --基准利率
,ratefloattype  --利率浮动方式
,executerate  --执行年利率
,bailratio  --保证金比例
,bailsum  --保证金金额
,bailaccount  --保证金账户编号
,repaytype  --还款方式
,paymenttype  --支付方式
,repaycycle  --还款周期
,balance  --贷款余额
,normalbalance  --正常余额
,overduebalance  --逾期余额
,dullbalance  --呆滞余额
,badbalance  --呆账余额
,extendtimes  --展期次数
,innerinterestbalance  --表内欠息余额
,outerinterestbalance  --表外欠息余额
,capitalpenaltybalance  --逾期罚息余额
,interestpenaltybalance  --复息余额
,overduedays  --贷款逾期天数
,owninterestdays  --欠息天数
,ichangedate  --欠息更新日期
,graceperiod  --贷款宽限期
,reducereservesum  --计提准备金额
,predictlostsum  --预测损失金额
,finishtype  --终结类型
,finishdate  --终结日期
,belongdept  --所属条线
,offsheetflag  --表内外标志
,islowrisk  --是否低风险
,badconfirmdate  --首次认定不良日期
,classifyresult  --贷款五级分类
,classifydate  --风险分类日期
,advanceflag  --担保代偿/垫款标志
,businessstatus  --业务状态
,mforgid  --主机机构号
,relativeduebillno  --原始借据号
,loanno  --贷款卡号
,remark  --备注
,operatedate  --经办日期
,operateuserid  --业务经办人编号
,operateorgid  --经办机构
,inputuserid  --登记人
,inputorgid  --登记机构
,inputdate  --登记日期
,updateuserid  --更新人
,updateorgid  --更新机构
,updatedate  --更新日期
,corporgid  --法人机构编号
,repaydate  --默认还款日
,mfcustomerid  --核心客户号
,settlementaccount  --结算账号
,overduedate  --逾期日期
,oweinterestdate  --欠息日期
,classifyresulteleven  --风险分类结果（11级）
,overduerate  --逾期利率
,mainorgid  --机构代号(核心记账机构id)
,remart  --计量标记-资产三分类
,vouchtype2  --担保方式2
,vouchtype3  --担保方式3
,rateadjusttype  --利率调整方式
,rateadjustfrequency  --利率调整周期
,floatrange  --浮动幅度
,settlementaccountname  --结算账户(还款账户)名
,loanaccountorgid  --贷款入账(出账账户)账户开户机构
,overdueratefloattype  --逾期利率浮动方式
,overdueratefloatvalue  --逾期利率浮动值
,putoutorgid  --出账机构编号(核心机构)
,dzhxstatus  --呆账核销状态
,classifyresultelevendate  --十一级分类日期
,loanaccountno  --贷款入账账号
,migtflag  --迁移标志：crs rcr ilc upl
,loanstatus  --贷款状态
,zxzflag  --支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了
,assetflag  --是否被认定为问题资产
,migtcustomerid  --转换前客户号
,migtbusinesstype  --转换前产品id
,migtoldvalue  --迁移数据-参数转换前字段值
,wrndate  --核销日期
,repayamt  --实付金额
,prifirstduedate  --本金未还最早日期
,intfirstduedate  --利息未还最早日期
,compensateamt  --代偿金额
,yjintamt  --应计利息
,csyjintamt  --催收应计利息
,ysintamt  --应收欠息
,csintamt  --催收欠息
,yjodpamt  --应计罚息
,csyjodpamt  --催收应计罚息
,ysodpamt  --应收罚息
,csodpamt  --催收罚息
,odppostedctddr  --应收未收罚息
,odipostedctddr  --应收未收复息
,yjodiamt  --应计复息
,wrnpriamt  --核销本金
,wrnintamt  --核销利息
,wrnreceiptamt  --核销回收金额
,intdate  --下一结息日
,accountbalance  --还款账号余额
,accountuserbalance  --还款账户可用余额
,termtype  --期限类型
,insum  --累计归还本金
,interestinsum  --累计归还利息
,exttradeno  --原业务编号
,fyjbalamt  --非应计余额
,periods  --贷款总期数
,remain_periods  --剩余还款期数
,lastclassifyresultten  --上期十级分类标志
,lastclassifyresulttendate  --上期十级分类日期
,classifyfivehchangedate  --上一期五级分类变更日期
,tenclaind  --十级分类人工干预标志1-人工、2-系统
,lastclassifyresult  --上期五级分类结果
,lastclassifyresultdate  --上期五级分类完成日期
,npltransflag  --不良资产转让标识：转入转出
,reversalflag  --冲正标志：y-冲正，n-未冲正
,risktype  --风险业务类型
,ratefloatratioorbp  --利率浮动类型（1-按比例2-按点差）
,loanaccountname  --贷款入账(收款账户)账户名
,odiflag  --是否复利
,odpflag  --是否罚息
,compensatepotype  --宽限到期日
,gracestartdate  --宽限起始日
,loanserialno  --风险监测关联流水号
,whethertorestructuretheloan  --是否重组贷款
,restructuretheloantype  --重组贷款类型
,ispensionindustry  --养老产业标识
,gracetype  --宽限期类型
,gearprodflag  --是否靠档计息标识
,absflag  --资产证券化标志
,intappltype  --利率启用方式
,rollfreq  --利率变更周期
,acctspreadrate  --浮动百分点
,intindflag  --是否计息
,intday  --存贷结息日期
,inttype  --利率类型
,interestbalance  --利息余额
,paymentserialno  --关联付款申请书编号
,actualoverduedays  --实际逾期天数（来源核心系统）
,notificationstatus  --债权通知书状态（客户级债权通知书）01-未确认,02-已确认
,principalbalance  --本金余额(仅用于对账使用)
,tysumcp  --同业系统本金余额(仅用于对账使用)
,originalloandeadline  --原贷款到期日
,settlementaccountbank  --结算账号开户行
,settlementaccountnum  --结算账户序号
,restructuretheloandate  --实施重组日期
,shareamount  --分润金额
,overduecount  --逾期次数
,firstoverduedate  --首次逾期日期
,contoverduedate  --连续逾期日期
,prioverduedays  --本金逾期天数
,intoverduedays  --利息逾期天数
,prioverdueamt  --本金逾期金额
,intoverdueamt  --利息逾期金额
,subproductname  --子产品名称

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --借据编号
,replace(replace(t1.putoutserialno,chr(13),''),chr(10),'') as putoutserialno --关联出账编号
,replace(replace(t1.contractserialno,chr(13),''),chr(10),'') as contractserialno --关联合同编号
,t1.occurdate as occurdate --发生日期
,replace(replace(t1.occurtype,chr(13),''),chr(10),'') as occurtype --贷款发放类型
,replace(replace(t1.vouchtype,chr(13),''),chr(10),'') as vouchtype --主担保方式
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid --客户编号
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername --客户名称
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid --产品编号
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency --币种
,t1.businesssum as businesssum --放款金额
,t1.termmonth as termmonth --期限(月)
,t1.termday as termday --期限(天)
,t1.putoutdate as putoutdate --发放日期
,t1.maturity as maturity --约定到期日
,t1.actualmaturity as actualmaturity --实际到期日
,replace(replace(t1.ratemodel,chr(13),''),chr(10),'') as ratemodel --利率模式
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype --基准利率类型
,t1.baserate as baserate --基准利率
,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'') as ratefloattype --利率浮动方式
,t1.executerate as executerate --执行年利率
,t1.bailratio as bailratio --保证金比例
,t1.bailsum as bailsum --保证金金额
,replace(replace(t1.bailaccount,chr(13),''),chr(10),'') as bailaccount --保证金账户编号
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype --还款方式
,replace(replace(t1.paymenttype,chr(13),''),chr(10),'') as paymenttype --支付方式
,replace(replace(t1.repaycycle,chr(13),''),chr(10),'') as repaycycle --还款周期
,t1.balance as balance --贷款余额
,t1.normalbalance as normalbalance --正常余额
,t1.overduebalance as overduebalance --逾期余额
,t1.dullbalance as dullbalance --呆滞余额
,t1.badbalance as badbalance --呆账余额
,t1.extendtimes as extendtimes --展期次数
,t1.innerinterestbalance as innerinterestbalance --表内欠息余额
,t1.outerinterestbalance as outerinterestbalance --表外欠息余额
,t1.capitalpenaltybalance as capitalpenaltybalance --逾期罚息余额
,t1.interestpenaltybalance as interestpenaltybalance --复息余额
,t1.overduedays as overduedays --贷款逾期天数
,t1.owninterestdays as owninterestdays --欠息天数
,t1.ichangedate as ichangedate --欠息更新日期
,t1.graceperiod as graceperiod --贷款宽限期
,t1.reducereservesum as reducereservesum --计提准备金额
,t1.predictlostsum as predictlostsum --预测损失金额
,replace(replace(t1.finishtype,chr(13),''),chr(10),'') as finishtype --终结类型
,t1.finishdate as finishdate --终结日期
,replace(replace(t1.belongdept,chr(13),''),chr(10),'') as belongdept --所属条线
,replace(replace(t1.offsheetflag,chr(13),''),chr(10),'') as offsheetflag --表内外标志
,replace(replace(t1.islowrisk,chr(13),''),chr(10),'') as islowrisk --是否低风险
,t1.badconfirmdate as badconfirmdate --首次认定不良日期
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult --贷款五级分类
,t1.classifydate as classifydate --风险分类日期
,replace(replace(t1.advanceflag,chr(13),''),chr(10),'') as advanceflag --担保代偿/垫款标志
,replace(replace(t1.businessstatus,chr(13),''),chr(10),'') as businessstatus --业务状态
,replace(replace(t1.mforgid,chr(13),''),chr(10),'') as mforgid --主机机构号
,replace(replace(t1.relativeduebillno,chr(13),''),chr(10),'') as relativeduebillno --原始借据号
,replace(replace(t1.loanno,chr(13),''),chr(10),'') as loanno --贷款卡号
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,t1.operatedate as operatedate --经办日期
,replace(replace(t1.operateuserid,chr(13),''),chr(10),'') as operateuserid --业务经办人编号
,replace(replace(t1.operateorgid,chr(13),''),chr(10),'') as operateorgid --经办机构
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid --登记人
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid --登记机构
,t1.inputdate as inputdate --登记日期
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid --更新人
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid --更新机构
,t1.updatedate as updatedate --更新日期
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid --法人机构编号
,t1.repaydate as repaydate --默认还款日
,replace(replace(t1.mfcustomerid,chr(13),''),chr(10),'') as mfcustomerid --核心客户号
,replace(replace(t1.settlementaccount,chr(13),''),chr(10),'') as settlementaccount --结算账号
,replace(replace(t1.overduedate,chr(13),''),chr(10),'') as overduedate --逾期日期
,replace(replace(t1.oweinterestdate,chr(13),''),chr(10),'') as oweinterestdate --欠息日期
,replace(replace(t1.classifyresulteleven,chr(13),''),chr(10),'') as classifyresulteleven --风险分类结果（11级）
,t1.overduerate as overduerate --逾期利率
,replace(replace(t1.mainorgid,chr(13),''),chr(10),'') as mainorgid --机构代号(核心记账机构id)
,replace(replace(t1.remart,chr(13),''),chr(10),'') as remart --计量标记-资产三分类
,replace(replace(t1.vouchtype2,chr(13),''),chr(10),'') as vouchtype2 --担保方式2
,replace(replace(t1.vouchtype3,chr(13),''),chr(10),'') as vouchtype3 --担保方式3
,replace(replace(t1.rateadjusttype,chr(13),''),chr(10),'') as rateadjusttype --利率调整方式
,replace(replace(t1.rateadjustfrequency,chr(13),''),chr(10),'') as rateadjustfrequency --利率调整周期
,t1.floatrange as floatrange --浮动幅度
,replace(replace(t1.settlementaccountname,chr(13),''),chr(10),'') as settlementaccountname --结算账户(还款账户)名
,replace(replace(t1.loanaccountorgid,chr(13),''),chr(10),'') as loanaccountorgid --贷款入账(出账账户)账户开户机构
,replace(replace(t1.overdueratefloattype,chr(13),''),chr(10),'') as overdueratefloattype --逾期利率浮动方式
,t1.overdueratefloatvalue as overdueratefloatvalue --逾期利率浮动值
,replace(replace(t1.putoutorgid,chr(13),''),chr(10),'') as putoutorgid --出账机构编号(核心机构)
,replace(replace(t1.dzhxstatus,chr(13),''),chr(10),'') as dzhxstatus --呆账核销状态
,t1.classifyresultelevendate as classifyresultelevendate --十一级分类日期
,replace(replace(t1.loanaccountno,chr(13),''),chr(10),'') as loanaccountno --贷款入账账号
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crs rcr ilc upl
,replace(replace(t1.loanstatus,chr(13),''),chr(10),'') as loanstatus --贷款状态
,replace(replace(t1.zxzflag,chr(13),''),chr(10),'') as zxzflag --支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了
,replace(replace(t1.assetflag,chr(13),''),chr(10),'') as assetflag --是否被认定为问题资产
,replace(replace(t1.migtcustomerid,chr(13),''),chr(10),'') as migtcustomerid --转换前客户号
,replace(replace(t1.migtbusinesstype,chr(13),''),chr(10),'') as migtbusinesstype --转换前产品id
,replace(replace(t1.migtoldvalue,chr(13),''),chr(10),'') as migtoldvalue --迁移数据-参数转换前字段值
,replace(replace(t1.wrndate,chr(13),''),chr(10),'') as wrndate --核销日期
,t1.repayamt as repayamt --实付金额
,replace(replace(t1.prifirstduedate,chr(13),''),chr(10),'') as prifirstduedate --本金未还最早日期
,replace(replace(t1.intfirstduedate,chr(13),''),chr(10),'') as intfirstduedate --利息未还最早日期
,t1.compensateamt as compensateamt --代偿金额
,t1.yjintamt as yjintamt --应计利息
,t1.csyjintamt as csyjintamt --催收应计利息
,t1.ysintamt as ysintamt --应收欠息
,t1.csintamt as csintamt --催收欠息
,t1.yjodpamt as yjodpamt --应计罚息
,t1.csyjodpamt as csyjodpamt --催收应计罚息
,t1.ysodpamt as ysodpamt --应收罚息
,t1.csodpamt as csodpamt --催收罚息
,t1.odppostedctddr as odppostedctddr --应收未收罚息
,t1.odipostedctddr as odipostedctddr --应收未收复息
,t1.yjodiamt as yjodiamt --应计复息
,t1.wrnpriamt as wrnpriamt --核销本金
,t1.wrnintamt as wrnintamt --核销利息
,t1.wrnreceiptamt as wrnreceiptamt --核销回收金额
,replace(replace(t1.intdate,chr(13),''),chr(10),'') as intdate --下一结息日
,t1.accountbalance as accountbalance --还款账号余额
,t1.accountuserbalance as accountuserbalance --还款账户可用余额
,replace(replace(t1.termtype,chr(13),''),chr(10),'') as termtype --期限类型
,t1.insum as insum --累计归还本金
,t1.interestinsum as interestinsum --累计归还利息
,replace(replace(t1.exttradeno,chr(13),''),chr(10),'') as exttradeno --原业务编号
,t1.fyjbalamt as fyjbalamt --非应计余额
,t1.periods as periods --贷款总期数
,t1.remain_periods as remain_periods --剩余还款期数
,replace(replace(t1.lastclassifyresultten,chr(13),''),chr(10),'') as lastclassifyresultten --上期十级分类标志
,t1.lastclassifyresulttendate as lastclassifyresulttendate --上期十级分类日期
,t1.classifyfivehchangedate as classifyfivehchangedate --上一期五级分类变更日期
,replace(replace(t1.tenclaind,chr(13),''),chr(10),'') as tenclaind --十级分类人工干预标志1-人工、2-系统
,replace(replace(t1.lastclassifyresult,chr(13),''),chr(10),'') as lastclassifyresult --上期五级分类结果
,replace(replace(t1.lastclassifyresultdate,chr(13),''),chr(10),'') as lastclassifyresultdate --上期五级分类完成日期
,replace(replace(t1.npltransflag,chr(13),''),chr(10),'') as npltransflag --不良资产转让标识：转入转出
,replace(replace(t1.reversalflag,chr(13),''),chr(10),'') as reversalflag --冲正标志：y-冲正，n-未冲正
,replace(replace(t1.risktype,chr(13),''),chr(10),'') as risktype --风险业务类型
,replace(replace(t1.ratefloatratioorbp,chr(13),''),chr(10),'') as ratefloatratioorbp --利率浮动类型（1-按比例2-按点差）
,replace(replace(t1.loanaccountname,chr(13),''),chr(10),'') as loanaccountname --贷款入账(收款账户)账户名
,replace(replace(t1.odiflag,chr(13),''),chr(10),'') as odiflag --是否复利
,replace(replace(t1.odpflag,chr(13),''),chr(10),'') as odpflag --是否罚息
,t1.compensatepotype as compensatepotype --宽限到期日
,t1.gracestartdate as gracestartdate --宽限起始日
,replace(replace(t1.loanserialno,chr(13),''),chr(10),'') as loanserialno --风险监测关联流水号
,replace(replace(t1.whethertorestructuretheloan,chr(13),''),chr(10),'') as whethertorestructuretheloan --是否重组贷款
,replace(replace(t1.restructuretheloantype,chr(13),''),chr(10),'') as restructuretheloantype --重组贷款类型
,replace(replace(t1.ispensionindustry,chr(13),''),chr(10),'') as ispensionindustry --养老产业标识
,replace(replace(t1.gracetype,chr(13),''),chr(10),'') as gracetype --宽限期类型
,replace(replace(t1.gearprodflag,chr(13),''),chr(10),'') as gearprodflag --是否靠档计息标识
,replace(replace(t1.absflag,chr(13),''),chr(10),'') as absflag --资产证券化标志
,replace(replace(t1.intappltype,chr(13),''),chr(10),'') as intappltype --利率启用方式
,replace(replace(t1.rollfreq,chr(13),''),chr(10),'') as rollfreq --利率变更周期
,t1.acctspreadrate as acctspreadrate --浮动百分点
,replace(replace(t1.intindflag,chr(13),''),chr(10),'') as intindflag --是否计息
,replace(replace(t1.intday,chr(13),''),chr(10),'') as intday --存贷结息日期
,replace(replace(t1.inttype,chr(13),''),chr(10),'') as inttype --利率类型
,t1.interestbalance as interestbalance --利息余额
,replace(replace(t1.paymentserialno,chr(13),''),chr(10),'') as paymentserialno --关联付款申请书编号
,t1.actualoverduedays as actualoverduedays --实际逾期天数（来源核心系统）
,replace(replace(t1.notificationstatus,chr(13),''),chr(10),'') as notificationstatus --债权通知书状态（客户级债权通知书）01-未确认,02-已确认
,t1.principalbalance as principalbalance --本金余额(仅用于对账使用)
,t1.tysumcp as tysumcp --同业系统本金余额(仅用于对账使用)
,t1.originalloandeadline as originalloandeadline --原贷款到期日
,replace(replace(t1.settlementaccountbank,chr(13),''),chr(10),'') as settlementaccountbank --结算账号开户行
,replace(replace(t1.settlementaccountnum,chr(13),''),chr(10),'') as settlementaccountnum --结算账户序号
,t1.restructuretheloandate as restructuretheloandate --实施重组日期
,t1.shareamount as shareamount --分润金额
,t1.overduecount as overduecount --逾期次数
,t1.firstoverduedate as firstoverduedate --首次逾期日期
,t1.contoverduedate as contoverduedate --连续逾期日期
,t1.prioverduedays as prioverduedays --本金逾期天数
,t1.intoverduedays as intoverduedays --利息逾期天数
,t1.prioverdueamt as prioverdueamt --本金逾期金额
,t1.intoverdueamt as intoverdueamt --利息逾期金额
,replace(replace(t1.subproductname,chr(13),''),chr(10),'') as subproductname --子产品名称
from ${iol_schema}.icms_business_duebill t1    --借据表
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_business_duebill',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
