/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_business_approve
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
create table ${iol_schema}.icms_business_approve_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_business_approve
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_approve_op purge;
drop table ${iol_schema}.icms_business_approve_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_approve_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_approve where 0=1;

create table ${iol_schema}.icms_business_approve_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_approve where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_approve_cl(
            serialno -- 批复编号流水号
            ,baserialno -- 申请编号
            ,originflag -- 信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
            ,relativeserialno -- 关联流水号关联流水号(额度申请中最外层额度编号)
            ,parentserialno -- 上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
            ,sourceserialno -- 源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,applytype -- 申请类型申请类型(单一、集团、同业)
            ,flowtype -- 流程类型
            ,businessflag -- 额度/业务标志
            ,occurtype -- 贷款发放类型
            ,occurdate -- 发生日期
            ,currency -- 额度/业务币种
            ,businesssum -- 授信额度
            ,baseproduct -- 基础产品(额度)基础产品
            ,productid -- 产品编号
            ,policyid -- 产品政策编号
            ,policyversionid -- 产品政策版本
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 额度/业务起始日起始日
            ,maturity -- 额度/业务到期日到期日
            ,isremotebusiness -- 是否异地业务
            ,iscycle -- 是否循环(额度)是否循环
            ,risktype -- 风险类型(额度)风险类型（一般、低风险）
            ,islowrisk -- 是否低风险业务
            ,creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
            ,nationalindustrytype -- 贷款投向行业
            ,intraindustrytype -- 行内行业投向
            ,purpose -- 用途
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
            ,repaytype -- 还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
            ,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
            ,repaydate -- 指定还款日
            ,reservesum -- 预留金额
            ,oldcontractno -- 关联的旧合同关联的旧的合同号
            ,clno -- 额度编号
            ,contractflag -- 生成合同标志
            ,approvestatus -- 审批状态
            ,approvetype -- 审批方式
            ,finalapproveopinion -- 最终审批意见
            ,remark -- 备注
            ,completeflag -- 数据录入完整性标识
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,belongdept -- 所属条线BelongDept
            ,corporgid -- 法人机构编号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,renewtermdate -- 展期前到期日
            ,renewtotalsum -- 展期前金额
            ,renewexecuteyearrate -- 展期前执行年利率
            ,loanusetype -- 贷款用途
            ,vouchtype2 -- 担保方式2
            ,vouchtype3 -- 担保方式3
            ,organizetype -- 授信组织方式01一般贷款2银团贷款)
            ,totalsum -- 额度敞口金额
            ,vouchtypeinner -- 担保方式（内部口径）
            ,pigeonholedate -- 归档日期
            ,classifyresulteleven -- 风险分类结果（11级）
            ,reinforceflag -- 补登标志
            ,status -- 生效标志
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,bailaccount -- 保证金账号
            ,bailtransaccount -- 保证金转出账号
            ,bailcurrency -- 保证金币种
            ,bailratio -- 保证金比例（%）
            ,bailsum -- 保证金金额
            ,rateadjustfrequency -- 利率调整周期
            ,overduerate -- 逾期执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountno -- 入账账户
            ,settlementaccount -- 结算账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,checkyearstatus -- 年审进行状态
            ,vouchflag -- 有无其他担保方式，HaveNot
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,effectdate -- 生效日期
            ,serialnocn -- 中文批复编号
            ,ispensionindustry -- 养老产业标识
            ,isyeartocheck -- 是否需要年审
            ,sqcheckyeardate -- 上期年审日期
            ,bqcheckyeardate -- 本期年审日期
            ,templeteno -- 同业模板编号
            ,templeteurl -- 同业模板页面路径
            ,whethertorestructuretheloan -- 是否重组贷款
            ,subproductname -- 子产品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_approve_op(
            serialno -- 批复编号流水号
            ,baserialno -- 申请编号
            ,originflag -- 信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
            ,relativeserialno -- 关联流水号关联流水号(额度申请中最外层额度编号)
            ,parentserialno -- 上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
            ,sourceserialno -- 源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,applytype -- 申请类型申请类型(单一、集团、同业)
            ,flowtype -- 流程类型
            ,businessflag -- 额度/业务标志
            ,occurtype -- 贷款发放类型
            ,occurdate -- 发生日期
            ,currency -- 额度/业务币种
            ,businesssum -- 授信额度
            ,baseproduct -- 基础产品(额度)基础产品
            ,productid -- 产品编号
            ,policyid -- 产品政策编号
            ,policyversionid -- 产品政策版本
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 额度/业务起始日起始日
            ,maturity -- 额度/业务到期日到期日
            ,isremotebusiness -- 是否异地业务
            ,iscycle -- 是否循环(额度)是否循环
            ,risktype -- 风险类型(额度)风险类型（一般、低风险）
            ,islowrisk -- 是否低风险业务
            ,creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
            ,nationalindustrytype -- 贷款投向行业
            ,intraindustrytype -- 行内行业投向
            ,purpose -- 用途
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
            ,repaytype -- 还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
            ,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
            ,repaydate -- 指定还款日
            ,reservesum -- 预留金额
            ,oldcontractno -- 关联的旧合同关联的旧的合同号
            ,clno -- 额度编号
            ,contractflag -- 生成合同标志
            ,approvestatus -- 审批状态
            ,approvetype -- 审批方式
            ,finalapproveopinion -- 最终审批意见
            ,remark -- 备注
            ,completeflag -- 数据录入完整性标识
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,belongdept -- 所属条线BelongDept
            ,corporgid -- 法人机构编号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,renewtermdate -- 展期前到期日
            ,renewtotalsum -- 展期前金额
            ,renewexecuteyearrate -- 展期前执行年利率
            ,loanusetype -- 贷款用途
            ,vouchtype2 -- 担保方式2
            ,vouchtype3 -- 担保方式3
            ,organizetype -- 授信组织方式01一般贷款2银团贷款)
            ,totalsum -- 额度敞口金额
            ,vouchtypeinner -- 担保方式（内部口径）
            ,pigeonholedate -- 归档日期
            ,classifyresulteleven -- 风险分类结果（11级）
            ,reinforceflag -- 补登标志
            ,status -- 生效标志
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,bailaccount -- 保证金账号
            ,bailtransaccount -- 保证金转出账号
            ,bailcurrency -- 保证金币种
            ,bailratio -- 保证金比例（%）
            ,bailsum -- 保证金金额
            ,rateadjustfrequency -- 利率调整周期
            ,overduerate -- 逾期执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountno -- 入账账户
            ,settlementaccount -- 结算账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,checkyearstatus -- 年审进行状态
            ,vouchflag -- 有无其他担保方式，HaveNot
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,effectdate -- 生效日期
            ,serialnocn -- 中文批复编号
            ,ispensionindustry -- 养老产业标识
            ,isyeartocheck -- 是否需要年审
            ,sqcheckyeardate -- 上期年审日期
            ,bqcheckyeardate -- 本期年审日期
            ,templeteno -- 同业模板编号
            ,templeteurl -- 同业模板页面路径
            ,whethertorestructuretheloan -- 是否重组贷款
            ,subproductname -- 子产品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 批复编号流水号
    ,nvl(n.baserialno, o.baserialno) as baserialno -- 申请编号
    ,nvl(n.originflag, o.originflag) as originflag -- 信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 关联流水号关联流水号(额度申请中最外层额度编号)
    ,nvl(n.parentserialno, o.parentserialno) as parentserialno -- 上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
    ,nvl(n.sourceserialno, o.sourceserialno) as sourceserialno -- 源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.applytype, o.applytype) as applytype -- 申请类型申请类型(单一、集团、同业)
    ,nvl(n.flowtype, o.flowtype) as flowtype -- 流程类型
    ,nvl(n.businessflag, o.businessflag) as businessflag -- 额度/业务标志
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 贷款发放类型
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 发生日期
    ,nvl(n.currency, o.currency) as currency -- 额度/业务币种
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 授信额度
    ,nvl(n.baseproduct, o.baseproduct) as baseproduct -- 基础产品(额度)基础产品
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.policyid, o.policyid) as policyid -- 产品政策编号
    ,nvl(n.policyversionid, o.policyversionid) as policyversionid -- 产品政策版本
    ,nvl(n.productclassify, o.productclassify) as productclassify -- 产品所属大类
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限(月)
    ,nvl(n.termday, o.termday) as termday -- 期限(天)
    ,nvl(n.startdate, o.startdate) as startdate -- 额度/业务起始日起始日
    ,nvl(n.maturity, o.maturity) as maturity -- 额度/业务到期日到期日
    ,nvl(n.isremotebusiness, o.isremotebusiness) as isremotebusiness -- 是否异地业务
    ,nvl(n.iscycle, o.iscycle) as iscycle -- 是否循环(额度)是否循环
    ,nvl(n.risktype, o.risktype) as risktype -- 风险类型(额度)风险类型（一般、低风险）
    ,nvl(n.islowrisk, o.islowrisk) as islowrisk -- 是否低风险业务
    ,nvl(n.creditinvest, o.creditinvest) as creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
    ,nvl(n.nationalindustrytype, o.nationalindustrytype) as nationalindustrytype -- 贷款投向行业
    ,nvl(n.intraindustrytype, o.intraindustrytype) as intraindustrytype -- 行内行业投向
    ,nvl(n.purpose, o.purpose) as purpose -- 用途
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
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
    ,nvl(n.repaydate, o.repaydate) as repaydate -- 指定还款日
    ,nvl(n.reservesum, o.reservesum) as reservesum -- 预留金额
    ,nvl(n.oldcontractno, o.oldcontractno) as oldcontractno -- 关联的旧合同关联的旧的合同号
    ,nvl(n.clno, o.clno) as clno -- 额度编号
    ,nvl(n.contractflag, o.contractflag) as contractflag -- 生成合同标志
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.approvetype, o.approvetype) as approvetype -- 审批方式
    ,nvl(n.finalapproveopinion, o.finalapproveopinion) as finalapproveopinion -- 最终审批意见
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 数据录入完整性标识
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 业务经办人编号
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 经办日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 所属条线BelongDept
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.payfrequencyunit, o.payfrequencyunit) as payfrequencyunit -- 指定周期单位
    ,nvl(n.payfrequency, o.payfrequency) as payfrequency -- 指定周期
    ,nvl(n.renewtermdate, o.renewtermdate) as renewtermdate -- 展期前到期日
    ,nvl(n.renewtotalsum, o.renewtotalsum) as renewtotalsum -- 展期前金额
    ,nvl(n.renewexecuteyearrate, o.renewexecuteyearrate) as renewexecuteyearrate -- 展期前执行年利率
    ,nvl(n.loanusetype, o.loanusetype) as loanusetype -- 贷款用途
    ,nvl(n.vouchtype2, o.vouchtype2) as vouchtype2 -- 担保方式2
    ,nvl(n.vouchtype3, o.vouchtype3) as vouchtype3 -- 担保方式3
    ,nvl(n.organizetype, o.organizetype) as organizetype -- 授信组织方式01一般贷款2银团贷款)
    ,nvl(n.totalsum, o.totalsum) as totalsum -- 额度敞口金额
    ,nvl(n.vouchtypeinner, o.vouchtypeinner) as vouchtypeinner -- 担保方式（内部口径）
    ,nvl(n.pigeonholedate, o.pigeonholedate) as pigeonholedate -- 归档日期
    ,nvl(n.classifyresulteleven, o.classifyresulteleven) as classifyresulteleven -- 风险分类结果（11级）
    ,nvl(n.reinforceflag, o.reinforceflag) as reinforceflag -- 补登标志
    ,nvl(n.status, o.status) as status -- 生效标志
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 贷款五级分类
    ,nvl(n.classifydate, o.classifydate) as classifydate -- 风险分类日期
    ,nvl(n.bailaccount, o.bailaccount) as bailaccount -- 保证金账号
    ,nvl(n.bailtransaccount, o.bailtransaccount) as bailtransaccount -- 保证金转出账号
    ,nvl(n.bailcurrency, o.bailcurrency) as bailcurrency -- 保证金币种
    ,nvl(n.bailratio, o.bailratio) as bailratio -- 保证金比例（%）
    ,nvl(n.bailsum, o.bailsum) as bailsum -- 保证金金额
    ,nvl(n.rateadjustfrequency, o.rateadjustfrequency) as rateadjustfrequency -- 利率调整周期
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期执行利率
    ,nvl(n.overdueratefloattype, o.overdueratefloattype) as overdueratefloattype -- 逾期利率浮动方式
    ,nvl(n.overdueratefloatvalue, o.overdueratefloatvalue) as overdueratefloatvalue -- 逾期利率浮动值
    ,nvl(n.settlementaccountname, o.settlementaccountname) as settlementaccountname -- 结算账户(还款账户)名
    ,nvl(n.loanaccountno, o.loanaccountno) as loanaccountno -- 入账账户
    ,nvl(n.settlementaccount, o.settlementaccount) as settlementaccount -- 结算账号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.migtcustomerid, o.migtcustomerid) as migtcustomerid -- 转换前客户号
    ,nvl(n.migtbusinesstype, o.migtbusinesstype) as migtbusinesstype -- 转换前产品ID
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 迁移数据-参数转换前字段值
    ,nvl(n.checkyearstatus, o.checkyearstatus) as checkyearstatus -- 年审进行状态
    ,nvl(n.vouchflag, o.vouchflag) as vouchflag -- 有无其他担保方式，HaveNot
    ,nvl(n.ratefloatratioorbp, o.ratefloatratioorbp) as ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
    ,nvl(n.effectdate, o.effectdate) as effectdate -- 生效日期
    ,nvl(n.serialnocn, o.serialnocn) as serialnocn -- 中文批复编号
    ,nvl(n.ispensionindustry, o.ispensionindustry) as ispensionindustry -- 养老产业标识
    ,nvl(n.isyeartocheck, o.isyeartocheck) as isyeartocheck -- 是否需要年审
    ,nvl(n.sqcheckyeardate, o.sqcheckyeardate) as sqcheckyeardate -- 上期年审日期
    ,nvl(n.bqcheckyeardate, o.bqcheckyeardate) as bqcheckyeardate -- 本期年审日期
    ,nvl(n.templeteno, o.templeteno) as templeteno -- 同业模板编号
    ,nvl(n.templeteurl, o.templeteurl) as templeteurl -- 同业模板页面路径
    ,nvl(n.whethertorestructuretheloan, o.whethertorestructuretheloan) as whethertorestructuretheloan -- 是否重组贷款
    ,nvl(n.subproductname, o.subproductname) as subproductname -- 子产品名称
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
from (select * from ${iol_schema}.icms_business_approve_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_business_approve where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.baserialno <> n.baserialno
        or o.originflag <> n.originflag
        or o.relativeserialno <> n.relativeserialno
        or o.parentserialno <> n.parentserialno
        or o.sourceserialno <> n.sourceserialno
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.applytype <> n.applytype
        or o.flowtype <> n.flowtype
        or o.businessflag <> n.businessflag
        or o.occurtype <> n.occurtype
        or o.occurdate <> n.occurdate
        or o.currency <> n.currency
        or o.businesssum <> n.businesssum
        or o.baseproduct <> n.baseproduct
        or o.productid <> n.productid
        or o.policyid <> n.policyid
        or o.policyversionid <> n.policyversionid
        or o.productclassify <> n.productclassify
        or o.termmonth <> n.termmonth
        or o.termday <> n.termday
        or o.startdate <> n.startdate
        or o.maturity <> n.maturity
        or o.isremotebusiness <> n.isremotebusiness
        or o.iscycle <> n.iscycle
        or o.risktype <> n.risktype
        or o.islowrisk <> n.islowrisk
        or o.creditinvest <> n.creditinvest
        or o.nationalindustrytype <> n.nationalindustrytype
        or o.intraindustrytype <> n.intraindustrytype
        or o.purpose <> n.purpose
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
        or o.reservesum <> n.reservesum
        or o.oldcontractno <> n.oldcontractno
        or o.clno <> n.clno
        or o.contractflag <> n.contractflag
        or o.approvestatus <> n.approvestatus
        or o.approvetype <> n.approvetype
        or o.finalapproveopinion <> n.finalapproveopinion
        or o.remark <> n.remark
        or o.completeflag <> n.completeflag
        or o.operateuserid <> n.operateuserid
        or o.operateorgid <> n.operateorgid
        or o.operatedate <> n.operatedate
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.belongdept <> n.belongdept
        or o.corporgid <> n.corporgid
        or o.payfrequencyunit <> n.payfrequencyunit
        or o.payfrequency <> n.payfrequency
        or o.renewtermdate <> n.renewtermdate
        or o.renewtotalsum <> n.renewtotalsum
        or o.renewexecuteyearrate <> n.renewexecuteyearrate
        or o.loanusetype <> n.loanusetype
        or o.vouchtype2 <> n.vouchtype2
        or o.vouchtype3 <> n.vouchtype3
        or o.organizetype <> n.organizetype
        or o.totalsum <> n.totalsum
        or o.vouchtypeinner <> n.vouchtypeinner
        or o.pigeonholedate <> n.pigeonholedate
        or o.classifyresulteleven <> n.classifyresulteleven
        or o.reinforceflag <> n.reinforceflag
        or o.status <> n.status
        or o.classifyresult <> n.classifyresult
        or o.classifydate <> n.classifydate
        or o.bailaccount <> n.bailaccount
        or o.bailtransaccount <> n.bailtransaccount
        or o.bailcurrency <> n.bailcurrency
        or o.bailratio <> n.bailratio
        or o.bailsum <> n.bailsum
        or o.rateadjustfrequency <> n.rateadjustfrequency
        or o.overduerate <> n.overduerate
        or o.overdueratefloattype <> n.overdueratefloattype
        or o.overdueratefloatvalue <> n.overdueratefloatvalue
        or o.settlementaccountname <> n.settlementaccountname
        or o.loanaccountno <> n.loanaccountno
        or o.settlementaccount <> n.settlementaccount
        or o.migtflag <> n.migtflag
        or o.migtcustomerid <> n.migtcustomerid
        or o.migtbusinesstype <> n.migtbusinesstype
        or o.migtoldvalue <> n.migtoldvalue
        or o.checkyearstatus <> n.checkyearstatus
        or o.vouchflag <> n.vouchflag
        or o.ratefloatratioorbp <> n.ratefloatratioorbp
        or o.effectdate <> n.effectdate
        or o.serialnocn <> n.serialnocn
        or o.ispensionindustry <> n.ispensionindustry
        or o.isyeartocheck <> n.isyeartocheck
        or o.sqcheckyeardate <> n.sqcheckyeardate
        or o.bqcheckyeardate <> n.bqcheckyeardate
        or o.templeteno <> n.templeteno
        or o.templeteurl <> n.templeteurl
        or o.whethertorestructuretheloan <> n.whethertorestructuretheloan
        or o.subproductname <> n.subproductname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_approve_cl(
            serialno -- 批复编号流水号
            ,baserialno -- 申请编号
            ,originflag -- 信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
            ,relativeserialno -- 关联流水号关联流水号(额度申请中最外层额度编号)
            ,parentserialno -- 上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
            ,sourceserialno -- 源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,applytype -- 申请类型申请类型(单一、集团、同业)
            ,flowtype -- 流程类型
            ,businessflag -- 额度/业务标志
            ,occurtype -- 贷款发放类型
            ,occurdate -- 发生日期
            ,currency -- 额度/业务币种
            ,businesssum -- 授信额度
            ,baseproduct -- 基础产品(额度)基础产品
            ,productid -- 产品编号
            ,policyid -- 产品政策编号
            ,policyversionid -- 产品政策版本
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 额度/业务起始日起始日
            ,maturity -- 额度/业务到期日到期日
            ,isremotebusiness -- 是否异地业务
            ,iscycle -- 是否循环(额度)是否循环
            ,risktype -- 风险类型(额度)风险类型（一般、低风险）
            ,islowrisk -- 是否低风险业务
            ,creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
            ,nationalindustrytype -- 贷款投向行业
            ,intraindustrytype -- 行内行业投向
            ,purpose -- 用途
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
            ,repaytype -- 还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
            ,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
            ,repaydate -- 指定还款日
            ,reservesum -- 预留金额
            ,oldcontractno -- 关联的旧合同关联的旧的合同号
            ,clno -- 额度编号
            ,contractflag -- 生成合同标志
            ,approvestatus -- 审批状态
            ,approvetype -- 审批方式
            ,finalapproveopinion -- 最终审批意见
            ,remark -- 备注
            ,completeflag -- 数据录入完整性标识
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,belongdept -- 所属条线BelongDept
            ,corporgid -- 法人机构编号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,renewtermdate -- 展期前到期日
            ,renewtotalsum -- 展期前金额
            ,renewexecuteyearrate -- 展期前执行年利率
            ,loanusetype -- 贷款用途
            ,vouchtype2 -- 担保方式2
            ,vouchtype3 -- 担保方式3
            ,organizetype -- 授信组织方式01一般贷款2银团贷款)
            ,totalsum -- 额度敞口金额
            ,vouchtypeinner -- 担保方式（内部口径）
            ,pigeonholedate -- 归档日期
            ,classifyresulteleven -- 风险分类结果（11级）
            ,reinforceflag -- 补登标志
            ,status -- 生效标志
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,bailaccount -- 保证金账号
            ,bailtransaccount -- 保证金转出账号
            ,bailcurrency -- 保证金币种
            ,bailratio -- 保证金比例（%）
            ,bailsum -- 保证金金额
            ,rateadjustfrequency -- 利率调整周期
            ,overduerate -- 逾期执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountno -- 入账账户
            ,settlementaccount -- 结算账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,checkyearstatus -- 年审进行状态
            ,vouchflag -- 有无其他担保方式，HaveNot
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,effectdate -- 生效日期
            ,serialnocn -- 中文批复编号
            ,ispensionindustry -- 养老产业标识
            ,isyeartocheck -- 是否需要年审
            ,sqcheckyeardate -- 上期年审日期
            ,bqcheckyeardate -- 本期年审日期
            ,templeteno -- 同业模板编号
            ,templeteurl -- 同业模板页面路径
            ,whethertorestructuretheloan -- 是否重组贷款
            ,subproductname -- 子产品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_approve_op(
            serialno -- 批复编号流水号
            ,baserialno -- 申请编号
            ,originflag -- 信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
            ,relativeserialno -- 关联流水号关联流水号(额度申请中最外层额度编号)
            ,parentserialno -- 上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
            ,sourceserialno -- 源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,applytype -- 申请类型申请类型(单一、集团、同业)
            ,flowtype -- 流程类型
            ,businessflag -- 额度/业务标志
            ,occurtype -- 贷款发放类型
            ,occurdate -- 发生日期
            ,currency -- 额度/业务币种
            ,businesssum -- 授信额度
            ,baseproduct -- 基础产品(额度)基础产品
            ,productid -- 产品编号
            ,policyid -- 产品政策编号
            ,policyversionid -- 产品政策版本
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 额度/业务起始日起始日
            ,maturity -- 额度/业务到期日到期日
            ,isremotebusiness -- 是否异地业务
            ,iscycle -- 是否循环(额度)是否循环
            ,risktype -- 风险类型(额度)风险类型（一般、低风险）
            ,islowrisk -- 是否低风险业务
            ,creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
            ,nationalindustrytype -- 贷款投向行业
            ,intraindustrytype -- 行内行业投向
            ,purpose -- 用途
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
            ,repaytype -- 还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
            ,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
            ,repaydate -- 指定还款日
            ,reservesum -- 预留金额
            ,oldcontractno -- 关联的旧合同关联的旧的合同号
            ,clno -- 额度编号
            ,contractflag -- 生成合同标志
            ,approvestatus -- 审批状态
            ,approvetype -- 审批方式
            ,finalapproveopinion -- 最终审批意见
            ,remark -- 备注
            ,completeflag -- 数据录入完整性标识
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,belongdept -- 所属条线BelongDept
            ,corporgid -- 法人机构编号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,renewtermdate -- 展期前到期日
            ,renewtotalsum -- 展期前金额
            ,renewexecuteyearrate -- 展期前执行年利率
            ,loanusetype -- 贷款用途
            ,vouchtype2 -- 担保方式2
            ,vouchtype3 -- 担保方式3
            ,organizetype -- 授信组织方式01一般贷款2银团贷款)
            ,totalsum -- 额度敞口金额
            ,vouchtypeinner -- 担保方式（内部口径）
            ,pigeonholedate -- 归档日期
            ,classifyresulteleven -- 风险分类结果（11级）
            ,reinforceflag -- 补登标志
            ,status -- 生效标志
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,bailaccount -- 保证金账号
            ,bailtransaccount -- 保证金转出账号
            ,bailcurrency -- 保证金币种
            ,bailratio -- 保证金比例（%）
            ,bailsum -- 保证金金额
            ,rateadjustfrequency -- 利率调整周期
            ,overduerate -- 逾期执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountno -- 入账账户
            ,settlementaccount -- 结算账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,checkyearstatus -- 年审进行状态
            ,vouchflag -- 有无其他担保方式，HaveNot
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,effectdate -- 生效日期
            ,serialnocn -- 中文批复编号
            ,ispensionindustry -- 养老产业标识
            ,isyeartocheck -- 是否需要年审
            ,sqcheckyeardate -- 上期年审日期
            ,bqcheckyeardate -- 本期年审日期
            ,templeteno -- 同业模板编号
            ,templeteurl -- 同业模板页面路径
            ,whethertorestructuretheloan -- 是否重组贷款
            ,subproductname -- 子产品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 批复编号流水号
    ,o.baserialno -- 申请编号
    ,o.originflag -- 信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
    ,o.relativeserialno -- 关联流水号关联流水号(额度申请中最外层额度编号)
    ,o.parentserialno -- 上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
    ,o.sourceserialno -- 源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.applytype -- 申请类型申请类型(单一、集团、同业)
    ,o.flowtype -- 流程类型
    ,o.businessflag -- 额度/业务标志
    ,o.occurtype -- 贷款发放类型
    ,o.occurdate -- 发生日期
    ,o.currency -- 额度/业务币种
    ,o.businesssum -- 授信额度
    ,o.baseproduct -- 基础产品(额度)基础产品
    ,o.productid -- 产品编号
    ,o.policyid -- 产品政策编号
    ,o.policyversionid -- 产品政策版本
    ,o.productclassify -- 产品所属大类
    ,o.termmonth -- 期限(月)
    ,o.termday -- 期限(天)
    ,o.startdate -- 额度/业务起始日起始日
    ,o.maturity -- 额度/业务到期日到期日
    ,o.isremotebusiness -- 是否异地业务
    ,o.iscycle -- 是否循环(额度)是否循环
    ,o.risktype -- 风险类型(额度)风险类型（一般、低风险）
    ,o.islowrisk -- 是否低风险业务
    ,o.creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
    ,o.nationalindustrytype -- 贷款投向行业
    ,o.intraindustrytype -- 行内行业投向
    ,o.purpose -- 用途
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
    ,o.repaytype -- 还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
    ,o.repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
    ,o.repaydate -- 指定还款日
    ,o.reservesum -- 预留金额
    ,o.oldcontractno -- 关联的旧合同关联的旧的合同号
    ,o.clno -- 额度编号
    ,o.contractflag -- 生成合同标志
    ,o.approvestatus -- 审批状态
    ,o.approvetype -- 审批方式
    ,o.finalapproveopinion -- 最终审批意见
    ,o.remark -- 备注
    ,o.completeflag -- 数据录入完整性标识
    ,o.operateuserid -- 业务经办人编号
    ,o.operateorgid -- 经办机构
    ,o.operatedate -- 经办日期
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.belongdept -- 所属条线BelongDept
    ,o.corporgid -- 法人机构编号
    ,o.payfrequencyunit -- 指定周期单位
    ,o.payfrequency -- 指定周期
    ,o.renewtermdate -- 展期前到期日
    ,o.renewtotalsum -- 展期前金额
    ,o.renewexecuteyearrate -- 展期前执行年利率
    ,o.loanusetype -- 贷款用途
    ,o.vouchtype2 -- 担保方式2
    ,o.vouchtype3 -- 担保方式3
    ,o.organizetype -- 授信组织方式01一般贷款2银团贷款)
    ,o.totalsum -- 额度敞口金额
    ,o.vouchtypeinner -- 担保方式（内部口径）
    ,o.pigeonholedate -- 归档日期
    ,o.classifyresulteleven -- 风险分类结果（11级）
    ,o.reinforceflag -- 补登标志
    ,o.status -- 生效标志
    ,o.classifyresult -- 贷款五级分类
    ,o.classifydate -- 风险分类日期
    ,o.bailaccount -- 保证金账号
    ,o.bailtransaccount -- 保证金转出账号
    ,o.bailcurrency -- 保证金币种
    ,o.bailratio -- 保证金比例（%）
    ,o.bailsum -- 保证金金额
    ,o.rateadjustfrequency -- 利率调整周期
    ,o.overduerate -- 逾期执行利率
    ,o.overdueratefloattype -- 逾期利率浮动方式
    ,o.overdueratefloatvalue -- 逾期利率浮动值
    ,o.settlementaccountname -- 结算账户(还款账户)名
    ,o.loanaccountno -- 入账账户
    ,o.settlementaccount -- 结算账号
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.migtcustomerid -- 转换前客户号
    ,o.migtbusinesstype -- 转换前产品ID
    ,o.migtoldvalue -- 迁移数据-参数转换前字段值
    ,o.checkyearstatus -- 年审进行状态
    ,o.vouchflag -- 有无其他担保方式，HaveNot
    ,o.ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
    ,o.effectdate -- 生效日期
    ,o.serialnocn -- 中文批复编号
    ,o.ispensionindustry -- 养老产业标识
    ,o.isyeartocheck -- 是否需要年审
    ,o.sqcheckyeardate -- 上期年审日期
    ,o.bqcheckyeardate -- 本期年审日期
    ,o.templeteno -- 同业模板编号
    ,o.templeteurl -- 同业模板页面路径
    ,o.whethertorestructuretheloan -- 是否重组贷款
    ,o.subproductname -- 子产品名称
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
from ${iol_schema}.icms_business_approve_bk o
    left join ${iol_schema}.icms_business_approve_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_business_approve_cl d
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
--truncate table ${iol_schema}.icms_business_approve;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_business_approve') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_business_approve drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_business_approve add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_business_approve exchange partition p_${batch_date} with table ${iol_schema}.icms_business_approve_cl;
alter table ${iol_schema}.icms_business_approve exchange partition p_20991231 with table ${iol_schema}.icms_business_approve_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_business_approve to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_approve_op purge;
drop table ${iol_schema}.icms_business_approve_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_business_approve_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_business_approve',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
