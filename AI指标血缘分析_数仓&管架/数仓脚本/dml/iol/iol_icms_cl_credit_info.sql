/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cl_credit_info
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
create table ${iol_schema}.icms_cl_credit_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_cl_credit_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_credit_info_op purge;
drop table ${iol_schema}.icms_cl_credit_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_credit_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_credit_info where 0=1;

create table ${iol_schema}.icms_cl_credit_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_credit_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_credit_info_cl(
            loweroccupyupperexposureamount -- 下层占用上层授信敞口金额
            ,additioncommand -- 其他条件和要求
            ,availablelowriskexposuresum -- 类低风险可用敞口金额
            ,createdway -- 创建方式:审批/系统
            ,reservedamount -- 预留金额
            ,purpose -- 用途
            ,status -- 状态
            ,adjustnominalamount -- 串用名义金额
            ,explain -- 冻结、解冻、终结说明
            ,latestusedate -- 额度最迟使用日期
            ,occurway -- 发生方式
            ,totalpayment -- 累计放款
            ,operateorgid -- 经办机构
            ,reservedcustomerid -- 预留客户编号
            ,nominalamount -- 名义金额
            ,updateorgid -- 最后更新机构
            ,riskexposuresum -- 初始一般敞口金额
            ,execexposureamount -- 执行敞口金额
            ,freezestatus -- 冻结状态已冻结、未冻结）
            ,singlebizmostamount -- 明细额度下业务单笔最大金额
            ,assignoccupyupperexposureamoun -- 指定占用上层授信敞口金额
            ,creditphase -- 当前授信阶段
            ,suboccupynominalbalance -- 下层授信名义余额占用汇总
            ,operateuserid -- 经办人
            ,leftprenominalamount -- 剩余预占名义金额
            ,inputorgid -- 登记机构
            ,availablebusinesstype -- 适用业务品种
            ,prenominalamount -- 预占名义金额
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,nominalbalance -- 授信名义余额
            ,dedicatedflag -- 授信专用标志
            ,availablereservedamount -- 可用预留金额
            ,currencyrange -- 项下业务币种范围
            ,credittype -- 额度品种
            ,sourcesystem -- 最初来源系统
            ,businessoccupynominalamount -- 下层的业务占用名义金额汇总
            ,istrans -- 是否转授信标志
            ,availableexposureamount -- 可用敞口金额
            ,latestartdateunderlowercredit -- 项下下层授信最迟起始日
            ,availablenominalamount -- 可用名义金额
            ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
            ,loweroccupyuppernominalamount -- 下层占用上层授信名义金额
            ,currency -- 币种
            ,exposureamount -- 敞口金额
            ,occupyflag -- 占用标识
            ,suboccupyexposurebalance -- 下层授信敞口余额占用汇总
            ,adjustexposureamount -- 串用敞口金额
            ,exposurebalance -- 授信敞口余额
            ,inputuserid -- 登记人
            ,maxperioddayunderlowercredit -- 项下下层授信最长期限日）
            ,totalrepayment -- 累计还款
            ,lineclass -- 额度种类综合/专项/其他)
            ,leftpreexposureamount -- 剩余预占敞口金额
            ,freezeexposureamount -- 冻结敞口金额
            ,inputdate -- 登记日期
            ,ispubliccredit -- 是否公开授信
            ,availableriskexposuresum -- 一般风险可用敞口金额
            ,execnominalamount -- 执行名义金额
            ,freezenominalamount -- 冻结名义金额
            ,creditno -- 额度系统业务编号
            ,assignoccupyuppernominalamount -- 指定占用上层授信名义金额
            ,lateexpiredateunderlowercredit -- 项下下层授信最迟到期日
            ,businessoccupyexposureamount -- 下层的业务占用敞口金额汇总
            ,lowriskexposuresum -- 类低风险敞口金额
            ,timelimitmonth -- 期限月
            ,recyclable -- 可循环标志Y/N
            ,actualexpiredate -- 实际终结日
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,preexposureamount -- 预占敞口金额
            ,effectivedate -- 生效日期
            ,lockflag -- 锁定标识Y/N
            ,timelimitday -- 期限日
            ,onlineamount -- 初始线上额度
            ,sourcecreditno -- 最初来源额度编号
            ,manageuserid -- 管理人
            ,updateuserid -- 最后更新人
            ,customerid -- 客户编号
            ,manageorgid -- 管理机构
            ,earlystartdateunderlowercredit -- 项下下层授信最早起始日
            ,maxperiodmonthunderlowercredit -- 项下下层授信最长期限月）
            ,usableamountcalcflag -- 可用金额计算标志
            ,guarantyway -- 担保方式
            ,updatedate -- 最后更新日期
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,slowreleaseexposureamount -- 可缓释敞口金额
            ,canbeextractedundercredit -- 额度项下是否可直接提款Y或N
            ,expiredate -- 到期日
            ,remark -- 备注
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,pledgesum -- 抵质押物金额
            ,isexempt -- 是否豁免
            ,onlinebusinessamount -- 
            ,onlinebusinessbalance -- 
            ,lowoccupynominalamountonline -- 
            ,lowoccupyexposureamountonline -- 
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,icmsapproveamout -- 
            ,bapserialno -- 
            ,occupycreditno -- 
            ,riskapproveamout -- 
            ,iscollectionagency -- 
            ,nbgkamount -- 
            ,nbgkoccupyamount -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_credit_info_op(
            loweroccupyupperexposureamount -- 下层占用上层授信敞口金额
            ,additioncommand -- 其他条件和要求
            ,availablelowriskexposuresum -- 类低风险可用敞口金额
            ,createdway -- 创建方式:审批/系统
            ,reservedamount -- 预留金额
            ,purpose -- 用途
            ,status -- 状态
            ,adjustnominalamount -- 串用名义金额
            ,explain -- 冻结、解冻、终结说明
            ,latestusedate -- 额度最迟使用日期
            ,occurway -- 发生方式
            ,totalpayment -- 累计放款
            ,operateorgid -- 经办机构
            ,reservedcustomerid -- 预留客户编号
            ,nominalamount -- 名义金额
            ,updateorgid -- 最后更新机构
            ,riskexposuresum -- 初始一般敞口金额
            ,execexposureamount -- 执行敞口金额
            ,freezestatus -- 冻结状态已冻结、未冻结）
            ,singlebizmostamount -- 明细额度下业务单笔最大金额
            ,assignoccupyupperexposureamoun -- 指定占用上层授信敞口金额
            ,creditphase -- 当前授信阶段
            ,suboccupynominalbalance -- 下层授信名义余额占用汇总
            ,operateuserid -- 经办人
            ,leftprenominalamount -- 剩余预占名义金额
            ,inputorgid -- 登记机构
            ,availablebusinesstype -- 适用业务品种
            ,prenominalamount -- 预占名义金额
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,nominalbalance -- 授信名义余额
            ,dedicatedflag -- 授信专用标志
            ,availablereservedamount -- 可用预留金额
            ,currencyrange -- 项下业务币种范围
            ,credittype -- 额度品种
            ,sourcesystem -- 最初来源系统
            ,businessoccupynominalamount -- 下层的业务占用名义金额汇总
            ,istrans -- 是否转授信标志
            ,availableexposureamount -- 可用敞口金额
            ,latestartdateunderlowercredit -- 项下下层授信最迟起始日
            ,availablenominalamount -- 可用名义金额
            ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
            ,loweroccupyuppernominalamount -- 下层占用上层授信名义金额
            ,currency -- 币种
            ,exposureamount -- 敞口金额
            ,occupyflag -- 占用标识
            ,suboccupyexposurebalance -- 下层授信敞口余额占用汇总
            ,adjustexposureamount -- 串用敞口金额
            ,exposurebalance -- 授信敞口余额
            ,inputuserid -- 登记人
            ,maxperioddayunderlowercredit -- 项下下层授信最长期限日）
            ,totalrepayment -- 累计还款
            ,lineclass -- 额度种类综合/专项/其他)
            ,leftpreexposureamount -- 剩余预占敞口金额
            ,freezeexposureamount -- 冻结敞口金额
            ,inputdate -- 登记日期
            ,ispubliccredit -- 是否公开授信
            ,availableriskexposuresum -- 一般风险可用敞口金额
            ,execnominalamount -- 执行名义金额
            ,freezenominalamount -- 冻结名义金额
            ,creditno -- 额度系统业务编号
            ,assignoccupyuppernominalamount -- 指定占用上层授信名义金额
            ,lateexpiredateunderlowercredit -- 项下下层授信最迟到期日
            ,businessoccupyexposureamount -- 下层的业务占用敞口金额汇总
            ,lowriskexposuresum -- 类低风险敞口金额
            ,timelimitmonth -- 期限月
            ,recyclable -- 可循环标志Y/N
            ,actualexpiredate -- 实际终结日
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,preexposureamount -- 预占敞口金额
            ,effectivedate -- 生效日期
            ,lockflag -- 锁定标识Y/N
            ,timelimitday -- 期限日
            ,onlineamount -- 初始线上额度
            ,sourcecreditno -- 最初来源额度编号
            ,manageuserid -- 管理人
            ,updateuserid -- 最后更新人
            ,customerid -- 客户编号
            ,manageorgid -- 管理机构
            ,earlystartdateunderlowercredit -- 项下下层授信最早起始日
            ,maxperiodmonthunderlowercredit -- 项下下层授信最长期限月）
            ,usableamountcalcflag -- 可用金额计算标志
            ,guarantyway -- 担保方式
            ,updatedate -- 最后更新日期
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,slowreleaseexposureamount -- 可缓释敞口金额
            ,canbeextractedundercredit -- 额度项下是否可直接提款Y或N
            ,expiredate -- 到期日
            ,remark -- 备注
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,pledgesum -- 抵质押物金额
            ,isexempt -- 是否豁免
            ,onlinebusinessamount -- 
            ,onlinebusinessbalance -- 
            ,lowoccupynominalamountonline -- 
            ,lowoccupyexposureamountonline -- 
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,icmsapproveamout -- 
            ,bapserialno -- 
            ,occupycreditno -- 
            ,riskapproveamout -- 
            ,iscollectionagency -- 
            ,nbgkamount -- 
            ,nbgkoccupyamount -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.loweroccupyupperexposureamount, o.loweroccupyupperexposureamount) as loweroccupyupperexposureamount -- 下层占用上层授信敞口金额
    ,nvl(n.additioncommand, o.additioncommand) as additioncommand -- 其他条件和要求
    ,nvl(n.availablelowriskexposuresum, o.availablelowriskexposuresum) as availablelowriskexposuresum -- 类低风险可用敞口金额
    ,nvl(n.createdway, o.createdway) as createdway -- 创建方式:审批/系统
    ,nvl(n.reservedamount, o.reservedamount) as reservedamount -- 预留金额
    ,nvl(n.purpose, o.purpose) as purpose -- 用途
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.adjustnominalamount, o.adjustnominalamount) as adjustnominalamount -- 串用名义金额
    ,nvl(n.explain, o.explain) as explain -- 冻结、解冻、终结说明
    ,nvl(n.latestusedate, o.latestusedate) as latestusedate -- 额度最迟使用日期
    ,nvl(n.occurway, o.occurway) as occurway -- 发生方式
    ,nvl(n.totalpayment, o.totalpayment) as totalpayment -- 累计放款
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.reservedcustomerid, o.reservedcustomerid) as reservedcustomerid -- 预留客户编号
    ,nvl(n.nominalamount, o.nominalamount) as nominalamount -- 名义金额
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 最后更新机构
    ,nvl(n.riskexposuresum, o.riskexposuresum) as riskexposuresum -- 初始一般敞口金额
    ,nvl(n.execexposureamount, o.execexposureamount) as execexposureamount -- 执行敞口金额
    ,nvl(n.freezestatus, o.freezestatus) as freezestatus -- 冻结状态已冻结、未冻结）
    ,nvl(n.singlebizmostamount, o.singlebizmostamount) as singlebizmostamount -- 明细额度下业务单笔最大金额
    ,nvl(n.assignoccupyupperexposureamoun, o.assignoccupyupperexposureamoun) as assignoccupyupperexposureamoun -- 指定占用上层授信敞口金额
    ,nvl(n.creditphase, o.creditphase) as creditphase -- 当前授信阶段
    ,nvl(n.suboccupynominalbalance, o.suboccupynominalbalance) as suboccupynominalbalance -- 下层授信名义余额占用汇总
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办人
    ,nvl(n.leftprenominalamount, o.leftprenominalamount) as leftprenominalamount -- 剩余预占名义金额
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.availablebusinesstype, o.availablebusinesstype) as availablebusinesstype -- 适用业务品种
    ,nvl(n.prenominalamount, o.prenominalamount) as prenominalamount -- 预占名义金额
    ,nvl(n.bizmostmortgagerate, o.bizmostmortgagerate) as bizmostmortgagerate -- 额度下业务最高抵质押率
    ,nvl(n.nominalbalance, o.nominalbalance) as nominalbalance -- 授信名义余额
    ,nvl(n.dedicatedflag, o.dedicatedflag) as dedicatedflag -- 授信专用标志
    ,nvl(n.availablereservedamount, o.availablereservedamount) as availablereservedamount -- 可用预留金额
    ,nvl(n.currencyrange, o.currencyrange) as currencyrange -- 项下业务币种范围
    ,nvl(n.credittype, o.credittype) as credittype -- 额度品种
    ,nvl(n.sourcesystem, o.sourcesystem) as sourcesystem -- 最初来源系统
    ,nvl(n.businessoccupynominalamount, o.businessoccupynominalamount) as businessoccupynominalamount -- 下层的业务占用名义金额汇总
    ,nvl(n.istrans, o.istrans) as istrans -- 是否转授信标志
    ,nvl(n.availableexposureamount, o.availableexposureamount) as availableexposureamount -- 可用敞口金额
    ,nvl(n.latestartdateunderlowercredit, o.latestartdateunderlowercredit) as latestartdateunderlowercredit -- 项下下层授信最迟起始日
    ,nvl(n.availablenominalamount, o.availablenominalamount) as availablenominalamount -- 可用名义金额
    ,nvl(n.slowreleaseexposurecurrency, o.slowreleaseexposurecurrency) as slowreleaseexposurecurrency -- 可缓释敞口金额币种
    ,nvl(n.loweroccupyuppernominalamount, o.loweroccupyuppernominalamount) as loweroccupyuppernominalamount -- 下层占用上层授信名义金额
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.exposureamount, o.exposureamount) as exposureamount -- 敞口金额
    ,nvl(n.occupyflag, o.occupyflag) as occupyflag -- 占用标识
    ,nvl(n.suboccupyexposurebalance, o.suboccupyexposurebalance) as suboccupyexposurebalance -- 下层授信敞口余额占用汇总
    ,nvl(n.adjustexposureamount, o.adjustexposureamount) as adjustexposureamount -- 串用敞口金额
    ,nvl(n.exposurebalance, o.exposurebalance) as exposurebalance -- 授信敞口余额
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.maxperioddayunderlowercredit, o.maxperioddayunderlowercredit) as maxperioddayunderlowercredit -- 项下下层授信最长期限日）
    ,nvl(n.totalrepayment, o.totalrepayment) as totalrepayment -- 累计还款
    ,nvl(n.lineclass, o.lineclass) as lineclass -- 额度种类综合/专项/其他)
    ,nvl(n.leftpreexposureamount, o.leftpreexposureamount) as leftpreexposureamount -- 剩余预占敞口金额
    ,nvl(n.freezeexposureamount, o.freezeexposureamount) as freezeexposureamount -- 冻结敞口金额
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.ispubliccredit, o.ispubliccredit) as ispubliccredit -- 是否公开授信
    ,nvl(n.availableriskexposuresum, o.availableriskexposuresum) as availableriskexposuresum -- 一般风险可用敞口金额
    ,nvl(n.execnominalamount, o.execnominalamount) as execnominalamount -- 执行名义金额
    ,nvl(n.freezenominalamount, o.freezenominalamount) as freezenominalamount -- 冻结名义金额
    ,nvl(n.creditno, o.creditno) as creditno -- 额度系统业务编号
    ,nvl(n.assignoccupyuppernominalamount, o.assignoccupyuppernominalamount) as assignoccupyuppernominalamount -- 指定占用上层授信名义金额
    ,nvl(n.lateexpiredateunderlowercredit, o.lateexpiredateunderlowercredit) as lateexpiredateunderlowercredit -- 项下下层授信最迟到期日
    ,nvl(n.businessoccupyexposureamount, o.businessoccupyexposureamount) as businessoccupyexposureamount -- 下层的业务占用敞口金额汇总
    ,nvl(n.lowriskexposuresum, o.lowriskexposuresum) as lowriskexposuresum -- 类低风险敞口金额
    ,nvl(n.timelimitmonth, o.timelimitmonth) as timelimitmonth -- 期限月
    ,nvl(n.recyclable, o.recyclable) as recyclable -- 可循环标志Y/N
    ,nvl(n.actualexpiredate, o.actualexpiredate) as actualexpiredate -- 实际终结日
    ,nvl(n.bizbailinitialrate, o.bizbailinitialrate) as bizbailinitialrate -- 额度下业务初始保证金比例
    ,nvl(n.preexposureamount, o.preexposureamount) as preexposureamount -- 预占敞口金额
    ,nvl(n.effectivedate, o.effectivedate) as effectivedate -- 生效日期
    ,nvl(n.lockflag, o.lockflag) as lockflag -- 锁定标识Y/N
    ,nvl(n.timelimitday, o.timelimitday) as timelimitday -- 期限日
    ,nvl(n.onlineamount, o.onlineamount) as onlineamount -- 初始线上额度
    ,nvl(n.sourcecreditno, o.sourcecreditno) as sourcecreditno -- 最初来源额度编号
    ,nvl(n.manageuserid, o.manageuserid) as manageuserid -- 管理人
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 最后更新人
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.manageorgid, o.manageorgid) as manageorgid -- 管理机构
    ,nvl(n.earlystartdateunderlowercredit, o.earlystartdateunderlowercredit) as earlystartdateunderlowercredit -- 项下下层授信最早起始日
    ,nvl(n.maxperiodmonthunderlowercredit, o.maxperiodmonthunderlowercredit) as maxperiodmonthunderlowercredit -- 项下下层授信最长期限月）
    ,nvl(n.usableamountcalcflag, o.usableamountcalcflag) as usableamountcalcflag -- 可用金额计算标志
    ,nvl(n.guarantyway, o.guarantyway) as guarantyway -- 担保方式
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 最后更新日期
    ,nvl(n.execslowreleaseexposureamount, o.execslowreleaseexposureamount) as execslowreleaseexposureamount -- 执行可缓释敞口金额
    ,nvl(n.slowreleaseexposureamount, o.slowreleaseexposureamount) as slowreleaseexposureamount -- 可缓释敞口金额
    ,nvl(n.canbeextractedundercredit, o.canbeextractedundercredit) as canbeextractedundercredit -- 额度项下是否可直接提款Y或N
    ,nvl(n.expiredate, o.expiredate) as expiredate -- 到期日
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.bizlowestfloatrate, o.bizlowestfloatrate) as bizlowestfloatrate -- 额度下业务利率最低浮动
    ,nvl(n.pledgesum, o.pledgesum) as pledgesum -- 抵质押物金额
    ,nvl(n.isexempt, o.isexempt) as isexempt -- 是否豁免
    ,nvl(n.onlinebusinessamount, o.onlinebusinessamount) as onlinebusinessamount -- 
    ,nvl(n.onlinebusinessbalance, o.onlinebusinessbalance) as onlinebusinessbalance -- 
    ,nvl(n.lowoccupynominalamountonline, o.lowoccupynominalamountonline) as lowoccupynominalamountonline -- 
    ,nvl(n.lowoccupyexposureamountonline, o.lowoccupyexposureamountonline) as lowoccupyexposureamountonline -- 
    ,nvl(n.isjoinlimits, o.isjoinlimits) as isjoinlimits -- 
    ,nvl(n.otherlimitamount, o.otherlimitamount) as otherlimitamount -- 
    ,nvl(n.icmsapproveamout, o.icmsapproveamout) as icmsapproveamout -- 
    ,nvl(n.bapserialno, o.bapserialno) as bapserialno -- 
    ,nvl(n.occupycreditno, o.occupycreditno) as occupycreditno -- 
    ,nvl(n.riskapproveamout, o.riskapproveamout) as riskapproveamout -- 
    ,nvl(n.iscollectionagency, o.iscollectionagency) as iscollectionagency -- 
    ,nvl(n.nbgkamount, o.nbgkamount) as nbgkamount -- 
    ,nvl(n.nbgkoccupyamount, o.nbgkoccupyamount) as nbgkoccupyamount -- 
    ,case when
            n.creditno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.creditno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.creditno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_cl_credit_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_cl_credit_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.creditno = n.creditno
