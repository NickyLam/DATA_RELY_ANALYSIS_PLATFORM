/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_business_duebill
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_business_duebill_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_business_duebill
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_duebill_op purge;
drop table ${iol_schema}.icms_business_duebill_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_duebill_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_duebill where 0=1;

create table ${iol_schema}.icms_business_duebill_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_duebill where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_duebill_cl(
            serialno -- 借据编号
            ,putoutserialno -- 关联出账编号
            ,contractserialno -- 关联合同编号
            ,occurdate -- 发生日期
            ,occurtype -- 贷款发放类型
            ,vouchtype -- 主担保方式
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,currency -- 币种
            ,businesssum -- 放款金额
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,putoutdate -- 发放日期
            ,maturity -- 约定到期日
            ,actualmaturity -- 实际到期日
            ,ratemodel -- 利率模式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,executerate -- 执行年利率
            ,bailratio -- 保证金比例
            ,bailsum -- 保证金金额
            ,bailaccount -- 保证金账户编号
            ,repaytype -- 还款方式
            ,paymenttype -- 支付方式
            ,repaycycle -- 还款周期
            ,balance -- 贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期余额
            ,dullbalance -- 呆滞余额
            ,badbalance -- 呆账余额
            ,extendtimes -- 展期次数
            ,innerinterestbalance -- 表内欠息余额
            ,outerinterestbalance -- 表外欠息余额
            ,capitalpenaltybalance -- 逾期罚息余额
            ,interestpenaltybalance -- 复息余额
            ,overduedays -- 贷款逾期天数
            ,owninterestdays -- 欠息天数
            ,ichangedate -- 欠息更新日期
            ,graceperiod -- 贷款宽限期
            ,reducereservesum -- 计提准备金额
            ,predictlostsum -- 预测损失金额
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,belongdept -- 所属条线
            ,offsheetflag -- 表内外标志
            ,islowrisk -- 是否低风险
            ,badconfirmdate -- 首次认定不良日期
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,advanceflag -- 担保代偿/垫款标志
            ,businessstatus -- 业务状态
            ,mforgid -- 主机机构号
            ,relativeduebillno -- 原始借据号
            ,loanno -- 贷款卡号
            ,remark -- 备注
            ,operatedate -- 经办日期
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,repaydate -- 默认还款日
            ,mfcustomerid -- 核心客户号
            ,settlementaccount -- 结算账号
            ,overduedate -- 逾期日期
            ,oweinterestdate -- 欠息日期
            ,classifyresulteleven -- 风险分类结果（11级）
            ,overduerate -- 逾期利率
            ,mainorgid -- 机构代号(核心记账机构ID)
            ,remart -- 计量标记-资产三分类
            ,vouchtype2 -- 担保方式2
            ,vouchtype3 -- 担保方式3
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountorgid -- 贷款入账(出账账户)账户开户机构
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,dzhxstatus -- 呆账核销状态
            ,classifyresultelevendate -- 十一级分类日期
            ,loanaccountno -- 贷款入账账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,loanstatus -- 贷款状态
            ,zxzflag -- 支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了
            ,assetflag -- 是否被认定为问题资产
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,wrndate -- 核销日期
            ,repayamt -- 实付金额
            ,prifirstduedate -- 本金未还最早日期
            ,intfirstduedate -- 利息未还最早日期
            ,compensateamt -- 代偿金额
            ,yjintamt -- 应计利息
            ,csyjintamt -- 催收应计利息
            ,ysintamt -- 应收欠息
            ,csintamt -- 催收欠息
            ,yjodpamt -- 应计罚息
            ,csyjodpamt -- 催收应计罚息
            ,ysodpamt -- 应收罚息
            ,csodpamt -- 催收罚息
            ,odppostedctddr -- 应收未收罚息
            ,odipostedctddr -- 应收未收复息
            ,yjodiamt -- 应计复息
            ,wrnpriamt -- 核销本金
            ,wrnintamt -- 核销利息
            ,wrnreceiptamt -- 核销回收金额
            ,intdate -- 下一结息日
            ,accountbalance -- 还款账号余额
            ,accountuserbalance -- 还款账户可用余额
            ,termtype -- 期限类型
            ,insum -- 累计归还本金
            ,interestinsum -- 累计归还利息
            ,exttradeno -- 原业务编号
            ,fyjbalamt -- 非应计余额
            ,periods -- 贷款总期数
            ,remain_periods -- 剩余还款期数
            ,lastclassifyresultten -- 上期十级分类标志
            ,lastclassifyresulttendate -- 上期十级分类日期
            ,classifyfivehchangedate -- 上一期五级分类变更日期
            ,tenclaind -- 十级分类人工干预标志1-人工、2-系统
            ,lastclassifyresult -- 上期五级分类结果
            ,lastclassifyresultdate -- 上期五级分类完成日期
            ,npltransflag -- 不良资产转让标识：转入转出
            ,reversalflag -- 冲正标志：Y-冲正，N-未冲正
            ,risktype -- 风险业务类型
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,odiflag -- 是否复利
            ,odpflag -- 是否罚息
            ,compensatepotype -- 宽限到期日
            ,gracestartdate -- 宽限起始日
            ,loanserialno -- 风险监测关联流水号
            ,whethertorestructuretheloan -- 是否重组贷款
            ,restructuretheloantype -- 重组贷款类型
            ,ispensionindustry -- 养老产业标识
            ,gracetype -- 宽限期类型
            ,gearprodflag -- 是否靠档计息标识
            ,absflag -- 资产证券化标志
            ,intappltype -- 利率启用方式
            ,rollfreq -- 利率变更周期
            ,acctspreadrate -- 浮动百分点
            ,intindflag -- 是否计息
            ,intday -- 存贷结息日期
            ,inttype -- 利率类型
            ,interestbalance -- 利息余额
            ,paymentserialno -- 关联付款申请书编号
            ,actualoverduedays -- 实际逾期天数（来源核心系统）
            ,notificationstatus -- 债权通知书状态（客户级债权通知书）01-未确认,02-已确认
            ,principalbalance -- 本金余额(仅用于对账使用)
            ,tysumcp -- 同业系统本金余额(仅用于对账使用)
            ,originalloandeadline -- 原贷款到期日
            ,settlementaccountbank -- 结算账号开户行
            ,settlementaccountnum -- 结算账户序号
            ,restructuretheloandate -- 实施重组日期
            ,shareamount -- 分润金额
            ,overduecount -- 逾期次数
            ,firstoverduedate -- 首次逾期日期
            ,contoverduedate -- 连续逾期日期
            ,prioverduedays -- 本金逾期天数
            ,intoverduedays -- 利息逾期天数
            ,prioverdueamt -- 本金逾期金额
            ,intoverdueamt -- 利息逾期金额
            ,nextrolldate -- 下一重定价日期
            ,firstrolldate -- 首次重定价日期
            ,subproductname -- 子产品名称
            ,renewaltype -- 重组类型
            ,outrightsaleflag -- 卖断式转让标识
            ,incomerighttransferflag -- 收益权转让标识
            ,recoverflag -- 实时追缴标识
            ,speciallendflag -- 专项再贷款标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_duebill_op(
            serialno -- 借据编号
            ,putoutserialno -- 关联出账编号
            ,contractserialno -- 关联合同编号
            ,occurdate -- 发生日期
            ,occurtype -- 贷款发放类型
            ,vouchtype -- 主担保方式
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,currency -- 币种
            ,businesssum -- 放款金额
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,putoutdate -- 发放日期
            ,maturity -- 约定到期日
            ,actualmaturity -- 实际到期日
            ,ratemodel -- 利率模式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,executerate -- 执行年利率
            ,bailratio -- 保证金比例
            ,bailsum -- 保证金金额
            ,bailaccount -- 保证金账户编号
            ,repaytype -- 还款方式
            ,paymenttype -- 支付方式
            ,repaycycle -- 还款周期
            ,balance -- 贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期余额
            ,dullbalance -- 呆滞余额
            ,badbalance -- 呆账余额
            ,extendtimes -- 展期次数
            ,innerinterestbalance -- 表内欠息余额
            ,outerinterestbalance -- 表外欠息余额
            ,capitalpenaltybalance -- 逾期罚息余额
            ,interestpenaltybalance -- 复息余额
            ,overduedays -- 贷款逾期天数
            ,owninterestdays -- 欠息天数
            ,ichangedate -- 欠息更新日期
            ,graceperiod -- 贷款宽限期
            ,reducereservesum -- 计提准备金额
            ,predictlostsum -- 预测损失金额
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,belongdept -- 所属条线
            ,offsheetflag -- 表内外标志
            ,islowrisk -- 是否低风险
            ,badconfirmdate -- 首次认定不良日期
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,advanceflag -- 担保代偿/垫款标志
            ,businessstatus -- 业务状态
            ,mforgid -- 主机机构号
            ,relativeduebillno -- 原始借据号
            ,loanno -- 贷款卡号
            ,remark -- 备注
            ,operatedate -- 经办日期
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,repaydate -- 默认还款日
            ,mfcustomerid -- 核心客户号
            ,settlementaccount -- 结算账号
            ,overduedate -- 逾期日期
            ,oweinterestdate -- 欠息日期
            ,classifyresulteleven -- 风险分类结果（11级）
            ,overduerate -- 逾期利率
            ,mainorgid -- 机构代号(核心记账机构ID)
            ,remart -- 计量标记-资产三分类
            ,vouchtype2 -- 担保方式2
            ,vouchtype3 -- 担保方式3
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountorgid -- 贷款入账(出账账户)账户开户机构
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,dzhxstatus -- 呆账核销状态
            ,classifyresultelevendate -- 十一级分类日期
            ,loanaccountno -- 贷款入账账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,loanstatus -- 贷款状态
            ,zxzflag -- 支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了
            ,assetflag -- 是否被认定为问题资产
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,wrndate -- 核销日期
            ,repayamt -- 实付金额
            ,prifirstduedate -- 本金未还最早日期
            ,intfirstduedate -- 利息未还最早日期
            ,compensateamt -- 代偿金额
            ,yjintamt -- 应计利息
            ,csyjintamt -- 催收应计利息
            ,ysintamt -- 应收欠息
            ,csintamt -- 催收欠息
            ,yjodpamt -- 应计罚息
            ,csyjodpamt -- 催收应计罚息
            ,ysodpamt -- 应收罚息
            ,csodpamt -- 催收罚息
            ,odppostedctddr -- 应收未收罚息
            ,odipostedctddr -- 应收未收复息
            ,yjodiamt -- 应计复息
            ,wrnpriamt -- 核销本金
            ,wrnintamt -- 核销利息
            ,wrnreceiptamt -- 核销回收金额
            ,intdate -- 下一结息日
            ,accountbalance -- 还款账号余额
            ,accountuserbalance -- 还款账户可用余额
            ,termtype -- 期限类型
            ,insum -- 累计归还本金
            ,interestinsum -- 累计归还利息
            ,exttradeno -- 原业务编号
            ,fyjbalamt -- 非应计余额
            ,periods -- 贷款总期数
            ,remain_periods -- 剩余还款期数
            ,lastclassifyresultten -- 上期十级分类标志
            ,lastclassifyresulttendate -- 上期十级分类日期
            ,classifyfivehchangedate -- 上一期五级分类变更日期
            ,tenclaind -- 十级分类人工干预标志1-人工、2-系统
            ,lastclassifyresult -- 上期五级分类结果
            ,lastclassifyresultdate -- 上期五级分类完成日期
            ,npltransflag -- 不良资产转让标识：转入转出
            ,reversalflag -- 冲正标志：Y-冲正，N-未冲正
            ,risktype -- 风险业务类型
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,odiflag -- 是否复利
            ,odpflag -- 是否罚息
            ,compensatepotype -- 宽限到期日
            ,gracestartdate -- 宽限起始日
            ,loanserialno -- 风险监测关联流水号
            ,whethertorestructuretheloan -- 是否重组贷款
            ,restructuretheloantype -- 重组贷款类型
            ,ispensionindustry -- 养老产业标识
            ,gracetype -- 宽限期类型
            ,gearprodflag -- 是否靠档计息标识
            ,absflag -- 资产证券化标志
            ,intappltype -- 利率启用方式
            ,rollfreq -- 利率变更周期
            ,acctspreadrate -- 浮动百分点
            ,intindflag -- 是否计息
            ,intday -- 存贷结息日期
            ,inttype -- 利率类型
            ,interestbalance -- 利息余额
            ,paymentserialno -- 关联付款申请书编号
            ,actualoverduedays -- 实际逾期天数（来源核心系统）
            ,notificationstatus -- 债权通知书状态（客户级债权通知书）01-未确认,02-已确认
            ,principalbalance -- 本金余额(仅用于对账使用)
            ,tysumcp -- 同业系统本金余额(仅用于对账使用)
            ,originalloandeadline -- 原贷款到期日
            ,settlementaccountbank -- 结算账号开户行
            ,settlementaccountnum -- 结算账户序号
            ,restructuretheloandate -- 实施重组日期
            ,shareamount -- 分润金额
            ,overduecount -- 逾期次数
            ,firstoverduedate -- 首次逾期日期
            ,contoverduedate -- 连续逾期日期
            ,prioverduedays -- 本金逾期天数
            ,intoverduedays -- 利息逾期天数
            ,prioverdueamt -- 本金逾期金额
            ,intoverdueamt -- 利息逾期金额
            ,nextrolldate -- 下一重定价日期
            ,firstrolldate -- 首次重定价日期
            ,subproductname -- 子产品名称
            ,renewaltype -- 重组类型
            ,outrightsaleflag -- 卖断式转让标识
            ,incomerighttransferflag -- 收益权转让标识
            ,recoverflag -- 实时追缴标识
            ,speciallendflag -- 专项再贷款标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 借据编号
    ,nvl(n.putoutserialno, o.putoutserialno) as putoutserialno -- 关联出账编号
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 关联合同编号
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 发生日期
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 贷款发放类型
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主担保方式
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 放款金额
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限(月)
    ,nvl(n.termday, o.termday) as termday -- 期限(天)
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 发放日期
    ,nvl(n.maturity, o.maturity) as maturity -- 约定到期日
    ,nvl(n.actualmaturity, o.actualmaturity) as actualmaturity -- 实际到期日
    ,nvl(n.ratemodel, o.ratemodel) as ratemodel -- 利率模式
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.ratefloattype, o.ratefloattype) as ratefloattype -- 利率浮动方式
    ,nvl(n.executerate, o.executerate) as executerate -- 执行年利率
    ,nvl(n.bailratio, o.bailratio) as bailratio -- 保证金比例
    ,nvl(n.bailsum, o.bailsum) as bailsum -- 保证金金额
    ,nvl(n.bailaccount, o.bailaccount) as bailaccount -- 保证金账户编号
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 还款周期
    ,nvl(n.balance, o.balance) as balance -- 贷款余额
    ,nvl(n.normalbalance, o.normalbalance) as normalbalance -- 正常余额
    ,nvl(n.overduebalance, o.overduebalance) as overduebalance -- 逾期余额
    ,nvl(n.dullbalance, o.dullbalance) as dullbalance -- 呆滞余额
    ,nvl(n.badbalance, o.badbalance) as badbalance -- 呆账余额
    ,nvl(n.extendtimes, o.extendtimes) as extendtimes -- 展期次数
    ,nvl(n.innerinterestbalance, o.innerinterestbalance) as innerinterestbalance -- 表内欠息余额
    ,nvl(n.outerinterestbalance, o.outerinterestbalance) as outerinterestbalance -- 表外欠息余额
    ,nvl(n.capitalpenaltybalance, o.capitalpenaltybalance) as capitalpenaltybalance -- 逾期罚息余额
    ,nvl(n.interestpenaltybalance, o.interestpenaltybalance) as interestpenaltybalance -- 复息余额
    ,nvl(n.overduedays, o.overduedays) as overduedays -- 贷款逾期天数
    ,nvl(n.owninterestdays, o.owninterestdays) as owninterestdays -- 欠息天数
    ,nvl(n.ichangedate, o.ichangedate) as ichangedate -- 欠息更新日期
    ,nvl(n.graceperiod, o.graceperiod) as graceperiod -- 贷款宽限期
    ,nvl(n.reducereservesum, o.reducereservesum) as reducereservesum -- 计提准备金额
    ,nvl(n.predictlostsum, o.predictlostsum) as predictlostsum -- 预测损失金额
    ,nvl(n.finishtype, o.finishtype) as finishtype -- 终结类型
    ,nvl(n.finishdate, o.finishdate) as finishdate -- 终结日期
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 所属条线
    ,nvl(n.offsheetflag, o.offsheetflag) as offsheetflag -- 表内外标志
    ,nvl(n.islowrisk, o.islowrisk) as islowrisk -- 是否低风险
    ,nvl(n.badconfirmdate, o.badconfirmdate) as badconfirmdate -- 首次认定不良日期
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 贷款五级分类
    ,nvl(n.classifydate, o.classifydate) as classifydate -- 风险分类日期
    ,nvl(n.advanceflag, o.advanceflag) as advanceflag -- 担保代偿/垫款标志
    ,nvl(n.businessstatus, o.businessstatus) as businessstatus -- 业务状态
    ,nvl(n.mforgid, o.mforgid) as mforgid -- 主机机构号
    ,nvl(n.relativeduebillno, o.relativeduebillno) as relativeduebillno -- 原始借据号
    ,nvl(n.loanno, o.loanno) as loanno -- 贷款卡号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 经办日期
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 业务经办人编号
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.repaydate, o.repaydate) as repaydate -- 默认还款日
    ,nvl(n.mfcustomerid, o.mfcustomerid) as mfcustomerid -- 核心客户号
    ,nvl(n.settlementaccount, o.settlementaccount) as settlementaccount -- 结算账号
    ,nvl(n.overduedate, o.overduedate) as overduedate -- 逾期日期
    ,nvl(n.oweinterestdate, o.oweinterestdate) as oweinterestdate -- 欠息日期
    ,nvl(n.classifyresulteleven, o.classifyresulteleven) as classifyresulteleven -- 风险分类结果（11级）
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期利率
    ,nvl(n.mainorgid, o.mainorgid) as mainorgid -- 机构代号(核心记账机构ID)
    ,nvl(n.remart, o.remart) as remart -- 计量标记-资产三分类
    ,nvl(n.vouchtype2, o.vouchtype2) as vouchtype2 -- 担保方式2
    ,nvl(n.vouchtype3, o.vouchtype3) as vouchtype3 -- 担保方式3
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 利率调整方式
    ,nvl(n.rateadjustfrequency, o.rateadjustfrequency) as rateadjustfrequency -- 利率调整周期
    ,nvl(n.floatrange, o.floatrange) as floatrange -- 浮动幅度
    ,nvl(n.settlementaccountname, o.settlementaccountname) as settlementaccountname -- 结算账户(还款账户)名
    ,nvl(n.loanaccountorgid, o.loanaccountorgid) as loanaccountorgid -- 贷款入账(出账账户)账户开户机构
    ,nvl(n.overdueratefloattype, o.overdueratefloattype) as overdueratefloattype -- 逾期利率浮动方式
    ,nvl(n.overdueratefloatvalue, o.overdueratefloatvalue) as overdueratefloatvalue -- 逾期利率浮动值
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 出账机构编号(核心机构)
    ,nvl(n.dzhxstatus, o.dzhxstatus) as dzhxstatus -- 呆账核销状态
    ,nvl(n.classifyresultelevendate, o.classifyresultelevendate) as classifyresultelevendate -- 十一级分类日期
    ,nvl(n.loanaccountno, o.loanaccountno) as loanaccountno -- 贷款入账账号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.loanstatus, o.loanstatus) as loanstatus -- 贷款状态
    ,nvl(n.zxzflag, o.zxzflag) as zxzflag -- 支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了
    ,nvl(n.assetflag, o.assetflag) as assetflag -- 是否被认定为问题资产
    ,nvl(n.migtcustomerid, o.migtcustomerid) as migtcustomerid -- 转换前客户号
    ,nvl(n.migtbusinesstype, o.migtbusinesstype) as migtbusinesstype -- 转换前产品ID
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 迁移数据-参数转换前字段值
    ,nvl(n.wrndate, o.wrndate) as wrndate -- 核销日期
    ,nvl(n.repayamt, o.repayamt) as repayamt -- 实付金额
    ,nvl(n.prifirstduedate, o.prifirstduedate) as prifirstduedate -- 本金未还最早日期
    ,nvl(n.intfirstduedate, o.intfirstduedate) as intfirstduedate -- 利息未还最早日期
    ,nvl(n.compensateamt, o.compensateamt) as compensateamt -- 代偿金额
    ,nvl(n.yjintamt, o.yjintamt) as yjintamt -- 应计利息
    ,nvl(n.csyjintamt, o.csyjintamt) as csyjintamt -- 催收应计利息
    ,nvl(n.ysintamt, o.ysintamt) as ysintamt -- 应收欠息
    ,nvl(n.csintamt, o.csintamt) as csintamt -- 催收欠息
    ,nvl(n.yjodpamt, o.yjodpamt) as yjodpamt -- 应计罚息
    ,nvl(n.csyjodpamt, o.csyjodpamt) as csyjodpamt -- 催收应计罚息
    ,nvl(n.ysodpamt, o.ysodpamt) as ysodpamt -- 应收罚息
    ,nvl(n.csodpamt, o.csodpamt) as csodpamt -- 催收罚息
    ,nvl(n.odppostedctddr, o.odppostedctddr) as odppostedctddr -- 应收未收罚息
    ,nvl(n.odipostedctddr, o.odipostedctddr) as odipostedctddr -- 应收未收复息
    ,nvl(n.yjodiamt, o.yjodiamt) as yjodiamt -- 应计复息
    ,nvl(n.wrnpriamt, o.wrnpriamt) as wrnpriamt -- 核销本金
    ,nvl(n.wrnintamt, o.wrnintamt) as wrnintamt -- 核销利息
    ,nvl(n.wrnreceiptamt, o.wrnreceiptamt) as wrnreceiptamt -- 核销回收金额
    ,nvl(n.intdate, o.intdate) as intdate -- 下一结息日
    ,nvl(n.accountbalance, o.accountbalance) as accountbalance -- 还款账号余额
    ,nvl(n.accountuserbalance, o.accountuserbalance) as accountuserbalance -- 还款账户可用余额
    ,nvl(n.termtype, o.termtype) as termtype -- 期限类型
    ,nvl(n.insum, o.insum) as insum -- 累计归还本金
    ,nvl(n.interestinsum, o.interestinsum) as interestinsum -- 累计归还利息
    ,nvl(n.exttradeno, o.exttradeno) as exttradeno -- 原业务编号
    ,nvl(n.fyjbalamt, o.fyjbalamt) as fyjbalamt -- 非应计余额
    ,nvl(n.periods, o.periods) as periods -- 贷款总期数
    ,nvl(n.remain_periods, o.remain_periods) as remain_periods -- 剩余还款期数
    ,nvl(n.lastclassifyresultten, o.lastclassifyresultten) as lastclassifyresultten -- 上期十级分类标志
    ,nvl(n.lastclassifyresulttendate, o.lastclassifyresulttendate) as lastclassifyresulttendate -- 上期十级分类日期
    ,nvl(n.classifyfivehchangedate, o.classifyfivehchangedate) as classifyfivehchangedate -- 上一期五级分类变更日期
    ,nvl(n.tenclaind, o.tenclaind) as tenclaind -- 十级分类人工干预标志1-人工、2-系统
    ,nvl(n.lastclassifyresult, o.lastclassifyresult) as lastclassifyresult -- 上期五级分类结果
    ,nvl(n.lastclassifyresultdate, o.lastclassifyresultdate) as lastclassifyresultdate -- 上期五级分类完成日期
    ,nvl(n.npltransflag, o.npltransflag) as npltransflag -- 不良资产转让标识：转入转出
    ,nvl(n.reversalflag, o.reversalflag) as reversalflag -- 冲正标志：Y-冲正，N-未冲正
    ,nvl(n.risktype, o.risktype) as risktype -- 风险业务类型
    ,nvl(n.ratefloatratioorbp, o.ratefloatratioorbp) as ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
    ,nvl(n.loanaccountname, o.loanaccountname) as loanaccountname -- 贷款入账(收款账户)账户名
    ,nvl(n.odiflag, o.odiflag) as odiflag -- 是否复利
    ,nvl(n.odpflag, o.odpflag) as odpflag -- 是否罚息
    ,nvl(n.compensatepotype, o.compensatepotype) as compensatepotype -- 宽限到期日
    ,nvl(n.gracestartdate, o.gracestartdate) as gracestartdate -- 宽限起始日
    ,nvl(n.loanserialno, o.loanserialno) as loanserialno -- 风险监测关联流水号
    ,nvl(n.whethertorestructuretheloan, o.whethertorestructuretheloan) as whethertorestructuretheloan -- 是否重组贷款
    ,nvl(n.restructuretheloantype, o.restructuretheloantype) as restructuretheloantype -- 重组贷款类型
    ,nvl(n.ispensionindustry, o.ispensionindustry) as ispensionindustry -- 养老产业标识
    ,nvl(n.gracetype, o.gracetype) as gracetype -- 宽限期类型
    ,nvl(n.gearprodflag, o.gearprodflag) as gearprodflag -- 是否靠档计息标识
    ,nvl(n.absflag, o.absflag) as absflag -- 资产证券化标志
    ,nvl(n.intappltype, o.intappltype) as intappltype -- 利率启用方式
    ,nvl(n.rollfreq, o.rollfreq) as rollfreq -- 利率变更周期
    ,nvl(n.acctspreadrate, o.acctspreadrate) as acctspreadrate -- 浮动百分点
    ,nvl(n.intindflag, o.intindflag) as intindflag -- 是否计息
    ,nvl(n.intday, o.intday) as intday -- 存贷结息日期
    ,nvl(n.inttype, o.inttype) as inttype -- 利率类型
    ,nvl(n.interestbalance, o.interestbalance) as interestbalance -- 利息余额
    ,nvl(n.paymentserialno, o.paymentserialno) as paymentserialno -- 关联付款申请书编号
    ,nvl(n.actualoverduedays, o.actualoverduedays) as actualoverduedays -- 实际逾期天数（来源核心系统）
    ,nvl(n.notificationstatus, o.notificationstatus) as notificationstatus -- 债权通知书状态（客户级债权通知书）01-未确认,02-已确认
    ,nvl(n.principalbalance, o.principalbalance) as principalbalance -- 本金余额(仅用于对账使用)
    ,nvl(n.tysumcp, o.tysumcp) as tysumcp -- 同业系统本金余额(仅用于对账使用)
    ,nvl(n.originalloandeadline, o.originalloandeadline) as originalloandeadline -- 原贷款到期日
    ,nvl(n.settlementaccountbank, o.settlementaccountbank) as settlementaccountbank -- 结算账号开户行
    ,nvl(n.settlementaccountnum, o.settlementaccountnum) as settlementaccountnum -- 结算账户序号
    ,nvl(n.restructuretheloandate, o.restructuretheloandate) as restructuretheloandate -- 实施重组日期
    ,nvl(n.shareamount, o.shareamount) as shareamount -- 分润金额
    ,nvl(n.overduecount, o.overduecount) as overduecount -- 逾期次数
    ,nvl(n.firstoverduedate, o.firstoverduedate) as firstoverduedate -- 首次逾期日期
    ,nvl(n.contoverduedate, o.contoverduedate) as contoverduedate -- 连续逾期日期
    ,nvl(n.prioverduedays, o.prioverduedays) as prioverduedays -- 本金逾期天数
    ,nvl(n.intoverduedays, o.intoverduedays) as intoverduedays -- 利息逾期天数
    ,nvl(n.prioverdueamt, o.prioverdueamt) as prioverdueamt -- 本金逾期金额
    ,nvl(n.intoverdueamt, o.intoverdueamt) as intoverdueamt -- 利息逾期金额
    ,nvl(n.nextrolldate, o.nextrolldate) as nextrolldate -- 下一重定价日期
    ,nvl(n.firstrolldate, o.firstrolldate) as firstrolldate -- 首次重定价日期
    ,nvl(n.subproductname, o.subproductname) as subproductname -- 子产品名称
    ,nvl(n.renewaltype, o.renewaltype) as renewaltype -- 重组类型
    ,nvl(n.outrightsaleflag, o.outrightsaleflag) as outrightsaleflag -- 卖断式转让标识
    ,nvl(n.incomerighttransferflag, o.incomerighttransferflag) as incomerighttransferflag -- 收益权转让标识
    ,nvl(n.recoverflag, o.recoverflag) as recoverflag -- 实时追缴标识
    ,nvl(n.speciallendflag, o.speciallendflag) as speciallendflag -- 专项再贷款标识
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_business_duebill_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_business_duebill where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.putoutserialno <> n.putoutserialno
        or o.contractserialno <> n.contractserialno
        or o.occurdate <> n.occurdate
        or o.occurtype <> n.occurtype
        or o.vouchtype <> n.vouchtype
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.productid <> n.productid
        or o.currency <> n.currency
        or o.businesssum <> n.businesssum
        or o.termmonth <> n.termmonth
        or o.termday <> n.termday
        or o.putoutdate <> n.putoutdate
        or o.maturity <> n.maturity
        or o.actualmaturity <> n.actualmaturity
        or o.ratemodel <> n.ratemodel
        or o.baseratetype <> n.baseratetype
        or o.baserate <> n.baserate
        or o.ratefloattype <> n.ratefloattype
        or o.executerate <> n.executerate
        or o.bailratio <> n.bailratio
        or o.bailsum <> n.bailsum
        or o.bailaccount <> n.bailaccount
        or o.repaytype <> n.repaytype
        or o.paymenttype <> n.paymenttype
        or o.repaycycle <> n.repaycycle
        or o.balance <> n.balance
        or o.normalbalance <> n.normalbalance
        or o.overduebalance <> n.overduebalance
        or o.dullbalance <> n.dullbalance
        or o.badbalance <> n.badbalance
        or o.extendtimes <> n.extendtimes
        or o.innerinterestbalance <> n.innerinterestbalance
        or o.outerinterestbalance <> n.outerinterestbalance
        or o.capitalpenaltybalance <> n.capitalpenaltybalance
        or o.interestpenaltybalance <> n.interestpenaltybalance
        or o.overduedays <> n.overduedays
        or o.owninterestdays <> n.owninterestdays
        or o.ichangedate <> n.ichangedate
        or o.graceperiod <> n.graceperiod
        or o.reducereservesum <> n.reducereservesum
        or o.predictlostsum <> n.predictlostsum
        or o.finishtype <> n.finishtype
        or o.finishdate <> n.finishdate
        or o.belongdept <> n.belongdept
        or o.offsheetflag <> n.offsheetflag
        or o.islowrisk <> n.islowrisk
        or o.badconfirmdate <> n.badconfirmdate
        or o.classifyresult <> n.classifyresult
        or o.classifydate <> n.classifydate
        or o.advanceflag <> n.advanceflag
        or o.businessstatus <> n.businessstatus
        or o.mforgid <> n.mforgid
        or o.relativeduebillno <> n.relativeduebillno
        or o.loanno <> n.loanno
        or o.remark <> n.remark
        or o.operatedate <> n.operatedate
        or o.operateuserid <> n.operateuserid
        or o.operateorgid <> n.operateorgid
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.corporgid <> n.corporgid
        or o.repaydate <> n.repaydate
        or o.mfcustomerid <> n.mfcustomerid
        or o.settlementaccount <> n.settlementaccount
        or o.overduedate <> n.overduedate
        or o.oweinterestdate <> n.oweinterestdate
        or o.classifyresulteleven <> n.classifyresulteleven
        or o.overduerate <> n.overduerate
        or o.mainorgid <> n.mainorgid
        or o.remart <> n.remart
        or o.vouchtype2 <> n.vouchtype2
        or o.vouchtype3 <> n.vouchtype3
        or o.rateadjusttype <> n.rateadjusttype
        or o.rateadjustfrequency <> n.rateadjustfrequency
        or o.floatrange <> n.floatrange
        or o.settlementaccountname <> n.settlementaccountname
        or o.loanaccountorgid <> n.loanaccountorgid
        or o.overdueratefloattype <> n.overdueratefloattype
        or o.overdueratefloatvalue <> n.overdueratefloatvalue
        or o.putoutorgid <> n.putoutorgid
        or o.dzhxstatus <> n.dzhxstatus
        or o.classifyresultelevendate <> n.classifyresultelevendate
        or o.loanaccountno <> n.loanaccountno
        or o.migtflag <> n.migtflag
        or o.loanstatus <> n.loanstatus
        or o.zxzflag <> n.zxzflag
        or o.assetflag <> n.assetflag
        or o.migtcustomerid <> n.migtcustomerid
        or o.migtbusinesstype <> n.migtbusinesstype
        or o.migtoldvalue <> n.migtoldvalue
        or o.wrndate <> n.wrndate
        or o.repayamt <> n.repayamt
        or o.prifirstduedate <> n.prifirstduedate
        or o.intfirstduedate <> n.intfirstduedate
        or o.compensateamt <> n.compensateamt
        or o.yjintamt <> n.yjintamt
        or o.csyjintamt <> n.csyjintamt
        or o.ysintamt <> n.ysintamt
        or o.csintamt <> n.csintamt
        or o.yjodpamt <> n.yjodpamt
        or o.csyjodpamt <> n.csyjodpamt
        or o.ysodpamt <> n.ysodpamt
        or o.csodpamt <> n.csodpamt
        or o.odppostedctddr <> n.odppostedctddr
        or o.odipostedctddr <> n.odipostedctddr
        or o.yjodiamt <> n.yjodiamt
        or o.wrnpriamt <> n.wrnpriamt
        or o.wrnintamt <> n.wrnintamt
        or o.wrnreceiptamt <> n.wrnreceiptamt
        or o.intdate <> n.intdate
        or o.accountbalance <> n.accountbalance
        or o.accountuserbalance <> n.accountuserbalance
        or o.termtype <> n.termtype
        or o.insum <> n.insum
        or o.interestinsum <> n.interestinsum
        or o.exttradeno <> n.exttradeno
        or o.fyjbalamt <> n.fyjbalamt
        or o.periods <> n.periods
        or o.remain_periods <> n.remain_periods
        or o.lastclassifyresultten <> n.lastclassifyresultten
        or o.lastclassifyresulttendate <> n.lastclassifyresulttendate
        or o.classifyfivehchangedate <> n.classifyfivehchangedate
        or o.tenclaind <> n.tenclaind
        or o.lastclassifyresult <> n.lastclassifyresult
        or o.lastclassifyresultdate <> n.lastclassifyresultdate
        or o.npltransflag <> n.npltransflag
        or o.reversalflag <> n.reversalflag
        or o.risktype <> n.risktype
        or o.ratefloatratioorbp <> n.ratefloatratioorbp
        or o.loanaccountname <> n.loanaccountname
        or o.odiflag <> n.odiflag
        or o.odpflag <> n.odpflag
        or o.compensatepotype <> n.compensatepotype
        or o.gracestartdate <> n.gracestartdate
        or o.loanserialno <> n.loanserialno
        or o.whethertorestructuretheloan <> n.whethertorestructuretheloan
        or o.restructuretheloantype <> n.restructuretheloantype
        or o.ispensionindustry <> n.ispensionindustry
        or o.gracetype <> n.gracetype
        or o.gearprodflag <> n.gearprodflag
        or o.absflag <> n.absflag
        or o.intappltype <> n.intappltype
        or o.rollfreq <> n.rollfreq
        or o.acctspreadrate <> n.acctspreadrate
        or o.intindflag <> n.intindflag
        or o.intday <> n.intday
        or o.inttype <> n.inttype
        or o.interestbalance <> n.interestbalance
        or o.paymentserialno <> n.paymentserialno
        or o.actualoverduedays <> n.actualoverduedays
        or o.notificationstatus <> n.notificationstatus
        or o.principalbalance <> n.principalbalance
        or o.tysumcp <> n.tysumcp
        or o.originalloandeadline <> n.originalloandeadline
        or o.settlementaccountbank <> n.settlementaccountbank
        or o.settlementaccountnum <> n.settlementaccountnum
        or o.restructuretheloandate <> n.restructuretheloandate
        or o.shareamount <> n.shareamount
        or o.overduecount <> n.overduecount
        or o.firstoverduedate <> n.firstoverduedate
        or o.contoverduedate <> n.contoverduedate
        or o.prioverduedays <> n.prioverduedays
        or o.intoverduedays <> n.intoverduedays
        or o.prioverdueamt <> n.prioverdueamt
        or o.intoverdueamt <> n.intoverdueamt
        or o.nextrolldate <> n.nextrolldate
        or o.firstrolldate <> n.firstrolldate
        or o.subproductname <> n.subproductname
        or o.renewaltype <> n.renewaltype
        or o.outrightsaleflag <> n.outrightsaleflag
        or o.incomerighttransferflag <> n.incomerighttransferflag
        or o.recoverflag <> n.recoverflag
        or o.speciallendflag <> n.speciallendflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_duebill_cl(
            serialno -- 借据编号
            ,putoutserialno -- 关联出账编号
            ,contractserialno -- 关联合同编号
            ,occurdate -- 发生日期
            ,occurtype -- 贷款发放类型
            ,vouchtype -- 主担保方式
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,currency -- 币种
            ,businesssum -- 放款金额
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,putoutdate -- 发放日期
            ,maturity -- 约定到期日
            ,actualmaturity -- 实际到期日
            ,ratemodel -- 利率模式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,executerate -- 执行年利率
            ,bailratio -- 保证金比例
            ,bailsum -- 保证金金额
            ,bailaccount -- 保证金账户编号
            ,repaytype -- 还款方式
            ,paymenttype -- 支付方式
            ,repaycycle -- 还款周期
            ,balance -- 贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期余额
            ,dullbalance -- 呆滞余额
            ,badbalance -- 呆账余额
            ,extendtimes -- 展期次数
            ,innerinterestbalance -- 表内欠息余额
            ,outerinterestbalance -- 表外欠息余额
            ,capitalpenaltybalance -- 逾期罚息余额
            ,interestpenaltybalance -- 复息余额
            ,overduedays -- 贷款逾期天数
            ,owninterestdays -- 欠息天数
            ,ichangedate -- 欠息更新日期
            ,graceperiod -- 贷款宽限期
            ,reducereservesum -- 计提准备金额
            ,predictlostsum -- 预测损失金额
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,belongdept -- 所属条线
            ,offsheetflag -- 表内外标志
            ,islowrisk -- 是否低风险
            ,badconfirmdate -- 首次认定不良日期
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,advanceflag -- 担保代偿/垫款标志
            ,businessstatus -- 业务状态
            ,mforgid -- 主机机构号
            ,relativeduebillno -- 原始借据号
            ,loanno -- 贷款卡号
            ,remark -- 备注
            ,operatedate -- 经办日期
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,repaydate -- 默认还款日
            ,mfcustomerid -- 核心客户号
            ,settlementaccount -- 结算账号
            ,overduedate -- 逾期日期
            ,oweinterestdate -- 欠息日期
            ,classifyresulteleven -- 风险分类结果（11级）
            ,overduerate -- 逾期利率
            ,mainorgid -- 机构代号(核心记账机构ID)
            ,remart -- 计量标记-资产三分类
            ,vouchtype2 -- 担保方式2
            ,vouchtype3 -- 担保方式3
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountorgid -- 贷款入账(出账账户)账户开户机构
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,dzhxstatus -- 呆账核销状态
            ,classifyresultelevendate -- 十一级分类日期
            ,loanaccountno -- 贷款入账账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,loanstatus -- 贷款状态
            ,zxzflag -- 支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了
            ,assetflag -- 是否被认定为问题资产
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,wrndate -- 核销日期
            ,repayamt -- 实付金额
            ,prifirstduedate -- 本金未还最早日期
            ,intfirstduedate -- 利息未还最早日期
            ,compensateamt -- 代偿金额
            ,yjintamt -- 应计利息
            ,csyjintamt -- 催收应计利息
            ,ysintamt -- 应收欠息
            ,csintamt -- 催收欠息
            ,yjodpamt -- 应计罚息
            ,csyjodpamt -- 催收应计罚息
            ,ysodpamt -- 应收罚息
            ,csodpamt -- 催收罚息
            ,odppostedctddr -- 应收未收罚息
            ,odipostedctddr -- 应收未收复息
            ,yjodiamt -- 应计复息
            ,wrnpriamt -- 核销本金
            ,wrnintamt -- 核销利息
            ,wrnreceiptamt -- 核销回收金额
            ,intdate -- 下一结息日
            ,accountbalance -- 还款账号余额
            ,accountuserbalance -- 还款账户可用余额
            ,termtype -- 期限类型
            ,insum -- 累计归还本金
            ,interestinsum -- 累计归还利息
            ,exttradeno -- 原业务编号
            ,fyjbalamt -- 非应计余额
            ,periods -- 贷款总期数
            ,remain_periods -- 剩余还款期数
            ,lastclassifyresultten -- 上期十级分类标志
            ,lastclassifyresulttendate -- 上期十级分类日期
            ,classifyfivehchangedate -- 上一期五级分类变更日期
            ,tenclaind -- 十级分类人工干预标志1-人工、2-系统
            ,lastclassifyresult -- 上期五级分类结果
            ,lastclassifyresultdate -- 上期五级分类完成日期
            ,npltransflag -- 不良资产转让标识：转入转出
            ,reversalflag -- 冲正标志：Y-冲正，N-未冲正
            ,risktype -- 风险业务类型
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,odiflag -- 是否复利
            ,odpflag -- 是否罚息
            ,compensatepotype -- 宽限到期日
            ,gracestartdate -- 宽限起始日
            ,loanserialno -- 风险监测关联流水号
            ,whethertorestructuretheloan -- 是否重组贷款
            ,restructuretheloantype -- 重组贷款类型
            ,ispensionindustry -- 养老产业标识
            ,gracetype -- 宽限期类型
            ,gearprodflag -- 是否靠档计息标识
            ,absflag -- 资产证券化标志
            ,intappltype -- 利率启用方式
            ,rollfreq -- 利率变更周期
            ,acctspreadrate -- 浮动百分点
            ,intindflag -- 是否计息
            ,intday -- 存贷结息日期
            ,inttype -- 利率类型
            ,interestbalance -- 利息余额
            ,paymentserialno -- 关联付款申请书编号
            ,actualoverduedays -- 实际逾期天数（来源核心系统）
            ,notificationstatus -- 债权通知书状态（客户级债权通知书）01-未确认,02-已确认
            ,principalbalance -- 本金余额(仅用于对账使用)
            ,tysumcp -- 同业系统本金余额(仅用于对账使用)
            ,originalloandeadline -- 原贷款到期日
            ,settlementaccountbank -- 结算账号开户行
            ,settlementaccountnum -- 结算账户序号
            ,restructuretheloandate -- 实施重组日期
            ,shareamount -- 分润金额
            ,overduecount -- 逾期次数
            ,firstoverduedate -- 首次逾期日期
            ,contoverduedate -- 连续逾期日期
            ,prioverduedays -- 本金逾期天数
            ,intoverduedays -- 利息逾期天数
            ,prioverdueamt -- 本金逾期金额
            ,intoverdueamt -- 利息逾期金额
            ,nextrolldate -- 下一重定价日期
            ,firstrolldate -- 首次重定价日期
            ,subproductname -- 子产品名称
            ,renewaltype -- 重组类型
            ,outrightsaleflag -- 卖断式转让标识
            ,incomerighttransferflag -- 收益权转让标识
            ,recoverflag -- 实时追缴标识
            ,speciallendflag -- 专项再贷款标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_duebill_op(
            serialno -- 借据编号
            ,putoutserialno -- 关联出账编号
            ,contractserialno -- 关联合同编号
            ,occurdate -- 发生日期
            ,occurtype -- 贷款发放类型
            ,vouchtype -- 主担保方式
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,currency -- 币种
            ,businesssum -- 放款金额
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,putoutdate -- 发放日期
            ,maturity -- 约定到期日
            ,actualmaturity -- 实际到期日
            ,ratemodel -- 利率模式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,executerate -- 执行年利率
            ,bailratio -- 保证金比例
            ,bailsum -- 保证金金额
            ,bailaccount -- 保证金账户编号
            ,repaytype -- 还款方式
            ,paymenttype -- 支付方式
            ,repaycycle -- 还款周期
            ,balance -- 贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期余额
            ,dullbalance -- 呆滞余额
            ,badbalance -- 呆账余额
            ,extendtimes -- 展期次数
            ,innerinterestbalance -- 表内欠息余额
            ,outerinterestbalance -- 表外欠息余额
            ,capitalpenaltybalance -- 逾期罚息余额
            ,interestpenaltybalance -- 复息余额
            ,overduedays -- 贷款逾期天数
            ,owninterestdays -- 欠息天数
            ,ichangedate -- 欠息更新日期
            ,graceperiod -- 贷款宽限期
            ,reducereservesum -- 计提准备金额
            ,predictlostsum -- 预测损失金额
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,belongdept -- 所属条线
            ,offsheetflag -- 表内外标志
            ,islowrisk -- 是否低风险
            ,badconfirmdate -- 首次认定不良日期
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,advanceflag -- 担保代偿/垫款标志
            ,businessstatus -- 业务状态
            ,mforgid -- 主机机构号
            ,relativeduebillno -- 原始借据号
            ,loanno -- 贷款卡号
            ,remark -- 备注
            ,operatedate -- 经办日期
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,repaydate -- 默认还款日
            ,mfcustomerid -- 核心客户号
            ,settlementaccount -- 结算账号
            ,overduedate -- 逾期日期
            ,oweinterestdate -- 欠息日期
            ,classifyresulteleven -- 风险分类结果（11级）
            ,overduerate -- 逾期利率
            ,mainorgid -- 机构代号(核心记账机构ID)
            ,remart -- 计量标记-资产三分类
            ,vouchtype2 -- 担保方式2
            ,vouchtype3 -- 担保方式3
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountorgid -- 贷款入账(出账账户)账户开户机构
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,dzhxstatus -- 呆账核销状态
            ,classifyresultelevendate -- 十一级分类日期
            ,loanaccountno -- 贷款入账账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,loanstatus -- 贷款状态
            ,zxzflag -- 支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了
            ,assetflag -- 是否被认定为问题资产
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,wrndate -- 核销日期
            ,repayamt -- 实付金额
            ,prifirstduedate -- 本金未还最早日期
            ,intfirstduedate -- 利息未还最早日期
            ,compensateamt -- 代偿金额
            ,yjintamt -- 应计利息
            ,csyjintamt -- 催收应计利息
            ,ysintamt -- 应收欠息
            ,csintamt -- 催收欠息
            ,yjodpamt -- 应计罚息
            ,csyjodpamt -- 催收应计罚息
            ,ysodpamt -- 应收罚息
            ,csodpamt -- 催收罚息
            ,odppostedctddr -- 应收未收罚息
            ,odipostedctddr -- 应收未收复息
            ,yjodiamt -- 应计复息
            ,wrnpriamt -- 核销本金
            ,wrnintamt -- 核销利息
            ,wrnreceiptamt -- 核销回收金额
            ,intdate -- 下一结息日
            ,accountbalance -- 还款账号余额
            ,accountuserbalance -- 还款账户可用余额
            ,termtype -- 期限类型
            ,insum -- 累计归还本金
            ,interestinsum -- 累计归还利息
            ,exttradeno -- 原业务编号
            ,fyjbalamt -- 非应计余额
            ,periods -- 贷款总期数
            ,remain_periods -- 剩余还款期数
            ,lastclassifyresultten -- 上期十级分类标志
            ,lastclassifyresulttendate -- 上期十级分类日期
            ,classifyfivehchangedate -- 上一期五级分类变更日期
            ,tenclaind -- 十级分类人工干预标志1-人工、2-系统
            ,lastclassifyresult -- 上期五级分类结果
            ,lastclassifyresultdate -- 上期五级分类完成日期
            ,npltransflag -- 不良资产转让标识：转入转出
            ,reversalflag -- 冲正标志：Y-冲正，N-未冲正
            ,risktype -- 风险业务类型
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,odiflag -- 是否复利
            ,odpflag -- 是否罚息
            ,compensatepotype -- 宽限到期日
            ,gracestartdate -- 宽限起始日
            ,loanserialno -- 风险监测关联流水号
            ,whethertorestructuretheloan -- 是否重组贷款
            ,restructuretheloantype -- 重组贷款类型
            ,ispensionindustry -- 养老产业标识
            ,gracetype -- 宽限期类型
            ,gearprodflag -- 是否靠档计息标识
            ,absflag -- 资产证券化标志
            ,intappltype -- 利率启用方式
            ,rollfreq -- 利率变更周期
            ,acctspreadrate -- 浮动百分点
            ,intindflag -- 是否计息
            ,intday -- 存贷结息日期
            ,inttype -- 利率类型
            ,interestbalance -- 利息余额
            ,paymentserialno -- 关联付款申请书编号
            ,actualoverduedays -- 实际逾期天数（来源核心系统）
            ,notificationstatus -- 债权通知书状态（客户级债权通知书）01-未确认,02-已确认
            ,principalbalance -- 本金余额(仅用于对账使用)
            ,tysumcp -- 同业系统本金余额(仅用于对账使用)
            ,originalloandeadline -- 原贷款到期日
            ,settlementaccountbank -- 结算账号开户行
            ,settlementaccountnum -- 结算账户序号
            ,restructuretheloandate -- 实施重组日期
            ,shareamount -- 分润金额
            ,overduecount -- 逾期次数
            ,firstoverduedate -- 首次逾期日期
            ,contoverduedate -- 连续逾期日期
            ,prioverduedays -- 本金逾期天数
            ,intoverduedays -- 利息逾期天数
            ,prioverdueamt -- 本金逾期金额
            ,intoverdueamt -- 利息逾期金额
            ,nextrolldate -- 下一重定价日期
            ,firstrolldate -- 首次重定价日期
            ,subproductname -- 子产品名称
            ,renewaltype -- 重组类型
            ,outrightsaleflag -- 卖断式转让标识
            ,incomerighttransferflag -- 收益权转让标识
            ,recoverflag -- 实时追缴标识
            ,speciallendflag -- 专项再贷款标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 借据编号
    ,o.putoutserialno -- 关联出账编号
    ,o.contractserialno -- 关联合同编号
    ,o.occurdate -- 发生日期
    ,o.occurtype -- 贷款发放类型
    ,o.vouchtype -- 主担保方式
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.productid -- 产品编号
    ,o.currency -- 币种
    ,o.businesssum -- 放款金额
    ,o.termmonth -- 期限(月)
    ,o.termday -- 期限(天)
    ,o.putoutdate -- 发放日期
    ,o.maturity -- 约定到期日
    ,o.actualmaturity -- 实际到期日
    ,o.ratemodel -- 利率模式
    ,o.baseratetype -- 基准利率类型
    ,o.baserate -- 基准利率
    ,o.ratefloattype -- 利率浮动方式
    ,o.executerate -- 执行年利率
    ,o.bailratio -- 保证金比例
    ,o.bailsum -- 保证金金额
    ,o.bailaccount -- 保证金账户编号
    ,o.repaytype -- 还款方式
    ,o.paymenttype -- 支付方式
    ,o.repaycycle -- 还款周期
    ,o.balance -- 贷款余额
    ,o.normalbalance -- 正常余额
    ,o.overduebalance -- 逾期余额
    ,o.dullbalance -- 呆滞余额
    ,o.badbalance -- 呆账余额
    ,o.extendtimes -- 展期次数
    ,o.innerinterestbalance -- 表内欠息余额
    ,o.outerinterestbalance -- 表外欠息余额
    ,o.capitalpenaltybalance -- 逾期罚息余额
    ,o.interestpenaltybalance -- 复息余额
    ,o.overduedays -- 贷款逾期天数
    ,o.owninterestdays -- 欠息天数
    ,o.ichangedate -- 欠息更新日期
    ,o.graceperiod -- 贷款宽限期
    ,o.reducereservesum -- 计提准备金额
    ,o.predictlostsum -- 预测损失金额
    ,o.finishtype -- 终结类型
    ,o.finishdate -- 终结日期
    ,o.belongdept -- 所属条线
    ,o.offsheetflag -- 表内外标志
    ,o.islowrisk -- 是否低风险
    ,o.badconfirmdate -- 首次认定不良日期
    ,o.classifyresult -- 贷款五级分类
    ,o.classifydate -- 风险分类日期
    ,o.advanceflag -- 担保代偿/垫款标志
    ,o.businessstatus -- 业务状态
    ,o.mforgid -- 主机机构号
    ,o.relativeduebillno -- 原始借据号
    ,o.loanno -- 贷款卡号
    ,o.remark -- 备注
    ,o.operatedate -- 经办日期
    ,o.operateuserid -- 业务经办人编号
    ,o.operateorgid -- 经办机构
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.corporgid -- 法人机构编号
    ,o.repaydate -- 默认还款日
    ,o.mfcustomerid -- 核心客户号
    ,o.settlementaccount -- 结算账号
    ,o.overduedate -- 逾期日期
    ,o.oweinterestdate -- 欠息日期
    ,o.classifyresulteleven -- 风险分类结果（11级）
    ,o.overduerate -- 逾期利率
    ,o.mainorgid -- 机构代号(核心记账机构ID)
    ,o.remart -- 计量标记-资产三分类
    ,o.vouchtype2 -- 担保方式2
    ,o.vouchtype3 -- 担保方式3
    ,o.rateadjusttype -- 利率调整方式
    ,o.rateadjustfrequency -- 利率调整周期
    ,o.floatrange -- 浮动幅度
    ,o.settlementaccountname -- 结算账户(还款账户)名
    ,o.loanaccountorgid -- 贷款入账(出账账户)账户开户机构
    ,o.overdueratefloattype -- 逾期利率浮动方式
    ,o.overdueratefloatvalue -- 逾期利率浮动值
    ,o.putoutorgid -- 出账机构编号(核心机构)
    ,o.dzhxstatus -- 呆账核销状态
    ,o.classifyresultelevendate -- 十一级分类日期
    ,o.loanaccountno -- 贷款入账账号
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.loanstatus -- 贷款状态
    ,o.zxzflag -- 支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了
    ,o.assetflag -- 是否被认定为问题资产
    ,o.migtcustomerid -- 转换前客户号
    ,o.migtbusinesstype -- 转换前产品ID
    ,o.migtoldvalue -- 迁移数据-参数转换前字段值
    ,o.wrndate -- 核销日期
    ,o.repayamt -- 实付金额
    ,o.prifirstduedate -- 本金未还最早日期
    ,o.intfirstduedate -- 利息未还最早日期
    ,o.compensateamt -- 代偿金额
    ,o.yjintamt -- 应计利息
    ,o.csyjintamt -- 催收应计利息
    ,o.ysintamt -- 应收欠息
    ,o.csintamt -- 催收欠息
    ,o.yjodpamt -- 应计罚息
    ,o.csyjodpamt -- 催收应计罚息
    ,o.ysodpamt -- 应收罚息
    ,o.csodpamt -- 催收罚息
    ,o.odppostedctddr -- 应收未收罚息
    ,o.odipostedctddr -- 应收未收复息
    ,o.yjodiamt -- 应计复息
    ,o.wrnpriamt -- 核销本金
    ,o.wrnintamt -- 核销利息
    ,o.wrnreceiptamt -- 核销回收金额
    ,o.intdate -- 下一结息日
    ,o.accountbalance -- 还款账号余额
    ,o.accountuserbalance -- 还款账户可用余额
    ,o.termtype -- 期限类型
    ,o.insum -- 累计归还本金
    ,o.interestinsum -- 累计归还利息
    ,o.exttradeno -- 原业务编号
    ,o.fyjbalamt -- 非应计余额
    ,o.periods -- 贷款总期数
    ,o.remain_periods -- 剩余还款期数
    ,o.lastclassifyresultten -- 上期十级分类标志
    ,o.lastclassifyresulttendate -- 上期十级分类日期
    ,o.classifyfivehchangedate -- 上一期五级分类变更日期
    ,o.tenclaind -- 十级分类人工干预标志1-人工、2-系统
    ,o.lastclassifyresult -- 上期五级分类结果
    ,o.lastclassifyresultdate -- 上期五级分类完成日期
    ,o.npltransflag -- 不良资产转让标识：转入转出
    ,o.reversalflag -- 冲正标志：Y-冲正，N-未冲正
    ,o.risktype -- 风险业务类型
    ,o.ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
    ,o.loanaccountname -- 贷款入账(收款账户)账户名
    ,o.odiflag -- 是否复利
    ,o.odpflag -- 是否罚息
    ,o.compensatepotype -- 宽限到期日
    ,o.gracestartdate -- 宽限起始日
    ,o.loanserialno -- 风险监测关联流水号
    ,o.whethertorestructuretheloan -- 是否重组贷款
    ,o.restructuretheloantype -- 重组贷款类型
    ,o.ispensionindustry -- 养老产业标识
    ,o.gracetype -- 宽限期类型
    ,o.gearprodflag -- 是否靠档计息标识
    ,o.absflag -- 资产证券化标志
    ,o.intappltype -- 利率启用方式
    ,o.rollfreq -- 利率变更周期
    ,o.acctspreadrate -- 浮动百分点
    ,o.intindflag -- 是否计息
    ,o.intday -- 存贷结息日期
    ,o.inttype -- 利率类型
    ,o.interestbalance -- 利息余额
    ,o.paymentserialno -- 关联付款申请书编号
    ,o.actualoverduedays -- 实际逾期天数（来源核心系统）
    ,o.notificationstatus -- 债权通知书状态（客户级债权通知书）01-未确认,02-已确认
    ,o.principalbalance -- 本金余额(仅用于对账使用)
    ,o.tysumcp -- 同业系统本金余额(仅用于对账使用)
    ,o.originalloandeadline -- 原贷款到期日
    ,o.settlementaccountbank -- 结算账号开户行
    ,o.settlementaccountnum -- 结算账户序号
    ,o.restructuretheloandate -- 实施重组日期
    ,o.shareamount -- 分润金额
    ,o.overduecount -- 逾期次数
    ,o.firstoverduedate -- 首次逾期日期
    ,o.contoverduedate -- 连续逾期日期
    ,o.prioverduedays -- 本金逾期天数
    ,o.intoverduedays -- 利息逾期天数
    ,o.prioverdueamt -- 本金逾期金额
    ,o.intoverdueamt -- 利息逾期金额
    ,o.nextrolldate -- 下一重定价日期
    ,o.firstrolldate -- 首次重定价日期
    ,o.subproductname -- 子产品名称
    ,o.renewaltype -- 重组类型
    ,o.outrightsaleflag -- 卖断式转让标识
    ,o.incomerighttransferflag -- 收益权转让标识
    ,o.recoverflag -- 实时追缴标识
    ,o.speciallendflag -- 专项再贷款标识
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_business_duebill_bk o
    left join ${iol_schema}.icms_business_duebill_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_business_duebill_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_business_duebill;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_business_duebill') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_business_duebill drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_business_duebill add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_business_duebill exchange partition p_${batch_date} with table ${iol_schema}.icms_business_duebill_cl;
alter table ${iol_schema}.icms_business_duebill exchange partition p_20991231 with table ${iol_schema}.icms_business_duebill_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_business_duebill to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_duebill_op purge;
drop table ${iol_schema}.icms_business_duebill_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_business_duebill_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_business_duebill',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
