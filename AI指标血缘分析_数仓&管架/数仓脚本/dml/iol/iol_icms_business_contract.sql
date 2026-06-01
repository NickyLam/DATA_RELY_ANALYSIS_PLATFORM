/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_business_contract
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
create table ${iol_schema}.icms_business_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_business_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_contract_op purge;
drop table ${iol_schema}.icms_business_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_contract where 0=1;

create table ${iol_schema}.icms_business_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_contract_cl(
            serialno -- 合同编号
            ,bapserialno -- 批复编号
            ,relacontractno -- 关联合同编号
            ,artificialno -- 文本合同编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businessflag -- 额度/业务标志
            ,oldcontractno -- 关联的旧合同号
            ,applytype -- 申请类型
            ,occurtype -- 贷款发放类型
            ,occurdate -- 签订日期
            ,currency -- 额度/业务币种
            ,businesssum -- 合同金额
            ,putoutsum -- 实际放款金额
            ,putoutdate -- 放款日期
            ,baseproduct -- 基础产品(额度)基础产品
            ,productid -- 产品编号
            ,policyid -- 产品政策编号
            ,policyversionid -- 产品政策版本编号
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,iscycle -- 是否循环(额度)是否循环
            ,risktype -- 风险类型(额度)风险类型（一般、低风险）
            ,islowrisk -- 是否低风险业务
            ,isremotebusiness -- 是否异地业务
            ,ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
            ,fixedrate -- 固定利率
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,floatrange -- 浮动幅度
            ,executerate -- 执行利率
            ,vouchtype -- 主担保方式
            ,haveadditionalvouch -- 有无追加担保方式
            ,othervouchtype -- 其他担保方式
            ,additioncommand -- 其他条件和要求
            ,repaytype -- 还款方式码值为：repaytype
            ,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
            ,repaydate -- 指定还款日
            ,settlementaccount -- 结算账号
            ,paymenttype -- 支付方式
            ,creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
            ,nationalindustrytype -- 贷款投向行业
            ,intraindustrytype -- 行内行业投向
            ,purpose -- 用途
            ,reservesum -- 预留金额
            ,balance -- 合同贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期/垫款金额
            ,dullbalance -- 呆滞余额
            ,badbalance -- 呆账余额
            ,innerinterestbalance -- 表内欠息余额
            ,outerinterestbalance -- 表外欠息余额
            ,capitalpenaltybalance -- 逾期罚息余额
            ,interestpenaltybalance -- 复息余额
            ,overduedays -- 贷款逾期天数
            ,owninterestdays -- 欠息天数
            ,graceperiod -- 贷款宽限期
            ,cancelsum -- 核销本金
            ,cancelinterest -- 核销利息
            ,predictlostsum -- 预测损失金额
            ,reducereservesum -- 计提准备金额
            ,badconfirmdate -- 首次认定不良日期
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,status -- 合同状态
            ,finishdate -- 终结日期
            ,finishtype -- 终结类型
            ,finishflag -- 结清标志
            ,contracttype -- 合同类型合同类型(一般合同/虚拟合同)
            ,offsheetflag -- 表内外标志
            ,belongdept -- 所属条线BelongDept
            ,completeflag -- 数据录入完整性标识
            ,flowtype -- 流程类型
            ,approvestatus -- 审批状态
            ,clno -- 额度编号
            ,cleffectstatus -- 额度续作状态
            ,remark -- 备注
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,reinforceflag -- 补充标志
            ,corporgid -- 法人机构编号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,renewtermdate -- 展期前到期日
            ,renewtotalsum -- 展期前金额
            ,renewexecuteyearrate -- 展期前执行年利率
            ,isbankrel -- 是否我行关联方标志
            ,vouchtype3 -- 主要担保方式3
            ,vouchtype2 -- 主要担保方式2
            ,loanusetype -- 贷款用途
            ,totalsum -- 额度敞口金额
            ,outstndlmt -- 已占用额度
            ,bailratio -- 保证金比例（%）
            ,bailsum -- 保证金金额
            ,totalbalance -- 敞口余额(元)
            ,creditaggreement -- 额度协议流水号
            ,vouchtypeinner -- 担保方式（内部口径）
            ,executemonthrate -- 执行月利率
            ,classifyresulteleven -- 风险分类结果（11级）
            ,pigeonholedate -- 归档日期
            ,freezeflag -- 冻结标志
            ,rateadjustfrequency -- 利率调整周期
            ,overduerate -- 逾期执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountno -- 入账账户
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,bailcurrency -- 保证金币种
            ,bailaccount -- 保证金帐号
            ,bailtransaccount -- 保证金转出账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,manageuserid -- 贷后管理人员
            ,manageorgid -- 贷后管理机构
            ,ispagercontract -- 是否签署纸质合同
            ,isoccupycredit -- 是否占用他用额度
            ,occupycreditbapserialno -- 他用额度批复流水号
            ,occupycredittype -- 他用额度类型
            ,remart -- 计量标记
            ,creditauthno -- 征信授权影像流水号
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,authostrdate -- 授权起始日
            ,isonlinebusiness -- 是否线上业务：yes-是no/空-否
            ,oldstatus -- 备份生效标志
            ,oldcreditaggreement -- 使用授信协议号(备份额度合同流水号)
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,contractnobeforeextend -- 展期前合同
            ,pdgratio -- 手续费比率
            ,pdgsum -- 手续费金额
            ,templeteurl -- 同业模板页面路径
            ,templeteno -- 同业模板编号
            ,vouchflag -- 有无其他担保方式，HaveNot
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,strategicemergingindustrytype -- 战略性新兴产业类型
            ,transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
            ,effectdate -- 合同签订日期
            ,statisticstotalbalance -- 统计用敞口余额
            ,transformtimes -- 变更次数
            ,belongitem -- 所属项下
            ,useexposuretype -- 占用敞口类型(UseExposureType)
            ,isgxtechent -- 高新技术企业标志
            ,isscitechent -- 科技型企业
            ,iskctechent -- 科创企业
            ,isxxdquota -- 是否营销额度（新兴贷专用）
            ,ispensionindustry -- 养老产业标识
            ,ifseedloan -- 种业振兴贷款
            ,ifcountyloan -- 县城区贷款
            ,ifhighindustry -- 是否投向高技术产业
            ,numbereconomytype -- 投向数字经济核心产业类型
            ,riskapproveamout -- 风控审批可用金额
            ,icmsapproveamout -- 信贷审批可用金额
            ,ifcapproveamount -- 审批后额度合同金额（IFC专用）
            ,ifcapprovebalance -- 数总审批可用金额（IFC专用）
            ,issignedcontract -- 是否签订额度合同
            ,whethertorestructuretheloan -- 是否重组贷款
            ,bdserialno -- 借据号
            ,renewstartdate -- 展期起始日
            ,secondpayaccount -- 第二还款账号
            ,merchordernum -- 订单号
            ,applyno -- 房抵贷贷款申请编号
            ,pclnominalamount -- 华兴易贷担保可用金额
            ,pcloccupyamount -- 华兴易贷担保占用金额
            ,comticketrecourseflag -- 商票保贴追索标识（0-否，1-是）
            ,bizcontrwthrdisctpers -- 是否贴现人保证金账户（0-否，1-是）
            ,subproductname -- 子产品名称
            ,renewaltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_contract_op(
            serialno -- 合同编号
            ,bapserialno -- 批复编号
            ,relacontractno -- 关联合同编号
            ,artificialno -- 文本合同编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businessflag -- 额度/业务标志
            ,oldcontractno -- 关联的旧合同号
            ,applytype -- 申请类型
            ,occurtype -- 贷款发放类型
            ,occurdate -- 签订日期
            ,currency -- 额度/业务币种
            ,businesssum -- 合同金额
            ,putoutsum -- 实际放款金额
            ,putoutdate -- 放款日期
            ,baseproduct -- 基础产品(额度)基础产品
            ,productid -- 产品编号
            ,policyid -- 产品政策编号
            ,policyversionid -- 产品政策版本编号
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,iscycle -- 是否循环(额度)是否循环
            ,risktype -- 风险类型(额度)风险类型（一般、低风险）
            ,islowrisk -- 是否低风险业务
            ,isremotebusiness -- 是否异地业务
            ,ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
            ,fixedrate -- 固定利率
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,floatrange -- 浮动幅度
            ,executerate -- 执行利率
            ,vouchtype -- 主担保方式
            ,haveadditionalvouch -- 有无追加担保方式
            ,othervouchtype -- 其他担保方式
            ,additioncommand -- 其他条件和要求
            ,repaytype -- 还款方式码值为：repaytype
            ,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
            ,repaydate -- 指定还款日
            ,settlementaccount -- 结算账号
            ,paymenttype -- 支付方式
            ,creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
            ,nationalindustrytype -- 贷款投向行业
            ,intraindustrytype -- 行内行业投向
            ,purpose -- 用途
            ,reservesum -- 预留金额
            ,balance -- 合同贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期/垫款金额
            ,dullbalance -- 呆滞余额
            ,badbalance -- 呆账余额
            ,innerinterestbalance -- 表内欠息余额
            ,outerinterestbalance -- 表外欠息余额
            ,capitalpenaltybalance -- 逾期罚息余额
            ,interestpenaltybalance -- 复息余额
            ,overduedays -- 贷款逾期天数
            ,owninterestdays -- 欠息天数
            ,graceperiod -- 贷款宽限期
            ,cancelsum -- 核销本金
            ,cancelinterest -- 核销利息
            ,predictlostsum -- 预测损失金额
            ,reducereservesum -- 计提准备金额
            ,badconfirmdate -- 首次认定不良日期
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,status -- 合同状态
            ,finishdate -- 终结日期
            ,finishtype -- 终结类型
            ,finishflag -- 结清标志
            ,contracttype -- 合同类型合同类型(一般合同/虚拟合同)
            ,offsheetflag -- 表内外标志
            ,belongdept -- 所属条线BelongDept
            ,completeflag -- 数据录入完整性标识
            ,flowtype -- 流程类型
            ,approvestatus -- 审批状态
            ,clno -- 额度编号
            ,cleffectstatus -- 额度续作状态
            ,remark -- 备注
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,reinforceflag -- 补充标志
            ,corporgid -- 法人机构编号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,renewtermdate -- 展期前到期日
            ,renewtotalsum -- 展期前金额
            ,renewexecuteyearrate -- 展期前执行年利率
            ,isbankrel -- 是否我行关联方标志
            ,vouchtype3 -- 主要担保方式3
            ,vouchtype2 -- 主要担保方式2
            ,loanusetype -- 贷款用途
            ,totalsum -- 额度敞口金额
            ,outstndlmt -- 已占用额度
            ,bailratio -- 保证金比例（%）
            ,bailsum -- 保证金金额
            ,totalbalance -- 敞口余额(元)
            ,creditaggreement -- 额度协议流水号
            ,vouchtypeinner -- 担保方式（内部口径）
            ,executemonthrate -- 执行月利率
            ,classifyresulteleven -- 风险分类结果（11级）
            ,pigeonholedate -- 归档日期
            ,freezeflag -- 冻结标志
            ,rateadjustfrequency -- 利率调整周期
            ,overduerate -- 逾期执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountno -- 入账账户
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,bailcurrency -- 保证金币种
            ,bailaccount -- 保证金帐号
            ,bailtransaccount -- 保证金转出账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,manageuserid -- 贷后管理人员
            ,manageorgid -- 贷后管理机构
            ,ispagercontract -- 是否签署纸质合同
            ,isoccupycredit -- 是否占用他用额度
            ,occupycreditbapserialno -- 他用额度批复流水号
            ,occupycredittype -- 他用额度类型
            ,remart -- 计量标记
            ,creditauthno -- 征信授权影像流水号
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,authostrdate -- 授权起始日
            ,isonlinebusiness -- 是否线上业务：yes-是no/空-否
            ,oldstatus -- 备份生效标志
            ,oldcreditaggreement -- 使用授信协议号(备份额度合同流水号)
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,contractnobeforeextend -- 展期前合同
            ,pdgratio -- 手续费比率
            ,pdgsum -- 手续费金额
            ,templeteurl -- 同业模板页面路径
            ,templeteno -- 同业模板编号
            ,vouchflag -- 有无其他担保方式，HaveNot
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,strategicemergingindustrytype -- 战略性新兴产业类型
            ,transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
            ,effectdate -- 合同签订日期
            ,statisticstotalbalance -- 统计用敞口余额
            ,transformtimes -- 变更次数
            ,belongitem -- 所属项下
            ,useexposuretype -- 占用敞口类型(UseExposureType)
            ,isgxtechent -- 高新技术企业标志
            ,isscitechent -- 科技型企业
            ,iskctechent -- 科创企业
            ,isxxdquota -- 是否营销额度（新兴贷专用）
            ,ispensionindustry -- 养老产业标识
            ,ifseedloan -- 种业振兴贷款
            ,ifcountyloan -- 县城区贷款
            ,ifhighindustry -- 是否投向高技术产业
            ,numbereconomytype -- 投向数字经济核心产业类型
            ,riskapproveamout -- 风控审批可用金额
            ,icmsapproveamout -- 信贷审批可用金额
            ,ifcapproveamount -- 审批后额度合同金额（IFC专用）
            ,ifcapprovebalance -- 数总审批可用金额（IFC专用）
            ,issignedcontract -- 是否签订额度合同
            ,whethertorestructuretheloan -- 是否重组贷款
            ,bdserialno -- 借据号
            ,renewstartdate -- 展期起始日
            ,secondpayaccount -- 第二还款账号
            ,merchordernum -- 订单号
            ,applyno -- 房抵贷贷款申请编号
            ,pclnominalamount -- 华兴易贷担保可用金额
            ,pcloccupyamount -- 华兴易贷担保占用金额
            ,comticketrecourseflag -- 商票保贴追索标识（0-否，1-是）
            ,bizcontrwthrdisctpers -- 是否贴现人保证金账户（0-否，1-是）
            ,subproductname -- 子产品名称
            ,renewaltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 合同编号
    ,nvl(n.bapserialno, o.bapserialno) as bapserialno -- 批复编号
    ,nvl(n.relacontractno, o.relacontractno) as relacontractno -- 关联合同编号
    ,nvl(n.artificialno, o.artificialno) as artificialno -- 文本合同编号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.businessflag, o.businessflag) as businessflag -- 额度/业务标志
    ,nvl(n.oldcontractno, o.oldcontractno) as oldcontractno -- 关联的旧合同号
    ,nvl(n.applytype, o.applytype) as applytype -- 申请类型
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 贷款发放类型
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 签订日期
    ,nvl(n.currency, o.currency) as currency -- 额度/业务币种
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 合同金额
    ,nvl(n.putoutsum, o.putoutsum) as putoutsum -- 实际放款金额
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 放款日期
    ,nvl(n.baseproduct, o.baseproduct) as baseproduct -- 基础产品(额度)基础产品
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.policyid, o.policyid) as policyid -- 产品政策编号
    ,nvl(n.policyversionid, o.policyversionid) as policyversionid -- 产品政策版本编号
    ,nvl(n.productclassify, o.productclassify) as productclassify -- 产品所属大类
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限(月)
    ,nvl(n.termday, o.termday) as termday -- 期限(天)
    ,nvl(n.startdate, o.startdate) as startdate -- 合同开始日期
    ,nvl(n.maturity, o.maturity) as maturity -- 合同到期日期
    ,nvl(n.iscycle, o.iscycle) as iscycle -- 是否循环(额度)是否循环
    ,nvl(n.risktype, o.risktype) as risktype -- 风险类型(额度)风险类型（一般、低风险）
    ,nvl(n.islowrisk, o.islowrisk) as islowrisk -- 是否低风险业务
    ,nvl(n.isremotebusiness, o.isremotebusiness) as isremotebusiness -- 是否异地业务
    ,nvl(n.ratemodel, o.ratemodel) as ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
    ,nvl(n.fixedrate, o.fixedrate) as fixedrate -- 固定利率
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.ratefloattype, o.ratefloattype) as ratefloattype -- 利率浮动方式
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
    ,nvl(n.floatrange, o.floatrange) as floatrange -- 浮动幅度
    ,nvl(n.executerate, o.executerate) as executerate -- 执行利率
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主担保方式
    ,nvl(n.haveadditionalvouch, o.haveadditionalvouch) as haveadditionalvouch -- 有无追加担保方式
    ,nvl(n.othervouchtype, o.othervouchtype) as othervouchtype -- 其他担保方式
    ,nvl(n.additioncommand, o.additioncommand) as additioncommand -- 其他条件和要求
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式码值为：repaytype
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
    ,nvl(n.repaydate, o.repaydate) as repaydate -- 指定还款日
    ,nvl(n.settlementaccount, o.settlementaccount) as settlementaccount -- 结算账号
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式
    ,nvl(n.creditinvest, o.creditinvest) as creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
    ,nvl(n.nationalindustrytype, o.nationalindustrytype) as nationalindustrytype -- 贷款投向行业
    ,nvl(n.intraindustrytype, o.intraindustrytype) as intraindustrytype -- 行内行业投向
    ,nvl(n.purpose, o.purpose) as purpose -- 用途
    ,nvl(n.reservesum, o.reservesum) as reservesum -- 预留金额
    ,nvl(n.balance, o.balance) as balance -- 合同贷款余额
    ,nvl(n.normalbalance, o.normalbalance) as normalbalance -- 正常余额
    ,nvl(n.overduebalance, o.overduebalance) as overduebalance -- 逾期/垫款金额
    ,nvl(n.dullbalance, o.dullbalance) as dullbalance -- 呆滞余额
    ,nvl(n.badbalance, o.badbalance) as badbalance -- 呆账余额
    ,nvl(n.innerinterestbalance, o.innerinterestbalance) as innerinterestbalance -- 表内欠息余额
    ,nvl(n.outerinterestbalance, o.outerinterestbalance) as outerinterestbalance -- 表外欠息余额
    ,nvl(n.capitalpenaltybalance, o.capitalpenaltybalance) as capitalpenaltybalance -- 逾期罚息余额
    ,nvl(n.interestpenaltybalance, o.interestpenaltybalance) as interestpenaltybalance -- 复息余额
    ,nvl(n.overduedays, o.overduedays) as overduedays -- 贷款逾期天数
    ,nvl(n.owninterestdays, o.owninterestdays) as owninterestdays -- 欠息天数
    ,nvl(n.graceperiod, o.graceperiod) as graceperiod -- 贷款宽限期
    ,nvl(n.cancelsum, o.cancelsum) as cancelsum -- 核销本金
    ,nvl(n.cancelinterest, o.cancelinterest) as cancelinterest -- 核销利息
    ,nvl(n.predictlostsum, o.predictlostsum) as predictlostsum -- 预测损失金额
    ,nvl(n.reducereservesum, o.reducereservesum) as reducereservesum -- 计提准备金额
    ,nvl(n.badconfirmdate, o.badconfirmdate) as badconfirmdate -- 首次认定不良日期
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 贷款五级分类
    ,nvl(n.classifydate, o.classifydate) as classifydate -- 风险分类日期
    ,nvl(n.status, o.status) as status -- 合同状态
    ,nvl(n.finishdate, o.finishdate) as finishdate -- 终结日期
    ,nvl(n.finishtype, o.finishtype) as finishtype -- 终结类型
    ,nvl(n.finishflag, o.finishflag) as finishflag -- 结清标志
    ,nvl(n.contracttype, o.contracttype) as contracttype -- 合同类型合同类型(一般合同/虚拟合同)
    ,nvl(n.offsheetflag, o.offsheetflag) as offsheetflag -- 表内外标志
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 所属条线BelongDept
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 数据录入完整性标识
    ,nvl(n.flowtype, o.flowtype) as flowtype -- 流程类型
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.clno, o.clno) as clno -- 额度编号
    ,nvl(n.cleffectstatus, o.cleffectstatus) as cleffectstatus -- 额度续作状态
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 业务经办人编号
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 经办日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.reinforceflag, o.reinforceflag) as reinforceflag -- 补充标志
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.payfrequencyunit, o.payfrequencyunit) as payfrequencyunit -- 指定周期单位
    ,nvl(n.payfrequency, o.payfrequency) as payfrequency -- 指定周期
    ,nvl(n.renewtermdate, o.renewtermdate) as renewtermdate -- 展期前到期日
    ,nvl(n.renewtotalsum, o.renewtotalsum) as renewtotalsum -- 展期前金额
    ,nvl(n.renewexecuteyearrate, o.renewexecuteyearrate) as renewexecuteyearrate -- 展期前执行年利率
    ,nvl(n.isbankrel, o.isbankrel) as isbankrel -- 是否我行关联方标志
    ,nvl(n.vouchtype3, o.vouchtype3) as vouchtype3 -- 主要担保方式3
    ,nvl(n.vouchtype2, o.vouchtype2) as vouchtype2 -- 主要担保方式2
    ,nvl(n.loanusetype, o.loanusetype) as loanusetype -- 贷款用途
    ,nvl(n.totalsum, o.totalsum) as totalsum -- 额度敞口金额
    ,nvl(n.outstndlmt, o.outstndlmt) as outstndlmt -- 已占用额度
    ,nvl(n.bailratio, o.bailratio) as bailratio -- 保证金比例（%）
    ,nvl(n.bailsum, o.bailsum) as bailsum -- 保证金金额
    ,nvl(n.totalbalance, o.totalbalance) as totalbalance -- 敞口余额(元)
    ,nvl(n.creditaggreement, o.creditaggreement) as creditaggreement -- 额度协议流水号
    ,nvl(n.vouchtypeinner, o.vouchtypeinner) as vouchtypeinner -- 担保方式（内部口径）
    ,nvl(n.executemonthrate, o.executemonthrate) as executemonthrate -- 执行月利率
    ,nvl(n.classifyresulteleven, o.classifyresulteleven) as classifyresulteleven -- 风险分类结果（11级）
    ,nvl(n.pigeonholedate, o.pigeonholedate) as pigeonholedate -- 归档日期
    ,nvl(n.freezeflag, o.freezeflag) as freezeflag -- 冻结标志
    ,nvl(n.rateadjustfrequency, o.rateadjustfrequency) as rateadjustfrequency -- 利率调整周期
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期执行利率
    ,nvl(n.overdueratefloattype, o.overdueratefloattype) as overdueratefloattype -- 逾期利率浮动方式
    ,nvl(n.overdueratefloatvalue, o.overdueratefloatvalue) as overdueratefloatvalue -- 逾期利率浮动值
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 出账机构编号(核心机构)
    ,nvl(n.settlementaccountname, o.settlementaccountname) as settlementaccountname -- 结算账户(还款账户)名
    ,nvl(n.loanaccountno, o.loanaccountno) as loanaccountno -- 入账账户
    ,nvl(n.loanaccountname, o.loanaccountname) as loanaccountname -- 贷款入账(收款账户)账户名
    ,nvl(n.loanaccountorgid, o.loanaccountorgid) as loanaccountorgid -- 贷款入账(收款账户)账户开户机构
    ,nvl(n.bailcurrency, o.bailcurrency) as bailcurrency -- 保证金币种
    ,nvl(n.bailaccount, o.bailaccount) as bailaccount -- 保证金帐号
    ,nvl(n.bailtransaccount, o.bailtransaccount) as bailtransaccount -- 保证金转出账号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.manageuserid, o.manageuserid) as manageuserid -- 贷后管理人员
    ,nvl(n.manageorgid, o.manageorgid) as manageorgid -- 贷后管理机构
    ,nvl(n.ispagercontract, o.ispagercontract) as ispagercontract -- 是否签署纸质合同
    ,nvl(n.isoccupycredit, o.isoccupycredit) as isoccupycredit -- 是否占用他用额度
    ,nvl(n.occupycreditbapserialno, o.occupycreditbapserialno) as occupycreditbapserialno -- 他用额度批复流水号
    ,nvl(n.occupycredittype, o.occupycredittype) as occupycredittype -- 他用额度类型
    ,nvl(n.remart, o.remart) as remart -- 计量标记
    ,nvl(n.creditauthno, o.creditauthno) as creditauthno -- 征信授权影像流水号
    ,nvl(n.isquerycreditreport, o.isquerycreditreport) as isquerycreditreport -- 是否自动查询贷后报告
    ,nvl(n.authostrdate, o.authostrdate) as authostrdate -- 授权起始日
    ,nvl(n.isonlinebusiness, o.isonlinebusiness) as isonlinebusiness -- 是否线上业务：yes-是no/空-否
    ,nvl(n.oldstatus, o.oldstatus) as oldstatus -- 备份生效标志
    ,nvl(n.oldcreditaggreement, o.oldcreditaggreement) as oldcreditaggreement -- 使用授信协议号(备份额度合同流水号)
    ,nvl(n.migtcustomerid, o.migtcustomerid) as migtcustomerid -- 转换前客户号
    ,nvl(n.migtbusinesstype, o.migtbusinesstype) as migtbusinesstype -- 转换前产品ID
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 迁移数据-参数转换前字段值
    ,nvl(n.contractnobeforeextend, o.contractnobeforeextend) as contractnobeforeextend -- 展期前合同
    ,nvl(n.pdgratio, o.pdgratio) as pdgratio -- 手续费比率
    ,nvl(n.pdgsum, o.pdgsum) as pdgsum -- 手续费金额
    ,nvl(n.templeteurl, o.templeteurl) as templeteurl -- 同业模板页面路径
    ,nvl(n.templeteno, o.templeteno) as templeteno -- 同业模板编号
    ,nvl(n.vouchflag, o.vouchflag) as vouchflag -- 有无其他担保方式，HaveNot
    ,nvl(n.ratefloatratioorbp, o.ratefloatratioorbp) as ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
    ,nvl(n.advancedmanuflag, o.advancedmanuflag) as advancedmanuflag -- 先进制造业标志（0-否，1-是）
    ,nvl(n.cultureindustryflag, o.cultureindustryflag) as cultureindustryflag -- 文化产业标志（0-否，1-是）
    ,nvl(n.onlynewentflag, o.onlynewentflag) as onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
    ,nvl(n.onlynewsmallentflag, o.onlynewsmallentflag) as onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
    ,nvl(n.strategicemergingindustrytype, o.strategicemergingindustrytype) as strategicemergingindustrytype -- 战略性新兴产业类型
    ,nvl(n.transformationandupgradeid, o.transformationandupgradeid) as transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
    ,nvl(n.effectdate, o.effectdate) as effectdate -- 合同签订日期
    ,nvl(n.statisticstotalbalance, o.statisticstotalbalance) as statisticstotalbalance -- 统计用敞口余额
    ,nvl(n.transformtimes, o.transformtimes) as transformtimes -- 变更次数
    ,nvl(n.belongitem, o.belongitem) as belongitem -- 所属项下
    ,nvl(n.useexposuretype, o.useexposuretype) as useexposuretype -- 占用敞口类型(UseExposureType)
    ,nvl(n.isgxtechent, o.isgxtechent) as isgxtechent -- 高新技术企业标志
    ,nvl(n.isscitechent, o.isscitechent) as isscitechent -- 科技型企业
    ,nvl(n.iskctechent, o.iskctechent) as iskctechent -- 科创企业
    ,nvl(n.isxxdquota, o.isxxdquota) as isxxdquota -- 是否营销额度（新兴贷专用）
    ,nvl(n.ispensionindustry, o.ispensionindustry) as ispensionindustry -- 养老产业标识
    ,nvl(n.ifseedloan, o.ifseedloan) as ifseedloan -- 种业振兴贷款
    ,nvl(n.ifcountyloan, o.ifcountyloan) as ifcountyloan -- 县城区贷款
    ,nvl(n.ifhighindustry, o.ifhighindustry) as ifhighindustry -- 是否投向高技术产业
    ,nvl(n.numbereconomytype, o.numbereconomytype) as numbereconomytype -- 投向数字经济核心产业类型
    ,nvl(n.riskapproveamout, o.riskapproveamout) as riskapproveamout -- 风控审批可用金额
    ,nvl(n.icmsapproveamout, o.icmsapproveamout) as icmsapproveamout -- 信贷审批可用金额
    ,nvl(n.ifcapproveamount, o.ifcapproveamount) as ifcapproveamount -- 审批后额度合同金额（IFC专用）
    ,nvl(n.ifcapprovebalance, o.ifcapprovebalance) as ifcapprovebalance -- 数总审批可用金额（IFC专用）
    ,nvl(n.issignedcontract, o.issignedcontract) as issignedcontract -- 是否签订额度合同
    ,nvl(n.whethertorestructuretheloan, o.whethertorestructuretheloan) as whethertorestructuretheloan -- 是否重组贷款
    ,nvl(n.bdserialno, o.bdserialno) as bdserialno -- 借据号
    ,nvl(n.renewstartdate, o.renewstartdate) as renewstartdate -- 展期起始日
    ,nvl(n.secondpayaccount, o.secondpayaccount) as secondpayaccount -- 第二还款账号
    ,nvl(n.merchordernum, o.merchordernum) as merchordernum -- 订单号
    ,nvl(n.applyno, o.applyno) as applyno -- 房抵贷贷款申请编号
    ,nvl(n.pclnominalamount, o.pclnominalamount) as pclnominalamount -- 华兴易贷担保可用金额
    ,nvl(n.pcloccupyamount, o.pcloccupyamount) as pcloccupyamount -- 华兴易贷担保占用金额
    ,nvl(n.comticketrecourseflag, o.comticketrecourseflag) as comticketrecourseflag -- 商票保贴追索标识（0-否，1-是）
    ,nvl(n.bizcontrwthrdisctpers, o.bizcontrwthrdisctpers) as bizcontrwthrdisctpers -- 是否贴现人保证金账户（0-否，1-是）
    ,nvl(n.subproductname, o.subproductname) as subproductname -- 子产品名称
    ,nvl(n.renewaltype, o.renewaltype) as renewaltype -- 
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
from (select * from ${iol_schema}.icms_business_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_business_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.bapserialno <> n.bapserialno
        or o.relacontractno <> n.relacontractno
        or o.artificialno <> n.artificialno
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.businessflag <> n.businessflag
        or o.oldcontractno <> n.oldcontractno
        or o.applytype <> n.applytype
        or o.occurtype <> n.occurtype
        or o.occurdate <> n.occurdate
        or o.currency <> n.currency
        or o.businesssum <> n.businesssum
        or o.putoutsum <> n.putoutsum
        or o.putoutdate <> n.putoutdate
        or o.baseproduct <> n.baseproduct
        or o.productid <> n.productid
        or o.policyid <> n.policyid
        or o.policyversionid <> n.policyversionid
        or o.productclassify <> n.productclassify
        or o.termmonth <> n.termmonth
        or o.termday <> n.termday
        or o.startdate <> n.startdate
        or o.maturity <> n.maturity
        or o.iscycle <> n.iscycle
        or o.risktype <> n.risktype
        or o.islowrisk <> n.islowrisk
        or o.isremotebusiness <> n.isremotebusiness
        or o.ratemodel <> n.ratemodel
        or o.fixedrate <> n.fixedrate
        or o.baseratetype <> n.baseratetype
        or o.baserate <> n.baserate
        or o.ratefloattype <> n.ratefloattype
        or o.rateadjusttype <> n.rateadjusttype
        or o.floatrange <> n.floatrange
        or o.executerate <> n.executerate
        or o.vouchtype <> n.vouchtype
        or o.haveadditionalvouch <> n.haveadditionalvouch
        or o.othervouchtype <> n.othervouchtype
        or o.additioncommand <> n.additioncommand
        or o.repaytype <> n.repaytype
        or o.repaycycle <> n.repaycycle
        or o.repaydate <> n.repaydate
        or o.settlementaccount <> n.settlementaccount
        or o.paymenttype <> n.paymenttype
        or o.creditinvest <> n.creditinvest
        or o.nationalindustrytype <> n.nationalindustrytype
        or o.intraindustrytype <> n.intraindustrytype
        or o.purpose <> n.purpose
        or o.reservesum <> n.reservesum
        or o.balance <> n.balance
        or o.normalbalance <> n.normalbalance
        or o.overduebalance <> n.overduebalance
        or o.dullbalance <> n.dullbalance
        or o.badbalance <> n.badbalance
        or o.innerinterestbalance <> n.innerinterestbalance
        or o.outerinterestbalance <> n.outerinterestbalance
        or o.capitalpenaltybalance <> n.capitalpenaltybalance
        or o.interestpenaltybalance <> n.interestpenaltybalance
        or o.overduedays <> n.overduedays
        or o.owninterestdays <> n.owninterestdays
        or o.graceperiod <> n.graceperiod
        or o.cancelsum <> n.cancelsum
        or o.cancelinterest <> n.cancelinterest
        or o.predictlostsum <> n.predictlostsum
        or o.reducereservesum <> n.reducereservesum
        or o.badconfirmdate <> n.badconfirmdate
        or o.classifyresult <> n.classifyresult
        or o.classifydate <> n.classifydate
        or o.status <> n.status
        or o.finishdate <> n.finishdate
        or o.finishtype <> n.finishtype
        or o.finishflag <> n.finishflag
        or o.contracttype <> n.contracttype
        or o.offsheetflag <> n.offsheetflag
        or o.belongdept <> n.belongdept
        or o.completeflag <> n.completeflag
        or o.flowtype <> n.flowtype
        or o.approvestatus <> n.approvestatus
        or o.clno <> n.clno
        or o.cleffectstatus <> n.cleffectstatus
        or o.remark <> n.remark
        or o.operateuserid <> n.operateuserid
        or o.operateorgid <> n.operateorgid
        or o.operatedate <> n.operatedate
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.reinforceflag <> n.reinforceflag
        or o.corporgid <> n.corporgid
        or o.payfrequencyunit <> n.payfrequencyunit
        or o.payfrequency <> n.payfrequency
        or o.renewtermdate <> n.renewtermdate
        or o.renewtotalsum <> n.renewtotalsum
        or o.renewexecuteyearrate <> n.renewexecuteyearrate
        or o.isbankrel <> n.isbankrel
        or o.vouchtype3 <> n.vouchtype3
        or o.vouchtype2 <> n.vouchtype2
        or o.loanusetype <> n.loanusetype
        or o.totalsum <> n.totalsum
        or o.outstndlmt <> n.outstndlmt
        or o.bailratio <> n.bailratio
        or o.bailsum <> n.bailsum
        or o.totalbalance <> n.totalbalance
        or o.creditaggreement <> n.creditaggreement
        or o.vouchtypeinner <> n.vouchtypeinner
        or o.executemonthrate <> n.executemonthrate
        or o.classifyresulteleven <> n.classifyresulteleven
        or o.pigeonholedate <> n.pigeonholedate
        or o.freezeflag <> n.freezeflag
        or o.rateadjustfrequency <> n.rateadjustfrequency
        or o.overduerate <> n.overduerate
        or o.overdueratefloattype <> n.overdueratefloattype
        or o.overdueratefloatvalue <> n.overdueratefloatvalue
        or o.putoutorgid <> n.putoutorgid
        or o.settlementaccountname <> n.settlementaccountname
        or o.loanaccountno <> n.loanaccountno
        or o.loanaccountname <> n.loanaccountname
        or o.loanaccountorgid <> n.loanaccountorgid
        or o.bailcurrency <> n.bailcurrency
        or o.bailaccount <> n.bailaccount
        or o.bailtransaccount <> n.bailtransaccount
        or o.migtflag <> n.migtflag
        or o.manageuserid <> n.manageuserid
        or o.manageorgid <> n.manageorgid
        or o.ispagercontract <> n.ispagercontract
        or o.isoccupycredit <> n.isoccupycredit
        or o.occupycreditbapserialno <> n.occupycreditbapserialno
        or o.occupycredittype <> n.occupycredittype
        or o.remart <> n.remart
        or o.creditauthno <> n.creditauthno
        or o.isquerycreditreport <> n.isquerycreditreport
        or o.authostrdate <> n.authostrdate
        or o.isonlinebusiness <> n.isonlinebusiness
        or o.oldstatus <> n.oldstatus
        or o.oldcreditaggreement <> n.oldcreditaggreement
        or o.migtcustomerid <> n.migtcustomerid
        or o.migtbusinesstype <> n.migtbusinesstype
        or o.migtoldvalue <> n.migtoldvalue
        or o.contractnobeforeextend <> n.contractnobeforeextend
        or o.pdgratio <> n.pdgratio
        or o.pdgsum <> n.pdgsum
        or o.templeteurl <> n.templeteurl
        or o.templeteno <> n.templeteno
        or o.vouchflag <> n.vouchflag
        or o.ratefloatratioorbp <> n.ratefloatratioorbp
        or o.advancedmanuflag <> n.advancedmanuflag
        or o.cultureindustryflag <> n.cultureindustryflag
        or o.onlynewentflag <> n.onlynewentflag
        or o.onlynewsmallentflag <> n.onlynewsmallentflag
        or o.strategicemergingindustrytype <> n.strategicemergingindustrytype
        or o.transformationandupgradeid <> n.transformationandupgradeid
        or o.effectdate <> n.effectdate
        or o.statisticstotalbalance <> n.statisticstotalbalance
        or o.transformtimes <> n.transformtimes
        or o.belongitem <> n.belongitem
        or o.useexposuretype <> n.useexposuretype
        or o.isgxtechent <> n.isgxtechent
        or o.isscitechent <> n.isscitechent
        or o.iskctechent <> n.iskctechent
        or o.isxxdquota <> n.isxxdquota
        or o.ispensionindustry <> n.ispensionindustry
        or o.ifseedloan <> n.ifseedloan
        or o.ifcountyloan <> n.ifcountyloan
        or o.ifhighindustry <> n.ifhighindustry
        or o.numbereconomytype <> n.numbereconomytype
        or o.riskapproveamout <> n.riskapproveamout
        or o.icmsapproveamout <> n.icmsapproveamout
        or o.ifcapproveamount <> n.ifcapproveamount
        or o.ifcapprovebalance <> n.ifcapprovebalance
        or o.issignedcontract <> n.issignedcontract
        or o.whethertorestructuretheloan <> n.whethertorestructuretheloan
        or o.bdserialno <> n.bdserialno
        or o.renewstartdate <> n.renewstartdate
        or o.secondpayaccount <> n.secondpayaccount
        or o.merchordernum <> n.merchordernum
        or o.applyno <> n.applyno
        or o.pclnominalamount <> n.pclnominalamount
        or o.pcloccupyamount <> n.pcloccupyamount
        or o.comticketrecourseflag <> n.comticketrecourseflag
        or o.bizcontrwthrdisctpers <> n.bizcontrwthrdisctpers
        or o.subproductname <> n.subproductname
        or o.renewaltype <> n.renewaltype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_contract_cl(
            serialno -- 合同编号
            ,bapserialno -- 批复编号
            ,relacontractno -- 关联合同编号
            ,artificialno -- 文本合同编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businessflag -- 额度/业务标志
            ,oldcontractno -- 关联的旧合同号
            ,applytype -- 申请类型
            ,occurtype -- 贷款发放类型
            ,occurdate -- 签订日期
            ,currency -- 额度/业务币种
            ,businesssum -- 合同金额
            ,putoutsum -- 实际放款金额
            ,putoutdate -- 放款日期
            ,baseproduct -- 基础产品(额度)基础产品
            ,productid -- 产品编号
            ,policyid -- 产品政策编号
            ,policyversionid -- 产品政策版本编号
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,iscycle -- 是否循环(额度)是否循环
            ,risktype -- 风险类型(额度)风险类型（一般、低风险）
            ,islowrisk -- 是否低风险业务
            ,isremotebusiness -- 是否异地业务
            ,ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
            ,fixedrate -- 固定利率
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,floatrange -- 浮动幅度
            ,executerate -- 执行利率
            ,vouchtype -- 主担保方式
            ,haveadditionalvouch -- 有无追加担保方式
            ,othervouchtype -- 其他担保方式
            ,additioncommand -- 其他条件和要求
            ,repaytype -- 还款方式码值为：repaytype
            ,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
            ,repaydate -- 指定还款日
            ,settlementaccount -- 结算账号
            ,paymenttype -- 支付方式
            ,creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
            ,nationalindustrytype -- 贷款投向行业
            ,intraindustrytype -- 行内行业投向
            ,purpose -- 用途
            ,reservesum -- 预留金额
            ,balance -- 合同贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期/垫款金额
            ,dullbalance -- 呆滞余额
            ,badbalance -- 呆账余额
            ,innerinterestbalance -- 表内欠息余额
            ,outerinterestbalance -- 表外欠息余额
            ,capitalpenaltybalance -- 逾期罚息余额
            ,interestpenaltybalance -- 复息余额
            ,overduedays -- 贷款逾期天数
            ,owninterestdays -- 欠息天数
            ,graceperiod -- 贷款宽限期
            ,cancelsum -- 核销本金
            ,cancelinterest -- 核销利息
            ,predictlostsum -- 预测损失金额
            ,reducereservesum -- 计提准备金额
            ,badconfirmdate -- 首次认定不良日期
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,status -- 合同状态
            ,finishdate -- 终结日期
            ,finishtype -- 终结类型
            ,finishflag -- 结清标志
            ,contracttype -- 合同类型合同类型(一般合同/虚拟合同)
            ,offsheetflag -- 表内外标志
            ,belongdept -- 所属条线BelongDept
            ,completeflag -- 数据录入完整性标识
            ,flowtype -- 流程类型
            ,approvestatus -- 审批状态
            ,clno -- 额度编号
            ,cleffectstatus -- 额度续作状态
            ,remark -- 备注
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,reinforceflag -- 补充标志
            ,corporgid -- 法人机构编号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,renewtermdate -- 展期前到期日
            ,renewtotalsum -- 展期前金额
            ,renewexecuteyearrate -- 展期前执行年利率
            ,isbankrel -- 是否我行关联方标志
            ,vouchtype3 -- 主要担保方式3
            ,vouchtype2 -- 主要担保方式2
            ,loanusetype -- 贷款用途
            ,totalsum -- 额度敞口金额
            ,outstndlmt -- 已占用额度
            ,bailratio -- 保证金比例（%）
            ,bailsum -- 保证金金额
            ,totalbalance -- 敞口余额(元)
            ,creditaggreement -- 额度协议流水号
            ,vouchtypeinner -- 担保方式（内部口径）
            ,executemonthrate -- 执行月利率
            ,classifyresulteleven -- 风险分类结果（11级）
            ,pigeonholedate -- 归档日期
            ,freezeflag -- 冻结标志
            ,rateadjustfrequency -- 利率调整周期
            ,overduerate -- 逾期执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountno -- 入账账户
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,bailcurrency -- 保证金币种
            ,bailaccount -- 保证金帐号
            ,bailtransaccount -- 保证金转出账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,manageuserid -- 贷后管理人员
            ,manageorgid -- 贷后管理机构
            ,ispagercontract -- 是否签署纸质合同
            ,isoccupycredit -- 是否占用他用额度
            ,occupycreditbapserialno -- 他用额度批复流水号
            ,occupycredittype -- 他用额度类型
            ,remart -- 计量标记
            ,creditauthno -- 征信授权影像流水号
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,authostrdate -- 授权起始日
            ,isonlinebusiness -- 是否线上业务：yes-是no/空-否
            ,oldstatus -- 备份生效标志
            ,oldcreditaggreement -- 使用授信协议号(备份额度合同流水号)
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,contractnobeforeextend -- 展期前合同
            ,pdgratio -- 手续费比率
            ,pdgsum -- 手续费金额
            ,templeteurl -- 同业模板页面路径
            ,templeteno -- 同业模板编号
            ,vouchflag -- 有无其他担保方式，HaveNot
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,strategicemergingindustrytype -- 战略性新兴产业类型
            ,transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
            ,effectdate -- 合同签订日期
            ,statisticstotalbalance -- 统计用敞口余额
            ,transformtimes -- 变更次数
            ,belongitem -- 所属项下
            ,useexposuretype -- 占用敞口类型(UseExposureType)
            ,isgxtechent -- 高新技术企业标志
            ,isscitechent -- 科技型企业
            ,iskctechent -- 科创企业
            ,isxxdquota -- 是否营销额度（新兴贷专用）
            ,ispensionindustry -- 养老产业标识
            ,ifseedloan -- 种业振兴贷款
            ,ifcountyloan -- 县城区贷款
            ,ifhighindustry -- 是否投向高技术产业
            ,numbereconomytype -- 投向数字经济核心产业类型
            ,riskapproveamout -- 风控审批可用金额
            ,icmsapproveamout -- 信贷审批可用金额
            ,ifcapproveamount -- 审批后额度合同金额（IFC专用）
            ,ifcapprovebalance -- 数总审批可用金额（IFC专用）
            ,issignedcontract -- 是否签订额度合同
            ,whethertorestructuretheloan -- 是否重组贷款
            ,bdserialno -- 借据号
            ,renewstartdate -- 展期起始日
            ,secondpayaccount -- 第二还款账号
            ,merchordernum -- 订单号
            ,applyno -- 房抵贷贷款申请编号
            ,pclnominalamount -- 华兴易贷担保可用金额
            ,pcloccupyamount -- 华兴易贷担保占用金额
            ,comticketrecourseflag -- 商票保贴追索标识（0-否，1-是）
            ,bizcontrwthrdisctpers -- 是否贴现人保证金账户（0-否，1-是）
            ,subproductname -- 子产品名称
            ,renewaltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_contract_op(
            serialno -- 合同编号
            ,bapserialno -- 批复编号
            ,relacontractno -- 关联合同编号
            ,artificialno -- 文本合同编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businessflag -- 额度/业务标志
            ,oldcontractno -- 关联的旧合同号
            ,applytype -- 申请类型
            ,occurtype -- 贷款发放类型
            ,occurdate -- 签订日期
            ,currency -- 额度/业务币种
            ,businesssum -- 合同金额
            ,putoutsum -- 实际放款金额
            ,putoutdate -- 放款日期
            ,baseproduct -- 基础产品(额度)基础产品
            ,productid -- 产品编号
            ,policyid -- 产品政策编号
            ,policyversionid -- 产品政策版本编号
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,iscycle -- 是否循环(额度)是否循环
            ,risktype -- 风险类型(额度)风险类型（一般、低风险）
            ,islowrisk -- 是否低风险业务
            ,isremotebusiness -- 是否异地业务
            ,ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
            ,fixedrate -- 固定利率
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,floatrange -- 浮动幅度
            ,executerate -- 执行利率
            ,vouchtype -- 主担保方式
            ,haveadditionalvouch -- 有无追加担保方式
            ,othervouchtype -- 其他担保方式
            ,additioncommand -- 其他条件和要求
            ,repaytype -- 还款方式码值为：repaytype
            ,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
            ,repaydate -- 指定还款日
            ,settlementaccount -- 结算账号
            ,paymenttype -- 支付方式
            ,creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
            ,nationalindustrytype -- 贷款投向行业
            ,intraindustrytype -- 行内行业投向
            ,purpose -- 用途
            ,reservesum -- 预留金额
            ,balance -- 合同贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期/垫款金额
            ,dullbalance -- 呆滞余额
            ,badbalance -- 呆账余额
            ,innerinterestbalance -- 表内欠息余额
            ,outerinterestbalance -- 表外欠息余额
            ,capitalpenaltybalance -- 逾期罚息余额
            ,interestpenaltybalance -- 复息余额
            ,overduedays -- 贷款逾期天数
            ,owninterestdays -- 欠息天数
            ,graceperiod -- 贷款宽限期
            ,cancelsum -- 核销本金
            ,cancelinterest -- 核销利息
            ,predictlostsum -- 预测损失金额
            ,reducereservesum -- 计提准备金额
            ,badconfirmdate -- 首次认定不良日期
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,status -- 合同状态
            ,finishdate -- 终结日期
            ,finishtype -- 终结类型
            ,finishflag -- 结清标志
            ,contracttype -- 合同类型合同类型(一般合同/虚拟合同)
            ,offsheetflag -- 表内外标志
            ,belongdept -- 所属条线BelongDept
            ,completeflag -- 数据录入完整性标识
            ,flowtype -- 流程类型
            ,approvestatus -- 审批状态
            ,clno -- 额度编号
            ,cleffectstatus -- 额度续作状态
            ,remark -- 备注
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,reinforceflag -- 补充标志
            ,corporgid -- 法人机构编号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,renewtermdate -- 展期前到期日
            ,renewtotalsum -- 展期前金额
            ,renewexecuteyearrate -- 展期前执行年利率
            ,isbankrel -- 是否我行关联方标志
            ,vouchtype3 -- 主要担保方式3
            ,vouchtype2 -- 主要担保方式2
            ,loanusetype -- 贷款用途
            ,totalsum -- 额度敞口金额
            ,outstndlmt -- 已占用额度
            ,bailratio -- 保证金比例（%）
            ,bailsum -- 保证金金额
            ,totalbalance -- 敞口余额(元)
            ,creditaggreement -- 额度协议流水号
            ,vouchtypeinner -- 担保方式（内部口径）
            ,executemonthrate -- 执行月利率
            ,classifyresulteleven -- 风险分类结果（11级）
            ,pigeonholedate -- 归档日期
            ,freezeflag -- 冻结标志
            ,rateadjustfrequency -- 利率调整周期
            ,overduerate -- 逾期执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountno -- 入账账户
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,bailcurrency -- 保证金币种
            ,bailaccount -- 保证金帐号
            ,bailtransaccount -- 保证金转出账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,manageuserid -- 贷后管理人员
            ,manageorgid -- 贷后管理机构
            ,ispagercontract -- 是否签署纸质合同
            ,isoccupycredit -- 是否占用他用额度
            ,occupycreditbapserialno -- 他用额度批复流水号
            ,occupycredittype -- 他用额度类型
            ,remart -- 计量标记
            ,creditauthno -- 征信授权影像流水号
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,authostrdate -- 授权起始日
            ,isonlinebusiness -- 是否线上业务：yes-是no/空-否
            ,oldstatus -- 备份生效标志
            ,oldcreditaggreement -- 使用授信协议号(备份额度合同流水号)
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,contractnobeforeextend -- 展期前合同
            ,pdgratio -- 手续费比率
            ,pdgsum -- 手续费金额
            ,templeteurl -- 同业模板页面路径
            ,templeteno -- 同业模板编号
            ,vouchflag -- 有无其他担保方式，HaveNot
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,strategicemergingindustrytype -- 战略性新兴产业类型
            ,transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
            ,effectdate -- 合同签订日期
            ,statisticstotalbalance -- 统计用敞口余额
            ,transformtimes -- 变更次数
            ,belongitem -- 所属项下
            ,useexposuretype -- 占用敞口类型(UseExposureType)
            ,isgxtechent -- 高新技术企业标志
            ,isscitechent -- 科技型企业
            ,iskctechent -- 科创企业
            ,isxxdquota -- 是否营销额度（新兴贷专用）
            ,ispensionindustry -- 养老产业标识
            ,ifseedloan -- 种业振兴贷款
            ,ifcountyloan -- 县城区贷款
            ,ifhighindustry -- 是否投向高技术产业
            ,numbereconomytype -- 投向数字经济核心产业类型
            ,riskapproveamout -- 风控审批可用金额
            ,icmsapproveamout -- 信贷审批可用金额
            ,ifcapproveamount -- 审批后额度合同金额（IFC专用）
            ,ifcapprovebalance -- 数总审批可用金额（IFC专用）
            ,issignedcontract -- 是否签订额度合同
            ,whethertorestructuretheloan -- 是否重组贷款
            ,bdserialno -- 借据号
            ,renewstartdate -- 展期起始日
            ,secondpayaccount -- 第二还款账号
            ,merchordernum -- 订单号
            ,applyno -- 房抵贷贷款申请编号
            ,pclnominalamount -- 华兴易贷担保可用金额
            ,pcloccupyamount -- 华兴易贷担保占用金额
            ,comticketrecourseflag -- 商票保贴追索标识（0-否，1-是）
            ,bizcontrwthrdisctpers -- 是否贴现人保证金账户（0-否，1-是）
            ,subproductname -- 子产品名称
            ,renewaltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 合同编号
    ,o.bapserialno -- 批复编号
    ,o.relacontractno -- 关联合同编号
    ,o.artificialno -- 文本合同编号
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.businessflag -- 额度/业务标志
    ,o.oldcontractno -- 关联的旧合同号
    ,o.applytype -- 申请类型
    ,o.occurtype -- 贷款发放类型
    ,o.occurdate -- 签订日期
    ,o.currency -- 额度/业务币种
    ,o.businesssum -- 合同金额
    ,o.putoutsum -- 实际放款金额
    ,o.putoutdate -- 放款日期
    ,o.baseproduct -- 基础产品(额度)基础产品
    ,o.productid -- 产品编号
    ,o.policyid -- 产品政策编号
    ,o.policyversionid -- 产品政策版本编号
    ,o.productclassify -- 产品所属大类
    ,o.termmonth -- 期限(月)
    ,o.termday -- 期限(天)
    ,o.startdate -- 合同开始日期
    ,o.maturity -- 合同到期日期
    ,o.iscycle -- 是否循环(额度)是否循环
    ,o.risktype -- 风险类型(额度)风险类型（一般、低风险）
    ,o.islowrisk -- 是否低风险业务
    ,o.isremotebusiness -- 是否异地业务
    ,o.ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
    ,o.fixedrate -- 固定利率
    ,o.baseratetype -- 基准利率类型
    ,o.baserate -- 基准利率
    ,o.ratefloattype -- 利率浮动方式
    ,o.rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
    ,o.floatrange -- 浮动幅度
    ,o.executerate -- 执行利率
    ,o.vouchtype -- 主担保方式
    ,o.haveadditionalvouch -- 有无追加担保方式
    ,o.othervouchtype -- 其他担保方式
    ,o.additioncommand -- 其他条件和要求
    ,o.repaytype -- 还款方式码值为：repaytype
    ,o.repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
    ,o.repaydate -- 指定还款日
    ,o.settlementaccount -- 结算账号
    ,o.paymenttype -- 支付方式
    ,o.creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
    ,o.nationalindustrytype -- 贷款投向行业
    ,o.intraindustrytype -- 行内行业投向
    ,o.purpose -- 用途
    ,o.reservesum -- 预留金额
    ,o.balance -- 合同贷款余额
    ,o.normalbalance -- 正常余额
    ,o.overduebalance -- 逾期/垫款金额
    ,o.dullbalance -- 呆滞余额
    ,o.badbalance -- 呆账余额
    ,o.innerinterestbalance -- 表内欠息余额
    ,o.outerinterestbalance -- 表外欠息余额
    ,o.capitalpenaltybalance -- 逾期罚息余额
    ,o.interestpenaltybalance -- 复息余额
    ,o.overduedays -- 贷款逾期天数
    ,o.owninterestdays -- 欠息天数
    ,o.graceperiod -- 贷款宽限期
    ,o.cancelsum -- 核销本金
    ,o.cancelinterest -- 核销利息
    ,o.predictlostsum -- 预测损失金额
    ,o.reducereservesum -- 计提准备金额
    ,o.badconfirmdate -- 首次认定不良日期
    ,o.classifyresult -- 贷款五级分类
    ,o.classifydate -- 风险分类日期
    ,o.status -- 合同状态
    ,o.finishdate -- 终结日期
    ,o.finishtype -- 终结类型
    ,o.finishflag -- 结清标志
    ,o.contracttype -- 合同类型合同类型(一般合同/虚拟合同)
    ,o.offsheetflag -- 表内外标志
    ,o.belongdept -- 所属条线BelongDept
    ,o.completeflag -- 数据录入完整性标识
    ,o.flowtype -- 流程类型
    ,o.approvestatus -- 审批状态
    ,o.clno -- 额度编号
    ,o.cleffectstatus -- 额度续作状态
    ,o.remark -- 备注
    ,o.operateuserid -- 业务经办人编号
    ,o.operateorgid -- 经办机构
    ,o.operatedate -- 经办日期
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.reinforceflag -- 补充标志
    ,o.corporgid -- 法人机构编号
    ,o.payfrequencyunit -- 指定周期单位
    ,o.payfrequency -- 指定周期
    ,o.renewtermdate -- 展期前到期日
    ,o.renewtotalsum -- 展期前金额
    ,o.renewexecuteyearrate -- 展期前执行年利率
    ,o.isbankrel -- 是否我行关联方标志
    ,o.vouchtype3 -- 主要担保方式3
    ,o.vouchtype2 -- 主要担保方式2
    ,o.loanusetype -- 贷款用途
    ,o.totalsum -- 额度敞口金额
    ,o.outstndlmt -- 已占用额度
    ,o.bailratio -- 保证金比例（%）
    ,o.bailsum -- 保证金金额
    ,o.totalbalance -- 敞口余额(元)
    ,o.creditaggreement -- 额度协议流水号
    ,o.vouchtypeinner -- 担保方式（内部口径）
    ,o.executemonthrate -- 执行月利率
    ,o.classifyresulteleven -- 风险分类结果（11级）
    ,o.pigeonholedate -- 归档日期
    ,o.freezeflag -- 冻结标志
    ,o.rateadjustfrequency -- 利率调整周期
    ,o.overduerate -- 逾期执行利率
    ,o.overdueratefloattype -- 逾期利率浮动方式
    ,o.overdueratefloatvalue -- 逾期利率浮动值
    ,o.putoutorgid -- 出账机构编号(核心机构)
    ,o.settlementaccountname -- 结算账户(还款账户)名
    ,o.loanaccountno -- 入账账户
    ,o.loanaccountname -- 贷款入账(收款账户)账户名
    ,o.loanaccountorgid -- 贷款入账(收款账户)账户开户机构
    ,o.bailcurrency -- 保证金币种
    ,o.bailaccount -- 保证金帐号
    ,o.bailtransaccount -- 保证金转出账号
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.manageuserid -- 贷后管理人员
    ,o.manageorgid -- 贷后管理机构
    ,o.ispagercontract -- 是否签署纸质合同
    ,o.isoccupycredit -- 是否占用他用额度
    ,o.occupycreditbapserialno -- 他用额度批复流水号
    ,o.occupycredittype -- 他用额度类型
    ,o.remart -- 计量标记
    ,o.creditauthno -- 征信授权影像流水号
    ,o.isquerycreditreport -- 是否自动查询贷后报告
    ,o.authostrdate -- 授权起始日
    ,o.isonlinebusiness -- 是否线上业务：yes-是no/空-否
    ,o.oldstatus -- 备份生效标志
    ,o.oldcreditaggreement -- 使用授信协议号(备份额度合同流水号)
    ,o.migtcustomerid -- 转换前客户号
    ,o.migtbusinesstype -- 转换前产品ID
    ,o.migtoldvalue -- 迁移数据-参数转换前字段值
    ,o.contractnobeforeextend -- 展期前合同
    ,o.pdgratio -- 手续费比率
    ,o.pdgsum -- 手续费金额
    ,o.templeteurl -- 同业模板页面路径
    ,o.templeteno -- 同业模板编号
    ,o.vouchflag -- 有无其他担保方式，HaveNot
    ,o.ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
    ,o.advancedmanuflag -- 先进制造业标志（0-否，1-是）
    ,o.cultureindustryflag -- 文化产业标志（0-否，1-是）
    ,o.onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
    ,o.onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
    ,o.strategicemergingindustrytype -- 战略性新兴产业类型
    ,o.transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
    ,o.effectdate -- 合同签订日期
    ,o.statisticstotalbalance -- 统计用敞口余额
    ,o.transformtimes -- 变更次数
    ,o.belongitem -- 所属项下
    ,o.useexposuretype -- 占用敞口类型(UseExposureType)
    ,o.isgxtechent -- 高新技术企业标志
    ,o.isscitechent -- 科技型企业
    ,o.iskctechent -- 科创企业
    ,o.isxxdquota -- 是否营销额度（新兴贷专用）
    ,o.ispensionindustry -- 养老产业标识
    ,o.ifseedloan -- 种业振兴贷款
    ,o.ifcountyloan -- 县城区贷款
    ,o.ifhighindustry -- 是否投向高技术产业
    ,o.numbereconomytype -- 投向数字经济核心产业类型
    ,o.riskapproveamout -- 风控审批可用金额
    ,o.icmsapproveamout -- 信贷审批可用金额
    ,o.ifcapproveamount -- 审批后额度合同金额（IFC专用）
    ,o.ifcapprovebalance -- 数总审批可用金额（IFC专用）
    ,o.issignedcontract -- 是否签订额度合同
    ,o.whethertorestructuretheloan -- 是否重组贷款
    ,o.bdserialno -- 借据号
    ,o.renewstartdate -- 展期起始日
    ,o.secondpayaccount -- 第二还款账号
    ,o.merchordernum -- 订单号
    ,o.applyno -- 房抵贷贷款申请编号
    ,o.pclnominalamount -- 华兴易贷担保可用金额
    ,o.pcloccupyamount -- 华兴易贷担保占用金额
    ,o.comticketrecourseflag -- 商票保贴追索标识（0-否，1-是）
    ,o.bizcontrwthrdisctpers -- 是否贴现人保证金账户（0-否，1-是）
    ,o.subproductname -- 子产品名称
    ,o.renewaltype -- 
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
from ${iol_schema}.icms_business_contract_bk o
    left join ${iol_schema}.icms_business_contract_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_business_contract_cl d
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
--truncate table ${iol_schema}.icms_business_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_business_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_business_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_business_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_business_contract exchange partition p_${batch_date} with table ${iol_schema}.icms_business_contract_cl;
alter table ${iol_schema}.icms_business_contract exchange partition p_20991231 with table ${iol_schema}.icms_business_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_business_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_contract_op purge;
drop table ${iol_schema}.icms_business_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_business_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_business_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