where (
        o.creditno is null
    )
    or (
        n.creditno is null
    )
    or (
        o.loweroccupyupperexposureamount <> n.loweroccupyupperexposureamount
        or o.additioncommand <> n.additioncommand
        or o.availablelowriskexposuresum <> n.availablelowriskexposuresum
        or o.createdway <> n.createdway
        or o.reservedamount <> n.reservedamount
        or o.purpose <> n.purpose
        or o.status <> n.status
        or o.adjustnominalamount <> n.adjustnominalamount
        or o.explain <> n.explain
        or o.latestusedate <> n.latestusedate
        or o.occurway <> n.occurway
        or o.totalpayment <> n.totalpayment
        or o.operateorgid <> n.operateorgid
        or o.reservedcustomerid <> n.reservedcustomerid
        or o.nominalamount <> n.nominalamount
        or o.updateorgid <> n.updateorgid
        or o.riskexposuresum <> n.riskexposuresum
        or o.execexposureamount <> n.execexposureamount
        or o.freezestatus <> n.freezestatus
        or o.singlebizmostamount <> n.singlebizmostamount
        or o.assignoccupyupperexposureamoun <> n.assignoccupyupperexposureamoun
        or o.creditphase <> n.creditphase
        or o.suboccupynominalbalance <> n.suboccupynominalbalance
        or o.operateuserid <> n.operateuserid
        or o.leftprenominalamount <> n.leftprenominalamount
        or o.inputorgid <> n.inputorgid
        or o.availablebusinesstype <> n.availablebusinesstype
        or o.prenominalamount <> n.prenominalamount
        or o.bizmostmortgagerate <> n.bizmostmortgagerate
        or o.nominalbalance <> n.nominalbalance
        or o.dedicatedflag <> n.dedicatedflag
        or o.availablereservedamount <> n.availablereservedamount
        or o.currencyrange <> n.currencyrange
        or o.credittype <> n.credittype
        or o.sourcesystem <> n.sourcesystem
        or o.businessoccupynominalamount <> n.businessoccupynominalamount
        or o.istrans <> n.istrans
        or o.availableexposureamount <> n.availableexposureamount
        or o.latestartdateunderlowercredit <> n.latestartdateunderlowercredit
        or o.availablenominalamount <> n.availablenominalamount
        or o.slowreleaseexposurecurrency <> n.slowreleaseexposurecurrency
        or o.loweroccupyuppernominalamount <> n.loweroccupyuppernominalamount
        or o.currency <> n.currency
        or o.exposureamount <> n.exposureamount
        or o.occupyflag <> n.occupyflag
        or o.suboccupyexposurebalance <> n.suboccupyexposurebalance
        or o.adjustexposureamount <> n.adjustexposureamount
        or o.exposurebalance <> n.exposurebalance
        or o.inputuserid <> n.inputuserid
        or o.maxperioddayunderlowercredit <> n.maxperioddayunderlowercredit
        or o.totalrepayment <> n.totalrepayment
        or o.lineclass <> n.lineclass
        or o.leftpreexposureamount <> n.leftpreexposureamount
        or o.freezeexposureamount <> n.freezeexposureamount
        or o.inputdate <> n.inputdate
        or o.ispubliccredit <> n.ispubliccredit
        or o.availableriskexposuresum <> n.availableriskexposuresum
        or o.execnominalamount <> n.execnominalamount
        or o.freezenominalamount <> n.freezenominalamount
        or o.assignoccupyuppernominalamount <> n.assignoccupyuppernominalamount
        or o.lateexpiredateunderlowercredit <> n.lateexpiredateunderlowercredit
        or o.businessoccupyexposureamount <> n.businessoccupyexposureamount
        or o.lowriskexposuresum <> n.lowriskexposuresum
        or o.timelimitmonth <> n.timelimitmonth
        or o.recyclable <> n.recyclable
        or o.actualexpiredate <> n.actualexpiredate
        or o.bizbailinitialrate <> n.bizbailinitialrate
        or o.preexposureamount <> n.preexposureamount
        or o.effectivedate <> n.effectivedate
        or o.lockflag <> n.lockflag
        or o.timelimitday <> n.timelimitday
        or o.onlineamount <> n.onlineamount
        or o.sourcecreditno <> n.sourcecreditno
        or o.manageuserid <> n.manageuserid
        or o.updateuserid <> n.updateuserid
        or o.customerid <> n.customerid
        or o.manageorgid <> n.manageorgid
        or o.earlystartdateunderlowercredit <> n.earlystartdateunderlowercredit
        or o.maxperiodmonthunderlowercredit <> n.maxperiodmonthunderlowercredit
        or o.usableamountcalcflag <> n.usableamountcalcflag
        or o.guarantyway <> n.guarantyway
        or o.updatedate <> n.updatedate
        or o.execslowreleaseexposureamount <> n.execslowreleaseexposureamount
        or o.slowreleaseexposureamount <> n.slowreleaseexposureamount
        or o.canbeextractedundercredit <> n.canbeextractedundercredit
        or o.expiredate <> n.expiredate
        or o.remark <> n.remark
        or o.bizlowestfloatrate <> n.bizlowestfloatrate
        or o.pledgesum <> n.pledgesum
        or o.isexempt <> n.isexempt
        or o.onlinebusinessamount <> n.onlinebusinessamount
        or o.onlinebusinessbalance <> n.onlinebusinessbalance
        or o.lowoccupynominalamountonline <> n.lowoccupynominalamountonline
        or o.lowoccupyexposureamountonline <> n.lowoccupyexposureamountonline
        or o.isjoinlimits <> n.isjoinlimits
        or o.otherlimitamount <> n.otherlimitamount
        or o.icmsapproveamout <> n.icmsapproveamout
        or o.bapserialno <> n.bapserialno
        or o.occupycreditno <> n.occupycreditno
        or o.riskapproveamout <> n.riskapproveamout
        or o.iscollectionagency <> n.iscollectionagency
        or o.nbgkamount <> n.nbgkamount
        or o.nbgkoccupyamount <> n.nbgkoccupyamount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_credit_info_cl(
            loweroccupyupperexposureamount -- 下层占用上层授信敞口金额
            ,additioncommand -- 其他条件和要求
            ,availablelowriskexposuresum -- 类低风险可用敞口金额
            ,createdway -- 创建方式:审批/系统
            ,reservedamount -- 预留金额
            ,purpose -- 用途
            ,status -- 状态
            ,adjustnominalamount -- 串用名义金额
            ,explain -- 冻结、解冻、终结说明
            ,latestusedate -- 额度最迟使用日期
            ,occurway -- 发生方式
            ,totalpayment -- 累计放款
            ,operateorgid -- 经办机构
            ,reservedcustomerid -- 预留客户编号
            ,nominalamount -- 名义金额
            ,updateorgid -- 最后更新机构
            ,riskexposuresum -- 初始一般敞口金额
            ,execexposureamount -- 执行敞口金额
            ,freezestatus -- 冻结状态已冻结、未冻结）
            ,singlebizmostamount -- 明细额度下业务单笔最大金额
            ,assignoccupyupperexposureamoun -- 指定占用上层授信敞口金额
            ,creditphase -- 当前授信阶段
            ,suboccupynominalbalance -- 下层授信名义余额占用汇总
            ,operateuserid -- 经办人
            ,leftprenominalamount -- 剩余预占名义金额
            ,inputorgid -- 登记机构
            ,availablebusinesstype -- 适用业务品种
            ,prenominalamount -- 预占名义金额
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,nominalbalance -- 授信名义余额
            ,dedicatedflag -- 授信专用标志
            ,availablereservedamount -- 可用预留金额
            ,currencyrange -- 项下业务币种范围
            ,credittype -- 额度品种
            ,sourcesystem -- 最初来源系统
            ,businessoccupynominalamount -- 下层的业务占用名义金额汇总
            ,istrans -- 是否转授信标志
            ,availableexposureamount -- 可用敞口金额
            ,latestartdateunderlowercredit -- 项下下层授信最迟起始日
            ,availablenominalamount -- 可用名义金额
            ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
            ,loweroccupyuppernominalamount -- 下层占用上层授信名义金额
            ,currency -- 币种
            ,exposureamount -- 敞口金额
            ,occupyflag -- 占用标识
            ,suboccupyexposurebalance -- 下层授信敞口余额占用汇总
            ,adjustexposureamount -- 串用敞口金额
            ,exposurebalance -- 授信敞口余额
            ,inputuserid -- 登记人
            ,maxperioddayunderlowercredit -- 项下下层授信最长期限日）
            ,totalrepayment -- 累计还款
            ,lineclass -- 额度种类综合/专项/其他)
            ,leftpreexposureamount -- 剩余预占敞口金额
            ,freezeexposureamount -- 冻结敞口金额
            ,inputdate -- 登记日期
            ,ispubliccredit -- 是否公开授信
            ,availableriskexposuresum -- 一般风险可用敞口金额
            ,execnominalamount -- 执行名义金额
            ,freezenominalamount -- 冻结名义金额
            ,creditno -- 额度系统业务编号
            ,assignoccupyuppernominalamount -- 指定占用上层授信名义金额
            ,lateexpiredateunderlowercredit -- 项下下层授信最迟到期日
            ,businessoccupyexposureamount -- 下层的业务占用敞口金额汇总
            ,lowriskexposuresum -- 类低风险敞口金额
            ,timelimitmonth -- 期限月
            ,recyclable -- 可循环标志Y/N
            ,actualexpiredate -- 实际终结日
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,preexposureamount -- 预占敞口金额
            ,effectivedate -- 生效日期
            ,lockflag -- 锁定标识Y/N
            ,timelimitday -- 期限日
            ,onlineamount -- 初始线上额度
            ,sourcecreditno -- 最初来源额度编号
            ,manageuserid -- 管理人
            ,updateuserid -- 最后更新人
            ,customerid -- 客户编号
            ,manageorgid -- 管理机构
            ,earlystartdateunderlowercredit -- 项下下层授信最早起始日
            ,maxperiodmonthunderlowercredit -- 项下下层授信最长期限月）
            ,usableamountcalcflag -- 可用金额计算标志
            ,guarantyway -- 担保方式
            ,updatedate -- 最后更新日期
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,slowreleaseexposureamount -- 可缓释敞口金额
            ,canbeextractedundercredit -- 额度项下是否可直接提款Y或N
            ,expiredate -- 到期日
            ,remark -- 备注
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,pledgesum -- 抵质押物金额
            ,isexempt -- 是否豁免
            ,onlinebusinessamount -- 
            ,onlinebusinessbalance -- 
            ,lowoccupynominalamountonline -- 
            ,lowoccupyexposureamountonline -- 
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,icmsapproveamout -- 
            ,bapserialno -- 
            ,occupycreditno -- 
            ,riskapproveamout -- 
            ,iscollectionagency -- 
            ,nbgkamount -- 
            ,nbgkoccupyamount -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_credit_info_op(
            loweroccupyupperexposureamount -- 下层占用上层授信敞口金额
            ,additioncommand -- 其他条件和要求
            ,availablelowriskexposuresum -- 类低风险可用敞口金额
            ,createdway -- 创建方式:审批/系统
            ,reservedamount -- 预留金额
            ,purpose -- 用途
            ,status -- 状态
            ,adjustnominalamount -- 串用名义金额
            ,explain -- 冻结、解冻、终结说明
            ,latestusedate -- 额度最迟使用日期
            ,occurway -- 发生方式
            ,totalpayment -- 累计放款
            ,operateorgid -- 经办机构
            ,reservedcustomerid -- 预留客户编号
            ,nominalamount -- 名义金额
            ,updateorgid -- 最后更新机构
            ,riskexposuresum -- 初始一般敞口金额
            ,execexposureamount -- 执行敞口金额
            ,freezestatus -- 冻结状态已冻结、未冻结）
            ,singlebizmostamount -- 明细额度下业务单笔最大金额
            ,assignoccupyupperexposureamoun -- 指定占用上层授信敞口金额
            ,creditphase -- 当前授信阶段
            ,suboccupynominalbalance -- 下层授信名义余额占用汇总
            ,operateuserid -- 经办人
            ,leftprenominalamount -- 剩余预占名义金额
            ,inputorgid -- 登记机构
            ,availablebusinesstype -- 适用业务品种
            ,prenominalamount -- 预占名义金额
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,nominalbalance -- 授信名义余额
            ,dedicatedflag -- 授信专用标志
            ,availablereservedamount -- 可用预留金额
            ,currencyrange -- 项下业务币种范围
            ,credittype -- 额度品种
            ,sourcesystem -- 最初来源系统
            ,businessoccupynominalamount -- 下层的业务占用名义金额汇总
            ,istrans -- 是否转授信标志
            ,availableexposureamount -- 可用敞口金额
            ,latestartdateunderlowercredit -- 项下下层授信最迟起始日
            ,availablenominalamount -- 可用名义金额
            ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
            ,loweroccupyuppernominalamount -- 下层占用上层授信名义金额
            ,currency -- 币种
            ,exposureamount -- 敞口金额
            ,occupyflag -- 占用标识
            ,suboccupyexposurebalance -- 下层授信敞口余额占用汇总
            ,adjustexposureamount -- 串用敞口金额
            ,exposurebalance -- 授信敞口余额
            ,inputuserid -- 登记人
            ,maxperioddayunderlowercredit -- 项下下层授信最长期限日）
            ,totalrepayment -- 累计还款
            ,lineclass -- 额度种类综合/专项/其他)
            ,leftpreexposureamount -- 剩余预占敞口金额
            ,freezeexposureamount -- 冻结敞口金额
            ,inputdate -- 登记日期
            ,ispubliccredit -- 是否公开授信
            ,availableriskexposuresum -- 一般风险可用敞口金额
            ,execnominalamount -- 执行名义金额
            ,freezenominalamount -- 冻结名义金额
            ,creditno -- 额度系统业务编号
            ,assignoccupyuppernominalamount -- 指定占用上层授信名义金额
            ,lateexpiredateunderlowercredit -- 项下下层授信最迟到期日
            ,businessoccupyexposureamount -- 下层的业务占用敞口金额汇总
            ,lowriskexposuresum -- 类低风险敞口金额
            ,timelimitmonth -- 期限月
            ,recyclable -- 可循环标志Y/N
            ,actualexpiredate -- 实际终结日
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,preexposureamount -- 预占敞口金额
            ,effectivedate -- 生效日期
            ,lockflag -- 锁定标识Y/N
            ,timelimitday -- 期限日
            ,onlineamount -- 初始线上额度
            ,sourcecreditno -- 最初来源额度编号
            ,manageuserid -- 管理人
            ,updateuserid -- 最后更新人
            ,customerid -- 客户编号
            ,manageorgid -- 管理机构
            ,earlystartdateunderlowercredit -- 项下下层授信最早起始日
            ,maxperiodmonthunderlowercredit -- 项下下层授信最长期限月）
            ,usableamountcalcflag -- 可用金额计算标志
            ,guarantyway -- 担保方式
            ,updatedate -- 最后更新日期
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,slowreleaseexposureamount -- 可缓释敞口金额
            ,canbeextractedundercredit -- 额度项下是否可直接提款Y或N
            ,expiredate -- 到期日
            ,remark -- 备注
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,pledgesum -- 抵质押物金额
            ,isexempt -- 是否豁免
            ,onlinebusinessamount -- 
            ,onlinebusinessbalance -- 
            ,lowoccupynominalamountonline -- 
            ,lowoccupyexposureamountonline -- 
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,icmsapproveamout -- 
            ,bapserialno -- 
            ,occupycreditno -- 
            ,riskapproveamout -- 
            ,iscollectionagency -- 
            ,nbgkamount -- 
            ,nbgkoccupyamount -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.loweroccupyupperexposureamount -- 下层占用上层授信敞口金额
    ,o.additioncommand -- 其他条件和要求
    ,o.availablelowriskexposuresum -- 类低风险可用敞口金额
    ,o.createdway -- 创建方式:审批/系统
    ,o.reservedamount -- 预留金额
    ,o.purpose -- 用途
    ,o.status -- 状态
    ,o.adjustnominalamount -- 串用名义金额
    ,o.explain -- 冻结、解冻、终结说明
    ,o.latestusedate -- 额度最迟使用日期
    ,o.occurway -- 发生方式
    ,o.totalpayment -- 累计放款
    ,o.operateorgid -- 经办机构
    ,o.reservedcustomerid -- 预留客户编号
    ,o.nominalamount -- 名义金额
    ,o.updateorgid -- 最后更新机构
    ,o.riskexposuresum -- 初始一般敞口金额
    ,o.execexposureamount -- 执行敞口金额
    ,o.freezestatus -- 冻结状态已冻结、未冻结）
    ,o.singlebizmostamount -- 明细额度下业务单笔最大金额
    ,o.assignoccupyupperexposureamoun -- 指定占用上层授信敞口金额
    ,o.creditphase -- 当前授信阶段
    ,o.suboccupynominalbalance -- 下层授信名义余额占用汇总
    ,o.operateuserid -- 经办人
    ,o.leftprenominalamount -- 剩余预占名义金额
    ,o.inputorgid -- 登记机构
    ,o.availablebusinesstype -- 适用业务品种
    ,o.prenominalamount -- 预占名义金额
    ,o.bizmostmortgagerate -- 额度下业务最高抵质押率
    ,o.nominalbalance -- 授信名义余额
    ,o.dedicatedflag -- 授信专用标志
    ,o.availablereservedamount -- 可用预留金额
    ,o.currencyrange -- 项下业务币种范围
    ,o.credittype -- 额度品种
    ,o.sourcesystem -- 最初来源系统
    ,o.businessoccupynominalamount -- 下层的业务占用名义金额汇总
    ,o.istrans -- 是否转授信标志
    ,o.availableexposureamount -- 可用敞口金额
    ,o.latestartdateunderlowercredit -- 项下下层授信最迟起始日
    ,o.availablenominalamount -- 可用名义金额
    ,o.slowreleaseexposurecurrency -- 可缓释敞口金额币种
    ,o.loweroccupyuppernominalamount -- 下层占用上层授信名义金额
    ,o.currency -- 币种
    ,o.exposureamount -- 敞口金额
    ,o.occupyflag -- 占用标识
    ,o.suboccupyexposurebalance -- 下层授信敞口余额占用汇总
    ,o.adjustexposureamount -- 串用敞口金额
    ,o.exposurebalance -- 授信敞口余额
    ,o.inputuserid -- 登记人
    ,o.maxperioddayunderlowercredit -- 项下下层授信最长期限日）
    ,o.totalrepayment -- 累计还款
    ,o.lineclass -- 额度种类综合/专项/其他)
    ,o.leftpreexposureamount -- 剩余预占敞口金额
    ,o.freezeexposureamount -- 冻结敞口金额
    ,o.inputdate -- 登记日期
    ,o.ispubliccredit -- 是否公开授信
    ,o.availableriskexposuresum -- 一般风险可用敞口金额
    ,o.execnominalamount -- 执行名义金额
    ,o.freezenominalamount -- 冻结名义金额
    ,o.creditno -- 额度系统业务编号
    ,o.assignoccupyuppernominalamount -- 指定占用上层授信名义金额
    ,o.lateexpiredateunderlowercredit -- 项下下层授信最迟到期日
    ,o.businessoccupyexposureamount -- 下层的业务占用敞口金额汇总
    ,o.lowriskexposuresum -- 类低风险敞口金额
    ,o.timelimitmonth -- 期限月
    ,o.recyclable -- 可循环标志Y/N
    ,o.actualexpiredate -- 实际终结日
    ,o.bizbailinitialrate -- 额度下业务初始保证金比例
    ,o.preexposureamount -- 预占敞口金额
    ,o.effectivedate -- 生效日期
    ,o.lockflag -- 锁定标识Y/N
    ,o.timelimitday -- 期限日
    ,o.onlineamount -- 初始线上额度
    ,o.sourcecreditno -- 最初来源额度编号
    ,o.manageuserid -- 管理人
    ,o.updateuserid -- 最后更新人
    ,o.customerid -- 客户编号
    ,o.manageorgid -- 管理机构
    ,o.earlystartdateunderlowercredit -- 项下下层授信最早起始日
    ,o.maxperiodmonthunderlowercredit -- 项下下层授信最长期限月）
    ,o.usableamountcalcflag -- 可用金额计算标志
    ,o.guarantyway -- 担保方式
    ,o.updatedate -- 最后更新日期
    ,o.execslowreleaseexposureamount -- 执行可缓释敞口金额
    ,o.slowreleaseexposureamount -- 可缓释敞口金额
    ,o.canbeextractedundercredit -- 额度项下是否可直接提款Y或N
    ,o.expiredate -- 到期日
    ,o.remark -- 备注
    ,o.bizlowestfloatrate -- 额度下业务利率最低浮动
    ,o.pledgesum -- 抵质押物金额
    ,o.isexempt -- 是否豁免
    ,o.onlinebusinessamount -- 
    ,o.onlinebusinessbalance -- 
    ,o.lowoccupynominalamountonline -- 
    ,o.lowoccupyexposureamountonline -- 
    ,o.isjoinlimits -- 
    ,o.otherlimitamount -- 
    ,o.icmsapproveamout -- 
    ,o.bapserialno -- 
    ,o.occupycreditno -- 
    ,o.riskapproveamout -- 
    ,o.iscollectionagency -- 
    ,o.nbgkamount -- 
    ,o.nbgkoccupyamount -- 
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
from ${iol_schema}.icms_cl_credit_info_bk o
    left join ${iol_schema}.icms_cl_credit_info_op n
        on
            o.creditno = n.creditno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_cl_credit_info_cl d
        on
            o.creditno = d.creditno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_cl_credit_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_cl_credit_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_cl_credit_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_cl_credit_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_cl_credit_info exchange partition p_${batch_date} with table ${iol_schema}.icms_cl_credit_info_cl;
alter table ${iol_schema}.icms_cl_credit_info exchange partition p_20991231 with table ${iol_schema}.icms_cl_credit_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cl_credit_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_credit_info_op purge;
drop table ${iol_schema}.icms_cl_credit_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_cl_credit_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cl_credit_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
